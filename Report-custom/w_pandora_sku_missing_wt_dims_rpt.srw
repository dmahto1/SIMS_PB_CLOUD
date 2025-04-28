HA$PBExportHeader$w_pandora_sku_missing_wt_dims_rpt.srw
forward
global type w_pandora_sku_missing_wt_dims_rpt from w_std_report
end type
type cb_clip_it from commandbutton within w_pandora_sku_missing_wt_dims_rpt
end type
end forward

global type w_pandora_sku_missing_wt_dims_rpt from w_std_report
string title = "Missing Weight or DIMs Report"
cb_clip_it cb_clip_it
end type
global w_pandora_sku_missing_wt_dims_rpt w_pandora_sku_missing_wt_dims_rpt

type variables
Datastore ids_skus
String is_inadequate_skus
end variables

on w_pandora_sku_missing_wt_dims_rpt.create
int iCurrent
call super::create
this.cb_clip_it=create cb_clip_it
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_clip_it
end on

on w_pandora_sku_missing_wt_dims_rpt.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_clip_it)
end on

event open;call super::open;str_parms lstrparms

lstrparms = message.PowerObjectParm
ids_skus = lstrparms.datastore_arg[1]
is_inadequate_skus = lstrparms.String_arg[2]

ids_skus.RowsCopy(1, ids_skus.RowCount(),Primary!, dw_report, 1, Primary!)

dw_report.Object.t_title.text = ids_skus.Object.t_title.text

end event

event resize;call super::resize;dw_report.width = this.WorkSpaceWidth ( ) - 50
dw_report.height = this.WorkSpaceHeight ( ) - 200

cb_clip_it.x = width - 	800
cb_clip_it.y = height - 250

end event

type dw_select from w_std_report`dw_select within w_pandora_sku_missing_wt_dims_rpt
boolean visible = false
end type

type cb_clear from w_std_report`cb_clear within w_pandora_sku_missing_wt_dims_rpt
end type

type dw_report from w_std_report`dw_report within w_pandora_sku_missing_wt_dims_rpt
integer y = 12
integer height = 1424
string dataobject = "d_pandora_sku_missing_wt_dims_rpt"
end type

type cb_clip_it from commandbutton within w_pandora_sku_missing_wt_dims_rpt
integer x = 2633
integer y = 1468
integer width = 709
integer height = 112
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Copy data to ClipBoard"
end type

event clicked;ClipBoard(is_inadequate_skus)
end event

