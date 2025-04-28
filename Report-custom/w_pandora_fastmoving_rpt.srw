HA$PBExportHeader$w_pandora_fastmoving_rpt.srw
$PBExportComments$Fast Moving Report
forward
global type w_pandora_fastmoving_rpt from w_std_report
end type
end forward

global type w_pandora_fastmoving_rpt from w_std_report
integer width = 3547
integer height = 2044
string title = "Fast Moving Report"
end type
global w_pandora_fastmoving_rpt w_pandora_fastmoving_rpt

type variables
DataWindowChild idwc_warehouse
DataWindowChild idwc_owner
String	isOrigSql, isOrigOrder, isWhere

boolean ib_order_from_first
boolean ib_order_to_first
end variables

on w_pandora_fastmoving_rpt.create
call super::create
end on

on w_pandora_fastmoving_rpt.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;call super::open;

isOrigSql = dw_report.getsqlselect()





end event

event ue_retrieve;String ls_whcode, ls_sku, lsWhere, lsNewSql, lsFilter, lsGroup, ls_from_date, ls_to_date, ls_fwdpickloc_ind
DateTime ldFromDate, ldtodate
Long ll_balance, i, ll_cnt

If dw_select.AcceptText() = -1 Then Return

SetPointer(HourGlass!)
dw_report.Reset()

ls_whcode = dw_select.GetItemstring(1,"warehouse")
//lsgroup = dw_select.GetItemstring(1,"group")

ldFromDate = dw_select.GetItemDateTime(1,"order_from_date")
//ls_from_date = string(dw_select.GetItemDateTime(1,"order_from_date"),"mm/dd/yyyy hh:mm ")

ldtoDate = dw_select.GetItemDateTime(1,"order_to_date")
//ls_to_date = string(dw_select.GetItemDateTime(1,"order_to_date"),"mm/dd/yyyy hh:mm ")

string ls_owner

ls_owner = dw_select.GetItemString(1,"owner")

IF trim(ls_owner) = "" OR IsNull(ls_owner) THEN
	SetNull(ls_owner)
END IF

ls_fwdpickloc_ind = dw_select.GetItemString(1,"fwd_pickloc_ind")

IF trim(ls_fwdpickloc_ind) = "" OR IsNull(ls_fwdpickloc_ind) THEN
	SetNull(ls_fwdpickloc_ind)
END IF

// 01/01 PCONKL - All search fields are required
If isNull(ls_whcode) or isnull(ldFromDate) or isnull(ldToDate) Then
	Messagebox(is_title,"Warehouse, From & To Date must be entered for this report!")
	Return
End If

ll_cnt = dw_report.Retrieve(gs_project,ls_whcode,ldfromdate,ldtodate,ls_owner,ls_fwdpickloc_ind)

If ll_cnt > 0 Then
	im_menu.m_file.m_print.Enabled = True
	dw_report.Setfocus()
	
	//filter to show rows if requested
	If dw_select.GetItemNumber(1,"number_to_show") > 0 Then
		lsFilter = "c_rownum <= " + String(dw_select.GetItemNumber(1,"number_to_show"))
		dw_report.SetFilter(lsFilter)
		dw_report.Filter()
	End If
	
Else
	im_menu.m_file.m_print.Enabled = False	
	MessageBox(is_title, "No records found!")
	dw_select.Setfocus()
End If



end event

event resize;dw_report.Resize(workspacewidth() - 30,workspaceHeight()-270)
end event

event ue_clear;dw_select.Reset()
dw_select.InsertRow(0)
// pvh - 08/09/05 
ib_order_from_first = TRUE
ib_order_to_first = TRUE




end event

event ue_postopen;call super::ue_postopen;DatawindowChild	ldwc
string	lsFilter, ls_sql, ls_order

isOrigSql =  "SELECT Customer.Project_ID,  Customer.Cust_Code,  Customer.Cust_Name  FROM Customer Where PROJECT_ID = '"+ Upper(gs_Project) + "' " + " AND Customer.Customer_Type = 'WH' "
isOrigOrder =  " ORDER BY Customer.Project_ID ASC,  Customer.Cust_Code ASC "  

//populate dropdowns 

//dw_select.GetChild('warehouse', ldwc)
//ldwc.SetTransObject(Sqlca)
//ldwc.Retrieve(gs_project)


// LTK 20150908  Commented out block above.  Populate warehouse DDDW via common method which uses user's configured warehouses.
dw_select.GetChild("warehouse", ldwc)
ldwc.SetTransObject(sqlca)
g.of_set_warehouse_dropdown(ldwc)

if Len( Trim( gs_default_wh )) > 0 and dw_select.RowCount() > 0 then
	dw_select.SetItem(1, "warehouse", gs_default_wh)
end if


dw_select.GetChild('owner',  idwc_owner)
idwc_owner.SetTransObject(Sqlca)
idwc_owner.Retrieve(gs_project)

/*
//Filter Warehouse dropdown by Current Project
lsFilter = "project_id = '" + gs_project + "'"
ldwc.SetFilter(lsFilter)
ldwc.Filter()

dw_select.GetChild('group', ldwc)
ldwc.SetTransObject(Sqlca)
ldwc.Retrieve()
lsFilter = "project_id = '" + gs_project + "'"
ldwc.SetFilter(lsFilter)
ldwc.Filter()
*/
end event

type dw_select from w_std_report`dw_select within w_pandora_fastmoving_rpt
integer x = 0
integer y = 0
integer width = 3474
integer height = 224
string dataobject = "d_pandora_fastmovng_rpt_select"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event dw_select::constructor;ib_order_from_first 		= TRUE
ib_order_to_first 		= TRUE
end event

event dw_select::clicked;string 	ls_column

long		ll_row

datetime	ldt_begin_date
datetime	ldt_end_date

dw_select.AcceptText()
ls_column 	= DWO.Name
ll_row 		= dw_select.GetRow()

CHOOSE CASE ls_column
		
	CASE "order_from_date"
		
		IF ib_order_from_first THEN
			
			ldt_begin_date = f_get_date("BEGIN")
			dw_select.SetColumn("order_from_date")
			dw_select.SetText(string(ldt_begin_date, "mm/dd/yyyy hh:mm"))
			ib_order_from_first = FALSE
			
		END IF
		
	CASE "order_to_date"
		
		IF ib_order_to_first THEN
			
			ldt_end_date = f_get_date("END")
			dw_select.SetColumn("order_to_date")
			dw_select.SetText(string(ldt_end_date, "mm/dd/yyyy hh:mm"))
			ib_order_to_first = FALSE
			
		END IF
		
	CASE ELSE
		
END CHOOSE

end event

event dw_select::itemchanged;call super::itemchanged;string	lsFilter, ls_column,ls_whcode, ls_owner_cd, ls_display_name, ls_sql
long		ll_row, ll_dddwrow, ll_ownerid

//populate dropdowns 

dw_select.AcceptText()
ls_column 	= DWO.Name
ll_row 		= dw_select.GetRow()

CHOOSE CASE ls_column
		
	CASE "warehouse"
		
		ls_whcode = dw_select.GetItemString(ll_row, ls_column)
		
		idwc_owner.reset( )
		dw_select.SetItem(1,"owner","")
		
		If ls_whcode <> '' Then	
			isWhere = "  and user_field2 = '" + ls_whcode + "'" 
		End if
	
		If isWhere <> '' Then 
			ls_sql = isOrigSql + isWhere
		Else
			ls_sql = isOrigSql
		End if
		ls_sql = ls_sql + isOrigOrder

	
		idwc_owner.SetTransObject(SQLCA)
		idwc_owner.SetSqlSelect(ls_sql)
		//idwc_owner.Retrieve() //07-Jun-2013 :Madhu commented
		idwc_owner.Retrieve(gs_project)  //07-Jun-2013 :Madhu Added
		
	CASE "owner"
	/*	
		 ls_owner_cd = idwc_owner.GetItemString( idwc_owner.GetRow(), "owner_owner_cd" )
		 ll_ownerid = idwc_owner.GetItemNumber( idwc_owner.GetRow(), "owner_owner_id" )
		 ll_dddwrow = idwc_owner.Find( 'owner_owner_id=' + String(ll_ownerid),1,idwc_owner.RowCount())
		If ll_dddwrow > 0 then
			ls_display_name = idwc_owner.GetItemString(ll_dddwrow,'owner_owner_cd')
			//messagebox("dddw row", "OwnerCd: " + ls_owner_cd + " / OwnerID: " + string(ll_ownerid) + " / RowNo:" + String(ll_dddwrow) + " / DisplayName:" + ls_display_name)
			idwc_owner.scrolltorow(ll_dddwrow)
		else
			//messagebox("Could not find row",  "OwnerCd: " + ls_owner_cd + " / OwnerID: " + string(ll_ownerid))
		end if
		dw_select.SetItem(1,"owner",ls_display_name)
		idwc_owner.scrolltorow(ll_dddwrow)
*/
END CHOOSE
	
end event

type cb_clear from w_std_report`cb_clear within w_pandora_fastmoving_rpt
end type

type dw_report from w_std_report`dw_report within w_pandora_fastmoving_rpt
integer x = 18
integer y = 224
integer width = 3474
integer height = 1536
integer taborder = 30
string dataobject = "d_pandora_fastmoving_rpt"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

