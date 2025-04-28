$PBExportHeader$w_box_no_add_delete.srw
$PBExportComments$*
forward
global type w_box_no_add_delete from window
end type
type st_oneswap from statictext within w_box_no_add_delete
end type
type st_total_picked from statictext within w_box_no_add_delete
end type
type st_9 from statictext within w_box_no_add_delete
end type
type st_picked from statictext within w_box_no_add_delete
end type
type st_8 from statictext within w_box_no_add_delete
end type
type cb_cancel from commandbutton within w_box_no_add_delete
end type
type cb_ok from commandbutton within w_box_no_add_delete
end type
type dw_1 from u_dw_ancestor within w_box_no_add_delete
end type
type sle_qty_recd from statictext within w_box_no_add_delete
end type
type st_7 from statictext within w_box_no_add_delete
end type
type st_difference from statictext within w_box_no_add_delete
end type
type sle_owner from singlelineedit within w_box_no_add_delete
end type
type st_owner from statictext within w_box_no_add_delete
end type
type sle_pono from singlelineedit within w_box_no_add_delete
end type
type st_3 from statictext within w_box_no_add_delete
end type
type st_supplier from statictext within w_box_no_add_delete
end type
type st_6 from statictext within w_box_no_add_delete
end type
type st_5 from statictext within w_box_no_add_delete
end type
type sle_sku from singlelineedit within w_box_no_add_delete
end type
type st_4 from statictext within w_box_no_add_delete
end type
type cb_clear from commandbutton within w_box_no_add_delete
end type
type cb_delete from commandbutton within w_box_no_add_delete
end type
type st_2 from statictext within w_box_no_add_delete
end type
type st_totrows from statictext within w_box_no_add_delete
end type
type st_1 from statictext within w_box_no_add_delete
end type
type sle_boxno from singlelineedit within w_box_no_add_delete
end type
end forward

global type w_box_no_add_delete from window
integer width = 2190
integer height = 2620
boolean titlebar = true
string title = "Box ID Number Entry Screen"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
boolean clientedge = true
event ue_open ( )
event ue_postopen ( )
event ue_get_totals ( )
st_oneswap st_oneswap
st_total_picked st_total_picked
st_9 st_9
st_picked st_picked
st_8 st_8
cb_cancel cb_cancel
cb_ok cb_ok
dw_1 dw_1
sle_qty_recd sle_qty_recd
st_7 st_7
st_difference st_difference
sle_owner sle_owner
st_owner st_owner
sle_pono sle_pono
st_3 st_3
st_supplier st_supplier
st_6 st_6
st_5 st_5
sle_sku sle_sku
st_4 st_4
cb_clear cb_clear
cb_delete cb_delete
st_2 st_2
st_totrows st_totrows
st_1 st_1
sle_boxno sle_boxno
end type
global w_box_no_add_delete w_box_no_add_delete

type variables
public str_parms istrparms
window iwCurrent
boolean ib_value

String is_ProjectId
String is_UserLineItemNo
String is_PoNo
string is_sku
String is_WhCode
String is_LCode
String is_DoNo
String is_OwnerCd
long il_main_currow
long il_EdiBatchSeqNo
Long il_LineItemNo
Long il_OwnerId
Long il_BoxRow
Long il_SingleBoxIdSwap
String is_ContainerId //This is only used when the user is replacing one container ID
DataWindow ids_PickingWindow

// TAM -2018/11/02 - DE6948	added PONO2(Pallet Id)
String is_PoNo2

//06/2017 :TAM PEVS-605 - START
Boolean ibMouseClicked =FALSE
Boolean ibStartTimer =FALSE 
Boolean ibModified= FALSE
String is_ContainerIdScan

end variables

forward prototypes
public subroutine wf_window_center ()
public function integer uf_getboxtotals ()
public function integer uf_getpicktotals ()
end prototypes

event ue_open();long i,ll_tot_rows, llNumOfChars,ll_row,ll_rowCount,ll_Qty, ll_SkuCount, llPickRow
decimal ld_cur,ld_tot 
String ls_l_code,ls_inventory_type,ls_lot_no,ls_ro_no, lsType

This.sle_boxno.setfocus( )
dw_1.SettransObject(SQLCA)
istrparms = message.PowerobjectParm
iwCurrent = This

str_parms lstrparms

is_ProjectId = istrparms.string_arg[1]
is_WhCode = istrparms.string_arg[2]
is_Sku = istrparms.string_arg[3]
is_PoNo = istrparms.string_arg[4]
is_LCode = istrparms.string_arg[5]
is_DoNo = istrparms.string_arg[6]
is_OwnerCd = istrparms.string_arg[7]
is_ContainerId = istrparms.string_arg[8]
//TAM 2017/06 - PEVS-605
is_ContainerIdScan = istrparms.string_arg[9]
// TAM -2018/11/02 - DE6948	added PONO2(Pallet Id)
is_PoNo2 =	istrparms.String_arg[10] 

il_LineItemNo = istrparms.Long_arg[1]
il_EDIBatchSeqNo = istrparms.Long_arg[2]
il_OwnerId = istrparms.Long_arg[3]
il_SingleBoxIdSwap = istrparms.Long_arg[4]
llPickRow = istrparms.Long_arg[5]

ids_PickingWindow = istrparms.datawindow_arg[1]
istrparms.datastore_arg[2].Sharedata(dw_1)

sle_sku.text =is_Sku
st_supplier.text = is_ProjectId
sle_PoNo.text = is_PoNo
sle_owner.text = is_OwnerCd
ll_Qty = 0

If il_SingleBoxIdSwap = 0 then
	This.st_oneSwap.visible = false
	ll_rowCount =ids_PickingWindow.RowCount() 
	ids_PickingWindow.SetFilter("sku = '" + is_Sku + "'")
Else
	This.st_oneSwap.visible = True
	ll_rowCount = 1
	ids_PickingWindow.SetFilter("sku = '" + is_Sku + "'" + " and Line_Item_no = " + String(il_LineItemNo) + " and container_id = '" + is_ContainerID + "'")

End if

//ids_PickingWindow.SetFilter("sku = '" + is_Sku + "'")
ids_PickingWindow.Filter()

IF ids_PickingWindow.RowCount() > 0 THEN
	FOR ll_row = 1 TO ids_PickingWindow.RowCount() 
		If ids_pickingWindow.GetItemString(ll_row,'container_id_scanned_ind') = "N" Then
			ll_SkuCount = ll_SkuCount +1
			ll_Qty = ll_Qty + ids_PickingWindow.GetItemNumber(ll_row,'quantity')
		End If
	Next
End if

ids_PickingWindow.SetFilter("")
ids_PickingWindow.Filter()

sle_qty_recd.text = string(ll_Qty )
st_Picked.text = String(ll_SkuCount)

This.event ue_get_totals( )	

st_totrows.text= string(dw_1.Rowcount())	
ids_PickingWindow.ScrollToRow( llPickRow )


end event

event ue_get_totals();

st_Difference.text=string(uf_GetBoxTotals()) 




end event

public subroutine wf_window_center ();long li_ScreenH,li_ScreenW
Environment le_Env
GetEnvironment(le_Env)

li_ScreenH = PixelsToUnits(le_Env.ScreenHeight, YPixelsToUnits!)
li_ScreenW = PixelsToUnits(le_Env.ScreenWidth, XPixelsToUnits!)

this.Y = (li_ScreenH - this.Height) / 2
this.X = (li_ScreenW - this.Width) / 2

end subroutine

public function integer uf_getboxtotals ();
Long ll_Total, ll_TotalNeeded,ll_Diff, ll_Picked
Long ll_PickTotal, ll_PickDiff
dw_1.accepttext( )

//ll_Picked = Long(st_picked.text)

ll_TotalNeeded = Long(sle_qty_recd.text )
ll_Total = dw_1.getItemnumber ( 1 , "Total_Qty" )

//ll_PickTotal = dw_1.rowcount( )


ll_Diff  = ll_Total - ll_TotalNeeded 
st_totrows.text=string(ll_Total) 
ll_PickDiff = uf_getpicktotals()
//st_Difference.text=string(ll_Diff) 
Return ll_Diff
end function

public function integer uf_getpicktotals ();
Long ll_Picked
Long ll_PickTotal, ll_PickDiff
//dw_1.accepttext( )

ll_Picked = Long(st_picked.text)

ll_PickTotal = dw_1.rowcount( )

st_total_Picked.text = String(ll_PickTotal)

ll_PickDiff  = ll_Picked - ll_PickTotal 
//st_total_picked.text=string(ll_PickTotal) 
//st_Difference.text=string(ll_Diff) 
Return ll_PickDiff
end function

on w_box_no_add_delete.create
this.st_oneswap=create st_oneswap
this.st_total_picked=create st_total_picked
this.st_9=create st_9
this.st_picked=create st_picked
this.st_8=create st_8
this.cb_cancel=create cb_cancel
this.cb_ok=create cb_ok
this.dw_1=create dw_1
this.sle_qty_recd=create sle_qty_recd
this.st_7=create st_7
this.st_difference=create st_difference
this.sle_owner=create sle_owner
this.st_owner=create st_owner
this.sle_pono=create sle_pono
this.st_3=create st_3
this.st_supplier=create st_supplier
this.st_6=create st_6
this.st_5=create st_5
this.sle_sku=create sle_sku
this.st_4=create st_4
this.cb_clear=create cb_clear
this.cb_delete=create cb_delete
this.st_2=create st_2
this.st_totrows=create st_totrows
this.st_1=create st_1
this.sle_boxno=create sle_boxno
this.Control[]={this.st_oneswap,&
this.st_total_picked,&
this.st_9,&
this.st_picked,&
this.st_8,&
this.cb_cancel,&
this.cb_ok,&
this.dw_1,&
this.sle_qty_recd,&
this.st_7,&
this.st_difference,&
this.sle_owner,&
this.st_owner,&
this.sle_pono,&
this.st_3,&
this.st_supplier,&
this.st_6,&
this.st_5,&
this.sle_sku,&
this.st_4,&
this.cb_clear,&
this.cb_delete,&
this.st_2,&
this.st_totrows,&
this.st_1,&
this.sle_boxno}
end on

on w_box_no_add_delete.destroy
destroy(this.st_oneswap)
destroy(this.st_total_picked)
destroy(this.st_9)
destroy(this.st_picked)
destroy(this.st_8)
destroy(this.cb_cancel)
destroy(this.cb_ok)
destroy(this.dw_1)
destroy(this.sle_qty_recd)
destroy(this.st_7)
destroy(this.st_difference)
destroy(this.sle_owner)
destroy(this.st_owner)
destroy(this.sle_pono)
destroy(this.st_3)
destroy(this.st_supplier)
destroy(this.st_6)
destroy(this.st_5)
destroy(this.sle_sku)
destroy(this.st_4)
destroy(this.cb_clear)
destroy(this.cb_delete)
destroy(this.st_2)
destroy(this.st_totrows)
destroy(this.st_1)
destroy(this.sle_boxno)
end on

event open;wf_window_center()
//i_nwarehouse = Create n_warehouse


	Post event ue_open()



end event

event close;//Destroy n_warehouse
ClosewithReturn(this,istrparms)
end event

event resize;call super::resize;//dw_1.Resize(workspacewidth() - 580,workspaceHeight()-780 )
end event

event timer;//10-Apr-2017 :Madhu PEVS-424 - Stock Transfer Serial No
timer(0) 
ibModified =TRUE
MessageBox("Manual Entry", "Sorry! Manual Entry Option is Disabled!. ~r~r~nYou should have F10 access for Manual Entry", Stopsign!)
sle_boxno.text=''
end event

type st_oneswap from statictext within w_box_no_add_delete
integer x = 50
integer y = 412
integer width = 1362
integer height = 92
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 255
long backcolor = 67108864
string text = "You can only swap 1 Box ID"
boolean border = true
boolean focusrectangle = false
end type

type st_total_picked from statictext within w_box_no_add_delete
integer x = 1349
integer y = 2260
integer width = 293
integer height = 76
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
alignment alignment = right!
boolean border = true
boolean focusrectangle = false
end type

type st_9 from statictext within w_box_no_add_delete
integer x = 750
integer y = 2260
integer width = 590
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
string text = "Total Boxes Picked:"
boolean focusrectangle = false
end type

type st_picked from statictext within w_box_no_add_delete
integer x = 1623
integer y = 44
integer width = 293
integer height = 76
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
alignment alignment = right!
boolean border = true
boolean focusrectangle = false
end type

type st_8 from statictext within w_box_no_add_delete
integer x = 1134
integer y = 44
integer width = 425
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
string text = "Boxes to Pick:"
boolean focusrectangle = false
end type

type cb_cancel from commandbutton within w_box_no_add_delete
integer x = 1719
integer y = 2388
integer width = 402
integer height = 112
integer taborder = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Cancel"
end type

event cb_cancel::clicked;dw_1.reset( )
w_box_no_add_delete.triggerevent(Close!)
end event

type cb_ok from commandbutton within w_box_no_add_delete
integer x = 1321
integer y = 2388
integer width = 402
integer height = 112
integer taborder = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "OK"
end type

event clicked;//GailM 09/26/2017 SIMSPEVS-849/605 Should be soft stop 
long ll_status
String lsMsg

If uf_GetPickTotals() = 0 then
	If uf_GetBoxTotals() = 0 then
		Parent.event close( )
	else
		MessageBox('Pick Diff error ','The difference between Qty Picked and Qty Entered must be zero .')
		Return
	end if
Else
	lsMsg = "GPN " + is_sku + " has not been fully validated.  Please save~nthe picking list and return later to complete validation.~n~r~n~r          Are you sure you want to leave?"
	ll_status = MessageBox('Pick Difference Error', lsMsg, Question!, YesNo!)
//	ll_status = MessageBox('Pick Diff error','Qty Picked does not match Qty Entered.~n~r     Validations will not be complete.~n~r~n~r       Are you sure you want to leave?',Question!, YesNo!)
	IF ll_status = 1 THEN 		//Leave without saving  (Can still save pick list and container id scanned indicators
		Parent.event close( )
	Else
		Return
	End If
			
	
End if


end event

type dw_1 from u_dw_ancestor within w_box_no_add_delete
integer x = 37
integer y = 620
integer width = 1760
integer height = 1616
integer taborder = 80
string dataobject = "d_pandora_box_id"
end type

event itemchanged;call super::itemchanged;Long ll_AvailQty, ll_NewQty
ll_AvailQty = this.GetItemNumber(row,'qty_found')
Choose case dwo.name
case 'qty'
	ll_NewQty = Long(data)
	If ll_NewQty > ll_AvailQty Then
		Messagebox('Qty Error','There is not enough available qty for this box is.  Currently the is ' + String(ll_AvailQty) + ' available.')
		Return 0
	End if
	If ll_NewQty < 20 then
		If ll_NewQty <> ll_AvailQty Then
			Messagebox('Qty Error','If you are changing quantity to be less than 20 it must match what is avaliable for that box.  Currently the is ' + String(ll_AvailQty) + ' available.')
			Return 0
		End if
	End IF
End Choose
Parent.triggerevent( 'ue_get_totals')
end event

event clicked;call super::clicked;//IF row > 0 THEN
//	THIS.SelectRow(0, FALSE)
//	THIS.SelectRow(row, TRUE)
//END IF
il_BoxRow = Row
end event

type sle_qty_recd from statictext within w_box_no_add_delete
integer x = 1623
integer y = 112
integer width = 293
integer height = 76
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
alignment alignment = right!
boolean border = true
boolean focusrectangle = false
end type

type st_7 from statictext within w_box_no_add_delete
integer x = 1134
integer y = 256
integer width = 416
integer height = 76
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 79741120
boolean enabled = false
string text = "Difference:"
boolean focusrectangle = false
end type

type st_difference from statictext within w_box_no_add_delete
integer x = 1623
integer y = 256
integer width = 293
integer height = 76
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
boolean enabled = false
alignment alignment = right!
boolean border = true
boolean focusrectangle = false
end type

type sle_owner from singlelineedit within w_box_no_add_delete
integer x = 357
integer y = 324
integer width = 722
integer height = 64
integer taborder = 60
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
boolean border = false
boolean autohscroll = false
boolean displayonly = true
end type

event modified;
String lsSku
Long llRowCount, i
llRowCount = ids_PickingWindow.Rowcount( )

For i=1 to llRowCount
	lsSku = ids_PickingWindow.GetitemString( i, 'Sku')
	If lsSku <> '' then
	Exit
	End if
Next


//IF sle_sku.text = is_sku_text THEN
//	sle_boxno.Enabled = TRUE
//	sle_boxno.SetFocus()
//ELSE
//	MessageBox('','Scanned SKU does not match SKU on order.',StopSign!)
//	sle_sku.SelectText(1, Len(sle_sku.Text))
//	sle_sku.SetFocus()
//END IF
end event

type st_owner from statictext within w_box_no_add_delete
integer x = 73
integer y = 332
integer width = 279
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Owner:"
boolean focusrectangle = false
end type

type sle_pono from singlelineedit within w_box_no_add_delete
integer x = 357
integer y = 228
integer width = 722
integer height = 64
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
boolean border = false
boolean autohscroll = false
boolean displayonly = true
end type

event modified;
String lsSku
Long llRowCount, i
llRowCount = ids_PickingWindow.Rowcount( )

For i=1 to llRowCount
	lsSku = ids_PickingWindow.GetitemString( i, 'Sku')
	If lsSku <> '' then
	Exit
	End if
Next


//IF sle_sku.text = is_sku_text THEN
//	sle_boxno.Enabled = TRUE
//	sle_boxno.SetFocus()
//ELSE
//	MessageBox('','Scanned SKU does not match SKU on order.',StopSign!)
//	sle_sku.SelectText(1, Len(sle_sku.Text))
//	sle_sku.SetFocus()
//END IF
end event

type st_3 from statictext within w_box_no_add_delete
integer x = 50
integer y = 228
integer width = 279
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Project:"
boolean focusrectangle = false
end type

type st_supplier from statictext within w_box_no_add_delete
integer x = 357
integer y = 36
integer width = 722
integer height = 76
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
boolean focusrectangle = false
end type

type st_6 from statictext within w_box_no_add_delete
integer x = 50
integer y = 36
integer width = 279
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
string text = "Supplier:"
boolean focusrectangle = false
end type

type st_5 from statictext within w_box_no_add_delete
integer x = 50
integer y = 156
integer width = 279
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "SKU:"
boolean focusrectangle = false
end type

type sle_sku from singlelineedit within w_box_no_add_delete
integer x = 357
integer y = 156
integer width = 722
integer height = 64
integer taborder = 10
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
boolean border = false
boolean autohscroll = false
boolean displayonly = true
end type

event modified;
String lsSku
Long llRowCount, i
llRowCount = ids_PickingWindow.Rowcount( )

For i=1 to llRowCount
	lsSku = ids_PickingWindow.GetitemString( i, 'Sku')
	If lsSku <> '' then
	Exit
	End if
Next


//IF sle_sku.text = is_sku_text THEN
//	sle_boxno.Enabled = TRUE
//	sle_boxno.SetFocus()
//ELSE
//	MessageBox('','Scanned SKU does not match SKU on order.',StopSign!)
//	sle_sku.SelectText(1, Len(sle_sku.Text))
//	sle_sku.SetFocus()
//END IF
end event

type st_4 from statictext within w_box_no_add_delete
integer x = 1134
integer y = 112
integer width = 416
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
string text = "Qty Picked:"
boolean focusrectangle = false
end type

type cb_clear from commandbutton within w_box_no_add_delete
integer x = 1829
integer y = 756
integer width = 279
integer height = 108
integer taborder = 70
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Clear All"
end type

event clicked;//Clear the entire data after giving warning
long ll_status
ll_status = Messagebox("Serial Numbers", "Are you sure you want to~CLEAR all entered Box's?",Question! ,YesNO!)
IF ll_status = 1 THEN //clears the data
	dw_1.RowsDiscard(1, dw_1.RowCount(), Primary!)
	st_totrows.text=string(dw_1.rowcount())
END IF
Parent.triggerevent( 'ue_get_totals')	
end event

type cb_delete from commandbutton within w_box_no_add_delete
integer x = 1829
integer y = 652
integer width = 279
integer height = 108
integer taborder = 60
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Delete"
end type

event clicked;//Delete the rows & calculate total rows again
Long llRow
llRow = il_BoxRow

dw_1.DeleteRow ( llRow)

st_totrows.text=string(long(st_totrows.text) - 20) 
istrparms.long_arg[2] = dw_1.rowcount() 
Parent.triggerevent( 'ue_get_totals')
end event

type st_2 from statictext within w_box_no_add_delete
integer x = 1134
integer y = 188
integer width = 416
integer height = 76
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 79741120
boolean enabled = false
string text = "Qty Entered:"
boolean focusrectangle = false
end type

type st_totrows from statictext within w_box_no_add_delete
integer x = 1623
integer y = 188
integer width = 293
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
alignment alignment = right!
boolean border = true
boolean focusrectangle = false
end type

type st_1 from statictext within w_box_no_add_delete
integer x = 32
integer y = 512
integer width = 407
integer height = 84
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 79741120
boolean enabled = false
string text = "Box Number:"
boolean focusrectangle = false
end type

type sle_boxno from singlelineedit within w_box_no_add_delete
event ue_keydown pbm_keydown
event ue_mouseclick pbm_rbuttondown
integer x = 471
integer y = 512
integer width = 1056
integer height = 92
integer taborder = 40
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
end type

event ue_keydown;//10-Apr-2017 :Madhu PEVS-424 - Stock Transfer Serial No

If gbPressKeyContainerScan ='Y'  THEN
	
	//user access role
	CHOOSE CASE gs_role
		CASE '1','2'
		
		//If User doesn't have F10 access - Don't allow Manual entry
		IF Upper(gs_project)='PANDORA' and f_retrieve_parm('PANDORA', 'F10_AUTHORIZE', gs_userid,'USER_UPDATEABLE_IND')  <> 'Y' THEN
		
			//start timer, if not already started
			If ibStartTimer =FALSE THEN
				timer(0.3)
			else
				ibStartTimer =TRUE
			End If
		
			//capture Key's
			CHOOSE CASE key
				CASE KeyEnter!
					timer(0)
					ibStartTimer =FALSE //don't start timer
				
				CASE KeyControl!, KeyInsert! //copy+paste is not Allowed and don't use KeyShift!
					timer(0)
					MessageBox("Manual Entry", "Sorry! Manual Entry Option is Disabled!. ~r~r~nYou should have F10 access for Manual Entry", Stopsign!)
					sle_boxno.text=''
					ibStartTimer = FALSE //don't start timer
			END CHOOSE
			
		ELSE
			//reset all values
			ibStartTimer =TRUE
			ibMouseClicked =TRUE
			ibModified =FALSE
		END IF
	END CHOOSE

END IF
end event

event ue_mouseclick;//10-Apr-2017 :Madhu PEVS-424 - Stock Transfer Serial No
If gbPressKeyContainerScan ='Y' THEN
	CHOOSE CASE gs_role
		CASE '1','2'
			IF Upper(gs_project)='PANDORA'  and f_retrieve_parm('PANDORA', 'F10_AUTHORIZE', gs_userid, 'USER_UPDATEABLE_IND')  <> 'Y' THEN
				ibMouseClicked =FALSE
				MessageBox("Mouse Click","Sorry! Right Mouse Click (RMC) Option is Disabled!. ~r~r~nYou should have F10 access to do RMC", Stopsign!)
			ELSE 
				ibMouseClicked =TRUE
			END IF
	END CHOOSE
END IF

return 0
end event

event modified;long ll_row
long cur_line_item_num, row_num, row_num_main 
long ll_component_no , ll_LineNo, ll_Avail_Qty, ll_Allocated, ll_CurrentQty
String lsFind, lsSerial
String lsFind_main 
String ls_Component_ind  
String ls_Loc, ls_Sku, ls_Owner
String ls_Found, ls_FoundOrder, ls_FoundOnProject
Long llFound,llFindRow,ll_Current
String lsContainer, ls_LotNo, ls_Coo,ls_FoundOwnerCd, ls_FoundSku
String ls_PoNo2 //TAM - 2018/11/02 - DE6948
//TimA 04/15/2011 capture the error message in of_error_on_serial_no_exists to help with possible locking in SIMS
//Pandora
String ab_error_message_title, ab_error_message
String ls_project_id
datastore lds_GetBoxId
//g.sndPlaySoundA('boing_x.wav',1)
If uf_GetBoxTotals() >= 0 then
	MessageBox('Difference is 0 ','You cannot add anymore boxes.  The difference between Qty Picked and Qty Entered is zero.')
	this.text = ''
	Return
End if

If not isvalid(lds_GetBoxId) Then
	lds_GetBoxId = Create DataStore
	lds_GetBoxId.dataobject = 'd_get_box_id'
	lds_GetBoxId.SetTransObject(SQLCA)
End If


lsContainer = Nz(this.text,'')
//First look to see if they have scanned the container ID
lsFind =  " Container_Id = '" + lsContainer + "'"
llFound = dw_1.Find(lsFind,1,dw_1.RowCount())
If llFound > 0 then
	g.sndPlaySoundA('boing_x.wav',1)
	Messagebox('Error: Already scanned','This container has been scanned in your list already.   ~r' + lsContainer )
	This.text = ''
	Return
End if
lsFind = ''
llFound = 0
//Look to see if this container is on the original picking order
lsFind =  " Upper(Sku) = '" + Upper(is_sku) + "' and Container_Id = '" + lsContainer + "'"
llFound = ids_PickingWindow.Find(lsFind,1,ids_PickingWindow.RowCount())
If llFound > 0 then
	ids_PickingWindow.scrolltorow( llFound )
	ls_Sku = ids_PickingWindow.GetitemString(llFound, 'SKU')
	ll_LineNo = ids_PickingWindow.GetitemNumber(llFound, 'Line_Item_No')
	ll_CurrentQty= ids_PickingWindow.GetitemNumber(llFound, 'quantity')
	ll_Current = 1
End if

If llFound = 0 Then
	ll_Current = 0
	//TimA 01/30/15
	//The DW d_get_box_id is based on a stored procedure.  That stored procedure calls a user defind function in SQL server called SIMSVerifyBoxId.
	//We have to do it this way because Powerbuilder does not allow user defined functions at least in the version of 11.5
	llFound = lds_GetBoxId.retrieve(is_ProjectId, is_DoNo,is_WhCode, is_sku, il_OwnerId, is_PoNo, lsContainer )
	If llFound > 0 Then
		ll_Avail_Qty = lds_GetBoxId.GetItemNumber(llFound,'avail_qty' )
		ll_Allocated = lds_GetBoxId.GetItemNumber(llFound,'Allocated' )
		ls_Loc = lds_GetBoxId.GetItemString(llFound,'l_code' )
		ls_FoundOrder = Nz(lds_GetBoxId.GetItemString(llFound,'Found_Invoice_No' ),'')
		ls_FoundOnProject = Nz(lds_GetBoxId.GetItemString(llFound,'po_no' ),'')
		ls_Coo = lds_GetBoxId.GetItemString(llFound,'country_of_origin' )
		ls_LotNo= lds_GetBoxId.GetItemString(llFound,'lot_no' )
		ls_FoundOwnerCd= lds_GetBoxId.GetItemString(llFound,'Found_Owner_Cd' )
		ls_FoundSku= lds_GetBoxId.GetItemString(llFound,'Found_Sku' )
		ls_PoNo2= lds_GetBoxId.GetItemString(llFound,'po_no2' )  //TAM - 2018/11/02 - DE6948
		
		Choose case ll_Allocated
			Case 0
				//Good Box ID nothing to do here.

			Case 1
				//Aready allocated on another order.
				If  ll_Avail_Qty = 0 then
					g.sndPlaySoundA('boing_x.wav',1)
					Messagebox('Error: Already on an order','This container is already allocated on order.   ~r' + ls_FoundOrder )
					This.text = ''
					Return
				End if
			Case 2
				//Wrong project
				g.sndPlaySoundA('boing_x.wav',1)
				Messagebox('Error: On different project','This container is not on project.  ' + is_PoNo + ' ~r~r' + 'It is on project ' + ls_FoundOnProject )
				This.text = ''
				Return				
			Case 3
				//On a Cycle Count
				g.sndPlaySoundA('boing_x.wav',1)
				Messagebox('Error: On Cycle Count','This container is currently on an open cycle count. '  )
				This.text = ''
				Return
			Case 4
				//Wrong Owner
				g.sndPlaySoundA('boing_x.wav',1)
				Messagebox('Error: Different Owner','The original picking record has owner.  ' + is_OwnerCd + ' ~r~r' + 'This container has an owner of   ' + ls_FoundOwnerCd )
				This.text = ''
				Return				
			Case 5
				//Wrong Sku
				g.sndPlaySoundA('boing_x.wav',1)
				Messagebox('Error: Different Sku','You are searching for container ID on Sku :  ' + RightTrim(is_Sku) + ' ~r~r' + 'This container is on Sku: ' + ls_FoundSku )
				This.text = ''
				Return
			Case Else
				//Not found
				g.sndPlaySoundA('boing_x.wav',1)
				MessageBox('Error','Box ID not found')
				This.text = ''
				Return				
		End Choose
	End If
End if

IF upper(gs_project) = 'PANDORA' THEN
	If llFound > 0 then

		ll_row = dw_1.InsertRow(ll_row + 1)
		dw_1.ScrollToRow(ll_row)
		dw_1.setitem(ll_row,'container_id',lsContainer)
		If ll_Avail_Qty < 20 then
			//Found a box that is less than 20. 
			dw_1.setitem(ll_row,'qty',ll_Avail_Qty) 
		Else
			dw_1.setitem(ll_row,'qty',20) //Default value
		End if
		dw_1.setitem(ll_row,'qty_found',ll_Avail_Qty ) 		
//TAM 06/2017 PEVS-605 - If Container Scanned then Set the Indicator to 'Y'
		dw_1.setitem(ll_row,'Container_ID_Scanned_Ind','Y' )
		If ll_Current = 1 then
			dw_1.setitem(ll_row,'sku',ls_sku )
			dw_1.setitem(ll_row,'line_item_no',ll_LineNo )
			dw_1.setitem(ll_row,'qty_found',ll_CurrentQty ) 		
			dw_1.setitem(ll_row,'qty',ll_CurrentQty ) 		
			dw_1.setitem(ll_row,'current_record','1' )

		Else
			dw_1.setitem(ll_row,'sku',is_sku )
			dw_1.setitem(ll_row,'l_code',ls_Loc )
			dw_1.setitem(ll_row,'Owner_id',il_OwnerId )
			dw_1.setitem(ll_row,'country_of_origin',ls_Coo )
			dw_1.setitem(ll_row,'lot_no',ls_LotNo )
			dw_1.setitem(ll_row,'current_record','0')
			dw_1.setitem(ll_row,'po_no2',ls_pono2 ) //TAM - 2018/11/02 - DE6948
		End if
		This.Text = ''
Else
	g.sndPlaySoundA('boing_x.wav',1)
	MessageBox('Error','Box ID not found')
	This.text = ''
	Return
end if
ll_Current = 0
End if

Parent.triggerevent( 'ue_get_totals')

end event

event getfocus;
if len(this.text) > 0 then this.selecttext( 0, len(this.text) )

end event

type tab_main from w_std_master_detail`tab_main within w_box_no_add_delete
boolean visible = false
end type

type tabpage_main from w_std_master_detail`tabpage_main within tab_main
end type

type tabpage_search from w_std_master_detail`tabpage_search within tab_main
end type

