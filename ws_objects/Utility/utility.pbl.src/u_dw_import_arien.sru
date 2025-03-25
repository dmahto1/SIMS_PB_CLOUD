$PBExportHeader$u_dw_import_arien.sru
$PBExportComments$Import ItemMaster - FedEx Tracking information
forward
global type u_dw_import_arien from u_dw_import
end type
end forward

global type u_dw_import_arien from u_dw_import
integer width = 3077
integer height = 1572
string dataobject = "d_import_skuserialhold_in"
borderstyle borderstyle = stylebox!
end type
global u_dw_import_arien u_dw_import_arien

type variables

end variables

forward prototypes
public function string wf_validate (long al_row)
public function integer wf_save ()
end prototypes

public function string wf_validate (long al_row);		
//gap 5-03 Validate fields for FedEx Tracking trans.out file

String	lsSKU, lsSerial
integer 	liCarton,liLineItem 
			
long		llCount

SetPointer(Hourglass!)

lsSku = this.getitemstring( al_row, 'Sku')
lsSku = this.getitemstring( al_row, 'Serial_No')

//check to see if record exists in Sku_Serial_Hold
	Select Count(*)  into :llCount
	from Sku_Serial_No
	Where Project_ID = :gs_Project and Sku=:lsSku and Serial_No = :lsSerial
	Using SQLCA;

	If llCount <= 0 Then
		//Insert into SKU_Serail_no table
		This.Setfocus()
		This.SetColumn("SKU")
		iscurrvalcolumn = "SKU"
		Return "SKU does not exist!"
	End If
iscurrvalcolumn = ''

SetPointer(Arrow!)
Return ''

end function

public function integer wf_save ();//Long	llRowCount,	&
//		llRowPos,	&
//		llUpdate
//		
//String	lsOrderNo, 	&
//			lsDono,		&
//			lsCarton,	&
//			lsLineItem,	&
//			lsSku,		&
//			lsErrText,	&
//			lsSQL,		&
//			lsTrackingNo
//			
//Date		ldToday
//
//ldToday = Today()
//llRowCount = This.RowCount()
//
//llupdate = 0
//
//SetPointer(Hourglass!)
//
////Update each Row...
//
//Execute Immediate "Begin Transaction" using SQLCA; /* 11/04 - PCONKL - Auto Commit Turned on to eliminate DB locks*/
//
//For llRowPos = 1 to llRowCOunt
//	
//	w_main.SetmicroHelp("Saving Row " + string(llRowPos) + " of " + string(llRowCount))	
//
//	lsDono = gs_project + trim(This.GetItemString(llRowPos,"DoNo"))
//	lsCarton = string(This.GetItemNumber(llRowPos,"CartonNo"))
//	lsLineItem = string(This.GetItemNumber(llRowPos,"LineItemNo"))
//	lsTrackingNo = trim(This.GetItemString(llRowPos,"TrackingNo"))
//	lsOrderNo = trim(This.GetItemString(llRowPos,"OrderNo"))
//	
//	lsSQL = "Update Delivery_Packing Set "
//	lsSQL += "Shipper_Tracking_ID = '" + lsTrackingNo + "'"
//	lsSQl += " Where do_no = '" + lsDono + "'"
//	lsSQl += " and carton_no = " + lsCarton
//	lsSQl += " and line_item_no = " + lsLineItem  /*Where*/
//	
//	Execute Immediate :LSSQL Using SQLCA;
//	If sqlca.sqlcode <> 0 Then
//		lsErrText = sqlca.sqlerrtext /*text will be lost after rollback*/
//		Execute Immediate "ROLLBACK" using SQLCA;
//		Messagebox("Import","Unable to save changes to database!~r~r" + lsErrText)
//		SetPointer(Arrow!)
//		Return -1
//	End If	
//		
//	llupdate ++
//Next
//
//Execute Immediate "COMMIT" using SQLCA;
//If sqlca.sqlcode <> 0 Then
//	MessageBox("Import","Unable to Commit changes! No changes made to Database!")
//	Return -1
//End If
//
//MessageBox("Import","Records saved.~r~rRecords Updated: " + String(llUpdate))
//w_main.SetmicroHelp("Ready")
//SetPointer(Arrow!)
Return 0
end function

on u_dw_import_arien.create
call super::create
end on

on u_dw_import_arien.destroy
call super::destroy
end on

