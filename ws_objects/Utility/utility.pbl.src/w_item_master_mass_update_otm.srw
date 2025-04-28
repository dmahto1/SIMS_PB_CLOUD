$PBExportHeader$w_item_master_mass_update_otm.srw
$PBExportComments$Item Master mass update push to OTM.
forward
global type w_item_master_mass_update_otm from window
end type
type st_instr1 from statictext within w_item_master_mass_update_otm
end type
type st_instr3 from statictext within w_item_master_mass_update_otm
end type
type st_instr2 from statictext within w_item_master_mass_update_otm
end type
type gb_instructions from groupbox within w_item_master_mass_update_otm
end type
type cb_im_mass_upload from commandbutton within w_item_master_mass_update_otm
end type
type st_supp_code from statictext within w_item_master_mass_update_otm
end type
type st_iface_updt_ind from statictext within w_item_master_mass_update_otm
end type
type sle_iface_updt_ind from singlelineedit within w_item_master_mass_update_otm
end type
type sle_supp_code from singlelineedit within w_item_master_mass_update_otm
end type
type sle_project_id from singlelineedit within w_item_master_mass_update_otm
end type
type st_project_id from statictext within w_item_master_mass_update_otm
end type
type hpb_mass_load from hprogressbar within w_item_master_mass_update_otm
end type
type gb_im_mass_load_variables from groupbox within w_item_master_mass_update_otm
end type
end forward

global type w_item_master_mass_update_otm from window
integer width = 1829
integer height = 1392
boolean titlebar = true
string title = "Item Master Mass Update Push to OTM"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
st_instr1 st_instr1
st_instr3 st_instr3
st_instr2 st_instr2
gb_instructions gb_instructions
cb_im_mass_upload cb_im_mass_upload
st_supp_code st_supp_code
st_iface_updt_ind st_iface_updt_ind
sle_iface_updt_ind sle_iface_updt_ind
sle_supp_code sle_supp_code
sle_project_id sle_project_id
st_project_id st_project_id
hpb_mass_load hpb_mass_load
gb_im_mass_load_variables gb_im_mass_load_variables
end type
global w_item_master_mass_update_otm w_item_master_mass_update_otm

on w_item_master_mass_update_otm.create
this.st_instr1=create st_instr1
this.st_instr3=create st_instr3
this.st_instr2=create st_instr2
this.gb_instructions=create gb_instructions
this.cb_im_mass_upload=create cb_im_mass_upload
this.st_supp_code=create st_supp_code
this.st_iface_updt_ind=create st_iface_updt_ind
this.sle_iface_updt_ind=create sle_iface_updt_ind
this.sle_supp_code=create sle_supp_code
this.sle_project_id=create sle_project_id
this.st_project_id=create st_project_id
this.hpb_mass_load=create hpb_mass_load
this.gb_im_mass_load_variables=create gb_im_mass_load_variables
this.Control[]={this.st_instr1,&
this.st_instr3,&
this.st_instr2,&
this.gb_instructions,&
this.cb_im_mass_upload,&
this.st_supp_code,&
this.st_iface_updt_ind,&
this.sle_iface_updt_ind,&
this.sle_supp_code,&
this.sle_project_id,&
this.st_project_id,&
this.hpb_mass_load,&
this.gb_im_mass_load_variables}
end on

on w_item_master_mass_update_otm.destroy
destroy(this.st_instr1)
destroy(this.st_instr3)
destroy(this.st_instr2)
destroy(this.gb_instructions)
destroy(this.cb_im_mass_upload)
destroy(this.st_supp_code)
destroy(this.st_iface_updt_ind)
destroy(this.sle_iface_updt_ind)
destroy(this.sle_supp_code)
destroy(this.sle_project_id)
destroy(this.st_project_id)
destroy(this.hpb_mass_load)
destroy(this.gb_im_mass_load_variables)
end on

type st_instr1 from statictext within w_item_master_mass_update_otm
integer x = 73
integer y = 980
integer width = 1390
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "1. Update IM.Interface_Upd_Req_Ind to unique value"
boolean focusrectangle = false
end type

type st_instr3 from statictext within w_item_master_mass_update_otm
integer x = 73
integer y = 1128
integer width = 1509
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "3. Upon clicking the button, confirmation will be required"
boolean focusrectangle = false
end type

type st_instr2 from statictext within w_item_master_mass_update_otm
integer x = 73
integer y = 1056
integer width = 1591
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "2. Enter the three Item Master where clause variables above"
boolean focusrectangle = false
end type

type gb_instructions from groupbox within w_item_master_mass_update_otm
integer x = 32
integer y = 896
integer width = 1714
integer height = 360
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Instructions"
end type

type cb_im_mass_upload from commandbutton within w_item_master_mass_update_otm
integer x = 192
integer y = 536
integer width = 827
integer height = 112
integer taborder = 50
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Item Master OTM Mass Load"
end type

event clicked;// LTK 20140709  Quick and dirty window developed for Item_Master mass update to OTM push.

datastore lds_items
lds_items = create datastore
String ls_sql_syntax, ERRORS

//ls_sql_syntax = "SELECT project_id, sku, supp_code from item_master where project_id = 'PANDORA' and supp_code = 'PANDORA' and Interface_Upd_Req_Ind = 'Y';" 
ls_sql_syntax = "SELECT project_id, sku, supp_code from item_master where project_id = '" + &
					sle_project_id.text + "' and supp_code = '" + sle_supp_code.text + &
					"' and Interface_Upd_Req_Ind = '" + sle_iface_updt_ind.text + "';"

lds_items.Create(SQLCA.SyntaxFromSQL(ls_sql_syntax,"", ERRORS))
if Len(ERRORS) > 0 then
	MessageBox("Errors", "Unable to create datastore for OTM Item Master Mass Load.~r~r" + Errors)
   return - 1
end if

if lds_items.SetTransObject(SQLCA) <> 1 then
	MessageBox("Error","Error setting datastore's transaction object.")
	return -1
end if

long ll_rows
ll_rows = lds_items.retrieve()

if ll_rows = -1 then
	MessageBox("Error","Error retrieving the items.")
	return -1
end if

if ll_rows = 0 then
	
	MessageBox("No Rows", "No rows were retrieved based on the criteria you entered.", Information!, OK!)
	
elseif MessageBox("Rows To Process", String(ll_rows) + " row(s) were retrieved for processing.~rSend these items to OTM?",QUESTION!, YESNO!) = 1 then
	n_otm ln_otm
	ln_otm = CREATE n_otm
	
	String ls_delete_sku[]
	String ls_return_cd, ls_error_message
	
	hpb_mass_load.SetRange( 1, ll_rows )
	hpb_mass_load.Visible = TRUE

	long i
	for i = 1 to ll_rows
		if ln_otm.uf_push_otm_item_master("U", lds_items.getItemString(i, "project_id"), lds_items.getItemString(i, "sku"), lds_items.getItemString(i, "supp_code"), ls_return_cd, ls_error_message) < 0 then

			MessageBox("WebSphere Error", "WebSphere return code: " + ls_return_cd + "~r" + &
														"WebSphere return code:  " + ls_error_message)
														
			if MessageBox("Continue processing?", "Attempt to process the next item?", QUESTION!, YESNO!) = 2 then
				return -1
			end if
		end if

			hpb_mass_load.stepIt()
	next

	hpb_mass_load.Visible = FALSE
	MessageBox("Complete", "Mass Upload Complete!")

end if

end event

type st_supp_code from statictext within w_item_master_mass_update_otm
integer x = 160
integer y = 272
integer width = 293
integer height = 88
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Supp Code"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_iface_updt_ind from statictext within w_item_master_mass_update_otm
integer x = 64
integer y = 376
integer width = 389
integer height = 84
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "iFace Updt Ind"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_iface_updt_ind from singlelineedit within w_item_master_mass_update_otm
integer x = 466
integer y = 364
integer width = 494
integer height = 92
integer taborder = 40
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "Y"
borderstyle borderstyle = stylelowered!
end type

type sle_supp_code from singlelineedit within w_item_master_mass_update_otm
integer x = 466
integer y = 268
integer width = 494
integer height = 92
integer taborder = 30
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "PANDORA"
borderstyle borderstyle = stylelowered!
end type

type sle_project_id from singlelineedit within w_item_master_mass_update_otm
integer x = 466
integer y = 172
integer width = 494
integer height = 92
integer taborder = 20
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "PANDORA"
borderstyle borderstyle = stylelowered!
end type

type st_project_id from statictext within w_item_master_mass_update_otm
integer x = 247
integer y = 180
integer width = 206
integer height = 80
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Project"
alignment alignment = right!
boolean focusrectangle = false
end type

type hpb_mass_load from hprogressbar within w_item_master_mass_update_otm
boolean visible = false
integer x = 201
integer y = 688
integer width = 827
integer height = 64
boolean bringtotop = true
unsignedinteger maxposition = 100
integer setstep = 1
end type

type gb_im_mass_load_variables from groupbox within w_item_master_mass_update_otm
integer x = 32
integer y = 32
integer width = 1714
integer height = 812
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "OTM Item Master Mass Load"
end type

