HA$PBExportHeader$w_siemens_inv_qty_on_hand.srw
forward
global type w_siemens_inv_qty_on_hand from w_std_report
end type
type st_msg from statictext within w_siemens_inv_qty_on_hand
end type
end forward

global type w_siemens_inv_qty_on_hand from w_std_report
string title = "Quantity On Hand Inventory Report"
st_msg st_msg
end type
global w_siemens_inv_qty_on_hand w_siemens_inv_qty_on_hand

type variables
integer success = 1
integer failure = -1
integer nothing = 0

datastore	idsItemMaster
datastore	idsItemContent
datastore	idsSupplier
datastore	idsInventorytype

string isProjectId
string isDefaultProject = 'SIEMENS-LM'
string isWarehouse

string isCurrentWarehouse

string isWarehouses[]

string isContentFilter




end variables

forward prototypes
public subroutine setproject (string asproject)
public function string getproject ()
public subroutine setwarehouse (string aswarehouse)
public function string getwarehouse ()
public function integer setwarehouselist ()
public function integer docontentfilter (string asfilter)
public function string getwarehouse (integer _index)
public function integer setreportddata ()
public subroutine setcontentfilter (string asfilter)
public function string getcontentfilter ()
public subroutine setcurrentwarehouse (string aswarehouse)
public function string getcurrentwarehouse ()
public function integer setcontentrows (string assku)
public subroutine doresetcontentds ()
public function string getsupplier (string ascode)
public function string getinventorytype (string ascode)
public subroutine docontrolbreak (string assku, string astype, decimal advalue, integer aindex)
end prototypes

public subroutine setproject (string asproject);// setProject( string asProject )
isProjectId = asProject

end subroutine

public function string getproject ();// string = getProject()
return isProjectId

end function

public subroutine setwarehouse (string aswarehouse);// setWarehouse( string asWarehouse )
isWarehouse = asWarehouse

end subroutine

public function string getwarehouse ();// string = getWarehouse()
return isWarehouse


end function

public function integer setwarehouselist ();// integer = setWarehouselist()

string 					_selected
string 					_empty[]
long						_childrows
long						_index
datawindowchild	_adwc

_selected = getWarehouse()
if IsNull( _selected ) or len( _selected ) = 0 then return failure

iswarehouses = _empty

if _selected <> 'all' then
	iswarehouses[ 1 ] = getWarehouse()
	return success
end if

dw_select.getchild("warehouse_code",_adwc )
_adwc.setfilter( 'wh_code <> ~'all~'')
_adwc.filter()

_childrows = _adwc.rowcount()
for _index = 1 to _childrows
	iswarehouses[ _index ] = _adwc.getitemstring( _index , "wh_code")
next

return success




end function

public function integer docontentfilter (string asfilter);// integer = doContentFilter( string asFilter )

string filterbegin = 'wh_code = ~''
string filterend = "~'"
string sFilter
int resultcode

sFilter = filterbegin + Trim( asFilter ) + filterend
idsitemcontent.setfilter( sFilter )
idsitemcontent.filter()

if idsitemcontent.rowcount() <=0 then return failure

setContentFilter( sFilter )
setCurrentWarehouse( asFilter )

return success

end function

public function string getwarehouse (integer _index);// string = getWarehouse( integer _index )
if _index > UpperBound( isWarehouses ) then return ''

return isWarehouses[ _index ]
end function

public function integer setreportddata ();// integer = setReportdDate()

long index
long innerIndex
decimal{5} avail_qty
string inv_type
string inv_type_save
long reportRow
long itemRows
long contentRows
string sku

setPointer( hourglass! )

itemRows = idsitemmaster.rowcount()

for index = 1 to itemRows
	sku = idsitemmaster.object.sku[ index ]
	contentRows = setContentRows( Trim(sku)  )
	if contentRows <= 0 then
		avail_qty = 0
		inv_type = ''
		doControlBreak( sku, inv_type, avail_qty, index )
	else
		inv_type_save = '*'
		for innerIndex = 1 to contentRows
			inv_type = idsItemContent.object.inventory_type[ innerIndex ]
			if inv_type_save = "*" then inv_type_save = inv_type
			if inv_type <> inv_type_save then 
				doControlBreak( sku, inv_type_save, avail_qty, index )
				inv_type_save = inv_type
				avail_qty = idsitemcontent.object.avail_qty[ innerIndex]
			else
				avail_qty += idsitemcontent.object.avail_qty[ innerIndex]
			end if
		next
		doControlBreak( sku, inv_type, avail_qty, index )
	end if
	doResetContentds()
	avail_qty = 0
next

if reportRow < 0 then return failure

dw_report.object.t_project.text = getProject()

dw_report.groupcalc()

return success

end function

public subroutine setcontentfilter (string asfilter);// setContentFilter( string asFilter )
isContentFilter = asFilter

end subroutine

public function string getcontentfilter ();// string = getContentFilter()
return isContentFilter

end function

public subroutine setcurrentwarehouse (string aswarehouse);// setCurrentWarehouse( string asWarehouse )
isCurrentWarehouse = asWarehouse

end subroutine

public function string getcurrentwarehouse ();// string = getCurrentWarehouse()
return isCurrentWarehouse


end function

public function integer setcontentrows (string assku);// integer = setContentRows( string asSKU )

string filterbegin = 'sku = ~''
string filterend = "~'"
string sFilter
long 	filteredRows

int resultcode

sFilter = filterbegin + Trim( asSKU ) + filterend + 'and wh_code = ~'' + getCurrentWarehouse() + "~'"
idsitemcontent.setfilter( sFilter )
idsitemcontent.filter()
filteredRows = idsitemcontent.rowcount()

if filteredRows <=0 then return nothing
return filteredRows


end function

public subroutine doresetcontentds ();// doResetContentds()

idsItemContent.setfilter("")
idsItemContent.filter()

doContentFilter( getCurrentWarehouse() )


end subroutine

public function string getsupplier (string ascode);// string = getSupplier( string acode )

long foundrow
string searchbegin = "supp_code = ~'"
string searchend = "~'"
string searchfor

searchfor = searchbegin + asCode + searchend

foundrow = idssupplier.find( searchfor, 1, idssupplier.rowcount() )
if foundrow > 0 then	return idssupplier.object.supp_name[ foundrow ]

return asCode


end function

public function string getinventorytype (string ascode);// string = getInventoryType( string acode )

long foundrow
string searchbegin = "inv_type = ~'"
string searchend = "~'"
string searchfor

searchfor = searchbegin + Upper( trim( asCode)) + searchend

foundrow = idsinventorytype.find( searchfor, 1, idsinventorytype.rowcount() )
if foundrow > 0 then return idsinventorytype.object.inv_type_desc[ foundrow ]

return asCode


end function

public subroutine docontrolbreak (string assku, string astype, decimal advalue, integer aindex);// doControlBreak( string asSKU, string asType, decimal adValue, int index  )
long reportRow

	reportRow = dw_report.insertrow( 0)
	dw_report.object.warehouse[ reportRow ] = getCurrentWarehouse()
	dw_report.object.sku[ reportRow ]  = asSKU
	dw_report.object.description[ reportRow ] = idsitemmaster.object.description[ aIndex ]
	dw_report.object.supplier[ reportRow ] = getSupplier( idsitemmaster.object.supp_code[ aIndex ] )
	dw_report.object.inventory_type[ reportRow ] = getInventoryType( astype )
	dw_report.object.quantity[ reportRow ] = advalue

end subroutine

on w_siemens_inv_qty_on_hand.create
int iCurrent
call super::create
this.st_msg=create st_msg
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_msg
end on

on w_siemens_inv_qty_on_hand.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_msg)
end on

event ue_postopen;call super::ue_postopen;datawindowchild adwc
long childrow

// Initialize

setPointer( hourglass! )

this.setredraw( false )

setProject(  isDefaultProject  )

// add 'All' to selection dropdown

dw_select.getchild("warehouse_code",adwc )
adwc.settransobject( sqlca )
adwc.retrieve()
childrow = adwc.insertrow(0)
adwc.setitem( childrow, "warehouse_name"   , "-- ALL --" )
adwc.setitem( childrow, "wh_code"   , "all" )
adwc.setsort( "warehouse_name A")
adwc.sort()

// datastores

idsItemMaster = create datastore
idsItemMaster.dataobject = 'd_siemens_item_master_by_project_id'
idsItemMaster.settransobject( sqlca )
idsItemMaster.retrieve( getProject() )

idsItemContent = create datastore
idsItemContent.dataobject = 'd_siemens_content_by_project_id'
idsItemContent.settransobject( sqlca )
idsItemContent.retrieve( getProject() )

idsSupplier = create datastore
idsSupplier.dataobject = 'dddw_suppliers'
idsSupplier.settransobject( sqlca )
idsSupplier.retrieve( getProject() )

idsInventorytype = create datastore
idsInventorytype.dataobject = 'dddw_inventory_type_siemens_lm'
idsInventorytype.settransobject( sqlca )
idsInventorytype.retrieve( getProject() )

this.setredraw( true )
end event

event ue_retrieve;call super::ue_retrieve;int index
int max

if setWarehouseList() = failure then
	messagebox( this.title, "Select a Warehouse or ~'ALL~' from the Warehouse Dropdown, then re-try.",exclamation! )
	return
end if

SetPointer( Hourglass! )
st_msg.text = "Retrieving Data...Please Wait!"
this.setredraw( false )
dw_report.reset()
 // for each warehouse in the warehouse list...
max = Upperbound( isWarehouses )
for index = 1 to max
 // filter the content datastore to leave the warehouse content data
 	if doContentFilter( getWarehouse( index ) ) = failure then
		messagebox( this.title, "No Data Found For Warehouse Selected, Aborting Report.",exclamation! )
		exit
	end if
 	if setReportdData() = failure then
		messagebox( this.title, "There Was a Problem Matching Inventory To Content, Aborting Report.",exclamation! )
		exit
	end if
next
st_msg.text = ""
this.setredraw(true)

end event

event resize;call super::resize;dw_report.event ue_resize()

end event

type dw_select from w_std_report`dw_select within w_siemens_inv_qty_on_hand
integer width = 1317
integer height = 108
string dataobject = "d_siemens_warehouse_select"
boolean border = false
end type

event dw_select::itemchanged;call super::itemchanged;choose case lower( dwo.name )
	case 'warehouse_code'
		setWarehouse( trim( data ) )
end choose

end event

type cb_clear from w_std_report`cb_clear within w_siemens_inv_qty_on_hand
integer taborder = 20
end type

type dw_report from w_std_report`dw_report within w_siemens_inv_qty_on_hand
event ue_resize ( )
integer x = 5
integer taborder = 30
string dataobject = "d_siemens_qty_on_hand_ext"
boolean hscrollbar = true
end type

event dw_report::ue_resize();
this.width = (parent.width - 50)
this.height = ( parent.height - ( dw_select.height + 192 ) )
end event

type st_msg from statictext within w_siemens_inv_qty_on_hand
integer x = 1385
integer y = 40
integer width = 1929
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean focusrectangle = false
end type

