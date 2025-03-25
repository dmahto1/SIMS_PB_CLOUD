$PBExportHeader$w_delivery_bol.srw
$PBExportComments$+ TMS Bill Of Lading
forward
global type w_delivery_bol from window
end type
type dw_bol_prt from datawindow within w_delivery_bol
end type
type rb_cbol from radiobutton within w_delivery_bol
end type
type rb_mbol from radiobutton within w_delivery_bol
end type
type st_2 from statictext within w_delivery_bol
end type
type cb_print from commandbutton within w_delivery_bol
end type
type cb_generate from commandbutton within w_delivery_bol
end type
type sle_load_id from singlelineedit within w_delivery_bol
end type
type st_text from statictext within w_delivery_bol
end type
end forward

global type w_delivery_bol from window
integer width = 4338
integer height = 1984
boolean titlebar = true
string title = "Bill Of Lading"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 67108864
string icon = "AppIcon!"
event ue_process_bol ( )
event ue_print_bol ( )
dw_bol_prt dw_bol_prt
rb_cbol rb_cbol
rb_mbol rb_mbol
st_2 st_2
cb_print cb_print
cb_generate cb_generate
sle_load_id sle_load_id
st_text st_text
end type
global w_delivery_bol w_delivery_bol

type variables
w_delivery_bol iw_window
Datawindow idw_do_bol
end variables

event ue_process_bol();//29-AUG-2018 :Madhu S23059 - Process BOL
string ls_load_shipment, ls_text
long ll_count, ll_row

u_nvo_custom_bol 	lu_bol
lu_bol = Create u_nvo_custom_bol

SetPointer(HourGlass!)

ls_load_shipment = sle_load_id.text
			
//get checked value (MBOL /CBOL)
CHOOSE CASE upper(gs_project)
	CASE 'PANDORA'
		IF rb_mbol.checked=True THEN
			this.dw_bol_prt.dataobject='d_vics_mbol_prt_pandora'
			
			If isnull(ls_load_shipment) or ls_load_shipment ='' Then
				MessageBox("BOL Generate", "Please provide Load Id to generate MBOL")
				Return
			end If
			
			//get orders count against Load Id.
			select count(*) into :ll_count from Delivery_Master with(nolock)
			where Project_Id =:gs_project and Load_Id =:ls_load_shipment
			and  ord_status in ('I', 'A', 'C', 'D');
			
			ls_text = "Outbound Order is not available to generate MBOL against Load Id: "+ls_load_shipment
		ELSE
			ls_text ="CBOL"
			this.dw_bol_prt.dataobject='d_vics_cbol_prt_pandora'
			
			If isnull(ls_load_shipment) or ls_load_shipment ='' Then
				MessageBox("BOL Generate", "Please provide Shipment Id to generate CBOL")
				Return
			end If

			//get orders count against Shipment Id.
			select count(*) into :ll_count from Delivery_Master with(nolock)
			where Project_Id =:gs_project and Shipment_Id =:ls_load_shipment
			and  ord_status in ('I', 'A', 'C', 'D');
			
			ls_text = "Outbound Order is not available to generate CBOL against Shipment Id: "+ls_load_shipment
		END IF
END CHOOSE

If ll_count = 0 Then
	MessageBox("BOL Generate", ls_text)
	Return
End If

//Retrieve data
CHOOSE CASE upper(gs_project)
	CASE 'PANDORA'
		If rb_mbol.checked=True Then
			lu_bol.uf_process_master_bol_pandora( ls_load_shipment, idw_do_bol)
			this.dw_bol_prt.scroll( idw_do_bol.rowcount( ))
			
		else
			lu_bol.uf_process_child_bol_pandora( ls_load_shipment, idw_do_bol)
			this.dw_bol_prt.scroll( idw_do_bol.rowcount())
		End If
END CHOOSE

destroy lu_bol
end event

event ue_print_bol();OpenWithParm(w_dw_print_options, idw_do_bol)
end event

on w_delivery_bol.create
this.dw_bol_prt=create dw_bol_prt
this.rb_cbol=create rb_cbol
this.rb_mbol=create rb_mbol
this.st_2=create st_2
this.cb_print=create cb_print
this.cb_generate=create cb_generate
this.sle_load_id=create sle_load_id
this.st_text=create st_text
this.Control[]={this.dw_bol_prt,&
this.rb_cbol,&
this.rb_mbol,&
this.st_2,&
this.cb_print,&
this.cb_generate,&
this.sle_load_id,&
this.st_text}
end on

on w_delivery_bol.destroy
destroy(this.dw_bol_prt)
destroy(this.rb_cbol)
destroy(this.rb_mbol)
destroy(this.st_2)
destroy(this.cb_print)
destroy(this.cb_generate)
destroy(this.sle_load_id)
destroy(this.st_text)
end on

event open;iw_window = this

idw_do_bol = this.dw_bol_prt
idw_do_bol.settransobject( sqlca)
end event

event resize;this.dw_bol_prt.Resize(workspacewidth() - 80,workspaceHeight()-360)
end event

type dw_bol_prt from datawindow within w_delivery_bol
integer x = 32
integer y = 288
integer width = 4224
integer height = 1544
integer taborder = 30
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type rb_cbol from radiobutton within w_delivery_bol
integer x = 2057
integer y = 152
integer width = 402
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "CBOL"
end type

event clicked;st_text.text ="Shipment Id:"
end event

type rb_mbol from radiobutton within w_delivery_bol
integer x = 1787
integer y = 152
integer width = 402
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "MBOL"
boolean checked = true
end type

event clicked;st_text.text ="Load Id:"
end event

type st_2 from statictext within w_delivery_bol
integer x = 827
integer y = 28
integer width = 1449
integer height = 76
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 134217856
long backcolor = 67108864
string text = "BILL OF LADING"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_print from commandbutton within w_delivery_bol
integer x = 3131
integer y = 152
integer width = 311
integer height = 100
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Print"
end type

event clicked;iw_window.TriggerEvent("ue_print_bol")
end event

type cb_generate from commandbutton within w_delivery_bol
integer x = 2688
integer y = 152
integer width = 343
integer height = 100
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Generate"
end type

event clicked;iw_window.TriggerEvent("ue_process_bol")
end event

type sle_load_id from singlelineedit within w_delivery_bol
integer x = 517
integer y = 152
integer width = 1115
integer height = 92
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type st_text from statictext within w_delivery_bol
integer x = 41
integer y = 152
integer width = 402
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Load Id:"
alignment alignment = right!
boolean focusrectangle = false
end type

