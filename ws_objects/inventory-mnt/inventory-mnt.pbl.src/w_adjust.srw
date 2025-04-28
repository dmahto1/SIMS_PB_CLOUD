$PBExportHeader$w_adjust.srw
$PBExportComments$-Stock Adjustment Program
forward
global type w_adjust from window
end type
type dw_report from datawindow within w_adjust
end type
type cb_adjust_print_report from commandbutton within w_adjust
end type
type cb_adjust_clear from commandbutton within w_adjust
end type
type cb_adjust_search from commandbutton within w_adjust
end type
type dw_search from datawindow within w_adjust
end type
type dw_main from u_dw_ancestor within w_adjust
end type
end forward

global type w_adjust from window
integer x = 5
integer y = 4
integer width = 4137
integer height = 2680
boolean titlebar = true
string title = "Stock Adjustment "
string menuname = "m_simple_record"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 79741120
event ue_delete ( )
event ue_new ( )
event type long ue_save ( )
event ue_retrieve ( )
event ue_print ( )
event ue_edit ( )
event ue_help ( )
event ue_sort ( )
dw_report dw_report
cb_adjust_print_report cb_adjust_print_report
cb_adjust_clear cb_adjust_clear
cb_adjust_search cb_adjust_search
dw_search dw_search
dw_main dw_main
end type
global w_adjust w_adjust

type variables
m_simple_record im_menu
Boolean ib_changed
boolean ib_start_from_first
boolean ib_start_to_first
String is_title,i_sql, is_process
long	ilProcessRow, ilHelpTopicID
n_warehouse i_nwarehouse
str_parms	istrparms




end variables

forward prototypes
public function integer wf_settaborder (integer a_ind)
end prototypes

event ue_new();String ls_sku, ls_whcode, ls_location, ls_type, ls_ref_no,ls_reason
Long ll_row, row

If f_check_access(is_process,"N") = 0 Then Return

//14-MAY-2019 :Madhu S33404 F15609 Inventory Serial Reconciliation Process
IF gbSerialReconcileOnly THEN	MessageBox("Security Check","You do have permissions only for Serial Reconcile Adjustment Type.")

// 06/00 PCONKL - inserting in a new window - this one is too screwed up!
Open(w_adjust_create)


end event

event ue_save;

Return 0
end event

event ue_retrieve();
cb_adjust_search.Trigger Event Clicked()
end event

event ue_print;If dw_report.RowCount() > 0 Then
	OpenWithParm(w_dw_print_options,dw_report) 
Else
	MessageBox(is_title, "Nothing to print!")
End If	
end event

event ue_edit;// Acess Rights

If f_check_access(is_process,"E") = 0 Then
	close(w_adjust)
	return
end if

end event

event ue_help;
ShowHelp(g.is_helpfile,topic!,ilHelpTopicID) /*open by topic ID*/
end event

event ue_sort;
//This Event displays the sor criterial & sorts by the desire criteria
long ll_ret
String str_null
SetNull(str_null)

ll_ret=dw_main.Setsort(str_null)
ll_ret=dw_main.Sort()
	

end event

public function integer wf_settaborder (integer a_ind);Return 1
end function

on w_adjust.create
if this.MenuName = "m_simple_record" then this.MenuID = create m_simple_record
this.dw_report=create dw_report
this.cb_adjust_print_report=create cb_adjust_print_report
this.cb_adjust_clear=create cb_adjust_clear
this.cb_adjust_search=create cb_adjust_search
this.dw_search=create dw_search
this.dw_main=create dw_main
this.Control[]={this.dw_report,&
this.cb_adjust_print_report,&
this.cb_adjust_clear,&
this.cb_adjust_search,&
this.dw_search,&
this.dw_main}
end on

on w_adjust.destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_report)
destroy(this.cb_adjust_print_report)
destroy(this.cb_adjust_clear)
destroy(this.cb_adjust_search)
destroy(this.dw_search)
destroy(this.dw_main)
end on

event open;DataWindowChild ldwc, ldwc2
String	lsFilter

is_title = This.Title
im_menu = This.MenuID
This.move(0,0)
SetPointer(HourGlass!)

ilHelpTopicID = 529 /*set help topic*/

istrparms = Message.PowerObjectParm
//is_process = Message.StringParm
is_process = Istrparms.String_arg[1]

dw_main.SetTransObject(sqlca)
dw_search.SetTransObject(sqlca)
dw_report.SetTransObject(sqlca)
dw_main.ShareData(dw_report)

// 01/03 - Retrieve by Project instead of filtering
dw_search.GetChild("wh_code", ldwc)
ldwc.SetTransObject(sqlca)
If ldwc.Retrieve(gs_Project) < 1 Then ldwc.InsertRow(0) 

// 09/03 - pconkl - retrive Inventory Type dropdowns by project
dw_main.GetChild("inventory_Type", ldwc)
ldwc.SetTransObject(sqlca)
If ldwc.Retrieve(gs_Project) < 1 Then ldwc.InsertRow(0) 

//share with other (Old) inv type dropdown
dw_main.GetChild("old_inventory_Type", ldwc2)
ldwc.ShareData(ldwc2)

i_sql = dw_main.getsqlselect()
cb_adjust_clear.Trigger Event clicked() 
This.TriggerEvent("ue_edit")
end event

event closequery;Integer li_return

// Looking for unsaved changes 
IF ib_changed THEN
	Choose Case MessageBox(is_title,"Save Changes?",Question!,YesNoCancel!,3)
		Case 1
		   li_return = Trigger Event ue_save()
			Return li_return  
   	Case 2
			Return 0
		Case 3
			Return -1
	End Choose 		
ELSE
	Return 0
END IF
end event

event deactivate;g.POST of_setmenu(TRUE)
end event

event resize;
dw_main.Resize(workspacewidth() - 10,workspaceHeight()-320)
end event

type dw_report from datawindow within w_adjust
boolean visible = false
integer x = 2167
integer y = 1376
integer width = 494
integer height = 360
integer taborder = 60
string dataobject = "d_adjustment_report"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cb_adjust_print_report from commandbutton within w_adjust
integer x = 805
integer y = 20
integer width = 722
integer height = 88
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Print  Report"
end type

event clicked;datetime ldt_sdate,ldt_edate
string filename,lineout[],code_descript
OLEObject xl,xs
long pos,ll_rowcnt,i
string ls_code
string ls_adjust_type, ls_adjust_desc

IF dw_report.Rowcount() > 0 THEN

	//MEA - 	12-16-11 Added Nike functionality 

	IF gs_project = "NIKE-MY" OR  gs_project = "NIKE-SG" THEN
		
		IF messagebox(parent.Title,"Convert to Excel file",Question!,YesNo!,2)=2 then
			openwithparm(w_dw_print_options,dw_report)
   			return
		END IF

		ldt_sdate = dw_search.GetItemDateTime(1,"s_Date")
		ldt_edate = dw_search.GetItemDateTime(1,"e_Date")
		SetPointer(HourGlass!)

		SetMicroHelp("Opening Excel ...")
		filename =   gs_syspath + "Reports\stadjust.xls"

		xl = CREATE OLEObject
		xs = CREATE OLEObject
		xl.ConnectToNewObject("Excel.Application")
		xl.Workbooks.Open(filename,0,True)
		xs = xl.application.workbooks(1).worksheets(1)
		
		SetMicroHelp("Printing report heading...")

		xs.cells(1,1).Value = "Printed on: " + String(Today(),"mm/dd/yyyy hh:mm")
		xs.cells(3,1).Value = "( " + String(ldt_sdate) + " - " + String(ldt_edate) + " )" 
		ll_rowcnt=dw_main.RowCount()
		pos = 5
		
		// Ver : EWMS 2.0 20070814
		// Insert New COlumn : NEW QTY
		
		For i = 1 to ll_rowcnt
			pos += 1 
			SetMicroHelp("Exporting to Excel line " + String(i) + " of " + String(ll_rowcnt))
			xs.cells(pos,1).Value = dw_main.GetItemNumber(i, "adjust_no")
			xs.cells(pos,2).Value = dw_main.GetItemString(i, "sku")
			xs.cells(pos,3).Value = dw_main.GetItemString(i, "wh_code")
			xs.cells(pos,4).Value = String(dw_main.GetItemString(i, "l_code"),"@@@-@@-@@@")
			ls_code 	  = dw_main.GetItemString(i, "inventory_type")
			select Inv_Type_Desc into :code_descript 	from inventory_type 	where inv_type = :ls_code  and project_id = :gs_project ;
			xs.cells(pos,5).Value = code_descript
			xs.cells(pos,6).Value = dw_main.GetItemNumber(i, "old_quantity")
			xs.cells(pos,7).Value = dw_main.GetItemNumber(i, "quantity") - dw_main.GetItemNumber(i, "old_quantity") //sarun
			xs.cells(pos,8).Value = dw_main.GetItemNumber(i, "quantity")
			xs.cells(pos,9).Value = dw_main.GetItemString(i, "ref_no")
			
			string ls_reason_code, ls_reason
			integer li_pos
			
			ls_reason_code = dw_main.GetItemString(i, "reason")
			
			SELECT Code_Descript INTO :ls_reason
				FROM Lookup_Table 
				WHERE project_id = :gs_project and code_type = 'IA' and
						  code_id = :ls_reason_code USING SQLCA;
			
			if sqlca.sqlcode <> 0   then

				ls_reason = ls_reason_code
					
			end if
			
			xs.cells(pos,10).Value = ls_reason
			xs.cells(pos,11).Value = dw_main.GetItemString(i, "last_user")
			xs.cells(pos,12).Value = dw_main.GetItemDateTime(i, "last_update")
			
			//Stock Category
			xs.cells(pos,13).Value = dw_main.GetItemString(i,"lot_no")


			xs.cells(pos,14).Value = dw_main.GetItemString(i,"Country_of_Origin")
			//EWMS 2.0 090326 Start
			xs.cells(pos,15).Value = dw_main.GetItemString(i,"remarks")					
			//EWMS 2.0 090326 End
				
			if pos - 5 <= ll_rowcnt then
				xs.rows(pos + 1).Insert
			end if
		
		Next
		
		SetMicroHelp("Complete!")
		xl.Visible = True
		xl.DisconnectObject()

	ELSE

		OpenWithParm(w_dw_print_options,dw_report)
	
	END IF
	
ELSE
	Messagebox(is_title,"Nothing to Print")
END IF 
end event

event constructor;
g.of_check_label_button(this)
end event

type cb_adjust_clear from commandbutton within w_adjust
integer x = 425
integer y = 20
integer width = 352
integer height = 88
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Clear"
end type

event clicked;//If dw_main.RowCount() > 0 Then
//	If wf_save_changes() = -1 Then Return
//End If
//
dw_search.Reset()
dw_main.reset()
dw_search.InsertRow(0)
dw_search.SetFocus()
//dw_search.SetItem(1,"s_date",Today())
//dw_search.SetItem(1,"e_date",Today())
dw_search.SetColumn("s_date")
w_adjust.SetMicroHelp ( "(" + string(dw_main.Rowcount()) +")" + " Rows Retrieved")
end event

event constructor;
g.of_check_label_button(this)
end event

type cb_adjust_search from commandbutton within w_adjust
integer x = 27
integer y = 20
integer width = 366
integer height = 88
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Search"
end type

event clicked;datetime ldt_s_date, ldt_e_date
string ls_type, ls_sku, ls_whcode, ls_ref_no,ls_microhelp,ls_contid, ls_adjust_id
string ls_where,ls_sql,ls_supp, lsOrder
long i,ll_owner,ll_rtn
Boolean lb_where

//If wf_save_changes() = -1 Then Return
If dw_search.AcceptText() = -1 Then Return

dw_main.reset()
SetPointer(Hourglass!)

ls_sku = dw_search.getitemstring(1,"sku")
ls_supp = dw_search.getitemstring(1,"supp_code")
ls_whcode = dw_search.getitemstring(1,"wh_code")
ldt_s_date = dw_search.GetItemDatetime(1,"s_Date")
ldt_e_date = dw_search.GetItemDatetime(1,"e_Date")
ls_ref_no = dw_search.GetItemString(1,"ref_no")
ls_adjust_id = dw_search.GetItemString(1,"adjust_id")
ls_contid = dw_search.GetItemString(1,"container_id")
lsOrder = dw_search.GetItemString(1,"order_nbr") /* 11/11 - PCONKL */

ls_where = " And Adjustment.project_id = '" + gs_project + "' "

if  not isnull(ldt_s_date) then
	ls_where += " and Adjustment.last_update >= '" + String(ldt_s_date, "yyyy/mm/dd hh:mm") + "' "
	lb_where = TRUE
end if

if  not isnull(ldt_e_date) then
	ls_where += " and Adjustment.last_update <= '" + String(ldt_e_date, "yyyy/mm/dd hh:mm") + "' "
	lb_where = TRUE
end if

if not isnull(ls_sku) then
	ls_where += " and Adjustment.sku = '" +ls_sku+ "' "
	lb_where = TRUE
end if
if not isnull(ls_supp) then
	ls_where += " and Adjustment.supp_code = '" +ls_supp+ "' "
	lb_where = TRUE
end if

if not isnull(ls_ref_no) then
	ls_where += " and Adjustment.ref_no = '" +ls_ref_no+ "' "
	lb_where = TRUE
end if

if not isnull(ls_whcode) then
	ls_where += " and Adjustment.wh_code = '" +ls_whcode+ "' "
	lb_where = TRUE
end if

if not isnull(ls_adjust_id) then
	ls_where += " and Adjustment.adjust_no = '" +ls_adjust_id+ "' "
	lb_where = TRUE
end if

//07/03 Mathi Container id search
if not isnull(ls_contid) then
	ls_where += " and Adjustment.container_id = '" +ls_contid+ "' "
	lb_where = TRUE
end if

// 11/11 - PCONKL - Added Order Nbr to search 
If not isnull(lsOrder) Then
	ls_where += " and ro_no = '" + lsOrder + "'"
	lb_where = TRUE
End If

//DGM For giving warning for all no search criteria
if not lb_where then
	  IF i_nwarehouse.of_msg(is_title,1) = 2 THEN Return
END IF	  

ls_sql = i_sql
if ls_where <> '' then
	ls_sql += ls_where
	dw_main.setsqlselect(ls_sql)
end if
ll_rtn =dw_main.retrieve()
if ll_rtn = 0 then
	messagebox(is_title,"No record found!")
end if

ls_microhelp = "(" + string(dw_main.Rowcount()) +")" + " Rows Retrieved"
w_adjust.SetMicroHelp ( ls_microhelp )

dw_main.visible = true
SetPointer(Arrow!)

wf_settaborder(0)
end event

event constructor;
g.of_check_label_button(this)
end event

type dw_search from datawindow within w_adjust
integer x = 9
integer y = 112
integer width = 4087
integer height = 180
integer taborder = 10
string dataobject = "d_adjust_search"
borderstyle borderstyle = stylelowered!
end type

event itemchanged;string ls_supp_code,ls_sku
string ls_null
Setnull(ls_null)
Long ll_rtn

Choose Case dwo.name

case 'sku'
	//Check if item_master has the records for entered sku	
	ll_rtn=i_nwarehouse.of_item_sku(gs_project,data)
	IF ll_rtn > 0 THEN	
		//Check in drop down datawindows & insert row just to escape from retrieve
//		IF idwc_supplier.Retrieve(gs_project,data) > 0 THEN
//			ls_supp_code =idwc_supplier.Getitemstring(1,"supp_code")		
//		END IF
		//Check if ddw is 0 then insert to avoid retrival argument pop up
		//IF ddw ret 1 row then assign the value to dupp_code
   	IF ll_rtn = 1   THEN	
				ls_supp_code=i_nwarehouse.ids_sku.object.supp_code[row] 
			  	This.object.supp_code[ row ] = ls_supp_code
				ls_sku = data
				IF ll_rtn = 1 THEN Post f_setfocus(dw_search,row,'wh_code')
		ELSEIF ll_rtn > 1 THEN
				this.object.supp_code[row] = ls_null
				f_setfocus(dw_search,row,'supp_code')	
   	END IF
 Else			
		MessageBox(is_title, "Invalid SKU, please re-enter!",StopSign!)
		Post f_setfocus(dw_search,row,'sku')
		return 2
 END IF

Case 'supp_code'
	 ls_sku = this.Getitemstring(row,"sku")
	 ls_supp_code = data
	 
END Choose			
Return


end event

event constructor;i_nwarehouse = Create n_warehouse
//this.Getchild("supp_code",idwc_supplier)
//idwc_supplier.SettransObject(SQLCA)
//idwc_supplier.InsertRow(0)
ib_start_from_first 		= TRUE
ib_start_to_first 		= TRUE
g.of_check_label(this) 
end event

event destructor;Destroy i_nwarehouse
end event

event clicked;string 	ls_column

long		ll_row

datetime	ldt_begin_date
datetime	ldt_end_date

dw_search.AcceptText()
ls_column 	= DWO.Name
ll_row 		= dw_search.GetRow()

CHOOSE CASE ls_column
		
	CASE "s_date"
		
		IF ib_start_from_first THEN
			
			ldt_begin_date = f_get_date("BEGIN")
			dw_search.SetColumn("s_date")
			dw_search.SetText(string(ldt_begin_date, "mm/dd/yyyy hh:mm"))
			ib_start_from_first = FALSE
			
		END IF
		
	CASE "e_date"
		
		IF ib_start_to_first THEN
			
			ldt_end_date = f_get_date("END")
			dw_search.SetColumn("e_date")
			dw_search.SetText(string(ldt_end_date, "mm/dd/yyyy hh:mm"))
			ib_start_to_first = FALSE
			
		END IF
		
			
	CASE ELSE
		
END CHOOSE

end event

type dw_main from u_dw_ancestor within w_adjust
integer x = 9
integer y = 304
integer width = 4082
integer height = 2180
integer taborder = 50
string dataobject = "d_adjustment"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event clicked;If row > 0 Then
	If row <> This.GetRow() Then This.SetRow(row)
End If
end event

event constructor;call super::constructor;//DGM Make owner name invisible based in indicator
IF Upper(g.is_owner_ind) <> 'Y' THEN
	// this.object.cf_owner_name.visible = 0  GAP102703 Commented out-causing run time error due to field replaced by compute_2 field in the DW.
	this.object.compute_2.visible = 0  // GAP1003 Added ti fix problem above
	this.object.cf_name_t.visible = 0
End IF
end event

event itemerror;Return 1
end event

event process_enter;If This.GetColumnName() = "reason" Then
	If This.GetRow() = This.RowCount() Then
		Parent.Post Event ue_new()
		Return 1
	End If
Else
	Send(Handle(This),256,9,Long(0,0))
	Return 1
End If
end event

event rowfocuschanged;If This.GetItemStatus(currentrow,0,Primary!) = NotModified! Then
	wf_settaborder(0)
Else
	wf_settaborder(1)
End If
end event

event itemchanged;call super::itemchanged;// ET3 - 2012-07-05 Pandora 447 - cleanup SN's by removing leading/trailing '.' and '-'

BOOLEAN lb_SN_cleaned = FALSE
LONG    ll_Rtn = 0

CHOOSE CASE dwo.name
		
	CASE 'serial_no'
		IF UPPER(gs_project) = 'PANDORA' THEN
					
			// ET3 - 2012-07-05 Pandora 447 - cleanup SN's by removing leading/trailing '.' and '-'
			data = TRIM(data)
			If len(data) > 1 Then
				// strip extraneous Trailing chars
				DO WHILE MATCH( data, "[-\.]$" )
					data = MID(data, 1, len(data) - 1 )
					lb_SN_cleaned = TRUE
				LOOP
				
				// strip extraneous Leading chars
				DO WHILE MATCH( data, "^[-\.]")
					data = MID(data, 2, len(data) - 1 )
					lb_SN_cleaned = TRUE
				LOOP
				
			End If
			
		END IF  // Pandora

END CHOOSE


IF lb_SN_cleaned THEN
	ll_Rtn = 2
	this.setitem( row, dwo.name, data )
ELSE
	ll_Rtn = 0

END IF

RETURN ll_Rtn
end event

