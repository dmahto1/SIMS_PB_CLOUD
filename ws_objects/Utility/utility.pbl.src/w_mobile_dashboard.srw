$PBExportHeader$w_mobile_dashboard.srw
$PBExportComments$Mobile Dashboard
forward
global type w_mobile_dashboard from w_std_master_detail
end type
type tabpage_picking from userobject within tab_main
end type
type dw_pick_search from datawindow within tabpage_picking
end type
type dw_picking from u_dw_ancestor within tabpage_picking
end type
type st_1 from statictext within tabpage_picking
end type
type tabpage_picking from userobject within tab_main
dw_pick_search dw_pick_search
dw_picking dw_picking
st_1 st_1
end type
type tabpage_putaway from userobject within tab_main
end type
type st_2 from statictext within tabpage_putaway
end type
type dw_putaway from datawindow within tabpage_putaway
end type
type dw_putaway_search from datawindow within tabpage_putaway
end type
type tabpage_putaway from userobject within tab_main
st_2 st_2
dw_putaway dw_putaway
dw_putaway_search dw_putaway_search
end type
end forward

global type w_mobile_dashboard from w_std_master_detail
string title = "Mobile Dashboard"
end type
global w_mobile_dashboard w_mobile_dashboard

type variables
DataWindow		idw_Pick, idw_search_pick, idw_putaway, idw_Search_Putaway
end variables

forward prototypes
public function integer wf_set_aging_colors ()
public function integer wf_set_aging_colors_putaway ()
end prototypes

public function integer wf_set_aging_colors ();

//Set the aging colors based on user settings

DateTime	ldtCurrentTime,	ldtGreen, ldtYellow, ldtRed
Long	llRowCOunt, llRowPos

idw_Search_Pick.AcceptText()

ldtCurrentTime = f_getLocalWorldTime( idw_Search_Pick.getitemstring(1,'wh_code'))

llRowCount = idw_Pick.RowCount()
For llRowPos = 1 to llRowCount
	
	If isNull(idw_Pick.GetITemDateTime(llRowPos, 'mobile_pick_Complete_Time')) Then
		
		//Order not pick complete, compare to release time
		If idw_Pick.GetITemDateTime(llRowPos, 'green_release_Time') > ldtCurrentTime Then /* Current Time < Release time + green minutes*/
			idw_pick.SetItem(llRowPos,'aging_color','green')
		End If
		
		If ldtCurrentTime > idw_Pick.GetITemDateTime(llRowPos, 'yellow_release_Time')   Then /* Current TIme > Release time + yellow minutes*/
			idw_pick.SetItem(llRowPos,'aging_color','yellow')
		End If
		
		If ldtCurrentTime > idw_Pick.GetITemDateTime(llRowPos, 'red_release_Time')   Then /* Current TIme > Release time + red minutes*/
			idw_pick.SetItem(llRowPos,'aging_color','red')
		End If
		
	Else /* picked complete, compare to pick complete time*/
		
		If idw_Pick.GetITemDateTime(llRowPos, 'green_release_Time') > idw_Pick.GetITemDateTime(llRowPos, 'mobile_pick_Complete_Time') Then /* Release + Green Minutes < Pick Complete time*/
			idw_pick.SetItem(llRowPos,'aging_color','green')
		End If
		
		If idw_Pick.GetITemDateTime(llRowPos, 'mobile_pick_Complete_Time')  > idw_Pick.GetITemDateTime(llRowPos, 'yellow_release_Time')   Then /* Release + Yellow minutes > Pick Complete time */
			idw_pick.SetItem(llRowPos,'aging_color','yellow')
		End If
		
		If idw_Pick.GetITemDateTime(llRowPos, 'mobile_pick_Complete_Time')  > idw_Pick.GetITemDateTime(llRowPos, 'red_release_Time')   Then /* Release + Red minutes > Pick Complete time */
			idw_pick.SetItem(llRowPos,'aging_color','red')
		End If
		
	End If
	
	
Next



REturn 0
end function

public function integer wf_set_aging_colors_putaway ();//18-JUNE-2018 :Madhu S20312 - Mobile Inbound Putaway
//Set the aging colors based on user settings

DateTime	ldtCurrentTime,	ldtGreen, ldtYellow, ldtRed
Long	llRowCount, llRowPos

idw_Search_Putaway.AcceptText()

ldtCurrentTime = f_getLocalWorldTime( idw_Search_Putaway.getitemstring(1,'wh_code'))

llRowCount = idw_Putaway.RowCount()
For llRowPos = 1 to llRowCount
	
	IF isNull(idw_Putaway.GetItemDateTime(llRowPos, 'Mobile_Putaway_Complete_Time')) THEN
		
		//Order not putaway complete, compare to release time
		If idw_Putaway.GetItemDateTime(llRowPos, 'green_release_Time') > ldtCurrentTime Then /* Current Time < Release time + green minutes*/
			idw_Putaway.SetItem(llRowPos,'aging_color','green')
		End If
		
		If ldtCurrentTime > idw_Putaway.GetItemDateTime(llRowPos, 'yellow_release_Time')   Then /* Current TIme > Release time + yellow minutes*/
			idw_Putaway.SetItem(llRowPos,'aging_color','yellow')
		End If
		
		If ldtCurrentTime > idw_Putaway.GetItemDateTime(llRowPos, 'red_release_Time')   Then /* Current TIme > Release time + red minutes*/
			idw_Putaway.SetItem(llRowPos,'aging_color','red')
		End If
		
	Else /* putaway complete, compare to putaway complete time*/
		
		If idw_Putaway.GetItemDateTime(llRowPos, 'green_release_Time') > idw_Putaway.GetItemDateTime(llRowPos, 'Mobile_Putaway_Complete_Time') Then /* Release + Green Minutes < putaway Complete time*/
			idw_Putaway.SetItem(llRowPos,'aging_color','green')
		End If
		
		If idw_Putaway.GetItemDateTime(llRowPos, 'Mobile_Putaway_Complete_Time')  > idw_Putaway.GetItemDateTime(llRowPos, 'yellow_release_Time')   Then /* Release + Yellow minutes > putaway Complete time */
			idw_Putaway.SetItem(llRowPos,'aging_color','yellow')
		End If
		
		If idw_Putaway.GetItemDateTime(llRowPos, 'Mobile_Putaway_Complete_Time')  > idw_Putaway.GetItemDateTime(llRowPos, 'red_release_Time')   Then /* Release + Red minutes > putaway Complete time */
			idw_Putaway.SetItem(llRowPos,'aging_color','red')
		End If
		
	END IF
	
	
Next



Return 0
end function

on w_mobile_dashboard.create
int iCurrent
call super::create
end on

on w_mobile_dashboard.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_postopen;call super::ue_postopen;
DataWindowChild ldwc_warehouse

idw_Pick = Tab_Main.tabpage_picking.dw_Picking
idw_Search_Pick = Tab_Main.tabpage_picking.dw_pick_search

//18-JUNE-2018 :Madhu S20312 - Mobile Inbound Putaway
idw_putaway = tab_main.tabpage_putaway.dw_putaway
idw_Search_Putaway = tab_main.tabpage_putaway.dw_putaway_search

im_menu.m_record.m_filter.enabled = True

idw_Search_Pick.InsertRow(0)
If gs_default_WH > '' Then
	idw_Search_Pick.SetItem(1,'wh_code',gs_default_WH) 
End IF

idw_Search_Pick.GetChild("wh_code", ldwc_warehouse)
ldwc_warehouse.SetTransObject(sqlca)
g.of_set_warehouse_dropdown(ldwc_warehouse)

tab_Main.SetFocus()
tab_main.SelectTab('tabpage_Picking') 

if idw_Search_Pick.getItemString(1,'wh_code') > '' Then
	idw_Pick.TriggerEvent('ue_Retrieve')
End If

//18-JUNE-2018 :Madhu S20312 - Mobile Inbound Putaway - START
idw_Search_Putaway.InsertRow(0)
If gs_default_WH > '' Then
	idw_Search_Putaway.SetItem(1,'wh_code',gs_default_WH) 
End IF

idw_Search_Putaway.GetChild("wh_code", ldwc_warehouse)
ldwc_warehouse.SetTransObject(sqlca)
g.of_set_warehouse_dropdown(ldwc_warehouse)

idw_putaway.settransobject( SQLCA)

if idw_Search_Putaway.getItemString(1,'wh_code') > '' Then
	idw_putaway.TriggerEvent('ue_Retrieve')
End If

//18-JUNE-2018 :Madhu S20312 - Mobile Inbound Putaway  - END
end event

event resize;call super::resize;tab_main.Resize(workspacewidth(),workspaceHeight())

tab_main.tabpage_picking.dw_picking.Resize(workspacewidth() - 80,workspaceHeight()-450)
tab_main.tabpage_putaway.dw_putaway.Resize(workspacewidth() - 80,workspaceHeight()-450) //18-JUNE-2018 :Madhu S20312 - Mobile Inbound Putaway
end event

event ue_retrieve;call super::ue_retrieve;
If isvalid(idw_Current) Then
	idw_Current.TriggerEvent('ue_Retrieve')
End If
end event

event open;call super::open;im_menu = this.menuid
end event

type tab_main from w_std_master_detail`tab_main within w_mobile_dashboard
tabpage_picking tabpage_picking
tabpage_putaway tabpage_putaway
end type

on tab_main.create
this.tabpage_picking=create tabpage_picking
this.tabpage_putaway=create tabpage_putaway
call super::create
this.Control[]={this.tabpage_main,&
this.tabpage_search,&
this.tabpage_picking,&
this.tabpage_putaway}
end on

on tab_main.destroy
call super::destroy
destroy(this.tabpage_picking)
destroy(this.tabpage_putaway)
end on

event tab_main::selectionchanged;call super::selectionchanged;Choose Case newIndex
		
	Case 3 /*Pick Tab*/
		
		idw_current = idw_Pick
		
	Case 4 /*Putaway Tab */
		
		idw_current = idw_putaway
		
End Choose
end event

type tabpage_main from w_std_master_detail`tabpage_main within tab_main
boolean visible = false
boolean enabled = false
string text = ""
end type

type tabpage_search from w_std_master_detail`tabpage_search within tab_main
boolean visible = false
boolean enabled = false
end type

type tabpage_picking from userobject within tab_main
integer x = 18
integer y = 112
integer width = 3913
integer height = 1680
long backcolor = 79741120
string text = "Picking"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_pick_search dw_pick_search
dw_picking dw_picking
st_1 st_1
end type

on tabpage_picking.create
this.dw_pick_search=create dw_pick_search
this.dw_picking=create dw_picking
this.st_1=create st_1
this.Control[]={this.dw_pick_search,&
this.dw_picking,&
this.st_1}
end on

on tabpage_picking.destroy
destroy(this.dw_pick_search)
destroy(this.dw_picking)
destroy(this.st_1)
end on

type dw_pick_search from datawindow within tabpage_picking
integer x = 9
integer y = 28
integer width = 3739
integer height = 204
integer taborder = 20
string title = "none"
string dataobject = "d_mobile_dashboard_search_pick"
boolean border = false
boolean livescroll = true
end type

event itemchanged;
If dwo.name = 'green' Then
	This.SetItem(1,'yellow',long(data))
	
	If This.GetITemNumber(1,'red') < long(data) Then
		This.SetItem(1,'red',long(data))
	End If
	
elseIf dwo.name = 'yellow' Then
	
	This.SetItem(1,'green',long(data))
	
	If This.GetITemNumber(1,'red') < long(data) Then
		This.SetItem(1,'red',long(data))
	End If
	
End If
end event

type dw_picking from u_dw_ancestor within tabpage_picking
integer x = 27
integer y = 300
integer width = 3730
integer height = 1412
integer taborder = 20
string dataobject = "d_mobile_dashboard_picking"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event clicked;call super::clicked;IF row > 0 THEN
	This.SelectRow(0, FALSE)
	This.SelectRow(row, TRUE)
End If
end event

event doubleclicked;call super::doubleclicked;
Str_parms	lStrparms

If f_check_access ("W_DOR","") = 1 and row > 0 Then
	lStrparms.String_arg[1] = "W_DOR"
	lStrparms.String_arg[2] =  '*DONO*' +  this.GetItemString(row, 'do_no')
	OpenSheetwithparm(w_do,lStrparms, w_main, gi_menu_pos, Original!)
End If
end event

event ue_retrieve;call super::ue_retrieve;
String	lsWarehouse, lsUpdate
Date	ldtToday
Int		liGreen, liYellow, liRed


lsWarehouse = idw_Search_Pick.GetITemString(1,'wh_code')
ldtToday = Date(f_getLocalWorldTime( lsWarehouse ) )

liGreen = idw_Search_Pick.GetITemNumber(1,'green')
liYellow = idw_Search_Pick.GetITemNumber(1,'yellow')
lired = idw_Search_Pick.GetITemNumber(1,'red')

//can only update priority and other settings if operator has access to save 
If f_check_access(is_process,"S") = 0 Then 
	lsUpdate = "N"
Else
	lsUpdate = "Y"
End If

If lsWarehouse > '' Then
	This.Retrieve(gs_project,lsWarehouse,ldtToday,liGreen, liYellow, liRed,lsUpdate)
Else
	messageBox("Dashboard","Please select a warehouse")
End If

wf_set_Aging_colors()
end event

event itemchanged;call super::itemchanged;
String		lsDONO
Dec		ldQty

lsDONO = This.GetITemString(row,'do_no')

//WIll update on the fly...
Choose Case Upper(dwo.Name)
		
	Case "PRIORITY"
		
		If data = "" or isnull(data) Then
			
			setNull(ldQty)
			
		ElseIf  isNumber(data) Then
			
			ldQty = Dec(data)
			
		Else
			
			Return
			
		End IF
		
		Execute Immediate "Begin Transaction" using SQLCA;
		
		Update Delivery_MAster
		Set Priority = :ldQty
		Where do_no = :lsDONO;
		
		Execute Immediate "Commit" using SQLCA;
		
	Case "MOBILE_USER_ASSIGNED"
		
		Execute Immediate "Begin Transaction" using SQLCA;
		
		Update Delivery_MAster
		Set Mobile_User_Assigned = :data
		Where do_no = :lsDONO;
		
		Execute Immediate "Commit" using SQLCA;
		
	Case "MOBILE_PACK_LOCATION"
		
		Execute Immediate "Begin Transaction" using SQLCA;
		
		Update Delivery_MAster
		Set Mobile_Pack_Location = :data
		Where do_no = :lsDONO;
		
		Execute Immediate "Commit" using SQLCA;
		
End Choose
end event

type st_1 from statictext within tabpage_picking
integer x = 27
integer y = 224
integer width = 681
integer height = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = "Double click order to edit"
boolean focusrectangle = false
end type

type tabpage_putaway from userobject within tab_main
integer x = 18
integer y = 112
integer width = 3913
integer height = 1680
long backcolor = 79741120
string text = "Putaway"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
st_2 st_2
dw_putaway dw_putaway
dw_putaway_search dw_putaway_search
end type

on tabpage_putaway.create
this.st_2=create st_2
this.dw_putaway=create dw_putaway
this.dw_putaway_search=create dw_putaway_search
this.Control[]={this.st_2,&
this.dw_putaway,&
this.dw_putaway_search}
end on

on tabpage_putaway.destroy
destroy(this.st_2)
destroy(this.dw_putaway)
destroy(this.dw_putaway_search)
end on

type st_2 from statictext within tabpage_putaway
integer x = 27
integer y = 224
integer width = 681
integer height = 60
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = "Double click order to edit"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_putaway from datawindow within tabpage_putaway
event ue_retrieve ( )
integer x = 27
integer y = 300
integer width = 3730
integer height = 1412
integer taborder = 30
string dataobject = "d_mobile_dashboard_putaway"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
end type

event ue_retrieve();//18-JUNE-2018 :Madhu S20312 - Mobile Inbound Putaway

String	lsWarehouse, lsUpdate
Date	ldtToday
Int		liGreen, liYellow, liRed


lsWarehouse = idw_Search_Putaway.GetItemString(1,'wh_code')
ldtToday = Date(f_getLocalWorldTime( lsWarehouse ) )

liGreen = idw_Search_Putaway.GetItemNumber(1,'green')
liYellow = idw_Search_Putaway.GetItemNumber(1,'yellow')
lired = idw_Search_Putaway.GetItemNumber(1,'red')

//can only update priority and other settings if operator has access to save 
If f_check_access(is_process,"S") = 0 Then 
	lsUpdate = "N"
Else
	lsUpdate = "Y"
End If

If lsWarehouse > '' Then
	This.Retrieve(gs_project,lsWarehouse,ldtToday,liGreen, liYellow, liRed,lsUpdate)
Else
	messageBox("Dashboard","Please select a warehouse")
End If

wf_set_aging_colors_putaway()
end event

event clicked;//18-JUNE-2018 :Madhu S20312 - Mobile Inbound Putaway

IF row > 0 THEN
	This.SelectRow(0, FALSE)
	This.SelectRow(row, TRUE)
End If
end event

event doubleclicked;//18-JUNE-2018 :Madhu S20312 - Mobile Inbound Putaway

Str_parms	lStrparms

If f_check_access ("W_RO","") = 1 and row > 0 Then
	lStrparms.String_arg[1] = "W_RO"
	lStrparms.String_arg[2] =  '*RONO*' +  this.GetItemString(row, 'ro_no')
	OpenSheetwithparm(w_ro,lStrparms, w_main, gi_menu_pos, Original!)
End If
end event

event itemchanged;//18-JUNE-2018 :Madhu S20312 - Mobile Inbound Putaway

String		lsRONO
Dec		ldQty

lsRONO = This.GetITemString(row,'ro_no')

//WIll update on the fly...
Choose Case Upper(dwo.Name)
		
	Case "PRIORITY"
		
		If data = "" or isnull(data) Then
			
			setNull(ldQty)
			
		ElseIf  isNumber(data) Then
			
			ldQty = Dec(data)
			
		Else
			
			Return
			
		End IF
		
		Execute Immediate "Begin Transaction" using SQLCA;
		
		Update Receive_Master
		Set Priority = :ldQty
		Where ro_no = :lsRONO;
		
		Execute Immediate "Commit" using SQLCA;
		
	Case "MOBILE_USER_ASSIGNED"
		
		Execute Immediate "Begin Transaction" using SQLCA;
		
		Update Receive_Master
		Set Mobile_User_Assigned = :data
		Where ro_no = :lsRONO;
		
		Execute Immediate "Commit" using SQLCA;
		
	Case "MOBILE_STAGING_LOCATION"
		
		Execute Immediate "Begin Transaction" using SQLCA;
		
		Update Receive_Master
		Set Mobile_Staging_Location = :data
		Where ro_no = :lsRONO;
		
		Execute Immediate "Commit" using SQLCA;
		
End Choose
end event

type dw_putaway_search from datawindow within tabpage_putaway
integer x = 9
integer y = 28
integer width = 3739
integer height = 204
integer taborder = 30
string title = "none"
string dataobject = "d_mobile_dashboard_search_putaway"
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event itemchanged;
If dwo.name = 'green' Then
	This.SetItem(1,'yellow',long(data))
	
	If This.GetITemNumber(1,'red') < long(data) Then
		This.SetItem(1,'red',long(data))
	End If
	
elseIf dwo.name = 'yellow' Then
	
	This.SetItem(1,'green',long(data))
	
	If This.GetITemNumber(1,'red') < long(data) Then
		This.SetItem(1,'red',long(data))
	End If
	
End If
end event

