$PBExportHeader$w_sims_timer.srw
$PBExportComments$+ Added SIMS Timer Setup
forward
global type w_sims_timer from window
end type
type cb_1 from commandbutton within w_sims_timer
end type
type cb_all_selected_domain from commandbutton within w_sims_timer
end type
type st_domain from statictext within w_sims_timer
end type
type lb_domainname from listbox within w_sims_timer
end type
type cb_reset from commandbutton within w_sims_timer
end type
type cb_search_new from commandbutton within w_sims_timer
end type
type sle_search from singlelineedit within w_sims_timer
end type
type sle_version from singlelineedit within w_sims_timer
end type
type st_2 from statictext within w_sims_timer
end type
type cb_delete from commandbutton within w_sims_timer
end type
type cb_add from commandbutton within w_sims_timer
end type
type sle_custom_msg from singlelineedit within w_sims_timer
end type
type st_message from statictext within w_sims_timer
end type
type st_count_value from statictext within w_sims_timer
end type
type st_count from statictext within w_sims_timer
end type
type st_1 from statictext within w_sims_timer
end type
type rb_no from radiobutton within w_sims_timer
end type
type rb_yes from radiobutton within w_sims_timer
end type
type st_sort from statictext within w_sims_timer
end type
type cb_select_user from commandbutton within w_sims_timer
end type
type cb_cleare_user from commandbutton within w_sims_timer
end type
type cb_clear_project from commandbutton within w_sims_timer
end type
type cb_select_project from commandbutton within w_sims_timer
end type
type cb_close from commandbutton within w_sims_timer
end type
type cb_ok from commandbutton within w_sims_timer
end type
type st_msg_desc from statictext within w_sims_timer
end type
type dw_message_desc from datawindow within w_sims_timer
end type
type dw_message_type from datawindow within w_sims_timer
end type
type st_user from statictext within w_sims_timer
end type
type st_project from statictext within w_sims_timer
end type
type dw_user from datawindow within w_sims_timer
end type
type dw_project from datawindow within w_sims_timer
end type
type gb_project from groupbox within w_sims_timer
end type
type gb_user from groupbox within w_sims_timer
end type
type gb_notification from groupbox within w_sims_timer
end type
type gb_1 from groupbox within w_sims_timer
end type
type gb_custom from groupbox within w_sims_timer
end type
end forward

global type w_sims_timer from window
integer width = 3950
integer height = 2828
boolean titlebar = true
string title = "SIMS Notification Alert"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
event ue_projectlist ( )
event ue_userlist ( )
event ue_update_globalvalues ( )
event ue_search_userlist ( )
cb_1 cb_1
cb_all_selected_domain cb_all_selected_domain
st_domain st_domain
lb_domainname lb_domainname
cb_reset cb_reset
cb_search_new cb_search_new
sle_search sle_search
sle_version sle_version
st_2 st_2
cb_delete cb_delete
cb_add cb_add
sle_custom_msg sle_custom_msg
st_message st_message
st_count_value st_count_value
st_count st_count
st_1 st_1
rb_no rb_no
rb_yes rb_yes
st_sort st_sort
cb_select_user cb_select_user
cb_cleare_user cb_cleare_user
cb_clear_project cb_clear_project
cb_select_project cb_select_project
cb_close cb_close
cb_ok cb_ok
st_msg_desc st_msg_desc
dw_message_desc dw_message_desc
dw_message_type dw_message_type
st_user st_user
st_project st_project
dw_user dw_user
dw_project dw_project
gb_project gb_project
gb_user gb_user
gb_notification gb_notification
gb_1 gb_1
gb_custom gb_custom
end type
global w_sims_timer w_sims_timer

type variables
Boolean ib_selectallproject=false
Boolean ib_selectallusers =false
Boolean ib_searchusers = False
String isSql,isProjectlist,isUserlist,isSearchUserlist,is_am,is_ap,is_menlo,is_newbreed,is_project_new,is_user_new,is_select,is_select_user,is_select_project
integer ii_Index //  05/22/2024- Dinesh - SIMS-473-Google - SIMS – SIMS Timer Enhancement
DataWindow idw_project,idw_user,idw_message_type,idw_message_desc
end variables

forward prototypes
public subroutine f_domain_select ()
public function integer uf_populate_lb (listbox lb_param, string sql_param)
public function integer uf_populate_ddlb (dropdownlistbox ddlb_param, string sql_param)
end prototypes

event ue_projectlist();//09-APR-2015 Madhu SIMS Timer Notification Alert Functionality

//Get selected project list
String lsProjectlist
Integer li_row,li_rowcount
Boolean lb_found_project =false

//Get selected Project List, if it is not concatenated earlier
li_rowcount = idw_project.rowcount( )

FOR li_row=1 to li_rowcount
	IF idw_project.getitemstring(li_row,'c_select') ='Y' THEN
		IF lb_found_project THEN 
			lsProjectlist = lsProjectlist +","
		END IF
		lsProjectlist += "'" + idw_project.getitemstring(li_row,'Project_Id') + "'"
		lb_found_project = true
	END IF
NEXT
	
isProjectlist =	lsProjectlist //Store Project list into Instance variable
end event

event ue_userlist();//09-APR-2015 Madhu SIMS Timer Notification Alert Functionality

//Get selected Users List
String lsUSerlist
Integer li_row,li_rowcount
Boolean lb_found_user =false

li_rowcount =idw_user.rowcount( )
FOR li_row =1 to li_rowcount
	IF  idw_user.getitemstring(li_row,'c_select') ='Y' THEN
		IF lb_found_user THEN lsUserlist = lsUserlist +","
		lsUserlist += "'" +idw_user.getitemstring(li_row,'Userid') +"'"
		lb_found_user = true
	END IF
	
NEXT

isUserlist =lsUserlist //Store user list into Instance variable
end event

event ue_update_globalvalues();//10-APR-2015 Madhu - SIMS Timer Notification Alert Functionality

Integer li_time_interval

gs_Projectlist =idw_message_type.getitemstring(1,'Project_Id')
gs_Userlist	 = idw_message_type.getitemstring(1,'User_Id')
gs_AlertNotes = idw_message_type.getitemstring(1,'Notes')
gs_NotificationFlag = idw_message_type.getitemstring( 1, 'Notification_Flag')
gs_ShutdownFlag = idw_message_type.getitemstring(1,'Shutdown_Flag')

li_time_interval=idw_message_type.getitemnumber( 1, 'Time_Interval')

//IF Time Interval has changed update Global variable and re-call timer based on new Interval.
IF gi_time_interval <> li_time_interval THEN 
	gi_time_interval =li_time_interval;
	w_sims_banner.postEvent('open')
END IF

end event

event ue_search_userlist();//Begin- 05/09/2024- Dinesh - SIMS-473-Google - SIMS – SIMS Timer Enhancement
//Get selected Users List
String lsUSerlist,lsUserlistsearch,ls_project_list,ls_filter,ls_select,ls_select_proj,sqlsyntax
Integer li_row,li_rowcount,li_rowcount_project
long ll_msg_id,ll_time_interval,i,j,ll_row,error_code
Boolean lb_found_user =false
ib_searchusers = True

// Begin - Dinesh - 05/16/2024- SIMS-473-Google - SIMS – SIMS Timer Enhancement
datastore lds_searchuser_list
lds_searchuser_list  = create datastore
lds_searchuser_list.dataobject='d_sims_notification_search'
lds_searchuser_list.settrans(sqlca)
// End - Dinesh - 05/16/2024- SIMS-473-Google - SIMS – SIMS Timer Enhancement
ll_msg_id= dw_message_type.getitemnumber(1,'msg_id')
ll_time_interval= dw_message_type.getitemnumber(1,'time_interval')
if ib_selectallusers = True and ib_selectallproject= True then
							if gs_project='PANDORA' then
								//ls_project_list= gs_project
								ls_project_list= '*ALL' //Dinesh - 06/05/2024- SIMS-473-Google - SIMS – SIMS Timer Enhancement
							else
								ls_project_list= '*ALL'
							end if
						insert into SIMS_Notification_user (project_id,user_id,msg_id,time_interval) values(:ls_project_list,'*ALL',:ll_msg_id,:ll_time_interval) using sqlca;
						commit using sqlca;
end if
 if ib_selectallusers = True and ib_selectallproject= False then	
			 li_rowcount_project =idw_project.rowcount( )
				FOR i =1 to li_rowcount_project
					IF  idw_project.getitemstring(i,'c_select') ='Y' THEN
						ls_project_list= idw_project.getitemstring(i,'project_id')
						if ls_project_list='PANDORA' then
							ls_project_list= gs_project
							//ls_project_list= '*ALL'
						end if
						insert into SIMS_Notification_user (project_id,user_id,msg_id,time_interval) values(:ls_project_list,'*ALL',:ll_msg_id,:ll_time_interval) using sqlca;
						commit using sqlca;
					end if
				NEXT
	end if
if ib_selectallusers = False and ib_selectallproject= True then
	li_rowcount =idw_user.rowcount( )
	ls_select='Y'
	idw_user.SetFilter("c_select = '" + ls_select + "'")
	idw_user.Filter()
	li_rowcount =idw_user.rowcount( )
	ls_project_list= '*ALL'
	FOR li_row =1 to li_rowcount
			lsUserlistsearch= idw_user.getitemstring(li_row,'Userid')
				insert into SIMS_Notification_user (project_id,user_id,msg_id,time_interval) values(:ls_project_list,:lsUserlistsearch,:ll_msg_id,:ll_time_interval) using sqlca;
				commit using sqlca;
	//end if
		
	Next
end if

if ib_selectallusers = False and ib_selectallproject= False then
	 li_rowcount_project =idw_project.rowcount( )
		ls_select_proj='Y'
		idw_project.SetFilter("c_select = '" + ls_select_proj + "'")
		idw_project.Filter()
		li_rowcount_project=idw_project.rowcount()
	  FOR j =1 to li_rowcount_project
		ls_project_list= idw_project.getitemstring(j,'project_id')
			if ls_project_list='PANDORA' then
				ls_project_list= gs_project
			end if
				li_rowcount =idw_user.rowcount( )
				ls_select='Y'
				idw_user.SetFilter("c_select = '" + ls_select + "'")
				idw_user.Filter()
				li_rowcount=idw_user.rowcount()
				FOR ll_row =1 to li_rowcount
					
						lsUserlistsearch= idw_user.getitemstring(ll_row,'userid')
						
						insert into SIMS_Notification_user (project_id,user_id,msg_id,time_interval) values(:ls_project_list,:lsUserlistsearch,:ll_msg_id,:ll_time_interval) using sqlca;
						commit;
						 if sqlca.sqlcode = 0 then
						else
							messagebox('',string(sqlca.sqldbcode))
						end if
							
				Next
		Next
	
end if
//End - 05/09/2024- Dinesh - SIMS-473-Google - SIMS – SIMS Timer Enhancement
end event

public subroutine f_domain_select ();//Begin- 05/24/2024- Dinesh - SIMS-473-Google - SIMS – SIMS Timer Enhancement
String ls_code_list
String ls_order_types,ls_domain,lsSqlSyntax,ls_selected,ls_select
long i,ll_items,ll_row,ll_select,k

ll_items     = lb_domainname.TotalItems()
idw_user.dataobject='d_user_project_list'
lsSqlSyntax = idw_user.GetSQLSelect()
for i = 1 to  ll_items
	
	if lb_domainname.State(i) = 1 then
		k++
		ls_domain = lb_domainname.text(i)
		if k=1 then
			lsSqlSyntax = lsSqlSyntax+" where Userid like " +"'"+ls_domain+"%'"
		elseif k >1 then
			lsSqlSyntax = lsSqlSyntax+"  or Userid like " +"'"+ls_domain+"%'"
		end if
	
	end if

next
idw_user.SetTransObject(sqlca)
idw_user.SetSQLSelect( lsSqlSyntax )
idw_user.Retrieve()

//End- 05/24/2024- Dinesh - SIMS-473-Google - SIMS – SIMS Timer Enhancement
end subroutine

public function integer uf_populate_lb (listbox lb_param, string sql_param);// Begin - Dinesh - 05/24/2024- SIMS-473-Google - SIMS – SIMS Timer Enhancement
// populate a listbox with results from a sql statement
// returns number of rows from datastore retrieve
long ll_ddlb_length
long    ll_rc
long    ll_i
string ls_ds_sql
string ls_error
string    ls_val
datastore lds
lds = CREATE datastore
ls_ds_sql = SQLCA.syntaxfromsql( sql_param, 'Style(Type=Form)', ls_error)
IF (Len(ls_error) > 0 ) THEN
   MessageBox ("DataBase Error!", ls_error)
   return sqlca.sqlcode
ELSE
   lds.create(ls_ds_sql, ls_error)
   IF (Len(ls_error) > 0 ) THEN
      MessageBox ("Datastore create Error!", ls_error)
      return -1
   END IF
   lds.settransobject(SQLCA)
   ll_rc = lds.retrieve()
END IF
SetRedraw (lb_param, false)
Reset (lb_param)
FOR ll_i = 1 to ll_rc
   ls_val = lds.getitemstring(ll_i,1)
   Additem (lb_param, ls_val)
NEXT
SetRedraw (lb_param, true)
if ll_rc < 12 then
   ll_ddlb_length = ll_rc * 63 + 117
   lb_param.height = ll_ddlb_length
else
   lb_param.height = 873
end if
DESTROY lds
return ll_rc

// End - Dinesh - 05/24/2024- SIMS-473-Google - SIMS – SIMS Timer Enhancement
end function

public function integer uf_populate_ddlb (dropdownlistbox ddlb_param, string sql_param);//// Begin - Dinesh - 05/24/2024- SIMS-473-Google - SIMS – SIMS Timer Enhancement
//// populate a listbox with results from a sql statement
//// returns number of rows from datastore retrieve
//long ll_ddlb_length
long    ll_rc
//long    ll_i
//string ls_ds_sql
//string ls_error
//string    ls_val
//datastore lds
//lds = CREATE datastore
//ls_ds_sql = SQLCA.syntaxfromsql( sql_param, 'Style(Type=Form)', ls_error)
//IF (Len(ls_error) > 0 ) THEN
//   MessageBox ("DataBase Error!", ls_error)
//   return sqlca.sqlcode
//ELSE
//   lds.create(ls_ds_sql, ls_error)
//   IF (Len(ls_error) > 0 ) THEN
//      MessageBox ("Datastore create Error!", ls_error)
//      return -1
//   END IF
//   lds.settransobject(SQLCA)
//   ll_rc = lds.retrieve()
//END IF
//SetRedraw (ddlb_param, false)
//Reset (ddlb_param)
//FOR ll_i = 1 to ll_rc
//     ls_val = lds.getitemstring(ll_i,1)
//   Additem (ddlb_param, ls_val)
//NEXT
//SetRedraw (ddlb_param, true)
//if ll_rc < 12 then
//   ll_ddlb_length = ll_rc * 63 + 117
//   ddlb_param.height = ll_ddlb_length
//else
//   ddlb_param.height = 873
//end if
//DESTROY lds
return ll_rc
//// End - Dinesh - 05/24/2024- SIMS-473-Google - SIMS – SIMS Timer Enhancement
end function

on w_sims_timer.create
this.cb_1=create cb_1
this.cb_all_selected_domain=create cb_all_selected_domain
this.st_domain=create st_domain
this.lb_domainname=create lb_domainname
this.cb_reset=create cb_reset
this.cb_search_new=create cb_search_new
this.sle_search=create sle_search
this.sle_version=create sle_version
this.st_2=create st_2
this.cb_delete=create cb_delete
this.cb_add=create cb_add
this.sle_custom_msg=create sle_custom_msg
this.st_message=create st_message
this.st_count_value=create st_count_value
this.st_count=create st_count
this.st_1=create st_1
this.rb_no=create rb_no
this.rb_yes=create rb_yes
this.st_sort=create st_sort
this.cb_select_user=create cb_select_user
this.cb_cleare_user=create cb_cleare_user
this.cb_clear_project=create cb_clear_project
this.cb_select_project=create cb_select_project
this.cb_close=create cb_close
this.cb_ok=create cb_ok
this.st_msg_desc=create st_msg_desc
this.dw_message_desc=create dw_message_desc
this.dw_message_type=create dw_message_type
this.st_user=create st_user
this.st_project=create st_project
this.dw_user=create dw_user
this.dw_project=create dw_project
this.gb_project=create gb_project
this.gb_user=create gb_user
this.gb_notification=create gb_notification
this.gb_1=create gb_1
this.gb_custom=create gb_custom
this.Control[]={this.cb_1,&
this.cb_all_selected_domain,&
this.st_domain,&
this.lb_domainname,&
this.cb_reset,&
this.cb_search_new,&
this.sle_search,&
this.sle_version,&
this.st_2,&
this.cb_delete,&
this.cb_add,&
this.sle_custom_msg,&
this.st_message,&
this.st_count_value,&
this.st_count,&
this.st_1,&
this.rb_no,&
this.rb_yes,&
this.st_sort,&
this.cb_select_user,&
this.cb_cleare_user,&
this.cb_clear_project,&
this.cb_select_project,&
this.cb_close,&
this.cb_ok,&
this.st_msg_desc,&
this.dw_message_desc,&
this.dw_message_type,&
this.st_user,&
this.st_project,&
this.dw_user,&
this.dw_project,&
this.gb_project,&
this.gb_user,&
this.gb_notification,&
this.gb_1,&
this.gb_custom}
end on

on w_sims_timer.destroy
destroy(this.cb_1)
destroy(this.cb_all_selected_domain)
destroy(this.st_domain)
destroy(this.lb_domainname)
destroy(this.cb_reset)
destroy(this.cb_search_new)
destroy(this.sle_search)
destroy(this.sle_version)
destroy(this.st_2)
destroy(this.cb_delete)
destroy(this.cb_add)
destroy(this.sle_custom_msg)
destroy(this.st_message)
destroy(this.st_count_value)
destroy(this.st_count)
destroy(this.st_1)
destroy(this.rb_no)
destroy(this.rb_yes)
destroy(this.st_sort)
destroy(this.cb_select_user)
destroy(this.cb_cleare_user)
destroy(this.cb_clear_project)
destroy(this.cb_select_project)
destroy(this.cb_close)
destroy(this.cb_ok)
destroy(this.st_msg_desc)
destroy(this.dw_message_desc)
destroy(this.dw_message_type)
destroy(this.st_user)
destroy(this.st_project)
destroy(this.dw_user)
destroy(this.dw_project)
destroy(this.gb_project)
destroy(this.gb_user)
destroy(this.gb_notification)
destroy(this.gb_1)
destroy(this.gb_custom)
end on

event close;close(this);
end event

event open;//07-Apr-2015 Madhu- SIMS Timer Notification Alert Functionality
string lsFilter,ls_domain,ls_userid
long ll_count
string lsSqlSyntax
datastore lds_domain
//Set datawindows
datawindowchild ldwc_domain
idw_project =dw_project
idw_user=dw_user
idw_message_type =dw_message_type
idw_message_desc =dw_message_desc
ib_selectallproject= True//  05/22/2024- Dinesh - SIMS-473-Google - SIMS – SIMS Timer Enhancement
ib_selectallusers =True // Dinesh

//Set transaction object to all Datawindows
idw_project.settransobject( SQLCA);
idw_user.settransobject( SQLCA);
idw_message_type.settransobject( SQLCA);
idw_message_desc.settransobject( SQLCA);

isSql =idw_user.getsqlselect( ) //Get SQL of UserProject
gsSql= isSql

//Retrieve all datawindows one time
idw_project.retrieve()
idw_user.retrieve()
idw_message_type.retrieve()
idw_message_desc.retrieve()
//Begin -  Dinesh - 05/14/2024- SIMS-473- SIMS Timer Enhancement
//dw_domain.settransobject(SQLCA)
//dw_domain.retrieve()
//dw_domain.GetChild('userid', ldwc_domain)
//ldwc_domain.SetTransObject(SQLCA)	
//ldwc_domain.Retrieve()

	lds_domain = create datastore
	lds_domain.dataobject='d_domain'
	lsSqlSyntax = lds_domain.GetSQLSelect()
	lds_domain.SetTransObject(sqlca)
	lds_domain.SetSQLSelect( lsSqlSyntax )
	lds_domain.Retrieve()
	
	uf_populate_lb(lb_domainname,lsSqlSyntax)

//Right(lsNewOwnerCD,2) 
//select distinct left(userid,2)  from usertable with(nolock) where user_status=1;
select distinct left(userid,charindex('\',userid)) into :ls_userid  from usertable with(nolock) where user_status=1 and userid in(select distinct userid from user_login_history with(nolock) where server_login_time>getdate()-30) using sqlca;

//select distinct userid into:ls_userid from user_login_history with(nolock) where server_login_time > getdate()-30 using sqlca;
////dw_domain.Modify("userid.Background.Color='11665407'")

//ls_domain= dw_domain.getitemstring(1,'userid')
//lsFilter = "Upper(userid) = '" + ls_domain + "'"
//dw_domain.SetFilter(lsFilter)
//dw_domain.Filter()
//End -  Dinesh - 05/14/2024- SIMS-473- SIMS Timer Enhancement
//set with default login version
sle_version.text = f_get_Version()
end event

type cb_1 from commandbutton within w_sims_timer
integer x = 1179
integer y = 400
integer width = 229
integer height = 80
integer taborder = 30
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Reset"
end type

event clicked;string lsSql
long ll_res
datastore lds_domain
ib_selectallproject =true
idw_project.dataobject='d_assign_user_project'
lsSql = idw_project.GetSQLSelect()
idw_project.SetTransObject(sqlca)
idw_project.SetSQLSelect( lsSql )
ll_res= idw_project.Retrieve()
	
end event

type cb_all_selected_domain from commandbutton within w_sims_timer
integer x = 1157
integer y = 928
integer width = 690
integer height = 84
integer taborder = 70
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "All Selected Domain Users"
end type

event clicked;//Begin - Dinesh - 05/13/2024 - SIMS-473-Google - SIMS – SIMS Timer Enhancement
integer li_row,li_rowcount
ib_selectallusers = False
string ls_domain
ii_Index = lb_domainname.SelectedIndex()
if ii_Index < 1 then
	messagebox("Alert",'Please select at least one domain from the domain list')
	lb_domainname.SetFocus()
	return
end if
f_domain_select()  //Dinesh - 05/27/2024 - SIMS-473-Google - SIMS – SIMS Timer Enhancement
li_rowcount =idw_user.rowcount( ) //Get total row count
For li_row=1 to li_rowcount
	idw_user.setitem( li_row, 'c_select', 'Y') //Set Flag =Y to all users.
	is_user_new= idw_user.getitemstring(li_row,'userid')
NEXT

// End - Dinesh - 05/27/2024 - SIMS-473-Google - SIMS – SIMS Timer Enhancement






end event

type st_domain from statictext within w_sims_timer
integer x = 1865
integer y = 824
integer width = 229
integer height = 88
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 8388608
long backcolor = 67108864
string text = "Domain"
boolean focusrectangle = false
end type

type lb_domainname from listbox within w_sims_timer
integer x = 2094
integer y = 840
integer width = 512
integer height = 284
integer taborder = 60
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean vscrollbar = true
boolean multiselect = true
borderstyle borderstyle = stylelowered!
end type

event selectionchanged;//string ls_domain
////ls_domain = lb_domainname.SelectedItems()ls_domain= lb_domainname.SelectedItem())
////ls_domain = lb_domainname.SelectedItem()
//f_domain_select()  //Dinesh - 05/24/2024 - SIMS-473-Google - SIMS – SIMS Timer Enhancement
////This.SelectRow(0, false)
////This.SelectRow(row, true)
//
//
//ii_Index = lb_domainname.SelectedIndex()
////lb_actions.DeleteItem(li_Index)

end event

type cb_reset from commandbutton within w_sims_timer
string tag = "Search"
integer x = 1157
integer y = 1032
integer width = 238
integer height = 84
integer taborder = 40
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Reset"
end type

event clicked;integer li_row,li_rowcount
// Begin - Dinesh - 0508/2024- SIMS-473-Google - SIMS – SIMS Timer Enhancement
datastore lds_domain
string ls_search,lsSqlSyntax,lsSqlSyntaxuser,lsSql
LONG llfindrow,ll_res
ib_selectallusers =True
//lsSqlSyntaxuser=''
ls_search= sle_search.text
idw_user.dataobject='d_user_project_list'
lsSql = idw_user.GetSQLSelect()
idw_user.SetTransObject(sqlca)
idw_user.SetSQLSelect( lsSql )
ll_res= idw_user.Retrieve()
lds_domain = create datastore
	lds_domain.dataobject='d_domain'
	lsSqlSyntax = lds_domain.GetSQLSelect()
	lds_domain.SetTransObject(sqlca)
	lds_domain.SetSQLSelect( lsSqlSyntax )
	lds_domain.Retrieve()
	uf_populate_lb(lb_domainname,lsSqlSyntax)
	// End - Dinesh - 0508/2024- SIMS-473-Google - SIMS – SIMS Timer Enhancement
	

end event

type cb_search_new from commandbutton within w_sims_timer
string tag = "Search"
integer x = 1157
integer y = 720
integer width = 256
integer height = 84
integer taborder = 40
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Search"
end type

event clicked;// Begin - Dinesh - 05/08/2024- SIMS-473-Google - SIMS – SIMS Timer Enhancement
integer li_row,li_rowcount
ib_searchusers= True
string ls_search,lsSqlSyntax
LONG llfindrow
idw_user.reset()
ls_search= sle_search.text
ib_selectallusers = FALSE
idw_user.Retrieve()
	if ls_search ='' or isnull(ls_search) then
		messagebox('User Name','Please enter valid User Name')
		sle_search.setfocus()
		return
	else
		idw_user.dataobject='d_user_project_list'
		lsSqlSyntax = idw_user.GetSQLSelect()
		lsSqlSyntax = lsSqlSyntax+" where Userid like " +"'%"+ls_search+"%'"
		idw_user.SetTransObject(sqlca)
		idw_user.SetSQLSelect( lsSqlSyntax )
		idw_user.Retrieve()
	end if
//if sqlca.sqlcode <> 0 then
//	messagebox('User Name',"The user name you are searching is/are not found, Please enter Valid Key name")
//	sle_search.clear()
//	sle_search.setfocus()
//	return
//end if
// End - Dinesh - 05/08/2024- SIMS-473-Google - SIMS – SIMS Timer Enhancement






end event

type sle_search from singlelineedit within w_sims_timer
integer x = 462
integer y = 720
integer width = 663
integer height = 92
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type sle_version from singlelineedit within w_sims_timer
integer x = 3104
integer y = 556
integer width = 631
integer height = 96
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

event modified;//15-FEB-2016 Madhu SIMS Timer Notification Alert Functionality

//Get selected list of projects from selected list and append those onto User Query.
Integer li_usercount=0
String lsSql,ls_where,lsProjectlist,lsVersion


SetPointer(HourGlass!)
idw_user.dataobject='d_user_project_list_by_version_name'
idw_user.settransobject( SQLCA)

IF idw_user.accepttext( ) =-1 Then return

idw_user.reset( )
lsSql =idw_user.getsqlselect( )

lsVersion =Left(sle_version.text,10) +"%" //6020160101-PROD

IF not ib_selectallproject THEN //If all Projects are not selected then only do the process

	parent.event ue_projectlist( )
	
	ls_where =" WHERE up.Project_ID IN "
	
	IF isProjectlist > ' ' THEN lsSql += ls_where + "(" + isProjectlist + ")"

		lsSql +=  " AND ulh.SIMS_Version < '" + lsVersion+"'  AND ulh.Logout_Time IS NULL"

	idw_user.setsqlselect( lsSql)
	li_usercount =idw_user.retrieve( )

	st_count_value.text =String(li_usercount)
	
END IF

end event

type st_2 from statictext within w_sims_timer
integer x = 2185
integer y = 576
integer width = 919
integer height = 64
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 255
long backcolor = 67108864
string text = "Sort users by SIMS Version <"
boolean focusrectangle = false
end type

type cb_delete from commandbutton within w_sims_timer
integer x = 2967
integer y = 2104
integer width = 325
integer height = 116
integer taborder = 60
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&DELETE"
end type

event clicked;//10-APR-2015 Madhu SIMS Timer Notification Alert Functionality

//Delete selected row
Integer li_row,li_update

li_row =idw_message_desc.getselectedrow( 0)
idw_message_desc.deleterow( li_row)
idw_message_desc.update()


end event

type cb_add from commandbutton within w_sims_timer
integer x = 2967
integer y = 2340
integer width = 325
integer height = 116
integer taborder = 60
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&ADD"
end type

event clicked;//10-APR-2015 Madhu SIMS Timer Notification Alert Functionality

//Insert new customer message into SIMS_Notification_Message Table.
String ls_msg_desc,lsFind
Integer li_rowcount,li_row

ls_msg_desc = sle_custom_msg.text

li_rowcount =idw_message_desc.rowcount( )

lsFind ="Msg_Desc ='"+ls_msg_desc+"'"
li_row =idw_message_desc.find( lsFind, 0, li_rowcount)

IF li_row =0 and ls_msg_desc >' ' THEN //Don't allow to insert duplicate Messages.
	idw_message_desc.insertrow( 0)
	idw_message_desc.setitem(li_rowcount+1,'Msg_Id',li_rowcount+1)
	idw_message_desc.setitem(li_rowcount+1,'Msg_Desc',ls_msg_desc)
END IF

sle_custom_msg.text='' //Once it is added, clear the TEXT
end event

type sle_custom_msg from singlelineedit within w_sims_timer
integer x = 457
integer y = 2384
integer width = 2272
integer height = 100
integer taborder = 50
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
end type

type st_message from statictext within w_sims_timer
integer x = 37
integer y = 2384
integer width = 425
integer height = 68
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 67108864
string text = "Message Desc"
boolean focusrectangle = false
end type

type st_count_value from statictext within w_sims_timer
integer x = 2094
integer y = 712
integer width = 302
integer height = 88
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 255
long backcolor = 16777215
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type st_count from statictext within w_sims_timer
integer x = 1870
integer y = 712
integer width = 215
integer height = 88
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 8388608
long backcolor = 67108864
string text = "count"
boolean focusrectangle = false
end type

type st_1 from statictext within w_sims_timer
integer x = 837
integer y = 20
integer width = 1847
integer height = 84
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 8388608
long backcolor = 67108864
string text = "SIMS Notification Alert"
alignment alignment = center!
boolean focusrectangle = false
end type

type rb_no from radiobutton within w_sims_timer
integer x = 1943
integer y = 564
integer width = 293
integer height = 84
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 8388608
long backcolor = 67108864
string text = "No"
boolean checked = true
end type

event clicked;//08-APR-2015 Madhu SIMS Timer Notification Alert Functionality

//Don't sort by Project Id, list all users.
Integer li_usercount=0
String lsSql

lsSql =isSql
idw_user.setsqlselect( lsSql)
li_usercount =idw_user.retrieve( )
st_count_value.text =String(li_usercount)

end event

type rb_yes from radiobutton within w_sims_timer
integer x = 1669
integer y = 564
integer width = 247
integer height = 84
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 8388608
long backcolor = 67108864
string text = "Yes"
end type

event clicked;//07-APR-2015 Madhu SIMS Timer Notification Alert Functionality

//Get selected list of projects from selected list and append those onto User Query.
Integer li_usercount=0
String lsSql,ls_where,lsProjectlist


SetPointer(HourGlass!)

IF idw_user.accepttext( ) =-1 Then return

idw_user.reset( )
lsSql =isSql

IF not ib_selectallproject THEN //If all Projects are not selected then only do the process

	parent.event ue_projectlist( )

	ls_where =" WHERE Project_ID IN "
	
	IF isProjectlist > ' ' THEN lsSql += ls_where + "(" + isProjectlist + ")"
	
	idw_user.setsqlselect( lsSql)
	li_usercount =idw_user.retrieve( )

	st_count_value.text =String(li_usercount)
	
END IF

end event

type st_sort from statictext within w_sims_timer
integer x = 37
integer y = 564
integer width = 1586
integer height = 84
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 255
long backcolor = 67108864
string text = "Do you want to sort users by selected Project List?"
boolean focusrectangle = false
end type

type cb_select_user from commandbutton within w_sims_timer
integer x = 1157
integer y = 824
integer width = 425
integer height = 84
integer taborder = 20
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Select All Users"
end type

event clicked;integer li_row,li_rowcount

//ib_selectallusers =True //If select all users // commented - added below lines - 05/13/2024- Dinesh - SIMS-473-Google - SIMS – SIMS Timer Enhancement

//Begin - Dinesh - 05/13/2024 - SIMS-473-Google - SIMS – SIMS Timer Enhancement
//IF ib_searchusers= True then 
	ib_selectallusers =True //If select all users
	
//End if
// End - Dinesh - 05/13/2024 - SIMS-473-Google - SIMS – SIMS Timer Enhancement

li_rowcount =idw_user.rowcount( ) //Get total row count
idw_user.accepttext()
For li_row=1 to li_rowcount
	idw_user.setitem( li_row, 'c_select', 'Y') //Set Flag =Y to all users.
	is_select_user= idw_user.getitemstring(li_row,'userid')
NEXT






end event

type cb_cleare_user from commandbutton within w_sims_timer
integer x = 1417
integer y = 1032
integer width = 398
integer height = 84
integer taborder = 30
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Clear All Users"
end type

event clicked;integer li_row,li_rowcount
sle_search.clear()
li_rowcount =idw_user.rowcount( ) //Get total row count
For li_row=1 to li_rowcount
	idw_user.setitem( li_row, 'c_select', 'N') //Set Flag =N to all users.
	is_select_user= idw_user.getitemstring(li_row,'userid')
NEXT






end event

type cb_clear_project from commandbutton within w_sims_timer
integer x = 1175
integer y = 296
integer width = 494
integer height = 84
integer taborder = 20
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Clear All Projects"
end type

event clicked;integer li_row,li_rowcount
string ls_select

li_rowcount =idw_project.rowcount( ) //Get total row count
For li_row=1 to li_rowcount
	idw_project.setitem( li_row, 'c_select', 'N') //Set Flag =N to all projects.
	is_select_project= idw_project.getitemstring(li_row,'c_select')

NEXT
	ib_selectallproject =False






end event

type cb_select_project from commandbutton within w_sims_timer
integer x = 1175
integer y = 184
integer width = 494
integer height = 84
integer taborder = 20
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Select All Projects"
end type

event clicked;integer li_row,li_rowcount

ib_selectallproject =true //IF select all project is clicked set boolean variable to true

li_rowcount =idw_project.rowcount( ) //Get total row count
	idw_project.accepttext()
For li_row=1 to li_rowcount
	idw_project.setitem( li_row, 'c_select', 'Y') //Set Flag =Y to all projects
	is_select_project= idw_project.getitemstring(li_row,'c_select')
	
NEXT






end event

type cb_close from commandbutton within w_sims_timer
integer x = 1687
integer y = 2568
integer width = 393
integer height = 124
integer taborder = 60
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Close"
end type

event clicked;parent.event close( )
end event

type cb_ok from commandbutton within w_sims_timer
integer x = 1051
integer y = 2568
integer width = 393
integer height = 124
integer taborder = 50
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&OK"
end type

event clicked;//07-APR-2015 Madhu SIMS Timer Notification Alert Functionality

/*Case 	a. If "SelectAllProjects" =TRUE 	and 	"SelectAllUsers" = TRUE 	then set "User ID" value to default value as "*ALL"
			b. If "SelectAllProjects" =TRUE 	and 	"SelectAllUsers" = FALSE	then set "User ID" value to default value as "*ALL"
			c. If "SelectAllProjects" =FALSE 	and 	"SelectAllUsers" = TRUE 	then set "User ID" value to default value as "*ALL"
			d. If "SelectAllProjects" =FALSE 	and 	"SelectAllUsers" = FALSE (none of users selected) 	then set "User ID" value to default value as "*ALL"
			e. If "SelectAllProjects" =FALSE 	and 	"SelectAllUsers" = FALSE (some of users selected)	 then set "User ID" value to "Selected Users"
*/

Integer li_row,li_rowcount
long ll_row
String ls_notification,ls_shutdown,is_title,lsUserlistsearch,ls_notes,ls_login
datetime ldt_start_time
int i , li_rows,li_row_check,li_row_checks,li_rows_proj,j
boolean lb_checked
string ls_checked,ls_checked_project

SetPointer(Hourglass!)

idw_message_type.accepttext( )
idw_message_desc.accepttext( )
//Begin - 05/30/2024- Dinesh - SIMS-473-Google - SIMS – SIMS Timer Enhancement
 idw_user.accepttext( )
  idw_project.accepttext( )
li_rows = idw_user.RowCount() 

for i = 1 to li_rows
			ls_checked =  idw_user.getitemstring(i,'c_select')
			if ls_checked='Y' then
				idw_user.SetItem( j, 'c_select', 'Y')
			else
				idw_user.SetItem( j, 'c_select', 'N')
			End if
			
next
//
li_rows_proj = idw_project.RowCount() 
for j = 1 to li_rows_proj
			ls_checked_project =  idw_project.getitemstring(j,'c_select')
			if ls_checked_project='Y' then
				idw_project.SetItem( j, 'c_select', 'Y')
			else
				idw_project.SetItem( j, 'c_select', 'N')
			End if
next
//End - 05/22/2024- Dinesh - SIMS-473-Google - SIMS – SIMS Timer Enhancement
//Get selected Project List
parent.event ue_projectlist( )

//Set Project Id value
IF ib_selectallproject =FALSE and len(isProjectlist) > 0 THEN
	idw_message_type.setitem(1,'Project_Id',isProjectlist) //Set selected Project list
ELSE
	idw_message_type.setitem( 1, 'Project_Id', '*ALL') //Set default value as '*ALL'
END IF

//Get selected User List
parent.event ue_userlist( )

//Set User Id value
IF  (ib_selectallproject= FALSE and ib_selectallusers =FALSE and len(isUserlist) > 0) THEN
	
		idw_message_type.setitem(1,'User_Id',isUserlist)	
	ELSE
		//ib_selectallusers = True
		idw_message_type.setitem(1,'User_Id','*ALL')
END IF

//// Begin - Dinesh - 05/22/2024- Dinesh - SIMS-473-Google - SIMS – SIMS Timer Enhancement
delete from SIMS_Notification_user using sqlca;
commit using sqlca;
parent.event ue_search_userlist( ) 

//Set Last User Id value
idw_message_type.setitem(1,'Last_User',gs_userid)

//Get Alert Flag values
ls_notification = idw_message_type.getitemstring(1,'Notification_Flag')
ls_shutdown = idw_message_type.getitemstring(1,'Shutdown_Flag')


//Get the start time
//Begin - 05/22/2024- Dinesh - SIMS-473-Google - SIMS – SIMS Timer Enhancement
ldt_start_time = idw_message_type.getitemdatetime(1,'start_time') 
ls_notes = idw_message_type.getitemstring(1,'notes')
ls_login = idw_message_type.getitemstring(1,'login')
if ls_login='' or isnull(ls_login) then
	idw_message_type.setitem(1,'login','N')
end if
//Set End Time, if all Notification Flag's are Turned OFF
IF ls_notification ='N' and ls_shutdown ='N' THEN 	idw_message_type.setitem( 1, 'End_Time', DateTime(Today(),Now()))
	update SIMS_Notification_user set notification_flag='N', shutdown_flag='N', start_time= :ldt_start_time, end_time= GETDATE(),notes=:ls_notes,last_user=:gs_userid,login=:ls_login using sqlca;
	COMMIT using sqlca;
IF ls_notification ='N' and ls_shutdown ='Y' THEN 
	update SIMS_Notification_user set notification_flag='N', shutdown_flag='Y', start_time= :ldt_start_time, end_time= GETDATE(),notes=:ls_notes,last_user=:gs_userid,login=:ls_login using sqlca;
	COMMIT using sqlca;
ELSEIF ls_notification ='Y' and ls_shutdown ='N' THEN 
	update SIMS_Notification_user set notification_flag='Y', shutdown_flag='N', start_time= :ldt_start_time, end_time= GETDATE(),notes=:ls_notes,last_user=:gs_userid,login=:ls_login using sqlca;
	COMMIT using sqlca;
ELSEIF ls_notification ='Y' and ls_shutdown ='Y' THEN 
	update SIMS_Notification_user set notification_flag='Y', shutdown_flag='Y', start_time= :ldt_start_time, end_time= GETDATE(),notes=:ls_notes,last_user=:gs_userid,login=:ls_login using sqlca;
	COMMIT using sqlca;
END IF
//End - 05/22/2024- Dinesh - SIMS-473-Google - SIMS – SIMS Timer Enhancement
//update SIMS_Notification & SIMS_Notification_Message Table
Execute Immediate "Begin Transaction" using SQLCA;
SQLCA.DBParm = "disablebind =0"
li_row =idw_message_type.update( false,false) 
li_row =idw_message_desc.update( false, false)
SQLCA.DBParm = "disablebind =1"

IF li_row = 1 THEN
	Execute Immediate "COMMIT" using SQLCA;
	
	IF Sqlca.Sqlcode = 0 THEN
		idw_message_type.resetupdate( )
		idw_message_desc.resetupdate( )
		messagebox('SIMS Notification',"SIMS Notification alerts is successfully updated!!")
		Return 0
	ELSE
		Execute Immediate "ROLLBACK" using SQLCA;
		MessageBox(is_title, SQLCA.SQLErrText)
		Return -1
	END IF
ELSE
	Execute Immediate "ROLLBACK" using SQLCA;
	MessageBox(is_title, "System error, record save failed!")
	Return -1
	
END IF

end event

type st_msg_desc from statictext within w_sims_timer
integer x = 37
integer y = 1960
integer width = 416
integer height = 112
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 67108864
string text = "Message Desc:"
boolean focusrectangle = false
end type

type dw_message_desc from datawindow within w_sims_timer
integer x = 457
integer y = 1940
integer width = 2313
integer height = 292
integer taborder = 40
string title = "none"
string dataobject = "d_sims_alert_message_list"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;This.SelectRow(0, false)
This.SelectRow(row, true)
end event

type dw_message_type from datawindow within w_sims_timer
integer x = 41
integer y = 1232
integer width = 2843
integer height = 568
integer taborder = 30
string title = "none"
string dataobject = "d_sims_alert_type"
boolean border = false
borderstyle borderstyle = stylelowered!
end type

type st_user from statictext within w_sims_timer
integer x = 105
integer y = 736
integer width = 347
integer height = 88
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 67108864
string text = "User Name:"
boolean focusrectangle = false
end type

type st_project from statictext within w_sims_timer
integer x = 37
integer y = 240
integer width = 425
integer height = 80
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 67108864
string text = "Project"
boolean focusrectangle = false
end type

type dw_user from datawindow within w_sims_timer
integer x = 457
integer y = 828
integer width = 677
integer height = 292
integer taborder = 20
string title = "none"
string dataobject = "d_user_project_list"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;
 // Begin - 05/22/2024- Dinesh - SIMS-473-Google - SIMS – SIMS Timer Enhancement
	ib_selectallusers = False 
	
	is_select_user= this.getitemstring(row,'c_select')
	this.setitem( row, 'c_select', is_select_user) //Set Flag =N to all projects

		if (is_select_user <> 'N' ) and  	ib_selectallusers =True then
			ib_selectallusers = True
		else
			ib_selectallusers = FALSE
		end if

 // End - 05/22/2024- Dinesh - SIMS-473-Google - SIMS – SIMS Timer Enhancement
end event

type dw_project from datawindow within w_sims_timer
integer x = 457
integer y = 184
integer width = 677
integer height = 292
integer taborder = 10
string title = "none"
string dataobject = "d_assign_user_project"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;//Begin - 05/22/2024- Dinesh - SIMS-473-Google - SIMS – SIMS Timer Enhancement
int li_row, li_rows,li_row_check,li_row_checks
boolean lb_checked
string ls_checked
ib_selectallproject =false
	is_select_project= this.getitemstring(row,'c_select')
	this.setitem( row, 'c_select', is_select_project)
		if (is_select_project <> 'N' ) and  	ib_selectallproject =True then
			ib_selectallproject = True
		end if
 // End - 05/22/2024- Dinesh - SIMS-473-Google - SIMS – SIMS Timer Enhancement
	
end event

type gb_project from groupbox within w_sims_timer
integer x = 14
integer y = 124
integer width = 1710
integer height = 372
integer taborder = 10
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 8388608
long backcolor = 67108864
string text = "Project List"
end type

type gb_user from groupbox within w_sims_timer
integer x = 14
integer y = 664
integer width = 1847
integer height = 504
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 8388608
long backcolor = 67108864
string text = "User List"
end type

type gb_notification from groupbox within w_sims_timer
integer x = 9
integer y = 1164
integer width = 2930
integer height = 652
integer taborder = 40
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 8388608
long backcolor = 67108864
string text = "Notification Type"
end type

type gb_1 from groupbox within w_sims_timer
integer x = 9
integer y = 1832
integer width = 2926
integer height = 424
integer taborder = 40
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 8388608
long backcolor = 67108864
string text = "Notification Message Details"
end type

type gb_custom from groupbox within w_sims_timer
integer x = 9
integer y = 2300
integer width = 2926
integer height = 220
integer taborder = 50
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 8388608
long backcolor = 67108864
string text = "Custom Message"
end type

