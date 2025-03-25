$PBExportHeader$w_gmm_receive_order.srw
$PBExportComments$Recibo / Empaque / Tranferencia
forward
global type w_gmm_receive_order from w_std_report
end type
end forward

global type w_gmm_receive_order from w_std_report
integer width = 3712
integer height = 2464
string title = "Receiving Report By Order for GM Mexico"
end type
global w_gmm_receive_order w_gmm_receive_order

type variables
String	isOrigSql


end variables

on w_gmm_receive_order.create
call super::create
end on

on w_gmm_receive_order.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;call super::open;
isOrigSql = dw_report.getsqlselect()



end event

event ue_retrieve;String ls_sku, lsWhere, lsNewSql, ls_Folio, ls_line_item, ls_whCode, ls_LocLine1, ls_LocLine2, ls_break
Long ll_cnt, ll_Folio, ll_LocCount
integer i
datastore lds_sku_locations

If dw_select.AcceptText() = -1 Then Return

//Initialize Date Flags

SetPointer(HourGlass!)
dw_report.Reset()

//Always tackon project
lsWhere += " and receive_master.Project_id = '" + gs_project + "'"

//Tackon Warehouse
if  not isnull(dw_select.GetItemString(1,"warehouse")) then
	ls_whCode = dw_select.GetItemString(1,"warehouse")
	lswhere += " and Receive_Master.wh_code = '" + ls_whCode + "'"
end if

//Tackon Ro_No
if  not isnull(dw_select.GetItemString(1,"Ro_No")) then
	lswhere += " and Receive_Master.Ro_No = '" + dw_select.GetItemString(1,"Ro_No") + "'"
end if

//Tackon BOL Nbr
if  not isnull(dw_select.GetItemString(1,"bol_nbr")) and dw_select.GetItemString(1,"bol_nbr") <> "" then
	lswhere += " and Receive_Master.Supp_Invoice_No = '" + dw_select.GetItemString(1,"bol_nbr") + "'"
end if
	
If lsWhere > '  ' Then
	lsNewSql = isOrigSql + lsWhere 
	//MESSAGEBOX("LS NEWSQL", LSNEWSQL)
	dw_report.setsqlselect(lsNewsql)
Else
	dw_report.setsqlselect(isOrigSql)
End If

ll_cnt = dw_report.Retrieve()

If ll_cnt > 0 Then
		i = 1
		do while i <= ll_cnt 
			ls_LocLine1 = " "
			ls_LocLine2 = " "
			ls_Folio = right(dw_report.GetItemString(i,"RO_No"),6)
			ls_line_item = string(dw_report.GetItemNumber(i,"Line_Item_No"))
			ls_sku = dw_report.GetItemString(i,"receive_detail_sku")
			dw_report.setItem(i, "folio", ls_Folio + ls_line_item)
			// Get/Display all Locations for the SKU on the "ubicacion actual" line 
			lds_sku_locations = Create datastore
			lds_sku_locations.Dataobject = 'd_sku_locations'
			lds_sku_locations.SetTransObject(sqlca)
			lds_sku_locations.retrieve(gs_project, ls_whCode, ls_sku)
				lds_sku_locations.SetSort("#2 A")
				lds_sku_locations.Sort()
			ll_LocCount = lds_sku_locations.rowcount()
			if ll_LocCount > 0 then 
				do while ll_LocCount > 0
					if ll_LocCount < 15 then 
						ls_LocLine1 = ls_LocLine1  + lds_sku_locations.GetItemString(ll_LocCount,"content_l_code") + "  |  "
					else
						ls_LocLine2 = ls_LocLine2  + lds_sku_locations.GetItemString(ll_LocCount,"content_l_code") + "  |  "
					end if
					ll_LocCount = ll_LocCount - 1
				loop
				dw_report.setItem(i, "LocLine1", ls_LocLine1)	
				dw_report.setItem(i, "LocLine2", ls_LocLine2)
			end if
			i = i+1
		loop  
	im_menu.m_file.m_print.Enabled = True
	dw_report.Setfocus()	
Else
	im_menu.m_file.m_print.Enabled = False	
	MessageBox(is_title, "No records found!")
	dw_select.Setfocus()
End If



end event

event resize;dw_report.Resize(workspacewidth() - 30,workspaceHeight()-270)
end event

event ue_clear;dw_select.Reset()
dw_select.InsertRow(0)


end event

event ue_postopen;//If Receive Order is Open, default the Order Number
If isVAlid(w_ro) Then
	if w_ro.idw_main.RowCOunt() > 0 Then
		dw_select.SetItem(1,"bol_nbr", w_ro.tab_main.tabpage_main.sle_orderno.text)
		dw_select.SetItem(1,"ro_no", w_ro.idw_main.GetItemString(1,"ro_no"))
		dw_select.SetItem(1,"warehouse", w_ro.idw_main.GetItemString(1,"wh_code"))
		This.TriggerEvent('ue_retrieve')
	End If
End If


end event

type dw_select from w_std_report`dw_select within w_gmm_receive_order
integer width = 3630
integer height = 112
string dataobject = "d_gmm_receive_order_select"
boolean border = false
borderstyle borderstyle = stylebox!
end type

type cb_clear from w_std_report`cb_clear within w_gmm_receive_order
integer x = 3209
integer y = 60
end type

type dw_report from w_std_report`dw_report within w_gmm_receive_order
integer x = 14
integer y = 128
integer width = 3621
integer height = 2128
integer taborder = 30
string dataobject = "d_gmm_receive_order"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

