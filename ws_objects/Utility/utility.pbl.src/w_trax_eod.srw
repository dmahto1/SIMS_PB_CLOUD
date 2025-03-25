$PBExportHeader$w_trax_eod.srw
$PBExportComments$TRAX End of Day processing
forward
global type w_trax_eod from w_main_ancestor
end type
type dw_eod from u_dw_ancestor within w_trax_eod
end type
type cb_selectall from commandbutton within w_trax_eod
end type
type cb_clearall from commandbutton within w_trax_eod
end type
type cb_post from commandbutton within w_trax_eod
end type
type dw_select from u_dw_ancestor within w_trax_eod
end type
type cb_print from commandbutton within w_trax_eod
end type
end forward

global type w_trax_eod from w_main_ancestor
integer width = 3771
integer height = 2072
string title = "TRAX EOD"
string menuname = ""
long backcolor = 67108864
event ue_post_eod ( )
event ue_print_eod ( )
dw_eod dw_eod
cb_selectall cb_selectall
cb_clearall cb_clearall
cb_post cb_post
dw_select dw_select
cb_print cb_print
end type
global w_trax_eod w_trax_eod

type variables

w_trax_eod	iwWindow
end variables

event ue_post_eod();
Integer		liRC
u_nvo_trax	luTrax

luTrax = Create u_nvo_Trax

dw_eod.AcceptText()
liRC = luTrax.uf_process_eod(dw_eod)

This.TriggerEVent('ue_retrieve')
//This.TriggerEVent('ue_unselectall')
end event

event ue_print_eod();Integer		liRC, i
u_nvo_trax	luTrax
string lsBatchId

luTrax = Create u_nvo_Trax

dw_eod.AcceptText()

For i = 1 to dw_eod.RowCount()
	If (dw_eod.GetITemString(i,'c_select_Ind') = 'Y') Then
		liRC = luTrax.uf_print_eod_manifest(dw_eod.getItemString(i, 'last_eod_batchID'), 'ED')
	End If
Next

This.TriggerEVent('ue_retrieve')

end event

on w_trax_eod.create
int iCurrent
call super::create
this.dw_eod=create dw_eod
this.cb_selectall=create cb_selectall
this.cb_clearall=create cb_clearall
this.cb_post=create cb_post
this.dw_select=create dw_select
this.cb_print=create cb_print
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_eod
this.Control[iCurrent+2]=this.cb_selectall
this.Control[iCurrent+3]=this.cb_clearall
this.Control[iCurrent+4]=this.cb_post
this.Control[iCurrent+5]=this.dw_select
this.Control[iCurrent+6]=this.cb_print
end on

on w_trax_eod.destroy
call super::destroy
destroy(this.dw_eod)
destroy(this.cb_selectall)
destroy(this.cb_clearall)
destroy(this.cb_post)
destroy(this.dw_select)
destroy(this.cb_print)
end on

event ue_postopen;call super::ue_postopen;
DatawindowChild	ldwc

iwWindow = This

dw_select.GetChild("warehouse", ldwc)
ldwc.SetTransObject(sqlca)
g.of_set_warehouse_dropdown(ldwc)

dw_select.InsertRow(0)

If gs_default_WH > '' Then
	dw_select.SetITem(1,'warehouse',gs_default_WH) /* 04/04 - PCONKL - Warehouse now reauired field on search to keep users within their domain*/
End IF

This.TriggerEvent('ue_retrieve')
end event

event ue_retrieve;call super::ue_retrieve;String	lsWH

SetPointer(Hourglass!)
w_main.setmicrohelp("Retrieving Carrier list...")

lsWH = dw_Select.GetITemString(1,'warehouse')
dw_eod.Retrieve(gs_Project,dw_Select.GetITemString(1,'warehouse'))
dw_Eod.TriggerEVent('ue_enable')

w_main.setmicrohelp("Ready")
SetPointer(Arrow!)
end event

event resize;call super::resize;
dw_eod.Resize(workspacewidth() - 20,workspaceHeight()-150)
end event

event ue_selectall;call super::ue_selectall;Long	i

dw_eod.SetRedraw(False)

For i = 1 to dw_eod.RowCount()
	If (dw_eod.GetITemDateTime(i,'max_complete_date') > dw_eod.GetITemDateTime(i,'last_eod_date')) or isnull(dw_eod.GetITemDateTime(i,'last_eod_date')) Then
		dw_eod.SetItem(i,'c_select_Ind','Y')
	End If
Next

dw_eod.SetRedraw(True)

dw_Eod.TriggerEVent('ue_enable')
end event

event ue_unselectall;call super::ue_unselectall;
Long	i

dw_eod.SetRedraw(False)

For i = 1 to dw_eod.RowCount()
	dw_eod.SetItem(i,'c_select_Ind','N')
Next

dw_eod.SetRedraw(True)

dw_Eod.TriggerEVent('ue_enable')
end event

type cb_cancel from w_main_ancestor`cb_cancel within w_trax_eod
boolean visible = false
integer x = 1655
integer y = 1752
end type

type cb_ok from w_main_ancestor`cb_ok within w_trax_eod
boolean visible = false
integer x = 2459
integer y = 884
integer height = 80
integer textsize = -8
end type

type dw_eod from u_dw_ancestor within w_trax_eod
event ue_enable ( )
integer x = 32
integer y = 148
integer width = 3666
integer height = 1764
boolean bringtotop = true
string dataobject = "d_trax_eod"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event ue_enable();
If this.find("c_select_ind='Y'",1,this.RowCount()) > 0 Then
	cb_post.Enabled = True
	cb_print.Enabled = True
Else
	cb_post.Enabled = False
	cb_print.Enabled = False
End If
end event

event ue_postitemchanged;call super::ue_postitemchanged;
If dwo.name = 'c_select_ind' Then
	This.TriggerEvent('ue_Enable')
End If
end event

type cb_selectall from commandbutton within w_trax_eod
integer x = 41
integer y = 36
integer width = 343
integer height = 80
integer taborder = 10
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
parent.TriggerEvent('ue_selectall')
end event

type cb_clearall from commandbutton within w_trax_eod
integer x = 475
integer y = 36
integer width = 343
integer height = 80
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Clear All"
end type

event clicked;
parent.TriggerEvent('ue_unselectall')
end event

type cb_post from commandbutton within w_trax_eod
integer x = 910
integer y = 36
integer width = 343
integer height = 80
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Post EOD"
end type

event clicked;
PArent.TriggerEvent('ue_post_eod')
end event

type dw_select from u_dw_ancestor within w_trax_eod
integer x = 1797
integer y = 36
integer width = 1518
integer height = 84
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_warehouse"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event constructor;call super::constructor;
//This.InsertRow(0)
end event

event itemchanged;call super::itemchanged;
If dwo.Name = 'warehouse' Then
	iwWindow.PostEvent("ue_Retrieve")
End IF
end event

type cb_print from commandbutton within w_trax_eod
integer x = 1344
integer y = 36
integer width = 343
integer height = 80
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Print EOD"
end type

event clicked;
PArent.TriggerEvent('ue_print_eod')
end event

