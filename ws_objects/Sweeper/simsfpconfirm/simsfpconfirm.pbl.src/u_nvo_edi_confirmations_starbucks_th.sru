$PBExportHeader$u_nvo_edi_confirmations_starbucks_th.sru
forward
global type u_nvo_edi_confirmations_starbucks_th from nonvisualobject
end type
end forward

global type u_nvo_edi_confirmations_starbucks_th from nonvisualobject
end type
global u_nvo_edi_confirmations_starbucks_th u_nvo_edi_confirmations_starbucks_th

type prototypes

Function boolean MoveFile (ref string lpExistingFileName, ref string lpNewFileName ) LIBRARY "kernel32.dll" ALIAS FOR "MoveFileA;Ansi"
FUNCTION boolean CopyFile(ref string cfrom, ref string cto, boolean flag) LIBRARY "Kernel32.dll" ALIAS for "CopyFileA;Ansi"


end prototypes

type variables

Datastore	idsROMain, idsRODetail, idsROPutaway, idsDOMain, idsDODetail, idsDOPick, idsDOPack,	&
				idsOut,idsGROrders
				
				
string lsDelimitChar
end variables

forward prototypes
public function integer uf_gr ()
public function integer uf_gi ()
public function integer uf_process_flatfile_outbound_unicode (ref datastore adw_output, string asproject)
end prototypes

public function integer uf_gr ();//Prepare a Goods Receipt TSummary file for all orders confirmed today
// THis is triggered from the schedular on a timed basis and not triggered from the transaction file when order confirmed

Long			llRowPos, llRowCount, llFindRow,	llNewRow, llOrderCount, llOrderPos
				
String		lsFind, lsOutString,	lsMessage, lsLogOut, lsFileName,  lsSku, lsSuppCode, lsCOO, lsGrp, lsProject,ls_email
String   	sql_Syntax, errors, lsRONO,lssuppinvoiceno,lsprevsuppinvoiceno //04-Dec-2013 :Madhu Added
DEcimal		ldBatchSeq
Integer		liRC
Datastore	ldsOrders


lsLogOut = "    - Processing Daily GR file for Starbucks-TH "
gu_nvo_process_files.uf_write_log(lsLogOut)
FileWrite(gilogFileNo,lsLogOut)

If Not isvalid(idsOut) Then
	idsOut = Create Datastore
	idsOut.Dataobject = 'd_edi_generic_out'
	lirc = idsOut.SetTransobject(sqlca)
End If

//04-Dec-2013 :Madhu -Added code to generate GR file on grouping by Supp_Invoice_No,Line_Item_No -START

//If Not isvalid(idsromain) Then
//	idsromain = Create Datastore
//	idsromain.Dataobject = 'd_ro_master'
//	idsroMain.SetTransObject(SQLCA)
//End If
//
//If Not isvalid(idsRODetail) Then
//	idsRODetail = Create Datastore
//	idsRODetail.Dataobject = 'd_ro_detail' 
//	idsRODetail.SetTransObject(SQLCA)
//End If
//
//
//If Not isvalid(idsroputaway) Then
//	idsroputaway = Create Datastore
//	idsroputaway.Dataobject = 'd_ro_putaway_starbucks'
//	idsroputaway.SetTransObject(SQLCA)
//End If

//Retrieve a list of OldsOrders = Create Datastore
//ldsOrders = Create Datastore
//sql_syntax = "SELECT ro_no from Receive_Master " 
//sql_syntax += " Where Project_ID = 'STBTH' and ord_status = 'C' and (file_transmit_ind is null or file_transmit_ind <> 'Y')"
//ldsOrders.Create(SQLCA.SyntaxFromSQL(sql_syntax,"", ERRORS))
//IF Len(ERRORS) > 0 THEN
//   lsLogOut = "        *** Unable to create datastore for Starbucks GR~r~r" + Errors
//	FileWrite(gilogFileNo,lsLogOut)
//   RETURN - 1
//END IF
//
//ldsOrders.SetTransObject(SQLCA)
//llOrderCOunt = ldsOrders.Retrieve()
//
//If llOrderCount = 0 Then
//	 lsLogOut = "       No Inbound Orders retrieved for GR processing"
//	FileWrite(gilogFileNo,lsLogOut)
//   RETURN 0
//End If
//
//Get the Next Batch Seq Nbr - Used for all writing to generic tables
ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no('STBTH','EDI_Generic_Outbound','EDI_Batch_Seq_No')
If ldBatchSeq <= 0 Then
	lsLogOut = "        *** Unable to retrieve the next available sequence number~rfor Goods Receipt Confirmation.~r~rConfirmation will not be sent to Powerwave!'"
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If
//
////Process Each ORder
//FOr llOrderPos = 1 to llORderCount
//
////26-Nov-2013 :Madhu- Added code to get Ro_No based on Supp_Invoice_No -START
////	lsRONO = ldsOrders.GetITemSTring(llOrderPos,'ro_no') //Madhu -commented
//	lssuppinvoiceno =ldsOrders.GetItemString(llOrderPos,'supp_invoice_no') 
//	SELECT TOP 1 Ro_No into :lsRONO from Receive_Master where Project_Id ='STBTH' and Supp_Invoice_No=:lssuppinvoiceno using sqlca;
////26-Nov-2013 :Madhu- Added code to get Ro_No based on Supp_Invoice_No -END	
//
//	lsLogOut = "      Creating GR For RONO: " + lsRONO
//	FileWrite(gilogFileNo,lsLogOut)
//	
//	//Retreive the Receive Header and Putaway records for this order
//	If idsroMain.Retrieve(lsRoNo) <> 1 Then
//		lsLogOut = "                  *** Unable to retreive Receive Order Header For RONO: " + lsRONO
//		FileWrite(gilogFileNo,lsLogOut)
//		Return -1
//	End If
//
//	//6/13: MEA - No receipt confirmation file to be generated Requested by Tan BoonHee.
//	If idsROMain.GetItemString(1,'ord_type') =  'M' Then
//		lsLogOut = "                  NO EDI generates for Starbucks Marketing Order Type for Inbound Order#" + lsRONO
//		FileWrite(gilogFileNo,lsLogOut)
//		//MEA - Fixed 8/13
//		Continue
////		Return 0
//	End If
//
////26-Nov-2013 :Madhu -Passing Supp_Invoice_No instead of Ro_No -START
////	idsroPutaway.Retrieve(lsRONO) //Madhu commented
////	idsroDetail.Retrieve(lsRONO)    //Madhu commented
//
//	idsroPutaway.Retrieve(lssuppinvoiceno)
//	idsroDetail.Retrieve(lssuppinvoiceno)
//
////26-Nov-2013 :Madhu -Passing Supp_Invoice_No instead of Ro_No -END
//
//	lsProject = idsroMain.GetITemString(1,'Project_id')
//	
//	//Write the rows to the generic output table - delimited by lsDelimitChar
//	llRowCount = idsroputaway.RowCount()
//
//	For llRowPos = 1 to llRowCOunt
//	
//		llNewRow = idsOut.insertRow(0)
//	
//	
//		//Record_ID	C(2)	Yes	“GR”	Goods receipt confirmation identifier
//		lsOutString = 'GR'  + lsDelimitChar /*rec type = goods receipt*/
//
//		//Project ID	C(10)	Yes	N/A	Project identifier
//		lsOutString += lsproject + lsDelimitChar
//	
//		//Warehouse	C(10)	Yes	N/A	Receiving Warehouse
//		lsOutString += upper(idsroMain.getItemString(1, 'wh_code'))  + lsDelimitChar
//
//		//Order Number	C(20)	Yes	N/A	Purchase order number
//		lsOutString += idsROMain.GetItemString(1,'supp_invoice_no') + lsDelimitChar
//
//		//Inventory Type	C(1)	Yes	N/A	Item condition
//		lsOutString += idsroputaway.GetItemString(llRowPos,'inventory_type') + lsDelimitChar
//	
//		//Receipt Date	Date	Yes	N/A	Receipt completion date
//		lsOutString += String(idsROMain.GetITemDateTime(1,'complete_date'),'yyyy-mm-dd') + lsDelimitChar
//	
//		//SKU	C(50	Yes	N/A	Material Number
//		lsSku =  idsroputaway.GetItemString(llRowPos,'sku')
//		lsSuppCode = idsroputaway.GetItemString(llRowPos,'supp_code')		
//		lsOutString += idsroputaway.GetItemString(llRowPos,'sku') + lsDelimitChar
//	
//		//Quantity	N(15,5)	Yes	N/A	Received quantity
//		lsOutString += string(idsroputaway.GetItemNumber(llRowPos,'quantity')) + lsDelimitChar	
//	
//		//Lot Number	C(50)	No	N/A	1st User Defined Inventory field
//		If idsroputaway.GetItemString(llRowPos,'lot_no') <> '-' Then
//			lsOutString += String(idsroputaway.GetItemString(llRowPos,'lot_no')) + lsDelimitChar
//		Else
//			lsOutString += lsDelimitChar
//		End If	
//	
//		//PO NBR	C(50)	No	N/A	2nd User Defined Inventory field
//		If idsroputaway.GetItemString(llRowPos,'po_no') <> '-' Then
//			lsOutString += String(idsroputaway.GetItemString(llRowPos,'po_no')) + lsDelimitChar
//		Else
//			lsOutString += lsDelimitChar
//		End If	
//	
//		//PO NBR 2	C(50)	No	N/A	3rd User Defined Inventory Field
//		If idsroputaway.GetItemString(llRowPos,'po_no2') <> '-' Then
//			lsOutString += String(idsroputaway.GetItemString(llRowPos,'po_no2')) + lsDelimitChar
//		Else
//			lsOutString += lsDelimitChar
//		End If		
//	
//		//Serial Number	C(50)	No	N/A	Qty must be 1 if present
//
//		If idsroputaway.GetItemString(llRowPos,'serial_no') <> '-' Then
//			lsOutString += String(idsroputaway.GetItemString(llRowPos,'serial_no')) + lsDelimitChar
//		Else
//			lsOutString += lsDelimitChar
//		End If	
//	
//		//Container ID	C(25)	No	N/A	
//
//		If idsroputaway.GetItemString(llRowPos,'container_id') <> '-' Then
//			lsOutString += String(idsroputaway.GetItemString(llRowPos,'container_id')) + lsDelimitChar
//		Else
//			lsOutString += lsDelimitChar
//		End If		
//
//		//MEA - 8/13 - Not sending due to GR grouping as per BoonHee.
//
//		//Expiration Date	Date	No	N/A	
////		If Not IsNull(idsroputaway.GetItemDateTime(llRowPos,'expiration_date')) Then
////			lsOutString += String(idsroputaway.GetItemDateTime(llRowPos,'expiration_date'),'yyyy-mm-dd') + lsDelimitChar
////		Else
//			lsOutString += lsDelimitChar
////		End If		
//		
//		//Line Item Number	N(6,0)	Yes	N/A	Item number of purchase order document
//		lsOutString += String(idsroputaway.GetItemNumber(llRowPos,'line_item_no')) + lsDelimitChar
//	
//		//Customer  Line Item Number 	C(25)	No	N/A	Customer  Line Item Number
//		llFindRow = idsRODetail.Find("sku='"+lsSku+"' and supp_code = '"+lsSuppCode+"' ", 1, idsRODetail.RowCount())
//	
//		If llFindRow > 0 AND idsRODetail.GetItemString(llFindRow,'user_line_item_no') <> '' Then
//			lsOutString += String(idsRODetail.GetItemString(llFindRow,'user_line_item_no')) + lsDelimitChar
//		Else
//			lsOutString += lsDelimitChar
//		End If	
//	
//		//Detail User Field1	C(50)	No	N/A	User Field
//		If llFindRow > 0 AND idsRODetail.GetItemString(llFindRow,'user_field1') <> '' Then
//			lsOutString += String(idsRODetail.GetItemString(llFindRow,'user_field1')) + lsDelimitChar
//		Else
//			lsOutString += lsDelimitChar
//		End If		
//		
//		//Detail User Field2	C(50)	No	N/A	User Field
//		If llFindRow > 0 AND  idsRODetail.GetItemString(llFindRow,'user_field2') <> '' Then
//			lsOutString += String(idsRODetail.GetItemString(llFindRow,'user_field2')) + lsDelimitChar
//		Else
//			lsOutString += lsDelimitChar
//		End If		
//		
//		//Detail User Field3	C(50)	No	N/A	User Field
//		If llFindRow > 0 AND  idsRODetail.GetItemString(llFindRow,'user_field3') <> '' Then
//			lsOutString += String(idsRODetail.GetItemString(llFindRow,'user_field3')) + lsDelimitChar
//		Else
//			lsOutString += lsDelimitChar
//		End If		
//	
//		//Detail User Field4	C(50)	No	N/A	User Field
//		If llFindRow > 0 AND  idsRODetail.GetItemString(llFindRow,'user_field4') <> '' Then
//			lsOutString += String(idsRODetail.GetItemString(llFindRow,'user_field4')) + lsDelimitChar
//		Else
//			lsOutString += lsDelimitChar
//		End If	
//		
//		//Detail User Field5	C(50)	No	N/A	User Field
//		If llFindRow > 0 AND  idsRODetail.GetItemString(llFindRow,'user_field5') <> '' Then
//			lsOutString += String(idsRODetail.GetItemString(llFindRow,'user_field5')) + lsDelimitChar
//		Else
//			lsOutString += lsDelimitChar
//		End If		
//	
//		//Detail User Field6	C(50)	No	N/A	User Field
//
//		If llFindRow > 0 AND  idsRODetail.GetItemString(llFindRow,'user_field6') <> '' Then
//			lsOutString += String(idsRODetail.GetItemString(llFindRow,'user_field6')) + lsDelimitChar
//		Else
//			lsOutString += lsDelimitChar
//		End If		
//		
//		//Master User Field1	C(10)	No	N/A	User Field
//		If idsROMain.GetItemString(1,'user_field1') <> '' Then
//			lsOutString += String(idsROMain.GetItemString(1,'user_field1')) + lsDelimitChar
//		Else
//			lsOutString += lsDelimitChar
//		End If	
//	
//		//Master User Field2	C(10)	No	N/A	User Field
//		If idsROMain.GetItemString(1,'user_field2') <> '' Then
//			lsOutString += String(idsROMain.GetItemString(1,'user_field2')) + lsDelimitChar
//		Else
//			lsOutString += lsDelimitChar
//		End If	
//
//		//Master User Field3	C(10)	No	N/A	User Field
//		If idsROMain.GetItemString(1,'user_field3') <> '' Then
//			lsOutString += String(idsROMain.GetItemString(1,'user_field3')) + lsDelimitChar
//		Else
//			lsOutString += lsDelimitChar
//		End If	
//		
//		//Master User Field4	C(20)	No	N/A	User Field
//		If idsROMain.GetItemString(1,'user_field4') <> '' Then
//			lsOutString += String(idsROMain.GetItemString(1,'user_field4')) + lsDelimitChar
//		Else
//			lsOutString += lsDelimitChar
//		End If	
//	
//		//Master User Field5	C(20)	No	N/A	User Field
//		If idsROMain.GetItemString(1,'user_field5') <> '' Then
//			lsOutString += String(idsROMain.GetItemString(1,'user_field5')) + lsDelimitChar
//		Else
//			lsOutString += lsDelimitChar
//		End If		
//	
//		//Master User Field6	C(20)	No	N/A	User Field
//		If idsROMain.GetItemString(1,'user_field6') <> '' Then
//			lsOutString += String(idsROMain.GetItemString(1,'user_field6')) + lsDelimitChar
//		Else
//			lsOutString += lsDelimitChar
//		End If	
//	
//		//Master User Field7	C(30)	No	N/A	User Field
//		If idsROMain.GetItemString(1,'user_field7') <> '' Then
//			lsOutString += String(idsROMain.GetItemString(1,'user_field7')) + lsDelimitChar
//		Else
//			lsOutString += lsDelimitChar
//		End If	
//	
//		//Master User Field8	C(30)	No	N/A	User Field
//		If idsROMain.GetItemString(1,'user_field8') <> '' Then
//			lsOutString += String(idsROMain.GetItemString(1,'user_field8')) + lsDelimitChar
//		Else
//			lsOutString += lsDelimitChar
//		End If	
//	
//		//Master User Field9	C(255)	No	N/A	User Field
//		If idsROMain.GetItemString(1,'user_field9') <> '' Then
//			lsOutString += String(idsROMain.GetItemString(1,'user_field9')) + lsDelimitChar
//		Else
//			lsOutString += lsDelimitChar
//		End If	
//	
//		//Master User Field10	C(255)	No	N/A	User Field
//		If idsROMain.GetItemString(1,'user_field10') <> '' Then
//			lsOutString += String(idsROMain.GetItemString(1,'user_field10')) + lsDelimitChar
//		Else
//			lsOutString += lsDelimitChar
//		End If	
//	
//		//Master User Field11	C(255)	No	N/A	User Field
//		If idsROMain.GetItemString(1,'user_field11') <> '' Then
//			lsOutString += String(idsROMain.GetItemString(1,'user_field11')) + lsDelimitChar
//		Else
//			lsOutString += lsDelimitChar
//		End If	
//	
//		//Master User Field12	C(255)	No	N/A	User Field
//		If idsROMain.GetItemString(1,'user_field12') <> '' Then
//			lsOutString += String(idsROMain.GetItemString(1,'user_field12')) + lsDelimitChar
//		Else
//			lsOutString += lsDelimitChar
//		End If		
//	
//		//Master User Field13	C(255)	No	N/A	User Field
//		If idsROMain.GetItemString(1,'user_field13') <> '' Then
//			lsOutString += String(idsROMain.GetItemString(1,'user_field13')) + lsDelimitChar
//		Else
//			lsOutString += lsDelimitChar
//		End If		
//	
//		//Master User Field14	C(255)	No	N/A	User Field
//		If idsROMain.GetItemString(1,'user_field14') <> '' Then
//			lsOutString += String(idsROMain.GetItemString(1,'user_field14')) + lsDelimitChar
//		Else
//			lsOutString += lsDelimitChar
//		End If	
//	
//		//Master User Field15	C(255)	No	N/A	User Field
//		If idsROMain.GetItemString(1,'user_field15') <> '' Then
//			lsOutString += String(idsROMain.GetItemString(1,'user_field15')) + lsDelimitChar
//		Else
//			lsOutString += lsDelimitChar // TAM 2012/07 Remove comment.   Since new fields were add we need this delimeter
//		//	lsOutString += lsDelimitChar  // GXMOR 4/19/2013 Removed this line since extra line was put into output
//		End If	
//			
//		//Carrier
//		If idsROMain.GetItemString(1,'carrier') <> '' Then
//			lsOutString += String(idsROMain.GetItemString(1,'carrier')) + lsDelimitChar
//		Else
//			lsOutString += lsDelimitChar
//		End If	
//		
//		//Country Of Origin
//		If llFindRow > 0 AND  idsRODetail.GetItemString(llFindRow,'country_of_origin') <> '' Then
//			lsOutString += String(idsRODetail.GetItemString(llFindRow,'country_of_origin')) + lsDelimitChar
//		Else
//			lsOutString += lsDelimitChar
//		End If			
//			
//		//UnitOfMeasure
//		If llFindRow > 0 AND idsRODetail.GetItemString(llFindRow,'uom') <> '' Then
//			lsOutString += String(idsRODetail.GetItemString(llFindRow,'uom')) + lsDelimitChar
//		Else
//			lsOutString += lsDelimitChar
//		End If				
//		
//		//AWB #
//		If idsROMain.GetItemString(1,'AWB_BOL_No') <> '' Then
//			lsOutString += String(idsROMain.GetItemString(1,'AWB_BOL_No')) + lsDelimitChar
//		Else
//			lsOutString += lsDelimitChar
//		End If	
//				
//		//Grp - Get from Item_Master
//
//		Select grp INTO :lsGrp From Item_Master
//		Where sku = :lsSku and supp_code = :lsSuppCode and project_id = :lsproject
//		USING SQLCA;
//			
//		If IsNull(lsGrp) then lsGrp = ''
//		lsOutString += lsGrp  + lsDelimitChar
//
//
//		//Supplier Code
//		lsOutString += lsSuppCode + lsDelimitChar
//	
//		//Ship Ref
//		If idsROMain.GetItemString(1,'ship_ref') <> '' Then
//			lsOutString += String(idsROMain.GetItemString(1,'ship_ref'))  //+ lsDelimitChar
//		Else
//	//		lsOutString += lsDelimitChar
//		End If		
//		
//		
//		idsOut.SetItem(llNewRow,'Project_id', 'STBTH')
//		idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
//		idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
//		idsOut.SetItem(llNewRow,'batch_data', lsOutString)
//		lsFileName = 'GR' + String(ldBatchSeq,'00000000') + '.DAT'
//		idsOut.SetItem(llNewRow,'file_name', lsFileName)
//		
//		
//	next /*next Putaway record */
//
//Next /* Order */
//
///* GXMOR 4/19/2013 change project from 'STBTH' to gsProject.  GR files not finding project for file out. */
//If idsOut.RowCount() > 0 Then
//	gu_nvo_process_files.uf_process_flatfile_outbound_unicode(idsOut, 'Starbucks-TH')
//End If
//
////Update the ordersto reflect they have been transmitted
//For llOrderPos = 1 to llOrderCOunt
//	
//	/* GXMOR 4/19/2013 Changed 'do_no' to 'ro_no' below (invalid row/column error) */
//	//lsroNO = ldsOrders.GetITemString(llOrderPos,'ro_no') //26-Nov-2013 :Madhu -commented
//	lssuppinvoiceno =ldsOrders.GetItemString(llOrderPos,'supp_invoice_no') //26-Nov-2013 :Madhu- Added
//	
//	Update Receive_Master
//	Set file_transmit_ind = 'Y'
////	Where Ro_No =:lsroNo  //26-Nov-2013 :Madhu- commented
//	Where Supp_Invoice_No= :lssuppinvoiceno //26-Nov-2013 :Madhu- Added
//	and Project_ID = 'STBTH' and ord_status = 'C' and (file_transmit_ind is null or file_transmit_ind <> 'Y') //26-Nov-2013 :Madhu- Added
//	
//	Commit;
//Next
//

If Not isvalid(idsGROrders) Then
	idsGROrders = Create Datastore
	idsGROrders.Dataobject ='d_ro_gr_starbucks'
	idsGROrders.SetTransObject(SQLCA)
ENd If

idsOut.Reset()
idsGROrders.Retrieve()
llRowCount = idsGROrders.RowCount()

If llRowCount = 0 Then
	 lsLogOut = " No Inbound Orders retrieved for GR processing"
	FileWrite(gilogFileNo,lsLogOut)
   RETURN 0
else
	 lsLogOut = String(llROwcount) + "Retreived rows"
	FileWrite(gilogFileNo,lsLogOut)
End If

For llRowPos = 1 to llRowCOunt
	//SARUN2014APR30 : Exclusion of Marketing Orders which was missed in last enhancment
		If idsGROrders.GetItemString(llRowPos,'ord_type') =  'M' Then
			lsLogOut = "                  NO EDI generates for Starbucks Marketing Order Type for Inbound Order#" + lsRONO
			FileWrite(gilogFileNo,lsLogOut)
			Continue
		End If

		lsproject =idsGROrders.GetItemString(llRowPos,'Project_id')
		
		llNewRow = idsOut.insertRow(0)
		
		//Record_ID	C(2)	Yes	“GR”	Goods receipt confirmation identifier
		lsOutString = 'GR'  + lsDelimitChar /*rec type = goods receipt*/

		//Project ID	C(10)	Yes	N/A	Project identifier
		lsOutString += lsproject + lsDelimitChar
	
		//Warehouse	C(10)	Yes	N/A	Receiving Warehouse
		lsOutString += upper(idsGROrders.getItemString(llRowPos, 'wh_code'))  + lsDelimitChar

		//Order Number	C(20)	Yes	N/A	Purchase order number
		lsOutString += idsGROrders.GetItemString(llRowPos,'supp_invoice_no') + lsDelimitChar

		//Inventory Type	C(1)	Yes	N/A	Item condition
		lsOutString += idsGROrders.GetItemString(llRowPos,'inventory_type') + lsDelimitChar
	
		//Receipt Date	Date	Yes	N/A	Receipt completion date
		lsOutString += String(idsGROrders.GetITemDateTime(llRowPos,'complete_date'),'yyyy-mm-dd') + lsDelimitChar
	
		//SKU	C(50	Yes	N/A	Material Number
		lsSku =  idsGROrders.GetItemString(llRowPos,'sku')
		lsSuppCode = idsGROrders.GetItemString(llRowPos,'supp_code')		
		lsOutString += idsGROrders.GetItemString(llRowPos,'sku') + lsDelimitChar
	
		//Quantity	N(15,5)	Yes	N/A	Received quantity
		lsOutString += string(idsGROrders.GetItemNumber(llRowPos,'quantity')) + lsDelimitChar	
	
		//Lot Number	C(50)	No	N/A	1st User Defined Inventory field
		If idsGROrders.GetItemString(llRowPos,'lot_no') <> '-' Then
			lsOutString += String(idsGROrders.GetItemString(llRowPos,'lot_no')) + lsDelimitChar
		Else
			lsOutString += lsDelimitChar
		End If	
	
		//PO NBR	C(50)	No	N/A	2nd User Defined Inventory field
		If idsGROrders.GetItemString(llRowPos,'po_no') <> '-' Then
			lsOutString += String(idsGROrders.GetItemString(llRowPos,'po_no')) + lsDelimitChar
		Else
			lsOutString += lsDelimitChar
		End If	
	
		//PO NBR 2	C(50)	No	N/A	3rd User Defined Inventory Field
		If idsGROrders.GetItemString(llRowPos,'po_no2') <> '-' Then
			lsOutString += String(idsGROrders.GetItemString(llRowPos,'po_no2')) + lsDelimitChar
		Else
			lsOutString += lsDelimitChar
		End If		
	
		//Serial Number	C(50)	No	N/A	Qty must be 1 if present

		If idsGROrders.GetItemString(llRowPos,'serial_no') <> '-' Then
			lsOutString += String(idsGROrders.GetItemString(llRowPos,'serial_no')) + lsDelimitChar
		Else
			lsOutString += lsDelimitChar
		End If	
	
		//Container ID	C(25)	No	N/A	

		If idsGROrders.GetItemString(llRowPos,'container_id') <> '-' Then
			lsOutString += String(idsGROrders.GetItemString(llRowPos,'container_id')) + lsDelimitChar
		Else
			lsOutString += lsDelimitChar
		End If		

		//MEA - 8/13 - Not sending due to GR grouping as per BoonHee.

		//Expiration Date	Date	No	N/A	
//		If Not IsNull(idsroputaway.GetItemDateTime(llRowPos,'expiration_date')) Then
//			lsOutString += String(idsroputaway.GetItemDateTime(llRowPos,'expiration_date'),'yyyy-mm-dd') + lsDelimitChar
//		Else
			lsOutString += lsDelimitChar
//		End If		
		
		//Line Item Number	N(6,0)	Yes	N/A	Item number of purchase order document
		lsOutString += String(idsGROrders.GetItemNumber(llRowPos,'line_item_no')) + lsDelimitChar
	
		//Customer  Line Item Number 	C(25)	No	N/A	Customer  Line Item Number
		llFindRow = idsGROrders.Find("sku='"+lsSku+"' and supp_code = '"+lsSuppCode+"' ", 1, idsGROrders.RowCount())
	
		If llFindRow > 0 AND idsGROrders.GetItemString(llFindRow,'user_line_item_no') <> '' Then
			lsOutString += String(idsGROrders.GetItemString(llFindRow,'user_line_item_no')) + lsDelimitChar
		Else
			lsOutString += lsDelimitChar
		End If	
	
		//Detail User Field1	C(50)	No	N/A	User Field
		If llFindRow > 0 AND idsGROrders.GetItemString(llFindRow,'DUF1') <> '' Then
			lsOutString += String(idsGROrders.GetItemString(llFindRow,'DUF1')) + lsDelimitChar
		Else
			lsOutString += lsDelimitChar
		End If		
		
		//Detail User Field2	C(50)	No	N/A	User Field
		If llFindRow > 0 AND  idsGROrders.GetItemString(llFindRow,'DUF2') <> '' Then
			lsOutString += String(idsGROrders.GetItemString(llFindRow,'DUF2')) + lsDelimitChar
		Else
			lsOutString += lsDelimitChar
		End If		
		
		//Detail User Field3	C(50)	No	N/A	User Field
		If llFindRow > 0 AND  idsGROrders.GetItemString(llFindRow,'DUF3') <> '' Then
			lsOutString += String(idsGROrders.GetItemString(llFindRow,'DUF3')) + lsDelimitChar
		Else
			lsOutString += lsDelimitChar
		End If		
	
		//Detail User Field4	C(50)	No	N/A	User Field
		If llFindRow > 0 AND  idsGROrders.GetItemString(llFindRow,'DUF4') <> '' Then
			lsOutString += String(idsGROrders.GetItemString(llFindRow,'DUF4')) + lsDelimitChar
		Else
			lsOutString += lsDelimitChar
		End If	
		
		//Detail User Field5	C(50)	No	N/A	User Field
		If llFindRow > 0 AND  idsGROrders.GetItemString(llFindRow,'DUF5') <> '' Then
			lsOutString += String(idsGROrders.GetItemString(llFindRow,'DUF5')) + lsDelimitChar
		Else
			lsOutString += lsDelimitChar
		End If		
	
		//Detail User Field6	C(50)	No	N/A	User Field

		If llFindRow > 0 AND  idsGROrders.GetItemString(llFindRow,'DUF6') <> '' Then
			lsOutString += String(idsGROrders.GetItemString(llFindRow,'DUF6')) + lsDelimitChar
		Else
			lsOutString += lsDelimitChar
		End If		
		
		//Master User Field1	C(10)	No	N/A	User Field
		If idsGROrders.GetItemString(llRowPos,'user_field1') <> '' Then
			lsOutString += String(idsGROrders.GetItemString(llRowPos,'user_field1')) + lsDelimitChar
		Else
			lsOutString += lsDelimitChar
		End If	
	
		//Master User Field2	C(10)	No	N/A	User Field
		If idsGROrders.GetItemString(llRowPos,'user_field2') <> '' Then
			lsOutString += String(idsGROrders.GetItemString(llRowPos,'user_field2')) + lsDelimitChar
		Else
			lsOutString += lsDelimitChar
		End If	

		//Master User Field3	C(10)	No	N/A	User Field
		If idsGROrders.GetItemString(llRowPos,'user_field3') <> '' Then
			lsOutString += String(idsGROrders.GetItemString(llRowPos,'user_field3')) + lsDelimitChar
		Else
			lsOutString += lsDelimitChar
		End If	
		
		//Master User Field4	C(20)	No	N/A	User Field
		If idsGROrders.GetItemString(llRowPos,'user_field4') <> '' Then
			lsOutString += String(idsGROrders.GetItemString(llRowPos,'user_field4')) + lsDelimitChar
		Else
			lsOutString += lsDelimitChar
		End If	
	
		//Master User Field5	C(20)	No	N/A	User Field
		If idsGROrders.GetItemString(llRowPos,'user_field5') <> '' Then
			lsOutString += String(idsGROrders.GetItemString(llRowPos,'user_field5')) + lsDelimitChar
		Else
			lsOutString += lsDelimitChar
		End If		
	
		//Master User Field6	C(20)	No	N/A	User Field
		If idsGROrders.GetItemString(llRowPos,'user_field6') <> '' Then
			lsOutString += String(idsGROrders.GetItemString(llRowPos,'user_field6')) + lsDelimitChar
		Else
			lsOutString += lsDelimitChar
		End If	
	
		//Master User Field7	C(30)	No	N/A	User Field
		If idsGROrders.GetItemString(llRowPos,'user_field7') <> '' Then
			lsOutString += String(idsGROrders.GetItemString(llRowPos,'user_field7')) + lsDelimitChar
		Else
			lsOutString += lsDelimitChar
		End If	
	
		//Master User Field8	C(30)	No	N/A	User Field
		If idsGROrders.GetItemString(llRowPos,'user_field8') <> '' Then
			lsOutString += String(idsGROrders.GetItemString(llRowPos,'user_field8')) + lsDelimitChar
		Else
			lsOutString += lsDelimitChar
		End If	
	
		//Master User Field9	C(255)	No	N/A	User Field
		If idsGROrders.GetItemString(llRowPos,'user_field9') <> '' Then
			lsOutString += String(idsGROrders.GetItemString(llRowPos,'user_field9')) + lsDelimitChar
		Else
			lsOutString += lsDelimitChar
		End If	
	
		//Master User Field10	C(255)	No	N/A	User Field
		If idsGROrders.GetItemString(llRowPos,'user_field10') <> '' Then
			lsOutString += String(idsGROrders.GetItemString(llRowPos,'user_field10')) + lsDelimitChar
		Else
			lsOutString += lsDelimitChar
		End If	
	
		//Master User Field11	C(255)	No	N/A	User Field
		If idsGROrders.GetItemString(llRowPos,'user_field11') <> '' Then
			lsOutString += String(idsGROrders.GetItemString(llRowPos,'user_field11')) + lsDelimitChar
		Else
			lsOutString += lsDelimitChar
		End If	
	
		//Master User Field12	C(255)	No	N/A	User Field
		If idsGROrders.GetItemString(llRowPos,'user_field12') <> '' Then
			lsOutString += String(idsGROrders.GetItemString(llRowPos,'user_field12')) + lsDelimitChar
		Else
			lsOutString += lsDelimitChar
		End If		
	
		//Master User Field13	C(255)	No	N/A	User Field
		If idsGROrders.GetItemString(llRowPos,'user_field13') <> '' Then
			lsOutString += String(idsGROrders.GetItemString(llRowPos,'user_field13')) + lsDelimitChar
		Else
			lsOutString += lsDelimitChar
		End If		
	
		//Master User Field14	C(255)	No	N/A	User Field
		If idsGROrders.GetItemString(llRowPos,'user_field14') <> '' Then
			lsOutString += String(idsGROrders.GetItemString(llRowPos,'user_field14')) + lsDelimitChar
		Else
			lsOutString += lsDelimitChar
		End If	
	
		//Master User Field15	C(255)	No	N/A	User Field
		If idsGROrders.GetItemString(llRowPos,'user_field15') <> '' Then
			lsOutString += String(idsGROrders.GetItemString(llRowPos,'user_field15')) + lsDelimitChar
		Else
			lsOutString += lsDelimitChar // TAM 2012/07 Remove comment.   Since new fields were add we need this delimeter
		//	lsOutString += lsDelimitChar  // GXMOR 4/19/2013 Removed this line since extra line was put into output
		End If	
			
		//Carrier
		If idsGROrders.GetItemString(llRowPos,'carrier') <> '' Then
			lsOutString += String(idsGROrders.GetItemString(llRowPos,'carrier')) + lsDelimitChar
		Else
			lsOutString += lsDelimitChar
		End If	
		
		//Country Of Origin
		If llFindRow > 0 AND  idsGROrders.GetItemString(llFindRow,'country_of_origin') <> '' Then
			lsOutString += String(idsGROrders.GetItemString(llFindRow,'country_of_origin')) + lsDelimitChar
		Else
			lsOutString += lsDelimitChar
		End If			
			
		//UnitOfMeasure
		If llFindRow > 0 AND idsGROrders.GetItemString(llFindRow,'uom') <> '' Then
			lsOutString += String(idsGROrders.GetItemString(llFindRow,'uom')) + lsDelimitChar
		Else
			lsOutString += lsDelimitChar
		End If				
		
		//AWB #
		If idsGROrders.GetItemString(llRowPos,'AWB_BOL_No') <> '' Then
			lsOutString += String(idsGROrders.GetItemString(llRowPos,'AWB_BOL_No')) + lsDelimitChar
		Else
			lsOutString += lsDelimitChar
		End If	
				
		//Grp - Get from Item_Master

		Select grp INTO :lsGrp From Item_Master
		Where sku = :lsSku and supp_code = :lsSuppCode and project_id = :lsproject
		USING SQLCA;
			
		If IsNull(lsGrp) then lsGrp = ''
		lsOutString += lsGrp  + lsDelimitChar


		//Supplier Code
		lsOutString += lsSuppCode + lsDelimitChar
	
		//Ship Ref
		If idsGROrders.GetItemString(llRowPos,'ship_ref') <> '' Then
			lsOutString += String(idsGROrders.GetItemString(llRowPos,'ship_ref'))  //+ lsDelimitChar
		Else
	//		lsOutString += lsDelimitChar
		End If		
		
		
		idsOut.SetItem(llNewRow,'Project_id', 'STBTH')
		idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
		idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
		idsOut.SetItem(llNewRow,'batch_data', lsOutString)
		lsFileName = 'GR' + String(ldBatchSeq,'00000000') + '.DAT'
		idsOut.SetItem(llNewRow,'file_name', lsFileName)
		
				
	next /*next Putaway record */
	
	lsLogOut = " GR file : " + lsFileName + "is generated for STBTH"
	FileWrite(gilogFileNo,lsLogOut)

/* GXMOR 4/19/2013 change project from 'STBTH' to gsProject.  GR files not finding project for file out. */
If idsOut.RowCount() > 0 Then
	gu_nvo_process_files.uf_process_flatfile_outbound_unicode(idsOut, 'Starbucks-TH')
End If

//Update the ordersto reflect they have been transmitted
For llOrderPos = 1 to llRowCOunt
	
	/* GXMOR 4/19/2013 Changed 'do_no' to 'ro_no' below (invalid row/column error) */
	lssuppinvoiceno =idsGROrders.GetItemString(llOrderPos,'supp_invoice_no')
	
	IF (lsprevsuppinvoiceno <> lssuppinvoiceno) THEN
		Update Receive_Master
		Set file_transmit_ind = 'Y'
		Where Supp_Invoice_No= :lssuppinvoiceno
		and Project_ID = 'STBTH' and ord_status = 'C' and (file_transmit_ind is null or file_transmit_ind <> 'Y')
	Commit;
	END IF

	lsprevsuppinvoiceno =lssuppinvoiceno
Next

//04-Dec-2013 :Madhu -Added code to generate GR file on grouping by Supp_Invoice_No,Line_Item_No -END

//SARUN04APR42014 : Added Email for Successful Generation of GR/GI on request of GI/GR

select Email_String into :ls_email from Activity_Schedule where Project_Id = 'stbth'  and Activity_Id = 'STBTH-GI';
gu_nvo_process_files.uf_send_email(		lsProject,ls_email , "GR has been generated successfully on " + string(Today(), 'YYYY/MM/DD HH:MM') + ' GMT',"        Filename: " + lsFileName  , "")



Return 0
end function

public function integer uf_gi ();//Create a GI file for ALL orders confirmed today (or since last time run)
// THis is triggered from the schedular on a timed basis and not triggered from the transaction file when order confirmed


Long			llRowPos, llRowCount, llFindRow,	llNewRow, llLineItemNo,	llBatchSeq, llOrderPos, llOrderCount
				
String		lsOutString,	lsMessage, 	 lsLogOut, lsFileName, lsDONO, lsProject, lsaltsku  //16-Dec-2013 :Santosh - Added 'lsaltsku'
String  	lsFreight_Cost, lsTemp, lssku, lsSuppCode, lsLineItemNo, lsOrdStatus,  lsWHCode,ls_email
String   	sql_Syntax, errors
DataStore	ldsOrders
DEcimal		ldBatchSeq, ldNetWeight, ldGrossWeight, ldCBM
Integer		liRC
Boolean		lbFound

Long llDetailFind, llPackFind

lsLogOut = "    - Processing Daily GI file for Starbucks-TH "
gu_nvo_process_files.uf_write_log(lsLogOut)
FileWrite(gilogFileNo,lsLogOut)
	

	
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

If Not isvalid(idsDoDetail) Then
	idsDoDetail = Create Datastore
	idsDoDetail.Dataobject = 'd_do_Detail'
	idsDoDetail.SetTransObject(SQLCA)
End If

If Not isvalid(idsDoPick) Then
	idsDoPick = Create Datastore
	//idsDoPick.Dataobject = 'd_do_Picking' //12-Jan-2016 :Madhu- commented for GI Rolled up
	idsDoPick.Dataobject = 'd_do_Picking_starbucks_th' //12-Jan-2016 :Madhu- Added for GI Rolled up
	idsDoPick.SetTransObject(SQLCA)
End If

/* GXMOR 4/19/2013 Add to thrwart a null object reference */
If Not isvalid(idsDoPack) Then
	idsDoPack = Create Datastore
	idsDoPack.Dataobject = 'd_do_Packing'
	idsDoPack.SetTransObject(SQLCA)
End If

//Retrieve a list of all elligible Orders to process.
ldsOrders = Create Datastore
sql_syntax = "SELECT do_no from delivery_Master " 
// TAM  -  2013/10/2 - Check the Order Date to see if we should should wait to send the GI
//sql_syntax += " Where Project_ID = 'STBTH' and ord_status in ('C','D') and (file_transmit_ind is null or file_transmit_ind <> 'Y')"
sql_syntax += " Where Project_ID = 'STBTH' and ord_status in ('C','D') and (file_transmit_ind is null or file_transmit_ind <> 'Y') and  (ord_date <= DATEADD(day,1,getdate())) "

ldsOrders.Create(SQLCA.SyntaxFromSQL(sql_syntax,"", ERRORS))
IF Len(ERRORS) > 0 THEN
   lsLogOut = "        *** Unable to create datastore for Starbucks GI~r~r" + Errors
	FileWrite(gilogFileNo,lsLogOut)
   RETURN - 1
END IF

ldsOrders.SetTransObject(SQLCA)
llOrderCOunt = ldsOrders.Retrieve()

If llOrderCount = 0 Then
	lsLogOut = "       No orders retrieved for processing GI for Starbucks-TH "
	FileWrite(gilogFileNo,lsLogOut)
	Return 0
End If


//Get the Next Batch Seq Nbr - Used for all writing to generic tables
ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no('stbth','Good_Issue_File','Good_Issue')
If ldBatchSeq <= 0 Then
	lsLogOut = "        *** Unable to retrieve the next available sequence number~rfor Goods Issue Confirmation.~r~rConfirmation will not be sent to Starbucks!'"
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

idsOut.Reset()

//Loop through each order and add to current file

For llOrderPos = 1 to llOrderCOunt
	
	lsDoNO = ldsOrders.GetITemString(llOrderPos,'do_no')

	lsLogOut = "        Creating GI For DONO: " + lsDONO
	FileWrite(gilogFileNo,lsLogOut)

	//Retreive Delivery Master and Detail  records for this DONO
	If idsDOMain.Retrieve(lsDoNo) <> 1 Then
		lsLogOut = "        *** Unable to retreive Delivery Order Header For DONO: " + lsDONO
		FileWrite(gilogFileNo,lsLogOut)
		Return -1
	End If

	//6/13: MEA - No good confirmation file to be generated Requested by Tan BoonHee.
	If idsDOMain.GetItemString(1,'ord_type') =  'M' Then
		lsLogOut = "                  NO EDI generates for Starbucks Marketing Order Type for Outbound Order#" + lsDONO
		FileWrite(gilogFileNo,lsLogOut)
		Continue
	End If

	idsDoDetail.Retrieve(lsDoNo)
	idsDoPick.Retrieve(lsDoNo)
	idsDoPack.Retrieve(lsDoNo)

	//Write the rows to the generic output table - delimited by lsDelimitChar

	llRowCount = idsDoPick.RowCount()

	For llRowPos = 1 to llRowCOunt

		llNewRow = idsOut.insertRow(0)

		lsSku = idsdoPick.GetITEmString(llRowPos,'sku')
		lsSuppCode =  Upper(idsdoPick.GetITEmString(llRowPos,'supp_code'))
		lsLineItemNo = String(idsdoPick.GetITemNumber(llRowPos, 'Line_item_No'))
		lsOrdStatus = idsDoMain.GetItemString(1,'Ord_Status') 
		lsProject = idsDoMain.GetItemString(1,'Project_ID') 

	// 16-Dec-2013: Santosh- To find an alternate sku - START
	//	llDetailFind = idsDoDetail.Find("sku='"+lsSku+ "' and line_item_no = " + string(lsLineItemNo), 1, idsDoDetail.RowCount()) //commented
	//	 llDetailFind = idsDoDetail.Find( " Upper(supp_code) = '"+lsSuppCode + "' and line_item_no = " + string(lsLineItemNo), 1, idsDoDetail.RowCount())
	//04- march-2014 - Santosh- To find the sku for diffrent suppliers from picking to detail
	llDetailFind = idsDoDetail.Find( " line_item_no = " + string(lsLineItemNo), 1, idsDoDetail.RowCount())
	

		If llDetailFind > 0 then
			lsaltsku = idsDoDetail.object.sku[llDetailFind]
		End if 
		
		If ( lsSku = lsaltsku ) then
			llDetailFind = idsDoDetail.Find("sku='"+lsSku+ "' and line_item_no = " + string(lsLineItemNo), 1, idsDoDetail.RowCount())
		else
			llDetailFind = idsDoDetail.Find("sku='"+lsaltsku+ "' and line_item_no = " + string(lsLineItemNo), 1, idsDoDetail.RowCount())
		End if
// 16-Dec-2013: Santosh- To find an alternate sku - END


		//Can't Find Detail
		IF llDetailFind <= 0 then 
			continue
		End If

		llPackFind = idsDoPack.Find("sku='"+lsSku+"' and Upper(supp_code) = '"+lsSuppCode+"' and line_item_no=" + string(lsLineItemNo), 1, idsDoPack.RowCount())

		//Field Name	Type	Req.	Default	Description
		lsOutString = "GI" + lsDelimitChar	
		
		//Project ID	C(10)	Yes	N/A	Project identifier
		lsOutString +=  lsproject + lsDelimitChar
	
		//Warehouse	C(10)	Yes		Shipping Warehouse
		lsOutString += idsDoMain.GetItemString(1,'wh_code') + lsDelimitChar
	
		//Delivery Number	C(10)	Yes	N/A	Delivery Order Number
		lsOutString += Left(idsDoMain.GetItemString(1,'Invoice_no'), 10) + lsDelimitChar	

	
		//Delivery Line Item	N(6,0)	Yes	N/A	Delivery order item line number
		lsOutString += String(idsdoPick.GetITemNumber(llRowPos, 'Line_item_No')) + lsDelimitChar
	
		//SKU	C(50)	Yes	N/A	Material number
		lsOutString += lsSku  + lsDelimitChar	
	
		//Quantity	N(15,5)	Yes	N/A	Actual shipped quantity
		lsOutString += String( idsdoPick.GetITemNumber(llRowPos,'quantity')) + lsDelimitChar
	
		//Inventory Type	C(1)	Yes	N/A	Item condition
		lsOutString += String( idsdoPick.GetITemString(llRowPos,'Inventory_Type')) + lsDelimitChar
	
		//Lot Number	C(50)	No	N/A	1st User Defined Inventory field
		lsTemp = idsdoPick.GetITemString(llRowPos,'Lot_No')
		If IsNull(lsTemp) then lsTemp = ''
		lsOutString += lsTemp+ lsDelimitChar	
	
		//PO NBR	C(50)	No	N/A	2nd User Defined Inventory field
		lsTemp = idsdoPick.GetITemString(llRowPos,'PO_No')
		If IsNull(lsTemp) then lsTemp = ''
	
		If  lsTemp <> '-' Then
			lsOutString += lsTemp + lsDelimitChar
		Else
			lsOutString += lsDelimitChar
		End If		
	
		//PO NBR 2	C(50)	No	N/A	3rd User Defined Inventory Field
		lsTemp = idsdoPick.GetITemString(llRowPos,'PO_No2')
		If IsNull(lsTemp) then lsTemp = ''
	
		If  lsTemp <> '-' Then
			lsOutString += lsTemp + lsDelimitChar
		Else
			lsOutString += lsDelimitChar
		End If		
	
		//Serial Number	C(50)	No	N/A	Qty must be 1 if present
		lsTemp = idsdoPick.GetITemString(llRowPos,'Serial_No')
		If IsNull(lsTemp) then lsTemp = ''
	
		If  lsTemp <> '-' Then
			lsOutString += lsTemp + lsDelimitChar
		Else
			lsOutString += lsDelimitChar
		End If	
	
		//Container ID	C(25)	No	N/A	
		lsTemp = idsdoPick.GetITemString(llRowPos,'Container_ID')
	
		If IsNull(lsTemp) then lsTemp = ''

		If  lsTemp <> '-' Then
			lsOutString += lsTemp + lsDelimitChar
		Else
			lsOutString += lsDelimitChar
		End If	
	
		//Expiration Date	Date	No	N/A	
		//lsOutString += String( idsdoPick.GetITemDateTime(llRowPos,'Expiration_Date'),'yyyy-mm-dd') + lsDelimitChar		//12-Jan-2016 :Madhu- commented for GI Rolled up
		lsOutString += lsDelimitChar //12-Jan-2016 :Madhu- Added for GI Rolled up -No Expiration Date field value

		//Price	N(12,4)	No	N/A	
		lsTemp = String(idsdoPick.GetItemDecimal(llRowPos, "Price"))
	
		If IsNull(lsTemp) then lsTemp = ''
		lsOutString += lsTemp+ lsDelimitChar	
		
		//Ship Date	Date	No	N/A	Actual Ship date
		lsTemp = String( idsDoMain.GetItemDateTime(1,'complete_date'),'yyyy-mm-dd') 
		If IsNull(lsTemp) then lsTemp = ''
	
		lsOutString += lsTemp+ lsDelimitChar

	
		// Package Count	N(5,0)	No	N/A	Total no. of package in delivery
		lsTemp = String(0)  	 
		If IsNull(lsTemp) then lsTemp = ''
	
		lsOutString += lsTemp+ lsDelimitChar
		
		//Ship Tracking Number	C(25)	No	N/A	
		If idsDoMain.GetItemString(1,'awb_bol_no') <> '' Then
			lsOutString += String(idsDoMain.GetItemString(1,'awb_bol_no')) + lsDelimitChar
		Else
			lsOutString += lsDelimitChar
		End If				
	
		//Carrier	C (20)	No	N/A	Input by user
		If idsDoMain.GetItemString(1,'Carrier') <> '' Then
			lsOutString += String(idsDoMain.GetItemString(1,'Carrier')) + lsDelimitChar
		Else
			lsOutString += lsDelimitChar
		End If				
		
		//Freight Cost	N(10,3)	No	N/A	
		lsFreight_Cost = String(idsDoMain.GetItemDecimal(1,'Freight_Cost'))

		IF IsNull(lsFreight_Cost) then lsFreight_Cost = ""
		lsOutString += lsFreight_Cost + lsDelimitChar
		
		//Freight Terms	C(20)	No	N/A	
		lsTemp = Trim(idsDoMain.GetItemString(1,'Freight_Terms'))
		If IsNull(lsTemp) then lsTemp = ''
		If lsTemp <> '' Then
			lsOutString += String(lsTemp) + lsDelimitChar
		Else
			lsOutString += lsDelimitChar
		End If				
	
		// Total Weight	N(12,2)	No	N/A	- Send as 0
		lsTemp = "0"
		lsOutString += lsTemp+ lsDelimitChar		

		//Transportation Mode	C(10)	No	N/A	
		If idsDoMain.GetItemString(1,'transport_mode') <> '' Then
			lsOutString += String(idsDoMain.GetItemString(1,'transport_mode')) + lsDelimitChar
		Else
			lsOutString += lsDelimitChar
		End If			
	
		//Delivery Date	Date	No	N/A	
		lsTemp =  String( idsDoMain.GetItemDateTime(1,'complete_date'),'yyyy-mm-dd') 
		If IsNull(lsTemp) then lsTemp = ''
	
		lsOutString += lsTemp+ lsDelimitChar	

//		MEA - 8/13 - Commented out since after using SIMS don't need anymore.

//		//	Reason: We need to send the item_master.User_7 (e.g for item TL000022, user_7 is D-FR) to Starbucks in the GI file. 
//		//Currently GI file is created every night around 4am, when all confirmed orders are pulled from SIMS. Currently the Outbound Order_detail.User_Field1 is populated during manual import utility using CSV file, where Order_detail.User_Field1 is one of the columns. So this field is populated by the person uploading.
//		
//		//The change request: We want the Order_detail.User_Field1 to be updated with item_master.User_7 , anytime before GI file is created. One option is during order confirm. Another option is when orders starts picking.. any other option?
//
////		string ls_IMUF7
//
//
//		Select item_master.User_Field7 INTO :ls_IMUF7
//			From item_master 
//			Where sku = :lsSku and
//					 supp_code = :lsSuppCode and
//					 project_id = :lsProject USING SQLCA;
//	
//		llLineItemNo = idsdoPick.GetITemNumber(llRowPos, 'Line_item_No')
//	
//		Update Delivery_Detail
//		 	Set User_Field1 = :ls_IMUF7
//			 Where do_no = :lsDoNO and
//					 sku = :lsSku and
//					 supp_code = :lsSuppCode and
//					 Line_item_No = :llLineItemNo USING SQLCA;
//
//
//		COMMIT;
	
		//Detail User Field1	C(20)	No	N/A	User Field
		If  idsdoDetail.GetItemString(llDetailFind,'user_field1') <> '' Then
			lsOutString += String(idsdoDetail.GetItemString(llDetailFind,'user_field1')) + lsDelimitChar
//			lsOutString += ls_IMUF7 + lsDelimitChar

		Else
			lsOutString += lsDelimitChar
		End If	
		
		
	
		//Detail User Field2	C(20)	No	N/A	User Field
		If idsdoDetail.GetItemString(llDetailFind,'user_field2') <> '' Then
			lsOutString += String(idsdoDetail.GetItemString(llDetailFind,'user_field2')) + lsDelimitChar
		Else
			lsOutString += lsDelimitChar
		End If		
	
		//Detail User Field3	C(30)	No	N/A	User Field
		If idsdoDetail.GetItemString(llDetailFind,'user_field3') <> '' Then
			lsOutString += String(idsdoDetail.GetItemString(llDetailFind,'user_field3')) + lsDelimitChar
		Else
			lsOutString += lsDelimitChar
		End If		
	
		//Detail User Field4	C(30)	No	N/A	User Field
		If idsdoDetail.GetItemString(llDetailFind,'user_field4') <> '' Then
			lsOutString += String(idsdoDetail.GetItemString(llDetailFind,'user_field4')) + lsDelimitChar
		Else
			lsOutString += lsDelimitChar
		End If		
	
		//Detail User Field5	C(30)	No	N/A	User Field
		If idsdoDetail.GetItemString(llDetailFind,'user_field5') <> '' Then
			lsOutString += String(idsdoDetail.GetItemString(llDetailFind,'user_field5')) + lsDelimitChar
		Else
			lsOutString += lsDelimitChar
		End If		
	
		//Detail User Field6	C(30)	No	N/A	User Field
		If idsdoDetail.GetItemString(llDetailFind,'user_field6') <> '' Then
			lsOutString += String(idsdoDetail.GetItemString(llDetailFind,'user_field6')) + lsDelimitChar
		Else
			lsOutString += lsDelimitChar
		End If			
	
		//Detail User Field7	C(30)	No	N/A	User Field
		If idsdoDetail.GetItemString(llDetailFind,'user_field7') <> '' Then
			lsOutString += String(idsdoDetail.GetItemString(llDetailFind,'user_field7')) + lsDelimitChar
		Else
			lsOutString += lsDelimitChar
		End If			
	
		//Detail User Field8	C(30)	No	N/A	User Field
		If idsdoDetail.GetItemString(llDetailFind,'user_field8') <> '' Then
			lsOutString += String(idsdoDetail.GetItemString(llDetailFind,'user_field8')) + lsDelimitChar
		Else
			lsOutString += lsDelimitChar
		End If			

	
		//Master User Field2	C(10)	No	N/A	User Field
		If idsDoMain.GetItemString(1,'user_field2') <> '' Then
			lsOutString += String(idsDoMain.GetItemString(1,'user_field2')) + lsDelimitChar
		Else
			lsOutString += lsDelimitChar
		End If		

		//Master User Field3	C(10)	No	N/A	User Field
		If idsDoMain.GetItemString(1,'user_field3') <> '' Then
			lsOutString += String(idsDoMain.GetItemString(1,'user_field3')) + lsDelimitChar
		Else
			lsOutString += lsDelimitChar
		End If	

		//Master User Field4	C(20)	No	N/A	User Field
		If idsDoMain.GetItemString(1,'user_field4') <> '' Then
			lsOutString += String(idsDoMain.GetItemString(1,'user_field4')) + lsDelimitChar
		Else
			lsOutString += lsDelimitChar
		End If	

		//Master User Field5	C(20)	No	N/A	User Field
		If idsDoMain.GetItemString(1,'user_field5') <> '' Then
			lsOutString += String(idsDoMain.GetItemString(1,'user_field5')) + lsDelimitChar
		Else
			lsOutString += lsDelimitChar
		End If	
		
		//Master User Field6	C(20)	No	N/A	User Field
		If idsDoMain.GetItemString(1,'user_field6') <> '' Then
			lsOutString += String(idsDoMain.GetItemString(1,'user_field6')) + lsDelimitChar
		Else
			lsOutString += lsDelimitChar
		End If	

		//Master User Field7	C(30)	No	N/A	User Field
		If idsDoMain.GetItemString(1,'user_field7') <> '' Then
			lsOutString += String(idsDoMain.GetItemString(1,'user_field7')) + lsDelimitChar
		Else
			lsOutString += lsDelimitChar
		End If	

		//Master User Field8	C(60)	No	N/A	User Field
		If idsDoMain.GetItemString(1,'user_field8') <> '' Then
			lsOutString += String(idsDoMain.GetItemString(1,'user_field8')) + lsDelimitChar
		Else
			lsOutString += lsDelimitChar
		End If	

		//Master User Field9	C(30)	No	N/A	User Field
		If idsDoMain.GetItemString(1,'user_field9') <> '' Then
			lsOutString += String(idsDoMain.GetItemString(1,'user_field9')) + lsDelimitChar
		Else
			lsOutString += lsDelimitChar
		End If		
	
		//Master User Field10	C(30)	No	N/A	User Field
		If idsDoMain.GetItemString(1,'user_field10') <> '' Then
			lsOutString += String(idsDoMain.GetItemString(1,'user_field10')) + lsDelimitChar
		Else
			lsOutString += lsDelimitChar
		End If		
	
		//Master User Field11	C(30)	No	N/A	User Field
		If idsDoMain.GetItemString(1,'user_field11') <> '' Then
			lsOutString += String(idsDoMain.GetItemString(1,'user_field11')) + lsDelimitChar
		Else
			lsOutString += lsDelimitChar
		End If		
	
		//Master User Field12	C(50)	No	N/A	User Field
		If idsDoMain.GetItemString(1,'user_field12') <> '' Then
			lsOutString += String(idsDoMain.GetItemString(1,'user_field12')) + lsDelimitChar
		Else
			lsOutString += lsDelimitChar
		End If		
	
		//Master User Field13	C(50)	No	N/A	User Field
		If idsDoMain.GetItemString(1,'user_field13') <> '' Then
			lsOutString += String(idsDoMain.GetItemString(1,'user_field13')) + lsDelimitChar
		Else
			lsOutString += lsDelimitChar
		End If	
	
		//Master User Field14	C(50)	No	N/A	User Field
		If idsDoMain.GetItemString(1,'user_field14') <> '' Then
			lsOutString += String(idsDoMain.GetItemString(1,'user_field14')) + lsDelimitChar
		Else
			lsOutString += lsDelimitChar
		End If		
	
		//Master User Field15	C(50)	No	N/A	User Field
		If idsDoMain.GetItemString(1,'user_field15') <> '' Then
			lsOutString += String(idsDoMain.GetItemString(1,'user_field15')) + lsDelimitChar
		Else
			lsOutString += lsDelimitChar
		End If		
	
		//Master User Field16	C(100)	No	N/A	User Field
		If idsDoMain.GetItemString(1,'user_field16') <> '' Then
			lsOutString += String(idsDoMain.GetItemString(1,'user_field16')) + lsDelimitChar
		Else
			lsOutString += lsDelimitChar
		End If		
	
		//Master User Field17	C(100)	No	N/A	User Field
		If idsDoMain.GetItemString(1,'user_field17') <> '' Then
			lsOutString += String(idsDoMain.GetItemString(1,'user_field17')) + lsDelimitChar
		Else
			lsOutString += lsDelimitChar
		End If		
	
		//Master User Field18	C(100)	No	N/A	User Field
		If idsDoMain.GetItemString(1,'user_field18') <> '' Then
			lsOutString += String(idsDoMain.GetItemString(1,'user_field18')) + lsDelimitChar
		Else
			lsOutString +=lsDelimitChar
		End If		
	
		//CustomerCode	
		If idsDoMain.GetItemString(1,'cust_code') <> '' Then
			lsOutString += String(idsDoMain.GetItemString(1,'cust_code')) + lsDelimitChar
		Else
			lsOutString +=lsDelimitChar
		End If	
	
		//Ship To Name
		If idsDoMain.GetItemString(1,'cust_name') <> '' Then
			lsOutString += String(idsDoMain.GetItemString(1,'cust_name')) + lsDelimitChar
		Else
			lsOutString +=lsDelimitChar
		End If		
	
		//Ship Address 1	
		If idsDoMain.GetItemString(1,'address_1') <> '' Then
			lsOutString += String(idsDoMain.GetItemString(1,'address_1')) + lsDelimitChar
		Else
			lsOutString +=lsDelimitChar
		End If		
	
		//Ship Address 2	
		If idsDoMain.GetItemString(1,'address_2') <> '' Then
			lsOutString += String(idsDoMain.GetItemString(1,'address_2')) + lsDelimitChar
		Else
			lsOutString +=lsDelimitChar
		End If		

		//Ship Address 3	
		If idsDoMain.GetItemString(1,'address_3') <> '' Then
			lsOutString += String(idsDoMain.GetItemString(1,'address_3')) + lsDelimitChar
		Else
			lsOutString +=lsDelimitChar
		End If		
	
		//Ship Address 4	
		If idsDoMain.GetItemString(1,'address_4') <> '' Then
			lsOutString += String(idsDoMain.GetItemString(1,'address_4')) + lsDelimitChar
		Else
			lsOutString +=lsDelimitChar
		End If		
	
		//Ship City	
		If idsDoMain.GetItemString(1,'city') <> '' Then
			lsOutString += String(idsDoMain.GetItemString(1,'city')) + lsDelimitChar
		Else
			lsOutString +=lsDelimitChar
		End If		
	
		//Ship State	
		If idsDoMain.GetItemString(1,'state') <> '' Then
			lsOutString += String(idsDoMain.GetItemString(1,'state')) + lsDelimitChar
		Else
			lsOutString +=lsDelimitChar
		End If	
	
		//Ship Postal Code	
		If idsDoMain.GetItemString(1,'zip') <> '' Then
			lsOutString += String(idsDoMain.GetItemString(1,'zip')) + lsDelimitChar
		Else
			lsOutString +=lsDelimitChar
		End If		
	
		//Ship Country
		If idsDoMain.GetItemString(1,'country') <> '' Then
			lsOutString += String(idsDoMain.GetItemString(1,'country')) + lsDelimitChar
		Else
			lsOutString +=lsDelimitChar
		End If	
	
		//TODO - may need to populate UnitOfMeasure (weight)
		lsOutString += lsDelimitChar

		//UnitOfMeasure (quantity)	
		If idsdoDetail.GetItemString(llDetailFind,'uom') <> '' Then
			lsOutString += String(idsdoDetail.GetItemString(llDetailFind,'uom')) + lsDelimitChar
		Else
			lsOutString += lsDelimitChar
		End If

		//CountryOfOrigin	
	 	lsTemp = idsdoPick.GetITemString(llRowPos,'country_of_origin')
		If IsNull(lsTemp) then lsTemp = ''
		lsOutString += lsTemp+ lsDelimitChar	

		//Master User Field19	 
		If idsDoMain.GetItemString(1,'user_field19') <> '' Then
			lsOutString += String(idsDoMain.GetItemString(1,'user_field19')) + lsDelimitChar
		Else
			lsOutString +=lsDelimitChar
		End If		
			
		//Master User Field20	
		If idsDoMain.GetItemString(1,'user_field20') <> '' Then
			lsOutString += String(idsDoMain.GetItemString(1,'user_field20')) + lsDelimitChar
		Else
			lsOutString +=lsDelimitChar
		End If	

		//Master User Field21	
		If idsDoMain.GetItemString(1,'user_field21') <> '' Then
			lsOutString += String(idsDoMain.GetItemString(1,'user_field21')) + lsDelimitChar
		Else
			lsOutString +=lsDelimitChar
		End If				
		
		//Master User User Field22	
		If idsDoMain.GetItemString(1,'user_field22') <> '' Then
			lsOutString += String(idsDoMain.GetItemString(1,'user_field22')) + lsDelimitChar
		Else
			lsOutString +=lsDelimitChar
		End If		
	
		//ScheduleDate	Date	No	N/A	-- GXMOR 4/22/2013 * change date format to ddmmyyyy and populate lsOutString
		//lsTemp =  String( idsDoMain.GetItemDateTime(1,'schedule_date'),'yyyy-mm-dd') 
		lsTemp =  String( idsDoMain.GetItemDateTime(1,'schedule_date'),'ddmmyyyy') 
		If IsNull(lsTemp) then lsTemp = ''
		
		lsOutString += lsTemp
		
		idsOut.SetItem(llNewRow,'Project_id', 'STBTH')
		idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
		idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
		idsOut.SetItem(llNewRow,'batch_data', lsOutString)
		lsFileName = 'GI' + String(ldBatchSeq,'000000') + '.dat'
		idsOut.SetItem(llNewRow,'file_name', lsFileName)
	
//		lsLogOut = "        Filename: " + lsFileName + " : " + string (ldBatchSeq) 
//		FileWrite(gilogFileNo,lsLogOut)



	next /*next Delivery Detail record */


Next /* Order */

		lsLogOut = "        Filename: " + lsFileName + " : " + string (ldBatchSeq) 
		FileWrite(gilogFileNo,lsLogOut)


//Write the Outbound File - no need to save and re-retrieve - just use the currently loaded DW

//gu_nvo_process_files

uf_process_flatfile_outbound_unicode(idsOut,'Starbucks-TH')


//Update the ordersto reflect they have been transmitted
For llOrderPos = 1 to llOrderCOunt
	
	lsDoNO = ldsOrders.GetITemString(llOrderPos,'do_no')
	
	Update Delivery_Master
	Set file_transmit_ind = 'Y'
	Where do_no = :lsDONO
	
	Commit;
	
Next

//SARUN04APR42014 : Added Email for Successful Generation of GR/GI on request of GI/GR

select Email_String into :ls_email from Activity_Schedule where Project_Id = 'stbth'  and Activity_Id = 'STBTH-GI';
gu_nvo_process_files.uf_send_email(		lsProject,ls_email , "GI has been generated successfully on " + string(Today(), 'YYYY/MM/DD HH:MM') + ' GMT',"        Filename: " + lsFileName  , "")

Return 0
end function

public function integer uf_process_flatfile_outbound_unicode (ref datastore adw_output, string asproject);//Process outbound Flat files - if passed in a datawindow, we dont need to retrieve becuase the DW is still in memory
//													and not saved to DB



String	lsLogOut, lsProject, 	lsDirList, lsPathOut, lsFileOut,lsErrorPath, lsDefaultPath,	&
			lsData, lsOrigFileName,	lsNewFileName,	lsFileSequence, lsFileSequenceHold, lsFilePrefix, &
			lsFileSuffix, lsFileExtension, lsDestPath, lsDestCD, lsTmpFileName, lsFileExt
			
Long		llArrayPos,	&
			llDirPos	,	&
			llRowCount,	&
			llRowPos,	&
			llFileNo,	&
			llRC
			
//Jxlim 02/02/2013 Changed Integer to Long
//Integer	liFileNo,	&
//			liRC

Boolean	bRet

//Jxlim 02/02/2013 Sybase;FileWriteExEx is maintained for backward compatibility. Use the FileWriteExExEx function for new development.

//lsLogOut = ''
//FileWriteEx(giLogFileNo,lsLogOut)
//uf_write_Log(lsLogOut) /*display msg to screen*/
//lsLogOut = '- PROCESSING FUNCTION: Extract Outbound Flat Files'
//FileWriteEx(giLogFileNo,lsLogOut)
//uf_write_Log(lsLogOut) /*display msg to screen*/
//lsLogOut = ''
//FileWriteEx(giLogFileNo,lsLogOut)
//uf_write_Log(lsLogOut) /*display msg to screen*/
//
//lsLogOut = '   Project: ' + asProject 
//FileWriteEx(giLogFileNo,lsLogOut)
//uf_write_Log(lsLogOut) /*display msg to screen*/

lsProject = asProject

lsPathOut = ProfileString(gsinifile,lsProject,"flatfiledirout","") +'\'
	
llRowCount = adw_output.RowCount()
	
gu_nvo_process_files.uf_write_log('     ' + string(llRowCount) + ' Rows were retrieved for flatfile output...')

llFileNo = 0	
	
If llRowCount > 0 Then
	
	adw_Output.Sort() /* make sure we're sorted by batch seq so we only open an output file once */
		
	lsFileSequenceHold = ''
	
	//For each row, stream the data to the output file
	For llRowPos = 1 to llRowCount
		
		//If BatchSeq has changed, close current file and create a new one
		lsFileSequence = String(adw_output.GetItemNumber(llRowPos,'edi_batch_Seq_no')) /*sequence Number */
		
		If IsNull(lsFileSequence) then lsFileSequence = ""
		
		If lsFileSequence <> lsFileSequenceHold  or llRowPos = 1 Then
			
				//Close the existing file (if it's the first time, fileno will be 0)
				
				lsLogOut = "      llFileNO: " + string(llFileNo)
				FileWriteEx(gilogFileNo,lsLogOut)	
				gu_nvo_process_files.uf_write_Log(lsLogOut) /*display msg to screen*/				

				
				
				If llFileNo > 0 Then					
					FileClose(llFileNo) /*close the file*/					
					//Jxlim 02/13/2013 Remove .TMP extension when file is closed due to BatchSeq has changed
					//Jxlim 02/13/2013 Baseline - Copy to lsFileOut. Remove .TMP ext and, use original file extension
					lsFileExt = Right(lsFileOut, 4)
					If Upper(Trim(lsFileExt)) ='.TMP' Then
						lsTmpFileName = lsPathOut + lsFileOut		   //with .TMP ext	
						lsFileOut	 = left(lsFileOut	, len(lsFileOut) - 4)  //Remove .TMP	
						lsOrigFileName = lsPathOut + lsFileOut	//without .TMP extension aka keep the original file extension						
						
						//Jxlim 02/19/2013 If the original file exist then delete first; this happen when there is manual sweeper restart
						If FIleExists(lsOrigFileName) Then
							FileDelete(lsOrigFileName)
							lsLogOut = Space(10) + "***Unicode -File Sequence; Deleted existing File data successfully from: " + lsOrigFileName + " before moving file from .TMP to original extension."		
							FileWriteEx(giLogFileNo,lsLogOut)
							gu_nvo_process_files.uf_write_Log(lsLogOut)
						End if
						//Jxlim 02/03/2013 MoveFile() function does Rename to new file and delete old file similar to replace file.
						bret=MoveFile(lsTmpFileName, lsOrigFileName)
						//Jxlim 01/23/2012 write message on rename status
						If Bret Then
							lsLogOut = Space(10) + "Unicode -File sequence has changed and File data successfully replaced and renamed to Original Extension: " + lsOrigFileName
							FileWriteEx(giLogFileNo,lsLogOut)
							gu_nvo_process_files.uf_write_Log(lsLogOut)
						Else /*unable to rename*/
							lsLogOut = Space(10) + "***Unicode -File sequence has changed but Unable to replaced/renamed .TMP file data to Original Extension: " + lsOrigFileName
							FileWriteEx(giLogFileNo,lsLogOut)
							gu_nvo_process_files.uf_write_Log(lsLogOut)
						End If		
						
						//Extract the file
						lsLogOut = Space(10) + "Unicode -File sequence has changed and Flat File data successfully extracted to: " + lsPathOut + lsFileOut
						FileWriteEx(gilogFileNo,lsLogOut)
						gu_nvo_process_files.uf_write_Log(lsLogOut) /*display msg to screen*/
					
						//Archive the file
						lsOrigFileName = lsPathOut + lsFileOut
						//MA 12/08 - Added .txt to file
						lsNewFileName = ProfileString(gsinifile,lsProject,"archivedirectory","") + '\' + lsFileOut + '.txt'
						
						If FIleExists(lsNewFileName) Then
							lsNewFileName += '.' + String(DAteTime(Today(),Now()),'yyyymmddhhss')  + '.txt'
						End IF
						
						bret=CopyFile(lsOrigFileName,lsNewFileName,True)					
						//Jxlim 02/13/2012 write message on archive status
						If Bret Then
							lsLogOut = Space(10) + "Unicode -File sequence has changed and File archived to: " + lsNewFileName
							FileWriteEx(giLogFileNo,lsLogOut)
							gu_nvo_process_files.uf_write_Log(lsLogOut)
						Else /*unable to archive*/
							lsLogOut = Space(10) + "***Unicode -File sequence has changed but Unable to archive File: " + lsNewFileName
							FileWriteEx(giLogFileNo,lsLogOut)
							gu_nvo_process_files.uf_write_Log(lsLogOut)
						End If						
						
					End If //Jxlim 02/13/2013  File Sequence has changed; closed the file; end of .TMP removed on this section					
				End If /*not first time*/
				
				// 10/03 - Pconkl - we may have different output paths depending on the dest_Cd field in the output file
				lsDestPAth = ''
				If adw_output.GetItemString(llRowPos,'Dest_cd') > '' Then
					lsDestCd = "flatfileout-" + 	adw_output.GetItemString(llRowPos,'Dest_cd')
					lsDestPath = ProfileString(gsinifile,lsProject,lsDestCd,"")
				Else
					lsDestPath = ''
				End IF
	
				If lsDestPath > '' Then
					lsPAthout = lsDestPath + '\'
				Else
					lsPathOut = ProfileString(gsinifile,lsProject,"flatfiledirout","") +'\'
				End If
		
				// 05/03 - PCONKL - we may have a specific prefix, suffix (after the seq #, or file extension
					
				//Prefix
				lsFilePRefix = ProfileString(gsinifile,lsProject,"flatfileoutprefix","")
				If isNull(lsFilePrefix) or lsFilePrefix = '' Then
					lsFilePrefix  = Left(adw_output.GetItemString(llRowPos,'batch_data'),2)
				End If
				
				//Suffix
				lsFilesuffix = ProfileString(gsinifile,lsProject,"flatfileoutsuffix","")
				If isNull(lsFilesuffix) Then	lsFilesuffix  = ''
	
				//Extension
				lsFileExtension = ProfileString(gsinifile,lsProject,"flatfileoutextension","")
				If isNull(lsFileExtension) or lsFileExtension = '' Then
					lsFileExtension  = ".dat"
				End If
				
				//Build file name
				lsFileOut = lsFilePrefix + lsFileSequence + lsFileSuffix + lsFileExtension
	
				//We may have the file name specified in the datastore
				If adw_output.GetItemString(llRowPos,'file_name') > '' Then
					lsFileOut = adw_output.GetItemString(llRowPos,'file_name')
				End If
				
				lsLogOut = "      Flat File Out: " + lsFileOut
				FileWriteEx(gilogFileNo,lsLogOut)	
				gu_nvo_process_files.uf_write_Log(lsLogOut) /*display msg to screen*/				
				
	
				lsErrorPath = ""				
				
				//Jxlim 01/15/2013 Baseline changed - 
				//Notes: The file name exist on datastore but really the file has not exist on directory as yet.
				//During the process of writing flatfileout, we need to name the file ext with .TMP
				//to prevent file from grabbed by in the middle of writing. When is done writing we will have to remove .TMP so the file will be pick up by downstream as it should.				
									

				//liFileNo = FileOpen(lsPathOut + lsFileOut,LineMode!,Write!,LockREadWrite!,Append!,EncodingUTF16LE!)  //Jxlim 02/12/2012 for unicode use UTF8 parameter
				lsFileOut = adw_output.GetItemString(llRowPos,'file_name')  + '.TMP'    //Jxlim 01/17/2013 Added .TMP during processing		
				llFileNo = FileOpen(lsPathOut + lsFileOut,LineMode!,Write!,LockREadWrite!,Append!,EncodingUTF8!)  // Jxlim 02/11/2013 per Pete changed from EncodingUTF16LE! toEncodingUTF8!)

				lsLogOut = "      FileOpen llFileNO: " + string(llFileNo)
				FileWriteEx(gilogFileNo,lsLogOut)	
				gu_nvo_process_files.uf_write_Log(lsLogOut) /*display msg to screen*/				


							//Jxlim 02/02/2013 Used Long instead of Interger, and added <= 0
							If llFileNO <=  0 Then
								
								//10/08 - PCONKL - If we can't open the specified file, try to write out to a default directory - This probably only should happen if we are trying to write directly to a remote drive that might not be available.
								lsErrorPath =  lsPathOut + lsFileOut /*where we were trying to write to*/
								
								lsPathOut = ProfileString(gsinifile,lsProject,"flatfiledirout-hold","") +'\' /*Where we store it locally until we can try again*/
														
								//Try to Open the backup file (local)
								//liFileNo = n(lsPathOut + lsFileOut,LineMode!,Write!,LockREadWrite!,Append!,EncodingUTF16LE!)
								llFileNo = FileOpen(lsPathOut + lsFileOut,LineMode!,Write!,LockREadWrite!,Append!,EncodingUTF8!)
								
								If llFileNO < 0 or lsPAthOut = "\" Then
								
									lsLogOut = "     ***Unable to open file: " + lsPathOut + lsFileOut + " For output to Flat File."
									If lsErrorPath > "" Then
										lsLogOut += "  *** Attempted to open originally as: " + lsErrorPath + " ***"
									End If
									
									FileWriteEx(gilogFileNo,lsLogOut)		
									gu_nvo_process_files.uf_write_Log(lsLogOut) /*display msg to screen*/
									gu_nvo_process_files.uf_send_email('','Filexfer'," - ***** Unable to open remote file folder for file transfer. Action required to transfer file manually - see body of email for details.",lsLogOut ,'') /*send an email msg to the file transfer error list*/
									Return -1
									
								Else /*backup is open, send email to file transfer to alert that it needs to be redropped*/
									
									gu_nvo_process_files.uf_send_email('','Filexfer'," - ***** Unable to open remote file folder for file transfer. Action required to transfer file manually - see body of email for details.","Unable to open file: " + lsErrorPath + " for remote copy. File stored locally as: " + lsPathOut + lsFileOut + " and needs to be copied manually." ,'') /*send an email msg to the file transfer error list*/
									
								End IF
								
							End If
	
							lsLogOut = '     Unicode -File: ' + lsPathOut + lsFileOut + ' opened for Flat File extraction...'
							FileWriteEx(gilogFileNo,lsLogOut)	
							gu_nvo_process_files.uf_write_log(lsLogOut)		
			
		End If /*File Changed*/
		
		lsData = adw_output.GetItemString(llRowPos,'batch_data')		
		
		// 02/03 - PCONKL - 255 char limitation in DW, we may have data in second batch field to append to stream
		If (Not isnull(adw_output.GetItemString(llRowPos,'batch_data_2'))) and adw_output.GetItemString(llRowPos,'batch_data_2') > '' Then
			lsData += adw_output.GetItemString(llRowPos,'batch_data_2')
		End If
			
		llRC = FileWriteEx(llFileNo,lsData)
		
		If llRC < 0 Then
			lsLogOut =  string(llRowPos) +  "     ***Unable to write to file: " + lsPathOut + ":" +  lsFileOut + ":" + " For output to Flat File."
			FileWriteEx(gilogFileNo,lsLogOut)	
			gu_nvo_process_files.uf_write_Log(lsLogOut) /*display msg to screen*/
			
			
			
			
			
			lsLogOut = "FileName:" + adw_output.GetItemString(llRowPos,'file_name') 
			FileWriteEx(gilogFileNo,lsLogOut)	
			gu_nvo_process_files.uf_write_Log(lsLogOut) /*display msg to screen*/
			
			lsLogOut = "Unicode2      *** "+string(llRC)+": " + lsData 
			FileWriteEx(gilogFileNo,lsLogOut)	
			gu_nvo_process_files.uf_write_Log(lsLogOut) /*display msg to screen*/
			
			
		End If
		
		lsFileSequenceHold = lsFileSequence
		
	Next /*data row*/
	

	If llFileNo > 0 Then
		FileClose(llFileNo) /*close the last/only file*/		
	End If
	
	//Jxlim 02/13/2013 Remove .TMP extension after closing the file	
	lsFileExt = Right(lsFileOut, 4)
	If Upper(Trim(lsFileExt)) ='.TMP' Then
		lsTmpFileName = lsPathOut + lsFileOut		   //with .TMP ext	
		lsFileOut	 = left(lsFileOut	, len(lsFileOut) - 4)  //Remove .TMP	
		lsOrigFileName = lsPathOut + lsFileOut	//without .TMP extension aka keep the original file extension	
	End If

	//Jxlim 02/19/2013 If the original file exist then delete first; this happen when there is manual sweeper restart
	If  FIleExists(lsOrigFileName) Then
		FileDelete(lsOrigFileName)
		//Jxlim 02/20/2013 this message just for testing
		lsLogOut = Space(10) + "***Unicode - Deleted existing File data successfully from: " + lsOrigFileName + " before moving file from .TMP to original extension."	
		FileWriteEx(giLogFileNo,lsLogOut)
		gu_nvo_process_files.uf_write_Log(lsLogOut)
	End if
	//bret=CopyFile(lsTmpFileName, lsOrigFileName,True)  //Copy file content from .TMP to the original file
	//bret=DeleteFile(lsTmpFileName)  //Delete .TMP file after copy to original
	//Jxlim 02/03/2013 MoveFile() function does Rename to new file and delete old file similar to replace file.
	bret=MoveFile(lsTmpFileName, lsOrigFileName)
	//Jxlim 01/23/2012 write message on rename status
	If Bret Then
		lsLogOut = Space(10) + "Unicode -File data successfully replaced and renamed to Original: " + lsOrigFileName
		FileWriteEx(giLogFileNo,lsLogOut)
		gu_nvo_process_files.uf_write_Log(lsLogOut)
	Else /*unable to rename*/
		lsLogOut = Space(10) + "*** Unicode -Unable to replaced/renamed .TMP file data and .ext to Original File: " + lsOrigFileName
		FileWriteEx(giLogFileNo,lsLogOut)
		gu_nvo_process_files.uf_write_Log(lsLogOut)
	End If	

	//Jxlim 01/15/2013 Baseline - Remove .TMP ext and, use original file extension
	lsLogOut = Space(10) +"Unicode - Flat File data successfully extracted to: " + lsPathOut + lsFileOut
	FileWriteEx(gilogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_Log(lsLogOut) /*display msg to screen*/
		
	//Archive the last/only file
	lsOrigFileName = lsPathOut + lsFileOut
	//MA 12/08 - Added .txt to file
	IF ( asproject = 'PANDORA_DECOM' ) Then
		lsNewFileName = ProfileString(gsinifile,lsProject,"archivedirectory","") + '\' + lsFileOut
	Else 
		lsNewFileName = ProfileString(gsinifile,lsProject,"archivedirectory","") + '\' + lsFileOut + ".txt"
	End If
	
	// 03/04 - PCONKL - Check for existence of the file in the archive directory already - rename if duplicated
	//								We are now sending constant file names to some users instead of unique names (peice of shit AS400)
	
	//04/10 - MEA - Since we are batching the records, we only want to send the final file to Archive. 
	// 					 Delete any itermediate files.
	
	IF asproject <> 'WARNER' THEN

		If FileExists(lsNewFileName) Then
			lsNewFileName += '.' + String(DAteTime(Today(),Now()),'yyyymmddhhss')  + '.txt'
		End IF
	
	ELSE
	
		If FileExists(lsNewFileName) Then
			FileDelete ( lsNewFileName )
		END IF
	
	END IF
	
				Bret=CopyFile(lsOrigFileName,lsNewFileName,True)
				//Jxlim 01/23/2012 write message on archive status
				If Bret Then
					lsLogOut = Space(10) + "File archived to: " + lsNewFileName
					FileWriteEx(giLogFileNo,lsLogOut)
					gu_nvo_process_files.uf_write_Log(lsLogOut)
				Else /*unable to archive*/
					lsLogOut = Space(10) + "*** Unable to archive File: " + lsNewFileName
					FileWriteEx(giLogFileNo,lsLogOut)
					gu_nvo_process_files.uf_write_Log(lsLogOut)
				End If
		
Else /*no records to process for directory*/
		
		lsLogOut = "     There was no data to write for project: " + lsProject
		FileWriteEx(gilogFileNo,lsLogOut)
		gu_nvo_process_files.uf_write_Log(lsLogOut) /*display msg to screen*/
		
End If /*records exist to output*/
		
Return 0
end function

on u_nvo_edi_confirmations_starbucks_th.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_nvo_edi_confirmations_starbucks_th.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;
lsDelimitChar = char(9)
end event

