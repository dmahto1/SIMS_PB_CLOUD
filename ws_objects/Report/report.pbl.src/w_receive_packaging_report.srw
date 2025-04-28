$PBExportHeader$w_receive_packaging_report.srw
$PBExportComments$Recieve Packaging Report
forward
global type w_receive_packaging_report from w_std_report
end type
type pb_create_do from picturebutton within w_receive_packaging_report
end type
end forward

global type w_receive_packaging_report from w_std_report
integer width = 3552
integer height = 2044
string title = "Receive Packaging Report"
event ue_create_do ( )
pb_create_do pb_create_do
end type
global w_receive_packaging_report w_receive_packaging_report

type variables
String	isOrigSQL
end variables

event ue_create_do();//Create a delivery order for the packaging in the report

Long		llRowPos,	&
			llRowCount,	&
			llArrayPos,	&
			llOwner,		&
			llCount
			
Decimal	ldDoNo,ldQty[]
String	lsDONo,	&
			lsOrderNo,	&
			lsErrText,	&
			lsSKU,		&
			lsSKUHold,	&
			lsSupplier,		&
			lsSupplierHold,	&
			lsSKUarray[],	&
			lsSUpplierArray[],	&
			lsOrdType

DateTime	ldToday

// pvh 02.15.06 - gmt
ldToday = f_getLocalWorldTime( gs_default_wh ) 

//make sure the DW is sorted properly
dw_report.SetSort("sku_Child A, supp_code_child A")
dw_report.Sort()

SetPointer(Hourglass!)

llRowCount = dw_report.RowCount()

//Loop through and total the qty for each sku
For llRowPos = 1 to llRowCount
	
	lsSKU = dw_report.GetITemString(llRowPos,'sku_Child')
	lsSupplier = dw_report.GetITemString(llRowPos,'supp_code_Child')
	
	If (lsSKU <> lsSKUHold) or (lsSupplier <> lsSupplierHold) Then /*SKU has changed */
		llArrayPos ++
		lsSKUArray[llArrayPos] = lsSKU
		lsSupplierArray[llArrayPos] = lsSupplier
		ldQty[llArrayPos] = dw_report.Object.c_ext_qty[llRowPos]
	Else /*add same sku to existing QTY */
		ldQty[llArrayPos] = ldQty[llArrayPos] +  dw_report.Object.c_ext_qty[llRowPos]
	End If /*sku changed*/
	
	lsSKUHold = lsSKU
	lsSupplierHold = lsSupplier
	
Next /*report Row*/
	
If Upperbound(lsSKUArray) <=0  Then
	Messagebox(is_title,'There are no Details for a Delivery Order')
	Return
End If


//create the Delivery Master Record
//Get the next available DONO

//If we don't an Order Type of Packaging, default to 'S'
Select Count(*) into :llCount
From Delivery_order_Type
Where Project_id = :gs_Project and ord_type = "P";

If llCount > 0 Then
	lsOrdType = 'P'
Else
	lsOrdType = 'S'
End If

lddono = g.of_next_db_seq(gs_project,"Delivery_Master","DO_No" )//get the next available DO_NO
lsDoNO = gs_Project + String(Long(ldDoNo),"0000000") 
lsOrderNo = Right(lsDoNo,7)

Execute Immediate "Begin Transaction" using SQLCA; /* 11/04 - PCONKL - Auto Commit Turned on to eliminate DB locks*/

Insert Into Delivery_Master (Do_no, Project_id,Ord_date,Ord_status,Ord_Type,Inventory_type,
							wh_code,invoice_no,Freight_Cost,Cust_code,LAst_user,LASt_Update)
Values (:lsDONO,:gs_project,:ldToday,'N',:lsOrdType,'N',
			:gs_default_wh,:lsOrderNo,0,'N/A',:gs_userid,:ldToday)
Using SQLCA;
		
If sqlca.sqlcode <> 0 Then
	lsErrText = sqlca.sqlerrtext /*text will be lost after rollback*/
	Execute Immediate "ROLLBACK" using SQLCA;
	Messagebox("Import"," Unable to save new Delivery Master record to database!~r~r" + lsErrText)
	SetPointer(Arrow!)
	Return 
End If	

//Create an Order DEtail record for Each SKU
For llArrayPos = 1 to Upperbound(lsSKUArray)
	
	//Get the default Owner ID
	Select Owner_id into :llOwner
	From Item_MASter
	Where project_id = :gs_project and sku = :lsSKUArray[llARrayPos] and supp_code = :lsSupplierArray[llArrayPos];
	
	Insert Into Delivery_Detail (do_no, sku, supp_code, Owner_id, Alternate_sku, req_qty, alloc_qty, line_Item_no)
	Values							(:lsdoNo, :lsSKUArray[llARrayPos],:lsSupplierArray[llArrayPos], :llOwner, :lsSKUArray[llARrayPos], :ldQty[llARrayPos], 0, :llArrayPos)
	Using SQLCA;
		
	If sqlca.sqlcode <> 0 Then
		lsErrText = sqlca.sqlerrtext /*text will be lost after rollback*/
		Execute Immediate "ROLLBACK" using SQLCA;
		Messagebox("Import"," Unable to save new Delivery Detail record to database!~r~r" + lsErrText)
		SetPointer(Arrow!)
		Return 
	End If	
		
Next /*array */

Execute Immediate "COMMIT" using SQLCA;

SetPointer(Arrow!)
pb_create_do.Enabled = False

MessageBox(is_title,'Delivery Order # ' + lsOrderNo + ' has been created for items in this report.')





end event

on w_receive_packaging_report.create
int iCurrent
call super::create
this.pb_create_do=create pb_create_do
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_create_do
end on

on w_receive_packaging_report.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_create_do)
end on

event ue_retrieve;		
String	lsWhere,	&
			lsNewSQL


SetPointer(Hourglass!)
w_main.SetMicrohelp('Retrieving Report data...')

dw_select.AcceptText()

//Always Tack on Project ID 
lswhere = " and Receive_master.project_id = '" + gs_project + "'"

//Tackon Warehouse if PResent
If Not isnull(dw_Select.GetITemString(1,'wh_code')) Then
	lsWhere += " and Receive_master.Wh_code = '" + dw_Select.GetITemString(1,'wh_code') + "'"
End If

//Tackon Order Nbr if PResent
If Not isnull(dw_Select.GetITemString(1,'order_no')) Then
	lsWhere += " and Receive_master.supp_invoice_no = '" + dw_Select.GetITemString(1,'order_no') + "'"
End If

//Tackon Order Type if PResent
If Not isnull(dw_Select.GetITemString(1,'ord_Type')) Then
	lsWhere += " and Receive_master.ord_type = '" + dw_Select.GetITemString(1,'Ord_type') + "'"
End If

//Tackon Order Status if PResent
If Not isnull(dw_Select.GetITemString(1,'ord_status')) Then
	lsWhere += " and Receive_master.ord_status = '" + dw_Select.GetITemString(1,'Ord_status') + "'"
End If

//Tackon From Order Date
If date(dw_select.GetItemDateTime(1, "ord_date_from")) > date('01-01-1900') Then
	lsWhere = lsWhere + " and ord_date >= '" + string(dw_select.GetItemDateTime(1, "ord_date_from"),'mm-dd-yyyy hh:mm') + "'"
End If
	
//Tackon To Order Date
If date(dw_select.GetItemDateTime(1, "ord_date_to")) > date('01-01-1900') Then
	lsWhere = lsWhere + " and ord_date <= '" + string(dw_select.GetItemDateTime(1, "ord_date_to"),'mm-dd-yyyy hh:mm') + "'"
End If

//Tackon From Complete Date
If date(dw_select.GetItemDateTime(1, "comp_date_from")) > date('01-01-1900') Then
	lsWhere = lsWhere + " and complete_date >= '" + string(dw_select.GetItemDateTime(1, "comp_date_from"),'mm-dd-yyyy hh:mm') + "'"
End If
	
//Tackon To Complete Date
If date(dw_select.GetItemDateTime(1, "comp_date_to")) > date('01-01-1900') Then
	lsWhere = lsWhere + " and complete_date <= '" + string(dw_select.GetItemDateTime(1, "comp_date_to"),'mm-dd-yyyy hh:mm') + "'"
End If

//Modify SQL
lsNewSql = isorigsql + lsWhere 
dw_report.setsqlselect(lsNewsql)

If dw_report.Retrieve(gs_Project) > 0 Then
	im_menu.m_file.m_print.Enabled = True
	pb_create_do.Enabled = True
Else
	im_menu.m_file.m_print.Enabled = False	
	pb_create_do.Enabled = FAlse
	MessageBox(is_title, "No records found!")
End If

SetPointer(Arrow!)
w_main.SetMicrohelp('Ready')
end event

event resize;dw_report.Resize(workspacewidth() - 40,workspaceHeight()-270)
end event

event ue_postopen;call super::ue_postopen;
DatawindowChild	Ldwc

isOrigSQL = dw_report.GetSQlSelect() /*capture original SQL*/

pb_create_do.Enabled = FAlse

//populate warehouse dropdown
dw_select.GetChild('wh_code', ldwc)
ldwc.SetTransObject(Sqlca)
ldwc.Retrieve(gs_project)

//populate Receive Order Type dropdown
dw_select.GetChild('ord_type', ldwc)
ldwc.SetTransObject(Sqlca)
ldwc.Retrieve(gs_project)

dw_Select.SetItem(1,'wh_code',gs_default_wh)

//If Receive Order is open, default the report for that order
If isValid(w_ro) Then
	If w_ro.idw_main.RowCOunt() > 0 Then
		dw_select.SetITem(1, 'order_no', w_ro.idw_main.GetITemString(1,'Supp_invoice_no'))
		This.TriggerEvent('ue_retrieve')
	End If
End If /* RO Open */

end event

event ue_clear;call super::ue_clear;
dw_select.Reset()
dw_Select.InsertRow(0)
dw_Select.SetItem(1,'wh_code',gs_default_wh)
end event

type dw_select from w_std_report`dw_select within w_receive_packaging_report
integer x = 23
integer width = 2981
integer height = 256
string dataobject = "d_receive_packaging_rpt_search"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event dw_select::itemchanged;call super::itemchanged;// pvh 08/25/05 - GMT

if row <= 0 then return

choose case dwo.name
	case 'wh_code'
		g.setCurrentWarehouse( data )
end choose

end event

type cb_clear from w_std_report`cb_clear within w_receive_packaging_report
integer x = 3269
integer y = 0
end type

type dw_report from w_std_report`dw_report within w_receive_packaging_report
integer x = 5
integer y = 264
integer width = 3474
integer height = 1564
string dataobject = "d_receive_packaging_rpt"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

type pb_create_do from picturebutton within w_receive_packaging_report
integer x = 3077
integer y = 12
integer width = 402
integer height = 224
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Create Packing Order"
boolean originalsize = true
vtextalign vtextalign = multiline!
end type

event clicked;
PArent.TriggerEvent('ue_create_do')
end event

