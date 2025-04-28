$PBExportHeader$w_export_to_viaware.srw
$PBExportComments$Viaware Conversion Window
forward
global type w_export_to_viaware from window
end type
type tab_main from tab within w_export_to_viaware
end type
type tabpage_inventory from userobject within tab_main
end type
type dw_inventory from u_dw_ancestor within tabpage_inventory
end type
type tabpage_inventory from userobject within tab_main
dw_inventory dw_inventory
end type
type tabpage_inv_containers from userobject within tab_main
end type
type dw_inv_containers from u_dw_ancestor within tabpage_inv_containers
end type
type tabpage_inv_containers from userobject within tab_main
dw_inv_containers dw_inv_containers
end type
type tabpage_items from userobject within tab_main
end type
type tabpage_items from userobject within tab_main
end type
type tabpage_ib_header from userobject within tab_main
end type
type dw_ib_header from u_dw_ancestor within tabpage_ib_header
end type
type tabpage_ib_header from userobject within tab_main
dw_ib_header dw_ib_header
end type
type tabpage_ib_detail from userobject within tab_main
end type
type dw_ib_detail from u_dw_ancestor within tabpage_ib_detail
end type
type tabpage_ib_detail from userobject within tab_main
dw_ib_detail dw_ib_detail
end type
type tabpage_ib_container from userobject within tab_main
end type
type dw_ib_container from u_dw_ancestor within tabpage_ib_container
end type
type tabpage_ib_container from userobject within tab_main
dw_ib_container dw_ib_container
end type
type tab_main from tab within w_export_to_viaware
tabpage_inventory tabpage_inventory
tabpage_inv_containers tabpage_inv_containers
tabpage_items tabpage_items
tabpage_ib_header tabpage_ib_header
tabpage_ib_detail tabpage_ib_detail
tabpage_ib_container tabpage_ib_container
end type
end forward

global type w_export_to_viaware from window
integer x = 9
integer y = 4
integer width = 3264
integer height = 2044
boolean titlebar = true
string title = "Export to Viaware"
string menuname = "m_simple_edit"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 79741120
event ue_edit ( )
event ue_new ( )
event type long ue_save ( )
event ue_delete ( )
event ue_print ( )
event ue_refresh ( )
event ue_close ( )
event ue_retrieve ( )
event ue_postopen ( )
event ue_accept_text ( )
event ue_clear ( )
event ue_file ( )
event type long ue_sort ( )
event type long ue_filter ( )
event ue_help ( )
tab_main tab_main
end type
global w_export_to_viaware w_export_to_viaware

type variables
m_simple_edit im_menu
String is_title
String	isHelpKeyword
Long		ilHelpTopicID
String is_process = ""
Boolean ib_edit
Boolean ib_changed
str_parms istrparms
datawindow idw_current
Window	iwWindow


end variables

forward prototypes
public function integer wf_save_changes ()
public subroutine wf_check_menu (boolean ab_value, string as_option)
end prototypes

event ue_close;Close(This)
end event

event ue_retrieve();
If isvalid(idw_Current) Then idw_Current.TriggerEvent('ue_retrieve')

end event

event ue_postopen();

//Select appropriate tabs and datawindows based on Project and tables being exported 
Choose Case Upper(gs_project)
		
	Case 'DIEBOLD'
		
		//tabs
		tab_main.tabpage_ib_header.visible = True
		tab_main.tabpage_ib_detail.visible = True
		tab_main.tabpage_ib_container.visible = True
		tab_main.tabpage_inv_containers.visible = True
		
		//Dataobjects
		tab_main.tabpage_Inventory.dw_inventory.dataobject = 'd_viaware_conversion_inv_diebold'
		
		tab_main.tabpage_inv_containers.dw_inv_containers.dataobject = 'd_viaware_conversion_containers_diebold'
		tab_main.tabpage_inv_containers.dw_inv_containers.SetTransObject(SQLCA)
		
		tab_main.tabpage_ib_Header.dw_ib_Header.dataobject = 'd_viaware_conversion_po_header_diebold'
		tab_main.tabpage_ib_Header.dw_ib_Header.SetTransObject(SQLCA)
		
		tab_main.tabpage_ib_Detail.dw_ib_Detail.dataobject = 'd_viaware_conversion_po_detail_diebold'
		tab_main.tabpage_ib_Detail.dw_ib_Detail.SetTransObject(SQLCA)
		
		tab_main.tabpage_ib_Container.dw_ib_Container.dataobject = 'd_viaware_conversion_po_cntnr_diebold'
		tab_main.tabpage_ib_Container.dw_ib_Container.SetTransObject(SQLCA)
		
	Case 'NETAPP'
		
		//tab_main.tabpage_items.visible = true
		tab_main.tabpage_Inventory.dw_inventory.dataobject = 'd_viaware_conversion_inv_Netapp'
		
End Choose


tab_main.tabpage_Inventory.dw_inventory.SetTransObject(SQLCA)
end event

event ue_accept_text;IF ISValid(idw_current) THEN idw_current.AcceptText() 
end event

event ue_file();String	lsAction
//Triggered from Menu

lsAction = Message.StringParm

Choose CAse Upper(lsACtion)
		
	Case 'SAVEAS' /*export*/
		
		If isvalid(idw_current) Then
			idw_Current.TriggerEvent('ue_saveas')
		End If
		
End Choose


end event

event ue_sort;//This Event displays the sor criterial & sorts by the desire criteria
long ll_ret
String str_null
SetNull(str_null)
IF isvalid(idw_current) THEN
	ll_ret=idw_current.Setsort(str_null)
	ll_ret=idw_current.Sort()
	if isnull(ll_ret) then ll_ret=0
END IF	
return ll_ret
end event

event ue_filter;long ll_rtn
string null_str

SetNull(null_str)
	idw_current.SetRedraw(false)
	idw_current.SetFilter(null_str)
	idw_current.Filter()
	idw_current.SetRedraw(true)	
return ll_rtn
end event

event ue_help;Integer	liRC

//Help Topic ID is set in this event and passed to help file

//If you want to open by Topic ID, set the ilHelpTopicID to a valid Map #
// If you want to open by keyword, set the isHelpKeyord variable


If isHelpKeyword > ' ' Then
	lirc = ShowHelp(g.is_helpfile,Keyword!,isHelpKeyword) /*open by Keyword*/
ElseIf ilHelpTopicID > 0 Then
	lirc = ShowHelp(g.is_helpfile,topic!,ilHelpTopicID) /*open by topic ID*/
Else
	liRC = ShowHelp(g.is_HelpFile,Index!)
End If


end event

public function integer wf_save_changes ();Long ll_status

// 05/00 PCONKL - accept text on all dw's first to get changes if not tabbed out of field
This.TriggerEvent("ue_accept_text")

If ib_changed Then
	Choose Case Messagebox(is_title,"Save changes?",Question!,yesnocancel!,1)
		Case 1
			ll_status = This.Trigger event ue_save()
			Return ll_status
		Case 2
			ib_changed = False
			Return 0
		Case 3
			Return -1
	End Choose
Else
	Return 0
End If
end function

public subroutine wf_check_menu (boolean ab_value, string as_option);//For updating sort option
CHOOSE CASE lower(as_option)
	CASE 'sort'
		im_menu.m_file.m_sort.Enabled = ab_value
	CASE 'filter'
		im_menu.m_record.m_filter.Enabled = ab_value
END CHOOSE



end subroutine

on w_export_to_viaware.create
if this.MenuName = "m_simple_edit" then this.MenuID = create m_simple_edit
this.tab_main=create tab_main
this.Control[]={this.tab_main}
end on

on w_export_to_viaware.destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.tab_main)
end on

event open;SetPointer(HourGlass!)
This.move(0,0)
iwWindow = This

im_menu = This.MenuId

im_menu.m_record.m_new.Enabled = False
im_menu.m_record.m_delete.Enabled = False
im_menu.m_record.m_edit1.Enabled = False
im_menu.m_record.m_filter.Enabled = True
im_menu.m_file.m_save.Enabled = False
im_menu.m_file.m_print.Enabled = True



is_title = This.Title


This.PostEvent("ue_postOpen")
end event

event closequery;If wf_save_changes() = -1 Then
	Return 1
Else
	Return 0
End If
end event

event deactivate;//g.POST of_setmenu(TRUE)
end event

event resize;tab_main.Resize(workspacewidth(),workspaceHeight())
tab_main.tabpage_inventory.dw_inventory.Resize(workspacewidth() - 80,workspaceHeight()-250)
tab_main.tabpage_inv_containers.dw_inv_Containers.Resize(workspacewidth() - 80,workspaceHeight()-250)
tab_main.tabpage_ib_header.dw_ib_header.Resize(workspacewidth() - 80,workspaceHeight()-250)
tab_main.tabpage_ib_detail.dw_ib_detail.Resize(workspacewidth() - 80,workspaceHeight()-250)
tab_main.tabpage_ib_container.dw_ib_container.Resize(workspacewidth() - 80,workspaceHeight()-250)
end event

type tab_main from tab within w_export_to_viaware
integer x = 27
integer y = 20
integer width = 3173
integer height = 1808
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
boolean fixedwidth = true
boolean raggedright = true
alignment alignment = center!
integer selectedtab = 1
tabpage_inventory tabpage_inventory
tabpage_inv_containers tabpage_inv_containers
tabpage_items tabpage_items
tabpage_ib_header tabpage_ib_header
tabpage_ib_detail tabpage_ib_detail
tabpage_ib_container tabpage_ib_container
end type

on tab_main.create
this.tabpage_inventory=create tabpage_inventory
this.tabpage_inv_containers=create tabpage_inv_containers
this.tabpage_items=create tabpage_items
this.tabpage_ib_header=create tabpage_ib_header
this.tabpage_ib_detail=create tabpage_ib_detail
this.tabpage_ib_container=create tabpage_ib_container
this.Control[]={this.tabpage_inventory,&
this.tabpage_inv_containers,&
this.tabpage_items,&
this.tabpage_ib_header,&
this.tabpage_ib_detail,&
this.tabpage_ib_container}
end on

on tab_main.destroy
destroy(this.tabpage_inventory)
destroy(this.tabpage_inv_containers)
destroy(this.tabpage_items)
destroy(this.tabpage_ib_header)
destroy(this.tabpage_ib_detail)
destroy(this.tabpage_ib_container)
end on

event selectionchanged;
Choose Case newIndex
		
	Case 1 /*Inventory Tab*/
	
		idw_current = tab_main.Tabpage_inventory.dw_inventory
		
	Case 2 /*Inventory Containers Tab*/
	
		idw_current = tab_main.Tabpage_inv_containers.dw_inv_containers
		
	Case 3 /* Item Master */
		
	Case 4 /*IB Header*/
		
		idw_current = tab_main.tabpage_ib_Header.dw_ib_Header
		
	Case 5 /*IB Detail*/
		
		idw_current = tab_main.tabpage_ib_Detail.dw_ib_Detail
		
	Case 6 /*IB Container*/
		
		idw_current = tab_main.tabpage_ib_container.dw_ib_container
		
End Choose
end event

type tabpage_inventory from userobject within tab_main
integer x = 18
integer y = 112
integer width = 3136
integer height = 1680
long backcolor = 79741120
string text = "Inventory"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_inventory dw_inventory
end type

on tabpage_inventory.create
this.dw_inventory=create dw_inventory
this.Control[]={this.dw_inventory}
end on

on tabpage_inventory.destroy
destroy(this.dw_inventory)
end on

type dw_inventory from u_dw_ancestor within tabpage_inventory
event ue_saveas ( )
integer y = 8
integer width = 2930
integer height = 1592
integer taborder = 20
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
end type

event ue_saveas();
//Export Inventory data based on Project
String	lsFile, lsPath, lsRecData
Integer	liFileNo
Long	llRowPos, llRowCount

llRowCount = This.RowCount()

If llRowCount = 0 Then
	Messagebox("Export", "There are no rows to export!")
	Return
End If

If GetFileSaveName("Select Export File",lsPath,lsFile,"CSV","CSV Files (*.csv),*.csv,") <> 1 Then REturn

liFileNo = FileOpen(lsPath,LineMOde!,Write!,LockReadWrite!,Replace!)
If liFileNo < 0 Then
	Messagebox('Export','Unable to open ' + lspath + ' for exporting.')
	REturn
End If		

SetPointer(Hourglass!)

Choose Case Upper(gs_project)
		
	Case 'DIEBOLD'

		// write a header rec
		lsRecData = '"Warehouse","PO/PO Line","PO","PO Line","Receipt Date","SKU","Location","Hold Code","SO","SO Line","Container","Tag","Qty","Company"'
		FileWrite(liFileNo,lsRecData)
		
		For llRowPos = 1 to llRowCount
						
			iwWindow.SetMicroHelp("Exporting row " + String(lLRowPos) + " of " + String(llRowCount))
			
			If Not isnull(This.GetItemString(llRowPos,'warehouse')) Then
				lsRecData = '"' + This.GetItemString(llRowPos,'warehouse') + '",'
			Else
				lsRecData = ","
			End If
			
			lsRecData += '"' + This.GetItemString(llRowPos,'po_poline') + '",'
			
			lsRecData += '"' + This.GetItemString(llRowPos,'supp_invoice_no') + '",'
			
			If Not isnull(This.GetITemString(llRowPOs,'c_poline')) Then
				lsRecData += '"' + This.GetITemString(llRowPOs,'c_poline') + '",'
			Else
				lsRecData += ","
			End If
			
			If Not isnull(This.GetITemDateTime(llRowPOs,'complete_date')) Then
				lsRecData += '"' + String(This.GetITemDateTime(llRowPOs,'complete_date'),'yyyy/mm/dd hh:mm') + '",'
			Else
				lsRecData += ","
			End If
			
			lsRecData += '"' + This.GetItemString(llRowPos,'sku') + '",'
			lsRecData += '"' + This.GetItemString(llRowPos,'l_code') + '",'
			lsRecData += '"' + This.GetItemString(llRowPos,'inventory_type') + '",'
			
			If Not isnull(This.GetITemString(llRowPOs,'lot_no')) and This.GetITemString(llRowPOs,'lot_no') <> 'N/A' and This.GetITemString(llRowPOs,'lot_no') <> '-' Then
				lsRecData += '"' + This.GetITemString(llRowPOs,'lot_no') + '",'
			Else
				lsRecData += ","
			End If
			
			If Not isnull(This.GetITemString(llRowPOs,'po_no')) and This.GetITemString(llRowPOs,'po_no') <> 'N/A' and This.GetITemString(llRowPOs,'po_no') <> '-' Then
				lsRecData += '"' + This.GetITemString(llRowPOs,'po_no') + '",'
			Else
				lsRecData += ","
			End If
			
			If Not isnull(This.GetITemString(llRowPOs,'po_no2')) and This.GetITemString(llRowPOs,'po_no2') <> 'N/A' and This.GetITemString(llRowPOs,'po_no2') <> '-' Then
				lsRecData += '"' + This.GetITemString(llRowPOs,'po_no2') + '",'
				lsRecData += '"' + This.GetITemString(llRowPOs,'po_no2') + '",' /* want seperate fields for container and tag eventhough they are the same field*/
			Else
				lsRecData += ","
				lsRecData += ","
			End If
			
			lsRecData += String(This.GetITemNumber(llRowPos,'qty'),'##########0') + ","
			
			//Either Owner 132 or 100
			lsRecData += This.GetITemString(llRowPos,'c_company')
			
			
			FileWrite(liFileNo,lsRecData)
			
		Next
		
	Case 'NETAPP'

		// write a header rec
		lsRecData = '"Receipt Date","SKU","Location","SO/Line","HAT","Rev/Box Count","COO","Qty","Remarks/Import Permit"'
		FileWrite(liFileNo,lsRecData)
		
		For llRowPos = 1 to llRowCount
						
			iwWindow.SetMicroHelp("Exporting row " + String(lLRowPos) + " of " + String(llRowCount))
						
			If Not isnull(This.GetITemDateTime(llRowPOs,'complete_date')) Then
				lsRecData = '"' + String(This.GetITemDateTime(llRowPOs,'complete_date'),'yyyy/mm/dd hh:mm') + '",'
			Else
				lsRecData = ","
			End If
			
			lsRecData += '"' + This.GetItemString(llRowPos,'sku') + '",'
			lsRecData += '"' + This.GetItemString(llRowPos,'l_code') + '",'
						
			If Not isnull(This.GetITemString(llRowPOs,'lot_no'))  and This.GetITemString(llRowPOs,'lot_no') <> '-' Then
				lsRecData += '"' + This.GetITemString(llRowPOs,'lot_no') + '",'
			Else
				lsRecData += ","
			End If
			
			If Not isnull(This.GetITemString(llRowPOs,'po_no'))  and This.GetITemString(llRowPOs,'po_no') <> '-' Then
				lsRecData += '"' + This.GetITemString(llRowPOs,'po_no') + '",'
			Else
				lsRecData += ","
			End If
			
			If Not isnull(This.GetITemString(llRowPOs,'c_revision'))  and This.GetITemString(llRowPOs,'c_revision') <> '-' Then
				lsRecData += '"' + This.GetITemString(llRowPOs,'c_revision') + '",'
				
			Else
				lsRecData += ","
			End If
			
			If Not isnull(This.GetITemString(llRowPOs,'country_of_Origin'))  and This.GetITemString(llRowPOs,'country_of_Origin') <> 'XX' and This.GetITemString(llRowPOs,'country_of_Origin') <> 'XXX'Then
				lsRecData += '"' + This.GetITemString(llRowPOs,'country_of_Origin') + '",'
			Else
				lsRecData += ","
			End If
			
			lsRecData += String(This.GetITemNumber(llRowPos,'qty'),'##########0') + ","
			
			If Not isnull(This.GetITemString(llRowPOs,'remark'))  Then
				lsRecData += '"' + This.GetITemString(llRowPOs,'remark') + '"'
			Else
			//	lsRecData += ","
			End If
			
			FileWrite(liFileNo,lsRecData)
			
		Next
		
End Choose

FileClose(liFileNo)

iwWindow.SetMicroHelp("Ready")
SetPointer(Arrow!)
end event

event ue_retrieve;call super::ue_retrieve;
Long	llRowCount, llRowPos, llOWner
String	lsRONO, lsPOLine, lsSKU

//This.SetRedraw(False)


//Get the OWner ID for Company 132. On the export, if it's not 132, set to 100 - passing in as a parm for computed field compare
Select Owner_Id into :llOWner
From Owner
Where Project_id = 'DIEBOLD' and owner_type = 'C' and Owner_Cd = '132';
		
This.Retrieve(gs_project, llOwner)



iwWindow.SetMicroHelp("Ready")

//This.SetRedraw(True)
Setpointer(Arrow!)
end event

type tabpage_inv_containers from userobject within tab_main
boolean visible = false
integer x = 18
integer y = 112
integer width = 3136
integer height = 1680
long backcolor = 79741120
string text = "Inventory Containers"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_inv_containers dw_inv_containers
end type

on tabpage_inv_containers.create
this.dw_inv_containers=create dw_inv_containers
this.Control[]={this.dw_inv_containers}
end on

on tabpage_inv_containers.destroy
destroy(this.dw_inv_containers)
end on

type dw_inv_containers from u_dw_ancestor within tabpage_inv_containers
event ue_saveas ( )
integer y = 8
integer width = 3026
integer height = 1564
integer taborder = 20
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
end type

event ue_saveas();
//Export Inventory Container data based on Project
String	lsFile, lsPath, lsRecData
Integer	liFileNo
Long	llRowPos, llRowCount

llRowCount = This.RowCount()

If llRowCount = 0 Then
	Messagebox("Export", "There are no rows to export!")
	Return
End If

If GetFileSaveName("Select Export File",lsPath,lsFile,"CSV","CSV Files (*.csv),*.csv,") <> 1 Then REturn

liFileNo = FileOpen(lsPath,LineMOde!,Write!,LockReadWrite!,Replace!)
If liFileNo < 0 Then
	Messagebox('Export','Unable to open ' + lspath + ' for exporting.')
	REturn
End If		

SetPointer(Hourglass!)

Choose Case Upper(gs_project)
		
	Case 'DIEBOLD'
		
		// write a header rec
		lsRecData = '"Warehouse","Container","Location"'
		FileWrite(liFileNo,lsRecData)
		
		For llRowPos = 1 to llRowCount
			
			iwWindow.SetMicroHelp("Exporting row " + String(lLRowPos) + " of " + String(llRowCount))
			
			If Not isnull(This.GetItemString(llRowPos,'warehouse')) Then
				lsRecData = '"' + This.GetItemString(llRowPos,'warehouse') + '",'
			Else
				lsRecData = ","
			End If
			
			If Not isnull(This.GetItemString(llRowPos,'po_no2')) Then
				lsRecData += '"' + This.GetItemString(llRowPos,'po_no2') + '",'
			Else
				lsRecData += ","
			End If
			
			If Not isnull(This.GetItemString(llRowPos,'l_code')) Then
				lsRecData += '"' + This.GetItemString(llRowPos,'l_code') + '"'
			Else
	//			lsRecData += ","
			End If
			
			
			FileWrite(liFileNo,lsRecData)
			
		Next
		
End Choose

FileClose(liFileNo)

iwWindow.SetMicroHelp("Ready")
SetPointer(Arrow!)
end event

event ue_retrieve;call super::ue_retrieve;
This.Retrieve(gs_project)
end event

type tabpage_items from userobject within tab_main
boolean visible = false
integer x = 18
integer y = 112
integer width = 3136
integer height = 1680
long backcolor = 79741120
string text = "Item Master"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
end type

type tabpage_ib_header from userobject within tab_main
boolean visible = false
integer x = 18
integer y = 112
integer width = 3136
integer height = 1680
long backcolor = 79741120
string text = "Inbound Header"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_ib_header dw_ib_header
end type

on tabpage_ib_header.create
this.dw_ib_header=create dw_ib_header
this.Control[]={this.dw_ib_header}
end on

on tabpage_ib_header.destroy
destroy(this.dw_ib_header)
end on

type dw_ib_header from u_dw_ancestor within tabpage_ib_header
event ue_saveas ( )
integer y = 8
integer width = 2958
integer height = 1544
integer taborder = 20
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
end type

event ue_saveas();
//Export Inbound Order Header data based on Project
String	lsFile, lsPath, lsRecData
Integer	liFileNo
Long	llRowPos, llRowCount

llRowCount = This.RowCount()

If llRowCount = 0 Then
	Messagebox("Export", "There are no rows to export!")
	Return
End If

If GetFileSaveName("Select Export File",lsPath,lsFile,"CSV","CSV Files (*.csv),*.csv,") <> 1 Then REturn

liFileNo = FileOpen(lsPath,LineMOde!,Write!,LockReadWrite!,Replace!)
If liFileNo < 0 Then
	Messagebox('Export','Unable to open ' + lspath + ' for exporting.')
	REturn
End If		

SetPointer(Hourglass!)

Choose Case Upper(gs_project)
		
	Case 'DIEBOLD'
		
		// write a header rec
		lsRecData = '"Warehouse","PO Number","Order Type"'
		FileWrite(liFileNo,lsRecData)
		
		For llRowPos = 1 to llRowCount
			
			iwWindow.SetMicroHelp("Exporting row " + String(lLRowPos) + " of " + String(llRowCount))
			
			If Not isnull(This.GetItemString(llRowPos,'warehouse')) Then
				lsRecData = '"' + This.GetItemString(llRowPos,'warehouse') + '",'
			Else
				lsRecData = ","
			End If
			
			If Not isnull(This.GetItemString(llRowPos,'supp_invoice_No')) Then
				lsRecData += '"' + This.GetItemString(llRowPos,'supp_invoice_No') + '",'
			Else
				lsRecData += ","
			End If
			
			If Not isnull(This.GetItemString(llRowPos,'ord_type')) Then
				lsRecData += '"' + This.GetItemString(llRowPos,'ord_type') + '"'
			Else
	//			lsRecData += ","
			End If
			
			
			FileWrite(liFileNo,lsRecData)
			
		Next
		
End Choose

FileClose(liFileNo)

iwWindow.SetMicroHelp("Ready")
SetPointer(Arrow!)
end event

event ue_retrieve;call super::ue_retrieve;

This.Retrieve(gs_project)
end event

type tabpage_ib_detail from userobject within tab_main
boolean visible = false
integer x = 18
integer y = 112
integer width = 3136
integer height = 1680
long backcolor = 79741120
string text = "Inbound Detail"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_ib_detail dw_ib_detail
end type

on tabpage_ib_detail.create
this.dw_ib_detail=create dw_ib_detail
this.Control[]={this.dw_ib_detail}
end on

on tabpage_ib_detail.destroy
destroy(this.dw_ib_detail)
end on

type dw_ib_detail from u_dw_ancestor within tabpage_ib_detail
event ue_saveas ( )
integer y = 4
integer width = 2825
integer height = 1428
integer taborder = 20
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
end type

event ue_saveas();
//Export Inbound Order Header data based on Project
String	lsFile, lsPath, lsRecData
Integer	liFileNo
Long	llRowPos, llRowCount

llRowCount = This.RowCount()

If llRowCount = 0 Then
	Messagebox("Export", "There are no rows to export!")
	Return
End If

If GetFileSaveName("Select Export File",lsPath,lsFile,"CSV","CSV Files (*.csv),*.csv,") <> 1 Then REturn

liFileNo = FileOpen(lsPath,LineMOde!,Write!,LockReadWrite!,Replace!)
If liFileNo < 0 Then
	Messagebox('Export','Unable to open ' + lspath + ' for exporting.')
	REturn
End If		

SetPointer(Hourglass!)

Choose Case Upper(gs_project)
		
	Case 'DIEBOLD'
		
		// write a header rec
		lsRecData = '"Warehouse","PO Number","Order Type","SKU","SO","SO LINE","PO LINE","QTY"'
		FileWrite(liFileNo,lsRecData)
		
		For llRowPos = 1 to llRowCount
			
			iwWindow.SetMicroHelp("Exporting row " + String(lLRowPos) + " of " + String(llRowCount))
			
			If Not isnull(This.GetItemString(llRowPos,'warehouse')) Then
				lsRecData = '"' + This.GetItemString(llRowPos,'warehouse') + '",'
			Else
				lsRecData = ","
			End If
			
			If Not isnull(This.GetItemString(llRowPos,'supp_invoice_No')) Then
				lsRecData += '"' + This.GetItemString(llRowPos,'supp_invoice_No') + '",'
			Else
				lsRecData += ","
			End If
			
			If Not isnull(This.GetItemString(llRowPos,'ord_type')) Then
				lsRecData += '"' + This.GetItemString(llRowPos,'ord_type') + '",'
			Else
				lsRecData += ","
			End If
			
			If Not isnull(This.GetItemString(llRowPos,'SKU')) Then
				lsRecData += '"' + This.GetItemString(llRowPos,'SKU') + '",'
			Else
				lsRecData += ","
			End If
			
			If Not isnull(This.GetItemString(llRowPos,'user_field4')) Then
				lsRecData += '"' + This.GetItemString(llRowPos,'user_field4') + '",'
			Else
				lsRecData += ","
			End If
			
			If Not isnull(This.GetItemString(llRowPos,'user_field5')) Then
				lsRecData += '"' + This.GetItemString(llRowPos,'user_field5') + '",'
			Else
				lsRecData += ","
			End If
			
			If Not isnull(This.GetItemNumber(llRowPos,'poline')) Then
				lsRecData += '"' + String(This.GetItemNumber(llRowPos,'poline'),"######") + '",'
			Else
				lsRecData += ","
			End If
			
			If Not isnull(This.GetItemNumber(llRowPos,'qty')) Then
				lsRecData += '"' + String(This.GetItemNumber(llRowPos,'qty'),"########0") + '"'
			Else
				//lsRecData += ","
			End If
			
			FileWrite(liFileNo,lsRecData)
			
		Next
		
End Choose

FileClose(liFileNo)

iwWindow.SetMicroHelp("Ready")
SetPointer(Arrow!)
end event

event ue_retrieve;call super::ue_retrieve;
This.Retrieve(gs_project)
end event

type tabpage_ib_container from userobject within tab_main
boolean visible = false
integer x = 18
integer y = 112
integer width = 3136
integer height = 1680
long backcolor = 79741120
string text = "Inbound Container"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_ib_container dw_ib_container
end type

on tabpage_ib_container.create
this.dw_ib_container=create dw_ib_container
this.Control[]={this.dw_ib_container}
end on

on tabpage_ib_container.destroy
destroy(this.dw_ib_container)
end on

type dw_ib_container from u_dw_ancestor within tabpage_ib_container
event ue_saveas ( )
integer width = 2866
integer height = 1476
integer taborder = 20
boolean hscrollbar = true
boolean vscrollbar = true
end type

event ue_saveas();
//Export Inbound Order Header data based on Project
String	lsFile, lsPath, lsRecData
Integer	liFileNo
Long	llRowPos, llRowCount

llRowCount = This.RowCount()

If llRowCount = 0 Then
	Messagebox("Export", "There are no rows to export!")
	Return
End If

If GetFileSaveName("Select Export File",lsPath,lsFile,"CSV","CSV Files (*.csv),*.csv,") <> 1 Then REturn

liFileNo = FileOpen(lsPath,LineMOde!,Write!,LockReadWrite!,Replace!)
If liFileNo < 0 Then
	Messagebox('Export','Unable to open ' + lspath + ' for exporting.')
	REturn
End If		

SetPointer(Hourglass!)

Choose Case Upper(gs_project)
		
	Case 'DIEBOLD'
		
		// write a header rec
		lsRecData = '"Warehouse","PO Number","Order Type","PO_Line","Container","QTY"'
		FileWrite(liFileNo,lsRecData)
		
		For llRowPos = 1 to llRowCount
			
			iwWindow.SetMicroHelp("Exporting row " + String(lLRowPos) + " of " + String(llRowCount))
			
			If Not isnull(This.GetItemString(llRowPos,'warehouse')) Then
				lsRecData = '"' + This.GetItemString(llRowPos,'warehouse') + '",'
			Else
				lsRecData = ","
			End If
			
			If Not isnull(This.GetItemString(llRowPos,'supp_invoice_No')) Then
				lsRecData += '"' + This.GetItemString(llRowPos,'supp_invoice_No') + '",'
			Else
				lsRecData += ","
			End If
			
			If Not isnull(This.GetItemString(llRowPos,'ord_type')) Then
				lsRecData += '"' + This.GetItemString(llRowPos,'ord_type') + '",'
			Else
				lsRecData += ","
			End If
			
			If Not isnull(This.GetItemString(llRowPos,'user_field6')) Then
				lsRecData += '"' + This.GetItemString(llRowPos,'user_field6') + '",'
			Else
				lsRecData += ","
			End If
			
			If Not isnull(This.GetItemString(llRowPos,'po_no2')) Then
				lsRecData += '"' + This.GetItemString(llRowPos,'po_no2') + '",'
			Else
				lsRecData += ","
			End If
			
			If Not isnull(This.GetItemNumber(llRowPos,'qty')) Then
				lsRecData += '"' + String(This.GetItemNumber(llRowPos,'qty'),"########0") + '"'
			Else
				//lsRecData += ","
			End If
			
			FileWrite(liFileNo,lsRecData)
			
		Next
		
End Choose

FileClose(liFileNo)

iwWindow.SetMicroHelp("Ready")
SetPointer(Arrow!)
end event

event ue_retrieve;call super::ue_retrieve;
This.REtrieve(gs_Project)
end event

