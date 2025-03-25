$PBExportHeader$u_nvo_custom_validations_receive.sru
$PBExportComments$Project Level Receipt Validations
forward
global type u_nvo_custom_validations_receive from nonvisualobject
end type
end forward

global type u_nvo_custom_validations_receive from nonvisualobject
end type
global u_nvo_custom_validations_receive u_nvo_custom_validations_receive

forward prototypes
public function integer uf_check_confirm ()
end prototypes

public function integer uf_check_confirm ();Long	llRowCount,	llRowPos, llRoNo,	llLineItem,	llOwner, llFindRow

String	lsOrdStatus, lsOrder, lsPrevJob, lsTemp, ls_cust_order_no, ls_carrier, lsSKU, lsSUpplier, lsGroup, lsRONO, lsPrefix
string ls_find, ls_sku, ls_serial_find
long ll_findrow, ll_line_item_no, ll_idno, ll_qty, ll_serial_count
DateTime ldt_schedule_datetime, ldtToday
Boolean	lbInvalidPRefix, lbImport

//Check project level edits before Receipt confirmation

Choose Case Upper(gs_project)
		
	
	Case "LOGITECH" // 07/04 - PCONKL
		
		//Items must be received within tolerances depending on item grp
		llRowCOunt = w_ro.idw_Detail.RowCount()
		For llRowPos = 1 to llRowCount
			
			lsSKU = w_ro.idw_Detail.GetITemString(llRowPOs,'SKU')
			lsSupplier = w_ro.idw_Detail.GetITemString(llRowPOs,'Supp_code')
			
			Select grp into :lsGroup
			From ITem_Master
			Where Project_id = :gs_Project and SKU = :lsSKU and supp_code = :lsSupplier;
			
			If lsGroup = 'Y' Then /* Finished goods, Cant receive over and warn if receiving Under*/
			
				If w_ro.idw_Detail.GetITemNumber(llRowPOs,'Alloc_Qty') > w_ro.idw_Detail.GetITemNumber(llRowPOs,'Req_Qty') Then
					
					Messagebox(w_ro.is_title,"Line Item " + String(w_ro.idw_Detail.GetITemNumber(llRowPOs,'Line_Item_no')) + ", You may not receive > 100% of the ordered QTY!",StopSign!)
					Return -1
					
				ElseIf w_ro.idw_Detail.GetITemNumber(llRowPOs,'Alloc_Qty') < w_ro.idw_Detail.GetITemNumber(llRowPOs,'Req_Qty') Then
					
					If Messagebox(w_ro.is_title,"Line Item " + String(w_ro.idw_Detail.GetITemNumber(llRowPOs,'Line_Item_no')) + ", Receipt Qty is less than ordered QTY.~rAre you sure you want to continue?",Question!,YesNo!,1) = 2 Then
						Return -1
					End If
					
				End If
			
			Else /* Packing, Cant receive more than 110% and warn if less than 100% */
				
				If (w_ro.idw_Detail.GetITemNumber(llRowPOs,'Alloc_Qty') / w_ro.idw_Detail.GetITemNumber(llRowPOs,'Req_Qty')) > 1.1 Then
					
					Messagebox(w_ro.is_title,"Line Item " + String(w_ro.idw_Detail.GetITemNumber(llRowPOs,'Line_Item_no')) + ", You may not receive > 110% of the ordered QTY!",StopSign!)
					Return -1
					
				ElseIf w_ro.idw_Detail.GetITemNumber(llRowPOs,'Alloc_Qty') < w_ro.idw_Detail.GetITemNumber(llRowPOs,'Req_Qty') Then
					
					If Messagebox(w_ro.is_title,"Line Item " + String(w_ro.idw_Detail.GetITemNumber(llRowPOs,'Line_Item_no')) + ", Receipt Qty is less than ordered QTY.~rAre you sure you want to continue?",Question!,YesNo!,1) = 2 Then
						Return -1
					End If
					
				End If
				
			End If /* FG vs Packaging */
			
		Next /*detail */
					
	Case '3COM_NASH'
				
		//Order Type Validations
		Choose Case Upper(w_ro.idw_Main.GetItemString(1,'ord_type'))
				
			Case 'X' /* Return from Customer (Revenue Side) */
				
				//Current date must be within RMA Valid Dates (User 1,2) 
				If isDate(w_ro.idw_main.GetITemString(1,'User_Field1')) and isDate(w_ro.idw_main.GetITemString(1,'User_Field2')) Then
					If String(today(),'yyyy-mm-dd') < w_ro.idw_main.GetITemString(1,'User_Field1') or &
						String(today(),'yyyy-mm-dd') > w_ro.idw_main.GetITemString(1,'User_Field2') Then
				
						If Messagebox(w_ro.is_title, "This order is being received outside of the the expected RMA date range.~r~rDo you want to continue?",Question!,YesNo!,2) = 2 Then
							Return -1
						End If
					End If
				End If
					
				//Inventory type
				// pvh add logic for inventory type "hold" and "obsolete" filter those out?
				// pvh - 12/01/06 - MARL
				string findthis
				findthis = "Upper(Inventory_Type) <> 'R' and Upper(Inventory_Type) <> 'O' and Upper(Inventory_Type) <> 'H'"
				//lLFindRow = w_ro.idw_putaway.Find("Upper(Inventory_Type) <> 'R'",1,w_ro.idw_Putaway.RowCount())
				lLFindRow = w_ro.idw_putaway.Find( findthis ,1,w_ro.idw_Putaway.RowCount())
				If llFindRow > 0 Then
					// pvh - 12/01/06 - MARL
					MessageBox(w_ro.is_title, "Inventory Type Must be 'Return', 'Hold' or 'Obsolete' for a Return from Customer!", StopSign!)	
					//MessageBox(w_ro.is_title, "Inventory Type Must be 'Return', for a Return from Customer!", StopSign!)	
					w_ro.tab_main.SelectTab(3) 
					f_setfocus(w_ro.idw_putaway, llFindRow, "inventory_type")
					Return -1
				End If
			
				//Disp Code
				lLFindRow = w_ro.idw_putaway.Find("user_field1 = '' or isnull(user_Field1)",1,w_ro.idw_Putaway.RowCount())
				If llFindRow > 0 Then
					MessageBox(w_ro.is_title, "RMA Disposition Code is required for a Return from Customer!", StopSign!)	
					w_ro.tab_main.SelectTab(3) 
					f_setfocus(w_ro.idw_putaway, llFindRow, "USer_Field1")
					Return -1
				End If
				
			Case 'M', 'R' /* 08/07 - PCONKL - serial numbers required for RMA ORders (GLS Side) */
				
				If w_ro.idw_putaway.Find("Serialized_ind <> 'N' and (serial_no = '-' or serial_no = '' or isnull(serial_No))",1,w_ro.idw_putaway.RowCount()) > 0 Then
					MessageBox(w_ro.is_title, "Serial Numbers must be entered for this GLS Order Type", StopSign!)	
					w_ro.tab_main.SelectTab(5) 
					Return -1
				End If
			
		End Choose 
		
		//Validate required Detail Fields
		llRowCOunt = w_ro.idw_Detail.RowCount()
		For llRowPos = 1 to llRowCount
			
			//For Singapore WH, User Field 3 (FTZ vs Domestic shipment) is required and must be 'FTZ' or 'Dom'
			If w_ro.idw_main.GEtITemString(1,'wh_Code') = '3COM-SIN' Then
				If isnull(w_ro.idw_detail.GetITemString(llRowPos,'user_field3')) or w_ro.idw_detail.GetITemString(llRowPos,'user_field3') = '' Then
					MessageBox(w_ro.is_title,'FTZ/Dom is required and must be "FTZ" or "DOM"')
					w_ro.tab_main.SelectTab(2)
					f_setfocus(w_ro.idw_detail,llRowPos,"user_field3")
					Return -1
				ElseIf Upper(w_ro.idw_detail.GetITemString(llRowPos,'user_field3')) <> 'FTZ' and Upper(w_ro.idw_detail.GetITemString(llRowPos,'user_field3')) <> 'DOM' Then
					MessageBox(w_ro.is_title,'FTZ/Dom is required and must be "FTZ" or "DOM"')
					w_ro.tab_main.SelectTab(2)
					f_setfocus(w_ro.idw_detail,llRowPos,"user_field3")
					Return -1
				End If
			End If /*Sin Warehouse */
			
		Next /*Next detail Row*/
		
	Case 'PHXBRANDS' /* 03/4 - PCONKL - Phoenix brands*/
		
		//If a Return
		If w_ro.idw_Main.GetItemString(1,'ord_type') = 'X' Then
			
			// User Field 4 (who is paying freight charges) must be present and be 'C' (customer) or 'M' (Menlo)
			If isNull(w_ro.idw_main.GetITemString(1,'user_field4')) Or &
				(w_ro.idw_main.GetITemString(1,'user_field4') <> 'C' and w_ro.idw_main.GetITemString(1,'user_field4') <> 'M') Then
					MessageBox(w_ro.is_title, "'RMA Freight Chg' must be either 'C' (customer) or 'M' (Menlo)!", StopSign!)	
					w_ro.tab_main.SelectTab(1) 
					f_setfocus(w_ro.idw_main, 1, "USer_Field4")
					Return -1
			End If
			
		End If /*Return Order*/
		
	Case 'NETAPP'
		
		// 08/07 - PCONKL - IF Rev Required Ind (IM UF4), it must be entered in Detail UF2
		llRowCOunt = w_ro.idw_Detail.RowCount()
		For llRowPos = 1 to llRowCount
			
			If w_ro.idw_Detail.GetITEmString(llRowPos,'User_Field2') = '' or isnull(w_ro.idw_Detail.GetITEmString(llRowPos,'User_Field2')) Then
				
				lsSKU = w_ro.idw_Detail.GetITemString(llRowPOs,'SKU')
				lsSupplier = w_ro.idw_Detail.GetITemString(llRowPOs,'Supp_code')
			
				Select User_Field4 into :lsTemp
				From Item_Master
				Where Project_id = :gs_Project and sku = :lsSKU and Supp_Code = :lsSupplier;
				
				If Upper(Trim(lsTemp)) = 'Y' Then
					MessageBox(w_ro.is_title, "'Revision is required for this Item.", StopSign!)	
					w_ro.tab_main.SelectTab(2)
					f_setfocus(w_ro.idw_detail,llRowPos,"user_field2")
					Return -1
				End If
				
			End If
			
		Next

	Case 'DIEBOLD' 
		
		//If order type is Supplier (S), We are assigning Container ID's (into Po_no2) prefixed with the numeric portion of the RO_NO followed by 4 digit seq.
		//It is possible that container will be used in multiple orders so it will be a soft edit/stop
		// 10/08 - PCONKL - Include for Company 132 replenishment orders (type = P)
		
		If w_ro.Idw_Main.GetITemString(1,'ord_type') = 'S' or w_ro.Idw_Main.GetITemString(1,'ord_type') = 'P' Then
			
			If Upper(w_ro.Idw_Main.GetITemString(1,'supp_code')) <> 'DIEBOLD' Then
			
				//Prefix with char based on Warehouse Code
				Choose Case w_ro.idw_Main.getITemString(1,'wh_Code')
			
					Case 'DIE-COLUMB'
						lsPrefix = 'C'
					Case 'DIE-PHX'
						lsPrefix = 'P'
					Case 'DIE-GREENS'
						lsPrefix = 'G'
					Case Else
						lsPrefix = 'X'
				End Choose
				
				//We want to ignore validations for orders entered via spreadsheet - these will be supplier orders as well.
				//we will use presence of a value in receive_Detail UF1 which is the 'Spreadsheet ID'
				If w_ro.idw_Detail.RowCount() > 0 Then
					If w_ro.idw_Detail.GetITemString(1,'user_Field1') > '' Then lbImport = True
				End If
				
				lsRONO = Right(w_ro.idw_main.GetITemString(1,'ro_no'),6)
			
				llRowCount = w_ro.idw_Putaway.RowCount()
			
				For llRowPos = 1 to llRowCount
					
					//Ignore orders imported from spreadsheet
					If lbImport Then Exit
				
					//Check Warehouse PRefix
					If Upper(left(w_ro.idw_Putaway.GetITEmString(llRowPos,'po_no2'),1)) <>  lsPrefix Then
						Messagebox(w_ro.is_title,"Container ID for this warehouse must begin with '" + lsPRefix + "' for Supplier and 132 Replen Orders",StopSign!)
						w_ro.tab_main.SelectTab(3)
						f_setfocus(w_ro.idw_Putaway,llRowPos,"po_no2")
						Return -1
					End If
					
					//must be 11 digits (including warehouse prefix)
					If len(w_ro.idw_Putaway.GetITEmString(llRowPos,'po_no2')) <> 11 Then
						Messagebox(w_ro.is_title,"Container ID must be 11 digits for Supplier and 132 Replen Orders",StopSign!)
						w_ro.tab_main.SelectTab(3)
						f_setfocus(w_ro.idw_Putaway,llRowPos,"po_no2")
						Return -1
					End If
				
					If Not isnumber(Mid(w_ro.idw_Putaway.GetITEmString(llRowPos,'po_no2'),2,999))  Then
						Messagebox(w_ro.is_title,"Container ID must be numeric (after warehouse prefix) for Supplier and 132 Replen Orders!",StopSign!)
						w_ro.tab_main.SelectTab(3)
						f_setfocus(w_ro.idw_Putaway,llRowPos,"po_no2")
						Return -1
					End If /* not numeric*/
				
					//Invalid PRefix - Soft stop at end				
					If Mid(w_ro.idw_Putaway.GetITEmString(llRowPos,'po_no2'),2,6) <> lsRONO Then
						lbInvalidPRefix = True
					End If
								
				Next /*Putaway*/
				
				If lbInvalidPRefix Then
					If Messagebox(w_ro.is_title,"One or more Container ID's is associated with another order.~r~rID's associated with this order begin with '" + lsPRefix +  lsRoNo + "'~r~rDo you want to continue?",Question!,YesNo!) = 2 Then
						Return -1
					End If
				End If
				
			End If /*Supplier ORder*/
				
		End If /*Supplier Code = 'DIEBOLD'*/

//01-12 - MEA - Nike Validation (Doc Rcv DT and  Ref Nbr)

Case 'NIKE-SG', 'NIKE-MY'  				
				
	string ls_user_field10, ls_user_field11
	
	 ls_user_field10 = w_ro.idw_Main.GetITemString(1,'user_Field10')
	 ls_user_field11 = w_ro.idw_Main.GetITemString(1,'user_Field11')
	  
	 If Isnull(ls_user_field10) or trim(ls_user_field10) = '' then
		
		MessageBox (w_ro.is_title, "Must enter Doc Rcv DT before you confirm.")
		
		 w_ro.idw_Main.SetColumn("user_Field10")
		 w_ro.idw_Main.SetFocus()
		 
		 return -1
		
	end if

	 If Isnull(ls_user_field11) or trim(ls_user_field11) = '' then
	
		MessageBox (w_ro.is_title, "Must enter Ref Nbr before you confirm.")
		
		 w_ro.idw_Main.SetColumn("user_Field11")
		 w_ro.idw_Main.SetFocus()
		 
		 return -1
		
	end if	  

//16-March-2016 :Madhu Added validation for BOSCH - START
Case "BOSCH"
	
	llRowCount =w_ro.idw_detail.rowcount()
	
	If w_ro.idw_main.getItemString(1,'user_field6') ='SalesOrderReturn' Then
		
		For llRowPos=1 to llRowCount
				If trim(w_ro.idw_detail.getItemString(llRowPos,'user_field1'))='' or isnull(w_ro.idw_detail.getItemString(llRowPos,'user_field1')) Then
					MessageBox(w_ro.is_title,"Order Detail User Field1 should not be blank")
					w_ro.tab_main.SelectTab(3)
					f_setfocus(w_ro.idw_detail,llRowPos,"user_field1")
					Return -1
				End If
		Next
	End If
  //16-March-2016 :Madhu Added validation for BOSCH -END
  
End Choose

//04-APR-2019 :Madhu SS31781 F14974 Putaway Serial RollUp - START
//Putaway record serialized SKU QTY should match serial count on Serial Tab

IF g.ib_receive_putaway_serial_rollup_ind THEN
	
	//putaway count
	llRowCount = w_ro.idw_putaway.rowcount()
	
	//find serialized sku's
	ls_find ="Serialized_Ind IN ( 'Y', 'B')"
	ll_findrow = w_ro.idw_putaway.find(ls_find, 0, llRowCount)

	DO WHILE ll_findrow > 0
		
		//get required fields
		ls_sku = w_ro.idw_putaway.getItemString(ll_findrow, 'sku')
		ll_line_item_no = w_ro.idw_putaway.getItemNumber(ll_findrow, 'line_item_no')
		ll_idno = w_ro.idw_putaway.getItemNumber(ll_findrow, 'id_no')
		ll_qty = w_ro.idw_putaway.getItemNumber(ll_findrow, 'quantity')
		
		//find matching records count on serial tab
		ll_serial_count = w_ro.idw_rma_serial.rowcount()
		ls_serial_find = "sku='"+ls_sku+"' and line_item_no="+string(ll_line_item_no)+" and id_no="+string(ll_idno)
		w_ro.idw_rma_serial.setfilter(ls_serial_find)
		w_ro.idw_rma_serial.filter()
		ll_serial_count = w_ro.idw_rma_serial.rowcount()
		
		//if sku QTY  doesn't equal to serial count, prompt error message.
		IF ll_qty <> ll_serial_count THEN

			//remove filter
			w_ro.idw_rma_serial.setfilter("")
			w_ro.idw_rma_serial.filter()
			w_ro.idw_rma_serial.sort()
	
			MessageBox(w_ro.is_title, "Please scan required serial no's against SKU# "+ls_sku+" on Serial Tab.", StopSign!)
				
			w_ro.tab_main.SelectTab(4)
			f_setfocus(w_ro.idw_putaway, ll_findrow, "sku")
			Return -1
		END IF
		
		//remove filter
		w_ro.idw_rma_serial.setfilter("")
		w_ro.idw_rma_serial.filter()
		w_ro.idw_rma_serial.sort()
		
		ll_findrow = w_ro.idw_putaway.find(ls_find, ll_findrow+1, llRowCount+1)		
	LOOP

	//find, any serial no doesn't have a valid value.
	ls_serial_find ="serial_no='-' or isnull(serial_no) or serial_no=''"
	ll_serial_count = w_ro.idw_rma_serial.find(ls_serial_find, 1, w_ro.idw_rma_serial.rowcount())
	
	IF ll_serial_count > 0 THEN
		MessageBox(w_ro.is_title, "Serial Numbers must be entered for serialized parts!", StopSign!)	
		w_ro.tab_main.SelectTab(6) 
		f_setfocus(w_ro.idw_rma_serial, ll_serial_count, "serial_no")
		Return -1
	END IF

END IF
//04-APR-2019 :Madhu SS31781 F14974 Putaway Serial RollUp - END

Return 0
end function

on u_nvo_custom_validations_receive.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_nvo_custom_validations_receive.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

