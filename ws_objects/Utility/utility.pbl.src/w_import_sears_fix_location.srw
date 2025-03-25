$PBExportHeader$w_import_sears_fix_location.srw
$PBExportComments$Import locations for Sears Fixtures orders
forward
global type w_import_sears_fix_location from w_response_ancestor
end type
type dw_1 from datawindow within w_import_sears_fix_location
end type
end forward

global type w_import_sears_fix_location from w_response_ancestor
integer width = 1262
integer height = 1312
string title = "Select Store Locations"
dw_1 dw_1
end type
global w_import_sears_fix_location w_import_sears_fix_location

on w_import_sears_fix_location.create
int iCurrent
call super::create
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
end on

on w_import_sears_fix_location.destroy
call super::destroy
destroy(this.dw_1)
end on

event open;call super::open;
Istrparms = Message.PowerObjectParm
end event

event ue_postopen;call super::ue_postopen;Long	llArrayCount, llArraypos, llNewRow

dw_1.Setredraw(false)
//load DW from structure
llArrayCount = UpperBound(Istrparms.Long_arg)
For llArrayPos = 1 to llArrayCount
	llNewRow = dw_1.InsertRow(0)
	dw_1.SetItem(llNewrow,'store_id',istrparms.Long_arg[llArrayPos])
	dw_1.SetItem(llNewrow,'l_code',istrparms.String_arg[llArrayPos])
Next

dw_1.Sort()
dw_1.SetRedraw(True)
end event

event closequery;call super::closequery;str_parms	lstrparms
Long	llRowPos, llRowCount

dw_1.AcceptText()

If Not Istrparms.Cancelled Then
	
	istrparms = lstrparms /* re-init*/
	
	lLRowCount = dw_1.RowCount()
	For llRowPos = 1 to llRowCount
		Istrparms.Long_arg[llRowPos] = dw_1.GetITemNumber(llrowPos,'store_id')
		Istrparms.String_arg[lLRowPos] = dw_1.GetItemString(llRowPos,'l_code')
	next
	
End If

Message.PowerObjectParm = Istrparms
end event

type cb_cancel from w_response_ancestor`cb_cancel within w_import_sears_fix_location
integer x = 635
integer y = 1092
integer height = 92
integer textsize = -8
end type

type cb_ok from w_response_ancestor`cb_ok within w_import_sears_fix_location
integer x = 201
integer y = 1092
integer height = 92
integer textsize = -8
end type

type dw_1 from datawindow within w_import_sears_fix_location
integer x = 41
integer y = 8
integer width = 1143
integer height = 1028
integer taborder = 10
boolean bringtotop = true
string title = "none"
string dataobject = "d_import_sears_fix_locations"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event itemchanged;Long	llCount

//Validate Location

IF dwo.name = 'l_code' Then
	Select Count(*) into :llCount
	From Location
	Where wh_code = :gs_default_wh and l_code = :data;
End If

If llCount <= 0 Then
	messageBox('Select Locations', 'Invalid Location')
	Return 1
End If

end event

event itemerror;
Return 2
end event

