$PBExportHeader$w_sims_banner.srw
forward
global type w_sims_banner from window
end type
type dw_1 from datawindow within w_sims_banner
end type
end forward

global type w_sims_banner from window
string tag = "Sims Banner"
integer width = 7643
integer height = 4440
boolean enabled = false
string menuname = "m_main"
boolean border = false
windowtype windowtype = popup!
windowstate windowstate = maximized!
long backcolor = 268435456
string icon = "AppIcon!"
event ue_postopen ( )
event ue_dbdisplay ( )
dw_1 dw_1
end type
global w_sims_banner w_sims_banner

type variables
long il_prev_width = 0 ,il_prev_height = 0
m_main im_menu
n_cst_resize		inv_resize
n_cst_winsrv_preference	inv_preference
end variables

forward prototypes
public subroutine wf_resize ()
end prototypes

event ue_dbdisplay();//05-Oct-2016 :Madhu- Added "HIP Database Names".

This.title = 'SIMS Banner'
Long ll_text_color,ll_row
String ls_db,ls_dbname,ls_tit,ls_msg,ls_proj,ls_displaytill,lstemp
date ld_displaytill
ls_db = Upper(sqlca.database)

Choose case ls_db
	Case 'SIMSPANPRD'		
		ls_dbname ='Pandora-Prod'
		ll_text_color =  rgb(0,128,0)
	Case 'SIMS33PRD'
		ls_dbname = 'Production'
		ll_text_color =  rgb(0,255,0)		
	Case 'SIMS33TEST'
		ls_dbname = 'Test'
		ll_text_color =  rgb(255,0,0)		
	Case 'SIMS33PAN'
		ls_dbname = 'QA'
		ll_text_color =  rgb(255,255,0)	
	Case 'SIMS_DEV'
		ls_dbname ='HIPDEV'
		ll_text_color =  rgb(255,0,0)
	Case 'SIMS_QA'
		ls_dbname = 'HIPQA'
		ll_text_color =  rgb(255,255,0)	
	Case 'SIMS_QA_PAN'
		ls_dbname = 'HIPQAPAN'
		ll_text_color =  rgb(255,255,0)	
	Case 'SIMS_PRD_PAN'		
		ls_dbname ='HIPPANPRD'
		ll_text_color =  rgb(0,128,0)
	Case 'SIMS_PRD'
		ls_dbname = 'HIPPRD'
		ll_text_color =  rgb(0,255,0)		
		
End choose		

dw_1.object.msgtitle.visible = 0
dw_1.object.simsmsg.visible = 0

Select Code_Descript,project_id,User_Field1
into :ls_tit,:ls_proj,:ls_displaytill
from Lookup_Table
where Code_TYPE =  'SIMSBANNER'
AND Code_Id = 'MessageHeader';

Select Code_Descript into :ls_msg
from Lookup_Table
where Code_TYPE =  'SIMSBANNER'
AND Code_Id = 'MessageDetail';

ld_displaytill = date(ls_displaytill)

ll_row = dw_1.insertrow(0)
dw_1.object.t_db.text =ls_dbname
dw_1.setitem(ll_row,'simsusr', gs_userid)

dw_1.setitem(ll_row,'msgtitle',ls_tit)
dw_1.setitem(ll_row,'simsmsg', ls_msg)

if ls_proj = '*ALL'  and ld_displaytill >= today() then
	if len (ls_tit) > 5 	then 	  dw_1.object.msgtitle.visible = 1
	if len (ls_msg) > 5 then dw_1.object.simsmsg.visible = 1
end if

dw_1.Object.t_db.Color = string(ll_text_color)

w_sims_banner.postEvent ('ue_resize')

im_menu.m_outbound.triggerevent(clicked!)	
im_menu.m_inbound.triggerevent(clicked!)	
im_menu.m_reports.triggerevent(clicked!)	
im_menu.m_utilities.triggerevent(clicked!)	
im_menu.m_inventorymgmt.triggerevent(clicked!)
end event

public subroutine wf_resize ();width = w_main.width
height = w_main.height
dw_1.width = width /1
dw_1.height = height / 1.025
w_sims_banner.dw_1.Object.t_db.Width = dw_1.width  - 200
w_sims_banner.dw_1.Object.simsusr.Width = dw_1.width  - 200
w_sims_banner.dw_1.Object.msgtitle.Width = dw_1.width  - 200
w_sims_banner.dw_1.Object.simsmsg.Width = dw_1.width  - 200


end subroutine

on w_sims_banner.create
if this.MenuName = "m_main" then this.MenuID = create m_main
this.dw_1=create dw_1
this.Control[]={this.dw_1}
end on

on w_sims_banner.destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
end on

event open;im_menu = this.menuid
Post Event ue_dbdisplay()

timer( gi_time_interval) //07-Apr-2015 Madhu SIMS Timer Notification Alert Functionality
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

wf_resize()
//st_1.text = 'width : '+ string(width)  + ' height : ' + string(height) + '  par width : ' + string(w_main.width) + '  par heig ' + string(w_main.height)
//dw_1.y = height / 1.

//
//String ls_fontsize
//Long ll_fontsize,ll_width,ll_height
//ll_width =  w_main.width
//ll_height = w_main.height
//
//if isvalid (w_sims_banner) then
//		w_sims_banner.width = w_main.width
//		w_sims_banner.height = w_main.height
////		w_sims_banner.dw_1.Y = (this.height) - (w_sims_banner.dw_1.height)	
//		w_sims_banner.dw_1.Object.t_db.Width = w_main.width 
//		dw_1.height = w_main.height 
//		
///*		
//		if il_prev_height <>  ll_height and il_prev_width <> ll_width and il_prev_width > 0 and il_prev_height > 0  then
//			ls_fontsize = w_sims_banner.dw_1.Object.t_db.Font.Height
//			ll_fontsize = abs(long((ls_fontsize)) * (abs(ll_width - il_prev_width) * 100 )/il_prev_width) /100 
//			ls_fontsize = '-' + string(ll_fontsize)
//			w_sims_banner.dw_1.Object.t_db.Font.Height = ls_fontsize
//		end if
//		
//		il_prev_width =  w_main.width
//		il_prev_height = w_main.height
//	*/	
//end if
//
end event

event deactivate;wf_resize()
end event

event activate;wf_resize()

end event

event timer;//07-Apr-2015 Madhu- SIMS Timer Notification Alert Functionality
//Don't send msg alert to Developer.

integer li_time_interval
string ls_sql_syntax
////Re-trieve values from DB
//SELECT Project_Id,User_Id,Notification_Flag,Shutdown_Flag,Notes,Time_Interval 
//	into :gs_Projectlist,:gs_Userlist,:gs_NotificationFlag,:gs_ShutdownFlag,:gs_AlertNotes,:li_time_interval 
//FROM SIMS_Notification with(nolock);  // commented this line - Dinesh -05/31/2024-  SIMS-473-Google - SIMS – SIMS Timer Enhancement
//
long ll_count,i,j
datastore lds_sims_notification,lds_sims_notification_filter
//SELECT Project_Id,User_Id,Notification_Flag,Shutdown_Flag,Notes,Time_Interval ,login
//into :gs_Projectlist,:gs_Userlist,:gs_NotificationFlag,:gs_ShutdownFlag,:gs_AlertNotes,:li_time_interval,:gs_login
//FROM SIMS_Notification_user with(nolock); // Dinesh -05/31/2024-  SIMS-473-Google - SIMS – SIMS Timer Enhancement
//Begin -Dinesh -05/31/2024-  SIMS-473-Google - SIMS – SIMS Timer Enhancement
lds_sims_notification = create datastore 
lds_sims_notification_filter = create datastore
//connect using sqlca;
long ll_count_all
lds_sims_notification.dataobject='d_sims_notification_search_all'
lds_sims_notification.settrans(sqlca)
lds_sims_notification.retrieve()

ls_sql_syntax= lds_sims_notification.getsqlselect()
lds_sims_notification.setsqlselect(ls_sql_syntax)
lds_sims_notification.retrieve()
ll_count_all= lds_sims_notification.rowcount()
	for j=1 to ll_count_all
		gs_Projectlist= lds_sims_notification.getitemstring(j,'Project_Id')
		gs_Userlist= lds_sims_notification.getitemstring(j,'User_Id')
		gs_NotificationFlag= lds_sims_notification.getitemstring(j,'Notification_Flag')
		gs_ShutdownFlag= lds_sims_notification.getitemstring(j,'Shutdown_Flag')
		gs_AlertNotes= lds_sims_notification.getitemstring(j,'Notes')
		gi_time_interval= lds_sims_notification.getitemnumber(j,'Time_Interval')
		gs_login= lds_sims_notification.getitemstring(j,'login')
		gs_Projectlist= lds_sims_notification.getitemstring(j,'Project_Id')
		gs_Userlist= lds_sims_notification.getitemstring(j,'User_Id')
		gs_NotificationFlag= lds_sims_notification.getitemstring(j,'Notification_Flag')
		gs_ShutdownFlag= lds_sims_notification.getitemstring(j,'Shutdown_Flag')
		gs_AlertNotes= lds_sims_notification.getitemstring(j,'Notes')
		gi_time_interval= lds_sims_notification.getitemnumber(j,'Time_Interval')
		gs_login= lds_sims_notification.getitemstring(j,'login')
if gs_Userlist <> '*ALL' and gs_projectlist = '*ALL' then
	lds_sims_notification_filter.dataobject='d_sims_notification_search_all'
		lds_sims_notification_filter.settrans(sqlca)
		lds_sims_notification_filter.retrieve()
		lds_sims_notification_filter.SetFilter("user_id = '"+ gs_Userlist +"'")
		lds_sims_notification_filter.filter()
end if
if gs_Userlist='*ALL' and gs_projectlist <> '*ALL' then
	lds_sims_notification_filter.dataobject='d_sims_notification_search_all'
	lds_sims_notification_filter.settrans(sqlca)
	lds_sims_notification_filter.retrieve()
	lds_sims_notification_filter.SetFilter("project_id = '"+ gs_Projectlist +"'")
	lds_sims_notification_filter.filter()
end if
if gs_Userlist<> '*ALL' and gs_projectlist <> '*ALL' then
	lds_sims_notification_filter.dataobject='d_sims_notification_search_all'
	lds_sims_notification_filter.settrans(sqlca)
	lds_sims_notification_filter.retrieve()
	lds_sims_notification_filter.SetFilter("project_id = '"+ gs_Projectlist +"' and user_id = '"+ gs_Userlist +"'")
	lds_sims_notification_filter.filter()
	//lds_sims_notification_filter.setfilter(project_id= )
end if
lds_sims_notification_filter.retrieve()
ll_count= lds_sims_notification_filter.rowcount()
// End- Dinesh -06/05/2024-  SIMS-473-Google - SIMS – SIMS Timer Enhancement
for i =1 to ll_count
	gs_Projectlist= lds_sims_notification_filter.getitemstring(i,'Project_Id')
	gs_Userlist= lds_sims_notification_filter.getitemstring(i,'User_Id')
	gs_NotificationFlag= lds_sims_notification_filter.getitemstring(i,'Notification_Flag')
	gs_ShutdownFlag= lds_sims_notification_filter.getitemstring(i,'Shutdown_Flag')
	gs_AlertNotes= lds_sims_notification_filter.getitemstring(i,'Notes')
	li_time_interval= lds_sims_notification_filter.getitemnumber(i,'Time_Interval')
	gs_login= lds_sims_notification_filter.getitemstring(i,'login')

//SELECT Project_Id,User_Id,Notification_Flag,Shutdown_Flag,Notes,Time_Interval ,login
//	into :gs_Projectlist,:gs_Userlist,:gs_NotificationFlag,:gs_ShutdownFlag,:gs_AlertNotes,:li_time_interval,:gs_login
//FROM SIMS_Notification_user with(nolock); // Dinesh -05/31/2024-  SIMS-473-Google - SIMS – SIMS Timer Enhancement
	//Dinesh -06/11/2024 - SIMS-473- Google - SIMS – SIMS Timer Enhancement
  if gs_projectlist ='PANDORA'  and (upper(gs_Userlist)= upper(gs_userid)) then
			//If Interval is changed, re-call timer 
		IF li_time_interval <> gi_time_interval THEN
			gi_time_interval = li_time_interval
			timer(gi_time_interval)
		ELSE
			//IF gs_role <> '-1' THEN // Dinesh -05/31/2024-  SIMS-473-Google - SIMS – SIMS Timer Enhancement
				 
					g.of_sims_notification( gi_time_interval)
				
			
		END IF
		exit;
end if
IF gs_projectlist <> '*ALL' and gs_Userlist <>'*ALL' then
	if (upper(gs_Userlist)= upper(gs_userid)) and (upper(gs_projectlist)=upper(gs_project)) then
			//If Interval is changed, re-call timer 
		IF li_time_interval <> gi_time_interval THEN
			gi_time_interval = li_time_interval
			timer(gi_time_interval)
		ELSE
			//IF gs_role <> '-1' THEN // Dinesh -05/31/2024-  SIMS-473-Google - SIMS – SIMS Timer Enhancement
				 
					g.of_sims_notification( gi_time_interval)
				
			
		END IF
		exit;
	end if
End if
if upper(gs_projectlist)  = '*ALL' and gs_Userlist = '*ALL' then
	//If Interval is changed, re-call timer 
		IF li_time_interval <> gi_time_interval THEN
			gi_time_interval = li_time_interval
			timer(gi_time_interval)
		ELSE
			//IF gs_role <> '-1' THEN // Dinesh -05/31/2024-  SIMS-473-Google - SIMS – SIMS Timer Enhancement
				 
					g.of_sims_notification( gi_time_interval)
				
			
		END IF
		exit;
end if
if upper(gs_projectlist)  = '*ALL' and (UPPER(gs_Userlist) = UPPER(gs_userid)) then
	//If Interval is changed, re-call timer 
		IF li_time_interval <> gi_time_interval THEN
			gi_time_interval = li_time_interval
			timer(gi_time_interval)
		ELSE
			//IF gs_role <> '-1' THEN // Dinesh -05/31/2024-  SIMS-473-Google - SIMS – SIMS Timer Enhancement
				 
					g.of_sims_notification( gi_time_interval)
				
			
		END IF
		exit;
end if
if upper(gs_projectlist)  = upper(gs_project) and (UPPER(gs_Userlist) = '*ALL') then
	//If Interval is changed, re-call timer 
		IF li_time_interval <> gi_time_interval THEN
			gi_time_interval = li_time_interval
			timer(gi_time_interval)
		ELSE
			//IF gs_role <> '-1' THEN // Dinesh -05/31/2024-  SIMS-473-Google - SIMS – SIMS Timer Enhancement
				 
					g.of_sims_notification( gi_time_interval)
				
			
		END IF
		exit;
end if
		
next

// Begin -Dinesh -06/05/2024-  SIMS-473-Google - SIMS – SIMS Timer Enhancement
if gs_Userlist='*ALL' and gs_projectlist='*ALL' then
	lds_sims_notification_filter.dataobject='d_sims_notification_search_all'
	lds_sims_notification_filter.settrans(sqlca)
	lds_sims_notification_filter.retrieve()
	gs_Projectlist= lds_sims_notification_filter.getitemstring(1,'Project_Id')
	gs_Userlist= lds_sims_notification_filter.getitemstring(1,'User_Id')
	gs_NotificationFlag= lds_sims_notification_filter.getitemstring(1,'Notification_Flag')
	gs_ShutdownFlag= lds_sims_notification_filter.getitemstring(1,'Shutdown_Flag')
	gs_AlertNotes= lds_sims_notification_filter.getitemstring(1,'Notes')
	li_time_interval= lds_sims_notification_filter.getitemnumber(1,'Time_Interval')
	gs_login= lds_sims_notification_filter.getitemstring(1,'login')
	
	//Dinesh -06/11/2024 - SIMS-473- Google - SIMS – SIMS Timer Enhancement
	if gs_projectlist ='PANDORA'  and (upper(gs_Userlist)= upper(gs_userid)) then
			//If Interval is changed, re-call timer 
		IF li_time_interval <> gi_time_interval THEN
			gi_time_interval = li_time_interval
			timer(gi_time_interval)
		ELSE
			//IF gs_role <> '-1' THEN // Dinesh -05/31/2024-  SIMS-473-Google - SIMS – SIMS Timer Enhancement
				 
					g.of_sims_notification( gi_time_interval)
				
			
		END IF
		exit;
end if
IF gs_projectlist <> '*ALL' and gs_Userlist <>'*ALL' then
	if (upper(gs_Userlist)= upper(gs_userid)) and (upper(gs_projectlist)=upper(gs_project)) then
		//If Interval is changed, re-call timer 
		IF li_time_interval <> gi_time_interval THEN
			gi_time_interval = li_time_interval
			timer(gi_time_interval)
		ELSE
			//IF gs_role <> '-1' THEN // Dinesh -05/31/2024-  SIMS-473-Google - SIMS – SIMS Timer Enhancement
				 
					g.of_sims_notification( gi_time_interval)
				
			
		END IF
		exit;
	end if
End if
if upper(gs_projectlist)  = '*ALL' and gs_Userlist = '*ALL' then
	//If Interval is changed, re-call timer 
		IF li_time_interval <> gi_time_interval THEN
			gi_time_interval = li_time_interval
			timer(gi_time_interval)
		ELSE
			//IF gs_role <> '-1' THEN // Dinesh -05/31/2024-  SIMS-473-Google - SIMS – SIMS Timer Enhancement
				 
					g.of_sims_notification( gi_time_interval)
				
			
		END IF
		exit;
end if
if upper(gs_projectlist)  = '*ALL' and (UPPER(gs_Userlist) = UPPER(gs_userid)) then
	//If Interval is changed, re-call timer 
		IF li_time_interval <> gi_time_interval THEN
			gi_time_interval = li_time_interval
			timer(gi_time_interval)
		ELSE
			//IF gs_role <> '-1' THEN // Dinesh -05/31/2024-  SIMS-473-Google - SIMS – SIMS Timer Enhancement
				 
					g.of_sims_notification( gi_time_interval)
				
			
		END IF
		exit;
end if
if upper(gs_projectlist)  = upper(gs_project) and (UPPER(gs_Userlist) = '*ALL') then
	
		//If Interval is changed, re-call timer 
		IF li_time_interval <> gi_time_interval THEN
			gi_time_interval = li_time_interval
			timer(gi_time_interval)
		ELSE
			//IF gs_role <> '-1' THEN // Dinesh -05/31/2024-  SIMS-473-Google - SIMS – SIMS Timer Enhancement
				 
					g.of_sims_notification( gi_time_interval)
				
			
		END IF
		exit;
	end if
end if
 
next
//End -Dinesh -05/31/2024-  SIMS-473-Google - SIMS – SIMS Timer Enhancement
//destroy lds_sims_notification
//destroy lds_sims_notification_filter
end event

type dw_1 from datawindow within w_sims_banner
integer width = 6130
integer height = 1888
integer taborder = 10
boolean enabled = false
string title = "none"
string dataobject = "dw_sims_banner"
boolean border = false
borderstyle borderstyle = styleraised!
end type

