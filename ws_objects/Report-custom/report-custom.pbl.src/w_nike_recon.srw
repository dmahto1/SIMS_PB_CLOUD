$PBExportHeader$w_nike_recon.srw
forward
global type w_nike_recon from window
end type
type dw_diff from datawindow within w_nike_recon
end type
type dw_sku_sum_con from datawindow within w_nike_recon
end type
type em_edate from editmask within w_nike_recon
end type
type rb_det from radiobutton within w_nike_recon
end type
type rb_sum from radiobutton within w_nike_recon
end type
type st_2 from statictext within w_nike_recon
end type
type st_1 from statictext within w_nike_recon
end type
type dw_doc from datawindow within w_nike_recon
end type
type em_sdate from editmask within w_nike_recon
end type
type rb_loc from radiobutton within w_nike_recon
end type
type rb_sku from radiobutton within w_nike_recon
end type
type cb_print from commandbutton within w_nike_recon
end type
type dw_sku_sum from datawindow within w_nike_recon
end type
type gb_retype from groupbox within w_nike_recon
end type
type gb_2 from groupbox within w_nike_recon
end type
type gb_1 from groupbox within w_nike_recon
end type
type ln_1 from line within w_nike_recon
end type
end forward

global type w_nike_recon from window
integer x = 823
integer y = 364
integer width = 3090
integer height = 1864
boolean titlebar = true
string title = "Reconciliation Report"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 79741120
dw_diff dw_diff
dw_sku_sum_con dw_sku_sum_con
em_edate em_edate
rb_det rb_det
rb_sum rb_sum
st_2 st_2
st_1 st_1
dw_doc dw_doc
em_sdate em_sdate
rb_loc rb_loc
rb_sku rb_sku
cb_print cb_print
dw_sku_sum dw_sku_sum
gb_retype gb_retype
gb_2 gb_2
gb_1 gb_1
ln_1 ln_1
end type
global w_nike_recon w_nike_recon

on w_nike_recon.create
this.dw_diff=create dw_diff
this.dw_sku_sum_con=create dw_sku_sum_con
this.em_edate=create em_edate
this.rb_det=create rb_det
this.rb_sum=create rb_sum
this.st_2=create st_2
this.st_1=create st_1
this.dw_doc=create dw_doc
this.em_sdate=create em_sdate
this.rb_loc=create rb_loc
this.rb_sku=create rb_sku
this.cb_print=create cb_print
this.dw_sku_sum=create dw_sku_sum
this.gb_retype=create gb_retype
this.gb_2=create gb_2
this.gb_1=create gb_1
this.ln_1=create ln_1
this.Control[]={this.dw_diff,&
this.dw_sku_sum_con,&
this.em_edate,&
this.rb_det,&
this.rb_sum,&
this.st_2,&
this.st_1,&
this.dw_doc,&
this.em_sdate,&
this.rb_loc,&
this.rb_sku,&
this.cb_print,&
this.dw_sku_sum,&
this.gb_retype,&
this.gb_2,&
this.gb_1,&
this.ln_1}
end on

on w_nike_recon.destroy
destroy(this.dw_diff)
destroy(this.dw_sku_sum_con)
destroy(this.em_edate)
destroy(this.rb_det)
destroy(this.rb_sum)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.dw_doc)
destroy(this.em_sdate)
destroy(this.rb_loc)
destroy(this.rb_sku)
destroy(this.cb_print)
destroy(this.dw_sku_sum)
destroy(this.gb_retype)
destroy(this.gb_2)
destroy(this.gb_1)
destroy(this.ln_1)
end on

event open;This.Move(0,0)

end event

type dw_diff from datawindow within w_nike_recon
integer x = 1435
integer y = 1308
integer width = 494
integer height = 364
integer taborder = 80
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_sku_sum_con from datawindow within w_nike_recon
integer x = 133
integer y = 1580
integer width = 2098
integer height = 1004
integer taborder = 80
string dataobject = "d_nike_recon_summary_all"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type em_edate from editmask within w_nike_recon
integer x = 1019
integer y = 192
integer width = 402
integer height = 100
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
alignment alignment = right!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = datemask!
string mask = "mm/dd/yyyy"
end type

event losefocus;If rb_sku.checked = true then
	
	dw_doc.dataobject ='d_bysk'
else
	dw_doc.dataobject ='d_byloc'
end if

dw_doc.settransobject(sqlca)
dw_doc.retrieve(date(em_sdate.text),relativedate(date(em_edate.text),1))
end event

type rb_det from radiobutton within w_nike_recon
integer x = 832
integer y = 948
integer width = 517
integer height = 76
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Detailed Report"
end type

type rb_sum from radiobutton within w_nike_recon
integer x = 229
integer y = 956
integer width = 530
integer height = 76
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Summary Report"
boolean checked = true
end type

type st_2 from statictext within w_nike_recon
integer x = 864
integer y = 204
integer width = 142
integer height = 76
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "to"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_1 from statictext within w_nike_recon
integer x = 187
integer y = 196
integer width = 206
integer height = 76
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "From"
alignment alignment = right!
boolean focusrectangle = false
end type

type dw_doc from datawindow within w_nike_recon
integer x = 1536
integer y = 108
integer width = 695
integer height = 588
integer taborder = 30
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;If row > 0 Then
	If this.getselectedrow(row -1) = row THen
		This.SelectRow(row,False)
	Else
		This.SelectRow(row,True)
	End If
End If
end event

event rbuttondown;If row > 0 Then
	This.SelectRow(row,False)
End If

end event

type em_sdate from editmask within w_nike_recon
integer x = 457
integer y = 188
integer width = 384
integer height = 100
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
alignment alignment = right!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = datemask!
string mask = "mm/dd/yyyy"
end type

type rb_loc from radiobutton within w_nike_recon
integer x = 800
integer y = 556
integer width = 398
integer height = 76
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "By Location"
end type

event clicked;If rb_sku.checked = true then
	
	dw_doc.dataobject ='d_bysk'
else
	dw_doc.dataobject ='d_byloc'
end if

if isdate(em_sdate.text) and isdate(em_edate.text) then
dw_doc.settransobject(sqlca)
dw_doc.retrieve(date(em_sdate.text),relativedate(date(em_edate.text),1))
end if
end event

type rb_sku from radiobutton within w_nike_recon
integer x = 320
integer y = 556
integer width = 297
integer height = 76
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "By SKU"
boolean checked = true
end type

event clicked;If rb_sku.checked = true then
	
	dw_doc.dataobject ='d_bysk'
else
	dw_doc.dataobject ='d_byloc'
end if
if isdate(em_sdate.text) and isdate(em_edate.text) then
dw_doc.settransobject(sqlca)
dw_doc.retrieve(date(em_sdate.text),relativedate(date(em_edate.text),1))
end if
end event

type cb_print from commandbutton within w_nike_recon
integer x = 1669
integer y = 924
integer width = 265
integer height = 108
integer taborder = 70
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Retrieve"
end type

event clicked;integer i, pos, posd, j , k
long ll_row,ll_rcnt, ll_cnt, ll_sqty,ll_aqty,ll_cqty, ll_drcnt, ll_diff
string ls_list, ls_sku,ls_invtype,ls_lcode , ls_dsku,ls_div
OLEObject xl, xs , xs3
String filename, inv_des, inv_type

j=0

dw_sku_sum.reset()
dw_sku_sum_con.reset()

If rb_sum.checked = true then

	If rb_sku.checked = true then
		
		dw_sku_sum.dataobject='d_nike_recon_summary'
		dw_sku_sum_con.dataobject='d_nike_recon_summary_all'
		dw_sku_sum.SetTransObject(Sqlca)
		dw_sku_sum_con.SetTransObject(Sqlca)
		i = 0
		ls_list = ""
		i = dw_doc.GetSelectedRow(i)
		
		DO While i > 0 
			
		ls_list = dw_doc.GetItemString(i, "cc_no") 
		ll_rcnt = dw_sku_sum.retrieve(ls_list)
		ll_cnt=1
		
			 DO while ll_cnt <= ll_rcnt
				ls_sku = dw_sku_sum.GetItemString(ll_cnt,"SKU")
				ls_invtype = dw_sku_sum.GetItemString(ll_cnt,"Inventory_Type")
				ll_sqty = dw_sku_sum.GetItemNumber(ll_cnt,"systemqty")
				ll_aqty = dw_sku_sum.GetItemNumber(ll_cnt,"callocqty")
				ll_cqty = dw_sku_sum.GetItemNumber(ll_cnt,"ccountqty")
				ll_row=dw_sku_sum_con.insertrow(0)
				dw_sku_sum_con.SetItem(ll_row,"SKU", ls_sku)
				dw_sku_sum_con.SetItem(ll_row,"Inventory_Type", ls_invtype)
				dw_sku_sum_con.SetItem(ll_row,"systemqty", ll_sqty)
				dw_sku_sum_con.SetItem(ll_row,"callocqty", ll_aqty)
				dw_sku_sum_con.SetItem(ll_row,"ccountqty", ll_cqty)
				ll_cnt+=1 
			loop
	
			i = dw_doc.GetSelectedRow(i) 
		Loop
	
		// update in to excel
		SetPointer(HourGlass!)
		SetMicroHelp("Opening Excel ...")
		filename = ProfileString(gs_inifile,"ewms","syspath","") + "reconreport.xls"
		xl = CREATE OLEObject
		xs = CREATE OLEObject
		xl.ConnectToNewObject("Excel.Application")
		xl.Workbooks.Open(filename,0,True)
		xs = xl.application.workbooks(1).worksheets(1)
		xs3 = xl.application.workbooks(1).worksheets(3)
		SetMicroHelp("Printing report heading...")
		ls_list = ""
		i = dw_doc.GetSelectedRow(i)
		
		DO While i > 0 
			ls_list += trim(dw_doc.GetItemString(i, "cc_no")) + ", " 
			i = dw_doc.GetSelectedRow(i) 
		Loop
	
		xs.cells(4,4).value= left (ls_list, len(ls_list)-2)
		ll_cnt = dw_sku_sum_con.rowcount()
		pos =8
		posd = 7
		
		For i = 1 to ll_cnt
			
			SetMicroHelp("Exporting to Excel line " + String(i) + " of " + String(ll_cnt))
			pos += 1 
			If i + 2 <= ll_cnt Then xs.rows(pos + 1).Insert
			
			inv_type= dw_sku_sum_con.GetItemString(i,"Inventory_Type")
			
			If inv_type = 'U' then
				inv_des = "Unrestricted"
			elseif inv_type = 'R' then
				inv_des = "Restricted"
			elseif inv_type ='S' then
				inv_des = "Stock Return"
			end if
		
			ls_dsku = dw_sku_sum_con.GetItemString(i,"SKU")
			ll_diff = dw_sku_sum_con.GetItemNumber(i,"stock_diff")
		
			xs.cells(pos,3).value= String(ls_dsku, "@@@@@@-@@@-@@@@@")
			xs.cells(pos,4).value=inv_des
			xs.cells(pos,5).value=dw_sku_sum_con.GetItemNumber(i,"systemqty")
			xs.cells(pos,6).value=dw_sku_sum_con.GetItemNumber(i,"callocqty")
			xs.cells(pos,7).value= dw_sku_sum_con.GetItemNumber(i,"systemqty") + dw_sku_sum_con.GetItemNumber(i,"callocqty") //999
			xs.cells(pos,8).value=dw_sku_sum_con.GetItemNumber(i,"ccountqty")
			xs.cells(pos,9).value= ll_diff
			
			// difference report coding
			
			If ll_diff <> 0 then
				
					dw_diff.dataobject='d_drecon_detail'
					dw_diff.SetTransObject(Sqlca)
			
					j = dw_doc.GetSelectedRow(j)
			
					DO While j > 0 
						ls_list = trim(dw_doc.GetItemString(j, "cc_no"))  
						ll_drcnt = dw_diff.retrieve(ls_list,ls_dsku)
						
						 For k = 1 to ll_drcnt
						  posd += 1	 
						  If k+2 <= ll_drcnt then xs3.rows(posd+1).insert
						  
							xs3.cells(posd,3).value = dw_diff.getitemstring(k,"l_code")
							xs3.cells(posd,4).value = String(dw_diff.getitemstring(k,"sku"),"@@@@@@-@@@-@@@@")
							xs3.cells(posd,5).value = dw_diff.getitemstring(k,"inventory_type")
							xs3.cells(posd,6).value = dw_diff.getitemnumber(k,"systemqty")
							xs3.cells(posd,7).value = dw_diff.getitemnumber(k,"alloc_qty")
							xs3.cells(posd,8).value = dw_diff.getitemnumber(k,"systemqty") + dw_diff.getitemnumber(k,"alloc_qty") //999
							xs3.cells(posd,9).value = dw_diff.getitemnumber(k,"ccountqty")
							xs3.cells(posd,10).value = dw_diff.getitemnumber(k,"stock_diff")
						  
						 next
						 
						j = dw_doc.GetSelectedRow(j) 
					Loop
			end if
		Next
		
		SetMicroHelp("Complete!")
		xl.Visible = True
		xl.DisconnectObject()
		//coding end
	
	elseif rb_loc.checked = true then
	
		dw_sku_sum.dataobject='d_nike_loc_recon_summary'
		dw_sku_sum_con.dataobject='d_nike_loc_recon_summary_all'
		dw_sku_sum.SetTransObject(Sqlca)
		dw_sku_sum_con.SetTransObject(Sqlca)
		i = 0
		ls_list = ""
		i = dw_doc.GetSelectedRow(i)
		
		DO While i > 0 
			ls_list = dw_doc.GetItemString(i, "pc_no") 
			ll_rcnt = dw_sku_sum.retrieve(ls_list)
			ll_cnt=1
				 DO while ll_cnt <= ll_rcnt
					ls_sku = dw_sku_sum.GetItemString(ll_cnt,"SKU")
					ls_invtype = dw_sku_sum.GetItemString(ll_cnt,"Inventory_Type")
					ll_sqty = dw_sku_sum.GetItemNumber(ll_cnt,"systemqty")
					ll_aqty = dw_sku_sum.GetItemNumber(ll_cnt,"callocqty")
					ll_cqty = dw_sku_sum.GetItemNumber(ll_cnt,"ccountqty")
					ll_row=dw_sku_sum_con.insertrow(0)
					dw_sku_sum_con.SetItem(ll_row,"SKU", ls_sku)
					dw_sku_sum_con.SetItem(ll_row,"Inventory_Type", ls_invtype)
					dw_sku_sum_con.SetItem(ll_row,"systemqty", ll_sqty)
					dw_sku_sum_con.SetItem(ll_row,"callocqty", ll_aqty)
					dw_sku_sum_con.SetItem(ll_row,"ccountqty", ll_cqty)
					ll_cnt+=1 
				loop
		
			i = dw_doc.GetSelectedRow(i) 
		Loop
	
		// update in to excel

		SetPointer(HourGlass!)
		SetMicroHelp("Opening Excel ...")
		filename = ProfileString(gs_inifile,"ewms","syspath","") + "reconreport.xls"
		xl = CREATE OLEObject
		xs = CREATE OLEObject
		xl.ConnectToNewObject("Excel.Application")
		xl.Workbooks.Open(filename,0,True)
		xs = xl.application.workbooks(1).worksheets(1)
		xs3 = xl.application.workbooks(1).worksheets(3)
		
		SetMicroHelp("Printing report heading...")
		
		
		ls_list = ""
		i = dw_doc.GetSelectedRow(i)

		DO While i > 0 
			ls_list += trim(dw_doc.GetItemString(i, "pc_no")) + ", " 
			i = dw_doc.GetSelectedRow(i) 
		Loop

		xs.cells(4,4).value=left (ls_list, len(ls_list)-2)

		ll_cnt = dw_sku_sum_con.rowcount()
		pos = 8
		posd=7

		For i = 1 to ll_cnt
			
			SetMicroHelp("Exporting to Excel line " + String(i) + " of " + String(ll_cnt))
			pos += 1 
			If i + 2 <= ll_cnt Then xs.rows(pos + 1).Insert
			
			inv_type= dw_sku_sum_con.GetItemString(i,"Inventory_Type")
			
			If inv_type = 'U' then
				inv_des = "Unrestricted"
			elseif inv_type = 'R' then
				inv_des = "Restricted"
			elseif inv_type ='S' then
				inv_des = "Stock Return"
			end if
			
			ls_dsku = dw_sku_sum_con.GetItemString(i,"SKU")
			ll_diff = dw_sku_sum_con.Getitemnumber(i,"stock_diff")
			
			xs.cells(pos,3).value= String(ls_dsku,"@@@@@@-@@@-@@@@@")
			xs.cells(pos,4).value=inv_des
			xs.cells(pos,5).value=dw_sku_sum_con.GetItemNumber(i,"systemqty")
			xs.cells(pos,6).value=dw_sku_sum_con.GetItemNumber(i,"callocqty")
			xs.cells(pos,7).value= dw_sku_sum_con.GetItemNumber(i,"systemqty") + dw_sku_sum_con.GetItemNumber(i,"callocqty") //999
			xs.cells(pos,8).value=dw_sku_sum_con.GetItemNumber(i,"ccountqty")
			xs.cells(pos,9).value=ll_diff
			
			// difference report coding
			
			If ll_diff <> 0 then
				
					dw_diff.dataobject='d_dloc_recon_det'
					dw_diff.SetTransObject(Sqlca)
			
					j = dw_doc.GetSelectedRow(j)
			
					DO While j > 0 
						ls_list = trim(dw_doc.GetItemString(j, "pc_no"))  
						ll_drcnt = dw_diff.retrieve(ls_list,ls_dsku)
						
						 For k = 1 to ll_drcnt
						  posd += 1	 
						  If k+2 <= ll_drcnt then xs3.rows(posd+1).insert
						  
							xs3.cells(posd,3).value = dw_diff.getitemstring(k,"l_code")
							xs3.cells(posd,4).value = String(dw_diff.getitemstring(k,"sku"),"@@@@@@-@@@-@@@@")
							xs3.cells(posd,5).value = dw_diff.getitemstring(k,"inventory_type")
							xs3.cells(posd,6).value = dw_diff.getitemnumber(k,"systemqty")
							xs3.cells(posd,7).value = dw_diff.getitemnumber(k,"alloc_qty")
							xs3.cells(posd,8).value = dw_diff.getitemnumber(k,"systemqty") + dw_diff.getitemnumber(k,"alloc_qty") //999
							xs3.cells(posd,9).value = dw_diff.getitemnumber(k,"ccountqty")
							xs3.cells(posd,10).value = dw_diff.getitemnumber(k,"stock_diff")
						  
						 next
						 
						j = dw_doc.GetSelectedRow(j) 
					Loop
			
			end if
			
			
		Next

		SetMicroHelp("Complete!")
		xl.Visible = True
		xl.DisconnectObject()
	
		// coding end
		
	end if
	
elseif rb_det.checked = true then

	If rb_sku.checked = true then
	
		dw_sku_sum.dataobject='d_nike_recon_detail'
		dw_sku_sum_con.dataobject='d_nike_recon_detail_all'
		dw_sku_sum.SetTransObject(Sqlca)
		dw_sku_sum_con.SetTransObject(Sqlca)
		i = 0
		ls_list = ""
		i = dw_doc.GetSelectedRow(i)
		
		DO While i > 0 
			ls_list = dw_doc.GetItemString(i, "cc_no") 
			ll_rcnt = dw_sku_sum.retrieve(ls_list)
			ll_cnt=1
			
			DO while ll_cnt <= ll_rcnt
				ls_sku = dw_sku_sum.GetItemString(ll_cnt,"SKU")
				ls_div = dw_sku_sum.GetItemString(ll_cnt,"cdiv_code")
				ls_invtype = dw_sku_sum.GetItemString(ll_cnt,"Inventory_Type")
				ls_lcode = dw_sku_sum.GetItemString(ll_cnt,"L_code") 
				ll_sqty = dw_sku_sum.GetItemNumber(ll_cnt,"systemqty")
				ll_aqty = dw_sku_sum.GetItemNumber(ll_cnt,"alloc_qty")
				ll_cqty = dw_sku_sum.GetItemNumber(ll_cnt,"ccountqty")
				
				ll_row=dw_sku_sum_con.insertrow(0)
				dw_sku_sum_con.SetItem(ll_row,"cc_no", ls_list)
				dw_sku_sum_con.SetItem(ll_row,"cdiv_code", ls_div)
				dw_sku_sum_con.SetItem(ll_row,"SKU", ls_sku)
				dw_sku_sum_con.SetItem(ll_row,"Inventory_Type", ls_invtype)
				dw_sku_sum_con.SetItem(ll_row,"L_Code", ls_lcode)
				dw_sku_sum_con.SetItem(ll_row,"systemqty", ll_sqty)
				dw_sku_sum_con.SetItem(ll_row,"alloc_qty", ll_aqty)
				dw_sku_sum_con.SetItem(ll_row,"ccountqty", ll_cqty)
				ll_cnt+=1 
			loop
	
			i = dw_doc.GetSelectedRow(i) 
		Loop
		
		// update in to excel
	
		SetPointer(HourGlass!)
	
		SetMicroHelp("Opening Excel ...")
		filename = ProfileString(gs_inifile,"ewms","syspath","") + "reconreport.xls"
		xl = CREATE OLEObject
		xs = CREATE OLEObject
		xl.ConnectToNewObject("Excel.Application")
		xl.Workbooks.Open(filename,0,True)
		xs = xl.application.workbooks(1).worksheets(2)
	
		SetMicroHelp("Printing report heading...")
	
	
		ls_list = ""
		i = dw_doc.GetSelectedRow(i)
		
		DO While i > 0 
			ls_list += trim(dw_doc.GetItemString(i, "cc_no")) + ", " 
			i = dw_doc.GetSelectedRow(i) 
		Loop
	
		xs.cells(4,4).value=left (ls_list, len(ls_list)-2)
		
		ll_cnt = dw_sku_sum_con.rowcount()
		pos =7
		
		For i = 1 to ll_cnt
			
			SetMicroHelp("Exporting to Excel line " + String(i) + " of " + String(ll_cnt))
			pos += 1 
			If i + 2 <= ll_cnt Then xs.rows(pos + 1).Insert
			
			inv_type= dw_sku_sum_con.GetItemString(i,"Inventory_Type")
			
			If inv_type = 'U' then
				inv_des = "Unrestricted"
			elseif inv_type = 'R' then
				inv_des = "Restricted"
			elseif inv_type ='S' then
				inv_des = "Stock Return"
			end if
			
			xs.cells(pos,1).value=dw_sku_sum_con.GetItemString(i,"cdiv_code")			
			xs.cells(pos,2).value=dw_sku_sum_con.GetItemString(i,"cc_no")			
			xs.cells(pos,3).value=dw_sku_sum_con.GetItemString(i,"L_Code")			
			xs.cells(pos,4).value= String(dw_sku_sum_con.GetItemString(i,"SKU"),"@@@@@@-@@@-@@@@@")
			xs.cells(pos,5).value=inv_des
			xs.cells(pos,6).value=dw_sku_sum_con.GetItemNumber(i,"systemqty")
			xs.cells(pos,7).value=dw_sku_sum_con.GetItemNumber(i,"alloc_qty")
			xs.cells(pos,8).value=dw_sku_sum_con.GetItemNumber(i,"systemqty") + dw_sku_sum_con.GetItemNumber(i,"alloc_qty") //999
			xs.cells(pos,9).value=dw_sku_sum_con.GetItemNumber(i,"ccountqty")
			xs.cells(pos,10).value=dw_sku_sum_con.GetItemNumber(i,"stock_diff")
			
		Next
	
		SetMicroHelp("Complete!")
		xl.Visible = True
		xl.DisconnectObject()
	
		// coding end


	elseif rb_loc.checked = true then
	
		dw_sku_sum.dataobject='d_nike_loc_recon_det'
		dw_sku_sum_con.dataobject='d_nike_loc_recon_det_all'
		dw_sku_sum.SetTransObject(Sqlca)
		dw_sku_sum_con.SetTransObject(Sqlca)
		i = 0
		ls_list = ""
		i = dw_doc.GetSelectedRow(i)
		DO While i > 0 
			ls_list = dw_doc.GetItemString(i, "pc_no") 
			ll_rcnt = dw_sku_sum.retrieve(ls_list)
			ll_cnt=1
			
			DO while ll_cnt <= ll_rcnt
				ls_sku = dw_sku_sum.GetItemString(ll_cnt,"SKU")
				ls_div = dw_sku_sum.GetItemString(ll_cnt,"cdiv_code")
				ls_invtype = dw_sku_sum.GetItemString(ll_cnt,"Inventory_Type")
				ls_lcode = dw_sku_sum.GetItemString(ll_cnt,"L_Code") 
				ll_sqty = dw_sku_sum.GetItemNumber(ll_cnt,"systemqty")
				ll_aqty = dw_sku_sum.GetItemNumber(ll_cnt,"alloc_qty")
				ll_cqty = dw_sku_sum.GetItemNumber(ll_cnt,"ccountqty")
				ll_row=dw_sku_sum_con.insertrow(0)
				
				dw_sku_sum_con.SetItem(ll_row,"pc_no", ls_list)
				dw_sku_sum_con.SetItem(ll_row,"SKU", ls_sku)
				dw_sku_sum_con.SetItem(ll_row,"cdiv_code", ls_div)
				dw_sku_sum_con.SetItem(ll_row,"Inventory_Type", ls_invtype)
				dw_sku_sum_con.SetItem(ll_row,"L_Code", ls_lcode)
				dw_sku_sum_con.SetItem(ll_row,"systemqty", ll_sqty)
				dw_sku_sum_con.SetItem(ll_row,"alloc_qty", ll_aqty)
				dw_sku_sum_con.SetItem(ll_row,"ccountqty", ll_cqty)
				ll_cnt+=1 
			loop
	
			i = dw_doc.GetSelectedRow(i) 
		Loop
		
		// update in to excel
	
		SetPointer(HourGlass!)
	
		SetMicroHelp("Opening Excel ...")
		filename = ProfileString(gs_inifile,"ewms","syspath","") + "reconreport.xls"
		xl = CREATE OLEObject
		xs = CREATE OLEObject
		xl.ConnectToNewObject("Excel.Application")
		xl.Workbooks.Open(filename,0,True)
		xs = xl.application.workbooks(1).worksheets(2)
		
		SetMicroHelp("Printing report heading...")
		ls_list = ""
		i = dw_doc.GetSelectedRow(i)
	
		DO While i > 0 
			ls_list += trim(dw_doc.GetItemString(i, "pc_no")) + ", " 
			i = dw_doc.GetSelectedRow(i) 
		Loop
	
		xs.cells(4,4).value=left (ls_list, len(ls_list)-2)
		
		ll_cnt = dw_sku_sum_con.rowcount()
		pos =7
	
		For i = 1 to ll_cnt
		
			SetMicroHelp("Exporting to Excel line " + String(i) + " of " + String(ll_cnt))
			pos += 1 
			If i + 2 <= ll_cnt Then xs.rows(pos + 1).Insert
		
			inv_type= dw_sku_sum_con.GetItemString(i,"Inventory_Type")
		
			If inv_type = 'U' then
				inv_des = "Unrestricted"
			elseif inv_type = 'R' then
				inv_des = "Restricted"
			elseif inv_type ='S' then
				inv_des = "Stock Return"
			end if

			xs.cells(pos,1).value=dw_sku_sum_con.GetItemString(i,"cdiv_code")			
			xs.cells(pos,2).value=dw_sku_sum_con.GetItemString(i,"pc_no")			
			xs.cells(pos,3).value=dw_sku_sum_con.GetItemString(i,"L_Code")			
			xs.cells(pos,4).value= String(dw_sku_sum_con.GetItemString(i,"SKU"),"@@@@@@-@@@-@@@@@")
			xs.cells(pos,5).value=inv_des
			xs.cells(pos,6).value=dw_sku_sum_con.GetItemNumber(i,"systemqty")
			xs.cells(pos,7).value=dw_sku_sum_con.GetItemNumber(i,"alloc_qty")
			xs.cells(pos,8).value=dw_sku_sum_con.GetItemNumber(i,"systemqty") + dw_sku_sum_con.GetItemNumber(i,"alloc_qty") //999
			xs.cells(pos,9).value=dw_sku_sum_con.GetItemNumber(i,"ccountqty")
			xs.cells(pos,10).value=dw_sku_sum_con.GetItemNumber(i,"stock_diff")
		
		Next
	
		SetMicroHelp("Complete!")
		xl.Visible = True
		xl.DisconnectObject()
	
		// coding end
	
	end if

	
end if
	
	




end event

type dw_sku_sum from datawindow within w_nike_recon
integer x = 325
integer y = 1548
integer width = 878
integer height = 80
integer taborder = 60
string dataobject = "d_nike_recon_summary"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type gb_retype from groupbox within w_nike_recon
integer x = 178
integer y = 828
integer width = 1257
integer height = 316
integer taborder = 90
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Choose Type"
end type

type gb_2 from groupbox within w_nike_recon
integer x = 155
integer y = 92
integer width = 1289
integer height = 292
integer taborder = 40
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Order Date"
end type

type gb_1 from groupbox within w_nike_recon
integer x = 165
integer y = 420
integer width = 1271
integer height = 300
integer taborder = 50
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Choose Document"
end type

type ln_1 from line within w_nike_recon
long linecolor = 33554432
integer linethickness = 12
integer beginx = 23
integer beginy = 756
integer endx = 2322
integer endy = 756
end type

