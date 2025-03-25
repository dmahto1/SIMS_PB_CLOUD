$PBExportHeader$w_emc_capture.srw
forward
global type w_emc_capture from w_response_ancestor
end type
type gb_1 from groupbox within w_emc_capture
end type
type rb_manual from radiobutton within w_emc_capture
end type
type rb_auto from radiobutton within w_emc_capture
end type
type sle_sku from singlelineedit within w_emc_capture
end type
type sle_emc from singlelineedit within w_emc_capture
end type
type st_sku from statictext within w_emc_capture
end type
type st_emc from statictext within w_emc_capture
end type
type cb_generate from commandbutton within w_emc_capture
end type
type cb_save from commandbutton within w_emc_capture
end type
type dw_emc from u_dw_ancestor within w_emc_capture
end type
type st_message from statictext within w_emc_capture
end type
type gb_2 from groupbox within w_emc_capture
end type
end forward

global type w_emc_capture from w_response_ancestor
integer width = 3017
integer height = 1832
string title = "EMC Capture"
event type integer ue_process_sku ( string arg_sku )
event type integer ue_process_emc ( string arg_emc )
event ue_generate ( )
event type integer ue_process_manual_emc ( string arg_emc )
event type long ue_save ( )
gb_1 gb_1
rb_manual rb_manual
rb_auto rb_auto
sle_sku sle_sku
sle_emc sle_emc
st_sku st_sku
st_emc st_emc
cb_generate cb_generate
cb_save cb_save
dw_emc dw_emc
st_message st_message
gb_2 gb_2
end type
global w_emc_capture w_emc_capture

type variables
boolean ib_Changed, ibmultiplesku, ibSerialModified
string is_no, is_title, isSetColumn, is_mode, is_name, is_ordNbr
datastore ids_emc_detail



boolean ibSkuScanned, ib_All_EMC_Scanned
string	is_CurrentSKU , is_CurrentEMC
end variables

forward prototypes
public subroutine dodisplaymessage (string _title, string _message)
end prototypes

event type integer ue_process_sku(string arg_sku);//***************************************//
//MStuart - babycare emc functionality                         //
//                                                                              //
//***************************************//

String	lsMessage, ls_Find, ls_sku, lsSerial, ls_Supplier, ls_emc
Integer	liRC
Long	llLineITemNo, llFindRow

ls_sku = arg_sku

dw_emc.SelectRow( 0 , False )

ls_Find = "Upper(sku) = '" + Upper(ls_sku) + "' "
llFindRow = ids_emc_detail.Find(ls_Find,1,ids_emc_detail.RowCount() +1)

If llFindRow = 0 Then
	
	st_message.text = "Please enter a different SKU Code."
	
	doDisplayMessage("Validation Error","SKU Code not valid for" +' '+is_ordNbr+' '+"  !")
	
	Return -1
	
End If

is_CurrentSKU = ls_sku

//MStuart commented
/*
//If only one sku, we dont need to scan a sku.
If not ibmultiplesku Then
	
	ibSkuScanned = True
	If dw_emc.RowCOunt() > 0 Then
		
		isCurrentSKU = dw_emc.GetItemString(1,'sku') 
		
		lsFind = " Upper(sku) = '" + Upper(isCurrentSKU) + "' and isnull(serial_no)" 
		llFindRow = dw_emc.Find(lsFind,1,dw_emc.RowCount() + 1) 
		If llFindRow > 0 Then
			llLineItemNo = dw_emc.GetItemNumber(llFindRow,'Line_Item_no') 
		else
			llLineItemNo = dw_emc.GetItemNumber(1,'Line_Item_no') 
		end if
		
	End If
	
End If
*/




ls_Find = "Upper(sku) = '" + Upper(ls_sku) + "' and (trim(emc_code) = '' or isnull(emc_code))"
llFindRow = dw_emc.Find(ls_Find,1,dw_emc.RowCount() +1)

If llFindRow > 0 Then
	
	ib_All_EMC_Scanned = false
	
	dw_emc.SetRow(llFindRow)
	dw_emc.ScrollToRow(llFindRow)
	dw_emc.SelectRow(llFindRow, true)
	
	sle_emc.enabled = true
	sle_emc.SetFocus()
	sle_emc.SelectText(1,len(sle_sku.Text))								
														
Else
	/*all rows have emc codes for this SKU*/	
	
	st_message.text = "All EMC Code(s) entered for SKU-"+'ls_sku'+ &  
									" Please enter a different SKU Code."
	
	doDisplayMessage("Validation Error","All EMC Codes have been entered for SKU - "+ls_sku+ &  
									+"~n~r"+' '+ "Please enter a different SKU Code.")

									
	ib_All_EMC_Scanned = true															
	sle_emc.enabled = false
	
	sle_sku.SetFocus()
	sle_sku.SelectText(1,len(sle_sku.Text))
	
	is_CurrentSKU = ''
	
	Return -2
	
End If


end event

event type integer ue_process_emc(string arg_emc);//***************************************//
//MStuart - babycare emc functionality                         //
//                                                                              //
//***************************************//

String	lsMessage, lsFind, ls_sku, lsSerial, ls_Supplier, ls_emc
Integer	liRC
Long	llLineITemNo, llFindRow
dwItemStatus sku_status, col_status, row_status


If trim(is_CurrentSKU) = '' or IsNull(is_CurrentSKU) Then	
	
	st_message.text = "SKU Not found. Please scan a SKU."
	
	doDisplayMessage( "Validation Error","SKU Not found. Please scan a SKU.")	

	sle_sku.SetFocus()
	sle_sku.SelectText(1,len(sle_sku.Text))
	Return -1
	
End If

//check for all emc codes scanned
lsFind = "sku = '" + is_CurrentSKU + "' and (trim(emc_code) = '' or isnull(emc_code))"
	
llFindRow = dw_emc.Find(lsFind,1,dw_emc.RowCount() +1)
	
If llFindRow = 0 Then
	st_message.text = "All EMC Code(s) scanned for this SKU. Please scan a SKU Code."


	doDisplayMessage("Validation Error","All EMC Codes have been scanned for this SKU." +&
																		+'~n~r'+' '+"Please scan a SKU Code.")
	
		ib_All_EMC_Scanned = true
								
		Return -1
ENd If

ls_emc = arg_emc

dw_emc.SelectRow( 0 , False )

////If only one sku, we dont need to scan a sku.
//If not ibmultiplesku Then
//	
//	ibSkuScanned = True
//	If dw_emc.RowCOunt() > 0 Then
//		
//		isCurrentSKU = dw_emc.GetItemString(1,'sku') 
//		
//		lsFind = " Upper(sku) = '" + Upper(isCurrentSKU) + "' and isnull(serial_no)" 
//		llFindRow = dw_emc.Find(lsFind,1,dw_emc.RowCount() + 1) 
//		If llFindRow > 0 Then
//			llLineItemNo = dw_emc.GetItemNumber(llFindRow,'Line_Item_no') 
//		else
//			llLineItemNo = dw_emc.GetItemNumber(1,'Line_Item_no') 
//		end if
//		
//	End If
//	
//End If


//MEA - 9/11 - Took out sku validation as per Jeff.

//sku = '" + (is_CurrentSKU) + "' and 

//check for duplicates
lsFind = "emc_code = '" + (ls_emc) +"' "
llFindRow = dw_emc.Find(lsFind,1,dw_emc.RowCount() +1)

If llFindRow > 0 Then	
		
	st_message.text = "Duplicate EMC Code entered. Please enter another EMC Code."
	
	doDisplayMessage("Validation Error","Duplicate EMC Code " &
									+"~n~r"+"Please scan another EMC Code.")
									
		sle_sku.SetFocus()
		sle_sku.SelectText(1,len(sle_sku.Text))								
									
	Return -2
End If

is_CurrentEMC = ls_emc

lsFind = "sku = '" + is_CurrentSKU + "' and (trim(emc_code) = '' or isnull(emc_code))"
llFindRow = dw_emc.Find(lsFind,1,dw_emc.RowCount() +1)

If llFindRow > 0 Then
	
	dw_emc.SetITem(llFindRow,'emc_code',ls_emc) /*set empty row with EMC code*/
			
	ib_changed = True
							
	dw_emc.SetRow(llFindRow)
	dw_emc.ScrollToRow(llFindRow)
	dw_emc.SelectRow(llFindRow, true)
												
Else
	/*all rows have emc codes for this SKU*/		
	st_message.text = "All EMC Code(s) scanned. Please scan a SKU Code."
	
	doDisplayMessage("Validation Error","All EMC Codes have been scanned for this SKU")
	
	ib_All_EMC_Scanned = True
	
	Return -3
End If




end event

event ue_generate();//***************************************//
//MStuart - babycare emc functionality                         //
//                                                                              //
//***************************************//

integer li_i, li_ii, li_rtn
long ll_gen_rows, ll_curr_gen_row, ll_cnt
dec ld_sku_qty
string ls_emc_rows,  ls_ro_no, ls_do_no, ls_sku, lsMsg

ll_cnt = dw_emc.RowCount()

If ll_cnt > 0 Then
	
	st_message.text = "Records exist for order" +' '+is_ordNbr+' '+"  !"
	
	doDisplayMessage("Records exist for order" +' '+is_ordNbr+' '+"  !", &
				"Existing records will be cleared and re-generated!")
				//, StopSign!, &
					//																	OkCancel!)
		
//	If li_rtn = 2 Then
//		st_message.text = ''
//		Return
//	End If
	
//Else
//	st_message.text = "Generating records for order" +' '+is_ordNbr+' '+"  !"
	
End If

st_message.text = "Generating records for order" +' '+is_ordNbr+' '+"  !"
	
SetPointer(Hourglass!)

dw_emc.SetRedraw(False)

If ll_cnt > 0 Then
	li_rtn = dw_emc.RowsMove(1, ll_cnt, Primary!, &
														        dw_emc, 1, Delete!)																  																  																
End If

ll_cnt = ids_emc_detail.RowCount()

For li_i = 1 to ll_cnt
	
	ls_sku = ids_emc_detail.GetItemString( li_i,"SKU")
	ld_sku_qty = ids_emc_detail.GetItemDecimal( li_i, "Quantity")
	ls_emc_rows =	 ids_emc_detail.GetItemString( li_i,"User_Field4")
	
	//if ls_emc_rows is blank, null or not num default to 1
	If Not(IsNumber(trim(ls_emc_rows))) or IsNull(trim(ls_emc_rows)) Then
			
		ls_emc_rows = '1'
	End If
	
	ll_gen_rows = ld_sku_qty * dec(ls_emc_rows)
	
	For li_ii = 1 to ll_gen_rows
		//generate emc capture rows
		ll_curr_gen_row = dw_emc.InsertRow(0)
		
		//need to pop error message
		if ll_curr_gen_row < 0  then return
			
		dw_emc.SetItem( ll_curr_gen_row, "Project_ID" , gs_project )

		If is_name = 'w_ro' Then
			dw_emc.SetItem( ll_curr_gen_row, "Ro_No" , is_no )
		ElseIf is_name = 'w_do' Then
			dw_emc.SetItem( ll_curr_gen_row, "Do_No" , is_no )
		End If
		
		dw_emc.SetItem( ll_curr_gen_row, "Sku" , ls_sku )

		dw_emc.SetItem( ll_curr_gen_row, "emc_code" , '' )
	Next

Next

dw_emc.SetTransObject(SQLCA)
Execute Immediate "Begin Transaction" using SQLCA; 

li_rtn = dw_emc.UpDate()

If li_rtn = 1 Then

	Execute Immediate "COMMIT" using SQLCA;
Else

	  Execute Immediate "ROLLBACK" using SQLCA;
		lsMsg = "Unable to Delete EMC Records!~r~r"
		If Not isnull(SQLCA.SQLErrText) Then 
			lsMsg += SQLCA.SQLErrText
		End If
     	doDisplayMessage(is_title, lsMsg)	
End If

ib_Changed = false

st_message.text =''
dw_emc.SetRedraw(True)

//re-init the windows mode
//Choose Case upper(is_mode)	
//	Case 'AUTO'
//		rb_auto.TriggerEvent(clicked!)
//	Case 'MANUAL'
//		rb_manual.TriggerEvent(clicked!)			
//End Choose

//re-init the window to auto mode
rb_auto.checked = True
rb_auto.TriggerEvent(clicked!)
//sle_sku.SetFocus()

end event

event type integer ue_process_manual_emc(string arg_emc);//***************************************//
//MStuart - babycare emc functionality                         //
//                                                                              //
//***************************************//
String	lsFind
Long	llFindRow
dwItemStatus sku_status, col_status, row_status


If is_CurrentSKU = '' or IsNull(is_CurrentSKU) Then	
	
	st_message.text = "SKU Not found. Please type a SKU."
	
	doDisplayMessage( "Validation Error","SKU Not found. Please type a SKU.")	
	
	sle_sku.SetFocus()	
	Return -1
	
End If

dw_emc.AcceptText()

dw_emc.SelectRow( 0 , False )

//check for duplicates
lsFind = "sku = '" + (is_CurrentSKU) + "' and emc_code = '" + (arg_emc) +"' "
llFindRow = dw_emc.Find(lsFind,1,dw_emc.RowCount() +1)
If llFindRow > 0 Then
	
	Choose Case  upper(is_mode) 
		Case 'MANUAL', 'AUTO'
			
			Do While llFindRow > 0						
				If llFindRow <> dw_emc.GetRow() Then
						//process for emc code dups						
						st_message.text = "Duplicate EMC Code entered. Please type another EMC Code."
	
						doDisplayMessage("Validation Error","Duplicate EMC Code entered" &
														+"~n~r"+' '+"Please type another EMC Code.")							
						//itemchanged isn't rejecting data
						dw_emc.SetItem( dw_emc.GetRow(), "Emc_Code", "" )
						Return -2																		
					
					End If
																																														
				llFindRow++		
				IF llFindRow > dw_emc.RowCount() THEN EXIT
				
				lsFind = "Upper(sku) = '" + Upper(is_CurrentSKU) + "' and Upper(emc_code) = '" + Upper(arg_emc) +"' "
				llFindRow = dw_emc.Find(lsFind,llFindRow,dw_emc.RowCount() +1)
															
			Loop			

	End choose
	
End If

ib_changed = True
is_CurrentEMC = arg_emc


end event

event type long ue_save();//***************************************//
//MStuart - babycare emc functionality                         //
//                                                                              //
//***************************************//
integer li_rtn
string ls_msg

dw_emc.SetTransObject(SQLCA)

Execute Immediate "Begin Transaction" using SQLCA; 

li_rtn = dw_emc.update()

IF li_rtn = 1 THEN

	Execute Immediate "COMMIT" using SQLCA;

	ib_Changed = false

ELSE

	Execute Immediate "ROLLBACK" using SQLCA;
	
		ls_msg = "Unable to Delete EMC Records!~r~r"
			If Not isnull(SQLCA.SQLErrText) Then 
				ls_msg += SQLCA.SQLErrText
			End If
			
     	doDisplayMessage(is_title, ls_msg)
		
		Return -1
END IF

Return 1

end event

public subroutine dodisplaymessage (string _title, string _message);// doDisplayMessage( string _title, string _message )

str_parms	lstrParms


lstrParms.string_arg[1] = _title
lstrParms.string_arg[2] = _message

openwithparm( w_scan_message, lstrParms )

end subroutine

on w_emc_capture.create
int iCurrent
call super::create
this.gb_1=create gb_1
this.rb_manual=create rb_manual
this.rb_auto=create rb_auto
this.sle_sku=create sle_sku
this.sle_emc=create sle_emc
this.st_sku=create st_sku
this.st_emc=create st_emc
this.cb_generate=create cb_generate
this.cb_save=create cb_save
this.dw_emc=create dw_emc
this.st_message=create st_message
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_1
this.Control[iCurrent+2]=this.rb_manual
this.Control[iCurrent+3]=this.rb_auto
this.Control[iCurrent+4]=this.sle_sku
this.Control[iCurrent+5]=this.sle_emc
this.Control[iCurrent+6]=this.st_sku
this.Control[iCurrent+7]=this.st_emc
this.Control[iCurrent+8]=this.cb_generate
this.Control[iCurrent+9]=this.cb_save
this.Control[iCurrent+10]=this.dw_emc
this.Control[iCurrent+11]=this.st_message
this.Control[iCurrent+12]=this.gb_2
end on

on w_emc_capture.destroy
call super::destroy
destroy(this.gb_1)
destroy(this.rb_manual)
destroy(this.rb_auto)
destroy(this.sle_sku)
destroy(this.sle_emc)
destroy(this.st_sku)
destroy(this.st_emc)
destroy(this.cb_generate)
destroy(this.cb_save)
destroy(this.dw_emc)
destroy(this.st_message)
destroy(this.gb_2)
end on

event open;call super::open;//***************************************//
//MStuart - babycare emc functionality                         //
//                                                                              //
//***************************************//
str_parms	lstr_parms
string   ls_sku, ls_where, ls_sql
long li_pos
string ls_sql2
int li_rtn, li_cnt


lstr_parms = message.powerobjectparm

is_name   = lstr_parms.String_arg[1]
is_ordNbr = lstr_parms.String_arg[2]
is_no        = lstr_parms.String_arg[3]

ls_sql = dw_emc.GetSQLSelect( )


ids_emc_detail = Create datastore

If is_name = 'w_ro' Then
	
	ls_where = " where emc_capture.project_id = '" + gs_project + "' "
	ls_where += " and emc_capture.ro_no = '" + is_no + "' "

	ls_sql2 = left( ls_sql, pos(ls_sql,"WHERE") -1)

	ls_sql2 += ls_where

	ls_sql = Replace(ls_sql,pos(ls_sql,"WHERE"),100,ls_where)	

	dw_emc.SetSqlSelect( ls_sql2 )

	ids_emc_detail.Dataobject = 'd_emc_receive_putaway_ds'
	
ElseIf is_name = 'w_do' Then
	
	ls_where = " where emc_capture.project_id = '" + gs_project + "' "
	ls_where += " and emc_capture.do_no = '" + is_no + "' "

	ls_sql2 = left( ls_sql, pos(ls_sql,"WHERE") -1)

	ls_sql2 += ls_where

	ls_sql = Replace(ls_sql,pos(ls_sql,"WHERE"),100,ls_where)	

	dw_emc.SetTransObject(sqlca)
	li_rtn = dw_emc.SetSqlSelect( ls_sql2 )

	ids_emc_detail.Dataobject = 'd_emc_delivery_picklist_ds'
	
End If



//**********************************
//      set datastore
ids_emc_detail.SetTransObject(sqlca)

li_cnt = ids_emc_detail.Retrieve( gs_project,is_no )

If ids_emc_detail.Retrieve( gs_project,is_no ) = 0 Then
	//	messagebox(is_title,"No records found!")
End If
//     end of datastore
//************************************************

dw_emc.SetTransObject(sqlca)
li_rtn = dw_emc.SetSqlSelect(ls_sql2)

If dw_emc.Retrieve( ) = 0 Then
		//messagebox(is_title,"No records found!")
End If

This.TriggerEvent("ue_postOpen")





end event

event ue_postopen;call super::ue_postopen;//***************************************//
//MStuart - babycare emc functionality                         //
//                                                                              //
//***************************************//

rb_manual.checked = False
dw_emc.enabled    = False

rb_auto.checked = True

sle_sku.enabled = True
sle_emc.enabled = False

dw_emc.SetTabOrder("SKU",0)
dw_emc.SetTabOrder("EMC_Code",0)
dw_emc.enabled    = True

is_mode = 'AUTO'

st_message.text = ''
st_message.text = "Please scan the SKU Code."

sle_sku.SetFocus()

this.title = "EMC Data Capture"




end event

event ue_close;//***************************************//
//MStuart - babycare emc functionality                         //
//                                                                              //
//***************************************//
//ancestor over-ridden

Close(This)

end event

event closequery;call super::closequery;//***************************************//
//MStuart - babycare emc functionality                         //
//                                                                              //
//***************************************//
Integer li_return

dw_emc.AcceptText()

// Looking for unsaved changes
IF ib_changed THEN
	doDisplayMessage(is_title,"Save Changes?")
	//Choose Case MessageBox(is_title,"Save Changes?",Question!,YesNoCancel!,3)
	//	Case 1
	   li_return = Trigger Event ue_save()
			If li_return = -1 Then
				Return 1
			Else
				Return 0
			End If
//   	Case 2
//			Return 0
//		Case 3
//			Return 1
//	End Choose 		
ELSE
	Return 0
END IF
end event

type cb_cancel from w_response_ancestor`cb_cancel within w_emc_capture
integer x = 1079
integer y = 1448
integer width = 329
integer taborder = 80
end type

event cb_cancel::clicked;//overridden
ib_changed = False
Close(Parent)

end event

type cb_ok from w_response_ancestor`cb_ok within w_emc_capture
integer x = 722
integer y = 1448
integer width = 329
integer taborder = 70
boolean default = false
end type

type gb_1 from groupbox within w_emc_capture
integer x = 256
integer y = 28
integer width = 526
integer height = 232
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
end type

type rb_manual from radiobutton within w_emc_capture
integer x = 306
integer y = 76
integer width = 439
integer height = 76
integer taborder = 10
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "&Manual Entry"
end type

event clicked;
sle_sku.SelectText(1,len(sle_sku.Text))
sle_sku.Clear()
sle_sku.enabled = false

sle_emc.SelectText(1,len(sle_sku.Text))
sle_emc.Clear()
sle_emc.enabled = false

dw_emc.enabled = true

dw_emc.SetTabOrder("SKU",10)
dw_emc.SetTabOrder("EMC_Code",20)

dw_emc.SetFocus()
If dw_emc.RowCount() > 0 Then
	dw_emc.SetRow(1)
End If

//init instance vars
is_CurrentSKU = ''
is_CurrentEMC = ''
is_mode = 'MANUAL'


st_message.text = ''
st_message.text = "Please type the SKU or EMC Code."
		
		
end event

type rb_auto from radiobutton within w_emc_capture
integer x = 306
integer y = 168
integer width = 379
integer height = 76
integer taborder = 20
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "&Auto Entry"
end type

event clicked;

sle_sku.enabled = true
sle_sku.Clear()

sle_emc.enabled = false
sle_emc.Clear()

dw_emc.SetTabOrder("SKU",0)
dw_emc.SetTabOrder("EMC_Code",0)
dw_emc.enabled    = True
//dw_emc.enabled = false

sle_sku.SetFocus()
		
//init instance vars
is_CurrentSKU = ''
is_CurrentEMC = ''
is_mode = 'AUTO'

st_message.text = ''
st_message.text = "Please scan the SKU Code."

end event

type sle_sku from singlelineedit within w_emc_capture
integer x = 1317
integer y = 64
integer width = 1285
integer height = 92
integer taborder = 30
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
textcase textcase = upper!
integer limit = 50
integer accelerator = 115
borderstyle borderstyle = stylelowered!
end type

event getfocus;//MStuart BabyCare

If rb_auto.Checked Then
	This.SelectText(1,len(sle_sku.Text))
End IF
end event

event modified;//MStuart BabyCare
string ls_sku

ls_sku = sle_sku.Text
If trim(ls_sku) <> ''  Then
	Parent.Event ue_process_sku( sle_sku.Text )
End If


end event

type sle_emc from singlelineedit within w_emc_capture
integer x = 1317
integer y = 168
integer width = 1285
integer height = 92
integer taborder = 50
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
textcase textcase = upper!
integer limit = 50
integer accelerator = 101
borderstyle borderstyle = stylelowered!
end type

event getfocus;If rb_auto.Checked Then
	This.SelectText(1,len(sle_emc.Text))
End IF
end event

event modified;//MStuart BabyCare

Parent.Event ue_process_emc( sle_emc.text )

If rb_auto.Checked and &
			 Not(ib_All_EMC_Scanned) Then
	This.SetFocus()
	This.SelectText(1,len(sle_emc.Text))	
End IF

If ib_All_EMC_Scanned Then
	
//	causes two messageboxs to pop
//	This.SetFocus()
//	This.SelectText(1,len(sle_sku.Text))
	this.text = ''
	//this.Clear()
//	//This.Enabled = False
	
	sle_sku.SetFocus()
	sle_sku.SelectText(1,len(sle_sku.Text))
	sle_sku.Clear()

				
	//leave here if moved with other this. functions 
	//causes the mode to switch from auto to manual 
	This.Enabled = False
				
End If
end event

type st_sku from statictext within w_emc_capture
integer x = 987
integer y = 64
integer width = 325
integer height = 92
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "&SKU Code "
alignment alignment = right!
boolean focusrectangle = false
end type

type st_emc from statictext within w_emc_capture
integer x = 983
integer y = 168
integer width = 329
integer height = 92
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "&EMC Code "
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_generate from commandbutton within w_emc_capture
integer x = 1792
integer y = 1448
integer width = 329
integer height = 108
integer taborder = 100
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Generate"
end type

event clicked;
Parent.TriggerEvent("ue_generate")






end event

type cb_save from commandbutton within w_emc_capture
event ue_save ( )
integer x = 1435
integer y = 1448
integer width = 329
integer height = 108
integer taborder = 90
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Save"
end type

event clicked;
parent.trigger event closequery()

end event

type dw_emc from u_dw_ancestor within w_emc_capture
event ue_clear_emc_code ( )
event ue_set_column ( )
event ue_load_item_values ( long alserialrow,  long alpickrow )
integer x = 114
integer y = 328
integer width = 2766
integer height = 996
integer taborder = 60
boolean bringtotop = true
string dataobject = "d_emc"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event ue_clear_emc_code();
this.SetItem(This.GetRow(),'emc_code','')

end event

event ue_set_column();This.SetColumn(isSetColumn)
end event

event ue_load_item_values(long alserialrow, long alpickrow);
String		lsSku,lsDoNo,lsSupplier, lsDesc,	lsSkuParent, lsCompInd
Long			llID, llMaxSeq,llCompNo, llLineItemNo
String      ls_uf4

/*
lsDoNo = idw_pick.GetITemString(alPickRow,"do_no")
lsSku = idw_pick.GetITemString(alPickRow,"sku")
lsSkuParent = idw_pick.GetITemString(alPickRow,"sku_Parent")
lsCompInd = idw_pick.GetITemString(alPickRow,"Component_Ind")
lsSupplier = idw_pick.GetITemString(alPickRow,"supp_code")
llCompNo = idw_pick.GetITemNumber(alPickRow,"Component_no")
llLineItemNo = idw_pick.GetITemNumber(alPickRow,"line_item_no") /* 10/03 - PCONKL*/
*/


//Get the Item Description
Select Description,user_field4 Into :lsDesc,:ls_uf4
From Item_Master
Where project_id = :gs_project and sku = :lsSku and supp_code = :lsSUpplier;


//Get the ID from Picking Detail
Select Min(id_no) into :llID
from Delivery_Picking_Detail
Where do_no = :lsdoNo and sku = :lsSKU and supp_code = :lsSupplier and Line_Item_no = :llLineItemNo;
	
dw_emc.SetItem(alSerialRow,'id_no',llID)
dw_emc.SetITem(alSerialRow,'sku',lsSKU)
dw_emc.SetITem(alSerialRow,'supp_code',lsSUpplier)
dw_emc.SetITem(alSerialRow,'sku_parent',lsSKUPArent)
dw_emc.SetITem(alSerialRow,'component_ind',lsCompInd)
dw_emc.SetITem(alSerialRow,'component_no',llCompNo)
dw_emc.SetITem(alSerialRow,'description',lsDesc)
dw_emc.SetITem(alSerialRow,'item_master_user_field4',ls_uf4)
dw_emc.SetITem(alSerialRow,'sku_substitute',lsSKU) //TAM 2010/04
dw_emc.SetITem(alSerialRow,'supplier_substitute',lsSUpplier)  //TAM 2010/04

If gs_project <> 'LMC' Then /* 01/09 - PCONKL - LMC will be scanning the qty, don't default here */
	dw_emc.SetITem(alSerialRow,'quantity',1)
End If

llMaxSeq ++
If llMaxSeq = 0 Then llMaxSeq = 1
			
//Non components should sort at the end
If dw_emc.GetItemString(alSerialRow,'component_ind') = 'Y' Or dw_emc.GetItemString(alSerialRow,'component_ind') = '*' Or dw_emc.GetItemString(alSerialRow,'component_ind') = 'B' Then
	dw_emc.SetITem(alSerialRow,'component_sequence_no',llmaxSeq)
Else
	dw_emc.SetITem(alSerialRow,'component_sequence_no',999)
End If
		

dw_emc.SetColumn('carton_no')







end event

event clicked;call super::clicked;//If rb_auto.Checked Then
//	sle_sku.SetFocus()
//	sle_sku.SelectText(1,len(sle_sku.Text))
//End IF
end event

event constructor;call super::constructor;This.SetRowFocusIndicator(Hand!)
end event

event getfocus;call super::getfocus;//MStuart - commented 9/8
/*
If rb_auto.Checked Then
	sle_sku.SetFocus()
	sle_sku.SelectText(1,len(sle_sku.Text))
End IF
*/


end event

event itemchanged;call super::itemchanged;String	lsFind, lsMessage
Long	llFindRow
Integer	li_rtn

// TAM 07/21/2010 Needed a few more variables for Pandora Serial Vaidation
string ls_Serialized_Ind, ls_serial_no, ls_ro_no,ls_to_no, ls_owner_cd, ls_wh_code, ls_sku
long ll_rec_owner_id, ll_soc_owner_id, ll_owner_id, ll_return
long llComponent_no, ll_first, ll_last,  i_ndx , ll_na_component_no  //01/03/2011 ujh: S/N_Pb:
integer liMessage
string lsComponent_Ind //dts - not calling serial validation for component children


String ab_error_message_title, ab_error_message



// Get the SKU and emc code for current row.
is_CurrentSKU = GetItemString(row, "sku")
is_CurrentEMC = GetItemString(row, "emc_code")

ib_Changed = true

Choose Case Upper(dwo.Name)
		
	Case 'SKU'

//-1 invalid sku
//-2 all emc codes scanned

			li_rtn = Parent.Event ue_process_sku(data)
			
//			messagebox("item", string (li_rtn))
			
			if li_rtn < 0 Then
				return 2
//			elseIf li_rtn = -2 Then
				
			End If





	Case 'EMC_CODE'       
		//-1 sku not found
		//-2 dup emc
		//-3 all codes entered
		
		is_CurrentSKU = this.GetItemString( row, "sku")
		
		li_rtn = Parent.Event ue_process_manual_emc(data)
		
		If li_rtn < 0 Then
			Return 2
		End If
		
		dw_emc.SetRow(dw_emc.GetRow())
		dw_emc.ScrollToRow(dw_emc.GetRow())
		
		
			
			
		

End Choose


end event

event itemerror;call super::itemerror;Return 2
end event

event process_enter;call super::process_enter;Send(Handle(This),256,9,Long(0,0))
Return 1

end event

event retrievestart;call super::retrievestart;Return 2
end event

event scrollvertical;call super::scrollvertical;
sle_sku.SetFocus()
sle_sku.SelectText(1,len(sle_sku.Text))
end event

event ue_delete;call super::ue_delete;This.DEleteRow(This.GetRow())
ib_changed = True
ibSerialModified = True
end event

event ue_insert;call super::ue_insert;Long	llNewRow

llNewRow = This.InsertRow(0)
This.SetFocus()
This.SetRow(llNewROw)
This.ScrollToRow(llNewRow)
This.SetColumn('Line_Item_No')
end event

event ue_retrieve;call super::ue_retrieve;
//// 11/02 - PConkl - QTY fields changed to Decimal
//
//String		lsSku,lsDoNo,lsSupplier,lsCOO, lsLoc,lsInvType,lsLot, lsPO,lsPO2,lsSerialized,lsDash, &
//				lsDesc, lsFind, lsContainer, lsGrp
//Long			llOwner, llPickCOunt, llPickPos, llCount,llID, llNewRow,i, llMaxSeq,llFindRow, llCompNo, llLineItemNo
//Decimal		ldMod, ldPickQty, ldParentQty,ldUnitQty, ldUPC, ldQty
//String      ls_uf4, lsNativeDescription
//DateTime		ldtExpDt
//
//
////Picking detail records are being retrievd into datastore
////For each picking detail, we are retrieving the picking serial #'s. THis will allow us to create
//// blank rows as needed so we have rows of 1 qty to fill all qty for picking detail row
//
//// 03/04 - PCONKL - ALL Serial #'s are being retrieved at once - no need to loop through each pick detail record.
////							All we need to do is add empty rows as needed when the user clicks 'generate'
//
//If not isvalid(ids_pick_detail) Then
//	ids_pick_detail = Create DataStore
//	ids_pick_detail.dataobject = 'd_do_serial_no_hidden'
//	ids_pick_detail.SetTransObject(SQLCA)
//End If
//
//// will loop through each Pick record  and here we will return all pick details for that pick record.
//lsDoNo = idw_pick.GetITemString(ilretrieverow,"do_no")
//lsSku = idw_pick.GetITemString(ilretrieverow,"sku")
//lsSerialized = idw_pick.GetITemString(ilretrieverow,"serialized_ind")
//lsSupplier = idw_pick.GetITemString(ilretrieverow,"supp_code")
//llOwner = idw_pick.GetITemNumber(ilretrieverow,"owner_id")
//ldQty = idw_pick.GetITemNumber(ilretrieverow,"Quantity")
//llCompNo = idw_pick.GetITemNumber(ilretrieverow,"Component_no")
//llLineItemNo = idw_pick.GetITemNumber(ilretrieverow,"line_item_no") /* 10/03 - PCONKL*/
//lsCOO = idw_pick.GetITemString(ilretrieverow,"Country_of_origin")
//lsloc = idw_pick.GetITemString(ilretrieverow,"l_code")
//lsInvType = idw_pick.GetITemString(ilretrieverow,"inventory_type")
//lsLot = idw_pick.GetITemString(ilretrieverow,"lot_no")
//lsPO = idw_pick.GetITemString(ilretrieverow,"po_no")
//lsPO2 = idw_pick.GetITemString(ilretrieverow,"po_no2")
//lsContainer = idw_pick.GetITemString(ilretrieverow,"Container_ID") /* 12/04 - PCONKL*/
//ldtExpDT = idw_pick.GetITemDateTime(ilretrieverow,"Expiration_date")  /* 12/04 - PCONKL*/
//
//
////02/10 - PCONKL - If we are scanning all items, we only need one row per line/SKU - WE mya have multiple pick records for same line/sku - dont need multiples here
//If g.ibScanAllOrdersRequired and lsSerialized = 'N' Then
//	If dw_serial.Find("Line_Item_No = " + string(llLineItemNo) + " and Upper(SKU) = '" + upper(lsSKU) + "'",1,dw_serial.RowCount()) > 0 Then
//		Return
//	End If
//End If
//
////llPickQty = idw_pick.GetITemNumber(ilretrieverow,"quantity")
//
////Get the Item Description
//Select Description,user_field4, part_upc_Code, grp, Native_Description Into :lsDesc,:ls_uf4, :ldUPC, :lsGrp, :lsNativeDescription
//From Item_Master
//Where project_id = :gs_project and sku = :lsSku and supp_code = :lsSUpplier;
//
//llPickCount = ids_pick_detail.Retrieve(lsdono,lssku,lssupplier,llOwner,lscoo,lsloc,lsInvTYpe,lsLot,lsPO,lsPO2,llCompNo,llLineItemNo, lsContainer, ldtExpDt) /* 12/04 - PCONKL - added Container ID and Expiration DT */
//For llPickPos = 1 to llPickCount
//	
//	llID = ids_pick_detail.GetItemNumber(llPickPos,'id_no')
//	
//	// 10/08 - PCONKL - For Comcast, we only need 1 serial row per picking row since they are only scanning 1 pallet/carton per picked row
//	// 05/09 - PCONKL - For LMC, start with 1 row per Pick List. We will add as necessary but we are ending up with thousands of extra rows to delete
//	// 11/09 - If we are scanning all orders (Pack Val), we just want one row per SKU ifit is not a serialized part
//	If gs_project = 'COMCAST' or gs_project = 'LMC' or (g.ibScanAllOrdersRequired and (lsSerialized = 'N' or lsSerialized = 'Y'))  then
//		ldPickQty = 1
//	else
//		ldPickQty = ids_pick_detail.GetItemNumber(llPickPos,'quantity')
//	End If
//	
//	//dw_serial.Retrieve(llId,gs_project) /*retievestart=2*/
//	
//	//	//add blank rows where needed
//	// 03/04 - PCONKL - We will only add blank rows if we are 'generating', not just retreiving existing records
//		
//		select count(*)  into :llCount 
//		From Delivery_serial_detail
//		Where id_no = :llID;
//
//		//Find THe Max for this sku
//		llMaxSeq = 0
//		
//		//lsFind = "sku = '" + ids_pick_detail.GetItemString(llPickPos,'sku') + "' and supp_code = '" + ids_pick_detail.GetItemString(llPickPos,'supp_code') + "'"
//		lsFind = "sku_parent = '" + ids_pick_detail.GetItemString(llPickPos,'sku_parent') + "' and sku = '" + ids_pick_detail.GetItemString(llPickPos,'sku') + "' and supp_code = '" + ids_pick_detail.GetItemString(llPickPos,'supp_code') + "'"
//		llFindRow = dw_serial.Find(lsFind,1,dw_serial.RowCount())
//		
//		Do While llFindRow > 0
//			If dw_serial.GetItemNumber(llFindRow,'component_sequence_no') > llMaxSeq Then
//				llMaxSeq = dw_serial.GetItemNumber(llFindRow,'component_sequence_no')
//			End If
//			llFindRow ++
//			If llFindRow > dw_serial.RowCount() Then Exit
//			llFindRow = dw_serial.Find(lsFind,llFindRow,(dw_serial.RowCount() + 1))
//		Loop
//	
//		If llCount < ldPickQty Then // AND   NOT  (gs_project = 'WARNER' AND lsGrp = 'PO' ) Then
//			
//			For I = 1 to (Long(ldPickQty) - llCount)
//				
//				llNewRow = dw_serial.InsertRow(0)
//				dw_serial.SetItem(llNewRow,'id_no',llID)
//				dw_serial.SetITem(llNewRow,'sku',ids_pick_detail.GetItemString(llPickPos,'sku'))
//				dw_serial.SetITem(llNewRow,'supp_code',ids_pick_detail.GetItemString(llPickPos,'supp_code'))
//				dw_serial.SetITem(llNewRow,'sku_parent',ids_pick_detail.GetItemString(llPickPos,'sku_parent'))
//				dw_serial.SetITem(llNewRow,'component_ind',ids_pick_detail.GetItemString(llPickPos,'component_ind'))
//				dw_serial.SetITem(llNewRow,'component_no',ids_pick_detail.GetItemNumber(llPickPos,'component_no'))
//				dw_serial.SetITem(llNewRow,'line_Item_No',ids_pick_detail.GetItemNumber(llPickPos,'line_Item_No')) /* 03/05 - PCONKL*/
//				dw_serial.SetITem(llNewRow,'sku_substitute',ids_pick_detail.GetItemString(llPickPos,'sku')) //TAM 2010/04
//				dw_serial.SetITem(llNewRow,'supplier_substitute',ids_pick_detail.GetItemString(llPickPos,'supp_code'))  //TAM 2010/04
//				
//				// 01/11 - PCONKL - For Comcast, if we are doing a WH transfer from a Corp Warehouse to an SIK warehouse, set the Serial # to the Lot # from Picking
//				// 03/11 - PCONKL - Also if a virtual Shipment from warehouse 'COM-DIRECT'
//				if gs_project = 'COMCAST' Then
//					
//					If (idw_Main.GetITemSTring(1,'Ord_Type') = 'Z' and Left(idw_Main.GetItemString(1,'Cust_Code'),7) = 'COM-SIK') or idw_Main.GetITEmString(1,'wh_code') = 'COM-DIRECT'  Then
//					
//						dw_serial.SetITem(llNewRow,'serial_no',lsLot)
//						dw_serial.SetITem(llNewRow,'quantity',ldQty)
//						
//					End If
//										
//				End If /*Comcast*/
//				
//				//If we have a non swerialized part and we are scanning all items, ge the expeced qty from dd.alloc_qty since we wont be processing all the pick detail records (this logic will only be hit once per line/sku
//				If g.ibScanAllOrdersRequired and lsSerialized = 'N' Then
//					
//					llFindRow = idw_detail.Find("line_item_no = " + String(llLineItemNo) + " and Upper(SKU) = '" + upper(lsSKU) + "'",1,idw_detail.RowCount())
//					If llFindRow > 0 Then
//						dw_serial.SetITem(llNewRow,'expected_qty',idw_Detail.GetItemNumber(llFindRow,'alloc_Qty'))
//					Else
//						dw_serial.SetITem(llNewRow,'expected_qty',ids_pick_detail.GetItemNumber(llPickPos,'quantity'))
//					End If
//				Else
//					dw_serial.SetITem(llNewRow,'expected_qty',ids_pick_detail.GetItemNumber(llPickPos,'quantity'))
//				End If
//				
//				dw_serial.SetITem(llNewRow,'description',lsDesc)
//				dw_serial.SetITem(llNewRow,'native_description',lsNativeDescription)
//				dw_serial.SetITem(llNewRow,'part_upc_code',ldUPC)
//				dw_serial.SetITem(llNewRow,'item_master_user_field4',ls_uf4)
//				dw_serial.SetITem(llNewRow,'serialized_ind',lsSerialized)
//				
////				If gs_project <> 'LMC' Then /*LMC will be scanning Qty, don't default */
//				If dw_serial.GetITemNumber(llNewRow,'Quantity') > 0 Then
//				Else
//					dw_serial.SetITem(llNewRow,'quantity',0)
//				End If
////				End If
//					
//				//If not serialized for this item, default to '-' which will gray/protect
//				If lsSerialized <> 'O' and lsSerialized <> 'B' Then /* 02/09 - PCONKL - Added B */
//					//lsDash += '-' /*dummy value to avaoid dups but not require serial no where not required*/
//					dw_serial.SetITem(llNewRow,'serial_no','-')
//				End If
//			
//				//If it's not a child, always bump the Seq up, otherwise only bump up if we've included all the children for a single parent qty (there can be more than 1 of a child for a single parent*/
//			
//				// 03/03 - PCONKL - This is causing problems if the parent is split across multiple pick records (diff Lot, etc.).
//				// We will assume that there is only 1 of a child per parent. If not, they will need to be entered in the same row.
//			
//				llMaxSeq ++
//			
//				If llMaxSeq = 0 Then llMaxSeq = 1
//				If llMaxSeq > 9999999 Then llMaxSeq = 1 /* 05/04 - PCONKL - ensure it doesn't wrap*/
//			
//				//Non components should sort at the end
//				// 10/04 - PCONKL - If component_no = 0 (built in WO or blown out in DO) then no need to sort by component seq - set them all to 999
//				If (dw_serial.GetItemString(llNewRow,'component_ind') = 'Y' Or dw_serial.GetItemString(llNewRow,'component_ind') = '*' Or dw_serial.GetItemString(llNewRow,'component_ind') = 'B') and llCompNo > 0 Then
//
////TAM 2010/05/26 - BOMs are not sorted correctly if there is a child BOM quantity > 1.  The Parent sequence numbers wil be 1 to (parent quantity).  
////           In order to keep the Child Skus with their Parents we need to calculate the associated parent sequence number.  Divide Max Sequence by the Parent quantity and add 1 to the remainer
//					If gs_project = 'PANDORA' and llmaxSeq>ilparentqty and ilparentqty > 0 then
//						dw_serial.SetITem(llNewRow,'component_sequence_no',mod(llmaxSeq, ilparentqty) + 1)
//					Else
//						dw_serial.SetITem(llNewRow,'component_sequence_no',llmaxSeq)
//					End If
//				Else
//					dw_serial.SetITem(llNewRow,'component_sequence_no',999)
//				End If
//				
//			Next /*Next Pick Qty*/
//		
//		End If /* Blank rows needed */
//	
//Next /*Next Pick Detail*/
//
//long index
//long sRows
//string _supplier
//if gs_project = '3COM_NASH' THEN
//	sRows = dw_serial.rowcount()
//	for index = 1 to sRows
//		_supplier = dw_serial.object.supp_code[ index ]
//		if _supplier = '3COM' then
//			dw_serial.object.participatingsupplier[index] = 0  // 3com defaults to participating regardless of supplier master setting
//			continue
//		end if
//		if NOT f_isparticipatingsupplier( gs_project, 	_supplier ) then
//			dw_serial.object.participatingsupplier[index] = 1
//		else
//			dw_serial.object.participatingsupplier[index] = 0
//		end if
//	next
//end  if
//
//dw_serial.SetFocus()
//dw_serial.SetRow(1)
//dw_serial.ScrollToRow(1)
//dw_serial.SetColumn('serial_no')
//
//
//
//
//
//
//
//
end event

event updateend;call super::updateend;//MStuart - BabyCare
//if you click the generate button twice - rowchanged between retrieve and update error pops
//the identity column never resets without doing a retrieve
dw_emc.Reset()
	
If dw_emc.Retrieve(  ) = 0 Then
	//	messagebox(is_title,"No records found!")
End If
end event

type st_message from statictext within w_emc_capture
integer x = 375
integer y = 1596
integer width = 2107
integer height = 108
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
boolean focusrectangle = false
end type

type gb_2 from groupbox within w_emc_capture
integer x = 695
integer y = 1396
integer width = 1458
integer height = 180
integer taborder = 40
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
end type

