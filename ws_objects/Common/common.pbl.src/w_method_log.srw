$PBExportHeader$w_method_log.srw
forward
global type w_method_log from window
end type
type st_7 from statictext within w_method_log
end type
type sle_3 from singlelineedit within w_method_log
end type
type rb_5 from radiobutton within w_method_log
end type
type rb_4 from radiobutton within w_method_log
end type
type dw_edifilelist from datawindow within w_method_log
end type
type cbx_1 from checkbox within w_method_log
end type
type st_6 from statictext within w_method_log
end type
type st_5 from statictext within w_method_log
end type
type dw_3 from datawindow within w_method_log
end type
type cb_1 from commandbutton within w_method_log
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
type gb_3 from groupbox within w_method_log
end type
end forward

global type w_method_log from window
integer width = 5289
integer height = 2808
boolean titlebar = true
string title = "Method Trace LOG"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
event ue_postopen ( )
st_7 st_7
sle_3 sle_3
rb_5 rb_5
rb_4 rb_4
dw_edifilelist dw_edifilelist
cbx_1 cbx_1
st_6 st_6
st_5 st_5
dw_3 dw_3
cb_1 cb_1
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
gb_3 gb_3
end type
global w_method_log w_method_log

type variables
string system_no , system_to

String isOrderType, isRono, 	isdoNo , isOrderno, ispoNo
end variables

forward prototypes
public function integer wf_cc_log ()
end prototypes

event ue_postopen();//SANTOSH- 25/05/2014 - to get the order no from the opened inbuound or outbound screen and retrive directly in dashboard
string 	lsorderno, ls_sku, ls_supp_code

Choose case gs_ActiveWindow
Case  'IN'
	isOrderType = 'INBOUND'
	If isValid(w_ro) Then
		If w_ro.idw_main.RowCOunt() > 0 Then
			isRoNo = w_Ro.idw_main.getItemString(1,'ro_no')
			lsorderno = w_Ro.idw_main.getItemString(1,'supp_invoice_no')
			rb_1.checked =TRUE
			sle_2.text = lsorderno
			Retreive.TriggerEvent(Clicked!)
		End If
	End If

Case  'OUT'
	isOrderType = 'OUTBOUND'
	
	If isValid(w_do) Then
		If w_do.idw_main.RowCOunt() > 0 Then
			isdoNo = w_do.idw_main.getItemString(1,'do_no')
			lsorderno = w_do.idw_main.getItemString(1,'invoice_no')
			
			rb_2.checked =TRUE
			sle_2.text = lsorderno
			Retreive.TriggerEvent(Clicked!)
		End If
	End If

Case  'SOC'
	isOrderType = 'STOCK OWNER CHANGE'
	
	If isValid(w_owner_change) Then
		If w_owner_change.idw_main.RowCOunt() > 0 Then
			ispoNo = w_owner_change.idw_main.getItemString(1,'to_no')
			lsorderno = w_owner_change.idw_main.getItemString(1,'user_field3')
			
			rb_3.checked =TRUE
			sle_2.text = lsorderno
			Retreive.TriggerEvent(Clicked!)
		End If
	End If
	
Case 'IM' //29-May-2018 :Madhu S19730 -Added Item Master
	isOrderType ='ITEM MASTER'
	If isValid(w_maintenance_itemmaster) Then
		If w_maintenance_itemmaster.idw_main.RowCount() > 0 Then
			ls_sku = w_maintenance_itemmaster.idw_main.getItemString(1, 'sku')
			ls_supp_code = w_maintenance_itemmaster.idw_main.getItemString(1, 'supp_code')
			
			rb_5.checked =TRUE
			sle_2.text = trim(ls_sku)
			sle_3.text =trim(ls_supp_code)
			Retreive.TriggerEvent(Clicked!)
		End If
	End If
	
Case  else
	if isValid(w_cc) then
		isOrderType = 'Cycle Count'
		If w_cc.idw_main.RowCOunt() > 0 Then
			ispoNo = w_cc.idw_main.getItemString(1,'cc_no')
			rb_4.checked =TRUE
			sle_2.text = ispoNo
			Retreive.TriggerEvent(Clicked!)
		End If
	End If
	
	Return
End Choose

end event

public function integer wf_cc_log ();//Sarun2015Aug12: Added Cycle Count Method Trace Log to Dashbaord and Added Sims Version column to report

string  ls_orderno, ls_ordertype, ls_orderstat
String lsOrigSql, lsWhere ,lsNewSql
long ll_count

datetime ld_compdate,ld_ordedate

lsOrigSql = dw_1.GetSqlSelect()
ls_orderno= trim(sle_2.text) 
lsWhere = " Where Project_id = '" + gs_project + "'"

select count (*) into :ll_count
from 	cc_master with(nolock)
where project_id = :gs_project and cc_no = :ls_orderno; 
		
if (ll_count =0 ) then 
	messagebox ("Inbound", "Please provide the valid order number" )
	return -1
end if 
	
lswhere += " and object_name = 'CC' "
lsNewSql = lsOrigSQL + lsWhere

dw_1.SetSqlSelect(lsNewSql)
dw_1.settransobject(SQLCA)
dw_1.retrieve(gs_project,ls_orderno)
dw_1.object.t_12.text = ls_ordertype

select complete_date, ord_date,ord_status into :ld_compdate , :ld_ordedate, :ls_orderstat
from cc_master with(nolock)
where project_id = :gs_project and cc_no = :ls_orderno using sQLCA;	

st_2.text = string(ld_compdate)
st_4.text = string (ld_ordedate)

choose case ls_orderstat
	case "1"
		st_6.text = "1st Count"
	case "2"
		st_6.text = "2nd Count"
	case "3"
		st_6.text = "3rd Count"
	case "D"
		st_6.text = "Descrepancy"
		
	case "N"
		st_6.text = "NEW"
	case "P"
		st_6.text = "PROCESS"
	case "C"
		st_6.text = "COMPLETED"
	case "V"
		st_6.text = "VOID"
end choose

st_2.text = string(ld_compdate)
st_4.text = string (ld_ordedate)			

Return 1
end function

on w_method_log.create
this.st_7=create st_7
this.sle_3=create sle_3
this.rb_5=create rb_5
this.rb_4=create rb_4
this.dw_edifilelist=create dw_edifilelist
this.cbx_1=create cbx_1
this.st_6=create st_6
this.st_5=create st_5
this.dw_3=create dw_3
this.cb_1=create cb_1
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
this.gb_3=create gb_3
this.Control[]={this.st_7,&
this.sle_3,&
this.rb_5,&
this.rb_4,&
this.dw_edifilelist,&
this.cbx_1,&
this.st_6,&
this.st_5,&
this.dw_3,&
this.cb_1,&
this.st_4,&
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
this.gb_2,&
this.gb_3}
end on

on w_method_log.destroy
destroy(this.st_7)
destroy(this.sle_3)
destroy(this.rb_5)
destroy(this.rb_4)
destroy(this.dw_edifilelist)
destroy(this.cbx_1)
destroy(this.st_6)
destroy(this.st_5)
destroy(this.dw_3)
destroy(this.cb_1)
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
destroy(this.gb_3)
end on

event open;dw_1.settransobject(SQLCA)
dw_2.settransobject(SQLCA)
dw_3.settransobject(SQLCA)
dw_edifilelist.settransobject(SQLCA)

dw_2.insertrow(0)
rb_1.checked = TRUE
dw_2.object.t_2.visible = TRUE
dw_2.object.t_3.visible = false
this.triggerevent("ue_postopen") 

end event

event resize;dw_1.width = width - 80
dw_2.width = width - 80
dw_3.width = width - 80


end event

type st_7 from statictext within w_method_log
boolean visible = false
integer x = 4119
integer y = 56
integer width = 389
integer height = 80
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Supp Code:"
boolean focusrectangle = false
end type

type sle_3 from singlelineedit within w_method_log
boolean visible = false
integer x = 4517
integer y = 56
integer width = 581
integer height = 80
integer taborder = 40
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
end type

type rb_5 from radiobutton within w_method_log
integer x = 1518
integer y = 92
integer width = 439
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Item Master"
end type

event clicked;//29-May-2018 :Madhu S19730 - Added Supper Code
sle_3.visible =TRUE
st_7.visible =TRUE
end event

type rb_4 from radiobutton within w_method_log
integer x = 1083
integer y = 92
integer width = 430
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Cycle Count"
end type

event clicked;//29-May-2018 :Madhu S19730 - Added Supper Code
sle_3.visible =FALSE
st_7.visible =FALSE
end event

type dw_edifilelist from datawindow within w_method_log
integer x = 5
integer y = 396
integer width = 5179
integer height = 320
integer taborder = 50
string title = "none"
string dataobject = "d_method_edi_fileslist"
boolean vscrollbar = true
end type

type cbx_1 from checkbox within w_method_log
integer x = 1993
integer y = 64
integer width = 311
integer height = 128
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Archive"
end type

type st_6 from statictext within w_method_log
integer x = 503
integer y = 2572
integer width = 722
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type st_5 from statictext within w_method_log
integer x = 5
integer y = 2572
integer width = 471
integer height = 72
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Order Status"
boolean focusrectangle = false
end type

type dw_3 from datawindow within w_method_log
integer x = 5
integer y = 2056
integer width = 5189
integer height = 464
integer taborder = 30
string title = "none"
string dataobject = "d_batch_trans_detail"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
borderstyle borderstyle = stylelowered!
end type

type cb_1 from commandbutton within w_method_log
boolean visible = false
integer x = 4178
integer y = 2444
integer width = 663
integer height = 100
integer taborder = 20
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Shipment Details"
end type

event clicked;//18th March 014- written the retrive the details of batch transaction - Santosh
Str_parms	lstrParms
long ll_cnt
String ls_sysno


ll_cnt = dw_1.rowcount()
ls_sysno = system_no
lstrparms.String_Arg[1] = ls_sysno
//Openwithparm(w_batch_details, lstrParms)



 
 
 
 
 
 
 
 
 
 
 
 






end event

type st_4 from statictext within w_method_log
integer x = 1929
integer y = 2572
integer width = 722
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type st_3 from statictext within w_method_log
integer x = 1431
integer y = 2572
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
integer x = 3301
integer y = 2572
integer width = 718
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type clear from commandbutton within w_method_log
integer x = 3593
integer y = 56
integer width = 370
integer height = 100
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Clear"
end type

event clicked;dw_1.reset()
dw_2.reset()
dw_3.reset()
sle_2.text = ' '
sle_3.text = ' '
dw_2.insertrow(0)
st_2.text = ''
st_4.text = ''
st_6.text =''
dw_1.object.t_12.texT =''
cbx_1.Checked = FALSE
dw_1.dataobject = "d_method_log"
dw_1.settransobject(SQLCA)
dw_2.object.t_3.visible = TRUE
dw_2.object.t_1.visible = false



end event

type st_1 from statictext within w_method_log
integer x = 2752
integer y = 2572
integer width = 553
integer height = 68
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
integer x = 5
integer y = 244
integer width = 5179
integer height = 148
integer taborder = 40
string title = "none"
string dataobject = "d_method_details"
end type

type rb_3 from radiobutton within w_method_log
integer x = 818
integer y = 92
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
string text = "SOC"
end type

event clicked;//29-May-2018 :Madhu S19730 - Added Supper Code
sle_3.visible =FALSE
st_7.visible =FALSE
end event

type rb_2 from radiobutton within w_method_log
integer x = 398
integer y = 92
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

event clicked;//29-May-2018 :Madhu S19730 - Added Supper Code
sle_3.visible =FALSE
st_7.visible =FALSE
end event

type rb_1 from radiobutton within w_method_log
integer x = 23
integer y = 92
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

event clicked;//29-May-2018 :Madhu S19730 - Added Supper Code
sle_3.visible =FALSE
st_7.visible =FALSE
end event

type retreive from commandbutton within w_method_log
integer x = 3250
integer y = 56
integer width = 343
integer height = 100
integer taborder = 20
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Retrieve"
end type

event clicked;//SANTOSH18th March 014- written the retrive the details of log for inbound and oubound - 

String  ls_orderno, ls_inborder, ls_outborder, ls_ftpname, ls_ftpoutname,ls_recorder
String ls_delorder,ls_ordertype,ls_cruser, ls_orderstat , ls_temporder, ls_arrivaldt
String sql_syntax, ls_ErrorSql, ls_totalftp, lsOrigSql, lsWhere, lsNewSql, ls_dataobject
String ls_sku, ls_supp_code

int i=1
long ll_count, ll_countedi  ,ll_edi_no ,  ll_count1,ll_dw4row
long ll_FTP_Count,ll_row

datetime ld_compdate, ld_ordedate, ld_recorddt, ld_ediloadtime

Str_parms	lstrParms

Datastore idsEDIInbound, idsEDIOutbound

// check whether user want to see the log from archive folder too
If  cbx_1.Checked = TRUE then
	dw_1.Dataobject = 'd_method_log_two'
	dw_1.Settransobject(SQLCA)
End if 

ls_dataobject = dw_3.dataobject
dw_3.dataobject = ''
dw_3.dataobject = ls_dataobject
dw_3.reset()
dw_3.Settransobject(SQLCA)

lsOrigSql = dw_3.GetSqlSelect()
ls_orderno= trim(sle_2.text)
lsWhere = " Where Project_id = '" + gs_project + "'"


IF rb_1.checked =TRUE  THEN
	
	select count (*) into :ll_count
	from receive_master with(nolock)
	where project_id = :gs_project and supp_invoice_no = :ls_orderno; 
	
	if (ll_count =0 ) then 
		select count(*)   into :ll_count1  
		from receive_master with(nolock)
		where project_id = :gs_project and ro_no = :ls_orderno  ; 
		
		if ( ll_count1 =0 ) then 
			messagebox ("Inbound", "Please provide the valid order number" )
			return 	
		else
			select supp_invoice_no    into :ls_temporder
			from receive_master with(nolock)
			where project_id = :gs_project and ro_no = :ls_orderno ; 

			ls_orderno = 	ls_temporder
			sle_2.text  = ls_orderno
		end if 
	end if 
	
	select MAX(ro_no) into :system_no  from receive_master with(nolock) where project_id = :gs_project and supp_invoice_no =  :ls_orderno using SQLCA;

	ls_ordertype = "INBOUND"
	
	lswhere += " and Trans_Order_Id in ( select ro_no from receive_master with(nolock) where project_id = '" +gs_project + "' and supp_invoice_no =  '" + ls_orderno + "' )  &
	and trans_type in ('CI','GR','GS','GT','IM','MM','N ','PD','PK','RS','SI','TH','TPV  ','VD','WA','WO','WX') "
	
	lsNewSql = lsOrigSQL + lsWhere
	
	dw_3.SetSqlSelect(lsNewSql)
	dw_3.settransobject(SQLCA)
	
	dw_1.retrieve(gs_project,ls_orderno)
	dw_1.object.t_12.text = ls_ordertype
	dw_1.setitem(i,"ftp_file_name",ls_ftpname)
	
	if (dw_1.rowcount() = 0) then 
		If cbx_1.Checked = False then
			messagebox( "Alert", "No records are found in current Method Trace Log, please select Archive to look for records")
			dw_3.Retrieve(gs_project, system_no)
			return 
		Else
			messagebox (" Method Log","No entries Found ")
			dw_3.Retrieve(gs_project, system_no)
			return 
		End if 
	end if 
	
	select  order_no ,ftp_file_name , arrival_date, record_create_date into  :ls_inborder , :ls_ftpname , :ls_arrivaldt, :ld_recorddt
	from edi_inbound_header with(nolock)
	where project_id =:gs_project and order_no = :ls_orderno using sQLCA;	
	
	select complete_date, ord_date,edi_batch_seq_no , create_user, ro_no, ord_status, arrival_date, record_create_date  into :ld_compdate , :ld_ordedate, :ll_edi_no, :ls_cruser , :system_no, :ls_orderstat, :ls_arrivaldt, :ld_recorddt
	from receive_master with(nolock)
	where project_id = :gs_project and RO_no = :system_no using sQLCA;	

	dw_edifilelist.dataobject = 'd_method_edi_fileslist_inbound'
	dw_edifilelist.setTransobject( SQLCA)
	dw_edifilelist.retrieve(gs_project,ls_orderno)
	
	If(ll_edi_no <> 0 and  ls_cruser = 'SIMSFP' ) then 
		dw_2.setitem(i,'entered_As',"Electronically")
		dw_2.setitem(i,'arr_date',ls_arrivaldt)
		dw_2.setitem(i,'record_create_dt',ld_recorddt)
	else
		dw_2.setitem(i,'entered_As',"Manualy")
		dw_2.setitem(i,'arr_date',ls_arrivaldt)
		dw_2.setitem(i,'record_create_dt',ld_recorddt)
	end if 
	
	st_2.text = string(ld_compdate)
	st_4.text = string (ld_ordedate)
	
	choose case ls_orderstat
	case "H"
		st_6.text = "HOLD"
	case "N"
		st_6.text = "NEW"
	case "P"
		st_6.text = "PROCESS"
	case "C"
		st_6.text = "COMPLETED"
	case "V"
		st_6.text = "VOID"
	end choose
	
	dw_3.retrieve(gs_project, system_no)
		dw_3.setfocus()
	
elseIF 	rb_2.checked =TRUE THEN
	
	ls_ordertype = "OUTBOUND"
	
	select count(*)  into :ll_count
	from delivery_master with(nolock)
	where project_id = :gs_project and invoice_no = :ls_orderno; 
	
	if (ll_count =0 ) then 
		select count(*)   into :ll_count1  
		from delivery_master with(nolock)
		where project_id = :gs_project and do_no = :ls_orderno  ; 
		
		if ( ll_count1 =0 ) then 
			messagebox ("Outbound", "Please provide the valid order number" )
			return 
		else
			select invoice_no    into :ls_temporder
			from delivery_master with(nolock)
			where project_id = :gs_project and do_no = :ls_orderno ; 
			
			ls_orderno = 	ls_temporder
			sle_2.text  = ls_orderno
		end if 
	end if 
	
	select MAX(do_no)  into :system_no from delivery_master with(nolock) where project_id = :gs_project and invoice_no =  :ls_orderno using SQLCA;			
	
	dw_1.retrieve(gs_project,ls_orderno)
	dw_1.object.t_12.text = ls_ordertype
	dw_1.setitem(i,'ftp_file_name',ls_ftpname)
	
	lswhere += " and Trans_Order_Id in ( select do_no from delivery_master with(nolock) where project_id = '" +gs_project + "' and invoice_no  =  '" + ls_orderno + "' ) &
	and trans_type in ('CI','GI','GS','GT','IM','MM','N ','PD','PK','RS','SI','TH','TPV  ','VD','WA','WO','WX') "
	
	lsNewSql = lsOrigSQL + lsWhere
	
	dw_3.SetSqlSelect(lsNewSql)
	dw_3.settransobject(SQLCA)					
	
	if (dw_1.rowcount() = 0) then 
	
		If cbx_1.Checked = False then
			messagebox( "Alert", "No records are found in current Method Trace Log, please select Archive to look for records")
			dw_3.Retrieve(gs_project, system_no)
			return 
		Else
			messagebox (" Method Log","No entries Found ")
			dw_3.Retrieve(gs_project, system_no)
			return 
		End if 
	end if 
	
	select order_no ,ftp_file_name, record_create_date  into :ls_outborder , :ls_ftpname, :ld_recorddt
	from edi_outbound_header with(nolock)
	where project_id =:gs_project and invoice_no = :ls_orderno using SQLCA;
	
	select complete_date, ord_date , edi_batch_seq_no , create_user, do_no , ord_status  into :ld_compdate , :ld_ordedate, :ll_edi_no, :ls_cruser , :system_no, :ls_orderstat
	from delivery_master with(nolock)
	where project_id = :gs_project and DO_NO = :system_no; 

	dw_edifilelist.dataobject = 'd_method_edi_fileslist_outbound'
	dw_edifilelist.setTransobject( SQLCA)
	dw_edifilelist.retrieve(gs_project,ls_orderno)
	
	dw_2.object.t_3.visible = false 
	dw_2.object.t_1.visible = True 
	
	If(ll_edi_no <> 0 and  ls_cruser = 'SIMSFP' ) then 
		dw_2.setitem(i,'entered_As',"Electronically")
		dw_2.setitem(i,'arr_date',string(ld_ordedate))
		dw_2.setitem(i,'record_create_dt',ld_recorddt)
	else
		dw_2.setitem(i,'entered_As',"Manualy")
		dw_2.setitem(i,'arr_date',string(ld_ordedate))
		dw_2.setitem(i,'record_create_dt',ld_recorddt)
	end if 
	
	st_2.text = string(ld_compdate)
	st_4.text = string (ld_ordedate)
	
	choose case ls_orderstat
	case "H"
		st_6.text = "HOLD"
	case "N"
		st_6.text = "NEW"
	case "P"
		st_6.text = "PROCESS"
	case "I"
		st_6.text = "PICKING"
	case "A"
		st_6.text = "PACKING"
	case "D"
		st_6.text = "DELIVERED"
	case "C"
		st_6.text = "COMPLETED"
	case "R"
		st_6.text = "READY"
	case "V"
		st_6.text = "VOID"
	end choose
	
	dw_3.Retrieve(gs_project, system_no)
	dw_3.setfocus()

//SANTOSH20140721 - added for SOC change - pandora.- START

elseIF rb_3.checked = TRUE  THEN
	ls_ordertype = "STOCK OWNER CHANGE"
	
	select count (*) into :ll_count
	from transfer_master with(nolock)
	where project_id = :gs_project and user_field3 = :ls_orderno; 
	
	select max(to_no)  into :system_to from transfer_master  where project_id = :gs_project and user_field3 =  :ls_orderno using SQLCA;
	
	if (ll_count =0 ) then 
		select count(*)   into :ll_count1  
		from transfer_master with(nolock)
		where project_id = :gs_project and To_no = :ls_orderno  ; 
		
		if ( ll_count1 =0 ) then 
			messagebox ("Inbound", "Please provide the valid order number" )
			return 	
		else
			select user_field3    into :ls_temporder
			from transfer_master with(nolock)
			where project_id = :gs_project and To_no = :ls_orderno ; 

			ls_orderno = 	ls_temporder
			sle_2.text  = ls_orderno
		end if 
	end if 
	
	dw_1.retrieve(gs_project,ls_orderno)
	dw_1.object.t_12.text = ls_ordertype
	
	if (dw_1.rowcount() = 0) then 
	
		If cbx_1.Checked = False then
			messagebox( "Alert", "No records are found in current Method Trace Log, please select Archive to look for records")
			return 
		Else
			messagebox (" Method Log","No entries Found ")
			return 
		End if 
	end if 
	
	select complete_date, ord_date, to_no, ord_status, record_create_date  into :ld_compdate , :ld_ordedate,  :system_no, :ls_orderstat,:ld_recorddt
	from transfer_master with(nolock)
	where project_id = :gs_project and user_field3 = :ls_orderno using sQLCA;	
	
	ls_ftpname = dw_1.getitemstring(1,'ftp_file_name')
	ls_cruser = dw_1.getitemstring(1,'userid') 
	
	If(  ls_cruser = 'simsftp' ) then 
		dw_2.setitem(i,'entered_As',"Electronically")
		dw_2.setitem(i,'arr_date',string(ld_ordedate))
		dw_2.setitem(i,'record_create_dt',ld_recorddt)
	else
		dw_2.setitem(i,'entered_As',"Manualy")
		dw_2.setitem(i,'arr_date',string(ld_ordedate))
		dw_2.setitem(i,'record_create_dt',ld_recorddt)
	end if 
	
	st_2.text = string(ld_compdate)
	st_4.text = string (ld_ordedate)
	
	choose case ls_orderstat
	case "H"
		st_6.text = "HOLD"
	case "N"
		st_6.text = "NEW"
	case "P"
		st_6.text = "PROCESS"
	case "C"
		st_6.text = "COMPLETED"
	case "V"
		st_6.text = "VOID"
	end choose	
	
	lswhere += " and Trans_Order_Id = '" + system_to  + "'"
	lsNewSql = lsOrigSQL + lsWhere
	
	dw_3.SetSqlSelect(lsNewSql)
	dw_3.settransobject(SQLCA)
	dw_3.Retrieve(gs_project, system_to)
	dw_3.setfocus()
//SANTOSH20140721 - added for SOC change - pandora.- END

// Sarun2015Aug12: Added Cycle Count Method Trace Log to Dashbaord and Added Sims Version column to report
elseIF rb_4.checked = TRUE  THEN
	wf_cc_log()
	lswhere += " and Trans_Order_Id ='"+ ls_orderno +"'"
	lsNewSql = lsOrigSQL + lsWhere
	
	dw_3.setsqlselect( lsNewSql)
	dw_3.settransobject( SQLCA)
	dw_3.retrieve()
	dw_3.setfocus()

//29-May-2018 :Madhu S19730 - Added Item Master	
elseIF rb_5.checked = TRUE THEN
	
	ls_sku= trim(sle_2.text)
	ls_supp_code= trim(sle_3.text)
	
	IF IsNull(ls_supp_code) or ls_supp_code ='' THEN
		MessageBox("Method Trace Log", "Please provide valid Supplier Code to Retrieve Item Master Record!", Stopsign!)
		sle_3.setfocus( )
		Return -1
	END IF
		
	//Item Master List (dw_edifilelist)
	dw_edifilelist.dataobject ='d_method_edi_fileslist_item_master'
	dw_edifilelist.settransobject( SQLCA)
	dw_edifilelist.retrieve(gs_project, ls_sku, ls_supp_code )
	
	//Method Trace Log (dw_1)
	lsOrigSql = dw_1.getsqlselect( )
	lsWhere = " AND Object_Name like 'w_item_master%' "
	
	lsNewSql = lsOrigSql + lsWhere
	
	dw_1.setsqlselect( lsNewSql)
	dw_1.retrieve( gs_project, ls_sku )
	
end if
end event

type dw_1 from datawindow within w_method_log
integer x = 5
integer y = 720
integer width = 5193
integer height = 1248
integer taborder = 20
string title = "none"
string dataobject = "d_method_LOG"
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event doubleclicked;//18th March 014- written the retrive the details of batch transaction - Santosh
Str_parms	lstrParms

long ll_cnt, lirc
String ls_userid , ls_orderno,ls_date_from,ls_date_to
Datetime  ld_min, ld_max
Datastore  idsOut

ls_orderno=trim(sle_2.text)

if ls_orderno ='' then 
	return
end if 

//
//If cbx_1.checked = TRUE Then 
//	If Not isvalid(idsOut) Then
//		idsOut = Create Datastore
//		idsOut.Dataobject = 'd_method_log_two'
//		lirc = idsOut.SetTransobject(sqlca)
//	end if 
//Else 
//	If Not isvalid(idsOut) Then
//		idsOut = Create Datastore
//		idsOut.Dataobject = 'd_method_LOG'
//		lirc = idsOut.SetTransobject(sqlca)
//	End if 
//End If


//idsOut.retrieve(gs_project,ls_orderno)
ll_cnt = dw_1.rowcount()

dw_1 .SetSort("Method_enter_dt  A")
dw_1 .Sort()

ls_userid =dw_1.GetItemstring(row,"userid")
ld_min = dw_1.GetItemdatetime(1,"method_enter_dt")
ld_max = dw_1.GetItemdatetime(ll_cnt,"method_enter_dt")

//19-Jun-2014 :Madhu- Get User Data by passing one prior + one day ahead to mix, max dates- START
ls_date_from = String(Year(Date(ld_min))) +"-"+String(Month(Date(ld_min))) +"-"+String(Day(Date(ld_min)) -1) //Get 1 day prior
ls_date_to = String(Year(Date(ld_max))) +"-"+String(Month(Date(ld_max))) +"-"+String(Day(Date(ld_max)) +1) //Get 1 day after

ld_min =DateTime(ls_date_from)
ld_max =DateTime(ls_date_to)
//19-Jun-2014 :Madhu- Get User Data by passing one prior + one day ahead to mix, max dates- END

lstrparms.String_Arg[1] = ls_userid 
lstrparms.Datetime_Arg[2]= ld_min
lstrparms.Datetime_Arg[3]= ld_max


//destroy idsout
	If Not isvalid(idsOut) Then
		idsOut = Create Datastore
		idsOut.Dataobject = 'd_user_login_history'
		lirc = idsOut.SetTransobject(sqlca)
		idsOut.Retrieve(ls_userid, ld_min, ld_max, gs_project)
		
			If 	(idsOut.rowcount() = 0) then 
				if row=0 then 
					return
				end if 
				messagebox ("Login History ","User login details  are NOT avaiable for this order ")
				Destroy idsOut
				Return 
			Else
				Openwithparm(w_user_history, lstrParms)
			End if 
End if 
		




end event

type sle_2 from singlelineedit within w_method_log
integer x = 2345
integer y = 56
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
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
end type

type gb_1 from groupbox within w_method_log
integer y = 20
integer width = 1966
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
string text = "Process"
end type

type gb_2 from groupbox within w_method_log
integer x = 5
integer y = 180
integer width = 5198
integer height = 548
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

type gb_3 from groupbox within w_method_log
integer y = 1988
integer width = 5216
integer height = 560
integer taborder = 40
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Shipment Details"
end type

