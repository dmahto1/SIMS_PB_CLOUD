$PBExportHeader$w_ge_replenish_rpt.srw
$PBExportComments$window used for displaying information on GE replenishment
forward
global type w_ge_replenish_rpt from w_std_report
end type
type rb_1 from radiobutton within w_ge_replenish_rpt
end type
type rb_2 from radiobutton within w_ge_replenish_rpt
end type
type st_1 from statictext within w_ge_replenish_rpt
end type
end forward

global type w_ge_replenish_rpt from w_std_report
int Width=3662
int Height=2088
boolean TitleBar=true
string Title="GE Replenishment Report"
rb_1 rb_1
rb_2 rb_2
st_1 st_1
end type
global w_ge_replenish_rpt w_ge_replenish_rpt

type variables
datastore ids_find_warehouse
string is_warehouse_code
string is_warehouse_name
string is_origsql
boolean ib_first_time
integer ii_selected

end variables

on w_ge_replenish_rpt.create
int iCurrent
call super::create
this.rb_1=create rb_1
this.rb_2=create rb_2
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_1
this.Control[iCurrent+2]=this.rb_2
this.Control[iCurrent+3]=this.st_1
end on

on w_ge_replenish_rpt.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.st_1)
end on

event open;call super::open;
Integer  li_pos

//Choose G and GG parts as default window
rb_1.checked = TRUE
rb_2.checked = FALSE
//dw_report.dataobject = "d_ge_replenish_rpt"
//dw_report.SetTransObject(SQLCA)
ii_selected = 1
dw_select.Object.warehouse.visible = 1
dw_select.Object.warehouse_t.visible = 1

is_OrigSql = dw_report.getsqlselect()
end event

event resize;dw_report.Resize(workspacewidth() - 30,workspaceHeight()-225)
end event

event ue_clear;dw_select.Reset()
dw_select.InsertRow(0)

end event

event ue_postopen;call super::ue_postopen;DatawindowChild	ldwc_warehouse

//populate dropdowns - not done automatically since dw not being retrieved

dw_select.GetChild('warehouse', ldwc_warehouse)
ldwc_warehouse.SetTransObject(Sqlca)
ldwc_warehouse.Retrieve(gs_project)



end event

event ue_retrieve;
String ls_Where
String ls_NewSql
string ls_value
string ls_warehouse_code
string ls_warehouse_name


Long ll_balance
Long i
long ll_cnt
long ll_find_row

dw_select.AcceptText() 
IF ii_selected = 1 or ii_selected = 2 THEN
	
	SetPointer(HourGlass!)
	//dw_report.Reset()

	//Process Warehouse Number
	IF ib_first_time  = TRUE THEN
  	
		is_warehouse_name = dw_select.GetItemString(1,"warehouse") 
		ll_find_row = ids_find_warehouse.Find ("wh_name = '" + is_warehouse_name + "'",&
																1,ids_find_warehouse.RowCount())
		
		IF ll_find_row > 0 THEN
			is_warehouse_code = ids_find_warehouse.GetItemString(ll_find_row,"wh_code")
			ls_warehouse_name = ids_find_warehouse.GetItemString(ll_find_row,"wh_name")
							
		END IF
		ib_first_time = false
		IF (is_warehouse_code = "") or isnull(is_warehouse_code) THEN
			MessageBox("ERROR", "Please select a warehouse",stopsign!)
		ELSE
			dw_report.Object.project.text = gs_project
			dw_report.Object.warehouse.text = ls_warehouse_name
			ll_cnt = dw_report.Retrieve(gs_project, is_warehouse_code)

			If ll_cnt > 0 Then
				im_menu.m_file.m_print.Enabled = True
				dw_report.Setfocus()
			Else
				im_menu.m_file.m_print.Enabled = False	
				MessageBox(is_title, "No records found!")
				dw_select.Setfocus()
			END IF
		END IF
		
	
	ELSE
  		is_warehouse_code = dw_select.GetItemString(1,"warehouse")
		ll_find_row = ids_find_warehouse.Find ("wh_code = '" + is_warehouse_code + "'",&
																1,ids_find_warehouse.RowCount())
														
		IF ll_find_row > 0 THEN
			is_warehouse_code = ids_find_warehouse.GetItemString(ll_find_row,"wh_code")
			ls_warehouse_name = ids_find_warehouse.GetItemString(ll_find_row,"wh_name")
							
		ELSE
			ll_find_row = ids_find_warehouse.Find ("wh_name = '" + is_warehouse_code + "'",&
																1,ids_find_warehouse.RowCount())
			IF ll_find_row > 0 THEN
				is_warehouse_code = ids_find_warehouse.GetItemString(ll_find_row,"wh_code")
				ls_warehouse_name = ids_find_warehouse.GetItemString(ll_find_row,"wh_name")
											
			END IF
		END IF
		
		IF (is_warehouse_code = "") or isnull(is_warehouse_code) THEN
			MessageBox("ERROR", "Please select a warehouse",stopsign!)
		ELSE
			dw_report.Object.project.text = gs_project
			dw_report.Object.warehouse.text = ls_warehouse_name
			ll_cnt = dw_report.Retrieve(gs_project, is_warehouse_code)

			If ll_cnt > 0 Then
				im_menu.m_file.m_print.Enabled = True
				dw_report.Setfocus()
			Else
				im_menu.m_file.m_print.Enabled = False	
				MessageBox(is_title, "No records found!")
				dw_select.Setfocus()
			End If
		
		END IF

	END IF
	
	
	ELSE
		Messagebox("Error", "Please choose a report type", stopsign!)
	END IF
	
	
	is_warehouse_code = " "





end event

type dw_select from w_std_report`dw_select within w_ge_replenish_rpt
int Width=2638
int Height=188
string DataObject="d_ge_replenish_rpt_srch"
boolean Border=false
BorderStyle BorderStyle=StyleBox!
end type

event dw_select::constructor;long		ll_row
long		ll_find_row

string 	ls_value
string	ls_warehouse_name


//Create the locating warehouse name datastore
ids_find_warehouse = CREATE Datastore 
ids_find_warehouse.dataobject = 'd_find_warehouse'
ids_find_warehouse.SetTransObject(SQLCA)
ids_find_warehouse.Retrieve()

ll_row = This.insertrow(0)
ib_first_time = true
dw_select.Object.warehouse.visible = 0
dw_select.Object.warehouse_t.visible = 0

dw_select.SetItem(ll_row,"warehouse",gs_default_wh)
ls_value = dw_select.GetItemString(ll_row,"warehouse")

ll_find_row = ids_find_warehouse.Find ("wh_code = '" + ls_value + "'",&
																1,ids_find_warehouse.RowCount())
IF ll_find_row > 0 THEN
	is_warehouse_name = ids_find_warehouse.GetItemString(ll_find_row,"wh_name")
	is_warehouse_code = ids_find_warehouse.GetItemString(ll_find_row,"wh_code")
	dw_select.SetItem(ll_row,"warehouse",is_warehouse_name)
	
END IF

end event

type cb_clear from w_std_report`cb_clear within w_ge_replenish_rpt
int TabOrder=20
end type

type dw_report from w_std_report`dw_report within w_ge_replenish_rpt
int X=23
int Y=216
int Width=3566
int Height=1676
int TabOrder=30
string DataObject="d_ge_replenish_rpt"
boolean HScrollBar=true
end type

type rb_1 from radiobutton within w_ge_replenish_rpt
int X=46
int Y=4
int Width=795
int Height=76
boolean BringToTop=true
string Text="G and GE Parts"
boolean LeftText=true
long TextColor=33554432
long BackColor=67108864
int TextSize=-10
int Weight=400
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;if rb_1.checked = TRUE THEN
	rb_2.checked = FALSE
	dw_report.dataobject = "d_ge_replenish_rpt"
	dw_report.SetTransObject(SQLCA)
	ii_selected = 1
	dw_select.Object.warehouse.visible = 1
	dw_select.Object.warehouse_t.visible = 1

END IF


end event

type rb_2 from radiobutton within w_ge_replenish_rpt
int X=50
int Y=136
int Width=791
int Height=76
boolean BringToTop=true
string Text="All except G and GE Parts"
boolean LeftText=true
long TextColor=33554432
long BackColor=67108864
int TextSize=-10
int Weight=400
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;if rb_2.checked = TRUE THEN
	//messagebox("Test", "all except G and GE Parts ")
	rb_1.checked = FALSE
	dw_report.DataObject = "d_ge_replenish_rpt2"
	dw_report.SetTransObject(SQLCA)
	ii_selected = 2
	dw_select.Object.warehouse.visible = 1
	dw_select.Object.warehouse_t.visible = 1

END IF

end event

type st_1 from statictext within w_ge_replenish_rpt
int X=256
int Y=72
int Width=142
int Height=76
boolean Enabled=false
boolean BringToTop=true
string Text="(OR)"
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=67108864
int TextSize=-10
int Weight=700
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

