$PBExportHeader$w_select_owner.srw
$PBExportComments$Select Owner for Owner Table
forward
global type w_select_owner from w_response_ancestor
end type
type dw_select from u_dw_ancestor within w_select_owner
end type
type cb_search from commandbutton within w_select_owner
end type
type st_click_on_search_button from statictext within w_select_owner
end type
type st_select_an_owner_type from statictext within w_select_owner
end type
type dw_quick_choose from datawindow within w_select_owner
end type
end forward

global type w_select_owner from w_response_ancestor
integer height = 1204
boolean titlebar = false
string title = ""
boolean controlmenu = false
dw_select dw_select
cb_search cb_search
st_click_on_search_button st_click_on_search_button
st_select_an_owner_type st_select_an_owner_type
dw_quick_choose dw_quick_choose
end type
global w_select_owner w_select_owner

type variables
string is_owner_type

string is_wh_code
end variables

on w_select_owner.create
int iCurrent
call super::create
this.dw_select=create dw_select
this.cb_search=create cb_search
this.st_click_on_search_button=create st_click_on_search_button
this.st_select_an_owner_type=create st_select_an_owner_type
this.dw_quick_choose=create dw_quick_choose
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_select
this.Control[iCurrent+2]=this.cb_search
this.Control[iCurrent+3]=this.st_click_on_search_button
this.Control[iCurrent+4]=this.st_select_an_owner_type
this.Control[iCurrent+5]=this.dw_quick_choose
end on

on w_select_owner.destroy
call super::destroy
destroy(this.dw_select)
destroy(this.cb_search)
destroy(this.st_click_on_search_button)
destroy(this.st_select_an_owner_type)
destroy(this.dw_quick_choose)
end on

event ue_postopen;
dw_quick_choose.InsertRow(0)
dw_quick_choose.SetItem(1,"owner_type",'S') /*Default Radio button to Supplier*/
dw_quick_choose.SetItem(1,"update_all_rows_ind",'N') 
dw_quick_choose.SetFocus()
dw_quick_choose.SetColumn("owner_code")


IF gs_project = "PANDORA" THEN
	dw_select.dataobject = "d_select_owner_pandora"
	dw_select.SetTransObject(SQLCA)
END IF

end event

event closequery;Long	llOwnerID
String	lsOwnerName,	&
			lsType,			&
			lsCode


If Not Istrparms.Cancelled Then
	
	dw_quick_choose.AcceptText()
	
	If dw_quick_choose.GetItemString(1,"owner_code") > '' Then
		
		If isnull(dw_quick_choose.GetItemString(1,"owner_code")) Then
			Return 1 
		End If
		
		//Cant Select 'XX' as Owner
		If dw_quick_choose.GetItemString(1,"owner_code") = 'XX' Then
			messageBox("select Owner","'XX' is not a valid Owner!")
			dw_quick_choose.Setfocus()
			dw_quick_choose.SetColumn("Owner_code")
			Return 1
		End If
		
		lsType = dw_quick_choose.GetItemString(1,"owner_type")
		lsCode = dw_quick_choose.GetItemString(1,"owner_code")
		Select owner_id into :llOwnerID
		From	owner
		Where project_id = :gs_project and
				owner_type =:lsType and
				owner_cd = :lsCode and
				(NOT owner_type = 'IN' )
		using SQLCA;
		
		If (not isnull(llOwnerID)) and llOwnerID > 0 Then
			lsOwnerName = f_get_owner_name(llOwnerID)
			Istrparms.Long_arg[1] = llOwnerID
			Istrparms.String_arg[1] = lsOwnerName
			Istrparms.String_arg[2] = lsCode
			Istrparms.String_arg[3] = lsType
			Istrparms.String_arg[4] = dw_quick_choose.GetItemString(1,"update_all_rows_ind") /* 07/31 Pconkl - allow to update all rows for order with new owner*/
		Else /*Not Found*/
			messagebox("Select Owner","Owner Code Not Found!")
			dw_quick_choose.Setfocus()
			dw_quick_choose.SetColumn("Owner_code")
			Return 1
		End If
	End If /*owner code present*/
End If

Message.PowerObjectParm = Istrparms


end event

event open;call super::open;
is_wh_code = message.StringParm


end event

type cb_cancel from w_response_ancestor`cb_cancel within w_select_owner
integer x = 823
integer y = 1048
integer height = 100
integer taborder = 40
integer textsize = -9
end type

event cb_cancel::constructor;call super::constructor;
g.of_check_label_button(this)
end event

type cb_ok from w_response_ancestor`cb_ok within w_select_owner
integer x = 425
integer y = 1048
integer height = 100
integer textsize = -9
end type

event cb_ok::constructor;call super::constructor;
g.of_check_label_button(this)
end event

type dw_select from u_dw_ancestor within w_select_owner
integer x = 32
integer y = 340
integer width = 1934
integer height = 676
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_select_owner"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event clicked;//If row is clicked then highlight the row
IF row > 0 THEN
	This.SelectRow(0, FALSE)
	This.SelectRow(row, TRUE)
	dw_quick_choose.SetItem(1,"owner_code",This.getItemString(row,"owner_cd"))
	dw_quick_choose.SetItem(1,"owner_type",This.getItemString(row,"owner_type"))
End If

end event

event doubleclicked;
If Row > 0 Then
	Close(Parent)
End If
end event

type cb_search from commandbutton within w_select_owner
integer x = 1216
integer y = 1048
integer width = 302
integer height = 100
integer taborder = 50
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Search"
end type

event clicked;long  ll_row
String ls_sql

IF gs_project = "PANDORA" THEN
	
//	ls_sql =dw_select.GetSQLSelect()
//	MessageBox("jlatest", ls_sql +'~r~r Project ID = '+gs_project+ '~r~r Qwner_type = '+dw_quick_choose.getItemString(1,"owner_type")+'~r~r Qwner_type = '+is_wh_code)
	dw_select.retrieve(gs_project,dw_quick_choose.getItemString(1,"owner_type"), is_wh_code)
ELSE
	dw_select.retrieve(gs_project,dw_quick_choose.getItemString(1,"owner_type"))
END IF
end event

event constructor;///dw_quick_choose.SetItem(1,"owner_type",'S') /*Default Radio button to Supplier*/

g.of_check_label_button(this)
end event

type st_click_on_search_button from statictext within w_select_owner
integer x = 27
integer y = 260
integer width = 1719
integer height = 76
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
boolean enabled = false
string text = "OR  Click on the ~'Search~' button and double click an owner."
boolean focusrectangle = false
end type

event constructor;
g.of_check_label_button(this)
end event

type st_select_an_owner_type from statictext within w_select_owner
integer x = 5
integer y = 12
integer width = 1472
integer height = 76
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 80269524
boolean enabled = false
string text = "Select an Owner Type, Enter an Owner Code and Click ~'OK~'"
boolean focusrectangle = false
end type

event constructor;
g.of_check_label_button(this)
end event

type dw_quick_choose from datawindow within w_select_owner
integer x = 18
integer y = 76
integer width = 1934
integer height = 140
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_select_owner_quick"
boolean livescroll = true
end type

event itemchanged;String	ls_column
string	ls_data

long		ll_row

dw_quick_choose.AcceptText()

ls_column 	= DWO.Name

CHOOSE CASE ls_column
	CASE "owner_type"
		IF data = "C" THEN
//			dw_select.Dataobject = "d_select_pandora_uf2_customer"
			dw_select.SetTransObject(SQLCA)
			dw_quick_choose.SetItem(1,"owner_type","C")
			
		ELSE
//			dw_select.Dataobject = "d_select_owner"
			dw_select.SetTransObject(SQLCA)
			dw_quick_choose.SetItem(1,"owner_type","S")
			
		END IF
		
	CASE ELSE
		
END CHOOSE




end event

event constructor;dw_select.SetItem(1,"owner_type","S")

g.of_check_label(this) 
end event

