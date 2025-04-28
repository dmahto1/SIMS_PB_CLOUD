HA$PBExportHeader$n_pandora_delivery_service.sru
forward
global type n_pandora_delivery_service from nonvisualobject
end type
end forward

global type n_pandora_delivery_service from nonvisualobject
end type
global n_pandora_delivery_service n_pandora_delivery_service

forward prototypes
public function integer of_delete_serials (boolean ab_reconfirm, string as_initial_ord_status, string as_do_no, long al_method_trace_id, window aw_do)
end prototypes

public function integer of_delete_serials (boolean ab_reconfirm, string as_initial_ord_status, string as_do_no, long al_method_trace_id, window aw_do);// LTK 20110823	Pandora #258	Moved this serial deletion code from w_do.ue_confirm().

w_do lw_do
lw_do = aw_do

Int i_indx
String lsSKU, lsSerial, ls_component_ind, lsFind, as_error_message_title, as_error_message, ls_missing_sku_serial
Boolean lb_missing_sku_serial
Long ll_na_Component_no, llFindRow, ll_missing_sku_serial_cnt

// 08/11/2010 ujhall: 02 of ?? Full Circle Fix: Manage Serial nos in Serial_number_Inventory table
boolean lb_Error
string lswhcode, ls_owner_cd, lsSerializedInd
long ll_owner_id
long ll_return //01/03/2011 ujh: S/N_P

//08-Feb-2013  :Madhu code -START
string lsinvoice_no
select  Invoice_No INTO :lsinvoice_no
FROM Delivery_Master
WHERE DO_NO =:as_do_no
USING sqlca;
//08-Feb-2013  :Madhu code -END

//BCR 06-DEC-2011: Treat Bluecoat same as Pandora...
// if upper(gs_project) = 'PANDORA' OR upper(gs_project) = 'BLUECOAT' then
// ET3 2012-06-14: Implement generic test
if g.ibSNchainofcustody then
	lb_Error = false
	lsWhCode =  Upper(lw_do.idw_main.getitemstring(1,'wh_code'))
	Execute Immediate "Begin Transaction" using SQLCA; 
	FOR i_indx = 1 to lw_do.tab_main.tabpage_serial.dw_serial.RowCount()
//			ll_Owner_id = tab_main.tabpage_putaway.dw_putaway.GetItemNumber(i_indx,'Owner_id')
//			lsOwnerCd = tab_main.tabpage_putaway.dw_putaway.GetItemString(i_indx, 'Owner_cd')
		lsSKU =  lw_do.tab_main.tabpage_serial.dw_serial.GetItemString(i_indx,'SKU')
		lsSerial = lw_do.tab_main.tabpage_serial.dw_serial.GetItemString(i_indx, 'Serial_no')
		lsSerializedInd = lw_do.tab_main.tabpage_serial.dw_serial.GetItemString(i_indx, 'Serialized_ind')  // 01/03/2011 ujh: S/N_P
		ls_component_ind = lw_do.tab_main.tabpage_serial.dw_serial.GetItemString(i_indx, 'Component_ind')
		ll_na_Component_no = lw_do.tab_main.tabpage_serial.dw_serial.GetItemNumber(i_indx, 'na_Component_no')


		lsFind = "Upper(SKU) = '" + Upper(lsSKU) + "' and Upper(supp_code) = '" + Upper(lw_do.tab_main.tabpage_serial.dw_serial.GetItemString(i_indx, 'Supp_Code')) + "'"
		lsFind += " and Line_Item_no =  " + String(lw_do.tab_main.tabpage_serial.dw_serial.GetITemNumber(i_indx,'Line_Item_no')) 
		llFindRow = lw_do.idw_Pick.Find(lsFind,1,lw_do.idw_pick.RowCount())
		If llFindRow > 0 Then
			ll_owner_id = lw_do.idw_Pick.GetItemNumber(llfindrow,'owner_id')
		End if
		// Get owner_cd
		Select Owner_cd 
		Into :ls_owner_cd
		From Owner
		where Project_id = :gs_project
		and owner_id = :ll_owner_id;
		
		// 01/03/2011 ujh: S/N_P should this item be in the serial_number_inventory table?
		/////////////////////////////////////////////////////////////////////////////////////////////////////////////
		/* 01/03/2011 ujh: S/N_Pa:  The following requires dw_srial be orderd so Parents precede 
			children.  This was accomplished by the call to dw_sort() when the serial list was generated */
		/* If a non-type "B"  parent has type "B" serialized children, it was put it in Serialized_Number_Inventory
			so children could find their parent.  We only want to try to delete what should be there.*/
			// So, IS THIS A  NON_SERIALIZED "B" PARENT with "B" serialized children  IF llFindRow > 0 then YES it is
			llFindRow = 0   // Make sure no carry over from previous iteration. Don't care where child is, just that it exists
			IF lw_do.idw_serial.getitemString(i_indx, 'component_ind') = 'Y' &   
				and lw_do.idw_serial.getitemString(i_indx, 'Serialized_ind') <> 'B' then    
					lsFind = "Component_No = "  + String(lw_do.idw_serial.getitemnumber(i_indx,'component_no')) 
					lsFind += " And Serialized_ind = 'B' "
					lsFind +=  " And Component_ind = '*' " 
					// Find this part's serialized children if it has any
					llFindRow = lw_do.idw_serial.Find(lsFind,1,lw_do.idw_serial.RowCount())		
			end if //01/03/2011 ujh: S/N_Pa  
			
		/////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
			// 01/03/2011 ujh: S/N_P  Should this item be in the serialized_number_inventory table
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			//01/03/2011 ujh: S/N_Pa:  The following were reversed in order to check the code in 01/31/2011.  Must be reversed for S/N_P
//						if  not(isnull(lsSerial) or lsSerial = '-' or lsSerial = '') and Upper(lsSerializedInd) = 'B' then	 // original code
			if (not(isnull(lsSerial) or lsSerial = '-' or lsSerial = '') and Upper(lsSerializedInd) = 'B') or llFindRow > 0  then	// new S/N_P	
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

							
				/*01/03/2011 ujh: S/N_P:  The serial number SkU Combo should be in the table at this point,
					Error if it is NOT */
				//ll_return = i_nwarehouse.of_Error_on_serial_no_exists(gs_Project, lsSKU, lsSerial,ls_Owner_cd, ls_component_ind, ll_na_component_no,false)  // 01/03/2011 ujh: S/N_Pb:   change call to add component_ind and component_no
				
				//TimA 04/05/11
				//On a reconfirm there is no need to check serial numbers
//				If lbReconfirm = True then //TimA 04/15/2011 modified with a booleen flag instead
				If ab_reconfirm = True then //TimA 04/15/2011 modified with a booleen flag instead
				//If  Left(icb_confirm.Text,2) =  'Re' Then
					ll_return=0
				else
					as_error_message_title = ''
					as_error_message = ''
					ll_return = lw_do.i_nwarehouse.of_Error_on_serial_no_exists(gs_Project, lsSKU, lsSerial, ls_Owner_cd, ls_component_ind, ll_na_component_no, false, false,as_error_message_title,as_error_message,as_do_no,lsinvoice_no)  // dts - 20110219 - added parameter for SkipComponent
				
				if ll_return = 1 then
					lb_Error = true
					Exit  //01/03/2011 ujh: S/N_Pfx2   if there is an error, dont delet and don't continue processing
				else
					/* Parent and child serial numbers are in the same table, so there is no foreign key  constraint
						to force deleting children before parents.  Here because of the sort, parents will be delete 
						before children, but if there is an error and not deleted in this same transaction, lb_Error 
						will be set and cause a rollback*/
					if upper(ls_component_ind) = 'Y'	 or ls_component_ind = '*' then
						Delete Serial_Number_Inventory 
						WHERE Project_id = :gs_project
						and Serial_no = :lsSerial
						and SKU = :lsSKU
						and component_no = :ll_na_component_no; 
//								and wh_code = :lsWhCode
//								and owner_id = :ll_owner_id;
					else
						// Don't use component_ind for stand alone.  
						Delete Serial_Number_Inventory 
						WHERE Project_id = :gs_project
						and Serial_no = :lsSerial
						and SKU = :lsSKU;
					end if
		
					if  sqlca.SQlcode <> 0 then
					//Jxlim 09/10/2010 Added Rollback to prevent block/lock
//									 Execute Immediate "ROLLBACK" using SQLCA;
						  lb_Error = true
						  Exit  
					  end if
					  // 01/03/2011 ujh: S/N_P:  if the record was not in Serial_number_inventory capture first ten to display and warn
					 if sqlca.Sqlnrows = 0 then
						 lb_missing_sku_serial = true
						 ll_missing_sku_serial_cnt = ll_missing_sku_serial_cnt + 1
						 IF ll_missing_sku_serial_cnt <= 10  then// quit capturing after 10, but keep trying to do all we can
							 ls_missing_sku_serial = ls_missing_sku_serial + '('+lsSKU+','+lsSerial+') '
						END IF
						
					end if
					  
					  
				End if  // 01/03/2011 ujh: S/N_P  end checking retrun code that the serial number IS in the table
			end if  // // 01/03/2011 ujh: S/N_P  end whether or not item should be in the table
		end if
	next
	if lb_Error then
		Execute Immediate "ROLLBACK" using SQLCA;
//					if ib_unconfirm Then
//						MessageBox("DB Error Inserting Serial Nums", SQLCA.SQLErrText)
//					else
			MessageBox (as_error_message_title, as_error_message)
			//MessageBox ("DB Error Deleting Serial Nums", SQLCA.SQLErrText)
//					end if

		// LTK 20110817	#258 Do not allow confirmation if a serial number delete error occurred.
		update delivery_master
		set ord_status = :as_initial_ord_status
		where project_id = :gs_Project 
		and do_no = :as_do_no;
		
		// Post a retrieve to reset status and command buttons
		lw_do.PostEvent("ue_retrieve")
		// end #258
		
	//f_method_trace( al_method_trace_id, this.ClassName(), 'End ue_confirm' + ' DB error ' + as_error_message )	//08-Feb-2013  :Madhu commented
	f_method_trace_special( gs_project, this.ClassName(),'End ue_confirm' + ' DB error ' + as_error_message ,as_do_no, ' ',' ',lsinvoice_no) //08-Feb-2013  :Madhu added
		
		return -1
	else
		Execute Immediate "COMMIT" using SQLCA;
		if  lb_missing_sku_serial then
			 // 01/03/2011 ujh: S/N_P:
			messagebox('Delete Warning', 'Order confirmed, but following SKU/Serials not found in SNI table = ~r' + ls_missing_sku_serial)
		end if
	end if
	
end if

return 1

end function

on n_pandora_delivery_service.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_pandora_delivery_service.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;///////////////////////////////////////////////////////////////////////////////////////////
//
// Object:      n_pandora_delivery_service
//
// Author:        Larry Kehler
//
// Description: This class is used to contain Pandora validations and services.
//					It's purpose is to house Pandora specific delivery logic.
//
// Modifications: 20110823 Larry Kehler - Initial version
//
////////////////////////////////////////////////////////////////////////////////////////////

end event

