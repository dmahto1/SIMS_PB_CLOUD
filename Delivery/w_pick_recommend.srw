HA$PBExportHeader$w_pick_recommend.srw
$PBExportComments$*+Pick Recommendations
forward
global type w_pick_recommend from window
end type
type cb_expand from commandbutton within w_pick_recommend
end type
type cb_sort from commandbutton within w_pick_recommend
end type
type cb_cancel from commandbutton within w_pick_recommend
end type
type cb_help from commandbutton within w_pick_recommend
end type
type st_supplier from statictext within w_pick_recommend
end type
type dw_recommend from u_dw_ancestor within w_pick_recommend
end type
type st_remain from statictext within w_pick_recommend
end type
type st_total from statictext within w_pick_recommend
end type
type st_2 from statictext within w_pick_recommend
end type
type st_3 from statictext within w_pick_recommend
end type
type st_1 from statictext within w_pick_recommend
end type
type st_sku from statictext within w_pick_recommend
end type
type cb_clear from commandbutton within w_pick_recommend
end type
type cb_ok from commandbutton within w_pick_recommend
end type
end forward

global type w_pick_recommend from window
integer x = 823
integer y = 362
integer width = 4586
integer height = 1552
boolean titlebar = true
string title = "Pick recommendations"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 79741120
event ue_postopen ( )
event ue_calc_remaining ( )
event ue_clear ( )
event ue_filter_comcast_sik ( )
cb_expand cb_expand
cb_sort cb_sort
cb_cancel cb_cancel
cb_help cb_help
st_supplier st_supplier
dw_recommend dw_recommend
st_remain st_remain
st_total st_total
st_2 st_2
st_3 st_3
st_1 st_1
st_sku st_sku
cb_clear cb_clear
cb_ok cb_ok
end type
global w_pick_recommend w_pick_recommend

type variables
str_parms	istrparms
Decimal	idRemain
Window	iwCurrent
end variables

event ue_postopen();
Long 		llFindRow
String	lsFind, lsSort
datawindowChild	ldwc

Long llRowcount,llRowpos  //1-Aug-2013 :Madhu Added
int li_shelf,li_days,li_count //1-Aug-2013 :Madhu Added
DateTime ldtexpdate  //1-Aug-2013 :Madhu Added

// 03/03 - PCONKL - populate Inv Type dropdown by Project
dw_recommend.GetChild('content_inventory_Type',ldwc)
ldwc.SetTransObject(SQLCA)
ldwc.Retrieve(gs_PRoject)
If ldwc.RowCOunt() <=0 Then ldwc.InsertRow(0)

// 2002/08/12 Tony add owner to parm list
//dw_recommend.Retrieve(Istrparms.String_arg[1],Istrparms.String_arg[2],Istrparms.String_arg[3],Istrparms.String_arg[4],istrparms.long_arg[1])
dw_recommend.Retrieve(Istrparms.String_arg[1],Istrparms.String_arg[2],Istrparms.String_arg[3],Istrparms.String_arg[4])
//PANDORA...
if gs_Project = 'PANDORA' and string(istrparms.long_arg[1]) > '' then
	dw_recommend.SetFilter("owner_id = " + string(istrparms.long_arg[1]))
	dw_recommend.filter()
end if



st_sku.text = 'SKU: ' + Istrparms.String_arg[3]
st_supplier.text = 'Supplier: ' + Istrparms.String_arg[4]

st_total.Text = String(istrparms.Decimal_arg[1],'#######.#####')

This.TriggerEvent("ue_calc_remaining")

//MAS - 042911 - errors if w_do not valid or w_do.idw_Main rowcount < 1
//*****	moved new code below *****
// 11/10 - PCONKL - For Comcast, we don't want to allow bad pallets to be warehouse transferred to the SIK warehouse...
//If gs_project = 'COMCAST' and &
//	w_do.idw_Main.GetITemString(1,'Ord_Type') = 'Z' and &
//		left(w_do.idw_Main.GetITemString(1,'Cust_Code'),7) = 'COM-SIK' Then
//			This.TriggerEvent('ue_filter_Comcast_sik')
//End If

//***** Begin New Code ***** MAS - 042911
//updated code to prevent system error message
Choose Case upper(gs_project)
	Case  'COMCAST'
		If IsValid(w_do) Then
			If IsValid(w_do.idw_Main) and w_do.idw_Main.RowCount() >= 1 Then
				//MAS - commented - choose case above replaces If statement
				//If gs_project = 'COMCAST' and  &
				If w_do.idw_Main.GetITemString(1,'Ord_Type') = 'Z' and &
						left(w_do.idw_Main.GetITemString(1,'Cust_Code'),7) = 'COM-SIK' Then
							This.TriggerEvent('ue_filter_Comcast_sik')					
				End If			
			End If
		End If
End Choose
//***** END *****

// 11/02 - PCOnkl - Hide any unused lottable fields
dw_recommend.TriggerEvent('ue_hide_unused')

// 10/09 - PCONKL - IF a default sort stored in ini file, sort the DW now
lsSort = ProfileString(gs_iniFile,'DWSORT',gs_project + '-PICKRECOMMEND','')
If lsSort > '' Then
	dw_recommend.SetSort(lsSort)
	dw_recommend.Sort()
End If

//1-Aug-2013 :Madhu -Added code to get shelf life value -START
select shelf_life into :li_shelf from Item_Master where project_Id=:gs_project and sku=:Istrparms.String_arg[3] and supp_code=:Istrparms.String_arg[4] using sqlca;

llRowcount =dw_recommend.Rowcount()
li_count =0
FOR llRowpos =1 to llRowcount
	ldtexpdate =dw_recommend.getItemDateTime(llRowpos,"expiration_date")
	li_days =DaysAfter(Today,date(ldtexpdate))
	
	if li_days < li_shelf  and li_shelf > 0 THEN
		li_count =li_count +1
	END IF
Next
if li_count >0 THEN
		MessageBox("Shelf Life Validation","Expiration date shouldn't be greater than current date + shelf life",StopSign!)	
end if	
//1-Aug-2013 :Madhu -added code to get shelf life value -END

//Override Default Sort
//MEA - 9/12
if gs_Project = 'LMC'  then
	dw_recommend.SetSort("inventory_type A, expiration_date A, complete_date A")
	dw_recommend.Sort()
end if




end event

event ue_calc_remaining;Long	llRowPos,	&
		llRowCount
		
Decimal	ldQty

//Calc the remaining putaway based on amounts entered

ldQty = 0

llRowCount = dw_recommend.RowCount()
If llRowCount > 0 Then
	for llRowPos = 1 to llRowCount
		ldQty = ldQty + dw_recommend.GetItemNumber(llRowPos,"c_pick_amt")
	Next
End If



idRemain = Istrparms.Decimal_arg[1] - ldQty
st_remain.text = String(idRemain,'#######.#####')

end event

event ue_clear;
//Reset amts to 0

Long	llRowPos,	&
		llRowCount


llRowCount = dw_recommend.RowCount()
If llRowCount > 0 Then
	for llRowPos = 1 to llRowCount
		dw_recommend.SetItem(llRowPos,"c_pick_amt",0)
	Next
End If

This.TriggerEvent("ue_calc_remaining")



end event

event ue_filter_comcast_sik();Long	llRowCount, llRowPos, llSerialCount
String	lsSKU, lsSupplier, lsGroup, lsLotInd, lsPallet

lsSKU = istrparms.String_arg[3]
lsSupplier =  istrparms.String_arg[4]

//Get the Group
Select grp, lot_controlled_ind into :lsGroup, :lsLotInd
From ITem_MAster
Where project_id = :gs_project and sku = :lsSKU and supp_Code = :lsSupplier;


//Loop through each pallet and if there are not enough serial numbers or they are missing Unit/MAC ID, don't allow them to be sent to the SIK warehouse



if (lsGroup = 'DTA' or lsGroup = 'UDTA') and lsLotInd = 'Y' Then
					
	SetPointer(Hourglass!)
	
	llRowCOunt = dw_recommend.RowCount()
	For llRowPos = 1 to llRowCount
					
		lsPallet = dw_recommend.GetITemString(llRowPos,'lot_no')
		
		Choose Case Upper( lsGROUP)
							
				Case 'DTA' /*Needs Unit ID (User Field1) */
							
					Select Count(*) into :llSerialCount
					From Carton_serial
					Where Project_id = :gs_Project and pallet_id = :lsPallet and User_Field1 > '';
							
				Case 'UDTA' /*Needs Unit ID (User Field1) and RFMAC (User Field2) */
							
					Select Count(*) into :llSerialCount
					From Carton_serial
					Where Project_id = :gs_Project and pallet_id = :lsPallet and User_Field1 > '' and User_Field2 > '';
							
		End Choose
					
		If llSerialCount <> dw_recommend.GetITemNumber(llRowPos,'c_avail_qty') Then /*mismatch between pick qty for pallet and number of valid serial numbers */
			dw_recommend.SetITem(llRowPos,'inventory_shippable_ind','N')
		End If
					
	Next /*Inv Record*/
	
	SetPointer(Arrow!)
					
End If /* DTA or uDTA and Lot (Pallet) Controlled*/
end event

on w_pick_recommend.create
this.cb_expand=create cb_expand
this.cb_sort=create cb_sort
this.cb_cancel=create cb_cancel
this.cb_help=create cb_help
this.st_supplier=create st_supplier
this.dw_recommend=create dw_recommend
this.st_remain=create st_remain
this.st_total=create st_total
this.st_2=create st_2
this.st_3=create st_3
this.st_1=create st_1
this.st_sku=create st_sku
this.cb_clear=create cb_clear
this.cb_ok=create cb_ok
this.Control[]={this.cb_expand,&
this.cb_sort,&
this.cb_cancel,&
this.cb_help,&
this.st_supplier,&
this.dw_recommend,&
this.st_remain,&
this.st_total,&
this.st_2,&
this.st_3,&
this.st_1,&
this.st_sku,&
this.cb_clear,&
this.cb_ok}
end on

on w_pick_recommend.destroy
destroy(this.cb_expand)
destroy(this.cb_sort)
destroy(this.cb_cancel)
destroy(this.cb_help)
destroy(this.st_supplier)
destroy(this.dw_recommend)
destroy(this.st_remain)
destroy(this.st_total)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.st_1)
destroy(this.st_sku)
destroy(this.cb_clear)
destroy(this.cb_ok)
end on

event open;Integer			li_ScreenH, li_ScreenW
Environment	le_Env

// Center window
GetEnvironment(le_Env)

li_ScreenH = PixelsToUnits(le_Env.ScreenHeight, YPixelsToUnits!)
li_ScreenW = PixelsToUnits(le_Env.ScreenWidth, XPixelsToUnits!)

This.Y = (li_ScreenH - This.Height) / 2
This.X = (li_ScreenW - This.Width) / 2

istrparms = message.PowerobjectParm
iwCurrent = This

This.PostEvent("ue_postOpen")

if gs_project = 'LMC' then
	
	cb_expand.visible = true
	
end if

end event

event closequery;str_parms	lstrparms
String	lsWork, lsSyntax, lsSort
Long	llRowCount,	&
		llRowPos,	&
		llArrayPos,	&
		llPos, llPos2, llPos3
		
Decimal	ldQty
Boolean lbShowLMCWarning = true
Date ldCompleteDate
		
llArrayPos = 0
ldQty = 0

dw_recommend.AcceptText()

// //)5/02 - Pconkl - If cancelled, get out
If istrparms.Cancelled Then
	lstrparms.Cancelled = True
	message.PowerobjectParm = lstrparms
	Return 0
End If



//Return array of locations and amts for this sku

//Current
llRowCount = dw_recommend.RowCount()
If llRowCount > 0 Then
	For llRowpos = 1 to llRowCount
		If	dw_recommend.GetItemNumber(llRowPos,"c_pick_amt") > 0 Then
			llArrayPos++
			
			
			
			If Upper(gs_project) = "LMC" and lbShowLMCWarning Then
			
				lbShowLMCWarning = false
				
				integer liFind
				date ldExpDate
				
				//2.	For inventory with valid expiration dates other than 12/31/2999, if user pick inventory with newer expiration date, SIMS to pop up an alert message to indicate that FEFO rule is violated.
		
				ldExpDate = Date(dw_recommend.GetItemDateTime(llRowPos,"expiration_date"))
				
				if  ldExpDate <> Date('12/31/2999') then
					
					liFind = dw_recommend.Find("string(expiration_date,'YYYY/MM/DD') <> '" + string(ldExpDate,'YYYY/MM/DD') + "' and string(expiration_date,'YYYY/MM/DD') < '" + string(ldExpDate,'YYYY/MM/DD') + "' and string(expiration_date,'2999/12/31') <> 'YYYY/MM/DD' " ,1, dw_recommend.RowCount()) 
					
					if liFind > 0 then
						MessageBox ("Pick Warning","FEFO rule is violated!")
					end if
								

				end if

				//3.	For inventory with expiration dates =12/31/2999, if user pick inventory with newer receipt date, SIMS to pop up an alert message to indicate that FIFO rule is violated

				if  ldExpDate = Date('12/31/2999') then
				
					ldCompleteDate = Date(dw_recommend.GetItemDateTime(llRowPos,"complete_date"))
				
//					liFind = dw_recommend.Find(" string(expiration_date,'YYYY/MM/DD') < '" + string(ldExpDate,'YYYY/MM/DD') + "' " ,1, dw_recommend.RowCount()) 

					liFind = dw_recommend.Find("string(complete_date,'YYYY/MM/DD') <> '" + string(ldCompleteDate,'YYYY/MM/DD') + "' and string(complete_date,'YYYY/MM/DD') < '" + string(ldCompleteDate,'YYYY/MM/DD') + "'" ,1, dw_recommend.RowCount()) 
				
				
				
					if liFind > 0 then
						MessageBox ("Pick Warning","FIFO rule is violated!")
					end if
								

				end if
			
				
				
			End If

			
			
			//String_arg contains Location + Serial + lot + po + po2 seperated by commas
			//06/03 - PCONKL - Include Inv Type
			//08/03 - PCONKL - Change delimiter from , to | (comma in data causing bad parsing)
	
			
			
			lsWork = dw_recommend.GetItemString(llRowPos,"l_code") + '|'
			If not isnull(dw_recommend.GetItemString(llRowPos,"serial_no")) Then
				lsWork += dw_recommend.GetItemString(llRowPos,"serial_no") + '|'
			Else
				lsWork +='|'
			End If
			If not isnull(dw_recommend.GetItemString(llRowPos,"lot_no")) Then
				lsWork += dw_recommend.GetItemString(llRowPos,"lot_no") + '|'
			Else
				lsWork +='|'
			End If
			If not isnull(dw_recommend.GetItemString(llRowPos,"po_no")) Then
				lsWork += dw_recommend.GetItemString(llRowPos,"po_no") + '|'
			Else
				lsWork +='|'
			End If
			If not isnull(dw_recommend.GetItemString(llRowPos,"po_no2")) Then
				lsWork += dw_recommend.GetItemString(llRowPos,"po_no2") + '|'
			Else
				lsWork +='|'
			End If
			If not isnull(dw_recommend.GetItemString(llRowPos,"Container_id")) Then /* 11/02 - PCONKL */
				lsWork += dw_recommend.GetItemString(llRowPos,"Container_id") + '|'
			Else
				lsWork +='|'
			End If
			If not isnull(dw_recommend.GetItemString(llRowPos,"country_of_Origin")) Then /* 02/03 - PCONKL */
				lsWork += dw_recommend.GetItemString(llRowPos,"country_of_Origin") + '|'
			Else
				lsWork +='|'
			End If
			If not isnull(dw_recommend.GetItemString(llRowPos,"inventory_Type")) Then /* 06/03 - PCONKL */
				lsWork += dw_recommend.GetItemString(llRowPos,"inventory_Type") + '|'
			Else
				lsWork +='|'
			End If
			
			// 08/04 - PCONKL - include Container DIMS and weight
			If not isnull(dw_recommend.GetItemNumber(llRowPos,"Cntnr_Length")) Then 
				lsWork += String(dw_recommend.GetItemNumber(llRowPos,"Cntnr_Length") ) + '|'
			Else
				lsWork +='|'
			End If
			If not isnull(dw_recommend.GetItemNumber(llRowPos,"Cntnr_Width")) Then 
				lsWork += String(dw_recommend.GetItemNumber(llRowPos,"Cntnr_Width") ) + '|'
			Else
				lsWork +='|'
			End If
			If not isnull(dw_recommend.GetItemNumber(llRowPos,"Cntnr_height")) Then 
				lsWork += String(dw_recommend.GetItemNumber(llRowPos,"Cntnr_Height") ) + '|'
			Else
				lsWork +='|'
			End If
			If not isnull(dw_recommend.GetItemNumber(llRowPos,"Cntnr_Weight")) Then 
				lsWork += String(dw_recommend.GetItemNumber(llRowPos,"Cntnr_Weight") )
			Else
				//lsWork +='|'
			End If
			
			
			lstrparms.String_arg[llArrayPos] = lsWork /*concatonated loc,serial & lot & po 1&2, Container ID, Inv Type*/
			lstrparms.Decimal_arg[llArrayPos] = dw_recommend.GetItemNumber(llRowPos,"c_pick_amt")
			lstrparms.Integer_arg[llArrayPos] = dw_recommend.GetItemNumber(llRowPos,"component_no")
			lstrparms.Long_arg[llArrayPos] = dw_recommend.GetItemNumber(llRowPos,"owner_id")
			lstrparms.datetime_arg[llArrayPos] = dw_recommend.GetItemDateTime(llRowPos,"expiration_Date") /* 11/02 - PCONKL */
			ldQty += dw_recommend.GetItemNumber(llRowPos,"c_pick_amt")
			
		End If			
		
	Next
	
End If /*current rows exist*/

//10/09 - PCONKL - Save any sort
lsSyntax = dw_recommend.Object.DataWindow.Syntax
llPos = Pos(lsSyntax,"sort=")
If llPOs > 0 Then
	llPos += 6 /*start after "sort=" */
	lsSort = Mid(lsSyntax,llPos, (Pos(lsSyntax,'"',llPos)) - llPos)
End IF

SetProfileString(gs_inifile,'DWSORT',gs_project + '-PICKRECOMMEND',lsSort)

message.PowerobjectParm = lstrparms
Return 0



end event

type cb_expand from commandbutton within w_pick_recommend
boolean visible = false
integer x = 3365
integer y = 29
integer width = 274
integer height = 93
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Expand"
end type

event clicked;
parent.SetRedraw(False)

environment env

integer rtn

rtn = GetEnvironment(env)


//parent.WindowState = Maximized!

parent.height = w_main.height - 200 //env.ScreenHeight	- 400
parent.y = w_main.y + 100

dw_recommend.height = parent.height - (384)

cb_help.y = parent.height - (112 + cb_help.height)

cb_sort.y = parent.height - (112 + cb_sort.height)

cb_cancel.y = parent.height - (112 + cb_cancel.height)


cb_ok.y = parent.height - (112 +  cb_ok.height)

cb_clear.y = parent.height - (112 + cb_clear.height)

parent.SetRedraw(True)
end event

type cb_sort from commandbutton within w_pick_recommend
integer x = 486
integer y = 1360
integer width = 271
integer height = 93
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Sort"
end type

event clicked;long ll_ret
String str_null
SetNull(str_null)

ll_ret=dw_recommend.Setsort(str_null)
ll_ret=dw_recommend.Sort()
if isnull(ll_ret) then ll_ret=0
	
end event

type cb_cancel from commandbutton within w_pick_recommend
integer x = 1349
integer y = 1360
integer width = 271
integer height = 93
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancel"
boolean cancel = true
end type

event clicked;
istrparms.Cancelled = True
Close(Parent)
end event

type cb_help from commandbutton within w_pick_recommend
integer x = 3182
integer y = 1360
integer width = 216
integer height = 93
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Help"
end type

event clicked;
ShowHelp(g.is_helpFile,Topic!,556)
end event

type st_supplier from statictext within w_pick_recommend
integer x = 4
integer y = 58
integer width = 633
integer height = 96
integer textsize = -8
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

type dw_recommend from u_dw_ancestor within w_pick_recommend
event ue_hide_unused ( )
integer y = 154
integer width = 4513
integer height = 1181
string dataobject = "d_pick_recommend"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
end type

event ue_hide_unused();This.SetRedraw(False)

If This.Find("serial_no <> '-'",1,This.RowCount()) > 0 Then
	This.Modify("serial_no.width=311 content_serial_no_t.width=311")
Else
	This.Modify("serial_no.width=0 content_serial_no_t.width=0")
End If

If This.Find("lot_no <> '-'",1,This.RowCount()) > 0 Then
	This.Modify("lot_no.width=311 lot_no_t.width=311")
Else
	This.Modify("lot_no.width=0 lot_no_t.width=0")
End If

If This.Find("po_no <> '-'",1,This.RowCount()) > 0 Then
	This.Modify("po_no.width=311 po_no_t.width=311")
Else
	This.Modify("po_no.width=0 po_no_t.width=0")
End If

If This.Find("po_no2 <> '-'",1,This.RowCount()) > 0 Then
	This.Modify("po_no2.width=556 po_no2_t.width=556")
Else
	This.Modify("po_no2.width=0 po_no2_t.width=0")
End If

If This.Find("po_no2 <> '-'",1,This.RowCount()) > 0 Then
	This.Modify("po_no2.width=556 po_no2_t.width=556")
Else
	This.Modify("po_no2.width=0 po_no2_t.width=0")
End If

If This.Find("Container_ID <> '-'",1,This.RowCount()) > 0 Then
	This.Modify("Container_ID.width=556 container_id_t.width=556")
	This.Modify("cntnr_length.width=206 cntnr_length_t.width=206")
	This.Modify("cntnr_width.width=206 cntnr_width_t.width=206")
	This.Modify("cntnr_height.width=206 cntnr_height_t.width=206")
	This.Modify("cntnr_weight.width=206 cntnr_weight_t.width=206")
Else
	This.Modify("Container_ID.width=0 container_id_t.width=0")
	This.Modify("cntnr_length.width=0 cntnr_length_t.width=0")
	This.Modify("cntnr_width.width=0 cntnr_width_t.width=0")
	This.Modify("cntnr_height.width=0 cntnr_height_t.width=0")
	This.Modify("cntnr_weight.width=0 cntnr_weight_t.width=0")
End If

If This.Find("String(expiration_date,'mm/dd/yyyy') <> '12/31/2999'",1,This.RowCount()) > 0 Then
	This.Modify("expiration_date.width=311 expiration_date_t.width=311")
Else
	This.Modify("expiration_date.width=0")
End If

This.SetRedraw(True)
end event

event itemchanged;
If dwo.Name = "c_pick_amt" Then
	Parent.postEvent("ue_calc_remaining")
End IF
end event

event constructor;call super::constructor;
If g.is_coo_ind  <> 'Y' Then
	this.Modify("country_of_origin.visible=0")
End If
end event

type st_remain from statictext within w_pick_recommend
integer x = 1156
integer y = 74
integer width = 1894
integer height = 77
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
boolean enabled = false
boolean focusrectangle = false
end type

type st_total from statictext within w_pick_recommend
integer x = 1156
integer y = 16
integer width = 1894
integer height = 77
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
boolean enabled = false
boolean focusrectangle = false
end type

type st_2 from statictext within w_pick_recommend
integer x = 881
integer y = 74
integer width = 252
integer height = 77
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
boolean enabled = false
string text = "Remaining:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_3 from statictext within w_pick_recommend
integer x = 881
integer y = 16
integer width = 252
integer height = 77
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
boolean enabled = false
string text = "Total:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_1 from statictext within w_pick_recommend
integer x = 647
integer y = 35
integer width = 179
integer height = 77
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
boolean enabled = false
string text = "Pick:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_sku from statictext within w_pick_recommend
integer x = 4
integer y = 3
integer width = 633
integer height = 96
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Sku:"
boolean focusrectangle = false
end type

type cb_clear from commandbutton within w_pick_recommend
integer x = 2725
integer y = 1360
integer width = 216
integer height = 93
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Clear"
end type

event clicked;
Parent.TriggerEvent("ue_clear")
end event

type cb_ok from commandbutton within w_pick_recommend
integer x = 1814
integer y = 1360
integer width = 187
integer height = 93
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "OK"
boolean default = true
end type

event clicked;close(parent)
end event

