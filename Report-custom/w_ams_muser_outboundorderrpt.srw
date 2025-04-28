HA$PBExportHeader$w_ams_muser_outboundorderrpt.srw
forward
global type w_ams_muser_outboundorderrpt from w_std_query_window
end type
type rb_default from radiobutton within w_ams_muser_outboundorderrpt
end type
type rb_amd from radiobutton within w_ams_muser_outboundorderrpt
end type
type rb_spansion from radiobutton within w_ams_muser_outboundorderrpt
end type
type gb_export from groupbox within w_ams_muser_outboundorderrpt
end type
end forward

global type w_ams_muser_outboundorderrpt from w_std_query_window
string title = "  AMS OUTBOUND ORDER REPORT"
event ue_set_export_tags ( )
rb_default rb_default
rb_amd rb_amd
rb_spansion rb_spansion
gb_export gb_export
end type
global w_ams_muser_outboundorderrpt w_ams_muser_outboundorderrpt

type variables
uo_multi_select_search StatusSelect

end variables

forward prototypes
public subroutine setcriteriadw ()
end prototypes

event ue_set_export_tags();
//Set the Excel export tags based on the export radio buttons...

Long	llCols, llPos

//Clear existing Tags

llCols = Long( u_query.dw_report.Describe( 'datawindow.column.count' ) )
FOR llPos = llCols TO 1 STEP -1
	
	u_query.dw_report.Modify('#' + String( llPos ) + '.Tag=""')
	
//	asValue = adw_DW.Describe( '#' + String( index ) + '.Tag' )
//	if isNull( asValue) or len( asValue) = 0 or asValue = "?"  then continue
//	as_columns[ getColumnPosition( asValue ) ] = adw_DW.Describe( '#' + String( index ) + '.Name' )

NEXT


//Reset tags absed on export template
If rb_default.Checked Then
	
	u_query.dw_report.Modify("delivery_master_wh_code.Tag='1:Warehouse'")
	u_query.dw_report.Modify("delivery_master_invoice_no.Tag='2:Invoice No'")
	u_query.dw_report.Modify("awbno.Tag='3:AWB No'")
	u_query.dw_report.Modify("delivery_master_cust_code.Tag='4:Customer Code'")
	u_query.dw_report.Modify("delivery_master_cust_name.Tag='5:Customer Name'")
	u_query.dw_report.Modify("delivery_master_address_1.Tag='6:Address'")
	u_query.dw_report.Modify("delivery_master_address_2.Tag='7:Address 2'")
	u_query.dw_report.Modify("delivery_master_address_3.Tag='8:Address 3'")
	u_query.dw_report.Modify("delivery_master_city.Tag='9:City'")
	u_query.dw_report.Modify("delivery_master_state.Tag='10:State'")
	u_query.dw_report.Modify("delivery_master_zip.Tag='11:Zip'")
	u_query.dw_report.Modify("delivery_master_country.Tag='12:Country'")
	u_query.dw_report.Modify("carrier.Tag='13:Carrier'")
	u_query.dw_report.Modify("delivery_master_complete_date.Tag='14:Complete Date'")
	u_query.dw_report.Modify("t1_order.Tag='15:T1'")
//	u_query.dw_report.Modify("customs_doc.Tag='15:T1'")
	u_query.dw_report.Modify("mawb.Tag='16:MAWB'")
	u_query.dw_report.Modify("edi_outbound_detail_lot_no.Tag='17:HAWB'")
	u_query.dw_report.Modify("sap_order_no.Tag='18:SAP Order No'")
	u_query.dw_report.Modify("po.Tag='19:PO'")
	u_query.dw_report.Modify("delivery_detail_sku.Tag='20:SKU'")
	u_query.dw_report.Modify("item_master_description.Tag='21:Description'")
	u_query.dw_report.Modify("allocated_qty.Tag='22:QTY'")
	u_query.dw_report.Modify("weight.Tag='23:Weight'")
	u_query.dw_report.Modify("no_boxes.Tag='24:No Boxes'")
	u_query.dw_report.Modify("value.Tag='25:Value'")
	
Elseif rb_amd.checked Then
	
	u_query.dw_report.Modify("mawb.Tag='1:MAWB'")
	u_query.dw_report.Modify("edi_outbound_detail_lot_no.Tag='2:HAWB'")
	u_query.dw_report.Modify("sap_order_no.Tag='3:SAP Order No'")
	u_query.dw_report.Modify("item_master_description.Tag='4:Description'")
	u_query.dw_report.Modify("allocated_qty.Tag='5:QTY'")
	u_query.dw_report.Modify("weight.Tag='6:Weight'")
	u_query.dw_report.Modify("no_boxes.Tag='7:No Boxes'")
	u_query.dw_report.Modify("delivery_master_cust_name.Tag='8:Customer Name'")
	u_query.dw_report.Modify("delivery_master_address_1.Tag='9:Address'")
	u_query.dw_report.Modify("delivery_master_address_2.Tag='10:Address 2'")
	u_query.dw_report.Modify("delivery_master_city.Tag='11:City'")
	u_query.dw_report.Modify("po.Tag='12:PO'")
	u_query.dw_report.Modify("delivery_master_cust_code.Tag='13:Customer Code'")
	u_query.dw_report.Modify("carrier.Tag='14:Carrier'")
	u_query.dw_report.Modify("awbno.Tag='15:AWB No'")
//	u_query.dw_report.Modify("customs_doc.Tag='16:T1'")
	u_query.dw_report.Modify("t1_order.Tag='16:T1'")
	
ElseIf rb_spansion.Checked Then
	
	u_query.dw_report.Modify("carrier.Tag='1:Carrier'")
	u_query.dw_report.Modify("awbno.Tag='2:AWB No'")
	u_query.dw_report.Modify("delivery_master_cust_code.Tag='3:Customer Code'")
	u_query.dw_report.Modify("delivery_master_cust_name.Tag='4:Customer Name'")
	u_query.dw_report.Modify("delivery_master_address_1.Tag='5:Address'")
	u_query.dw_report.Modify("delivery_master_city.Tag='6:City'")
	u_query.dw_report.Modify("delivery_master_zip.Tag='7:Zip'")
	u_query.dw_report.Modify("delivery_master_country.Tag='8:Country'")
	u_query.dw_report.Modify("mawb.Tag='9:MAWB'")
	u_query.dw_report.Modify("edi_outbound_detail_lot_no.Tag='10:HAWB'")
	u_query.dw_report.Modify("sap_order_no.Tag='11:SAP Order No'")
	u_query.dw_report.Modify("po.Tag='12:PO'")
	u_query.dw_report.Modify("delivery_detail_sku.Tag='13:SKU'")
	u_query.dw_report.Modify("item_master_description.Tag='14:Description'")
	u_query.dw_report.Modify("allocated_qty.Tag='15:QTY'")
	u_query.dw_report.Modify("weight.Tag='16:Weight'")
	u_query.dw_report.Modify("no_boxes.Tag='17:No Boxes'")
	u_query.dw_report.Modify("value.Tag='18:Value'")
	u_query.dw_report.Modify("t1_order.Tag='19:T1'")
	
End If
end event

public subroutine setcriteriadw ();long insertrow
datawindowchild adwc

// manipulate the criteria dw here

u_query.dw_select.getchild( "wh_code", adwc )
adwc.settransobject( sqlca )
adwc.retrieve( gs_project )

u_query.dw_select.getchild( "ord_type", adwc )
adwc.settransobject( sqlca )
adwc.retrieve( gs_project )
insertrow = adwc.insertrow(0)
adwc.setitem( insertrow , 'wh_name', '- All -' )
adwc.setitem( insertrow , 'wh_code', 'All' )
adwc.setsort( 'wh_name A' )
adwc.sort()
	
u_query.dw_select.insertrow(0)

u_query.setFromDateCol( 'fcomplete_date')
u_query.setToDateCol( 'tcomplete_date')

end subroutine

on w_ams_muser_outboundorderrpt.create
int iCurrent
call super::create
this.rb_default=create rb_default
this.rb_amd=create rb_amd
this.rb_spansion=create rb_spansion
this.gb_export=create gb_export
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_default
this.Control[iCurrent+2]=this.rb_amd
this.Control[iCurrent+3]=this.rb_spansion
this.Control[iCurrent+4]=this.gb_export
end on

on w_ams_muser_outboundorderrpt.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_default)
destroy(this.rb_amd)
destroy(this.rb_spansion)
destroy(this.gb_export)
end on

event open;// OVERRIDE

// w_ams_muser_outboundorderrpt
// Intitialize
//
// In your inherited version..... copy this ENTIRE BLOCK of code into your open event
// and add your two datasources to string arg 1 and two.
//
// NOTE:  string_arg[1] is the QUERY interface and
//			  string_arg[2] is the Report
//
//  if you need to do some child manipulation in the query window...put the code in setCriteriaDW()
//
//  you can manipulate and muck with the report sql in the u_retrieveReport() event.
// 
//	see w_gm_last_on_hand_rpt for an example of this.

	This.X = 0
	This.Y = 0
	
	str_parms lstrparms
	
	lstrparms = message.PowerObjectParm
	
	lstrparms.string_arg[1] = 'd_ams_muser_outbound_order_search'
	lstrparms.string_arg[2] = 'd_ams_muser_order_report'
	
	setredraw( false )
	
	openuserobjectwithparm( u_query, lstrparms)
	
	u_query.width = this.width -50
	u_query.height = this.height - 50
	u_query.dw_select.x = 0
	u_query.dw_select.y = 0
	u_query.dw_select.height = 500
	u_query.dw_report.y = (dw_select.height + 300 )
	u_query.dw_report.width = u_query.width
	
	u_query.setTitle( this.title )
// 
// 	If you want to add the project to the where clause sent the following true
// 	if your datawindow already has a where with the project, send false
//
	u_query.setAddProjectToWhere( FALSE )
	iWindow = this
	u_query.initialize( iWindow )

// manipulate the criteria here
	 setCriteriaDW()
	
// open the status multi select object
	openuserobject( StatusSelect,2325,0 )
	StatusSelect.height = 265
	StatusSelect.uf_init("d_ord_status_search_list", "delivery_master.Ord_Status", "ord_status")
	StatusSelect.bringtotop= true

	setredraw( true )
	
	is_title = This.Title
	im_menu = This.MenuId
	ilHelpTopicID = 506 /*default help topic for reports*/
	dw_report.SetTransObject(sqlca)
	dw_select.InsertRow(0)
	
	This.PostEvent("ue_postopen") /* 06/00 PCONKL*/




end event

event ue_retrievereport;call super::ue_retrievereport;// ue_retrieveReport()

// manipulate the select and retrieve the report
string StatusSelectSQL
long rows

if u_query.sqlutil.CreateWhereFromDW( u_query.dw_select ) = -1 then return 

StatusSelectSQL =  StatusSelect.uf_build_search(true)
if not isNull( StatusSelectSQL ) and len( StatusSelectSQL ) > 0 then
	StatusSelectSQL = right( StatusSelectSQL, len( StatusSelectSQL) -5 ) // strip off the AND
	u_query.sqlutil.setNewWhere( StatusSelectSQL )
end if
u_query.dw_report.SetSQlSelect( u_query.sqlutil.getSQL() )

rows = u_query.dw_report.retrieve()
choose case rows
	case is < 0
		messagebox(u_query.GetTitle(), 'Database Error!' + string( sqlca.sqlcode) + " : " + sqlca.sqlerrtext , exclamation! )
		return
	case 0
		im_menu.m_file.m_print.Enabled = False	
		messagebox( u_query.GetTitle(),  'No Records Found!', exclamation! )
		return
	case is > 0
		im_menu.m_file.m_print.Enabled = True
		dw_report.Setfocus()
end choose


end event

event ue_retrieve;call super::ue_retrieve;event ue_retrieveReport()
end event

event ue_clear;call super::ue_clear;StatusSelect.uf_clear_list()



end event

event ue_postopen;call super::ue_postopen;
rb_default.checked = True /* default to default export*/
end event

type dw_select from w_std_query_window`dw_select within w_ams_muser_outboundorderrpt
end type

type cb_clear from w_std_query_window`cb_clear within w_ams_muser_outboundorderrpt
end type

type dw_report from w_std_query_window`dw_report within w_ams_muser_outboundorderrpt
end type

type rb_default from radiobutton within w_ams_muser_outboundorderrpt
integer x = 123
integer y = 268
integer width = 270
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Default"
end type

event clicked;
Parent.TriggerEvent('ue_set_export_tags')
end event

type rb_amd from radiobutton within w_ams_muser_outboundorderrpt
integer x = 443
integer y = 272
integer width = 343
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "AMD"
end type

event clicked;Parent.TriggerEvent('ue_set_export_tags')
end event

type rb_spansion from radiobutton within w_ams_muser_outboundorderrpt
integer x = 677
integer y = 272
integer width = 343
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Spansion"
end type

event clicked;Parent.TriggerEvent('ue_set_export_tags')
end event

type gb_export from groupbox within w_ams_muser_outboundorderrpt
integer x = 50
integer y = 224
integer width = 1010
integer height = 140
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Export as"
end type

