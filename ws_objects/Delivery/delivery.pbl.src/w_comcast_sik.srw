$PBExportHeader$w_comcast_sik.srw
forward
global type w_comcast_sik from w_master
end type
type st_nonserialized from statictext within w_comcast_sik
end type
type dw_nonserial from u_dw_ancestor within w_comcast_sik
end type
type dw_rma_report from datawindow within w_comcast_sik
end type
type dw_report from datawindow within w_comcast_sik
end type
type cb_reprint_letter from commandbutton within w_comcast_sik
end type
type cb_cancel from commandbutton within w_comcast_sik
end type
type cb_ok from commandbutton within w_comcast_sik
end type
type sle_order from singlelineedit within w_comcast_sik
end type
type st_order from statictext within w_comcast_sik
end type
type dw_serial from u_dw_ancestor within w_comcast_sik
end type
type sle_serial from singlelineedit within w_comcast_sik
end type
type dw_main from u_dw_ancestor within w_comcast_sik
end type
type st_serial from statictext within w_comcast_sik
end type
type st_serialized from statictext within w_comcast_sik
end type
end forward

global type w_comcast_sik from w_master
integer width = 3986
integer height = 2432
string title = "SIK Line Capture"
event ue_retrieve ( )
event ue_print_letter ( )
event ue_copy_rows ( )
event ue_print_rma_letter ( )
event ue_print_welcome_1 ( )
event ue_print_account_1 ( )
st_nonserialized st_nonserialized
dw_nonserial dw_nonserial
dw_rma_report dw_rma_report
dw_report dw_report
cb_reprint_letter cb_reprint_letter
cb_cancel cb_cancel
cb_ok cb_ok
sle_order sle_order
st_order st_order
dw_serial dw_serial
sle_serial sle_serial
dw_main dw_main
st_serial st_serial
st_serialized st_serialized
end type
global w_comcast_sik w_comcast_sik

type variables
Boolean	ibCancel, ibValid, ibReturnTrackingRequired
SingleLineEdit	isle_order, isle_serial
Int ilSetRow, ilRow, il_cnt, ii_qty
u_nvo_carton_serial_scanning iuo_carton_serial_scanning
dwItemStatus il_status
//datastore ids_serial


end variables

forward prototypes
public function integer wf_clear_screen ()
public subroutine dodisplaymessage (string _title, string _message)
public function integer wf_enable_main ()
public function integer wf_enable_detail ()
public function integer wf_reset ()
public function boolean readytoprint ()
end prototypes

event ue_retrieve();String ls_order, ls_dono, ls_serial, lsFind, lsNull
long ll_cnt, li_qty,  llfindrow, i, j,  llSerialPos, llSerialCount, llPickQty, llPickSum, llNonSerilizedCount,  llID

SetNull(lsNull)

//Traking Order
ls_order = isle_Order.Text

If ls_order <> '' then
	ls_order = Trim(ls_order)
End If

//ids_serial = Create Datastore
//ids_serial.DataObject = 'd_serial_comcast_sik'
//ids_serial.SetTransObject(Sqlca)
//
//dw_main.SetTransObject(Sqlca)
//dw_serial.SetTransObject(Sqlca)

wf_clear_screen()

dw_main.Retrieve(ls_order)

ll_cnt = dw_main.RowCount()

If ll_cnt > 0 Then		
	
	wf_enable_main()					
	
	ls_dono = dw_main.GetItemString(1, 'do_no')		
					
	llSerialCount = dw_serial.Retrieve(ls_dono) /* 01/12 - PCONKL - This will now only retrieve serialized items*/

	llNonSerilizedCount = dw_nonserial.Retrieve(ls_dono) /* 01/12 - PCONKL - new DW for Non-serialized items*/
	
	If llNonSerilizedCount > 0 Then
		For i = 1 to llNonSerilizedCount
			If isnull(dw_nonserial.GetITemNUmber(i,'scanned_qty')) Then
				dw_nonserial.SetITem(i,'scanned_qty',0)
			End If
		Next
	End If
	
	If llSerialCount > 0 Then
		
//		//Get the Sum of the Pick Qty
//		Select Sum(Quantity) into :llPickQty
//		from delivery_picking with (nolock)
//		Where do_no = :ls_dono;
//		
//		//If Serial Row Count < Pick Qty, Add rows
//		If llSerialCount < llPickQty Then
//			
//			For i = 1 to (llPickQty - llSerialCount)					
//				  dw_serial.RowsCopy( 1, 1, Primary!, dw_serial, 999, Primary!)		
//				  dw_serial.SetITem(dw_serial.RowCount(),'serial_no',lsNull)
//				  dw_serial.SetITemStatus(dw_serial.RowCount(),0,Primary!,NotModified!)
//			Next
//			
//		End If

		//01/12 - PCONKL - Have non serialized now, can't just sum Picking,  We already have the Quantity for each row retrieved, we can just do it based on what's already retrieved
		For lLSerialPos = 1 to dw_serial.RowCount()
			
			llId = dw_serial.GetITemNumber(lLSerialPos,'Delivery_Picking_Detail_ID_NO')
			llPickQty = dw_serial.GetITemNumber(lLSerialPos,'Delivery_Picking_Detail_Quantity')
			
			If llPickQty > 1 Then
				
				llPickSum = 0
				For J = 1 to dw_serial.RowCount()
					
					If dw_serial.GetITemNumber(j,'Delivery_Picking_Detail_ID_NO') = llID Then
						llPickSum ++
					End If
					
				Next
				
				If llPickQty > llPickSum Then /* need extra rows */
				
					For i = 1 to (llPickQty - llPickSum)	
						
					 	dw_serial.RowsCopy( lLSerialPos, lLSerialPos, Primary!, dw_serial, 999, Primary!)		
					  	dw_serial.SetITem(dw_serial.RowCount(),'serial_no',lsNull)
					  	dw_serial.SetITemStatus(dw_serial.RowCount(),0,Primary!,NotModified!)
						  
					Next
					
				End If
				
			End If /* Qty > 1 */
			
		Next /*Picking Detail record */
						 						 
		dw_serial.show()
		st_serialized.visible = True
		
//		st_serial.Show()
//		sle_serial.Show()
//		sle_serial.Enabled = True
					
	End If /*serialized parts*/
	
	If llNonSerilizedCount > 0 Then
		st_nonserialized.visible = True
		dw_nonserial.show()
	End IF
	
	

	If 	llSerialCount > 0 or llNonSerilizedCount > 0 Then
		
		st_serial.Show()
		sle_serial.Show()
		sle_serial.Enabled = True
		
	End If
					
//	// 10/11 - PCONKL - For RMA ORders, we will require the Return Tracking ID to be scanned (alredy saved in DM, just want it confirmed*/
//	If dw_Main.getITemString(1,'Ord_type') = 'R' Then
//		ibReturnTrackingRequired = True
//	Else
//		ibReturnTrackingRequired = False
//	End If
	
	sle_serial.SetFocus()
	//sle_serial.TriggerEvent("Modified") 
	
	If 	llSerialCount > 0 Then
		
		 lsFind = "IsNull(Upper(serial_no)) or serial_no = ''"
		 llFindRow = dw_serial.Find(lsFind,1,dw_serial.RowCOunt())
		 
		 If llFindRow > 0 Then
			cb_reprint_letter.Enabled = False
		//	cb_reprint_label.Enabled = False	
		 Else
			 cb_reprint_letter.Enabled = True
			// cb_reprint_label.Enabled = True
			 sle_order.Setfocus()
			 isle_order.SelectText(1,Len(ls_Order))	
		 End If
		
	End If
	
	// modify scan entry field text based on if we have serialized, Non or both
	If llSerialCount > 0 and llNonSerilizedCount > 0 Then
		st_serial.Text = "Scanned SKU/Serial No:"
	ElseIf lLSerialCount > 0 Then
		st_serial.Text = "Scanned Serial No:"
	Else
		st_serial.Text = "Scanned SKU:"
	End If
						
Else /*Order Not Found */
	
	//MessageBox('SIK Line Capture', "Order not found, please enter again!", Exclamation!)		
	doDisplayMessage('SIK Line Capture', "Order not found, please enter again!")		
	isle_order.SetFocus()
	isle_order.SelectText(1,Len(ls_Order))	
	wf_clear_screen()
	
End If


end event

event ue_print_letter();//01/12 - PCONKL - We may now have SKUs that print different letters or Non Serialized parts that don't print a letter at all
 //							Item Master UF 4 will determine which letter to print. If found at all, each print routine will determine what's printed (1 letter for all or 1 for each). Not going to loop here
 //							The original WElcome Letter is being designated as 'WELCOME-1'



//Check for original welcome letter...
If dw_serial.Find("Upper(User_Field4) = 'WELCOME-1'",1,dw_serial.RowCOunt()) > 0 Then
	This.TriggerEvent("ue_print_welcome_1")
End If

//Modem Account card
If dw_serial.Find("Upper(User_Field4) = 'ACCOUNT-1'",1,dw_serial.RowCOunt()) > 0 Then
	This.TriggerEvent("ue_print_account_1")
End If
end event

event ue_copy_rows();////Jxlim 08/06/2010  Copy numbers of rows based on Pick qty to enable entering serial number on the detail dw
//Long li_qty, i
//
//li_qty = ii_qty -1
//For i = 1 to li_qty	
//	 ids_serial.RowsCopy(i, li_qty, Primary!, dw_serial, li_qty, Primary!)		  
//Next
//


end event

event ue_print_rma_letter();
Messagebox('','RMA letter printed')
end event

event ue_print_welcome_1();
// Print the original SIK welcome letter...

//JXLIM 07/28/2010 Print Comcast welcome letter.
String lsPrinter, ls_dono, ls_custname,ls_acc, ls_cust_id, ls_desc, ls_serial
String ls_add, ls_city, ls_zip, ls_state, ls_return_add, lsModify
Long ll_row,i, ll_cnt, liRC, li_rtn


//Clear the Report Window (hidden datawindow)
dw_report.Reset()
dw_Report.dataobject = 'd_print_letter_comcast' /*each letter will use the same DW*/

// 01/12 - PCONKL - Filter the Serial DW for items in case we have items that get a different letter
dw_Serial.SetFilter("Upper(User_Field4) = 'WELCOME-1'")
dw_serial.Filter()

ls_dono = dw_main.GetItemString(1, 'do_no')

dw_report.InsertRow(0)
//Get customer name
ls_custname = dw_main.GetItemString(1, 'cust_name')
dw_report.SetItem(1, 'cust_name', ls_custname)

//Get account number and customer ID
ls_acc = dw_main.GetItemString(1, 'user_field5')
ls_cust_id = dw_main.GetItemString(1, 'user_field4')

dw_report.SetItem(1, 'user_field5', ls_acc)
dw_report.SetItem(1, 'user_field4', ls_cust_id)

// 08/10 - PCONKL   - Only want to print number of labels for qty being shipped. make the others invisible.

For i = 1 to 9 /*make them all invisible*/
	lsModify = "user_Field4_" + String(i) + ".visible=0"
	dw_report.Modify(lsModify)
Next

ll_cnt = dw_serial.RowCount()
for i = 1 to ll_cnt /*make them visible for number of serial rows*/
	lsModify = "user_Field4_" + String(i) + ".visible=1"
	dw_report.Modify(lsModify)
Next

// 08/11 - PCONKL - removed return address at Comcast's request

////Get return address information
//Select 	address_1, city, state, zip 
//Into :ls_add, :ls_city, :ls_state, :ls_zip
//From Delivery_alt_address
//Where do_no = :ls_dono
//And Address_type = 'RW'
//Using SQLCA;					
//					ls_return_add = ls_add + ', ' + ls_city + ', ' + ls_state + ', ' + ls_zip + '.' 					
//					If ls_add = '' Then
//						ls_return_add = ''
//					End if								
//					dw_report.SetItem(1, 'return_address', ls_return_add)
//					//autosize width why it doesn't resize?????
//					//dw_report.Modify("return_address.Width.Autosize=yes")
					
//Get Item Master Description			
ll_cnt = dw_serial.RowCount()
For i = 1 To ll_cnt
	 ls_desc = dw_serial.GetItemString(i, 'item_master_description')		 
	If i = 1 Then
		dw_report.SetItem(1, 'Description1',  ls_desc)
	Elseif i = 2 Then
		dw_report.SetItem(1, 'Description2',   ls_desc)
	Elseif i = 3 Then
		dw_report.SetItem(1, 'Description3',   ls_desc)
	Elseif i = 4 Then
		dw_report.SetItem(1, 'Description4',   ls_desc)
	Elseif i = 5 Then
		dw_report.SetItem(1, 'Description5',   ls_desc)
	Elseif i = 6 Then
		dw_report.SetItem(1, 'Description6',   ls_desc)
	End If
Next					
					
//Get Serial Number
For i = 1 To ll_cnt
	 ls_serial = dw_serial.GetItemString(i, 'serial_no')		 
	If i = 1 Then
		dw_report.SetItem(1, 'serial1',  ls_serial)
	Elseif i = 2 Then
		dw_report.SetItem(1, 'serial2',  ls_serial)
	Elseif i = 3 Then
		dw_report.SetItem(1, 'serial3',  ls_serial)
	Elseif i = 4 Then
		dw_report.SetItem(1, 'serial4',  ls_serial)
	Elseif i = 5 Then
		dw_report.SetItem(1, 'serial5',  ls_serial)
	Elseif i = 6 Then
		dw_report.SetItem(1, 'serial6',  ls_serial)
	End If
Next

ll_row = dw_report.RowCount()
IF ll_row < 1 THEN MessageBox("Database Error", "No rows retrieved.")

//See if we have a saved default printer for COMCASTWELCOMELETTER
lsPrinter = ProfileString(gs_iniFile,'PRINTERS','COMCASTWELCOMELETTER','')
//lsPrinter = ''
If lsPrinter > '' Then 
	PrintSetPrinter(lsPrinter)
	g.ibNoPromptPrint = True /* called print routine will not display print dialog box */
End If

//testing if there is row to print
If ll_row > 0 Then
	If g.ibNoPromptPrint Then	
		Print(This.dw_report) //printing dw
	Else
		//Prompt for printer selection for first time
		OpenWithParm(w_dw_print_options, dw_report) //printing dw
	End If
	//Jxlim 11/13/2010 
	//After printed the welcome letter, Set Delivery_Master.User_Field2 to ‘Y’.
	dw_main.SetItem(1, 'user_field2', 'Y')
End If

Execute Immediate "Begin Transaction" using SQLCA; /* Auto Commit Turned on to eliminate DB locks*/

liRC = dw_main.Update()
					
If liRC = 1 Then				
	
		Execute Immediate "COMMIT" using SQLCA;	
		
		If SQLCA.SQLCode = 0 Then								
			li_rtn = dw_main.ResetUpdate()							
		End If						
		
	Else
		
		Execute Immediate "ROLLBACK" using SQLCA;
		MessageBox('Invalid','Unable to Save changes to records.')
		Return
		
End If
					
// We want to store the last printer used for Printing the Welcome lettert for defaulting later
lsPrinter = PrintGetPrinter()
SetProfileString(gs_inifile, 'PRINTERS','COMCASTWELCOMELETTER', lsPrinter)

g.ibNoPromptPrint = False

dw_Serial.SetFilter("")
dw_serial.Filter()


//Focus and highlight tracking order after print for re-printing
sle_order.SetFocus()
sle_order.SelectText(1,Len(sle_order.Text))	


end event

event ue_print_account_1();
//Print Account cards for Modems



String lsPrinter, ls_dono, ls_custname,ls_acc, ls_mac, ls_serial

Long ll_row,i, ll_cnt, liRC, li_rtn


//Clear the Report Window (hidden datawindow)
dw_report.Reset()
dw_Report.dataobject = 'd_comcast_sik_account_letter' /*each letter will use the same DW*/

// 01/12 - PCONKL - Filter the Serial DW for items in case we have items that get a different letter
dw_Serial.SetFilter("Upper(User_Field4) = 'ACCOUNT-1'")
dw_serial.Filter()

ls_dono = dw_main.GetItemString(1, 'do_no')

//Get customer name and Account Nbr
ls_custname = dw_main.GetItemString(1, 'cust_name')
ls_acc = dw_main.GetItemString(1, 'user_field5')

//See if we have a saved default printer for COMCASTWELCOMELETTER
lsPrinter = ProfileString(gs_iniFile,'PRINTERS','COMCASTACCOUNTLETTER1','')

If lsPrinter > '' Then 
	PrintSetPrinter(lsPrinter)
	g.ibNoPromptPrint = True /* called print routine will not display print dialog box */
End If


//We are printing one account card per serial row

ll_cnt = dw_serial.RowCount()
for i = 1 to ll_cnt 
	
	dw_report.Reset()
	dw_report.InsertRow(0)
	
	dw_report.SetItem(1, 'cust_name', ls_custname)
	dw_report.SetItem(1, 'account_nbr', ls_acc)
	
	//Gett MAC ID from Carton Serial (Address1 = User_Field1)
	ls_serial = dw_serial.GetITemString(i,'serial_no')
	ls_mac = ''
	
	Select Max(User_Field1) Into :ls_MAC
	From carton_serial
	Where Project_id = 'COMCAST'
	And serial_no = :ls_serial
	Using SQLCA;	
	
	dw_report.SetItem(1, 'mac_id', ls_mac)
	
	//Print
	If g.ibNoPromptPrint Then	
		Print(This.dw_report) //printing dw
	Else
		//Prompt for printer selection for first time
		OpenWithParm(w_dw_print_options, dw_report) //printing dw
		g.ibNoPromptPrint = True
	End If
	
	//After printed the account card, Set Delivery_Master.User_Field2 to ‘Y’.
	dw_main.SetItem(1, 'user_field2', 'Y')
	
Next /*Serial record*/

Execute Immediate "Begin Transaction" using SQLCA; /* Auto Commit Turned on to eliminate DB locks*/

liRC = dw_main.Update()
					
If liRC = 1 Then				
	
		Execute Immediate "COMMIT" using SQLCA;	
		
		If SQLCA.SQLCode = 0 Then								
			li_rtn = dw_main.ResetUpdate()							
		End If						
		
	Else
		
		Execute Immediate "ROLLBACK" using SQLCA;
		MessageBox('Invalid','Unable to Save changes to records.')
		Return
		
End If
					
// We want to store the last printer used for Printing the Welcome lettert for defaulting later
lsPrinter = PrintGetPrinter()
SetProfileString(gs_inifile, 'PRINTERS','COMCASTACCOUNTLETTER1', lsPrinter)

g.ibNoPromptPrint = False

dw_Serial.SetFilter("")
dw_serial.Filter()


//Focus and highlight tracking order after print for re-printing
sle_order.SetFocus()
sle_order.SelectText(1,Len(sle_order.Text))	


end event

public function integer wf_clear_screen ();//Jxlim 07/27/2010 for dw reset.

dw_serial.SetRedraw(True)	
dw_Nonserial.SetRedraw(True)	

dw_main.Reset()
dw_serial.Reset()
dw_nonserial.Reset() /* 01/12 - PCONKL */

dw_main.Hide()
dw_serial.Hide()
dw_nonserial.Hide()  /* 01/12 - PCONKL */

cb_ok.Enabled = False
cb_cancel.Enabled = False	
cb_reprint_letter.Enabled = False	
//cb_reprint_label.Enabled = False	

st_serial.Hide()
sle_serial.Hide()
sle_serial.Enabled = False

st_serialized.visible = False
st_nonserialized.visible = False

Return 0


end function

public subroutine dodisplaymessage (string _title, string _message);//Jxlim 07/27/2010 clone this function to enable the usage of w_scan_message (dodisplayMesssage)
// doDisplayMessage( string _title, string _message )

str_parms	lstrParms

lstrParms.string_arg[1] = _title
lstrParms.string_arg[2] = _message

openwithparm( w_scan_message, lstrParms )

end subroutine

public function integer wf_enable_main ();//Jxlim 07/30/2010 Enabled when tracking order return result set.
//Enabled when dw_main > 0
//string ls_serial

If 	dw_main.rowcount() > 0 Then
	
	dw_main.Show()	
		
	cb_ok.Show()
	cb_cancel.Show()
	cb_ok.Enabled = True
	cb_cancel.Enabled = True
	
	cb_reprint_letter.Show()
//	cb_reprint_label.Show()
	
End If

Return 0

end function

public function integer wf_enable_detail ();//Jxlim 07/30/2010 Enable when tracking order return result set.
string ls_serial

dw_main.Show()	
cb_ok.Show()
cb_cancel.Show()
cb_reprint_letter.Show()
//cb_reprint_label.Show()

//Scan serial number
st_serial.Show()
isle_serial.Show()
isle_serial.Enabled = True				
isle_serial.SetFocus()

ls_serial = isle_serial.Text
isle_serial.SelectText(1,Len(ls_serial))	

Return 0
end function

public function integer wf_reset ();//Jxlim 08/02/2010 Reset all the controls on the window.
wf_clear_screen()

st_serial.Hide()
isle_serial.Hide()
isle_serial.Enabled = False

sle_order.SetFocus()
sle_order.Text = ""
isle_order = This.sle_order

//reset scan serial
sle_serial.Text = ""
sle_serial.backcolor = rgb(255,255,255)

// 10/11 - PCONKL - reset color on Retrun Tracking ID
dw_main.Modify("return_tracking_no.color=0")

Return 0
end function

public function boolean readytoprint ();
Boolean	lbReadyToPrint
String	lsFind
Long	llFindRow

lbReadyToPrint = True

//If Serial ized parts exist, can only print when all of the serials have been scanned
If dw_serial.RowCount() > 0 Then
	
	 lsFind = "IsNull(Upper(serial_no)) or serial_no = ''"
	 llFindRow = dw_serial.Find(lsFind,1,dw_serial.RowCOunt())
	 
	 If llFindRow > 0 Then
		lbReadyToPrint = False
	End If
	
End If /*Serial records exist*/

//If Non-Serialized parts exist, all must be scanned
If dw_nonSerial.RowCount() > 0 Then
	
	lsFind = "scanned_qty < alloc_Qty"
	llFindRow = dw_nonSerial.Find(lsFind,1,dw_nonSerial.RowCOunt())
	 
	 If llFindRow > 0 Then
		lbReadyToPrint = False
	End If
	
End If

//If Return Tracking Numberis required and hasn't been entered, can't print
If ibreturntrackingrequired Then
	lbReadyToPrint = False
End If

REturn lbReadyToPrint
end function

on w_comcast_sik.create
int iCurrent
call super::create
this.st_nonserialized=create st_nonserialized
this.dw_nonserial=create dw_nonserial
this.dw_rma_report=create dw_rma_report
this.dw_report=create dw_report
this.cb_reprint_letter=create cb_reprint_letter
this.cb_cancel=create cb_cancel
this.cb_ok=create cb_ok
this.sle_order=create sle_order
this.st_order=create st_order
this.dw_serial=create dw_serial
this.sle_serial=create sle_serial
this.dw_main=create dw_main
this.st_serial=create st_serial
this.st_serialized=create st_serialized
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_nonserialized
this.Control[iCurrent+2]=this.dw_nonserial
this.Control[iCurrent+3]=this.dw_rma_report
this.Control[iCurrent+4]=this.dw_report
this.Control[iCurrent+5]=this.cb_reprint_letter
this.Control[iCurrent+6]=this.cb_cancel
this.Control[iCurrent+7]=this.cb_ok
this.Control[iCurrent+8]=this.sle_order
this.Control[iCurrent+9]=this.st_order
this.Control[iCurrent+10]=this.dw_serial
this.Control[iCurrent+11]=this.sle_serial
this.Control[iCurrent+12]=this.dw_main
this.Control[iCurrent+13]=this.st_serial
this.Control[iCurrent+14]=this.st_serialized
end on

on w_comcast_sik.destroy
call super::destroy
destroy(this.st_nonserialized)
destroy(this.dw_nonserial)
destroy(this.dw_rma_report)
destroy(this.dw_report)
destroy(this.cb_reprint_letter)
destroy(this.cb_cancel)
destroy(this.cb_ok)
destroy(this.sle_order)
destroy(this.st_order)
destroy(this.dw_serial)
destroy(this.sle_serial)
destroy(this.dw_main)
destroy(this.st_serial)
destroy(this.st_serialized)
end on

event ue_postopen;call super::ue_postopen;ibCancel = True
ibValid = False

//ids_serial = Create Datastore
//ids_serial.DataObject = 'd_serial_comcast_sik'
//ids_serial.SetTransObject(Sqlca)

dw_main.SetTransObject(Sqlca)
dw_serial.SetTransObject(Sqlca)

wf_clear_screen()

sle_order.SetFocus()
sle_order.Text = ""
isle_order = This.sle_order

Return
end event

event closequery;call super::closequery;//Get out if canceled
If ibCancel Then
	Return 0
End IF
end event

event ue_save;call super::ue_save;//Jxlim 08/05/2010  //Save changes to Serial DW
Long llFindRow
Integer	liRC, li_rtn
String lastrow, lsFind
dwItemStatus l_status

//For new record, we wanted dw to send Insert statement to database instead of update.
//Hence we need to set dwitemstatus from DataModified! to NewModified! with the following sequence.
//SetItemStatus is not always straight forward, we need to follow the sequence from PB dwItemStatus.

If ilRow > 0 Then
	
	l_status = dw_serial.GetItemStatus(ilRow, 0, Primary!)	
	dw_serial.SetItemStatus(ilRow, 0, Primary!, New!)	
	dw_serial.SetItemStatus(ilRow, 0, Primary!, NotModified!)	
	dw_serial.SetItemStatus(ilRow, 0, Primary!, NewModified!)	

	lastrow = dw_serial.Object.DataWindow.LastRowOnPage

	Execute Immediate "Begin Transaction" using SQLCA; /* 11/04 - PCONKL - Auto Commit Turned on to eliminate DB locks*/
	liRC = dw_serial.Update(True, False)
					
	If liRC = 1 Then				
						
		Execute Immediate "COMMIT" using SQLCA;	
		If SQLCA.SQLCode = 0 Then								
			li_rtn = dw_serial.ResetUpdate()							
		End If					
						
	Else
						
		Execute Immediate "ROLLBACK" using SQLCA;
		MessageBox('Invalid Serial','Unable to Save changes to records.')
		Return -1
						
	End If
					
End If

////Only auto print when all of the serials have been scanned
// lsFind = "IsNull(Upper(serial_no)) or serial_no = ''"
// llFindRow = dw_serial.Find(lsFind,1,dw_serial.RowCOunt())
// If llFindRow > 0 Then
//	ibValid = False
//	Return -1
//Else
//	ibValid = True
//End If
						
Return 0



	
end event

event close;call super::close;Destroy iuo_carton_serial_scanning
//Destroy ids_serial
end event

type st_nonserialized from statictext within w_comcast_sik
integer x = 1499
integer y = 1664
integer width = 786
integer height = 64
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = "NON-SERIALIZED"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_nonserial from u_dw_ancestor within w_comcast_sik
integer x = 137
integer y = 1736
integer width = 3657
integer height = 396
integer taborder = 30
string dataobject = "d_nonserial_comcast_sik"
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = styleraised!
end type

type dw_rma_report from datawindow within w_comcast_sik
boolean visible = false
integer x = 3470
integer y = 2164
integer width = 155
integer height = 108
integer taborder = 40
string title = "none"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_report from datawindow within w_comcast_sik
boolean visible = false
integer x = 3237
integer y = 2156
integer width = 146
integer height = 112
string title = "none"
string dataobject = "d_print_letter_comcast"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cb_reprint_letter from commandbutton within w_comcast_sik
integer x = 2459
integer y = 2188
integer width = 475
integer height = 112
integer taborder = 50
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Re-Print Letter"
end type

event clicked;Parent.TriggerEvent("ue_print_letter")
end event

type cb_cancel from commandbutton within w_comcast_sik
integer x = 1751
integer y = 2184
integer width = 471
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

event clicked;ibCancel = True
Close(Parent)
end event

type cb_ok from commandbutton within w_comcast_sik
integer x = 1033
integer y = 2188
integer width = 471
integer height = 112
integer taborder = 10
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "OK"
end type

event clicked;ibCancel = False

//Parent.TriggerEvent('ue_save')

Close(Parent)
end event

type sle_order from singlelineedit within w_comcast_sik
integer x = 741
integer y = 36
integer width = 1248
integer height = 92
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
end type

event modified;Parent.TriggerEvent('ue_retrieve')

end event

event getfocus;//08/03/2010 Jxlim When tracking order is on focus clear out the sle_serial
//sle_serial.Text =""
//sle_serial.backcolor = rgb(255,255,255)

end event

type st_order from statictext within w_comcast_sik
integer x = 41
integer y = 36
integer width = 722
integer height = 92
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Tracking ID/Order Nbr:"
boolean focusrectangle = false
end type

type dw_serial from u_dw_ancestor within w_comcast_sik
integer x = 137
integer y = 1112
integer width = 3657
integer height = 520
integer taborder = 0
string dataobject = "d_serial_comcast_sik"
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean border = false
borderstyle borderstyle = stylebox!
end type

event updatestart;call super::updatestart;//
end event

event updateend;call super::updateend;//
end event

event sqlpreview;call super::sqlpreview;//
end event

event dberror;call super::dberror;If sqldbcode = -3 Then
	messagebox('dberror', 'sqldbcode: ' + String(sqldbcode) +  '~r' +  sqlsyntax)
End if
end event

type sle_serial from singlelineedit within w_comcast_sik
integer x = 2857
integer y = 960
integer width = 1029
integer height = 96
integer taborder = 20
boolean bringtotop = true
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

event modified;Long ll_cnt, i, llfindrow, llfindrowd,   li_picking_id, llFindRown, llBatchPickID, llCount
String lsfind, ls_serial, ls_sku, lsWarehouse, lsDONO, lsQty

ibValid = False
dw_serial.SetRedraw(False)
 
ll_cnt = dw_serial.RowCount()
il_cnt = ll_cnt

dw_serial.AcceptText()

//Scan serial number
isle_serial = sle_serial
ls_serial = isle_serial.Text
ls_serial = Trim(ls_serial)

If ls_serial <> "" Then	
	isle_serial.SetFocus()
	isle_serial.SelectText(1,Len(ls_serial))	
End If

If ls_serial = "" Then
	
	If 	ll_cnt > 0 Then
		
		 lsFind = "IsNull(Upper(serial_no)) or serial_no = ''"
		 llFindRow = dw_serial.Find(lsFind,1,dw_serial.RowCOunt())
		 
		 If llFindRow > 0 Then
			isle_serial.SetFocus()
			cb_reprint_letter.Enabled = False
//			cb_reprint_label.Enabled = False	
		 Else
			 cb_reprint_letter.Enabled = True
//			 cb_reprint_label.Enabled = True
			 isle_order.SetFocus()									 
			 isle_order.SelectText(1,Len(isle_order.Text))	
		 End If
		
	End If
	
Else
	
 	If 	ll_cnt > 0 Then
			
		 lsFind = "Upper(serial_no) = '" + upper(ls_serial) + "'"
		 llFindRow = dw_serial.Find(lsFind,1,dw_serial.RowCount())		 
				 
		 If llFindRow > 0 Then
					
			doDisplayMessage('Duplicate', "This Serial Number has already been scanned!")					
			This.SetFocus()
			This.SelectText(1,Len(ls_serial))
			cb_reprint_letter.Enabled = False
//			cb_reprint_label.Enabled = False	
			
			return
					
		Else
					
			 cb_reprint_letter.Enabled = True
//			 cb_reprint_label.Enabled = True
			 This.SetFocus()
			 This.SelectText(1,Len(ls_serial))
				 
		End If
				
	End If
		
End If

//If scan serial field is not empty then check for validation.
If ls_serial <> "" Then			
	
	// 10/11 - PCONKL - Check to see if the REturn Tracking Number was just scanned
	If Upper(ls_serial) = Upper(dw_main.GEtITemString(1,'return_tracking_no')) Then
		
		ibReturnTrackingRequired = False /*no longer needed to be scanned*/
		dw_main.Modify("return_tracking_no.color=255")
		
		//Print after passing validation
		If readyToPrint() = True Then
			cb_reprint_letter.Enabled = True
//			cb_reprint_label.Enabled = True
			Parent.triggerEvent("ue_print_letter")
			wf_reset()
		End If
		
		return
		
	End If /*return tracking number scanned*/
	
	// 01/12 - PCONKL - Check to see if a SKU was scanned for a Non_Serialized Part
	If dw_nonSerial.RowCount() > 0 Then
		
		lsFind = "Upper(Sku) = '" + upper(ls_serial) + "'"
		llFindRow = dw_nonSerial.Find(lsFind,1,dw_NonSerial.RowCount())
		
		If llFindRow > 0 Then /*SKU scanned*/
		
			If dw_nonSerial.GetITemNUmber(llFindRow,'scanned_Qty') < dw_nonSerial.GetITemNUmber(llFindRow,'alloc_qty') Then /* not all yet scanned */
			
				dw_nonSerial.SetItem(llFindRow,'scanned_qty',dw_nonSerial.GetITemNUmber(llFindRow,'scanned_Qty') + 1) /*bump up scanned Qty*/
				
				//Save to DB (DD.UF3)
				lsDONO = dw_Main.GetITemString(1,'do_no')
				lsQty = String(dw_nonSerial.GetITemNUmber(llFindRow,'scanned_Qty'))
				
				Execute Immediate "Begin Transaction" using SQLCA;
			
				Update Delivery_Detail
				Set User_Field3 = :lsQty
				Where do_no = :lsDONO and sku = :ls_Serial;
						
				Execute Immediate "COMMIT" using SQLCA;	
				
				//Print after passing validation
				If readyToPrint() = True Then
					cb_reprint_letter.Enabled = True
//					cb_reprint_label.Enabled = True
					Parent.triggerEvent("ue_print_letter")
					wf_reset()
				End If
		
				return
				
			Else /* Already all scanned*/
				
				This.SetFocus()
		 		This.SelectText(1,Len(ls_serial))
				 doDisplayMessage('', "THIS SKU HAS BEEN COMPLETELY SCANNED! DO NOT INCLUDE!")
				 Return	
				 
			End IF /*All scanned? */
			
		Else /* Sku Not found*/
			
			//If there are no Serialzed parts, then they must be scanning a SKU and it is invalid*/
			If dw_serial.RowCount() = 0 Then
				 doDisplayMessage('Invalid SKU', "SKU not found on order!")
				 Return
			End If
				
		End If /* SKU Scanned? */
				
	End If /* Non Serialized exist */

	//SARUN : 06June2012 Adding filter SKU to the below SQL 	to avoid serial assoicated with other SKU, After this SQL will look for only sku in order.
	
	lsDONO = dw_Main.GetITemString(1,'do_no')
	
	Select Max(sku) Into :ls_sku
	From carton_serial
	Where Project_id = 'COMCAST'
	And serial_no = :ls_serial
	and sku in (Select distinct dpd.sku from delivery_picking_detail dpd,item_master im where dpd.sku = im.sku and dpd.do_no = :lsDONO and im.Serialized_Ind in ('O','B'))
	Using SQLCA;	
	
	/*	
	//Get the Sku from carton serial with the scan serial number
	Select Max(sku) Into :ls_sku
	From carton_serial
	Where Project_id = 'COMCAST'
	And serial_no = :ls_serial
	Using SQLCA;	
   */
	
	//SARUN : 06June2012 End
	
	//If sku not found from carton serial it is an error
	If ls_sku = '' or IsNull(ls_sku) Then
		
		This.SetFocus()
		 This.SelectText(1,Len(ls_serial))
		 doDisplayMessage('Invalid Serial', "The scanned serial is not valid.  Please scan again!")
		 Return						 
		 
	Else /*Sku Found in Carton Serial*/
		
		//If sku found from carton serial, look for sku on the detail serial from the given ls_sku
		lsFind = "Upper(sku) = '" + upper(ls_sku) + "'"
		llFindRow = dw_serial.Find(lsFind,1,dw_serial.RowCount())
								
		If llfindRow > 0 Then
			
			lsFind += "And Upper(serial_no) = '" + upper(ls_serial) + "'"
			llFindRow = dw_serial.Find(lsFind,1,dw_serial.RowCount())
									
			//If serial number is found on detail serial 
			If llfindRow > 0 Then 
				
				  //If serial number is found on detail serial don't have to print automatically but enabled reprint button								
				  This.backcolor = rgb(255,255,255)
				  This.SetFocus()
				  This.SelectText(1,Len(ls_serial))
				  cb_reprint_letter.Enabled = True
//				  cb_reprint_label.Enabled = True
				 //If serial number is not found on serial detail then update the serial from carton serial
			Else							
											
				//Find the first empty serial row for this scan. 
				lsFind = "Upper(sku) = '" + Upper(ls_sku) + "' and (isnull(serial_no) or serial_no = '')"
				llFindRown = dw_serial.Find(lsFind,1,dw_serial.RowCount())
				ilRow = llFindRown
				
				//If serial number not already exist in dw_serial then allow to insert
				If llFindRown > 0 Then	
					
						lsFind = "Upper(sku) = '" + Upper(ls_sku) + "' and Upper(serial_no) = '" + Upper(ls_serial)+ "'"
						//nextrow
						llFindRow = dw_serial.Find(lsFind, llFindRown, dw_serial.RowCount())		
														
						//If serial number already exist in dw_serial then not allow to insert
						If llFindRow > 0 Then	
							
							This.SetFocus()
							This.SelectText(1,Len(ls_serial))
							doDisplayMessage('', "This Serial Number has already been scanned on this order!")
							Return	
							
						//If serial number not already exist in dw_serial then allow to insert	
						Else																
							
							// 09/11 - PCONKL - We also need to validate that this serial number hasn't been scanned on any other order. Limiting it to open orders and current batch if order is on a batch
							llBatchPickID = dw_main.GetITemNumber(1,'batch_pick_id')
							lswarehouse = dw_Main.GetITemString(1,'wh_code')
							
							If isnull(llBatchPickID) then llBatchPickID = 0
							
							llCount = 0
							
							If llBatchPickID > 0 Then
								
								Select Count(1) into :llCount
								from delivery_master with (nolock), Delivery_Picking_Detail with (nolock) , Delivery_serial_Detail with (nolock)
								Where Delivery_MAster.do_no = Delivery_Picking_Detail.do_no and Delivery_picking_Detail.id_no = delivery_serial_Detail.id_no and 
								project_id = 'Comcast' and wh_code = :lsWarehouse and    batch_pick_id = :llBatchPickID and sku = :ls_sku and delivery_serial_detail.serial_no= :ls_serial;
								
							Else /*not in a batch, check all open orders*/
								
								Select Count(1) into :llCount
								from delivery_master with (nolock), Delivery_Picking_Detail with (nolock) , Delivery_serial_Detail with (nolock)
								Where Delivery_MAster.do_no = Delivery_Picking_Detail.do_no and Delivery_picking_Detail.id_no = delivery_serial_Detail.id_no and 
								project_id = 'Comcast' and wh_code = :lsWarehouse and   ord_status not in ('C', 'V')  and sku = :ls_sku and delivery_serial_detail.serial_no= :ls_serial;
								
							End If
							
							If llCount > 0 Then
								
								doDisplayMessage('', "This Serial Number has already been scanned                               *** ON ANOTHER ORDER! **")
								Return
								
							End If
							
							li_picking_id = dw_serial.GetItemNumber(llFindRown, 'delivery_picking_detail_id_no')	
							dw_serial.ScrollToRow(llFindRown)																
							dw_serial.SetItem(llFindRown, 'serial_no',ls_serial)
							dw_serial.SetItem(llFindRown, 'id_no', li_picking_id)
							dw_serial.SetItem(llFindRown, 'quantity', 1)	
							
						End If
															
					Else	
						
						This.SetFocus()
						This.SelectText(1,Len(ls_serial))
						doDisplayMessage('', "This record  already contains a Serial Number!")
						Return														
						
					End If				
											
					Parent.Trigger event ue_save()	
					This.backcolor = rgb(0,255,0)	
												
				End If
											
			//This sku for this scanned serial is not listed on the serial dw.
			Else
				
				 doDisplayMessage('Invalid Serial', "The scanned serial is not valid for this sku, Please scan again!")
				 Return
				This.SetFocus()
				This.SelectText(1,Len(ls_serial))
				
			End If
			
		End If
		
End If /*Serial SLE populated */

dw_serial.SetRedraw(True)		

//Print after passing validation
// 10/11 - PCONKL - Dont print letter if Return Tracking Number still needs to be scanned

//If (ibValid = True) and (not ibReturnTrackingRequired) Then
If readyToPrint() = True Then
	cb_reprint_letter.Enabled = True
//	cb_reprint_label.Enabled = True
	Parent.triggerEvent("ue_print_letter")
	wf_reset()
End If


end event

type dw_main from u_dw_ancestor within w_comcast_sik
integer x = 37
integer y = 132
integer width = 3895
integer height = 816
integer taborder = 0
string dataobject = "d_shipto_comcast_sik"
boolean border = false
borderstyle borderstyle = stylebox!
end type

type st_serial from statictext within w_comcast_sik
integer x = 1998
integer y = 972
integer width = 832
integer height = 80
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Scanned Serial No:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_serialized from statictext within w_comcast_sik
integer x = 1499
integer y = 1036
integer width = 786
integer height = 64
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = "SERIALIZED"
alignment alignment = center!
boolean focusrectangle = false
end type

