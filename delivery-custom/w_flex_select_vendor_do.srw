HA$PBExportHeader$w_flex_select_vendor_do.srw
forward
global type w_flex_select_vendor_do from window
end type
type cb_3 from commandbutton within w_flex_select_vendor_do
end type
type dw_1 from datawindow within w_flex_select_vendor_do
end type
type cb_2 from commandbutton within w_flex_select_vendor_do
end type
type cb_1 from commandbutton within w_flex_select_vendor_do
end type
type dw_select_vendor_dono from datawindow within w_flex_select_vendor_do
end type
end forward

global type w_flex_select_vendor_do from window
integer width = 1595
integer height = 1492
boolean titlebar = true
string title = "Select Vendor DO"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cb_3 cb_3
dw_1 dw_1
cb_2 cb_2
cb_1 cb_1
dw_select_vendor_dono dw_select_vendor_dono
end type
global w_flex_select_vendor_do w_flex_select_vendor_do

on w_flex_select_vendor_do.create
this.cb_3=create cb_3
this.dw_1=create dw_1
this.cb_2=create cb_2
this.cb_1=create cb_1
this.dw_select_vendor_dono=create dw_select_vendor_dono
this.Control[]={this.cb_3,&
this.dw_1,&
this.cb_2,&
this.cb_1,&
this.dw_select_vendor_dono}
end on

on w_flex_select_vendor_do.destroy
destroy(this.cb_3)
destroy(this.dw_1)
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.dw_select_vendor_dono)
end on

event open;
dw_1.SetTransObject(SQLCA)
dw_1.insertrow(0)
//SARUN2015JULY15 : Added Search Criter for Flex Vendor Selection Window
dw_select_vendor_dono.SetTransObject(SQLCA)
dw_select_vendor_dono.Retrieve()
end event

type cb_3 from commandbutton within w_flex_select_vendor_do
integer x = 1074
integer y = 136
integer width = 402
integer height = 76
integer taborder = 20
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Clear"
end type

event clicked;dw_1.reset()
dw_1.SetTransObject(SQLCA)
dw_1.insertrow(0)
dw_select_vendor_dono.SetTransObject(SQLCA)
	string ls_filter
	ls_filter = ''

	dw_select_vendor_dono.setfilter(ls_filter)
	dw_select_vendor_dono.filter()
	
dw_select_vendor_dono.Retrieve()
end event

type dw_1 from datawindow within w_flex_select_vendor_do
integer y = 12
integer width = 1499
integer height = 156
integer taborder = 10
string title = "none"
string dataobject = "d_flex_vendorloc_search"
boolean border = false
end type

event itemchanged;
	string ls_filter
	ls_filter = ''

//	dw_select_vendor_dono.setfilter(ls_filter)
//	dw_select_vendor_dono.filter()
	

Choose Case dwo.name
	
	case 'loc'


	ls_filter = "trim(l_code) = '" + data + "'"
	dw_select_vendor_dono.setfilter(ls_filter)
	dw_select_vendor_dono.filter()
	Setitem(1,'vendor','')

End Choose






end event

event editchanged;String ls_filter,ls_loc


ls_loc= Getitemstring(1,'loc')

ls_filter = " trim(l_code) = " + "'" + ls_loc + "'"

Choose Case dwo.name
	
	case 'vendor'

if len(data) > 0 then 
	if len(ls_loc) > 0 then
		  ls_filter= ls_filter + " and  trim(po_no) like '" + data + "%" + "'"
	else
		ls_filter = "trim(po_no) like '" + data + "%" + "'"
	end if
else
	if len(ls_loc) > 0 then
		  ls_filter= ls_filter
	else
		ls_filter = ''		
	end if
end if

		dw_select_vendor_dono.setfilter(ls_filter)
		dw_select_vendor_dono.filter()
	
End Choose
end event

type cb_2 from commandbutton within w_flex_select_vendor_do
integer x = 110
integer y = 1236
integer width = 402
integer height = 112
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "OK"
boolean default = true
end type

event clicked;
SetPointer(Hourglass!)

integer li_idx
long ll_row, ll_content_idx
string ls_ord_type

string ls_po_no
string ls_sku

datastore lds_vendor_content 

lds_vendor_content  = create datastore
lds_vendor_content.dataobject = "d_flex_vendor_content_list"
lds_vendor_content.SetTransObject(SQLCA)

w_do.idw_detail.Reset()



//The outbound order with LOCAL Order Type can contains only the value 'GST' under PO Nbr 2 (IM Permit) field.
// 
//The outbound order with INTERNATIONAL Order Type can contains all other value (excluding GST) under PO Nbr 2 (IM Permit) field.
// 
//So please validate either the user selected correct Vendor DO#''s  before create outbound order, and prompt error if the Vendor DO#'s selection is not correct
// 
//Example,  a & b are possible scenarios and c is not possible scenario.
// 
//a) if user selected three Vendor DO#'s and three Vendor DO#'s  contains 20 line items. All the 20 lines items have 'GST' under PO Nmr2, then create outbound order and assign order type as 'LOCAL'. 
// 
//b) if user selected three Vendor DO#'s and three Vendor DO#'s  contains 15 line items. All the 15 lines items have other values (it can be any thing, but not GST) under PO Nmr2, then create outbound order and assign order type as 'INTERNATIONAL'. 
// 
//c) If user selected three Vendor DO#'s and three Vendor DO#'s contains 22 line items. 10 line items have 'GST' under PO Nbr2 and 12 line items have other values, SIMS should reject this selection without creating order and prompt message 'Local and International order can not be mixed'.
//

datastore lds_check
string ls_pono[]
integer li_find

//FLEX-SIN  	I	INTERNATIONAL
//FLEX-SIN  	L	LOCAL

lds_check  = create datastore
lds_check.dataobject = "d_flex_vendor_distinct_pono2_list"
lds_check.SetTransObject(SQLCA)


for li_idx = 1 to dw_select_vendor_dono.RowCount()

	if dw_select_vendor_dono.GetItemNumber( li_idx, "selected") = 1 then
		
		ls_po_no = dw_select_vendor_dono.GetItemString( li_idx, "po_no")

		ls_pono[UpperBound(ls_pono)+1] = ls_po_no 

	end if	
	
next

if UpperBound(ls_pono) = 0 then
	
	MessageBox ("No Rows Selected", "There are no rows selected.")
	RETURN -1

end if

 lds_check.Retrieve( ls_pono[])

if lds_check.RowCount() > 0 then
	
	if lds_check.RowCount() > 1 then
		
				
		li_Find = lds_check.Find("po_no2='GST'", 1, lds_check.RowCount())
	
		if li_Find > 0 then
		
			MessageBox ("Error", "Local and International order can not be mixed.")
			RETURN -1
			
		else	
	
			w_do.idw_main.Post Function SetItem(1,'ord_type', 'I')
	
		end if
		
	else
		
		if Trim(lds_check.GetItemString(1, "po_no2")) = 'GST' then
			w_do.idw_main.Post Function SetItem(1,'ord_type', 'L')
		else
			w_do.idw_main.Post Function SetItem(1,'ord_type', 'I')
		end if
	
	end if
	
else	
	
	MessageBox ("DB Error", "Error getting PO_No2")
	
end if


for li_idx = 1 to dw_select_vendor_dono.RowCount()

	if dw_select_vendor_dono.GetItemNumber( li_idx, "selected") = 1 then
		
		ls_po_no = dw_select_vendor_dono.GetItemString( li_idx, "po_no")
		
		lds_vendor_content.Retrieve(ls_po_no)
		
		if lds_vendor_content.RowCount() > 0 then
		
			for ll_content_idx = 1 to lds_vendor_content.RowCount()

				w_do.tab_main.tabpage_detail.cb_do_det_insert.Trigger Event clicked()

				ll_row = w_do.idw_detail.RowCount()
				

				w_do.idw_detail.SetItem(ll_row, "pick_po_no", ls_po_no)
	
				
				ls_sku =  lds_vendor_content.GetItemString(ll_content_idx, "sku")
				
				w_do.idw_detail.SetItem(ll_row,'sku', ls_sku)
				
				w_do.idw_detail.SetItem(ll_row,'supp_code', lds_vendor_content.GetItemString(ll_content_idx, "supp_code"))
				
				w_do.idw_detail.SetItem(ll_row,'req_qty', lds_vendor_content.GetItemDecimal(ll_content_idx, "avail_qty"))
			
				dwobject ldw_object
			
				ldw_object = w_do.idw_detail.Object.sku
			
				w_do.idw_detail.Trigger Event ItemChanged(ll_row, ldw_object, ls_sku )


			next

		end if
//idw_detail



	end if

next



Close(Parent)
end event

type cb_1 from commandbutton within w_flex_select_vendor_do
integer x = 873
integer y = 1236
integer width = 402
integer height = 112
integer taborder = 20
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
Close(parent)
end event

type dw_select_vendor_dono from datawindow within w_flex_select_vendor_do
integer x = 192
integer y = 232
integer width = 1221
integer height = 972
integer taborder = 10
string title = "none"
string dataobject = "d_flex_vendor_do_select_list"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

