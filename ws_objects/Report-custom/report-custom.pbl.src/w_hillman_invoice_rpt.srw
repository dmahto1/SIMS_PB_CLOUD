$PBExportHeader$w_hillman_invoice_rpt.srw
$PBExportComments$Window used for Genrad invoice information
forward
global type w_hillman_invoice_rpt from w_std_report
end type
type ole_numtotext from olecustomcontrol within w_hillman_invoice_rpt
end type
end forward

global type w_hillman_invoice_rpt from w_std_report
integer width = 3703
integer height = 2240
string title = "Hillman Invoice "
ole_numtotext ole_numtotext
end type
global w_hillman_invoice_rpt w_hillman_invoice_rpt

type variables
string is_origsql2, isOrder,ls_orderno
long il_long
integer ii_cnt

end variables

forward prototypes
public function string wf_numtotext (string as_num)
end prototypes

public function string wf_numtotext (string as_num);//....Called from ue_postopen
string ls_int, ls_rem, ls_txt, ls_pwd
integer li_pos
/* GetString is only returning whole numbers, so call it twice, the 2nd time with the remainder 
     (separate the Dollar amount from the Cents amount with ' con ') */
/* dts - 11/23/04 Now using Pesos and not converting the 'centavos' portion to text
		- Instead, printing 'xxxxxx pesos yy/100 MN'
		  (where 'xxxxxx' is the Spanish-converted number and 'yy' is the centavos portion)
		  (ie; Doscientos seis pesos 14/100 MN)
	Now 11/29/04, and Home Depot advised Hillman they're not ready for Pesos
	  - Rolled back to USD version by promoting previous version (from Pete's pc) to production
*/

//ls_pwd = "<x].-("
ls_pwd = "GWTAGJBG00CAB36P5AW00CLTV*KJB400CRNR4TJDJ00CAB36P5AW00CEBPTAUDF00CEBPTAUDF00CEBPTAUDF00CEBPTAUDF00CEBPTAUDF00CG7JRHJDU00CPNJ%MJDJ00CGAH%HJDM00CJ*EWG5AP00CM%UVP5AD00C26YXG5A300CEBPTAUDF00CEBPTAUDF00CEBPTAUDF00CEBPTAUDF00CCPFRPJBH00CB26CR5A200CMWKHN5A800CRYG%E5AW00CUTUHC5A%00CCBFGJJDL00C7*DVLJBX00C7YU5P5AA00C8%KRAUDY00CEK26GJDP00C"
ole_NumToText.object.Password(ls_pwd)
// 
ls_rem = '00'
li_pos = pos(as_num, ".")
if li_pos > 0 then
	ls_int = left(as_num, li_pos - 1)
	ls_rem = mid(as_num, li_pos + 1)
	if len(ls_rem) = 1 then ls_rem = ls_rem + "0"
		//ls_rem = string(integer(ls_rem) * 10)
else
	ls_int = as_num
end if


//ls_txt = ole_NumToText.object.GetString(double(as_num), 0)
ls_txt = ole_NumToText.object.GetString(double(ls_int), 0)

/* 11/23/04 - No longer converting the cents to spanish text
if li_pos > 0 then
	ls_txt = ls_txt + " con " + ole_NumToText.object.GetString(double(ls_rem), 0)
end if
*/
// Now appending 
ls_txt = ls_txt + ' pesos ' + ls_rem + '/100 MN'
//messagebox("wf_NumToText", "Total: " + as_num + ", Int: " + ls_int + ", Rem:" + ls_rem + char(13) + ls_txt)

return ls_txt


end function

on w_hillman_invoice_rpt.create
int iCurrent
call super::create
this.ole_numtotext=create ole_numtotext
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.ole_numtotext
end on

on w_hillman_invoice_rpt.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.ole_numtotext)
end on

event resize;dw_report.Resize(workspacewidth() - 30,workspaceHeight()-210)
end event

event ue_clear;dw_select.Reset()
dw_select.InsertRow(0)
//
end event

event ue_retrieve;//retrieve the order information from database   wason 12/23
string ls_invoice_no,ls_field3,ls_field5,ld_freightcost,ls_temp1,ls_temp2
int li_invoiceno,i //li_cnt

If isVAlid(w_do) Then                                     //wason 01/04
	if w_do.idw_main.RowCOunt() > 0 Then                   //wason 01/04
		ls_orderno = w_do.idw_main.GetITemString(1,'do_no') //wason 01/04
	End If                                                 //wason 01/04
End If                                                    //wason 01/04

If isnull(ls_OrderNo) or ls_OrderNo = '' Then
	Messagebox(is_Title,'You must have a valid Delivery Order open~rbefore you can print the invoice')
	Return
End If

dw_report.modify("DataWindow.Print.Preview = yes ")
ii_cnt=dw_report.retrieve(ls_orderno)

IF ii_cnt > 0  THEN
	dw_select.Setfocus()
  im_menu.m_file.m_print.Enabled = TRUE  
  im_menu.m_file.m_printpreview.Enabled = false
ELSE
	im_menu.m_file.m_print.Enabled = FALSE	
	MessageBox(is_title, "Order not in Packing or Ready Status!~r~rInvoice can not be printed!")
/*dts 11/01/06 - Inadvertently ended up with the message below which was only
//		in place for a short time. Back to original 'Packing Status' message. */
// TAM 2005/04/27  Changed the requirement to only allow printing "COMPLETED" orders
//	MessageBox(is_title, "Order not in Completed Status!~r~rInvoice can not be printed!")
	dw_select.Setfocus()
END IF
















		







end event

event ue_print;//Ancestor overridden
int li_rowcount,li_cnt,i, li_find, li_line_item_no //, li_invoiceno
long li_invoiceno //dts 10/25/06 invoices now over integer limit (of 32768-ish)
string ls_invoiceno,ls_IVA, ls_sku

dw_select.accepttext()
li_rowcount=dw_report.rowcount()


if dw_select.getitemnumber(1,"invoice_no") <>0 then
  li_invoiceno=dw_select.getitemnumber(1,"invoice_no")
  /*don't allow the user to get out of Preview mode
     - it affects the paging upon which Invoice number is based */
else
  //im_menu.m_file.m_print.Enabled = FALSE 
  messagebox("","Please enter the beginning invoice number!")
  dw_select.Setfocus()
  return
end if

for i = 1 to li_rowcount
	dw_report.setitem(i,"invoiceno",li_invoiceno)
next

OpenWithParm(w_dw_print_options,dw_report) 

ls_invoiceno = string(dw_report.getitemnumber(li_rowcount,"compute_4")+dw_report.getitemnumber(li_rowcount,"invoiceno"))
ls_invoiceno= fill("0",4 - len(ls_invoiceno)) + ls_invoiceno

ls_IVA = string(dw_report.getitemnumber(li_rowcount,"compute_6"))

// We need to updated the fields on the DO screen - they may confirm the order without re-retreiving first.
If isVAlid(w_do) Then                                     
	if w_do.idw_main.RowCOunt() > 0 Then                   
		w_do.idw_Other.SetITem(1,'User_field2',ls_IVA)
		w_do.idw_Other.SetITem(1,'User_field4',ls_invoiceno)
		
		if w_do.idw_detail.RowCount() > 0 Then 
			
			//Need to save each page item was printed on.
			
			for i = 1 to li_rowcount
			
				ls_sku = dw_report.GetItemString( i, "delivery_detail_sku")
				li_line_item_no = dw_report.GetItemNumber( i, "line_item_no")

				ls_invoiceno = dw_report.getitemstring(i,"current_invoice")
			
				li_find = w_do.idw_detail.Find("sku='"+ls_sku+"' " + " and line_item_no="+string(li_line_item_no) , 1, dw_report.RowCount())

				if li_find > 0 then
			
					w_do.idw_detail.SetItem(li_find, "User_field4", ls_invoiceno)
		
		
				end if
		
			next
		
		end if
		
		w_do.ib_changed = True
	End If                                                 
End If    

//update delivery_master 
//set user_field4 = :ls_invoiceno ,user_field2 = :ls_IVA
//where do_no = :ls_orderno
//using sqlca;
//
//IF sqlca.SQLNRows > 0 THEN
//		COMMIT USING sqlca ;
//ELSE 
//	Messagebox("","Update error!,Pls print this invoice again")
//END IF
 




end event

event ue_postopen;string ls_Modify, ls_Total, ls_Spanish

this.TriggerEvent("ue_retrieve")

if ii_cnt> 0 then
	ls_total = string(dw_report.object.c_total[1])
	ls_Spanish = wf_NumToText(ls_Total)
	// 11/23/04 wf_NumToText is now returning total as 'xxxxxx pesos 25/100 MN'
	//ls_Spanish += " USD"
	
	ls_Modify = "t_NumToText.Text = '" + ls_Spanish + "'"
	dw_report.Modify(ls_Modify)
end if
end event

type dw_select from w_std_report`dw_select within w_hillman_invoice_rpt
event ue_populate_dropdowns ( )
event ue_process_enter pbm_dwnprocessenter
integer x = 23
integer y = 24
integer width = 1957
integer height = 152
string dataobject = "d_hillman_invoice_input"
boolean controlmenu = true
boolean border = false
borderstyle borderstyle = stylebox!
end type

event dw_select::itemerror;Return 1
end event

type cb_clear from w_std_report`cb_clear within w_hillman_invoice_rpt
integer y = 32
integer taborder = 20
end type

type dw_report from w_std_report`dw_report within w_hillman_invoice_rpt
integer x = 5
integer y = 184
integer width = 3483
integer height = 968
integer taborder = 30
string dataobject = "d_hillman_invoice_rpt"
boolean hscrollbar = true
end type

type ole_numtotext from olecustomcontrol within w_hillman_invoice_rpt
integer x = 2391
integer y = 64
integer width = 110
integer height = 96
integer taborder = 30
boolean bringtotop = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
string binarykey = "w_hillman_invoice_rpt.win"
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
end type


Start of PowerBuilder Binary Data Section : Do NOT Edit
03w_hillman_invoice_rpt.bin 
2900000c00e011cfd0e11ab1a1000000000000000000000000000000000003003e0009fffe000000060000000000000000000000010000000100000000000010000000000200000001fffffffe0000000000000000fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffd00000004fffffffefffffffefffffffeffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff006f00520074006f004500200074006e00790072000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000050016ffffffffffffffff00000003000000000000000000000000000000000000000000000000000000008d788ea001cca62900000003000001400000000000500003004c004200430049004e0045004500530045004b000000590000000000000000000000000000000000000000000000000000000000000000000000000002001cffffffffffffffffffffffff00000000000000000000000000000000000000000000000000000000000000000000000000000000000000280000000000500003004f0042005800430054005300450052004d0041000000000000000000000000000000000000000000000000000000000000000000000000000000000002001affffffffffffffffffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000010000004800000000004200500043004f00530058004f00540041005200450047000000000000000000000000000000000000000000000000000000000000000000000000000000000101001a000000020000000100000004611a9f9d4cf6e32c2bdaf9a72ac8fcf8000000008d788ea001cca6298d788ea001cca629000000000000000000000000fffffffe00000002fffffffe00000004fffffffeffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
26ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00680073006b006f006a0067006a00670068007100680072006d0067006b00720069006e006800670000000000000000000000000000000000000000000000000000b29300000048000800034757f20b000000200065005f00740078006e0065007800740000027b000800034757f20affffffe00065005f00740078006e0065007900740000027b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000b29300000048000800034757f20b000000200065005f00740078006e0065007800740000027b000800034757f20affffffe00065005f00740078006e0065007900740000027b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004f00430054004e004e00450053005400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001020012ffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000000000000000000300000048000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffff00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
13w_hillman_invoice_rpt.bin 
End of PowerBuilder Binary Data Section : No Source Expected After This Point
