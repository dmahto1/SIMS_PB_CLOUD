$PBExportHeader$w_adjust_create_import.srw
$PBExportComments$+ Adjustment on Import
forward
global type w_adjust_create_import from w
end type
type cb_delete from commandbutton within w_adjust_create_import
end type
type st_validation from statictext within w_adjust_create_import
end type
type cb_cancel from commandbutton within w_adjust_create_import
end type
type cb_ok from commandbutton within w_adjust_create_import
end type
type cb_import from commandbutton within w_adjust_create_import
end type
type dw_adjustment_import from datawindow within w_adjust_create_import
end type
end forward

global type w_adjust_create_import from w
string tag = "Stock Adjustment Import"
integer width = 3931
integer height = 1424
string title = "Stock Adjustment Import"
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
cb_delete cb_delete
st_validation st_validation
cb_cancel cb_cancel
cb_ok cb_ok
cb_import cb_import
dw_adjustment_import dw_adjustment_import
end type
global w_adjust_create_import w_adjust_create_import

type variables
 Datawindow iw_adjust_content
end variables

forward prototypes
public function string wf_validate (long al_row)
public function string wf_duplicate_record_validation ()
end prototypes

public function string wf_validate (long al_row);String ls_colname,ls_value,ls_origvalue,lsFind,ls_prevcolumn
String ls_sku,ls_org_lotno,ls_new_lotno,ls_org_pono,ls_new_pono,ls_org_pono2,ls_new_pono2
Long ll_colnum,li_StartCol,ll_Findrow


st_validation.text=''
ll_colnum = Long (dw_adjustment_import.object.datawindow.column.count) 

FOR li_StartCol = 1 to ll_colnum 
	ls_colname = dw_adjustment_import.describe ('#' + string (li_StartCol) + ". name") + "_t" 
	ls_value=dw_adjustment_import.getitemstring( al_row, li_StartCol)
	
	ls_colname = Left(ls_colname, (pos(ls_colname,'_t')-1))
	
	//Ignore validation if Original and NEW attribute values are NULL /Blank
	IF upper(ls_colname)='NEW_LOT' or upper(ls_colname)='NEW_PONO' or upper(ls_colname)='NEW_PONO2'THEN
		If ls_origvalue >''  and (ls_value ='' or isnull(ls_value))THEN //If Original value is present,  validate NEW attribute value.
			f_setfocus(dw_adjustment_import,ll_colnum,ls_colname)
			Return " Following column: " + Upper(ls_colname) + " shouldn't be NULL or Blank, Since it's Orignal Column has a value"
		ELSEIF ls_value >''  and (ls_origvalue ='' or isnull(ls_origvalue))THEN //If NEW value is present,  validate Original attribute value.
				f_setfocus(dw_adjustment_import,ll_colnum,ls_prevcolumn)
				Return " Following column: " + Upper(ls_prevcolumn) + " shouldn't be NULL or Blank, Since it's NEW Column has a value"
		END IF
	END IF
	
	ls_origvalue = ls_value
	ls_prevcolumn =ls_colname

NEXT

//check whether record exists on Adjustment content DW or not.

ls_sku= dw_adjustment_import.getitemstring(al_row,'SKU')
ls_org_lotno= dw_adjustment_import.getitemstring(al_row,'Original_Lot')
ls_org_pono= dw_adjustment_import.getitemstring(al_row,'Original_PoNo')
ls_org_pono2= dw_adjustment_import.getitemstring(al_row,'Original_PoNo2')

IF  ls_sku >' ' Then lsFind = "SKU='"+ls_sku+"'"
IF  ls_org_lotno > ' ' Then lsFind += " and lot_no= '"+ls_org_lotno+"'"
IF  ls_org_pono > ' ' Then lsFind += " and po_no= '"+ls_org_pono+"'"
IF  ls_org_pono2 > ' ' Then lsFind += "and po_no2= '"+ls_org_pono2+"'"
	
ll_Findrow = iw_adjust_content.find( lsFind, 1, iw_adjust_content.rowcount()) //Find a record with original attribute values.

//prompt an error message
If ll_Findrow = 0 THEN
	MessageBox("Stock Adjustment Import","Import Record doesn't exists on Stock Adjustment Screen with Original values. Please Import appropriate record and Re-validate!", StopSign!)
	Return " SKU: "+nz(dw_adjustment_import.getitemstring(al_row,'SKU'),'')+", Lot No: "+nz(dw_adjustment_import.getitemstring(al_row,'Original_Lot'),'') &
	+", Po No: "+ nz(dw_adjustment_import.getitemstring(al_row,'Original_PoNo'),'')+", Po No2: "+nz(dw_adjustment_import.getitemstring(al_row,'Original_PoNo2'),'')+"."
END IF

end function

public function string wf_duplicate_record_validation ();string ls_sku,ls_org_lotno,ls_new_lotno,ls_org_pono,ls_new_pono,ls_org_pono2,ls_new_pono2,lsFind
Long li_row,ll_Findrow,ll_duplicaterow

For li_row =1 to dw_adjustment_import.rowcount( )
ls_sku=dw_adjustment_import.getitemstring(li_row,'SKU')
ls_org_lotno= dw_adjustment_import.getitemstring(li_row,'Original_Lot')
ls_new_lotno= dw_adjustment_import.getitemstring(li_row,'New_Lot')
ls_org_pono= dw_adjustment_import.getitemstring(li_row,'Original_PoNo')
ls_new_pono= dw_adjustment_import.getitemstring(li_row,'New_PoNo')
ls_org_pono2= dw_adjustment_import.getitemstring(li_row,'Original_PoNo2')
ls_new_pono2= dw_adjustment_import.getitemstring(li_row,'New_PoNo2')

lsFind ="SKU= '"+ls_sku+"' and Original_Lot= '"+ls_org_lotno+"' and New_Lot= '"+ls_new_lotno+"'"
lsFind +="and Original_PoNo= '"+ls_org_pono+"' and 	New_PoNo='"+ls_new_pono+"'"
lsFind +="and Original_PoNo2='"+ls_org_pono2+"' and New_PoNo2='"+ls_new_pono2+"'"

ll_Findrow =dw_adjustment_import.find( lsFind, 0, dw_adjustment_import.rowcount())

Do While ll_Findrow >0 
	ll_Findrow = dw_adjustment_import.Find(lsFind,ll_Findrow+1,dw_adjustment_import.RowCount()+1)
	
	IF ll_Findrow >1 Then
		ll_duplicaterow =ll_Findrow
	END IF
Loop

IF ll_duplicaterow = li_row THEN
	//MessageBox("Stock Adjustment Import","Doesn't allow to Import duplicate Adjustment records  at row  " +string(ll_duplicaterow),StopSign!)
	Return "Doesn't allow to Import duplicate Adjustment records  at row  " +string(ll_duplicaterow)
END IF

NEXT
end function

on w_adjust_create_import.create
int iCurrent
call super::create
this.cb_delete=create cb_delete
this.st_validation=create st_validation
this.cb_cancel=create cb_cancel
this.cb_ok=create cb_ok
this.cb_import=create cb_import
this.dw_adjustment_import=create dw_adjustment_import
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_delete
this.Control[iCurrent+2]=this.st_validation
this.Control[iCurrent+3]=this.cb_cancel
this.Control[iCurrent+4]=this.cb_ok
this.Control[iCurrent+5]=this.cb_import
this.Control[iCurrent+6]=this.dw_adjustment_import
end on

on w_adjust_create_import.destroy
call super::destroy
destroy(this.cb_delete)
destroy(this.st_validation)
destroy(this.cb_cancel)
destroy(this.cb_ok)
destroy(this.cb_import)
destroy(this.dw_adjustment_import)
end on

event resize;call super::resize;dw_adjustment_import.resize( workspacewidth() -10, workspaceHeight() -360)
end event

event open;call super::open;iw_adjust_content=message.powerobjectparm

end event

type cb_delete from commandbutton within w_adjust_create_import
integer x = 1678
integer y = 1228
integer width = 402
integer height = 112
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Delete"
end type

event clicked;If dw_adjustment_import.rowcount( ) =0 THEN
	MessageBox("tock Adjustment Import","No records are available to delete", StopSign!)
	Return
END IF

dw_adjustment_import.deleterow(dw_adjustment_import.getrow( ))
end event

type st_validation from statictext within w_adjust_create_import
integer x = 55
integer y = 1124
integer width = 3735
integer height = 92
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
boolean focusrectangle = false
end type

type cb_cancel from commandbutton within w_adjust_create_import
integer x = 1134
integer y = 1228
integer width = 402
integer height = 112
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancel"
end type

event clicked;close(parent)
end event

type cb_ok from commandbutton within w_adjust_create_import
integer x = 603
integer y = 1228
integer width = 402
integer height = 112
integer taborder = 20
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "OK"
end type

event clicked;String ls_sku,ls_org_lotno,ls_new_lotno,ls_org_pono,ls_new_pono,ls_org_pono2,ls_new_pono2
String lsmsg,lsFind
Long il_row,ll_rowcount,ilcurrvalrow,ll_adjust_count,ll_Findrow

SetPointer(HourGlass!)
dw_adjustment_import.accepttext( )

ilcurrvalrow =1

ll_rowcount =dw_adjustment_import.rowcount( ) //get total rows from datawindow

//validate each row/column
Do While ilcurrvalrow <= ll_rowcount and ll_rowcount > 0
	w_main.SetMicroHelp("validating Row" + string(ilcurrvalrow) + ' of ' + string(ll_rowcount))
	lsmsg =wf_validate(ilcurrvalrow)
	
	If lsmsg >'' Then
		dw_adjustment_import.scrolltorow( ilcurrvalrow)
		st_validation.text ='Row' + string(ilcurrvalrow) + ':' + lsmsg
		SetPointer(Arrow!)
		ilcurrvalrow++
		Return -1
	END IF
	ilcurrvalrow++	
Loop

//check for duplicate records on Import file
lsmsg= wf_duplicate_record_validation()

If lsmsg >'' THEN
	MessageBox("Stock Adjustment Import",lsmsg,StopSign!)
	Return -1
END IF

//If Import count > adjust count throw error message
IF ll_rowcount > iw_adjust_content.rowcount( ) THEN
	MessageBox("Stock Adjustment Import", "Import file shouldn't have more than existing Adjustment Content Records", StopSign!)
	Return -1
END IF

//update NEW attribute values onto Stock Adjustment Content records.
For il_row=1 to ll_rowcount
	
	ls_sku= dw_adjustment_import.getitemstring(il_row,'SKU')
	ls_org_lotno= dw_adjustment_import.getitemstring(il_row,'Original_Lot')
	ls_new_lotno= dw_adjustment_import.getitemstring(il_row,'New_Lot')
	ls_org_pono= dw_adjustment_import.getitemstring(il_row,'Original_PoNo')
	ls_new_pono= dw_adjustment_import.getitemstring(il_row,'New_PoNo')
	ls_org_pono2= dw_adjustment_import.getitemstring(il_row,'Original_PoNo2')
	ls_new_pono2= dw_adjustment_import.getitemstring(il_row,'New_PoNo2')
	

	IF  ls_sku >' ' Then lsFind = "SKU='"+ls_sku+"'"
	IF  ls_org_lotno > ' ' Then lsFind += " and lot_no= '"+ls_org_lotno+"'"
	IF  ls_org_pono > ' ' Then lsFind += "and po_no= '"+ls_org_pono+"'"
	IF  ls_org_pono2 > ' ' Then lsFind += "and po_no2= '"+ls_org_pono2+"'"

	//Find appropriate record
	ll_Findrow =iw_adjust_content.find(lsFind,0,iw_adjust_content.rowcount( ))
	
	//populate with new values onto Adjustment Content Detail row.
	IF ll_Findrow > 0 THEN
		IF ls_new_lotno >' ' THEN 	 iw_adjust_content.setitem( ll_Findrow, 'lot_no', ls_new_lotno)
		IF ls_new_pono >' ' THEN 	 iw_adjust_content.setitem( ll_Findrow, 'po_no', ls_new_pono)
		IF ls_new_pono2 > ' ' THEN iw_adjust_content.setitem( ll_Findrow, 'po_no2', ls_new_pono2)
		iw_adjust_content.setitem( ll_Findrow, 'c_send_collab_ind', 'Y')
	END IF
	
NEXT

MessageBox("Stock Adjustment Import"," Successfully Imported records onto Stock Adjustment Screen!")

close(parent)

end event

type cb_import from commandbutton within w_adjust_create_import
integer x = 69
integer y = 1228
integer width = 402
integer height = 112
integer taborder = 20
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Import"
end type

event clicked;
String is_filepath,is_filename

SetPointer(HourGlass!)

GetFileOpenName("Open",is_filepath,is_filename,"ALL Files","All Files (*.*), *.*") //Open a dailog box to select the import file

IF FileExists(is_filename) THEN
	dw_adjustment_import.importfile( is_filename)
ELSE
	dw_adjustment_import.reset( )
	dw_adjustment_import.insertrow( 0)
END IF

SetPointer(Arrow!)

st_validation.text = ""



end event

type dw_adjustment_import from datawindow within w_adjust_create_import
integer x = 32
integer y = 28
integer width = 3886
integer height = 1068
integer taborder = 10
string title = "Stock Adjustment Import"
string dataobject = "d_adjustment_import"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event constructor;This.SetRowFocusindicator(Hand!)

end event

