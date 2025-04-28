$PBExportHeader$w_license_labels.srw
$PBExportComments$License Plate Labels
forward
global type w_license_labels from w_main_ancestor
end type
type cb_print from commandbutton within w_license_labels
end type
type dw_label from u_dw_ancestor within w_license_labels
end type
type cb_selectall from commandbutton within w_license_labels
end type
type cb_1 from commandbutton within w_license_labels
end type
type rb_rono from radiobutton within w_license_labels
end type
type rb_container from radiobutton within w_license_labels
end type
type sle_retrieve from singlelineedit within w_license_labels
end type
type st_1 from statictext within w_license_labels
end type
type gb_1 from groupbox within w_license_labels
end type
end forward

global type w_license_labels from w_main_ancestor
integer width = 3410
integer height = 1852
string title = "License Plate labels"
event ue_print ( )
event ue_rema_print ( )
cb_print cb_print
dw_label dw_label
cb_selectall cb_selectall
cb_1 cb_1
rb_rono rb_rono
rb_container rb_container
sle_retrieve sle_retrieve
st_1 st_1
gb_1 gb_1
end type
global w_license_labels w_license_labels

type variables

n_labels	invo_labels

constant int success = 0
constant int failure = -1

String is_ro_or_wo
String	isOrigSQL
end variables

forward prototypes
public function integer uf_dolam (ref any _anyparm)
end prototypes

event ue_print();Str_Parms	lstrParms
Long	llQty,	&
		llRowCount,	&
		llRowPos, llPrintCount, llPrintPos
		
Any	lsAny

String	lsFormat,	&
			lsUOM, 	&
			lsPrinterInfo, lsPrinter, lsLotLabel, lsPOLabel, lsPO2Label
Integer	liRC

Dw_Label.AcceptText()

//  If we have a default printer for license plate labels, Load now
lsPrinter = ProfileString(gs_iniFile,'PRINTERS','ZEBRALICENSEPLATE','')
If lsPrinter > '' Then PrintSetPrinter(lsPrinter)

//Get printer and Qty
lstrParms.String_arg[1] = "License Tag Label"
lstrParms.Long_arg[1] = 1 /*default qty on print options*/
OpenWithParm(w_label_print_options,lstrParms)

lstrParms = Message.PowerObjectParm
If lstrParms.Cancelled Then Return

lsPrinterInfo = lstrParms.String_arg[1]

IF Upper(gs_project) = "LOGITECH" THEN

		lsFormat = invo_labels.uf_read_label_Format("Logitech_Zebra_License_Tag.DWN")

ELSE
//TAM 11/01/2010 Added NYCSP
IF Upper(gs_project) = "NYCSP" THEN

		lsFormat = invo_labels.uf_read_label_Format("NYCSP_Zebra_License_Tag.txt")

ELSE

		//Load the format - only need to retrieve once - will pass to print routine
		CHOOSE CASE  Right(lsPrinterInfo,1) 
			Case "Z" 
			//	lsFormat = invo_labels.uf_read_label_Format("Zebra_License_Tag.DWN")
				lsFormat = invo_labels.uf_read_label_Format("Zebra_License_Plate.txt") /* 04/16 - PCONKL - new baseline format*/
			Case "I"
				lsFormat = invo_labels.uf_read_label_Format("Intermec_License_Tag.DWN") 
			Case Else 
				Messagebox('Labels', 'Printer TYPE not specified. Labels will not be printed')
				Return //Format not loaded
		end choose

	END IF
END IF

llQty = lstrParms.Long_arg[1] /*Number of copies from Setup window*/
	
//retrieve any custom column labels (based on Putaway)
select column_label into :lsLotLabel from column_label 
where project_id = :gs_project and datawindow = 'd_ro_putaway' and column_name = 'lot_no';

select column_label into :lsPOLabel from column_label 
where project_id = :gs_project and datawindow = 'd_ro_putaway' and column_name = 'po_no';

select column_label into :lsPO2Label from column_label 
where project_id = :gs_project and datawindow = 'd_ro_putaway' and column_name = 'po_no2';

If isNull(lsLotLabel) or lsLotLabel = '' Then
	lsLotLabel = 'Lot No:'
End If

If pos(lsLotLabel,"~~r") > 0 Then
	lsLotLabel = replace(lsLotLabel,pos(lsLotLabel,"~~r") ,2," ")
End If

If isNull(lsPOLabel) or lsPOLabel = '' Then
	lsPOLabel = 'Po No:'
End If

If pos(lsPOLabel,"~~r") > 0 Then
	lsPOLabel = replace(lsPOLabel,pos(lsPOLabel,"~~r") ,2," ")
End If

If isNull(lsPO2Label) or lsPO2Label = '' Then
	lsPO2Label = 'Po No2:'
End If

If pos(lsPO2Label,"~~r") > 0 Then
	lsPO2Label = replace(lsPO2Label,pos(lsPO2Label,"~~r") ,2," ")
End If

//Print each detail Row 
llRowCount = dw_label.RowCount()

For llRowPos = 1 to llRowCount /*each detail row */
	
	//If not selected for Printing, continue with next row
	If dw_label.GetITemString(llRowPos,'c_Print_Ind') <> 'Y' Then Continue
	
	//Loop once for number of copies
	llPrintCount = dw_Label.GetITemNumber(llRowPos, 'c_Copies')
	For llPrintPos = 1 to llPrintCount
		
		lstrParms.String_arg[1] = lsFormat /*DAT file */
		
		//26-APR-2018 :Madhu S18747 Exp Date - START
		//03-MAR-2020:MikeA  S43301 F21617 - KDO-Kendo: Remove Expiration Date from LPN
		If upper(gs_project) ='REMA' OR upper(gs_project) ='KENDO' Then
			lstrParms.string_arg[2] ="" //don't print Exp Date.
		else
			lstrParms.String_arg[2] = dw_label.object.c_exp_date[llRowPos] /* Exp DAte*/ 
		End If
		//26-APR-2018 :Madhu S18747 Exp Date - END
		
		// For all but the last label, use the carton qty, if last, use partial if it exists
		If llPrintPos < llPrintCount Then
			lstrParms.String_arg[3] = String(dw_label.GetItemNumber(llRowPos,'qty_2'),'#######.#####') 
		Else
			If dw_label.GetITemNumber(llRowPos,'c_partial_qty') > 0 Then
				lstrParms.String_arg[3] = String(dw_label.GetItemNumber(llRowPos,'c_partial_qty'),'#######.#####')
			Else
				lstrParms.String_arg[3] = String(dw_label.GetItemNumber(llRowPos,'qty_2'),'#######.#####') 
			End If
		End If
		
		//lstrParms.String_arg[3] = String(dw_label.GetItemNumber(llRowPos,'quantity'),'#######.#####') 
	
		lstrParms.String_arg[4] = dw_label.GetItemString(llRowPos,'SKU') /* SKU */
	
		If dw_label.GetItemString(llRowPos,'lot_no') <> '-' Then 
			lstrParms.String_arg[5] = lsLotLabel + ": " + dw_label.GetItemString(llRowPos,'lot_no') /* ID #*/ 
		Else
			lstrParms.String_arg[5] = ""
		End If
		
		lstrParms.String_arg[6] = dw_label.GetItemString(llRowPos,'container_Id') /* Container ID */

		If isnull(dw_label.GetItemString(llRowPos,'UOM')) Then
			lsUOM = 'EA'
		Else
			lsUOM = dw_label.GetItemString(llRowPos,'UOM')
		End If
	
		lstrParms.String_arg[7] = lsUOM /*Unit of Measure*/
		lstrParms.String_arg[8] = dw_label.GetItemString(llRowPos,'l_Code') /* location */
		lstrParms.String_arg[9] = dw_label.GetItemString(llRowPos,'description') /* Description */
	
		// 04/16 - PCONKL - Added PO, PO2 and Inv Type and Order Nbr
	
		If dw_label.GetItemString(llRowPos,'po_no') <> '-' Then
			lstrParms.String_arg[14] = lsPoLabel + ": " + dw_label.GetItemString(llRowPos,'po_no') /* po_no */
		Else
			lstrParms.String_arg[14] = ""
		End If

		//26-APR-2018 :GailM S18652 if Rema plug AltSKU into PoNo2 - START
		If upper(gs_project) = 'REMA' Then
				lstrParms.String_arg[15] = "AltSKU: " + dw_label.GetItemString(llRowPos, 'alternate_sku' ) /*Alt SKU */
		Else	
			If dw_label.GetItemString(llRowPos,'po_no2') <> '-' Then
				lstrParms.String_arg[15] =  lsPo2Label + ": " +  dw_label.GetItemString(llRowPos,'po_no2') /* po_no2 */
			Else
				lstrParms.String_arg[15] = ""
			End If
		End If
		//30-APR-2018 :GailM S18652 AltSku - END
	
		//14-MAY-2019 :Madhu S33323 Remove Inv Type
		IF upper(gs_project) ='REMA' THEN
			lstrParms.String_arg[16] = "" //don't print Inv Type
		ELSE		
			lstrParms.String_arg[16] = dw_label.GetItemString(llRowPos,'inv_type_desc') /* Inv Type */
		END IF
		
		lstrParms.String_arg[17] = dw_label.GetItemString(llRowPos,'supp_invoice_no') /* order Nbr */
	
		lstrParms.Long_arg[1] = llQty /*Copies to Print*/
		
		// pvh - 11.25.09 LAM-SG 
		Choose case Upper(gs_project)
			
			case "LAM-SG"
			
				Any anyParm
				string theSerial
				theSerial = dw_label.object.serial_no[llRowPos]
				lstrParms.String_arg[1] =  invo_labels.uf_read_label_Format("LAM-SGLicenseTag.txt")
				lstrParms.String_arg[10] = dw_label.GetItemString(llRowPos,'serial_no')

				anyParm = lstrParms
				liRC = invo_labels.uf_license_tag_lam(lstrParms)

			case "LOGITECH"
			
				String ls_sku, ls_ro_no, ls_container_ID, ls_inventory_type
				String ls_supp_code, ls_lot_no, ls_po_no
				Datetime ldt_expiration_date
		
				ls_sku = dw_label.GetItemString(llRowPos,'sku') 
				ls_supp_code = dw_label.GetItemString(llRowPos,'supp_code') 
				ls_ro_no = dw_label.GetItemString(llRowPos,'ro_no') 
				ls_inventory_type = dw_label.GetItemString(llRowPos,'inventory_type') 

				SELECT Container_ID, Lot_No, Expiration_Date, Po_No 
				INTO :ls_container_id, :ls_lot_no, :ldt_expiration_date, :ls_po_no
				FROM Content
				WHERE SKU = :ls_sku AND
						SUPP_CODE = :ls_supp_code AND
						RO_NO = :ls_ro_no AND 
						INVENTORY_TYPE = :ls_inventory_type AND 
						PROJECT_ID = 'LOGITECH' USING SQLCA;
						
				if SQLCA.SQLCode <> 0 then
					MessageBOx ("DB Error", SQLCA.SQLErrText )
			
					lstrParms.String_arg[2] = " " 
				end if
				
				lstrParms.String_arg[5] = ls_lot_no
				lstrParms.String_arg[2] = string(ldt_expiration_date, '[shortdate]')
				lstrParms.String_arg[6] = ls_container_id
				lstrParms.String_arg[10] = String(dw_label.GetItemNumber(llRowPos,'part_upc_code') )
				lstrParms.String_arg[11] = dw_label.GetItemString(llRowPos,'user_field6') 
				lstrParms.String_arg[12] = dw_label.GetItemString(llRowPos,'user_field7') 
				lstrParms.String_arg[13] = ls_po_no 

				If IsNull(lstrParms.String_arg[10]) then lstrParms.String_arg[10] = " "
				If IsNull(lstrParms.String_arg[11]) then lstrParms.String_arg[11] = " "
				If IsNull(lstrParms.String_arg[12]) then lstrParms.String_arg[12] = " "
				If IsNull(lstrParms.String_arg[13]) then lstrParms.String_arg[13] = " "
				lsAny = lstrParms
				liRC = invo_labels.uf_license_tag_logitech(lstrParms)

			case ELSE

				lsAny = lstrParms
		
				CHOOSE CASE  Right(lsPrinterInfo,1) 
					Case "Z" 
						liRC = invo_labels.uf_license_tag_zebra(lsAny)
					Case "I"
							liRC = invo_labels.uf_license_tag_intermec(lsAny)
				Case Else 
						Messagebox('Labels', 'Unable to Parse Label file. Labels will not be printed')
						Return //Format not loaded
				end choose
		
		END CHOOSE
		
	Next /*print copy*/
	
	dw_label.SetItem(llRowPos,'c_Print_Ind','N') 
	
	If liRC < 0 Then Exit
	
Next /*detail row to Print*/

// We want to store the last printer used for Printing the license plate
lsPrinter = PrintGetPrinter()
SetProfileString(gs_inifile,'PRINTERS','ZEBRALICENSEPLATE',lsPrinter)









end event

event ue_rema_print();//06-SEP-2018 :Madhu S23455 REMA Inventory Placards

Long	ll_New_Row, llRowCount,	llRowPos, llPrintCount, llPrintPos
string lsPrinter

dw_label.accepttext( )

Datastore ldsPlacard

ldsPlacard = create Datastore
ldsPlacard.dataobject='d_rema_license_placard'
ldsPlacard.settransobject( SQLCA)

lsPrinter = ProfileString(gs_iniFile,'PRINTERS','PACKLIST','')
If lsPrinter > '' Then PrintSetPrinter(lsPrinter)

llRowCount = dw_label.RowCount()

For llRowPos = 1 to llRowCount

	//If not selected for Printing, continue with next row
	If dw_label.getItemString(llRowPos,'c_Print_Ind') <> 'Y' Then Continue
	
	//Loop once for number of copies
	llPrintCount = dw_Label.getItemNumber(llRowPos, 'c_Copies')
	
	For llPrintPos = 1 to llPrintCount
	
		ll_New_Row = ldsPlacard.insertrow( 0)
		
		ldsPlacard.setItem( ll_New_Row, 'container_id', dw_label.getItemString(llRowPos,'container_Id'))
		ldsPlacard.setItem( ll_New_Row, 'order_no', dw_label.getItemString(llRowPos,'supp_invoice_no'))
		
		IF isnull(dw_label.getItemString(llRowPos,'UOM')) THEN
			ldsPlacard.setItem( ll_New_Row, 'uom', 'EA')
		ELSE
			ldsPlacard.setItem( ll_New_Row, 'uom', dw_label.getItemString(llRowPos,'UOM'))
		END IF
		
		ldsPlacard.setItem( ll_New_Row, 'description', dw_label.getItemString(llRowPos,'description'))
		ldsPlacard.setItem( ll_New_Row, 'inventory_type', dw_label.getItemString(llRowPos,'inv_type_desc'))
		ldsPlacard.setItem( ll_New_Row, 'location', dw_label.getItemString(llRowPos,'l_Code'))
		ldsPlacard.setItem( ll_New_Row, 'lot_no', dw_label.getItemString(llRowPos,'lot_no'))
		ldsPlacard.setItem( ll_New_Row, 'alt_sku', dw_label.getItemString(llRowPos,'alternate_sku'))	//DE6728
		ldsPlacard.setItem( ll_New_Row, 'exp_date', 'N/A')
		ldsPlacard.setItem( ll_New_Row, 'sku', dw_label.getItemString(llRowPos,'SKU'))
		
		// For all but the last label, use the carton qty, if last, use partial if it exists
		IF llPrintPos < llPrintCount THEN
			ldsPlacard.setItem( ll_New_Row, 'qty', dw_label.getItemNumber(llRowPos,'qty_2'))
			ldsPlacard.setItem( ll_New_Row, 'pallet_qty', dw_label.getItemNumber(llRowPos,'qty_2'))
		ELSE
			IF dw_label.getItemNumber(llRowPos,'c_partial_qty') > 0 THEN
				ldsPlacard.setItem( ll_New_Row, 'qty', dw_label.getItemNumber(llRowPos,'c_partial_qty'))
				ldsPlacard.setItem( ll_New_Row, 'pallet_qty', dw_label.getItemNumber(llRowPos,'qty_2'))
			ELSE
				ldsPlacard.setItem( ll_New_Row, 'qty', dw_label.getItemNumber(llRowPos,'qty_2'))
				ldsPlacard.setItem( ll_New_Row, 'pallet_qty', dw_label.getItemNumber(llRowPos,'qty_2'))
			END IF
		END IF
	
	Next /*print copy*/

	dw_label.SetItem(llRowPos,'c_Print_Ind','N') 
	
Next /*detail row to Print*/

OpenWithParm(w_dw_print_options, ldsPlacard)

// We want to store the last printer used for Printing the license plate
lsPrinter = PrintGetPrinter()
SetProfileString(gs_inifile,'PRINTERS','PACKLIST',lsPrinter)

destroy ldsPlacard
end event

public function integer uf_dolam (ref any _anyparm);//
// int = uf_doLam( any _anyParm )
//
// Process Lam License Plate Tag
//

// if there are a billion labels to print for this detail line, prompt 
// them?

// Requirements state that there may or may not be serials for this detail
// if there serials print the label serial section
// if not, the label serial section should print blank
// So, there are two formats...guess which one is which
//
// LAM-SGLicenseTagSerial.DWN
// LAM-SGLicenseTag.DWN
//

string theSku
string thePkg
string theOwner


return success

end function

on w_license_labels.create
int iCurrent
call super::create
this.cb_print=create cb_print
this.dw_label=create dw_label
this.cb_selectall=create cb_selectall
this.cb_1=create cb_1
this.rb_rono=create rb_rono
this.rb_container=create rb_container
this.sle_retrieve=create sle_retrieve
this.st_1=create st_1
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_print
this.Control[iCurrent+2]=this.dw_label
this.Control[iCurrent+3]=this.cb_selectall
this.Control[iCurrent+4]=this.cb_1
this.Control[iCurrent+5]=this.rb_rono
this.Control[iCurrent+6]=this.rb_container
this.Control[iCurrent+7]=this.sle_retrieve
this.Control[iCurrent+8]=this.st_1
this.Control[iCurrent+9]=this.gb_1
end on

on w_license_labels.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_print)
destroy(this.dw_label)
destroy(this.cb_selectall)
destroy(this.cb_1)
destroy(this.rb_rono)
destroy(this.rb_container)
destroy(this.sle_retrieve)
destroy(this.st_1)
destroy(this.gb_1)
end on

event ue_postopen;call super::ue_postopen;
invo_labels = Create n_labels

cb_print.Enabled = False

isOrigSQL = dw_label.GetSQLSelect()

If istrParms.String_arg[1] = 'A' Then /*Coming from Stock Adjustment*/
	
		rb_container.Checked = True
		sle_retrieve.Text = Istrparms.String_arg[2] /*list of containers that have changed*/
			
		This.TriggerEvent('ue_retrieve')
	
ElseIf isValid(w_ro) Then /*Coming from menu, see if Receive Order is open */
	
	if w_ro.idw_main.rowCount() > 0 Then
		
		rb_roNo.Checked = True
		sle_retrieve.Text = w_ro.idw_main.getITemString(1,'ro_no')
		This.TriggerEvent('ue_retrieve')
		
	End If
		
//Else
//  TAM 2010/10  Added workorder
	ElseIf isValid(w_workorder) Then /*Coming from menu, see if Workorder Order is open */
	
	if w_workorder.idw_main.rowCount() > 0 Then
		
		rb_roNo.Checked = True
		is_ro_or_wo = 'wo_no'
		sle_retrieve.Text = w_workorder.idw_main.getITemString(1,'wo_no')
		This.TriggerEvent('ue_retrieve')
		
	End If
		
Else

	
	rb_Container.Checked = True
		
End If



end event

event ue_retrieve;call super::ue_retrieve;String	lsOrder,	&
			lsDONO,	&
			lsWhere,	&
			lsNewSQL,	&
			lsRetrieveVal,	&
			lsTemp

Long		llRowCount,	&
			llRowPos, llPrintCount, llTotalQty, lLCartonQty, llPartialCarton

cb_print.Enabled = False

if gs_project = "LOGITECH" then
	
	dw_label.dataobject = "d_logitech_license_label"
	dw_label.SetTransObject(SQLCA)
	
end if

//Modify SQL to retrieve by Sys Number (RONO) or Container ID

lsWhere = " and Receive_MASter.Project_id = '" + gs_Project + "'" /*always tackon project */

lsRetrieveVal = sle_Retrieve.Text


// TAM 2010/11/08 - Added a LIKE wildcard "%" instead of IN statement for NYCSP. (Could be used for everyone)
If gs_project = "NYCSP" and Pos(lsRetrieveVal,'%') > 0 Then /*Wildcard Used*/ 
	//If retrieving by RoNO, tackon RONO
	If rb_rono.Checked Then
		lsWhere += " and Receive_Master.ro_no Like '" + lsRetrieveVal + "'"
	Else /*retrieving by Container */
		lsWhere += " and Receive_Putaway.Container_ID Like  '" + lsRetrieveVal + "'"
	End If
Else

	//Values in "IN" (for multiple values) statement must have quotes areound Values
	If Pos(lsRetrieveVal,',') = 0 Then /*only one Value*/
		lsRetrieveVal = "'" + lsRetrieveVal + "'"
	Else /*mult values - add quotes around each value*/
		lsTemp = sle_Retrieve.Text
		lsRetrieveVAl = ''
		Do While Pos(lsTemp,',') > 0
			lsRetrieveVal += " '" + Left(lsTemp,(Pos(lsTemp,',') - 1)) + "', "
			lsTemp = Trim(Right(lsTemp,(len(lsTemp) - Pos(lsTemp,','))))
		Loop
		lsRetrieveVal += "'" + Trim(lsTemp) + "'" /*last one*/
	End If


	//If retrieving by RoNO, tackon RONO
	If rb_rono.Checked Then
		lsWhere += " and Receive_Master.ro_no In (" + lsRetrieveVal + ")"
	Else /*retrieving by Container */
		lsWhere += " and Receive_Putaway.Container_ID In (" + lsRetrieveVal + ")"
	End If

End If

lsNewSQL = isOrigSql + lsWhere

//If retrieving by Container, take from Content instead of Putaway (new containers won't exist in Putaway)
//change all joins on Receive_Putaway to Content
If rb_container.Checked Then
	
	Do While Pos(Upper(lsNewSQL),'RECEIVE_PUTAWAY') > 0
		lsNewSQL = Replace(lsNewSQL,Pos(Upper(lsNewSQL),'RECEIVE_PUTAWAY'), 15, 'Content')
	Loop
	
	lsNewSQL = Replace(lsNewSQL,Pos(lsNewSQL,'(Receive_Detail.Line_Item_No = Content.Line_Item_No) and'), 64, '') /*No join to Line Item in Content*/
	lsNewSQL = Replace(lsNewSQL,Pos(Upper(lsNewSQL),'QUANTITY'), 8, 'Avail_Qty') /*content qty field is named different then Putaway*/
	lsNEwSql += " and Content.Project_id = '" + gs_Project + "'" /*optimize query a little more */
End If
// TAM 2010/10 added Workorder processing
If is_ro_or_wo = 'wo_no' Then
	Do While Pos(Upper(lsNewSQL),'RECEIVE') > 0
		lsNewSQL = Replace(lsNewSQL,Pos(Upper(lsNewSQL),'RECEIVE'), 7, 'WORKORDER')
	Loop
	Do While Pos(Upper(lsNewSQL),'RO_NO') > 0
		lsNewSQL = Replace(lsNewSQL,Pos(Upper(lsNewSQL),'RO_NO'), 5, 'WO_NO')
	Loop
	lsNewSQL = Replace(lsNewSQL,Pos(Upper(lsNewSQL),'SUPP_INVOICE_NO'), 15, 'WorkOrder_Number') /*content qty field is named different then Putaway*/
	lsNewSQL = Replace(lsNewSQL,Pos(Upper(lsNewSQL),'WORKORDER_DETAIL.UOM,'), 21, "'EA' as UOM,") /*No join to Line Item in Content*/
End If

dw_label.SetSqlSelect(lsNewSQL)
dw_label.Retrieve()

If dw_label.RowCOunt() > 0 Then
Else
	Messagebox('Labels','No records found!')
	Return
End If

//We may be using the same tag but need to put a label on each carton with the correct carton qty - may have a partial at the end
llRowCount = dw_label.RowCount()
For llRowPos = 1 to llRowCount
	
	llPrintCount = 0
	
	llTotalQty = dw_label.GetITemNumber(llRowPos,'quantity')
	llCartonQty = dw_label.GetITemNumber(llRowPos,'qty_2')
	
	If llCartonQty = 0 or isNull(llCartonQty) Then
		llPrintCount = 1
		dw_label.SetITem(llRowPos,'qty_2',llTotalQty)
	Else
		
		llPrintCount = Truncate(llTotalQty/llCartonQty,0)
		llpartialCarton = mod(llTotalQty,llCartonQty) /* remainder*/
		
		If llPartialCarton > 0 Then
			llPrintCount ++ /* last remainder*/
		End If
		
	End If
	
	Dw_label.SetItem(llRowPos,'c_copies',llPrintCount)
	dw_label.SetItem(llRowPos,'c_partial_qty',llPartialCarton)
	
Next


cb_print.Enabled = True
end event

event resize;call super::resize;
dw_label.Resize(workspacewidth() - 50,workspaceHeight()-300)
end event

event open;call super::open;
Istrparms = Message.PowerObjectParm
end event

type cb_cancel from w_main_ancestor`cb_cancel within w_license_labels
boolean visible = false
integer x = 2373
integer y = 1408
integer height = 100
end type

type cb_ok from w_main_ancestor`cb_ok within w_license_labels
integer x = 3026
integer y = 128
integer height = 84
boolean default = false
end type

type cb_print from commandbutton within w_license_labels
integer x = 3026
integer y = 28
integer width = 270
integer height = 84
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Print"
end type

event clicked;//TAM 2019/01/17 - S28229  - Remove custom Rema Placard
//06-SEP-2018 :Madhu S23455 Rema Inventory Placards
//CHOOSE CASE upper(gs_project)
//	CASE 'REMA'
//		Parent.TriggerEvent('ue_rema_print')
//	CASE ELSE
		Parent.TriggerEvent('ue_Print')
//END CHOOSE
end event

type dw_label from u_dw_ancestor within w_license_labels
event ue_check_enable ( )
integer x = 41
integer y = 252
integer width = 3310
integer height = 1380
boolean bringtotop = true
string dataobject = "d_license_label"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event ue_check_enable;
If This.Find("c_print_ind = 'Y'",1,This.RowCount()) <= 0 Then
	cb_Print.Enabled = False
End If
end event

event itemchanged;call super::itemchanged;
If dwo.Name = 'c_print_ind' Then
	If data = 'Y' Then
		cb_Print.Enabled = True
	Else
		This.PostEvent('ue_check_enable')
	End If
End If
end event

event sqlpreview;call super::sqlpreview;
//Messagebox('??',sqlsyntax)
end event

type cb_selectall from commandbutton within w_license_labels
integer x = 2587
integer y = 28
integer width = 379
integer height = 84
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Select All"
end type

event clicked;Long	llRowPos,	&
		llRowCount

		
dw_label.SetRedraw(False)

llRowCount = dw_label.RowCount()
For llRowPos = 1 to llRowCount
	dw_label.SetITem(llRowPos,'c_print_ind','Y')
Next

dw_label.SetRedraw(True)

cb_print.Enabled = True

end event

type cb_1 from commandbutton within w_license_labels
integer x = 2587
integer y = 128
integer width = 379
integer height = 84
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Clear All"
end type

event clicked;Long	llRowPos,	&
		llRowCount

		
dw_label.SetRedraw(False)

llRowCount = dw_label.RowCount()
For llRowPos = 1 to llRowCount
	dw_label.SetITem(llRowPos,'c_print_ind','N')
Next

dw_label.SetRedraw(True)

cb_print.Enabled = False

end event

type rb_rono from radiobutton within w_license_labels
integer x = 142
integer y = 68
integer width = 489
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "&Sys Number:"
end type

event clicked;
sle_retrieve.Text = ''
dw_label.Reset()
end event

type rb_container from radiobutton within w_license_labels
integer x = 142
integer y = 140
integer width = 425
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "&Tag:"
end type

event clicked;sle_retrieve.Text = ''
dw_label.Reset()
end event

type sle_retrieve from singlelineedit within w_license_labels
integer x = 677
integer y = 76
integer width = 1819
integer height = 92
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

event modified;
parent.TriggerEvent('ue_retrieve')
end event

type st_1 from statictext within w_license_labels
integer x = 782
integer y = 176
integer width = 1669
integer height = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Enter Multiple values separated by Commas or ~'%~' for a Wildcard"
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_license_labels
integer x = 55
integer width = 599
integer height = 224
integer taborder = 10
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Print By"
end type

