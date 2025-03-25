$PBExportHeader$w_maintenance_stryker_mrp_edit.srw
$PBExportComments$BCR - UOM Maintenance window
forward
global type w_maintenance_stryker_mrp_edit from w_response_ancestor
end type
type dw_mrp_sku from u_dw_ancestor within w_maintenance_stryker_mrp_edit
end type
end forward

global type w_maintenance_stryker_mrp_edit from w_response_ancestor
integer width = 2505
integer height = 1296
string title = "Stryker Sku MRP Edit"
dw_mrp_sku dw_mrp_sku
end type
global w_maintenance_stryker_mrp_edit w_maintenance_stryker_mrp_edit

on w_maintenance_stryker_mrp_edit.create
int iCurrent
call super::create
this.dw_mrp_sku=create dw_mrp_sku
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_mrp_sku
end on

on w_maintenance_stryker_mrp_edit.destroy
call super::destroy
destroy(this.dw_mrp_sku)
end on

event open;call super::open;
long ll_id, ll_row


ll_id = message.DoubleParm 

if ll_id = 0  then
	
	ll_row = dw_mrp_sku.InsertRow(0)
	
	dw_mrp_sku.SetItem(ll_row, "project_id", gs_project)
	dw_mrp_sku.SetItem(ll_row, "supp_code", "IN_STRYKER")	
	
	
else
	
	dw_mrp_sku.Retrieve(ll_id)
	
end if

dw_mrp_sku.Post Function SetFocus()
end event

type cb_cancel from w_response_ancestor`cb_cancel within w_maintenance_stryker_mrp_edit
integer x = 1275
integer y = 1064
end type

type cb_ok from w_response_ancestor`cb_ok within w_maintenance_stryker_mrp_edit
integer x = 809
integer y = 1064
end type

event cb_ok::clicked;
//Ancestor Override

dw_mrp_sku.AcceptText()

datetime ldt_current_datetime

ldt_current_datetime = datetime( today(), now())

dw_mrp_sku.SetItem( 1, "Last_User", gs_userid)
dw_mrp_sku.SetItem( 1, "Last_Update", ldt_current_datetime)

if dw_mrp_sku.Update() < 0 then
	return -1
else
	CloseWithReturn(parent, 1)
end if
end event

type dw_mrp_sku from u_dw_ancestor within w_maintenance_stryker_mrp_edit
integer x = 23
integer y = 28
integer width = 2331
integer height = 972
boolean bringtotop = true
string dataobject = "d_maintenance_stryker_mrp_sku_edit"
boolean border = false
borderstyle borderstyle = stylebox!
end type

