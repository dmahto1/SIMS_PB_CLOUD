$PBExportHeader$u_nvo_edi_confirmations_honda.sru
$PBExportComments$Process outbound edi confirmation transactions for Honda Thailand
forward
global type u_nvo_edi_confirmations_honda from nonvisualobject
end type
end forward

global type u_nvo_edi_confirmations_honda from nonvisualobject
end type
global u_nvo_edi_confirmations_honda u_nvo_edi_confirmations_honda

type variables

Datastore	idsROMain, idsRODetail, idsROPutaway, idsDOMain, idsDODetail, idsDOPick, idsDOPack,	&
				idsOut
				
				
string lsDelimitChar
end variables

forward prototypes
public function integer uf_gr (string asproject, string asrono)
public function integer uf_adjustment (string asproject, long aladjustid)
public function integer uf_gi (string asproject, string asdono)
public function integer uf_gr_dom (string asproject, string asrono)
public function integer uf_gr_exp (string asproject, string asrono)
public function integer uf_gi_dom (string asproject, string asdono)
public function integer uf_gi_exp (string asproject, string asdono)
end prototypes

public function integer uf_gr (string asproject, string asrono);//Prepare a Goods Receipt Transaction for Honda for the order that was just confirmed

String		lswarehouse
Integer	liRC

SELECT WH_Code      INTO :lswarehouse      FROM Receive_Master     WHERE ( Project_Id = :asproject ) AND   ( RO_No = :asrono )   ;

If Upper(lswarehouse) = 'DOM-HONDA' Then
	liRC = uf_gr_dom(asProject, asRONO)
Else
	liRC = uf_gr_exp(asProject, asRONO)
End If

Return 0
end function

public function integer uf_adjustment (string asproject, long aladjustid);//Prepare a Stock Adjustment Transaction for Baseline Unicode Stock Adjustment just made



Long			llNewRow,llRowCount
				
String		lsOutString, lsMessage,	lsSKU, lsSupplier,  lsWarehouse,  lsOldLotNo,	lsNewLotNo, lsOldPoNo, lsNewPoNo, lsFileName,  lsPoNoTrunc, lsCaseTrunc,	lsUf4, lsUf5, lsUf6, lsUf7, lsUf8, LsUf9, lsfilenamedate

Decimal		ldBatchSeq, ldPos
Integer		liRC
String	lsLogOut,lsFileNamePath
Datastore ldsAdjustment
lsLogOut = "      Creating Honda Adjustment For AdjustID: " + String(alAdjustID)
FileWrite(gilogFileNo,lsLogOut)

If Not isvalid(idsOut) Then
	idsOut = Create Datastore
	idsOut.Dataobject = 'd_edi_generic_out'
	lirc = idsOut.SetTransobject(sqlca)
End If

If Not isvalid(ldsAdjustment) Then
	ldsAdjustment = Create Datastore
	ldsAdjustment.Dataobject = 'd_adjustment'
	ldsAdjustment.SetTransObject(SQLCA)
End If

//Retreive the adjustment record
If ldsAdjustment.Retrieve(asProject, alAdjustID) <= 0 Then
	lsLogOut = "        *** Unable to retreive Adjustment Record for AdjustID: " + String(alAdjustID)
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If


lsSku = ldsAdjustment.GetITemString(1,'sku')
lsSupplier = ldsAdjustment.GetITemString(1,'supp_code')
lsWarehouse = Trim(ldsAdjustment.GetITemString(1,'wh_code'))

	
lsOldLotNo = ldsAdjustment.GetITemString(1,"old_lot_no") /*original value before update!*/
lsNewLotNo = ldsAdjustment.GetITemString(1,"lot_no")

lsOldPoNo = ldsAdjustment.GetITemString(1,"old_po_no") /*original value before update!*/
lsNewPoNo = ldsAdjustment.GetITemString(1,"po_no")

//Only send for Warehouse "EXP_HONDA" and only for lot number changes or po number changes

If (lsWarehouse = 'EXP-HONDA' ) Then
	If (lsOldLotNo = lsNewLotNo) And (lsOldPoNo = lsNewPoNo)  Then
	Else

 lsfilenamedate = String(DateTime(Today(),Now()),'yyyymmddhhmmss' )

	
	//Get the Next Batch Seq Nbr - Used for all writing to generic tables
	ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asproject,'EDI_Generic_Outbound','EDI_Batch_Seq_No')
	If ldBatchSeq <= 0 Then
		lsLogOut = "        *** Unable to retreive Next Available Sequence Number"
		FileWrite(gilogFileNo,lsLogOut)
		Return -1
	End If


		
	//Field Name	Type	Req.	Default	Description
	
	//Delivery Date	Date	Yes	N/A	Delivery completion date
	lsOutString = String(ldsAdjustment.GetITemDateTime(1,'last_update' ),'yyyymmdd') //+ lsDelimitChar

	//Delivery Time	Time	Yes	N/A	Delivery completion time
	lsOutString += String(ldsAdjustment.GetITemDateTime(1,'last_update' ),'hhmmss') //+ lsDelimitChar

	//Project	C(10)	Yes	“HONDA     ”	Project Identifier
	lsOutString += 'HONDA     '  //+ lsDelimitChar /*rec type = goods receipt*/

	//Warehouse	C(10)	Yes	N/A{first 3 of Warehouse only)	Receiving Warehouse
	lsOutString += Left(Upper(ldsAdjustment.getItemString(1, 'wh_code')),3) + Space(7)  //+ lsDelimitChar

	//Program ID	C(10)	Yes	Blank	
	lsOutString += Space(10)  //+ lsDelimitChar

	//A	C(1)	Yes	Blank	
	lsOutString +='A'  //+ lsDelimitChar

	//1	C(2)	Yes	01	
	lsOutString += '01'  //+ lsDelimitChar

	//4	C(2)	Yes	04	
	lsOutString += '04'  //+ lsDelimitChar

	//Old PC No	C(7)	No	N/A	Old PO Number left of Hyphen'-'
	If ldsAdjustment.GetItemString(1,'old_po_no') <> '-' Then
		ldPos = Pos(ldsAdjustment.GetItemString(1,'old_po_no'),'-')
		If ldPos > 0 and ldPos < 8 Then  //If Hyphen Found then Truncate PONO and Space fill to 7
			lsPoNoTrunc = Left(ldsAdjustment.GetItemString(1,'old_po_no'),ldPos -1)
		Else	
			lsPoNoTrunc = Left(ldsAdjustment.getItemString(1, 'old_po_no'),7)  
		End If
			lsOutString += lsPoNoTrunc + Space(7 - len(lsPoNoTrunc)) //+ lsDelimitChar
	Else	
		lsOutString +=space(7) //+ lsDelimitChar
	End If	
	
	//Old Case Nbr	C(7)	No	N/A	Old PO Number Right of Hyphen'-' !!!Left Fill with Blanks

// TAM 2014/09/23  Take right 6 of PONO and add space in front
	If ldsAdjustment.GetItemString(1,'old_po_no') <> '-' Then
			lsCaseTrunc = Mid(ldsAdjustment.GetItemString(1,'old_po_no'),8,6)
	Else	
		lsCaseTrunc = ''  
	End If
	lsOutString +=fill(' ',(7 -len(lsCaseTrunc))) + lsCaseTrunc //+ lsDelimitChar
//	If ldsAdjustment.GetItemString(1,'old_po_no') <> '-' Then
//		ldPos = Pos(ldsAdjustment.GetItemString(1,'old_po_no'),'-')
//		If ldPos > 0  Then  //If Hyphen Found then Truncate PONO and Space fill to 6
//			lsCaseTrunc = Left(Mid(ldsAdjustment.GetItemString(1,'old_po_no'),ldPos +1),7)
//		Else	
//			lsCaseTrunc = Space(7)  
//		End If
//			lsOutString +=fill(' ',(7 -len(lsCaseTrunc))) + lsCaseTrunc //+ lsDelimitChar
//	Else	
//		lsOutString +=space(7) //+ lsDelimitChar
//	End If	

	//Old Lot Number	C(50)	No	N/A	Old Lot Number
	If ldsAdjustment.GetItemString(1,'Old_Lot_No') <> '-' Then
		If len(ldsAdjustment.GetItemString(1,'Old_Lot_No')) < 2 Then
			lsOutString += Left(ldsAdjustment.GetItemString(1,'Old_Lot_No'),2) + Space(2 - len(ldsAdjustment.GetItemString(1,'Old_Lot_No'))) //+ lsDelimitChar
		Else
			lsOutString += Left(ldsAdjustment.GetItemString(1,'Old_Lot_No'),2) //+ lsDelimitChar
		End If	
	Else
		lsOutString += Space(2)  //+ lsDelimitChar
	End If	
	
	//New PC No	C(7)	No	N/A	PO Number left of Hyphen'-'
	If ldsAdjustment.GetItemString(1,'po_no') <> '-' Then
		ldPos = Pos(ldsAdjustment.GetItemString(1,'po_no'),'-')
		If ldPos > 0 and ldPos < 8 Then  //If Hyphen Found then Truncate PONO and Space fill to 7
			lsPoNoTrunc = Left(ldsAdjustment.GetItemString(1,'po_no'),ldPos -1)
		Else	
			lsPoNoTrunc = Left(ldsAdjustment.getItemString(1, 'po_no'),7)  
		End If
			lsOutString += lsPoNoTrunc + Space(7 - len(lsPoNoTrunc)) //+ lsDelimitChar
	Else	
		lsOutString +=space(7) //+ lsDelimitChar
	End If	
	
	//New Case Nbr	C(7)	No	N/A	PO Number Right of Hyphen'-' !!!Left Fill with Blanks
// TAM 2014/09/23  Take right 6 of PONO and add space in front
	If ldsAdjustment.GetItemString(1,'po_no') <> '-' Then
		lsCaseTrunc = Mid(ldsAdjustment.GetItemString(1,'po_no'),8,6)
	Else	
		lsCaseTrunc = ''  
	End If
	lsOutString +=fill(' ',(7 -len(lsCaseTrunc))) + lsCaseTrunc //+ lsDelimitChar
//	If ldsAdjustment.GetItemString(1,'po_no') <> '-' Then
//		ldPos = Pos(ldsAdjustment.GetItemString(1,'po_no'),'-')
//		If ldPos > 0  Then  //If Hyphen Found then Truncate PONO and Space fill to 6
//			lsCaseTrunc = Left(Mid(ldsAdjustment.GetItemString(1,'po_no'),ldPos +1),7)
//		Else	
//			lsCaseTrunc = Space(7)  
//		End If
//			lsOutString +=fill(' ',(7 -len(lsCaseTrunc))) + lsCaseTrunc //+ lsDelimitChar
//	Else	
//		lsOutString +=space(7) //+ lsDelimitChar
//	End If	

	//New Lot Number	C(50)	No	N/A	Lot Nunber
	If ldsAdjustment.GetItemString(1,'Lot_No') <> '-' Then
		If len(ldsAdjustment.GetItemString(1,'Lot_No')) < 2 Then
			lsOutString += Left(ldsAdjustment.GetItemString(1,'Lot_No'),2) + Space(2 - len(ldsAdjustment.GetItemString(1,'Lot_No'))) //+ lsDelimitChar
		Else
			lsOutString += Left(ldsAdjustment.GetItemString(1,'Lot_No'),2) //+ lsDelimitChar
		End If	
	Else
		lsOutString += Space(2)  //+ lsDelimitChar
	End If	
	
	//Container No	C(15)	Yes	Blanks
	lsOutString += Space(15) //+ lsDelimitChar
	
	//Get from Item_Master

	Select User_Field4, User_Field5, User_Field6, User_Field7, User_Field8, User_Field9  INTO :lsUf4, :lsUf5, :lsUf6, :lsUf7, :lsUf8, :lsUf9 From Item_Master
		Where sku = :lsSku and supp_code = :lsSupplier and project_id = :asproject
		USING SQLCA;
			
	//Item Master User Field4	C(11)	No	N/A	Model
	If IsNull(lsUf4) then lsUf4 = ''
	If len(lsUf4) > 0 Then
		If len(lsUf4) < 11 Then
			lsOutString += Left(lsUf4,11) + Space(11 - len(lsUf4)) //+ lsDelimitChar
		Else
			lsOutString += Left(lsUf4,11) //+ lsDelimitChar
		End If	
	Else
		lsOutString += Space(11)  //+ lsDelimitChar
	End If	

	//Item Master User Field5	C(4)	No	N/A	Type
	If IsNull(lsUf5) then lsUf5 = ''
	If len(lsUf5) > 0 Then
		If len(lsUf5) < 4 Then
			lsOutString += Left(lsUf5,4) + Space(4 - len(lsUf5)) //+ lsDelimitChar
		Else
			lsOutString += Left(lsUf5,4) //+ lsDelimitChar
		End If	
	Else
		lsOutString += Space(4) //+ lsDelimitChar
	End If	

	//Item Master User Field6	C(3)	No	N/A	Option
	If IsNull(lsUf6) then lsUf6 = ''
	If len(lsUf6) > 0 Then
		If len(lsUf6) < 3 Then
			lsOutString += Left(lsUf6,3) + Space(3 - len(lsUf6)) //+ lsDelimitChar
		Else
			lsOutString += Left(lsUf6,3) //+ lsDelimitChar
		End If	
	Else
		lsOutString += Space(3) //+ lsDelimitChar
	End If	

	//Item Master User Field7	C(8)	No	N/A	Hes Color
	If IsNull(lsUf7) then lsUf7 = ''
	If len(lsUf7) > 0 Then
		If len(lsUf7) < 8 Then
			lsOutString += Left(lsUf7,8) + Space(8 - len(lsUf7)) //+ lsDelimitChar
		Else
			lsOutString += Left(lsUf5,8) //+ lsDelimitChar
		End If	
	Else
		lsOutString += Space(8) //+ lsDelimitChar
	End If	

	//Color C(8)	Yes	Blank	
	lsOutString += Space(8)  //+ lsDelimitChar

	//Int Color C(2)	Yes	Blank	
	lsOutString += Space(2)  //+ lsDelimitChar

	//Item Master User Field8	and 9 C(6)	No	N/A	Option
	String lsPackingNo
	If IsNull(lsUf8) then 
		lsUf8 = ''
	Else 
		lsUf8 = Left(lsUf8,3)
	End If

	If IsNull(lsUf9) then 
		lsUf9 = '000'
	Else
		If len(lsUf9) < 3 then
			lsUf9 = fill('0', (3 - len(lsUf9))) + lsUf9 
		Else
			lsUf9 = Left(lsUf9,3)
		End If
	End If

	lsPackingNo = lsUf8 + lsUf9
	lsOutString += Left(lsPackingNo,6) + Space(6 - len(lsPackingNo)) //+ lsDelimitChar
	
	
	//Quantity	N(15,5)	Yes	N/A	Received quantity
	If len(string(ldsAdjustment.GetItemNumber(1,'quantity'))) > 0 Then
		If len(string(ldsAdjustment.GetItemNumber(1,'quantity'))) < 3 Then
			lsOutString += Fill('0',(3 - len(string(ldsAdjustment.GetItemNumber(1,'quantity' ))))) + string(ldsAdjustment.GetItemNumber(1,'quantity'))  //+ lsDelimitChar
		Else
			lsOutString += Left(string(ldsAdjustment.GetItemNumber(1,'quantity')),3) //+ lsDelimitChar
		End If	
	Else
		lsOutString += '000'  //+ lsDelimitChar
	End If	

	//Staus	C(1)	No	' '	
	lsOutString +=space(1) //+ lsDelimitChar

	//Staus date	C(8)	No	'00000000'	
	lsOutString +='00000000' //+ lsDelimitChar

	//Rec Typ	C(1)	No	' '	
	lsOutString +=space(1) //+ lsDelimitChar

	//Error	C(1)	No	' '	
	lsOutString +=space(1)  // Last item in GR so no Delimeter

	lsLogOut = lsOutString + ":" + String(alAdjustID)
	FileWrite(gilogFileNo,lsLogOut)	
		
		
	llNewRow = idsOut.insertRow(0)
	
	idsOut.SetItem(llNewRow,'Project_id', asproject)
	idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	idsOut.SetItem(llNewRow,'batch_data', lsOutString)
	
	lsFileName = 'GCHG' + lsfilenamedate + '.TXT'
	idsOut.SetItem(llNewRow,'file_name', lsFileName)
	
	
   //Write the Outbound File - no need to save and re-retrieve - just use the currently loaded DW
	gu_nvo_process_files.uf_process_flatfile_outbound_unicode(idsOut,asProject)
	
//25-Oct-2014 :Madhu -  Email the confirmation file
lsFileNamePath = ProfileString(gsinifile,asproject,"archivedirectory","") + '\' + lsFileName + '.txt'
gu_nvo_process_files.uf_send_email("HONDA-TH","CUSTVAL","Adjustment File Sent on " + string(Today(), 'YYYY/MM/DD HH:MM') + ' GMT', "Attached is the Adjustment File on" + string(Today(), 'YYYY/MM/DD HH:MM') + ' GMT', lsFileNamePath)

//TAM 2014/09/30  Added a 1 secong sleep to allow filenames to be different
	sleep(1)
End If /* inv type changed*/
End If /* inv type changed*/
		


Return 0
end function

public function integer uf_gi (string asproject, string asdono);//Prepare a Goods Issue Transaction for Honda for the order that was just confirmed

String		lswarehouse
Integer		liRC

SELECT WH_Code      INTO :lswarehouse      FROM Delivery_Master     WHERE ( Project_Id = :asproject ) AND   ( DO_No = :asdono )   ;

If Upper(lswarehouse) = 'DOM-HONDA' Then
	liRC = uf_gi_dom(asProject, asDONO)
Else
	liRC = uf_gi_exp(asProject, asDONO)
End If

Return 0
end function

public function integer uf_gr_dom (string asproject, string asrono);//Prepare a Goods Receipt Transaction for Honda that was just confirmed

Long			llRowPos, llRowCount, llFindRow,	llNewRow, llDetailFind,llPoNoLen 
				
String		lsFind, lsOutString,	lsMessage, lsLogOut, lsFileName,  lsSku, lsSuppCode,lsfilenamedate, lsLineItemNo,lsModel,lsType,lsColor
//lsUf4,lsUf5,lsUf6,lsUf7,lsUf8,lsUf9,lsCaseTrunc,lsfilenametype, lsPoNoTrunc,lsfilenamedate
String       lsFileNamePath, lsTemp

DEcimal		ldBatchSeq, ldPos
Integer		liRC

If Not isvalid(idsOut) Then
	idsOut = Create Datastore
	idsOut.Dataobject = 'd_edi_generic_out'
	lirc = idsOut.SetTransobject(sqlca)
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

//		If ls_D_Name > '' Then
//			lsOutString+= trim(Left(ls_D_Name,30)) + Space(30 - Len(ls_D_Name)) + '","'					//Destination Name 
//		Else
//			lsOutString+= 'None' + Space(26) + '","'
//		End If	


idsroPutaway.Retrieve(asRONO)
idsroDetail.Retrieve(asRONO)

//Get the Next Batch Seq Nbr - Used for all writing to generic tables
ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asproject,'EDI_Generic_Outbound','EDI_Batch_Seq_No')
If ldBatchSeq <= 0 Then
	lsLogOut = "        *** Unable to retrieve the next available sequence number~rfor Goods Receipt Confirmation.~r~rConfirmation will not be sent to Powerwave!'"
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If
 lsfilenamedate = String(DateTime(Today(),Now()),'yyyymmddhhmmss' )

//Write the rows to the generic output table - delimited by lsDelimitChar
llRowCount = idsroputaway.RowCount()

For llRowPos = 1 to llRowCOunt
	
	llNewRow = idsOut.insertRow(0)
	lsSku =  idsroputaway.GetItemString(llRowPos,'sku')
	lsSuppCode = Upper(idsroputaway.GetItemString(llRowPos,'supp_code'))
	
	lsLineItemNo = String(idsroputaway.GetITemNumber(llRowPos, 'Line_item_No'),'000' )
	
	llDetailFind = idsRoDetail.Find("sku='"+lsSku+"' and Upper(supp_code) = '"+lsSuppCode+"' and line_item_no = " + lsLineItemNo, 1, idsRoDetail.RowCount())
	//Field Name	Type	Req.	Default	Description
	
	//Receipt Date	Date	Yes	N/A	Receipt completion date
	lsOutString = String(idsROMain.GetITemDateTime(1,'complete_date'),'yyyymmdd') 

	//Receipt Time	Time	Yes	N/A	Receipt completion time
	lsOutString += String(idsROMain.GetITemDateTime(1,'complete_date'),'hhmmss') 

	//Active Flag	C(1)	Yes	'A'	
	lsOutString += 'A' 

	//Company Code	C(2)	Yes	'01	'
	lsOutString += '01' 

	//Order Date	Date	Yes	N/A	Receipt order date
	lsOutString += String(idsROMain.GetITemDateTime(1,'ord_date'),'yyyymmdd') //+ lsDelimitChar
	
	//Lot No	C(8)	No		N/A	Detail_UF1
	lsTemp = Left(idsRoDetail.GetItemString(llDetailFind,'User_Field1'),8)
	If IsNull(lsTemp) then 
		lsTemp = '        '
	Else
		lsTemp =  lsTemp + Space(8 - len(lsTemp))
	End If
	lsOutString += lsTemp

	// Line Number C(3)
	lsOutString += lsLineItemNo
	
	//Catagory	C(2)	Yes	'03	'
	lsOutString += '03' 
	
	// Engine Head C(9)	Serial Number 8th Position
	lsTemp = Left(idsRoPutaway.GetITemString(llRowPos,'Serial_No'), len(idsRoPutaway.GetITemString(llRowPos,'Serial_No'))- 7 )
	If IsNull(lsTemp) then
		lsTemp = '         '
	Else
		lsTemp =  lsTemp + Space(9 - len(lsTemp))
	End If
	lsOutString += lsTemp
	
	//Engine No	C(7) 1st 7 of serial no
	lsTemp = Right(idsRoPutaway.GetITemString(llRowPos,'Serial_No'),7)
	If IsNull(lsTemp) then
		lsTemp = '       '
	Else
		lsTemp =  lsTemp + Space(7 - len(lsTemp))
	End If
	lsOutString += lsTemp
	
	//Model_Code C(10)  Sku to the 1st hyphen
	ldPos = Pos(lsSku,'-' )
	If ldPos > 0 and ldPos < 10 Then  //If Hyphen Found then get the SKU to the first Hyphen
		lsModel = Left(lsSku,ldPos -1)
	Else	
		lsModel = Left(lsSku,10)  
	End If
	lsOutString +=  lsModel + Space(10 - len(lsModel ))

	//Type C(6) Sku between the 1st and 2nd hyphen
	lsTemp = Mid(lssku,(ldPos +1))  
	ldPos = Pos(lsTemp,'-' )
	If ldPos > 0 and ldPos < 6 Then  //If Hyphen Found then get the SKU between the 1st and 2nd  Hyphen
		lsType = Left(lsTemp,ldPos -1)
	Else	
		lsType = Left(lsTemp,6)  
	End If
	lsOutString +=  lsType + Space(6 - len(lsType))
		
	//Color C(3) Sku after the 2nd hyphen
	//TAM 2015/1 If color is missing the return 3 Blanks
	//If ldPos = 0 then
	//	lsTemp = '   '
	//End If

	lsTemp = Mid(lstemp,(ldPos +1))  
	If IsNull(lsTemp) then
		lsTemp = '   '
	Else
		lsTemp =  lsTemp + Space(3 - len(lsTemp))
	End If
	lsOutString += lsTemp

	//Model Code From THM	C(15)	No		N/A	Detail_UF2
	lsTemp = Left(idsRoDetail.GetItemString(llDetailFind,'User_Field2'),15)
	If IsNull(lsTemp) then 
		lsTemp = '               '
	Else
		lsTemp =  lsTemp + Space(15 - len(lsTemp))
	End If
	lsOutString += lsTemp
	
	//Color from THM	C(12)	No		N/A	Detail_UF3
	lsTemp = Left(idsRoDetail.GetItemString(llDetailFind,'User_Field3'),12)
	If IsNull(lsTemp) then 
		lsTemp = '            '
	Else
		lsTemp =  lsTemp + Space(12 - len(lsTemp))
	End If
	lsOutString += lsTemp
	
	//Frame Head  C(10)		All but Last 7 of PoNo2  
	llPoNoLen =  len(idsROPutaway.GetItemString(llRowPos,'po_no2' ))
	If llPoNoLen < 8 Then 
		lsTemp = '          '
	Else
		lsTemp = Left(idsROPutaway.GetItemString(llRowPos,'po_no2' ), len(idsROPutaway.GetItemString(llRowPos,'po_no2' )) - 7)
	End If
	lsTemp =  lsTemp + Space(10 - len(lsTemp))
	lsOutString += lsTemp
	
	//Frame No C(7)	last 7 of PoNo2 
	if  len(idsROPutaway.GetItemString(llRowPos,'po_no2' )) <=7 Then
		lsTemp =idsROPutaway.GetItemString(llRowPos,'po_no2' )
		If IsNull(lsTemp) then 
			lsTemp = '       '
		End If	
	Else
		lsTemp = Right(idsROPutaway.GetItemString(llRowPos,'po_no2' ),7)
	End If
	lsTemp =  lsTemp + Space(7 - len(lsTemp))
	lsOutString += lsTemp

	//Process Date	Yes	N/A	Receipt completion date
	lsOutString += String(idsROMain.GetITemDateTime(1,'complete_date'),'yyyymmdd') 

	// Location
	lsOutString += 'DOM  '
	
	// Shift Code
	lsOutString += '01'
	
	//Trip Number
	lsTemp = Left(idsRoMain.GetItemString(1,'ship_ref' ),4)
	If IsNull(lsTemp) then 
		lsTemp = '0000'
	Else
		lsTemp =  fill('0', len(lsTemp)-4) + lsTemp
	End If
	lsOutString += lsTemp
	
	idsOut.SetItem(llNewRow,'Project_id', asproject)
	idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	idsOut.SetItem(llNewRow,'batch_data', lsOutString)
	lsFileName = 'GRCD' + lsfilenamedate + '.TXT'
	idsOut.SetItem(llNewRow,'file_name', lsFileName)


next /*next output record */

//TAM 2014/09/30  Added a 1 secong sleep to allow filenames to be different
	sleep(1)

If idsOut.RowCount() > 0 Then
	gu_nvo_process_files.uf_process_flatfile_outbound_unicode(idsOut, asproject)
End If

//25-Oct-2014 :Madhu -  Email the confirmation file
IF idsroMain.getItemString(1, 'ord_type' ) <> 'H' THEN
lsFileNamePath = ProfileString(gsinifile,asproject,"archivedirectory","") + '\' + lsFileName + '.txt'
gu_nvo_process_files.uf_send_email("HONDA-TH","CUSTVAL","Inbound Confirmation File Sent on " + string(Today(), 'YYYY/MM/DD HH:MM') + ' GMT', "Attached is the Inbound Confirmation File on" + string(Today(), 'YYYY/MM/DD HH:MM') + ' GMT', lsFileNamePath)
END IF
//TAM 2014/09/30  Added a 1 secong sleep to allow filenames to be different
	sleep(1)

Return 0
end function

public function integer uf_gr_exp (string asproject, string asrono);//Prepare a Goods Receipt Transaction for Honda that was just confirmed

Long			llRowPos, llRowCount, llFindRow,	llNewRow
				
String		lsFind, lsOutString,	lsMessage, lsLogOut, lsFileName,  lsSku, lsSuppCode, lsUf4,lsUf5,lsUf6,lsUf7,lsUf8,lsUf9,lsCaseTrunc,lsfilenametype, lsPoNoTrunc,lsfilenamedate
String       lsFileNamePath //24-Oct-2014 :Madhu- Added

DEcimal		ldBatchSeq, ldPos
Integer		liRC

If Not isvalid(idsOut) Then
	idsOut = Create Datastore
	idsOut.Dataobject = 'd_edi_generic_out'
	lirc = idsOut.SetTransobject(sqlca)
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

//		If ls_D_Name > '' Then
//			lsOutString+= trim(Left(ls_D_Name,30)) + Space(30 - Len(ls_D_Name)) + '","'					//Destination Name 
//		Else
//			lsOutString+= 'None' + Space(26) + '","'
//		End If	


idsroPutaway.Retrieve(asRONO)
idsroDetail.Retrieve(asRONO)

//Get the Next Batch Seq Nbr - Used for all writing to generic tables
ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asproject,'EDI_Generic_Outbound','EDI_Batch_Seq_No')
If ldBatchSeq <= 0 Then
	lsLogOut = "        *** Unable to retrieve the next available sequence number~rfor Goods Receipt Confirmation.~r~rConfirmation will not be sent to Powerwave!'"
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If
 lsfilenamedate = String(DateTime(Today(),Now()),'yyyymmddhhmmss' )

//Write the rows to the generic output table - delimited by lsDelimitChar
llRowCount = idsroputaway.RowCount()

For llRowPos = 1 to llRowCOunt
	
	llNewRow = idsOut.insertRow(0)
	lsSku =  idsroputaway.GetItemString(llRowPos,'sku')
	lsSuppCode = idsroputaway.GetItemString(llRowPos,'supp_code')
	
	//Field Name	Type	Req.	Default	Description
	
	//Receipt Date	Date	Yes	N/A	Receipt completion date
	lsOutString = String(idsROMain.GetITemDateTime(1,'complete_date'),'yyyymmdd') //+ lsDelimitChar

	//Receipt Time	Time	Yes	N/A	Receipt completion time
	lsOutString += String(idsROMain.GetITemDateTime(1,'complete_date'),'hhmmss') //+ lsDelimitChar

	//Project	C(10)	Yes	“HONDA     ”	Project Identifier
	lsOutString += 'HONDA     '  //+ lsDelimitChar /*rec type = goods receipt*/

	//Warehouse	C(10)	Yes	N/A{first 3 of Warehouse only)	Receiving Warehouse
	lsOutString += Left(Upper(idsroMain.getItemString(1, 'wh_code')),3) + Space(7)  //+ lsDelimitChar

	//Program ID	C(10)	Yes	Blank	
	lsOutString += Space(10)  //+ lsDelimitChar

	//A	C(1)	Yes	Blank	
	lsOutString += 'A'  //+ lsDelimitChar

	//1	C(2)	Yes	01	
	lsOutString += '01'  //+ lsDelimitChar

	//4	C(2)	Yes	04	
	lsOutString += '04'  //+ lsDelimitChar

	//Order Date	Date	Yes	N/A	Receipt order date
	lsOutString += String(idsROMain.GetITemDateTime(1,'ord_date'),'yyyymmdd') //+ lsDelimitChar
	
	//Location	C(10)	Yes	N/A{first 3 of Warehouse only)	Export or Domestic
	lsOutString += Left(upper(idsroMain.getItemString(1, 'wh_code')),3) + Space(2)  //+ lsDelimitChar

	//Trip No	C(4)	Yes	N/A{first 4 of Ship Ref No only)	
	lsOutString += Left(idsroMain.getItemString(1, 'ship_ref'),4) + Space(4 - len(Left(idsroMain.getItemString(1, 'ship_ref'),4) )) //+ lsDelimitChar

//	//PO NBR	C(7)	No	N/A	PO Number left of Hyphen'-'
	If idsroputaway.GetItemString(llRowPos,'po_no') <> '-' Then
		ldPos = Pos(idsroputaway.GetItemString(llRowPos,'po_no'),'-')
		If ldPos > 0 and ldPos < 8 Then  //If Hyphen Found then Truncate PONO and Space fill to 7
			lsPoNoTrunc = Left(idsroputaway.GetItemString(llRowPos,'po_no'),ldPos -1)
		Else	
			lsPoNoTrunc = Left(idsroputaway.getItemString(llRowPos, 'po_no'),7)  
		End If
			lsOutString +=  lsPoNoTrunc + Space(7 - len(lsPoNoTrunc))  //+ lsDelimitChar
	Else	
		lsOutString +=space(7) //+ lsDelimitChar
	End If	

			
	//Get from Item_Master

	Select User_Field4, User_Field5, User_Field6, User_Field7, User_Field8, User_Field9  INTO :lsUf4, :lsUf5, :lsUf6, :lsUf7, :lsUf8, :lsUf9 From Item_Master
		Where sku = :lsSku and supp_code = :lsSuppCode and project_id = :asproject
		USING SQLCA;
			
	//Item Master User Field4	C(11)	No	N/A	Model
	If IsNull(lsUf4) then lsUf4 = ''
	If len(lsUf4) > 0 Then
		If len(lsUf4) < 11 Then
			lsOutString += Left(lsUf4,11) + Space(11 - len(lsUf4)) //+ lsDelimitChar
		Else
			lsOutString += Left(lsUf4,11) //+ lsDelimitChar
		End If	
	Else
		lsOutString += Space(11)  //+ lsDelimitChar
	End If	

	//Item Master User Field5	C(4)	No	N/A	Type
	If IsNull(lsUf5) then lsUf5 = ''
	If len(lsUf5) > 0 Then
		If len(lsUf5) < 4 Then
			lsOutString += Left(lsUf5,4) + Space(4 - len(lsUf5)) //+ lsDelimitChar
		Else
			lsOutString += Left(lsUf5,4) //+ lsDelimitChar
		End If	
	Else
		lsOutString += Space(4) //+ lsDelimitChar
	End If	

	//Item Master User Field6	C(3)	No	N/A	Option
	If IsNull(lsUf6) then lsUf6 = ''
	If len(lsUf6) > 0 Then
		If len(lsUf6) < 3 Then
			lsOutString += Left(lsUf6,3) + Space(3 - len(lsUf6)) //+ lsDelimitChar
		Else
			lsOutString += Left(lsUf6,3) //+ lsDelimitChar
		End If	
	Else
		lsOutString += Space(3) //+ lsDelimitChar
	End If	

	//Item Master User Field7	C(8)	No	N/A	Hes Color
	If IsNull(lsUf7) then lsUf7 = ''
	If len(lsUf7) > 0 Then
		If len(lsUf7) < 8 Then
			lsOutString += Left(lsUf7,8) + Space(8 - len(lsUf7)) //+ lsDelimitChar
		Else
			lsOutString += Left(lsUf5,8) //+ lsDelimitChar
		End If	
	Else
		lsOutString += Space(8) //+ lsDelimitChar
	End If	

	//Int Color C(2)	Yes	Blank	
	lsOutString += Space(2)  //+ lsDelimitChar

	//Item Master User Field8	and 9 C(6)	No	N/A	Option
	String lsPackingNo
	If IsNull(lsUf8) then 
		lsUf8 = ''
	Else 
		lsUf8 = Left(lsUf8,3)
	End If

	If IsNull(lsUf9) then 
		lsUf9 = '000'
	Else
		If len(lsUf9) < 3 then
			lsUf9 = fill('0', (3 - len(lsUf9))) + lsUf9 
		Else
			lsUf9 = Left(lsUf9,3)
		End If
	End If

	lsPackingNo = lsUf8 + lsUf9
	lsOutString += Left(lsPackingNo,6) + Space(6 - len(lsPackingNo)) //+ lsDelimitChar
	
	//Case Nbr	C(7)	No	N/A	PO Number Right of Hyphen'-'

// TAM 2014/09/23  Take right 6 of PONO and add space in front
	If idsroputaway.GetItemString(llRowPos,'po_no') <> '-' Then
		lsCaseTrunc = Mid(idsroputaway.GetItemString(llRowPos,'po_no'),8,6)
	Else	
		lsCaseTrunc = '' 
	End If
	lsOutString +=  Space(7 - len(lsCaseTrunc)) + lsCaseTrunc  //+ lsDelimitChar
//	If idsroputaway.GetItemString(llRowPos,'po_no') <> '-' Then
//		ldPos = Pos(idsroputaway.GetItemString(llRowPos,'po_no'),'-')
//		If ldPos > 0  Then  //If Hyphen Found then Truncate PONO and Space fill to 6
//			lsCaseTrunc = Left(Mid(idsroputaway.GetItemString(llRowPos,'po_no'),ldPos +1),7)
//		Else	
//			lsCaseTrunc = Space(7)  
//		End If
//		lsOutString +=  Space(7 - len(lsCaseTrunc)) + lsCaseTrunc  //+ lsDelimitChar
//	Else	
//		lsOutString +=space(7) //+ lsDelimitChar
//	End If	
	
	//Quantity	N(15,5)	Yes	N/A	Received quantity
	If len(string(idsroputaway.GetItemNumber(llRowPos,'quantity'))) > 0 Then
		If len(string(idsroputaway.GetItemNumber(llRowPos,'quantity'))) < 3 Then
			lsOutString += string(idsroputaway.GetItemNumber(llRowPos,'quantity')) + Space(3 - len(string(idsroputaway.GetItemNumber(llRowPos,'quantity')))) //+ lsDelimitChar
		Else
			lsOutString += Left(string(idsroputaway.GetItemNumber(llRowPos,'quantity')),3) //+ lsDelimitChar
		End If	
	Else
		lsOutString += Space(3)  //+ lsDelimitChar
	End If	

	//Staus	C(1)	No	' '	
	lsOutString +=space(1) //+ lsDelimitChar

	//Staus date	C(8)	No	'00000000'	
	lsOutString +='00000000' //+ lsDelimitChar

	//Error	C(1)	No	' '	
	lsOutString +=space(1)  // Last item in GR so no Delimeter

	// Use Order Type to determine file name.
	choose case idsroMain.getItemString(1, 'ord_type' )
		case 'X'
			lsfilenametype = 'NDO'
		case 'I'
			lsfilenametype = 'IMP'
		case else
			lsfilenametype = 'RCV'
	end choose
	
	idsOut.SetItem(llNewRow,'Project_id', asproject)
	idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	idsOut.SetItem(llNewRow,'batch_data', lsOutString)
	lsFileName = 'G' + lsfilenametype + lsfilenamedate + '.TXT'
	idsOut.SetItem(llNewRow,'file_name', lsFileName)


next /*next output record */

//TAM 2014/09/30  Added a 1 secong sleep to allow filenames to be different
	sleep(1)

If idsOut.RowCount() > 0 Then
	gu_nvo_process_files.uf_process_flatfile_outbound_unicode(idsOut, asproject)
End If

//25-Oct-2014 :Madhu -  Email the confirmation file
IF idsroMain.getItemString(1, 'ord_type' ) <> 'H' THEN
lsFileNamePath = ProfileString(gsinifile,asproject,"archivedirectory","") + '\' + lsFileName + '.txt'
gu_nvo_process_files.uf_send_email("HONDA-TH","CUSTVAL","Inbound Confirmation File Sent on " + string(Today(), 'YYYY/MM/DD HH:MM') + ' GMT', "Attached is the Inbound Confirmation File on" + string(Today(), 'YYYY/MM/DD HH:MM') + ' GMT', lsFileNamePath)
END IF
//TAM 2014/09/30  Added a 1 secong sleep to allow filenames to be different
	sleep(1)

Return 0
end function

public function integer uf_gi_dom (string asproject, string asdono);//Prepare a Goods Issue Transaction for Honda for the order that was just confirmed

Long			llRowPos, llRowCount, llFindRow,	llNewRow, llDetailFind
				
String		lsFind, lsOutString,	lsMessage, lsLogOut, lsFileName,  lsSku, lsSuppCode,  lsfilenamedate, lslineitemno
String 	lsCaseTrunc, lsUf4, lsUf5, lsUf6, lsUf7, lsUf8, lsUf9, lsfilenametype, lsLineItemN, lsPoNoTrunc,lsFileNamePath, lsModel, lsType, lsColor, lsTemp 


DEcimal		ldBatchSeq, ldPos
Integer		liRC


If Not isvalid(idsOut) Then
	idsOut = Create Datastore
	idsOut.Dataobject = 'd_edi_generic_out'
	lirc = idsOut.SetTransobject(sqlca)
End If

If Not isvalid(idsDOMain) Then
	idsDOMain = Create Datastore
	idsDOMain.Dataobject = 'd_do_master'
	idsDOMain.SetTransObject(SQLCA)
End If

If Not isvalid(idsDoPick) Then
	idsDoPick = Create Datastore
//  TAM 07/19/2012 Changed the datawindow to look at Picking Detail with an out Join to Delivery_serial_detail.  This is so we can populate scanned serial numbers on the GI file
//	idsDoPick.Dataobject = 'd_do_Picking'
	idsDoPick.Dataobject = 'd_do_Picking_detail_baseline' 
	idsDoPick.SetTransObject(SQLCA)
End If

If Not isvalid(idsDoDetail) Then
	idsDoDetail = Create Datastore
	idsDoDetail.Dataobject = 'd_do_Detail'
	idsDoDetail.SetTransObject(SQLCA)
End If

idsOut.Reset()

lsLogOut = "        Creating GI For DONO: " + asDONO
FileWrite(gilogFileNo,lsLogOut)

//Retreive Delivery Master and Detail  records for this DONO
If idsDOMain.Retrieve(asDoNo) <> 1 Then
	lsLogOut = "        *** Unable to retreive Delivery Order Header For DONO: " + asDONO
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

//  If not received elctronically, don't send a confirmation
//If idsDOMain.GetITemNumber(1,'edi_batch_seq_no') = 0 or isNull(idsDOMain.GetITemNumber(1,'edi_batch_seq_no'))    Then Return 0


idsDoPick.Retrieve(asDoNo)
idsDoDetail.Retrieve(asDoNo)


//Get the Next Batch Seq Nbr - Used for all writing to generic tables
ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asproject,'Good_Issue_File','Good_Issue')
If ldBatchSeq <= 0 Then
	lsLogOut = "        *** Unable to retrieve the next available sequence number~rfor Goods Issue Confirmation.~r~rConfirmation will not be sent to Warner!'"
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

 lsfilenamedate = String(DateTime(Today(),Now()),'yyyymmddhhmmss' )

//Write the rows to the generic output table - delimited by lsDelimitChar

llRowCount = idsDoPick.RowCount()

For llRowPos = 1 to llRowCOunt

	llNewRow = idsOut.insertRow(0)


	lsSku = idsdoPick.GetITEmString(llRowPos,'sku')
	lsSuppCode =  Upper(idsdoPick.GetITEmString(llRowPos,'supp_code'))
	lsLineItemNo = String(idsdoPick.GetITemNumber(llRowPos, 'Line_item_No'))
	llDetailFind = idsDoDetail.Find("sku='"+lsSku+"' and Upper(supp_code) = '"+lsSuppCode+"' and line_item_no = " + string(lsLineItemNo), 1, idsDoDetail.RowCount())


	//Can't Find Detail
	IF llDetailFind <= 0 then 
		continue
	End If

	//Field Name	Req.	Default	Description
	
	//Delivery Date	Date	Yes	N/A	Delivery completion date
	lsOutString = String(idsDOMain.GetITemDateTime(1,'complete_date'),'yyyymmdd')

	//Delivery Time	Time	Yes	N/A	Delivery completion time
	lsOutString += String(idsDOMain.GetITemDateTime(1,'complete_date'),'hhmmss')

	//Active Flag	C(1)	Yes	'A'	
	lsOutString += 'A'  //+ lsDelimitChar

	//Company Code	C(2)	Yes	'01	'
	lsOutString += '01'  //+ lsDelimitChar

	//Location	C(5)	Yes	'DOM  '
	lsOutString += 'DOM  '  //+ lsDelimitChar

	//Order Number	C(7)	Yes	N/A	Invoice Number
	lsTemp = Left(idsDoMain.getItemString(1, 'invoice_no'),7)  
	lsOutString +=  lsTemp + Space(7 - len(lsTemp))

	//Line Number	C(4)	Yes	N/A	Line Item Number
	lsOutString +=  string(idsDoDetail.GetItemNumber(llDetailFind,'Line_item_no'),'0000' )

	//Schedule Date	Date	Yes	N/A	Delivery scheduled date
	lsOutString += String(idsDOMain.GetITemDateTime(1,'schedule_date'),'yyyymmdd') //+ lsDelimitChar
	
	//Dealer Code	C(5)	Yes	N/A	Customer Code
	lstemp = Left(idsDoMain.getItemString(1, 'Cust_Code'),5)  
	If IsNull(lsTemp) then 
		lsTemp = '   '
	Else
		lsTemp =  lsTemp + Space(5 - len(lsTemp))
	End If
	lsOutString += lsTemp
	
	//Territory	C(3)	No		N/A	Detail_UF3
	lsTemp = Left(idsDoDetail.GetItemString(llDetailFind,'User_Field3'),3)
	If IsNull(lsTemp) then 
		lsTemp = '   '
	Else
		lsTemp =  lsTemp + Space(3 - len(lsTemp))
	End If
	lsOutString += lsTemp

	//Ship To		C(5)	Yes	N/A	Master_UF4
	lstemp = Left(idsDoMain.getItemString(1, 'User_Field4'),5)  
	If IsNull(lsTemp) then 
		lsTemp = '     '
	Else
		lsTemp =  lsTemp + Space(5 - len(lsTemp))
	End If
	lsOutString += lsTemp
	
	//Allocate No	C(7)	No		N/A	Detail_UF4
	lsTemp = Left(idsDoDetail.GetItemString(llDetailFind,'User_Field4'),7)
	If IsNull(lsTemp) then 
		lsTemp = '       '
	Else
		lsTemp =  lsTemp + Space(7 - len(lsTemp))
	End If
	lsOutString += lsTemp

	//Allocate Date		C(8)	No		N/A	Detail_UF5
	lsTemp = Left(idsDoDetail.GetItemString(llDetailFind,'User_Field5'),8)
	If IsNull(lsTemp) then 
		lsTemp = '        '
	Else
		lsTemp =  lsTemp + Space(8 - len(lsTemp))
	End If
	lsOutString += lsTemp

	//Item No	C(4)	No		N/A	Detail_UF8
	lsTemp = Left(idsDoDetail.GetItemString(llDetailFind,'User_Field8'),4)
	If IsNull(lsTemp) then 
		lsTemp = '    '
	Else
		lsTemp =  lsTemp + Space(4 - len(lsTemp))
	End If
	lsOutString += lsTemp

	//Model_Code C(10)  Sku to the 1st hyphen
	ldPos = Pos(lsSku,'-' )
	If ldPos > 0 and ldPos < 10 Then  //If Hyphen Found then get the SKU to the first Hyphen
		lsModel = Left(lsSku,ldPos -1)
	Else	
		lsModel = Left(lsSku,10)  
	End If
		lsOutString +=  lsModel + Space(10 - len(lsModel ))

	//Type C(6) Sku between the 1st and 2nd hyphen
	lsTemp = Mid(lssku,(ldPos +1))  
	ldPos = Pos(lsTemp,'-' )
	If ldPos > 0 and ldPos < 6 Then  //If Hyphen Found then get the SKU between the 1st and 2nd  Hyphen
		lsType = Left(lsTemp,ldPos -1)
	Else	
		lsType = Left(lsTemp,6)  
	End If
		lsOutString +=  lsType + Space(6 - len(lsType))
		
	//Color C(3) Sku after the 2nd hyphen(remainder
	//TAM 2015/1 If color is missing the return 3 Blanks
//	If ldPos = 0 Then 
//		lsTemp = '   '
//	End If
	
	lsTemp = Mid(lstemp,(ldPos +1))  
	If IsNull(lsTemp) then 
		lsTemp = '   '
	Else
		lsTemp =  lsTemp + Space(3 - len(lsTemp))
	End If
	lsOutString += lsTemp

	//Order Type	C(2)	No		N/A	Detail_UF6
	lsTemp = Left(idsDoDetail.GetItemString(llDetailFind,'User_Field6'),2)
	If IsNull(lsTemp) then 
		lsTemp = '  '
	Else
		lsTemp =  lsTemp + Space(2 - len(lsTemp))
	End If
	lsOutString += lsTemp
	
	//Pack Code 	C(6)	No		N/A	Detail_UF7
	lsTemp = Left(idsDoDetail.GetItemString(llDetailFind,'User_Field7'),6)
	If IsNull(lsTemp) then 
		lsTemp = '      '
	Else
		lsTemp =  lsTemp + Space(6 - len(lsTemp))
	End If
	lsOutString += lsTemp

	// Engine Head C(9)	Serial Number 8th Position
	lsTemp = Left(idsdoPick.GetITemString(llRowPos,'Serial_No'), len(idsdoPick.GetITemString(llRowPos,'Serial_No'))- 7 )
	
	If IsNull(lsTemp) then
		lsTemp = '         '
	Else
		lsTemp =  lsTemp + Space(9 - len(lsTemp))
	End If
	lsOutString += lsTemp

	
	//Engine No	C(7) last 7 of serial no
	lsTemp = Right(idsdoPick.GetITemString(llRowPos,'Serial_No'),7)
	
	If IsNull(lsTemp) then
		lsTemp = '       '
	Else
		lsTemp =  lsTemp + Space(7 - len(lsTemp))
	End If
	lsOutString += lsTemp
	
	//Frame Head  C(10)		PoNo2 after 7 chars 

	lsTemp = Left(idsdoPick.GetITemString(llRowPos,'po_no2' ), len(idsdoPick.GetITemString(llRowPos,'Po_No2'))- 7 )
	
	If IsNull(lsTemp) then
		lsTemp = '         '
	Else
		lsTemp =  lsTemp + Space(10 - len(lsTemp))
	End If
	lsOutString += lsTemp
	
	//Frame No C(7)	last 7 of PoNo2 
	lsTemp = Right(idsDoPick.GetItemString(llRowPos,'po_no2' ),7)
	If IsNull(lsTemp) then 
		lsTemp = '       '
	Else
		lsTemp =  lsTemp + Space(7 - len(lsTemp))
	End If
	lsOutString += lsTemp

	//Process Date	Yes	N/A	Delivery completion date
	lsOutString += String(idsDOMain.GetITemDateTime(1,'complete_date'),'yyyymmdd')

	//Truck No	C(7)	No		N/A	Detail_UF1
	lsTemp = Left(idsDoDetail.GetItemString(llDetailFind,'User_Field1'),7)
	If IsNull(lsTemp) then 
		lstemp = '  '
	Else
		lsTemp =  lsTemp + Space(7 - len(lsTemp))
	End If
	lsOutString += lsTemp

	//Delivery Time	Time	Yes	N/A	Delivery completion time
		
	idsOut.SetItem(llNewRow,'Project_id', asProject)
	idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	idsOut.SetItem(llNewRow,'batch_data', lsOutString)
	lsFileName = 'GISD' + lsfilenamedate + '.TXT'
	idsOut.SetItem(llNewRow,'file_name', lsFileName)


next /*next Delivery Detail record */


//Write the Outbound File - no need to save and re-retrieve - just use the currently loaded DW
gu_nvo_process_files.uf_process_flatfile_outbound_unicode(idsOut,asProject)

//25-Oct-2014 :Madhu -  Email the confirmation file
IF idsDOMain.getItemString(1, 'ord_type' ) <> 'H' THEN
lsFileNamePath = ProfileString(gsinifile,asproject,"archivedirectory","") + '\' + lsFileName + '.txt'
gu_nvo_process_files.uf_send_email("HONDA-TH","CUSTVAL","Outbound Confirmation File Sent on " + string(Today(), 'YYYY/MM/DD HH:MM') + ' GMT', "Attached is the Outbound Confirmation File on" + string(Today(), 'YYYY/MM/DD HH:MM') + ' GMT', lsFileNamePath)
END IF

//TAM 2014/09/30  Added a 1 second sleep to allow filenames to be different
	sleep(1)

Return 0
end function

public function integer uf_gi_exp (string asproject, string asdono);//Prepare a Goods Issue Transaction for Honda for the order that was just confirmed

Long			llRowPos, llRowCount, llFindRow,	llNewRow, llDetailFind
				
String		lsFind, lsOutString,	lsMessage, lsLogOut, lsFileName,  lsSku, lsSuppCode,  lsfilenamedate, lslineitemno
String 	lsCaseTrunc, lsUf4, lsUf5, lsUf6, lsUf7, lsUf8, lsUf9, lsfilenametype, lsLineItemN, lsPoNoTrunc,lsFileNamePath


DEcimal		ldBatchSeq, ldPos
Integer		liRC


If Not isvalid(idsOut) Then
	idsOut = Create Datastore
	idsOut.Dataobject = 'd_edi_generic_out'
	lirc = idsOut.SetTransobject(sqlca)
End If

If Not isvalid(idsDOMain) Then
	idsDOMain = Create Datastore
	idsDOMain.Dataobject = 'd_do_master'
	idsDOMain.SetTransObject(SQLCA)
End If

If Not isvalid(idsDoPick) Then
	idsDoPick = Create Datastore
//  TAM 07/19/2012 Changed the datawindow to look at Picking Detail with an out Join to Delivery_serial_detail.  This is so we can populate scanned serial numbers on the GI file
//	idsDoPick.Dataobject = 'd_do_Picking'
	idsDoPick.Dataobject = 'd_do_Picking_detail_baseline' 
	idsDoPick.SetTransObject(SQLCA)
End If

If Not isvalid(idsDoDetail) Then
	idsDoDetail = Create Datastore
	idsDoDetail.Dataobject = 'd_do_Detail'
	idsDoDetail.SetTransObject(SQLCA)
End If

idsOut.Reset()

lsLogOut = "        Creating GI For DONO: " + asDONO
FileWrite(gilogFileNo,lsLogOut)

//Retreive Delivery Master and Detail  records for this DONO
If idsDOMain.Retrieve(asDoNo) <> 1 Then
	lsLogOut = "        *** Unable to retreive Delivery Order Header For DONO: " + asDONO
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

//  If not received elctronically, don't send a confirmation
//If idsDOMain.GetITemNumber(1,'edi_batch_seq_no') = 0 or isNull(idsDOMain.GetITemNumber(1,'edi_batch_seq_no'))    Then Return 0


idsDoPick.Retrieve(asDoNo)
idsDoDetail.Retrieve(asDoNo)


//Get the Next Batch Seq Nbr - Used for all writing to generic tables
ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asproject,'Good_Issue_File','Good_Issue')
If ldBatchSeq <= 0 Then
	lsLogOut = "        *** Unable to retrieve the next available sequence number~rfor Goods Issue Confirmation.~r~rConfirmation will not be sent to Warner!'"
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

 lsfilenamedate = String(DateTime(Today(),Now()),'yyyymmddhhmmss' )

//Write the rows to the generic output table - delimited by lsDelimitChar

llRowCount = idsDoPick.RowCount()

For llRowPos = 1 to llRowCOunt

	llNewRow = idsOut.insertRow(0)


	lsSku = idsdoPick.GetITEmString(llRowPos,'sku')
	lsSuppCode =  Upper(idsdoPick.GetITEmString(llRowPos,'supp_code'))
	lsLineItemNo = String(idsdoPick.GetITemNumber(llRowPos, 'Line_item_No'))
	llDetailFind = idsDoDetail.Find("sku='"+lsSku+"' and Upper(supp_code) = '"+lsSuppCode+"' and line_item_no = " + string(lsLineItemNo), 1, idsDoDetail.RowCount())


	//Can't Find Detail
	IF llDetailFind <= 0 then 
		continue
	End If


	//Field Name	Type	Req.	Default	Description
	
	//Delivery Date	Date	Yes	N/A	Delivery completion date
	lsOutString = String(idsDOMain.GetITemDateTime(1,'complete_date'),'yyyymmdd') //+ lsDelimitChar

	//Delivery Time	Time	Yes	N/A	Delivery completion time
	lsOutString += String(idsDOMain.GetITemDateTime(1,'complete_date'),'hhmmss') //+ lsDelimitChar

	//Project	C(10)	Yes	“HONDA     ”	Project Identifier
	lsOutString += 'HONDA     '  //+ lsDelimitChar /*rec type = goods receipt*/

	//Warehouse	C(10)	Yes	N/A{first 3 of Warehouse only)	Receiving Warehouse
	lsOutString += Left(Upper(idsDOMain.getItemString(1, 'wh_code')),3) + Space(7)  //+ lsDelimitChar

	//Program ID	C(10)	Yes	Blank	
	lsOutString += space(10)

	//A	C(1)	Yes	Blank	
	lsOutString += 'A'  //+ lsDelimitChar

	//1	C(2)	Yes	01	
	lsOutString += '01'  //+ lsDelimitChar

	//4	C(2)	Yes	04	
	lsOutString += '04'  //+ lsDelimitChar

	//PC No	C(7)	No	N/A	PO Number left of Hyphen'-'
	If idsDoPick.GetItemString(llRowPos,'po_no') <> '-' Then
		ldPos = Pos(idsDoPick.GetItemString(llRowPos,'po_no'),'-')
		If ldPos > 0 and ldPos < 8 Then  //If Hyphen Found then Truncate PONO and Space fill to 7
			lsPoNoTrunc = Left(idsDoPick.GetItemString(llRowPos,'po_no'),ldPos -1)
		Else	
			lsPoNoTrunc = Left(idsDoPick.getItemString(llRowPos, 'po_no'),7)  
		End If
			lsOutString +=  lsPoNoTrunc + Space(7 - len(lsPoNoTrunc))//+ lsDelimitChar
	Else	
		lsOutString +=space(7) //+ lsDelimitChar
	End If	
	
	//Lot Number	C(50)	No	N/A	1st User Defined Inventory field
	If Not IsNull(idsDoDetail.GetItemString(llDetailFind,'User_Field2'))Then
		If len(idsDoDetail.GetItemString(llDetailFind,'User_Field2')) < 2 Then
			lsOutString += Left(idsDoDetail.GetItemString(llDetailFind,'User_Field2'),2) + Space(2 - len(idsDoDetail.GetItemString(llDetailFind,'User_Field2'))) //+ lsDelimitChar
		Else
			lsOutString += Left(idsDoDetail.GetItemString(llDetailFind,'User_Field2'),2) //+ lsDelimitChar
		End If	
	Else
		lsOutString += Space(2)  //+ lsDelimitChar
	End If	
	
	//Case Nbr	C(7)	No	N/A	PO Number Right of Hyphen'-' !!!Left Fill with Blanks
// TAM 2014/09/23  Take right 6 of PONO and add space in front
	If idsDoPick.GetItemString(llRowPos,'po_no') <> '-' Then
		lsCaseTrunc = Mid(idsDoPick.GetItemString(llRowPos,'po_no'),8,6)
	Else	
		lsCaseTrunc = ''  
	End If	
	lsOutString +=fill(' ',(7 -len(lsCaseTrunc))) + lsCaseTrunc //+ lsDelimitChar

//	If idsDoPick.GetItemString(llRowPos,'po_no') <> '-' Then
//		ldPos = Pos(idsDoPick.GetItemString(llRowPos,'po_no'),'-')
//		If ldPos > 0  Then  //If Hyphen Found then Truncate PONO and Space fill to 6
//			lsCaseTrunc = Left(Mid(idsDoPick.GetItemString(llRowPos,'po_no'),ldPos +1),7)
//		Else	
//			lsCaseTrunc = Space(7)  
//		End If
//			lsOutString +=fill(' ',(7 -len(lsCaseTrunc))) + lsCaseTrunc //+ lsDelimitChar
//	Else	
//		lsOutString +=space(7) //+ lsDelimitChar
//	End If	

//01-Dec-2014 :Madhu- As requested get container Id value from DM.UF3 instead of DD.UF1 -START
	//Container No	C(15)	Yes	N/A {first 15 of Ship Ref No only)	
//	If Not IsNull(idsDoDetail.GetItemString(llDetailFind,'User_Field1'))Then
//		If len(idsDoDetail.GetItemString(llDetailFind,'User_Field1')) < 15 Then
//			lsOutString += Left(idsDoDetail.GetItemString(llDetailFind,'User_Field1'),15) + Space(15 - len(idsDoDetail.GetItemString(llDetailFind,'User_Field1'))) //+ lsDelimitChar
//		Else
//			lsOutString += Left(idsDoDetail.GetItemString(llDetailFind,'User_Field1'),15) //+ lsDelimitChar
//		End If	
//	Else
//		lsOutString += Space(15)  //+ lsDelimitChar
//	End If	

If Not IsNull(idsDOMain.getitemstring(1,'user_field3')) THEN
	If len(idsDOMain.getitemstring(1,'user_field3')) < 15 Then
		lsOutString += Left(idsDoMain.getitemstring(1,'user_field3'),15) + Space(15 - len(idsDoMain.getitemstring(1,'user_field3')))
	ELSE
		lsOutString += Left(idsDoMain.getitemstring(1,'user_field3'),15)
	End If
Else
	lsOutString += Space(15)
End If
//01-Dec-2014 :Madhu- As requested get container Id value from DM.UF3 instead of DD.UF1 -END

	//Get from Item_Master

	Select User_Field4, User_Field5, User_Field6, User_Field7, User_Field8, User_Field9  INTO :lsUf4, :lsUf5, :lsUf6, :lsUf7, :lsUf8, :lsUf9 From Item_Master
		Where sku = :lsSku and supp_code = :lsSuppCode and project_id = :asproject
		USING SQLCA;
			
	//Item Master User Field4	C(11)	No	N/A	Model
	If IsNull(lsUf4) then lsUf4 = ''
	If len(lsUf4) > 0 Then
		If len(lsUf4) < 11 Then
			lsOutString += Left(lsUf4,11) + Space(11 - len(lsUf4)) //+ lsDelimitChar
		Else
			lsOutString += Left(lsUf4,11) //+ lsDelimitChar
		End If	
	Else
		lsOutString += Space(11)  //+ lsDelimitChar
	End If	

	//Item Master User Field5	C(4)	No	N/A	Type
	If IsNull(lsUf5) then lsUf5 = ''
	If len(lsUf5) > 0 Then
		If len(lsUf5) < 4 Then
			lsOutString += Left(lsUf5,4) + Space(4 - len(lsUf5)) //+ lsDelimitChar
		Else
			lsOutString += Left(lsUf5,4) //+ lsDelimitChar
		End If	
	Else
		lsOutString += Space(4) //+ lsDelimitChar
	End If	

	//Item Master User Field6	C(3)	No	N/A	Option
	If IsNull(lsUf6) then lsUf6 = ''
	If len(lsUf6) > 0 Then
		If len(lsUf6) < 3 Then
			lsOutString += Left(lsUf6,3) + Space(3 - len(lsUf6)) //+ lsDelimitChar
		Else
			lsOutString += Left(lsUf6,3) //+ lsDelimitChar
		End If	
	Else
		lsOutString += Space(3) //+ lsDelimitChar
	End If	

	//Item Master User Field7	C(8)	No	N/A	Color
	If IsNull(lsUf7) then lsUf7 = ''
	If len(lsUf7) > 0 Then
		If len(lsUf7) < 8 Then
			lsOutString += Left(lsUf7,8) + Space(8 - len(lsUf7)) //+ lsDelimitChar
		Else
			lsOutString += Left(lsUf5,8) //+ lsDelimitChar
		End If	
	Else
		lsOutString += Space(8) //+ lsDelimitChar
	End If	

	//Hes Color C(8)	Yes	Blank	
	lsOutString += Space(8)  //+ lsDelimitChar

	//Int Color C(2)	Yes	Blank	
	lsOutString += Space(2)  //+ lsDelimitChar

	//Item Master User Field8	and 9 C(6)	No	N/A	Option
	String lsPackingNo
	If IsNull(lsUf8) then 
		lsUf8 = '   '
	Else 
		lsUf8 = Left(lsUf8,3)
	End If

	If IsNull(lsUf9) then 
		lsUf9 = '000'
	Else
		If len(lsUf9) < 3 then
			lsUf9 = fill('0', (3 - len(lsUf9))) + lsUf9 
		Else
			lsUf9 = Left(lsUf9,3)
		End If
	End If

	lsPackingNo = lsUf8 + lsUf9
	lsOutString += Left(lsPackingNo,6) + Space(6 - len(lsPackingNo)) //+ lsDelimitChar
	
	//Quantity	N(15,5)	Yes	N/A	Received quantity
	If len(string(idsDoPick.GetItemNumber(llRowPos,'quantity'))) > 0 Then
		If len(string(idsDoPick.GetItemNumber(llRowPos,'quantity'))) <= 3 Then
			lsOutString += string(idsDoPick.GetItemNumber(llRowPos,'quantity')) + Space(3 - len(string(idsDoPick.GetItemNumber(llRowPos,'quantity')))) //+ lsDelimitChar
		Else
			lsOutString += Left(string(idsDoPick.GetItemNumber(llRowPos,'quantity')),3) //+ lsDelimitChar
		End If	
	Else
		lsOutString += Space(3)  //+ lsDelimitChar
	End If	

	//Staus	C(1)	No	' '	
	lsOutString +=space(1) //+ lsDelimitChar

	//Staus date	C(8)	No	'00000000'	
	lsOutString +='00000000' //+ lsDelimitChar

	//Rec Typ	C(1)	No	' '	
	lsOutString +=space(1) //+ lsDelimitChar

	//Error	C(1)	No	' '	
	lsOutString +=space(1)  // Last item in GR so no Delimeter

//	// Use Order Type to determine file name.
//	choose case idsDOMain.getItemString(1, 'ord_type' )
//		case 'X'
//			lsfilenametype = 'NDO'
//		case 'I'
//			lsfilenametype = 'IMP'
//		case else
			lsfilenametype = 'SS'
//	end choose

	//Delivery Time	Time	Yes	N/A	Delivery completion time
		
	idsOut.SetItem(llNewRow,'Project_id', asProject)
	idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	idsOut.SetItem(llNewRow,'batch_data', lsOutString)
	lsFileName = 'GI' + lsfilenametype + lsfilenamedate + '.TXT'
	idsOut.SetItem(llNewRow,'file_name', lsFileName)


next /*next Delivery Detail record */


//Write the Outbound File - no need to save and re-retrieve - just use the currently loaded DW
gu_nvo_process_files.uf_process_flatfile_outbound_unicode(idsOut,asProject)

//25-Oct-2014 :Madhu -  Email the confirmation file
IF idsDOMain.getItemString(1, 'ord_type' ) <> 'H' THEN
lsFileNamePath = ProfileString(gsinifile,asproject,"archivedirectory","") + '\' + lsFileName + '.txt'
gu_nvo_process_files.uf_send_email("HONDA-TH","CUSTVAL","Outbound Confirmation File Sent on " + string(Today(), 'YYYY/MM/DD HH:MM') + ' GMT', "Attached is the Outbound Confirmation File on" + string(Today(), 'YYYY/MM/DD HH:MM') + ' GMT', lsFileNamePath)
END IF

//TAM 2014/09/30  Added a 1 secong sleep to allow filenames to be different
	sleep(1)

Return 0
end function

on u_nvo_edi_confirmations_honda.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_nvo_edi_confirmations_honda.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;
lsDelimitChar = char(9)
end event

