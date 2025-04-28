HA$PBExportHeader$u_nvo_gm_ims.sru
$PBExportComments$Screen Scraping functions for the GM IMS system
forward
global type u_nvo_gm_ims from nonvisualobject
end type
end forward

global type u_nvo_gm_ims from nonvisualobject
end type
global u_nvo_gm_ims u_nvo_gm_ims

forward prototypes
public function integer uf_verify_bom (ref window awwindow, ref datawindow adwdetail)
public function string wf_format_group (string asgroup)
public function integer uf_update_ro_contract (datastore adsbom)
public function integer uf_update_bom (string asxml, ref window awwindow)
public function integer uf_update_asn_contract (ref datastore adsbom)
end prototypes

public function integer uf_verify_bom (ref window awwindow, ref datawindow adwdetail);String	lsFile, lsRun, lsUser, lsPassword, lsResponse, lsErrorText, &
			lsStatusMsg, lsStatusMsgSave, lsTempMsg, lsMsg, lsTemp, lsSKUSave
Integer	liFileNo, listatusfileNo, liPos, liCurrPos, liMaxPos, liRC
Long	llRowPos, llRowCount,  llBeginPos, llEndPos
Boolean	lbFileExists
Str_parms	lstrParms

//User ID and Password are coming from USer File
Select gm_ims_logonID, gm_ims_password
into	:lsUser, :lsPassword
from Usertable
where USerID = :gs_UserID;

If lsUser = "" or lsPassword = "" Then
	MEssagebox("", "GM IMS USer ID and Password are required before proceeding~r(They are entered on User Maintenance)",StopSign!)
	Return -1
End If

//Look in the Macros sub-directory of the SIMS directory
If gs_SysPath > '' Then
	lsFile = gs_syspath + 'Macros\' + 'GM_IMS_EPCOU03A.ebm'
	
Else
	lsFile = 'Macros\' + 'GM_IMS_EPCOU03A.ebm'
End If

If Not FileExists(lsFile) Then
	Messagebox("", 'Unable to Find Macro Format (GM_IMS_EPCOU03A.ebm)!')
	Return -1
End If

//We can't call the Macro with parms - We need to create a .ini file with the variables
liFileNo = FileOpen(gs_syspath + 'Macros\' + 'GM_IMS_EPCOU03A.ini',LineMode!,Write!,LockReadWrite!,Replace!)
If liFileNo < 0 Then
	Messagebox("","Unable to create Macro .ini File")
	Return -1
End If

SetPointer(Hourglass!)
w_main.SetMicrohelp("Retrieving BOM data from IMS")

//Write User ID and Password to .ini file
FileWrite(liFileNo,lsUser)
FileWrite(liFileNo,lsPassword)

//For Each Detail REcord, add record to the .ini file - Only need to add SKU once - DW sorted in calling DW first

llRowCount = adwDetail.RowCount()
For llRowPos = 1 to llRowCount
	
	If adwdetail.GetITemString(llRowPos,'sku') <> lsSKUSave Then
		FileWrite(liFileNo,adwdetail.GetITemString(llRowPos,'sku') + "|" + adwdetail.GetITemString(llRowPos,'supp_code'))
	End If
	
	lsSKUSave = adwdetail.GetITemString(llRowPos,'sku')
	
Next

FileClose(liFileNo)
Sleep(2)

//Delete file from previous run if exists...
If FileExists(gs_syspath + 'Macros\' + 'EPC2u03.tmp') Then
	FileDelete(gs_syspath + 'Macros\' + 'EPC2u03.tmp')
End If

If FileExists(gs_syspath + 'Macros\' + 'EPC2u03.xml') Then
	FileDelete(gs_syspath + 'Macros\' + 'EPC2u03.xml')
End If

If FileExists(gs_syspath + 'Macros\' + 'GM_IMS_EPCOU03A_status.txt') Then
	FileDelete(gs_syspath + 'Macros\' + 'GM_IMS_EPCOU03A_status.txt')
End If

//Run the Macro
lsRun = 'ebrun.exe ' + gs_syspath + 'Macros\' + 'GM_IMS_EPCOU03A.ebm' 
Run(lsRun,Normal!)

//Open status 
Open(w_ims_status)
w_ims_status.title = "IMS - BOM, COO and Contract"

//Wait for the output file to be created.
lbFileExists = False
Do Until lbFileExists
	
	Yield()
	
	//Get the macro status from the status file
	liStatusFileNo = FileOpen(gs_syspath + 'Macros\' + 'GM_IMS_EPCOU03A_status.txt',LineMode!,Read!,Shared!)
	If liStatusFileNo > 0 Then
		
		FileRead(liStatusFileNo,lsStatusMsg)
		
		If isvalid(w_ims_status) and lsStatusMsg <> lsStatusMsgSave Then
			
			//If pipe seperated, we have a pos and max pos for the status bar
			If Pos(lsStatusMsg,'|') > 0 Then
				
				lsTempMsg = lsStatusMsg
				liPOs = Pos(lsTempMsg,'|')
				liCurrPos = Long(Left(lsTempMsg,(liPos - 1)))
				lsTempMsg = Right(lsTempMsg,(len(lsTempMsg) - liPos))
				
				liPOs = Pos(lsTempMsg,'|')
				liMaxPos = Long(Left(lsTempMsg,(liPos - 1)))
				lsTempMsg = Right(lsTempMsg,(len(lsTempMsg) - liPos))
				
				lsMSg = lsTempMsg
				
				w_ims_status.hpb_status.Position = liCurrPos
				w_ims_status.hpb_status.MaxPosition = liMaxPos
				
			Else
				
				lsMsg = lsStatusMsg
				
			End If
			
			w_ims_status.st_status.Text = lsMsg
			
		End If /*Status msg updated */
		
		lsStatusMsgSave = lsStatusMsg
		FileClose(liStatusFileNo)
		
	End IF /*Status file read*/
		
	//If popup window has been closed, get out...
	If not isvalid(w_ims_Status) Then
		
		//If canceled, delete ini file which will cause macro to stop
		If FileExists(gs_syspath + 'Macros\' + 'GM_IMS_EPCOU03A.ini') Then
			FileDelete(gs_syspath + 'Macros\' + 'GM_IMS_EPCOU03A.ini')
		End If
		
		Return -1
		
	End If
	
	lbFileExists = FileExists(gs_syspath + 'Macros\' + 'EPC2u03.xml')
	If lbFileExists Then
		w_ims_status.st_status.Text = "Copying data, PLEASE WAIT..."
		Sleep(3) /*Make sure file completely written...*/
	End If
	
Loop

If  isvalid(w_ims_Status) Then
	close (w_ims_status)
End iF

//Read the file
liFileNo = FileOpen(gs_syspath + 'Macros\' + 'EPC2u03.xml',StreamMode!,Read!)

liRC = FileRead(liFileNo,lsTemp)
Do While liRC > 0
	lsResponse += lsTemp
	liRC = FileRead(liFileNo,lsTemp)
Loop

FileClose(liFileNo)

//Cleanse the XML (remove any special characters
w_main.SetMicrohelp("Parsing XML...")
lsREsponse = f_cleanse_xml(lsResponse)

Setpointer(Arrow!)
w_main.SetMicrohelp("Ready")

//Process return XML...

//Messagebox("",lsREsponse)

//If we don't have an end marker, something went wrong...
If Pos(Upper(lsResponse),"</GM_IMS_RESPONSE>") = 0 Then
	Messagebox("", "The GM IMS system did not return a valid response.~r~rNo updates applied to Item Master")
	Return -1
End IF

//Check for errors...
If Pos(Upper(lsResponse),"ERRORTEXT") > 0 Then
	
	llBeginPos = Pos(Upper(lsResponse),"ERRORTEXT") + 11
	llEndPos = Pos(Upper(lsResponse),"'",llbeginPos + 1)
	
	lsErrorText = MId(lsResponse,llBeginPos,(llEndPos - llBeginPos))
	
	Messagebox("", "The GM IMS system returned the following error:~r~r" + lsErrorText + "~r~rNo updates applied to Item Master")
	Return -1
	
End If

//See if any items were returned...
If Pos(Upper(lsResponse),"<PARENTITEM>") = 0 Then
	Messagebox("", "The GM IMS system did not return any items to update.~r~rNo updates applied to Item Master")
	Return -1
End IF

// 06/26/06 - PCONKL - Updating behind the scenes - not showing user
Return uf_update_Bom(lsResponse,awwindow)


end function

public function string wf_format_group (string asgroup);

String	lsGroup

// "Three digit group numbers will have one leading zero (i.e. 0.659). All other Group numbers will have
//  No leading zeros (i.e.1.266, 10.373" From the GM standards manual

lsGroup = asGroup

//First, make sure there is a period - If not, there should be 3 digits after...
If POs(lsGroup,'.') = 0 Then
	lsGroup = Left(lsGroup,(len(lsGroup) - 3)) + "." + Right(lsGroup,3)
End IF

Choose Case Len(lsGroup) /*len includes period*/
		
	Case 4 /*needs a leading zero for 3 digit groups*/
		
		lsGroup = "0" + lsGroup
		
	Case 6 /*drop any leading zeros*/
		
		If left(lsGroup,1) = '0' Then lsGroup = Right(lsGroup,5)
				
End Choose

Return lsGroup
end function

public function integer uf_update_ro_contract (datastore adsbom);String	lsSKU, lsSupplierContract, lsMenloContract, lsContract, lsCOO
Long	llRowPos, llRowCount, llFindRow

llRowCount = adsBOM.RowCount()
For llRowpOs = 1 to llRowCount
	
	lsSKU = adsBOM.getITemString(llRowPos, 'parent_sku')
	lsSupplierContract = adsBOM.getITemString(llRowPos, 'supplier_Contract')
	lsMenloContract = adsBOM.getITemString(llRowPos, 'Menlo_Contract')
	
	//validate COO returned from IMS
	lsCOO = adsBOM.getITemString(llRowPos, 'COO')
	If f_get_country_name(lsCOO) = "" Then
		lsCOO = 'XXX'
	End If
	
	If lsSupplierContract > "" Then
		lsContract = "S = '" + lsSupplierContract + "' "
	End If
	
	If lsMEnloContract > "" THen
		
		If lsContract > "" Then
			lsContract += ", M = " + lsMEnloContract
		Else
			lsContract = "M = " + lsMEnloContract
		End If
		
	End IF
	
	// 02/09 - PCONKL - We want to also update the Contract if it has been reomved (lsContract = "")
//	If lsContract > "" Then
		
		llFindRow = w_ro.idw_detail.Find("Upper(Sku) = '" + Upper(lsSKU) + "'",1, w_ro.idw_detail.rowcount())
		Do While llFindRow > 0
			
			w_ro.idw_detail.SetITem(llFindRow,'User_Field3', lsContract)
			
			If lsCOO > "" and lsCOO <> 'XXX' Then
				w_ro.idw_detail.SetITem(llFindRow,'Country_of_Origin', lsCoo)
			End If
			
			llFindRow ++
			If llFindRow > w_ro.idw_detail.rowcount() Then
				llFindRow = 0
			Else
				llFindRow = w_ro.idw_detail.Find("Upper(Sku) = '" + Upper(lsSKU) + "'",llFindRow, w_ro.idw_detail.rowcount())
			End If
			
		Loop
			
//	End If
	
Next /* Detail Row */

w_ro.ib_changed = True

Return 0
end function

public function integer uf_update_bom (string asxml, ref window awwindow);
String lsParentSKU, lsParentSKUSave, lsChildSku, lsDesc, lsSpanishDesc, lsFrenchDesc,	lsPackageType, &
			lsItemGroup, lsACDPart, lsErrText, lsChildSupplier, lsParentSupplier, lsUPC, lsACDPLC, lsCOO, lsNewITems, presentation_str, lsSQL, dwsyntax_str
			
Long	llRowCount, llRowPos, llUPC, llChildQty, llMerchQty, llFindRow, llDefaultOwner, llSuppPos, llSuppCount, llCount, llOwner

Integer	liRC

DateTime ldtToday
DataStore	ldsBOM, ldsSupplier

ldsSupplier = Create Datastore
presentation_str = "style(type=grid)"
lsSQl = "Select supp_code from Item_Master"  /*sql appended below*/
dwsyntax_str = SQLCA.SyntaxFromSQL(lsSQL, presentation_str, lsErrText)
ldsSupplier.Create( dwsyntax_str, lsErrText)
ldsSupplier.SetTransObject(SQLCA)

ldtToday = DateTime(today(),now())
lsNewITems = ""

SetPointer(Hourglass!)

//Load DS from XML
ldsBom = Create DataStore
ldsBom.dataobject = 'd_load_gm_bom'
ldsBom.SetTransObject(SQLCA)
liRC = ldsBOM.ImportString(xml!,asxml)

If liRC < 0 Then
	Messagebox("", "Error importing XML Document.~r~rNo changes applied to Item Master!")
	Return -1
End If

ldsBom.sort()

//Delete any duplicate parent/child sku combinations...
llRowCount = ldsBom.RowCount()
For llRowPos = llRowCount to 1 step -1

	If llRowPos > 1 then
		
		If ldsBom.GetITemString(llRowPos,'parent_sku') = ldsBom.GetITemString((llRowPos - 1),'parent_sku') and &
			ldsBom.GetITemString(llRowPos,'child_sku') = ldsBom.GetITemString((llRowPos - 1),'child_sku') Then
			
				ldsBom.DeleteRow(llRowPos)
				
		End If
			
	End If
	
Next

//If coming from REceive Order or ASN Update screen, we want to copy contract info to Receive Detail
If awwindow = w_ro Then	
	uf_update_ro_contract(ldsBOM)
ElseIf awwindow = w_load_gm_asn Then	
	uf_update_asn_contract(ldsBOM)
End If

Execute Immediate "Begin Transaction" using SQLCA;

//For each PArent SKU - update the Item MAster, Delete the Packaging component records and re-create

lLRowCount = ldsBom.RowCount()
For lLRowPos = 1 to llRowCount
	
	lsParentSku = ldsBom.GetITemString(llRowPos,'parent_sku')
	lsDesc = ldsBom.GetITemString(llRowPOs,'desc')
	lsFrenchDesc = ldsBom.GetITemString(llRowPOs,'french_desc')
	lsSpanishDesc = ldsBom.GetITemString(llRowPOs,'spanish_desc')
	
	lsItemGroup = ldsBom.GetITemString(llRowPOs,'group')
	lsItemGroup = wf_format_group(lsItemGroup) /* group code may need formatting*/
	lsChildSku = ldsBom.GetITemString(llRowPOs,'child_sku')
	lsACDPart = ldsBom.GetITemString(llRowPOs,'acd_part')
	lsACDPLC = ldsBom.GetITemString(llRowPOs,'acd_plc')
	lsPackageType = ldsBom.GetITemString(llRowPOs,'package_type')
	
	lsUPC = Trim(ldsBom.GetITemString(llRowPos,'upc'))
	
	//Remove any spaces from UPC
	Do While Pos(lsUpc," ") > 0
		lsUpc = Replace(lsUpc,Pos(lsUpc," "),1,"")
	Loop
	
	lsCOO = ldsBom.GetITemString(llRowPOs,'coo')
	If isNull(lsCOO) or lsCOO = "" Then lsCOO = "XXX"
	
	llmerchQty = ldsBom.GetITemNumber(llRowPos,'merch_qty')
	llChildQty = ldsBom.GetITemNumber(llRowPos,'child_Qty')
	
	//If parent SKU has changed, update the item master and delete the children packaging records..
	If lsParentSku <> lsParentSkuSave Then
		
		//Retrieve all suppliers for this item - we will delete all children and recreate for all parent suppliers
		
		ldsSupplier.SetSqlSelect("Select supp_code from Item_Master where project_id = '" + gs_project + "' and sku = '" + lsParentSKU + "'")
		llSuppCount = ldsSupplier.Retrieve()
		
		//If we are coming from the ASN Load, it is possible that we have scraped items and/or suppliers that don't yet exist in SIMS
		If llSuppCount = 0 and awWindow = w_load_gm_asn Then /* Item doesn't exist in SIMS*/
			
			//Make sure Supplier exists...
			llFindRow = w_load_gm_asn.dw_asn.Find("sku = '" + lsParentSKU + "'",1,w_load_gm_asn.dw_asn.RowCount())
			If llFindRow > 0 Then
				
				lsParentSupplier = w_load_gm_asn.dw_asn.GetITemString(llFindRow,'supp_code')
				
				Select Count(*) into :llCount
				From Supplier
				Where Project_id = :gs_project and supp_code = :lsPArentSupplier;
				
				//If not found, try with a leading zero...
				If llCount < 1 Then
					
					lsParentSupplier = "0" + lsParentSupplier
					
					Select Count(*) into :llCount
					From Supplier
					Where Project_id = :gs_project and supp_code = :lsPArentSupplier;
					
				End If
				
				//Insert a supplier record...
				If llCount < 1 Then 
					
					lsParentSupplier = w_load_gm_asn.dw_asn.GetITemString(llFindRow,'supp_code') /*create supplier as retrieved from IMS*/
					
					Insert into Supplier (project_id, supp_code, supp_name, LAst_user, LAst_Update)
					Values (:gs_project, :lsParentSupplier, :lsParentSupplier, :gs_userid, :ldtToday)
					using SQLCA;
					
					If sqlca.SqlCode < 0 Then
			
						lsErrText = SQLCA.SQLErrText
   					Execute Immediate "ROLLBACK" using SQLCA;
						SetPointer(Arrow!)
						Messagebox("", "Unable to insert new supplier record:~r~r" + lsErrText)
						Return -1
			
					End If
							
				End If /*supplier not found*/
				
				//Get THe Owner for this Supplier...
				Select Owner_id into :llOwner
				From Owner
				Where Project_id = :gs_project and owner_type = 'S' and owner_cd = :lsParentSupplier;
				
				//Insert the new Item MAster record
				Insert Into Item_MASter (Project_ID, SKU, Supp_code, Description, User_Field8, User_Field9, User_Field10, USer_Field1, 
													User_Field12, part_upc_Code, UOM_2, Qty_2, Country_of_Origin_Default, Owner_ID, LAst_User, LAst_UPdate)
						Values				( :gs_Project, :lsPArentSKU, :lsParentSupplier, :lsDesc, :lsFrenchDesc,:lsSpanishDesc,:lsACDPLC, :lsItemGroup,
													:lsACDPart, :lsUPC, 'PKG', :llMerchQty, :lsCOO, :llOwner, :gs_userID, :ldtToday)
				using SQLCA;
					
				If sqlca.SqlCode < 0 Then
			
					lsErrText = SQLCA.SQLErrText
   				Execute Immediate "ROLLBACK" using SQLCA;
					SetPointer(Arrow!)
					Messagebox("", "Unable to insert new ItemMaster record:~r~r" + lsErrText)
					Return -1
			
				End If									
					
				//Add a row in the Supplier DS so we create children records for this supplier (below)
				ldsSupplier.InsertRow(0)
				ldsSupplier.SetItem(1,'supp_code',lsParentSupplier)
				
			End If /*detail row found*/
			
			
		End If /*ASN scrape - Item not found */
			
		//Update Item MASter(s) if we didn't just create it
		If llSuppCount > 0 Then
			
			Update Item_MASter
			Set Description = :lsDesc, User_field8 = :lsFrenchDesc, User_field9 = :lsSpanishDesc, user_field10 = :lsACDPLC, 
					User_field1 = :lsItemGroup, user_Field12 = :lsACDPart, part_upc_Code = :lsUPC, UOM_2 = 'PKG', Qty_2 = :llMerchQty, 
					Country_of_Origin_Default = :lsCOO, Last_user = :gs_UserID, LASt_Update = :ldtToday
			Where Project_id = :gs_project and sku = :lsParentSKU;
		
			If sqlca.SqlCode < 0 Then
			
				lsErrText = SQLCA.SQLErrText
   			Execute Immediate "ROLLBACK" using SQLCA;
				SetPointer(Arrow!)
				Messagebox("", "Unable to udpate Item Master Record:~r~r" + lsErrText)
				Return -1
			
			End If
			
		End If /*items exist in SIMS*/
			
		
		//Delete all children and re-create for each supplier retrieved above
		Delete from Item_Component
		Where project_id = :gs_Project and sku_parent = :lsParentSku and component_type = 'P';
		
		If sqlca.SqlCode < 0 Then
			
			lsErrText = SQLCA.SQLErrText
   		Execute Immediate "ROLLBACK" using SQLCA;
			SetPointer(Arrow!)
			Messagebox("", "Unable to Delete old Child Packaging Record(s):~r~r" + lsErrText)
			Return -1
			
		End If

		
	End If /*parent sku changed*/
	
	
	
	//Create a new Package record (item_Component)
	
	If lsChildSKU > "" Then
		
		//We need the supplier of the child Item
		Select Min(supp_code) into:lsChildSupplier
		from Item_MAster 
		Where project_id = :gs_project and sku = :lsChildSku;
	
		//If item not found, create for supplier 0000 - Non inventory tracked items
		If lsChildSupplier = "" or isnull(lsChildSupplier) Then 
			
			//If owner for 000 not already retrieved, retrieve now
			If llDefaultOwner = 0 or isnull(llDefaultOwner) Then
				
				Select Owner_id into :llDefaultOwner
				From Owner
				Where Project_id = :gs_project and owner_type = 'S' and owner_cd = '0000';
				
			End If
			
			lsChildSupplier = '0000'
			
			Insert Into Item_Master (Project_id, SKU, Supp_code, OWner_ID, Country_of_origin_default, Description,
												Grp, last_user, last_update)
					Values (:gs_project, :lsChildSKU, :lsChildSupplier, :llDefaultOwner, 'XXX', 'Misc pacakging materials',
								'Non-Inv', :gs_userID, :ldttoday);
					
			If sqlca.SqlCode < 0 Then
				lsErrText = SQLCA.SQLErrText
   			Execute Immediate "ROLLBACK" using SQLCA;
				SetPointer(Arrow!)
				Messagebox("", "Unable to Insert new Item Master Record:~r~r" + lsErrText)
				Return -1
			End If
			
			If lsNewItems = "" Then
				lsNewItems = lsChildSKU
			Else
				lsNewItems += "~r" + lsChildSKU
			End If
			
		End If /*item not found*/
		
		//Create a child item for each Parent Supplier of the SKU
		lLSuppCount = ldsSupplier.RowCount()
		For llSuppPos = 1 to llSuppCount
			
			lsParentSupplier = ldsSupplier.GetITemString(llSuppPos,'Supp_code')
			
			Insert into item_component (project_id, sku_parent, supp_Code_parent, sku_child, supp_Code_child,
													child_qty, last_user, last_update, Component_Type, Bom_Group, child_package_Type)
											
			Values							(:gs_project, :lsParentSku, :lsparentSupplier, :lsChildSku, :lsChildSupplier,
													:llChildQty, :gs_userID, :ldttoday, 'P', '-', :lsPackageType);
												
			If sqlca.SqlCode < 0 Then
				lsErrText = SQLCA.SQLErrText
   			Execute Immediate "ROLLBACK" using SQLCA;
				SetPointer(Arrow!)
				Messagebox("", "Unable to Insert new Child Packaging Record(s):~r~r" + lsErrText)
				Return -1
			End If
			
		next /*parent Supplier*/
		
	End If /*Child SKU present */
	
	lsPArentSkuSave = lsParentSKU
	
Next

Execute Immediate "COMMIT" using SQLCA;

SetPointer(Arrow!)

//We don't want to show status msg if coming from ASN LOad (batch process)
If awwindow <> w_load_gm_asn Then
	
	If lsNewITems = "" Then
		Messagebox("","Item Master and Packaging records updated.")
	Else
		Messagebox("","Item Master and Packaging records updated.~r~rThe following new item(s) were created as Non Inventory Tracked Items (Supplier '0000'):~r~r" + lsNewItems + "~r~rThe supplier can be changed in Item Master Maintenance if necessary.")
	End If
	
End If

Return 0

end function

public function integer uf_update_asn_contract (ref datastore adsbom);
String	lsSKU, lsSupplierContract, lsMenloContract, lsContract, lsCOO
Long	llRowPos, llRowCount, llFindRow

SetPointer(Hourglass!)

llRowCount = adsBOM.RowCount()
For llRowpOs = 1 to llRowCount
	
	lsSKU = adsBOM.getITemString(llRowPos, 'parent_sku')
	lsSupplierContract = adsBOM.getITemString(llRowPos, 'supplier_Contract')
	lsMenloContract = adsBOM.getITemString(llRowPos, 'Menlo_Contract')
	
	//validate COO returned from IMS
	lsCOO = adsBOM.getITemString(llRowPos, 'COO')
	If f_get_country_name(lsCOO) = "" Then
		lsCOO = 'XXX'
	End If
	
	If lsSupplierContract > "" Then
		lsContract = "S = '" + lsSupplierContract + "' "
	End If
	
	If lsMEnloContract > "" THen
		
		If lsContract > "" Then
			lsContract += ", M = " + lsMEnloContract
		Else
			lsContract = "M = " + lsMEnloContract
		End If
		
	End IF
	
	// 02/09 - PCONKL - We want to also update the Contract if it has been reomved (lsContract = "")
	//If lsContract > "" Then
		
		llFindRow = w_load_gm_asn.dw_asn.Find("Upper(Sku) = '" + Upper(lsSKU) + "'",1, w_load_gm_asn.dw_asn.rowcount())
		Do While llFindRow > 0
			
			w_load_gm_asn.dw_asn.SetITem(llFindRow,'User_Field3', lsContract)
			
			If lsCOO > "" and lsCOO <> 'XXX' Then
				w_load_gm_asn.dw_asn.SetITem(llFindRow,'Country_of_Origin', lsCoo)
			End If
			
			llFindRow ++
			If llFindRow > w_load_gm_asn.dw_asn.rowcount() Then
				llFindRow = 0
			Else
				llFindRow = w_load_gm_asn.dw_asn.Find("Upper(Sku) = '" + Upper(lsSKU) + "'",llFindRow, w_load_gm_asn.dw_asn.rowcount())
			End If
			
		Loop
			
	//End If
	
Next /* Detail Row */

SetPointer(Arrow!)

Return 0
end function

on u_nvo_gm_ims.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_nvo_gm_ims.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

