$PBExportHeader$w_sims_gemini_manifest_rpt.srw
$PBExportComments$Sims/Gemini manifest Report Gemini specific Report
forward
global type w_sims_gemini_manifest_rpt from w_std_report
end type
end forward

global type w_sims_gemini_manifest_rpt from w_std_report
integer width = 3547
integer height = 2016
string title = "SIMS/Gemini Manifest Report"
end type
global w_sims_gemini_manifest_rpt w_sims_gemini_manifest_rpt

on w_sims_gemini_manifest_rpt.create
call super::create
end on

on w_sims_gemini_manifest_rpt.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_retrieve;datetime ldt_null,ldt_start,ldt_end
String ls_SQL,ls_wh_code,ls_where
long ll_temp 
Setnull(ldt_null)
dw_report.Reset()
dw_select.AcceptText()
dw_report.Setfilter("")
ls_sql = dw_report.GetSQLSelect()
ldt_start= dw_select.object.start_date[1]
ldt_end =dw_select.object.end_date[1]
ls_wh_code =dw_select.object.warehouse_code[1]
dw_report.SetRedraw(False)
IF dw_report.Retrieve(gs_project) = 0 THEN
//		MessageBox(is_title,"No Record found")		
//  im_menu.m_file.m_print.Enabled = FALSE
		goto enddata
ELSE
  im_menu.m_file.m_print.Enabled = TRUE
  IF Not ISNULL(ldt_start) THEN ls_where += "complete_date >= datetime('" + string(ldt_start) +"') and"	
  IF Not ISNULL(ldt_end) THEN	ls_where += "  complete_date <= datetime('" + string(ldt_end) +"') and"
  IF Not ISNULL(ls_wh_code) and ls_wh_code <> "" THEN	ls_where += "  upper(wh_code) = '" + ls_wh_code + "' and"

  ll_temp=(len(ls_where)-3)
  IF trim(mid(ls_where,ll_temp)) = 'and' THEN  ls_where = mid(ls_where,1,ll_temp)
		
  IF NOT ISNULL(ls_where) and ls_where <> "" THEN
		dw_report.SetFilter(ls_where)
		dw_report.Filter( )
  END IF	
  IF dw_report.RowCount() = 0 THEN goto enddata
END IF

dw_report.SetRedraw(TRUE)
Return
enddata:
MessageBox(is_title,"No Record found")		
  im_menu.m_file.m_print.Enabled = FALSE
end event

event ue_postopen;call super::ue_postopen;DatawindowChild	ldwc_warehouse
dw_select.GetChild('warehouse_code', ldwc_warehouse)
ldwc_warehouse.SetTransObject(sqlca)
ldwc_warehouse.Retrieve(gs_project)
	
end event

event ue_clear;call super::ue_clear;dw_report.Reset()
dw_select.Reset()
dw_select.Insertrow(0)
im_menu.m_file.m_print.Enabled = FALSE

end event

event resize;call super::resize;dw_report.Resize(workspacewidth() - 30,workspaceHeight()-200)
end event

event ue_print;//Overide the print statement
dw_report.Modify("DataWindow.Print.Orientation = 1")
OpenWithParm(w_dw_print_options,dw_report) 

end event

type dw_select from w_std_report`dw_select within w_sims_gemini_manifest_rpt
event ue_open ( )
string dataobject = "d_sims_manifest_rpt_search"
boolean border = false
borderstyle borderstyle = styleshadowbox!
end type

event dw_select::ue_open;Datetime ldt_begin_date,ldt_end_date
ldt_begin_date = f_get_date("BEGIN")
this.object.start_date[THis.GetRow()]=ldt_begin_date
ldt_end_date = f_get_date("END")
this.object.end_date[THis.GetRow()]=ldt_end_date
end event

event dw_select::clicked;call super::clicked;datetime	ldt_begin_date
datetime	ldt_end_date
CHOOSE CASE DWO.Name
		
	CASE "start_date"
			   ldt_begin_date= this.object.start_date[row]
				IF ISNULL(ldt_begin_date) THEN
					ldt_begin_date = f_get_date("BEGIN")
					this.object.start_date[row]=ldt_begin_date
				END IF	

	CASE "end_date"
			ldt_end_date= this.object.end_date[row]
			IF ISNULL(ldt_end_date) THEN
		   	ldt_end_date = f_get_date("END")
				this.object.end_date[row]=ldt_end_date
			END IF	

END CHOOSE

end event

event dw_select::constructor;call super::constructor;post event ue_open()
end event

type cb_clear from w_std_report`cb_clear within w_sims_gemini_manifest_rpt
integer taborder = 20
end type

type dw_report from w_std_report`dw_report within w_sims_gemini_manifest_rpt
integer width = 3383
integer height = 1524
integer taborder = 30
string dataobject = "d_sims_manifest_rpt"
boolean hscrollbar = true
end type

