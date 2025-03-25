$PBExportHeader$w_tran_serial_numbers.srw
$PBExportComments$Serial Numbers associated with Stock Transfer
forward
global type w_tran_serial_numbers from w_response_ancestor
end type
type dw_serial from u_dw_ancestor within w_tran_serial_numbers
end type
type sle_serial from singlelineedit within w_tran_serial_numbers
end type
type st_1 from statictext within w_tran_serial_numbers
end type
type cb_select_all from commandbutton within w_tran_serial_numbers
end type
type cb_clear_all from commandbutton within w_tran_serial_numbers
end type
type st_2 from statictext within w_tran_serial_numbers
end type
type st_3 from statictext within w_tran_serial_numbers
end type
type st_serial_req from statictext within w_tran_serial_numbers
end type
type st_serial_scanned from statictext within w_tran_serial_numbers
end type
type sle_pono2 from singlelineedit within w_tran_serial_numbers
end type
type sle_container_id from singlelineedit within w_tran_serial_numbers
end type
type st_pono2 from statictext within w_tran_serial_numbers
end type
type st_container from statictext within w_tran_serial_numbers
end type
type st_serial from statictext within w_tran_serial_numbers
end type
end forward

global type w_tran_serial_numbers from w_response_ancestor
integer width = 1947
integer height = 2280
string title = "Transfer Serial Numbers"
dw_serial dw_serial
sle_serial sle_serial
st_1 st_1
cb_select_all cb_select_all
cb_clear_all cb_clear_all
st_2 st_2
st_3 st_3
st_serial_req st_serial_req
st_serial_scanned st_serial_scanned
sle_pono2 sle_pono2
sle_container_id sle_container_id
st_pono2 st_pono2
st_container st_container
st_serial st_serial
end type
global w_tran_serial_numbers w_tran_serial_numbers

type prototypes

end prototypes

type variables
datastore		idsLocSummary, ids_serial

//10-Apr-2017 :Madhu PEVS-424 - Stock Transfer Serial No -START
n_warehouse i_nwarehouse
Boolean ibMouseClicked =FALSE
Boolean ibStartTimer =FALSE 
Boolean ibModified= FALSE
//10-Apr-2017 :Madhu PEVS-424 - Stock Transfer Serial No -END

end variables

forward prototypes
public subroutine dodisplaymessage (string _title, string _message)
public function datastore uf_get_serial_inventory_records (string as_sku, string as_wh, long al_owner_id)
public function integer uf_get_sku_tracked_by_validation ()
end prototypes

public subroutine dodisplaymessage (string _title, string _message);// doDisplayMessage( string _title, string _message )

str_parms	lstrParms


lstrParms.string_arg[1] = _title
lstrParms.string_arg[2] = _message

openwithparm( w_scan_message, lstrParms )


end subroutine

public function datastore uf_get_serial_inventory_records (string as_sku, string as_wh, long al_owner_id);//22-Jan-2018 :Madhu S15155- Foot Prints

string ls_sql_syntax, ls_errors
long ll_rows


ids_serial =create Datastore
ls_sql_syntax = " select * from  Serial_Number_Inventory with(nolock) "
ls_sql_syntax +=" where Project_Id ='"+gs_project+"' and sku ='"+as_sku+"'"
ls_sql_syntax +=" and wh_code ='"+as_wh+"' and Owner_Id ="+string(al_owner_Id)

ids_serial.Create(SQLCA.SyntaxFromSQL(ls_sql_syntax,"", ls_errors))

IF Len(ls_errors) > 0 THEN
	MessageBox("Errors", "Unable to create datastore to check Serail Number.~r~r" + ls_errors)
END IF

IF ids_serial.SetTransObject(SQLCA) <> 1 THEN
	MessageBox("Error","Error setting datastore's transaction object to check for Serial Number.")
END IF

ll_rows = ids_serial.retrieve()

Return ids_serial
end function

public function integer uf_get_sku_tracked_by_validation ();//22-Jan-2018 :Madhu S14389 - Foot Prints
//check any SKU is tracked by Serialized (B), PoNo2 (Y) and Container Id (Y)

string ls_sku, ls_supp, ls_prev_sku, lsFind
string	ls_serial_Ind, ls_pono2_Ind, ls_container_Ind
long ll_row, ll_count, ll_Item_count, llFindRow

ll_count = 0
i_nwarehouse.of_init( )

FOR ll_row =1 to w_tran.idw_detail.rowcount()
	ls_sku = w_tran.idw_detail.getItemString(ll_row, 'sku')
	ls_supp = w_tran.idw_detail.getItemString(ll_row, 'supp_code')
	
	IF ls_sku <> ls_prev_sku THEN
		ll_Item_count = i_nwarehouse.of_item_master( gs_project, ls_sku, ls_supp)
		lsFind ="Project_Id ='"+gs_project+"' and sku ='"+ls_sku+"' and UPPER(supp_code) ='"+UPPER(ls_supp)+"'"
		llFindRow = i_nwarehouse.ids.find( lsFind, 1, i_nwarehouse.ids.rowcount())
		
		ls_serial_Ind = i_nwarehouse.ids.getItemString(llFindRow, 'Serialized_Ind')
		ls_pono2_Ind = i_nwarehouse.ids.getItemString(llFindRow, 'PO_No2_Controlled_Ind')
		ls_container_Ind = i_nwarehouse.ids.getItemString(llFindRow, 'Container_Tracking_Ind')
		
		IF upper(ls_serial_Ind) ='B' and upper(ls_pono2_Ind) ='Y' and upper(ls_container_Ind) ='Y' THEN ll_count++
	END IF
	
	ls_prev_sku =ls_sku
NEXT

Return ll_count
end function

on w_tran_serial_numbers.create
int iCurrent
call super::create
this.dw_serial=create dw_serial
this.sle_serial=create sle_serial
this.st_1=create st_1
this.cb_select_all=create cb_select_all
this.cb_clear_all=create cb_clear_all
this.st_2=create st_2
this.st_3=create st_3
this.st_serial_req=create st_serial_req
this.st_serial_scanned=create st_serial_scanned
this.sle_pono2=create sle_pono2
this.sle_container_id=create sle_container_id
this.st_pono2=create st_pono2
this.st_container=create st_container
this.st_serial=create st_serial
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_serial
this.Control[iCurrent+2]=this.sle_serial
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.cb_select_all
this.Control[iCurrent+5]=this.cb_clear_all
this.Control[iCurrent+6]=this.st_2
this.Control[iCurrent+7]=this.st_3
this.Control[iCurrent+8]=this.st_serial_req
this.Control[iCurrent+9]=this.st_serial_scanned
this.Control[iCurrent+10]=this.sle_pono2
this.Control[iCurrent+11]=this.sle_container_id
this.Control[iCurrent+12]=this.st_pono2
this.Control[iCurrent+13]=this.st_container
this.Control[iCurrent+14]=this.st_serial
end on

on w_tran_serial_numbers.destroy
call super::destroy
destroy(this.dw_serial)
destroy(this.sle_serial)
destroy(this.st_1)
destroy(this.cb_select_all)
destroy(this.cb_clear_all)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.st_serial_req)
destroy(this.st_serial_scanned)
destroy(this.sle_pono2)
destroy(this.sle_container_id)
destroy(this.st_pono2)
destroy(this.st_container)
destroy(this.st_serial)
end on

event ue_postopen;call super::ue_postopen;
String	lsTONO, sql_syntax, errors, lsFind, lsordStatus
long	llReqQty, llRowPOs, llRowCount, llFindRow ,llRowQty, llExistSkuCount
Datastore	ldsTransferSerial
Boolean lb_load_serials_from_locations = TRUE

i_nwarehouse = Create n_warehouse  //04-APR-2017 :Madhu -PEVS-424 - Stock Transfer Serial No

//22-Jan-2018 :Madhu S15155 - Foot Prints -START
If upper(gs_project) ='PANDORA' and uf_get_sku_tracked_by_validation() > 0 Then
	st_pono2.visible =true
	sle_pono2.visible =true
	st_container.visible =true
	sle_container_id.visible =true
	sle_pono2.setfocus( )

	dw_serial.Modify("po_no2.visible=true  po_no2_t.visible=true")
	dw_serial.Modify("carton_id.visible=true  carton_id_t.visible=true")
else
	st_pono2.visible =false
	sle_pono2.visible =false
	st_container.visible =false
	sle_container_id.visible =false
	sle_serial.SetFocus()
	
	dw_serial.Modify("po_no2.visible=false  po_no2_t.visible=false")
	dw_serial.Modify("carton_id.visible=false  carton_id_t.visible=false")
End If
//22-Jan-2018 :Madhu S15155 - Foot Prints -END

lsTONO = w_tran.idw_Main.GetITemString(1,'to_no')
lsOrdStatus = w_tran.idw_main.GetITemString(1,'ord_status')

dw_Serial.SetRedraw(False)

// LTK 20160107  Pandora #1002  Don't automatically load serials from Transfer Detail "from locations" unless user
// is super duper and they request it via the MessageBox
if gs_project = 'PANDORA' then
	lb_load_serials_from_locations = FALSE
	if gs_role = '-1' then
		if MessageBox(this.title, "Do you wish to load serials from Transfer Detail 'From Locations'?", QUESTION!, YESNO!) = 1 then
			lb_load_serials_from_locations = TRUE
		end if
	end if
end if

if lb_load_serials_from_locations then
	dw_Serial.Retrieve(lsTONO)
end if

//Load any existing ones (check the boxes)
ldsTransferSerial = Create DataStore
sql_syntax = "SELECT *  from transfer_Serial_Detail " 
sql_syntax += " where to_no = '" + lstono + "'" 
ldsTransferSerial.Create(SQLCA.SyntaxFromSQL(sql_syntax,"", ERRORS))
ldsTransferSerial.SetTransObject(SQLCA)
ldsTransferSerial.Retrieve()

llRowCount = ldsTransferSerial.RowCount()
For llRowPOs = 1 to llRowCount
	
	lsFind = "upper(sku) = '" + upper(ldsTransferSerial.GetITEmString(llRowPos,'sku')) + "' and upper(serial_no) = '" + upper(ldsTransferSerial.GetITEmString(llRowPos,'serial_no')) + "'"
	llFindROw = dw_Serial.Find(lsFind,1,dw_Serial.RowCount())
	If llFindRow > 0 Then
		dw_serial.SetITem(llFindRow,'c_select_ind','Y')
		dw_serial.SetITem(llFindRow,'to_loc', ldsTransferSerial.GetITEmString(llRowPos,'d_location'))
		dw_serial.SetItem(dw_serial.RowCount(), 'po_no2', ldsTransferSerial.getItemString(llRowPos, 'po_no2'))		//22-Jan-2018 :Madhu S15155 -Foot Prints
		dw_serial.SetItem(dw_serial.RowCount(), 'carton_id', ldsTransferSerial.getItemString(llRowPos, 'container_Id')) //22-Jan-2018 :Madhu S15155 -Foot Prints
	Else
		dw_Serial.InsertRow(0)
		dw_serial.SetITem(dw_serial.RowCount(),'c_select_ind','Y')
		dw_serial.SetITem(dw_serial.RowCount(),'to_loc', ldsTransferSerial.GetITEmString(llRowPos,'d_location'))
		dw_serial.SetITem(dw_serial.RowCount(),'sku', ldsTransferSerial.GetITEmString(llRowPos,'sku'))
		dw_serial.SetITem(dw_serial.RowCount(),'serial_no', ldsTransferSerial.GetITEmString(llRowPos,'serial_no'))
		dw_serial.SetItem(dw_serial.RowCount(), 'po_no2', ldsTransferSerial.getItemString(llRowPos, 'po_no2'))		//22-Jan-2018 :Madhu S15155 -Foot Prints
		dw_serial.SetItem(dw_serial.RowCount(), 'carton_id', ldsTransferSerial.getItemString(llRowPos, 'container_Id')) //22-Jan-2018 :Madhu S15155 -Foot Prints
	End If
	sle_pono2.text = ldsTransferSerial.getItemString(1, 'po_no2')
	sle_container_id.text = ldsTransferSerial.getItemString(1, 'container_Id')	
Next

dw_serial.Sort()

dw_Serial.SetRedraw(True)

//get a summary of SKU/Loc and Qty
//If Ord status is complete, we won;t allow updates

idsLocSummary = Create Datastore

If lsOrdStatus = 'C' Then
	
	dw_serial.Modify("c_select_ind.Protect=1 to_loc.protect=1")
	sle_serial.enabled = False
	st_1.text = ''
	
Else
	
	sql_syntax = "SELECT sku, po_no2, container_Id, d_location, sum(quantity) as required_Qty  from transfer_Detail " 
	sql_syntax += " where to_no = '" + lstono + "'" 
	sql_syntax += " and SKU in (select sku from item_MAster where project_id = '" + gs_project + "' and serialized_ind = 'B')"
	sql_syntax += " Group by sku, po_no2, container_Id, d_location"

	idsLocSummary.Create(SQLCA.SyntaxFromSQL(sql_syntax,"", ERRORS))
	idsLocSummary.SetTransObject(SQLCA)
	idsLocSummary.Retrieve()

	//Calculate the number of serial numbers required
	llReqQty = 0
	llRowCount = idsLocSummary.RowCount()
	For llRowPos = 1 to llRowCount
		llReqQty += idsLocSummary.GetITemNumber(llRowPos,'required_Qty')
	Next

	st_serial_req.Text = String(llReqQty)

	//03-APR-2017 :Madhu -PEVS-424 - Stock Transfer Serial No. - START	
	//Loop through Transfer Detail DS
	For llRowPos =1 to llRowCount
		
		//get SKU count, if already exists on Transfer Serial No Screen
		llExistSkuCount =0
		lsFind ="upper(sku)='"+idsLocSummary.getitemstring( llRowPos, 'sku')+"'"
		lsFind += " and po_no2 ='"+idsLocSummary.getitemstring( llRowPos, 'po_no2')+"'"
		lsFind += " and carton_id ='"+idsLocSummary.getitemstring( llRowPos, 'container_Id')+"'"
		llFindRow =dw_serial.find( lsFind, 1, dw_serial.rowcount())
		
		DO WHILE llFindRow > 0
			llExistSkuCount++
			llFindRow = dw_serial.find( lsFind, llFindRow+1, dw_serial.rowcount()+1)
		LOOP
		
		//create SN rows against QTY to know how many SN needs to be scanned.
		For llRowQty=1 to idsLocSummary.getitemnumber( llRowPos, 'required_Qty')
				
				If llRowQty > llExistSkuCount Then
					//If SN has already scanned, don't make another Insert row.
					dw_Serial.insertrow( 0)
					dw_Serial.setitem( dw_serial.RowCount(), 'sku',idsLocSummary.getitemstring( llRowPos, 'sku'))
					dw_Serial.setitem(dw_serial.RowCount(),'to_loc',idsLocSummary.getitemstring( llRowPos, 'd_location'))
					dw_Serial.setitem(dw_serial.RowCount(),'po_no2',idsLocSummary.getitemstring( llRowPos, 'po_no2'))
					dw_Serial.setitem(dw_serial.RowCount(),'carton_Id',idsLocSummary.getitemstring( llRowPos, 'container_Id'))
			End If
		Next

	Next
	//03-APR-2017 :Madhu -PEVS-424 - Stock Transfer Serial No. - END

	dw_serial.PostEvent('ue_count_checked')
	
End If

//Don;t allow updates if Transfer is complete
end event

event closequery;call super::closequery;
Long	llRowPos, llRowCount, llFindRow
Dec	ldReqQty, ldSelectedQty
String	lsFInd, lsTONO, lsSKU, lsSerial, lsLoc, lsOrdStatus, ls_po_no2, ls_carton_id
Boolean lb_is_pandora_single_project_location_rule_on	// LTK 20160105  Pandora #1002

lsOrdStatus = w_tran.idw_main.GetITemString(1,'ord_status')

If istrparms.cancelled or lsOrdStatus = 'C'  then REturn 0

lsTONO = w_tran.idw_Main.GetITemString(1,'to_no')

//Validate that locations are present and serial numbers allocated properly to all locations
llRowCount = dw_serial.RowCount()
For llRowPos = 1 to llRowCount
	
	If dw_serial.GetItemString(llRowPos,'c_select_ind') = 'Y' and (dw_Serial.GetITemString(llRowPos,'to_loc') = '' or isnull(dw_Serial.GetITemString(llRowPos,'to_loc'))) Then
		Messagebox(This.Title,'Selected Row must contain a valid Location',StopSign!)
		dw_serial.SetFocus()
		dw_Serial.ScrollToRow(llRowPos)
		dw_Serial.SetRow(llRowPos)
		dw_Serial.SetColumn('to_loc')
		REturn 1
	End If
	
Next

llRowCount = idsLocSummary.RowCount()
For llRowPos = 1 to llRowCount
	
	ldReqQty = idsLocSummary.GetITemDecimal(llRowPos,'required_qty')
	ldSelectedQty = 0
	
	lsFind = ("Upper(sku) = '" + upper(idsLocSummary.GetITEmString(llRowPos,'sku')) + "' and upper(to_loc) = '" + upper(idsLocSummary.GetITEmString(llRowPos,'d_location')) + "'")
	llFindRow = dw_serial.Find(lsFind,1,dw_Serial.RowCOunt())
	
	Do While llFindRow > 0
		
		//ldSelectedQty ++
		// LTK 20160111  Added the select indicator check in order to updated selected count
		if dw_serial.Object.c_select_ind[ llFindRow ] = 'Y' then
			ldSelectedQty ++
		end if
		llFindRow ++
		
		If llFindRow > dw_serial.RowCount() Then
			llFindRow = 0
		Else
			llFindRow = dw_serial.Find(lsFind,llFindRow,dw_Serial.RowCOunt())
		End If
		
	Loop
	
	//Madhu commented
//	If ldReqQty <> ldSelectedQty and ldSelectedQty > 0 Then
//		Messagebox(this.title,"SKU: " + idsLocSummary.GetITEmString(llRowPos,'sku') + " / Location: " + idsLocSummary.GetITEmString(llRowPos,'d_location') + " ~r Required Qty = " + String(ldReqQty) + ", selected Qty = " + String(ldselectedQty),StopSign!) 
//		Return 1
//	End If
	
NExt

if gs_project = 'PANDORA' then
	lb_is_pandora_single_project_location_rule_on = ( f_retrieve_parm("PANDORA", "FLAG", "SOC_SERIAL_GPN_TRACK_ON") = 'Y' )
end if

//Create Transfer_Serial_Detail records for checked rows
Execute Immediate "Begin Transaction" using SQLCA; 

Delete from Transfer_Serial_Detail where to_no = :lsTONO;

llRowCOunt = dw_Serial.RowCOunt()
For llRowPos = 1 to llRowCount
	
	If dw_Serial.GetITEmString(llRowPos,'c_select_ind') = 'Y' Then
		
		lsSKU = dw_serial.GetITemString(llRowPos,'SKU')
		lsLoc = dw_serial.GetITEmString(llRowPos,'to_loc')
		lsSerial = dw_serial.GetITEmString(llRowPos,'serial_no')
		ls_po_no2 = dw_serial.GetItemString(llRowPos,'po_no2')
		ls_carton_id =dw_serial.GetItemString(llRowPos,'carton_id')
		
	
		Insert into Transfer_Serial_Detail (to_no, sku, serial_no, d_Location, Po_No2, Container_Id)
		Values (:lsTONO, :lsSKU, :lsSerial, :lsLoc, :ls_po_no2, :ls_carton_id)
		Using SQLCA;
		
		IF Sqlca.Sqlcode <>  0 THEN
			Execute Immediate "ROLLBACK" using SQLCA;
			MessageBox(this.title, SQLCA.SQLErrText)
			return 1
		End If
		
		// LTK 20151217  Pandora #1002 added Pandora block to validate single project (po_no) location rule (if appropriate)
		if gs_project = 'PANDORA' and lb_is_pandora_single_project_location_rule_on then

			// LTK 20160105  Pandora #1002 updating last update date/user per Dave
			DateTime ldt_wh_time
			String ls_wh_code
			ls_wh_code = w_tran.idw_Main.GetITemString(1,'s_warehouse')
			if Len( ls_wh_code ) > 0 then
				ldt_wh_time = f_getLocalWorldTime( ls_wh_code ) 

				UPDATE 	Serial_Number_Inventory
				SET 		Update_Date = :ldt_wh_time, Update_User = :gs_userid
				WHERE 	Project_Id = :gs_project
				AND 		SKU = :lsSKU
				AND		Serial_No = :lsSerial
				USING	SQLCA;
			end if
		end if
	End If

Next

Execute Immediate "COMMIT" using SQLCA;
end event

event timer;call super::timer;//10-Apr-2017 :Madhu PEVS-424 - Stock Transfer Serial No
timer(0)
ibModified =TRUE
MessageBox("Manual Entry", "Sorry! Manual Entry Option is Disabled!. ~r~r~nYou should have F10 access for Manual Entry", Stopsign!)
sle_serial.text=''
end event

type cb_cancel from w_response_ancestor`cb_cancel within w_tran_serial_numbers
integer x = 1106
integer y = 2072
integer taborder = 80
end type

type cb_ok from w_response_ancestor`cb_ok within w_tran_serial_numbers
integer x = 507
integer y = 2072
boolean default = false
end type

type dw_serial from u_dw_ancestor within w_tran_serial_numbers
event ue_count_checked ( )
event ue_set_locations ( )
integer x = 55
integer y = 664
integer width = 1842
integer height = 1376
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_tran_Serial_Detail"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event ue_count_checked();long	llCheckedCount, i, llCount

llCheckedCount = 0
llCount = dw_serial.RowCount()

This.AcceptText()

For i = 1 to llCount
	If This.GetITEmString(i,'c_select_ind') = 'Y' Then
		llCheckedCount ++
	End If
Next


st_serial_scanned.Text = String(llCheckedCount)

//03-APR-2017 :Madhu -PEVS-424 - Stock Transfer Serial No. - Enable OK button for Pandora
If upper(gs_project) ='PANDORA' Then
	cb_ok.enabled =True
else
	If Long(st_serial_scanned.Text) = Long(st_serial_req.Text) Then
		cb_ok.enabled = True
	Else
		cb_ok.enabled = False
	End If
	
End If

end event

event ue_set_locations();
DatawindowChild	ldWC
Long	llRow, i
String	lsSKU

//If only one location in transfer detail for SKU, set it . Otherwise populate dropdown with valid locations (To Loc on Transfer Detail)
llRow = This.GetRow()
lsSKU = This.GetItemString(llRow,'sku')

idsLocSummary.SetFilter("upper(sku) = '" + upper(lsSKU) + "'")
idsLocSummary.Filter()

This.GetChild('to_loc',ldwc)
ldwc.Reset()
		
For i = 1 to idsLocSummary.RowCount()
			
	ldwc.InsertRow(0)
	ldwc.SetITem(ldwc.RowCount(),'l_code',idsLocSummary.GetITemString(i,'d_location'))
	
Next
	
If this.GetItemString(llRow,'c_select_ind') = 'Y' Then
	
	If ldwc.RowCOunt() = 1 Then
		This.SetITem(llRow,'to_loc',ldwc.GetITemString(1,'l_code'))
	ElseIf idsLocSummary.RowCOunt() > 1 Then
		This.SetColumn('to_loc')
	End If
	
End If

idsLocSummary.SetFilter("")
idsLocSummary.Filter()
end event

event itemchanged;call super::itemchanged;

If Upper(dwo.name) = 'C_SELECT_IND' Then
	
	//TODO load location dropdown from Transfer Detail records
	
	this.PostEvent('ue_count_checked')
	this.PostEvent('ue_set_locations')
	
elseIf Upper(dwo.name) = 'TO_LOC' Then
	
	If idsLocSummary.Find("Upper(SKU) = '" + Upper(this.GetITemString(row,'SKU')) + "' and Upper(d_Location) = '" + upper(Trim(data)) + "'",1,idsLocSummary.RowCount()) < 1 Then
		MessageBox(this.Title,"Invalid To Location",StopSign!)
		Return 1
	End If
	
End If

end event

event itemerror;call super::itemerror;return 1
end event

event itemfocuschanged;call super::itemfocuschanged;If isvalid(dwo) Then
	If DWO.Name = 'to_loc' Then
		this.triggerEvent('ue_set_locations')
	End If
End If
end event

type sle_serial from singlelineedit within w_tran_serial_numbers
event ue_mouseclick pbm_rbuttondown
event ue_keydown pbm_keydown
event ue_edit_change pbm_enchange
integer x = 439
integer y = 292
integer width = 1193
integer height = 84
integer taborder = 50
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

event ue_mouseclick;//10-Apr-2017 :Madhu PEVS-424 - Stock Transfer Serial No
If gbPressKeySNScanTransfers ='Y' THEN
	CHOOSE CASE gs_role
		CASE '1','2'
			IF Upper(gs_project)='PANDORA'  and f_retrieve_parm('PANDORA', 'F10_AUTHORIZE', gs_userid, 'USER_UPDATEABLE_IND')  <> 'Y' THEN
				ibMouseClicked =FALSE
				MessageBox("Mouse Click","Sorry! Right Mouse Click (RMC) Option is Disabled!. ~r~r~nYou should have F10 access to do RMC", Stopsign!)
			ELSE 
				ibMouseClicked =TRUE
			END IF
	END CHOOSE
END IF

return 0
end event

event ue_keydown;//10-Apr-2017 :Madhu PEVS-424 - Stock Transfer Serial No

If gbPressKeySNScanTransfers ='Y'  THEN
	
	//user access role
	CHOOSE CASE gs_role
		CASE '1','2'
		
		//If User doesn't have F10 access - Don't allow Manual entry
		IF Upper(gs_project)='PANDORA' and f_retrieve_parm('PANDORA', 'F10_AUTHORIZE', gs_userid,'USER_UPDATEABLE_IND')  <> 'Y' THEN
		
			//capture Key's
			CHOOSE CASE key
				CASE KeyEnter!
					timer(0)
					ibStartTimer =TRUE //don't start timer
				
				CASE KeyControl!, KeyInsert! //copy+paste is not Allowed and don't use KeyShift!
					timer(0)
					MessageBox("Manual Entry", "Sorry! Manual Entry Option is Disabled!. ~r~r~nYou should have F10 access for Manual Entry", Stopsign!)
					sle_serial.text=''
					ibStartTimer =TRUE //don't start timer
			END CHOOSE
			
			//start timer, if not already started
			If ibStartTimer =FALSE THEN
				timer(0.3)
			else
				ibStartTimer =TRUE
			End If
		
		ELSE
			//reset all values
			ibStartTimer =TRUE
			ibMouseClicked =TRUE
			ibModified =FALSE
		END IF
	END CHOOSE

END IF
end event

event ue_edit_change;//10-Apr-2017 :Madhu PEVS-424 - Stock Transfer Serial No
//It fires for each input value of sle_serial field and start timer only for 1st entry.

If len(this.text) =1 then
	ibStartTimer =FALSE
else
	ibStartTimer =TRUE
end if

end event

event modified;
String	lsSerial, lsFind, lsTONO, lsSKU, lsWarehouse, lsSuppcode, ls_return
Long	llFindRow, llNewRow, i, ll_rows, ll_found_row, ll_Index
DatawindowChild	ldwc
String ls_toloc, ls_suppcode, lsmodifiedSN, lsreturnedSN, ls_formatted_gpns, ls_sql_syntax, ERRORS, ls_find
String lsa_gpns[], ls_stripoff_checked
boolean lbstripoff =FALSE
Str_Parms ls_str_parms

Datastore lds_serial
n_string_util ln_string_util


//10-Apr-2017 :Madhu PEVS-424 - Stock Transfer Serial No -START
//Don't trigger Modified() event when error message is prompted and re-set modified value
IF ibModified=FALSE THEN
	timer(0) //stop timer

	//31-Oct-2017 :Madhu PEVS-654 2D Barcode for Pandora
	ls_str_parms = i_nwarehouse.of_parse_2d_barcode( This.Text)
	FOR ll_Index =1 to UPPERBOUND(ls_str_parms.string_arg)
		
		//If scanned serial number found, check the box, If not found and is a valid serial Number, insert a row and check
		//lsSerial = This.Text
		lsSerial = ls_str_parms.string_arg[ll_Index]
		this.text = ls_str_parms.string_arg[ll_Index]
		
		lsFind = "Upper(Serial_No) = '" + upper(lsSerial) + "'"
		llFindRow = dw_Serial.Find(lsFind,1,dw_serial.rowcount())
		
		If llFindRow > 0 Then
			dw_serial.SetItem(llFindRow,'c_select_ind','Y')
			dw_serial.ScrolltoRow(llFindRow)
			dw_serial.SetRow(llFindRow)
			This.SelectText(1, len(this.Text))
			
			lsSKU = dw_serial.GetItemString(llFindROw,'SKU')
			idsLocSummary.SetFilter("upper(sku) = '" + upper(lsSKU) + "'")
			idsLocSummary.Filter()
			
			If idsLocSummary.RowCOunt() = 1 Then
				dw_serial.SetITem(llFindRow,'to_loc',idsLocSummary.GetITemString(1,'d_location'))
			ElseIf idsLocSummary.RowCOunt() > 1 Then
				dw_serial.GetChild('to_loc',ldwc)
				ldwc.Reset()
				
				For i = 1 to idsLocSummary.RowCount()
					ldwc.InsertRow(0)
					ldwc.SetITem(ldwc.RowCount(),'l_code',idsLocSummary.GetITemString(i,'d_location'))
				Next
				
				dw_serial.SetColumn('to_loc')
				dw_serial.TriggerEvent('clicked')
			End If
		
		Else
		
			lsTONO = w_tran.idw_Main.GetITemString(1,'to_no')
			lsWarehouse = w_tran.idw_Main.GetITemString(1,'s_warehouse')
			
			//09-JUNE-2017 Madhu -PEVS-554 Look for StripOff validation is enabled/disabled for SKU -START
			lds_serial = CREATE Datastore
			ln_string_util = CREATE n_string_util
			
			FOR i = 1 to w_tran.idw_detail.RowCount()
				IF w_tran.idw_detail.Object.Serialized_Ind[i] = 'B' or w_tran.idw_detail.Object.Serialized_Ind[i] = 'O' or w_tran.idw_detail.Object.Serialized_Ind[i] = 'Y' THEN
					lsa_gpns[ UpperBound(lsa_gpns) + 1 ] = w_tran.idw_detail.Object.SKU[i]
				END IF
			NEXT
			
			ls_formatted_gpns = ln_string_util.of_format_string( lsa_gpns, n_string_util.FORMAT1 )
			//09-JUNE-2017 Madhu - PEVS-554Look for StripOff validation is enabled/disabled for SKU -END
			
			IF gs_project = 'PANDORA' and f_retrieve_parm("PANDORA", "FLAG", "SOC_SERIAL_GPN_TRACK_ON") = 'Y'  THEN
			
			// First retrieve serial number (which could be for any serialized GPN in the Transfer Detail list)
			ls_sql_syntax = "SELECT * FROM SERIAL_NUMBER_INVENTORY WHERE PROJECT_ID = '" + gs_project + "' AND SERIAL_NO = '" + lsSerial + "' AND SKU in ( " + ls_formatted_gpns + " ) "
			
			lds_serial.Create(SQLCA.SyntaxFromSQL(ls_sql_syntax,"", ERRORS))
			if Len(ERRORS) > 0 then
				MessageBox("Errors", "Unable to create datastore to check Serail Number.~r~r" + Errors)
				return
			end if
			
			if lds_serial.SetTransObject(SQLCA) <> 1 then
				MessageBox("Error","Error setting datastore's transaction object to check for Serial Number.")
				return
			end if
			
			ll_rows = lds_serial.retrieve()
			
			IF ll_rows = 0 THEN
				// Serial number was not found in Serial_Number_Inventory, attempt to find serial number in Content
				ls_sql_syntax = "SELECT * FROM CONTENT WHERE PROJECT_ID = '" + gs_project + "' AND SERIAL_NO = '" + lsSerial + "' AND SKU in ( " + ls_formatted_gpns + " ) "
				
				lds_serial.Create(SQLCA.SyntaxFromSQL(ls_sql_syntax,"", ERRORS))
				if Len(ERRORS) > 0 then
					MessageBox("Errors", "Unable to create Content datastore to check Serail Number.~r~r" + Errors)
					return
				end if
				
				if lds_serial.SetTransObject(SQLCA) <> 1 then
					MessageBox("Error","Error setting Content datastore's transaction object to check for Serial Number.")
					return
				end if
				
				ll_rows = lds_serial.retrieve()
			END IF
			
			//09-JUNE-2017 Madhu -PEVS-554 Look for StripOff validation is enabled/disabled for SKU -START
			//strip off 1st char and re-validate
			IF ll_rows =0 THEN
				ls_sql_syntax = "SELECT * FROM SERIAL_NUMBER_INVENTORY WHERE PROJECT_ID = '" + gs_project + "' AND SERIAL_NO = '" + Right(lsSerial ,len(lsSerial) -1) + "' AND SKU in ( " + ls_formatted_gpns + " ) "
				
				lds_serial.Create(SQLCA.SyntaxFromSQL(ls_sql_syntax,"", ERRORS))
				if Len(ERRORS) > 0 then
					MessageBox("Errors", "Unable to create datastore to check Serail Number.~r~r" + Errors)
					return
				end if
				
				if lds_serial.SetTransObject(SQLCA) <> 1 then
					MessageBox("Error","Error setting datastore's transaction object to check for Serial Number.")
					return
				end if
				ll_rows = lds_serial.retrieve()
				
				If ll_rows > 0 Then 
					lbstripoff =TRUE //set boolean value and assume, stripoff 1st char of SN
					lsmodifiedSN = Right(lsSerial ,len(lsSerial) -1)
				End IF
			End IF
			//09-JUNE-2017 Madhu -PEVS-554 Look for StripOff validation is enabled/disabled for SKU -END
			
			lsSKU = ''	// default here and reset below if found
			IF ll_rows > 0 THEN
				// Find the retrieved serial number in the Transfer Detail List
				IF Len( String( lds_serial.Object.Po_No[ 1 ] )) > 0 and Len( String( lds_serial.Object.L_Code[ 1 ] )) > 0 THEN
					//ls_find = 	"sku = '" + lds_serial.Object.SKU[ 1 ] + "' and owner_id = " + String( lds_serial.Object.Owner_Id[ 1 ] ) + " and po_no = '" + lds_serial.Object.Po_No[ 1 ] + "' and serial_no = '" + lds_serial.Object.Serial_No[ 1 ] + "' "		// many of the serials are not populated in production so leave it out
					ls_find = 	"sku = '" + lds_serial.Object.SKU[ 1 ] + "' and owner_id = " + String( lds_serial.Object.Owner_Id[ 1 ] ) + " and po_no = '" + lds_serial.Object.Po_No[ 1 ] + "' "
			
					IF lds_serial.Object.Po_No[ 1 ] = 'MAIN' THEN
					// Don't use location code
					else
						ls_find += " and s_location = '" + String( lds_serial.Object.L_Code[ 1 ] ) + "' "
					END IF
				
					ll_found_row = w_tran.idw_detail.Find( ls_find, 1, w_tran.idw_detail.RowCount() + 1)
					IF  ll_found_row > 0 THEN
						lsSKU = lds_serial.Object.SKU[ 1 ]
						lsSuppcode = w_tran.idw_detail.getitemstring(ll_found_row,'supp_code') //03-APR-2017 :Madhu -PEVS-424 - Stock Transfer Serial No.
					END IF
				
					//09-JUNE-2017 Madhu -PEVS-554 Look for StripOff validation is enabled/disabled for SKU -START
					lsreturnedSN = i_nwarehouse.of_stripoff_firstcol_serialno(lsSKU,lsSuppcode, This.Text) //always pass original SN
				
					If (lbstripoff =TRUE) and ( lsmodifiedSN <> lsreturnedSN) then //original SN = returned SN which means stripoff turned off then throw error message.
						lsSKU =''
					//09-JUNE-2017 Madhu -PEVS-554 Look for StripOff validation is enabled/disabled for SKU -END
					else				
						
						//03-APR-2017 :Madhu -PEVS-424 - Added Item Serial Prefix Mask Validation -START
						//a. check whether SKU is enabled for StripOff First char or not.
						//b. If scanned SN does pass Serial Mask, don't need to check against StripOff 1st char.
						//c. If scanned SN does not pass Serial Mask, need to check against StripOff 1st char and re-do Serial Mask Validation.
						ls_stripoff_checked = i_nwarehouse.of_stripoff_firstcol_checked( lsSKU, lsSuppcode)
						ls_return = i_nwarehouse.of_validate_serial_format( lsSKU, This.Text , lsSuppcode )
								
						//28-JULY-2017 :Madhu -PEVS-554 - TCIF Linked Code39 "TLC39" SerialBarcodes -START
						If ls_return <> "" and upper(ls_stripoff_checked) ='Y' Then
							lsSerial = lsreturnedSN
							ls_return = i_nwarehouse.of_validate_serial_format(lsSKU, lsSerial , lsSuppcode )
						End If
						//28-JULY-2017 :Madhu -PEVS-554 - TCIF Linked Code39 "TLC39" SerialBarcodes -END
					
						IF ls_return <> "" THEN
							Messagebox( 'Serial Number Entry', ls_return )
							this.SetFocus()
							this.text=''
							return 1
						END IF
						//03-APR-2017 :Madhu -PEVS-424 - Added Item Serial Prefix Mask Validation -END
					END IF
			 END IF
			END IF //rows >0 block
			
		ELSE
			Select sku into :lsSKU
			FRom Serial_Number_Inventory
			Where Project_id = :gs_project and wh_code = :lsWarehouse and serial_no = :lsSerial and sku in (select sku from transfer_detail where to_no = :lstono);
			
			//09-JUNE-2017 Madhu -PEVS-554 Look for StripOff validation is enabled/disabled for SKU -START
			IF isNull(lsSKU) or lsSKU='' or lsSKU=' ' THEN
			
				ls_sql_syntax = "SELECT * FROM SERIAL_NUMBER_INVENTORY WHERE PROJECT_ID = '" + gs_project + "' AND SERIAL_NO = '" + Right(lsSerial ,len(lsSerial) -1) + "' AND SKU in ( " + ls_formatted_gpns + " ) "
				
				lds_serial.Create(SQLCA.SyntaxFromSQL(ls_sql_syntax,"", ERRORS))
				IF Len(ERRORS) > 0 THEN
					MessageBox("Errors", "Unable to create datastore to check Serail Number.~r~r" + Errors)
					return
				END IF
				
				IF lds_serial.SetTransObject(SQLCA) <> 1 THEN
					MessageBox("Error","Error setting datastore's transaction object to check for Serial Number.")
					return
				END IF
				
				ll_rows = lds_serial.retrieve()
				
				If ll_rows > 0 THEN
					lbstripoff =TRUE //set boolean value and assume, string 1st char of SN
					lsmodifiedSN = Right(lsSerial ,len(lsSerial) -1)
				End IF
				
				IF ll_rows > 0 THEN
					// Find the retrieved serial number in the Transfer Detail List
					IF Len( String( lds_serial.Object.Po_No[ 1 ] )) > 0 and Len( String( lds_serial.Object.L_Code[ 1 ] )) > 0 THEN
						ls_find = 	"sku = '" + lds_serial.Object.SKU[ 1 ] + "' and owner_id = " + String( lds_serial.Object.Owner_Id[ 1 ] ) + " and po_no = '" + lds_serial.Object.Po_No[ 1 ] + "' "
				
						IF lds_serial.Object.Po_No[ 1 ] = 'MAIN' THEN
							// Don't use location code
						else
							ls_find += " and s_location = '" + String( lds_serial.Object.L_Code[ 1 ] ) + "' "
						END IF
					
						ll_found_row = w_tran.idw_detail.Find( ls_find, 1, w_tran.idw_detail.RowCount() + 1)
						IF  ll_found_row > 0 THEN
							lsSKU = lds_serial.Object.SKU[ 1 ]
							lsSuppcode = w_tran.idw_detail.getitemstring(ll_found_row,'supp_code')
						END IF
				
						lsreturnedSN = i_nwarehouse.of_stripoff_firstcol_serialno(lsSKU,lsSuppcode, This.Text) //always pass original SN
						
						IF (lbstripoff =TRUE) and ( lsmodifiedSN <> lsreturnedSN) THEN //original SN = returned SN which means stripoff turned off then throw error message.
							lsSKU =''
						else
							lsSerial = lsreturnedSN
						END IF
					END IF
				END IF //rows >0 block
			End IF //SKU validation block
			//09-JUNE-2017 Madhu -PEVS-554 Look for StripOff validation is enabled/disabled for SKU -END
		END IF
			
		IF lsSKU > '' THEN
			
			//03-APR-2017 :Madhu -PEVS-424 - Stock Transfer Serial No. - START
			//Find an Unselected row against SKU on Serial screen and update SN accordingly.
			IF upper(gs_project) ='PANDORA' THEN
				ls_Find = "sku ='" +lsSKU+"' and (c_select_ind ='N' or IsNull(c_select_ind) or c_select_ind='' or c_select_ind=' ')  "
			else
				ls_Find = "sku ='" +lsSKU+"' and (c_select_ind ='N' or IsNull(c_select_ind) or c_select_ind='' or c_select_ind=' ')  and serial_no='"+lsSerial+"'"
			END IF
			
			ll_found_row = dw_serial.find( ls_Find, 1, dw_serial.rowcount()+1)
			
			IF ll_found_row > 0 THEN
				dw_serial.setitem( ll_found_row, 'sku', lsSKU)
				dw_serial.setitem( ll_found_row, 'serial_no', lsSerial)
				dw_serial.setitem( ll_found_row, 'c_select_ind', 'Y')
			else
				doDisplayMessage('Invalid Serial Number', 'Invalid Serial Number or SKU/Serial Number not present on this order.')
			END IF
			
			This.SelectText(1, len(this.Text))
		
		else
			doDisplayMessage('Invalid Serial Number', 'Invalid Serial Number or SKU/Serial Number not present on this order.')
			This.SelectText(1, len(this.Text))
		END IF
		
	 END IF //llFindRow block
 NEXT
	destroy lds_serial
	dw_serial.PostEvent('ue_count_checked')
	dw_serial.PostEvent('ue_set_locations')
ELSE
	ibModified = FALSE
END IF
//10-Apr-2017 :Madhu PEVS-424 - Stock Transfer Serial No - END
end event

type st_1 from statictext within w_tran_serial_numbers
integer x = 27
integer y = 388
integer width = 1307
integer height = 88
boolean bringtotop = true
integer textsize = -7
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = "Scan or type a serial number to check a box or add a new row"
boolean focusrectangle = false
end type

type cb_select_all from commandbutton within w_tran_serial_numbers
integer x = 55
integer y = 544
integer width = 306
integer height = 92
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Select All"
end type

event clicked;
Long	i
String	lsSKU, lsSKUPrev

For i = 1 to dw_serial.RowCount()
	
	dw_serial.SetItem(i,'c_select_ind','Y')
	
	lsSKU = dw_serial.GetItemString(i,'sku')
	If lsSKU <> lsSKUPrev Then
		idsLocSummary.SetFilter("upper(sku) = '" + upper(lsSKU) + "'")
		idsLocSummary.Filter()
		lsSKUPrev = lsSKU
	End If

	If idsLocSummary.RowCOunt() = 1 Then
		dw_Serial.SetITem(i,'to_loc',idsLocSummary.GetITemString(1,'d_location'))
	End If
		
Next

st_serial_scanned.Text = String(dw_serial.RowCount())

If Long(st_serial_scanned.Text) = Long(st_serial_req.Text) Then
	cb_ok.enabled = True
Else
	cb_ok.enabled = False
End If
end event

type cb_clear_all from commandbutton within w_tran_serial_numbers
integer x = 366
integer y = 544
integer width = 306
integer height = 92
integer taborder = 70
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Clear All"
end type

event clicked;Long	i
For i = 1 to dw_serial.RowCount()
	dw_serial.SetItem(i,'c_select_ind','N')
	dw_serial.SetItem(i,'to_loc','')
Next

dw_serial.Sort()
st_serial_scanned.Text = '0'
end event

type st_2 from statictext within w_tran_serial_numbers
integer x = 1335
integer y = 496
integer width = 256
integer height = 56
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Serials Required:"
boolean focusrectangle = false
end type

type st_3 from statictext within w_tran_serial_numbers
integer x = 1335
integer y = 568
integer width = 256
integer height = 56
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Serials Selected:"
boolean focusrectangle = false
end type

type st_serial_req from statictext within w_tran_serial_numbers
integer x = 1605
integer y = 496
integer width = 224
integer height = 56
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
alignment alignment = right!
boolean border = true
boolean focusrectangle = false
end type

type st_serial_scanned from statictext within w_tran_serial_numbers
integer x = 1605
integer y = 568
integer width = 224
integer height = 56
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
alignment alignment = right!
boolean border = true
boolean focusrectangle = false
end type

type sle_pono2 from singlelineedit within w_tran_serial_numbers
integer x = 439
integer y = 88
integer width = 1193
integer height = 84
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
end type

event modified;//22-Jan-2018 :Madhu S15155 -Foot Prints
//a. Get scanned Pallet Id value and find appropriate Detail Record.
//b. Get count of Serial No's from SNI Table against PoNo2, sku, wh, ownerId
//c. If count matches, populate all serial no's and set check box =Y else prompt an error message.

string lsFind, ls_sku, ls_supp, ls_wh, lsFilter
long	llFindRow, ll_Qty, ll_ownerId, ll_serial_count, ll_row, ll_scanned_count

ll_Qty =0
ls_wh = w_tran.idw_main.getItemString( 1, 's_warehouse')

lsFind ="upper(po_no2) ='"+sle_pono2.text+"'"
llFindRow =w_tran.idw_detail.find(lsFind, 1, w_tran.idw_detail.RowCount())

//If Findrow =0 then throw error message.
If llFindRow =0  or sle_pono2.text ='-' Then
	MessageBox("Transfer Serial Records", " Scanned Pallet Id# "+sle_pono2.text+" is not Valid. Please scan valid Pallet Id.", StopSign!)
	Return -1
End If

DO WHILE llFindRow > 0
	ls_sku = w_tran.idw_detail.getItemString(llFindRow, 'sku')
	ll_ownerId = w_tran.idw_detail.getItemNumber(llFindRow, 'owner_Id')
	ll_Qty +=	w_tran.idw_detail.getItemNumber(llFindRow, 'quantity')
	
	llFindRow =w_tran.idw_detail.find(lsFind, llFindRow+1, w_tran.idw_detail.RowCount()+1)	
LOOP

ids_serial = uf_get_serial_inventory_records(ls_sku, ls_wh, ll_ownerId) //get Serial No Inventory Records.

lsFilter ="upper(po_no2) ='"+sle_pono2.text+"'"
ids_serial.setfilter( lsFilter)
ids_serial.filter( )
ll_serial_count  = ids_serial.rowcount( )

IF ll_Qty <> ll_serial_count THEN
	//prompt an error message
	MessageBox("Transfer Serial Records", "Pallet/Carton must be split through the Stock Adjustment function first!" &
				 +"~n~rPalletId# "+sle_pono2.text+" , Req Pallet Qty# "+string(ll_Qty)+ " and Available Serial Records Qty# "+string(ll_serial_count), StopSign!)
	Return -1
ELSE
	//populate all associated Serial No's with PoNo2 and select check box.
	For ll_row =1 to ll_serial_count
		
		lsFind = "upper(sku) ='" +ls_sku+"' and upper(po_no2) ='"+sle_pono2.text+"' and serial_no ='"+ids_serial.getItemString(ll_row, 'serial_no')  +"'"
		llFindRow = dw_serial.find( lsFind, 1, dw_serial.rowcount())
		
		IF llFindRow = 0 Then
			lsFind = " upper(sku) ='" +ls_sku+"' and upper(po_no2) ='"+sle_pono2.text+"' and (c_select_ind ='N' or IsNull(c_select_ind) or c_select_ind='' or c_select_ind=' ')  "
			llFindRow = dw_serial.find( lsFind, 1, dw_serial.rowcount())
		
			IF llFindRow > 0 THEN
				dw_serial.setitem( llFindRow, 'sku', ls_sku)
				dw_serial.setitem( llFindRow, 'serial_no', ids_serial.getItemString(ll_row, 'serial_no'))
				dw_serial.setitem( llFindRow, 'c_select_ind', 'Y')
			End IF
	END IF
	Next
	
	ll_scanned_count =long(	st_serial_scanned.Text)
	st_serial_scanned.Text = String(ll_scanned_count + ll_serial_count)
	
End IF

sle_pono2.text =""
destroy ids_serial
end event

type sle_container_id from singlelineedit within w_tran_serial_numbers
integer x = 439
integer y = 196
integer width = 1193
integer height = 84
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
end type

event modified;//22-Jan-2018 :Madhu S15155 -Foot Prints
//a. Get scanned Pallet Id value and find appropriate Detail Record.
//b. Get count of Serial No's from SNI Table against PoNo2, sku, wh, ownerId
//c. If count matches, populate all serial no's and set check box =Y else prompt an error message.

string lsFind, ls_sku, ls_supp, ls_wh, lsFilter
long	llFindRow, ll_Qty, ll_ownerId, ll_serial_count, ll_row, ll_scanned_count

ll_Qty =0
ls_wh = w_tran.idw_main.getItemString( 1, 's_warehouse')

lsFind ="upper(container_Id) ='"+sle_container_id.text+"'"
llFindRow =w_tran.idw_detail.find(lsFind, 1, w_tran.idw_detail.RowCount())

//If Findrow =0 then throw error message.
If llFindRow =0 or sle_pono2.text ='-' Then
	MessageBox("Transfer Serial Records", " Scanned Container Id# "+sle_container_id.text+" is not Valid. Please scan valid Container Id.", StopSign!)
	Return -1
End If

DO WHILE llFindRow > 0
	ls_sku = w_tran.idw_detail.getItemString(llFindRow, 'sku')
	ll_ownerId = w_tran.idw_detail.getItemNumber(llFindRow, 'owner_Id')
	ll_Qty +=	w_tran.idw_detail.getItemNumber(llFindRow, 'quantity')
	
	llFindRow =w_tran.idw_detail.find(lsFind, llFindRow+1, w_tran.idw_detail.RowCount()+1)	
LOOP

ids_serial = uf_get_serial_inventory_records(ls_sku, ls_wh, ll_ownerId) //get Serial No Inventory Records.

lsFilter ="carton_Id ='"+sle_container_id.text+"'"
ids_serial.setfilter( lsFilter)
ids_serial.filter( )
ll_serial_count  = ids_serial.rowcount( )

IF ll_Qty <> ll_serial_count THEN
	//prompt an error message
	MessageBox("Transfer Serial Records", "Pallet/Carton must be split through the Stock Adjustment function first!" &
				 +"~n~Container Id# "+sle_container_id.text+" , Req Container Id Qty# "+string(ll_Qty)+ " and Available Serial Records Qty# "+string(ll_serial_count), StopSign!)
	Return -1
ELSE
	//populate all associated Serial No's with PoNo2 and select check box.
	For ll_row =1 to ll_serial_count
		
		lsFind = "upper(sku) ='" +ls_sku+"' and upper(carton_id) ='"+sle_container_id.text+"' and serial_no ='"+ids_serial.getItemString(ll_row, 'serial_no')  +"'"
		llFindRow = dw_serial.find( lsFind, 1, dw_serial.rowcount())
		
		IF llFindRow = 0 Then
			lsFind = "upper(sku) ='" +ls_sku+"' and upper(carton_id) ='"+sle_container_id.text+"' and (c_select_ind ='N' or IsNull(c_select_ind) or c_select_ind='' or c_select_ind=' ')  "
			llFindRow = dw_serial.find( lsFind, 1, dw_serial.rowcount())
		
			IF llFindRow > 0 THEN
				dw_serial.setitem( llFindRow, 'sku', ls_sku)
				dw_serial.setitem( llFindRow, 'serial_no', ids_serial.getItemString(ll_row, 'serial_no'))
				dw_serial.setitem( llFindRow, 'c_select_ind', 'Y')
			End IF
		END IF
	Next
	
	ll_scanned_count =long(	st_serial_scanned.Text)
	st_serial_scanned.Text = String(ll_scanned_count + ll_serial_count)
End IF

sle_container_id.text=""
destroy ids_serial
end event

type st_pono2 from statictext within w_tran_serial_numbers
integer x = 37
integer y = 108
integer width = 398
integer height = 56
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Pallet Id:"
boolean focusrectangle = false
end type

type st_container from statictext within w_tran_serial_numbers
integer x = 37
integer y = 204
integer width = 398
integer height = 56
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Container Id:"
boolean focusrectangle = false
end type

type st_serial from statictext within w_tran_serial_numbers
integer x = 37
integer y = 292
integer width = 398
integer height = 60
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Serial No:"
boolean focusrectangle = false
end type

