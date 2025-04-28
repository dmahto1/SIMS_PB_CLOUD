HA$PBExportHeader$u_dw_import_pandora_alt_address.sru
$PBExportComments$Import Supplier Information
forward
global type u_dw_import_pandora_alt_address from u_dw_import
end type
end forward

global type u_dw_import_pandora_alt_address from u_dw_import
integer width = 3077
integer height = 1572
end type
global u_dw_import_pandora_alt_address u_dw_import_pandora_alt_address

forward prototypes
public function string wf_validate (long al_row)
public function integer wf_save ()
end prototypes

public function string wf_validate (long al_row);
//    THIS VALIDATION IS ALREADY PERFORMED ON EACH COLUMN BEFORE THIS FUNCTION IS CALLED FOR THE ROW COLUMN  VIA POWERBUILDER




//iscurrvalcolumn = This.GetColumnName()
//
////Validate for valid field length and type
//
//// if Currvalcolumn > '' then we didn't validate the whole row, start with the next column
//Choose Case iscurrvalcolumn
//
//	Case "pandora_finance_data_wh_code"
//		goto wh_code
//
//	Case "pandora_finance_data_owner_cd"
//		goto owner_code
//
//	Case "pandora_finance_data_intl"
//		goto intl
//
//	Case "pandora_finance_data_in_out"
//		goto in_out
//
//	Case "pandora_finance_data_complete_date"
//		goto complete_date
//
//	Case "pandora_finance_data_system_number"
//		goto system_number
//
//	Case "pandora_finance_data_invoice_no"
//		goto invoice_no
//
//	Case "pandora_finance_data_line_item_no"
//		goto line_item_no
//
//	Case "pandora_finance_data_EUCntry"
//		goto EUCntry
//
//	Case "pandora_finance_data_ThirdParty"
//		goto ThirdParty
//
//	Case "pandora_finance_data_returns"
//		goto returns
//
//	Case "pandora_finance_data_S_Commodity"
//		goto S_Commodity
//
//	Case "pandora_finance_data_FromLoc"
//		goto FromLoc
//
//	Case "pandora_finance_data_SF_Name"
//		goto SF_Name
//
//	Case "pandora_finance_data_SF_Addr1"
//		goto SF_Addr1
//
//	Case "pandora_finance_data_SF_Addr2"
//		goto SF_Addr2
//
//	Case "pandora_finance_data_SF_City"
//		goto SF_City
//
//	Case "pandora_finance_data_SF_Zip"
//		goto SF_Zip
//
//	Case "pandora_finance_data_SF_Cntry"
//		goto SF_Cntry
//
//	Case "pandora_finance_data_wh_Ord_Type"
//		goto Ord_Type
//
//	Case "pandora_finance_data_TransType"
//		goto TransType
//
//	Case "pandora_finance_data_ST_Loc"
//		goto ST_Loc
//
//	Case "pandora_finance_data_ST_Name"
//		goto ST_Name
//
//	Case "pandora_finance_data_ST_Addr1"
//		goto ST_Addr1
//
//	Case "pandora_finance_data_ST_Addr2"
//		goto ST_Addr2
//
//	Case "pandora_finance_data_ST_City"
//		goto ST_City
//
//	Case "pandora_finance_data_ST_Zip"
//		goto ST_Zip
//
//	Case "pandora_finance_data_ST_Cntry"
//		goto ST_Cntry
//
//	Case "pandora_finance_data_SoldTo_Name"
//		goto SoldTo_Name
//
//	Case "pandora_finance_data_SoldTo_Addr1"
//		goto SoldTo_Addr1
//
//	Case "pandora_finance_data_SoldTo_Addr2"
//		goto SoldTo_Addr2
//
//	Case "pandora_finance_data_SoldTo_City"
//		goto SoldTo_City
//
//	Case "pandora_finance_data_SoldTo_Zip"
//		goto SoldTo_Zip
//
//	Case "pandora_finance_data_SoldTo_Cntry"
//		goto SoldTo_Cntry
//
//	Case "pandora_finance_data_SKU"
//		goto SKU
//
//	Case "pandora_finance_data_Description"
//		goto Description
//
//	Case "pandora_finance_data_VendorName"
//		goto VendorName
//
//	Case "pandora_finance_data_alternate_sku"
//		goto alternate_sku
//
//	Case "pandora_finance_data_Alloc_qty"
//		goto Alloc_qty
//
//	Case "pandora_finance_data_Cost"
//		goto Cost
//
//	Case "pandora_finance_data_ExtendedCost"
//		goto ExtendedCost
//
//	Case "pandora_finance_data_CurCode"
//		goto CurCode
//
//	Case "pandora_finance_data_HTS"
//		goto wh_HTS
//
//	Case "pandora_finance_data_ECCN"
//		goto ECCN
//
//	Case "pandora_finance_data_COO"
//		goto COO
//
//	Case "pandora_finance_data_Supl_Integration"
//		goto Supl_Integration
//
//	Case "pandora_finance_data_ORG"
//		goto	ORG
//
//	Case "pandora_finance_data_PO_NO"
//		goto PO_NO
//
//	Case "pandora_finance_data_CostCenter"
//		goto CostCenter
//
//	Case "pandora_finance_data_ValueID"
//		goto ValueID
//
//	Case "pandora_finance_data_CI_Num"
//		goto CI_Num
//
//	Case "pandora_finance_data_requestor"
//		goto requestor
//
//	Case "pandora_finance_data_remark"
//		goto remark
//
//	Case "pandora_finance_data_CntryOfDispatch"
//		goto CntryOfDispatch
//
//	Case "pandora_finance_data_Commodity"
//		goto Commodity
//
//	Case "pandora_finance_data_FromCntry"
//		goto FromCntry
//
//	Case "pandora_finance_data_ToCntry"
//		goto ToCntry
//
//	Case "pandora_finance_data_Vat_ID"
//		goto Vat_ID
//
//	Case "pandora_finance_data_Transport_mode"
//		goto Transport_mode
//
//	Case "pandora_finance_data_Wgt"
//		goto Wgt
//
//	Case "pandora_finance_data_ExtendedWgt"
//		goto ExtendedWgt
//
//	Case "pandora_finance_data_Customer_type"
//		goto Customer_type
//
//End Choose
//
//
// wh_code:
//
//If len(trim(This.getItemString(al_row,iscurrvalcolumn))) > 50 Then
//	This.Setfocus()
//	This.SetColumn(iscurrvalcolumn)
//	Return iscurrvalcolumn +" is > 50 Characters"
//Else
//	Return ""
//End If
//
//owner_code:
//
//If len(trim(This.getItemString(al_row,iscurrvalcolumn))) > 20 Then
//	This.Setfocus()
//	This.SetColumn(iscurrvalcolumn)
//	Return iscurrvalcolumn +" is > 20 Characters"
//Else
//	Return ""
//End If
//
//intl:
//
//in_out:
//
//complete_date:
//
//system_number:
//
//invoice_no:
//
//line_item_no:
//
//EUCntry:
//
//ThirdParty:
//
//returns:
//
//S_Commodity:
//
//FromLoc:
//
//SF_Name:
//
//SF_Addr1:
//
//SF_Addr2:
//
//SF_City:
//
//SF_Zip:
//
//SF_Cntry:
//
//Ord_Type:
//
//TransType:
//
//ST_Loc:
//
//ST_Name:
//
//ST_Addr1:
//
//ST_Addr2:
//
//ST_City:
//
//ST_Zip:
//
//ST_Cntry:
//
//SoldTo_Name:
//
//SoldTo_Addr1:
//
//SoldTo_Addr2:
//
//SoldTo_City:
//
//SoldTo_Zip:
//
//SoldTo_Cntry:
//
//SKU:
//
//Description:
//
//VendorName:
//
//alternate_sku:
//
//Alloc_qty:
//
//Cost:
//
//ExtendedCost:
//
//CurCode:
//
//wh_HTS:
//
//ECCN:
//
//COO:
//
//Supl_Integration:
//
//ORG:
//
//PO_NO:
//
//CostCenter:
//
//ValueID:
//
//CI_Num:
//
//requestor:
//
//remark:
//
//CntryOfDispatch:
//
//Commodity:
//
//FromCntry:
//
//ToCntry:
//
//Vat_ID:
//
//Transport_mode:
//
//Wgt:
//
//ExtendedWgt:
//
//Customer_type:
//
//
//
//////Validate Supplier Code
////If isnull(This.getItemString(al_row,"supplier_code")) Then
////	This.Setfocus()
////	This.SetColumn("supplier_code")
////	iscurrvalcolumn = "supplier_code"
////	return "'Supplier Code' can not be null!"
////End If
////
////If len(trim(This.getItemString(al_row,"supplier_code"))) > 10 Then
////	This.Setfocus()
////	This.SetColumn("supplier_code")
////	iscurrvalcolumn = "supplier_code"
////	return "'Supplier Code' is > 10 characters"
////End If
////	
////lsuppname:
////Validate Supplier Name
//If len(trim(This.getItemString(al_row,"supplier_name"))) > 40 Then
//	This.Setfocus()
//	This.SetColumn("supplier_name")
//	iscurrvalcolumn = "supplier_name"
//	Return "Supplier Name is > 40 Characters"
//End If
//
////laddr1:
//////Validate Address 1
////If len(trim(This.getItemString(al_row,"address1"))) > 40 Then
////	This.Setfocus()
////	This.SetColumn("address1")
////	iscurrvalcolumn = "address1"
////	Return "Address 1 is > 40 Characters"
////End If
////
////laddr2:
//////Validate Address 2
////If len(trim(This.getItemString(al_row,"address2"))) > 40 Then
////	This.Setfocus()
////	This.SetColumn("address2")
////	iscurrvalcolumn = "address2"
////	Return "Address 2 is > 40 Characters"
////End If
////	
////lstate:
//////Validate State
////If len(trim(This.getItemString(al_row,"state"))) > 40 Then
////	This.Setfocus()
////	This.SetColumn("state")
////	iscurrvalcolumn = "state"
////	Return "State is > 40 Characters"
////End If
////
////lzip:
//////Validate Zip
////If len(trim(This.getItemString(al_row,"zip"))) > 40 Then
////	This.Setfocus()
////	This.SetColumn("zip")
////	iscurrvalcolumn = "zip"
////	Return "Zip Code is > 40 Characters"
////End If
////
////lcity:
//////Validate City
////If len(trim(This.getItemString(al_row,"city"))) > 30 Then
////	This.Setfocus()
////	This.SetColumn("city")
////	iscurrvalcolumn = "city"
////	Return "City is > 30 Characters"
////End If
////
////lcountry:
//////Validate City
////If len(trim(This.getItemString(al_row,"country"))) > 30 Then
////	This.Setfocus()
////	This.SetColumn("country")
////	iscurrvalcolumn = "country"
////	Return "Country is > 30 Characters"
////End If
////
////lcontact:
//////Validate contact
////If len(trim(This.getItemString(al_row,"contact"))) > 40 Then
////	This.Setfocus()
////	This.SetColumn("contact")
////	iscurrvalcolumn = "contact"
////	Return "Contact is > 40 characters"
////End If
////
////ltel:
//////Validate Telephone
////If len(trim(This.getItemString(al_row,"telephone"))) > 20 Then
////	This.Setfocus()
////	This.SetColumn("telephone")
////	iscurrvalcolumn = "telephone"
////	Return "Telephone is > 20 characters"
////End If
////
iscurrvalcolumn = ''
return ''

end function

public function integer wf_save ();		
DateTime	ldt_begin_completion_date, &
				ldt_current_completion_date, &
				ldt_end_completion_date
				
Integer        li_update

Long			llRowCount,lRowNumber

String			lsErrText
				
llRowCount = THIS.RowCount()


SetPointer(Hourglass!)



FOR	lRowNumber  = 1 TO llRowCount
	
   	IF 		lRowNumber = 1 THEN
				ldt_begin_completion_date	 	= THIS.GetItemDateTime(1,"pandora_finance_data_complete_date")
		 		ldt_end_completion_date  		= ldt_begin_completion_date
	Else //* Count > 1
		         ldt_current_completion_date	= This.GetItemDateTime(lRowNumber,"pandora_finance_data_complete_date")
				If  ldt_current_completion_date <  ldt_begin_completion_date   Then 	ldt_begin_completion_date  =  ldt_current_completion_date
		 		If  ldt_current_completion_date >  ldt_end_completion_date  	  Then 	ldt_end_completion_date     = ldt_current_completion_date
	End If 
	
	SetItem(lRowNumber, "import_date", Now())
	
NEXT

 li_update = MessageBox("Import Rows", "Import will replace all Financial Data from "+String(ldt_begin_completion_date)+" to " + &
 								String(ldt_end_completion_date) + ". ~r~rSelect Yes to Save. ",  Exclamation!, YesNo!, 2)

IF  li_update = 1 THEN // Save Financial Data

	CONNECT USING SQLCA;

	Delete From Pandora_Finance_Data Where  complete_date >= :ldt_begin_completion_date and complete_date <= :ldt_end_completion_date USING SQLCA;

	If sqlca.sqlcode <> 0 Then
		lsErrText = sqlca.sqlerrtext /* sql error text returned */
		Messagebox("Import","Unable to delete existing rows in database!~r~r" + lsErrText)
		SetPointer(Arrow!)
		Return -1
	End If

	THIS.SetTransObject(SQLCA)
	
	THIS.Update() 

	If sqlca.sqlcode <> 0 Then
		lsErrText = sqlca.sqlerrtext /* sql error text returned */
		Execute Immediate "ROLLBACK" using SQLCA;
		Messagebox("Import","Unable to insert import records to database!~r~r" + lsErrText)
		SetPointer(Arrow!)
		Return -1
	Else
		Commit using SQLCA;
	End If
	
	MessageBox("Import","Financial Records saved to Database.~r~rRecords Added: " + String(llRowCount))
	w_main.SetmicroHelp("Ready")
	SetPointer(Arrow!)
	Return 87
Else
	
	MessageBox("Import","No Records saved to Database.~r~rSelect OK to Continue. " )
	w_main.SetmicroHelp("Ready")
	SetPointer(Arrow!)
	Return -87
	
End If


end function

on u_dw_import_pandora_alt_address.create
call super::create
end on

on u_dw_import_pandora_alt_address.destroy
call super::destroy
end on

event ue_save;call super::ue_save;long ll_returncode, ll_numrows, ll_rownum, ll_reccount
DateTime	ldt_begin_completion_date, &
				ldt_current_completion_date, &
				ldt_end_completion_date
				
Long			llRowCount,lRowNumber

string			lsErrText


								
llRowCount = THIS.RowCount()


SetPointer(Hourglass!)

FOR	lRowNumber  = 1 TO llRowCount
	
  		IF 		lRowNumber = 1 THEN
				ldt_begin_completion_date	 	= THIS.GetItemDateTime(1,"complete_date")
		 		ldt_end_completion_date  		= THIS.GetItemDateTime(1,"complete_date")
		Else //* Count > 1
		         ldt_current_completion_date	= This.GetItemDateTime(lRowNumber,"complete_date")
				If  ldt_current_completion_date <  ldt_begin_completion_date   Then 	ldt_begin_completion_date  =  ldt_current_completion_date
				If  ldt_current_completion_date >  ldt_end_completion_date  	  Then 	ldt_end_completion_date     = ldt_current_completion_date
		End If 

	 	// Set the status as datamodified.
		SetItemStatus(lRowNumber, 0, Primary!, DataModified!)

NEXT

Delete From Pandora_Finance_Data Where  complete_date >= :ldt_begin_completion_date and complete_date <= :ldt_end_completion_date USING SQLCA;

If 	sqlca.sqlcode <> 0 Then
	lsErrText = sqlca.sqlerrtext /* sql error text returned */
	Messagebox("Import","Unable to delete existing rows in database!~r~r" + lsErrText)
	SetPointer(Arrow!)
End If
	
// Save the data
ll_returncode = update()
		
// Commit the changes.
Execute Immediate "COMMIT" using SQLCA;
		
// Set the pointer to arrow.
setpointer(arrow!)

If sqlca.sqlcode <> 0 Then
	lsErrText = sqlca.sqlerrtext /* sql error text returned */
	Execute Immediate "ROLLBACK" using SQLCA;
	Messagebox("Import","Unable to insert import records to database!~r~r" + lsErrText)
	SetPointer(Arrow!)
End If	

MessageBox("Import","Records saved to Database.~r~rRecords Added: " + String(llRowCount))
				

// Set microhelp to 'ready'.
w_main.setmicrohelp("Ready...")

end event

