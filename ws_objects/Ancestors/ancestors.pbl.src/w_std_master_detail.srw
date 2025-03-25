$PBExportHeader$w_std_master_detail.srw
$PBExportComments$Standard obejct for master detail windows
forward
global type w_std_master_detail from window
end type
type tab_main from tab within w_std_master_detail
end type
type tabpage_main from userobject within tab_main
end type
type tabpage_main from userobject within tab_main
end type
type tabpage_search from userobject within tab_main
end type
type tabpage_search from userobject within tab_main
end type
type tab_main from tab within w_std_master_detail
tabpage_main tabpage_main
tabpage_search tabpage_search
end type
end forward

global type w_std_master_detail from window
integer x = 9
integer y = 4
integer width = 4087
integer height = 2036
boolean titlebar = true
string title = "Delivery Order"
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
event type long ue_find ( )
event ue_unlock ( )
event ue_preopen ( )
tab_main tab_main
end type
global w_std_master_detail w_std_master_detail

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
Long	il_method_trans_id


Public:
// - Common return value constants:
constant integer 		SUCCESS = 1
constant integer 		FAILURE = -1
constant integer 		NO_ACTION = 0
// - Continue/Prevent return value constants:
constant integer 		CONTINUE_ACTION = 1
constant integer 		PREVENT_ACTION = 0
//constant integer 		FAILURE = -1

n_cst_winsrv		inv_base
n_cst_winsrv_preference	inv_preference
n_cst_resize		inv_resize

Protected:
any			ia_helptypeid
//u_dw			idw_active

// Logical Unit of Work -  SelfUpdatingObject - Save Process - (Attributes).
boolean			ib_isupdateable = True
boolean			ib_disableclosequery
boolean			ib_alwaysvalidate	// Save process flag to include all objects in validation process.
boolean			ib_closestatus
boolean			ib_savestatus
string			is_dberrormsg  	// Obsoleted in 6.0.
//n_cst_dberrorattrib 		inv_dberrorattrib  	// Replaces Obsoleted is_dberrormsg.
powerobject		ipo_updaterequestor
powerobject		ipo_pendingupdates[]
powerobject		ipo_updateobjects[]
powerobject		ipo_tempupdateobjects[]
//n_cst_luw		inv_luw

//TimA 11/05/12
String isFileName
end variables

forward prototypes
public function integer wf_save_changes ()
public subroutine wf_check_menu (boolean ab_value, string as_option)
public function integer of_setresize (boolean ab_switch)
end prototypes

event ue_delete;// Acess Rights
//If f_check_access(is_process,"D") = 0 Then Return

// Looking for unsaved changes
If wf_save_changes() = 0 Then Return	

end event

event ue_close;Close(This)
end event

event ue_retrieve;If wf_save_changes() = -1 Then Return

end event

event ue_postopen;//Posted event from Open Event - Speeds opening processing
end event

event ue_accept_text;IF ISValid(idw_current) THEN idw_current.AcceptText() 
end event

event ue_file;String	lsAction
//Triggered from Menu

lsAction = Message.StringParm

Choose CAse Upper(lsACtion)
		
	Case 'SAVEAS' /*export*/
		
		If isvalid(idw_current) Then
			idw_Current.SaveAs()
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

event type long ue_find();
//This Event displays Find box and searches for the desired column.
long ll_ret
String str_null
SetNull(str_null)
IF isvalid(idw_current) THEN
	
	OpenWithParm (w_find, idw_current)
	
//	ll_ret=idw_current.Setsort(str_null)
//	ll_ret=idw_current.Sort()
	if isnull(ll_ret) then ll_ret=0
END IF	
return ll_ret
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
	CASE 'find'
		im_menu.m_file.m_find.Enabled = ab_value
END CHOOSE



end subroutine

public function integer of_setresize (boolean ab_switch);//////////////////////////////////////////////////////////////////////////////
//	Public Function:  of_SetResize
//	Arguments:		ab_switch   starts/stops the window resize service
//	Returns:			Integer 		1 = success,  0 = no action necessary, -1 error
//	Description:		Starts or stops the window resize service
//////////////////////////////////////////////////////////////////////////////
//	Rev. History:	Version
//						5.0   Initial version
//						8.0   Modified to initially set window dimensions based on the class definition
//////////////////////////////////////////////////////////////////////////////
//	Copyright © 1996-2001 Sybase, Inc. and its subsidiaries.  All rights reserved.  Any distribution of the 
// PowerBuilder Foundation Classes (PFC) source code by other than Sybase, Inc. and its subsidiaries is prohibited.
//////////////////////////////////////////////////////////////////////////////
integer	li_rc, li_v, li_vars
integer li_origwidth, li_origheight

// Check arguments
if IsNull (ab_switch) then
	return -1
end if

if ab_Switch then
	if IsNull(inv_resize) Or not IsValid (inv_resize) then
		inv_resize = create n_cst_resize
		
		/*  Get this window's class definition and extract the width and height  */
		classdefinition lcd_class
		lcd_class = this.ClassDefinition
		
		li_vars = UpperBound ( lcd_class.VariableList )
		For li_v = 1 to li_vars
			If lcd_class.VariableList[li_v].Name = "width" Then li_origwidth = Integer ( lcd_class.VariableList[li_v].InitialValue ) 
			If lcd_class.VariableList[li_v].Name = "height" Then li_origheight = Integer ( lcd_class.VariableList[li_v].InitialValue ) 
			If li_origwidth > 0 And li_origheight > 0 Then Exit
		Next
		inv_resize.of_SetOrigSize ( li_origwidth, li_origheight )
		li_rc = 1
	end if
else
	if IsValid (inv_resize) then
		destroy inv_resize
		li_rc = 1
	end if
end If

return li_rc
end function

on w_std_master_detail.create
if this.MenuName = "m_simple_edit" then this.MenuID = create m_simple_edit
this.tab_main=create tab_main
this.Control[]={this.tab_main}
end on

on w_std_master_detail.destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.tab_main)
end on

event open;SetPointer(HourGlass!)
This.move(0,0)

im_menu = This.MenuId
is_title = This.Title


//05/01 PCONKL - Allow for multiple parms to be passed in

//is_process = Message.StringParm
Istrparms = message.PowerObjectParm
is_process = Istrparms.String_arg[1]

ib_changed = False

// cawikholm - 07/05/11 Added tracking of User
SetNull( il_method_trans_id )
//f_method_trace( il_method_trans_id, this.ClassName(), 'Window Opened' ) //08-Feb-2013  :Madhu commented
f_method_trace_special( gs_project,this.ClassName() + ' - open','Window Opened ',' ',' ',' ' ,' ') //08-Feb-2013  :Madhu added

//TimA 05/22/12
This.Event ue_preopen()

// 05/00 PCONKL - move most open processing to posted event ue_postopen - will speed open processing
This.PostEvent("ue_postOpen")
end event

event closequery;
IF IsValid(w_find) THEN
	
	Close(w_find)
	
END IF

If wf_save_changes() = -1 Then
	Return 1
Else
	Return 0
End If
end event

event deactivate;//g.POST of_setmenu(TRUE)
end event

event close;
//f_method_trace( il_method_trans_id, this.ClassName(), 'Window Closed' ) //08-Feb-2013  :Madhu commented
f_method_trace_special( gs_project,this.ClassName() + ' - close','Window Closed ',' ',' ',' ' ,' ') //08-Feb-2013  :Madhu added
end event

event resize;//////////////////////////////////////////////////////////////////////////////
//
//	Event:  resize
//
//	Description:
//	Send resize notification to services
//
//////////////////////////////////////////////////////////////////////////////
//	
//	Revision History
//
//	Version
//	5.0   Initial version
//	7.0   Change to not resize when window is being restored from a minimized state
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright © 1996-1997 Sybase, Inc. and its subsidiaries.  All rights reserved.
//	Any distribution of the PowerBuilder Foundation Classes (PFC)
//	source code by other than Sybase, Inc. and its subsidiaries is prohibited.
//
//////////////////////////////////////////////////////////////////////////////

// Notify the resize service that the window size has changed.
If IsValid (inv_resize) and This.windowstate <> minimized! Then
	inv_resize.Event Resize (sizetype, This.WorkSpaceWidth(), This.WorkSpaceHeight())
End If

// Store the position and size on the preference service.
// With this information the service knows the normal size of the 
// window even when the window is closed as maximized/minimized.	

If IsValid (inv_preference) And This.windowstate = normal! Then
	inv_preference.Post of_SetPosSize()
End If
end event

type tab_main from tab within w_std_master_detail
integer x = 27
integer y = 20
integer width = 3950
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
tabpage_main tabpage_main
tabpage_search tabpage_search
end type

on tab_main.create
this.tabpage_main=create tabpage_main
this.tabpage_search=create tabpage_search
this.Control[]={this.tabpage_main,&
this.tabpage_search}
end on

on tab_main.destroy
destroy(this.tabpage_main)
destroy(this.tabpage_search)
end on

type tabpage_main from userobject within tab_main
integer x = 18
integer y = 112
integer width = 3913
integer height = 1680
long backcolor = 79741120
string text = " Master "
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
end type

type tabpage_search from userobject within tab_main
integer x = 18
integer y = 112
integer width = 3913
integer height = 1680
long backcolor = 79741120
string text = " Search "
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
end type

