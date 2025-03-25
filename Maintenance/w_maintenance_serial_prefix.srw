HA$PBExportHeader$w_maintenance_serial_prefix.srw
$PBExportComments$-
forward
global type w_maintenance_serial_prefix from w_std_simple_list
end type
type st_1 from statictext within w_maintenance_serial_prefix
end type
type sle_sku from singlelineedit within w_maintenance_serial_prefix
end type
type cb_1 from commandbutton within w_maintenance_serial_prefix
end type
type p_arrow from picture within w_maintenance_serial_prefix
end type
end forward

global type w_maintenance_serial_prefix from w_std_simple_list
integer width = 4041
integer height = 2384
string title = "Item Serial Prefix List"
event ue_file ( )
st_1 st_1
sle_sku sle_sku
cb_1 cb_1
p_arrow p_arrow
end type
global w_maintenance_serial_prefix w_maintenance_serial_prefix

type variables
w_maintenance_serial_prefix iw_window
int iiWidth
int iiHeight

end variables

forward prototypes
public subroutine doexcelexport ()
public subroutine setwidth (integer _width)
public function integer getwidth ()
public subroutine setheight (integer _height)
public function integer getheight ()
end prototypes

event ue_file();// ue_file

if messagebox( "Save As", "Export to Excel?",question!,yesno!) = 1 then
	doExcelExport(  )
else
	dw_list.Saveas()
end if
	
end event

public subroutine doexcelexport ();// doExcelExport()
long rows

u_dwexporter exportr

rows = dw_list.rowcount()
if rows > 0 then 
	exportr.initialize()
	exportr.doExcelExport( dw_list, rows, true  )	
	exportr.cleanup()
end if



end subroutine

public subroutine setwidth (integer _width);// setwidth( int _width )

iiWidth = _width

end subroutine

public function integer getwidth ();// int = getWidth()
return iiWidth

end function

public subroutine setheight (integer _height);// setHeight( int _height )

iiheight = _height


end subroutine

public function integer getheight ();// int = getHeight()
return iiHeight

end function

on w_maintenance_serial_prefix.create
int iCurrent
call super::create
this.st_1=create st_1
this.sle_sku=create sle_sku
this.cb_1=create cb_1
this.p_arrow=create p_arrow
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.sle_sku
this.Control[iCurrent+3]=this.cb_1
this.Control[iCurrent+4]=this.p_arrow
end on

on w_maintenance_serial_prefix.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.sle_sku)
destroy(this.cb_1)
destroy(this.p_arrow)
end on

event ue_save;call super::ue_save;Long  ll_row
IF AncestorReturnValue = -1 THEN Return -1

ll_row = g.ids_coo_translate.rowcount()
// After validation updating the datawindow
Execute Immediate "Begin Transaction" using SQLCA;  // 11/22/04 - Turned Autocommit on, requiring 'Begin Transaction'
IF dw_list.Update(FALSE, FALSE) > 0 THEN
	Execute Immediate "COMMIT" using SQLCA;
	IF Sqlca.SqlCode = 0 THEN
		dw_list.Sort()
		dw_list.ResetUpdate()
		ib_changed = False
		// pvh - 10/24/05 - reload global translation table
		// reload the global translation table
		ll_row = g.ids_item_serial_prefix.Retrieve(gs_Project )
		//
		Return 0
	ELSE
		Execute Immediate "ROLLBACK" using SQLCA;
		MessageBox(is_title,Sqlca.SqlErrText, Exclamation!, Ok!, 1)
		Return -1
	END IF
ELSE
	Execute Immediate "ROLLBACK" using SQLCA;
	MessageBox(is_title,"Error while saving record!")
	Return -1
END IF						

end event

event ue_new;call super::ue_new;
dw_list.SetColumn("sku")
dw_list.object.project_id[dw_list.Getrow()]= gs_project
end event

event ue_postopen;call super::ue_postopen;iw_window = This

dw_list.setrowfocusindicator( p_arrow )

// pvh 11/14/05 - enabled save as menu 

m_simple_record.m_file.m_saveas.enabled = true
m_simple_record.m_file.m_saveas.visible = true

This.TriggerEvent('ue_retrieve')
end event

event ue_preupdate;call super::ue_preupdate;Long ll_rowcnt, ll_row,ll_rtn
String ls_sku,ls_supplier
n_cst_common_tables ln_common

If f_check_access(is_process,"S") = 0 THEN Return -1

If dw_list.AcceptText() = -1 Then Return -1

ll_rtn = 1

ll_rowcnt = dw_list.RowCount()

ll_rowcnt = dw_list.RowCount()

// Deleting the blank Rows
FOR ll_row = ll_rowcnt to 1 Step -1
	ls_sku = dw_list.object.sku[ll_row]
	IF IsNull(ls_sku) THEN
		dw_list.DeleteRow(ll_row)
	END IF
NEXT
ll_row = 1

//Validation checks
ll_rowcnt = dw_list.RowCount()
For ll_row = 1 to ll_rowcnt
	IF dw_list.Getitemstatus(ll_row,0,Primary!) = Notmodified! THEN Continue
	ls_sku     = dw_list.object.sku[ll_row]
	ls_supplier= dw_list.object.supp_code[ll_row]
	IF ln_common.of_item_master_sku_count(ls_sku,ls_supplier) = 0 THEN
		Messagebox(This.title,"Please check Sku = "+ ls_sku + " and supplier = " + ls_supplier +&
		"~n Combination is not valid...",stopsign!)
		dw_list.ScrollTORow(ll_row)
		ll_rtn= -1
		exit
	END IF
Next
Return ll_rtn
end event

event resize;call super::resize;// pvh - 04/25/06
setwidth( newwidth )
setheight( newheight )
dw_list.event ue_resize()
//dw_list.Resize(workspacewidth() - 10 ,workspaceHeight() - 130 )
end event

event ue_retrieve;// Ancestor being overridden

Integer li_return

IF ib_changed THEN
	Choose Case MessageBox(is_title,"Save Changes?",Question!,YesNoCancel!,3)
	   Case 1
		   li_return = Trigger Event ue_save()
			IF li_return = 0 THEN 
				dw_list.Retrieve(gs_project)
				ib_changed = False
			END IF
   	Case 2 
			dw_list.Retrieve(gs_project)
			ib_changed = False
	End Choose 		
ELSE
	dw_list.Retrieve(gs_project)
	ib_changed = False
END IF

end event

event ue_preopen;
//anscestor overridden
end event

event open;call super::open;// Intitialize
This.X = 0
This.Y = 0
is_process = Message.StringParm
is_title = This.Title

dw_list.SetTransObject(sqlca)


end event

type dw_list from w_std_simple_list`dw_list within w_maintenance_serial_prefix
integer x = 18
integer y = 120
integer width = 3973
integer height = 1984
string dataobject = "d_item_serial_prefix_grid"
end type

event dw_list::process_enter;// If last row & Column then insert new row
IF This.GetColumnName() = "prefix" THEN
	IF This.GetRow() = This.RowCount() THEN
		iw_window.PostEvent("ue_new")
	ELSE
		Send(Handle(This),256,9,Long(0,0))
		Return 1
	END IF
ELSE
	Send(Handle(This),256,9,Long(0,0))
	Return 1
End If

end event

event dw_list::ue_postitemchanged;call super::ue_postitemchanged;String ls_sku, ls_prev_serial,ls_supplier,ls_prefix,ls_syntax
Long ll_rowcnt,ll_find
IF row = 1 THEN Return
CHOOSE CASE dwo.Name
	CASE 'sku','supplier','prefix'
		ls_sku   = dw_list.object.sku[row]
		ls_supplier = dw_list.object.supp_code[row]
		ls_prefix = dw_list.object.prefix[row]
		ls_syntax = "sku = '" +ls_sku + "' and supp_code = '"+ls_supplier+ "' and prefix ='" + ls_prefix+"'"
		ll_find = dw_list.Find(ls_syntax,1, row - 1)
		IF ll_find > 0 THEN
			MessageBox(is_title, "Duplicate record found, please check!")
			Post Setcolumn("sku")			
		END IF	
END CHOOSE

	
end event

event dw_list::ue_resize;call super::ue_resize;
this.width = ( parent.getwidth() - 50 )
this.height = ( parent.getheight() - 130 )
this.x = 18


end event

type st_1 from statictext within w_maintenance_serial_prefix
integer x = 14
integer y = 28
integer width = 498
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Scroll To SKU:"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_sku from singlelineedit within w_maintenance_serial_prefix
integer x = 521
integer y = 20
integer width = 640
integer height = 80
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
end type

type cb_1 from commandbutton within w_maintenance_serial_prefix
integer x = 1175
integer y = 28
integer width = 402
integer height = 72
integer taborder = 10
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Go"
boolean default = true
end type

event clicked;string findthis
string searchfor

findthis = trim( sle_sku.text )

If findthis = "" or isNull(findThis) Then Return

searchfor = 'sku = ~'' + findthis + "~'"

long foundrow 

foundrow = dw_list.find( searchfor, 1, dw_list.rowcount() )
if foundrow <= 0 then
	beep( 1 )
	messagebox( "Search for sku", "Sku not found.",exclamation! )
	sle_sku.selecttext(1, Len(sle_sku.Text))
	sle_sku.setfocus()
	return
end if
dw_list.setsort( 'SKU A' )
dw_list.sort()
dw_list.scrolltorow( foundrow )
dw_list.setrow( foundrow )



end event

type p_arrow from picture within w_maintenance_serial_prefix
boolean visible = false
integer x = 1984
integer y = 32
integer width = 73
integer height = 64
boolean bringtotop = true
boolean originalsize = true
string picturename = "Next!"
boolean focusrectangle = false
end type

