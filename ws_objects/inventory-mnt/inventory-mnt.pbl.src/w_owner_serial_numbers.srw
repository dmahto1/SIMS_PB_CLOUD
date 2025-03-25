$PBExportHeader$w_owner_serial_numbers.srw
$PBExportComments$+ SOC Serial No.s
forward
global type w_owner_serial_numbers from w_response_ancestor
end type
type dw_soc_serial from datawindow within w_owner_serial_numbers
end type
type sle_serial from singlelineedit within w_owner_serial_numbers
end type
type cb_select from commandbutton within w_owner_serial_numbers
end type
type cb_clear from commandbutton within w_owner_serial_numbers
end type
type st_text from statictext within w_owner_serial_numbers
end type
end forward

global type w_owner_serial_numbers from w_response_ancestor
integer y = 360
integer width = 2169
integer height = 2147
string title = "Scan SOC Serial No..."
dw_soc_serial dw_soc_serial
sle_serial sle_serial
cb_select cb_select
cb_clear cb_clear
st_text st_text
end type
global w_owner_serial_numbers w_owner_serial_numbers

type variables
n_warehouse i_nwarehouse
n_string_util i_string_util

end variables

forward prototypes
public function integer uf_do_scan_pandora_ip (string asscan)
end prototypes

public function integer uf_do_scan_pandora_ip (string asscan);
//MA 02/18Process DO scans for Pandora IP(ntellectual Property)  - SIMS-F5726 - Footprint Logic - Validation to allow only full pallet for Pandora

//Merged Trey's Code

String    lsScan, lsSKU, lsFind, lsContainer, lsLineItemNo,ls_ctype,lsCartonId, ls_sku,lsSUpplier, sql_syntax
String ls_Filter, lsPalletId,  lsSerialNo,lsCartonNo
Long      i, j, llFindRow, llContainerQty, llCartonQty, ldQty, ldCount, ldSNRowCount, ldContentQty, llFindRowSOCSerial, llSOCRows
DataStore lds_serial
lds_serial = CREATE Datastore

//If Not isValid(lds_serial) Then
//                ldw_serial = Create DAtastore
//                ldw_serial.DataObject = 'd_serial_inventory_validate'
//                ldw_serial.SetTransObject(SQLCA)
//End If

//1. Resolve the scan to its associated Pallet ID.  All IP(Intellectual Property) SKUs must be on a pallet.  Reguardless of the value(Serial, Container ID or Pallet) entered we can determine which Pallet it  belongs to.


// Check if the value scanned is a Pallet 
lsFind = "Upper(po_no2) = '" + Upper(asscan) + "'"
llFindRow = w_owner_change.idw_detail.Find(lsFind,1,  w_owner_change.idw_detail.RowCount())
If llFindRow > 0 Then 
     lsPalletId = asScan
Else

                // Check if the value scanned is a Container
                lsFind = "Upper(container_id) = '" + Upper(asScan) + "'"
                llFindRow = w_owner_change.idw_detail.Find(lsFind,1,  w_owner_change.idw_detail.RowCount())

                If llFindRow > 0 Then 
                          lsPalletId =  w_owner_change.idw_detail.GetITemString(llFindRow,'po_no2' )
                Else
                                
				  // Check if the value scanned is a serial Number 
				  Select Min(Po_No2) into :lsPalletId
				  From Serial_Number_Inventory
				  Where Project_id = 'PANDORA' and Serial_No = :asScan;
				  
				 	  
				  If lsPalletId ='' OR IsNull(lsPalletId)  then //Error - Scanned value not found 

										MessageBox('Invalid Scan', 'Scanned Value " '+ asScan + '" was not associated with a Pallet on the SOC Serial Numbers.~r~nPlease correct SOC Serial Number and re-scan or scan a different code'  )
										Return -1

				  Else//Pallet found, now, make sure it was actually picked

							llFindRow =  w_owner_change.idw_detail.Find( "Upper(po_no2) = '" + Upper(lsPalletID) + "'",1,  w_owner_change.idw_detail.RowCount())
							If llFindRow <= 0 Then //Error - Wrong value scanned
												 MessageBox('Invalid Scan', "Scanned Value '" + asScan + "' was not associated with a Pallet on the SOC Serial Numbers.~r~nPlease correct SOC Serial Number and re-scan or scan a different code" )
												 Return -1
							Else
												 lsPalletId = w_owner_change.idw_detail.GetITemString(llFindRow,'po_no2' )
							End If //Wrong value scanned
				  End If // Pallet Found
               End If //Container
End If //Pallet
                             							  
									  						 

string ls_whcode, ls_error,ls_serialNo 

integer ll_index, li_line_item_no, liDetLineItemNo, liRows


////2.        Retrieve the Serial Numbers for that Pallet ID into a data store 

//ldSNRowCount = ldw_serial.retrieve('PANDORA', lsPalletId)
//If ldSNRowCount <= 0 Then 
//                MessageBox('Invalid Scan', "PALLET ID Cannot be found in the Serial Inventory Table." )
//                Return -1
//End If

ls_whcode = w_owner_change.idw_main.getItemString(1, 's_warehouse')

//Serial No records
sql_syntax =" select * from Serial_Number_Inventory with(nolock) where Project_Id = '"+ gs_project+"'"
sql_syntax +=" and wh_code ='"+ ls_whcode+"'" 
sql_syntax += " and po_no2 = '"+ lsPalletId + "'"

lds_serial.create( SQLCA.syntaxfromsql( sql_syntax, "", ls_error))
lds_serial.settransobject( SQLCA)
lds_serial.retrieve( )

//3.       Check the found Skus. 

	ldQty = 0

If lds_serial.RowCount() > 0 then 
	 
	
	for ll_Index = 1 to  w_owner_change.idw_detail.RowCount()
		
		If  w_owner_change.idw_detail.GetItemString (ll_Index, "po_no2") = lsPalletId then
			
			ldQty = ldQty + w_owner_change.idw_detail.GetITemNumber (ll_Index, "quantity") 
			liDetLineItemNo = w_owner_change.idw_detail.GetITemNumber (ll_Index, "line_item_no")
			ls_SKU = w_owner_change.idw_detail.GetItemString(ll_Index, "sku")		
			
		End If
		
	next 
	
	If lds_serial.RowCount() =  ldQty and lds_serial.RowCount() = ldQty Then

		lsFind ="sku_parent  = '"+ls_Sku+"'  and to_line_item_no ="+ string(liDetLineItemNo) + " and c_select_ind <> 'Y'"
		llSOCRows = w_owner_change.idw_serial.RowCount()
		liRows = lds_serial.RowCount()

		for ll_Index = 1 to  liRows
			llFindRow = dw_soc_serial.find( lsFind, 1, llSOCRows )
					
			IF llFindRow > 0 THEN
				dw_soc_serial.setItem( llFindRow, 'c_select_ind', 'Y')
				dw_soc_serial.setItem( llFindRow, 'serial_no_parent', lds_serial.GetItemString( ll_index, 'serial_no') )
			END IF
		next 

Else
		
		MessageBox('Scan Error"', "The SOC Serial_Number Scan only allowes full pallets." )
		Return -1
		
	End If

Else
	
	 MessageBox('Invalid Scan', "PALLET ID Cannot be found in the Serial Inventory Table." )
	Return -1
	
End If

Return 0

end function

on w_owner_serial_numbers.create
int iCurrent
call super::create
this.dw_soc_serial=create dw_soc_serial
this.sle_serial=create sle_serial
this.cb_select=create cb_select
this.cb_clear=create cb_clear
this.st_text=create st_text
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_soc_serial
this.Control[iCurrent+2]=this.sle_serial
this.Control[iCurrent+3]=this.cb_select
this.Control[iCurrent+4]=this.cb_clear
this.Control[iCurrent+5]=this.st_text
end on

on w_owner_serial_numbers.destroy
call super::destroy
destroy(this.dw_soc_serial)
destroy(this.sle_serial)
destroy(this.cb_select)
destroy(this.cb_clear)
destroy(this.st_text)
end on

event closequery;call super::closequery;//update serial No values into respective serial No records (Parent)

string ls_parent_sku, ls_find, ls_serial_parent
long 	ll_row, ll_line_item_no, ll_find_row, ll_row_count, ll_serial_count


ll_row_count = dw_soc_serial.rowcount( )
ll_serial_count = w_owner_change.idw_serial.rowcount()

FOR ll_row =1 to dw_soc_serial.rowcount( )
	
	ls_parent_sku = dw_soc_serial.getItemString(ll_row, 'sku_parent')
	ll_line_item_no = dw_soc_serial.getItemNumber(ll_row, 'to_line_item_no')
	
	ls_serial_parent = dw_soc_serial.getItemString(ll_row, 'serial_no_parent')
		
	ls_find ="sku_parent ='"+ls_parent_sku+"' and to_line_item_no ="+string(ll_line_item_no)+" and serial_no_parent ='-'"
	
	ll_find_row = w_owner_change.idw_serial.find(ls_find, 1, ll_serial_count)
	
	w_owner_change.idw_serial.setItem(ll_find_row, 'serial_no_parent', ls_serial_parent)
	w_owner_change.idw_serial.setItem(ll_find_row, 'serial_no_child', ls_serial_parent)	
	
NEXT	


end event

event ue_postopen;call super::ue_postopen;//01-Nov-2017 :Madhu PEVS-654 - 2D Barcode for Pandora

string ls_tono

dw_soc_serial.settransobject( SQLCA)	
dw_soc_serial.reset()

ls_tono =w_owner_change.idw_main.getItemString(1,'to_no')
dw_soc_serial.retrieve( ls_tono)

sle_serial.setfocus( )
end event

type cb_cancel from w_response_ancestor`cb_cancel within w_owner_serial_numbers
integer y = 1917
end type

type cb_ok from w_response_ancestor`cb_ok within w_owner_serial_numbers
integer y = 1917
end type

type dw_soc_serial from datawindow within w_owner_serial_numbers
integer x = 55
integer y = 381
integer width = 2074
integer height = 1376
integer taborder = 10
boolean bringtotop = true
string title = "Scan SOC Serial No"
string dataobject = "d_do_soc_serial_tono"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type sle_serial from singlelineedit within w_owner_serial_numbers
integer x = 40
integer y = 96
integer width = 1818
integer height = 83
integer taborder = 10
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
end type

event modified;//01-Nov-2017 :Madhu PEVS-654 2D Barcode for Pandora.

long ll_serial_count, ll_row,ll_Index, ll_find_row,ll_serial_find_row, ll_detail_find_row, ll_line_item_no
long ll_find_detail_row, ll_owner_id, ll_content_owner_id, ll_serial_find

string ls_sku_list[], ls_sku, ls_prev_sku, ls_formatted_skus, ls_serialNo, ls_whcode, ls_find
String sql_syntax, ls_error, ls_from_loc, ls_from_project, ls_tono, ls_owner_cd, ls_serial_sku

Boolean lbFootprint
String ls_SerializedInd, ls_PONO2ControlledInd, ls_ContainerTrackingInd, ls_supplier

Str_Parms ls_str_parms



//MEA 2018/02 - S14383
//SIMS-F5726 - Footprint Logic - Validation to allow only full pallet for Pandora

//10SEPT-2018 :MEA S23046 F9270 - I1304 - Google - SIMS Footprints Containerization - Outbound
//Use Foot_Prints_Ind Flag

FOR ll_row = 1 to w_owner_change.idw_detail.rowcount()

	 ls_sku = w_owner_change.idw_detail.Object.sku[ll_row]
	 ls_supplier =  w_owner_change.idw_detail.Object.supp_code[ll_row]
	
	If f_is_sku_foot_print(ls_sku, ls_supplier) Then
		
		 lbFootprint = True
	End if

NEXT


//MA 2018/01 - Footprint - Override existing LPN validation and call new validation
If lbFootprint = True Then
	
	 //get Scanned Values
	
	 uf_do_scan_Pandora_Ip(sle_serial.Text)
	 
	 Return
End If



Datastore lds_serial
lds_serial = CREATE Datastore

ls_whcode = w_owner_change.idw_main.getItemString(1, 's_warehouse')

//get all SKU's from Detail.
FOR ll_row = 1 to w_owner_change.idw_detail.rowcount()
	 ls_sku = w_owner_change.idw_detail.Object.sku[ll_row]
	 
	 If ls_sku <> ls_prev_sku Then
		 ls_sku_list[ UpperBound(ls_sku_list) + 1 ] = ls_sku //don't store duplicate SKU's
	End If
	
	ls_prev_sku =ls_sku //store current Sku value into previous sku
NEXT

ls_formatted_skus = i_string_util.of_format_string( ls_sku_list, n_string_util.FORMAT1 ) //get formatted SKU's separated by comma.

//Serial No records
sql_syntax =" select * from Serial_Number_Inventory with(nolock) where Project_Id = '"+ gs_project+"'"
sql_syntax += " and sku in ("+ ls_formatted_skus +") "
sql_syntax +=" and wh_code ='"+ ls_whcode+"'"

lds_serial.create( SQLCA.syntaxfromsql( sql_syntax, "", ls_error))
lds_serial.settransobject( SQLCA)
lds_serial.retrieve( )

 //get Scanned Serial No's.
ls_str_parms = i_nwarehouse.of_parse_2d_barcode( sle_serial.Text)

FOR ll_Index =1 to UPPERBOUND(ls_str_parms.string_arg)
		
		ls_serialNo = ls_str_parms.string_arg[ll_Index] //get Serial No.
		
		//Find Serial No
		ls_find ="serial_no ='"+ls_serialNo+"'"
		ll_find_row = lds_serial.find( ls_find, 1, lds_serial.rowcount())
		
		IF ll_find_row > 0 THEN
			ls_serial_sku = lds_serial.getItemString(ll_find_row, 'sku')
			
			//find record in un-scanned Serial No List
			ls_find ="sku_parent ='"+ls_serial_sku+"' and (c_select_ind ='N' or IsNull(c_select_ind) or c_select_ind='' or c_select_ind=' ') "
			ll_serial_find_row = dw_soc_serial.find( ls_find, 1, dw_soc_serial.rowcount())
			
			ll_line_item_no = dw_soc_serial.getItemNumber( ll_serial_find_row, 'to_line_item_no')
			
			//find detail record
			ls_find = "sku = '" + ls_serial_sku + "' and line_item_no = " + string(ll_line_item_no)
			ll_find_detail_row = w_owner_change.idw_detail.find(ls_find, 1, w_owner_change.idw_detail.RowCount())
			
			// Ensure user does not enter duplicate serial numbers in the Parent Serial Number list
			if dw_soc_serial.Find ( "serial_no_parent = '" + ls_serialNo + "'", 1, dw_soc_serial.RowCount()) > 0 then
				w_owner_change.ib_display_unique_item_error_message = true
				MessageBox("Serial Number Entry Error", "Serial number (" + ls_serialNo + ") already exists in Parent Serial Number list!  "  + &
											"~r~nPlease enter a unique serial number.", StopSign!)
				//sle_serial.SelectText(1, Len(sle_serial.GetText()))
				return 1
			end if
			
			ll_owner_id = w_owner_change.idw_detail.GetItemNumber(ll_find_detail_row, "owner_id")
			ls_from_loc = w_owner_change.idw_detail.GetItemString(ll_find_detail_row, "s_location")
			ls_from_project = w_owner_change.idw_detail.GetItemString(ll_find_detail_row, "po_no")
			ls_tono = w_owner_change.idw_detail.GetItemString(ll_find_detail_row, "to_no")
			
			If upper(ls_from_project) <> 'MAIN'  and w_owner_change.ibSingleProjectTurnedOn Then
				ls_find ="sku ='"+ls_serial_sku+"' and Owner_Id ="+string(ll_owner_id)+" and po_no='"+ls_from_project+"' and l_code ='"+ls_from_loc+"' and serial_no='"+ls_serialNo+"'"
			else
				ls_find ="sku ='"+ls_serial_sku+"' and Owner_Id ="+string(ll_owner_id)+" and po_no='"+ls_from_project+"' and serial_no='"+ls_serialNo+"'"
			End If
			
			ll_serial_find = lds_serial.find(ls_find, 1, lds_serial.rowcount( ))
			ls_owner_cd = lds_serial.getItemString(ll_serial_find ,'owner_cd')		
	
			If trim(ls_owner_cd) ="" Then
				
				If upper(ls_from_project) <> 'MAIN'  and w_owner_change.ibSingleProjectTurnedOn Then
					SELECT owner_id 	INTO :ll_content_owner_id
					FROM Content with(nolock)
					WHERE project_id = :gs_project AND sku = :ls_serial_sku AND owner_id = :ll_owner_id
					and po_no = :ls_from_project	and l_code =:ls_from_loc AND serial_no = :ls_serialNo
					using sqlca;
				else
					SELECT owner_id 	INTO :ll_content_owner_id
					FROM Content with(nolock)
					WHERE project_id = :gs_project AND sku = :ls_serial_sku AND owner_id = :ll_owner_id
					and po_no = :ls_from_project	AND serial_no = :ls_serialNo
					using sqlca;				
				End If
				
				If ll_content_owner_id = 0 Then return 1
				
			End If
			
			//update Serial No
			dw_soc_serial.setItem( ll_serial_find_row, 'c_select_ind', 'Y')
			dw_soc_serial.setItem( ll_serial_find_row, 'serial_no_parent', ls_serialNo)
			dw_soc_serial.setItem( ll_serial_find_row, 'serial_no_child', ls_serialNo)
			
		END IF		
NEXT

destroy lds_serial
sle_serial.Text ='' //clear text
end event

event constructor;i_nwarehouse = CREATE n_warehouse
i_string_util = CREATE n_string_util
end event

type cb_select from commandbutton within w_owner_serial_numbers
integer x = 55
integer y = 272
integer width = 307
integer height = 93
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Select All"
end type

event clicked;//select all records
long ll_row

For ll_row =1 to dw_soc_serial.rowcount()
		dw_soc_serial.setItem( ll_row, 'c_select_ind', 'Y')
Next
		
end event

type cb_clear from commandbutton within w_owner_serial_numbers
integer x = 366
integer y = 272
integer width = 307
integer height = 93
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Clear All"
end type

event clicked;//un-select all records
long ll_row

For ll_row =1 to dw_soc_serial.rowcount()
		dw_soc_serial.setItem( ll_row, 'c_select_ind', 'N')
Next
		
end event

type st_text from statictext within w_owner_serial_numbers
integer x = 40
integer y = 202
integer width = 1430
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 134217857
long backcolor = 67108864
string text = "Scan 2D Barcode or type a serial number to check a box."
alignment alignment = center!
boolean focusrectangle = false
end type

