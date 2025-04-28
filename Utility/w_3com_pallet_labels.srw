HA$PBExportHeader$w_3com_pallet_labels.srw
$PBExportComments$Pallet Labels for 3COM
forward
global type w_3com_pallet_labels from w_main_ancestor
end type
type cb_print from commandbutton within w_3com_pallet_labels
end type
type dw_label from u_dw_ancestor within w_3com_pallet_labels
end type
type cb_clear from commandbutton within w_3com_pallet_labels
end type
end forward

global type w_3com_pallet_labels from w_main_ancestor
boolean visible = false
integer width = 1797
integer height = 1832
string title = "3Com Pallet Labels"
event ue_print ( )
cb_print cb_print
dw_label dw_label
cb_clear cb_clear
end type
global w_3com_pallet_labels w_3com_pallet_labels

type variables
//n_warehouse i_nwarehouse
//n_labels	invo_labels
n_3com_labels invo_3com_labels

String	isUCCSCompanyPrefix, isUCCSWHPrefix

String	isDONO

Boolean	ibReady

string isChangedColumn
integer iiChangedRow
boolean ibNotNumber
end variables

event ue_print();Str_Parms	lstrparms

Long	llQty,	&
		llRowCount,	&
		llRowPos, &
		ll_rtn, &
		ll_alloc_qty,llRowPos1
		
Any	lsAny

String	ls_format, lsPrinter
			
boolean lb_print
long ll_cnt,ll_cnt1,ll_carton_cnt,ll_count,ll_count_prev

string lsBoxCount, lsPallet
integer liButton, i, liRow

Dw_Label.AcceptText()

//// 09/04 - PCONKL - See if we have a default label printer stored in the .ini file
//lsPrinter = ProfileString(gs_iniFile,'PRINTERS','SHIPLABEL','')
//If lsPrinter > '' Then PrintSetPrinter(lsPrinter)

//Count the number of Pallets (rows)
FOR ll_count= 1 TO dw_label.RowCount()
	
	IF dw_label.object.c_print_ind[ll_count] <> 'Y' THEN Continue
	IF ll_count > 1 THEN 
		ll_count_prev=ll_count - 1
	ELSE
		ll_count_prev=1
		ll_carton_cnt ++
		Continue
	END IF	
	
NEXT

//Print each detail Row
llRowCount = dw_label.RowCount()
For llRowPos = 1 to llRowCount /*each detail row */
	
	//ll_alloc_qty = dw_label.GetItemNumber(llRowPos,'delivery_detail_alloc_qty')
	//If ll_alloc_qty = 0 Then Continue
	IF dw_label.object.c_print_ind[llRowPos] <> 'Y' THEN Continue
	//dts ls_carton_no= dw_label.object.delivery_packing_carton_no[llRowPos]
	//llQty = dw_label.object.c_qty_per_carton[llRowPos] /*Number of copies from Setup window*/
	llQty = 1 // not allowing for more than 1 copy at this time...
	Lstrparms.Long_arg[1] = llQty
//		lstrparms.Long_arg[1] = llQty/*default qty on print options*/
		
	IF Not lb_print THEN /*only need to prompt once*/
		
		OpenWithParm(w_label_print_options, lStrParms)
		Lstrparms = Message.PowerObjectParm		  
		If lstrParms.Cancelled Then Exit
   	lb_print = True			
		 
	END IF
		  
	//LstrParms.String_arg[1] = dw_label.object.customer_user_field2[llRowPos] +".DWN"// **Change Later
	
	lsBoxCount = dw_label.GetItemString(llRowPos, 'user_field1')
	Lstrparms.String_arg[1] = lsBoxCount
	Lstrparms.String_arg[2] = string(llRowPos)
	Lstrparms.String_arg[3] = string(llRowCount)
	Lstrparms.String_arg[4] = dw_label.GetItemString(llRowPos, 'Cust_Order_No')
	
	lsAny=lstrparms		
	invo_3com_labels.uf_3com_pallet_label(lsAny, dw_label)
	
	//Update UF1 in Delivery Packing...	
	lsPallet = dw_label.GetItemString(llRowPos, 'Carton_no')
	//End point of search (w_do.idw_pack.RowCount() + 1) is one more than row count to avoid infinite loop
	liRow = w_do.idw_pack.find("carton_no = '" + lsPallet + "'", 1, w_do.idw_pack.RowCount() + 1)
	do while lirow > 0
		w_do.idw_pack.SetItem(liRow, 'User_Field1', lsBoxCount)
		liRow = w_do.idw_pack.find("carton_no = '" + lsPallet + "'", liRow + 1, w_do.idw_pack.RowCount() + 1)
		w_do.ib_changed = true
	loop

Next /*detail row to Print*/

////09/04 - PCONKL - Store the last label printer used in the .ini file
//lsPrinter = PrintGetPrinter()
//SetProfileString(gs_inifile,'PRINTERS','SHIPLABEL',lsPrinter)

end event

on w_3com_pallet_labels.create
int iCurrent
call super::create
this.cb_print=create cb_print
this.dw_label=create dw_label
this.cb_clear=create cb_clear
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_print
this.Control[iCurrent+2]=this.dw_label
this.Control[iCurrent+3]=this.cb_clear
end on

on w_3com_pallet_labels.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_print)
destroy(this.dw_label)
destroy(this.cb_clear)
end on

event ue_postopen;call super::ue_postopen;
// 09/04 - PCONKL - Being triggered from whip docs window, don't want to re-post
If dw_label.RowCount() > 0 Then Return

invo_3com_labels = Create n_3com_labels
//i_nwarehouse = Create n_warehouse

cb_print.Enabled = False

//We can only print based on DO_NO - User must have valid order open to pass DO_NO in from w_DO
If isValid(w_do) Then
	if w_do.idw_main.RowCOunt() > 0 Then
		isDoNo = w_do.idw_main.GetITemString(1,'do_no')
	End If
End If

If isNUll(isDONO) or  isDoNO = '' Then
	Messagebox('Labels','You must have an order retrieved in the Delivery Order Window~rbefore you can print labels!')
Else
	//limit to Carton Type of Pallet (in data window sql)?
	This.TriggerEvent('ue_retrieve')
End If

dw_label.setcolumn(4) //set current column to Box Count (uf1)

end event

event ue_retrieve;call super::ue_retrieve;String	lsDONO,	&
			lsCartonNo

Long		llRowCount,	&
			llRowPos


cb_print.Enabled = False

If isdono > '' Then
	dw_label.Retrieve(gs_project,isdono)
End If

If dw_label.RowCOunt() > 0 Then
Else
	Messagebox('Labels','Order Not found!')
	Return
End If

lsDoNo = dw_label.GetITemString(1,'delivery_Master_DO_NO')

//Default the Label Format and Starting Carton Number
llRowCount = dw_label.RowCount()


cb_print.Enabled = True

// 12/03 - PCONKL - WE need the Project level UCCS Company prefix and the Warehouse level prefix
Select ucc_Company_Prefix into :isuccscompanyprefix
FRom Project
Where Project_ID = :gs_Project;

SElect ucc_location_Prefix into :isuccswhprefix
From Warehouse
Where wh_Code = (select wh_Code from Delivery_MASter where Project_ID = :gs_Project and do_no = :isdono);


end event

event ue_selectall;call super::ue_selectall;Long	llRowPos,	&
		llRowCount

		
dw_label.SetRedraw(False)

llRowCount = dw_label.RowCount()
For llRowPos = 1 to llRowCount
	dw_label.SetITem(llRowPos,'c_print_ind','Y')
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

event close;call super::close;//IF ISVALID(i_nwarehouse) THEN Destroy(i_nwarehouse)
end event

event open;call super::open;
If NOt isvalid(w_print_ship_docs) Then this.visible = True
end event

type cb_cancel from w_main_ancestor`cb_cancel within w_3com_pallet_labels
boolean visible = false
integer x = 1938
integer y = 1392
integer height = 80
integer taborder = 30
end type

type cb_ok from w_main_ancestor`cb_ok within w_3com_pallet_labels
integer x = 1358
integer y = 24
integer height = 80
integer taborder = 20
boolean default = false
end type

type cb_print from commandbutton within w_3com_pallet_labels
integer x = 946
integer y = 24
integer width = 329
integer height = 80
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Print"
end type

event clicked;Parent.TriggerEvent('ue_Print')
end event

type dw_label from u_dw_ancestor within w_3com_pallet_labels
integer x = 9
integer y = 136
integer width = 1701
integer height = 1448
boolean bringtotop = true
string dataobject = "d_3com_pallet_label"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event retrieveend;call super::retrieveend;/*
//As this is compute column needs to be assigned value 
// DGM 09/22/03
integer i
FOR i = 1 TO rowcount
 This.object.c_qty_per_carton[i]=1
NEXT

*/
end event

event itemchanged;call super::itemchanged;iiChangedRow = Row
isChangedColumn = this.GetColumnName()
if isChangedColumn = 'user_field1' then
	if not isNumber(data) then
		messagebox (gstitle, "Box Count must be a number.")
		ibNotNumber = true
	else
		ibNotNumber = false
	end if
end if
end event

event ue_postitemchanged;call super::ue_postitemchanged;integer liButton, i
string lsBoxCount

//messagebox ("Column", string(this.getcolumnName()))
if isChangedColumn = 'user_field1' then 
	if ibNotNumber then
		this.SetColumn(4)
		this.SetRow(row)
	else
		this.SetItem(row, 'c_print_ind', 'Y')
		if row = 1  and this.RowCount() > 3 then
			lsBoxCount = this.GetItemString(row, 'user_field1')
			//liButton = messagebox(gstitle, 'Copy ' + lsBoxCount + ' to other rows?',,YesNo!)
			liButton = messagebox(gstitle, 'Copy Box Count "' + lsBoxCount + '" to other rows?',Question!,YesNo!)
			if liButton = 1 then
				for i = 2 to this.RowCount()
					this.SetItem(i, 'User_Field1', lsBoxCount)
					this.SetItem(i, 'c_print_ind', 'Y')
				next
			end if
		end if
	end if
end if

end event

type cb_clear from commandbutton within w_3com_pallet_labels
integer x = 393
integer y = 24
integer width = 338
integer height = 80
integer taborder = 50
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Clear All"
end type

event clicked;Parent.Event ue_unselectall()
end event

