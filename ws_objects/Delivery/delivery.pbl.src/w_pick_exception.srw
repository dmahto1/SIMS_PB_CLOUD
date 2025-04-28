$PBExportHeader$w_pick_exception.srw
$PBExportComments$*Picking exception
forward
global type w_pick_exception from window
end type
type cb_clear from commandbutton within w_pick_exception
end type
type cb_reserve from commandbutton within w_pick_exception
end type
type st_1 from statictext within w_pick_exception
end type
type cb_print from commandbutton within w_pick_exception
end type
type cb_ok from commandbutton within w_pick_exception
end type
type dw_exception from datawindow within w_pick_exception
end type
end forward

global type w_pick_exception from window
integer x = 823
integer y = 360
integer width = 3040
integer height = 1548
boolean titlebar = true
string title = "Pick Exceptions"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 79741120
event ue_postopen ( )
cb_clear cb_clear
cb_reserve cb_reserve
st_1 st_1
cb_print cb_print
cb_ok cb_ok
dw_exception dw_exception
end type
global w_pick_exception w_pick_exception

type variables
str_parms	istrparms
String is_dono, isinvoice_no
end variables

event ue_postopen();Long	llArrayCount,	&
		llArrayPos,		&
		llnewRow
//Load exceptions from array
string lsData, lsTemp
integer lipos
DatawindowChild	lDWC
long ll_line_item_no
integer li_Find

dw_exception.SetRedraw(false)
SetPointer(Hourglass!)

//SARUN2013DEC24 : workable in w_batch case too.
If IsValid(w_do) then
	if w_do.idw_Main.RowCount() >= 1 Then
		is_dono = w_do.idw_Main.GetItemString(1, "Do_no")	
		isinvoice_no = w_do.idw_Main.GetItemString(1, "invoice_no")
		f_method_trace_special( gs_project, this.ClassName() + ' - ue_postopen', 'Pick Exception called:' ,is_dono, ' ',' ',isinvoice_no)
	end if
End if

//Retrieve Inv Type dropdown
dw_exception.GetChild('inv_type',ldwc)
ldwc.SetTransObject(SQLCA)
ldwc.Retrieve(gs_Project)

llArrayCount = UpperBound(istrparms.String_arg)

//If genereated on server, we will parse returned xml of shortages, otherwise, parse as usual...
If Pos(Istrparms.String_arg[1],"DOPickShort") > 0 Then /*server*/

	// 12/05 - PCONKL - Importing from XML returned from Websphere
	dw_exception.modify("datawindow.import.xml.usetemplate='dopickshort'")
	dw_exception.ImportString(xml!,istrparms.String_arg[1])

	//MEA 12/11 - Added for NIKE 
	 
	IF gs_project = "NIKE-SG" OR gs_project = "NIKE-MY" THEN
		
		For llArrayPos = 1 to dw_exception.RowCount()
	
			If IsValid(w_do.idw_Main) and w_do.idw_Main.RowCount() >= 1 Then
				
				dw_exception.SetItem(llArrayPos,"invoice_no", w_do.idw_Main.GetItemString(1, "invoice_no"))
			
				ll_line_item_no = dw_exception.GetItemNumber(llArrayPos, "line_item_no")
		
				li_Find = w_do.idw_detail.Find("line_item_no="+string(ll_line_item_no), 1, w_do.idw_detail.RowCount())
		
				If li_find > 0 Then
					
					dw_exception.SetItem(llArrayPos,"user_field1", w_do.idw_detail.GetItemString(li_find, "user_field1"))
					
				End IF
				
			End IF
		Next	
	End IF 
	
	
Else /*client*/
	
	For llArrayPos = 1 to llArrayCount
		llNewRow = dw_exception.insertRow(0)
	
	
 	 	//GAP 12-02 add code below to extract the datawindow values from each structure
		lsData = Trim (Istrparms.String_arg[llArrayPos])
		lipos = pos(lsData,'|')
		lsTemp = Left(lsData,(lipos - 1))
		dw_exception.SetItem(llNewRow,"sku",lsTemp)
		lsData = Replace(lsData, 1, lipos, ' ')
		lipos = pos(lsData,'|')
		lsTemp = Left(lsData,(lipos - 1))
		dw_exception.SetItem(llNewRow,"requested_qty",dec(lsTemp))
		lsData = Replace(lsData, 1, lipos, ' ')
		dw_exception.SetItem(llNewRow,"available_qty",dec(lsData))

	Next
	
	
End If

//Hide any of the unused lottable fields

If dw_exception.Find(" inv_type > ''",1,dw_exception.RowCOunt()) > 0 Then
	dw_exception.Modify("inv_Type.width=400 inv_Type_t.width=400")
Else /*Hide*/
	dw_exception.Modify("inv_Type.width=0 inv_Type_t.width=0")
End If

If dw_exception.Find("lot_no > ''",1,dw_exception.RowCOunt()) > 0 Then
	dw_exception.Modify("lot_no.width=261 lot_no_t.width=261")
Else /*Hide*/
	dw_exception.Modify("lot_no.width=0 lot_no_t.width=0")
End If

If dw_exception.Find("po_no > ''",1,dw_exception.RowCOunt()) > 0 Then
	dw_exception.Modify("po_no.width=261 po_no_t.width=261")
Else /*Hide*/
	dw_exception.Modify("po_no.width=0 po_no_t.width=0")
End If

If dw_exception.Find("po_no2 > ''",1,dw_exception.RowCOunt()) > 0 Then
	dw_exception.Modify("po_no2.width=261 po_no2_t.width=261")
Else /*Hide*/
	dw_exception.Modify("po_no2.width=0 po_no2_t.width=0")
End If

IF gs_project = "NIKE-SG" OR gs_project = "NIKE-MY" THEN
	dw_exception.Modify("user_field1.visible=1")
End If

dw_exception.SetRedraw(True)
SetPointer(Arrow!)
end event

on w_pick_exception.create
this.cb_clear=create cb_clear
this.cb_reserve=create cb_reserve
this.st_1=create st_1
this.cb_print=create cb_print
this.cb_ok=create cb_ok
this.dw_exception=create dw_exception
this.Control[]={this.cb_clear,&
this.cb_reserve,&
this.st_1,&
this.cb_print,&
this.cb_ok,&
this.dw_exception}
end on

on w_pick_exception.destroy
destroy(this.cb_clear)
destroy(this.cb_reserve)
destroy(this.st_1)
destroy(this.cb_print)
destroy(this.cb_ok)
destroy(this.dw_exception)
end on

event open;string ls_syntax, ls_rc
int    li_rc
Integer			li_ScreenH, li_ScreenW
Environment	le_Env

istrparms = message.PowerObjectParm

// Center window
GetEnvironment(le_Env)

li_ScreenH = PixelsToUnits(le_Env.ScreenHeight, YPixelsToUnits!)
li_ScreenW = PixelsToUnits(le_Env.ScreenWidth, XPixelsToUnits!)

This.Y = (li_ScreenH - This.Height) / 2
This.X = (li_ScreenW - This.Width) / 2

This.PostEvent("ue_postopen")


If gs_project = 'GM_MI_DAT' and isvalid(w_workorder) Then
	cb_reserve.visible = True
	cb_Clear.visible = True
Else
	cb_reserve.visible = False
	cb_Clear.visible = False
End IF






end event

event closequery;Str_parms	lStrParms

//03/06 - PCONKL - For any rows that are 'reserved', we will send back a parm
Long	llrowPos, llRowCount, llArrayPos

llArrayPos = 0
llRowCount= dw_exception.RowCount()
For llRowPos = 1 to llRowCount
	if dw_exception.GetITemString(llRowPOs,'hold_ind') = 'Y' Then
		llArrayPos ++
		lstrparms.String_arg[llArrayPos] = dw_exception.GetITEmString(llRowPos,'sku')
	End If
Next

Message.PowerObjectParm = lstrparms

end event

type cb_clear from commandbutton within w_pick_exception
boolean visible = false
integer x = 2382
integer y = 1352
integer width = 389
integer height = 84
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Clear All"
end type

event clicked;Long llRowCount, llRowPos

llRowCount = dw_exception.RowCount()
For llRowPos = 1 to lLRowCount
	dw_exception.SetItem(llRowPos,'hold_ind','N')
Next
end event

type cb_reserve from commandbutton within w_pick_exception
boolean visible = false
integer x = 2382
integer y = 1252
integer width = 389
integer height = 84
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Reserve All"
end type

event clicked;
Long llRowCount, llRowPos

llRowCount = dw_exception.RowCount()
For llRowPos = 1 to lLRowCount
	If dw_exception.GetITemNUmber(llRowPOs,'available_qty') > 0 Then
		dw_exception.SetItem(llRowPos,'hold_ind','Y')
	End If
Next
end event

type st_1 from statictext within w_pick_exception
integer x = 5
integer y = 12
integer width = 1522
integer height = 76
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Pick exceptions exist for the following SKU~'s:"
boolean focusrectangle = false
end type

type cb_print from commandbutton within w_pick_exception
integer x = 1321
integer y = 1296
integer width = 247
integer height = 108
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Print"
end type

event clicked;OpenWithParm(w_dw_print_options,dw_exception) 
end event

type cb_ok from commandbutton within w_pick_exception
integer x = 955
integer y = 1296
integer width = 247
integer height = 108
integer taborder = 20
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "OK"
boolean default = true
end type

event clicked;Close(Parent)
end event

type dw_exception from datawindow within w_pick_exception
integer x = 18
integer y = 104
integer width = 2976
integer height = 1124
integer taborder = 10
string dataobject = "d_picking_exception"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event constructor;
//Hold ind only used by GM in conjunction with WO's
If gs_Project <> 'GM_MI_DAT' or not isvalid(w_Workorder) Then
	This.modify("Hold_ind.visible=0")
End IF
end event

