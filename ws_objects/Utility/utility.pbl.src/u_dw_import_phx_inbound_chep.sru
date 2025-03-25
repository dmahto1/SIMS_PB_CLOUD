$PBExportHeader$u_dw_import_phx_inbound_chep.sru
forward
global type u_dw_import_phx_inbound_chep from u_dw_import
end type
end forward

global type u_dw_import_phx_inbound_chep from u_dw_import
string title = "Import Phx Inbound Chep"
string dataobject = "d_import_phx_inbound_chep"
end type
global u_dw_import_phx_inbound_chep u_dw_import_phx_inbound_chep

forward prototypes
public function string wf_validate (long al_row)
public function integer wf_save ()
end prototypes

public function string wf_validate (long al_row);//Jxlim 04/19/10 
String lstemp, lsday, lsmon, lsyear, lsSuplOrdNo, lsMsg
long llcount
//Validate for valid field length and type

// if Currvalcolumn > '' then we didn't validate the whole row, start with the next column
Choose Case iscurrvalcolumn
	Case "supplier_order_nbr" 
		goto lssuppordnbr
	Case "chep_proc_dt"
		goto lprocdt
	case "chep_ref_nbr"
		goto lrefnbr
	case "chep_recon_qty"
		goto lreconqty
	case "lssuppordnbr"
		iscurrvalcolumn = ''
		Return ''
End Choose

//Validate Supplier Order Number must be valid and exist!
lssuppordnbr:
lsSuplOrdNo = This.getItemString(al_row,"supplier_order_nbr")
// Supplier Order Number must be Exist
IF isNull( lsSuplOrdNo ) or len(lsSuplOrdNo ) = 0 then 
	lsMsg= "Supplier Order Number' can not be null!"
	Return lsMsg
End IF
// Supplier Order Number must be Valid
IF (Not isnull(lsSuplOrdNo)) and lsSuplOrdNo > ' ' Then
		Select Count(*) into :llCount
		From Receive_Master 
		Where project_id = :gs_project 
		and supp_order_no = :lsSuplOrdNo
		and ord_status = 'C'
		Using SQLCA;
				
		If llCount <= 0 Then
			lsMsg="Supplier Order Number' Does Not Exist!"
			Return  lsMsg
			This.Setfocus()
			This.SetColumn("suppplier_order_nbr")
			iscurrvalcolumn = "suppplier_order_nbr"			
		End If		
End If /*Supplier Order Number*/

lprocdt:
//Validate Chep Proc Dt must be a valid date
lsTEMP = This.GetItemString(al_row, "chep_proc_dt")
IF not isnull(lsTEMP) then
	//yyyy/mm/dd  - This isn't being interpreted as a date, so...
	IF len(lsTemp) <> 10 THEN
		This.Setfocus()
		This.SetColumn("chep_proc_dt")
		iscurrvalcolumn = "chep_proc_dt"
		Return "Unexpected format: 'Chep Proc Date' must be yyyy/mm/dd!"
	END IF	
END IF
If isnull(lsTEMP) or not isdate(lsTEMP) Then
	This.Setfocus()
	This.SetColumn("chep_proc_dt")
	iscurrvalcolumn = "chep_proc_dt"
	Return "'Chep Proc Date' can not be null and must be a date!"
End If	

lrefnbr:
//Validate Chep Ref Nbr must be <= 30 characters
If len(trim(This.getItemString(al_row,"chep_ref_nbr"))) > 30 Then
	This.Setfocus()
	This.SetColumn("chep_ref_nbr")
	iscurrvalcolumn = "chep_ref_nbr"
	Return "Chep Ref Nbr must be less or equal to 30 characters!"
End If

lreconqty:
//Validate chep Recon Qty must be numeric
If not isnumber(This.getItemString(al_row,"chep_recon_qty")) Then
	This.Setfocus()
	This.SetColumn("chep_recon_qty")
	iscurrvalcolumn = "chep_recon_qty"
	Return "Chep Recon Qty must be numeric!"
End If

iscurrvalcolumn = ''
return ''

end function

public function integer wf_save ();//Jxlim 04/19/2010 New for Phoenix Import Inbound
Long		llRowCount,	llRowPos, llNew
String		lsErrText,  lsToday, lsDay, lsTime, lsTemp
String		lsSuppOrdNbr, lsChepRefnbr, lsChepProcDate, lsChepReconQty
Datetime		ldToday

// pvh 02.15.06 - gmt
ldToday = f_getLocalWorldTime( gs_default_wh ) 
lsToday = string(ldToday)
lsDay = string(date(ldToday))
lsTime = string(time(ldToday))

llRowCount = This.RowCount()

SetPointer(Hourglass!)

//For each Supplier Order Number, update all orders that are in 'C' status....
lsTemp = 'Set to Complete at ' + lsTime + ' on ' + lsDay 
For llRowPos = 1 to llRowCount	
	w_main.SetmicroHelp("Saving Row " + string(llRowPos) + " of " + string(llRowCount))
	lsSuppOrdNbr = This.GetItemString(llRowPos, "supplier_order_nbr")
	lsChepRefNbr = left(trim(This.GetItemString(llRowPos, "chep_ref_nbr")), 30)
	lsChepReconQty =This.GetItemString(llRowPos, "chep_recon_qty")
	lschepProcDate = This.GetItemString(llRowPos, "chep_proc_dt")  // yyyy/mm/dd

	Execute Immediate "Begin Transaction" using SQLCA;
	Update Receive_master 
	Set User_field10 = :lsChepProcDate, 
	User_Field12 = :lsChepRefNbr, 
	User_Field13 = :lsChepReconQty
	Where project_id = :gs_project 
	and supp_order_no = :lsSuppOrdNbr
	Using SQLCA;
	
	If sqlca.sqlcode <> 0 Then
		lsErrText = sqlca.sqlerrtext /*text will be lost after rollback*/
		Execute Immediate "ROLLBACK" using SQLCA;
		Messagebox("Import","Unable to save changes to database!~r~r" + lsErrText)
		SetPointer(Arrow!)
		Return -1
	Else
		llnew ++		
	End If
	
	Execute Immediate "COMMIT" using SQLCA;
	If sqlca.sqlcode <> 0 Then
		MessageBox("Import","Record " + string(llnew) + ": Unable to Commit changes! No changes made to Database!")
		Return -1
	End If		
Next

MessageBox("Import","Records saved.~r~rRecords Added: " + String(llNew))
w_main.SetmicroHelp("Ready")
SetPointer(Arrow!)
Return 0
end function

on u_dw_import_phx_inbound_chep.create
call super::create
end on

on u_dw_import_phx_inbound_chep.destroy
call super::destroy
end on

