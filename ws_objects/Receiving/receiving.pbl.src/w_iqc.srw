$PBExportHeader$w_iqc.srw
$PBExportComments$*+receiving order
forward
global type w_iqc from w_std_master_detail
end type
type dw_iqc_stats from datawindow within tabpage_main
end type
type st_1 from statictext within tabpage_main
end type
type sle_sku from singlelineedit within tabpage_main
end type
type dw_iqc from u_dw_ancestor within tabpage_main
end type
type dw_search_result from u_dw_ancestor within tabpage_search
end type
type cb_search from commandbutton within tabpage_search
end type
type dw_search_entry from datawindow within tabpage_search
end type
end forward

global type w_iqc from w_std_master_detail
integer width = 3351
integer height = 1964
string title = "Initial Quality Control (IQC)"
end type
global w_iqc w_iqc

type variables

w_iqc iw_window

SingleLineEdit isle_code

DataWindow Idw_Main, Idw_Search, Idw_Result, idw_stats

String isOrigSQL_Result, isOrigSQL_Stats, is_rono, is_SKU, is_UF1

long il_lineno

end variables

forward prototypes
public subroutine wf_clear_screen ()
public function integer wf_validation ()
end prototypes

public subroutine wf_clear_screen ();idw_main.Reset()
tab_main.SelectTab(1) 
idw_main.Hide()
idw_stats.Hide()

//isle_code.Text = ""
isle_code.visible = true
isle_code.SetFocus()

is_rono = ''
il_lineno = 0
Return

end subroutine

public function integer wf_validation ();
If idw_main.AcceptText() = -1 Then 
	tab_main.SelectTab(1) 
	idw_main.SetFocus()
	Return -1
End If
  
SetPointer(Hourglass!)
w_main.SetMicroHelp('Validating Data...')

// Check if all required fields are filled

If f_check_required(is_title, idw_main) = -1 Then
	tab_main.SelectTab(1) 
	Return -1
End If

//Other Required Fields
/*
If isnull(idw_main.GetItemString(1,'wh_code')) or idw_main.GetItemString(1,'wh_code') = '' Then
	messagebox(is_title, 'Warehouse is Required')
	tab_main.SelectTab(1) 
	idw_main.SetFocus()
	idw_main.SetColumn('wh_Code')
	Return -1
End If
*/

//ls_whcode = idw_main.getitemstring(1,'wh_code')			

SetPointer(Arrow!)

return 0
end function

on w_iqc.create
int iCurrent
call super::create
end on

on w_iqc.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_postopen;call super::ue_postopen;DatawindowChild ldwc //, ldwc2

iw_window = This

//iu_Shipments = Create u_nvo_shipments

tab_main.MoveTab(2, 99) /* search tab alwasy last*/

// Tabs/DW's assigned to Variables
idw_main = tab_main.tabpage_main.dw_iqc
idw_stats = tab_main.tabpage_main.dw_IQC_Stats

idw_Search = tab_main.tabpage_search.dw_search_entry
idw_Result = tab_main.tabpage_search.dw_search_result
idw_result.SetTransObject(Sqlca)

isle_Code = Tab_main.tabpage_main.sle_sku

//Retrieve DDDWS
//Warehouse
idw_search.GetChild("wh_code",ldwc)
ldwc.SetTransObject(SQLCA)
g.of_set_warehouse_dropdown(ldwc) /* load from User Warehouse DS */

idw_main.GetChild("inspection_level",ldwc)
ldwc.SetTransObject(sqlca)
ldwc.Retrieve(gs_project,'IQCIL')

idw_main.GetChild("failure_category",ldwc)
ldwc.SetTransObject(sqlca)
ldwc.Retrieve(gs_project,'IQCFC')

idw_main.GetChild("cause",ldwc)
ldwc.SetTransObject(sqlca)
ldwc.Retrieve(gs_project, 'IQCCC')

/*
//Share Warehouse with Info Tab
idw_main.GetChild("wh_code",ldwc2)
ldwc.ShareData(ldwc2)
*/

isOrigSql_Result = idw_result.GetSqlSelect() /* orig SQL for Search Criteria */
//? isOrigSql_Stats = idw_Stats.GetSqlSelect() /* orig SQL for Search Criteria */
//? why isn't idw_Stats.GetSqlSelect() working?
isOrigSql_Stats = idw_Result.GetSqlSelect() /* orig SQL for Search Criteria */

idw_search.InsertRow(0)
idw_stats.InsertRow(0)

This.TriggerEvent("ue_edit")

// We may be coming from RO with a selected Detail Line
If UpperBound(Istrparms.String_arg) > 0 Then // Order/Line selected

	//dw_1.SetITem(1,'po_uom',Istrparms.String_arg[1])
	If Istrparms.String_arg[2] > '' Then
		//is_rono = Istrparms.String_arg[1]
		is_rono = Istrparms.String_arg[2]
		il_LineNo = Istrparms.Long_arg[3]
		is_sku = Istrparms.String_arg[4]
		//what about nulls?
		is_UF1 = Istrparms.String_arg[5]
		This.TriggerEvent('ue_retrieve')
	End If
End If

end event

event ue_edit;call super::ue_edit;// Acess Rights

// Looking for unsaved changes
If wf_save_changes() = -1 Then Return	

This.Title = is_title + " - Edit"
ib_edit = True
ib_changed = False

// Changing menu properties
//im_menu.m_file.m_save.Disable()
im_menu.m_file.m_retrieve.Enable()
im_menu.m_record.m_delete.Disable()

//? wf_clear_screen()

//TEMP isle_code.Visible=True
//TEMP is_roNo = ''
//TEMP isle_code.DisplayOnly = False
//TEMP isle_code.TabOrder = 10
//TEMP isle_code.SetFocus()


end event

event ue_new;call super::ue_new;//From w_ro.ue_new....
string ls_Prefix,ls_order
long ll_no

// Acess Rights
If f_check_access(is_process,"N") = 0 Then Return

// Looking for unsaved changes
If wf_save_changes() = -1 Then Return	

// Clear existing data
This.Title = is_title + " - New"
ib_edit = False
ib_changed = False
//ibConfirmrequested = False

isle_code.text = ""
//isle_order2.text = ""

wf_clear_screen()

idw_main.InsertRow(0)
//wf_checkstatus()

idw_main.Show()
idw_main.SetFocus()
//idw_main.SetColumn("supp_invoice_no")

end event

event ue_save;call super::ue_save;//from w_ro.ue_save...
Integer li_ret,li_ret_l,li_ret_ll,li_return

long i,ll_totalrows, ll_no

String	ls_Order, lsRONO, lsOrdStat

IF f_check_access(is_process,"S") = 0 THEN Return -1

// Validations

SetPointer(HourGlass!)

// pvh 11/23/05 - gmt
datetime ldtToday
ldtToday = f_getLocalWorldTime( gs_default_wh ) 

If idw_main.RowCount() > 0 Then
	 idw_main.SetItem(1,'last_update' , ldtToday ) 
	// idw_main.SetItem(1,'last_update',Today()) 
	idw_main.SetItem(1,'last_user',gs_userid)
	If wf_validation() = -1 Then
		SetMicroHelp("Save failed!")
		Return -1
	End If
End If

// Assign Order No.

/*
ib_edit = ib_edit

If ib_edit = False Then
	
	
Else /*updating existing record*/
	
	
End If
*/


// Updating the Datawindow

Execute Immediate "Begin Transaction" using SQLCA; /* 11/04 - PCONKL - Auto Commit Turned on to eliminate DB locks*/

If idw_main.RowCount() > 0 Then
	li_ret = idw_main.Update()
Else 
	li_ret = 1
End If
/*
if li_ret = 1 then li_ret = idw_detail.Update()
if li_ret = 1 then li_ret = idw_putaway.Update()
if li_ret = 1 then li_ret = idw_content.Update()
If idw_main.RowCount() = 0 and li_ret = 1 Then li_ret = idw_main.Update()
*/

IF li_ret = 1 THEN
	Execute Immediate "COMMIT" using SQLCA;
	IF Sqlca.Sqlcode = 0 THEN
		If idw_main.RowCount() > 0 Then 
			ib_changed = False
			ib_edit = True
			This.Title = is_title  + " - Edit"
//			wf_checkstatus()
			SetMicroHelp("Record Saved!")
		End If
		Return 0
   ELSE
		Execute Immediate "ROLLBACK" using SQLCA;
      MessageBox(is_title, SQLCA.SQLErrText)
		Return -1
   END IF
ELSE
   Execute Immediate "ROLLBACK" using SQLCA;
	SetMicroHelp("Save failed!")
	MessageBox(is_title, "System error, record save failed!")
	Return -1
END IF


end event

event open;call super::open;Istrparms = Message.PowerObjectParm

end event

event ue_retrieve;call super::ue_retrieve;
// lsSKU,
String lsLastLvl, lsCurLvl, lsPassFail
Long	llCount, llRowPos, llInspections, llAccepted, llMonths
datastore ldsStats
DateTime ldLastDT, ldCurDt
boolean lbNoFailures

string ls_sql, ls_where

//Set bol = current text
//lsSKU = This.Text

//If the Order/Line have been set...
	IF is_rono > '' and il_LineNo > 0 THEN
		//May want to move this outside of ue_retrieve...
		
		//calculate IQC Stats and populate dw_iqc_stats
		ldsStats = Create u_ds_datastore
		ldsStats.dataobject= 'd_iqc_search_result'
		ldsStats.SetTransObject(SQLCA)

		ldsStats.Reset()
		ls_sql = isOrigSql_Stats //Is this being set correctly?
		ls_where = " and receive_master.project_id = '" + gs_project + "' "
		ls_where += " and receive_detail.sku = '" + is_Sku + "' "
		ls_where += " and iqc_pass_fail is not null"
		ls_sql += ls_where + " order by iqc_date desc"	
		ldsStats.SetSqlSelect(ls_sql)

		llCount = ldsStats.Retrieve()
		//ldsStats.SetSort
		//ldsStats.Sort
		if llcount > 0 then
			lbNoFailures = true
			llmonths = 0
			llAccepted = 0
		end if
		For llRowPos = 1 to llCount
			lsPassFail = ldsStats.GetItemString(llRowPos,'IQC_Pass_Fail')
			//if lsLastLvl = '' then 
			if llRowPos = 1 then //first time through (latest record)
				lsLastLvl = ldsStats.GetItemString(llRowPos,'Inspection_Level')
				ldLastDT = ldsStats.GetItemDateTime(llRowPos,'IQC_Date')				
				llInspections = 1
				if lsPassFail = 'Y' and lbNoFailures then
					//counting up consecutive ACCEPTED inspections at current level
					llAccepted = 1
				else
					//already set llAccepted = 0 
					lbNoFailures = false // last inspection wasn't Accepted (passed).
				end if
			else
				lsCurLvl = ldsStats.GetItemString(llRowPos,'Inspection_Level')
				if lsCurLvl = lsLastLvl then
					ldCurDT = ldsStats.GetItemDateTime(llRowPos,'IQC_Date')
					llInspections += 1
					if lsPassFail = 'Y' and lbNoFailures then
						//counting up consecutive 
						llAccepted += 1
					else
						lbNoFailures = false
					end if
				else
					/*
					if llInspections > 1 then
						messagebox ("temp", "LastDt: " + string(month(date(ldLastDT))))
						messagebox ("temp", "CurDt: " + string(month(date(ldCurDT))))
						
						llMonths = month(date(ldLastDT)) - month(date(LDCurDT))
						messagebox ("temp", "Months: " + string(llMonths))
					end if
					*/
					exit
				end if			
			end if
		Next /*data row*/
		
		if llInspections > 1 then
			//TEMP? Rounding down?
			llMonths = month(date(ldLastDT)) - month(date(LDCurDT))
			messagebox ("temp", "Months: " + string(llMonths))
		end if

		idw_stats.SetItem(1, "Last_Insp_Lvl", lsLastLvl)
		idw_stats.SetItem(1, "Last_Insp_DT", ldLastDT)
		idw_stats.SetItem(1, "Num_Consec", llInspections)
		idw_stats.SetItem(1, "Num_Accept", llAccepted)
		idw_stats.SetItem(1, "Months", llMonths)
		
		/*?
		IF SQLCA.sqlcode <> 0 THEN
			MessageBox(is_title, "IQC Record not found, please enter again!", Exclamation!)
			isle_code.SetFocus()
			isle_code.SelectText(1,Len(is_SKU))
			RETURN
		End If
		*/
	END IF

IF is_rono = "" THEN RETURN

idw_main.Retrieve(is_rono, il_lineno)

IF idw_main.RowCount() > 0 Then
/*
	wf_checkstatus()
	
	If idw_main.GetItemString(1, "ord_status") <> "C" and &
		idw_main.GetItemString(1, "ord_status") <> "V" Then
		iw_window.TriggerEvent("ue_refresh")
	End If
	*/
	ib_changed = False
/*
	idw_main.Show()
	idw_stats.show() //show this dw on top of dw_Main
	idw_main.SetFocus()
	isle_code.Visible = FALSE	
*/
ELSE
	idw_main.InsertRow(0)
	idw_main.SetItem(1, "ro_no", is_rono)
	idw_main.SetItem(1, "line_item_no", il_LineNo)
	idw_main.SetItem(1, "Original_Inv_Type", is_UF1)
	idw_main.SetItem(1, "SKU", is_SKU)
	idw_main.SetFocus()
	//ib_changed = True
	//MessageBox(is_title, "IQC Record not found, please enter again!", Exclamation!)
	//isle_code.SetFocus()
	//isle_code.SelectText(1,Len(is_Sku))
END IF
tab_main.SelectTab(1)
idw_main.Show()
idw_stats.show() //show this dw on top of dw_Main
idw_main.SetFocus()
isle_code.Visible = FALSE	

end event

event ue_clear;call super::ue_clear;wf_clear_screen()
end event

event resize;call super::resize;tab_main.Resize(workspacewidth() - 20,workspaceHeight())
//tab_main.tabpage_main.dw_iqc.Resize(workspacewidth() - 80,workspaceHeight()-300)
tab_main.tabpage_search.dw_search_result.Resize(workspacewidth() - 120, workspaceHeight()-700)

end event

type tab_main from w_std_master_detail`tab_main within w_iqc
integer width = 3237
integer height = 1744
end type

type tabpage_main from w_std_master_detail`tabpage_main within tab_main
event create ( )
event destroy ( )
integer width = 3200
integer height = 1616
string text = "IQC Information"
dw_iqc_stats dw_iqc_stats
st_1 st_1
sle_sku sle_sku
dw_iqc dw_iqc
end type

on tabpage_main.create
this.dw_iqc_stats=create dw_iqc_stats
this.st_1=create st_1
this.sle_sku=create sle_sku
this.dw_iqc=create dw_iqc
int iCurrent
call super::create
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_iqc_stats
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.sle_sku
this.Control[iCurrent+4]=this.dw_iqc
end on

on tabpage_main.destroy
call super::destroy
destroy(this.dw_iqc_stats)
destroy(this.st_1)
destroy(this.sle_sku)
destroy(this.dw_iqc)
end on

type tabpage_search from w_std_master_detail`tabpage_search within tab_main
integer width = 3200
integer height = 1616
dw_search_result dw_search_result
cb_search cb_search
dw_search_entry dw_search_entry
end type

on tabpage_search.create
this.dw_search_result=create dw_search_result
this.cb_search=create cb_search
this.dw_search_entry=create dw_search_entry
int iCurrent
call super::create
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_search_result
this.Control[iCurrent+2]=this.cb_search
this.Control[iCurrent+3]=this.dw_search_entry
end on

on tabpage_search.destroy
call super::destroy
destroy(this.dw_search_result)
destroy(this.cb_search)
destroy(this.dw_search_entry)
end on

type dw_iqc_stats from datawindow within tabpage_main
boolean visible = false
integer x = 1719
integer y = 508
integer width = 1184
integer height = 580
integer taborder = 40
boolean enabled = false
boolean titlebar = true
string title = "Inspection Stats"
string dataobject = "d_iqc_stats"
boolean livescroll = true
end type

type st_1 from statictext within tabpage_main
integer x = 123
integer y = 60
integer width = 402
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "SKU:"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_sku from singlelineedit within tabpage_main
integer x = 517
integer y = 40
integer width = 873
integer height = 88
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

event modified;long llCount
is_sku = This.Text
	/*If entering a SKU to start, check to see if existing IQC records exist
	  - If One, retrieve it, If more than one show Search grid
	  If coming from w_ro with Detail Line selected (or coming from search grid), Retrieve
	  */
	  
//if 'modified' was called from search screen, retrieve iqc record...
if is_rono = '' or isnull(is_rono) then
	Select Count(*) into :llCount
	FROM Receive_IQC IQC, Receive_Master RM, Receive_Detail RD
	WHERE iqc.RO_No = RM.RO_No
	and iqc.RO_No = RD.RO_No and iqc.Line_Item_No = RD.Line_Item_No
	and SKU = :is_SKU and project_id = :gs_project;
	
	If llCount = 0 or SQLCA.sqlcode <> 0 THEN
		MessageBox(is_title, "IQC Record not found!", Exclamation!)
		isle_code.SetFocus()
		isle_code.SelectText(1,Len(is_SKU))
		RETURN
	ElseIf llCount > 1 Then 
		Messagebox(is_title,"Multiple records found for this SKU, please select from search tab!")
		//SetItem for SKU on dw_search_entry (idw_Search)?
		isle_code.SetFocus()
		isle_code.SelectText(1,Len(is_SKU))
		Return
	end if 
end if
	//Else /* one record found or called from grid */
		Select IQC.ro_no, IQC.line_item_no into :is_rono, :il_LineNo
		FROM Receive_IQC IQC, Receive_Master RM, Receive_Detail RD
		WHERE iqc.RO_No = RM.RO_No
		and iqc.RO_No = RD.RO_No and iqc.Line_Item_No = RD.Line_Item_No
		and SKU = :is_SKU and project_id = :gs_project;
		iw_window.TriggerEvent('ue_Retrieve')
	//end if
return

end event

type dw_iqc from u_dw_ancestor within tabpage_main
event ue_post_check_status ( )
integer y = 8
integer width = 3154
integer height = 1548
integer taborder = 30
string dataobject = "d_iqc"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event itemerror;//Choose Case dwo.name
//	Case "supp_code"
//		Return 1
//	Case Else
//		Return 2
//End Choose

Return 2
end event

event process_enter;Send(Handle(This),256,9,Long(0,0))
Return 1
end event

event itemchanged;call super::itemchanged;
ib_changed = True
end event

type dw_search_result from u_dw_ancestor within tabpage_search
integer x = 9
integer y = 352
integer width = 3150
integer height = 1100
integer taborder = 30
string dataobject = "d_iqc_search_result"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event clicked;call super::clicked;//If row is clicked then highlight the row
IF row > 0 THEN
	This.SelectRow(0, FALSE)
	This.SelectRow(row, TRUE)
END IF
end event

event doubleclicked;// Pasting the record to the main entry datawindow
//string ls_code

IF Row > 0 THEN
	iw_window.TriggerEvent("ue_edit")
	If ib_changed = False and ib_edit = True Then
		//ls_code = this.getitemstring(row,'supp_invoice_no')
		//ls_code = this.getitemstring(row,'sku')
		is_sku = this.getitemstring(row,'sku')
		is_rono = this.getitemstring(row,'ro_no')
		il_lineno = this.getitemNumber(row,'line_item_no')
		iw_window.TriggerEvent('ue_retrieve')
		//isle_code.text = ls_code
		//isle_code.TriggerEvent(Modified!)
	End If
END IF
end event

type cb_search from commandbutton within tabpage_search
integer x = 2798
integer y = 116
integer width = 274
integer height = 108
integer taborder = 30
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Search"
boolean default = true
end type

event clicked;DateTime ldt_date
String ls_string, ls_where, ls_sql 
Boolean lb_order_from, lb_order_to, lb_sched_from, lb_sched_to, lb_complete_from, lb_complete_to
Boolean lb_where
Boolean lsuseSku,lsuseCONTID,lsusePONO
//Initialize Date Flags
lb_order_from 		= FALSE
lb_order_to 		= FAlSE
lb_sched_from 		= FALSE
lb_sched_to 		= FALSE
lb_complete_from 	= FALSE
lb_complete_to 	= FALSE

If idw_search.AcceptText() = -1 Then Return

//idw_search.Reset()
idw_result.Reset()
ls_sql = isOrigSql_Result
lb_where = False

ls_where = " and receive_master.project_id = '" + gs_project + "' "
//ls_where = " and receive_iqc.ro_no like '" + gs_project + "%' "

/*
ldt_date = idw_search.GetItemDateTime(1,"ord_date_s")
If  Not IsNull(ldt_date) Then
	ls_where += " and receive_master.ord_date >= '" + &
		String(ldt_date, "yyyy-mm-dd hh:mm:ss") + "' "
	lb_order_from = TRUE
	lb_where = TRUE
End If

ldt_date = idw_Search.GetItemDateTime(1,"ord_date_e")
If  Not IsNull(ldt_date) Then
	ls_where += " and receive_master.ord_date <= '" + &
		String(ldt_date, "yyyy-mm-dd hh:mm:ss") + "' "
	lb_order_to = TRUE
	lb_where = TRUE
End If

*/
ls_string = idw_Search.GetItemString(1,"wh_code")
if not isNull(ls_string) and trim(ls_string)<>'' then
	ls_where += " and receive_master.wh_code = '" + ls_string + "' "
	lb_where = TRUE
end if

ls_string = idw_Search.GetItemString(1,"supp_code")
if not isNull(ls_string) and trim(ls_string)<>'' then
	ls_where += " and receive_master.supp_code = '" + ls_string + "' "
	lb_where = TRUE
end if

ls_string = idw_Search.GetItemString(1,"sku")
if not isNull(ls_string) and trim(ls_string)<>'' then
	ls_where += " and receive_detail.sku = '" + ls_string + "' "
//	lsUseSku = True /* 07/03 Mathi - searching on sku, we need to remove outer join to Master*/
	lb_where = TRUE
end if

/*
ls_string = idw_Search.GetItemString(1,"po_no")
if not isNull(ls_string) then
	ls_where += " and (receive_putaway.po_no = '" + ls_string + "' or Receive_Putaway.ro_no in (select ro_no from receive_xref where po_no = '" + ls_string + "'))" /* 04/04 - MA - Added so Receive _Xref would be search for po_no */
	lsusePONO = True /* 12/03 Mathi - searching on PO NO, we need to remove outer join to Master*/
	lb_where = TRUE
end if
*/


//Check Order Date range for any errors prior to retrieving
IF ((lb_order_to = TRUE and lb_order_from = FALSE) 	OR &
	 (lb_order_from = TRUE and lb_order_to = FALSE)  	OR &
	 (lb_order_from = FALSE and lb_order_to = TRUE)) 	THEN
		messagebox("ERROR", "Please complete the FROM\To in Order Date Range", Stopsign!)
	Return
END IF

ls_sql += ls_where

idw_result.SetSqlSelect(ls_sql)

If idw_result.Retrieve() = 0 Then
	messagebox(is_title,"No records found!")
End If

end event

type dw_search_entry from datawindow within tabpage_search
integer x = 37
integer y = 60
integer width = 3081
integer height = 324
integer taborder = 20
string title = "none"
string dataobject = "d_iqc_search_entry"
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

