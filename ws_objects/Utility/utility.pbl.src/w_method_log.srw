$PBExportHeader$w_method_log.srw
forward
global type w_method_log from window
end type
type st_4 from statictext within w_method_log
end type
type st_3 from statictext within w_method_log
end type
type st_2 from statictext within w_method_log
end type
type clear from commandbutton within w_method_log
end type
type st_1 from statictext within w_method_log
end type
type dw_2 from datawindow within w_method_log
end type
type rb_3 from radiobutton within w_method_log
end type
type rb_2 from radiobutton within w_method_log
end type
type rb_1 from radiobutton within w_method_log
end type
type retreive from commandbutton within w_method_log
end type
type dw_1 from datawindow within w_method_log
end type
type sle_2 from singlelineedit within w_method_log
end type
type gb_1 from groupbox within w_method_log
end type
type gb_2 from groupbox within w_method_log
end type
end forward

global type w_method_log from window
integer width = 4229
integer height = 2584
boolean titlebar = true
string title = "Method Trace LOG"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
st_4 st_4
st_3 st_3
st_2 st_2
clear clear
st_1 st_1
dw_2 dw_2
rb_3 rb_3
rb_2 rb_2
rb_1 rb_1
retreive retreive
dw_1 dw_1
sle_2 sle_2
gb_1 gb_1
gb_2 gb_2
end type
global w_method_log w_method_log

on w_method_log.create
this.st_4=create st_4
this.st_3=create st_3
this.st_2=create st_2
this.clear=create clear
this.st_1=create st_1
this.dw_2=create dw_2
this.rb_3=create rb_3
this.rb_2=create rb_2
this.rb_1=create rb_1
this.retreive=create retreive
this.dw_1=create dw_1
this.sle_2=create sle_2
this.gb_1=create gb_1
this.gb_2=create gb_2
this.Control[]={this.st_4,&
this.st_3,&
this.st_2,&
this.clear,&
this.st_1,&
this.dw_2,&
this.rb_3,&
this.rb_2,&
this.rb_1,&
this.retreive,&
this.dw_1,&
this.sle_2,&
this.gb_1,&
this.gb_2}
end on

on w_method_log.destroy
destroy(this.st_4)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.clear)
destroy(this.st_1)
destroy(this.dw_2)
destroy(this.rb_3)
destroy(this.rb_2)
destroy(this.rb_1)
destroy(this.retreive)
destroy(this.dw_1)
destroy(this.sle_2)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event open;dw_1.settransobject(SQLCA)
dw_2.settransobject(SQLCA)

dw_2.insertrow(0)
rb_1.checked = TRUE
end event

type st_4 from statictext within w_method_log
integer x = 3351
integer y = 2248
integer width = 722
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean border = true
boolean focusrectangle = false
end type

type st_3 from statictext within w_method_log
integer x = 2889
integer y = 2248
integer width = 471
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Ordered Date :"
boolean focusrectangle = false
end type

type st_2 from statictext within w_method_log
integer x = 3351
integer y = 2308
integer width = 722
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean border = true
boolean focusrectangle = false
end type

type clear from commandbutton within w_method_log
integer x = 3287
integer y = 120
integer width = 663
integer height = 100
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Clear"
end type

event clicked;dw_1.reset()
dw_2.reset()
sle_2.text = ' '
dw_2.insertrow(0)
st_2.text = ''
st_4.text = ''
end event

type st_1 from statictext within w_method_log
integer x = 2889
integer y = 2308
integer width = 471
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Completed Date :"
boolean focusrectangle = false
end type

type dw_2 from datawindow within w_method_log
integer x = 119
integer y = 444
integer width = 3278
integer height = 232
integer taborder = 40
string title = "none"
string dataobject = "d_method_details"
boolean livescroll = true
borderstyle borderstyle = StyleRaised!
end type

type rb_3 from radiobutton within w_method_log
integer x = 1083
integer y = 140
integer width = 402
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Work order"
end type

type rb_2 from radiobutton within w_method_log
integer x = 640
integer y = 140
integer width = 402
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Outbound"
end type

type rb_1 from radiobutton within w_method_log
integer x = 247
integer y = 140
integer width = 402
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Inbound"
end type

type retreive from commandbutton within w_method_log
integer x = 2551
integer y = 120
integer width = 663
integer height = 100
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Retreive"
end type

event clicked;string  ls_orderno, ls_inborder, ls_outborder, ls_ftpname, ls_ftpoutname,ls_recorder, ls_delorder,ls_ordertype,ls_cruser
int i=1
long ll_count, ll_countedi  ,ll_edi_no 
datetime ld_compdate,ld_ordedate


ls_orderno= trim(sle_2.text)

if rb_1.checked =TRUE  then
			ls_ordertype = "INBOUND"
			
			select  order_no ,ftp_file_name into  :ls_inborder , :ls_ftpname
			from edi_inbound_header 
			where project_id =:gs_project and order_no = :ls_orderno using sQLCA;	
			
					
			select complete_date, ord_date,edi_batch_seq_no , create_user  into :ld_compdate , :ld_ordedate, :ll_edi_no, :ls_cruser
			from receive_master 
			where project_id = :gs_project and supp_invoice_no = :ls_orderno; 
			
			
			If(ll_edi_no <> 0 and  ls_cruser = 'SIMSFP' ) then 
				dw_2.setitem(i,'order_entered_As',"Electronically")
				dw_2.setitem(i,'ftp_file_name',ls_ftpname)
			else
				dw_2.setitem(i,'order_entered_As',"Manualy")
				dw_2.setitem(i,'ftp_file_name',"-")
       		end if 
				
						
			//if( ord_type = 'B','This is a Back Order.','This order was entered through MSE'))
			
						
			select count (*) into :ll_count
			from receive_master 
			where project_id = :gs_project and supp_invoice_no = :ls_orderno; 
			
			
			
			if (ll_count = 0) then 
					messagebox ("error", "check the order number")	
			else 
					dw_1.retrieve(gs_project,ls_orderno)
					dw_1.setitem(i,'Object_name',ls_ordertype)
					dw_1.setitem(i,"ftp_file_name",ls_ftpname)
					if (dw_1.rowcount() = 0) then 
						messagebox (" !","No Rows Found ")
					end if 
			end if 
			
			st_2.text = string(ld_compdate)
			st_4.text = string (ld_ordedate)
			
	elseif 	rb_2.checked =true then
			ls_ordertype = "OUTBOUND"
			
			
			select order_no ,ftp_file_name into :ls_outborder , :ls_ftpname
			from edi_outbound_header 
			where project_id =:gs_project and order_no = :ls_orderno using SQLCA;
			
			
			select complete_date, ord_date , edi_batch_seq_no , create_user   into :ld_compdate , :ld_ordedate, :ll_edi_no, :ls_cruser
			from delivery_master 
			where project_id = :gs_project and invoice_no = :ls_orderno; 
			
			If(ll_edi_no <> 0 and  ls_cruser = 'SIMSFP' ) then 
				dw_2.setitem(i,'order_entered_As',"Electronically")
				dw_2.setitem(i,'ftp_file_name',ls_ftpname)
			else
				dw_2.setitem(i,'order_entered_As',"Manualy")
				dw_2.setitem(i,'ftp_file_name',"-")
       		end if 
			
			select count(*)  into :ll_count
			from delivery_master 
			where project_id = :gs_project and invoice_no = :ls_orderno; 
			
						
				if (ll_count =0 ) then 
					messagebox ("error", "check the order number")	
				else 
					
					dw_1.retrieve(gs_project,ls_orderno)
					dw_1.setitem(i,'Object_name',ls_ordertype)
					dw_1.setitem(i,'ftp_file_name',ls_ftpname)
					if (dw_1.rowcount() = 0) then 
						messagebox (" !","No Rows Found ")
					end if 
				end if 
			st_2.text = string(ld_compdate)
			st_4.text = string (ld_ordedate)
			
 end if 
 
 
 
 
 
 
 
 
 
 
 
 






end event

type dw_1 from datawindow within w_method_log
integer x = 123
integer y = 780
integer width = 3931
integer height = 1304
integer taborder = 20
string title = "none"
string dataobject = "d_method_LOG"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type sle_2 from singlelineedit within w_method_log
integer x = 1545
integer y = 120
integer width = 878
integer height = 100
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type gb_1 from groupbox within w_method_log
integer x = 224
integer y = 68
integer width = 1298
integer height = 172
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Order Type"
end type

type gb_2 from groupbox within w_method_log
integer x = 105
integer y = 380
integer width = 3305
integer height = 320
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Order Details"
end type

