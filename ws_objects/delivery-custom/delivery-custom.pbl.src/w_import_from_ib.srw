$PBExportHeader$w_import_from_ib.srw
$PBExportComments$Allow import into delivery detail from receive putaway
forward
global type w_import_from_ib from w_response_ancestor
end type
type sle_order from singlelineedit within w_import_from_ib
end type
type st_message from statictext within w_import_from_ib
end type
type cbx_1 from checkbox within w_import_from_ib
end type
type cb_1 from commandbutton within w_import_from_ib
end type
end forward

global type w_import_from_ib from w_response_ancestor
integer width = 1650
integer height = 648
string title = "Import from Inbound Order"
event type integer ue_copy_ro_by_ord ( )
event type integer ue_copy_ro_by_rono ( )
sle_order sle_order
st_message st_message
cbx_1 cbx_1
cb_1 cb_1
end type
global w_import_from_ib w_import_from_ib

type variables
String isOrderNo = ''
Long llRowCount
Datastore idsROMaster, idsRODetail, idsROPutaway, idsDODetail, idsRoNo

end variables

event type integer ue_copy_ro_by_ord();// Copy detail records from receive order to delivery detail by querying by order number.
String lsMessage, lsRoNo, lsDoNo, lsFind, lsFindRow, lsSku, lsSuppCode, lsAlternateSku 
String lsLotNo, lsPoNo, lsPoNo2
Int ilMasterCount, ilRoNoRow, ilDoNoRow, ilRoDetailRow, ilRoPutawayCount, ilLineItemNo
Int ilResult, ilRoPutawayRow, ilRoDetailCount
Long llFindRow, llDetailQty, llRoQty, llOwnerId
Boolean ibMerge
datawindow idw_detail

idw_detail = w_do.tab_main.tabpage_detail.dw_detail
ilLineItemNo = 0
ibMerge = False

ilLineItemNo = idw_detail.rowcount( )		// Detail row can be added to detail list

idsROMaster = create datastore
idsRODetail = create datastore
idsROPutaway = create datastore

idsRODetail.reset()
idsRODetail.dataobject = 'd_ro_detail'
idsRODetail.SetTransObject(SQLCA)

idsROPutaway.reset()
idsROPutaway.dataobject = 'd_ro_putaway'
idsROPutaway.SetTransObject(SQLCA)

//Process each order and add detail sku,supp_code,owner_id, alternate_sku
for ilRoNoRow = 1 to llRowCount
	lsRoNo = idsRoNo.getitemstring(ilRoNoRow, 1)
	ilRoDetailCount = idsRODetail.Retrieve(lsRoNo)
	ilRoPutawayCount = idsROPutaway.Retrieve(lsRoNo, gs_project)
	ibMerge = False
	
	// build detail record from received order putaway list
	For ilRoPutawayRow = 1 to ilRoPutawayCount			//sku,supp_code,owner_id, alternate_sku
			lsFind = 'Line_Item_No = ' + String(idsROPutaway.getitemNumber(ilRoPutawayRow,"line_item_no"))
			ilRoDetailRow = idsRODetail.Find(lsFind, 1 , ilRoDetailCount)
			
			lsSku = idsRoPutaway.getitemstring(ilRoPutawayRow,"sku")
			lsSuppCode = idsRoPutaway.getitemstring(ilRoPutawayRow,"supp_code")
			llOwnerId = idsRoPutaway.getitemNumber(ilRoPutawayRow,"owner_id") 
			lsAlternateSku =  idsRODetail.getItemstring(ilRoDetailRow,"alternate_sku")
			If cbx_1.checked = True Then
				lsLotNo = idsRoPutaway.getItemString(ilRoPutawayRow,"lot_no")
				lsPoNo = idsRoPutaway.getItemString(ilRoPutawayRow,"po_no")
				lsPoNo2 = idsRoPutaway.getItemString(ilRoPutawayRow,"po_no2")
			End If
			
			ilDoNoRow = idw_detail.InsertRow(0)
			ilLineItemNo ++
			lsDoNo = w_do.tab_main.tabpage_main.dw_main.getitemstring(1,"do_no")
			idw_detail.setitem(ilDoNoRow, "do_no",w_do.tab_main.tabpage_main.dw_main.getitemstring(1,"do_no"))
			idw_detail.setitem(ilDoNoRow, "line_item_no", ilLineItemNo) 
			idw_detail.setitem(ilDoNoRow, "sku", lsSku)
			idw_detail.setitem(ilDoNoRow, "supp_code", lsSuppCode)
			idw_detail.setitem(ilDoNoRow, "owner_id", llOwnerId)
			idw_detail.setitem(ilDoNoRow, "req_qty",idsROPutaway.getitemNumber(ilRoPutawayRow,"quantity"))
			idw_detail.setitem(ilDoNoRow, "alternate_sku", lsAlternateSku)
			idw_detail.setitem(ilDoNoRow, "uom",idsRODetail.getitemstring(ilRoDetailRow,"uom"))
			idw_detail.setitem(ilDoNoRow, "cost",idsRODetail.getitemNumber(ilRoDetailRow,"cost"))
			idw_detail.setitem(ilDoNoRow, "user_line_item_no",idsROPutaway.getitemstring(ilRoPutawayRow,"user_line_item_no"))
			idw_detail.setitem(ilDoNoRow, "project_id", gs_Project)
			idw_detail.setitem(ilDoNoRow, "currency_code",idsRODetail.getitemstring(ilRoDetailRow,"currency_code"))
			idw_detail.setitem(ilDoNoRow, "pick_lot_no", lsLotNo)
			idw_detail.setitem(ilDoNoRow, "pick_po_no", lsPoNo)
			idw_detail.setitem(ilDoNoRow, "pick_po_no2", lsPoNo2)
	next
next

If idw_detail.ModifiedCount() > 0 Then
	w_do.TriggerEvent("ue_save")
End If



return 0
end event

event type integer ue_copy_ro_by_rono();// Copy detail records from receive order to delivery detail by querying by order number.
String lsMessage, lsRoNo, lsDoNo, lsFind, lsFindRow, lsSku, lsSuppCode, lsAlternateSku 
String lsLotNo, lsPoNo, lsPoNo2
Int ilMasterCount, ilRoNoRow, ilDoNoRow, ilRoDetailRow, ilRoDetailCount, ilLineItemNo
Int ilResult, ilRoPutawayRow, ilRoPutawayCount
Long llFindRow, llDetailQty, llRoQty, llOwnerId
Boolean ibMerge
datawindow idw_detail

idw_detail = w_do.tab_main.tabpage_detail.dw_detail
ilLineItemNo = 0
ibMerge = False

ilLineItemNo = idw_detail.rowcount( )		// Detail row can be added to detail list

idsROMaster = create datastore
idsRODetail = create datastore
idsROPutaway = create datastore

idsRODetail.reset()
idsRODetail.dataobject = 'd_ro_detail'
idsRODetail.SetTransObject(SQLCA)

idsROPutaway.reset()
idsROPutaway.dataobject = 'd_ro_putaway'
idsROPutaway.SetTransObject(SQLCA)

lsRoNo =  Trim(sle_order.text)
ilRoDetailCount = idsRODetail.Retrieve(lsRoNo)
ilRoPutawayCount = idsROPutaway.Retrieve(lsRoNo, gs_project)

	// build detail record from received order putaway list
	For ilRoPutawayRow = 1 to ilRoPutawayCount			//sku,supp_code,owner_id, alternate_sku
			lsFind = 'Line_Item_No = ' + String(idsROPutaway.getitemNumber(ilRoPutawayRow,"line_item_no"))
			ilRoDetailRow = idsRODetail.Find(lsFind, 1 , ilRoDetailCount)
			
			lsSku = idsRoPutaway.getitemstring(ilRoPutawayRow,"sku")
			lsSuppCode = idsRoPutaway.getitemstring(ilRoPutawayRow,"supp_code")
			llOwnerId = idsRoPutaway.getitemNumber(ilRoPutawayRow,"owner_id") 
			lsAlternateSku =  idsRODetail.getItemstring(ilRoDetailRow,"alternate_sku")
			If cbx_1.checked = True Then
				lsLotNo = idsRoPutaway.getItemString(ilRoPutawayRow,"lot_no")
				lsPoNo = idsRoPutaway.getItemString(ilRoPutawayRow,"po_no")
				lsPoNo2 = idsRoPutaway.getItemString(ilRoPutawayRow,"po_no2")
			End If
			
			ilDoNoRow = idw_detail.InsertRow(0)
			ilLineItemNo ++
			lsDoNo = w_do.tab_main.tabpage_main.dw_main.getitemstring(1,"do_no")
			idw_detail.setitem(ilDoNoRow, "do_no",w_do.tab_main.tabpage_main.dw_main.getitemstring(1,"do_no"))
			idw_detail.setitem(ilDoNoRow, "line_item_no", ilLineItemNo) 
			idw_detail.setitem(ilDoNoRow, "sku", lsSku)
			idw_detail.setitem(ilDoNoRow, "supp_code", lsSuppCode)
			idw_detail.setitem(ilDoNoRow, "owner_id", llOwnerId)
			idw_detail.setitem(ilDoNoRow, "req_qty",idsROPutaway.getitemNumber(ilRoPutawayRow,"quantity"))
			idw_detail.setitem(ilDoNoRow, "alternate_sku", lsAlternateSku)
			idw_detail.setitem(ilDoNoRow, "uom",idsRODetail.getitemstring(ilRoDetailRow,"uom"))
			idw_detail.setitem(ilDoNoRow, "cost",idsRODetail.getitemNumber(ilRoDetailRow,"cost"))
			idw_detail.setitem(ilDoNoRow, "user_line_item_no",idsROPutaway.getitemstring(ilRoPutawayRow,"user_line_item_no"))
			idw_detail.setitem(ilDoNoRow, "project_id", gs_Project)
			idw_detail.setitem(ilDoNoRow, "currency_code",idsRODetail.getitemstring(ilRoDetailRow,"currency_code"))
			idw_detail.setitem(ilDoNoRow, "pick_lot_no", lsLotNo)
			idw_detail.setitem(ilDoNoRow, "pick_po_no", lsPoNo)
			idw_detail.setitem(ilDoNoRow, "pick_po_no2", lsPoNo2)
	next

	If idw_detail.ModifiedCount() > 0 Then
	w_do.TriggerEvent("ue_save")
	
Else
	lsMessage = "Could not retreve receive order with system order #" + lsRoNo
	messagebox("Import from Inbound Order", lsMessage)
End If





return 0
end event

on w_import_from_ib.create
int iCurrent
call super::create
this.sle_order=create sle_order
this.st_message=create st_message
this.cbx_1=create cbx_1
this.cb_1=create cb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_order
this.Control[iCurrent+2]=this.st_message
this.Control[iCurrent+3]=this.cbx_1
this.Control[iCurrent+4]=this.cb_1
end on

on w_import_from_ib.destroy
call super::destroy
destroy(this.sle_order)
destroy(this.st_message)
destroy(this.cbx_1)
destroy(this.cb_1)
end on

type cb_cancel from w_response_ancestor`cb_cancel within w_import_from_ib
integer x = 896
integer y = 428
end type

type cb_ok from w_response_ancestor`cb_ok within w_import_from_ib
boolean visible = false
integer x = 462
integer y = 424
boolean enabled = false
boolean default = false
end type

event cb_ok::constructor;call super::constructor;SetFocus(sle_order)

end event

type sle_order from singlelineedit within w_import_from_ib
integer x = 55
integer y = 144
integer width = 1408
integer height = 112
integer taborder = 10
boolean bringtotop = true
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

type st_message from statictext within w_import_from_ib
integer x = 55
integer y = 56
integer width = 1550
integer height = 92
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Enter Order Number or System Number (RONO):"
boolean focusrectangle = false
end type

type cbx_1 from checkbox within w_import_from_ib
integer x = 187
integer y = 308
integer width = 1198
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Pick only received Inventory Attributes"
end type

type cb_1 from commandbutton within w_import_from_ib
integer x = 462
integer y = 428
integer width = 270
integer height = 108
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "OK"
boolean default = true
end type

event clicked;/* Expect an inbound supp_invoice_no or ro_no.  Query receive_putaway to construct delivery_detail record.  */
/* Check for RO_No:  First five characters are the project_id.  If order number, check for multiple order and raise a warning to enter an RO_No. */
Int liResult
String lsSQLSelect, lsSyntax, lsErrorSyntax, lsErrorCreate

liResult = 0

isOrderNo = Trim(sle_order.text)
if trim(isOrderNo) = '' then
	SetFocus(sle_order)
	Return
end if

lsSQLSelect = "select ro_no from receive_master where project_id = '" + gs_Project + "' and supp_invoice_no = '" + isOrderNo + "' and ord_status = 'C'"

If LEFT(UPPER(isOrderNo),3) = LEFT(UPPER(gs_project),3) Then
	Select Count(*) into :llRowCount
	FROM Receive_Master
	WHERE project_id = :gs_project AND RO_No = :isOrderNo and ord_status = 'C';

	If llRowCount = 0 Then
		messagebox("Receive Order not found","The requested system receive order number~r~nwas not found.  Ensure order is complete. ~r~nPlease try again.")
		SetFocus(sle_order)
		Return
	Else
		Parent.TriggerEvent("ue_copy_ro_by_rono")
	End If

Else
	idsRoNo = create datastore 
	lsSyntax = sqlca.syntaxfromsql( lsSQLSelect, 'style(type=grid)', lsErrorSyntax)
	liResult = idsRoNo.create(lsSyntax, lsErrorCreate)    
	idsRoNo.SetTransObject(SQLCA)
	llRowCount = idsRoNo.retrieve()
	
	If llRowCount = 0 Then	
		messagebox("Receive Order not found","The requested system receive order number~r~nwas not found.  Ensure order is complete. ~r~nPlease try again.")
		SetFocus(sle_order)
		Return
	ElseIf llRowCount = 1 Then
		liResult = Parent.TriggerEvent("ue_copy_ro_by_ord")
	Else	
		If messagebox("Receive Order", "There are " + string(llRowCount) + " records for Order #" + isOrderNo + "~r~n" + &
				"If you proceed, all detail records will be copied.~r~nYes to proceed, No to cancel", Question!, YesNo!) = 1 Then
			liResult = Parent.TriggerEvent("ue_copy_ro_by_ord")
		Else
			sle_order.text = ''
			SetFocus(sle_order)
			Return
		End If
		
	End If
End If

parent.TriggerEvent("ue_close")


end event

