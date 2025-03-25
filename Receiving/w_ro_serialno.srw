HA$PBExportHeader$w_ro_serialno.srw
$PBExportComments$*
forward
global type w_ro_serialno from window
end type
type st_7 from statictext within w_ro_serialno
end type
type st_3 from statictext within w_ro_serialno
end type
type sle_container from singlelineedit within w_ro_serialno
end type
type sle_pono2 from singlelineedit within w_ro_serialno
end type
type rb_scan_last from radiobutton within w_ro_serialno
end type
type rb_scan_first from radiobutton within w_ro_serialno
end type
type rb_scan_all from radiobutton within w_ro_serialno
end type
type cb_1 from commandbutton within w_ro_serialno
end type
type st_supplier from statictext within w_ro_serialno
end type
type st_6 from statictext within w_ro_serialno
end type
type cb_add from commandbutton within w_ro_serialno
end type
type st_5 from statictext within w_ro_serialno
end type
type sle_sku from singlelineedit within w_ro_serialno
end type
type sle_qty_recd from singlelineedit within w_ro_serialno
end type
type st_4 from statictext within w_ro_serialno
end type
type cb_clear from commandbutton within w_ro_serialno
end type
type cb_delete from commandbutton within w_ro_serialno
end type
type st_2 from statictext within w_ro_serialno
end type
type st_totrows from statictext within w_ro_serialno
end type
type cb_close from commandbutton within w_ro_serialno
end type
type cb_ok from commandbutton within w_ro_serialno
end type
type dw_1 from datawindow within w_ro_serialno
end type
type st_1 from statictext within w_ro_serialno
end type
type sle_srno from singlelineedit within w_ro_serialno
end type
type gb_1 from groupbox within w_ro_serialno
end type
type em_scan_first from editmask within w_ro_serialno
end type
type em_scan_last from editmask within w_ro_serialno
end type
end forward

global type w_ro_serialno from window
integer x = 823
integer y = 362
integer width = 2099
integer height = 2080
boolean titlebar = true
string title = "Serial Number Entry Screen"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 79741120
event ue_open ( )
event ue_postopen ( )
st_7 st_7
st_3 st_3
sle_container sle_container
sle_pono2 sle_pono2
rb_scan_last rb_scan_last
rb_scan_first rb_scan_first
rb_scan_all rb_scan_all
cb_1 cb_1
st_supplier st_supplier
st_6 st_6
cb_add cb_add
st_5 st_5
sle_sku sle_sku
sle_qty_recd sle_qty_recd
st_4 st_4
cb_clear cb_clear
cb_delete cb_delete
st_2 st_2
st_totrows st_totrows
cb_close cb_close
cb_ok cb_ok
dw_1 dw_1
st_1 st_1
sle_srno sle_srno
gb_1 gb_1
em_scan_first em_scan_first
em_scan_last em_scan_last
end type
global w_ro_serialno w_ro_serialno

type variables
public str_parms istrparms
window iwCurrent
boolean ib_value
n_warehouse i_nwarehouse

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 07/14/2010 ujhall: 01 of 05  Validate Serial # Double click  Create instance variable = provide access to out of scope objects
string is_user_line_item_no , is_po_no2, is_container_Id
string is_serialized_ind  , is_po_no2_Ind, is_container_Ind 
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
long il_main_currow, il_putaway_row	//GailM 5/21/2019 What putaway row does the main currow relate to?

string is_sku_text
Boolean ibkeytype =FALSE //17-Aug-2015 :Madhu- Added code to prevent manual scanning
Boolean ibmouseclick =FALSE //17-Aug-2015 :Madhu- Added code to prevent manual scanning
datastore ids_scan_serial //16-Jan-2018 :Madhu S14839 Foot Print
end variables
forward prototypes
public subroutine wf_window_center ()
public function long wf_val_serial_nos (string as_ord_nbr, string as_ord_type, string as_serial_no_entered, long al_edibatch, string as_sku, string as_user_line_item_no, string as_serialized_ind)
end prototypes

event ue_open();long i,ll_tot_rows, llNumOfChars, llLineItemNo
decimal ld_cur,ld_tot //GAP 11/02 convert to decimal
String ls_l_code,ls_inventory_type,ls_lot_no,ls_ro_no, lsType, lsLineItemNo

dw_1.SettransObject(SQLCA)
istrparms = message.PowerobjectParm
iwCurrent = This
str_parms lstrparms

//16-Jan-2018 :Madhu S14839 Foot Prints
is_serialized_ind = istrparms.string_arg[9]
is_po_no2_Ind =istrparms.String_arg[11]  
is_container_Ind =istrparms.String_arg[12]
is_po_no2 =istrparms.String_arg[13]
is_container_Id =istrparms.String_arg[14]
lsLineItemNo = istrparms.String_arg[8]


If upper(gs_project) ='PANDORA' and is_serialized_ind='B' and  is_po_no2_Ind='Y' and is_container_Ind ='Y' Then
	sle_pono2.setfocus( )
	st_3.visible =true
	st_7.visible =true
	sle_pono2.visible=true
	sle_container.visible=true
	dw_1.modify( "po_no2.visible =true  po_no2_t.visible =true")
	dw_1.modify( "container_id.visible =true  container_id_t.visible =true")

else
	sle_srno.setfocus()
	st_3.visible =false
	st_7.visible =false
	sle_pono2.visible=false
	sle_container.visible=false
	dw_1.modify( "po_no2.visible =false  po_no2_t.visible =false")
	dw_1.modify( "container_id.visible =false  container_id_t.visible =false")

End IF

//structure is assigned values from put away windows in serial number command button from w_ro window
sle_sku.text =istrparms.string_arg[1]
sle_qty_recd.text = string(istrparms.Long_arg[1])
st_supplier.text = istrparms.String_arg[7]
ls_l_code =istrparms.String_arg[2]  
ls_inventory_type=istrparms.String_arg[4]
ls_lot_no=istrparms.String_arg[5]
il_main_currow = istrparms.Long_arg[3]  // 12/06/2010 ujh: SNQM; Get the current row doubleclicked on main window
//GailM 5/21/2019 DE10668 Google Putaway Screen issue - Need to know what putaway row to query - main window is serial tab dw
il_putaway_row = w_ro.tab_main.tabpage_putaway.dw_putaway.Find("Line_Item_No = " + lsLineItemNo , 1, w_ro.tab_main.tabpage_putaway.dw_putaway.rowcount())
If il_putaway_row > 0 Then il_main_currow = il_putaway_row

If upper(gs_project) ='PANDORA' Then ids_scan_serial = istrparms.datastore_arg[1] //16-Jan-2018 :Madhu S14839 Foot Print

//ll_tot_rows = dw_1.retrieve(sle_sku.text,ls_l_code,ls_lot_no,ls_inventory_type)//retrieve the rows if already exist

// 12/06/2010 ujh: SNQM; If the SN column doubleclicked is not dash we need to put its value (SN) in the entry window
IF istrparms.String_arg[6]	<> '-' THEN		
	dw_1.insertrow(0)
	dw_1.Setitem(dw_1.Getrow(),'serial_no',istrparms.String_arg[6])  //12/06/2010 ujh: SNQM; 
END IF 

//12/06/2010 ujh: SNQM; Set the rows entered for operational use and for viewing by operator.
st_totrows.text= string(dw_1.Rowcount())	

// 07/14/2010 ujhall: 03 of 05 Validate Serial # Double Click:   Transfering values from out of scope object
is_user_line_item_no = istrparms.string_arg[8] 	

istrparms[]=lstrparms[] //Reset the array 

// 08/09 - PCONKL - See if we have stored the left/right trim scan settings in the .ini file
lsType = ProfileString(gs_iniFile,'SCANNING',upper(gs_project) + '-INBOUNDTYPE','')
llNumOfChars = Long(ProfileString(gs_iniFile,'SCANNING',Upper(gs_project) +'-INBOUNDNUMBEROFCHARS',''))
Choose Case upper(lsType)
	Case 'A' /*All */
		rb_Scan_all.Checked = True
		em_scan_First.Enabled = False
		em_scan_last.Enabled = False
	Case 'F' /*First xxx */
		rb_Scan_first.Checked = True
		If llNumofChars > 0 Then
			em_scan_first.text = String(llNumOfChars)
		End If
		em_scan_First.Enabled = True
		em_scan_last.Enabled = False
	Case 'L' /*All */
		rb_Scan_last.Checked = True
		If llNumofChars > 0 Then
			em_scan_last.text = String(llNumOfChars)
		End If
		em_scan_First.Enabled = False
		em_scan_last.Enabled = True
	Case Else
		rb_Scan_all.Checked = True
		em_scan_First.Enabled = False
		em_scan_last.Enabled = False
End Choose
end event

event ue_postopen();//BCR 11-SEP-2011: NEW event. Cloned from ue_open, and for Franke_TH ONLY.
//Make sle_sku enabled for Franke_TH and disable serial no until a valid sku is scanned.

long i,ll_tot_rows, llNumOfChars
decimal ld_cur,ld_tot 
String ls_l_code,ls_inventory_type,ls_lot_no,ls_ro_no, lsType

str_parms lstrparms

IF Upper(gs_project) = 'FRANKE_TH' THEN 
	sle_sku.enabled = TRUE
	sle_sku.Border = TRUE
	sle_sku.BorderStyle = StyleLowered!
	sle_sku.SetFocus()
	
	IF (IsNull(sle_sku.Text) OR sle_sku.Text = '') THEN
		sle_srno.Enabled = FALSE
	END IF
END IF

dw_1.SettransObject(SQLCA)
istrparms = message.PowerobjectParm
iwCurrent = This

//structure is assigned values from put away windows in serial number command button from w_ro window
//16-Jan-2018 :Madhu S14839 Foot Prints
is_serialized_ind = istrparms.string_arg[9]
is_po_no2_Ind =istrparms.String_arg[11]  
is_container_Ind =istrparms.String_arg[12]
is_po_no2 =istrparms.String_arg[13]
is_container_Id =istrparms.String_arg[14]

If upper(gs_project) ='PANDORA' and is_serialized_ind='B' and  is_po_no2_Ind='Y' and is_container_Ind ='Y' Then
	sle_pono2.setfocus( )
	st_3.visible =true
	st_7.visible =true
	sle_pono2.visible=true
	sle_container.visible=true
	dw_1.modify( "po_no2.visible =true  po_no2_t.visible =true")
	dw_1.modify( "container_id.visible =true  container_id_t.visible =true")
else
	sle_srno.setfocus()
	st_3.visible =false
	st_7.visible =false
	sle_pono2.visible=false
	sle_container.visible=false
	dw_1.modify( "po_no2.visible =false  po_no2_t.visible =false")
	dw_1.modify( "container_id.visible =false  container_id_t.visible =false")
End IF

is_sku_text = istrparms.string_arg[1] //BCR...
sle_qty_recd.text = string(istrparms.Long_arg[1])
st_supplier.text = istrparms.String_arg[7]
ls_l_code =istrparms.String_arg[2]  
ls_inventory_type=istrparms.String_arg[4]
ls_lot_no=istrparms.String_arg[5]
il_main_currow = istrparms.Long_arg[3]  // 12/06/2010 ujh: SNQM; Get the current row doubleclicked on main window
If upper(gs_project) ='PANDORA' Then ids_scan_serial = istrparms.datastore_arg[1] //16-Jan-2018 :Madhu S14839 Foot Print

//12/06/2010 ujh: SNQM; Set the rows entered for operational use and for viewing by operator.
st_totrows.text= string(dw_1.Rowcount())	

// 07/14/2010 ujhall: 03 of 05 Validate Serial # Double Click:   Transfering values from out of scope object
is_user_line_item_no = istrparms.string_arg[8] 	

istrparms[]=lstrparms[] //Reset the array 

// 08/09 - PCONKL - See if we have stored the left/right trim scan settings in the .ini file
lsType = ProfileString(gs_iniFile,'SCANNING',upper(gs_project) + '-INBOUNDTYPE','')
llNumOfChars = Long(ProfileString(gs_iniFile,'SCANNING',Upper(gs_project) +'-INBOUNDNUMBEROFCHARS',''))
Choose Case upper(lsType)
	Case 'A' /*All */
		rb_Scan_all.Checked = True
		em_scan_First.Enabled = False
		em_scan_last.Enabled = False
	Case 'F' /*First xxx */
		rb_Scan_first.Checked = True
		If llNumofChars > 0 Then
			em_scan_first.text = String(llNumOfChars)
		End If
		em_scan_First.Enabled = True
		em_scan_last.Enabled = False
	Case 'L' /*All */
		rb_Scan_last.Checked = True
		If llNumofChars > 0 Then
			em_scan_last.text = String(llNumOfChars)
		End If
		em_scan_First.Enabled = False
		em_scan_last.Enabled = True
	Case Else
		rb_Scan_all.Checked = True
		em_scan_First.Enabled = False
		em_scan_last.Enabled = False
End Choose
end event

public subroutine wf_window_center ();long li_ScreenH,li_ScreenW
Environment le_Env
GetEnvironment(le_Env)

li_ScreenH = PixelsToUnits(le_Env.ScreenHeight, YPixelsToUnits!)
li_ScreenW = PixelsToUnits(le_Env.ScreenWidth, XPixelsToUnits!)

this.Y = (li_ScreenH - this.Height) / 2
this.X = (li_ScreenW - this.Width) / 2

end subroutine

public function long wf_val_serial_nos (string as_ord_nbr, string as_ord_type, string as_serial_no_entered, long al_edibatch, string as_sku, string as_user_line_item_no, string as_serialized_ind);

// 07/14/2010 ujh: 03 of ???    Validate Serial # DoubleClick   Function that validates
String ls_serial_no, ls_serial_no_sent

				If upper(as_ord_type) = 'Z' and upper(as_serialized_ind) = 'B'  Then   // if a warehouse transfer
					SELECT TOP 1 ds.Serial_no 
					INTO :ls_Serial_no
					FROM Delivery_Picking_Detail dp
					JOIN Delivery_Master dm on dm.DO_no = dp.DO_no
					JOIN Delivery_Serial_Detail ds on ds.ID_NO = dp.ID_No
							and dm.Invoice_NO = :as_Ord_Nbr
							and ds.Serial_no = :as_serial_no_entered;
				
				else
					// Was at least one serial number sent?
					SELECT TOP 1 Serial_no 
					INTO :ls_Serial_no_sent
					FROM EDI_Inbound_Detail
					WHERE  Project_ID = :gs_project
							and EDI_Batch_Seq_no = :al_EDIBatch
							and SKU = :as_SKU
							and Serial_no <> '-' and Serial_no <> '' ;

					if not isnull (ls_Serial_no_sent) and (ls_Serial_no_sent <> '') Then
							SELECT TOP 1 Serial_no 
							INTO :ls_Serial_no
							FROM EDI_Inbound_Detail
							WHERE  Project_ID = :gs_project
									and EDI_Batch_Seq_no = :al_EDIBatch
									and SKU = :as_SKU
									and Serial_no = :as_serial_no_entered;
					else
						Return 0
					End if
					

				End if 
				// end 07/10/2010 ujhall:
				
				// If at least one "sent" serial number does not match the one just scanned (entered), there is a missmatich
				if upper(ls_Serial_no) <> upper(as_serial_no_entered) then
//					li_Message = messagebox(is_title, 'Serial No Missmatch! Do you want to keep serial number = '+as_serial_no,Question!, YesNo!,2)
//					if li_Message = 2 then
//						This.SetItem(row, 'Serial_no', '')  // blank out the scanned data
						return 1
					else
						return 0
					end if  // checking liMessage
				


end function

on w_ro_serialno.create
this.st_7=create st_7
this.st_3=create st_3
this.sle_container=create sle_container
this.sle_pono2=create sle_pono2
this.rb_scan_last=create rb_scan_last
this.rb_scan_first=create rb_scan_first
this.rb_scan_all=create rb_scan_all
this.cb_1=create cb_1
this.st_supplier=create st_supplier
this.st_6=create st_6
this.cb_add=create cb_add
this.st_5=create st_5
this.sle_sku=create sle_sku
this.sle_qty_recd=create sle_qty_recd
this.st_4=create st_4
this.cb_clear=create cb_clear
this.cb_delete=create cb_delete
this.st_2=create st_2
this.st_totrows=create st_totrows
this.cb_close=create cb_close
this.cb_ok=create cb_ok
this.dw_1=create dw_1
this.st_1=create st_1
this.sle_srno=create sle_srno
this.gb_1=create gb_1
this.em_scan_first=create em_scan_first
this.em_scan_last=create em_scan_last
this.Control[]={this.st_7,&
this.st_3,&
this.sle_container,&
this.sle_pono2,&
this.rb_scan_last,&
this.rb_scan_first,&
this.rb_scan_all,&
this.cb_1,&
this.st_supplier,&
this.st_6,&
this.cb_add,&
this.st_5,&
this.sle_sku,&
this.sle_qty_recd,&
this.st_4,&
this.cb_clear,&
this.cb_delete,&
this.st_2,&
this.st_totrows,&
this.cb_close,&
this.cb_ok,&
this.dw_1,&
this.st_1,&
this.sle_srno,&
this.gb_1,&
this.em_scan_first,&
this.em_scan_last}
end on

on w_ro_serialno.destroy
destroy(this.st_7)
destroy(this.st_3)
destroy(this.sle_container)
destroy(this.sle_pono2)
destroy(this.rb_scan_last)
destroy(this.rb_scan_first)
destroy(this.rb_scan_all)
destroy(this.cb_1)
destroy(this.st_supplier)
destroy(this.st_6)
destroy(this.cb_add)
destroy(this.st_5)
destroy(this.sle_sku)
destroy(this.sle_qty_recd)
destroy(this.st_4)
destroy(this.cb_clear)
destroy(this.cb_delete)
destroy(this.st_2)
destroy(this.st_totrows)
destroy(this.cb_close)
destroy(this.cb_ok)
destroy(this.dw_1)
destroy(this.st_1)
destroy(this.sle_srno)
destroy(this.gb_1)
destroy(this.em_scan_first)
destroy(this.em_scan_last)
end on

event open;wf_window_center()
i_nwarehouse = Create n_warehouse


//BCR 11-SEP-2011: Modify processing for Franke_TH 

IF Upper(gs_project) = 'FRANKE_TH' THEN 
	Trigger Event ue_postopen()
ELSE
	//End Modification
	Post event ue_open()
END IF
//
	
	
//Post event ue_open()


end event

event close;Destroy n_warehouse
ClosewithReturn(this,istrparms)
end event

event timer;//17-Aug-2015 :Madhu- Added code to prevent manual scanning
Long ll_foundrow

timer(0)
ibkeytype=FALSE
ibmouseclick =FALSE
MessageBox("Manual Entry","Doesn't Accept manual Entry")

ll_foundrow = dw_1.Find("serial_no = '" + sle_srno.text + "'", 0, dw_1.rowcount())
sle_srno.text=''
dw_1.deleterow(ll_foundrow )

end event

type st_7 from statictext within w_ro_serialno
integer x = 33
integer y = 323
integer width = 519
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Container Id:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_3 from statictext within w_ro_serialno
integer x = 33
integer y = 211
integer width = 519
integer height = 83
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Pallet Id:"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_container from singlelineedit within w_ro_serialno
integer x = 600
integer y = 323
integer width = 859
integer height = 109
integer taborder = 50
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

event modified;//16-Jan-2018 :Madhu - S14839 - Foot Print
//update scanned Container Id value to all serial records.

long ll_row

If dw_1.rowcount( ) > 0 Then
	For ll_row =1 to dw_1.rowcount( )
		dw_1.setItem( ll_row, 'Container_Id', sle_container.text)
	Next
End If
end event

type sle_pono2 from singlelineedit within w_ro_serialno
integer x = 600
integer y = 211
integer width = 859
integer height = 109
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

event modified;//16-Jan-2018 :Madhu - S14839 - Foot Print
//update scanned Po No2 value to all serial records.

long ll_row

If dw_1.rowcount( ) > 0 Then
	For ll_row =1 to dw_1.rowcount( )
		dw_1.setItem( ll_row, 'Po_No2', sle_pono2.text)
	Next
End If
end event

type rb_scan_last from radiobutton within w_ro_serialno
integer x = 1543
integer y = 1075
integer width = 486
integer height = 74
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Last XXXX  Char"
end type

event clicked;em_scan_last.Enabled = True
em_scan_last.SetFocus()

em_scan_First.Enabled = False
em_scan_First.Text = '0'
end event

type rb_scan_first from radiobutton within w_ro_serialno
integer x = 1543
integer y = 1008
integer width = 486
integer height = 74
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "First XXXX  Char"
end type

event clicked;em_scan_first.enabled = True
em_scan_first.SetFocus()


em_scan_last.Text = '0'
em_scan_last.Enabled = False

end event

type rb_scan_all from radiobutton within w_ro_serialno
integer x = 1543
integer y = 941
integer width = 486
integer height = 80
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "All Char"
end type

event clicked;em_scan_last.Text = '0'
em_scan_First.Text = '0'

em_scan_First.Enabled = False
em_scan_last.Enabled = False
end event

type cb_1 from commandbutton within w_ro_serialno
integer x = 1276
integer y = 1760
integer width = 249
integer height = 109
integer taborder = 150
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Help"
end type

event clicked;
ShowHelp(g.is_helpFile,Topic!,551)
end event

type st_supplier from statictext within w_ro_serialno
integer x = 358
integer y = 83
integer width = 870
integer height = 77
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

type st_6 from statictext within w_ro_serialno
integer x = 48
integer y = 83
integer width = 278
integer height = 77
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
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_add from commandbutton within w_ro_serialno
integer x = 1646
integer y = 221
integer width = 249
integer height = 109
integer taborder = 70
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Add"
end type

event clicked;//BCR 12-SEP-2011: Modifications for Franke_TH

IF Upper(gs_project) = 'FRANKE_TH' THEN
	sle_srno.Enabled = FALSE
	sle_sku.SelectText(1, Len(sle_sku.Text))
	sle_sku.SetFocus()
ELSE
	//End Modification
	sle_srno.SetFocus()
END IF
end event

type st_5 from statictext within w_ro_serialno
integer x = 132
integer y = 26
integer width = 194
integer height = 77
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
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_sku from singlelineedit within w_ro_serialno
integer x = 351
integer y = 26
integer width = 870
integer height = 77
integer taborder = 10
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
boolean enabled = false
boolean border = false
boolean autohscroll = false
end type

event modified;//BCR 11-SEP-2011: Enable Serial No field if valid sle_sku was entered for Franke_TH

IF sle_sku.text = is_sku_text THEN
	sle_srno.Enabled = TRUE
	sle_srno.SetFocus()
ELSE
	MessageBox('','Scanned SKU does not match SKU on order.',StopSign!)
	sle_sku.SelectText(1, Len(sle_sku.Text))
	sle_sku.SetFocus()
END IF
end event

type sle_qty_recd from singlelineedit within w_ro_serialno
integer x = 1704
integer y = 16
integer width = 304
integer height = 77
integer taborder = 20
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
end type

type st_4 from statictext within w_ro_serialno
integer x = 1280
integer y = 16
integer width = 417
integer height = 77
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Qty Received:"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_clear from commandbutton within w_ro_serialno
integer x = 1624
integer y = 672
integer width = 278
integer height = 109
integer taborder = 90
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
ll_status = Messagebox("Serial Numbers", "Are you sure you want to~CLEAR all entered S/N's?",Question! ,YesNO!)
IF ll_status = 1 THEN //clears the data
	dw_1.RowsDiscard(1, dw_1.RowCount(), Primary!)
	st_totrows.text=string(dw_1.rowcount())
END IF
	
end event

type cb_delete from commandbutton within w_ro_serialno
integer x = 1624
integer y = 512
integer width = 278
integer height = 109
integer taborder = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Delete"
end type

event clicked;//Delete the rows & calculate total rows again
dw_1.DeleteRow ( dw_1.GetRow())
//st_totrows.text=string(dw_1.rowcount())
st_totrows.text=string(long(st_totrows.text) - 1) // 12/06/2010 ujh: SNQM; decrement qty entered 
istrparms.long_arg[2] = dw_1.rowcount() // 12/06/2010 ujh: SNQM; preserve number of serial numbers on entry window
end event

type st_2 from statictext within w_ro_serialno
integer x = 1298
integer y = 106
integer width = 399
integer height = 77
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
alignment alignment = right!
boolean focusrectangle = false
end type

type st_totrows from statictext within w_ro_serialno
integer x = 1704
integer y = 106
integer width = 384
integer height = 77
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
boolean enabled = false
boolean focusrectangle = false
end type

type cb_close from commandbutton within w_ro_serialno
integer x = 896
integer y = 1760
integer width = 249
integer height = 109
integer taborder = 120
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancel"
boolean cancel = true
end type

event clicked;w_ro_serialno.triggerevent(Close!)

end event

type cb_ok from commandbutton within w_ro_serialno
integer x = 494
integer y = 1760
integer width = 249
integer height = 109
integer taborder = 100
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "OK"
end type

event clicked;//Check to see if total sr. nos are equal to the quantity 
long ll_status
istrparms.long_arg[2] = dw_1.rowcount()  // 01/03/2011 ujh: S/N_P: Fix bug null object when no rows (found doing Serial # project)
If upper(gs_project) ='PANDORA' Then istrparms.datastore_arg[1] = ids_scan_serial //Madhu Added

//08/09 - PCONKL - Store any custom scan setting in the .ini file
// 08/09 - PCONKL - See if we have stored the left/right trim scan settings in the .ini file
If rb_scan_all.Checked Then
	SetProfileString(gs_inifile,'SCANNING',upper(gs_project) + '-INBOUNDTYPE',"A")
	SetProfileString(gs_inifile,'SCANNING',upper(gs_project) + '-INBOUNDNUMBEROFCHARS',"")
ElseIf rb_scan_first.Checked Then
	SetProfileString(gs_inifile,'SCANNING',upper(gs_project) + '-INBOUNDTYPE',"F")
	SetProfileString(gs_inifile,'SCANNING',upper(gs_project) + '-INBOUNDNUMBEROFCHARS',em_scan_first.text)
ElseIf rb_scan_last.Checked Then
	SetProfileString(gs_inifile,'SCANNING',upper(gs_project) + '-INBOUNDTYPE',"L")
	SetProfileString(gs_inifile,'SCANNING',upper(gs_project) + '-INBOUNDNUMBEROFCHARS',em_scan_last.text)
End If

//str_parms	lstrparms
IF dw_1.AcceptText() = -1 THEN Messagebox("","Accept Text Failed")

// 12/06/2010 ujh: SNQM; If qty received greater than qty entered allow choice to close window anyway
IF long(sle_qty_recd.text) > long(st_totrows.text)  THEN
		//MAS 020310 - bluecoat change = items > then serials no's entered prevent user from from closing
		//window, user must enter same number of serial no's as item no's - change is for BlueCoat only...
		If gs_project = 'BLUECOAT' Then
			messagebox(w_ro_serialno.Title,"The total number of serial numbers entered~ris less than the quantity of items received.~r~r"+&
	             "Please add serial numbers to match Qty Received")
				 sle_srno.Setfocus()
				 Return							  
		Else			  					  
			ll_status= Messagebox(w_ro_serialno.Title,"The total number of serial numbers entered~ris less than the quantity of items received.~r~r"+&
	      	        "Are you sure you want to exit?",Question!,YesNo!)
		End If
	
		IF ll_status = 1 THEN //Changed Serial numbers
			sle_qty_recd.text = string(dw_1.RowCount())
//			st_totrows.text =  string(dw_1.RowCount())
			if dw_1.RowCount() > 0 then  // 01/03/2011 ujh: S/N_P: Fix bug null object when no rows (found doing Serial # project)
				IF  i_nwarehouse.of_check_serial_nos(dw_1,istrparms) = 1 THEN	 ClosewithReturn(parent,istrparms)
			else 
				cb_close.TriggerEvent(clicked!)
			end if
		ELSE
			sle_srno.Setfocus()
			
		END IF
ElseIF long(sle_qty_recd.text) < long(st_totrows.text) THEN
	// 12/06/2010 ujh: SNQM;   Qty greater than required count not allowed
	messagebox(w_ro_serialno.Title,"The total number of serial numbers entered~ris greater than the quantity of items received.~r~r"+&
	             "Please delete items to match Qty Received")
	ll_status= 1  // 12/06/2010 ujh: SNQM;  Set status other than zero so the window does not close.
	
//			ll_status= Messagebox(w_ro_serialno.Title,"The total number of serial numbers entered does~rnot equal the quantity of items received.~r~r"+&
//	              "Are you sure you want to exit?",Question!,YesNo!)
//	IF ll_status = 1 THEN //Change of quantity
//		sle_qty_recd.text = string(dw_1.RowCount())
//		IF i_nwarehouse.of_check_serial_nos(dw_1,istrparms) = 1 THEN	 ClosewithReturn(parent,istrparms)      
//	ELSE
//		dw_1.Setfocus()
//		dw_1.SetColumn("serial_no")
//		
//	END IF
		
END IF


long ll_row, ll_New_row

IF ll_status = 0 THEN
	IF i_nwarehouse.of_check_serial_nos(dw_1,istrparms) = 1 THEN	 		ClosewithReturn(parent,istrparms)
END IF	




end event

type dw_1 from datawindow within w_ro_serialno
integer x = 88
integer y = 640
integer width = 1371
integer height = 1056
integer taborder = 30
string dataobject = "d_serial_no_detail"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;IF row > 0 THEN
	THIS.SelectRow(0, FALSE)
	THIS.SelectRow(row, TRUE)
END IF	
end event

type st_1 from statictext within w_ro_serialno
integer x = 33
integer y = 467
integer width = 519
integer height = 83
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 79741120
boolean enabled = false
string text = "Serial Number:"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_srno from singlelineedit within w_ro_serialno
event ue_keydown pbm_keydown
event ue_mouseclick pbm_rbuttondown
integer x = 600
integer y = 448
integer width = 859
integer height = 109
integer taborder = 60
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

event ue_keydown;//17-Aug-2015 :Madhu- Added code to prevent Manul Scanning
If gbPressKeySNScan ='Y'  and gbPressF10Unlock =FALSE and  Upper(gs_project)='PANDORA' THEN
	CHOOSE CASE gs_role
		CASE '1','2'
			If ibkeytype =FALSE THEN
				timer(0.5)
				ibkeytype=TRUE
			END IF
			
			//Get Key Pressed
			IF (KeyDown(KeyShift!) and KeyDown(KeyInsert!)) or (KeyDown(KeyControl!))THEN
				MessageBox("Manual Entry", "Control, Shift Key's are disabled!")
				sle_srno.text=''
				ibkeytype =FALSE
			END IF
			
			CHOOSE CASE key
				CASE KeyEnter!,KeyUpArrow!,KeyDownArrow!,KeyLeftArrow!,KeyRightArrow!
					timer(0)
					ibkeytype=FALSE
			END CHOOSE
	END CHOOSE 
END IF
end event

event ue_mouseclick;//17-Aug-2015 :Madhu- Added code to prevent Manul Scanning
If gbPressKeySNScan ='Y'  and gbPressF10Unlock =FALSE THEN
	IF Upper(gs_project)='PANDORA'  THEN
		ibmouseclick =FALSE
		MessageBox("MouseClick","Right Mouse Click (RMC) Option is disabled")
	ELSE 
		ibmouseclick =TRUE
	END IF
END IF

Return 0	
end event

event modified;/******************************************************************/
/*						Change History Details											  					 */
/*	30-OCT-2017	:Madhu	-	Removed commented code and re-formatted					 */
/*	07-JUNE-2017	:Madhu	-	PEVS-554 - TCIF Linked Code39 "TLC39" SerialBarcodes		 */
/*	30-OCT-2017	:Madhu	-	PEVS-654 -2D Barcode for Pandora								 */
/******************************************************************/

long ll_row, cur_line_item_num, row_num, row_num_main, ll_component_no, ll_EDIBatch , ll_return, li_Index
String lsFind, lsSerial, ls_stripoff_checked, lsFind_main, ls_Component_ind, ab_error_message_title, ab_error_message
String	ls_return, ls_Ord_Nbr, ls_Ord_Type, ls_SKU, ls_user_line_item_no, ls_serialized_ind, ls_Owner_cd, lsCustType, lsCustCode
String		ls_pono2, ls_container_Id, ls_po_no2_Ind, ls_container_Ind
Integer li_Message
Boolean lbFromWMS
Str_Parms ls_str_parms

lbFromWMS = False //TimA 10/28/2015

//TimA 04/15/2011 capture the error message in of_error_on_serial_no_exists to help with possible locking in SIMS
If rb_scan_all.Checked Then
	lsSerial = This.Text
	Elseif rb_scan_first.Checked Then
		if Long(em_scan_first.text) > 0 Then
			lsSerial = Left(This.Text,Long(em_scan_first.text))
		Else
			lsSerial = This.Text
		End If
	Elseif rb_scan_last.Checked Then
		if Long(em_scan_last.text) > 0 Then
			lsSerial = Right(This.Text,Long(em_scan_last.text))
		Else
			lsSerial = This.Text
		End If
	Else
		lsSerial = This.Text
End If

//16-Jan-2018 :Madhu S14839 - Foot Prints -START
//Prompt a message to user, if they don't scan PoNo2 /Container Id
If upper(gs_project) ='PANDORA' and is_serialized_ind='B' and is_po_no2_Ind='Y' and is_container_Ind='Y' Then
	If ((IsNull(sle_pono2.text) or sle_pono2.text='' or sle_pono2.text =' ')  and (IsNull(sle_container.text) or sle_container.text='' or sle_container.text =' ' )) Then
		MessageBox('Serial Number Entry', 'Please scan either Pallet Id or Container Id as first before to scan Serial No"s')
		Return
	End If
End If
//16-Jan-2018 :Madhu S14839 - Foot Prints -END

ls_stripoff_checked = i_nwarehouse.of_stripoff_firstcol_checked( sle_sku.text, st_supplier.text) //07-JUNE-2017 :Madhu -PEVS-554 - TCIF Linked Code39 "TLC39" SerialBarcodes
ls_str_parms = i_nwarehouse.of_parse_2d_barcode( this.text) //30-OCT-2017	:Madhu -PEVS-654 -2D Barcode for Pandora

FOR li_Index =1 to upperbound(ls_str_parms.string_arg) //30-OCT-2017 :Madhu -PEVS-654 -2D Barcode - Added -Loop through list
		lsSerial = ls_str_parms.string_arg[li_Index]
	
	IF upper(gs_project) = 'PANDORA' THEN
		lsSerial = TRIM(lsSerial)
		If len(lsSerial) > 1 Then
			// strip extraneous Trailing chars
			DO WHILE MATCH( lsSerial, "[-\.]$" )
				lsSerial = MID(lsSerial, 1, len(lsSerial) - 1 )
			LOOP
		
			// strip extraneous Leading chars
			DO WHILE MATCH( lsSerial, "^[-\.]")
				lsSerial = MID(lsSerial, 2, len(lsSerial) - 1 )
			LOOP
		
			this.text = lsSerial
			ls_return = i_nwarehouse.of_validate_serial_format( sle_sku.text, lsSerial , st_supplier.text ) 	// TAM 20160602  Serial number mask validation
		
			//28-JULY-2017 :Madhu -PEVS-554 - TCIF Linked Code39 "TLC39" SerialBarcodes -START
			If ls_return <> "" and upper(ls_stripoff_checked) ='Y' Then
				lsSerial = i_nwarehouse.of_Stripoff_firstcol_serialno( sle_sku.text, st_supplier.text, lsSerial)
				ls_return = i_nwarehouse.of_validate_serial_format( sle_sku.text, lsSerial , st_supplier.text )
			End If
			//28-JULY-2017 :Madhu -PEVS-554 - TCIF Linked Code39 "TLC39" SerialBarcodes -END
		
			if ls_return <> "" then
				Messagebox( 'Serial Number Entry', ls_return )
				This.SetFocus()
				This.SelectText(1, Len(Trim(This.Text)))
				Return
				return 1
			end if
		End If
	END IF //Project
	
	//JXLIM 01/05/2011 If workorder
	If IsValid(w_workorder) Then
		cur_line_item_num = w_workorder.idw_putaway.GetItemNumber(il_main_currow,"line_item_no")
		If dw_1.RowCount() > 0 Then
			lsFind = "Serial_no = '" + lsSerial + "'"
			lsFind_main = "Serial_no = '" + lsSerial + "'" &
			+ " and line_item_no = " + string(cur_line_item_num) + " and SKU = '" + sle_sku.text +"'"  //12/06/2010 ujh: SNQM
			row_num = dw_1.Find(lsFind,1,dw_1.RowCount())  // 12/06/2010 ujh: SNQM; Check entry window for SN
			row_num_main = w_workorder.idw_putaway.Find(lsFind_main,1,w_workorder.idw_putaway.RowCount())  // Check main for SN
			// If duplicate found on SN entry window, show message, else test on main page
			If row_num > 0 then
				MessageBox("Duplicate found","This Serial Number has already been entered here on line "+string(row_num))
				This.SetFocus()
				This.SelectText(1, Len(Trim(This.Text)))
				Return
			elseif row_num_main > 0 then  // If duplicate found on main page, show message
				MessageBox("Duplicate found on main window","This Serial Number has already been entered on main page line "+string(row_num_main))
				This.SetFocus()
				This.SelectText(1, Len(Trim(This.Text)))
				Return
			End If
		End If
	Else	//Jxlim 01/06/2011 Added Else for not work order window	
		// 07/00 PCONKL - Check for Duplicates
		lsFind = "Serial_no = '" + lsSerial + "'"
		lsFind_main = "Serial_no = '" + lsSerial + "'" &
		+ " and SKU = '" + sle_sku.text +"'"  //12/06/2010 ujh: SNQM
		row_num = dw_1.Find(lsFind,1,dw_1.RowCount())  // 12/06/2010 ujh: SNQM; Check entry window for SN
		row_num_main = w_ro.idw_putaway.Find(lsFind_main,1,w_ro.idw_putaway.RowCount())  // Check main for SN
		
		If row_num > 0 then
			MessageBox("Duplicate found","This Serial Number SKU combination has already been entered here on line "+string(row_num))
			This.SetFocus()
			This.SelectText(1, Len(Trim(This.Text)))
			Return
		elseif   row_num_main > 0 then  // If duplicate found on main page, show message
			MessageBox("Duplicate found on main window","This Serial Number SKU combination has already been entered on main page line "+string(row_num_main))
			This.SetFocus()
			This.SelectText(1, Len(Trim(This.Text)))
			Return
		End If
	End If //Jxlim 01/06/2011 Ended code for checking w_workorder is valid.
	
	IF g.ibSNchainofcustody THEN
		ll_return = pos(Trim(lsSerial), ' ', 1)
		If Not len(trim(lsSerial)) > 0 or ll_return <> 0 then
			messagebox('SN Validation', 'Serial Numbers must not be null, blank or contain spaces')
			This.SetFocus()
			This.SelectText(1, Len(Trim(This.Text)))
			return
		else
			lsSerial = upper(lsSerial)  // Set to all caps
		end if
	
		IF IsValid(w_ro) THEN
			ls_Ord_Nbr = w_ro.tab_main.tabpage_main.dw_main.getitemstring(1,'supp_invoice_no')
			ls_Ord_Type  = w_ro.tab_main.tabpage_main.dw_main.GetITemString(1,'Ord_type')
			ll_EDIBatch = w_ro.tab_main.tabpage_main.dw_main.GetItemNumber(1,"edi_batch_seq_no")
			ls_Owner_cd = w_ro.tab_main.tabpage_putaway.dw_putaway.GetItemString(1,"Owner_cd") //(1,"c_owner_name")
			ls_SKU = sle_sku.text
			ls_user_line_item_no = Parent.is_user_line_item_no
			ls_serialized_ind   = Parent.is_serialized_ind
			ls_Component_ind = w_ro.tab_main.tabpage_putaway.dw_putaway.GetItemString(il_main_currow,"component_ind")
			ll_Component_no = w_ro.tab_main.tabpage_putaway.dw_putaway.GetItemNumber(il_main_currow,"component_no")  // 01/03/2011 ujh: S/N_Pb
			lsCustCode = w_ro.tab_main.tabpage_other_info.dw_Other.GetItemString(1,'User_Field6' )	 //TimA 10/28/2015
		
			//TimA 10/28/2015 lookup to see if the From Location is from a WMS order.
			If upper(gs_project) = 'PANDORA' then
				If lsCustCode <> '' Then
					SELECT CU.Customer_Type Into :lsCustType FROM Customer CU WITH (NOLOCK) 
					WHERE Cu.Project_Id = :gs_project
					AND CU.Cust_Code = :lsCustCode
					Using SQLCA;
					
					If lsCustType = 'WMS' then
						lbFromWMS = True
					Else
						lbFromWMS = False
					End if
				End if
			End if
		END IF //End of (w_ro)
	
		If upper(ls_ord_type) = 'Z' or ls_Component_ind <> '*' Then
			ll_return = i_nwarehouse.of_val_serial_nos(ls_ord_nbr,ls_Ord_type,lsSerial,ll_EDIBatch,ls_SKU,ls_user_line_item_no,ls_serialized_ind)
			if ll_return <> 0 then  // Test return from serial validation function
			
				//TimA 10/28/2015 added lbFromWMS flag.  Need to validate serial numbers from WMS orders
				If upper(ls_Ord_type) = 'Z' or lbFromWMS = True Then   // if a warehouse transfer
					If lbFromWMS = True then
						li_Message = Messagebox('Error'," Serial Number " + lsSerial + " does not exist on the Outbound half of the WMS warehouse transfer!   Please verify serial number was entered correctly and if so please contact your Site Manager/Supervisor to determine what needs to be corrected.")
					Else
						li_Message = Messagebox('Error'," Serial Number " + lsSerial + " does not exist in the Outbound half of the warehouse transfer!   Please verify serial number was entered correctly and if so please contact your Site Manager/Supervisor to determine what needs to be corrected.")
					End if
					This.SetFocus()
					This.Text = ''
					return
				else
					li_Message = messagebox('Error', 'Serial No Missmatch! Do you want to keep serial number = '+ lsSerial,Question!, YesNo!,2)
					if li_Message = 2 then  // Missmatch choice 
						This.SetFocus()
						This.Text = ''
						return
					end if  // End S/N missmatch choice
				end if  // End if warehouse transfer
			end if  // Test return from serial validation function
		End if // End Serial number validation against sent
	
		ab_error_message_title = ''
		ab_error_message = ''
		//24-Jul-2014 : Madhu - Added "rono,suppinvoiceno" to write those onto Method Trace Log
		ll_return = i_nwarehouse.of_Error_on_serial_no_exists(gs_Project, ls_SKU, lsSerial,ls_owner_cd, ls_component_ind,ll_component_no, true, true,ab_error_message_title,ab_error_message,ls_Ord_Nbr,ls_Ord_Nbr) // TEMPO!?! SkipComponent true/false?
		
		// TAM - 2013/11 - Added Friedrich Serial Validation
		IF upper(gs_project) = 'FRIEDRICH' Then
			if ll_return <> 1 then
				ll_return = i_nwarehouse.of_Error_serial_prior_receipt(gs_Project, ls_SKU, lsSerial, ls_owner_cd, ls_component_ind, ll_component_no, true, true,ab_error_message_title,ab_error_message) //TEMPO! - TRUE for SkipComponent?
			end if
		End If
	
		if ll_return = 1 then  // check Return
			This.SetFocus()
			This.Text = ''
			messagebox(ab_error_message_title, ab_error_message)
			return
		End if  // End Check return
	End if   // End of chain of Custody
	
	this.SetRedraw ( FALSE )
	dw_1.Insertrow(0)
	ll_row = dw_1.rowcount() //count the total rows in datawindow
	dw_1.Setitem(ll_row,"serial_no",lsSerial) //asssign serial number entered in sle
	
	//16-Jan-2018 :Madhu S14839 - Foot Print
	//Assign PoNo2, Container Id to respective scanned SN on dw.
	If upper(gs_project) ='PANDORA' Then
		If	is_serialized_ind ='B'  and is_po_no2_Ind ='Y' and is_container_Ind='Y' Then
			
			If IsNull(sle_pono2.text) or sle_pono2.text='' or sle_pono2.text =' ' Then 
				dw_1.Setitem(ll_row,"Po_No2", '-') //set default value as '-'				
			else
				dw_1.Setitem(ll_row,"Po_No2", sle_pono2.text) //asssign Po No2 entered in sle
			End If
			
			If IsNull(sle_container.text) or sle_container.text='' or sle_container.text =' ' Then 
				dw_1.Setitem(ll_row,"Container_Id", '-') //set default value as '-'
			else
				dw_1.Setitem(ll_row,"Container_Id", sle_container.text) //asssign container Id entered in sle
			End If
		else
			dw_1.Setitem(ll_row,"Po_No2", is_po_no2) //set default values of Putaway
			dw_1.Setitem(ll_row,"Container_Id", is_container_Id) //set default values of Putaway
		End If
	End IF

	sle_srno.text = "" //clear sle
	st_totrows.text=string(dw_1.rowcount()) //12/06/2010 ujh: SNQM; assign the total rows & display same
	istrparms.long_arg[2] = dw_1.rowcount() // 12/06/2010 ujh: SNQM; preserve the number of serial numbers entered
	sle_srno.Setfocus()
	sle_srno.SetRedraw( TRUE)
	ll_row = dw_1.RowCount()
	dw_1.SCROLLTOROW(ll_row)
	
	//BCR 12-SEP-2011: Change processing for Franke_TH
	IF Upper(gs_project) = 'FRANKE_TH' THEN
		sle_srno.Enabled = FALSE
		sle_sku.SelectText(1, Len(sle_sku.Text))
		sle_sku.SetFocus()
	END IF
NEXT //30-OCT-2017 :Madhu-PEVS-654 -2D Barcode -Added- Loop through list 
end event

event getfocus;// ET - change to make sure that the field is blank or will be replaced with whatever is scanned
if len(this.text) > 0 then this.selecttext( 0, len(this.text) )

end event

type gb_1 from groupbox within w_ro_serialno
integer x = 1488
integer y = 874
integer width = 571
integer height = 298
integer taborder = 110
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Scan:"
end type

type em_scan_first from editmask within w_ro_serialno
integer x = 1744
integer y = 1002
integer width = 143
integer height = 74
integer taborder = 140
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
alignment alignment = center!
borderstyle borderstyle = stylelowered!
string mask = "##"
end type

type em_scan_last from editmask within w_ro_serialno
integer x = 1744
integer y = 1075
integer width = 143
integer height = 74
integer taborder = 130
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
alignment alignment = center!
borderstyle borderstyle = stylelowered!
string mask = "##"
end type

