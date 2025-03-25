$PBExportHeader$u_nvo_edi_confirmations_sears-fix.sru
$PBExportComments$Process outbound edi confirmation transactions for Sears Fixtures
forward
global type u_nvo_edi_confirmations_sears-fix from nonvisualobject
end type
end forward

global type u_nvo_edi_confirmations_sears-fix from nonvisualobject
end type
global u_nvo_edi_confirmations_sears-fix u_nvo_edi_confirmations_sears-fix

forward prototypes
public function integer uf_tms_notification (ref datawindow adw_import)
end prototypes

public function integer uf_tms_notification (ref datawindow adw_import);
//Send a notification to TMS for Delivery Order

Datastore	ldsOut,	&
				ldsGR
				
Long			llRowPos, llRowCount, llNewRow
				
				
String		lsOutString, lsMessage,	lsStore,	lsProject, lsOrder, lsOrderHold,	&
				lsShipperOCI, lsTemp, lsDONO,	lsSKU, lsSupplier
		
DEcimal		ldBatchSeq,		&
				ldTotalWeight, ldTotalQty
				
Integer		liRC



ldsOut = Create Datastore
ldsOut.Dataobject = 'd_edi_generic_out'
lirc = ldsOut.SetTransobject(sqlca)

SetPointer(HourGlass!)
w_main.SetMicrohelp('Creating Inbound TMS Notifications for Sears...')

// We are creating a single outbound order per store. Sort by project/store so we can create a new header when it changes
adw_import.SetSort("Project_id A, Store_ID A")
adw_import.Sort()

//Shipper OCI from Warehouse UF1
Select user_field2 into :lsSHipperOcI
From Warehouse
Where wh_code = :gs_default_wh;

//Get the Next Batch Seq Nbr - Used for all writing to generic tables
//sqlca.sp_next_avail_seq_no(gs_project,'EDI_Inbound_Header','EDI_Inbound_Header',ldBatchSeq)
ldBatchSeq = g.of_next_db_seq(gs_project,'EDI_Inbound_Header','EDI_Batch_Seq_No')
If ldBatchSeq <= 0 Then
	MessageBox('System Error','Unable to retrieve the next available sequence number~rfor TMS Notification.~r~rNotification will not be sent!')
	Return -1
End If

if isnull(lsShipperOCI) Then lsShipperOCI = ''

llRowCOunt = adw_Import.RowCount()
For llRowPos = 1 to llRowCount /*For each Import Row*/
	
	lsOutString = ""
	
	lsStore = String(Long(adw_import.GetITemString(llRowPos,'Store_ID')),'00000') /* always pad with leading zeros for store */
	lsProject = adw_import.GetITemString(llRowPos,'Project_ID')
	lsOrder = lsStore + '-' + lsProject
	
	If lsOrder <> lsOrderHold Then /*Create a new header*/
		
		lsOutString = "HD|" /* rec type = header */
//MA		lsOutString += "856|" /* transaction_type */
		lsOutString += "SLS|" /*Customer*/
		lsOutString += "KSL|" /*SIC Code*/
		lsOutString += "EXP|" /*Division*/
		
		//Shipper Ref (Order Number)
		If Not isnull(lsOrder) Then
			lsOutString += lsOrder + "|"
		Else
			lsOutString += "|"
		End If
		
		// Menlo Booking Number - Blank Here, will be sent back by TMS later
		lsOutString += "|"
		
		// Carrier - Blank Here, will be sent back by TMS later
		lsOutString += "|"
		
		//Consignee (Store)
		If Not isnull(lsStore) Then
			lsOutString += lsStore + "|"
		Else
			lsOutString += "|"
		End If
		
		//Shipper OCI - From warehouse UF 1
		If Not isnull(lsshipperOCI) Then
			lsOutString += lsshipperOCI + "|"
		Else
			lsOutString += "|"
		End If
		
		//Ship Date (Planned)
		lsTemp = String(Date(adw_Import.GetITemString(llRowPos,'End_Date')),'YYYYMMDD')
		If Not isnull(lsTemp) Then
			lsOutString += lsTemp + "|"
		Else
			lsOutString += "|"
		End If
		
		//Ship Time (Planned) - Default to 13:00
		lsOutString += "130000|"
		
		//Delivery Date (Planned)
		lsTemp = String(Date(adw_Import.GetITemString(llRowPos,'Delivery_Date')),'YYYYMMDD')
		If Not isnull(lsTemp) Then
			lsOutString += lsTemp + "|"
		Else
			lsOutString += "|"
		End If
		
		//Delivery Time (Planned) - Default to 13:00
		lsOutString += "130000|"
		
		//Terms - Default to 'PP' - 01/04 - PCONKL - Change to 'CC'
		//lsOutString += "PP|"
		lsOutString += "CC|" /*- 01/04 - PCONKL - Change to 'CC'*/
		
		//File Direction O=Outbound SIMS->TMS
		lsOutString += "O|"
		
		//we'll pass the DONO associated with this order so we can match coming back form TMS
		Select Max(do_no) into :lsDONO from Delivery_MAster where project_id = :gs_project and invoice_no = :lsOrder;
		
		If Not isnull(lsDONO) Then
			lsOutString += lsDONO + "|"
		Else
			lsOutString += "|"
		End If
		
		//Get max quantity and weight for this order
		Select Sum(req_qty), Sum(Convert( Decimal, user_field1)) into :ldTotalQTY, :ldTotalWeight
		From Delivery_Detail
		Where do_no = :lsDONO;
		
		If isnull(ldTotalQty) Then ldTotalQty = 0
		If isnull(ldTotalWeight) Then ldTotalWeight = 0
		
		lsOutString += String(ldTotalQty,'#########.##') + "|"
		lsOutString += String(ldTotalWeight,'#########.##') + "|"
		
		//Remarks - Last Column
		lsTemp = adw_import.GEtITemString(1,'remark')
		If Not isnull(lsTemp) Then
			lsOutString += lsTemp + "|"
		Else
			lsOutString += "|"
		End If
		
		//Remarks 2 - always blank
		//lsOutString += "|"
		
		//If the last char is a pipe, remove it
		Do While Right(lsOutString,1) = '|'
			lsOutString = Left(lsOutString,(len(lsOutString) - 1))
		Loop


//MA		//Carrie_PRO_Number
//		lsOutString += "|"
//
//		//Trailer_Number
//		lsOutString += "|"
//
//		//Ship_From_Name
//		lsOutString += "|"
//		
//		//Ship_From_Address
//		lsOutString += "|"
//
//		//Ship_From_City
//		lsOutString += "|"
//
//		//Ship_From_State
//		lsOutString += "|"
//
//		//Ship_From_Zip
//		lsOutString += "|"
//		
//		//Ship_From_Country
//		lsOutString += "|"
//	
//		//Ship_To_Name
//		lsOutString += "|"
//		
//		//Ship_To_Address
//		lsOutString += "|"
//
//		//Ship_To_City
//		lsOutString += "|"
//
//		//Ship_To_State
//		lsOutString += "|"
//
//		//Ship_To_Zip
//		lsOutString += "|"
//		
//		//Ship_To_Country
//		lsOutString += "|"
//		
//		//Status
//		lsOutString += "XB" + "|"
//		
//
//		//Status Confirm Date 
//		lsOutString += "|"
//
//		//Status Confirm Time 		
//		lsOutString += "|"		
//
//		//Status City 		
//		lsOutString += "Aurora" + "|"
//		
//		//Status State 		
//		lsOutString += "IL" + "|"
//		
//		//Status Country 		
//		lsOutString += "|"
//		
//		//Status Original App 		
//		lsOutString += "SIMS" + "|"
//		
//		//Status Transaction_ID 		
//		lsOutString += "214" + "|"
//		
//		//Purchase Order Numbers 		
//		lsOutString += ""
//
		
		//Write the Header record
		llNewRow = ldsOut.insertRow(0)
		ldsOut.SetItem(llNewRow,'Project_id', 'TMS-SEARS') /*matches project parm in Ini file */
		ldsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
		ldsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
		If len(lsOutString) > 255 Then //  We can only store 255 char in a dw field, split into second batch field if necessary
			ldsOut.SetItem(llNewRow,'batch_data', Left(lsOutString,255))
			ldsOut.SetItem(llNewRow,'batch_data_2', Mid(lsOutString,256))
		Else
			ldsOut.SetItem(llNewRow,'batch_data', lsOutString)
			ldsOut.SetItem(llNewRow,'batch_data_2', '')
		End If
		
	End If /*new Header */
	
	//Write a detail record
	
	lsOutString = "DT|" /* rec type = Detail */
	
	//Order Number
	If Not isnull(lsOrder) Then
		lsOutString += lsOrder + "|"
	Else
		lsOutString += "|"
	End If

//	//SKU
//	lSSKU = lsStore + '-' + lsProject + '-' + adw_import.GetITemString(llRowPos,'UOM') /* Sku is Store + Project + UOM */
//	If Not isnull(lSSKU) Then
//		lsOutString += lSSKU + "|"
//	Else
//		lsOutString += "|"
//	End If

	//Supplier Code
	lSSupplier = adw_Import.GetITemString(llRowPos,'supp_code')
	If Not isnull(lSSupplier) Then
		lsOutString += lSSupplier + "|"
	Else
		lsOutString += "|"
	End If
	
	//Freight Class
	lsTemp = String(Dec(adw_import.GetITemString(llRowPos,'Freight_Class')),'#####.#')
	If Not isnull(lsTemp) Then
		lsOutString += lsTemp + "|"
	Else
		lsOutString += "|"
	End If
	
	//Description
	lsTemp = adw_import.GetITemString(llRowPos,'Description')
	If Not isnull(lsTemp) Then
		lsOutString += lsTemp + "|"
	Else
		lsOutString += "|"
	End If
	
	//Quantity
	lsTemp = String(Dec(adw_import.GetITemString(llRowPos,'Quantity')),'#########.##')
	If Not isnull(lsTemp) Then
		lsOutString += lsTemp + "|"
	Else
		lsOutString += "|"
	End If
	
	//UOM
	lsTemp = adw_import.GetITemString(llRowPos,'UOM')
	If Not isnull(lsTemp) Then
		lsOutString += lsTemp + "|"
	Else
		lsOutString += "|"
	End If
	
	//Weight
	lsTemp = String(Dec(adw_import.GetITemString(llRowPos,'Weight')),'#########.##')
	If Not isnull(lsTemp) Then
		lsOutString += lsTemp + "|"
	Else
		lsOutString += "|"
	End If
	
	//Cube
	lsTemp = String(Dec(adw_import.GetITemString(llRowPos,'Cube')),'#########.##')
	If Not isnull(lsTemp) Then
		lsOutString += lsTemp 
	Else
	//	lsOutString += "|"
	End If
	
//	//If the last char is a pipe, remove it
//	Do While Right(lsOutString,1) = '|'
//		lsOutString = Left(lsOutString,(len(lsOutString) - 1))
//	Loop
		
	//Write the Detail record
	llNewRow = ldsOut.insertRow(0)
	ldsOut.SetItem(llNewRow,'Project_id', 'TMS-SEARS') /*matches project parm in Ini file */
	ldsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	ldsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	If len(lsOutString) > 255 Then //  We can only store 255 char in a dw field, split into second batch field if necessary
		ldsOut.SetItem(llNewRow,'batch_data', Left(lsOutString,255))
		ldsOut.SetItem(llNewRow,'batch_data_2', Mid(lsOutString,256))
	Else
		ldsOut.SetItem(llNewRow,'batch_data', lsOutString)
		ldsOut.SetItem(llNewRow,'batch_data_2', '')
	End If
		
	lsOrderHold = lsOrder
	
Next /* Next Import record */

//Save the changes to the generic output table - SP will write to flat file
liRC = ldsOut.Update()
If liRC = 1 Then
	Execute Immediate "COMMIT" using SQLCA;
Else
	lsMessage= SQLCA.SQLErrText
	Execute Immediate "ROLLBACK" using SQLCA;
	 MessageBox('TMS Notification', 'Unable to save TMS Notification: ' + lsMessage)
	 Return -1
End If

w_main.SetMicrohelp('TMS Notification created for Sears.')
SetPointer(Arrow!)

Return 0
end function

on u_nvo_edi_confirmations_sears-fix.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_nvo_edi_confirmations_sears-fix.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

