$PBExportHeader$w_gm_detroit_part_labels.srw
$PBExportComments$GM Detroit part labels
forward
global type w_gm_detroit_part_labels from w_main_ancestor
end type
type cb_print from commandbutton within w_gm_detroit_part_labels
end type
type dw_label from u_dw_ancestor within w_gm_detroit_part_labels
end type
type cb_selectall from commandbutton within w_gm_detroit_part_labels
end type
type cb_clear from commandbutton within w_gm_detroit_part_labels
end type
end forward

global type w_gm_detroit_part_labels from w_main_ancestor
boolean visible = false
integer width = 3707
integer height = 1968
string title = "GM Part Labels"
string menuname = ""
event ue_print ( )
cb_print cb_print
dw_label dw_label
cb_selectall cb_selectall
cb_clear cb_clear
end type
global w_gm_detroit_part_labels w_gm_detroit_part_labels

type variables
n_warehouse i_nwarehouse
n_labels	invo_labels
n_3com_labels	invo_3com_labels

String	isOrigSql


end variables

forward prototypes
public function string wf_format_group (string asgroup)
end prototypes

event ue_print();Str_Parms	lstrparms
n_labels	lu_labels

Long	llQty,	&
		llRowCount,	&
		llRowPos, &
		ll_rtn, llPrintJob, llFindRow
		
Any	lsAny

String	lsformat, lsFormatSave, lsPrinter, lsLabel, lsLabelPrint, lsCountryName, lsPrintText, lsLabelDesc, &
			lsCurrentLabel, lsGMSKU, lsACSKU, lsGroup, lsLineCode, lsUPC
Integer	liMsg
Boolean lbPrompt, lbRoChanged
String	lsJulianDate

lu_labels = Create n_labels

Dw_Label.AcceptText()

//// 09/04 - PCONKL - See if we have a default label printer stored in the .ini file
//lsPrinter = ProfileString(gs_iniFile,'PRINTERS','SHIPLABEL','')
//If lsPrinter > '' Then PrintSetPrinter(lsPrinter)
						
//Print each detail Row
llRowCount = dw_label.RowCount()
For llRowPos = 1 to llRowCount /*each detail row */
		
	IF dw_label.object.c_print_ind[llRowPos] <> 'Y' THEN Continue
	
	//Make Sure Source Code has been entered
	If isnull(dw_label.object.User_field4[llRowPos]) or dw_label.object.User_field4[llRowPos] = "" Then
		Messagebox("Labels","Row " + String(llRowPos) + ", Source Code is required.~r~rLabel not printed")
		Continue
	End If
	
	//Label Format
	Choose Case upper(dw_label.GetITemString(llRowPos,'user_field11'))
			
		Case "GM1216"
			lsformat = "GM_PART_1216.Txt"
			lsLabelDesc = "GM 1216 (4 x 2.25)"
		Case "GM1217"
			lsformat = "GM_PART_1217.Txt"
			lsLabelDesc = "GM 1217 (2.25 x 1.5)"
		Case "AC1216"
			lsformat = "ACDELCO_PART_1216.Txt"
			lsLabelDesc = "ACDelco 1216 (4 x 2.25)"
		Case "AC1207"
			lsformat = "ACDELCO_PART_1207.Txt"
			lsLabelDesc = "ACDelco 1207 (2.25 x 1.5)"
		Case Else
			messagebox('Labels',"Invalid label format in row " + String(llRowPos) + ", row will be skipped")
			
	End Choose
	
	//If label format has changed, we need to prompt user to switch stock or printers and load the new format
	If lsFormat <> lsFormatSave Then
		
		//Send the Previous format to the printer...
		If lsLabelPrint > "" Then
		
			lsPrintText = 'GM Part Labels '

			//Open Printer File 
			llPrintJob = PrintOpen(lsPrintText)
	
			If llPrintJob <0 Then 
				Messagebox('Labels', 'Unable to open Printer file. Labels will not be printed')
				Return
			End If

			//French characters need to be 'cleansed'
			lsLabelPrint = f_cleanse_printer(lsLabelPrint)

			PrintSend(llPrintJob, lsLabelPrint)	
			PrintClose(llPrintJob)
			
			lsLabelPrint = ""
		
		End If /* previous label to print*/
				
		//Prompt the user to switch label stock or printer (always prompt for printer on first format)
		If not lbPrompt Then
			
			lstrparms.String_arg[1] = lsLabelDesc
			OpenWithParm(w_label_print_options,lStrParms)
			Lstrparms = Message.PowerObjectParm		  
			If lstrParms.Cancelled Then
				Return
			End If
			
			lbPrompt = True
			
		Else /*ask if they want to set another printer*/
			
			liMsg =  messagebox("New Label Format","The following label stock is now required:~r~r" + lsLabelDesc + "~r~rDo you want to continue with the same printer?~r~r'Yes' - use same printer~r'No' - Select a new printer",Question!,yesNocancel!,1) 
				
			If liMsg = 2 Then /*select printer*/
			
				OpenWithParm(w_label_print_options,lStrParms)
				Lstrparms = Message.PowerObjectParm		  
				If lstrParms.Cancelled Then
					Return
				End If
				
			ElseIf liMsg = 3 Then
				Return
			End If
			
		End If
		
		lsLabel = lu_labels.uf_read_label_Format(lsFormat)
		If lsLabel = "" Then Return
		
	End If /*format changed */
	
	//load current label from the template (we can resuse template until format changes)
	lsCurrentLabel= lsLabel
	
	If dw_label.GetITemString(llRowPos,'sku') > "" Then
		
		lsGMSKU = dw_label.GetITemString(llRowPos,'sku')
		
		//Get rid of any leading zeros
		Do While Left(lsGMSku,1) = '0'
			lsGmSKU = Mid(lsGMSku,2,99)
		Loop
		
		lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~gm_part~~",lsGMSKU) /* GM Part*/
		lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~gm_part_barcode~~",lsGMSKU) /* Barcoded GM Part*/
	Else
		lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~gm_part~~","")
		lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~gm_part_barcode~~","")
	End If
	
	If dw_label.GetITemString(llRowPos,'user_field4') > "" Then
		lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~source_code~~",dw_label.GetITemString(llRowPos,'user_field4') + " " + dw_label.GetITemString(llRowPos,'c_julian_date')) /* Source Code + Julian Date*/
	Else
		lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~source_code~~","")
	End If
			
	If dw_label.GetITemString(llRowPos,'user_field1') > "" Then
		
		//Group needs to be formatted
		lsGroup = wf_format_group(dw_label.GetITemString(llRowPos,'user_field1'))
		
		lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~Group_number~~",lsGroup) /* Group Code*/
	Else
		lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~Group_number~~","")
	End If
	
	If dw_label.GetITemString(llRowPos,'description') > "" Then	
		lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~English_desc~~",dw_label.GetITemString(llRowPos,'description')) /* English Desc*/
	Else
		lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~English_desc~~","")
	End If
	
	If	dw_label.GetITemString(llRowPos,'user_field8') > "" Then
		lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~French_desc~~",dw_label.GetITemString(llRowPos,'user_field8')) /* French Desc*/
	Else
		lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~French_desc~~","")
	End If
	
	If dw_label.GetITemString(llRowPos,'user_field9') > "" Then
		lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~Spanish_Desc~~",dw_label.GetITemString(llRowPos,'user_field9')) /* Spanish Desc*/
	Else
		lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~Spanish_Desc~~","")
	End If
	
	If dw_label.GetITemString(llRowPos,'user_field5') > "" Then
		lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~Core_group~~",dw_label.GetITemString(llRowPos,'user_field5')) /* Core Group*/
	Else
		lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~Core_group~~","")
	End If
	
	If dw_label.GetITemNumber(llRowPos,'qty_2') > 0 Then	
		lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~package_qty~~",String(dw_label.GetITemNumber(llRowPos,'qty_2'))) /* Pkg Qty*/
	Else
		lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~package_qty~~","1")
	End If
	
	//DOT
	If dw_label.GetITemString(llRowPos,'user_field7') = 'Y' Then
		lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~DOT~~","D.O.T.")
	Else
		lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~DOT~~","")
	End If
		
	//COO
	If dw_label.GetITemString(llRowPos,'Country_of_Origin_default')<> 'XXX' Then
		
		//Get the Name from the Code...
		lsCountryName = f_get_country_name(dw_label.GetITemString(llRowPos,'Country_of_Origin_Default'))
		If Upper(trim(lsCountryName)) = "UNITED STATES OF AMERICA" Then lsCountryName = "USA"
		if lsCountryName > "" Then
			lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~COO~~","MADE IN " + Upper(lsCountryName))
		Else
			lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~COO~~","")
		End IF
		
	Else
		lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~COO~~","")
	End If
	
	//ACDelco Part NUmber
	If dw_label.GetITemString(llRowPos,'user_field12') > "" Then
		lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~ac_part~~",dw_label.GetITemString(llRowPos,'user_field12')) 
	Else /*Not present, use GM Part*/
		lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~ac_part~~",lsGMSKU)
	End If
	
	//ACDelco Product Line CD
	If dw_label.GetITemString(llRowPos,'user_field10') > "" Then
		
		//Line code needs to be 2 digit with leading zero if necessary
		lsLineCOde = dw_label.GetITemString(llRowPos,'user_field10')
		If len(lsLineCode) = 1 then lsLineCode = "0" + lsLineCode
		lsLineCode = "LC " + lsLineCode
		lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~prod_line_cd~~", lsLineCode) 
		
	Else
		lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~prod_line_cd~~","")
	End If
	
	//ACDelco UPC Code
	
	//If there are only 11 characters, we need to assume that a leading zero has been dropped
	lsUPC = String(dw_label.GetITemNumber(llRowPos,'part_upc_code'))
	If len(lsUPC) = 11 Then
		lsUPC = "0" + lsUPC
	End If
	
	If lsUPC > "" Then	
		lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~upc_barcode~~",lsUPC) 
	Else
		lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~upc_barcode~~","1")
	End If
	
	//Override Print Count if necessary
	If dw_label.GetITemNUmber(llRowPos,'c_print_qty') > 1 Then
		lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"^PQ1,","^PQ" + string(dw_label.GetITemNUmber(llRowPos,'c_print_qty')) + ",")
	End If
		
	lsFormatSave = lsFormat
	lsLabelPrint += lsCurrentLabel
	
	//We want to set a user field on the eceive DEtail record to show that the label has printed.
	If isvalid(w_ro) Then
		
		llFindRow = w_ro.idw_detail.Find("Upper(sku) = '" + Upper(dw_label.GetItemString(llRowPos, 'sku')) + "'",1,w_ro.idw_detail.RowCount())
		Do While llFindRow > 0 
			
			w_ro.idw_detail.SetItem(llFindRow,'user_field1','Y')
			lbRoChanged = True
			
			llFindRow ++
			if llFindRow > w_ro.idw_detail.RowCount() Then
				llFindRow = 0
			Else
				llFindRow = w_ro.idw_detail.Find("Upper(sku) = '" + Upper(dw_label.GetItemString(llRowPos, 'sku')) + "'",llFindRow,w_ro.idw_detail.RowCount())
			End If
		
		Loop
	
	End If
		
	dw_label.object.c_print_ind[llRowPos] = "N"
	
Next /*detail row to Print*/

//If Receive Order updated, save changes
if lbRoChanged Then
	w_ro.TriggerEvent('ue_save')
End IF

//Send the Last/Only format to the printer...
If lsLabelPrint > "" Then
		
	lsPrintText = 'GM Part Labels '

		//Open Printer File 
		llPrintJob = PrintOpen(lsPrintText)
	
		If llPrintJob <0 Then 
			Messagebox('Labels', 'Unable to open Printer file. Labels will not be printed')
			Return
		End If

		//French characters need to be 'cleansed'
		lsLabelPrint = f_cleanse_printer(lsLabelPrint)
			
		PrintSend(llPrintJob, lsLabelPrint)	
		PrintClose(llPrintJob)
		
End If
		










end event

public function string wf_format_group (string asgroup);
String	lsGroup

// "Three digit group numbers will have one leading zero (i.e. 0.659). All other Group numbers will have
//  No leading zeros (i.e.1.266, 10.373" From the GM standards manual

lsGroup = asGroup

//First, make sure there is a period - If not, there should be 3 digits after...
If POs(lsGroup,'.') = 0 Then
	lsGroup = Left(lsGroup,(len(lsGroup) - 3)) + "." + Right(lsGroup,3)
End IF

Choose Case Len(lsGroup) /*len includes period*/
		
	Case 4 /*needs a leading zero for 3 digit groups*/
		
		lsGroup = "0" + lsGroup
		
	Case 6 /*drop any leading zeros*/
		
		If left(lsGroup,1) = '0' Then lsGroup = Right(lsGroup,5)
				
End Choose

lsGroup = "GR. " + lsGroup

Return lsGroup
end function

on w_gm_detroit_part_labels.create
int iCurrent
call super::create
this.cb_print=create cb_print
this.dw_label=create dw_label
this.cb_selectall=create cb_selectall
this.cb_clear=create cb_clear
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_print
this.Control[iCurrent+2]=this.dw_label
this.Control[iCurrent+3]=this.cb_selectall
this.Control[iCurrent+4]=this.cb_clear
end on

on w_gm_detroit_part_labels.destroy
call super::destroy
destroy(this.cb_print)
destroy(this.dw_label)
destroy(this.cb_selectall)
destroy(this.cb_clear)
end on

event ue_postopen;call super::ue_postopen;Boolean	lbInvalid
invo_labels = Create n_labels
i_nwarehouse = Create n_warehouse

cb_print.Enabled = False

isOrigSql = dw_label.GetSqlSelect()


lbInvalid = False
If isVAlid(w_ro) Then
	if w_ro.idw_main.rowCount() < 1 Then 
		lbInvalid = True
	Else
		if w_ro.ib_changed Then
			Messagebox("Labels","You must save your Receive Order changes before they will be reflected here!")
			Return
		End If
	End If
Elseif isvalid(w_workorder) Then
	if w_workorder.idw_main.rowCount() < 1 Then
		lbInvalid = True
	Else
		if w_workorder.ib_changed Then
			Messagebox("Labels","You must save your WorkOrder changes before they will be reflected here!")
			Return
		End If
	End If
Elseif isvalid(w_maintenance_itemmaster) Then
	if w_maintenance_itemmaster.idw_main.rowCount() < 1 Then
		lbInvalid = True
	Else
		if w_maintenance_itemmaster.ib_changed Then
			Messagebox("Labels","You must save your Item Master changes before they will be reflected here!")
			Return
		End If
	End If
Else
	lbInvalid = True
End If

If lbInvalid Then
	Messagebox("Labels","You must have an open WorkOrder, Receiving Order or Item Master Maintenance window to print part labels.")
End If

This.TriggerEvent('ue_retrieve')
end event

event ue_retrieve;call super::ue_retrieve;
Long		llRowCount,	llRowPos, llQty, llPkgQty, llFindRow
String	lsWhere, lsJulianDate
Int	liWholeQty

//We will either be printing a single sku or one or more skus depending on whether the Receive Order or Item Master windows are open

//Always add project to sql
lsWhere = " Where Project_ID = '" + gs_project + "'"

If isvalid(w_ro) Then
	
	if w_ro.idw_main.rowCount() > 0 Then
		If w_ro.idw_main.getItemString(1,'ro_no') > "" and Not isnull(w_ro.idw_main.getItemString(1,'ro_no')) Then 
			lsWhere += " and supp_code = '" + w_ro.idw_main.getItemString(1,'supp_code') + "'" 
			lsWhere += " and sku in (select sku from receive_detail where ro_no = '" + w_ro.idw_main.getItemString(1,'ro_no') + "')" 
		Else
			Return
		End If
	else
		return
	End If
	
ElseIf isvalid(w_workorder) Then
	
	if w_workorder.idw_main.rowCount() > 0 Then
		If w_workorder.idw_main.getItemString(1,'wo_no') > "" and Not isnull(w_workorder.idw_main.getItemString(1,'wo_no')) Then 

			llRowCount = w_workorder.idw_Detail.RowCount()
			
			lsWhere += " and ("
			
			For llRowPos = 1 to llRowCount
				
				If llRowPos > 1 Then lsWhere += " or "
				
				lsWhere += "  (sku = '" + w_workorder.idw_Detail.GetITemString(lLRowPos,'sku') + "'"
				lsWhere += "and supp_code = '" + w_workorder.idw_Detail.GetITemString(lLRowPos,'supp_code') + "') "
				
			Next
			
			lsWhere += ")"
				
		Else
			Return
		End If
	else
		return
	End If
	
Elseif isValid(w_maintenance_ItemMaster) Then
	
	if w_maintenance_itemMaster.idw_Main.RowCount() > 0 Then
		If w_maintenance_itemMaster.idw_main.getItemString(1,'sku') > "" and Not isnull(w_maintenance_itemMaster.idw_main.getItemString(1,'sku')) Then
			lsWhere += " and sku = '" + w_maintenance_itemMaster.idw_main.getItemString(1,'sku') + "'" 
			lsWhere += " and supp_code = '" + w_maintenance_itemMaster.idw_main.getItemString(1,'supp_code') + "'" 
		Else
			Return
		End If
	else
		return
	End If
else
	return
end If

cb_print.Enabled = False

dw_label.SetSqlSelect(isOrigSql + lsWhere)
dw_label.Retrieve()

//If we are coming from an order, try and default qty to print to qty being received...
If isvalid(w_ro)  Then
	
	//For each row, get either the received or order qty (depening on whether putaway generated or not*/
	lLRowCount = dw_label.RowCount()
	For llRowPos = 1 to llRowCount
		
		lLQty = 0
		
		llFindRow = w_ro.idw_detail.Find("Upper(sku) = '" + Upper(dw_label.GetItemString(llRowPos, 'sku')) + "'",1,w_ro.idw_detail.RowCount())
		Do While llFindRow > 0
			
			If w_ro.idw_detail.getItemNumber(llFindRow,'Alloc_qty') > 0 Then
				llQty += w_ro.idw_detail.getItemNumber(llFindRow,'Alloc_qty')
			else
				llQty += w_ro.idw_detail.getItemNumber(llFindRow,'Req_qty')
			end If
			
			llFindRow ++
			if llFindRow > w_ro.idw_detail.RowCount() Then
				llFindRow = 0
			Else
				llFindRow = w_ro.idw_detail.Find("Upper(sku) = '" + Upper(dw_label.GetItemString(llRowPos, 'sku')) + "'",llFindRow,w_ro.idw_detail.RowCount())
			End If
			
		Loop
		
		If llQty > 0 Then
			
			llPkgQty = dw_label.GetItemNumber(llRowPos,'Qty_2')
			If llPkgQty <=0 Then llPkgQty = 1
			
			// Print labels is received qty divided by pkg qty
			liWholeQty = llQty/llPkgQty
			
			If liWholeQty * llPkgQty = llQty Then
				dw_label.SetItem(llRowPos, 'c_print_qty',liWholeQty)
			Else
				dw_label.SetItem(llRowPos, 'c_print_qty',liWholeQty + 1)
			End If
			
		Else
			
			dw_label.SetItem(llRowPos, 'c_print_qty',1)
			
		End If
		
	Next /*label row*/
	
ElseIf isvalid(w_workorder)  Then
	
	//For each row, get either the received or order qty (depening on whether putaway generated or not*/
	lLRowCount = dw_label.RowCount()
	For llRowPos = 1 to llRowCount
		
		lLQty = 0
		
		llFindRow = w_workorder.idw_detail.Find("Upper(sku) = '" + Upper(dw_label.GetItemString(llRowPos, 'sku')) + "'",1,w_workorder.idw_detail.RowCount())
		Do While llFindRow > 0
			
			If w_workorder.idw_detail.getItemNumber(llFindRow,'Alloc_qty') > 0 Then
				llQty += w_workorder.idw_detail.getItemNumber(llFindRow,'Alloc_qty')
			else
				llQty += w_workorder.idw_detail.getItemNumber(llFindRow,'Req_qty')
			end If
			
			llFindRow ++
			if llFindRow > w_workorder.idw_detail.RowCount() Then
				llFindRow = 0
			Else
				llFindRow = w_workorder.idw_detail.Find("Upper(sku) = '" + Upper(dw_label.GetItemString(llRowPos, 'sku')) + "'",llFindRow,w_workorder.idw_detail.RowCount())
			End If
			
		Loop
		
		If llQty > 0 Then
			
			llPkgQty = dw_label.GetItemNumber(llRowPos,'Qty_2')
			If llPkgQty <=0 Then llPkgQty = 1
			
			// Print labels is received qty divided by pkg qty
			liWholeQty = llQty/llPkgQty
			
			If liWholeQty * llPkgQty = llQty Then
				dw_label.SetItem(llRowPos, 'c_print_qty',liWholeQty)
			Else
				dw_label.SetItem(llRowPos, 'c_print_qty',liWholeQty + 1)
			End If
			
		Else
			
			dw_label.SetItem(llRowPos, 'c_print_qty',1)
			
		End If
		
	Next /*label row*/
	

End If /*receiving order or Workorder */


cb_print.Enabled = True


end event

event ue_selectall;call super::ue_selectall;Long	llRowPos,	&
		llRowCount

		
dw_label.SetRedraw(False)

llRowCount = dw_label.RowCount()
For llRowPos = 1 to llRowCount
	If dw_label.GetITemstring(llrowPos,'user_field11') > "" Then dw_label.SetITem(llRowPos,'c_print_ind','Y')
Next

dw_label.SetRedraw(True)

cb_print.Enabled = True

end event

event ue_unselectall;call super::ue_unselectall;Long	llRowPos,	&
		llRowCount

		
dw_label.SetRedraw(False)

llRowCount = dw_label.RowCount()
For llRowPos = 1 to llRowCount
	dw_label.SetITem(llRowPos,'c_print_ind','N')
Next

dw_label.SetRedraw(True)

cb_print.Enabled = True

end event

event resize;call super::resize;dw_label.Resize(workspacewidth() - 50,workspaceHeight()-150)
end event

event close;call super::close;IF ISVALID(i_nwarehouse) THEN Destroy(i_nwarehouse)
end event

type cb_cancel from w_main_ancestor`cb_cancel within w_gm_detroit_part_labels
boolean visible = false
integer x = 1938
integer y = 1392
integer height = 80
end type

type cb_ok from w_main_ancestor`cb_ok within w_gm_detroit_part_labels
integer x = 1769
integer y = 32
integer height = 80
integer textsize = -9
boolean default = false
end type

type cb_print from commandbutton within w_gm_detroit_part_labels
integer x = 946
integer y = 32
integer width = 329
integer height = 80
integer taborder = 30
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Print"
end type

event clicked;Parent.TriggerEvent('ue_Print')
end event

type dw_label from u_dw_ancestor within w_gm_detroit_part_labels
integer x = 9
integer y = 140
integer width = 3634
integer height = 1668
boolean bringtotop = true
string dataobject = "d_gm_detroit_part_labels"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event itemchanged;call super::itemchanged;
Choose Case Upper(dwo.name)
		
	Case "COUNTRY_OF_ORIGIN_DEFAULT"
		
		If data > "" Then
			
			If f_get_country_name(data) = "" Then
				Messagebox("Labels", "Invalid Country of Origin")
				Return 1
			End If
			
		End If
		
End Choose
end event

event itemerror;call super::itemerror;return 1
end event

event constructor;call super::constructor;
DatawindowChild	ldwc

This.GetChild('user_field11',ldwc)

ldwc.SetTransObject(SQLCA)

ldwc.Retrieve(gs_project,'PTLBL')
end event

event process_enter;call super::process_enter;
Send(Handle(This),256,9,Long(0,0))
end event

type cb_selectall from commandbutton within w_gm_detroit_part_labels
integer x = 37
integer y = 32
integer width = 338
integer height = 80
integer taborder = 20
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Select All"
end type

event clicked;Parent.Event ue_selectall()

end event

type cb_clear from commandbutton within w_gm_detroit_part_labels
integer x = 393
integer y = 32
integer width = 338
integer height = 80
integer taborder = 30
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Clear All"
end type

event clicked;Parent.Event ue_unselectall()
end event

