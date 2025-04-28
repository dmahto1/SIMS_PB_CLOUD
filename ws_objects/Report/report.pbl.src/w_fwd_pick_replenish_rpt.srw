$PBExportHeader$w_fwd_pick_replenish_rpt.srw
$PBExportComments$Window used for displaying FWD Pick replenishment information
forward
global type w_fwd_pick_replenish_rpt from w_std_report
end type
type rb_all from radiobutton within w_fwd_pick_replenish_rpt
end type
type rb_below from radiobutton within w_fwd_pick_replenish_rpt
end type
end forward

global type w_fwd_pick_replenish_rpt from w_std_report
integer width = 3579
integer height = 2124
string title = "FWD Pick Replenish Report"
rb_all rb_all
rb_below rb_below
end type
global w_fwd_pick_replenish_rpt w_fwd_pick_replenish_rpt

type variables
datastore idsAvailInv
datastore idsExport


end variables

forward prototypes
public subroutine doexcelexport ()
end prototypes

public subroutine doexcelexport ();int i
long rows
long index
long innerIndex
long childRows

string lsProject
string lsWarehouse
string lsSku
string lsSupplier
string lsLocation
string lsPartialPick

long insertRow

u_dwexporter exportr

idsExport.reset()

rows = dw_report.rowcount()
for index = 1 to rows
	
	lsProject = dw_report.object.item_forward_pick_project_id[ index ]
	lsWarehouse = dw_report.object.item_forward_pick_wh_code[ index ]
	lsSku = dw_report.object.item_forward_pick_sku_1[ index ]
//	lsSupplier = dw_report.object.item_forward_pick_supp_code_1[ index ] 

	lsSupplier = dw_report.object.item_forward_pick_supp_code[ index ] //Nxjain 06062014

	lsLocation = dw_report.object.item_forward_pick_l_code_1[ index ]
	
	insertRow = idsExport.insertrow( 0 )
	idsExport.object.project[ insertrow ] = lsProject
	idsExport.object.warehouse[ insertrow ] = lsWarehouse
	idsExport.object.sku[ insertrow ] = lsSku
	idsExport.object.supplier[ insertrow ] = lsSupplier
	idsExport.object.location[ insertrow ] = lsLocation
	idsExport.object.replenishtriggerqty[ insertrow ] 	= dw_report.object.min_fp_qty[ index ]
	idsExport.object.maxqtytopick[ insertrow ] 			= dw_report.object.max_qty_to_pick[ index ]
	idsExport.object.replenishqty[ insertrow ] 				= dw_report.object.replenish_qty[ index ]
	idsExport.object.cartonqty[ insertrow ] 					= dw_report.object.qty_2[ index ]
	lsPartialPick = 'Bulk'
	if dw_report.object.partial_pick_ind[ index ] = 'Y' then lsPartialPick = 'FWD'
	idsExport.object.partialpick[ insertrow ] 				= lsPartialPick
	idsExport.object.loccurr_qty[ insertrow ] 				= dw_report.object.c_curr_qty[ index ]
	idsExport.object.locpending_qty[ insertrow ] 			= dw_report.object.c_pending_qty[ index ]
	idsExport.object.loctotal_qty[ insertrow ] 				= dw_report.object.c_total_qty[ index ]
	idsExport.object.replenishSort[ insertrow ] 			= dw_report.object.c_replen_sort[ index ]

	childRows = idsAvailInv.retrieve( lsProject, lsWarehouse, lsSku, lsSupplier, lsLocation )
	for innerIndex = 1 to childRows
		if innerIndex > 1 then
			insertRow = idsExport.insertrow(0)
			idsExport.object.project[ insertrow ] = lsProject
			idsExport.object.warehouse[ insertrow ] = lsWarehouse
			idsExport.object.sku[ insertrow ] = lsSku
			idsExport.object.supplier[ insertrow ] = lsSupplier
			idsExport.object.location[ insertrow ] = lsLocation
			idsExport.object.replenishtriggerqty[ insertrow ] 	= dw_report.object.min_fp_qty[ index ]
			idsExport.object.maxqtytopick[ insertrow ] 			= dw_report.object.max_qty_to_pick[ index ]
			idsExport.object.replenishqty[ insertrow ] 				= dw_report.object.replenish_qty[ index ]
			idsExport.object.cartonqty[ insertrow ] 					= dw_report.object.qty_2[ index ]
			lsPartialPick = 'Bulk'
			if dw_report.object.partial_pick_ind[ index ] = 'Y' then lsPartialPick = 'FWD'
			idsExport.object.partialpick[ insertrow ] 				= lsPartialPick
			idsExport.object.loccurr_qty[ insertrow ] 				= dw_report.object.c_curr_qty[ index ]
			idsExport.object.locpending_qty[ insertrow ] 			= dw_report.object.c_pending_qty[ index ]
			idsExport.object.loctotal_qty[ insertrow ] 				= dw_report.object.c_total_qty[ index ]
			idsExport.object.replenishSort[ insertrow ] 			= dw_report.object.c_replen_sort[ index ]
		End If
		idsExport.object.avail_qty[ insertrow ] 			= idsAvailInv.object.avail_qty[ innerIndex ]
		idsExport.object.doh[ insertrow ] 						= idsAvailInv.object.daysonhand[ innerIndex ]
	next
	
next
rows = idsExport.rowcount()
if rows > 0 then 
	exportr.initialize()
	exportr.doExcelExportDS( idsExport, rows, true  )	
	exportr.cleanup()
end if


end subroutine

on w_fwd_pick_replenish_rpt.create
int iCurrent
call super::create
this.rb_all=create rb_all
this.rb_below=create rb_below
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_all
this.Control[iCurrent+2]=this.rb_below
end on

on w_fwd_pick_replenish_rpt.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_all)
destroy(this.rb_below)
end on

event resize;dw_report.Resize(workspacewidth() - 30,workspaceHeight()-175)
end event

event ue_clear;dw_select.Reset()
dw_select.InsertRow(0)
dw_Select.SetItem(1,'warehouse',gs_default_wh)
end event

event ue_retrieve;

dw_report.SetRedraw(False)

dw_report.SetFilter('')
dw_report.Filter()

dw_report.Retrieve(gs_project,dw_select.GetITemString(1,'warehouse'))

//If RB checked, only show where we are below
if rb_below.Checked Then
	dw_report.SetFilter("c_replen_sort <> 1")
	dw_Report.Filter()
End If
If dw_report.RowCount() > 0 Then
	im_menu.m_file.m_print.Enabled = True
	dw_report.Setfocus()
Else
	im_menu.m_file.m_print.Enabled = False	
	MessageBox(is_title, "No records found!")
	dw_select.Setfocus()
End If

dw_report.SetRedraw(True)
end event

event ue_postopen;call super::ue_postopen;DatawindowChild	ldwc_warehouse
String	lsFilter

//populate dropdowns - not done automatically since dw not being retrieved

dw_select.GetChild('warehouse', ldwc_warehouse)
ldwc_warehouse.SetTransObject(Sqlca)
//ldwc_warehouse.Retrieve(gs_project)
dw_Select.SetItem(1,'warehouse',gs_default_wh)

//ldwc_warehouse.InsertRow(0)
g.of_set_warehouse_dropdown(ldwc_warehouse)

If gs_default_WH > '' Then
	dw_select.SetITem(1,'warehouse',gs_default_WH) /* 04/04 - PCONKL - Warehouse now reauired field on search to keep users within their domain*/
End IF

rb_all.Checked = True

idsAvailInv = Create datastore
idsAvailInv.dataobject = 'd_fwd_pick_replenish_avail_inv'
idsAvailInv.settransobject( sqlca )

idsExport = Create datastore
idsExport.dataobject = 'd_fwd_pick_replenish_export'

//Jxlim 11/17/2012 Pandora BRD#464 fwd Pick 
If Upper(gs_project) = 'PANDORA' Then
	dw_report.dataobject = 'd_pandora_fwd_pick_replenish_rpt'
	dw_report.settransobject( sqlca )
Else
	dw_report.dataobject = 'd_fwd_pick_replenish_rpt'
	dw_report.settransobject( sqlca )
End If

end event

event ue_file;String	lsOption

lsoption = Message.StringParm

Choose Case lsoption
		

	Case "PRINTPREVIEW" /*print preview window*/
		
		OpenwithParm(w_printzoom,dw_report)
			
	// pvh - 09/06/05				
	Case "SAVEAS" /*Export*/
		if messagebox( "Save As", "Export to Excel?",question!,yesno!) = 1 then
			doExcelExport(  )
		else
			dw_report.Saveas()
		end if
	// eom	
		
End Choose
end event

type dw_select from w_std_report`dw_select within w_fwd_pick_replenish_rpt
integer y = 28
integer width = 1577
integer height = 96
string dataobject = "d_warehouse_display_wh_code"
boolean border = false
borderstyle borderstyle = stylebox!
end type

type cb_clear from w_std_report`cb_clear within w_fwd_pick_replenish_rpt
integer x = 3191
integer y = 8
integer width = 320
end type

type dw_report from w_std_report`dw_report within w_fwd_pick_replenish_rpt
integer x = 32
integer y = 160
integer width = 3483
integer height = 1780
string dataobject = "d_fwd_pick_replenish_rpt"
boolean hscrollbar = true
end type

type rb_all from radiobutton within w_fwd_pick_replenish_rpt
integer x = 1650
integer width = 695
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
string text = "Show All Items"
end type

event clicked;
dw_report.SetFilter("")
	dw_Report.Filter()
end event

type rb_below from radiobutton within w_fwd_pick_replenish_rpt
integer x = 1650
integer y = 60
integer width = 1458
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
string text = "Show only Items at or Below Replenishment Point"
end type

event clicked;
dw_report.SetFilter("c_replen_sort <> 1")
dw_Report.Filter()
end event

