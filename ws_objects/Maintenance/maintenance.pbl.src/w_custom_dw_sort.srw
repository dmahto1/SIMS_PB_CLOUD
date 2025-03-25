$PBExportHeader$w_custom_dw_sort.srw
$PBExportComments$+ Custom DW sort column
forward
global type w_custom_dw_sort from w
end type
type st_4 from statictext within w_custom_dw_sort
end type
type st_3 from statictext within w_custom_dw_sort
end type
type st_2 from statictext within w_custom_dw_sort
end type
type st_1 from statictext within w_custom_dw_sort
end type
type dw_custom_sort from u_dw_ancestor within w_custom_dw_sort
end type
end forward

global type w_custom_dw_sort from w
integer width = 2610
integer height = 1944
string title = "Custom Sort Column"
st_4 st_4
st_3 st_3
st_2 st_2
st_1 st_1
dw_custom_sort dw_custom_sort
end type
global w_custom_dw_sort w_custom_dw_sort

on w_custom_dw_sort.create
int iCurrent
call super::create
this.st_4=create st_4
this.st_3=create st_3
this.st_2=create st_2
this.st_1=create st_1
this.dw_custom_sort=create dw_custom_sort
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_4
this.Control[iCurrent+2]=this.st_3
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.st_1
this.Control[iCurrent+5]=this.dw_custom_sort
end on

on w_custom_dw_sort.destroy
call super::destroy
destroy(this.st_4)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.dw_custom_sort)
end on

event open;call super::open;int il_customno
str_parms lstrparms
lstrparms = message.PowerObjectparm

il_customno = lstrparms.integer_arg[1]

dw_custom_sort.settransobject(SQLCA)
dw_custom_sort.retrieve(il_customno)

end event

event resize;call super::resize;dw_custom_sort.Resize(workspacewidth() - 50,workspaceHeight()-130)

end event

type st_4 from statictext within w_custom_dw_sort
integer x = 539
integer y = 100
integer width = 1102
integer height = 60
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 134217857
long backcolor = 67108864
string text = "0 = Hide Column, 1440 = 1 inch"
boolean focusrectangle = false
end type

type st_3 from statictext within w_custom_dw_sort
integer x = 32
integer y = 100
integer width = 494
integer height = 60
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 134217856
long backcolor = 67108864
string text = "Column Width:"
boolean focusrectangle = false
end type

type st_2 from statictext within w_custom_dw_sort
integer x = 544
integer y = 28
integer width = 713
integer height = 60
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 134217857
long backcolor = 67108864
string text = "from LEFT to RIGHT"
boolean focusrectangle = false
end type

type st_1 from statictext within w_custom_dw_sort
integer x = 37
integer y = 24
integer width = 549
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 134217856
long backcolor = 67108864
string text = "Sort Sequence:"
boolean focusrectangle = false
end type

type dw_custom_sort from u_dw_ancestor within w_custom_dw_sort
integer y = 160
integer width = 2523
integer height = 1572
integer taborder = 10
string title = "Custom Sort Column"
string dataobject = "d_custom_datawindow_sort"
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event itemchanged;//29-Jul-2014 : Madhu- Added code to do Auto sort sequence no

long ll_rowcount,ll_original_no,ll_NextRow,ll_row,ll_seq_no,ll_original_row,ll_orignal_column_width
string ls_orignal_column_name,lsfind


ll_rowcount =this.rowcount()
lsFind ="sort_sequence_no= " + data 

ll_NextRow = this.Find( lsFind, 1, this.rowcount() +1) //Next occurance value
ll_original_row = ll_NextRow

Choose Case dwo.Name
	case 'sort_sequence_no'
		ll_original_no= this.getItemnumber(row,'sort_sequence_no',Primary!,true)
		ls_orignal_column_name =    this.getItemString(row,'column_name',Primary!,true)
		ll_orignal_column_width =    this.getItemnumber(row,'column_width',Primary!,true)
		
		//If orignal value (2) < data (6) then push to seq no,column name, width to next/forward row.
		IF ll_original_no < long(data) Then
			For ll_row = row to ll_NextRow - 1

				this.setitem(row,'column_name',this.getItemstring(row+1,'column_name',Primary!,true))
				this.setitem(row,'sort_sequence_no',this.getItemnumber(row,'sort_sequence_no',Primary!,true))
				this.setitem(row,'column_width',this.getItemnumber(row+1,'column_width',Primary!,true))
				
				row++
			NEXT
		
		this.setitem(ll_NextRow,'column_name',ls_orignal_column_name)
		this.setitem(ll_NextRow,'sort_sequence_no',long(data))
		this.setitem(ll_NextRow,'column_width',ll_orignal_column_width)
		
	ELSE
			//If orignal value (6) > data (2) then push to seq no,column name, width to backward row.
			For ll_row = ll_NextRow to row - 1
				ll_seq_no =this.getItemnumber(ll_NextRow,'sort_sequence_no',Primary!,true)
				
				this.setitem(ll_NextRow+1,'column_name',this.getItemstring(ll_NextRow,'column_name',Primary!,true))
				this.setitem(ll_NextRow+1,'sort_sequence_no',ll_seq_no +1)
				this.setitem(ll_NextRow+1,'column_width',this.getItemnumber(ll_NextRow,'column_width',Primary!,true))

				ll_NextRow++
			NEXT
			
			this.setitem(ll_original_row,'column_name',ls_orignal_column_name)
			this.setitem(ll_original_row,'sort_sequence_no',long(data))
			this.setitem(ll_original_row,'column_width',ll_orignal_column_width)
		
	END IF	

END CHOOSE
		
dw_custom_sort.update( ) //update to db
		
Return 2
end event

