$PBExportHeader$w_pandora_inbound_intransit_rpt.srw
$PBExportComments$Pandora Intransit report
forward
global type w_pandora_inbound_intransit_rpt from w_std_report
end type
type uo_cust_type from uo_multi_select_search within w_pandora_inbound_intransit_rpt
end type
type cb_do_clear from commandbutton within w_pandora_inbound_intransit_rpt
end type
end forward

global type w_pandora_inbound_intransit_rpt from w_std_report
integer width = 4128
integer height = 2272
string title = "Pandora Inbound Intransit Report"
uo_cust_type uo_cust_type
cb_do_clear cb_do_clear
end type
global w_pandora_inbound_intransit_rpt w_pandora_inbound_intransit_rpt

type variables
//inet	linit
//u_nvo_websphere_post	iuoWebsphere
String		is_OrigSql
string   	is_select
string   	is_groupby
string   	is_warehouse_code
string   	is_warehouse_name
datastore 	ids_find_warehouse
boolean 		ib_first_time, ib_from_date_first, ib_to_date_first

DatawindowChild	 idwc_Owner

// LTK 20160408 Added 4 filter variables
String is_warehouse_filter
String is_owner_filter
String is_rdd_from_filter
String is_rdd_to_filter


//TAM  2018/3 - S16210
Boolean ib_show_cust_type = false
String is_cust_type_to_filter

end variables

forward prototypes
public subroutine uf_showhide_cust_type (string as_field)
public subroutine wf_multi_select_cust_type ()
public function string wf_and_it (string as_str1, string as_str2, string as_str3, string as_str4, string as_str5)
end prototypes

public subroutine uf_showhide_cust_type (string as_field);/*TAM 2018/03 S16210 - to turn multi select DW on/off when clicking DDDW for cust Type */
CHOOSE CASE as_field
		
	CASE 'cust_type'
		If ib_show_cust_type Then
			this.uo_cust_type.bringtotop = False
			ib_show_cust_type = False
		Else
			this.uo_cust_type.bringtotop = True
			ib_show_cust_type = True
		End If
		
END CHOOSE

end subroutine

public subroutine wf_multi_select_cust_type ();//TAM - 2018/03 - MAke customer_type multi-select

String lsSql, lserror
long ll_row

Datastore lds_cust_type

//Remove filter
uo_cust_type.dw_search.setfilter( "")
uo_cust_type.dw_search.filter()

uo_cust_type.dw_search.setfilter("")
uo_cust_type.dw_search.filter()

this.uo_cust_type.visible = true
this.uo_cust_type.width = 725
this.uo_cust_type.dw_search.width = 720
this.uo_cust_type.height = 570
this.uo_cust_type.dw_search.height = 565
this.uo_cust_type.bringtotop = false
this.uo_cust_type.uf_init("d_cust_type_list","c.customer_type","cust_type")

//create datastore
lds_cust_type =create Datastore
lsSql = " SELECT  Code_ID , Code_Descript FROM Lookup_Table with(nolock) "
lsSql += " Where Project_Id ='"+gs_project+"' And Code_Type = 'CTYPE'"
lsSql += " Order by Code_ID ASC"

lds_cust_type.create( SQLCA.syntaxfromsql( lsSql, "", lserror))

If len(lserror) > 0 then
	MessageBox("Error", lserror)
else
	lds_cust_type.settransobject( sqlca)
	lds_cust_type.retrieve( )
End If

For ll_row =1 to lds_cust_type.rowcount( )
	this.uo_cust_type.dw_search.insertrow( 0)
	this.uo_cust_type.dw_search.setitem( ll_row, 'cust_type', trim(lds_cust_type.getitemstring(ll_row,'Code_ID')))
	this.uo_cust_type.dw_search.setitem( ll_row, 'cust_type_desc', trim(lds_cust_type.getitemstring(ll_row,'Code_Descript')))
	this.uo_cust_type.dw_search.setitem( ll_row, 'selected', 0)
Next

dw_select.setItem(1,"cust_type", "<Select Multiple>")
dw_select.Modify("cust_type.dddw.Limit=0")
dw_select.Modify("cust_type.dddw.Name='None'")
dw_select.Modify("cust_type.dddw.PercentWidth=0")
dw_select.Modify("cust_type.dddw.HScrollBar=0")

destroy lds_cust_type
end subroutine

public function string wf_and_it (string as_str1, string as_str2, string as_str3, string as_str4, string as_str5);String ls_return

if Len( Trim( as_str1 )) > 0 then
	ls_return = "( " + as_str1 + " )"
end if

if Len( Trim( as_str2 )) > 0 then
	if Len( Trim( ls_return )) > 0 then
		ls_return = ls_return + "  and (" + as_str2 + ") "
	else
		ls_return = as_str2
	end if
end if

if Len( Trim( as_str3 )) > 0 then
	if Len( Trim( ls_return )) > 0 then
		ls_return = ls_return + " and (" + as_str3 + ") "
	else
		ls_return = as_str3
	end if
end if

if Len( Trim( as_str4 )) > 0 then
	if Len( Trim( ls_return )) > 0 then
		ls_return = ls_return + " and (" + as_str4 + ") "
	else
		ls_return = as_str4
	end if
end if

//TAM 2018/3 - S16210 - Add Cust_Type Multi Select 
if Len( Trim( as_str5 )) > 0 then
	if Len( Trim( ls_return )) > 0 then
		ls_return = ls_return + " and (" + as_str5 + ") "
	else
		ls_return = as_str5
	end if
end if

return ls_return

end function

on w_pandora_inbound_intransit_rpt.create
int iCurrent
call super::create
this.uo_cust_type=create uo_cust_type
this.cb_do_clear=create cb_do_clear
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_cust_type
this.Control[iCurrent+2]=this.cb_do_clear
end on

on w_pandora_inbound_intransit_rpt.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_cust_type)
destroy(this.cb_do_clear)
end on

event resize;//dw_report.Resize(workspacewidth() - 100,workspaceHeight()-200)
dw_report.Resize( newwidth - 110, newheight - 680 )


end event

event ue_clear;dw_select.Reset()
dw_select.InsertRow(0)

end event

event ue_retrieve;long llRtn


w_main.setMicroHelp('Retrieving Inbound Intransit report ...')

llRtn = dw_report.retrieve( gs_project)

w_main.setMicroHelp( string(llRtn) + ' records retrieved')

end event

event ue_postopen;DatawindowChild	ldwc_warehouse, ldwc, ldwc_from_warehouse
string	lsFilter

idw_current = dw_Report

//populate dropdowns - not done automatically since dw not being retrieved

//dw_select.GetChild('warehouse', ldwc_warehouse)
//ldwc_warehouse.SetTransObject(sqlca)
//If ldwc_warehouse.Retrieve(gs_project) > 0 Then
//	
//	//Filter Warehouse dropdown by Current Project
//	lsFilter = "Upper(project_id) = '" + Upper(gs_project) + "'"
//	ldwc_warehouse.SetFilter(lsFilter)
//	ldwc_warehouse.Filter()
//	
////	If ldwc_warehouse.RowCount() > 0 Then
////		dw_select.SetItem(1, "warehouse" , ldwc_warehouse.GetItemString(1, "wh_code"))
////	End If
//	
//End If

// LTK 20150922  Commented out block above.  Populate warehouse DDDW via common method which uses user's configured warehouses.
//dw_select.GetChild("warehouse", ldwc_warehouse)
dw_select.GetChild("wh_code", ldwc_warehouse)
ldwc_warehouse.SetTransObject(sqlca)
g.of_set_warehouse_dropdown(ldwc_warehouse)

dw_select.GetChild("from_wh_code", ldwc_from_warehouse)
ldwc_from_warehouse.SetTransObject(sqlca)
g.of_set_warehouse_dropdown(ldwc_from_warehouse)


dw_report.Setredraw( FALSE )
	
This.TriggerEvent('ue_retrieve')

// LTK 20150922  Set and filter default warehouse if present
if Len( Trim( gs_default_wh )) > 0 and dw_select.RowCount() > 0 then
	dw_select.SetItem(1, "wh_code", gs_default_wh)
	dw_report.SetFilter("receive_master_wh_code = '" + gs_default_wh + "' ")
	dw_report.Filter( )
end if

dw_report.SetRedraw( TRUE )



// LTK 20160401  
//DatawindowChild	ldwc_wh_code
//dw_select.GetChild("wh_code", ldwc_wh_code)
//ldwc_wh_code.SetTransObject(SQLCA)
//ldwc_wh_code.retrieve( gs_project )
//
dw_select.GetChild('owner_code', idwc_Owner)
idwc_Owner.SetTransObject(sqlca)


//TAM - 2018/03 - MAke customer_type multi-select
wf_multi_select_cust_type()







end event

event ue_print;call super::ue_print;dw_report.print( )
end event

event open;call super::open;Integer  li_pos

is_OrigSql = dw_report.getsqlselect()

end event

type dw_select from w_std_report`dw_select within w_pandora_inbound_intransit_rpt
event ue_keydown pbm_dwnkey
string tag = "Warehouse"
integer y = 0
integer width = 3136
integer height = 536
string dataobject = "d_pandora_inbound_intransit_search"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event dw_select::ue_keydown;if this.getcolumnname( ) = 'cust_type'  then
	uo_cust_type.uf_set_filter( this.gettext())
end if
end event

event dw_select::itemchanged;call super::itemchanged;//// based upon selection filter the dw_report window
//
//string lsWhsCode
//
////lsWhsCode = this.getitemstring( currentrow, 'wh_code')
////lsWhsCode = this.getitemstring( currentrow, 'warehouse')
//lsWhsCode = data
//
//
//dw_report.Setredraw( FALSE )
//dw_report.SetFilter("receive_master_wh_code = '" + lsWhsCode + "' ")
//dw_report.Filter( )
//dw_report.SetRedraw( TRUE )
//
//return 0
//


// LTK 20160407  Commented original event above and modified with additional search parms...

String ls_Null

Choose Case Upper(dwo.name)		

	case "WH_CODE"

//		idwc_Owner.Retrieve ( data )	// LTK 20160408 Added
//		idwc_Owner.SetSort("Cust_Code A")

		// based upon selection filter the dw_report window
		
		dw_report.Setredraw( FALSE )
		//dw_report.SetFilter("receive_master_wh_code = '" + data + "' ")
		is_warehouse_filter = " receive_master_wh_code = '" + data + "' "
/*TAM 2018/03 S16210 - to turn multi select DW on/off when clicking DDDW for cust Type */
//		dw_report.SetFilter( wf_and_it( is_warehouse_filter, is_owner_filter, is_rdd_from_filter, is_rdd_to_filter ) )
		dw_report.SetFilter( wf_and_it( is_warehouse_filter, is_owner_filter, is_rdd_from_filter, is_rdd_to_filter, is_cust_type_to_filter ) )
		dw_report.Filter( )
		dw_report.SetRedraw( TRUE )
		
		return 0

	case "FROM_WH_CODE"

		SetNull ( ls_Null )
		this.Object.Owner_code[1] = ls_Null
		
		idwc_Owner.Retrieve ( data )	// LTK 20160421 Added
		idwc_Owner.SetSort("Cust_Code A")

		return 0

	case "OWNER_CODE"

		// LTK 20160408 Added owner case
		dw_report.Setredraw( FALSE )
		is_owner_filter = "rm_user_field6 = '" + data + "' "
/*TAM 2018/03 S16210 - to turn multi select DW on/off when clicking DDDW for cust Type */
//		dw_report.SetFilter( wf_and_it( is_warehouse_filter, is_owner_filter, is_rdd_from_filter, is_rdd_to_filter ) )
		dw_report.SetFilter( wf_and_it( is_warehouse_filter, is_owner_filter, is_rdd_from_filter, is_rdd_to_filter, is_cust_type_to_filter ) )
		dw_report.Filter( )
		dw_report.SetRedraw( TRUE )
		
		return 0
	
		
	case "RDD_FROM_DATE"
		
		// LTK 20160408 Added RDD case
		dw_report.Setredraw( FALSE )
		is_rdd_from_filter = "dm_request_date >= " + String( DateTime( data ), "yyyy-mm-dd")
/*TAM 2018/03 S16210 - to turn multi select DW on/off when clicking DDDW for cust Type */
//		dw_report.SetFilter( wf_and_it( is_warehouse_filter, is_owner_filter, is_rdd_from_filter, is_rdd_to_filter ) )
		dw_report.SetFilter( wf_and_it( is_warehouse_filter, is_owner_filter, is_rdd_from_filter, is_rdd_to_filter, is_cust_type_to_filter ) )
		dw_report.Filter( )
		dw_report.SetRedraw( TRUE )
		
		return 0

				
	case "RDD_TO_DATE"

		// LTK 20160408 Added RDD case
		dw_report.Setredraw( FALSE )
		is_rdd_to_filter = "dm_request_date < " + String( RelativeDate(Date( data ), 1), "yyyy-mm-dd" )
/*TAM 2018/03 S16210 - to turn multi select DW on/off when clicking DDDW for cust Type */
//		dw_report.SetFilter( wf_and_it( is_warehouse_filter, is_owner_filter, is_rdd_from_filter, is_rdd_to_filter ) )
		dw_report.SetFilter( wf_and_it( is_warehouse_filter, is_owner_filter, is_rdd_from_filter, is_rdd_to_filter, is_cust_type_to_filter ) )
		dw_report.Filter( )
		dw_report.SetRedraw( TRUE )
		
		return 0

/*TAM 2018/03 S16210 - to turn multi select DW on/off when clicking DDDW for cust Type */
	Case 'CUST_TYPE'
		uo_cust_type.uf_set_filter( data)
		dw_report.Setredraw( FALSE )
		is_cust_type_to_filter = uo_cust_type.uf_build_search( false)
		dw_report.SetFilter( wf_and_it( is_warehouse_filter, is_owner_filter, is_rdd_from_filter, is_rdd_to_filter, is_cust_type_to_filter ) )
		dw_report.Filter( )
		dw_report.SetRedraw( TRUE )
		
				
End Choose

end event

event dw_select::clicked;call super::clicked;string 	ls_column

long		ll_row

this.AcceptText()
ls_column 	= DWO.Name
ll_row 		= this.GetRow()

CHOOSE CASE ls_column
		
	Case "cust_type" 
		
		uf_showhide_cust_type("cust_type")	

		dw_report.Setredraw( FALSE )
		is_cust_type_to_filter = uo_cust_type.uf_build_search( false)
		dw_report.SetFilter( wf_and_it( is_warehouse_filter, is_owner_filter, is_rdd_from_filter, is_rdd_to_filter, is_cust_type_to_filter ) )
		dw_report.Filter( )
		dw_report.SetRedraw( TRUE )
		
		
CASE ELSE
		
END CHOOSE

end event

event dw_select::losefocus;call super::losefocus;accepttext()
end event

type cb_clear from w_std_report`cb_clear within w_pandora_inbound_intransit_rpt
integer x = 4279
integer y = 8
integer width = 261
integer taborder = 20
end type

type dw_report from w_std_report`dw_report within w_pandora_inbound_intransit_rpt
integer y = 556
integer width = 3982
integer height = 1472
integer taborder = 30
string dataobject = "d_pandora_inbound_intransit_rpt"
boolean hscrollbar = true
end type

type uo_cust_type from uo_multi_select_search within w_pandora_inbound_intransit_rpt
event ue_mousemove pbm_mousemove
event destroy ( )
boolean visible = false
integer x = 2085
integer y = 88
integer width = 1038
integer taborder = 40
boolean bringtotop = true
end type

event ue_mousemove;//if ib_show_cust_type then
//	ib_show_cust_type = false
//	this.bringtotop = false
//else
//	ib_show_cust_type = true
//	this.bringtotop = true
//end if
//
end event

on uo_cust_type.destroy
call uo_multi_select_search::destroy
end on

type cb_do_clear from commandbutton within w_pandora_inbound_intransit_rpt
integer x = 3342
integer y = 188
integer width = 270
integer height = 96
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Clear"
end type

event clicked;/*TAM 2018/05 S16210 - Clear other values */
dw_select.Reset()
dw_select.InsertRow(0)

/*TAM 2018/03 S16210 - to turn multi select DW on/off when clicking DDDW for cust Type */
uo_cust_type.visible = true
uo_cust_type.bringtotop = false
ib_show_cust_type = False
uo_cust_type.uf_clear_list( )
dw_select.setItem(1,"cust_type", "<Select Multiple>")

/*TAM 2018/05 S16210 - Clear other values */
is_warehouse_filter = ''
is_owner_filter = ''
is_rdd_from_filter = ''
is_rdd_to_filter = ''
is_cust_type_to_filter = ''

dw_report.Setredraw( FALSE )
dw_report.SetFilter( wf_and_it( is_warehouse_filter, is_owner_filter, is_rdd_from_filter, is_rdd_to_filter, is_cust_type_to_filter ) )
//dw_report.SetFilter( '' )
dw_report.Filter( )
dw_report.SetRedraw( TRUE )
return 0

end event

event constructor;
g.of_check_label_button(this)
end event

