$PBExportHeader$w_consolidation.srw
$PBExportComments$Order Consolidation
forward
global type w_consolidation from w_std_master_detail
end type
type cb_confirm from commandbutton within tabpage_main
end type
type sle_order from singlelineedit within tabpage_main
end type
type st_1 from statictext within tabpage_main
end type
type dw_main from u_dw_ancestor within tabpage_main
end type
type dw_result from u_dw_ancestor within tabpage_search
end type
type cb_clear from commandbutton within tabpage_search
end type
type cb_search from commandbutton within tabpage_search
end type
type dw_search from u_dw_ancestor within tabpage_search
end type
type tabpage_detail1 from userobject within tab_main
end type
type cb_clearall1 from commandbutton within tabpage_detail1
end type
type cb_selectall1 from commandbutton within tabpage_detail1
end type
type st_2 from statictext within tabpage_detail1
end type
type cb_receive_from_supplier from commandbutton within tabpage_detail1
end type
type cb_ship_1 from commandbutton within tabpage_detail1
end type
type cb_delete1 from commandbutton within tabpage_detail1
end type
type cb_add_orders from commandbutton within tabpage_detail1
end type
type dw_detail1 from u_dw_ancestor within tabpage_detail1
end type
type tabpage_detail1 from userobject within tab_main
cb_clearall1 cb_clearall1
cb_selectall1 cb_selectall1
st_2 st_2
cb_receive_from_supplier cb_receive_from_supplier
cb_ship_1 cb_ship_1
cb_delete1 cb_delete1
cb_add_orders cb_add_orders
dw_detail1 dw_detail1
end type
type tabpage_detail2 from userobject within tab_main
end type
type cb_set_dates from commandbutton within tabpage_detail2
end type
type cb_print from commandbutton within tabpage_detail2
end type
type cb_clearall from commandbutton within tabpage_detail2
end type
type cb_selectall from commandbutton within tabpage_detail2
end type
type cb_ship_2 from commandbutton within tabpage_detail2
end type
type cb_receive from commandbutton within tabpage_detail2
end type
type dw_detail2 from u_dw_ancestor within tabpage_detail2
end type
type tabpage_detail2 from userobject within tab_main
cb_set_dates cb_set_dates
cb_print cb_print
cb_clearall cb_clearall
cb_selectall cb_selectall
cb_ship_2 cb_ship_2
cb_receive cb_receive
dw_detail2 dw_detail2
end type
type tabpage_detail3 from userobject within tab_main
end type
type st_4 from statictext within tabpage_detail3
end type
type dw_detail3 from u_dw_ancestor within tabpage_detail3
end type
type tabpage_detail3 from userobject within tab_main
st_4 st_4
dw_detail3 dw_detail3
end type
end forward

global type w_consolidation from w_std_master_detail
integer width = 3653
integer height = 2056
string title = "Consolidation"
event ue_set_tab_labels ( )
event ue_ship_to_dest ( )
event ue_receive_from_source ( )
event ue_ship_to_cust ( )
event ue_confirm ( )
event ue_receive_from_supplier ( )
event ue_set_dates ( )
end type
global w_consolidation w_consolidation

type variables

Window	iw_Window
singlelineedit	isle_Order
//commandbutton	icb_Action
Datawindow	idw_Main, idw_Detail1, idw_detail2, idw_detail3, idw_Search, idw_Result
String	isOrigSearchSQL
n_warehouse	i_nwarehouse 

// pvh - GMT
string isFromWH_CD
string isToWH_CD

end variables

forward prototypes
public function integer wf_validation ()
public function integer wf_clear_screen ()
public function integer wf_check_status ()
public subroutine setfromwhcode (string acode)
public subroutine settowhcode (string acode)
public function string getfromwhcode ()
public function string gettowhcode ()
end prototypes

event ue_set_tab_labels;//Replace Source/Dest Literals with actual Warehouse Names if present

String	lsFrom,	lsTo

If idw_main.RowCount() < 1 Then Return

lsFrom = idw_Main.GetITemString(1,'from_wh_code')
If isnull(lsFrom) or lsFrom = '' Then lsFrom = 'Source'

If idw_main.GetITemString(1,'ord_type') = 'C' Then /* SHipping dorectly to Cust*/
	lsTO = 'Cust'
Else
	lsTO = idw_Main.GetITemString(1,'to_wh_code')
End If


If isnull(lsTo) or lsTo = '' Then lsTo = 'Dest WH'

tab_main.tabpage_detail1.Text = lsFrom + " -> " + lsTo
tab_main.tabpage_detail2.Text = lsTo + " -> Cust"
tab_main.tabpage_detail3.Text = lsTo + " -> Inventory"
end event

event ue_ship_to_dest();Long	llRowCOunt,	&
		llRowPos,	&
		llNo,			&
		llDetailPos,	&
		llDetailCount,	&
		llCartonCount,	&
		llRC,				&
		llOwner,			&
		llLineITem,		&
		llReqQty
		
String	lsDONO,	&
			lsNewDONO,	&
			lsMsg,		&
			lsCarrier,	&
			lsAWB,		&
			lsDest,		&
			lsToWH,		&
			lsOrderNo,	&
			lsNewRONO,	&
			lsConSolNo,	&
			lsErrText,	&
			lsSKU,		&
			lsAltSKU,	&
			lsCOO

Decimal	ldWeight
			
			
Datastore	ldsMAster,	&
				ldsDetail
DateTime		ldTNull,	&
				ldtToday
				
DatawindowChild	ldwc

// Dest will either be Warehouse or Customer
If idw_MAin.GetITemString(1,'ord_type') = 'C' Then
	lsDest = 'The Customer'
Else
	lsDest = idw_main.GetItemString(1,'to_wh_code')
End If

//At least one order must be checked
If idw_Detail1.Find("c_select_ind = 'Y'",1,idw_Detail1.RowCOunt()) <=0 Then
	Messagebox(is_title,"At least 1 order must be checked for Shipment to " + lsDest + "!",StopSign!)
	Return
End If

//Can only ship in Process status
If idw_Detail1.Find("c_select_ind = 'Y' and ord_status <> 'P'",1,idw_Detail1.RowCOunt()) > 0 Then
	Messagebox(is_title,"You can not ship orders that have not been received from the supplier yet~ror have already been shipped to " + lsDest + "!",StopSign!)
	Return
End If

If Messagebox(is_title,'Are you sure you want to confirm shipment of these orders to ' + lsDest + '?', Question!,YesNo!,2) = 2 Then Return
	
SetPointer(HourGlass!)

lsCarrier = idw_Main.GetITemString(1,'Carrier')
lsAWB = idw_main.GetITemString(1,'awb_bol_nbr')
lsToWH = idw_main.GetITemString(1,'to_wh_code')
lsConsolNo = idw_main.GetITemString(1,'consolidation_no')

ldWeight = 0
llCartonCount = 0

// pvh 11/23/05 - gmt
ldtToday = f_getLocalWorldTime( gs_default_wh ) 

//Set Status to Complete on All outbound ORders on detail tab 1
llRowCount = idw_Detail1.RowCount()
For llRowPos = 1 to llRowCount
	If idw_Detail1.GetITemString(llRowPos,'c_select_ind') <> 'Y' Then Continue /*not checked, don't update */
	idw_Detail1.SetITem(lLRowPos,'ord_Status','C')
	idw_Detail1.SetItem(lLRowPos,'last_user',gs_userID)
	// pvh 11/23/05 - gmt
	idw_Detail1.SetItem(lLRowPos,'Last_Update', ldtToday )
Next

//If we are consolidating through the warehouse to the customer, Complete another set of Outbound orders for Dest-> Cust
// We may also be creating an Inbound Order if the Order Type reflects that it is for FG Putaway instead of shipment to customer

If idw_Main.GetITemString(1,'ord_Type') = 'W' Then
	
	ldsMaster = Create Datastore
	ldsMaster.Dataobject = 'd_do_master'
	ldsMAster.SetTransOBject(SQLCA)
	
	//dropdowns retrieved by project need initializing
	ldsMaster.GetChild('ord_Type',ldwc)
	ldwc.InsertRow(0)
	ldsMaster.GetChild('wh_code',ldwc)
	ldwc.InsertRow(0)
	ldsMaster.GetChild('address_code',ldwc)
	ldwc.InsertRow(0)
	ldsMaster.GetChild('inventory_Type',ldwc)
	ldwc.InsertRow(0)

	ldsDetail = Create Datastore
	ldsDetail.Dataobject = 'd_do_detail'
	ldsDetail.SetTransOBject(SQLCA)

	ldsDetail.GetChild('supp_code',ldwc)
	ldwc.InsertRow(0)

	// For Each Order, either Create an Outbound or Inbound depending on the Order Type
	llRowCount = idw_Detail1.RowCount()
	For llRowPos = 1 to llRowCount
	
		If idw_Detail1.GetITemString(llRowPos,'c_select_ind') <> 'Y' Then Continue /*not checked, don't update */
	
		lsDONO = idw_Detail1.GetItemString(lLRowPos, 'do_no')
		
		//Retrieve the Original DO Header/Details - they will be used to create either new outbounds for the second leg
		//or Inbounds if being putaway to Inventory
	
		ldsMaster.Retrieve(lsDONO) /*retrieve original Order header */
		If ldsMAster.RowCount() <> 1 Then Continue
		
		llDetailCount = ldsDetail.Retrieve(lsDONO)
		
		If ldsMaster.GetITemString(1,'ord_type') = 'I' Then /*Consolidation To Inventory - Create Inbound Order*/
					
			//Get the next available RONO
			llno = g.of_next_db_seq(gs_project,'Receive_Master','RO_No')
			If llno <= 0 Then
				messagebox(is_title,"Unable to retrieve the next available Inbound order Number!")
				Return
			End If
			lsNewRONO = Trim(Left(gs_project,9)) + String(llno,"0000000")
				
			lsOrderNo = idw_detail1.GetITemString(llRowPos,'invoice_no')
			
			// pvh 11/23/05 - gmt
			ldtToday = f_getLocalWorldTime( gs_default_wh ) 
			//New Receive MAster
			Insert Into Receive_Master
							(ro_no, Project_id, wh_Code, Supp_code, supp_invoice_No, Consolidation_No,
							Ord_Type, ord_status, Ord_Date, Inventory_Type, Last_User, Last_Update)
					Values (:lsNewRONO, :gs_Project, :lsToWH, 'PULSE', :lsOrderNo, :lsConsolNo, 'F', 'N', :ldtToday, 'F', :gs_userID, :ldtToday)
					Using SQLCA;
			
			If SQLCA.sqlCode < 0 Then
				lsErrText = sqlca.sqlErrText
				Execute Immediate "ROLLBACK" using SQLCA;
				MessageBox(is_title, "Unable to create Matching Inbound Order Header: " + lsErrText)
				Continue
			End If
			
			//Create a Receive Detail for Each Delivery Detail of the first leg
			For llDEtailPos = 1 to lLDetailCount
				
				lsSKu = ldsDetail.getITemString(llDEtailPos,'SKU')
				lsaltSKu = ldsDetail.getITemString(llDEtailPos,'alternate_SKU')
				llOwner = ldsDetail.getITemNumber(llDEtailPos,'owner_ID')
				llLineITem = ldsDetail.getITemNumber(llDEtailPos,'Line_Item_No')
				llREQqTY = ldsDetail.getITemNumber(llDEtailPos,'Req_Qty')
				
				//Get Default COO from Item MAster
				Select country_of_Origin_Default Into :lsCOO
				From Item_MAster
				Where Project_id = :gs_Project and sku = :lsSKU and supp_code = 'PULSE';
				
				If isnull(lsCOO) or lsCOO = '' Then lsCOO = 'XXX'
				
				Insert Into REceive_Detail
								(ro_no, sku, alternate_SKU, Supp_code, Owner_ID, Country_of_Origin, req_qty, alloc_Qty, damage_Qty, Line_Item_no)
						Values (:lsNewRONO, :lsSKU, :lsAltSKU, 'PULSE', :llOwner, :lsCOO, :llReqQty, 0, 0, :llLineItem)
				Using SQLCA;
				
				If SQLCA.sqlCode < 0 Then
					lsErrText = sqlca.sqlErrText
					Execute Immediate "ROLLBACK" using SQLCA;
					MessageBox(is_title, "Unable to create Matching Inbound Order Detail: " + lsErrText)
					Continue
				End If
								
			Next /*Detail */
		
		Else /* Consolidating to Customer, create Matching Outbound order for last leg */
			
			ldsMaster.RowsCopy(1,1,Primary!,ldsMAster,99,Primary!) /*copy to new header*/
	
			//modify appropriate fields on new header
	
			//Get the next available DONO
			llno = g.of_next_db_seq(gs_project,'Delivery_Master','DO_No')
			If llno <= 0 Then
				messagebox(is_title,"Unable to retrieve the next available order Number!")
				Return
			End If
			lsNewDONO = Trim(Left(gs_project,9)) + String(llno,"0000000")
			
			// pvh 11/23/05 - gmt
			ldtToday = f_getLocalWorldTime( gs_default_wh ) 
			
			ldsMaster.SetItem(2,'do_no',lsNewDONO)
			ldsMAster.SetItem(2,'ord_Status','H') /* set order status to Hold until it arrives at the Dest WH */
			ldsMAster.SetItem(2,'wh_code', getToWHCode() ) /* Warehouse is the Dest WH */
			ldsMAster.SetItem(2,'last_user',gs_userID)
			ldsMAster.SetItem(2,'LAst_Update', ldtToday )
			SetNull(ldtNull)
			ldsMAster.SetItem(2,'Complete_Date',ldtNull)
			ldsMAster.SetItem(2,'ship_via','') /* was set to air or ocean on first leg - does not apply to second leg*/
	
			// If we have a Consolidation level Carrier and AWB, we want to update the original orders to reflect this for visibility
			// of the first leg.
			ldsMAster.SetItem(1,'Carrier',lsCarrier)
			ldsMaster.SetItem(1,'awb_bol_no',lsAWB)
	
			//DETAIL
				
			//set the alloc qty to the req qty if not picking order
			For llDetailPos = 1 to llDetailCount
				If isnull(ldsDEtail.GetItemNumber(llDetailPos,'alloc_qty')) or ldsDEtail.GetItemNumber(llDetailPos,'alloc_qty') = 0  Then
					ldsDetail.SetITem(llDetailPos,'alloc_qty',ldsDEtail.GetItemNumber(llDetailPos,'Req_qty'))
				End If
			Next
		
			ldsDetail.RowsCopy(1,llDetailCount,Primary!,ldsDetail,(lldetailCount + 1),Primary!) /*copy to new detail rows*/
	
			//Set DO on new rows
			For llDetailPos = llDetailCount + 1 to ldsDetail.RowCOunt()
				ldsDetail.SetItem(llDetailPos,'do_no',lsNewDONO)
			next
	
			//Save new headers and Details
			llRC = ldsMASter.Update()
			If llRC = 1 Then 
				llrc = ldsDetail.Update()
			End If
	
			If llRC < 1 Then
				Execute Immediate "ROLLBACK" using SQLCA;
				lsMsg = "Unable to save New Delivery Order Records!~r~r"
				If Not isnull(SQLCA.SQLErrText) Then /*if errtext is null, we get no msg - datastores dont return error codes like DW's*/
					lsMsg += SQLCA.SQLErrText
				End If
     			MessageBox(is_title, lsMsg)
	 	 		Return
			End If
		
		End If /*Inbound or Outbound?? */
			
	
	Next /*Next Order (Inbound or Outbound) */
	
	idw_main.SetITem(1,'ord_status','T') /*Constolidation Status to In Transit */
	
Else /*Shipped directly to Customer - Shipment Complete - set status */
	
	idw_main.SetITem(1,'ord_status','U') /*Constolidation Status to 'Shipped to Cust*/
	
End If /*Consolidating to warehouse - second leg created */
		
idw_main.SetITem(1,'Ship_date',Today()) /*Set Ship Date */

//Reset checkboxes
for llrowPos = 1 to llRowCount
	idw_Detail1.SetITem(lLRowPos,'c_select_Ind','N') 
Next

////Update weight and carton count on Master
//If isnull(idw_main.GetITemNumber(1,'weight')) or idw_main.GetITemNumber(1,'weight') = 0 Then
//	idw_main.SetItem(1,'weight',ldWEight)
//End If
//
//If isnull(idw_main.GetITemNumber(1,'ctn_cnt')) or idw_main.GetITemNumber(1,'ctn_cnt') = 0 Then
//	idw_main.SetItem(1,'ctn_cnt',llCartonCount)
//End If
		
This.TriggerEvent('ue_save')

This.TriggerEvent('ue_retrieve') /*populate the 2nd detail tab */
		
wf_Check_Status()
		
SetPointer(Arrow!)

Messagebox(is_title,'Shipment to ' + lsDest + ' confirmed!')

end event

event ue_receive_from_source;Long	llRowCount,	&
		llRowPos
		
//At least one order must be checked
If idw_Detail2.Find("c_select_ind = 'Y'",1,idw_Detail2.RowCOunt()) <=0 Then
	Messagebox(is_title,"At least 1 order must be checked for Receipt!",StopSign!)
	Return
End If

//Can't receive what's already been received
If idw_Detail2.Find("c_select_ind = 'Y' and ord_status <> 'H'",1,idw_Detail2.RowCOunt()) > 0 Then
	Messagebox(is_title,"You can not receive orders that have already been received!",StopSign!)
	Return
End If

If Messagebox(is_title,'Are you sure you want to confirm Receipt of these orders from ' + idw_main.GetItemString(1,'from_wh_code') + '?', Question!,YesNo!,2) = 2 Then Return
	
SetPointer(HourGlass!)

//Set Status to New on All outbound ORders on detail tab 2
llRowCount = idw_Detail2.RowCount()
For llRowPos = 1 to llRowCount
	If (Idw_detail2.GetITemString(llRowPos,'c_select_ind') <> 'Y') or Isnull(Idw_detail2.GetITemString(llRowPos,'c_select_ind'))  Then Continue
	idw_Detail2.SetITem(lLRowPos,'ord_Status','N') /*Set to New from Hold */
	idw_detail2.SetItem(llRowPos,'c_select_ind','N')
Next

idw_main.setItem(1,'Receive_Date',Today()) /* set receipt date */
idw_main.SetITem(1,'ord_status','D') /*Constolidation Status to On-site Dest */
		
This.TriggerEvent('ue_save')
		
wf_Check_Status()

Messagebox(is_title,'Receipts confirmed from ' + idw_main.GetItemString(1,'from_wh_code') + '!')
end event

event ue_ship_to_cust();//Ship selected orders to customer

Long	llRowCOunt,	&
		llRowPos

//At least one order must be checked
If idw_Detail2.Find("c_select_ind = 'Y'",1,idw_Detail2.RowCOunt()) <=0 Then
	Messagebox(is_title,"At least 1 order must be checked for Shipping!",StopSign!)
	Return
End If

//Cant ship orders in Hold Stus (haven't been received into WH yet)
If idw_Detail2.Find("c_select_ind = 'Y' and ord_status = 'H'",1,idw_Detail2.RowCOunt()) > 0 Then
	Messagebox(is_title,"You can not ship orders that have not been received yet!",StopSign!)
	Return
End If


//Cant Ship orders until Carrier Notified date has been set.
If idw_Detail2.Find("c_select_ind = 'Y' and isNull(carrier_notified_date)",1,idw_Detail2.RowCOunt()) > 0 Then
	Messagebox(is_title,"You must enter the Carrier Notified date before shipping orders!",StopSign!)
	Return
End If


//Confirm Shipment
If Messagebox(is_title,"Are you sure you want to ship the checked orders to the Customer?",Question!,yesNo!,1) = 2 Then Return

// pvh 11/23/05 - gmt
datetime ldtToday
ldtToday = f_getLocalWorldTime( gs_default_wh ) 
//

//Update the Order Status on each detail (Order) row
llRowCount = idw_DEtail2.RowCOunt()
For llRowPos = 1 to llRowCount
	
	If (Idw_detail2.GetITemString(llRowPos,'c_select_ind') <> 'Y') or Isnull(Idw_detail2.GetITemString(llRowPos,'c_select_ind'))  Then Continue
	
	idw_Detail2.SetITem(llRowPos,'ord_Status','C') /*complete*/
	idw_Detail2.SetItem(lLRowPos,'last_user',gs_userID)
	idw_Detail2.SetItem(lLRowPos,'Last_Update', ldtToday )
	idw_Detail2.SetItem(lLRowPos,'Complete_Date',Today())
	
	idw_detail2.SetItem(llRowPos,'c_select_ind','N')
	
Next

//Set the Consol Ord Status to Shipping
idw_main.SetItem(1,'Ord_Status','S')

This.TriggerEvent('ue_save')

wf_Check_Status()

Messagebox(is_title,'Shipment to Customers confirmed.')
end event

event ue_confirm;
//All Delivery orders must be confirmed (Shipped) before confirming the Consol
If idw_detail2.Find("ord_status <> 'C'",1,idw_Detail2.RowCount()) > 0 Then
	Messagebox(is_title,'All orders must be shipped before you can confirm the Consolidation!',StopSign!)
	Return
End If

//Prompt if Not all carriers/AWBs have been entered
If idw_Detail2.Find("isnull(carrier) or carrier = '' or isnull(awb_bol_no) or awb_bol_no = ''",1,idw_Detail2.RowCOunt()) > 0 Then
	If Messagebox(is_title,"Not all Carriers and/or AWB's have been entered!~r~rWould you like to enter them before you confirm this Consolidation?",Question!,YesNo!,1) = 1 Then
		Return
	End If
End If

If Messagebox(is_title,'Are you sure you want to confirm this Consolidation?',Question!,YesNo!,1) = 2 Then
	Return
End If

idw_main.SetITem(1,'ord_status','C')
idw_Main.SetITem(1,'complete_date',Today())

This.TriggerEvent('ue_Save')

Messagebox(is_title,'Consolidation Confirmed!')

end event

event ue_receive_from_supplier;
Long	llRowCount,	&
		llRowPos

//At least one order must be checked
If idw_Detail1.Find("c_select_ind = 'Y'",1,idw_Detail1.RowCOunt()) <=0 Then
	Messagebox(is_title,"At least 1 order must be checked for Receipt!",StopSign!)
	Return
End If

//Can't receive what's already been received
If idw_Detail1.Find("c_select_ind = 'Y' and ord_status <> 'N'",1,idw_Detail1.RowCOunt()) > 0 Then
	Messagebox(is_title,"You can not receive orders that have already been received!",StopSign!)
	Return
End If

If Messagebox(is_title,'Are you sure you want to confirm Receipt of these orders from the Supplier?', Question!,YesNo!,2) = 2 Then Return

//Set the checked orders to 'Process' 
llRowCount = idw_Detail1.RowCount()
For llRowPos = 1 to llRowCount
	If idw_Detail1.GetITemString(llRowPos,'c_select_ind') <> 'Y' Then Continue /*not checked, don't update */
	idw_Detail1.SetItem(llRowPos,'ord_status','P')
	idw_Detail1.SetItem(llRowPos,'c_select_Ind','N')
Next

idw_main.SetItem(1,'ord_status','Z') /*Consol Order Status = 'On site Srce WH' */

This.TriggerEvent('ue_save')
wf_Check_Status()
		
Messagebox(is_title,'Receipt from Supplier Confirmed!')

end event

event ue_set_dates;Str_parms	lstrparms
Long			llRowPos, llRowCount

//At least one order must be checked
If idw_Detail2.Find("c_select_ind = 'Y'",1,idw_Detail2.RowCOunt()) <=0 Then
	Messagebox(is_title,"At least 1 order must be checked to set dates!",StopSign!)
	Return
End If


OpenWithParm(w_consolidation_set_dates,lstrparms)
lstrparms = Message.PowerObjectParm

If Lstrparms.Cancelled then Return

llRowCount = idw_detail2.RowCount()
For llRowPos = 1 to llRowCount
	
	If idw_Detail2.GetITemString(llRowPos,'c_select_ind') <> 'Y' Then Continue
	
	Choose Case Lstrparms.String_arg[1]
			
		//Case 'A' /* arrived at port */
		//	idw_detail2.SetItem(llRowPos,'freight_ata',lstrparms.DateTime_arg[1])
		//Case 'B' /*Customs Cleared */			
		//	idw_detail2.SetItem(llRowPos,'customs_clearance_Date',lstrparms.DateTime_arg[1])
		Case 'C' /*Carrier Notified */
			//Arrived at port (freightt ata) and customs clerance dates must be entered first
			If isnull(idw_main.GetItemDateTime(1,'port_arrival_date')) or isnull(idw_Main.GetItemDateTime(1,'customs_clearance_Date')) Then
				Messagebox(is_title,'Arrival at Port and Customs Clearance dates must be entered~rbefore you can set the Carrier Notified Date!')
				Return
			Else
				idw_detail2.SetItem(llRowPos,'carrier_notified_Date',lstrparms.DateTime_arg[1])
			End If
	End Choose
	
	idw_detail2.SetITem(llRowPos,'c_select_ind','N')
	
Next

////If we were setting the Customs Cleared Date, update on Master
//If Lstrparms.String_arg[1] = 'B' Then
//	idw_main.SetItem(1,'customs_clearance_date',lstrparms.DateTime_arg[1])
//End If

This.TriggerEvent('ue_save')
end event

public function integer wf_validation ();
//Validations

//Order Info Validations

//Source/Dest WH are required and can not be the same (unless consolidating directly to Customer)
If isNull(idw_Main.GetITemString(1,'from_wh_code')) or idw_Main.GetITemString(1,'from_wh_code') = '' Then
	messagebox(is_Title, "Source Warehouse is required!")
	tab_main.SelectTab(1)
	idw_main.SetFocus()
	idw_Main.SetColumn('from_wh_code')
	Return -1
End If

If isNull(idw_Main.GetITemString(1,'to_wh_code')) or idw_Main.GetITemString(1,'to_wh_code') = '' Then
	messagebox(is_Title, "Destination Warehouse is required!")
	tab_main.SelectTab(1)
	idw_main.SetFocus()
	idw_Main.SetColumn('to_wh_code')
	Return -1
End If

If (idw_Main.GetITemString(1,'from_wh_code') = idw_Main.GetITemString(1,'to_wh_code')) and idw_Main.GetITemString(1,'ord_Type') = 'W'	Then
	messagebox(is_Title, "Destination Warehouse must be different from the Source Warehouse!")
	tab_main.SelectTab(1)
	idw_main.SetFocus()
	idw_Main.SetColumn('to_wh_code')
	Return -1
End If

Return 0
end function

public function integer wf_clear_screen ();
idw_main.Reset()
idw_detail1.Reset()
idw_detail2.Reset()
idw_detail3.Reset()

isle_order.Text = ""

tab_main.SelectTab(1) 

Return 0

end function

public function integer wf_check_status ();str_multiparms lstr_parms
integer i
commandbutton lcb_gen,lcb_rate


isle_order.DisplayOnly = True
isle_order.Visible = False
isle_order.TabOrder = 0

//Dont show tab for Dest-> Cust if consolidating directly to the Customer
If idw_main.RowCount() > 0 Then
	If idw_Main.GetITemString(1,'Ord_type') = 'C' Then /*Consolidating directly to the customer*/
		tab_main.Tabpage_Detail2.Visible = False
		tab_main.Tabpage_Detail3.Visible = False
		tab_main.tabpage_detail1.cb_ship_1.Text = '&Ship to Customer'
	Else /*Warehouse*/
		tab_main.Tabpage_Detail2.Visible = True
		tab_main.tabpage_detail1.cb_ship_1.Text = '&Ship to Dest WH'
	End If
Else
	tab_main.Tabpage_Detail2.Visible = True
End If

iw_Window.TriggerEvent('ue_set_tab_Labels')

Choose Case idw_main.GetItemString(1,"ord_status")
		
	Case "I" /*In Transit - Supplier Source WH */
		
	   im_menu.m_file.m_save.Enabled = True
		im_menu.m_file.m_print.Enabled = True
		im_menu.m_file.m_refresh.Enabled = True
		
		If ib_edit Then
			im_menu.m_record.m_delete.Enabled = True
			im_menu.m_file.m_retrieve.Enabled = True
		Else
			im_menu.m_record.m_delete.Enabled = False
			im_menu.m_file.m_retrieve.Enabled = False
		End If
		
		tab_main.tabpage_detail1.Enabled = True
		tab_main.tabpage_detail2.Enabled = False
		tab_main.tabpage_detail3.Enabled = False
		
		tab_main.tabpage_detail1.cb_Ship_1.Enabled = False
		tab_main.tabpage_detail1.cb_receive_From_Supplier.Enabled = True
		tab_main.tabpage_detail1.cb_Delete1.Enabled = False
		tab_main.tabpage_detail1.cb_add_Orders.Enabled = False
		tab_main.tabpage_detail1.cb_selectall1.Enabled = True
		tab_main.tabpage_detail1.cb_clearall1.Enabled = True
		
		tab_main.tabpage_detail2.cb_receive.Enabled = False
		tab_main.tabpage_detail2.cb_ship_2.Enabled = False
		tab_main.tabpage_detail2.cb_set_dates.Enabled = False
		tab_main.tabpage_detail2.cb_selectall.Enabled = True
		tab_main.tabpage_detail2.cb_clearall.Enabled = True
		
		tab_main.tabpage_main.cb_Confirm.Enabled = False
		
		idw_detail1.modify("carrier.Protect=1 carrier.border=0 awb_bol_no.border=0 awb_bol_no.Protect=1") /* can only change carrier for outbound to cust when on-site */
		idw_detail2.modify("carrier.Protect=1 carrier.border=0 awb_bol_no.border=0 awb_bol_no.Protect=1") /* can only change carrier for outbound to cust when on-site */
		
	Case "N" , "Z" /*New / On-Site - Srce WH */
		
	   im_menu.m_file.m_save.Enabled = True
		im_menu.m_file.m_print.Enabled = True
		im_menu.m_file.m_refresh.Enabled = True
		
		If ib_edit Then
			im_menu.m_record.m_delete.Enabled = True
			im_menu.m_file.m_retrieve.Enabled = True
		Else
			im_menu.m_record.m_delete.Enabled = False
			im_menu.m_file.m_retrieve.Enabled = False
		End If
		
		tab_main.tabpage_detail1.Enabled = True
		tab_main.tabpage_detail2.Enabled = True
		tab_main.tabpage_detail3.Enabled = True
		
		If idw_Detail1.RowCount() > 0 Then
			tab_main.tabpage_detail1.cb_Ship_1.Enabled = True
		Else
			tab_main.tabpage_detail1.cb_Ship_1.Enabled = False
		End If
	
		If idw_detail1.Find("ord_Status='N'",1,idw_Detail1.RowCount()) <=0 Then
			tab_main.tabpage_detail1.cb_receive_From_Supplier.Enabled = False
		Else
			tab_main.tabpage_detail1.cb_receive_From_Supplier.Enabled = True
		End If
		
		tab_main.tabpage_detail1.cb_Delete1.Enabled = True
		tab_main.tabpage_detail1.cb_add_Orders.Enabled = True
		tab_main.tabpage_detail1.cb_selectall1.Enabled = True
		tab_main.tabpage_detail1.cb_clearall1.Enabled = True
		
		tab_main.tabpage_detail2.cb_receive.Enabled = False
		tab_main.tabpage_detail2.cb_ship_2.Enabled = False
		tab_main.tabpage_detail2.cb_set_dates.Enabled = False
		tab_main.tabpage_detail2.cb_selectall.Enabled = True
		tab_main.tabpage_detail2.cb_clearall.Enabled = True
		
		tab_main.tabpage_main.cb_Confirm.Enabled = False
		
		idw_detail1.modify("carrier.Protect=1 carrier.border=0 awb_bol_no.border=0 awb_bol_no.Protect=1") /* can only change carrier for outbound to cust when on-site */
		idw_detail2.modify("carrier.Protect=1 carrier.border=0 awb_bol_no.border=0 awb_bol_no.Protect=1") /* can only change carrier for outbound to cust when on-site */
		
	Case "T" /*In Transit Src->Dest WH*/
		
		im_menu.m_file.m_save.Enabled = True
		im_menu.m_file.m_print.Enabled = True
		im_menu.m_file.m_refresh.Enabled = True
		im_menu.m_record.m_delete.Enabled = False
		
		tab_main.tabpage_detail1.Enabled = True
		tab_main.tabpage_detail2.Enabled = True
		tab_main.tabpage_detail3.Enabled = True
				
		tab_main.tabpage_detail1.cb_Delete1.Enabled = False
		tab_main.tabpage_detail1.cb_add_Orders.Enabled = False
		
		If idw_Detail1.Find("ord_Status <> 'C'",1,idw_detail1.RowCount()) > 0 Then
			tab_main.tabpage_detail1.cb_selectall1.Enabled = True
			tab_main.tabpage_detail1.cb_clearall1.Enabled = True
		Else
			tab_main.tabpage_detail1.cb_selectall1.Enabled = False
			tab_main.tabpage_detail1.cb_clearall1.Enabled = False
		End If
		
		If idw_detail1.Find("ord_Status='P'",1,idw_Detail1.RowCount()) <=0 Then
			tab_main.tabpage_detail1.cb_ship_1.Enabled = False
		Else
			tab_main.tabpage_detail1.cb_ship_1.Enabled = True
		End If
		
		If idw_detail1.Find("ord_Status='N'",1,idw_Detail1.RowCount()) <=0 Then
			tab_main.tabpage_detail1.cb_receive_From_Supplier.Enabled = False
		Else
			tab_main.tabpage_detail1.cb_receive_From_Supplier.Enabled = True
		End If
				
		tab_main.tabpage_detail2.cb_receive.Enabled = True
		tab_main.tabpage_detail2.cb_ship_2.Enabled = False
		tab_main.tabpage_detail2.cb_set_dates.Enabled = True
		tab_main.tabpage_detail2.cb_selectall.Enabled = True
		tab_main.tabpage_detail2.cb_clearall.Enabled = True
		
		//If All of the orders being received are going into inventory, Enable the Confirm button
		If idw_detail2.RowCount() = 0 and idw_detail3.RowCount() > 0 Then
			tab_main.tabpage_main.cb_Confirm.Enabled = True
		Else
			tab_main.tabpage_main.cb_Confirm.Enabled = False
		End If
		
		idw_detail1.modify("carrier.Protect=1 carrier.border=0 awb_bol_no.border=0 awb_bol_no.Protect=1") /* can only change carrier for outbound to cust when on-site */
		idw_detail2.modify("carrier.Protect=1 carrier.border=0 awb_bol_no.border=0 awb_bol_no.Protect=1") /* can only change carrier for outbound to cust when on-site */
		
	Case "D" /* On-site at Destination WH */
		
		im_menu.m_file.m_save.Enabled = True
		im_menu.m_file.m_print.Enabled = True
		im_menu.m_file.m_refresh.Enabled = True
		
		im_menu.m_record.m_delete.Enabled = False
		
		tab_main.tabpage_detail1.Enabled = True
		tab_main.tabpage_detail2.Enabled = True
		tab_main.tabpage_detail3.Enabled = True
				
		tab_main.tabpage_detail1.cb_Delete1.Enabled = False
		tab_main.tabpage_detail1.cb_add_Orders.Enabled = False
		
		If idw_Detail1.Find("ord_Status <> 'C'",1,idw_detail1.RowCount()) > 0 Then
			tab_main.tabpage_detail1.cb_selectall1.Enabled = True
			tab_main.tabpage_detail1.cb_clearall1.Enabled = True
		Else
			tab_main.tabpage_detail1.cb_selectall1.Enabled = False
			tab_main.tabpage_detail1.cb_clearall1.Enabled = False
		End If
		
		If idw_detail1.Find("ord_Status='P'",1,idw_Detail1.RowCount()) <=0 Then
			tab_main.tabpage_detail1.cb_ship_1.Enabled = False
		Else
			tab_main.tabpage_detail1.cb_ship_1.Enabled = True
		End If
		
		If idw_detail1.Find("ord_Status='N'",1,idw_Detail1.RowCount()) <=0 Then
			tab_main.tabpage_detail1.cb_receive_From_Supplier.Enabled = False
		Else
			tab_main.tabpage_detail1.cb_receive_From_Supplier.Enabled = True
		End If
		
		If idw_detail2.Find("ord_Status='H'",1,idw_Detail2.RowCount()) > 0 Then
			tab_main.tabpage_detail2.cb_receive.Enabled = True
		Else
			tab_main.tabpage_detail2.cb_receive.Enabled = False
		End If
		
		tab_main.tabpage_detail2.cb_ship_2.Enabled = True
		tab_main.tabpage_detail2.cb_set_dates.Enabled = True
		
		tab_main.tabpage_detail2.cb_selectall.Enabled = True
		tab_main.tabpage_detail2.cb_clearall.Enabled = True
		
		//If All of the orders being received are going into inventory, Enable the Confirm button
		If idw_detail2.RowCount() = 0 and idw_detail3.RowCount() > 0 Then
			tab_main.tabpage_main.cb_Confirm.Enabled = True
		Else
			tab_main.tabpage_main.cb_Confirm.Enabled = False
		End If
		
		idw_detail1.modify("carrier.Protect=1 carrier.border=0 awb_bol_no.border=0 awb_bol_no.Protect=1") /* can only change carrier for outbound to cust when on-site */
		idw_detail2.modify("carrier.Protect=0 carrier.border=5 awb_bol_no.border=5 awb_bol_no.Protect=0") /* can only change carrier for outbound to cust when on-site */
		
	Case 'S', 'U'/*Shipping from Dest , Shipped to Customer*/
		
		im_menu.m_file.m_save.Enabled = True
		im_menu.m_file.m_print.Enabled = True
		im_menu.m_file.m_refresh.Enabled = True
		
		tab_main.tabpage_detail1.Enabled = True
		tab_main.tabpage_detail2.Enabled = True
		tab_main.tabpage_detail3.Enabled = True
				
		tab_main.tabpage_detail1.cb_Delete1.Enabled = False
		tab_main.tabpage_detail1.cb_add_Orders.Enabled = False
		
		If idw_Detail1.Find("ord_Status <> 'C'",1,idw_detail1.RowCount()) > 0 Then
			tab_main.tabpage_detail1.cb_selectall1.Enabled = True
			tab_main.tabpage_detail1.cb_clearall1.Enabled = True
		Else
			tab_main.tabpage_detail1.cb_selectall1.Enabled = False
			tab_main.tabpage_detail1.cb_clearall1.Enabled = False
		End If
		
		If idw_detail1.Find("ord_Status='P'",1,idw_Detail1.RowCount()) <=0 Then
			tab_main.tabpage_detail1.cb_ship_1.Enabled = False
		Else
			tab_main.tabpage_detail1.cb_ship_1.Enabled = True
		End If
		
		If idw_detail1.Find("ord_Status='N'",1,idw_Detail1.RowCount()) <=0 Then
			tab_main.tabpage_detail1.cb_receive_From_Supplier.Enabled = False
		Else
			tab_main.tabpage_detail1.cb_receive_From_Supplier.Enabled = True
		End If
		
		If idw_detail2.Find("ord_Status='H'",1,idw_Detail2.RowCount()) > 0 Then
			tab_main.tabpage_detail2.cb_receive.Enabled = True
		Else
			tab_main.tabpage_detail2.cb_receive.Enabled = False
		End If
		
		tab_main.tabpage_detail2.cb_ship_2.Enabled = True
		tab_main.tabpage_detail2.cb_set_dates.Enabled = True
		tab_main.tabpage_detail2.cb_selectall.Enabled = True
		tab_main.tabpage_detail2.cb_clearall.Enabled = True
		
		tab_main.tabpage_main.cb_Confirm.Enabled = True
		
		idw_detail1.modify("carrier.Protect=1 carrier.border=0 awb_bol_no.border=0 awb_bol_no.Protect=1") /* can only change carrier for outbound to cust when on-site */
		idw_detail2.modify("carrier.Protect=0 carrier.border=5 awb_bol_no.border=5 awb_bol_no.Protect=0") /* can only change carrier for outbound to cust when on-site */
		
	Case 'C' /*Complete */
		
		im_menu.m_file.m_save.Enabled = True
		im_menu.m_file.m_print.Enabled = True
		im_menu.m_file.m_refresh.Enabled = True
		
		tab_main.tabpage_detail1.Enabled = True
		tab_main.tabpage_detail2.Enabled = True
		tab_main.tabpage_detail3.Enabled = True
				
		tab_main.tabpage_detail1.cb_Delete1.Enabled = False
		tab_main.tabpage_detail1.cb_add_Orders.Enabled = False
		tab_main.tabpage_detail1.cb_ship_1.Enabled = False
		tab_main.tabpage_detail1.cb_receive_From_Supplier.Enabled = False
		tab_main.tabpage_detail1.cb_selectall1.Enabled = False
		tab_main.tabpage_detail1.cb_clearall1.Enabled = False
		
		tab_main.tabpage_detail2.cb_receive.Enabled = False
		tab_main.tabpage_detail2.cb_ship_2.Enabled = False
		tab_main.tabpage_detail2.cb_set_dates.Enabled = False
		tab_main.tabpage_detail2.cb_selectall.Enabled = False
		tab_main.tabpage_detail2.cb_clearall.Enabled = False
		
		tab_main.tabpage_main.cb_Confirm.Enabled = False
		
		idw_detail1.modify("carrier.Protect=1 carrier.border=0 awb_bol_no.border=0 awb_bol_no.Protect=1") /* can only change carrier for outbound to cust when on-site */
		idw_detail2.modify("carrier.Protect=1 carrier.border=0 awb_bol_no.border=0 awb_bol_no.Protect=1") /* can only change carrier for outbound to cust when on-site */
		
End Choose


Return 0
end function

public subroutine setfromwhcode (string acode);// setFromWHCode( string acode )
isFromWH_CD = acode

end subroutine

public subroutine settowhcode (string acode);// setToWHCode( string acode )
isToWH_CD = acode

end subroutine

public function string getfromwhcode ();// string - getFromWHCode()
return isFromWH_CD

end function

public function string gettowhcode ();// string - getToWHCode()
return isToWH_CD

end function

on w_consolidation.create
int iCurrent
call super::create
end on

on w_consolidation.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_postopen;call super::ue_postopen;DatawindowChild	ldwc, ldwc2


ib_changed = False
ib_edit = True
tab_main.MoveTab(2, 99)

iw_window = This

// Storing into variables
idw_main = tab_main.tabpage_main.dw_main
idw_Detail1 = tab_Main.Tabpage_detail1.dw_Detail1
idw_Detail2 = tab_Main.Tabpage_detail2.dw_Detail2
idw_Detail3 = tab_Main.Tabpage_detail3.dw_Detail3
idw_Search = tab_Main.Tabpage_Search.dw_Search
idw_result = tab_Main.Tabpage_Search.dw_Result

isle_Order = tab_main.tabpage_main.sle_Order

//Populate dropdowns based on Project
idw_main.GetChild("from_wh_code",ldwc)
ldwc.SetTransObject(SQLCA)
ldwc.Retrieve(gs_Project)
If ldwc.RowCount() <= 0 Then ldwc.InsertRow(0)

//Share with To warehouse and Search screen
idw_main.GetChild("to_wh_code",ldwc2)
ldwc.Sharedata(ldwc2)

idw_search.GetChild("fr_wh_code",ldwc2)
ldwc.Sharedata(ldwc2)
idw_search.GetChild("to_wh_code",ldwc2)
ldwc.Sharedata(ldwc2)

idw_main.GetChild("Carrier",ldwc)
ldwc.SetTransObject(SQLCA)
ldwc.Retrieve(gs_Project)
If ldwc.RowCount() <= 0 Then ldwc.InsertRow(0)
idw_Search.GetChild("Carrier",ldwc2)
ldwc.Sharedata(ldwc2)

idw_main.GetChild("ord_Type",ldwc)
ldwc.SetTransObject(SQLCA)
ldwc.Retrieve(gs_Project)
If ldwc.RowCount() <= 0 Then ldwc.InsertRow(0)
idw_search.GetChild("ord_Type",ldwc2)
ldwc.Sharedata(ldwc2)
idw_result.GetChild("ord_Type",ldwc2)
ldwc.Sharedata(ldwc2)

idw_detail1.GetChild("ord_Type",ldwc)
ldwc.SetTransObject(SQLCA)
ldwc.Retrieve(gs_Project)
If ldwc.RowCount() <= 0 Then ldwc.InsertRow(0)
idw_detail2.GetChild("ord_Type",ldwc2)
ldwc.Sharedata(ldwc2)


idw_Search.InsertRow(0)

isOrigSearchSQL = idw_result.GetSQLSelect() /*original search criteria SQL */

// Default into edit mode
This.TriggerEvent("ue_edit")
end event

event ue_edit;call super::ue_edit;// Looking for unsaved changes
If wf_save_changes() = -1 Then Return	

This.Title = is_title + " - Edit"
ib_edit = True
ib_changed = False

// Changing menu properties
im_menu.m_file.m_save.Disable()
im_menu.m_file.m_retrieve.Enable()
im_menu.m_record.m_delete.Disable()

// Tab properties
tab_main.tabpage_detail1.Enabled = False
tab_main.tabpage_detail2.Enabled = False
tab_main.tabpage_detail3.Enabled = False

tab_main.tabpage_main.cb_confirm.Enabled = False

wf_clear_screen()

isle_order.Visible=True
isle_order.DisplayOnly = False
isle_order.TabOrder = 10
isle_order.SetFocus()

end event

event ue_retrieve;call super::ue_retrieve;
String	lsOrder,	&
			lsFromWH,	&
			lsTOWH


Decimal	ldWEight
Long		llCartonCount,	&
			llRowPos,		&
			llRowCOunt

lsOrder = isle_Order.Text

idw_Main.Retrieve(gs_Project, lsORder)

If idw_Main.RowCount() > 0 Then
	
	lsFromWH = idw_main.GetITemString(1,'from_wh_code')
	lsTOWH = idw_main.GetITemString(1,'To_wh_code')
	
	//Retrieve Detail Tabs
	idw_detail1.Retrieve('1',gs_Project, lsOrder, lsFromWH) /* Source to Dest WH */
	idw_detail2.Retrieve('2',gs_Project, lsOrder, lsToWH) /* Dest WH to Cust */
	idw_detail3.Retrieve(gs_Project, lsOrder) /* Dest WH to Inv (Inbound Orders) */
	
	wf_check_Status()
	
	This.TriggerEvent('ue_set_tab_Labels') /*include wh name in tab titles */
	
	//Calculate Consolidated Weight and Carton Count if not present
	If isnull(idw_main.GetITemNumber(1,'weight')) or idw_main.GetITemNumber(1,'weight') = 0 or & 
		isnull(idw_main.GetITemNumber(1,'ctn_cnt')) or idw_main.GetITemNumber(1,'ctn_cnt') = 0 Then
		
			llRowCount = idw_Detail1.RowCount()
			ldWEight = 0
			llCartonCount = 0
			For llRowPos = 1 to llRowCount
				ldWeight += idw_Detail1.GetITemNumber(llRowPos,'weight')
				llCartonCount += idw_Detail1.GetITemNumber(llRowPos,'ctn_cnt')
			Next
			idw_Main.SetItem(1,'weight',ldWeight)
			idw_Main.SetItem(1,'ctn_cnt',llCartonCount)
		
	End If
	
Else /* Not Found */
	
	MessageBox(is_title, "Order not found, please enter again!", Exclamation!)
	isle_Order.SetFocus()
	isle_Order.SelectText(1,Len(isle_order.Text))
	
End If


end event

event ue_new;call super::ue_new;Long ll_bol, ll_len, ll_found
String ls_bol

// Acess Rights
//If f_check_access(is_process,"N") = 0 Then Return

// Looking for unsaved changes
If wf_save_changes() = -1 Then Return	

This.Title = is_title + " - New"
ib_edit = False
ib_changed = False

wf_clear_screen()

idw_main.InsertRow(0)

idw_main.SetItem(1, "ord_date", Today())
idw_main.SetItem(1, "from_wh_code", gs_default_wh)
idw_main.SetItem(1, "to_wh_code", gs_default_wh)
idw_main.SetItem(1,"ord_type",'W') /* Warehouse Consol*/
idw_main.SetItem(1, "ord_status", 'N') /*New*/

wf_check_status()
iw_window.TriggerEvent('ue_set_tab_Labels') /*include wh name in tab titles */

isle_order.DisplayOnly = True

isle_order.visible=False
isle_order.TabOrder = 0

idw_main.Show()

idw_main.SetFocus()

Return





end event

event ue_save;Long ll_result

String  ls_prefix,  ls_order, lsMsg
long ll_no, i
Integer	liRC

// Acess Rights
//If f_check_access(is_process,"S") = 0 Then return -1

If idw_main.AcceptText() < 0 Then Return -1

// Validations

SetPointer(HourGlass!)

// pvh 11/23/05 - gmt
datetime ldtToday
ldtToday = f_getLocalWorldTime( gs_default_wh ) 

If idw_main.RowCount() > 0 Then
	ls_order = idw_main.GetItemString(1,"co_no")
	// pvh 11/23/05 - gmt
	idw_main.SetItem(1,'last_update', ldtToday ) 
	// idw_main.SetItem(1,'last_update',Today()) 
	//
	idw_main.SetItem(1,'last_user',gs_userid) 
	If wf_validation() = -1 Then
		SetMicroHelp("Save failed!")
		Return -1
	End If
End If

if ib_edit = false then

	// Assign order no. for new order
	ll_no = g.of_next_db_seq(gs_project,'Consolidation_Master','CO_No')
	
	If ll_no <= 0 Then
		messagebox(is_title,"Unable to retrieve the next available order Number!")
		Return -1
	End If
	
	ls_order = Trim(Left(gs_project,9)) + String(ll_no,"0000000")

	idw_main.setitem(1,"co_no",ls_order)	
	idw_main.setitem(1,"project_id",gs_project)	
			
	isle_order.Visible = FALSE
		
else
	
end if

//Set the Consolidation number if not already set
If IsNull(idw_main.GetITemString(1,'consolidation_no')) Or 	idw_main.GetITemString(1,'consolidation_no') = '' Then
	If Messagebox(is_title,'Consolidation Number is required!~r~rWould you like the system to assign a number?',Question!,yesNo!,1) = 1 Then
		idw_main.SetItem(1, "consolidation_no", Right(ls_order, 7))
	Else
		idw_main.SetFocus()
		idw_Main.SetColumn("consolidation_no")
		Return -1
	End If
End If
	
isle_order.text = idw_main.GetITemString(1,'consolidation_no')
	
//save changes to database

Execute Immediate "Begin Transaction" using SQLCA; /* 11/04 - PCONKL - Auto Commit Turned on to eliminate DB locks*/

If idw_main.RowCount() > 0 Then
	ll_result  = idw_main.Update(False, False)
Else
	ll_result = 1	
End If

//We may be updating Consol #, AWB, or Carrier on the DElivery MAster records
If ll_Result = 1 Then
	ll_result  = idw_detail1.Update(False, False)
End If

If ll_Result = 1 Then
	ll_result  = idw_detail2.Update(False, False)
End If

If ll_result = 1 Then
	Execute Immediate "COMMIT" using SQLCA;
	If SQLCA.SQLCode = 0 Then
				
	  	idw_main.ResetUpdate()
   	
		If idw_main.RowCount() > 0 Then
			This.Title = is_title + " - Edit"
			ib_changed = False
			ib_edit = True
			wf_check_status()
			idw_main.SetFocus()
		End If
		SetMicroHelp("Record Saved!")
//		Return 0 
   Else
		Execute Immediate "ROLLBACK" using SQLCA;
		lsMsg = "Unable to save Consolidation Record!~r~r"
		If Not isnull(SQLCA.SQLErrText) Then /*if errtext is null, we get no msg - datastores dont return error codes like DW's*/
			lsMsg += SQLCA.SQLErrText
		End If
     	MessageBox(is_title, lsMsg)
		SetMicroHelp("Save failed!")
		return -1
	End If
Else
   Execute Immediate "ROLLBACK" using SQLCA;
  	lsMsg = "Unable to save Consolidation Record!~r~r"
	If Not isnull(SQLCA.SQLErrText) Then /*if errtext is null, we get no msg - datastores dont return error codes like DW's*/
		lsMsg += SQLCA.SQLErrText
	End If
   MessageBox(is_title, lsMsg)
	SetMicroHelp("Save Failed!")
	return -1
End If

Return 0 
end event

event ue_accept_text;call super::ue_accept_text;
idw_Main.AcceptText()
end event

event open;call super::open;
i_nwarehouse = Create n_warehouse
end event

event ue_close;call super::ue_close;
Destroy i_nwarehouse
end event

event resize;call super::resize;tab_main.Resize(workspacewidth(),workspaceHeight())
tab_main.tabpage_detail1.dw_detail1.Resize(workspacewidth() - 80,workspaceHeight()-300)
tab_main.tabpage_detail2.dw_detail2.Resize(workspacewidth() - 80,workspaceHeight()-300)
tab_main.tabpage_detail3.dw_detail3.Resize(workspacewidth() - 80,workspaceHeight()-50)
tab_main.tabpage_search.dw_result.Resize(workspacewidth() - 80,workspaceHeight()- 700)
end event

event ue_delete;call super::ue_delete;String	lsCOLNo,	&
			lsMsg
Long	llRC


If Messagebox(is_title,"Are you sure you want to delete this Consolidation?",Question!,YesNo!,2) = 2 Then REturn

lsCOLNO = idw_Main.GetITemString(1,'Consolidation_NO')
If isnull(lsColNo) or lsColNo = '' Then Return

//Remove the Consolidation No from all Delivery ORders that have this number

Execute Immediate "Begin Transaction" using SQLCA; /* 11/04 - PCONKL - Auto Commit Turned on to eliminate DB locks*/

Update Delivery_Master set Consolidation_no = "" Where Project_id = :gs_Project and consolidation_no = :lsColNO
USing SQLCA;

idw_main.DeleteRow(1)

llRC = idw_Main.Update()
If llRC = 1 Then
	Execute Immediate "COMMIT" using SQLCA;
Else
	Execute Immediate "ROLLBACK" using SQLCA;
	lsMsg = "Unable to Delete Consolidation Record!~r~r"
		If Not isnull(SQLCA.SQLErrText) Then /*if errtext is null, we get no msg - datastores dont return error codes like DW's*/
			lsMsg += SQLCA.SQLErrText
		End If
     	MessageBox(is_title, lsMsg)
End If

ib_changed = False

//If This.Trigger Event ue_save() = 0 Then
//	SetMicroHelp("Record deleted!")
//Else
//	SetMicroHelp("Record	deleted failed!")
//End If

This.Trigger Event ue_edit()
end event

type tab_main from w_std_master_detail`tab_main within w_consolidation
integer x = 0
integer y = 0
integer width = 3598
integer height = 1836
boolean fixedwidth = false
tabpage_detail1 tabpage_detail1
tabpage_detail2 tabpage_detail2
tabpage_detail3 tabpage_detail3
end type

on tab_main.create
this.tabpage_detail1=create tabpage_detail1
this.tabpage_detail2=create tabpage_detail2
this.tabpage_detail3=create tabpage_detail3
int iCurrent
call super::create
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tabpage_detail1
this.Control[iCurrent+2]=this.tabpage_detail2
this.Control[iCurrent+3]=this.tabpage_detail3
end on

on tab_main.destroy
call super::destroy
destroy(this.tabpage_detail1)
destroy(this.tabpage_detail2)
destroy(this.tabpage_detail3)
end on

event tab_main::selectionchanged;call super::selectionchanged;
	
IlHelpTopicID = 0

Choose Case NewIndex
	Case 1 /*order Info*/
		wf_check_menu(False,'sort')
		wf_check_menu(False,'filter')
		idw_current = idw_main
	CAse 2 /*Order Detail1*/
		wf_check_menu(TRUE,'sort') 
		wf_check_menu(TRUE,'filter')
		idw_current = idw_detail1
	Case 3 /*Order Detail 2*/
		wf_check_menu(True,'sort') 
		wf_check_menu(TRUE,'filter')
		idw_current = idw_detail2
	Case 4 /*Order Detail 3*/
		wf_check_menu(True,'sort') 
		wf_check_menu(TRUE,'filter')
		idw_current = idw_detail3
	Case 5 /*search Tab*/
		idw_current = idw_result
	   wf_check_menu(TRUE,'sort')
		wf_check_menu(TRUE,'filter')
End Choose
		
end event

type tabpage_main from w_std_master_detail`tabpage_main within tab_main
integer width = 3561
integer height = 1708
string text = "Order Info"
cb_confirm cb_confirm
sle_order sle_order
st_1 st_1
dw_main dw_main
end type

on tabpage_main.create
this.cb_confirm=create cb_confirm
this.sle_order=create sle_order
this.st_1=create st_1
this.dw_main=create dw_main
int iCurrent
call super::create
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_confirm
this.Control[iCurrent+2]=this.sle_order
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.dw_main
end on

on tabpage_main.destroy
call super::destroy
destroy(this.cb_confirm)
destroy(this.sle_order)
destroy(this.st_1)
destroy(this.dw_main)
end on

type tabpage_search from w_std_master_detail`tabpage_search within tab_main
integer width = 3561
integer height = 1708
dw_result dw_result
cb_clear cb_clear
cb_search cb_search
dw_search dw_search
end type

on tabpage_search.create
this.dw_result=create dw_result
this.cb_clear=create cb_clear
this.cb_search=create cb_search
this.dw_search=create dw_search
int iCurrent
call super::create
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_result
this.Control[iCurrent+2]=this.cb_clear
this.Control[iCurrent+3]=this.cb_search
this.Control[iCurrent+4]=this.dw_search
end on

on tabpage_search.destroy
call super::destroy
destroy(this.dw_result)
destroy(this.cb_clear)
destroy(this.cb_search)
destroy(this.dw_search)
end on

type cb_confirm from commandbutton within tabpage_main
integer x = 1454
integer y = 1580
integer width = 407
integer height = 104
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Confirm"
end type

event clicked;
iw_window.TriggerEvent('ue_Confirm')
end event

type sle_order from singlelineedit within tabpage_main
integer x = 549
integer y = 52
integer width = 654
integer height = 76
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

event modified;
iw_window.TriggerEvent('ue_Retrieve')
end event

event getfocus;
If This.text <> '' then
	This.SelectText(1, Len(Trim(This.Text)))
end If
end event

type st_1 from statictext within tabpage_main
integer x = 55
integer y = 60
integer width = 475
integer height = 64
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = 67108864
string text = "Consolidation No:"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_main from u_dw_ancestor within tabpage_main
integer x = 5
integer y = 28
integer width = 3520
integer height = 1516
integer taborder = 20
string dataobject = "d_consolidation_master"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event process_enter;call super::process_enter;Send(Handle(This),256,9,Long(0,0))
Return 1
end event

event itemchanged;call super::itemchanged;Long	llCount,	&
		llRowCount,	&
		llRowPos

ib_changed = True

// pvh 08/25/05 - GMT
// Broke out the from and to warehose case statements
// and added sets
//
Choose Case Upper(dwo.name)
		
	Case "FR_WH_CODE"  /*include wh name in tab titles if from or To WH changes */
		iw_window.PostEvent('ue_set_tab_Labels') 
		setFromWhCode( Trim(data) )
		
	Case "TO_WH_CODE"  /*include wh name in tab titles if from or To WH changes */
		iw_window.PostEvent('ue_set_tab_Labels') 
		setToWhCode( Trim(data) )
		
	Case 'CONSOLIDATION_NO' /* if changed, make sure i doesn't already exist in the DB, otherwise update any new orders */
		
		Select Count(*) into :llCount
		From Consolidation_MAster where Project_id = :gs_project and consolidation_no = :data;

		If llCount > 0 Then
			Messagebox(is_title,'This Consolidation Number has already been used!',StopSign!)
			REturn 1
		End If
		
		//Update new Consol Number on First detail screen - will only allow changes for new status (controlled in DW)
		llRowCOunt = idw_Detail1.RowCount()
		For llRowPos = 1 to llRowCount
			idw_detail1.SetITem(llRowPos,'Consolidation_no',data)
		Next
		
End Choose
end event

event itemerror;call super::itemerror;
Return 2
end event

event retrieveend;call super::retrieveend;// pvh 08/25/05 - GMT

if rowcount <= 0 then return AncestorReturnValue

setFromWhCode( dw_main.object.from_wh_code[ 1 ]  )
setToWhCode( dw_main.object.to_wh_code[ 1 ]  )

return AncestorReturnValue


end event

type dw_result from u_dw_ancestor within tabpage_search
integer x = 9
integer y = 552
integer width = 3502
integer height = 1092
integer taborder = 20
string dataobject = "d_consolidation_result"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event ue_retrieve;call super::ue_retrieve;String	lsWhere,	&
			lsNewSql
			
Boolean	lbJoinMaster

idw_search.AcceptText()

lsNewSQL = isORigSearchSQL

//Tackon search Criteria to existing SQL

lbJoinMaster = False

lsWhere = " Where Consolidation_MAster.Project_ID = '" + gs_project + "'" /*Always tackon project*/

//Consolidation Nbr - LIKE
If idw_Search.GetItemString(1,'Consolidation_no') > '' Then
	lsWhere += " and Consolidation_MAster.consolidation_no Like '%" + idw_Search.GetItemString(1,'Consolidation_no') + "%'"
End If

//Order Type
If idw_Search.GetItemString(1,'ord_Type') > '' Then
	lsWhere += " and Consolidation_MAster.ord_Type = '" + idw_Search.GetItemString(1,'ord_Type') + "'"
End If

//Order Status
If idw_Search.GetItemString(1,'ord_Status') > '' Then
	lsWhere += " and Consolidation_MAster.ord_Status = '" + idw_Search.GetItemString(1,'ord_Status') + "'"
End If

//Source WH
If idw_Search.GetItemString(1,'fr_wh_code') > '' Then
	lsWhere += " and from_wh_code = '" + idw_Search.GetItemString(1,'fr_wh_code') + "'"
End If

//Dest WH
If idw_Search.GetItemString(1,'to_wh_code') > '' Then
	lsWhere += " and to_wh_code = '" + idw_Search.GetItemString(1,'to_wh_code') + "'"
End If

//House AWB BOL NBR
If idw_Search.GetItemString(1,'awb_bol_nbr') > '' Then
	lsWhere += " and Consolidation_MAster.awb_bol_nbr = '" + idw_Search.GetItemString(1,'awb_bol_nbr') + "'"
End If

// Master AWB BOL NBR
If idw_Search.GetItemString(1,'master_awb_bol_nbr') > '' Then
	lsWhere += " and Consolidation_MAster.master_awb_bol_no = '" + idw_Search.GetItemString(1,'master_awb_bol_nbr') + "'"
End If

//Carrier
If idw_Search.GetItemString(1,'Carrier') > '' Then
	lsWhere += " and Consolidation_MAster.Carrier = '" + idw_Search.GetItemString(1,'Carrier') + "'"
End If

//Order Number - 
If idw_Search.GetItemString(1,'order_no') > '' Then
	lbJoinMaster = True /* we need to tack on Delivery Master to Tables and joins */
	lsWhere += " and delivery_master.invoice_no Like '%" + idw_Search.GetItemString(1,'order_no') + "%'"
End If

//Delivery MAster UF 4 (Sales Order # for Pulse) 
If idw_Search.GetItemString(1,'user_field4') > '' Then
	lbJoinMaster = True /* we need to tack on Delivery Master to Tables and joins */
	lsWhere += " and delivery_master.user_field4 = '" + idw_Search.GetItemString(1,'user_Field4') + "'"
End If

//Order Date From
If not isnull(idw_Search.GetItemDateTime(1,'order_date_from'))  Then
	lsWhere += " and Consolidation_MAster.ord_date >= '" + String(idw_Search.GetItemDateTime(1,'order_date_from'), "yyyy-mm-dd hh:mm:ss")  + "'"
End If 

//Order Date To
If not isnull(idw_Search.GetItemDateTime(1,'order_date_to'))  Then
	lsWhere += " and Consolidation_MAster.ord_date <= '" + String(idw_Search.GetItemDateTime(1,'order_date_to'), "yyyy-mm-dd hh:mm:ss")  + "'"
End If

//Ship Date From
If not isnull(idw_Search.GetItemDateTime(1,'ship_date_from'))  Then
	lsWhere += " and Consolidation_MAster.ship_date >= '" + String(idw_Search.GetItemDateTime(1,'ship_date_from'), "yyyy-mm-dd hh:mm:ss")  + "'"
End If 

//Ship Date To
If not isnull(idw_Search.GetItemDateTime(1,'Ship_date_to'))  Then
	lsWhere += " and Consolidation_MAster.ship_date <= '" + String(idw_Search.GetItemDateTime(1,'Ship_date_to'), "yyyy-mm-dd hh:mm:ss")  + "'"
End If

//Receive Date From
If not isnull(idw_Search.GetItemDateTime(1,'receive_date_from'))  Then
	lsWhere += " and Consolidation_MAster.receive_date >= '" + String(idw_Search.GetItemDateTime(1,'receive_date_from'), "yyyy-mm-dd hh:mm:ss")  + "'"
End If 

//Receive Date To
If not isnull(idw_Search.GetItemDateTime(1,'receive_date_to'))  Then
	lsWhere += " and Consolidation_MAster.receive_date <= '" + String(idw_Search.GetItemDateTime(1,'receive_date_to'), "yyyy-mm-dd hh:mm:ss")  + "'"
End If

//Sched Arrival Date From
If not isnull(idw_Search.GetItemDateTime(1,'sched_arrival_from'))  Then
	lsWhere += " and Consolidation_MAster.sched_arrival_date >= '" + String(idw_Search.GetItemDateTime(1,'sched_arrival_from'), "yyyy-mm-dd hh:mm:ss")  + "'"
End If 

//Sched Arrival Date To
If not isnull(idw_Search.GetItemDateTime(1,'sched_arrival_to'))  Then
	lsWhere += " and Consolidation_MAster.sched_arrival_date <= '" + String(idw_Search.GetItemDateTime(1,'sched_arrival_to'), "yyyy-mm-dd hh:mm:ss")  + "'"
End If

//Port Arrival Date From
If not isnull(idw_Search.GetItemDateTime(1,'freight_ata_from'))  Then
	lsWhere += " and Consolidation_MAster.Port_arrival_date >= '" + String(idw_Search.GetItemDateTime(1,'freight_ata_from'), "yyyy-mm-dd hh:mm:ss")  + "'"
End If 

//Freight ATA Date To
If not isnull(idw_Search.GetItemDateTime(1,'freight_ata_to'))  Then
	lsWhere += " and Consolidation_MAster.Port_arrival_date <= '" + String(idw_Search.GetItemDateTime(1,'freight_ata_to'), "yyyy-mm-dd hh:mm:ss")  + "'"
End If

//Customs Cleared Date From 
If not isnull(idw_Search.GetItemDateTime(1,'customs_cleared_from'))  Then
	lsWhere += " and Consolidation_MAster.customs_clearance_date >= '" + String(idw_Search.GetItemDateTime(1,'customs_cleared_from'), "yyyy-mm-dd hh:mm:ss")  + "'"
End If 

//Customs Cleared Date To
If not isnull(idw_Search.GetItemDateTime(1,'customs_cleared_to'))  Then
	lsWhere += " and Consolidation_MAster.customs_clearance_date <= '" + String(idw_Search.GetItemDateTime(1,'customs_cleared_to'), "yyyy-mm-dd hh:mm:ss")  + "'"
End If

//Carrier Notified Date From (Delivery Master)
If not isnull(idw_Search.GetItemDateTime(1,'carrier_notified_from'))  Then
	lbJoinMaster = True /* we need to tack on Delivery Master to Tables and joins */
	lsWhere += " and Delivery_MAster.carrier_notified_date >= '" + String(idw_Search.GetItemDateTime(1,'carrier_notified_from'), "yyyy-mm-dd hh:mm:ss")  + "'"
End If 

//Carrier Notified Date To
If not isnull(idw_Search.GetItemDateTime(1,'carrier_notified_to'))  Then
	lbJoinMaster = True /* we need to tack on Delivery Master to Tables and joins */
	lsWhere += " and Delivery_MAster.carrier_notified_date <= '" + String(idw_Search.GetItemDateTime(1,'carrier_notified_to'), "yyyy-mm-dd hh:mm:ss")  + "'"
End If


If lbJoinMaster Then /* including fields from Delivery MAster, add Joins */
	lsWhere += " and Delivery_MAster.Project_ID = Consolidation_MAster.Project_ID and Delivery_MAster.Consolidation_no = Consolidation_Master.Consolidation_no"
	lsNewSQL = Replace(lsNewSQL,Pos(lsNewSQL,"FROM Consolidation_Master"),25, "FROM Consolidation_Master, DElivery_MAster")
End If

//warn if no sql tacked on
If Pos(lsWhere," and ") <=0 Then
	IF	i_nwarehouse.of_msg(is_title,1) <> 1 THEN Return
End If

lsNewSql += lsWhere
this.SetSQLSelect(lsNewSQL)

This.Retrieve()

If This.RowCount() <=0 Then
	messagebox(is_title,"No records found!")
End If
end event

event clicked;call super::clicked;//If row is clicked then highlight the row
IF row > 0 THEN
	This.SelectRow(0, FALSE)
	This.SelectRow(row, TRUE)
END IF
end event

event doubleclicked;call super::doubleclicked;
// Pasting the record to the main entry datawindow
string ls_code

IF Row > 0 THEN
	iw_window.TriggerEvent("ue_edit")
	If ib_changed = False and ib_edit = True Then
		ls_code = this.getitemstring(row,'consolidation_no')
		isle_order.text = ls_code
		iw_Window.TriggerEvent('ue_retrieve')
	End If
END IF
end event

type cb_clear from commandbutton within tabpage_search
integer x = 3241
integer y = 140
integer width = 302
integer height = 92
integer taborder = 40
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Clear"
end type

event clicked;idw_Search.Reset()
idw_Search.InsertRow(0)

idw_Result.Reset()

end event

type cb_search from commandbutton within tabpage_search
integer x = 3241
integer y = 36
integer width = 302
integer height = 92
integer taborder = 30
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Search"
boolean default = true
end type

event clicked;
idw_Result.TriggerEvent('ue_Retrieve')
end event

type dw_search from u_dw_ancestor within tabpage_search
integer x = 23
integer y = 8
integer width = 3506
integer height = 548
integer taborder = 20
string dataobject = "d_consolidation_search"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event process_enter;call super::process_enter;Send(Handle(This),256,9,Long(0,0))
Return 1
end event

type tabpage_detail1 from userobject within tab_main
integer x = 18
integer y = 112
integer width = 3561
integer height = 1708
long backcolor = 79741120
string text = "Source -> Dest WH"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
cb_clearall1 cb_clearall1
cb_selectall1 cb_selectall1
st_2 st_2
cb_receive_from_supplier cb_receive_from_supplier
cb_ship_1 cb_ship_1
cb_delete1 cb_delete1
cb_add_orders cb_add_orders
dw_detail1 dw_detail1
end type

on tabpage_detail1.create
this.cb_clearall1=create cb_clearall1
this.cb_selectall1=create cb_selectall1
this.st_2=create st_2
this.cb_receive_from_supplier=create cb_receive_from_supplier
this.cb_ship_1=create cb_ship_1
this.cb_delete1=create cb_delete1
this.cb_add_orders=create cb_add_orders
this.dw_detail1=create dw_detail1
this.Control[]={this.cb_clearall1,&
this.cb_selectall1,&
this.st_2,&
this.cb_receive_from_supplier,&
this.cb_ship_1,&
this.cb_delete1,&
this.cb_add_orders,&
this.dw_detail1}
end on

on tabpage_detail1.destroy
destroy(this.cb_clearall1)
destroy(this.cb_selectall1)
destroy(this.st_2)
destroy(this.cb_receive_from_supplier)
destroy(this.cb_ship_1)
destroy(this.cb_delete1)
destroy(this.cb_add_orders)
destroy(this.dw_detail1)
end on

type cb_clearall1 from commandbutton within tabpage_detail1
integer x = 315
integer y = 16
integer width = 265
integer height = 80
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Clear All"
end type

event clicked;idw_detail1.TriggerEvent('ue_Clear_all')
end event

type cb_selectall1 from commandbutton within tabpage_detail1
integer x = 18
integer y = 16
integer width = 270
integer height = 80
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Select All"
end type

event clicked;
idw_detail1.TriggerEvent('ue_Select_all')
end event

type st_2 from statictext within tabpage_detail1
integer x = 2798
integer y = 56
integer width = 763
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Double Click an order to Edit"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_receive_from_supplier from commandbutton within tabpage_detail1
integer x = 1650
integer y = 16
integer width = 608
integer height = 80
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "R&eceive from Supplier"
end type

event clicked;
iw_Window.TriggerEvent('ue_receive_from_Supplier')
end event

type cb_ship_1 from commandbutton within tabpage_detail1
integer x = 2286
integer y = 16
integer width = 498
integer height = 80
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Ship to Dest WH"
end type

event clicked;
iw_Window.TriggerEvent('ue_ship_to_dest')
end event

type cb_delete1 from commandbutton within tabpage_detail1
integer x = 718
integer y = 16
integer width = 434
integer height = 80
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Remove Orders"
end type

event clicked;
idw_detail1.TriggerEvent('ue_Delete')
end event

type cb_add_orders from commandbutton within tabpage_detail1
integer x = 1179
integer y = 16
integer width = 352
integer height = 80
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Add Orders"
end type

event clicked;
idw_detail1.TriggErEvent('ue_add_orders')


end event

type dw_detail1 from u_dw_ancestor within tabpage_detail1
event ue_select_all ( )
event ue_clear_all ( )
event ue_add_orders ( )
integer y = 112
integer width = 3410
integer height = 1484
integer taborder = 20
string dataobject = "d_consolidation_detail"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
end type

event ue_select_all;Long	llRowCount, llrowPos

llRowCount = This.RowCount()
For llRowPOs = 1 to llRowCount
	This.SetItem(llRowPos,'c_select_ind','Y')
Next
end event

event ue_clear_all;
Long	llRowCount, llrowPos

llRowCount = This.RowCount()
For llRowPOs = 1 to llRowCount
	This.SetItem(llRowPos,'c_select_ind','N')
Next
end event

event ue_add_orders;Str_Parms	lstrparms
Long			llRowPos,	&
				llRowCount
				
String		lsCarrier,	&
				lsAWB

If idw_main.GetITemString(1,'consolidation_no') = '' or isnull(idw_main.GetITemString(1,'consolidation_no')) Then
	Messagebox(is_title,'Please save your changes first.')
	REturn
End If

Lstrparms.String_arg[1] = idw_main.GetITemString(1,'consolidation_no')
OpenWithParm(w_select_consol_do,lstrparms)
Lstrparms = Message.PowerObjectParm

If Not lstrparms.Cancelled Then iw_window.TriggerEvent('ue_Retrieve')

This.SetRedraw(True)
SetPointer(Arrow!)
end event

event process_enter;call super::process_enter;Send(Handle(This),256,9,Long(0,0))
Return 1
end event

event itemchanged;call super::itemchanged;If dwo.name <> 'c_select_ind' Then ib_changed = True
end event

event ue_delete;call super::ue_delete;
Long	llRowCOunt,	&
		llRowPos
		

If This.Find("c_select_ind = 'Y'",1,This.RowCount()) <=0 Then
	Messagebox(is_title,'At least one order must be checked for removal.')
	Return
ElseIf MessageBox(is_title,'Are you sure you want to REMOVE the checked order(s) from this Consolidation?',Question!,YesNo!,2) = 21 Then
	Return
End If

llRowCount = This.RowCount()
For llRowPos = 1 to llRowCount
	
	If This.GetITemString(llRowPos,'c_Select_ind') <> 'Y' Then Continue
	
	This.SetItem(llRowPos,'Consolidation_no','') /*just remove the order from this consolidation, we're not deleting it*/
	
Next

iw_window.TriggerEvent('ue_save')
iw_window.TriggerEvent('ue_retrieve')
end event

event clicked;call super::clicked;
//If row is clicked then highlight the row
IF row > 0 THEN
	This.SelectRow(0, FALSE)
	This.SelectRow(row, TRUE)
END IF
end event

event doubleclicked;call super::doubleclicked;
String	lsDONO

str_parms	lstrParms

If row > 0 Then
	
	Lstrparms.String_arg[1] = "W_DOR"
	Lstrparms.String_arg[2] = '*DONO*' + This.GetITemString(row,'do_no') /* *dono will tell DO to retrieve by DONO instead of the default order number */
	OpenSheetwithparm(w_do,lStrparms, w_main, gi_menu_pos, Original!)
		
End If
end event

event constructor;call super::constructor;
This.Modify("freight_ata.width=0 carrier_notified_date.width=0 customs_clearance_date.width=0")
end event

type tabpage_detail2 from userobject within tab_main
integer x = 18
integer y = 112
integer width = 3561
integer height = 1708
long backcolor = 79741120
string text = "Dest WH -> Cust"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
cb_set_dates cb_set_dates
cb_print cb_print
cb_clearall cb_clearall
cb_selectall cb_selectall
cb_ship_2 cb_ship_2
cb_receive cb_receive
dw_detail2 dw_detail2
end type

on tabpage_detail2.create
this.cb_set_dates=create cb_set_dates
this.cb_print=create cb_print
this.cb_clearall=create cb_clearall
this.cb_selectall=create cb_selectall
this.cb_ship_2=create cb_ship_2
this.cb_receive=create cb_receive
this.dw_detail2=create dw_detail2
this.Control[]={this.cb_set_dates,&
this.cb_print,&
this.cb_clearall,&
this.cb_selectall,&
this.cb_ship_2,&
this.cb_receive,&
this.dw_detail2}
end on

on tabpage_detail2.destroy
destroy(this.cb_set_dates)
destroy(this.cb_print)
destroy(this.cb_clearall)
destroy(this.cb_selectall)
destroy(this.cb_ship_2)
destroy(this.cb_receive)
destroy(this.dw_detail2)
end on

type cb_set_dates from commandbutton within tabpage_detail2
integer x = 2075
integer y = 12
integer width = 402
integer height = 80
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Set Dates"
end type

event clicked;
iw_Window.TriggerEvent('ue_set_dates')
end event

type cb_print from commandbutton within tabpage_detail2
integer x = 3191
integer y = 12
integer width = 261
integer height = 80
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Print"
end type

event clicked;
OpenSheet(w_consolidation_Report,w_main, gi_menu_pos, Original!)
end event

type cb_clearall from commandbutton within tabpage_detail2
integer x = 338
integer y = 12
integer width = 293
integer height = 80
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Clear All"
end type

event clicked;
idw_detail2.TriggerEvent('ue_clearall')
end event

type cb_selectall from commandbutton within tabpage_detail2
integer x = 9
integer y = 12
integer width = 311
integer height = 80
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Select All"
end type

event clicked;
idw_detail2.TriggerEvent('ue_selectall')
end event

type cb_ship_2 from commandbutton within tabpage_detail2
integer x = 1463
integer y = 12
integer width = 485
integer height = 80
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Ship  to Cust"
end type

event clicked;
iw_Window.TriggerEvent('ue_ship_to_Cust')
end event

type cb_receive from commandbutton within tabpage_detail2
integer x = 704
integer y = 12
integer width = 709
integer height = 80
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Receive from Source WH"
end type

event clicked;

iw_Window.TriggerEvent('ue_receive_from_source')
end event

type dw_detail2 from u_dw_ancestor within tabpage_detail2
event ue_selectall ( )
event ue_clearall ( )
integer y = 112
integer width = 3401
integer height = 1448
integer taborder = 20
string dataobject = "d_consolidation_detail"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
end type

event ue_selectall;Long	llRowCount,	llRowPos

This.SetRedraw(False)
llRowCount = This.rowCount()
For llRowPos = 1 to llRowCount
	If This.GetITemString(llRowPos,'ord_status') <> 'C' Then
		This.SetITem(llRowPos,'c_select_ind','Y')
	End If
Next
This.SetRedraw(True)
end event

event ue_clearall;Long	llRowCount,	llRowPos

This.SetRedraw(False)
llRowCount = This.rowCount()
For llRowPos = 1 to llRowCount
	This.SetITem(llRowPos,'c_select_ind','N')
Next
This.SetRedraw(True)
end event

event process_enter;call super::process_enter;Send(Handle(This),256,9,Long(0,0))
Return 1
end event

event itemchanged;call super::itemchanged;
If dwo.name <> 'c_select_ind' Then ib_changed = True
end event

event doubleclicked;call super::doubleclicked;

String	lsDONO

str_parms	lstrParms

If row > 0 Then
	
	Lstrparms.String_arg[1] = "W_DOR"
	Lstrparms.String_arg[2] = '*DONO*' + This.GetITemString(row,'do_no') /* *dono will tell DO to retrieve by DONO instead of the default order number */
	OpenSheetwithparm(w_do,lStrparms, w_main, gi_menu_pos, Original!)
		
End If
end event

event clicked;call super::clicked;

//If row is clicked then highlight the row
IF row > 0 THEN
	This.SelectRow(0, FALSE)
	This.SelectRow(row, TRUE)
END IF
end event

type tabpage_detail3 from userobject within tab_main
integer x = 18
integer y = 112
integer width = 3561
integer height = 1708
long backcolor = 79741120
string text = "Dest WH ->Inventory"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
st_4 st_4
dw_detail3 dw_detail3
end type

on tabpage_detail3.create
this.st_4=create st_4
this.dw_detail3=create dw_detail3
this.Control[]={this.st_4,&
this.dw_detail3}
end on

on tabpage_detail3.destroy
destroy(this.st_4)
destroy(this.dw_detail3)
end on

type st_4 from statictext within tabpage_detail3
integer x = 2587
integer y = 4
integer width = 773
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Double Click an order to Edit"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_detail3 from u_dw_ancestor within tabpage_detail3
integer x = 9
integer y = 68
integer width = 3465
integer height = 1588
integer taborder = 20
string dataobject = "d_consolidation_receive_detail"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
end type

event clicked;call super::clicked;

//If row is clicked then highlight the row
IF row > 0 THEN
	This.SelectRow(0, FALSE)
	This.SelectRow(row, TRUE)
END IF
end event

event doubleclicked;call super::doubleclicked;


String	lsDONO

str_parms	lstrParms

If row > 0 Then
	
	Lstrparms.String_arg[1] = "W_DOR"
	Lstrparms.String_arg[2] = '*RONO*' + This.GetITemString(row,'ro_no') /* *rono will tell RO to retrieve by RONO instead of the default order number */
	OpenSheetwithparm(w_ro,lStrparms, w_main, gi_menu_pos, Original!)
		
End If
end event

