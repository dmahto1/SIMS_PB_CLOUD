$PBExportHeader$w_nike_ship_label.srw
$PBExportComments$Print Nike Ship labels (plain paper)
forward
global type w_nike_ship_label from w_std_report
end type
type cbx_1 from checkbox within w_nike_ship_label
end type
end forward

global type w_nike_ship_label from w_std_report
integer x = 567
integer y = 564
integer width = 3314
integer height = 1968
string title = "Shipping Label"
long backcolor = 12632256
cbx_1 cbx_1
end type
global w_nike_ship_label w_nike_ship_label

type variables
DataWindowChild idwc_warehouse
String	isOrigSql


end variables

on w_nike_ship_label.create
int iCurrent
call super::create
this.cbx_1=create cbx_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cbx_1
end on

on w_nike_ship_label.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cbx_1)
end on

event open;call super::open;

ilHelpTopicID = 542
end event

event ue_clear;dw_select.Reset()
dw_select.Insertrow(0)
end event

event ue_retrieve;call super::ue_retrieve;// 12/11 - PCONKL - Plaguerized from Nike EWMS

Long i, j, ll_row, ll_cnt, ll_size_cnt, ll_item,  ll_qty, ll_ctn_row, ll_tot_qty
integer l_ret
String ls_sku, ls_size, ls_style, ls_prev_style,ls_coo
String ls_cust_code, ls_cust_name, ls_contact, ls_tel
String ls_cust_add1, ls_cust_add2, ls_cust_add3, ls_cust_add4
String ls_descript, ls_ppl, ls_dono ,ls_orderno
string ls_ctn_no ,ls_prev_ctn_no,ls_packer
Long ll_ctnno
String ls_shipid, lsMarkFor,lsMarkForA1

If w_do.idw_pack.AcceptText() = -1 Then Return
dw_report.Reset()

w_do.idw_Pack.SetSort("long(carton_no) A, SKU A") /* 03/12 - PCONKL - needs to be sorted by SKU so sizes for a SKU (Model.Color) print across page properly*/
w_do.idw_pack.Sort()

ls_cust_code = w_do.idw_main.GetItemString(1, "cust_Code") 
ls_cust_name =	w_do.idw_main.GetItemString(1, "cust_name")
ls_cust_add1 = w_do.idw_main.GetItemString(1, "address_1")
ls_cust_add2 = w_do.idw_main.GetItemString(1, "address_2")
ls_cust_add3 = w_do.idw_main.GetItemString(1, "address_3")
ls_cust_add4 = w_do.idw_main.GetItemString(1, "address_4")
ls_packer	 = w_do.idw_main.GetItemString(1, "user_field11")


lsMarkFor = w_do.idw_main.GetITemString(1,"User_Field3") /* Mark For ID*/
lsMArkForA1 = w_do.idw_main.GetITemString(1,"User_Field8") /* Mark For Name*/

If IsNull(ls_cust_code) Then ls_cust_code = ""
If IsNull(ls_cust_name) Then ls_cust_name = ""

ll_item = 1
ll_tot_qty = 0
ll_cnt = w_do.idw_pack.RowCount()

For i = 1 to ll_cnt
	
	ls_ctn_no = w_do.idw_pack.GetItemString(i, "carton_no")
//	ll_ctnno = w_do.idw_pack.GetItemNumber(i, "ctnno")
	ll_ctnno = Long(w_do.idw_pack.GetItemString(i, "carton_no"))
	ls_sku = w_do.idw_pack.GetItemString(i, "sku")
	ls_style = Left(ls_sku, 10)
	ls_size = Trim(Mid(ls_sku, 12, 5))
	ll_qty = w_do.idw_pack.GetItemNumber(i,"quantity")
	
	If ll_qty = 0 Then Continue
	
	If ls_ctn_no<>ls_prev_ctn_no or ls_style <> ls_prev_style or ll_size_cnt = 10 Then
		
		If ((ls_ctn_no<>ls_prev_ctn_no) or (ls_style <> ls_prev_style)) and ll_tot_qty > 0 Then
			
			dw_report.SetItem(ll_row,"total_qty",ll_tot_qty)
			ll_tot_qty = 0
			ll_item += 1
			
		End If
		
		ll_row = dw_report.InsertRow(0)
		
		if ls_ctn_no<>ls_prev_ctn_no then
	
	      ll_ctn_row =  ll_row
	
		end if	
		
		dw_report.SetItem(ll_row,"item_no",ll_item)
      	dw_report.SetItem(ll_row,"ctn_no", ls_ctn_no)
		dw_report.SetItem(ll_row,"ctnno", ll_ctnno)   
		dw_report.SetItem(ll_row,"style", ls_style)
	//	dw_report.SetItem(ll_row, 'coo', ls_coo)
		
		If not Isnull(lsMArkFor) or lsMarkFor <>"" then
			dw_report.SetItem(ll_row,"cust_name",Trim(lsMarkFor) +","+Trim(lsMarkForA1))
		else
			dw_report.SetItem(ll_row,"cust_name", ls_cust_name)  //ls_cust_code + " " +
		End If
		
		dw_report.SetItem(ll_row,"cust_address1", ls_cust_add1)
		dw_report.SetItem(ll_row,"cust_address2", ls_cust_add2)
		dw_report.SetItem(ll_row,"cust_address3", ls_cust_add3)
		dw_report.SetItem(ll_row,"cust_address4", ls_cust_add4)
		dw_report.SetItem(ll_row,"packer", ls_packer)
		dw_report.SetItem(ll_row,"contact", ls_contact)
		dw_report.SetItem(ll_row,"ctn_remark", w_do.idw_main.GetItemString(1, "User_Field20"))
		dw_report.SetItem(ll_row,"telephone", w_do.idw_main.getitemstring(1,"User_Field13")) /* really region (UF13)*/
		dw_report.SetItem(ll_row,"do_no", w_do.idw_main.getitemstring(1,"invoice_no")) /* really the Order Number, not the DO_NO*/
	//	dw_report.SetItem(ll_row,"ppl_no", ls_ppl)
		dw_report.SetItem(ll_row,"order_no", ls_orderno)
		dw_report.SetItem(ll_row,"date", Date(w_do.idw_main.GetItemDateTime(1,"schedule_date")))
		dw_report.SetItem(ll_row,"transporter", w_do.idw_main.GetItemString(1,"carrier"))
		dw_report.SetItem(ll_row,"need_date", w_do.idw_main.GetItemDateTime(1,"request_date"))
		ll_size_cnt = 0
		
	End If
	
	ll_size_cnt += 1
	ll_tot_qty += ll_qty
	dw_report.SetItem(ll_row, 10 + ll_size_cnt, ls_size)
	dw_report.SetItem(ll_row, 20 + ll_size_cnt, ll_qty)
	ls_prev_ctn_no= ls_ctn_no    //
	ls_prev_style = ls_style
	
Next

dw_report.SetItem(ll_row,"total_qty",ll_tot_qty)
dw_report.Sort()
dw_report.GroupCalc()

If dw_report.RowCount() > 0 Then
	im_menu.m_file.m_print.Enabled = True
End If


end event

event ue_postopen;call super::ue_postopen;
This.TriggerEvent('ue_retrieve')
end event

event resize;call super::resize;
dw_report.Resize(workspacewidth() - 20,workspaceHeight()-130)
end event

event ue_print;
//Ancestor being overridden
String	lsDONO
Long	llPrintCount

lsDONO = w_do.idw_Main.GetITEmString(1,'do_no')

//Only ad Admin or Super can re-print if already printed once
Select carton_label_Print_Count Into :llPrintCount From delivery_master Where do_no = :lsDONO;

If IsNull(llPrintCount) Then llPrintCount = 0
//If llPrintCount > 0 Then
//	If gs_role = "2" Then
//		MessageBox("Labels", "Only an ADMIN or SUPER can re-print labels!",StopSign!)
//		Return
//	End If
//End If

OpenWithParm(w_dw_print_options,dw_report) 

If message.doubleparm = 1 Then
		
	Execute Immediate "Begin Transaction" using SQLCA; /* 11/04 - PCONKL - Auto Commit Turned on to eliminate DB locks*/
	
	Update Delivery_master
	Set carton_label_Print_Count = ( :llPrintCount + 1 ) where Do_no = :lsDONO;
	
	Execute Immediate "COMMIT" using SQLCA;
	
End if
end event

type dw_select from w_std_report`dw_select within w_nike_ship_label
boolean visible = false
integer x = 960
integer y = 8
integer width = 1929
integer height = 160
boolean enabled = false
boolean border = false
borderstyle borderstyle = stylebox!
end type

type cb_clear from w_std_report`cb_clear within w_nike_ship_label
integer x = 2350
integer y = 12
integer width = 270
integer height = 100
integer taborder = 20
end type

event cb_clear::clicked;call super::clicked;
dw_select.reset()
dw_select.insertrow(0)

end event

type dw_report from w_std_report`dw_report within w_nike_ship_label
integer x = 0
integer y = 116
integer width = 3191
integer height = 1664
integer taborder = 30
string dataobject = "d_nike_ctn_label"
boolean hscrollbar = true
end type

type cbx_1 from checkbox within w_nike_ship_label
integer x = 50
integer y = 20
integer width = 672
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Print SHIP Address"
boolean checked = true
end type

event clicked;
if this.checked then
	dw_report.Object.cust_address_t.visible = 1

	dw_report.Object.cust_address1.visible = 1
	dw_report.Object.cust_address2.visible = 1
	dw_report.Object.cust_address3.visible = 1
	dw_report.Object.cust_address4.visible = 1	
	

else

	dw_report.Object.cust_address_t.visible = 0	
	
	dw_report.Object.cust_address1.visible = 0
	dw_report.Object.cust_address2.visible = 0
	dw_report.Object.cust_address3.visible = 0
	dw_report.Object.cust_address4.visible = 0

	
end if
end event

