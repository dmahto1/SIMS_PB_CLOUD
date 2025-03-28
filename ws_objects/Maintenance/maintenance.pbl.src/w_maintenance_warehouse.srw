$PBExportHeader$w_maintenance_warehouse.srw
$PBExportComments$- warehouse modify
forward
global type w_maintenance_warehouse from w_std_master_detail
end type
type dw_putaway_sort from datawindow within tabpage_main
end type
type st_warehouse from statictext within tabpage_main
end type
type sle_warehouse from singlelineedit within tabpage_main
end type
type dw_warehouse from u_dw_ancestor within tabpage_main
end type
type cb_warehouse_search from commandbutton within tabpage_search
end type
type dw_search from u_dw_ancestor within tabpage_search
end type
type tabpage_location from userobject within tab_main
end type
type cb_insert_loc from commandbutton within tabpage_location
end type
type cb_delete_loc from commandbutton within tabpage_location
end type
type dw_location_search from datawindow within tabpage_location
end type
type cb_search_loc from commandbutton within tabpage_location
end type
type cb_clear_loc from commandbutton within tabpage_location
end type
type dw_location from u_dw_ancestor within tabpage_location
end type
type tabpage_location from userobject within tab_main
cb_insert_loc cb_insert_loc
cb_delete_loc cb_delete_loc
dw_location_search dw_location_search
cb_search_loc cb_search_loc
cb_clear_loc cb_clear_loc
dw_location dw_location
end type
type tabpage_project_warehouse from userobject within tab_main
end type
type cb_putaway_sort from commandbutton within tabpage_project_warehouse
end type
type dw_project_warehouse from u_dw_ancestor within tabpage_project_warehouse
end type
type tabpage_project_warehouse from userobject within tab_main
cb_putaway_sort cb_putaway_sort
dw_project_warehouse dw_project_warehouse
end type
type tabpage_mobile from userobject within tab_main
end type
type dw_mobile from u_dw_ancestor within tabpage_mobile
end type
type tabpage_mobile from userobject within tab_main
dw_mobile dw_mobile
end type
type tabpage_sa from userobject within tab_main
end type
type cb_4 from commandbutton within tabpage_sa
end type
type cb_3 from commandbutton within tabpage_sa
end type
type cb_2 from commandbutton within tabpage_sa
end type
type cb_1 from commandbutton within tabpage_sa
end type
type dw_sa from datawindow within tabpage_sa
end type
type gb_1 from groupbox within tabpage_sa
end type
type tabpage_sa from userobject within tab_main
cb_4 cb_4
cb_3 cb_3
cb_2 cb_2
cb_1 cb_1
dw_sa dw_sa
gb_1 gb_1
end type
end forward

global type w_maintenance_warehouse from w_std_master_detail
integer width = 4251
integer height = 2224
string title = "Warehouse"
boolean clientedge = true
event ue_set_putaway_sort ( )
end type
global w_maintenance_warehouse w_maintenance_warehouse

type variables
Datawindow   idw_main, idw_search,idw_location, idw_project_warehouse, idw_mobile,idw_sa
SingleLineEdit isle_whcode
long ii_row = 0 //get datawindow(search) current rows,
long  ilTabindex
boolean  ib_loc_changed,ib_dimentions
String	isOrigSQL
boolean ib_sa

// pvh 11/22/05
string isWhCode
// pvh - gmt 12/19/05
datastore idsDstCodeLookup
w_maintenance_warehouse iw_window

inet	linit
u_nvo_websphere_post	iuoWebsphere


end variables

forward prototypes
public subroutine wf_convert (ref string as_measure)
public subroutine setgmtdisplay (boolean _switch)
public function boolean dovalidate ()
public subroutine setgmtroledisplay (integer asrole)
public subroutine setgmtadmindisplay (boolean _switch)
public subroutine setwhcode (string _value)
public function string getwhcode ()
public subroutine setrelativedatecode (string _value)
public function string getrelativedatecode ()
public subroutine dosweepertest ()
public function boolean dotestforcontent (long _row)
public function integer wf_validate ()
public function boolean dotestforcontentsummary (long _row)
public function boolean checkfororphancontent ()
end prototypes

event ue_set_putaway_sort();

String	lsSort, lsSortString
Integer	liRC


//Load the current Sort Order
lsSort = idw_project_warehouse.GetITemString(1,'receive_putaway_sort_order')
If isnull(lsSort) or lsSort = ""  Then
	tab_main.tabpage_main.dw_putaway_sort.SetSort("")
Else
	tab_main.tabpage_main.dw_putaway_sort.SetSort(lsSort)
End If

liRC = tab_main.tabpage_main.dw_putaway_sort.Sort()

//Open the sort window
SetNull(lsSortString)
tab_main.tabpage_main.dw_putaway_sort.SetSort(lsSortString)
liRC = tab_main.tabpage_main.dw_putaway_sort.Sort()

//Get the new sort Order
lsSortString = tab_main.tabpage_main.dw_putaway_sort.Describe('datawindow.table.Sort')
If lsSortString = '?' Then lsSortString = ''

idw_project_warehouse.SetItem(1,'receive_putaway_sort_order',lsSortString)


ib_changed = True
idw_project_warehouse.SetItem(1, "last_user", gs_userid)
idw_project_warehouse.SetItem(1, "last_update" ,today())
	
end event

public subroutine wf_convert (ref string as_measure);//This function is used for converting English to Matrics conversion 
//called from itemchange event dw_main

Real lr_length, lr_width,lr_height,lr_cbm,lr_weight
long ll_row
ll_row = idw_location.GetRow()
lr_length = real(idw_location.object.length[ll_row])
lr_width = real(idw_location.object.width[ll_row])
lr_height = real(idw_location.object.height[ll_row])
lr_cbm = real(idw_location.object.cbm[ll_row])
lr_weight=real(idw_location.object.weight_capacity[ll_row])


IF as_measure = 'E' THEN			
	idw_location.object.length[ll_row]= round(g.i_nwarehouse.of_convert(lr_length,'CM','IN'),2)
	idw_location.object.width[ll_row]= round(g.i_nwarehouse.of_convert(lr_width,'CM','IN'),2)
	idw_location.object.height[ll_row]= round(g.i_nwarehouse.of_convert(lr_height,'CM','IN'),2)
	idw_location.object.cbm[ll_row]= round(g.i_nwarehouse.of_convert(lr_cbm,'CM','IN'),2)	
	idw_location.object.weight_capacity[ll_row]= round(g.i_nwarehouse.of_convert(lr_weight,'KG','PO'),2)	
ELSE
	idw_location.object.length[ll_row]= round(g.i_nwarehouse.of_convert(lr_length,'IN','CM'),2)
	idw_location.object.width[ll_row]= round(g.i_nwarehouse.of_convert(lr_width,'IN','CM'),2)
	idw_location.object.height[ll_row]= round(g.i_nwarehouse.of_convert(lr_height,'IN','CM'),2)	
	idw_location.object.cbm[ll_row]= round(g.i_nwarehouse.of_convert(lr_cbm,'IN','CM'),2)
	idw_location.object.weight_capacity[ll_row]= round(g.i_nwarehouse.of_convert(lr_weight,'PO','KG'),2)
END IF	

end subroutine

public subroutine setgmtdisplay (boolean _switch);// setGMTDisplay( boolean _switch )

string sVisible

sVisible = '0'
if _switch then sVisible = '1'

idw_main.object.gb_gmtdata_t.visible = sVisible
idw_main.object.dst_flag.visible = sVisible
idw_main.object.dst_starts_t.visible = sVisible
idw_main.object.gmt_offset.visible = sVisible     
idw_main.object.dststart.visible = sVisible
idw_main.object.dstend.visible = sVisible
idw_main.object.b_testoffset_t.visible = sVisible
idw_main.object.b_gmtsite_t.visible = sVisible
idw_main.object.gmtoffset_t.visible = sVisible
idw_main.object.dst_ends_t.visible = sVisible
end subroutine

public function boolean dovalidate ();// boolean = doValidate()

int _value

if idw_main.rowcount() < 1 then return true

_value = idw_main.object.gmt_offset[ 1 ]

if _value < -14 or _value > 14 then
	messagebox( is_title, "GMT Offset Range ( -14.0 ) to +14.0",exclamation!)
	return false
end if

// for any detail row that has changed, primarily the locatoin code, ensure there is no content record

return true

end function

public subroutine setgmtroledisplay (integer asrole);// setgmtroledisplay( int asRole )

string sVisible
boolean switch

sVisible = '0'
switch = false

if asRole = 0 or asRole = -1 then switch = true
setGMTDisplay( switch )

if asRole = 1 then switch = true
setGMTADMINdisplay( switch )



end subroutine

public subroutine setgmtadmindisplay (boolean _switch);// setGMTADMINdisplay( boolean _switch )

// turn off/on visiblility based on _switch

string sVisible

sVisible = '0'
if _switch then sVisible = '1'

idw_main.object.gb_gmtdata_t.visible = sVisible
idw_main.object.gmtoffset_t.visible = sVisible
idw_main.object.dst_flag.visible = sVisible
idw_main.object.dst_starts_t.visible = sVisible
idw_main.object.dst_ends_t.visible = sVisible
idw_main.object.gmt_offset.visible = sVisible
idw_main.object.dststart.visible = sVisible
idw_main.object.dstend.visible = sVisible
idw_main.object.b_testoffset_t.visible = sVisible
idw_main.object.b_gmtsite_t.visible = sVisible


end subroutine

public subroutine setwhcode (string _value);// setWhCode( string _value )

if isNull( _value ) then _value = ''
isWhCode = _value

end subroutine

public function string getwhcode ();// string = getWhCode()
return isWhCode

end function

public subroutine setrelativedatecode (string _value);// setRelativeDateCode( string _value )

// the code is....

// occurance 1-5 meaning first,2nd,3rd,4th,Last
// daynumber 1-7 sunday = 1, saturday = 7
// monthnumber 1-12 january = 1, December = 12

// code comes in 1104*5110
// 1104 = first, sunday, april
// 5110 = last, sunday, october

// see if the old code matchs the new code
long lrow

if isNull( _value ) or len( _value ) = 0 then _value = '1101'  // default first sunday january
lrow = idsdstcodelookup.getrow()
if lrow > 0 then
	idsdstcodelookup.object.code_descript[ lrow ] = _value
end if




end subroutine

public function string getrelativedatecode ();// string = getRelativeDateCode()

long lRow
string returnValue

returnValue = ''
lrow = idsdstcodelookup.getrow()
if lRow =0 then lRow = idsdstcodelookup.retrieve( gs_project, getWhCode() )
if lRow =0 then
	idsdstcodelookup.reset()
	lRow = idsdstcodelookup.insertrow(0)
	idsdstcodelookup.object.project_id[ lRow ] = gs_project
	idsdstcodelookup.object.code_type[ lRow ] = 'DST'
	idsdstcodelookup.object.code_id[ lRow ] = getwhcode()
	idsdstcodelookup.object.user_updateable_ind[ lRow ] = 'N'	
	idsdstcodelookup.object.code_descript[ lRow ] ='1101*1101'
end if
if lRow > 0 then	returnValue = idsdstcodelookup.object.code_descript[ lRow ]

return returnValue

end function

public subroutine dosweepertest ();// dosweeperTest()


u_nvo_dst_setdates uSetDate

uSetDate = Create u_nvo_dst_setdates
uSetDate.setYear( 2008 )
uSetDate.setDates()
if uSetDate.setDates() < 0 then
	messagebox("uSetDate Test", "Test Failed!")
else
	messagebox("uSetDate Test", "Success!~r~n~r~nDone")
end if


end subroutine

public function boolean dotestforcontent (long _row);// boolean doTestForContent( long _Row )

string location
string warehouse
int lCount

location = idw_location.object.l_code[ _Row ]
warehouse = idw_main.object.wh_code[ 1 ]

// Was checking the content table - KZUV.COM

select Count( sku ) into :lCount
from content
where project_id = :gs_project and
l_code = :location and
wh_code = :warehouse; 
//and avail_qty + component_qty > 0 ;

// Now checking content_summary - KZUV.COM
// dts - 01/12/2011 - added alloc_qty

//TimA - 03/29/11 Moved to ne function dotestforcontentsummary
//select Count( sku ) into :lCount
//from content_summary
//where project_id = :gs_project and
//l_code = :location and
//wh_code = :warehouse and
//avail_qty + alloc_qty > 0 ;

if isNull( lCount ) or lCount = 0 then return false // no content exists

return true
end function

public function integer wf_validate ();Long	ll_cnt
String	ls_loc, ls_ploc
Integer	i


If f_check_required(is_title, idw_main) = -1 Then
	tab_main.SelectTab(1) 
	Return -1
End If

// 01/17 - PCONKL - Validate transaction group. Set as required but a blank passes that test...
If idw_Main.GetITemString(1, 'transaction_group') > '' Then
Else
	Messagebox(is_title,"SIC is required.",StopSign!)
	tab_main.SelectTab(1) 
	idw_main.SetColumn('transaction_Group')
	return -1
End If

//If f_check_required(is_title, idw_location) = -1 Then
//	tab_main.SelectTab(2) 
//	Return -1
//End If

// 07/00 PCONKL - Only validate if we've actually changed a location record
If ib_loc_changed Then
	
	ll_cnt = idw_location.RowCount()
	
	// 11/00 - PCONKL default sort may have been changed, resort by location
	idw_location.SetSort("l_code A")
	//idw_location.Sort()
	
	ls_ploc = "XXXXXXXXXX"
	For i = 1 to ll_cnt 
		
		SetMicroHelp("Checking location record " + String(i) + " of " + String(ll_cnt))
		
		//If validating DIMS, make sure they're entered and Length > width > height...
		If idw_Location.GetITemString(i,'validate_dims_ind') = 'Y' Then
			
			If isnull(idw_Location.GetITemNumber(i,'length')) or idw_Location.GetITemNumber(i,'length') = 0 or &
				isnull(idw_Location.GetITemNumber(i,'width')) or idw_Location.GetITemNumber(i,'width') = 0 or &
				isnull(idw_Location.GetITemNumber(i,'height')) or idw_Location.GetITemNumber(i,'height') = 0  Then
									
					tab_main.selecttab(2)
					f_setfocus(idw_location, i, "length")
					Messagebox(is_title,"If DIMS are Validated, Length, Width and Height must be entered.",StopSign!)
					return -1
				
			Else
				
//				If idw_Location.GetITemNumber(i,'length') < idw_Location.GetITemNumber(i,'width') or &
//					idw_Location.GetITemNumber(i,'length') < idw_Location.GetITemNumber(i,'height') or &
//					idw_Location.GetITemNumber(i,'width') < idw_Location.GetITemNumber(i,'height') Then
//										
//						tab_main.selecttab(2)
//						f_setfocus(idw_location, i, "length")
//						Messagebox(is_title,"Length must be > Width > Height.",StopSign!)
//						return -1
//						
//				End If
				
			End IF
			
			
		End IF
		
		//If validating make sure Weight has been entered
		If idw_Location.GetITemString(i,'validate_weight_ind') = 'Y' Then
			
			If idw_Location.GetITemNumber(i,'weight_capacity')  = 0 or isnull(idw_Location.GetITemNumber(i,'weight_capacity')) Then
								
				tab_main.selecttab(2)
				f_setfocus(idw_location, i, "weight_capacity")
				Messagebox(is_title,"If validating Weight, Weight must be entered.",StopSign!)
				return -1
				
			End If
				
		End If
			
		//Check for dups...
		ls_loc = trim(idw_location.GetItemString(i, "l_code"))
		If ls_loc = ls_ploc Then
			
			tab_main.selecttab(2)
			f_setfocus(idw_location, i, "l_code")
			Messagebox(is_title,"Found duplicate location record, please check!",StopSign!)
			return -1

			//18-Dec-2014 : Madhu -Validate location shouldn't be NULL /BLANK -START
		ELSEIF ls_loc='' or isnull(ls_loc) THEN
			tab_main.selecttab(2)
			f_setfocus(idw_location, i, "l_code")
			Messagebox(is_title,"Location shouldn't be Empty, please check!",StopSign!)
			return -1
			//18-Dec-2014 : Madhu -Validate location shouldn't be NULL /BLANK -END
		End If
		
		
		If IsNull(idw_location.GetItemString(i, "wh_code")) Then
			idw_location.setitem(i,'wh_code', idw_main.GetItemString(1, "wh_code"))
		End If
		
		ls_ploc = ls_loc
		
	Next
	
End If /*location changed*/



Return 0
end function

public function boolean dotestforcontentsummary (long _row);// boolean doTestForContent( long _Row )
//New function created to check for contect summary records
//TimA - 03/29/11 Issue #165

string location
string warehouse
int lCount

location = idw_location.object.l_code[ _Row ]
warehouse = idw_main.object.wh_code[ 1 ]

// dts - 01/12/2011 - added alloc_qty
select Count( sku ) into :lCount
from content_summary
where project_id = :gs_project and
l_code = :location and
wh_code = :warehouse and
avail_qty + alloc_qty > 0 ;

if isNull( lCount ) or lCount = 0 then return false // no content exists

return true
end function

public function boolean checkfororphancontent ();//TimA 03/29/11 Testing a possiblem new function for deleting orphan content records

string ls_l_code, ls_wh_code, ls_sku_parent, ls_sku_child // 03/02/2011 ujh: I-161
long  ll_Count  // 03/02/2011 ujh: I-161
long i
boolean ib_error
Long curr_row
dwitemstatus rowstatus

curr_row = idw_location.GetRow()
//ls_l_code = idw_location.object.l_code[curr_row ] 
//ls_wh_code = idw_main.object.wh_code[ 1 ]   


//ll_Count = idw_location.RowCount()
ll_Count =  idw_location.deletedcount( )

//ll_result = ldsSerial.Update(False, False)

For i = 1 to ll_Count

//ls_l_code = idw_location.object.l_code[i ]  
//ls_wh_code = idw_main.object.wh_code[ 1 ]   
	
//	Update carton_serial
//	set status_cd = 'N', do_no = ''
//	Where project_id = :gs_Project and serial_no = :lsSerial and sku = :lsSKU;
	
//next /*Deleted Row*/

	
	rowstatus =  idw_location.GetItemStatus ( i, 0, Delete! ) //= DataModified! 
		
		idw_location.SetItemStatus ( i, 0, Primary!, NotModified! )
		idw_location.retrieve( i)
		ls_l_code =idw_location.GetItemString(i, 'l_code')
		ls_wh_code = idw_main.object.wh_code[ 1 ]  
	messagebox ('',ls_l_code + '  ' + ls_wh_code)
		
//	End If
Next


/*
if curr_row > 0 then
	if dotestForContentsummary( curr_row ) =  false then  //Fist check the content summary records
		if dotestForContent( curr_row ) then
			//03/02/2011 ujh: I-161 Try to delete content records that may be blocking loc delete due to existing with qty zero
			Execute Immediate "Begin Transaction" using SQLCA;
			Delete content
			where Project_id = :gs_Project
				and wh_code = :ls_wh_code
				and l_code = :ls_l_code
				and avail_qty = 0
				and component_qty = 0
				using SQLCA;
			if  sqlca.SQlcode = 0 then  //Success
				Execute Immediate "COMMIT" using SQLCA;
				return
			else
				// these rows need to be deleted no matter what
				 rollback;
				// If any rows were delted from content, try to delete location again else fall down to error
				if sqlca.Sqlnrows > 0 then
					 parent.postEvent("ue_try_delete_again")
					return
				end if
			end if
			
		//messagebox( is_title, "Content found for selected row, Unable to delete, Please Check.", exclamation! )
		messagebox( is_title, "Inventory found for selected row (either available or allocated). Unable to delete. Please Check.", exclamation! )
		
			return // can't delete a location if content exists.
		end if
	else
		messagebox( is_title, "Inventory found for selected row (either available or allocated). Unable to delete. Please Check.", exclamation! )
		return // can't delete a location if content summary records exists.
	end if
*/	
//	idw_location.deleterow(0)
//	ib_changed = True
//	ib_loc_changed = True /* 07/00 PCONKL - only validate locs if changed*/
//end if


return true
end function

event open;call super::open;iw_window = This
ib_edit = True
ib_changed = False
ib_loc_changed = False
ilHelpTopicID = 534 /*set Help Topic ID*/
tab_main.MoveTab(2, 99) /*search tab to end*/

// pvh - 08/17/06
//is_process = Message.StringParm
istrparms = Message.PowerObjectParm	
if UpperBound( istrparms.string_arg) > 0 then
	is_process = istrparms.string_arg[1]
end if

// Storing into variables
idw_main = tab_main.tabpage_main.dw_warehouse
idw_search = tab_main.tabpage_search.dw_search
isle_whcode = tab_main.tabpage_main.sle_warehouse
idw_location = tab_main.tabpage_location.dw_location
idw_project_warehouse = tab_main.tabpage_project_warehouse.dw_project_warehouse
idw_mobile = tab_main.tabpage_mobile.dw_mobile /* 09/14 - PCONKL*/

idw_main.SetTransObject(Sqlca)
idw_search.SetTransObject(Sqlca)
idw_location.SetTransObject(Sqlca)
idw_project_warehouse.SetTransObject(Sqlca)

tab_main.tabpage_location.dw_location_search.InsertRow(0) /* 11/00 PCONKL*/
isOrigSql = idw_location.GetSqlSelect()

//09/14 - PCONKL - Share Main DW with new MObile DW
idw_Main.ShareData(idw_Mobile)

// change the style of datawindow object
f_datawindow_change (idw_main)
f_datawindow_change(idw_location)

// 07/00 PCONKL - Only a super user can assign a project to a location or insert/delete a project
// pvh - 08/19/05 - added gmt display 
setgmtroledisplay( integer( gs_role ) )

// 02/17 - PCONKL - Only Super Duper users can do this now...
//If gs_role = '0' or gs_role = '-1' Then
If  gs_role = '-1' Then
	idw_location.modify("project_reserved.visible=True project_reserved_t.visible=True")
	im_menu.m_record.m_new.Enable()
Else
	idw_location.modify("project_reserved.visible=False project_reserved_t.visible=False")
	im_menu.m_record.m_new.Disable()
End If

// Default into edit mode
This.TriggerEvent("ue_edit")


end event

on w_maintenance_warehouse.create
int iCurrent
call super::create
end on

on w_maintenance_warehouse.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_edit;// Acess Rights

// pvh - 08/28/06 - already set in open
//is_process = Message.StringParm
If f_check_access(is_process,"E") = 0 Then
	close(w_maintenance_warehouse)
	return
end if

// Looking for unsaved changes
If wf_save_changes() = -1 Then Return	

This.Title = is_title + " - Edit"
ib_edit = True
ib_changed = False
ib_loc_changed = False

// Changing menu properties
im_menu.m_file.m_save.Disable()
im_menu.m_file.m_retrieve.Enable()
im_menu.m_record.m_delete.Disable()
tab_main.tabpage_location.enabled = false
tab_main.tabpage_project_warehouse.enabled = false

idw_main.Reset()
idw_location.reset()
idw_main.Hide()

tab_main.SelectTab(1) 

// Reseting the Single line edit
isle_whcode.DisplayOnly = False
isle_whcode.TabOrder = 10
isle_whcode.Text = ""
isle_whcode.SetFocus()

tab_main.tabpage_project_warehouse.cb_putaway_sort.visible=False



end event

event ue_save;Integer li_ret
String ls_loc, ls_ploc, lswarehouse, lsSort,ls_data
Long ll_cnt, i

IF f_check_access(is_process,"S") = 0 THEN Return 0

SetPointer(Hourglass!)

If idw_main.AcceptText() = -1 Then 
	tab_main.SelectTab(1) 
	idw_main.SetFocus()
	Return -1
End If

If idw_location.AcceptText() = -1 Then 
	tab_main.SelectTab(2) 
	idw_location.SetFocus()
	Return -1
End If

// Begin....12/05/2024....Akash Baghel....SIMS-588... Development for Google – SIMS- Bulk Locations Utilization
	long ll_row 
	ll_row = idw_location.getrow()
	ls_data = idw_location.getitemstring(ll_row, 'user_field2')
	     IF gs_project='PANDORA' then
	       if long(len(ls_data)) > 3 then
		    messagebox('','Please enter the pallet qty less than or equal to 3 digit.')
		     return -1
	        end if
	      END IF
// End....12/05/2024...SIMS-588..Akash Baghel.... Development for Google – SIMS- Bulk Locations Utilization


//TAM - 2017/12/18 - 3pl cc - Added AcceptText to project/warehouse 
If idw_project_warehouse.AcceptText() = -1 Then 
	tab_main.SelectTab(3) 
	idw_project_warehouse.SetFocus()
	Return -1
End If


// pvh - 08/19/05 - validate GMT Offset
if NOT doValidate() then return -1

//Validations
If wf_validate() < 0 Then Return -1

// When updating setting the current user & date

idw_main.SetItem(1,'last_update',Today()) 
idw_main.SetItem(1,'last_user',gs_userid)

// Updating the Datawindow
Execute Immediate "Begin Transaction" using SQLCA;  // 11/22/04 - Turned Autocommit on, requiring 'Begin Transaction'
If idw_main.RowCount() > 0 Then
	SQLCA.DBParm = "disablebind =0"
	li_ret = idw_main.Update(False, False)
	SQLCA.DBParm = "disablebind =1"
Else
	li_ret = 1
End If
SQLCA.DBParm = "disablebind =0"

If li_ret = 1 Then li_ret = idw_location.Update(False, False)
If li_ret = 1 Then li_ret = idw_project_warehouse.Update(False, False)
If li_ret = 1 and idw_main.RowCount() = 0 Then li_ret = idw_main.Update(False, False)
// pvh - gmt 12/20/05
if li_ret = 1 then li_ret = idsdstcodelookup.update( false, false )
SQLCA.DBParm = "disablebind =1"

IF li_ret = 1 THEN
	Execute Immediate "COMMIT" using SQLCA;
	IF Sqlca.Sqlcode = 0 THEN
		idw_location.ResetUpdate()
		idw_main.ResetUpdate()
		// pvh - gmt 12/20/05
		idsdstcodelookup.ResetUpdate()
	//	idw_sa.ResetUpdate() // Dinesh -sa
		//
		SetMicroHelp("Record Saved!")
		tab_main.tabpage_location.enabled = true
		ib_changed = False
		ib_loc_changed = False
		IF ib_edit = False THEN
			ib_edit = True
			This.Title = is_title + " - Edit"
			im_menu.m_file.m_save.Enable()
			im_menu.m_file.m_retrieve.Enable()
			im_menu.m_record.m_delete.Enable()
		END IF
		
		// pvh 02.17.06  // reload the project warehouse
		g.doProjectWarehouseRefresh()
		
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

SetPointer(arrow!)
end event

event ue_delete;call super::ue_delete;Long i, ll_cnt
String	lsWarehouse

If f_check_access(is_process,"D") = 0 Then Return


// 05/00 PCONKL - We need to be able to delete Locations or the entire warehouse depending on which tab is current!
Choose Case iltabIndex
	Case 1 /*warehouse Tab*/
		// Prompting for deletion
		If MessageBox(is_title, "Are you sure you want to delete this WAREHOUSE record",Question!,YesNo!,2) = 2 Then
			Return
		End If
	Case 2 /*location Tab*/
		If idw_location.GetRow() > 0 Then
			If MessageBox(is_title, "Are you sure you want to delete this LOCATION (" + idw_location.GetItemString(idw_location.GetRow(),"l_code") + ") record",Question!,YesNo!,2) = 2 Then
				Return
			End If
		Else /*no row selected*/
			REturn
		End If
	Case Else
		return
End Choose

SetPointer(HourGlass!)

//Delete either the current warehouse record or location record!
Choose Case iltabIndex
	Case 1 /*warehouse Tab*/
		
		ib_changed = False
		tab_main.SelectTab(1)

		// 03/01 PCONKL - no loner always retrieving some or all locations so we must use SQL to delete
		
		lsWarehouse = idw_main.GetITemString(1,'wh_code')
		Delete from location 
		Where wh_code = :lsWarehouse
		Using SQLCA;
		
//		ll_cnt = idw_location.RowCount()
//		For i = ll_cnt to 1 Step -1
//			idw_location.DeleteRow(i)
//		Next

		idw_main.DeleteRow(1)

		If This.Trigger Event ue_save() = 0 Then
			SetMicroHelp("Record	Deleted!")
		Else
			SetMicroHelp("Record	deletion failed!")
		End If

		This.Trigger Event ue_edit()
		
	Case 2 /*location*/
		
		idw_location.DeleteRow(idw_location.Getrow())
		ib_changed = True
		
End Choose


end event

event ue_new;// Acess Rights
If f_check_access(is_process,"N") = 0 Then Return

// Looking for unsaved changes
If wf_save_changes() = -1 Then Return	

This.Title = is_title + " - New"
ib_edit = False
ib_changed = False
ib_loc_changed = False

// Changing menu properties
im_menu.m_file.m_save.Disable()
im_menu.m_file.m_retrieve.Enable()
im_menu.m_record.m_delete.Disable()
tab_main.tabpage_location.enabled = False
tab_main.tabpage_project_warehouse.enabled = False

// Tab properties
tab_main.SelectTab(1)
idw_main.Reset()
idw_project_warehouse.reset()
idw_location.Reset()
idw_main.InsertRow(0)
//idw_main.Hide()
idw_main.Show()

// Reseting the Single line edit
isle_whcode.DisplayOnly = False
isle_whcode.TabOrder = 10
isle_whcode.Text = ""
isle_whcode.SetFocus()

tab_main.tabpage_project_warehouse.cb_putaway_sort.visible=False

end event

event ue_retrieve;call super::ue_retrieve;isle_whcode.TriggerEvent(Modified!)
end event

event ue_postopen;call super::ue_postopen;Long	llCount
String	lsWarehouse
g.of_setwarehouse(True)

//If ony 1 warehouse for project. might as well load it...
Select Count(*) into :llCount
From Project_warehouse
Where Project_id = :gs_Project;

If llCount = 1 Then
	
	Select wh_code into :lsWarehouse
	From Project_warehouse
	Where Project_id = :gs_Project;
	
	isle_whcode.text = lsWarehouse
	isle_whcode.TriggerEvent('modified')
	
End If

// pvh - gmt 12/19/05
if not IsValid( idsDstCodeLookup ) then
	idsDstCodeLookup	= f_datastorefactory("d_warehouse_dstrel_code_lookup")
end if

//09/14 - PCONKL - Only show mobile tab if project Mobile Enabled
if not g.ibMobileEnabled Then
	tab_main.Tabpage_mobile.visible = False
End If

//Begin - Dinesh - S69824 -Google -  SIMS - Saudi Arabia Shipments
If Upper(gs_project) = 'PANDORA' then
	
	if gs_role <> '-1' then
		tab_main.Tabpage_sa.visible = False
		else 
		tab_main.Tabpage_sa.visible = True
	end if
	
else
	
	tab_main.Tabpage_sa.visible = False
End if
//End - Dinesh - S69824 -Google -  SIMS - Saudi Arabia Shipments
end event

event close;call super::close;g.of_setwarehouse(False)
end event

event resize;call super::resize;
tab_main.Resize(workspacewidth(),workspaceHeight())
tab_main.tabpage_location.dw_location.Resize(workspacewidth() - 80,workspaceHeight()-280)
tab_main.tabpage_search.dw_search.Resize(workspacewidth() - 80,workspaceHeight()-200)
end event

event closequery;call super::closequery;
//09/14 - PCONKL - Retrieve the global datastore if warehouse has changed
w_main.setMicroHelp("Updating Warehouse Datastore...")

g.ids_project_warehouse.Retrieve(gs_project)

w_main.setMicroHelp("Ready")
end event

type tab_main from w_std_master_detail`tab_main within w_maintenance_warehouse
event create ( )
event destroy ( )
integer x = 23
integer y = 4
integer width = 4091
integer height = 2012
tabpage_location tabpage_location
tabpage_project_warehouse tabpage_project_warehouse
tabpage_mobile tabpage_mobile
tabpage_sa tabpage_sa
end type

on tab_main.create
this.tabpage_location=create tabpage_location
this.tabpage_project_warehouse=create tabpage_project_warehouse
this.tabpage_mobile=create tabpage_mobile
this.tabpage_sa=create tabpage_sa
call super::create
this.Control[]={this.tabpage_main,&
this.tabpage_search,&
this.tabpage_location,&
this.tabpage_project_warehouse,&
this.tabpage_mobile,&
this.tabpage_sa}
end on

on tab_main.destroy
call super::destroy
destroy(this.tabpage_location)
destroy(this.tabpage_project_warehouse)
destroy(this.tabpage_mobile)
destroy(this.tabpage_sa)
end on

event tab_main::selectionchanged;string ls_code_type
string ls_pnd_wh
ls_pnd_wh='PND_%'
datawindowchild ldwc_warehouse
connect using sqlca;
 
 long ll_ret
 ilTabindex = NewIndex
ls_code_type= 'Saudi_Arabia_Shipment'

tab_main.tabpage_sa.dw_sa.GetChild ( "code_id",ldwc_warehouse )
ldwc_warehouse.SetTransObject (SQLCA)
ldwc_warehouse.Retrieve (ls_pnd_wh)
 
If NewIndex = 2 Then /*Loaction*/
	wf_check_menu(TRUE,'sort')
	idw_current = idw_location
		
	tabpage_location.dw_location_search.SetFocus()
	tabpage_location.dw_location_search.SetColumn("from_loc")
ELSEIF NewIndex = 5 THEN /*retrieve*/
//idw_current = idw_sa
	//tab_main.tabpage_sa.dw_sa.dataobject='d_maintanence_sa_shipments'
	tabpage_sa.dw_sa.SetTransObject(sqlca)
	ll_ret= tabpage_sa.dw_sa.retrieve(ls_code_type)
    IF ll_ret > 0 THEN
		tabpage_sa.dw_sa.retrieve(ls_code_type)
		
	else
		tabpage_sa.dw_sa.insertrow(0)
	end if
//ELSEIF NewIndex = 5 THEN /*Sarch*/  Dinesh - Add tab
ELSEIF NewIndex = 6 THEN /*Sarch*/
		wf_check_menu(TRUE,'sort')
		idw_current =idw_search
Else
	wf_check_menu(FALSE,'sort')
//	SetNull(idw_current)
End If
 
 
end event

type tabpage_main from w_std_master_detail`tabpage_main within tab_main
integer width = 4055
integer height = 1884
string text = " Warehouse "
dw_putaway_sort dw_putaway_sort
st_warehouse st_warehouse
sle_warehouse sle_warehouse
dw_warehouse dw_warehouse
end type

on tabpage_main.create
this.dw_putaway_sort=create dw_putaway_sort
this.st_warehouse=create st_warehouse
this.sle_warehouse=create sle_warehouse
this.dw_warehouse=create dw_warehouse
int iCurrent
call super::create
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_putaway_sort
this.Control[iCurrent+2]=this.st_warehouse
this.Control[iCurrent+3]=this.sle_warehouse
this.Control[iCurrent+4]=this.dw_warehouse
end on

on tabpage_main.destroy
call super::destroy
destroy(this.dw_putaway_sort)
destroy(this.st_warehouse)
destroy(this.sle_warehouse)
destroy(this.dw_warehouse)
end on

type tabpage_search from w_std_master_detail`tabpage_search within tab_main
integer width = 4055
integer height = 1884
cb_warehouse_search cb_warehouse_search
dw_search dw_search
end type

on tabpage_search.create
this.cb_warehouse_search=create cb_warehouse_search
this.dw_search=create dw_search
int iCurrent
call super::create
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_warehouse_search
this.Control[iCurrent+2]=this.dw_search
end on

on tabpage_search.destroy
call super::destroy
destroy(this.cb_warehouse_search)
destroy(this.dw_search)
end on

type dw_putaway_sort from datawindow within tabpage_main
boolean visible = false
integer x = 3296
integer y = 1116
integer width = 201
integer height = 180
integer taborder = 40
string title = "none"
string dataobject = "d_ro_Putaway"
boolean border = false
boolean livescroll = true
end type

type st_warehouse from statictext within tabpage_main
integer x = 78
integer y = 84
integer width = 389
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Warehouse:"
alignment alignment = right!
boolean focusrectangle = false
end type

event constructor;
g.of_check_label_button(this)
end event

type sle_warehouse from singlelineedit within tabpage_main
integer x = 475
integer y = 76
integer width = 617
integer height = 92
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean autohscroll = false
textcase textcase = upper!
integer limit = 10
borderstyle borderstyle = stylelowered!
end type

event modified;String ls_code
Long   ll_rows, &
		llCount

ls_code = This.Text

IF NOT IsNull(ls_code) Or ls_code <> '' THEN
	
	//If gs_role <> '0' Then
	If gs_role = '0' or gs_role = '-1'  Then
	Else
		// 04/01 pconkl - make sure warehouse is available to the current project, unless super user
		Select Count(*) into :llCount
		From project_warehouse
		where project_id = :gs_project and wh_code = :ls_code
		Using SQLCA;
	
		If llCount <=0 Then
			messagebox(is_title,"Warehouse not found, please enter again!")
			isle_whcode.SetFocus()
			isle_whcode.SelectText(1,Len(ls_code))
			Return 0
		End If
	End If /* not a super user*/
		
	ll_rows = idw_main.Retrieve(ls_code)       // Retrieving the entry datawindow	
	IF ib_edit THEN								    // Edit Mode
		IF ll_rows > 0 THEN
			This.DisplayOnly = True
			This.TabOrder = 0			
			//ll_rows = idw_location.Retrieve(ls_code)   11/00 pconkl - locations retrieved when search selected on location tab
			idw_project_warehouse.retrieve(gs_project,ls_code) /* 02/06 - PCOnkl*/
			idw_project_warehouse.TriggerEvent('ue_retrieve_random_cc_stats') /* 09/09 - PCONKL - Retrive the Random CC statistics*/
			idw_main.Show()
			idw_main.SetFocus()
			im_menu.m_file.m_save.Enable()
			// Remove Admin restriction for deletes  KRZ
//			// 04/01 PCONKL - Only super user can delete a warehouse
//			If gs_role = '0' or gs_role = '-1' Then
//				im_menu.m_record.m_delete.Enable()
//			Else
//				im_menu.m_record.m_delete.Disable()
//			End If
			
			tab_main.tabpage_location.enabled = true
			tab_main.tabpage_project_warehouse.enabled = true
			
			tab_main.tabpage_project_warehouse.cb_putaway_sort.visible=True
			tab_main.tabpage_project_warehouse.cb_putaway_sort.bringtoTop=True
			
			// pvh - 10-18-05
			string aflag
			aflag = idw_main.object.trax_enable_ind[ idw_main.getrow() ] 
			if isNull( aflag ) or len( aflag ) = 0 then  idw_main.object.trax_enable_ind[ idw_main.getrow() ]  = 'N'
			aflag = idw_main.object.trax_label_print_dest[ idw_main.getrow() ] 
			if isNull( aflag ) or len( aflag ) = 0 then  idw_main.object.trax_label_print_dest[ idw_main.getrow() ]  = 'N'
			// eom
			
			// pvh - 11/22/05
			setWhCode( ls_code )
			if isNull( idw_main.object.dst_flag[ idw_main.getrow() ] )  then idw_main.object.dst_flag[ idw_main.getrow() ] = 'N'
			if idw_main.object.dst_flag[ idw_main.getrow() ] = 'N' then
				idw_main.object.dststart.Protect=1
				idw_main.object.dstend.Protect=1
			else
				idw_main.object.dststart.Protect=0
				idw_main.object.dstend.Protect=0
			end if
			
			If Pos(iw_window.Title, '[') = 0 Then
				iw_window.Title = iw_window.Title + " [" + idw_main.GetItemString(1,'wh_Code') + "]"
			End IF
			
		ELSE
			MessageBox(is_title, "Warehouse not found, please enter again!", Exclamation!)
			isle_whcode.SetFocus()
			isle_whcode.SelectText(1,Len(ls_code))
  		END IF
	ELSE													  // New Mode
		IF ll_rows > 0 THEN
			MessageBox(is_title, "Record already exist, please enter again", Exclamation!)
			isle_whcode.SetFocus()
			isle_whcode.SelectText(1,Len(ls_code))		
		ELSE
			This.DisplayOnly = True
			This.TabOrder = 0			
			idw_main.Reset()
			idw_main.InsertRow(0)
			idw_main.SetItem(1,"wh_code",ls_code)
			idw_main.Show()
			idw_main.SetFocus()
			im_menu.m_file.m_save.Enable()
			
			// pvh - 10-18-05
			idw_main.object.trax_enable_ind[ idw_main.getrow() ]  = 'N'
			idw_main.object.trax_label_print_dest[ idw_main.getrow() ]  = 'N'
			// eom

			// pvh - 11/22/05
			setWhCode( ls_code )
			idw_main.object.dst_flag[ idw_main.getrow() ] = 'N'
			idw_main.object.dststart.Protect=1
			idw_main.object.dstend.Protect=1

			tab_main.tabpage_project_warehouse.cb_putaway_sort.visible=True
			tab_main.tabpage_project_warehouse.cb_putaway_sort.bringtoTop=True
			
		END IF
	END IF
ELSE
	MessageBox(is_title, "Please enter the Warehouse Code", Exclamation!)
	isle_whcode.SetFocus()
END IF	

// pvh - 08/28/06 - 11/07 - PCONKL - Open up to Admins as well
if gs_role <> '0'  and gs_role <> '1' and gs_role <> '-1' Then
	idw_main.enabled = false
	idw_project_warehouse.enabled = false
end if


end event

type dw_warehouse from u_dw_ancestor within tabpage_main
integer y = 204
integer width = 3991
integer height = 1700
integer taborder = 20
string dataobject = "d_maintanence_warehouse"
boolean border = false
boolean livescroll = false
borderstyle borderstyle = stylebox!
end type

event itemchanged;Long	llCount
String	lsWhCode, lsXML
DEcimal	ldOffset


ib_changed = True



Choose Case Upper(dwo.Name)
		
	case 'DST_FLAG'
		
		if data = 'N' then
			this.object.b_setdst_t.visible = '0'
			this.object.dststart.Protect=1
			this.object.dstend.Protect=1
		else
			this.object.b_setdst_t.visible = '1'
			this.object.dststart.Protect=0
			this.object.dstend.Protect=0
		end if
			
	Case 'USER_FIELD3' /*Pending DO storage Loc*/
		lsWhCode = This.GetItemString(1,'wh_code')
		Choose Case lsWhCode
			Case 'RB-SG','60ALPS','BENOI','BENOI-CLW','BENOI-CMC','WS_BONDED','WS-DP','MBLH','6911','6912','6918','691A','691B','691C','PHILIPS','PHILIPSCLS','PHILIPS-DA','SUN_CBMM','GOLDIN'
				//GailM 9/29/2020 - S50130/F24604/I3002 Singapore PassOut Note - User_Field3 will be auto-populated with 
				Messagebox(is_title,'This field is reserved for auto-populated Singapore~r~nPass-out Note serial number.   Current number~r~nrepresents the latest note serial number.')
				Return 1
			Case Else
				// 07/02 - Pconkl - We are storing the Pending DO storage loc field in USer 3. - Validate if entered
				//							This field is used at Putaway to look for pending Delivery Orders and move required stock to this location
				
				If Data > '' Then /*validate for location */
					lsWhCode = This.GetItemString(1,'wh_code')
					Select Count(*) Into :llCount
					From Location
					Where wh_code = :lsWhCode and l_code = :Data;
					
					If isnUll(llCount) or llCount <=0 Then
						Messagebox(is_title,'Invalid Location for this Warehouse')
						Return 1
					End If
					
				End If
		End Choose
	Case 'TIMEZONE' 
		
		//09/14 - PCONKL - If timezone chaged, update offsets. Update Warehouse tabale and make websphere call which will update offset and then re-retrieve
		if data > '' Then
			
			SetPointer(Hourglass!)
			
			lsWhCode = This.GetItemString(1,'wh_code')
			
			Execute Immediate "Begin Transaction" using SQLCA;
			
			Update warehouse
			Set timezone = :data
			Where wh_code = :lsWhCode
			Using SQLCA;
			
			Execute Immediate "Commit" using SQLCA;
			
			//09/14 - PCONKL - Update warehouse Offsets from Websphere...
			iuoWebsphere = CREATE u_nvo_websphere_post
			linit = Create Inet
			lsXML = iuoWebsphere.uf_request_header("WarehouseOffsetUpdateRequest", "ProjectID='" + gs_Project + "'")
			lsXML = iuoWebsphere.uf_request_footer(lsXML)

			w_main.setMicroHelp("Updating Warehouse Offset times...")

			 iuoWebsphere.uf_post_url(lsXML)
			 
			 Select GMT_Offset into :ldOffset
			 FRom Warehouse
			 Where wh_code = :lsWhCode;
			 
			 This.SetItem(1,'GMT_Offset',ldOffset)
			 
			w_main.setMicroHelp("Ready")
			SetPointer(Arrow!)

		End If
		
End Choose
end event

event process_enter;Send(Handle(This),256,9,Long(0,0))
Return 1

end event

event itemerror;call super::itemerror;return 2
end event

event clicked;call super::clicked;string _timeformat = "dddd, dd mmmm yyyy hh:mm:ss am/pm" 
datetime _local
str_parms lparms
long lRow

this.accepttext()
Choose Case dwo.Name
	case 'b_testoffset_t'
		if ib_changed then
			messagebox( is_Title, "Save Changes First",stopsign! )
			return
		end if
		_local =  f_getlocalworldtime ( getWhCode()  )
		messagebox( 'GMT Offset ' + string(this.object.gmt_offset[ 1 ]) + ' Test', &
							 "Local Time: "  + string( _local , _timeformat ) + &
							'~r~n~r~nClick ~'GMT Site~' to verify result.')
	case 'b_gmtsite_t'
		run( "C:\Program Files\Internet Explorer\iexplore.exe http://wwp.greenwichmeantime.com"	)	
		
	case 'b_timezone' /*09/14 - PCONKL */
		run( "C:\Program Files\Internet Explorer\iexplore.exe http://en.wikipedia.org/wiki/List_of_tz_database_time_zones"	)	
	case 'b_setdst_t'
		
		lparms.string_arg[1] = getRelativeDateCode()
		openwithparm( w_maintenance_warehouse_dst, lparms )
		lparms = message.powerobjectparm
		if isNull( lparms) then return
		
		if lparms.Cancelled = True then return
		
		if Upperbound( lparms.string_arg ) > 0 then
			if lparms.string_arg[1]='CLEAR' then
				lrow = idsdstcodelookup.getrow()
				idsdstcodelookup.deleterow( lRow )
				return
			end if
		end if
			
		if Upperbound( lparms.datetime_arg ) > 1 then
			if NOT isNull( lparms.datetime_arg[1] ) then	tab_main.tabpage_main.dw_warehouse.object.dststart[1] = lparms.datetime_arg[1]
			if NOT isNull( lparms.datetime_arg[2] ) then tab_main.tabpage_main.dw_warehouse.object.dstend[1] = lparms.datetime_arg[2]
		end if
		if Upperbound( lparms.string_arg ) > 0 then
			setRelativeDateCode( lparms.string_arg[1] )
		end if
	
	// testing
	case 'b_sweeper'
		dosweeperTest()
end choose

end event

event constructor;call super::constructor;
//02/17 - PCONKL - Only IT can change SIC or Address
If  gs_role = '-1' Then
	//this.modify("transaction_group.protect=0")
Else
	this.modify("transaction_group.protect=1 wh_name.protect=1 address_1.protect=1 address_2.protect=1 address_3.protect=1 address_4.protect=1 city.protect=1 state.protect=1 zip.protect=1 country.protect=1")
End If
end event

type cb_warehouse_search from commandbutton within tabpage_search
integer x = 23
integer y = 28
integer width = 357
integer height = 108
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Search"
end type

event clicked;SetPointer(Hourglass!)

dw_search.SetRedraw(False)
dw_search.Reset()
ii_row = dw_search.Retrieve(gs_project)
IF ii_row < 1 THEN 
	MessageBox("Database Error","No rows retrieved.")
END IF
dw_search.SetRedraw(True)
SetPointer(Arrow!)

end event

event constructor;
g.of_check_label_button(this)
end event

type dw_search from u_dw_ancestor within tabpage_search
integer x = 27
integer y = 148
integer width = 3269
integer height = 1516
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_maintenance_warehouse_search"
boolean vscrollbar = true
end type

event doubleclicked;// Pasting the record to the main entry datawindow
IF Row > 0 THEN
	w_maintenance_warehouse.TriggerEvent("ue_edit")
	IF NOT ib_changed THEN
		isle_whcode.Text = This.GetItemString(row,"wh_code")
		// pvh - gmt 12/20/05
		setwhcode( isle_whcode.Text  )
		idsdstcodelookup.reset()
		isle_whcode.TriggerEvent("modified")
	END IF
END IF

integer liOffset
datetime ldtWHTime
string lsWHTime, lsDSTFlag
date ldtDSTStart, ldtDSTEnd

			string lsWarehouse
lsWarehouse = isle_whcode.Text
//messagebox ("local world time", string(f_getLocalWorldTime(lsWarehouse)))
//messagebox ("hour NOW", string(hour(now())))

				select gmt_offset, DST_Flag, dylght_svngs_time_Start, dylght_svngs_time_end into :liOffset, :lsDSTFlag, :ldtDSTStart, :ldtDSTEnd
				from warehouse
				where wh_code = :lsWarehouse;
				if lsDSTFlag = 'Y' and today() >= ldtDSTStart and today()<= LdtDSTEnd then
					liOffset = liOffset + 1
				end if
				if hour(now()) > -liOffset then
					ldtWHTime = datetime(today(), RelativeTime(now(), liOffset*60*60))
				else
					ldtWHTime = datetime(today(), RelativeTime(now(), liOffset*60*60))
				end if
//messagebox ("NOW + offset", string(hour(now()) + liOffset))
//messagebox ("wh Time", string(ldtWHTime))
//				lsWHTime = String(Today(), "m/d/yy hh:mm")
//				ldtWHTime = datetime(lsWHTime) + liOffset/24
			//	idsPOheader.SetItem(llNewRow, 'ord_date', ldtWHTime) 


end event

event clicked;call super::clicked;setredraw(false)
selectrow(0,false)
selectrow(row,true)
setredraw( true )

end event

type tabpage_location from userobject within tab_main
event create ( )
event destroy ( )
event ue_try_delete_again ( )
integer x = 18
integer y = 112
integer width = 4055
integer height = 1884
long backcolor = 79741120
string text = "Location"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 553648127
cb_insert_loc cb_insert_loc
cb_delete_loc cb_delete_loc
dw_location_search dw_location_search
cb_search_loc cb_search_loc
cb_clear_loc cb_clear_loc
dw_location dw_location
end type

on tabpage_location.create
this.cb_insert_loc=create cb_insert_loc
this.cb_delete_loc=create cb_delete_loc
this.dw_location_search=create dw_location_search
this.cb_search_loc=create cb_search_loc
this.cb_clear_loc=create cb_clear_loc
this.dw_location=create dw_location
this.Control[]={this.cb_insert_loc,&
this.cb_delete_loc,&
this.dw_location_search,&
this.cb_search_loc,&
this.cb_clear_loc,&
this.dw_location}
end on

on tabpage_location.destroy
destroy(this.cb_insert_loc)
destroy(this.cb_delete_loc)
destroy(this.dw_location_search)
destroy(this.cb_search_loc)
destroy(this.cb_clear_loc)
destroy(this.dw_location)
end on

event ue_try_delete_again();

// 03/02/2011 ujh: I-161

tab_main.tabpage_location.cb_delete_loc.TriggerEvent(clicked!)
end event

type cb_insert_loc from commandbutton within tabpage_location
integer x = 9
integer y = 32
integer width = 375
integer height = 80
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Insert Row"
end type

event clicked;
Long ll_row

idw_location.SetFocus()

If idw_location.AcceptText() = -1 Then Return

idw_location.setcolumn('l_code')

ll_row = idw_location.GetRow()
If ll_row > 0 Then
	ll_row = idw_location.InsertRow(ll_row + 1)
	idw_location.ScrollToRow(ll_row)
Else
	ll_row = idw_location.InsertRow(0)
End If
dw_location.object.standard_of_measure[ll_row]= g.is_std_mesure
dw_location.object.location_available_ind[ll_row]= 'Y'

//09/09 - PCONKL - Assign a random number for random cycle counts
dw_location.object.cc_rnd_loc_Nbr[ll_row]= rand(32767)
dw_location.object.cc_rnd_cnt_ind[ll_row]= 'N' /*note yest counted in this cycle*/

ib_loc_changed = True /* 07/00 PCONKL - only validate locs if changed*/


end event

event constructor;
g.of_check_label_button(this)
end event

type cb_delete_loc from commandbutton within tabpage_location
integer x = 398
integer y = 32
integer width = 375
integer height = 80
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Delete Row"
end type

event clicked;string ls_l_code, ls_wh_code, ls_sku_parent, ls_sku_child // 03/02/2011 ujh: I-161
long  ll_Count  // 03/02/2011 ujh: I-161
boolean ib_error
Long curr_row

curr_row = idw_location.GetRow()
ls_l_code = idw_location.object.l_code[curr_row ]  // 03/02/2011 ujh: I-161
ls_wh_code = idw_main.object.wh_code[ 1 ]   // 03/02/2011 ujh: I-161

//TimA - 03/30/11 Pandora issue #161
if curr_row > 0 then
	if dotestForContentsummary( curr_row ) =  false then  //Fist check the content summary records
		//No Content Summary records found
		if dotestForContent( curr_row ) then 
			//If content records found this means there is no content summary records so delete the zero quanities
			Execute Immediate "Begin Transaction" using SQLCA;
			Delete content
			where Project_id = :gs_Project
				and wh_code = :ls_wh_code
				and l_code = :ls_l_code
				and avail_qty = 0
				and component_qty = 0
				using SQLCA;
			if  sqlca.SQlcode = 0 then  //Success
				Execute Immediate "COMMIT" using SQLCA;
			else
				Execute Immediate "ROLLBACK" using SQLCA;
	      		MessageBox('Error deleting inventory', SQLCA.SQLErrText)
				Return
				// If any rows were delted from content, try to delete location again else fall down to error
				//if sqlca.Sqlnrows > 0 then
				//	 parent.postEvent("ue_try_delete_again")
				//	return
				//end if
			end if
			
			idw_location.deleterow(curr_row)
			ib_changed = True
			ib_loc_changed = True /* 07/00 PCONKL - only validate locs if changed*/			
			//messagebox( is_title, "Content found for selected row, Unable to delete, Please Check.", exclamation! )
			//messagebox( is_title, "Inventory found for selected row (either available or allocated). Unable to delete. Please Check.", exclamation! )
			return // can't delete a location if content exists.
		else
			string lsFind
			long llFindRow
			//lsFind = "wh_code = '" + ls_wh_code +"' and " + "l_Code = '" + ls_l_code +"'"
			//llFindRow = idw_location.Find(lsFind,1,idw_location.RowCOunt())
			//idw_location.DeleteRow(llFindRow)
			idw_location.deleterow(curr_row)
			ib_changed = True
			ib_loc_changed = True /* 07/00 PCONKL - only validate locs if changed*/			
			
		end if
	else
		messagebox( is_title, "Inventory found for selected row (either available or allocated). Unable to delete. Please Check.", exclamation! )
		return // can't delete a location if content summary records exists.
	end if
end if

end event

event constructor;
g.of_check_label_button(this)
end event

type dw_location_search from datawindow within tabpage_location
event ue_fix_and_try_delete_again ( )
integer x = 901
integer y = 16
integer width = 1806
integer height = 116
integer taborder = 40
boolean bringtotop = true
string dataobject = "d_location_search"
boolean border = false
boolean livescroll = true
end type

event ue_fix_and_try_delete_again();

long ujhtest
ujhtest = 2

//tab_main.tabpage_location.

cb_delete_loc.TriggerEvent(clicked!)
end event

event constructor;
g.of_check_label(this)
end event

type cb_search_loc from commandbutton within tabpage_location
integer x = 2752
integer y = 20
integer width = 283
integer height = 96
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Search"
end type

event clicked;
String	lsWhere,	&
			lsNewSql
Integer	liRC

// 11/00 PCONKL - added search ability for Locations

//Warehouse is always dynamically loaded

dw_location_search.AcceptText()

LsWhere = " Where wh_code = '" + idw_main.GetItemString(1,"wh_code") + "'"

//Tackon Zone if present
If not isnull(dw_location_search.GetItemString(1,"zone_id")) Then
	lsWhere += " and zone_id = '" + dw_location_search.GetItemString(1,"zone_id") + "'"
End If

//Tackon From Location if present
If not isnull(dw_location_search.GetItemString(1,"from_loc")) Then
	lsWhere += " and l_code >= '" + dw_location_search.GetItemString(1,"from_loc") + "'"
End If

//Tackon To Location if present
If not isnull(dw_location_search.GetItemString(1,"to_loc")) Then
	lsWhere += " and l_code <= '" + dw_location_search.GetItemString(1,"to_loc") + "'"
End If

//Set Sql and Retrieve
lsNewSql = isOrigSQL + lsWhere
LiRC = idw_location.SetSqlSelect(lsNewSQL)

idw_location.Retrieve()

If idw_location.RowCount() <=0 Then
	Messagebox(is_title,"No Location records were found matching your criteria!")
End If
end event

event constructor;
g.of_check_label_button(this)
end event

type cb_clear_loc from commandbutton within tabpage_location
integer x = 3067
integer y = 20
integer width = 247
integer height = 96
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Clear"
end type

event clicked;
dw_location_search.Reset()
dw_location.Reset()
dw_location_search.InsertRow(0)
dw_location_search.SetFocus()
dw_location_search.SetColumn("from_loc")
end event

event constructor;
g.of_check_label_button(this)
end event

type dw_location from u_dw_ancestor within tabpage_location
event ue_calc_cbm ( )
integer x = 5
integer y = 148
integer width = 3653
integer height = 1692
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_maintanence_location"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event ue_calc_cbm();
Long	llRow

llRow = This.getRow()

If llRow = 0 Then return

This.SetItem(llRow,'cbm',This.GetITemNumber(llRow,'length') * This.GetITemNumber(llRow,'width') * This.GetITemNumber(llRow,'height'))
end event

event itemchanged;string  ls_sku
ib_loc_changed = True /* 07/00 PCONKL - only validate locs if changed*/
ib_changed = True
This.SetItem(row, "last_user", gs_userid)
This.SetItem(row, "last_update" ,today())
CHOOSE CASE dwo.name
	CASE 'standard_of_measure'
		IF ib_dimentions THEN 
			MessageBox(is_title,"Please Save the Changes first")
			ib_dimentions= False
			Return 2
		END IF	
			
		IF This.object.standard_of_measure.Original[row] <> data THEN
		 		wf_convert(data) //dgm 031601
		ELSE
			This.object.length[row]=This.object.length.Original[row]
			This.object.height[row]=This.object.height.Original[row]
			This.object.width[row]=This.object.width.Original[row]
			This.object.cbm[row]=This.object.cbm.Original[row]
   		This.object.weight_capacity[row]=This.object.weight_capacity.Original[row]
		END IF
	
	CASE 'height','width','length','cbm','weight_capacity'
		ib_dimentions = TRUE		// This is to ensure save messagebox
		This.PostEvent('ue_calc_cbm')
	
	// Begin....11/27/2024....Akash Baghel..SIMS-588... Development for Google – SIMS- Bulk Locations Utilization
	CASE 'user_field2' 
	     IF gs_project='PANDORA' then
	       if long(len(data)) > 3 then
		    messagebox('','Please enter the pallet qty less than or equal to 3 digit.')
		     return -1
	        end if
	      END IF
			
	// END....11/27/2024....Akash Baghel....SIMS-588... Development for Google – SIMS- Bulk Locations Utilization
	
		
// Added SKU Reserved to Screen and Edit for valid SKU
	CASE 'sku_reserved'
		
		If isnull(data) or data = '' Then Return
		
		/* dts - 07/21/05 - added 'min' to Select so that sku's with 
		multiple suppliers return only one record, and then check ls_sku
		instead of sqlca.sqlcode (multiple records result in sqlcode = -1) */
		Select min(sku)
		Into :ls_sku
		From item_master
		Where project_id = :gs_project and
				sku = :data;
		
		//If sqlca.sqlcode <> 0 Then
		if isnull(ls_sku) then
				MessageBox(is_title, "Invalid SKU, please re-enter!")
				Return 1
		End If
		
			
END CHOOSE




end event

event process_enter;IF This.GetColumnName() = "user_field3" THEN
	IF This.GetRow() = This.RowCount() THEN
		tab_main.tabpage_location.cb_insert_loc.TriggerEvent(Clicked!)
	Else
		Send(Handle(This),256,9,Long(0,0))
	END IF
ELSE
	Send(Handle(This),256,9,Long(0,0))
End If

Return 1
end event

event constructor;call super::constructor;
DatawindowChild	ldwc

This.GetChild('storage_type_cd',ldwc)
ldwc.SetTransObject(SQLCA)
ldwc.Retrieve(gs_Project)
If ldwc.RowCount() = 0 Then ldwc.insertRow(0)

This.GetChild('equipment_type_cd',ldwc)
ldwc.SetTransObject(SQLCA)
ldwc.Retrieve(gs_Project)
If ldwc.RowCount() = 0 Then ldwc.insertRow(0)
end event

event sqlpreview;call super::sqlpreview;//messagebox('',sqlsyntax)

end event

type tabpage_project_warehouse from userobject within tab_main
integer x = 18
integer y = 112
integer width = 4055
integer height = 1884
long backcolor = 79741120
string text = "Project/Warehouse"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
cb_putaway_sort cb_putaway_sort
dw_project_warehouse dw_project_warehouse
end type

on tabpage_project_warehouse.create
this.cb_putaway_sort=create cb_putaway_sort
this.dw_project_warehouse=create dw_project_warehouse
this.Control[]={this.cb_putaway_sort,&
this.dw_project_warehouse}
end on

on tabpage_project_warehouse.destroy
destroy(this.cb_putaway_sort)
destroy(this.dw_project_warehouse)
end on

type cb_putaway_sort from commandbutton within tabpage_project_warehouse
integer x = 59
integer y = 204
integer width = 526
integer height = 92
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Putaway Sort Order:"
end type

event clicked;
w_maintenance_warehouse.triggerEvent('ue_set_putaway_sort')
end event

event constructor;
g.of_check_label_button(this)
end event

type dw_project_warehouse from u_dw_ancestor within tabpage_project_warehouse
event ue_retrieve_random_cc_stats ( )
event ue_calc_cc_locs ( )
integer x = 23
integer y = 44
integer width = 3314
integer height = 1804
integer taborder = 20
string dataobject = "d_maintenance_warehouse_project"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event ue_retrieve_random_cc_stats();
String	lsProject, lsWarehouse
Long		llTotal, llAlready, llRemain,llInprogress



If This.RowCount() > 0 Then
	
	lsProject = This.GetITemSTring(1,'Project_id')
	lsWarehouse = This.GEtITemSTring(1,'wh_code')
	
	Select Count(*) into :llTotal
	From Location
	Where  wh_code = :lsWarehouse and location_available_ind = 'Y';
	
	Select Count(*) into :llAlready
	From Location
	Where  wh_code = :lsWarehouse and location_available_ind = 'Y' and cc_rnd_cnt_ind = 'Y';
	
	Select Count(*) into :llInprogress
	From Location
	Where  wh_code = :lsWarehouse and location_available_ind = 'Y' and cc_rnd_cnt_ind = 'X';
	
	Select Count(*) into :llRemain
	From Location
	Where  wh_code = :lsWarehouse and location_available_ind = 'Y' and (cc_rnd_cnt_ind = 'N' or cc_rnd_cnt_ind is null);
	
	This.SetItem(1,'c_loc_count',llTotal)
	This.SetItem(1,'c_already_counted',llAlready)
	This.SetItem(1,'c_remaining_to_Count',llRemain)
	This.SetItem(1,'c_inprogress_Count',llInprogress)
	
End If
end event

event ue_calc_cc_locs();
If This.GetITemNumber(1,'cc_rnd_cnt_Freq') > 0 and This.GetITemNumber(1,'cc_rnd_num_wrk_days') > 0 Then
	
	This.SetITem(1,'cc_rnd_loc_Cnt',Round((This.GetITemNumber(1,'c_loc_count') * This.GetITemNumber(1,'cc_rnd_cnt_Freq')) / This.GetITemNumber(1,'cc_rnd_num_wrk_days') + .5,0))
	
End IF
end event

event itemchanged;call super::itemchanged;
ib_changed = True
This.SetItem(row, "last_user", gs_userid)
This.SetItem(row, "last_update" ,today())


// 09/09 - PCONKL - Recalc Random CC locations to count
If dwo.name = "cc_rnd_cnt_freq" or dwo.name = "cc_rnd_num_wrk_days" Then
	This.PostEvent('ue_Calc_cc_locs')
End If



end event

type tabpage_mobile from userobject within tab_main
integer x = 18
integer y = 112
integer width = 4055
integer height = 1884
long backcolor = 79741120
string text = "Mobile"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_mobile dw_mobile
end type

on tabpage_mobile.create
this.dw_mobile=create dw_mobile
this.Control[]={this.dw_mobile}
end on

on tabpage_mobile.destroy
destroy(this.dw_mobile)
end on

type dw_mobile from u_dw_ancestor within tabpage_mobile
integer y = 28
integer width = 3419
integer height = 1788
integer taborder = 20
string dataobject = "d_maintenance_warehouse_mobile"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event itemchanged;call super::itemchanged;
ib_changed = True
end event

type tabpage_sa from userobject within tab_main
integer x = 18
integer y = 112
integer width = 4055
integer height = 1884
long backcolor = 79741120
string text = "Saudi Arabia Shipment"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
cb_4 cb_4
cb_3 cb_3
cb_2 cb_2
cb_1 cb_1
dw_sa dw_sa
gb_1 gb_1
end type

on tabpage_sa.create
this.cb_4=create cb_4
this.cb_3=create cb_3
this.cb_2=create cb_2
this.cb_1=create cb_1
this.dw_sa=create dw_sa
this.gb_1=create gb_1
this.Control[]={this.cb_4,&
this.cb_3,&
this.cb_2,&
this.cb_1,&
this.dw_sa,&
this.gb_1}
end on

on tabpage_sa.destroy
destroy(this.cb_4)
destroy(this.cb_3)
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.dw_sa)
destroy(this.gb_1)
end on

type cb_4 from commandbutton within tabpage_sa
integer x = 1509
integer y = 68
integer width = 402
integer height = 112
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Retrieve"
end type

event clicked;// Begin - Dinesh - 07042022- S69824- Google -  SIMS - Saudi Arabia Shipments
string ls_code_type
ls_code_type='SAUDI_ARABIA_SHIPMENT'
ib_sa= false
connect using sqlca;
tab_main.tabpage_sa.dw_sa.dataobject='d_maintanence_sa_shipments_list'
tab_main.tabpage_sa.dw_sa.SetTransObject(sqlca)
tab_main.tabpage_sa.dw_sa.retrieve(ls_code_type)
// Begin - Dinesh - 07042022- S69824- Google -  SIMS - Saudi Arabia Shipments

end event

type cb_3 from commandbutton within tabpage_sa
integer x = 695
integer y = 64
integer width = 402
integer height = 112
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Save"
end type

event clicked;
// Begin - Dinesh - S69824- Google -  SIMS - Saudi Arabia Shipments
string ls_code_type
long ll_k
connect using sqlca;
tab_main.tabpage_sa.dw_sa.SetTransObject(sqlca)
ll_k=tab_main.tabpage_sa.dw_sa.update()

IF ll_k <> 1 THEN
	 MessageBox("Error",'This warehouse code is already exists in the lookup table')
	 return
else
	ls_code_type='SAUDI_ARABIA_SHIPMENT'
	tab_main.tabpage_sa.dw_sa.dataobject='d_maintanence_sa_shipments_list'
	tab_main.tabpage_sa.dw_sa.SetTransObject(sqlca)
	tab_main.tabpage_sa.dw_sa.retrieve(upper(ls_code_type))
	ib_sa= false
end if
 


// End - Dinesh - S69824- Google -  SIMS - Saudi Arabia Shipments
end event

type cb_2 from commandbutton within tabpage_sa
integer x = 160
integer y = 64
integer width = 517
integer height = 112
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Insert Warehouse"
end type

event clicked;// Begin - Dinesh - S69824- Google -  SIMS - Saudi Arabia Shipments

Long ll_row
datawindowchild ldwc_warehouse
string ls_pnd_wh
ls_pnd_wh='PND_%'
dw_sa.SetFocus()
long ll_retn
//If idw_sa.AcceptText() = -1 Then Return
connect using sqlca;

tab_main.tabpage_sa.dw_sa.SetTransObject(sqlca)
tab_main.tabpage_sa.dw_sa.dataobject='d_maintanence_sa_shipments'
ll_row = tab_main.tabpage_sa.dw_sa.GetRow()
tab_main.tabpage_sa.dw_sa.GetChild ( "code_id",ldwc_warehouse )
ldwc_warehouse.SetTransObject (SQLCA)
ldwc_warehouse.Retrieve (ls_pnd_wh)
If ll_row > 0 Then
	ll_row = tab_main.tabpage_sa.dw_sa.InsertRow(ll_row + 1)
	tab_main.tabpage_sa.dw_sa.ScrollToRow(ll_row)
	tab_main.tabpage_sa.dw_sa.setitem(ll_row,'Project_id','PANDORA')
	tab_main.tabpage_sa.dw_sa.setitem(ll_row,'Code_Type','SAUDI_ARABIA_SHIPMENT')
	tab_main.tabpage_sa.dw_sa.setitem(ll_row,'Code_Descript','Allow_Saudi_Arabia_Shipment')
Else
	ll_row = tab_main.tabpage_sa.dw_sa.InsertRow(0)
	tab_main.tabpage_sa.dw_sa.setitem(ll_row,'Project_id','PANDORA')
	tab_main.tabpage_sa.dw_sa.setitem(ll_row,'Code_Type','SAUDI_ARABIA_SHIPMENT')
	tab_main.tabpage_sa.dw_sa.setitem(ll_row,'Code_Descript','Allow_Saudi_Arabia_Shipment')
end if
ib_sa= True

// End - Dinesh - S69824- Google -  SIMS - Saudi Arabia Shipments

end event

type cb_1 from commandbutton within tabpage_sa
integer x = 1929
integer y = 68
integer width = 526
integer height = 116
integer taborder = 50
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Delete warehouse"
end type

event clicked;// Begin - Dinesh - S69824- Google -  SIMS - Saudi Arabia Shipments
string ls_code_type,ls_code_id
long ll_row,ll_ret
ls_code_type='SAUDI_ARABIA_SHIPMENT'
connect using sqlca;

tab_main.tabpage_sa.dw_sa.setredraw(True)
ll_row=tab_main.tabpage_sa.dw_sa.getrow()
ls_code_id= tab_main.tabpage_sa.dw_sa.getitemstring(ll_row,'code_id')
tab_main.tabpage_sa.dw_sa.SetTransObject(sqlca)
tab_main.tabpage_sa.dw_sa.retrieve(ls_code_type)

IF ll_row <= 0 then
	 Messagebox('Alert','Please select the row you want to delete the warehouse')	
	 return
end if

IF ll_row > 0 THEN
	tab_main.tabpage_sa.dw_sa.SelectRow(0, FALSE)
	tab_main.tabpage_sa.dw_sa.SelectRow(ll_row, TRUE)
END IF

if ll_row> 0 then
	
	If Messagebox('Alert','Delete Warehouse from the Lookup table.~r~rAre you sure, You want to delete WH code (' + ls_code_id + ') ?',Question!,YesNo!,2) = 2 Then
		return
	End If
end if
ll_ret=tab_main.tabpage_sa.dw_sa.deleterow(ll_row)
tab_main.tabpage_sa.dw_sa.update()
tab_main.tabpage_sa.dw_sa.retrieve(ls_code_type)
ib_sa= false

// End - Dinesh - S69824- Google -  SIMS - Saudi Arabia Shipments
end event

type dw_sa from datawindow within tabpage_sa
integer x = 146
integer y = 228
integer width = 3826
integer height = 1152
integer taborder = 40
string title = "none"
string dataobject = "d_maintanence_sa_shipments"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
end type

event clicked;
if ib_sa= false then

	if row > 0 then
		tab_main.tabpage_sa.dw_sa.SelectRow(0, FALSE)
		tab_main.tabpage_sa.dw_sa.SelectRow(row, TRUE)
	end if
	
end if
	

end event

type gb_1 from groupbox within tabpage_sa
integer x = 137
integer y = 8
integer width = 2373
integer height = 212
integer taborder = 50
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
borderstyle borderstyle = stylebox!
end type

