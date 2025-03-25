$PBExportHeader$u_nvo_edi_confirmations_metro.sru
$PBExportComments$Process outbound edi confirmation transactions for Metro Thailand
forward
global type u_nvo_edi_confirmations_metro from nonvisualobject
end type
end forward

global type u_nvo_edi_confirmations_metro from nonvisualobject
end type
global u_nvo_edi_confirmations_metro u_nvo_edi_confirmations_metro

type variables

Datastore	idsROMain, idsRODetail, idsROPutaway, idsDOMain, idsDODetail, idsDOPick, idsDOPack,	&
				idsOut
u_ds_datastore ids_ds
				
				
string lsDelimitChar
end variables

forward prototypes
public function integer uf_gr (string asproject, string asrono)
public function integer uf_gi (string asproject, string asdono)
public function integer uf_process_ds (string aspath)
end prototypes

public function integer uf_gr (string asproject, string asrono);//Prepare a Goods Receipt Transaction for Metro that was just confirmed

Long			llRowPos, llRowCount, llFindRow,llNewRow,llDetailRow, llColPos
Long 			li_Loop, ll_colcount
String 		ls_ColName, lsa_ColNames[],  lsa_DataTypes[], lsDataType
				
String			lsFind, lsOutString, lsMessage, lsLogOut, lsFileName,  lsSku, lsSuppCode, lsSupplier, lsUf1,lsUf2,lsUf4,lsUf5,lsUf6,lsUf7,lsUf8,lsUf9
String			lsCaseTrunc,lsfilenametype, lsPoNoTrunc,lsfilenamedate, lsAltSku, lsInvType, lsShipRef, lsQuantity, lsReqQty, lsShipQty, lsDamageQty
String			lsLineItemNo, lsItemDescription

DEcimal		ldBatchSeq, ldPos, ldLineItemNo
Integer		liRC, liPos, liReqQty, liShipQty, liDamageQty

lsDelimitChar = '|'

If Not isvalid(idsOut) Then
	idsOut = Create Datastore
	idsOut.Dataobject = 'd_edi_generic_out'
	lirc = idsOut.SetTransobject(sqlca)
End If

If Not isvalid(ids_ds) Then
	ids_ds = Create Datastore
	ids_ds.Dataobject = 'd_gr_layout_metro'
	lirc = ids_ds.SetTransobject(sqlca)
End If

If Not isvalid(idsromain) Then
	idsromain = Create Datastore
	idsromain.Dataobject = 'd_ro_master'
	idsroMain.SetTransObject(SQLCA)
End If

If Not isvalid(idsRODetail) Then
	idsRODetail = Create Datastore
	idsRODetail.Dataobject = 'd_ro_detail'
	idsRODetail.SetTransObject(SQLCA)
End If


If Not isvalid(idsroputaway) Then
	idsroputaway = Create Datastore
	idsroputaway.Dataobject = 'd_ro_Putaway'
	idsroputaway.SetTransObject(SQLCA)
End If

idsOut.Reset()


lsLogOut = "      Creating GR For RONO: " + asRONO
FileWrite(gilogFileNo,lsLogOut)
	
//Retreive the Receive Header and Putaway records for this order
If idsroMain.Retrieve(asRoNo) <> 1 Then
	lsLogOut = "                  *** Unable to retreive Receive Order Header For RONO: " + asRONO
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

/*********Get DW display columns*************/
ll_colcount = Long(ids_ds.object.datawindow.column.count)
FOR li_Loop = 1 TO ll_colcount
  	ls_ColName = ids_ds.Describe("#" + String( li_Loop ) + ".Name")
	lsDataType = ids_ds.Describe("#" + String(li_Loop) + ".coltype")
	IF Long( ids_ds.Describe( ls_ColName + ".Visible") ) > 0 THEN
		lsa_ColNames[ UpperBound(lsa_ColNames[]) + 1] = ls_ColName
		lsa_DataTypes[ UpperBound(lsa_DataTypes[]) + 1] = lsDataType
    END IF
next
/***************************************/

idsroPutaway.Retrieve(asRONO)
idsroDetail.Retrieve(asRONO)

/*Get the Next Batch Seq Nbr - Used for all writing to generic tables */
ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asproject,'EDI_Generic_Outbound','EDI_Batch_Seq_No')
If ldBatchSeq <= 0 Then
	lsLogOut = "        *** Unable to retrieve the next available sequence number~rfor Goods Receipt Confirmation.~r~rConfirmation will not be sent to Powerwave!'"
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If 
 lsfilenamedate = String(DateTime(Today(),Now()),'yyyymmddhhmmss' )

//Write the rows to the generic output table - delimited by lsDelimitChar
llRowCount = idsroputaway.RowCount()

For llRowPos = 0 to llRowCOunt
	lsOutString = ''
	if llRowPos = 0 then			//Header Row
		for llColPos = 1 to ll_colcount
			If llColPos = ll_colcount Then
				lsOutString += lsa_ColNames[llColPos] 			// Last column does not end in a delimiter
			Else	
				lsOutString += lsa_ColNames[llColPos] + lsDelimitChar
			End If
		next
	else
		lsSku =  idsroputaway.GetItemString(llRowPos,'sku')
		lsSuppCode = idsroputaway.GetItemString(llRowPos,'supp_code')
		ldLineItemNo = idsroputaway.GetItemNumber(llRowPos,'line_item_no')
		lsLineItemNo = string(ldLineItemNo)
		
		lsFind = "line_item_no = " + lsLineItemNo
		llDetailRow = idsRODetail.Find(lsFind,1,idsRODetail.RowCount())
	
		If llDetailRow = 0 Then /*Could not find detail row with putaway line item no.  Error*/
			lsLogOut = "        *** Structure error.  Putaway LineItemNo " + lsLineItemNo + " does not exists in Detail~rfor Goods Receipt Confirmation.~r~r" +&
						"Receive Order: " + asRONO + ".  Confirmation will not be sent to Metro!'"
			FileWrite(gilogFileNo,lsLogOut)
			Return -1
		End If
	
		//Project	--	Project Identifier
		lsOutString += asproject + lsDelimitChar 	/*asproject = project_id*/
		
		//Warehouse	-- Receiving Warehouse
		lsOutString += nz(Upper(idsroMain.getItemString(1, 'wh_code')),'') + lsDelimitChar
	
		//Supplier	-- Supplier name from supplier table  
		Select supp_name Into :lsSupplier from Supplier where project_id = :asproject and supp_code = :lsSuppCode USING SQLCA;
		
		lsOutString += nz(lsSupplier,'') + lsDelimitChar
		
		//SuppCode	-- Supplier Code
		lsOutString += lsSuppCode + lsDelimitChar
	
		//SuppInvoiceNo	-- Invoice Number
		lsOutString += nz(Upper(idsroMain.getItemString(1, 'supp_invoice_no')),'') + lsDelimitChar
	
		//Arrival Date	
		lsOutString += nz(String(idsROMain.GetITemDateTime(1,'arrival_date'),'yyyymmddThh:mm:ss.ff'),'') + lsDelimitChar
		
		//Receipt Date	
		//lsOutString += nz(String(idsROMain.GetITemDateTime(1,'request_date'),'yyyymmdd hh:mm:ss.ff'),'') + lsDelimitChar
		lsOutString += lsDelimitChar	//GWM - 11/21/2014 - Metro requested that request date always be empty 
		
		//LineItemNo
		lsOutString += lsLineItemNo + lsDelimitChar
		
		//OrderType
		lsOutString += nz(Upper(idsroMain.getItemString(1, 'ord_type')),'') + lsDelimitChar
		
		//SKU
		lsOutString += nz(Upper(idsroputaway.GetItemString(llRowPos,'sku')),'')+ lsDelimitChar
		
		//AlternateSKU  -- Customer Sku
		lsAltSku = nz(idsRODetail.GetItemString(llDetailRow,'alternate_sku'),'')
		If IsNull(lsAltSku) then lsAltSku = ''
		lsOutString += lsAltSku + lsDelimitChar
		
		// GailM - 01/15/2015 - Get inventory type to determine ship and damage qty from req qty
		lsInvType = nz(Upper(idsroputaway.GetItemString(llRowPos,'inventory_type')),'')
		
		//ReqQty	-- requested quantity 
		liReqQty = idsroputaway.GetItemNumber(llRowPos,'quantity')
		lsReqQty = nz(Upper(string(liReqQty)),'')
		liPos = pos(lsReqQty,'.')
		If liPos > 0 Then
			lsReqQty = left(lsReqQty, liPos - 1)
		Else
		End If
		lsOutString += lsReqQty + lsDelimitChar
		
		//ShipQty	-- putaway quantity
		If lsInvType <> 'D' Then
			liShipQty = liReqQty
		else 
			liShipQty = 0
		end if
		lsShipQty = nz(string(liShipQty),'')
		liPos = pos(lsShipQty,'.')
		If liPos > 0 Then
			lsShipQty = left(lsShipQty, liPos - 1)
		Else
		End If
		lsOutString += lsShipQty + lsDelimitChar
		
		//ShipRef -- Inbound order does not have ShipRef (use blank)
		lsShipRef = nz(Upper(idsroMain.getItemString(1, 'ship_ref')),'')
		If IsNull(lsShipRef) then lsShipRef = ''
		lsOutString +=   lsShipRef+ lsDelimitChar
		
		//damagedQty	-- putaway quantity 
		If lsInvType = 'D' Then
			liDamageQty = liReqQty
		else 
			liDamageQty = 0
		end if
		lsDamageQty = nz(string(liDamageQty),'')
		liPos = pos(lsDamageQty,'.')
		If liPos > 0 Then
			lsDamageQty = left(lsDamageQty, liPos - 1)
		Else
		End If
		lsOutString += lsDamageQty + lsDelimitChar
		
		//UserField1 - Receive Master User Field 1
		lsUf1 = Upper(idsroMain.getItemString(1, 'user_field1')) 
		If IsNull(lsUf1) then lsUf1 = ''
		lsOutString += lsUF1 + lsDelimitChar
		
		//UserField2 - Receive Master User Field 2
		lsUf2 = Upper(idsroMain.getItemString(1, 'user_field2')) 
		If IsNull(lsUf2) then lsUf2 = ''
		lsOutString += lsUF2 + lsDelimitChar
		
		//CompleteDate	-- 	Date Confirmed
		lsOutString += nz(String(idsROMain.GetITemDateTime(1,'complete_date'),'yyyymmddThh:mm:ss.ff'),'') + lsDelimitChar
	
		//Order Date	-- 	Date of Order
		lsOutString += nz(String(idsROMain.GetITemDateTime(1,'ord_date'),'yyyymmddThh:mm:ss.ff'),'') + lsDelimitChar
	
		//Status 	-- 	Order Status Code
		lsOutString += nz(Upper(idsROMain.GetITemString(1,'ord_status')),'') + lsDelimitChar
	
		// cf_owner_Name  -- Ignored
		lsOutString +=  lsDelimitChar
	
		//RONo 	-- 	Menlo generated follow number
		lsOutString += nz(Upper(idsROMain.GetITemString(1,'ro_no')),'') + lsDelimitChar
	
		//UserField7 - Customer specific field 7
		lsUf7 = Upper(idsroMain.getItemString(1, 'user_field7')) 
		If IsNull(lsUf7) then lsUf7 = ''
		lsOutString += lsUF7 + lsDelimitChar
		
		// Grp -- Always empty
		lsOutString +=  lsDelimitChar
	
		//Description  --  Part description
		Select description Into :lsItemDescription from item_master where project_id = :asproject and sku = :lsSku and supp_code = :lsSuppCode USING SQLCA;
		
		lsOutString +=  nz(lsItemDescription,'') + lsDelimitChar
	
		//native_description  --  Always empty
		lsOutString +=  lsDelimitChar
	
		//Lot number
		lsOutString += nz(Upper(idsroputaway.GetItemString(llRowPos,'lot_no')),'')+ lsDelimitChar
	
		//Client Order Line Identifier
		lsOutString += nz(idsRODetail.GetItemString(llDetailRow,'cust_line_no'),'')
	
		/* Last element */
	end if
	
	llNewRow = idsOut.insertRow(0)
	idsOut.SetItem(llNewRow,'Project_id', asproject)
	idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	idsOut.SetItem(llNewRow,'batch_data', lsOutString)
	lsFileName = 'GRR' + lsfilenamedate + '.dat'
	idsOut.SetItem(llNewRow,'file_name', lsFileName)


next /*next output record */

//TAM 2014/09/30  Added a 1 secong sleep to allow filenames to be different
	sleep(1)

If idsOut.RowCount() > 0 Then
	gu_nvo_process_files.uf_process_flatfile_outbound_unicode(idsOut, asproject)
End If

//TAM 2014/09/30  Added a 1 secong sleep to allow filenames to be different
	sleep(1)

Return 0
end function

public function integer uf_gi (string asproject, string asdono);//Prepare a Goods Issue Transaction for Metro for the order that was just confirmed
Long llRowCount, llRowPos, llColumnCount, llColPos, llNewRow
Long ll_rc = 0
Int liColNo,liPos,liDec

Any laDecimalData, laRowData[]
Decimal ldDecimalData
String lsDecimalData,lsDec

String lsLogOut, lsOutString, lsColumnData, lsDataType, lsfilenamedate, lsFileName
Decimal ldBatchSeq
string sCustCds[]
string quote = String(Blob(Char(34)), EncodingANSI!)
string comma = ','
string tabchar = '~t'
string pipechar = '|'
string delimiter = pipechar	// set up the system to use pipe_delimiter as the default delimiter

If Not isvalid(idsOut) Then
	idsOut = Create Datastore
	idsOut.Dataobject = 'd_edi_generic_out'
	ll_rc = idsOut.SetTransobject(sqlca)
End If

ids_ds = Create u_ds_datastore
ids_ds.dataobject= 'd_gi_outbound_metro'
ids_ds.SetTransObject(SQLCA)

/*Get the Next Batch Seq Nbr - Used for all writing to generic tables */
ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asproject,'EDI_Generic_Outbound','EDI_Batch_Seq_No')
If ldBatchSeq <= 0 Then
	lsLogOut = "        *** Unable to retrieve the next available sequence number~rfor Goods Receipt Confirmation.~r~rConfirmation will not be sent to Powerwave!'"
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If 
 lsfilenamedate = String(DateTime(Today(),Now()),'yyyymmddhhmmss' )

/**************************************/
lsLogOut = '      - Processing Metro SO Outbound GI file from DoNo: ' + asdono
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

/*********Get DW display columns*************/
  Long li_Loop, ll_columns
  String ls_ColName, lsa_ColNames[], lsa_DataTypes[]
  Any la_colno

	llRowCount = ids_ds.retrieve(asdono)
  	la_colno = ids_ds.object.datawindow.column.count
 	ll_columns = long(la_colno) 
   
  Any la_any[]
  la_any = ids_ds.object.data
 FOR li_Loop = 1 TO ll_columns
  	ls_ColName = ids_ds.Describe("#" + String( li_Loop ) + ".Name")
	lsDataType = ids_ds.Describe("#" + String(li_Loop) + ".coltype")
	IF Long( ids_ds.Describe( ls_ColName + ".Visible") ) > 0 THEN
		lsa_ColNames[ UpperBound(lsa_ColNames[]) + 1] = ls_ColName
		lsa_DataTypes[ UpperBound(lsa_DataTypes[]) + 1] = lsDataType
    END IF
 next
llColumnCount =  UpperBound(lsa_ColNames[])
/*****************************************/
/*	Metro wants a header row on their confirmations      */
/*****************************************/

		lsOutString = ''
		for llColPos = 1 to llColumnCount
			ls_ColName = lsa_ColNames[llColPos]
			If llColPos = llColumnCount Then
				lsOutString += ls_ColName 			// Last column does not end in a delimiter
			Else	
				lsOutString += ls_ColName + delimiter
			End If
		next
		llNewRow = idsOut.insertRow(0)
		idsOut.SetItem(llNewRow,'Project_id', asproject)
		idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
		idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
		idsOut.SetItem(llNewRow,'batch_data', lsOutString)
		lsFileName = 'GIR' + lsfilenamedate + '.dat'
		idsOut.SetItem(llNewRow,'file_name', lsFileName)

// Loop through each row
if llRowCount >0 Then
	for llRowPos = 1 to llRowCount
		laRowData = la_any[llRowPos]
		llNewRow = idsOut.insertRow(0)
		lsOutString = ''
		for llColPos = 1 to llColumnCount
			ls_ColName = lsa_ColNames[llColPos]
			lsDataType = lsa_DataTypes[llColPos]
			CHOOSE CASE left(lsDataType,4)
				CASE 'char'
					//lsColumnData = ids_ds.GetItemString(llRowPos,llColPos) 
					lsColumnData = nz(laRowData[llColPos],'')
				CASE 'date'
					//lsColumnData = String(ids_ds.GetItemDateTime(llRowPos,llColPos),'YYYYMMDD') 
					lsColumnData = nz(String(laRowData[llColPos],"yyyymmddThh:mm:ss.ff"),'')
				CASE 'deci'
					lsDecimalData = String(laRowData[llColPos])
					lsDec = mid(lsDataType,pos(lsDataType,'(')+1,len(lsDataType)-pos(lsDataType,'(')-1)
					liDec = Long(lsDec)
					liPos = pos(lsDecimalData,'.')
					If IsNull(lsDecimalData) Then 
						lsColumnData = '' 
					ElseIf liPos = 0 Then
						lsColumnData = lsDecimalData
					ElseIf liDec = 0 Then
						lsColumnData= Left(lsDecimalData,liPos - 1)
					else
						if liDec > 3 then liDec = 3
						lsColumnData = Left(lsDecimalData, liPos + liDec)
					End If
			END CHOOSE
			If IsNull(lsColumnData) Then lsColumnData = ''
			If llColPos = llColumnCount Then
				lsOutString += lsColumnData 			// Last column does not end in a delimiter
			Else	
				lsOutString += lsColumnData + delimiter
			End If
		next
		/* Last element */
		
		idsOut.SetItem(llNewRow,'Project_id', asproject)
		idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
		idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
		idsOut.SetItem(llNewRow,'batch_data', lsOutString)
		lsFileName = 'GIR' + lsfilenamedate + '.dat'
		idsOut.SetItem(llNewRow,'file_name', lsFileName)
	next
End If

//TAM 2014/09/30  Added a 1 secong sleep to allow filenames to be different
	sleep(1)

If idsOut.RowCount() > 0 Then
	ll_rc = gu_nvo_process_files.uf_process_flatfile_outbound_unicode(idsOut, asproject)
End If

//TAM 2014/09/30  Added a 1 secong sleep to allow filenames to be different
	sleep(1)

return ll_rc

end function

public function integer uf_process_ds (string aspath);Long llRtn = 0
long ll_rc, rtn, fId, llen
String lsLogOut, sLine
string thisColumn
datetime ldtToday
int lposComma, lposPipe, lposTab

string sCustCds[]
string quote = String(Blob(Char(34)), EncodingANSI!)
string comma = ','
string tabchar = '~t'
string pipechar = '|'
string delimiter = comma	// set up the system to use comma as the default delimiter

long lpos = 0			// used for pos search
long lpos2 = 0 			// find quotes

long lImportRow = 0
long cnt = 0         		// counter
long i = 0				// iterator
long ldr = 0
string ss = ''

/*********Get DW display columns*************/
  Long li_Loop, ll_columns
  String ls_ColName, lsa_ColNames[]
  
  Any la_colno
  la_colno = ids_ds.object.datawindow.column.count
  ll_columns = long(la_colno)
  FOR li_Loop = 1 TO ll_columns
  	ls_ColName = ids_ds.Describe("#" + String( li_Loop ) + ".Name")
	IF Long( ids_ds.Describe( ls_ColName + ".Visible") ) > 0 THEN
    		lsa_ColNames[ UpperBound(lsa_ColNames[]) + 1] = ls_ColName
    END IF
 next
/*****************************************/
fId = fileopen ( asPath, LineMode!, Read!)

rtn = FileReadEx( fId, sLine )  
if IsNull(rtn) OR (rtn <= 0 ) then
		lsLogOut = "        Could not read: " + asPath + " - File will not be processed."
		FileWrite(gilogFileNo,lsLogOut)
		gu_nvo_process_files.uf_writeError(lsLogout)
		Return -1
else
	llen = len(sLine)
end if

//ldtToday = f_getLocalWorldTime( gs_default_wh )

// determine the delimiter to use
lposComma = 0
lposPipe = 0
lposTab = 0

lposComma = pos(sLine, comma, 1)
lposPipe  = pos(sLine, PipeChar, 1)
lposTab   = pos(sLine, TabChar, 1)

IF lposComma > 0 THEN
	delimiter = comma
ELSEIF lposPipe > 0 THEN
	delimiter = PipeChar
ELSEIF lposTab > 0 THEN
	delimiter = TabChar
ELSE
		lsLogOut = "        Unable to determine delimiter. ~r~nPlease confirm that the file uses either the comma, tab or pipe characters as column markers."
		FileWrite(gilogFileNo,lsLogOut)
		gu_nvo_process_files.uf_writeError(lsLogout)
		Return -1
END IF

DO WHILE ( rtn > 0)
	
	lImportRow ++
	// write to the status line
	w_main.SetMicroHelp( 'Processing row: ' + string(lImportRow) + ': ' + sLine)
	
	llen = len(sLine)
	i = 1
	cnt = 0
	
	DO UNTIL (i >= llen)
		// get the columns
		cnt++ // increment column counter
		
		lpos = pos(sLine, delimiter, i)
		if lpos > 0 then
			ss = mid(sLine, i, lpos - i)
			// how to deal with embedded quotes and delimiters:
			// Test for quote and if found then find match and set i and lpos appropriately
			If left(ss,1) = quote Then
				lpos2 = pos(sLine, quote, lpos + 1)
				if lpos > 0 then
					ss = mid(sline, i + 1, lpos2 - i - 1) 
					i = lpos2 + 2
					//lpos = lpos2
				end if
			else
				i = lpos + 1
			End if
		elseif lpos = 0 and i = 0 then
			ss = ''
			i++
			cnt --
		else
			ss = mid(sLine, i)
			i = llen 
		end if
		
		thisColumn = upper(lsa_ColNames[cnt])
		
		// Add column data to DS
		If cnt = 1 Then 
			If left(upper(ss),4) = left(upper(thisColumn),4) Then
				// Header row - do not process
				EXIT
			Else
				ldr =ids_ds.insertrow(0)
				ids_ds.setitem( ldr, thisColumn, ss)
			End If
		Else
			ids_ds.setitem( ldr, thisColumn, ss)
		End If
		
	LOOP // Parse through the colunns
	
	rtn = FileReadEx( fId, sLine )  // row 5+ data

LOOP  // Rows 4+

rtn = FileClose(fId)

return llRtn

end function

on u_nvo_edi_confirmations_metro.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_nvo_edi_confirmations_metro.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;
lsDelimitChar = char(9)
end event

