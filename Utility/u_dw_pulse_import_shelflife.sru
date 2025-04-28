HA$PBExportHeader$u_dw_pulse_import_shelflife.sru
$PBExportComments$Import Pulse Shelflife updates
forward
global type u_dw_pulse_import_shelflife from u_dw_import
end type
end forward

global type u_dw_pulse_import_shelflife from u_dw_import
integer width = 3077
integer height = 1572
string dataobject = "d_pulse_import_shelflife"
boolean border = false
borderstyle borderstyle = stylebox!
end type
global u_dw_pulse_import_shelflife u_dw_pulse_import_shelflife

forward prototypes
public function string wf_validate (long al_row)
public function integer wf_save ()
end prototypes

public function string wf_validate (long al_row);// 12/02 PCONKL - Validate Pull order for Pulse

String	lsPlant,	&
			lsSKU,		&
			lsInvoice,	&
			lsQTY
			
Long		llCount

//SKU is Required
lsSKU = This.GetITemString(al_row,'SKU')
If len(lsSKU) < 1 or lsSKU = '' Then
	This.SetFocus()
	This.SetRow(al_row)
	This.SetColumn('SKU')
	return "'SKU' is Required"
End If

//SKU must be valid 
Select Count(*) into :llCount
From Item_MASter
Where project_id = :gs_Project and sku = :lsSKU;

If llCount < 1 Then
	This.SetFocus()
	This.SetRow(al_row)
	This.SetColumn('SKU')
	return "'SKU is Invalid. "
End If

//Shelf Life must be present and Numeric
lsQTY =  This.GetITemString(al_row,'Shelf_Life')
If lsQTY > '' Then
	If Not isNumber(lsQTY) Then
		This.SetFocus()
		This.SetRow(al_row)
		This.SetColumn('Shelf_Life')
		return "'Shelf Life' must be numeric"
	End If
Else /* Not present*/
	This.SetFocus()
	This.SetRow(al_row)
	This.SetColumn('Shelf_Life')
	return "'Shelf Life' is Required."
End If

iscurrvalcolumn = ''
return ''

end function

public function integer wf_save ();Long	llRowCount, llRowPos, llShelfLife, llContentCount, llContentPos, llItemsUpdated, llContentupdated
String	lsSKU
Integer	liRC

Date	ldtCompleteDate, ldtExpDate

Datastore	ldsContent

ldsContent = Create Datastore
ldsContent.Dataobject = 'd_pulse_shelflife_content'
ldsContent.SetTransObject(SQLCA)

llRowCount = This.RowCount()

llItemsUpdated = 0
llContentupdated = 0

SetPointer(Hourglass!)

//For each import row - Update all sku's in content with Expiration date calculated from Shelf Life

/*** 07/10 - PCONKL - moving each row to a seperate transaction to reduce locking ***/

//Execute Immediate "Begin Transaction" using SQLCA; /* 11/04 - PCONKL - Auto Commit Turned on to eliminate DB locks*/

For llRowPos = 1 to llRowCOunt
	
	w_main.SetmicroHelp("Updating Row " + string(llRowPos) + " of " + string(llRowCount))
		
	lsSKU = This.GetITemString(llRowPos,'SKU')
	llShelfLife = Long(This.GetITemString(llRowPos,'shelf_Life'))
	
	// For each Content record fior this sku, set the expiration_date
	llContentCount = ldsContent.Retrieve(gs_Project, lsSKU)
	
	If llCOntentCount > 0 Then llItemsUpdated ++
	
	For llContentPos = 1 to llContentCount
		
		/*Exp Date maybe already set by user*/
		If String(ldsContent.GetITemDateTime(llContentPos,'content_expiration_date'),"mm/dd/yyyy") <> "12/31/2999" Then Continue 
		
		ldtCompleteDAte = Date(ldsContent.GetITemDateTime(llContentPos,'receive_master_complete_date'))
		ldtExpDate = RelativeDate(ldtCompleteDate, llShelfLife)
		
		ldsContent.SetITem(llContentPos,'content_expiration_date', ldtExpDate)
		ldsContent.SetITem(llContentPos,'content_Last_Update', Today())
		ldsContent.SetITem(llContentPos,'content_LAst_User', gs_userid)
		
		llContentupdated ++
				
	Next /*Content record for SKU*/
	
	Execute Immediate "Begin Transaction" using SQLCA;
	
	liRC = ldsContent.Update(fALSE, FALSE)
	
	If liRC < 0 Then
		Execute Immediate "Rollback" using SQLCA;
		MessageBox("Import","Row: " + String(llRowPos) + " Unable to Save changes! No changes made to Database!")
		Return -1
	End If
	
	Execute Immediate "Commit" using SQLCA;
	If sqlca.sqlcode <> 0 Then
		MessageBox("Import","Unable to Commit changes! No changes made to Database!")
		Return -1
	End If

Next /*Next Import Row*/

//Commit Using Sqlca;
//If sqlca.sqlcode <> 0 Then
//	MessageBox("Import","Unable to Commit changes! No changes made to Database!")
//	Return -1
//End If

MessageBox("Import",String(llItemsUpdated) + " Item Master records Updated~r~r" + String(llContentupdated) + " Content records updated!")
w_main.SetmicroHelp("Ready")
SetPointer(Arrow!)

Return 0
end function

on u_dw_pulse_import_shelflife.create
call super::create
end on

on u_dw_pulse_import_shelflife.destroy
call super::destroy
end on

event dberror;call super::dberror;Messagebox('',sqlerrtext)
end event

