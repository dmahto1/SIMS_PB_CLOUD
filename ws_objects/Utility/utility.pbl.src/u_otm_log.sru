$PBExportHeader$u_otm_log.sru
$PBExportComments$OTM logging logic.  This UO is opened in w_log.
forward
global type u_otm_log from userobject
end type
type lb_order_types from listbox within u_otm_log
end type
type cbx_select_all_order_types from checkbox within u_otm_log
end type
type cb_reprocess from commandbutton within u_otm_log
end type
type cb_clear from commandbutton within u_otm_log
end type
type cb_selectall from commandbutton within u_otm_log
end type
type cbx_clip_sql from checkbox within u_otm_log
end type
type st_rows from statictext within u_otm_log
end type
type cbx_columns from checkbox within u_otm_log
end type
type dp_to_date from datepicker within u_otm_log
end type
type ddlb_action from dropdownlistbox within u_otm_log
end type
type st_1 from statictext within u_otm_log
end type
type st_error_stats from statictext within u_otm_log
end type
type ddlb_error_status from dropdownlistbox within u_otm_log
end type
type sle_ship_id from singlelineedit within u_otm_log
end type
type st_ship_id from statictext within u_otm_log
end type
type sle_invoice_no from singlelineedit within u_otm_log
end type
type st_invoice_no from statictext within u_otm_log
end type
type sle_do_no from singlelineedit within u_otm_log
end type
type st_do_no from statictext within u_otm_log
end type
type sle_supp_code from singlelineedit within u_otm_log
end type
type st_supp_code from statictext within u_otm_log
end type
type dw_log from datawindow within u_otm_log
end type
type cb_search from commandbutton within u_otm_log
end type
type dp_from_date from datepicker within u_otm_log
end type
type sle_sku from singlelineedit within u_otm_log
end type
type st_3 from statictext within u_otm_log
end type
type st_2 from statictext within u_otm_log
end type
type st_sku from statictext within u_otm_log
end type
type gb_search from groupbox within u_otm_log
end type
type gb_log from groupbox within u_otm_log
end type
end forward

global type u_otm_log from userobject
integer width = 3922
integer height = 2316
long backcolor = 67108864
string text = "none"
borderstyle borderstyle = stylelowered!
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
lb_order_types lb_order_types
cbx_select_all_order_types cbx_select_all_order_types
cb_reprocess cb_reprocess
cb_clear cb_clear
cb_selectall cb_selectall
cbx_clip_sql cbx_clip_sql
st_rows st_rows
cbx_columns cbx_columns
dp_to_date dp_to_date
ddlb_action ddlb_action
st_1 st_1
st_error_stats st_error_stats
ddlb_error_status ddlb_error_status
sle_ship_id sle_ship_id
st_ship_id st_ship_id
sle_invoice_no sle_invoice_no
st_invoice_no st_invoice_no
sle_do_no sle_do_no
st_do_no st_do_no
sle_supp_code sle_supp_code
st_supp_code st_supp_code
dw_log dw_log
cb_search cb_search
dp_from_date dp_from_date
sle_sku sle_sku
st_3 st_3
st_2 st_2
st_sku st_sku
gb_search gb_search
gb_log gb_log
end type
global u_otm_log u_otm_log

type variables
String is_sql
String is_sort = 'A'
window iw_parent
datastore ids_order_types
long il_order_type_rows
end variables

forward prototypes
public subroutine of_resize (integer newwidth, integer newheight)
public subroutine of_init_search ()
public function string of_build_in_clause_string ()
end prototypes

public subroutine of_resize (integer newwidth, integer newheight);this.width = newwidth - 75
this.height = newheight - 150

gb_search.width = newwidth - 125

gb_log.width = newwidth - 125
gb_log.height = newheight - 900

dw_log.width =  newwidth - 250
dw_log.height = newheight - 1000

cbx_columns.y = gb_log.y + gb_log.height + 10
cbx_clip_sql.y = cbx_columns.y
st_rows.y  = gb_log.y + gb_log.height + 10
st_rows.x = this.width - 770


end subroutine

public subroutine of_init_search ();//sle_supp_code.text = gs_project

date ld_today
time lt_time
ld_today = Today()
lt_time = Time("00:00:00")
dp_from_date.SetValue(ld_today,lt_time)
lt_time = Time("23:59:59")
dp_to_date.SetValue(ld_today,lt_time)

ids_order_types = Create DataStore
ids_order_types.dataobject = 'd_lookup_table'
ids_order_types.SetTransObject(SQLCA)
il_order_type_rows = ids_order_types.Retrieve(gs_project, "LOG_REQUEST_TYPES")

if il_order_type_rows = 0 then
	MessageBox("Warning", "This project is not set up to retrieve log requests.  Contact support to insert LOG_REQUEST_TYPES for this project in the LOOKUP_TABLE.")
else
	// Populate OTM request types
	long i
	for i = 1 to il_order_type_rows
		lb_order_types.addItem(ids_order_types.Object.code_descript[i])
	next
	cbx_select_all_order_types.TriggerEvent("clicked")	// cbx is defaulted to checked
end if

end subroutine

public function string of_build_in_clause_string ();// Convert request type description to code and build SQL "in" clause
String ls_in_clause
String ls_code_list
String ls_order_types
long i
for i = 1 to  il_order_type_rows
	if lb_order_types.State(i) = 1 then
		String ls_description
		ls_description = lb_order_types.text(i)
		Long ll_row
		ll_row = ids_order_types.Find("code_descript='" + ls_description + "'",1,il_order_type_rows)
		ls_code_list += "'" + ids_order_types.Object.code_id[ll_row] + "', "
	end if
next

ls_code_list = Trim(ls_code_list)
if Len(ls_code_list) > 0 then
	if Right(ls_code_list,1) = "," then
			ls_code_list = Left(ls_code_list,Len(ls_code_list) -1)
	end if
	ls_in_clause = " and request_id in (" + ls_code_list + ") "
end if

return ls_in_clause
end function

on u_otm_log.create
this.lb_order_types=create lb_order_types
this.cbx_select_all_order_types=create cbx_select_all_order_types
this.cb_reprocess=create cb_reprocess
this.cb_clear=create cb_clear
this.cb_selectall=create cb_selectall
this.cbx_clip_sql=create cbx_clip_sql
this.st_rows=create st_rows
this.cbx_columns=create cbx_columns
this.dp_to_date=create dp_to_date
this.ddlb_action=create ddlb_action
this.st_1=create st_1
this.st_error_stats=create st_error_stats
this.ddlb_error_status=create ddlb_error_status
this.sle_ship_id=create sle_ship_id
this.st_ship_id=create st_ship_id
this.sle_invoice_no=create sle_invoice_no
this.st_invoice_no=create st_invoice_no
this.sle_do_no=create sle_do_no
this.st_do_no=create st_do_no
this.sle_supp_code=create sle_supp_code
this.st_supp_code=create st_supp_code
this.dw_log=create dw_log
this.cb_search=create cb_search
this.dp_from_date=create dp_from_date
this.sle_sku=create sle_sku
this.st_3=create st_3
this.st_2=create st_2
this.st_sku=create st_sku
this.gb_search=create gb_search
this.gb_log=create gb_log
this.Control[]={this.lb_order_types,&
this.cbx_select_all_order_types,&
this.cb_reprocess,&
this.cb_clear,&
this.cb_selectall,&
this.cbx_clip_sql,&
this.st_rows,&
this.cbx_columns,&
this.dp_to_date,&
this.ddlb_action,&
this.st_1,&
this.st_error_stats,&
this.ddlb_error_status,&
this.sle_ship_id,&
this.st_ship_id,&
this.sle_invoice_no,&
this.st_invoice_no,&
this.sle_do_no,&
this.st_do_no,&
this.sle_supp_code,&
this.st_supp_code,&
this.dw_log,&
this.cb_search,&
this.dp_from_date,&
this.sle_sku,&
this.st_3,&
this.st_2,&
this.st_sku,&
this.gb_search,&
this.gb_log}
end on

on u_otm_log.destroy
destroy(this.lb_order_types)
destroy(this.cbx_select_all_order_types)
destroy(this.cb_reprocess)
destroy(this.cb_clear)
destroy(this.cb_selectall)
destroy(this.cbx_clip_sql)
destroy(this.st_rows)
destroy(this.cbx_columns)
destroy(this.dp_to_date)
destroy(this.ddlb_action)
destroy(this.st_1)
destroy(this.st_error_stats)
destroy(this.ddlb_error_status)
destroy(this.sle_ship_id)
destroy(this.st_ship_id)
destroy(this.sle_invoice_no)
destroy(this.st_invoice_no)
destroy(this.sle_do_no)
destroy(this.st_do_no)
destroy(this.sle_supp_code)
destroy(this.st_supp_code)
destroy(this.dw_log)
destroy(this.cb_search)
destroy(this.dp_from_date)
destroy(this.sle_sku)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.st_sku)
destroy(this.gb_search)
destroy(this.gb_log)
end on

event constructor;iw_parent = message.PowerObjectParm	
iw_parent.title += " - OTM"

// LTK 20130913  Pandora #623  Hide the reprocess button for all but Pandora super and super duper users
if gs_project = 'PANDORA' then
	if gs_role <> "-1" and gs_role <> "0" then
		cb_reprocess.visible = false
	end if
end if

end event

type lb_order_types from listbox within u_otm_log
integer x = 46
integer y = 200
integer width = 553
integer height = 280
integer taborder = 20
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean hscrollbar = true
boolean vscrollbar = true
boolean sorted = false
boolean multiselect = true
borderstyle borderstyle = stylelowered!
end type

event constructor;this.SetRedraw(TRUE)
end event

event selectionchanged;cbx_select_all_order_types.checked = FALSE
end event

type cbx_select_all_order_types from checkbox within u_otm_log
integer x = 46
integer y = 124
integer width = 617
integer height = 76
integer taborder = 10
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Select/Unselect All"
boolean checked = true
end type

event clicked;boolean lb_is_on
if this.checked then
	lb_is_on = TRUE
else
	lb_is_on = FALSE
end if

long i
for i = 1 to il_order_type_rows
	lb_order_types.SetState(i,lb_is_on)
next

end event

type cb_reprocess from commandbutton within u_otm_log
integer x = 1221
integer y = 536
integer width = 402
integer height = 112
integer taborder = 110
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Reprocess"
boolean default = true
end type

event clicked;//// MEA 3/13 This will reprocess a OTM Order via the TIBCO bus

if IsValid(w_main) then
	w_main.setMicroHelp("Updating OTM server...")
end if

String lsXML, lsXMLResponse, lsLogID
Long llIdx

u_nvo_websphere_post lu_nvo_websphere_post
string ls_server_return_code, ls_server_error_message

lu_nvo_websphere_post = CREATE u_nvo_websphere_post


for llIdx = 1 to dw_log.RowCount()
	
	if  dw_log.GetItemString( llIdx, "c_select_ind" ) <> 'Y' then continue
	
	lsLogID = String(dw_log.GetItemNumber( llIdx, "log_id" ))
	
//	MessageBox ("Log", lsLogId)
	
	lsXML = lu_nvo_websphere_post.uf_request_header("OTMReSendRequest", "ProjectID='" + gs_project + "'")
	lsXML += 	'<LogID>' + lsLogID +  '</LogID>' 
	//lsXML += 	'<Project_ID>' + gs_project +  '</Project_ID>' 
	
	//lsXML += 	'<SKU>' + as_sku +  '</SKU>' 
	//lsXML += 	'<Supp_Code>' + as_supp_cd +  '</Supp_Code>' 
	//lsXML += 	'<action>' + as_action_code +  '</action>' 
	lsXML = lu_nvo_websphere_post.uf_request_footer(lsXML)
	
	lsXMLResponse = lu_nvo_websphere_post.uf_post_url(lsXML)
	
	//Check for Valid Return...
	//If we didn't receive an XML back, there is a fatal exception error
	If pos(Upper(lsXMLResponse),"SIMSRESPONSE") = 0 Then
		Messagebox("Websphere Fatal Exception Error","Unable to send item to OTM/TIBCO bus: ~r~r" + lsXMLResponse,StopSign!)
		ls_server_return_code = "-1"
		ls_server_error_message = lsXMLResponse
//		Return -1
	End If
	
	// Only the errors with the communication to WebSphere SIMS are trapped here.  The call to the TIBCO bus is asynchronous and will be logged in WebSphere.
	ls_server_return_code 		= lu_nvo_websphere_post.uf_get_xml_single_Element(lsXMLResponse,"returncode")
	ls_server_error_message	= lu_nvo_websphere_post.uf_get_xml_single_Element(lsXMLResponse,"errormessage")
	
	Choose Case ls_server_return_code
			
		Case "-99" /* Websphere non fatal exception error*/
			
			Messagebox("Websphere Operational Exception Error","Unable to send item to OTM/TIBCO bus: ~r~r" + ls_server_error_message,StopSign!)
//			Return -1
		
		Case Else
			
			If ls_server_error_message > '' Then
				Messagebox("",ls_server_error_message)
//				Return -1
			End If
				
	End Choose
	
	//end if
	//
	//MEA 3/13	If we get here then we have made a successful call to WebSphere.  In Test and QA, we may want to indicate this to the testers.
	if Upper(Trim(f_retrieve_parm(gs_project,"FLAG","VERBOSE"))) = 'Y' then
		MessageBox("WebSphere Call Success", "The call to WebSphere was successful! ~r~r" + &
															"Return code: " + ls_server_return_code + "~r" + &
															"Error message: " + ls_server_error_message)
	end if

next


end event

type cb_clear from commandbutton within u_otm_log
integer x = 425
integer y = 536
integer width = 338
integer height = 112
integer taborder = 160
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Clear All"
end type

event clicked;Long	llRowPos,	&
		llRowCount
		

SetPointer(hourglass!)
		
dw_log.SetRedraw(False)

llRowCount = dw_log.RowCount()

If llRowCount > 0 Then

	For llRowPos = 1 to llRowCount

	 
		dw_log.SetITem(llRowPos,'c_Select_Ind','N')
	 
	Next
	
End If

dw_log.SetRedraw(True)
end event

type cb_selectall from commandbutton within u_otm_log
integer x = 69
integer y = 536
integer width = 338
integer height = 112
integer taborder = 140
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Select All"
end type

event clicked;Long	llRowPos,	&
		llRowCount

		
SetPointer(hourglass!)
		
dw_log.SetRedraw(False)

llRowCount = dw_log.RowCount()

If llRowCount > 0 Then

	For llRowPos = 1 to llRowCount

	 
		dw_log.SetITem(llRowPos,'c_Select_Ind','Y')
	 
	Next
	
End If

dw_log.SetRedraw(True)



end event

type cbx_clip_sql from checkbox within u_otm_log
integer x = 699
integer y = 2232
integer width = 795
integer height = 76
integer taborder = 190
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Send SQL to clipboard"
end type

event clicked;if this.checked then
	dw_log.Object.request.visible = 1
	dw_log.Object.response.visible = 1
	dw_log.Object.request_url.visible = 1
	dw_log.Object.project_id.visible = 1
else
	dw_log.Object.request.visible = 0
	dw_log.Object.response.visible = 0
	dw_log.Object.request_url.visible = 0
	dw_log.Object.project_id.visible = 0
end if
end event

type st_rows from statictext within u_otm_log
integer x = 3159
integer y = 2232
integer width = 745
integer height = 64
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Rows: "
alignment alignment = right!
boolean focusrectangle = false
end type

type cbx_columns from checkbox within u_otm_log
integer x = 64
integer y = 2232
integer width = 608
integer height = 76
integer taborder = 200
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Show all columns"
end type

event clicked;if this.checked then
	dw_log.Object.request.visible = 1
	dw_log.Object.response.visible = 1
	dw_log.Object.request_url.visible = 1
	dw_log.Object.project_id.visible = 1
else
	dw_log.Object.request.visible = 0
	dw_log.Object.response.visible = 0
	dw_log.Object.request_url.visible = 0
	dw_log.Object.project_id.visible = 0
end if
end event

type dp_to_date from datepicker within u_otm_log
integer x = 2706
integer y = 388
integer width = 677
integer height = 80
integer taborder = 130
boolean border = true
borderstyle borderstyle = stylelowered!
boolean showupdown = true
datetimeformat format = dtfcustom!
string customformat = "MM/dd/yyy  HH:mm:ss"
date maxdate = Date("2999-12-31")
date mindate = Date("1800-01-01")
datetime value = DateTime(Date("2012-02-21"), Time("11:01:15.000000"))
integer textsize = -9
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
integer calendarfontweight = 400
boolean todaysection = true
boolean todaycircle = true
boolean valueset = true
end type

type ddlb_action from dropdownlistbox within u_otm_log
integer x = 2706
integer y = 124
integer width = 677
integer height = 512
integer taborder = 90
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean sorted = false
string item[] = {"","FINAL","INTERIM","INSERT","UPDATE","DELETE"}
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within u_otm_log
integer x = 2363
integer y = 132
integer width = 325
integer height = 64
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Action"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_error_stats from statictext within u_otm_log
integer x = 2363
integer y = 220
integer width = 325
integer height = 64
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Error Status"
alignment alignment = right!
boolean focusrectangle = false
end type

type ddlb_error_status from dropdownlistbox within u_otm_log
integer x = 2706
integer y = 216
integer width = 677
integer height = 504
integer taborder = 100
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean sorted = false
string item[] = {"","SUCCESS","ERROR","WARN"}
borderstyle borderstyle = stylelowered!
end type

type sle_ship_id from singlelineedit within u_otm_log
integer x = 1765
integer y = 284
integer width = 549
integer height = 80
integer taborder = 80
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type st_ship_id from statictext within u_otm_log
integer x = 1463
integer y = 292
integer width = 288
integer height = 64
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Ship ID"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_invoice_no from singlelineedit within u_otm_log
integer x = 1765
integer y = 204
integer width = 549
integer height = 80
integer taborder = 70
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type st_invoice_no from statictext within u_otm_log
integer x = 1463
integer y = 212
integer width = 288
integer height = 64
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Invoice No"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_do_no from singlelineedit within u_otm_log
integer x = 1765
integer y = 124
integer width = 549
integer height = 80
integer taborder = 60
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type st_do_no from statictext within u_otm_log
integer x = 1463
integer y = 132
integer width = 288
integer height = 64
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Do_No"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_supp_code from singlelineedit within u_otm_log
integer x = 850
integer y = 204
integer width = 549
integer height = 80
integer taborder = 50
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type st_supp_code from statictext within u_otm_log
integer x = 576
integer y = 212
integer width = 251
integer height = 64
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Supplier"
alignment alignment = right!
boolean focusrectangle = false
end type

type dw_log from datawindow within u_otm_log
integer x = 59
integer y = 760
integer width = 3813
integer height = 1424
integer taborder = 180
string title = "none"
string dataobject = "d_sims_log"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event constructor;this.SetTransObject(SQLCA)
u_otm_log.of_init_search()

end event

event clicked;// TODO: future functionality...Sorting

//if Lower(dwo.name) = 'log_id_t' then
//	dw_log.SetSort("log_id " + "DESC")
//	dw_log.Sort()
//end if
//
//if Lower(dwo.name) = 'request_id_t' then
//	dw_log.SetSort("request_id " + "ASC")
//	dw_log.Sort()
//end if
//
//if Lower(dwo.name) = 'request_system_t' then
//	dw_log.SetSort("request_system " + "ASC")
//	dw_log.Sort()
//end if
//
end event

type cb_search from commandbutton within u_otm_log
integer x = 3456
integer y = 124
integer width = 402
integer height = 112
integer taborder = 150
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Search"
boolean default = true
end type

event clicked;// TODO: implement SQL Union functionality with the three OTM search types
boolean lb_item_parms, lb_order_parms
if Len(sle_sku.text) > 0 or Len(sle_supp_code.text) > 0 then
	lb_item_parms = TRUE
end if

if Len(sle_do_no.text) > 0 or Len(sle_invoice_no.text) > 0 or Len(sle_ship_id.text) > 0 then
	lb_order_parms = TRUE
end if

if lb_item_parms and lb_order_parms then
	MessageBox("Future Functionality", "The log cannot yet be searched using both Item and Order parameters.~rPlease enter one or the other.~rThis functionality will be available soon!")
	return
end if
// end TODO


String ls_where, ls_in_clause
String ls_action
long ll_rows

dw_log.reset()
st_rows.text = "Rows:  "

if is_sql = "" then
	// Set the whereless instance SQL var
	is_sql = dw_log.getSqlSelect()
end if

// Always use project
ls_where = " where project_id = '" + gs_project + "' "

if lb_order_types.TotalSelected() = 0 then
	MessageBox("Invalid Parameters", "Please select at least one OTM transaction type.")
	return
end if

// Append transaction type "in" clause
ls_where += of_build_in_clause_string()

// Item search parms
if Len(Trim(sle_sku.text)) > 0 then
	ls_where += " and sku = '" + Trim(sle_sku.text) + "' "
end if
	
if Len(Trim(sle_supp_code.text)) > 0 then
	ls_where += " and supp_code = '" + Trim(sle_supp_code.text) + "' "
end if

// Order search parms
if Len(Trim(sle_do_no.text)) > 0 then
	ls_where += " and do_no = '" + Trim(sle_do_no.text) + "' "
end if

if Len(Trim(sle_invoice_no.text)) > 0 then
	ls_where += " and invoice_no = '" + Trim(sle_invoice_no.text) + "' "
end if

if Len(Trim(sle_ship_id.text)) > 0 then
	ls_where += " and ship_id = '" + Trim(sle_ship_id.text) + "' "
end if

// Misc search parms
ls_action = Upper(Trim(ddlb_action.text))
if Len(ls_action) > 0 then
	if ls_action = 'INSERT' then
		ls_action = 'I'
	end if
	if ls_action = 'UPDATE' then
		ls_action = 'U'
	end if
	if ls_action = 'DELETE' then
		ls_action = 'D'
	end if	

	ls_where += " and action = '" + Trim(ls_action) + "' "
end if

if Len(ddlb_error_status.text) > 0 then
	ls_where += " and response_code = '" + Trim(ddlb_error_status.text) + "' "
end if

// Date search parms
datetime ldt_work
dp_from_date.GetValue (ldt_work)
ls_where += " and request_date >= '" + String(ldt_work) + "'"

dp_to_date.GetValue (ldt_work)
ls_where += " and request_date <= '" + String(ldt_work) + "'"

if cbx_clip_sql.checked then
	ClipBoard(is_sql + ls_where)	
end if

dw_log.setSqlSelect(is_sql + ls_where)
ll_rows = dw_log.retrieve()

st_rows.text = "Rows:  " + String(ll_rows)

end event

type dp_from_date from datepicker within u_otm_log
integer x = 2706
integer y = 308
integer width = 677
integer height = 80
integer taborder = 120
boolean border = true
borderstyle borderstyle = stylelowered!
boolean showupdown = true
datetimeformat format = dtfcustom!
string customformat = "MM/dd/yyy  HH:mm:ss"
date maxdate = Date("2999-12-31")
date mindate = Date("1800-01-01")
datetime value = DateTime(Date("2012-02-21"), Time("13:29:03.000000"))
integer textsize = -9
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
integer calendarfontweight = 400
boolean todaysection = true
boolean todaycircle = true
boolean valueset = true
end type

type sle_sku from singlelineedit within u_otm_log
integer x = 850
integer y = 124
integer width = 549
integer height = 80
integer taborder = 40
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type st_3 from statictext within u_otm_log
integer x = 2363
integer y = 396
integer width = 325
integer height = 68
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "To Date"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_2 from statictext within u_otm_log
integer x = 2363
integer y = 316
integer width = 325
integer height = 68
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "From Date"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_sku from statictext within u_otm_log
integer x = 576
integer y = 132
integer width = 251
integer height = 64
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "SKU"
alignment alignment = right!
boolean focusrectangle = false
end type

type gb_search from groupbox within u_otm_log
integer x = 18
integer y = 20
integer width = 3890
integer height = 484
integer taborder = 30
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Search Criteria"
end type

type gb_log from groupbox within u_otm_log
integer x = 18
integer y = 676
integer width = 3890
integer height = 1536
integer taborder = 170
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Search Results"
end type

