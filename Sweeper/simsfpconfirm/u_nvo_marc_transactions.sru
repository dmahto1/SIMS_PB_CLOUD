HA$PBExportHeader$u_nvo_marc_transactions.sru
$PBExportComments$Process outbound Marc V transactions
forward
global type u_nvo_marc_transactions from nonvisualobject
end type
end forward

global type u_nvo_marc_transactions from nonvisualobject
end type
global u_nvo_marc_transactions u_nvo_marc_transactions

type variables

Datastore	idsROMain, idsRODetail, idsROPutaway, idsDOMain, idsDODetail, idsDOPick, idsDOPack,	&
				idsOut, idsreceipts, idsAdjustment, idsWOMain, idsWOPick, idsAdjComp, idsoutcorr, idscorrection
				
end variables

forward prototypes
public function integer uf_process_correction_datastore (string asproject, datastore adscorrection)
public function integer uf_corrections (string asproject, long aladjustid)
public function integer uf_receipts (string asproject, string asrono)
public function integer uf_shipments (string asproject, string asdono)
end prototypes

public function integer uf_process_correction_datastore (string asproject, datastore adscorrection);//Prepare a Stock Adjustment Transactions for MARC GT Interface

Long			llNewRow,  llRowPos, llRowCount
				
String		lsOutString, lsMessage,	lsLogOut, ls_filename, &
				ls_warehouse, ls_company_code, ls_date, ls_SKU, ls_coo, ls_correction_no, &
				ls_correction_type, ls_quantity, ls_party_code, ls_bonded
				
DEcimal		ldBatchSeq
Integer		liRC


lsLogOut = "      Creating Correction Records for MARC GT: "
FileWrite(gilogFileNo,lsLogOut)

If Not isvalid(idsoutcorr) Then
	idsOutCorr = Create Datastore
	idsOutCorr.Dataobject = 'd_edi_generic_out'
	lirc = idsOutCorr.SetTransobject(sqlca)
End If

idsOutCorr.Reset()


//Get the Next Batch Seq Nbr - Used for all writing to generic tables
ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asproject,'Marc_Corr','EDI_Batch_Seq_No')
If ldBatchSeq <= 0 Then
	lsLogOut = "        *** Unable to retrieve the next available sequence number~rfor Marc Correction File.~r~rFile will not be sent to Marc GT!'"
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

ls_filename = 'CO' + string(ldbatchseq,"0000000000") + '.COR'

llRowCount = adscorrection.RowCount()

//Process for each component *** There will be the original SKU it doesn't have components.
For llRowPos = 1 to llRowCount
		
	ls_Warehouse = adscorrection.GetItemString(llrowpos,'site_name')
	ls_Company_Code = adscorrection.GetItemString(llrowpos,'company_code')
	ls_Date = adscorrection.GetItemString(llrowpos,'date_encountered')
	ls_sku = adscorrection.GetItemString(llrowpos,'sku_code')
	ls_COO = adscorrection.GetItemString(llrowpos,'country_origin')
	ls_correction_no = adscorrection.GetItemString(llrowpos,'correction_no')
	ls_correction_type = adscorrection.GetItemString(llrowpos,'correction_type')
	ls_quantity = adscorrection.GetItemString(llrowpos,'adjusted_quantity')
	ls_party_code = adscorrection.GetItemString(llrowpos,'party_code')
	ls_bonded = adscorrection.GetItemString(llrowpos,'bonded_ind')


	// Format the Adjustment Output String Fixed Lenth

	If ls_Warehouse > '' Then
		lsOutString = '"' + trim(Left(ls_Warehouse,30)) + Space(30 - Len(ls_Warehouse)) + '","' 	//Site Name
	Else
		lsOutString = Space(30) + '","'
	End If
	If ls_Company_Code > '' Then
		lsOutString += trim(Left(ls_Company_Code,2)) + Space(2 - Len(ls_Company_Code)) + '","'		//Company Code
	Else
		lsOutString+= Space(2) + '","'
	End If
	If ls_Date > '' Then
		lsOutString+= ls_date + '","'																					//Date Encountered
	Else
		lsOutString+= Space(10) + '","'
	End If	
	If ls_Sku > '' Then
		lsOutString += trim(Left(ls_sku,20)) + Space(20 - Len(ls_sku)) + '","'							//Sku
	Else
		lsOutString+= Space(20) + '","'
	End If
	If ls_Coo > '' Then
		lsOutString += trim(Left(ls_COO,2)) + Space(2 - Len(ls_COO)) + '","'								//Country of Origin
	Else
		lsOutString+= Space(2) + '","'
	End If
	If ls_correction_no > '' Then
		lsOutString += ls_correction_no + '","'																	//Correction No  already formatted
	Else
		lsOutString+= fill("0",30) + '","'
	End If
	If ls_correction_type > '' Then
		lsOutString += trim(Left(ls_correction_type,2)) + Space(2 - Len(ls_correction_type)) + '","'	//Correction Type
	Else
		lsOutString+= Space(2) + '","'
	End If
	lsOutString += ls_quantity + '","'																				//Quantity 
	If ls_party_code > '' Then
		lsOutString += trim(Left(ls_party_code,30)) + Space(30 - Len(ls_Party_Code)) + '","'			//Party Code
	Else
		lsOutString+= Space(2) + '","'
	End If
	If ls_Bonded > '' Then
		lsOutString+= ls_Bonded + '"'																					//Bonded Ind
	Else
		lsOutString+= Space(1) + '"'
	End If

	llNewRow = idsOutCorr.insertRow(0)
	idsOutCorr.SetItem(llNewRow,'Project_id', asProject) 
	idsOutCorr.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	idsOutCorr.SetItem(llNewRow,'line_seq_no', llNewRow)
	idsOutCorr.SetItem(llNewRow,'batch_data', lsOutString)
	idsOutCorr.SetItem(llNewRow,'file_name', ls_filename)	
	
Next

// TAM 2006/11/30 Commented out unused code.
//Get the Next Batch Seq Nbr - Used for all writing to generic tables
//ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asproject,'EDI_Generic_Outbound','EDI_Batch_Seq_No')
//If ldBatchSeq <= 0 Then
//	lsLogOut = "        *** Unable to retreive Next Available Sequence Number"
//	FileWrite(gilogFileNo,lsLogOut)
//	Return -1
//End If

//Write the Outbound File - no need to save and re-retrieve - just use the currently loaded DW
// TAM 2006/01/10 - Allow for Multiple Marc Gt projects in the ini file
//gu_nvo_process_files.uf_process_flatfile_outbound(idsOutCorr,'MARC_GT')
gu_nvo_process_files.uf_process_flatfile_outbound(idsOutCorr,"MARC_GT_" + asproject)


Return 0
end function

public function integer uf_corrections (string asproject, long aladjustid);//Jxlim 08/07/2012 CR12 Added 3 interfaces for Physio-XD mimic AMS-MUSER
//Prepare a Stock Adjustment Transactions for MARC GT Interface

Long			llNewRow, llOldQty, llNewQty, llChildQty, llRowCount, llRowPos, &
				llAdjustID, llOwnerID, llOrigOwnerID, llNetQty, llCorrectionRow
				
String		lsOutString, lsMessage,	ls_SKU, ls_child_sku, lsOldInvType,	lsNewInvType, ls_component_ind, &
				lsReason, lsTranType, lsSupplier, lsLogOut, ls_warehouse, ls_date, ls_old_coo, ls_old_coo2, ls_correction_no, &
				ls_correction_type, ls_old_bonded, ls_new_bonded, ls_coo, ls_new_coo, ls_new_coo2, ls_filename, &
				ls_old_company_code, ls_new_company_code, ls_Old_Owner_Cd, ls_New_Owner_Cd, lscorrection, &
				ls_child_coo, ls_child_coo2, lsChildSupplier
	
				
DateTime    ldtTranstime				
				
			
lsLogOut = "      Creating Adjustment Records for MARC GT: " + String(alAdjustID)
FileWrite(gilogFileNo,lsLogOut)

If Not isvalid(idsAdjustment) Then
	idsAdjustment = Create Datastore
	idsAdjustment.Dataobject = 'd_adjustment'
	idsAdjustment.SetTransObject(SQLCA)
End If

If Not isvalid(idsAdjComp) Then
	idsAdjComp = Create u_ds_datastore
	idsAdjComp.Dataobject = 'd_marc_gt_adjustments_components'
	idsAdjComp.SetTransObject(SQLCA)
End If

If Not isvalid(idscorrection) Then
	idscorrection = Create u_ds_datastore
	idscorrection.Dataobject = 'd_marc_correction'
	idscorrection.SetTransobject(sqlca)
End If

// TAM 07/04 - Clear out the datastore
idscorrection.Reset()
idsAdjustment.Reset()
idsAdjComp.Reset()

//Retreive the adjustment record
If idsAdjustment.Retrieve(asProject, alAdjustID) <= 0 Then
	lsLogOut = "        *** Unable to retreive Adjustment Record for AdjustID: " + String(alAdjustID)
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

ls_Warehouse = idsadjustment.GetItemString(1,'wh_code')
lsSupplier = idsadjustment.GetITemString(1,'supp_code')
ls_Sku = idsadjustment.GetITemString(1,'sku')
lscorrection = string(alAdjustID,'00000000000000000000000000000')

// 08/04 - PCONKL - Use Adjustment Date instead of Current Date
ldtTransTime = idsAdjustment.GetItemDateTime(1,'last_update')
If isNull(ldtTranstime) Then ldtTranstime = DateTime(Today(),Now())

ls_Date = String(ldtTranstime,"dd-mm-yyyy")	

ls_Old_COO = idsadjustment.GetITemString(1,'Old_Country_of_Origin')
ls_New_COO = idsadjustment.GetITemString(1,'Country_of_Origin')

// Get 2 char old country code		
If Len(ls_Old_coo) = 2 THen
	ls_Old_coo2 = ls_Old_coo		
Else
	Select Designating_Code into :ls_old_coo2
	From country
	Where ISO_Country_Cd = :ls_old_coo;
End if

// Get 2 char new country code		
If Len(ls_New_coo) = 2 THen
	ls_new_coo2 = ls_new_coo		
Else
	Select Designating_Code into :ls_new_coo2
	From country
	Where ISO_Country_Cd = :ls_new_coo;
End If

ls_old_bonded = idsadjustment.GetITemString(1,'Old_Po_No2')
ls_new_bonded = idsadjustment.GetITemString(1,'Po_No2')

lsOldInvType = idsadjustment.GetITemString(1,"old_inventory_type") /*original value before update!*/
lsNewInvType = idsadjustment.GetITemString(1,"inventory_type")

llOwnerID = idsadjustment.GetITemNumber(1,"owner_ID")
llOrigOwnerID = idsadjustment.GetITemNumber(1,"old_owner")

llNewQty = idsadjustment.GetITemNumber(1,"quantity")
llOldQty = idsadjustment.GetITemNumber(1,"old_quantity")

// Get Old Owner Company Code From Supplier Table using Owner Code
Select Owner_Cd into :ls_Old_Owner_Cd
From Owner
Where Project_id = :asProject and Owner_ID = :llOrigOwnerID;

Select User_Field2 into :ls_Old_Company_Code
From Supplier
Where Project_id = :asProject and Supp_code = :ls_Old_Owner_Cd;

// Get New Owner Company Code From Supplier Table using Owner Code
Select Owner_Cd into :ls_New_Owner_Cd
From Owner
Where Project_id = :asProject and Owner_ID = :llOwnerID;

Select User_Field2 into :ls_New_Company_Code
From Supplier
Where Project_id = :asProject and Supp_code = :ls_New_Owner_Cd;

		
// Only send interface records if Inventory Type, Owner, Qty, Bonded or COO change
//TAM 2015/06/30  Do not send .COR file for Inventory Type Changes
//If (lsOldInvType <> lsNewInvType) or (llOwnerID <> llOrigOwnerID) or (llOldQty <> llNewQty) or (ls_old_Bonded <> ls_new_Bonded) or (ls_old_coo2) <> (ls_new_coo) Then
If (llOwnerID <> llOrigOwnerID) or (llOldQty <> llNewQty) or (ls_old_Bonded <> ls_new_Bonded) or (ls_old_coo2) <> (ls_new_coo) Then
							
	// Get Component Ind from Item Master and retrieve Children SKUs.  These will be used to create the Marc GT Correction interface records
	Select Component_Ind into :ls_component_ind
	From ITem_MAster
	Where Project_id = :asProject and sku = :ls_SKU and Supp_code = :lsSupplier;

	If ls_component_ind = 'Y' Then
	//Retreive the Item Components record
		If idsAdjComp.Retrieve(asProject, lsSupplier, ls_sku) <= 0 Then
			lsLogOut = "        *** Unable to retreive Item Components for Supplier/SKU: " + lsSupplier + "/" + ls_SKU
			FileWrite(gilogFileNo,lsLogOut)
		Return -1
		End If
			llRowCount = idsAdjComp.RowCount()
	Else
	//Set 1st row in datastore to Item Master SKU for Non Component SKUs to use in the loop below
		llRowCount = idsAdjComp.insertRow(0)
		idsAdjComp.SetItem(1,'sku_child', ls_SKU) 
		idsAdjComp.SetItem(1,'supp_code_Child', lssupplier) /* pCONKL*/
		idsAdjComp.SetItem(1,'Child_Qty', 1)
	End If
	
	
	//Process for each component *** There will be the original SKU it doesn't have components.
	For llRowPos = 1 to llRowCount
		ls_Child_SKU = idsAdjComp.GetItemString(llRowPos,'sku_child')
		lsChildSupplier = idsAdjComp.GetItemString(llRowPos,'supp_code_Child') /* PCONKL */
		llChildQTY = idsAdjComp.GetItemNumber(llRowPos,'Child_Qty')

		// TAM 08/04
		// Made a change to get the COO from the Components Item Master record if It is not a compontent SKU
		// Then we use Old_COO
		
		// Get COO from Item Master for Children SKUs.  
		If llrowcount > 1 Then //Only Do for Components (rowcount > 1)
		
			Select Country_of_Origin_default into :ls_child_COO
			From ITem_MAster
			Where Project_id = :asProject and sku = :ls_child_SKU and Supp_code = :lsChildSupplier; /* PCONKL chaned to child supplier*/
		
			If isnull(ls_child_coo) then
				ls_child_COO2 = ls_old_COO2
			Else
				// Get 2 char new country code		
				If Len(ls_child_coo) = 2 THen
					ls_child_coo2 = ls_child_coo		
				Else
					Select Designating_Code into :ls_child_coo2
					From country
					Where ISO_Country_Cd = :ls_child_coo;
				End If
			End If
		Else
			ls_child_COO2 = ls_Old_COO2
		End If

	// If old coo = new coo use child coo as new coo	
		If ls_new_COO2 = ls_old_COO2 then 
			ls_new_COO2 = ls_child_COO2
		End If

		// Send Original(Old) record as a cancel and all other changes as	adds.
		// This allows us to not worry about keeping MARC GT and SIMS in Sync since we will explicitly sync them up at each adjustment.
		// Since we do not do remaining quantity calculations in SIMS(We just overlay what is typed on the screen),
		// we should not use a calculation for the interface quantity.

		If llOldQty > 0 Then //Skip writing the Original Adjustment if Old Quantity = 0. The Split adjustments don't have Original Quantity

		// If Quantity Changed then Create a CY entry			
			If llOldQty <> llNewQty Then
				
				llCorrectionRow = idscorrection.insertRow(0)

				idscorrection.SetItem(llCorrectionRow,'Site_Name', ls_warehouse)
				idscorrection.SetItem(llCorrectionRow,'Company_Code', ls_Old_Company_Code)
				idscorrection.SetItem(llCorrectionRow,'Date_Encountered', ls_date)
				idscorrection.SetItem(llCorrectionRow,'Sku_Code', ls_child_sku)
//				idscorrection.SetItem(llCorrectionRow,'Country_Origin', ls_old_coo2)
// TAM 08/04 Used COO value from above as original COO
				idscorrection.SetItem(llCorrectionRow,'Country_Origin', ls_child_coo2)
				idscorrection.SetItem(llCorrectionRow,'Correction_No', lscorrection)
				idscorrection.SetItem(llCorrectionRow,'Correction_Type', 'CY')
				idscorrection.SetItem(llCorrectionRow,'Adjusted_Quantity', string((llNewQty -llOldQty) * llChildQTY,"+00000000;-00000000"))
				idscorrection.SetItem(llCorrectionRow,'Party_Code', ' ')
				idscorrection.SetItem(llCorrectionRow,'Bonded_Ind', ls_old_Bonded)
				
//		// If Create a CY entry for the new quantity			
//				llCorrectionRow = idscorrection.insertRow(0)
//
//				idscorrection.SetItem(llCorrectionRow,'Site_Name', ls_warehouse)
//				idscorrection.SetItem(llCorrectionRow,'Company_Code', ls_Old_Company_Code)
//				idscorrection.SetItem(llCorrectionRow,'Date_Encountered', ls_date)
//				idscorrection.SetItem(llCorrectionRow,'Sku_Code', ls_child_sku)
//				idscorrection.SetItem(llCorrectionRow,'Country_Origin', ls_old_coo2)
//				idscorrection.SetItem(llCorrectionRow,'Correction_No', lscorrection)
//				idscorrection.SetItem(llCorrectionRow,'Correction_Type', 'CY')
//				idscorrection.SetItem(llCorrectionRow,'Adjusted_Quantity', string(llNewQty * llChildQTY,"+00000000;-00000000"))
//				idscorrection.SetItem(llCorrectionRow,'Party_Code', ' ')
//				idscorrection.SetItem(llCorrectionRow,'Bonded_Ind', ls_old_Bonded)

			End If

		// If Inventory Type Changes to Scrapped  Create a SC entry			
			If lsOldInvType <> lsNewInvType Then
				// If Scrapped or Damaged 
				IF lsNewInvType = 'S' Then
	
					llCorrectionRow = idscorrection.insertRow(0)

					idscorrection.SetItem(llCorrectionRow,'Site_Name', ls_warehouse)
					idscorrection.SetItem(llCorrectionRow,'Company_Code', ls_Old_Company_Code)
					idscorrection.SetItem(llCorrectionRow,'Date_Encountered', ls_date)
					idscorrection.SetItem(llCorrectionRow,'Sku_Code', ls_child_sku)
	//				idscorrection.SetItem(llCorrectionRow,'Country_Origin', ls_old_coo2)
	// TAM 08/04 Used COO value from above as original COO
					idscorrection.SetItem(llCorrectionRow,'Country_Origin', ls_child_coo2)
					idscorrection.SetItem(llCorrectionRow,'Correction_No', lscorrection)
					idscorrection.SetItem(llCorrectionRow,'Correction_Type', 'SC')
					idscorrection.SetItem(llCorrectionRow,'Adjusted_Quantity', string(llNewQty * llChildQTY,"+00000000;-00000000"))
					idscorrection.SetItem(llCorrectionRow,'Party_Code', ' ')
					idscorrection.SetItem(llCorrectionRow,'Bonded_Ind', ls_old_Bonded)
				End If
			End If
				
		// If COO Changed then Create a reversing CO entry			
			If ls_child_coo2 <> ls_new_coo2 Then
				
				llCorrectionRow = idscorrection.insertRow(0)

				idscorrection.SetItem(llCorrectionRow,'Site_Name', ls_warehouse)
				idscorrection.SetItem(llCorrectionRow,'Company_Code', ls_Old_Company_Code)
				idscorrection.SetItem(llCorrectionRow,'Date_Encountered', ls_date)
				idscorrection.SetItem(llCorrectionRow,'Sku_Code', ls_child_sku)
//				idscorrection.SetItem(llCorrectionRow,'Country_Origin', ls_old_coo2)
// TAM 08/04 Used COO value from above as original COO
				idscorrection.SetItem(llCorrectionRow,'Country_Origin', ls_child_coo2)
				idscorrection.SetItem(llCorrectionRow,'Correction_No', lscorrection)
				idscorrection.SetItem(llCorrectionRow,'Correction_Type', 'CO')
				idscorrection.SetItem(llCorrectionRow,'Adjusted_Quantity', string(llNewQty * llChildQTY * -1,"+00000000;-00000000"))
				idscorrection.SetItem(llCorrectionRow,'Party_Code', ' ')
				idscorrection.SetItem(llCorrectionRow,'Bonded_Ind', ls_Old_Bonded)
				
		// If Create a CO entry for the new COO			
				llCorrectionRow = idscorrection.insertRow(0)

				idscorrection.SetItem(llCorrectionRow,'Site_Name', ls_warehouse)
				idscorrection.SetItem(llCorrectionRow,'Company_Code', ls_Old_Company_Code)
				idscorrection.SetItem(llCorrectionRow,'Date_Encountered', ls_date)
				idscorrection.SetItem(llCorrectionRow,'Sku_Code', ls_child_sku)
				idscorrection.SetItem(llCorrectionRow,'Country_Origin', ls_new_coo2)
				idscorrection.SetItem(llCorrectionRow,'Correction_No', lscorrection)
				idscorrection.SetItem(llCorrectionRow,'Correction_Type', 'CO')
				idscorrection.SetItem(llCorrectionRow,'Adjusted_Quantity', string(llNewQty * llChildQTY,"+00000000;-00000000"))
				idscorrection.SetItem(llCorrectionRow,'Party_Code', ' ')
				idscorrection.SetItem(llCorrectionRow,'Bonded_Ind', ls_Old_Bonded)
			End If


		// If Owner Changed then Create a reversing OE entry			
			If llOwnerID <> llOrigOwnerID Then
				
				llCorrectionRow = idscorrection.insertRow(0)

				idscorrection.SetItem(llCorrectionRow,'Site_Name', ls_warehouse)
				idscorrection.SetItem(llCorrectionRow,'Company_Code', ls_Old_Company_Code)
				idscorrection.SetItem(llCorrectionRow,'Date_Encountered', ls_date)
				idscorrection.SetItem(llCorrectionRow,'Sku_Code', ls_child_sku)
				idscorrection.SetItem(llCorrectionRow,'Country_Origin', ls_new_coo2)
				idscorrection.SetItem(llCorrectionRow,'Correction_No', lscorrection)
				idscorrection.SetItem(llCorrectionRow,'Correction_Type', 'OE')
				idscorrection.SetItem(llCorrectionRow,'Adjusted_Quantity', string(llNewQty * llChildQTY  * -1,"+00000000;-00000000"))
				idscorrection.SetItem(llCorrectionRow,'Party_Code', ' ')
				idscorrection.SetItem(llCorrectionRow,'Bonded_Ind', ls_Old_Bonded)
			
		// If Owner Changed then Create a new OE entry			
				llCorrectionRow = idscorrection.insertRow(0)

				idscorrection.SetItem(llCorrectionRow,'Site_Name', ls_warehouse)
				idscorrection.SetItem(llCorrectionRow,'Company_Code', ls_New_Company_Code)
				idscorrection.SetItem(llCorrectionRow,'Date_Encountered', ls_date)
				idscorrection.SetItem(llCorrectionRow,'Sku_Code', ls_child_sku)
				idscorrection.SetItem(llCorrectionRow,'Country_Origin', ls_new_coo2)
				idscorrection.SetItem(llCorrectionRow,'Correction_No', lscorrection)
				idscorrection.SetItem(llCorrectionRow,'Correction_Type', 'OE')
				idscorrection.SetItem(llCorrectionRow,'Adjusted_Quantity', string(llNewQty * llChildQTY ,"+00000000;-00000000"))
				idscorrection.SetItem(llCorrectionRow,'Party_Code', ' ')
				idscorrection.SetItem(llCorrectionRow,'Bonded_Ind', ls_Old_Bonded)
			End If

		Else

		// Create a New CY record for the Split Line			
				
				llCorrectionRow = idscorrection.insertRow(0)

				idscorrection.SetItem(llCorrectionRow,'Site_Name', ls_warehouse)
				idscorrection.SetItem(llCorrectionRow,'Company_Code', ls_New_Company_Code)
				idscorrection.SetItem(llCorrectionRow,'Date_Encountered', ls_date)
				idscorrection.SetItem(llCorrectionRow,'Sku_Code', ls_child_sku)
				idscorrection.SetItem(llCorrectionRow,'Country_Origin', ls_new_coo2)
				idscorrection.SetItem(llCorrectionRow,'Correction_No', lscorrection)
				idscorrection.SetItem(llCorrectionRow,'Correction_Type', 'CY')
				idscorrection.SetItem(llCorrectionRow,'Adjusted_Quantity', string(llNewQty * llChildQTY ,"+00000000;-00000000"))
				idscorrection.SetItem(llCorrectionRow,'Party_Code', ' ')
				idscorrection.SetItem(llCorrectionRow,'Bonded_Ind', ls_Old_Bonded)
		End If

	Next
End If

//Write the Outbound Correction File
If llCorrectionRow > 0 Then
	this.uf_process_correction_datastore(asproject, idscorrection)
End If

Return 0
end function

public function integer uf_receipts (string asproject, string asrono);
// Create an Outbound receipt record for the MARC GT Interface

Long	llrowPos, llRowCount, llNewRow, ll_Qty, llCorrectionRow, llprice
Decimal	ldBatchSeq
String	lsOutString, ls_SKU, lsMessage, ls_receipt_type, ls_company_code, ls_bonded, ls_date, ls_time, ls_supplier, &
			ls_Warehouse, ls_OrderNo, ls_trailer, ls_inventory_type, ls_uom_code, ls_Country, ls_country_code, &
			ls_filename, lsLogOut, lsRONONbr, lscorrectionnumber, lsPrice, lsCurrency, ls_Receipt_Code, ls_SON
			
Integer	liRC

lsLogOut = "      Creating Marc Receipt file For RONO: " + asRONO
FileWrite(gilogFileNo,lsLogOut)

If Not isvalid(idsOut) Then
	idsOut = Create Datastore
	idsOut.Dataobject = 'd_edi_generic_out'
	lirc = idsOut.SetTransobject(sqlca)
End If

If Not isvalid(idsromain) Then
	idsromain = Create Datastore
	idsromain.Dataobject = 'd_ro_master'
	idsromain.SetTransobject(sqlca)
End If

If Not isvalid(idsroputaway) Then
	idsroputaway = Create Datastore
	idsroputaway.Dataobject = 'd_ro_Putaway'
	idsroputaway.SetTransobject(sqlca)
End If

If Not isvalid(idscorrection) Then
	idscorrection = Create u_ds_datastore
	idscorrection.Dataobject = 'd_marc_correction'
	idscorrection.SetTransobject(sqlca)
End If

idsOut.Reset()

//Retreive the Receive Header and Putaway records for this order
If idsroMain.Retrieve(asRoNo) <> 1 Then
	lsLogOut = "        *** Unable to retreive Receive Order Header For RONO: " + asRONO
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

idsroPutaway.Retrieve(asRONO)

idsROPutaway.Setfilter("Component_Ind <> 'Y'")
idsROPutaway.Filter()

llRowCount = idsroPutaway.RowCount()

lsLogOut = "  Putaway Rowcount : " + String(llrowcount)
FileWrite(gilogFileNo,lsLogOut)

 //17-Feb-2014 :Madhu- C13-135 - PHC - Split re-trigger interface files (SIMS- MARC GT) -START
//	Madhu added code to stop send transaction files to MarcGT, if WH is Non-bonded -shifted from u_nvo_edi_confirmations_ams-muser.uf_gr()
      string ls_whtype
      select wh_type  into :ls_whtype from Warehouse_Type where WH_Type in (
                                        select WH_Type from Warehouse where WH_Code in (
                                         select WH_Code from Receive_Master where RO_No=:asrono))
      using sqlca;

	IF (ls_whtype = 'N' and asproject ='AMS-MUSER' ) THEN
			lsLogOut = "        *** Don't generate MarcGT file For Non-Bonded WH of  RONO: " + asRONO
			FileWrite(gilogFileNo,lsLogOut)
	Return -1
	END IF
//17-Feb-2014 :Madhu- C13-135 - PHC - Split re-trigger interface files (SIMS- MARC GT) -END


//We need warehouse info
ls_Warehouse = Upper(idsroMain.GetItemString(1,'wh_code'))
ls_Supplier = Upper(idsroMain.GetItemString(1,'Supp_Code'))
ls_Date = string(idsroMain.GetItemDatetime(1,'arrival_date'),"dd-mm-yyyy")
ls_OrderNo = idsroMain.GetITemString(1,'supp_invoice_no')
ls_SON = idsroMain.GetItemString(1,'supp_order_no')  //hdc 11/02/2012
ls_Trailer = idsroMain.GetITemString(1,'user_field5')
ls_uom_code = "EA"

lsRONONbr = RightTrim(String(Mid(asrono,10)))

If isnumber(lsRONONbr) Then /*only map if numeric*/
	lsCorrectionNumber = fill('0',(30 - len(lsrononbr))) + lsrononbr
Else
	lscorrectionNumber = '00000000000000000000000000001'
End If

// Format order type to 2 characters
ls_Receipt_Type = idsroMain.GetITemString(1,'Ord_Type')
Choose Case idsroMain.GetITemString(1,'Ord_Type')
	Case 'S'
		ls_Receipt_Type = 'SO'
	Case 'B'
		ls_Receipt_Type = 'BO'
	Case 'X'
		ls_Receipt_Type = 'RO'
	Case Else
		ls_Receipt_Type = idsroMain.GetITemString(1,'Ord_Type')
End Choose

// Get Company Code From Supplier Table 
Select User_Field2 into :ls_Company_Code
From Supplier
Where Project_id = :asProject and Supp_code = :ls_Supplier;

//Get the Next Batch Seq Nbr - Used for all writing to generic tables
ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asproject,'Marc_Receipt','EDI_Batch_Seq_no')
If ldBatchSeq <= 0 Then
	lsLogOut = "        *** Unable to retreive Next Available Batch Sequence Number"
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

// 11/13 - PCONKL - Let the prefix be assigned in the Seq No table and not here

ls_filename = 'RE' + string(ldbatchseq,"0000000000") + '.REC'

//if asProject ='PHYSIO-XD' then
//	
//	ls_filename = 'RE' + string(ldbatchseq,"2000000000") + '.REC'
//else 
//	ls_filename = 'RE' + string(ldbatchseq,"1000000000") + '.REC'
//end if 


For llRowPos = 1 to lLRowCount /* For each Putaway Row */

//Jxlim 08/14/2012 May removed the unwanted project later
//Jxlim 08/07/2012 CR12 Added 3 interfaces for PHYSIO-XD and PHYSIO-MAA mimic AMS-MUSER
//TAM 03/29/2006 For AMS added Putaway Line Item Number to Order Number and Invoice number to Receipt Code 
	//If asproject = 'AMS-MUSER'  or asproject = 'PHYSIO-XD' or asproject = 'PHYSIO-MAA'  Then
	If (asproject = 'PHYSIO-XD' or asproject = 'PHYSIO-MAA' or asproject = 'PHYSIO AMS' or asproject = 'PHYSIO MAA') and (ls_trailer="" or IsNull(ls_trailer)) Then		
	//hdc 11/02/2012 we're assuming that if it's non-null/blank that it was populated from user field 5; this is for when the SON isn't in user field 5		
		ls_trailer = ls_SON  
	end if
	If asproject = 'AMS-MUSER'  or asproject = 'PHYSIO-XD' or asproject = 'PHYSIO-MAA' or asproject = 'PHYSIO AMS' or asproject = 'PHYSIO MAA' Then	
		ls_OrderNo = String(idsroPutaway.GetITemNumber(llRowPos,'Line_Item_no'))
		ls_Receipt_Code = idsroMain.GetITemString(1,'supp_invoice_no')
	End If
	
	ls_SKU = idsroPutaway.GetITemString(llRowPos,'SKU')
	ls_bonded = idsroPutaway.GetITemString(llRowPos,'Po_No2')
	ls_country = idsroPutaway.GetITemString(llRowPos,'Country_of_Origin')
	ls_inventory_type = idsroPutaway.GetITemString(llRowPos,'inventory_type')

// TAM 2006/01/06 Need to send Price/CurrencyCode info for (New for AMD)
	If isnumber(idsroPutaway.GetITemString(llRowPos,'user_field4')) Then /*only get price if numeric*/
	//	lsPrice = fill('0',(14 - len(trim(idsroPutaway.GetITemString(llRowPos,'user_field4'))))) + trim(idsroPutaway.GetITemString(llRowPos,'user_field4'))
		lsprice = string(dec(idsroPutaway.GetItemString(llRowPos,'user_field4'))*10000000,'00000000000000')
	Else
		lsPrice = '00000000000000'
	End If
	lsCurrency = idsroPutaway.GetITemString(llRowPos,'user_field5')
	
	// Get 2 char country code		
	If Len(ls_country) = 2 Then
		ls_country_code = ls_country		
	Else
		Select Designating_Code into :ls_country_code
		From country
		Where ISO_Country_Cd = :ls_country;
	End If

	
	ll_Qty = idsroPutaway.GetITemNumber(llRowPos,'Quantity')
	
	// Create a correction record for each putaway row that is damaged
	If ls_Inventory_Type = "D" Then

		llCorrectionRow = idscorrection.insertRow(0)

		idscorrection.SetItem(llCorrectionRow,'Site_Name', ls_warehouse)
		idscorrection.SetItem(llCorrectionRow,'Company_Code', ls_Company_Code)
		idscorrection.SetItem(llCorrectionRow,'Date_Encountered', string(today(),"dd-mm-yyyy"))
		idscorrection.SetItem(llCorrectionRow,'Sku_Code', ls_Sku)
		idscorrection.SetItem(llCorrectionRow,'Country_Origin', ls_country_code)
		idscorrection.SetItem(llCorrectionRow,'Correction_No', lscorrectionnumber)
		idscorrection.SetItem(llCorrectionRow,'Correction_Type', 'DR')
		idscorrection.SetItem(llCorrectionRow,'Adjusted_Quantity', string(ll_qty))
		idscorrection.SetItem(llCorrectionRow,'Party_Code', ' ')
		idscorrection.SetItem(llCorrectionRow,'Bonded_Ind', ls_bonded)
	End If
	
	//Output contain fixed length fields
	If ls_Warehouse > '' Then
		lsOutString = '"' + trim(Left(ls_Warehouse,30)) + Space(30 - Len(ls_Warehouse)) + '","' 	//Site Name
	Else
		lsOutString = Space(30) + '","'
	End If
	If ls_Date > '' Then
		lsOutString+= ls_date + '","'																					//Arrival date
	Else
		lsOutString+= Space(10) + '","'
	End If	
	lsOutString += Space(5) + '","'																				//Arrival Time
	If ls_Company_Code > '' Then
		lsOutString += trim(Left(ls_Company_Code,2)) + Space(2 - Len(ls_Company_Code)) + '","'		//Company Code
	Else
		lsOutString+= Space(2) + '","'
	End If
	If ls_country_code > '' Then
		ls_Country_code = upper(ls_country_code) //dts (9/05/06) 
		lsOutString += trim(Left(ls_country_code,2)) + Space(2 - Len(ls_country_code)) + '","'	//Country of Origin
	Else
		lsOutString += Space(2) + '","'
	End If
	lsOutString += '  ' + '","' 																					//Country source
// TAM 2006/01/09  Added Currency for AMD
 	If lsCurrency > '' Then
		lsOutString += trim(Left(lsCurrency,3)) + Space(3 - Len(lsCurrency)) + '","'				//Currency
	Else
		lsOutString += Space(3) + '","'
	End If

	lsOutString += '                              ' + '","' 												//Customer Code
	lsOutString += '   ' + '","' 																					//Delivery Term Code
	lsOutString += '                              ' + '","' 												//Party Code
	If ls_OrderNo > '' Then
		lsOutString += trim(Left(ls_OrderNo,15)) + Space(15 - Len(ls_OrderNo)) + '","' 			//Purchase Order Code
	Else
		lsOutString += Space(15) + '","'
	End If
	lsOutString += string(ll_Qty,"000000000") + '","' 														//Quantity
//TAM 03/29/2006 Added Receipt Code for AMS	
	If ls_Receipt_Code > '' Then
//		lsOutString += trim(Left(ls_Receipt_Code,15)) + Space(15 - Len(ls_Receipt_Code)) + '","' 	//Receipt Code nxjain update the length  2013-10-09
		lsOutString += trim(Left(ls_Receipt_Code,25)) + Space(25 - Len(ls_Receipt_Code)) + '","' 	//Receipt Code
	Else
		lsOutString += Space(15) + '","'
	End If
	If ls_receipt_type > '' Then
		lsOutString += trim(Left(ls_receipt_type,2)) + Space(2 - Len(ls_receipt_type)) + '","' //Receipt Type
	Else
		lsOutString += Space(2) + '","'
	End If
	
	asrono =Right(asrono,14) //31-Oct-2013 :Madhu -C13-080-Reduce sysNo to 14chrs -Added
	lsOutString += trim(Left(asrono,30)) + Space(30 - Len(asrono)) + '","' 							//Bill of Lading

	If ls_sku > '' Then
		lsOutString += trim(Left(ls_sku,20)) + Space(20 - Len(ls_sku)) + '","' 						//Sku
	Else
		lsOutString += Space(20) + '","'
	End If
	If ls_trailer > '' Then
		//lsOutString += trim(Left(ls_trailer,20)) + Space(20 - Len(ls_trailer)) + '","' 			//Trialer Code
		lsOutString += trim(Left(ls_trailer,30)) + Space(30 - Len(ls_trailer)) + '","' 			//increse the Trialer column value 
		
	Else
		lsOutString += Space(20) + '","'
	End If

//TAM 2006/01/09 Send Price for AMD (Formatted above)
	lsOutString += lsPrice + '","' 																				//Unit Price

	lsOutString += '                              ' + '","' 												//Sku Description
	If ls_uom_code > '' Then
		lsOutString += trim(Left(ls_uom_code,4)) + Space(4 - Len(ls_uom_code)) + '","' 			//UOM Code
	Else
		lsOutString += Space(4) + '","'
	End If
	lsOutString += 'N' + '","' 																					//Complete Flag
	If ls_bonded > '' Then
		lsOutString += ls_bonded + '"' 																			//Bonded Ind
	Else
		lsOutString += Space(1) + '","'
	End If
	
	llNewRow = idsOut.insertRow(0)

	idsOut.SetItem(llNewRow,'Project_id', asProject)
	idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	idsOut.SetItem(llNewRow,'batch_data', lsOutString)
	idsOut.SetItem(llNewRow,'file_name', ls_filename)
lsLogOut = "newrow/Row/Outstring : " + String(llnewrow)+ "/" + String(llRowPos) + "/" + lsoutstring
FileWrite(gilogFileNo,lsLogOut)

Next /*Putaway Row*/
lsLogOut = "  llrowcount/llcorrectionrow : " + String(llrowcount) + "/" + String(llCorrectionRow)
FileWrite(gilogFileNo,lsLogOut)

//Write the Outbound File - no need to save and re-retrieve - just use the currently loaded DW
//gu_nvo_process_files.uf_process_flatfile_outbound(idsOut,"MARC_GT_" + asproject)
// TAM 2006/01/10 - Allow for Multiple Marc Gt projects in the ini file
gu_nvo_process_files.uf_process_flatfile_outbound(idsOut,"MARC_GT_" + asproject)

//Write the Outbound Correction File for Damaged Goods
If llCorrectionRow > 0 Then
	this.uf_process_correction_datastore(asproject, idscorrection)
End If

Return 0
end function

public function integer uf_shipments (string asproject, string asdono);
String		lsLogOut, lsTemp, lsProject, lsCrap
				
Long			llRowPos, llRowCount, llNewRow, ll_qty, llcorrectionrow
				
String		lsOutString, ls_Dono, ls_Order_Type, ls_Company_Code, ls_Delivery_Term_Code, &
				ls_SKU, ls_COO, ls_COO2, ls_filename, ls_date, &
				ls_Warehouse, ls_BT_Address_1, ls_BT_City, ls_BT_Country, ls_BT_Country2, ls_BT_Name, ls_BT_Cust_Code, &
				ls_D_Address_1, ls_D_City, ls_D_Country, ls_d_country2, ls_D_Name, ls_D_Cust_Code, ls_bonded, ls_WoNo, &
				ls_country2, ls_trailer,  lscorrection, lsBOL, lsDONONbr, ls_OwnerCode, ls_cust_VAT, lsPrice, lsCurrency
//				ls_supplier

Decimal		ldBatchSeq
				
Integer		liRC

DateTime    ldtTranstime

If Not isvalid(idsOut) Then
	idsOut = Create Datastore
	idsOut.Dataobject = 'd_edi_generic_out'
	lirc = idsOut.SetTransobject(sqlca)
End If

If Not isvalid(idsDOMain) Then
	idsDOMain = Create Datastore
	idsDOMain.Dataobject = 'd_do_master'
	idsDOMain.SetTransObject(SQLCA)
End If

If Not isvalid(idsDopick) Then
	idsDopick = Create Datastore
	idsDopick.Dataobject = 'd_do_picking'
	idsDopick.SetTransObject(SQLCA)
End If

If Not isvalid(idscorrection) Then
	idscorrection = Create u_ds_datastore
	idscorrection.Dataobject = 'd_marc_correction'
	idscorrection.SetTransobject(sqlca)
End If

If Not isvalid(idsWopick) Then
	idsWopick = Create u_ds_datastore
	idsWopick.Dataobject = 'd_workorder_picking'
	idsWoPick.SetTransObject(SQLCA)
End If


idsOut.Reset()
// TAM 07/04 - Clear out the datastore
idscorrection.Reset()

//Retreive Delivery Master records for this DONO
If idsDOMain.Retrieve(asDoNo) <> 1 Then
	lsLogOut = "        *** Unable to retreive Delivery Order Header For DONO: " + asDONO
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

//Retreive Detail picking Records for this DONO
idsDopick.Retrieve(asDoNo) 
// Filter out Component Parents
idsDOpick.Setfilter("Component_Ind <> 'Y'")
idsDOpick.Filter()


//Retrieve The WorkOrder Picking for this DONO/WONO
Select Wo_No into :ls_wono
FRom Workorder_master
Where do_no = :asDoNo;

idsWoPick.Retrieve(ls_WoNo) 



lsLogOut = "        Creating Marc GT Shipment File For DONO: " + asDONO
FileWrite(gilogFileNo,lsLogOut)


//Get the Next Batch Seq Nbr - Used for all writing to generic tables
ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asproject,'Marc_Ship','EDI_Batch_Seq_No')
If ldBatchSeq <= 0 Then
	lsLogOut = "        *** Unable to retrieve the next available sequence number~rfor Marc Shipment File.~r~rFile will not be sent to Marc GT!'"
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

// Create the output filename
ls_filename = 'SH' + string(ldbatchseq,"0000000000") + '.SHP'


// 11/13 - PCONKL - Let the prefix be assigned in the Seq No table and not here

//if asProject ='PHYSIO-XD' then
//	
//	ls_filename = 'SH' + string(ldbatchseq,"2000000000") + '.SHP'
//else 
//	ls_filename = 'SH' + string(ldbatchseq,"1000000000") + '.SHP'
//end if 


// Load Delivery Order Header Records
ls_Warehouse = Upper(idsDOmain.GetItemString(1,'wh_Code'))

//Jxlim 08/14/2012 may removed unwanted project
//Jxlim 08/07/2012 CR12 Added 3 interfaces for PHYSIO-XD and PHYSIO-MAA mimic AMS-MUSER
// dts - 01/08/08 - AMS-MUSER wants to send Invoice_No instead of DO_NO in Trailer...
If asProject = "AMS-MUSER" or asproject = "PHYSIO-XD" or asproject = 'PHYSIO-MAA'  or asproject = 'PHYSIO AMS' or asproject = 'PHYSIO MAA'Then
	ls_Trailer = idsDoMain.GetItemString(1, 'Invoice_no')
else
	ls_Trailer = asDONO
end if

ls_Order_Type = 'SO'

ls_Delivery_Term_Code =  idsDOmain.GetItemString(1,'user_field1')

// 12/07 - PCONKL - We may need to Translate our terms code into a different code for Marc (i.e. 3COM is sending numeric codes that Marc can't handle)
If ls_Delivery_Term_Code > '' Then
	
	lsProject = idsDoMain.GetItemString(1,'Project_id')
	lsCrap = Trim(ls_Delivery_Term_Code)
		
	Select Marc_value into :lsTemp
	From Marc_translations
	Where Project_id = :lsProject and  code_type = 'TC' and Sims_value = :lsCrap;
			
	If lsTemp > "" Then
		ls_Delivery_Term_Code = lsTemp
	End If
	
End If 

//TAM 2005/05/13 added UF11
If idsDOmain.GetItemString(1,'user_field11') = 'T' Then
	ls_cust_VAT = idsDOmain.GetItemString(1,'user_field11') 
Else
	ls_cust_VAT = ''
End If


// 08/04 - PCONKL - Use the Orde Complete Date as the transaction Date
ldtTransTime = idsDoMain.GetITemDateTime(1,'Complete_Date')
If isNull(ldtTranstime) Then ldtTranstime = DateTime(Today(),Now())

ls_Date = String(ldtTranstime,"dd-mm-yyyy")	

//Retrieve the Bill To Address
Select Address_1, City, Country, Name into :ls_BT_Address_1, :ls_BT_City, :ls_BT_Country, :ls_BT_Name
From Delivery_Alt_Address
Where do_no = :asDoNo and Address_type = "BT";
// Get 2 char country code		
If Len(ls_bt_country) = 2 Then
	ls_bt_country2 = ls_bt_country		
Else
	Select Designating_Code into :ls_bt_country2
	From country
	Where ISO_Country_Cd = :ls_bt_country;
End If


//Delivery Address
ls_D_Address_1 = idsDOmain.GetItemString(1,'address_1')
ls_D_City = idsDOmain.GetItemString(1,'City')
ls_D_Cust_Code = idsDOmain.GetItemString(1,'Cust_Code')
ls_D_Name = idsDOmain.GetItemString(1,'Cust_Name')
ls_D_Country = idsDOmain.GetItemString(1,'country')
// Get 2 char country code		
If Len(ls_d_country) = 2 THen
	ls_d_country2 = ls_d_country		
Else
	Select Designating_Code into :ls_d_country2
	From country
	Where ISO_Country_Cd = :ls_d_country;
End If

//USE DONO UNTIL DETERMINE WHAT CORRECTION SHOULD BE
lsDONONbr = RightTrim(String(Mid(asDono,10)))

If isnumber(lsDONONbr) Then /*only map if numeric*/
	lsCorrection = fill('0',(30 - len(lsDononbr))) + lsdononbr
Else
	lscorrection = '00000000000000000000000000001'
End If

// TAM 2006/02/07 Use Customs code if present.  Otherwise continue to use DoNo
If (idsDOmain.GetItemString(1,'customs_doc') >'') and not isnull(idsDOmain.GetItemString(1,'customs_doc')) then
	lsBOL = idsDOmain.GetItemString(1,'customs_doc') 
Else
	lsBOL = asdono
End If

//Write the rows to the generic output table - delimited by ",(Double Quote and comma)

//Create the Shipment Records . 1 record for each component or 1 record for each non component detail.
//Delivery picking and Workorder Picking is broken down in this way

// Begin Delivery Order Picklist
llRowCount = idsDOpick.RowCount()

If llRowCount >= 1 then
	For llRowPos = 1 to llRowCount
		ll_qty = idsDOpick.GetItemNumber(llRowPos,'Quantity')
		ls_sku = idsDOpick.GetItemString(llRowPos,'Sku')
		ls_bonded = idsDOpick.GetItemString(llRowPos,'Po_No2')
		ls_COO = idsDOpick.GetItemString(llRowPos,'country_of_origin')
	// TAM 2006/01/06 Need to send Price/CurrencyCode info for (New for AMD)
		lsprice = string(idsDOpick.GetItemNumber(llRowPos,'price')*10000000,'00000000000000')
	//Jxlim 08/14/2012 May remove unwanted project
	//Jxlim 08/07/2012 CR12 Added 3 interfaces for PHYSIO-XD and PHYSIO-MAA mimic AMS-MUSER	
	// TAM 2006/02/20 Only Send Currency for AMS
		If asProject = "AMS-MUSER" or asProject = "PHYSIO-XD"  or asproject = 'PHYSIO-MAA' or asproject = 'PHYSIO AMS' or asproject = 'PHYSIO MAA'Then
			lsCurrency = idsDoPick.GetITemString(llRowPos,'Currency')
		Else
			lsCurrency = ''
		End If

		// Get 2 char country code		
		If Len(ls_coo) = 2 THen	
			ls_coo2 = ls_coo		
		Else
			Select Designating_Code into :ls_coo2
			From country
			Where ISO_Country_Cd = :ls_coo;
		End if
	
	  	// Get Company Code From Supplier Table using the owner_code from the pick detail
	  	ls_ownercode = idsDoPick.GetItemString(llRowPos,'owner_owner_cd')
		// TAM 07/04  - Use Owner Code instead of Supplier Code
//			ls_supplier = idsDOpick.GetItemString(llRowPos,'Supp_Code')
			Select User_Field2 into :ls_Company_Code
			From Supplier
			Where Project_id = :asProject and Supp_code = :ls_OwnerCode;
//			Where Project_id = :asProject and Supp_code = :ls_Supplier;

	//TAM 2006/01/06 - Added AMS-MUSER to MARC GT but we only Send out owner change transactions for 3COM_NASH
		IF asproject = '3COM_NASH' Then

		// Create a Owner Change correction record for each non 3com owned pick row
			If Left(Upper(idsDoPick.GetItemString(llRowPos,'owner_owner_cd')),4) <> '3COM' Then 

//		// Back out bonded and from Old Owner and add non-bonded to Old Owner?			
//				If ls_Bonded = 'Y' Then
//				
//					llCorrectionRow = idscorrection.insertRow(0)
//
//					idscorrection.SetItem(llCorrectionRow,'Site_Name', ls_warehouse)
//					idscorrection.SetItem(llCorrectionRow,'Company_Code', ls_Company_Code)
//					idscorrection.SetItem(llCorrectionRow,'Date_Encountered', string(today(),"dd-mm-yyyy"))
//					idscorrection.SetItem(llCorrectionRow,'Sku_Code', ls_Sku)
//					idscorrection.SetItem(llCorrectionRow,'Country_Origin', ls_coo2)
//					idscorrection.SetItem(llCorrectionRow,'Correction_No', '00000000000000000000000000000')
//					idscorrection.SetItem(llCorrectionRow,'Correction_Type', 'CG')
//					idscorrection.SetItem(llCorrectionRow,'Adjusted_Quantity', string(ll_qty*-1,"+00000000;-00000000"))
//					idscorrection.SetItem(llCorrectionRow,'Party_Code', ' ')
//					idscorrection.SetItem(llCorrectionRow,'Bonded_Ind', ls_bonded)
//			//Add non-bonded to old owner	
//					llCorrectionRow = idscorrection.insertRow(0)
//
//					idscorrection.SetItem(llCorrectionRow,'Site_Name', ls_warehouse)
//					idscorrection.SetItem(llCorrectionRow,'Company_Code', ls_Company_Code)
//					idscorrection.SetItem(llCorrectionRow,'Date_Encountered', string(today(),"dd-mm-yyyy"))
//					idscorrection.SetItem(llCorrectionRow,'Sku_Code', ls_Sku)
//					idscorrection.SetItem(llCorrectionRow,'Country_Origin', ls_coo2)
//					idscorrection.SetItem(llCorrectionRow,'Correction_No', '00000000000000000000000000000')
//					idscorrection.SetItem(llCorrectionRow,'Correction_Type', 'CG')
//					idscorrection.SetItem(llCorrectionRow,'Adjusted_Quantity', string(ll_qty,"+00000000;-00000000"))
//					idscorrection.SetItem(llCorrectionRow,'Party_Code', ' ')
//					idscorrection.SetItem(llCorrectionRow,'Bonded_Ind', 'N')
//					ls_bonded = 'N'
//				End If
	//Back Out Old Owner
				llCorrectionRow = idscorrection.insertRow(0)

				idscorrection.SetItem(llCorrectionRow,'Site_Name', ls_warehouse)
				idscorrection.SetItem(llCorrectionRow,'Company_Code', ls_Company_Code)
//				idscorrection.SetItem(llCorrectionRow,'Date_Encountered', string(today(),"dd-mm-yyyy"))
//	 TAM use Ship Complete Date instead of today
				idscorrection.SetItem(llCorrectionRow,'Date_Encountered', ls_date)
				idscorrection.SetItem(llCorrectionRow,'Sku_Code', ls_Sku)
				idscorrection.SetItem(llCorrectionRow,'Country_Origin', ls_coo2)
//				idscorrection.SetItem(llCorrectionRow,'Correction_No', '00000000000000000000000000000')
				idscorrection.SetItem(llCorrectionRow,'Correction_No', lscorrection)
				idscorrection.SetItem(llCorrectionRow,'Correction_Type', 'OE')
				idscorrection.SetItem(llCorrectionRow,'Adjusted_Quantity', string(ll_qty*-1,"+00000000;-00000000"))
				idscorrection.SetItem(llCorrectionRow,'Party_Code', ' ')
				idscorrection.SetItem(llCorrectionRow,'Bonded_Ind', ls_bonded)
		// Add New Owner
				llCorrectionRow = idscorrection.insertRow(0)

				idscorrection.SetItem(llCorrectionRow,'Site_Name', ls_warehouse)
				idscorrection.SetItem(llCorrectionRow,'Company_Code', '3C')
//				idscorrection.SetItem(llCorrectionRow,'Date_Encountered', string(today(),"dd-mm-yyyy"))
//	 TAM use Ship Complete Date instead of today
				idscorrection.SetItem(llCorrectionRow,'Date_Encountered', ls_date)
				idscorrection.SetItem(llCorrectionRow,'Sku_Code', ls_Sku)
				idscorrection.SetItem(llCorrectionRow,'Country_Origin', ls_coo2)
//				idscorrection.SetItem(llCorrectionRow,'Correction_No', '00000000000000000000000000000')
				idscorrection.SetItem(llCorrectionRow,'Correction_No', lscorrection)
				idscorrection.SetItem(llCorrectionRow,'Correction_Type', 'OE')
				idscorrection.SetItem(llCorrectionRow,'Adjusted_Quantity', string(ll_qty,"+00000000;-00000000"))
				idscorrection.SetItem(llCorrectionRow,'Party_Code', ' ')
				idscorrection.SetItem(llCorrectionRow,'Bonded_Ind', ls_bonded)
			End If
		End If // End 3COM Owner Change
		
	
	// Format the Shipment Output String Fixed Lenth

		If ls_Warehouse > '' Then
			lsOutString = '"' + trim(Left(ls_Warehouse,30)) + Space(30 - Len(ls_Warehouse)) + '","' 	//Site Name
		Else
			lsOutString = Space(30) + '","'
		End If
		lsOutString += string(ll_Qty,"000000000") + '","'															//Quantity
		If ls_Date > '' Then
			lsOutString+= ls_date + '","'																					//Departure date
		Else
			lsOutString+= Space(10) + '","'
		End If	
		lsOutString += space(5) + '","'																					//Departure Time
		If ls_Sku > '' Then
			lsOutString += trim(Left(ls_sku,20)) + Space(20 - Len(ls_sku)) + '","'							//Sku
		Else
			lsOutString+= Space(20) + '","'
		End If
		If ls_trailer > '' Then
			lsOutString += trim(Left(ls_trailer,20)) + Space(20 - Len(ls_trailer)) + '","'				//Trailer Code
		Else
			lsOutString+= Space(20) + '","'
		End If
		
		asDoNo =Right(asDoNo,14) //31-Oct-2013 :Madhu -C13-080-Reduce sysNo to 14chrs -Added
		
		lsOutString += trim(Left(asDoNo,15)) + Space(15 - Len(asDoNo)) + '","'								//Order Code
		If ls_Order_Type > '' Then
			lsOutString += trim(Left(ls_Order_Type,2)) + Space(2 - Len(ls_Order_Type)) + '","'			//Order Type
		Else
			lsOutString+= 'Space(2) + ","'
		End If
	//Default Company code to 3com for all shipments
	// TAM 2006/01/11 Only Default if 3COM
		If asProject = '3COM_NASH' Then
			lsOutString += '3C' + '","'
		Else
			lsOutString += trim(Left(ls_Company_Code,2)) + Space(2 - Len(ls_Company_Code))  + '","'
		End If	

		lsOutString += Space(30) + '","'																					//Container Code
		If ls_Coo > '' Then
			lsOutString += trim(Left(ls_COO2,2)) + Space(2 - Len(ls_COO2)) + '","'							//Country of Origin
		Else
			lsOutString+= 'XX' + '","'
		End If
		If lsBOL > '' Then
			lsOutString += trim(Left(lsBOL,15)) + Space(15 - Len(lsBOL)) + '","'								//BOL
		Else
			lsOutString+= Space(15) + '","'
		End If
		lsOutString += Space(1) + '","'																					//Active Refinement Ind

	// TAM 2006/01/09  Added Currency for AMD
	 	If lsCurrency > '' Then
			lsOutString += trim(Left(lsCurrency,3)) + Space(3 - Len(lsCurrency)) + '","'				//Currency
		Else
			lsOutString += Space(3) + '","'
		End If
		
		If ls_BT_Address_1 > '' Then
			lsOutString+= trim(Left(ls_BT_Address_1,40)) + Space(40 - Len(ls_BT_Address_1)) + '","'	//Customer Address 1 
		Else
			lsOutString+= 'None' + Space(36) + '","'
		End If
		If ls_BT_City > '' Then
			lsOutString+= trim(Left(ls_BT_City,40)) + Space(40 - Len(ls_BT_City)) + '","'					//Customer City
		Else
			lsOutString+= 'None' + Space(36) + '","'
		End If
		//dts (9/05/06) If ls_BT_Country > '' Then
		If ls_BT_Country2 > '' Then
			ls_BT_Country2 = upper(ls_BT_Country2) //dts (9/05/06) 
			lsOutString+= trim(Left(ls_BT_Country2,2)) + Space(2 - Len(ls_BT_Country2)) + '","'			//Customer Country
		//Jxlim 08/24/2012 If bill_to.country is empty used ship_to country for Physio
		ElseIf Left(Upper(asProject), 6) = 'PHYSIO'  and IsNull(ls_BT_Country2) or ls_BT_Country2 = ''	 Then
			ls_BT_Country2 = upper(ls_d_Country2) //copy from ship_to country  Jxlim 08/24/2012
			lsOutString+= trim(Left(ls_BT_Country2,2)) + Space(2 - Len(ls_BT_Country2)) + '","'			//Customer Country			
		Else
			lsOutString+= 'XX' + '","'
		End If	
				
		If ls_BT_Name > '' Then
			lsOutString+= trim(Left(ls_BT_Name,30)) + Space(30 - Len(ls_BT_Name)) + '","'					//Customer Name 
		Else
			lsOutString+= 'None' + Space(26) + '","'
		End If
		If ls_D_Cust_Code > '' Then
			lsOutString+= trim(Left(ls_D_Cust_Code,30)) + Space(30 - Len(ls_D_Cust_Code)) + '","'		//Destination Code 
		Else
			lsOutString+= Space(30) + '","'
		End If
// TAM 2005/04/05  Added UF11
		If ls_cust_VAT > '' Then
			lsOutString+= trim(Left(ls_Cust_VAT,18)) + Space(18 - Len(ls_cust_VAT)) + '","'				//Cust VAT 
		Else
			lsOutString+= Space(18) + '","'																					
		End If
		lsOutString+= Space(20) + '","'																					//Cust Zip
		lsOutString+= Space(15) + '","'																					//Carrier Code
		lsOutString+= Space(3) + '","'																					//Carrier Type
		If ls_D_Address_1 > '' Then
			lsOutString+= trim(Left(ls_D_Address_1,40)) + Space(40 - Len(ls_D_Address_1)) + '","'		//Destination Address 1 
		Else
			lsOutString+= 'None' + Space(36) + '","'
		End If
		If ls_D_City > '' Then
			lsOutString+= trim(Left(ls_D_City,40)) + Space(40 - Len(ls_D_City)) + '","'					//Destination City
		Else
			lsOutString+= 'None' + Space(36) + '","'
		End If
		If ls_D_Country2 > '' Then
			ls_D_Country2 = upper(ls_D_Country2) //dts (9/05/06) 
			lsOutString+= trim(Left(ls_D_Country2,2)) + Space(2 - Len(ls_D_Country2)) + '","'			//Destination Country
		Else
			lsOutString+= 'XX' +  '","'
		End If
		If ls_D_Cust_Code > '' Then
			lsOutString+= trim(Left(ls_D_Cust_Code,30)) + Space(30 - Len(ls_D_Cust_Code)) + '","'		//Destination Code 
		Else
			lsOutString+= Space(30) + '","'
		End If
		If ls_D_Name > '' Then
			lsOutString+= trim(Left(ls_D_Name,30)) + Space(30 - Len(ls_D_Name)) + '","'					//Destination Name 
		Else
			lsOutString+= 'None' + Space(26) + '","'
		End If	
		lsOutString+= Space(18) + '","'																					//Destination VAT
		lsOutString+= Space(20) + '","'																					//Destination Zip
		If ls_Delivery_Term_Code > '' Then
			lsOutString+= trim(Left(ls_Delivery_Term_Code,3)) + Space(3 - Len(ls_Delivery_Term_Code)) + '","'	//Delivery Term Code
		Else
			lsOutString+= Space(3) + '","'
		End If
		lsOutString+= Space(30) + '","'																					//Party Code
//		lsOutString+= '00000000000000' + '","'																			//Unit Price	
		//TAM 2006/01/09 Send Price for AMD
		If lsprice > '0' Then 
			lsOutString += fill('0',(14 - len(trim(lsprice)))) + trim(lsprice) + '","'
		Else
			lsOutString += '00000000000000' + '","'
		End If
		
		If ls_Bonded > '' Then
			lsOutString+= ls_Bonded + '"'																					//Bonded Ind
		Else
			lsOutString+= Space(1) + '"'
		End If

		llNewRow = idsOut.insertRow(0)
		idsOut.SetItem(llNewRow,'Project_id', asProject) 
		idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
		idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
		idsOut.SetItem(llNewRow,'batch_data', lsOutString)
		idsOut.SetItem(llNewRow,'file_name', ls_filename)

	Next
End if
// End Delivery Order picklist
	
// Begin Workorder Picklist
llRowCount = idsWOPick.RowCount()
If llRowCount >= 1 then
	For llRowPos = 1 to llRowCount
		ll_qty = idsWOPick.GetItemNumber(llRowPos,'Quantity')
		ls_sku = idsWOpick.GetItemString(llRowPos,'Sku')
		ls_bonded = idsWOpick.GetItemString(llRowPos,'Po_No2')
		ls_COO = idsWOpick.GetItemString(llRowPos,'country_of_origin')


// Get 2 char country code		
		If Len(ls_coo) = 2 THen	
			ls_coo2 = ls_coo		
		Else
			Select Designating_Code into :ls_coo2
			From country
			Where ISO_Country_Cd = :ls_coo;
		End if
  
	//TAM 2006/01/06 - Added AMS-MUSER to MARC GT but we only Send out owner change transactions for 3COM_NASH
		IF asproject = '3COM_NASH' Then
		
	// Get Company Code From Supplier Table using the owner_code from the pick detail
		ls_ownercode = idsWoPick.GetItemString(llRowPos,'owner_owner_cd')
// TAM 07/04  - Use Owner Code instead of Supplier Code
//		ls_supplier = idsWOpick.GetItemString(llRowPos,'Supp_Code')
		Select User_Field2 into :ls_Company_Code
		From Supplier
		Where Project_id = :asProject and Supp_code = :ls_OwnerCode;
//		Where Project_id = :asProject and Supp_code = :ls_Supplier;

	// Create a Owner Change correction record for each non 3com owned pick row
		If Left(Upper(idsWoPick.GetItemString(llRowPos,'owner_owner_cd')),4) <> '3COM' Then 
//		// Back out bonded and from Old Owner and add non-bonded to Old Owner?			
//			If ls_Bonded = 'Y' Then
//				
//				llCorrectionRow = idscorrection.insertRow(0)
//
//				idscorrection.SetItem(llCorrectionRow,'Site_Name', ls_warehouse)
//				idscorrection.SetItem(llCorrectionRow,'Company_Code', ls_Company_Code)
//				idscorrection.SetItem(llCorrectionRow,'Date_Encountered', string(today(),"dd-mm-yyyy"))
//				idscorrection.SetItem(llCorrectionRow,'Sku_Code', ls_Sku)
//				idscorrection.SetItem(llCorrectionRow,'Country_Origin', ls_coo2)
//				idscorrection.SetItem(llCorrectionRow,'Correction_No', '00000000000000000000000000000')
//				idscorrection.SetItem(llCorrectionRow,'Correction_Type', 'CG')
//				idscorrection.SetItem(llCorrectionRow,'Adjusted_Quantity', string(ll_qty*-1,"+00000000;-00000000"))
//				idscorrection.SetItem(llCorrectionRow,'Party_Code', ' ')
//				idscorrection.SetItem(llCorrectionRow,'Bonded_Ind', ls_bonded)
//		//Add non-bonded to old owner	
//				llCorrectionRow = idscorrection.insertRow(0)
//
//				idscorrection.SetItem(llCorrectionRow,'Site_Name', ls_warehouse)
//				idscorrection.SetItem(llCorrectionRow,'Company_Code', ls_Company_Code)
//				idscorrection.SetItem(llCorrectionRow,'Date_Encountered', string(today(),"dd-mm-yyyy"))
//				idscorrection.SetItem(llCorrectionRow,'Sku_Code', ls_Sku)
//				idscorrection.SetItem(llCorrectionRow,'Country_Origin', ls_coo2)
//				idscorrection.SetItem(llCorrectionRow,'Correction_No', '00000000000000000000000000000')
//				idscorrection.SetItem(llCorrectionRow,'Correction_Type', 'CG')
//				idscorrection.SetItem(llCorrectionRow,'Adjusted_Quantity', string(ll_qty,"+00000000;-00000000"))
//				idscorrection.SetItem(llCorrectionRow,'Party_Code', ' ')
//				idscorrection.SetItem(llCorrectionRow,'Bonded_Ind', 'N')
//				ls_bonded = 'N'
//			End If
	//Back Out Old Owner
			llCorrectionRow = idscorrection.insertRow(0)

			idscorrection.SetItem(llCorrectionRow,'Site_Name', ls_warehouse)
			idscorrection.SetItem(llCorrectionRow,'Company_Code', ls_Company_Code)
//			idscorrection.SetItem(llCorrectionRow,'Date_Encountered', string(today(),"dd-mm-yyyy"))
// TAM use Ship Complete Date instead of today
			idscorrection.SetItem(llCorrectionRow,'Date_Encountered', ls_date)
			idscorrection.SetItem(llCorrectionRow,'Sku_Code', ls_Sku)
			idscorrection.SetItem(llCorrectionRow,'Country_Origin', ls_coo2)
//			idscorrection.SetItem(llCorrectionRow,'Correction_No', '00000000000000000000000000000')
			idscorrection.SetItem(llCorrectionRow,'Correction_No', lscorrection)
			idscorrection.SetItem(llCorrectionRow,'Correction_Type', 'OE')
			idscorrection.SetItem(llCorrectionRow,'Adjusted_Quantity', string(ll_qty*-1,"+00000000;-00000000"))
			idscorrection.SetItem(llCorrectionRow,'Party_Code', ' ')
			idscorrection.SetItem(llCorrectionRow,'Bonded_Ind', ls_bonded)
	// Add New Owner
			llCorrectionRow = idscorrection.insertRow(0)

			idscorrection.SetItem(llCorrectionRow,'Site_Name', ls_warehouse)
			idscorrection.SetItem(llCorrectionRow,'Company_Code', '3C')
//			idscorrection.SetItem(llCorrectionRow,'Date_Encountered', string(today(),"dd-mm-yyyy"))
// TAM use Ship Complete Date instead of today
			idscorrection.SetItem(llCorrectionRow,'Date_Encountered', ls_date)
			idscorrection.SetItem(llCorrectionRow,'Sku_Code', ls_Sku)
			idscorrection.SetItem(llCorrectionRow,'Country_Origin', ls_coo2)
//			idscorrection.SetItem(llCorrectionRow,'Correction_No', '00000000000000000000000000000')
			idscorrection.SetItem(llCorrectionRow,'Correction_No', lscorrection)
			idscorrection.SetItem(llCorrectionRow,'Correction_Type', 'OE')
			idscorrection.SetItem(llCorrectionRow,'Adjusted_Quantity', string(ll_qty,"+00000000;-00000000"))
			idscorrection.SetItem(llCorrectionRow,'Party_Code', ' ')
			idscorrection.SetItem(llCorrectionRow,'Bonded_Ind', ls_bonded)
		End If
		End If

	
	// Format the Output String Fixed Lenth

		If ls_Warehouse > '' Then
			lsOutString = '"' + trim(Left(ls_Warehouse,30)) + Space(30 - Len(ls_Warehouse)) + '","' 	//Site Name
		Else
			lsOutString = Space(30) + '","'
		End If
		lsOutString += string(ll_Qty,"000000000") + '","'															//Quantity
		If ls_Date > '' Then
			lsOutString+= ls_date + '","'																					//Departure date
		Else
			lsOutString+= Space(10) + '","'
		End If	
		lsOutString += space(5) + '","'																					//Departure Time
		If ls_Sku > '' Then
			lsOutString += trim(Left(ls_sku,20)) + Space(20 - Len(ls_sku)) + '","'							//Sku
		Else
			lsOutString+= Space(20) + '","'
		End If
		If ls_trailer > '' Then
			lsOutString += trim(Left(ls_trailer,20)) + Space(20 - Len(ls_trailer)) + '","'				//Trailer Code
		Else
			lsOutString+= Space(20) + '","'
		End If
		lsOutString += trim(Left(asDoNo,15)) + Space(15 - Len(asDoNo)) + '","'								//Order Code
		If ls_Order_Type > '' Then
			lsOutString += trim(Left(ls_Order_Type,2)) + Space(2 - Len(ls_Order_Type)) + '","'			//Order Type
		Else
			lsOutString+= 'Space(2) + ","'
		End If
	//Default Company code to 3com for all shipments
			lsOutString += '3C' + '","'
		lsOutString += Space(30) + '","'																					//Container Code
		If ls_Coo > '' Then
			lsOutString += trim(Left(ls_COO2,2)) + Space(2 - Len(ls_COO2)) + '","'							//Country of Origin
		Else
			lsOutString+= Space(2) + '","'
		End If
		If lsBOL > '' Then
			lsOutString += trim(Left(lsBOL,15)) + Space(15 - Len(lsBOL)) + '","'								//BOL
		Else
			lsOutString+= Space(15) + '","'
		End If
		lsOutString += Space(1) + '","'																					//Active Refinement Ind
		lsOutString += Space(3) + '","'																					//Currency	
		If ls_BT_Address_1 > '' Then
			lsOutString+= trim(Left(ls_BT_Address_1,40)) + Space(40 - Len(ls_BT_Address_1)) + '","'	//Customer Address 1 
		Else
			lsOutString+= 'None' + Space(36) + '","'
		End If
		If ls_BT_City > '' Then
			lsOutString+= trim(Left(ls_BT_City,40)) + Space(40 - Len(ls_BT_City)) + '","'					//Customer City
		Else
			lsOutString+= 'None' + Space(36) + '","'
		End If
		If ls_BT_Country2 > '' Then
			ls_BT_Country2 = upper(ls_BT_Country2) //dts (9/05/06) 
			lsOutString+= trim(Left(ls_BT_Country2,2)) + Space(2 - Len(ls_BT_Country2)) + '","'			//Customer Country
		//Jxlim 08/24/2012 If bill_to.country is empty used ship_to country for Physio
		ElseIf Left(Upper(asProject), 6) = 'PHYSIO'  and IsNull(ls_BT_Country2) or ls_BT_Country2 = ''	 Then	
			ls_BT_Country2 = upper(ls_d_Country2) //copy from ship_to country  Jxlim 08/24/2012
			lsOutString+= trim(Left(ls_BT_Country2,2)) + Space(2 - Len(ls_BT_Country2)) + '","'			//Customer Country
		Else
			lsOutString+= 'XX' + '","'
		End If		
		
		If ls_BT_Name > '' Then
			lsOutString+= trim(Left(ls_BT_Name,30)) + Space(30 - Len(ls_BT_Name)) + '","'					//Customer Name 
		Else
			lsOutString+= 'None' + Space(26) + '","'
		End If
		If ls_D_Cust_Code > '' Then
			lsOutString+= trim(Left(ls_D_Cust_Code,30)) + Space(30 - Len(ls_D_Cust_Code)) + '","'		//Destination Code 
		Else
			lsOutString+= Space(30) + '","'
		End If
		lsOutString+= Space(18) + '","'																					//Cust VAT
		lsOutString+= Space(20) + '","'																					//Cust Zip
		lsOutString+= Space(15) + '","'																					//Carrier Code
		lsOutString+= Space(3) + '","'																					//Carrier Type
		If ls_D_Address_1 > '' Then
			lsOutString+= trim(Left(ls_D_Address_1,40)) + Space(40 - Len(ls_D_Address_1)) + '","'		//Destination Address 1 
		Else
			lsOutString+= 'None' + Space(36) + '","'
		End If
		If ls_D_City > '' Then
			lsOutString+= trim(Left(ls_D_City,40)) + Space(40 - Len(ls_D_City)) + '","'					//Destination City
		Else
			lsOutString+= 'None' + Space(36) + '","'
		End If
		If ls_D_Country > '' Then
			ls_D_Country2 = upper(ls_D_Country2) //dts (9/05/06) 
			lsOutString+= trim(Left(ls_D_Country2,2)) + Space(2 - Len(ls_D_Country2)) + '","'			//Destination Country
		Else
			lsOutString+= 'XX' + '","'
		End If
		If ls_D_Cust_Code > '' Then
			lsOutString+= trim(Left(ls_D_Cust_Code,30)) + Space(30 - Len(ls_D_Cust_Code)) + '","'		//Destination Code 
		Else
			lsOutString+= Space(30) + '","'
		End If
		If ls_D_Name > '' Then
			lsOutString+= trim(Left(ls_D_Name,30)) + Space(30 - Len(ls_D_Name)) + '","'					//Destination Name 
		Else
			lsOutString+= 'None' + Space(26) + '","'
		End If	
		lsOutString+= Space(18) + '","'																					//Destination VAT
		lsOutString+= Space(20) + '","'																					//Destination Zip
		If ls_Delivery_Term_Code > '' Then
			lsOutString+= trim(Left(ls_Delivery_Term_Code,3)) + Space(3 - Len(ls_Delivery_Term_Code)) + '","'	//Delivery Term Code
		Else
			lsOutString+= Space(3) + '","'
		End If
		lsOutString+= Space(30) + '","'																					//Party Code
		//TAM 2006/01/09 Send Price for AMD
		If lsprice > '0' Then 
			lsOutString += fill('0',(14 - len(trim(lsprice)))) + trim(lsprice)
		Else
			lsPrice = '00000000000000'
		End If

		
		
		lsOutString+= trim(Left(ls_Delivery_Term_Code,3)) + Space(3 - Len(ls_Delivery_Term_Code)) + '","'	//Delivery Term Code

		If ls_Bonded > '' Then
			lsOutString+= ls_Bonded + '"'																					//Bonded Ind
		Else
			lsOutString+= Space(1) + '"'
		End If

		llNewRow = idsOut.insertRow(0)
		idsOut.SetItem(llNewRow,'Project_id', 'asProject')
		idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
		idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
		idsOut.SetItem(llNewRow,'batch_data', lsOutString)
		idsOut.SetItem(llNewRow,'file_name', ls_filename)
	Next
End if


//Write the Outbound Correction File for Owner Changes Before the Shipment gets written
If llCorrectionRow > 0 Then
	this.uf_process_correction_datastore(asproject, idscorrection)
End If
	
//Write the Outbound File - no need to save and re-retrieve - just use the currently loaded DW
// TAM 2006/01/10 - Allow for Multiple Marc Gt projects in the ini file
//gu_nvo_process_files.uf_process_flatfile_outbound(idsOut,'MARC_GT')
gu_nvo_process_files.uf_process_flatfile_outbound(idsOut,"MARC_GT_" + asproject)


Return 0
end function

on u_nvo_marc_transactions.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_nvo_marc_transactions.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

