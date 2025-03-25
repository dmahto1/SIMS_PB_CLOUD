$PBExportHeader$w_response_ancestor.srw
$PBExportComments$Ancestor window for response windows
forward
global type w_response_ancestor from window
end type
type cb_cancel from commandbutton within w_response_ancestor
end type
type cb_ok from commandbutton within w_response_ancestor
end type
end forward

global type w_response_ancestor from window
integer x = 823
integer y = 360
integer width = 2016
integer height = 1208
boolean titlebar = true
string title = "Untitled"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 79741120
event ue_close ( )
event ue_cancel ( )
event ue_retrieve ( )
event ue_postopen ( )
event ue_help ( )
event ue_preopen ( )
cb_cancel cb_cancel
cb_ok cb_ok
end type
global w_response_ancestor w_response_ancestor

type variables
str_parms	IstrParms
String	isHelpKeyword
Long	ilHelpTopicID

n_cst_winsrv		inv_base
n_cst_winsrv_preference	inv_preference
n_cst_resize		inv_resize
end variables

forward prototypes
public function integer of_setresize (boolean ab_switch)
end prototypes

event ue_close;
Close(This)
end event

event ue_cancel;
Istrparms.Cancelled = True
Close(This)
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

event open;string ls_syntax, ls_rc
int    li_rc


Integer			li_ScreenH, li_ScreenW
Environment	le_Env

// Center window
GetEnvironment(le_Env)

li_ScreenH = PixelsToUnits(le_Env.ScreenHeight, YPixelsToUnits!)
li_ScreenW = PixelsToUnits(le_Env.ScreenWidth, XPixelsToUnits!)

This.Y = (li_ScreenH - This.Height) / 2
This.X = (li_ScreenW - This.Width) / 2
//TimA 09/26/12
This.Event ue_preopen()

This.PostEvent("ue_postOpen")
end event

on w_response_ancestor.create
this.cb_cancel=create cb_cancel
this.cb_ok=create cb_ok
this.Control[]={this.cb_cancel,&
this.cb_ok}
end on

on w_response_ancestor.destroy
destroy(this.cb_cancel)
destroy(this.cb_ok)
end on

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

type cb_cancel from commandbutton within w_response_ancestor
integer x = 1029
integer y = 944
integer width = 270
integer height = 108
integer taborder = 20
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Cancel"
boolean cancel = true
end type

event clicked;parent.TriggerEvent("ue_cancel")
end event

type cb_ok from commandbutton within w_response_ancestor
integer x = 594
integer y = 944
integer width = 270
integer height = 108
integer taborder = 10
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "OK"
boolean default = true
end type

event clicked;parent.TriggerEvent("ue_close")
end event

