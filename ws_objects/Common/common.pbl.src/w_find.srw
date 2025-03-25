$PBExportHeader$w_find.srw
forward
global type w_find from window
end type
type cbx_search_backwards from checkbox within w_find
end type
type dw_find from datawindow within w_find
end type
type cb_close from commandbutton within w_find
end type
type cb_1 from commandbutton within w_find
end type
end forward

global type w_find from window
integer width = 1632
integer height = 788
boolean titlebar = true
string title = "Find Data"
boolean controlmenu = true
boolean minbox = true
windowtype windowtype = popup!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cbx_search_backwards cbx_search_backwards
dw_find dw_find
cb_close cb_close
cb_1 cb_1
end type
global w_find w_find

type variables

datawindow is_currentdw

long il_find = 0

end variables

on w_find.create
this.cbx_search_backwards=create cbx_search_backwards
this.dw_find=create dw_find
this.cb_close=create cb_close
this.cb_1=create cb_1
this.Control[]={this.cbx_search_backwards,&
this.dw_find,&
this.cb_close,&
this.cb_1}
end on

on w_find.destroy
destroy(this.cbx_search_backwards)
destroy(this.dw_find)
destroy(this.cb_close)
destroy(this.cb_1)
end on

event open;



datawindowchild ldw_child
long l_Row

dw_find.InsertRow(0)

is_currentdw = message.PowerObjectParm

dw_find.GetChild("find_column", ldw_child)


//------------------------------------------------------------------
//  Get the columns from the DataWindow.  If a column is already set
//  as sorted, move the row to the sorted DataWindow.
//------------------------------------------------------------------

Long l_ColumnCnt, l_Idx
String l_name

l_ColumnCnt = Integer(is_currentdw.Describe("datawindow.column.count"))

string ls_syntax, ls_display_name, l_Visible
long ll_foundrow

FOR l_Idx = 1 TO l_ColumnCnt

	l_Name = is_currentdw.Describe("#" + String(l_Idx) + ".name")
	
	//CHECK IF COLUMN LABELS ARE NOT BLANK

	l_Visible = is_currentdw.Describe("#" + String(l_Idx) + ".visible")
	
	if left(l_Visible, 1) <> "1" THEN CONTINUE

	 ls_syntax=  "upper(datawindows) = '"+upper(string(is_currentdw.dataobject))+ "' and upper(column_name) = '"+upper(string(l_Name))+"' and (column_label <> '')"

	 ll_foundrow = g.ids_columnlabel.Find(ls_syntax,1, g.ids_columnlabel.RowCount()) 				
		
	 if ll_foundrow > 0 then
		
		ls_display_name = g.ids_columnlabel.GetItemString( ll_foundrow, "column_label")
		
	 else
	 	ls_display_name = l_Name		
	 end if

	l_Row  = ldw_child.InsertRow(0)
	ldw_child.SetItem(l_Row, "display_name", ls_display_name)
	ldw_child.SetItem(l_Row, "column_name", l_Name)		


NEXT

IF is_currentdw.dataobject = "d_ro_detail" OR &
	is_currentdw.dataobject = "d_ro_putaway" OR &
	is_currentdw.dataobject = "d_do_detail" OR &
	is_currentdw.dataobject = "d_do_picking" OR &
	is_currentdw.dataobject = "d_do_packing_grid" THEN	

	
	dw_find.SetItem( 1, "find_column", "sku")
	dw_find.SetColumn("find_value")
	
END IF

dw_find.SetFocus()


end event

type cbx_search_backwards from checkbox within w_find
integer x = 539
integer y = 380
integer width = 581
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Search Backwards"
end type

type dw_find from datawindow within w_find
integer x = 73
integer y = 48
integer width = 1490
integer height = 260
integer taborder = 10
string title = "none"
string dataobject = "d_find"
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event itemchanged;
il_find = 0


end event

type cb_close from commandbutton within w_find
integer x = 937
integer y = 548
integer width = 402
integer height = 100
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Close"
boolean cancel = true
end type

event clicked;
Close(parent)
end event

type cb_1 from commandbutton within w_find
integer x = 402
integer y = 548
integer width = 402
integer height = 100
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Find Next"
boolean default = true
end type

event clicked;long ll_old_find

//if is_currentdw.GetRow() > 0 then
//	il_find = is_currentdw.GetRow()
//end if

ll_old_find = il_find



string ls_find_value, ls_find_column, l_ColType

dw_find.AcceptText()



ls_find_column = dw_find.GetItemString(1, "find_column")

ls_find_value = dw_find.GetItemString(1, "find_value")

IF IsNull(ls_find_column) THEN
	
	MessageBox ("Error", "Must enter a find column.")
	dw_find.SetColumn("find_column")
	dw_find.SetFocus()
	Return -1 
	
END IF


IF IsNull(ls_find_value) THEN
	
	MessageBox ("Error", "Must enter a find value.")
	dw_find.SetColumn("find_value")
	dw_find.SetFocus()
	Return -1 
	
END IF

l_ColType = Upper(is_currentdw.Describe(ls_find_column + ".ColType"))



string ls_Find_String

CHOOSE CASE left(l_ColType, 3)
CASE "DEC", "NUM", "LON", "ULO", "REA"
	ls_Find_String = ls_find_column + "=" + ls_find_value 
CASE ELSE
	ls_Find_String = "Upper(" + ls_find_column + ")='" + Upper(ls_find_value) + "'"
END CHOOSE

IF cbx_search_backwards.checked THEN

	il_find = il_find -1

	if il_find <= 0 then il_find = is_currentdw.RowCount()
	
	il_find = is_currentdw.Find(ls_Find_String, il_find, 1)

ELSE

	il_find = il_find + 1

	if  il_find > is_currentdw.RowCount() then il_find = 1


	il_find = is_currentdw.Find(ls_Find_String, il_find, is_currentdw.RowCount())

END IF

//If not found, try starting from top or bottom.

IF (il_find = 0) AND (ll_old_find <> 1) THEN
	
	IF cbx_search_backwards.checked THEN

		il_find = is_currentdw.Find(ls_Find_String, is_currentdw.RowCount(), 1)

	ELSE

		il_find = is_currentdw.Find(ls_Find_String, 1, is_currentdw.RowCount())

	END IF
	
END IF

if il_find > 0 THEN
	is_currentdw.SetColumn(ls_find_column)
	is_currentdw.ScrollToRow(il_find)
	is_currentdw.SetRow(il_find)
	
	is_currentdw.SelectText(1, Len(is_currentdw.GetText()))
	
	is_currentdw.SetFocus()

//	is_currentdw.SelectRow( 0, False)
//	is_currentdw.SelectRow( il_find, True)
	
	is_currentdw.Modify("DataWindow.Selected='"+string(il_find)+"/"+string(il_find)+"/"+ls_find_column+"/"+ls_find_column+"'")
	
	
//	Close(parent)
	
else 
	
	is_currentdw.Modify("DataWindow.Selected=''")

	
	MessageBox ("Error", "No row found.")	
end if



end event

