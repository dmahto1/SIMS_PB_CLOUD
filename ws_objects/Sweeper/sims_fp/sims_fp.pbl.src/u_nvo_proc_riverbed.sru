$PBExportHeader$u_nvo_proc_riverbed.sru
$PBExportComments$BCR 06-OCT-2011
forward
global type u_nvo_proc_riverbed from nonvisualobject
end type
end forward

global type u_nvo_proc_riverbed from nonvisualobject
end type
global u_nvo_proc_riverbed u_nvo_proc_riverbed

type prototypes

Function Long MultiByteToWideChar(UnsignedLong CodePage, Ulong dwFlags, string lpMultiByteStr, Long cbMultiByte,  REF blob lpWideCharStr, Long cchWideChar) Library "kernel32.dll" alias for "MultiByteToWideChar;Ansi" 

end prototypes

forward prototypes
public function integer uf_process_itemmaster (string aspath, string asproject)
public function integer uf_process_purchase_order (string aspath, string asproject)
public function integer uf_process_userfields (integer al_startimportcolumnnumber, integer al_totaluserfields, ref datastore adw_importdw, integer adw_importdwcurrentrow, ref datastore adw_destdw, integer adw_destdwcurrentrow)
public function integer uf_process_delivery_order (string aspath, string asproject)
public function integer uf_process_files (string asproject, string aspath, string asfile, string asinifile)
public function integer uf_return_order (string aspath, string asproject)
public function integer uf_process_dboh (string asproject, string asinifile)
public function integer uf_process_work_order (string aspath, string asproject)
public function integer uf_load_trax_terms (ref datastore adw_importdw, integer adw_importdwcurrentrow, ref datastore adw_destdw, integer adw_destdwcurrentrow)
end prototypes

public function integer uf_process_itemmaster (string aspath, string asproject);
//Process Item Master (IM) Transaction for Baseline Unicode Client

STRING lsTemp, lsProject, lsSku, lsSupplier
BOOLEAN lbError, lbNew
LONG llCount, llNew, llNewRow, llOwner, llexist
INTEGER lirc, liRtnImp
STRING lsLogOut
u_ds_datastore	ldsImport

//Item Master

u_ds_datastore	ldsItem 

ldsItem = Create u_ds_datastore
ldsItem.dataobject= 'd_baseline_unicode_item_master'
ldsItem.SetTransObject(SQLCA)

ldsImport = Create u_ds_datastore
ldsImport.dataobject = 'd_baseline_unicode_generic_import'

//Open and read the File In
lsLogOut = '      - Opening Item Master File: ' + asPath
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

//Bring in File
liRtnImp =  ldsImport.ImportFile( Text!, aspath) 

//Convert to Chinese - CodePage

integer li_row_idx, li_col_idx 
string lsdata, lsConvData

//for li_row_idx =1 to ldsImport.RowCount()
//
//	for li_col_idx = 1 to 75
//		
//		lsData = ldsImport.GetItemString(li_row_idx, "col" + string(li_col_idx))
//		
//		// Convert utf-8 to utf-16 
//		// Return the numbers of Wide Chars 
//		liRC = MultiByteToWideChar(65001, 0, lsData, -1, lblb_wide_chars, 0) 
//		IF liRC > 0 THEN 
//			
//				// Reserve Unicode Chars 
//				lblb_wide_chars = blob( space( (liRC+1)*2 ) ) 
//		
//				// Convert UTF-8 to UTF-16 
//				liRC = MultiByteToWideChar(65001, 0, lsData, -1, lblb_wide_chars, (liRC+1)*2 ) 
//		
//				// Convert UTF-16 to ANSI 
//				lsConvData = FromUnicode( lblb_wide_chars )         
//				
//		
//		END IF 
//		
////		lsConvData = String(lblb_wide_chars)
//		
//		if li_col_idx = 46 then 
//			Messagebox ("Error", lsData)		
//			Messagebox ("Error", lsConvData)
//			
//		end if
//		
//		if lsDAta <> lsConvData then
//			
//			ldsImport.SetItem(li_row_idx, "col" + string(li_col_idx), lsConvData)
//			
//		end if
//		
//	Next
//Next


if liRtnImp < 0 then
	lsLogOut = "-       ***Unable to Open Item Master File for '+asproject+' Processing: " + asPath + " Import Error: " + string(liRtnImp)
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
end if

integer llFileRowPos
integer llFilerowCount

llFilerowCount = ldsImport.RowCount()

//Loop through

for llFileRowPos = 1 to llFilerowCount

	w_main.SetMicroHelp("Processing Item Master Record " + String(llFileRowPos) + " of " + String(llFilerowCount))

	//Field Name	Type	Req.	Default	Description
	//Record ID	C(2)	Yes	“IM”	Item Master Identifier

	//Validate Rec Type is IM
	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col1"))
	If lsTemp <> 'IM' Then
		gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Invalid Record Type: '" + lsTemp + "'. Record will not be processed.")
		lbError = True
		Continue /*Process Next Record */
	End If

	//Project ID	C(10)	Yes	N/A	Project identifier
	
	lsTemp = Upper(Trim(ldsImport.GetItemString(llFileRowPos, "col2")))
	
	If IsNull(lsTemp) OR trim(lsTemp) = '' Then
		gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Project is required. Record will not be processed.")
		lbError = True
		Continue		
	Else
		lsProject = lsTemp
	End If	
	
	//SKU	C(50)	Yes	N/A	Material number

	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col3"))
	
	If IsNull(lsTemp) OR trim(lsTemp) = '' Then
		gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Sku is required. Record will not be processed.")
		lbError = True
		Continue		
	Else
		lsSku = lsTemp
	End If	


	//Supplier Code	C(20)	Yes	N/A	Valid Supplier code

	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col4"))
	
	If IsNull(lsTemp) OR trim(lsTemp) = '' Then
		gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Supplier Code is required. Record will not be processed.")
		lbError = True
		Continue		
	Else
		lsSupplier = lsTemp
	End If	

	////Retrieve for SKU - We will be updating across Suppliers

	llCount = ldsItem.Retrieve(lsProject, lsSKU, lsSupplier)
	
	llCount = ldsItem.RowCount()

	If llCount <= 0 Then

		llNew ++ /*add to new count*/
		lbNew = True
		llNewRow = ldsItem.InsertRow(0)

		ldsItem.SetItem(1,'SKU',lsSKU)
		ldsItem.SetItem(1,'project_id', lsProject)		
		
		//Get Default owner for Supplier
		Select owner_id into :llOwner
		From Owner
		Where project_id = :lsProject and Owner_type = 'S' and owner_cd = :lsSupplier;
		
		
		If IsNull(llOwner) OR llOwner <= 0  Then
			gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Owner for Supplier ("+lsSupplier+") not found in database.")
			lbError = True
			Continue			
		End If
		
		ldsItem.SetItem(1,'supp_code',lsSupplier)
		ldsItem.SetItem(1,'owner_id',llOwner)
							
	Else /*exists*/		
		llexist += llCount /*add to existing Count*/
		lbNew = False
	End If
	
	//Description	C(70)	Yes	N/A	Item description

	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col5"))
	
	If IsNull(lsTemp) OR trim(lsTemp) = '' Then
		gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Description is required. Record will not be processed.")
		lbError = True
		Continue		
	Else
		ldsItem.SetItem(1,'description', lsTemp)
	End If	

	//UOM1	C(4)	No	“EA”	Base unit of measure

	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col6"))
	
	If IsNull(lsTemp) OR trim(lsTemp) = '' Then
		lsTemp = "EA"
	End If	
	
	ldsItem.SetItem(1,'uom_1', lsTemp)
	
	//Length1	N(9,2)	No	N/A	Item Length
	
	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col7"))
	
	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'Length_1', Dec(lsTemp))
	End If	
	
	//Width1	N(9,2)	No	N/A	Item Width
	
	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col8"))
	
	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'Width_1', Dec(lsTemp))
	End If		
	
	//Height1 	N(9,2)	No	N/A	Item Height
	
	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col9"))
	
	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'Height_1', Dec(lsTemp))
	End If		
	
	//Weight1	N(11,5)	No	N/A	Net weight of base unit of measure (kg)

	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col10"))
	
	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'Weight_1', Dec(lsTemp))
	End If			
	
	//UOM2	C(4)	No	N/A	Level 2 unit of measure
	
	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col11"))
	
	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'UOM_2', lsTemp)
	End If			
	
	//Length2	N(9,2)	No	N/A	Item Length
	
	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col12"))
	
	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'Length_2', Dec(lsTemp))
	End If			
	
	//Width2	N(9,2)	No	N/A	Item Width

	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col13"))
	
	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'Width_2', Dec(lsTemp))
	End If		
	
	//Height2 	N(9,2)	No	N/A	Item Height
	
	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col14"))
	
	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'Height_2', Dec(lsTemp))
	End If			
	
	//Weight2	N(11,5)	No	N/A	Net weight of base unit of measure (kg)
	
	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col15"))
	
	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'Weight_2', Dec(lsTemp))
	End If			
	
	//Qty 2	N(15,5)	No	N/A	Level 2 Qty in relation to base UOM
	
	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col16"))
	
	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'Qty_2', Dec(lsTemp))
	End If			
	
	
	//UOM3	C(4)	No	N/A	Level 3 unit of measure
	
	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col17"))
	
	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'UOM_3', lsTemp)
	End If			
	
	//Length3	N(9,2)	No	N/A	Item Length
	
	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col18"))
	
	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'Length_3', Dec(lsTemp))
	End If		
	
	//Width3	N(9,2)	No	N/A	Item Width
	
	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col19"))
	
	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'Width_3', Dec(lsTemp))
	End If			
	
	//Height3	N(9,2)	No	N/A	Item Height

	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col20"))
	
	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'Height_3', Dec(lsTemp))
	End If			
	
	//Weight3	N(11,5)	No	N/A	Net weight of base unit of measure (kg)
	
	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col21"))
	
	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'Weight_3', Dec(lsTemp))
	End If				
	
	//Qty 3	N(15,5)	No	N/A	Level 3 Qty in relation to Base UOM

	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col22"))
	
	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'Qty_3', Dec(lsTemp))
	End If				

	//UOM4	C(4)	No	N/A	Base unit of measure

	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col23"))
	
	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'UOM_4', lsTemp)
	End If			
	
	//Length4	N(9,2)	No	N/A	Item Length
	
	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col24"))
	
	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'Length_4', Dec(lsTemp))
	End If			
	
	//Width4	N(9,2)	No	N/A	Item Width

	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col25"))
	
	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'Width_4', Dec(lsTemp))
	End If			
	
	
	//Height4	N(9,2)	No	N/A	Item Height

	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col26"))
	
	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'Height_4', Dec(lsTemp))
	End If			

	
	//Weight4	N(11,5)	No	N/A	Net weight of base unit of measure (kg)

	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col27"))
	
	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'Weight_4', Dec(lsTemp))
	End If			
	
	//Qty 4	N(15,5)	No	N/A	Level 4 Qty in relation to Base UOM

	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col28"))
	
	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'Qty_4', Dec(lsTemp))
	End If			

	//Cost	N(12,4)	No	N/A	Item Cost (std_cost)

	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col29"))
	
	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'std_cost', Dec(lsTemp))
	End If				
	
	//CC Frequency	N(5,0)	No	N/A	Cycle count frequency (in days)

	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col30"))
	
	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'CC_Freq', Dec(lsTemp))
	End If			
	
	//HS Code	C(15)	No	N/A	HS Code

	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col31"))
	
	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'HS_Code', lsTemp)
	End If			
	
	//UPC Code	C(14)	No	N/A	UPC Code

	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col32"))
	
	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'Part_UPC_Code', lsTemp)
	End If			
	
	//Freight Class	C(10)	No	N/A	Freight Class

	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col33"))
	
	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'Freight_Class', lsTemp)
	End If			

	//Storage Code	C(10)	No	N/A	Storage Code

	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col34"))
	
	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'storage_code', lsTemp)
	End If			
	
	//Inventory Class	C(10)	No	N/A	Inventory Class

	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col35"))
	
	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'inventory_class', lsTemp)
	End If			
	
	//Alternate SKU	C(50)	No	N/A	Alternate/Customer SKU

	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col36"))
	
	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'Alternate_SKU', lsTemp)
	End If				
	
	//COO	C(3)	No	N/A	Default Country of Origin
	//Validate COO if present, otherwise Default to XXX

	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col37"))
	
	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then

		If f_get_Country_name(lsTemp) <= ' ' Then
			gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Invalid Country of Origin: '" + lsTemp + "'. Record will not be processed.")
			lbError = True
			Continue /*Process Next Record */
		Else		
			ldsItem.SetItem(1,'Country_of_Origin_Default', lsTemp)
		End If
		
	Else
		//Set Default to 'XXX'
		ldsItem.SetItem(1,'Country_of_Origin_Default', 'XXX')   
	End If				

	
	//Shelf Life	N(5)	No	N/A	Shelf life in Days

	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col38"))
	
	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'Shelf_Life', Dec(lsTemp))
	End If			
	
	//Inventory Tracking field 1 (Lot) Controlled	C(1)	No	N/A	Inventory Tracking field 1 (Lot) Controlled Indicator

	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col39"))

	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'Lot_Controlled_Ind', lsTemp)
	End If		
	
	//Inventory Tracking field 2 (PO) Controlled	C(1)	No	N/A	Inventory Tracking field 2 (PO) Controlled Indicator

	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col40"))

	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'PO_Controlled_Ind', lsTemp)
	End If			
	
	//Inventory Tracking field 3 (PO2) Controlled	C(1)	No	N/A	Inventory Tracking field 3 (PO2) Controlled Indicator

	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col41"))
	
	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'PO_NO2_Controlled_Ind', lsTemp)
	End If			
	
	//Serialized Indicator	C(1)	No	N/A	Serialized Indicator
		//N = not serialized
		//B	 = capture serial # at receipt and when shipped but don’t track in inventory
		//O = capture serial # only when shipped
		//Y	 = capture serial # at receipt, track in inventory and when shipped
	
	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col42"))
	
	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'Serialized_Ind', lsTemp)
	End If			

	//Expiration Date Controlled	C(1)	No	N/A	Expiration Date Controlled indicator
	
	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col43"))
	
	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'expiration_controlled_ind', lsTemp)
	End If		
	
	//Container Tracking Indicator	C(1)	No	N/A	Container Tracking Indicator

	
	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col44"))
	
	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'container_tracking_ind', lsTemp)
	End If	
	
	//Delete Flag	C(1)	No	“N”	Flag for record deletion
	
	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col45"))

	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'Item_Delete_Ind', lsTemp)
	End If		

	
	//Native Description	C(75)	No	N/A	Foreign language Description

	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col46"))

	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'Native_Description', lsTemp)
	End If		

	//Handle User Fields

	//User Field1	C(10)	No	N/A	User Field
	//User Field2	C(10)	No	N/A	User Field
	//User Field3	C(10)	No	N/A	User Field
	//User Field4	C(10)	No	N/A	User Field
	//User Field5	C(10)	No	N/A	User Field
	//User Field6	C(20)	No	N/A	User Field
	//User Field7	C(20)	No	N/A	User Field
	//User Field8	C(30)	No	N/A	User Field
	//User Field9	C(30)	No	N/A	User Field
	//User Field10	C(30)	No	N/A	User Field
	//User Field11	C(30)	No	N/A	User Field
	//User Field12	C(30)	No	N/A	User Field
	//User Field13	C(30)	No	N/A	User Field
	//User Field14	C(70)	No	N/A	User Field
	//User Field15	C(70)	No	N/A	User Field
	//User Field16	C(70)	No	N/A	User Field
	//User Field17	C(70)	No	N/A	User Field
	//User Field18	C(70)	No	N/A	User Field
	//User Field19	C(70)	No	N/A	User Field
	//User Field20	C(70)	No	N/A	User Field
	
	uf_process_userfields(47, 20, ldsImport, llFileRowPos, ldsItem, 1)	
	
	ldsItem.SetItem(1,'Standard_of_measure','E')
	ldsItem.SetItem(1,'Last_user','SIMSFP')
	ldsItem.SetItem(1,'last_update',today())	
	
	//GailM 1/14/2020 DE14161 Riverbed IM files failed at sweeper - create time not being set by column default - force to today() if new
	If lbNew Then
		ldsItem.SetItem(1,'create_time',today())
	End If
	
//Note: 
//
//1.	If delete flag is set for “Y”, the item will not be available for further transactions.
//2.	If delete flag is set for “Y” and no warehouse transaction exist, the record will be physically deleted from database.

	//Save New Item to DB
	SQLCA.DBParm = "disablebind =0"
	lirc = ldsItem.Update()
	SQLCA.DBParm = "disablebind =1"
	
	If liRC = 1 then
		Commit;
	Else
		Rollback;
		lsLogOut = Space(17) + "- ***System Error!  Unable to Save new Item Master Record(s) to database!"
		FileWrite(gilogFileNo,lsLogOut)
		gu_nvo_process_files.uf_writeError("- ***System Error!  Unable to Save new Item Master Record to database!")
		Return -1
		Continue
	End If

Next /*File row to Process */

w_main.SetMicroHelp("")

lsLogOut = Space(10) + String(llNew) + ' Item Records were successfully added and ' + String(llExist) + ' Records were updated.'
FileWrite(gilogFileNo,lsLogOut)

Destroy ldsItem

If lbError then
	Return -1
Else
	Return 0
End If

Return 0
end function

public function integer uf_process_purchase_order (string aspath, string asproject);
//Process Purchase Order (PM) Transaction for Baseline Unicode Client

STRING lsTemp, lsProject, lsSku, lsSupplier, lsWarehouse, lsOrderNumber, lsOrderType
BOOLEAN lbError, lbNew, lbDetailError
LONG llCount, llNew, llOwner, llexist, llOrderSeq, llLineSeq, llbatchseq, llLineItemNo
INTEGER lirc, liRtnImp, liNewRow, llNewDetailRow
STRING lsLogOut, lsChangeID
INTEGER li_StartCol
INTEGER li_UFIdx
DECIMAL ldQuantity
STRING lsNull
DATETIME ldtWHTime

SetNull(lsNull)

u_ds_datastore	ldsPOHeader,	&
				     ldsPODetail, &
					 ldsImport

ldsPOheader = Create u_ds_datastore
ldsPOheader.dataobject= 'd_baseline_unicode_po_header'
ldsPOheader.SetTransObject(SQLCA)

ldsPOdetail = Create u_ds_datastore
ldsPOdetail.dataobject= 'd_baseline_unicode_po_detail'
ldsPOdetail.SetTransObject(SQLCA)

ldsImport = Create u_ds_datastore
ldsImport.dataobject = 'd_baseline_unicode_generic_import'

//Open and read the File In
lsLogOut = '      - Opening Purchase Order File: ' + asPath
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

//Bring in File
liRtnImp =  ldsImport.ImportFile( Text!, aspath) 

if liRtnImp < 0 then
	lsLogOut = "-       ***Unable to Open Purchase Order File for "+asproject+" Processing: " + asPath + " Import Error: " + string(liRtnImp)
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
end if

integer llFileRowPos
integer llFilerowCount

llFilerowCount = ldsImport.RowCount()

//Get the next available file sequence number
llBAtchSeq = gu_nvo_process_files.uf_get_next_seq_no(asProject,'EDI_Inbound_Header','EDI_Batch_Seq_No')
If llBatchSeq <= 0 Then Return -1

//Loop through

for llFileRowPos = 1 to llFilerowCount

	w_main.SetMicroHelp("Processing Purchase Order Record " + String(llFileRowPos) + " of " + String(llFilerowCount))


	//Field Name	Type	Req.	Default	Description
	//Record_ID	C(2)	Yes	“PM”	Purchase order master identifier
	//Record ID	C(2)	Yes	“PD”	Purchase order detail identifier

	//Validate Rec Type is PM OR PD
	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col1"))
	If NOT (lsTemp = 'PM' OR lsTemp = 'PD') Then
		gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Invalid Record Type: '" + lsTemp + "'. Record will not be processed.")
		lbError = True
		//Continue /*Process Next Record */
	End If
	
	IF IsNull(lsTemp) OR lsTemp ="EOF" Then continue //21-Dec-2018 :Madhu Don't process empty rows

	Choose Case Upper(lsTemp)
	
		//Purchase Order Master
	
		Case 'PM' /*PO Header*/

			//Change ID	C(1)	Yes	N/A	
				//A – Add
				//U – Update
				//D – Delete
				//X – Ignore (Add or update regardless)
				
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col2"))

			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
				gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Change ID is required. Record will not be processed.")
				lbError = True
				Continue		
			Else
				lsChangeID = lsTemp
			End If		
			
			//Project ID	C(10)	Yes	N/A	Project identifier

			lsTemp = Upper(Trim(ldsImport.GetItemString(llFileRowPos, "col3")))
			
			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
				gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Project is required. Record will not be processed.")
				lbError = True
				Continue		
			Else
				lsProject = lsTemp
			End If					
				
				
			//Warehouse	C(10)	Yes	N/A	Receiving Warehouse

			lsTemp = Upper(Trim(ldsImport.GetItemString(llFileRowPos, "col4")))
			
			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
				gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Warehouse is required. Record will not be processed.")
				lbError = True
				Continue		
			Else
				lsWarehouse = lsTemp
			End If					
							
			
			//Order Number	C(30)	Yes	N/A	Purchase order number
			
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col5"))
			
			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
				gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Order Number is required. Record will not be processed.")
				lbError = True
				Continue		
			Else
				lsOrderNumber = lsTemp
			End If					
				
				
			//Order Type	C(1)	Yes	“S”	Must be valid order typr
			
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col6"))
			
			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
				lsTemp = "S"	
			Else
				lsOrderType = lsTemp
			End If					
				
				
			//Supplier Code	C(20)	Yes	N/A	Valid Supplier code

			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col7"))
			
			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
				gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Supplier Code is required. Record will not be processed.")
				lbError = True
				Continue		
			Else
				lsSupplier = lsTemp
			End If			

			/* End Required */		
			
			liNewRow = 	ldsPOheader.InsertRow(0)
			llOrderSeq ++
			llLineSeq = 0
			
			//New Record Defaults
			ldsPOheader.SetItem(liNewRow,'project_id',lsProject)
			ldsPOheader.SetItem(liNewRow,'wh_code',lsWarehouse)
			ldsPOheader.SetItem(liNewRow,'Request_date',String(Today(),'YYMMDD'))
			ldsPOheader.SetItem(liNewRow,'edi_batch_seq_no',llbatchseq) /*batch seq No*/
			ldsPOheader.SetItem(liNewRow,'order_seq_no',llOrderSeq) 
			ldsPOheader.SetItem(liNewRow,'ftp_file_name',asPath) /*FTP File Name*/
			ldsPOheader.SetItem(liNewRow,'Status_cd','N')
			ldsPOheader.SetItem(liNewRow,'Last_user','SIMSEDI')

			ldsPOheader.SetItem(liNewRow,'Order_No',lsOrderNumber)			
			ldsPOheader.SetItem(liNewRow,'Order_type',lsOrderType) /*Order Typer*/
			ldsPOheader.SetItem(liNewRow,'Inventory_Type','N') /*default to Normal*/
	
	
			ldsPOheader.SetItem(liNewRow,'action_cd',lsChangeID) /*Supplier Order*/	

			ldsPOheader.SetItem(liNewRow,'Supp_Code',lsSupplier) /*Supplier Code*/	
			

				
			//Order Date	Date	No	N/A	Order Date
			
//			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col8"))
	
//			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
//				ldsPOheader.SetItem(liNewRow,'Ord_Date', lsTemp)
//			End If	
			 // 4/2010  - now setting ord_date to local wh time
			ldtWHTime = f_getLocalWorldTime(lsWarehouse)
			ldsPOheader.SetItem(liNewRow, 'ord_date', string(ldtWHTime, 'mm-dd-yyyy hh:mm'))
			
			//Delivery Date	Date	No	N/A	Expected Delivery Date at Warehouse

			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col9"))
	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsPOheader.SetItem(liNewRow,'arrival_date', lsTemp)
			End If	

			
			//Carrier	C(10)	No	N/A	Carrier
			
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col10"))
	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsPOheader.SetItem(liNewRow,'Carrier',  lsTemp)
			End If				
			
			//Supplier Invoice Number	C(30)	No	N/A	Supplier Invoice Number
			
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col11"))
	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsPOheader.SetItem(liNewRow,'Supp_Order_No', lsTemp)
			End If				
			
			//AWB #	C(20)	No	N?A	Airway Bill/Tracking Number
			
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col12"))
	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsPOheader.SetItem(liNewRow,'AWB_BOL_No', lsTemp)
			End If				
			
			//Transport Mode	C(10)	No	N/A	Transportation mode to warehouse
			
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col13"))
	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsPOheader.SetItem(liNewRow,'Transport_Mode', lsTemp)
			End If				
			
			//Remarks	C(250)	No	N/A	Freeform Remarks

			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col14"))
	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsPOheader.SetItem(liNewRow,'Remark', lsTemp)
			End If	

			//User Field1	C(10)	No	N/A	User Field
			//User Field2	C(10)	No	N/A	User Field
			//User Field3	C(10)	No	N/A	User Field
			//User Field4	C(20)	No	N/A	User Field
			//User Field5	C(20)	No	N/A	User Field
			//User Field6	C(20)	No	N/A	User Field
			//User Field7	C(30)	No	N/A	User Field
			//User Field8	C(30)	No	N/A	User Field
			//User Field9	C(255)	No	N/A	User Field
			//User Field10	C(255)	No	N/A	User Field
			//User Field11	C(255)	No	N/A	User Field
			//User Field12	C(255)	No	N/A	User Field
			//User Field13	C(255)	No	N/A	User Field
			//User Field14	C(255)	No	N/A	User Field, not viewable on screen
			//User Field15	C(255)	No	N/A	User Field, not viewable on screen
			//

			uf_process_userfields(15, 15, ldsImport, llFileRowPos, ldsPOheader, liNewRow)	

				
	
			//Note: 
			//
			//1.	A PO can only be deleted if no receipts have been generated against the PO.
			//2.	Deletion of a Purchase Order Master will also delete related purchase order details.
			//3.	Updated PO’s should include all of the information for the PO regardless of whether or not a specific item has been changed.
						
						

		//Purchase Order Detail				
				
		CASE 'PD' /* detail*/

			//Change ID	C(1)	Yes	N/A	
				//A – Add
				//U – Update
				//D – Delete

			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col2"))

			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
				gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Change ID is required. Record will not be processed.")
				lbError = True
				Continue		
			Else
				lsChangeID = lsTemp
			End If		
			
			//Project ID	C(10)	Yes	N/A	Project identifier
			
			lsTemp = Upper(Trim(ldsImport.GetItemString(llFileRowPos, "col3")))
			
			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
				gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Project is required. Record will not be processed.")
				lbError = True
				Continue		
			Else
				lsProject = lsTemp
			End If									

			//Order Number	C(30)	Yes	N/A	Purchase order number

			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col4"))
			
			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
				gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Order Number is required. Record will not be processed.")
				lbError = True
				Continue		
			Else
				
			
				//Make sure we have a header for this Detail...
				If ldsPoHeader.Find("Upper(order_no) = '" + Upper(lstemp) + "'",1, ldsPoHeader.RowCount()) = 0 Then
					gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Detail Order Number does not match header ORder Number. Record will not be processed.")
					lbDetailError = True
				End If
					
				lsOrderNumber = lsTemp
			End If			

				
			//Supplier Code	C(20)	Yes	N/A	Valid Supplier code

			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col5"))
			
			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
				gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Supplier Code is required. Record will not be processed.")
				lbError = True
				Continue		
			Else
				lsSupplier = lsTemp
			End If			
				
			
			//Line Item Number	N(6,0)	Yes	N/A	Item number of purchase order document

			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col6"))
			
			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
				gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Line Item Number is required. Record will not be processed.")
				lbError = True
				Continue		
			Else
				llLineItemNo = Long(lsTemp)
			End If					
			
			//SKU	C(26)	Yes	N/A	Material number
			
			
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col7"))
			
			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
				gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Sku is required. Record will not be processed.")
				lbError = True
				Continue		
			Else
				lsSku = lsTemp
			End If				
			
			//Quantity	N(15,5)	Yes	N/A	Purchase order quantity


			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col8"))
			
			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
				gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Quantity is required. Record will not be processed.")
				lbError = True
				Continue		
			Else
				ldQuantity = Dec(lsTemp)
			End If			
		
			/* End Required */
		
		
			lbDetailError = False
			llNewDetailRow = 	ldsPODetail.InsertRow(0)
			llLineSeq ++
					
			//Add detail level defaults
			ldsPODetail.SetItem(llNewDetailRow,'order_seq_no',llOrderSeq) 
			ldsPODetail.SetItem(llNewDetailRow,'project_id', lsProject) /*project*/
			ldsPODetail.SetItem(llNewDetailRow,'status_cd', 'N') 
			ldsPODetail.SetItem(llNewDetailRow,'Inventory_Type', 'N') 
			ldsPODetail.SetItem(llNewDetailRow,'edi_batch_seq_no',llbatchseq) /*batch seq No*/
			ldsPODetail.SetItem(llNewDetailRow,"order_line_no",string(llLineSeq))
			
			ldsPODetail.SetItem(llNewDetailRow,'Order_No',lsOrderNumber)			
			ldsPODetail.SetItem(llNewDetailRow,'action_cd',lsChangeID) /*Supplier Order*/	

			ldsPODetail.SetItem(llNewDetailRow,'sku',lsSku) /*Sku*/	
			ldsPODetail.SetItem(llNewDetailRow,'Supp_Code',lsSupplier) /*Supplier Code*/	
			ldsPODetail.SetItem(llNewDetailRow,'Line_Item_No',llLineItemNo) /*Line_Item_No*/	
			ldsPODetail.SetItem(llNewDetailRow,'Quantity', String(ldQuantity)) /*Quantity*/				
			//TAM  2011/12/07 - Default PO_NO to "GENERIC" on receive orders.  If Riverbed sends a delivery invoice number then we must reserve this inventory for a specific DO_NO.  To do this we will put the Delivery invoice number into the PO_NO in inventory.
			// If there is no Delivery Invoice Number then we will default PO_NO to "GENERIC".  We will then require Inventory to be picked by PO_NO on the delivery order.
			ldsPODetail.SetItem(llNewDetailRow,'PO_NO', 'GENERIC') 
			
			
			//Inventory Type	C(1)	No	N/A	Inventory Type
			
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col9"))
	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsPODetail.SetItem(llNewDetailRow,'Inventory_Type', lsTemp)
			End If	
			
			//Alternate SKU	C(50)	No	N/A	Supplier’s material number
			
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col10"))
	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsPODetail.SetItem(llNewDetailRow,'Alternate_Sku', lsTemp)
			Else
				ldsPODetail.SetItem(llNewDetailRow,'Alternate_Sku', lsNull)
			End If	
			
			//Lot Number	C(50)	No	N/A	1st User Defined Inventory field
			
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col11"))
	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsPODetail.SetItem(llNewDetailRow,'Lot_No', lsTemp)
			End If				
			
			//PO NBR	C(50)	No	N/A	2nd User Defined Inventory field
			
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col12"))
	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsPODetail.SetItem(llNewDetailRow,'PO_No', lsTemp)
			End If	
			
			//PO NBR 2	C(50)	No	N/A	3rd User Defined Inventory Field
			
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col13"))
	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsPODetail.SetItem(llNewDetailRow,'PO_No2', lsTemp)
			End If	
			
			//Serial Number	C(50)	No	N/A	Qty must be 1 if present

			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col14"))
	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsPODetail.SetItem(llNewDetailRow,'Serial_No', lsTemp)
			End If	
			
			//Expiration Date	Date	No	N/A	Product expiration Date
			
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col15"))
	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsPODetail.SetItem(llNewDetailRow,'Expiration_Date', datetime(lsTemp))
			End If				
			
			//Customer  Line Item Number 	C(25)	No	N/A	Customer  Line Item Number
			//05-Dec-2018 :Madhu S26847 changed from Line_Item_No to User_Line_Item_No
			
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col16"))
	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsPODetail.SetItem(llNewDetailRow,'User_Line_Item_No', lsTemp)
			End If			
			

		
			//User Field1	C(50)	No	N/A	User Field
			//User Field2	C(50)	No	N/A	User Field
			//User Field3	C(50)	No	N/A	User Field
			//User Field4	C(50)	No	N/A	User Field
			//User Field5	C(50)	No	N/A	User Field
			//User Field6	C(50)	No	N/A	User Field
			
			uf_process_userfields(17, 6, ldsImport, llFileRowPos, ldsPODetail, llNewDetailRow)	


				//
				//Note: 
				//
			
				
			//1.	PO item can only be deleted if there are no receipts for the line item.
			//2.	PO Qty can not be reduced below that which has already been received.
			//

			
		CASE Else /* Invalid Rec Type*/
		
			gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Invalid Record Type: '" + lsTemp + "'. Record will not be processed.")
			Continue
		
	End Choose /*record Type*/
	
Next /*File record */
	
	
//Save the Changes 



SQLCA.DBParm = "disablebind =0"
lirc = ldsPOHeader.Update()
	
If liRC = 1 Then
	liRC = ldsPODetail.Update()
End If
SQLCA.DBParm = "disablebind =1"	

If liRC = 1 then
	Commit;
Else
	
	Rollback;
	lsLogOut = Space(17) + "- ***System Error!  Unable to Save new PO Records to database!"
	FileWrite(gilogFileNo,lsLogOut)
	gu_nvo_process_files.uf_writeError("- ***System Error!  Unable to Save new PO Records to database!")
	Return -1
End If

If lbError Then
	Return -1
Else
	Return 0
End If

end function

public function integer uf_process_userfields (integer al_startimportcolumnnumber, integer al_totaluserfields, ref datastore adw_importdw, integer adw_importdwcurrentrow, ref datastore adw_destdw, integer adw_destdwcurrentrow);
integer li_StartCol, li_UFIdx
string lsTemp	

	
 li_StartCol = al_StartImportColumnNumber

//Handle User Fields

For li_UFIdx = 1 to al_TotalUserFields

	lsTemp = Trim(adw_ImportDW.GetItemString(adw_ImportDWCurrentRow, "col" + string(li_StartCol)))

//	Messagebox ("ok", lsTemp)

	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		adw_DestDW.SetItem(adw_DestDWCurrentRow,'User_Field' + string(li_UFIdx), lsTemp)
	End If		

	li_StartCol = li_StartCol + 1
	
Next

RETURN 0
end function

public function integer uf_process_delivery_order (string aspath, string asproject);


//Process Sales Order (DM) Transaction for Baseline Unicode Client

STRING lsTemp, lsProject, lsSku, lsSupplier, lsWarehouse, lsOrderType, lsInvoiceNumber, lsDtlInvoice, lsuf12
BOOLEAN lbError, lbNew, lbDetailError
LONG llCount, llNew, llOwner, llexist, llOrderSeq, llLineSeq, llbatchseq, llLineItemNo, llNewAddressRow,llcontentcount
INTEGER lirc, liRtnImp, liNewRow, llNewDetailRow
STRING lsLogOut, lsChangeID
INTEGER li_StartCol
INTEGER li_UFIdx
DECIMAL ldQuantity
STRING lsCustomerCode
STRING ls_OrderDate, ls_DeliveryDate, ls_GI_Date
BOOLEAN lbBillToAddress
STRING lsBillToAddr1, lsBillToAddr2, lsBillToAddr3, lsBillToAddr4, lsBillToCity
STRING	lsBillToState, lsBillToZip, lsBillToCountry, lsBillToTel, lsBillToName
BOOLEAN lb3PAddress
STRING ls3PAddr1, ls3PAddr2, ls3PAddr3, ls3PAddr4, ls3PCity
STRING	ls3PState, ls3PZip, ls3PCountry, ls3PTel, ls3PName
STRING ls_InventoryType
DATETIME ldtWHTime
decimal ldChildQty
String	lsChildSku, lsParentID, lsParentIdSave
Boolean	lbBOM
Long	llNewBOMRow		
 
				

u_ds_datastore 	ldsSOheader,	&
				ldsSOdetail, &
				ldsDOAddress, &
				ldsDOBOM
				
u_ds_datastore ldsImport

//DateTime	ldtToday

//ldtToday = DateTime(Today(),Now())

ldsSOheader = Create u_ds_datastore
ldsSOheader.dataobject= 'd_baseline_unicode_shp_header'
ldsSOheader.SetTransObject(SQLCA)

ldsSOdetail = Create u_ds_datastore
ldsSOdetail.dataobject= 'd_baseline_unicode_shp_detail'
ldsSOdetail.SetTransObject(SQLCA)

ldsDOAddress = Create u_ds_datastore
ldsDOAddress.dataobject = 'd_baseline_unicode_do_address'
ldsDOAddress.SetTransObject(SQLCA)

ldsDOBOM = Create u_ds_datastore
ldsDOBOM.dataobject = 'd_delivery_bom'
ldsDOBOM.SetTransObject(SQLCA)

ldsImport = Create u_ds_datastore
ldsImport.dataobject = 'd_baseline_unicode_generic_import'

//Open and read the File In
lsLogOut = '      - Opening Sales Order File: ' + asPath
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

//Bring in File
liRtnImp =  ldsImport.ImportFile( Text!, aspath) 

if liRtnImp < 0 then
	lsLogOut = "-       ***Unable to Open Sales Order File for "+asproject+" Processing: " + asPath + " Import Error: " + string(liRtnImp)
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
	Return -1 //25-APR-2019 :Madhu DE10154 Don't continue the process
end if

integer llFileRowPos
integer llFilerowCount

llFilerowCount = ldsImport.RowCount()

//Get the next available file sequence number
// 03/09 llBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asProject, 'EDI_Outbound_Header', 'EDI_Batch_Seq_No')
// 03/09 -  using edi_INbound_header because web does and it will crash when trying to re-use a sequence number
llBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asProject, 'EDI_Inbound_Header', 'EDI_Batch_Seq_No')
If llBatchSeq <= 0 Then Return -1

llBAtchSeq = gu_nvo_process_files.uf_get_next_seq_no(asProject,'EDI_Inbound_Header','EDI_Batch_Seq_No')
If llBatchSeq <= 0 Then Return -1

//Loop through

//
//Delivery Order Master
//

//
//* - Either the Delivery Date or the Goods issue Date is required. If neither is present, the order drop date will be the default ship date.
//
//



for llFileRowPos = 1 to llFilerowCount

	w_main.SetMicroHelp("Processing Sales Order Record " + String(llFileRowPos) + " of " + String(llFilerowCount))


	//Field Name	Type	Req.	Default	Description
	//Record ID	C(2)	Yes	“DM”	Delivery order master identifier
	//Record ID	C(2)	Yes	“DD”	Delivery order detail identifier

	//Validate Rec Type is PM OR PD
	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col1"))
	If NOT (lsTemp = 'DM' OR lsTemp = 'DD') Then
		gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Invalid Record Type: '" + lsTemp + "'. Record will not be processed.")
		lbError = True
		//Continue /*Process Next Record */
	End If

	Choose Case Upper(lsTemp)
	
		//Purchase Order Master
	
		//HEADER RECORD
		Case 'DM' /* Header */


			//Change ID	C(1)	Yes	N/A	
				//A – Add
				//U – Update
				//D – Delete
				//X – Ignore (Add or update regardless)
				
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col2"))

			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
				gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Change ID is required. Record will not be processed.")
				lbError = True
				Continue		
			Else
				lsChangeID = lsTemp
			End If					

			//Project ID	C(10)	Yes	N/A	Project identifier
			
			lsTemp = Upper(Trim(ldsImport.GetItemString(llFileRowPos, "col3")))
			
			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
				gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Project is required. Record will not be processed.")
				lbError = True
				Continue		
			Else
				lsProject = lsTemp
			End If					
				
				
			//Warehouse	C(10)	Yes	N/A	Receiving Warehouse

			lsTemp = Upper(Trim(ldsImport.GetItemString(llFileRowPos, "col4")))
			
			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
				gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Warehouse is required. Record will not be processed.")
				lbError = True
				Continue		
			Else
				lsWarehouse = lsTemp
			End If					
							
			
			//Delivery Number	C(20)	Yes	N/A	Delivery Order Number  

			
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col5"))
			
			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
				gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Order Number is required. Record will not be processed.")
				lbError = True
				Continue		
			Else


			//Old -----Invoice Number	 is a concatination of Column 5 "Order Number" and Column 47 "OrderNo-UF9"
			//New----Invoice Number	is a concatination of Column 5 "Order Number" and The first hyphen"-" found + the first number after the hyphen of Column 50 "OrderNo-UF12"
				lsInvoiceNumber = lsTemp 
//				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col47"))
				lstemp = Trim(ldsImport.GetItemString(llFileRowPos, "col50"))
//TAM 2012/03/27 We need all the digits between the the 1st and 2nd hyphen.  Not just the 1 digit.
//				lsuf12 = mid(lstemp,POS(lsTemp, "-"),2) 
				long	lihyphen1, lihyphen2
				lihyphen1 = POS(lsTemp, "-")
				lihyphen2 = POS(lsTemp, "-", lihyphen1+1)
				If lihyphen2 > lihyphen1 then
					lsuf12 = mid(lstemp,POS(lsTemp, "-"),lihyphen2 - lihyphen1) 
				Else
					lsuf12 = mid(lstemp,POS(lsTemp, "-")) 
				End If

				If IsNull(lsuf12) OR trim(lsuf12) = '' Then
				Else
					lsInvoiceNumber = lsinvoiceNumber + lsuf12
				End If			
			End If	
							
			//Order Date	Date	No	N/A	Order Date
			
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col6"))
			
			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
			Else
				ls_OrderDate = lsTemp
			End If				
			
			
			//Delivery Date	Date	No*	*	Date for delivery to Customer

			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col7"))
			
			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
			Else
				ls_DeliveryDate = lsTemp
			End If				
			
			//GI Date	Date	No*	*	Planned goods ship date from warehouse
			
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col8"))
			
			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
			Else
				ls_GI_Date = lsTemp
			End If				
			
			
			//Customer Code	C(20)	Yes	N/A	Customer ID
		
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col9"))
			
			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
				gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Customer Code is required. Record will not be processed.")
				lbError = True
				Continue		
			Else
				lsCustomerCode = lsTemp
			End If		


			/* End Required */		

			
			
			liNewRow = 	ldsSOheader.InsertRow(0)
			llOrderSeq ++
			llLineSeq = 0			
			
			//New Record Defaults
			ldsSOheader.SetItem(liNewRow,'project_id',lsProject)
			ldsSOheader.SetItem(liNewRow,'wh_code',lsWarehouse)
//			ldsSOheader.SetItem(liNewRow,'Request_date',String(Today(),'YYMMDD'))
			ldsSOheader.SetItem(liNewRow,'edi_batch_seq_no',llbatchseq) /*batch seq No*/
			ldsSOheader.SetItem(liNewRow,'order_seq_no',llOrderSeq) 
			ldsSOheader.SetItem(liNewRow,'ftp_file_name',asPath) /*FTP File Name*/
			ldsSOheader.SetItem(liNewRow,'status_cd','N')
			ldsSOheader.SetItem(liNewRow,'Last_user','SIMSEDI')

			ldsSOheader.SetItem(liNewRow,'invoice_no',lsInvoiceNumber)			

//			ldsSOheader.SetItem(liNewRow,'Inventory_Type','N') /*default to Normal*/

			ldsSOheader.SetItem(liNewRow,'cust_code',lsCustomerCode) /*Order Type*/
	
	
			ldsSOheader.SetItem(liNewRow,'action_cd',lsChangeID) /*Supplier Order*/	

//			1.	Map Delivery Date on DM to “Delivery Date” in SIMS
//			2.	Map GI Date on DM to “Schedule Date” in SIMS
//			
			
				 // 4/2010  - now setting ord_date to local wh time
			ldtWHTime = f_getLocalWorldTime(lsWarehouse)
			ldsSOheader.SetItem(liNewRow, 'ord_date', string(ldtWHTime, 'mm-dd-yyyy hh:mm'))
// 			ldsSOheader.SetItem(liNewRow,'ord_date',ls_OrderDate)
			ldsSOheader.SetItem(liNewRow,'delivery_date',ls_DeliveryDate)
			ldsSOheader.SetItem(liNewRow,'schedule_date',ls_GI_Date)
		
			//Order Type	C(1)	No	N/A	Order Type
			
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col10"))
			
			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
				lsTemp = "S"	
			Else
				lsOrderType = lsTemp
				
				ldsSOheader.SetItem(liNewRow,'Order_type',lsOrderType) /*Order Type*/	
								
			End If					
				
				
			//Customer Order #	C(20)	No	N/A	Customer Order Number
			
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col11"))
	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsSOheader.SetItem(liNewRow,'order_no', lsTemp)
			End If		
						
			
			//Carrier	C(20)	No	N/A			
			
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col12"))
	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsSOheader.SetItem(liNewRow,'carrier', lsTemp)
			End If		
			
		
			
			//Transport Mode	C10)	No	N/A	
			
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col13"))
	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsSOheader.SetItem(liNewRow,'transport_mode', lsTemp)
			End If		
			
			//Ship Via	C(15)	No	N/A	

			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col14"))
	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsSOheader.SetItem(liNewRow,'ship_via', lsTemp)
			End If				
			
			//Freight Terms	C(20)	No	N/A	

			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col15"))
	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsSOheader.SetItem(liNewRow,'freight_terms', lsTemp)
			End If			
			
			//Agent Info	C(30)	No	N/A	
			
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col16"))
	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsSOheader.SetItem(liNewRow,'agent_info', lsTemp)
			End If				
			
			
			//If we have Ship to information, we will need to build an 3rd party Alt Address record
		 	lb3PAddress = False		
			//Ship To Name	C(50)	No	N/A	
			
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col17"))
	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsSOheader.SetItem(liNewRow,'cust_name', lsTemp)
				lb3PAddress = True
				ls3PName = Trim(lsTemp)
			ELSE
				ls3PName = ''
			End If				

				
			
			//Ship Address 1	C(60)	No	N/A	
			
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col18"))
	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsSOheader.SetItem(liNewRow,'address_1', lsTemp)
				lb3PAddress = True
				ls3PAddr1 = Trim(lsTemp)
			ELSE
				ls3PAddr1 = ''
			End If			
			
			//Ship Address 2	C(60)	No	N/A	
			
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col19"))
	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsSOheader.SetItem(liNewRow,'address_2', lsTemp)
				lb3PAddress = True
				ls3PAddr2 = Trim(lsTemp)
			ELSE
				ls3PAddr2 = ''
			End If			
			
			//Ship Address 3	C(60)	No	N/A	
	
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col20"))
	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsSOheader.SetItem(liNewRow,'address_3', lsTemp)
				lb3PAddress = True
				ls3PAddr3 = Trim(lsTemp)
			ELSE
				ls3PAddr3 = ''
			End If	
			
			//Ship Address 4	C6)	No	N/A	
			
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col21"))
	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsSOheader.SetItem(liNewRow,'address_4', lsTemp)
				lb3PAddress = True
				ls3PAddr4 = Trim(lsTemp)
			ELSE
				ls3PAddr4 = ''
			End If				
			
			//Ship City	C(50)	No	N/A	
			
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col22"))
	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsSOheader.SetItem(liNewRow,'city', lsTemp)
				lb3PAddress = True
				ls3PCity = Trim(lsTemp)
			ELSE
				ls3PCity = ''
			End If			
			
			//Ship State	C(50)	No	N/A
			
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col23"))
	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsSOheader.SetItem(liNewRow,'state', lsTemp)
				lb3PAddress = True
				ls3PState = Trim(lsTemp)
			ELSE
				ls3PState = ''
			End If				
			
			//Ship Postal Code	C(50)	No	N/A	
			
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col24"))
	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsSOheader.SetItem(liNewRow,'zip', lsTemp)
				lb3PAddress = True
				ls3PZip = Trim(lsTemp)
			ELSE
				ls3PZip = ''
			End If				
			
			//Ship Country	C(50)	No	N/A	
			
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col25"))
	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsSOheader.SetItem(liNewRow,'country', lsTemp)
				lb3PAddress = True
				ls3PCountry = Trim(lsTemp)
			ELSE
				ls3PCountry = ''
			End If				
			
			//Ship Tel	C(20)	No	N/A	
			
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col26"))
	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsSOheader.SetItem(liNewRow,'tel', lsTemp)
				lb3PAddress = True
				ls3PTel = Trim(lsTemp)
			ELSE
				ls3PTel = ''
			End If				


			//If we have Bill to information, we will need to build an Alt Address record
		 	lbBillToAddress = False		
				
			//Bill To Name	C(50)	No	N/A	
			
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col27"))
	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				lbBillToAddress = True
				lsBillToName = Trim(lsTemp)
			ELSE
				lsBillToName = ''
			End If				
			
			//Bill Address 1	C(60)	No	N/A	
			
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col28"))
	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				lbBillToAddress = True
				lsBillToADdr1 = Trim(lsTemp)
			ELSE
				lsBillToADdr1 = ''
			End If				
			
			//Bill Address 2	C(60)	No	N/A	
			
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col29"))
	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				lbBillToAddress = True
				lsBillToADdr2 = Trim(lsTemp)
			ELSE
				lsBillToADdr2 = ''
			End If					
			
			//Bill Address 3	C(60)	No	N/A	
			
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col30"))
	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				lbBillToAddress = True
				lsBillToADdr3 = Trim(lsTemp)
			ELSE
				lsBillToADdr3 = ''
			End If					
			
			//Bill Address 4	C(60)	No	N/A	
			
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col31"))
	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				lbBillToAddress = True
				lsBillToADdr4 = Trim(lsTemp)
			ELSE
				lsBillToADdr4 = ''
			End If				
			
			
			//Bill City	C(50)	No	N/A	
			
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col32"))
	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				lbBillToAddress = True
				lsBillToCity = Trim(lsTemp)
			ELSE
				lsBillToCity = ''
			End If	
			
			//Bill State	C(50)	No	N/A	
			
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col33"))
	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				lbBillToAddress = True
				lsBillToState = Trim(lsTemp)
			ELSE
				lsBillToState = ''
			End If			
			
			//Bill Postal Code	C(50)	No	N/A
			
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col34"))
	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				lbBillToAddress = True
				lsBillToZip = Trim(lsTemp)
			ELSE
				lsBillToZip = ''
			End If				
			
			//Bill Country	C(50)	No	N/A
			
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col35"))
	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				lbBillToAddress = True
				lsBillToCountry = Trim(lsTemp)
			ELSE
				lsBillToCountry = ''
			End If			
			
			//Bill Tel	C(20)	No	N/A	
			
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col36"))
	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				lbBillToAddress = True
				lsBillToTel = Trim(lsTemp)
			ELSE
				lsBillToTel = ''
			End If				
			
			//Remarks	C(255)	No	N/A	
		
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col37"))
	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsSOheader.SetItem(liNewRow,'remark', lsTemp)
			End If		
			
			//Shipping Instructions	C(255)	No	N/A	
		
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col38"))
	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsSOheader.SetItem(liNewRow,'shipping_instructions_Text', lsTemp)
			End If			
			
			//Packlist Notes	C(255)	No	N/A
			
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col39"))
	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsSOheader.SetItem(liNewRow,'packlist_notes_Text', lsTemp)
			End If			
			
						
			//User Field2	C(10)	No	N/A	User Field
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col40"))
	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsSOheader.SetItem(liNewRow,'User_field2', lsTemp)
			End If			
			//User Field3	C(10)	No	N/A	User Field
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col41"))
	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsSOheader.SetItem(liNewRow,'User_field3', lsTemp)
			End If			
			//User Field4	C(20)	No	N/A	User Field
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col42"))
			
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsSOheader.SetItem(liNewRow,'User_field4', lsTemp)
//				// TAM 09/2012  Populate Freight Terms based on value in user_field4
//				Choose Case Upper(lsTemp)
//		 				Case 'SHIPPER'
//		 					ldsSOheader.SetItem(liNewRow,'Freight_Terms', 'PREPAID' )
//		 				Case 'RECIPIENT'
//			 				ldsSOheader.SetItem(liNewRow,'Freight_Terms', 'COLLECT' )
//						Case 'THIRD PARTY'
//							ldsSOheader.SetItem(liNewRow,'Freight_Terms', 'THIRDPARTY' )
//						Case else
//							ldsSOheader.SetItem(liNewRow,'Freight_Terms', 'PREPAID' )
//				End Choose
			End If			

						
			//User Field5	C(20)	No	N/A	User Field
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col43"))
	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsSOheader.SetItem(liNewRow,'User_field5', lsTemp)
			End If			

			//User Field6	C(20)	No	N/A	User Field
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col44"))
	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsSOheader.SetItem(liNewRow,'User_field6', lsTemp)
//				// TAM 09/2012  Populate Duty based on value in user_field6
//				Choose Case Upper(lsTemp)
//						Case 'SHIPPER'
//							ldsSOheader.SetItem(liNewRow,'Trax_Duty_Terms', 'SHIPPERDUTYVAT' )
//						Case 'RECIPIENT'
//							ldsSOheader.SetItem(liNewRow,'Trax_Duty_Terms', 'CONSIGNEEDUTYVAT' )
//						Case 'THIRD PARTY'
//							ldsSOheader.SetItem(liNewRow,'Trax_Duty_Terms', 'THIRDPARTYDUTYVAT' )
//						Case else
//							ldsSOheader.SetItem(liNewRow,'Trax_Duty_Terms', 'SHIPPERDUTYVAT' )
//				End Choose
			End If			

			
			//User Field7	C(30)	No	N/A	User Field
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col45"))
	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsSOheader.SetItem(liNewRow,'User_field7', lsTemp)
			End If			
			//User Field8	C(60)	No	N/A	User Field
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col46"))
	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsSOheader.SetItem(liNewRow,'User_field8', lsTemp)
			End If			
			//User Field9	C(30)	No	N/A	User Field
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col47"))
	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsSOheader.SetItem(liNewRow,'User_field9', lsTemp)
			End If			
			//User Field10	C(30)	No	N/A	User Field
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col48"))
	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsSOheader.SetItem(liNewRow,'User_field10', lsTemp)
			End If			
			//User Field11	C(30)	No	N/A	User Field
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col49"))
	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsSOheader.SetItem(liNewRow,'User_field11', lsTemp)
			End If			
			//User Field12	C(50)	No	N/A	User Field
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col50"))
	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsSOheader.SetItem(liNewRow,'User_field12', lsTemp)
			End If			
			//User Field13	C(50)	No	N/A	User Field
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col51"))
	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsSOheader.SetItem(liNewRow,'User_field13', lsTemp)
			End If			
			//User Field14	C(50)	No	N/A	User Field
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col52"))
	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsSOheader.SetItem(liNewRow,'User_field14', lsTemp)
			End If			
			//User Field15	C(50)	No	N/A	User Field
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col53"))
	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsSOheader.SetItem(liNewRow,'User_field15', lsTemp)
			End If			
			//User Field16	C(100)	No	N/A	User Field
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col54"))
	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsSOheader.SetItem(liNewRow,'User_field16', lsTemp)
			End If			
			//User Field17	C(100)	No	N/A	User Field
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col55"))
	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsSOheader.SetItem(liNewRow,'User_field17', lsTemp)
			End If			
			//User Field18	C(100)	No	N/A	User Field
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col56"))
	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsSOheader.SetItem(liNewRow,'User_field18', lsTemp)
			End If			
			
//			uf_process_userfields(40, 18, ldsImport, llFileRowPos, ldsSOheader, liNewRow)	

			//Ship To Contact	C(30)	No	N/A
			
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col57"))
	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsSOheader.SetItem(liNewRow,'contact_person', lsTemp)
			End If			
			
			//Ship To Email		C(50)	No	N/A
			
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col58"))
	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsSOheader.SetItem(liNewRow,'email_address', lsTemp)
			End If			
			
// TAM 2012/03/01 -  Load Trax Freight and Duty Terms from userfields
			uf_load_trax_terms(ldsImport, llFileRowPos, ldsSOheader, liNewRow)	
			
			
			//If we have Bill To Information, create the Alt Address record
			If lbBillToAddress Then
				
				llNewAddressRow = ldsDOAddress.InsertRow(0)
				ldsDOAddress.SetITem(llNewAddressRow,'project_id', lsProject) /*Project ID*/
				ldsDOAddress.SetItem(llNewAddressRow,'edi_batch_seq_no',llbatchseq) /*batch seq No*/
				ldsDOAddress.SetItem(llNewAddressRow,'order_seq_no',llOrderSeq) 
		
				ldsDOAddress.SetItem(llNewAddressRow,'address_type','BT') /* Bill To Address */
				ldsDOAddress.SetItem(llNewAddressRow,'Name',lsBillToName)
				ldsDOAddress.SetItem(llNewAddressRow,'address_1',lsBillToAddr1)
				ldsDOAddress.SetItem(llNewAddressRow,'address_2',lsBillToAddr2)
				ldsDOAddress.SetItem(llNewAddressRow,'address_3',lsBillToAddr3)
				ldsDOAddress.SetItem(llNewAddressRow,'address_4',lsBillToAddr4)
				ldsDOAddress.SetItem(llNewAddressRow,'City',lsBillToCity)
				ldsDOAddress.SetItem(llNewAddressRow,'State',lsBillToState)
				ldsDOAddress.SetItem(llNewAddressRow,'Zip',lsBillToZip)
				ldsDOAddress.SetItem(llNewAddressRow,'Country',lsBillToCountry)
				ldsDOAddress.SetItem(llNewAddressRow,'tel',lsBillToTel)
				
			End If /*alt address exists*/
								
//TAM 2012/07/13 Added 3rd Party Address using the shipto adress data
			//If we have Ship To Information, create the 3rd Party Alt Address record
			If lb3PAddress Then
				
				llNewAddressRow = ldsDOAddress.InsertRow(0)
				ldsDOAddress.SetITem(llNewAddressRow,'project_id', lsProject) /*Project ID*/
				ldsDOAddress.SetItem(llNewAddressRow,'edi_batch_seq_no',llbatchseq) /*batch seq No*/
				ldsDOAddress.SetItem(llNewAddressRow,'order_seq_no',llOrderSeq) 
		
				ldsDOAddress.SetItem(llNewAddressRow,'address_type','3P') /* Bill To Address */
				ldsDOAddress.SetItem(llNewAddressRow,'Name',ls3PName)
				ldsDOAddress.SetItem(llNewAddressRow,'address_1',ls3PAddr1)
				ldsDOAddress.SetItem(llNewAddressRow,'address_2',ls3PAddr2)
				ldsDOAddress.SetItem(llNewAddressRow,'address_3',ls3PAddr3)
				ldsDOAddress.SetItem(llNewAddressRow,'address_4',ls3PAddr4)
				ldsDOAddress.SetItem(llNewAddressRow,'City',ls3PCity)
				ldsDOAddress.SetItem(llNewAddressRow,'State',ls3PState)
				ldsDOAddress.SetItem(llNewAddressRow,'Zip',ls3PZip)
				ldsDOAddress.SetItem(llNewAddressRow,'Country',ls3PCountry)
				ldsDOAddress.SetItem(llNewAddressRow,'tel',ls3PTel)
				
			End If /*alt address exists*/
								
		// DETAIL RECORD

		Case 'DD' /*Detail */

//TAM 2013/06/13  If Line is a PTO then Skip it.  We don't keep this line. Riverbed just sends it and cannot filter it.
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col17"))
			If Left(lstemp, 40) = "PreConfigIdent:X;ItemTypeDescription:PTO" Then
			 Continue
			End If
//TAM 2013/07/03  If Line is an ATO then Skip it.  We don't keep this line. Riverbed just sends it and cannot filter it.
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col17"))
			If Left(lstemp, 40) = "PreConfigIdent:X;ItemTypeDescription:ATO" Then
			 Continue
			End If


		 	// If Item is has  the same Parent Id as the one saved then it is a BOM and we need to save a Delivery BOM below.
			lsParentID = Trim(ldsImport.GetItemString(llFileRowPos, "col18"))
			IF IsNull(lsParentID) then lsParentID = ''

			// If the Parent ID is the same and not blank Then check to see if all of the flags in the string below are set to 'N'.  If they are then we do not load this record.  (Riverbed Rule)
			If lsParentID = lsParentIdSave and lsParentId <> '' Then
				If POS(Trim(ldsImport.GetItemString(llFileRowPos, "col17")), "IsShippable:N;IsPrintPackingSlip:N;IsPrintCommercialInvoice:N;IsSerialPresent:N") > 0 or POS(Trim(ldsImport.GetItemString(llFileRowPos, "col17")), "IsShippable:N;IsPrintPackingSlip:N;IsPrintCommercialInvoice:Y;IsSerialPresent:N") > 0 Then
					Continue
				End If
			End If
				

			 // If Item is has  the same Parent Id as the one saved then it is a BOM and we need to save a Delivery BOM below.

			If lsParentID <> lsParentIdSave or lsParentId = '' Then
				lsParentIDSave = lsParentID
		
				//Delivery Order Detail


				//Change ID	C(1)	Yes	N/A	
					//A – Add
					//U – Update
					//D – Delete

				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col2"))

				If IsNull(lsTemp) OR trim(lsTemp) = '' Then
					gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Change ID is required. Record will not be processed.")
					lbError = True
					Continue		
				Else
					lsChangeID = lsTemp
				End If		
			
				//Project ID	C(10)	Yes	N/A	Project identifier
			
				lsTemp = Upper(Trim(ldsImport.GetItemString(llFileRowPos, "col3")))
			
				If IsNull(lsTemp) OR trim(lsTemp) = '' Then
					gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Project is required. Record will not be processed.")
					lbError = True
					Continue		
				Else
					lsProject = lsTemp
				End If									

				//Delivery Number	C(20)	Yes	N/A	Delivery Order Number (must match header)

				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col4"))
			
				If IsNull(lsTemp) OR trim(lsTemp) = '' Then
					gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Order Number is required. Record will not be processed.")
					lbError = True
					Continue		
				Else
				

					//*Note(We Concatinated Order # with UserField12 above)
					If len(lsUf12) > 0 Then 
						lsDtlInvoice = lsTemp + lsuf12
					Else
						lsDtlInvoice = lsTemp
					End If
					//Make sure we have a header for this Detail... 
					If ldsSOHeader.Find("Upper(invoice_no) = '" + Upper(lsDtlInvoice) + "'",1, ldsSOHeader.RowCount()) = 0 Then
						gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Detail Order Number does not match header ORder Number. Record will not be processed.")
						lbError = True
						Continue		
					End If
				End If			

			
				//Supplier Code	C(20)	Yes	N/A	

				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col5"))
			
				If IsNull(lsTemp) OR trim(lsTemp) = '' Then
					gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Supplier Code is required. Record will not be processed.")
					lbError = True
					Continue		
				Else
					lsSupplier = lsTemp
				End If			

		
				//Line Number	N(6,0)	Yes	N/A	Delivery line item number

				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col6"))
			
				If IsNull(lsTemp) OR trim(lsTemp) = '' Then
					gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Line Item Number is required. Record will not be processed.")
					lbError = True
					Continue		
				Else
					llLineItemNo = Long(lsTemp)
				End If					
			
				//SKU	C(50)	Yes	N/A	Material number

	
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col7"))
			
				If IsNull(lsTemp) OR trim(lsTemp) = '' Then
					gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Sku is required. Record will not be processed.")
					lbError = True
					Continue		
				Else
					lsSku = lsTemp
				End If				
			
				//Quantity	N(15,5)	Yes	N/A	Requested delivery quantity

				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col8"))
			
				If IsNull(lsTemp) OR trim(lsTemp) = '' Then
					gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Quantity is required. Record will not be processed.")
					lbError = True
					Continue		
				Else
					ldQuantity = Dec(lsTemp)
				End If			

				//Inventory Type	C(1)	Yes	N/A	Inventory Type		
	
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col9"))
			
				If IsNull(lsTemp) OR trim(lsTemp) = '' Then
					gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Inventory Type is required. Record will not be processed.")
					lbError = True
					Continue		
				Else
					ls_InventoryType = lsTemp
				End If		
	
				/* End Required */
		
		
				lbDetailError = False
				llNewDetailRow = 	ldsSODetail.InsertRow(0)
				llLineSeq ++
					
				//Add detail level defaults
				ldsSODetail.SetItem(llNewDetailRow,'order_seq_no',llOrderSeq) 
				ldsSODetail.SetItem(llNewDetailRow,'project_id', lsProject) /*project*/
				ldsSODetail.SetItem(llNewDetailRow,'status_cd', 'N') 
				ldsSODetail.SetItem(llNewDetailRow,'Inventory_Type', ls_InventoryType) 
				ldsSODetail.SetItem(llNewDetailRow,'edi_batch_seq_no',llbatchseq) /*batch seq No*/
				ldsSODetail.SetItem(llNewDetailRow,"order_line_no",string(llLineSeq))
			
				ldsSODetail.SetItem(llNewDetailRow,'invoice_no',lsDtlInvoice)			
	//			ldsSODetail.SetItem(llNewDetailRow,'action_cd',lsChangeID) /*Supplier Order*/	

				ldsSODetail.SetItem(llNewDetailRow,'sku',lsSku) /*Sku*/	
				ldsSODetail.SetItem(llNewDetailRow,'Supp_Code',lsSupplier) /*Supplier Code*/	
				ldsSODetail.SetItem(llNewDetailRow,'Line_Item_No',llLineItemNo) /*Line_Item_No*/	
				ldsSODetail.SetItem(llNewDetailRow,'Quantity', String(ldQuantity)) /*Quantity*/				
			

				//Customer  Line Item Number	C(20)	No	N/A	Customer Line Item Number

				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col10"))
	
				If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
//					ldsSOheader.SetItem(liNewRow,'user_field4', lsTemp)
					ldsSODetail.SetItem(llNewDetailRow,'user_field4', lsTemp)  //TAM added this to the detail level as well
				End If		

				//Alternate SKU	C(50)	No	N/A	Alternate SKU
			
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col11"))
	
				If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
					ldsSODetail.SetItem(llNewDetailRow,'alternate_sku', lsTemp)
				End If				
			
			
				//Customer SKU	C(35)	No	N/A	Customer/Alternate SKU
			
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col12"))
	
				If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
	//				ldsSODetail.SetItem(llNewDetailRow,'cust_sku', lsTemp)
				End If				
			
				//Lot Number	C(50)	No	N/A	1st User Defined Inventory field
			
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col13"))
	
				If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
					ldsSODetail.SetItem(llNewDetailRow,'lot_no', lsTemp)
				End If				
			
			
				//PO NBR	C(50)	No	N/A	2nd User Defined Inventory field
			
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col14"))
	
				If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
					ldsSODetail.SetItem(llNewDetailRow,'po_no', lsTemp)
				End If			
			
			
				//PO NBR 2	C(50)	No	N/A	3rd User Defined Inventory Field
			
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col15"))
	
				If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
					ldsSODetail.SetItem(llNewDetailRow,'po_no2', lsTemp)
				End If				
			
				//Serial Number	C(50)	No	N/A	Qty must be 1 if present
			
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col16"))
	
				If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
					ldsSODetail.SetItem(llNewDetailRow,'serial_no', lsTemp)
				End If				
			
				//Line Item Text	C(255)	No	N/A	Notes / remarks
			
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col17"))
	
				If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
					ldsSODetail.SetItem(llNewDetailRow,'line_item_notes', lsTemp)
				End If				
			
			
				//User Field1	C(20)	No	N/A	User Field
				//User Field2	C(20)	No	N/A	User Field
				//User Field3	C(30)	No	N/A	User Field
				//User Field4	C(30)	No	N/A	User Field
				//User Field5	C(30)	No	N/A	User Field
				//User Field6	C(30)	No	N/A	User Field
				//User Field7	C(30)	No	N/A	User Field
				//User Field8	C(30)	No	N/A	User Field, not viewable on screen
	
				uf_process_userfields(18, 8, ldsImport, llFileRowPos, ldsSODetail, llNewDetailRow)

			//TAM  2011/12/07 - Look to see if we have inventory with for Invoice No = PO_NO.  If we do then this inventore was created by a workorder specifically for this delivery order and we need
			// to set the Pick By PO_NO field to this invoice number.   If No inventory exists then we need to set the pick by Po_No to "GENERIC.  Riverbed sends a delivery invoice number on the workorder then we must reserve this inventory for a specific DO_NO.  To do this we will put the Delivery invoice number into the PO_NO in inventory.
			// If there is no Delivery Invoice Number on the workorder then we will default PO_NO to "GENERIC".  We will then require Inventory to be picked by PO_NO on the delivery order.
		   SELECT count(*) INTO :llcontentcount FROM Content  
		   WHERE (Content.Project_ID = :lsProject ) AND  (Content.SKU = :lssku ) AND  ( Content.WH_Code = :lswarehouse ) AND  ( Content.PO_No = :lsInvoiceNumber )   ;
			If llcontentcount > 0 then
					ldsSODetail.SetItem(llNewDetailRow,'pick_po_no', lsInvoiceNumber)
			else
					ldsSODetail.SetItem(llNewDetailRow,'pick_po_no', 'GENERIC')
			end If

			Else  //Add Delivery BOM

				//SKU	C(50)	Yes	N/A	Material number

				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col7"))
			
				If IsNull(lsTemp) OR trim(lsTemp) = '' Then
					gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Sku is required. Record will not be processed.")
					lbError = True
					Continue		
				Else
					lsChildSku = lsTemp
				End If				

				//Quantity	N(15,5)	Yes	N/A	Requested delivery quantity

				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col8"))
			
				If IsNull(lsTemp) OR trim(lsTemp) = '' Then
					gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Quantity is required. Record will not be processed.")
					lbError = True
					Continue		
				Else
					ldChildQty = Dec(lsTemp)
					If ldQuantity = 0 Then // Parent Quantity from above.  
						gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Parent Quantity is required. Record will not be processed.")
						lbError = True
						Continue		
					Else
						ldChildQty = ldChildQty/ldQuantity   //Child quantity needs to be store as a BOM qty.  Riverbed sends it as a total quantity
					End If			

//					ldChildQty = Dec(lsTemp)
				End If			
				
				llNewBOMRow = ldsDOBOM.InsertRow(0)
				ldsDOBOM.SetITem(llNewBOMRow,'project_id',asProject) 
				ldsDOBOM.SetItem(llNewBOMRow,'edi_batch_seq_no',llbatchseq) 
				ldsDOBOM.SetItem(llNewBOMRow,'order_seq_no',llOrderSeq) 
				ldsDOBOM.SetItem(llNewBOMRow,'line_item_no',llLineItemNo) 
				ldsDOBOM.SetItem(llNewBOMRow,'sku_parent',lsSKU) 
				ldsDOBOM.SetItem(llNewBOMRow,'sku_child',lsChildSku) 
				ldsDOBOM.SetItem(llNewBOMRow,'child_Qty',ldChildQty) 
				ldsDOBOM.SetItem(llNewBOMRow,'supp_code_parent',lsSupplier) 

			// User 1 
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col18"))
	
				If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
					ldsSODetail.SetItem(liNewRow,'po_no', lsTemp)
					ldsDOBOM.SetItem(llNewBOMRow,'User_Field1',lsTemp) 
				End If			

				// User 2 
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col10"))
	
				If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
					ldsDOBOM.SetItem(llNewBOMRow,'User_Field2',lsTemp) 
				End If			

				// User 3 
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col17"))
	
				If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
					ldsDOBOM.SetItem(llNewBOMRow,'User_Field3',lsTemp) 
					// If Item is non shippable then we are picking it from virtual inventory "V"
					If POS(Trim(ldsImport.GetItemString(llFileRowPos, "col17")), "IsShippable:N") > 0  Then
						ldsDOBOM.SetItem(llNewBOMRow,'Inventory_Type','V') 
					End If
				End If			
					
					
					//Customer Line Number C(50)	No	N/A	
			
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col19"))
	
				If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
					ldsDOBOM.SetItem(llNewBOMRow,'User_Field4',lsTemp) 
				End If				

					//Alternate SKU	C(50)	No	N/A	Alternate SKU  - User_Field5
			
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col11"))
	
				If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
					ldsDOBOM.SetItem(llNewBOMRow,'User_Field5',lsTemp) 
				End If				

					

					
				Select Min(supp_Code) into :lsSupplier
				From Item_MAster
				Where PRoject_ID = :asProject and sku = :lsChildSku;
		
				If lsSupplier > "" Then
					ldsDOBOM.SetItem(llNewBOMRow,'supp_code_child',lsSupplier) 
				Else /*Child ITem does not exist*/
					gu_nvo_process_files.uf_writeError("(Detail) Row: " + String(llFileRowPos) + " - Child SKU: '" + lsChildSku + "' Does not exist. Record will not be processed.")
					ldsSODetail.SetItem(llNewDetailRow,'status_cd','E') /*Don't want to process record in next step*/
					ldsDOBOM.DeleteRow(llNewBomRow)
					lbError = True
					Continue /*Process Next Record */
				End If

			//TAM  2011/12/07 - Look to see if we have inventory with for Invoice No = PO_NO.  If we do then this inventore was created by a workorder specifically for this delivery order and we need
			// to set the Pick By PO_NO field to this invoice number.   If No inventory exists then we need to set the pick by Po_No to "GENERIC.  Riverbed sends a delivery invoice number on the workorder then we must reserve this inventory for a specific DO_NO.  To do this we will put the Delivery invoice number into the PO_NO in inventory.
			// If there is no Delivery Invoice Number on the workorder then we will default PO_NO to "GENERIC".  We will then require Inventory to be picked by PO_NO on the delivery order.
			   SELECT count(*) INTO :llcontentcount FROM Content  
			   WHERE (Content.Project_ID = :lsProject ) AND  (Content.SKU = :lschildsku ) AND  ( Content.WH_Code = :lswarehouse ) AND  ( Content.PO_No = :lsInvoiceNumber )   ;
				If llcontentcount > 0 then
						ldsDoBOM.SetItem(llNewBOMRow,'pick_po_no', lsInvoiceNumber)
				else
						ldsDoBOM.SetItem(llNewBOMRow,'pick_po_no', 'GENERIC')
				end If
		
					
			End If

		End Choose /*Header, Detail or Notes */
	
	
Next /*File record */
	
//Save the Changes 
SQLCA.DBParm = "disablebind =0"
lirc = ldsSOheader.Update()
SQLCA.DBParm = "disablebind =1"

	
If liRC = 1 Then
	SQLCA.DBParm = "disablebind =0"
	liRC = ldsSOdetail.Update()
	SQLCA.DBParm = "disablebind =1"

	If liRC = 1 Then
		SQLCA.DBParm = "disablebind =0"
		liRC = ldsDOBOM.Update()
		SQLCA.DBParm = "disablebind =1"
	ELSE
		lsLogOut = Space(17) + "- ***System Error!  Unable to Save new SO Detail Records to database!"
		FileWrite(gilogFileNo,lsLogOut)
		gu_nvo_process_files.uf_writeError("- ***System Error!  Unable to Save new SO Detail Records to database!")
		Return -1
	End If

ELSE
	lsLogOut = Space(17) + "- ***System Error!  Unable to Save new SO Header Records to database!"
	FileWrite(gilogFileNo,lsLogOut)
	gu_nvo_process_files.uf_writeError("- ***System Error!  Unable to Save new SO Records to database!")
	Return -1
End If



If liRC = 1 Then
	
//	Execute Immediate "COMMIT" using SQLCA; COMMIT USING SQLCA;
	SQLCA.DBParm = "disablebind =0"
	liRC = ldsDOAddress.Update()
	SQLCA.DBParm = "disablebind =1"
ELSE	
//	Execute Immediate "ROLLBACK" using SQLCA;
	lsLogOut = Space(17) + "- ***System Error!  Unable to Save new SO Detail Records to database!"
	FileWrite(gilogFileNo,lsLogOut)
	gu_nvo_process_files.uf_writeError("- ***System Error!  Unable to Save new SO Records to database!")
	Return -1
End If



	
If liRC = 1 then
//	Commit;
Else
	
//	Execute Immediate "ROLLBACK" using SQLCA; 
	lsLogOut = Space(17) + "- ***System Error!  Unable to Save new SO Records to database!"
	FileWrite(gilogFileNo,lsLogOut)
	gu_nvo_process_files.uf_writeError("- ***System Error!  Unable to Save new SO Records to database!")
	Return -1
End If

If lbError Then
	Return -1
Else
	Return 0
End If

end function

public function integer uf_process_files (string asproject, string aspath, string asfile, string asinifile);//Process the correct file type based on the first 4 characters of the file name

String	lsLogOut,	&
			lsSaveFileName, &
			lsPOLineCountFileName
			
Integer	liRC

Boolean	bRet

Choose Case Upper(Left(asFile,2))
		
	Case  'PM'  
		
		liRC = uf_process_purchase_order(asPath, asProject)
	
		//Process any added PO's
		//We need to change to project. This will be changed after testing.
		liRC = gu_nvo_process_files.uf_process_purchase_order(asProject)  //asProject

	Case  'DM'  
		
		liRC = uf_process_delivery_order(asPath, asProject)
		
		
		//Process any added SO's
		//GailM 08/09/2017 SIMSPEVS-783 Baseline - Allow multiple Inbound Sweeper for single customer migration from PDX->HiP - Add project parameter
		//25-APR-2019 :Madhu DE10154 Don't continue the process, if it is errored out
		IF liRC = 0 THEN liRC = gu_nvo_process_files.uf_process_Delivery_order( asProject )

		
	Case 'IM'
		
		liRC = uf_Process_ItemMaster(asPath, asProject)
		

	Case  'RM'  
		
		liRC = uf_return_order(asPath, asProject)
	
		//Process any added PO's
		//We need to change to project. This will be changed after testing.
		liRC = gu_nvo_process_files.uf_process_purchase_order('CHINASIMS')  //asProject
		
	//BCR 05-OCT-2011: Riverbed WO Interface
	Case 'WM'
		
		liRC = uf_process_work_order(asPath, asProject)
	
		//Process any added WO's
		liRC = gu_nvo_process_files.uf_process_workorder(asProject)  
	////////////////////	

	Case Else /*Invalid file type*/
		
		lsLogOut = "        Invalid File Type: " + asFile + " - File will not be processed."
		FileWrite(gilogFileNo,lsLogOut)
		gu_nvo_process_files.uf_writeError(lsLogout)
		Return -1
		
End Choose

Return liRC
end function

public function integer uf_return_order (string aspath, string asproject);
//Process Return Order (RM) Transaction for Baseline Unicode Client

STRING lsTemp, lsProject, lsSku, lsSupplier, lsWarehouse, lsOrderNumber, lsOrderType
BOOLEAN lbError, lbNew, lbDetailError
LONG llCount, llNew, llOwner, llexist, llOrderSeq, llLineSeq, llbatchseq, llLineItemNo
INTEGER lirc, liRtnImp, liNewRow, llNewDetailRow
STRING lsLogOut, lsChangeID
INTEGER li_StartCol
INTEGER li_UFIdx
DECIMAL ldQuantity

u_ds_datastore	ldsPOHeader,	&
				     ldsPODetail, &
					 ldsImport

ldsPOheader = Create u_ds_datastore
ldsPOheader.dataobject= 'd_baseline_unicode_po_header'
ldsPOheader.SetTransObject(SQLCA)

ldsPOdetail = Create u_ds_datastore
ldsPOdetail.dataobject= 'd_baseline_unicode_po_detail'
ldsPOdetail.SetTransObject(SQLCA)

ldsImport = Create u_ds_datastore
ldsImport.dataobject = 'd_baseline_unicode_generic_import'

//Open and read the File In
lsLogOut = '      - Opening Purchase Order File: ' + asPath
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

//Bring in File
liRtnImp =  ldsImport.ImportFile( Text!, aspath) 

if liRtnImp < 0 then
	lsLogOut = "-       ***Unable to Open Purchase Order File for "+asproject+" Processing: " + asPath + " Import Error: " + string(liRtnImp)
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
end if

integer llFileRowPos
integer llFilerowCount

llFilerowCount = ldsImport.RowCount()

//Get the next available file sequence number
llBAtchSeq = gu_nvo_process_files.uf_get_next_seq_no(asProject,'EDI_Inbound_Header','EDI_Batch_Seq_No')
If llBatchSeq <= 0 Then Return -1

//Loop through

for llFileRowPos = 1 to llFilerowCount

	w_main.SetMicroHelp("Processing Return Order Record " + String(llFileRowPos) + " of " + String(llFilerowCount))

	//Field Name	Type	Req.	Default	Description
	//Record_ID	C(2)	Yes	“RM”	Return order master identifier
	//Record ID	C(2)	Yes	“RD”	Purchase order detail identifier

	//Validate Rec Type is PM OR PD
	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col1"))
	If NOT (lsTemp = 'RM' OR lsTemp = 'RD') Then
		gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Invalid Record Type: '" + lsTemp + "'. Record will not be processed.")
		lbError = True
		//Continue /*Process Next Record */
	End If

	Choose Case Upper(lsTemp)
	
		//Return Master
	
		Case 'RM' /*RM Header*/

			//Change ID	C(1)	Yes	N/A	
				//A – Add
				//U – Update
				//D – Delete
				//X – Ignore (Add or update regardless)
				
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col2"))

			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
				gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Change ID is required. Record will not be processed.")
				lbError = True
				Continue		
			Else
				lsChangeID = lsTemp
			End If		
			
			//Project ID	C(10)	Yes	N/A	Project identifier

			lsTemp = Upper(Trim(ldsImport.GetItemString(llFileRowPos, "col3")))
			
			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
				gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Project is required. Record will not be processed.")
				lbError = True
				Continue		
			Else
				lsProject = lsTemp
			End If					

			//Warehouse	C(10)	Yes	N/A	Receiving Warehouse

			lsTemp = Upper(Trim(ldsImport.GetItemString(llFileRowPos, "col4")))
			
			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
				gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Warehouse is required. Record will not be processed.")
				lbError = True
				Continue		
			Else
				lsWarehouse = lsTemp
			End If					

			//Order Number	C(30)	Yes	N/A	Purchase order number
			
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col5"))
			
			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
				gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Order Number is required. Record will not be processed.")
				lbError = True
				Continue		
			Else
				lsOrderNumber = lsTemp
			End If					
				
				
			//Order Type	C(1)	Yes	“S”	Must be valid order typr
			
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col6"))
			
			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
				lsOrderType = "X"	
			Else
				lsOrderType = lsTemp
			End If					
	
			
			//Supplier Code	C(20)	Yes	N/A	Valid Supplier code

			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col7"))
			
			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
				gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Supplier Code is required. Record will not be processed.")
				lbError = True
				Continue		
			Else
				lsSupplier = lsTemp
			End If			

			/* End Required */		
			
			liNewRow = 	ldsPOheader.InsertRow(0)
			llOrderSeq ++
			llLineSeq = 0
			
			//New Record Defaults
			ldsPOheader.SetItem(liNewRow,'project_id',lsProject)
			ldsPOheader.SetItem(liNewRow,'wh_code',lsWarehouse)
			ldsPOheader.SetItem(liNewRow,'Request_date',String(Today(),'YYMMDD'))
			ldsPOheader.SetItem(liNewRow,'edi_batch_seq_no',llbatchseq) /*batch seq No*/
			ldsPOheader.SetItem(liNewRow,'order_seq_no',llOrderSeq) 
			ldsPOheader.SetItem(liNewRow,'ftp_file_name',asPath) /*FTP File Name*/
			ldsPOheader.SetItem(liNewRow,'Status_cd','N')
			ldsPOheader.SetItem(liNewRow,'Last_user','SIMSEDI')

			ldsPOheader.SetItem(liNewRow,'Order_No',lsOrderNumber)			
			ldsPOheader.SetItem(liNewRow,'Order_type',lsOrderType) /*Order Typer*/
			ldsPOheader.SetItem(liNewRow,'Inventory_Type','N') /*default to Normal*/
	
	
			ldsPOheader.SetItem(liNewRow,'action_cd',lsChangeID) /*Supplier Order*/	

			ldsPOheader.SetItem(liNewRow,'Supp_Code',lsSupplier) /*Supplier Code*/	
			
			//Order Date	Date	No	N/A	Order Date
			
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col8"))
	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsPOheader.SetItem(liNewRow,'Ord_Date', lsTemp)
			End If	
			
			//Delivery Date	Date	No	N/A	Expected Delivery Date at Warehouse

			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col9"))
	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsPOheader.SetItem(liNewRow,'arrival_date', lsTemp)
			End If	

			//Carrier	C(10)	No	N/A	Carrier
			
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col10"))
	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsPOheader.SetItem(liNewRow,'Carrier',  lsTemp)
			End If				
			
			//Supplier Invoice Number	C(30)	No	N/A	Supplier Invoice Number
			
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col11"))
	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsPOheader.SetItem(liNewRow,'Supp_Order_No', lsTemp)
			End If				
			
			//AWB #	C(20)	No	N/A	Airway Bill/Tracking Number
			
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col12"))
	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsPOheader.SetItem(liNewRow,'AWB_BOL_No', lsTemp)
			End If				
			
			//Transport Mode	C(10)	No	N/A	Transportation mode to warehouse
			
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col13"))
	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsPOheader.SetItem(liNewRow,'Transport_Mode', lsTemp)
			End If				
			
			//Remarks	C(250)	No	N/A	Freeform Remarks

			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col14"))
	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsPOheader.SetItem(liNewRow,'Remark', lsTemp)
			End If	

			//Return Name	C(50)	No	N/A	
			//Return Address 1	C(60)	No	N/A	
			//Return Address 2	C(60)	No	N/A	
			//Return Address 3	C(60)	No	N/A	
			//Return Address 4	C6)	No	N/A	
			//Return City	C(50)	No	N/A	
			//Return State	C(50)	No	N/A	
			//Return Postal Code	C(50)	No	N/A	
			//Return Country	C(50)	No	N/A	
			//Return Tel	C(20)	No	N/A	
			//Return Contact Name	C(40)	No	N/A	
			//User Field1	C(10)	No	N/A	User Field
			//User Field2	C(10)	No	N/A	User Field
			//User Field3	C(10)	No	N/A	User Field
			//User Field4	C(20)	No	N/A	User Field
			//User Field5	C(20)	No	N/A	User Field
			//User Field6	C(20)	No	N/A	User Field
			//User Field7	C(30)	No	N/A	User Field
			//User Field8	C(30)	No	N/A	User Field
			//User Field9	C(255)	No	N/A	User Field
			//User Field10	C(255)	No	N/A	User Field
			//User Field11	C(255)	No	N/A	User Field
			//User Field12	C(255)	No	N/A	User Field
			//User Field13	C(255)	No	N/A	User Field
			//User Field14	C(255)	No	N/A	User Field, not viewable on screen
			//User Field15	C(255)	No	N/A	User Field, not viewable on screen
			//

			uf_process_userfields(26, 15, ldsImport, llFileRowPos, ldsPOheader, liNewRow)	

			//Note: 
			//
			//4.	A return can only be deleted if no receipts have been generated against it.
			//5.	Deletion of a Return Order Master will also delete related purchase order details.
			//6.	Updated RM/RD’s should include all of the information for the RM/RD’s regardless of whether or not a specific item has been changed.
			//
						

		//Return Detail				
				
		CASE 'RD' /* detail*/

		//Return Order Detail

			//Change ID	C(1)	Yes	N/A	
				//A – Add
				//U – Update
				//D – Delete

			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col2"))

			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
				gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Change ID is required. Record will not be processed.")
				lbError = True
				Continue		
			Else
				lsChangeID = lsTemp
			End If		
			
			//Project ID	C(10)	Yes	N/A	Project identifier
			
			lsTemp = Upper(Trim(ldsImport.GetItemString(llFileRowPos, "col3")))
			
			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
				gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Project is required. Record will not be processed.")
				lbError = True
				Continue		
			Else
				lsProject = lsTemp
			End If									

			//Order Number	C(30)	Yes	N/A	Purchase order number

			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col4"))
			
			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
				gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Order Number is required. Record will not be processed.")
				lbError = True
				Continue		
			Else
				
			
				//Make sure we have a header for this Detail...
				If ldsPoHeader.Find("Upper(order_no) = '" + Upper(lstemp) + "'",1, ldsPoHeader.RowCount()) = 0 Then
					gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Detail Order Number does not match header ORder Number. Record will not be processed.")
					lbDetailError = True
				End If
					
				lsOrderNumber = lsTemp
			End If			

				
			//Supplier Code	C(20)	Yes	N/A	Valid Supplier code

			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col5"))
			
			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
				gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Supplier Code is required. Record will not be processed.")
				lbError = True
				Continue		
			Else
				lsSupplier = lsTemp
			End If			
				
			
			//Line Item Number	N(6,0)	Yes	N/A	Item number of purchase order document

			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col6"))
			
			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
				gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Line Item Number is required. Record will not be processed.")
				lbError = True
				Continue		
			Else
				llLineItemNo = Long(lsTemp)
			End If					
			
			//SKU	C(26)	Yes	N/A	Material number
			
			
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col7"))
			
			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
				gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Sku is required. Record will not be processed.")
				lbError = True
				Continue		
			Else
				lsSku = lsTemp
			End If				
			
			//Quantity	N(15,5)	Yes	N/A	Purchase order quantity


			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col8"))
			
			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
				gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Quantity is required. Record will not be processed.")
				lbError = True
				Continue		
			Else
				ldQuantity = Dec(lsTemp)
			End If			
		
			/* End Required */
		
		
			lbDetailError = False
			llNewDetailRow = 	ldsPODetail.InsertRow(0)
			llLineSeq ++
					
			//Add detail level defaults
			ldsPODetail.SetItem(llNewDetailRow,'order_seq_no',llOrderSeq) 
			ldsPODetail.SetItem(llNewDetailRow,'project_id', lsProject) /*project*/
			ldsPODetail.SetItem(llNewDetailRow,'status_cd', 'N') 
			ldsPODetail.SetItem(llNewDetailRow,'Inventory_Type', 'N') 
			ldsPODetail.SetItem(llNewDetailRow,'edi_batch_seq_no',llbatchseq) /*batch seq No*/
			ldsPODetail.SetItem(llNewDetailRow,"order_line_no",string(llLineSeq))
			
			ldsPODetail.SetItem(llNewDetailRow,'Order_No',lsOrderNumber)			
			ldsPODetail.SetItem(llNewDetailRow,'action_cd',lsChangeID) /*Supplier Order*/	

			ldsPODetail.SetItem(llNewDetailRow,'sku',lsSku) /*Sku*/	
			ldsPODetail.SetItem(llNewDetailRow,'Supp_Code',lsSupplier) /*Supplier Code*/	
			ldsPODetail.SetItem(llNewDetailRow,'Line_Item_No',llLineItemNo) /*Line_Item_No*/	
			ldsPODetail.SetItem(llNewDetailRow,'Quantity', String(ldQuantity)) /*Quantity*/				
			
			
			//Inventory Type	C(1)	No	N/A	Inventory Type
			
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col9"))
	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsPODetail.SetItem(llNewDetailRow,'Inventory_Type', lsTemp)
			End If	
			
			//Alternate SKU	C(50)	No	N/A	Supplier’s material number
			
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col10"))
	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsPODetail.SetItem(llNewDetailRow,'Alternate_Sku', lsTemp)
			End If	
			
			//Lot Number	C(50)	No	N/A	1st User Defined Inventory field
			
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col11"))
	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsPODetail.SetItem(llNewDetailRow,'Lot_No', lsTemp)
			End If				
			
			//PO NBR	C(50)	No	N/A	2nd User Defined Inventory field
			
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col12"))
	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsPODetail.SetItem(llNewDetailRow,'PO_No', lsTemp)
			End If	
			
			//PO NBR 2	C(50)	No	N/A	3rd User Defined Inventory Field
			
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col13"))
	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsPODetail.SetItem(llNewDetailRow,'PO_No2', lsTemp)
			End If	
			
			//Serial Number	C(50)	No	N/A	Qty must be 1 if present

			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col14"))
	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsPODetail.SetItem(llNewDetailRow,'Serial_No', lsTemp)
			End If	
			
			//Expiration Date	Date	No	N/A	Product expiration Date
			
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col15"))
	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsPODetail.SetItem(llNewDetailRow,'Expiration_Date', datetime(lsTemp))
			End If				
			
			//Customer  Line Item Number 	C(25)	No	N/A	Customer  Line Item Number
			
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col16"))
	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsPODetail.SetItem(llNewDetailRow,'Line_Item_No', long(lsTemp))
			End If			
			

		
			//User Field1	C(50)	No	N/A	User Field
			//User Field2	C(50)	No	N/A	User Field
			//User Field3	C(50)	No	N/A	User Field
			//User Field4	C(50)	No	N/A	User Field
			//User Field5	C(50)	No	N/A	User Field
			//User Field6	C(50)	No	N/A	User Field
			
			uf_process_userfields(17, 6, ldsImport, llFileRowPos, ldsPODetail, llNewDetailRow)	
				
				
				//
				//Note: 
				//
			
				
			//1.	PO item can only be deleted if there are no receipts for the line item.
			//2.	PO Qty can not be reduced below that which has already been received.
			//

			
		CASE Else /* Invalid Rec Type*/
		
			gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Invalid Record Type: '" + lsTemp + "'. Record will not be processed.")
			Continue
		
	End Choose /*record Type*/
	
Next /*File record */
	
	
//Save the Changes 



SQLCA.DBParm = "disablebind =0"
lirc = ldsPOHeader.Update()
	
If liRC = 1 Then
	liRC = ldsPODetail.Update()
End If
SQLCA.DBParm = "disablebind =1"	

If liRC = 1 then
	Commit;
Else
	
	Rollback;
	lsLogOut = Space(17) + "- ***System Error!  Unable to Save new PO Records to database!"
	FileWrite(gilogFileNo,lsLogOut)
	gu_nvo_process_files.uf_writeError("- ***System Error!  Unable to Save new PO Records to database!")
	Return -1
End If

If lbError Then
	Return -1
Else
	Return 0
End If

end function

public function integer uf_process_dboh (string asproject, string asinifile);
//Process Daily Balance on Hand Confirmation File


Datastore	ldsOut,	&
				ldsboh
				
Long			llRowPos,	&
				llRowCount,	&
				llFindRow,	&
				llNewRow
				
String		lsFind,	&
				lsOutString,	&
				lslogOut,	&
				lsProject,	&
				lsNextRunTime,	&
				lsNextRunDate,	&
				lsRunFreq, &
				lsFilename, &
				lsWarehouse, &
				lsLastWarehouse

DEcimal		ldBatchSeq
Integer		liRC
DateTime		ldtNextRunTime
Date			ldtNextRunDate

String lsFileNamePath

//This function runs on a scheduled basis - the next time to run is stored in the ini as well as the frequency for setting the next run


//Moved to Scheduled Activity Table

//lsNextRunDate = ProfileString(asIniFile,asproject,'DBOHNEXTDATE','')
//lsNextRunTime = ProfileString(asIniFile, asproject,'DBOHNEXTTIME','')
//
//
//If trim(lsNextRunDate) = '' or trim(lsNextRunTIme) = '' or (not isdate(string(Date(lsNextRunDate)))) or (not isTime(string(Time(lsNextRunTime)))) Then /*not scheduled to run*/
//	Return 0
//Else /*valid date*/
//	ldtNextRunTIme = DateTime(Date(lsNextRunDate),Time(lsNextRunTime))
//	If ldtNextRunTime > dateTime(today(),now()) Then /*not yet time to run*/
//		Return 0
//	End If
//End If

ldsOut = Create Datastore
ldsOut.Dataobject = 'd_edi_generic_out'
lirc = ldsOut.SetTransobject(sqlca)

ldsboh = Create Datastore
ldsboh.Dataobject = 'd_riverbed_dboh'
lirc = ldsboh.SetTransobject(sqlca)

lsLogOut = "- PROCESSING FUNCTION: "+asproject+" Balance On Hand Confirmation!"
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
lsLogOut = ""
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/

lsProject = ProfileString(asInifile, asproject,"project","")

//Get the Next Batch Seq Nbr - Used for all writing to generic tables
sqlca.sp_next_avail_seq_no(lsproject,'EDI_Inbound_Header','EDI_Batch_Seq_No',ldBatchSeq)
commit;

If ldBatchSeq <= 0 Then
	lsLogOut = "   ***Unable to retrive next available sequence number for '+asproject+' BOH confirmation."
	FileWrite(gilogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
	 Return -1
End If

//Retrive the BOH Data
gu_nvo_process_files.uf_write_log('Retrieving Balance on Hand Data.....') /*display msg to screen*/

llRowCOunt = ldsBOH.Retrieve(lsProject)

gu_nvo_process_files.uf_write_log(String(llRowCount) + ' Rows were retrieved for processing.') /*display msg to screen*/

//Write the rows to the generic output table - delimited by ', '
gu_nvo_process_files.uf_write_log('Processing Balance on Hand Data.....') /*display msg to screen*/

For llRowPos = 1 to llRowCOunt
//TAM 2013/05/06 - Remove PTO Items from the DBOH report 
	If Pos( ldsboh.GetITemString(llRowPos,'SKU' ), '-PTO' ) = 0 Then 

	llNewRow = ldsOut.insertRow(0)
	

	//Field Name	Type	Req.	Default	Description
	//Record_ID	C(2)	Yes	“BH”	Balance on hand identifier
	
	lsOutString = 'BH' + ', '
	
	//Project ID	C(10)	Yes	N/A	Project identifier
	lsOutString +=  asproject  + ', '

	//Warehouse Code	C(10)	Yes	N/A	Warehouse ID

	lsWarehouse = left(ldsboh.GetItemString(llRowPos,'wh_code'),10)

	lsOutString +=  lsWarehouse + ', '
	
	//Inventory Type	C(30)	Yes	N/A	Item condition

	lsOutString += left(ldsboh.GetItemString(llRowPos,'inv_type_desc'),30) + ', '

	//SKU	C(50)	Yes	N/A	Material number

	lsOutString += left(ldsboh.GetItemString(llRowPos,'sku'),26) + ', '
	
	//Quantity	N(15,5)	Yes	N/A	Balance on hand
	
	lsOutString += string(ldsboh.GetItemNumber(llRowPos,'avail_qty')) + ', '

	//Quantity Allocated	N(15,5)	No	N/A	Allocated to Outbound Order
	
	lsOutString += string(ldsboh.GetItemNumber(llRowPos,'alloc_qty')) + ', '
	
	//Lot Number	C(50)	No	N/A	1st User Defined Inventory field

	if IsNull(ldsboh.GetItemString(llRowPos,'lot_no')) OR trim(ldsboh.GetItemString(llRowPos,'lot_no')) = '-' then
		lsOutString += ', '
	else	
	   lsOutString +=  left(ldsboh.GetItemString(llRowPos,'lot_no'),50) + ', '
	end if	

	//PO NBR	C(50)	No	N/A	2nd User Defined Inventory field
	
	if IsNull(ldsboh.GetItemString(llRowPos,'po_no')) OR trim(ldsboh.GetItemString(llRowPos,'po_no')) = '-' then
		lsOutString += ', '
	else	
	   lsOutString += ldsboh.GetItemString(llRowPos,'po_no') + ', '
	end if	
	
	//PO NBR 2	C(50)	No	N/A	3rd User Defined Inventory Field
	
	if IsNull(ldsboh.GetItemString(llRowPos,'po_no2')) OR Trim(ldsboh.GetItemString(llRowPos,'po_no2')) = '-'  then
		lsOutString += ', '
	else	
	   lsOutString += ldsboh.GetItemString(llRowPos,'po_no2') + ', '
	end if		
	
	//Serial Number	C(50)	No	N/A	Qty must be 1 if present
	
	if IsNull(ldsboh.GetItemString(llRowPos,'serial_no')) OR Trim(ldsboh.GetItemString(llRowPos,'serial_no')) = '-'  then
		lsOutString += ', '
	else	
	   lsOutString += ldsboh.GetItemString(llRowPos,'serial_no') + ', '
	end if			
	
	//Container ID	C(25)	No	N/A	Container ID
	
	if IsNull(ldsboh.GetItemString(llRowPos,'container_ID')) OR trim(ldsboh.GetItemString(llRowPos,'container_ID')) = '-'  then
		lsOutString +=', '
	else	
	   lsOutString += ldsboh.GetItemString(llRowPos,'container_ID') + ', '
	end if
	
	//Expiration Date	Date	No	N/A	Expiration Date	

	If string(ldsboh.GetItemdatetime(llRowPos,'Expiration_date'),'MM/DD/YYYY') <> "12/31/2999" Then
		lsOutString += string(ldsboh.GetItemdatetime(llRowPos,'Expiration_date'),'YYYY-MM-DD')
	ELSE
//		lsOutString +=', '
	End If
	
	
//	BHYYMDD.dat
	
	lsFilename = ("BH" + string(today(), "YYMMDD") + lsWarehouse + ".dat")
	
	ldsOut.SetItem(llNewRow,'file_name', lsFilename)
	ldsOut.SetItem(llNewRow,'Project_id', lsproject)
	
	if lsLastWarehouse <> lsWarehouse then

		//Get the Next Batch Seq Nbr - Used for all writing to generic tables
		sqlca.sp_next_avail_seq_no(lsproject,'EDI_Inbound_Header','EDI_Batch_Seq_No',ldBatchSeq)
		commit;
		
		If ldBatchSeq <= 0 Then
			lsLogOut = "   ***Unable to retrive next available sequence number for '+asproject+' BOH confirmation."
			FileWrite(gilogFileNo,lsLogOut)
			gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
			 Return -1
		End If
		
		lsLastWarehouse = lsWarehouse
		
	end if	
	
	
	ldsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	ldsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	ldsOut.SetItem(llNewRow,'batch_data', lsOutString)
End If
next /*next output record */


//Write the Outbound File - no need to save and re-retrieve - just use the currently loaded DW
gu_nvo_process_files.uf_process_flatfile_outbound(ldsOut,lsProject)

// TAM 2011/09  Added ability to email the report

lsFileNamePath = ProfileString(asInifile,lsProject,"archivedirectory","") + '\' + lsFileName  + ".txt"
gu_nvo_process_files.uf_send_email(lsProject,"BOHEMAIL", lsProject + " Daily Balance On Hand Run on " + string(Today(), 'YYYY/MM/DD HH:MM') + ' GMT', "Attached is the BALANCE ON HAND REPORT run on" + string(Today(), 'YYYY/MM/DD HH:MM') + ' GMT', lsFileNamePath)


//Set the next time to run if freq is set in ini file
lsRunFreq = ProfileString(asIniFile, asproject,'DBOHFREQ','')
If isnumber(lsRunFreq) Then
	//ldtNextRunDate = relativeDate(Date(ldtNextRunTime),Long(lsRunFreq))
	ldtNextRunDate = relativeDate(today(),Long(lsRunFreq)) /*relative based on today*/
	SetProfileString(asIniFile, asproject,'DBOHNEXTDATE',String(ldtNextRunDate,'mm-dd-yyyy'))
Else
	SetProfileString(asIniFile, asproject,'DBOHNEXTDATE','')
End If

Return 0
end function

public function integer uf_process_work_order (string aspath, string asproject);
//BCR 03-OCT-2011: Process Work Order (WO) Transaction for Riverbed

STRING lsTemp, lsProject, lsSku, lsSupplier, lsWarehouse, lsOrderNumber, lsOrderType, lsOrderDate, lsOwnerID
BOOLEAN lbError, lbNew, lbDetailError
LONG llCount, llNew, llOwner, llexist, llOrderSeq, llLineSeq, llbatchseq, llLineItemNo, llNewBOMRow
INTEGER lirc, liRtnImp, liNewRow, llNewDetailRow
STRING lsLogOut, lsChangeID, lsSkuParent, lsSkuChild, lsSupplierParent, lsSupplierChild, lsSuppOrdNo
INTEGER li_StartCol
INTEGER li_UFIdx
DECIMAL ldQuantity
STRING lsNull
DATETIME ldtWHTime
SetNull(lsNull)

u_ds_datastore	ldsWOHeader,	&
				     ldsWODetail, &
					 ldsDOBOM, & 
					 ldsImport

ldsWOHeader = Create u_ds_datastore
ldsWOHeader.dataobject= 'd_baseline_unicode_po_header'
ldsWOHeader.SetTransObject(SQLCA)

ldsWODetail = Create u_ds_datastore
ldsWODetail.dataobject= 'd_baseline_unicode_po_detail'
ldsWODetail.SetTransObject(SQLCA)

ldsDOBOM = Create u_ds_datastore
ldsDOBOM.dataobject = 'd_delivery_bom'
ldsDOBOM.SetTransObject(SQLCA)

ldsImport = Create u_ds_datastore
ldsImport.dataobject = 'd_baseline_unicode_generic_import'

//Open and read the File In
lsLogOut = '      - Opening Work Order File: ' + asPath
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

//Bring in File
liRtnImp =  ldsImport.ImportFile( Text!, aspath) 

if liRtnImp < 0 then
	lsLogOut = "-       ***Unable to Open Work Order File for "+asproject+" Processing: " + asPath + " Import Error: " + string(liRtnImp)
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
end if

integer llFileRowPos
integer llFilerowCount

llFilerowCount = ldsImport.RowCount()

//Get the next available file sequence number
llBAtchSeq = gu_nvo_process_files.uf_get_next_seq_no(asProject,'EDI_Inbound_Header','EDI_Batch_Seq_No')
If llBatchSeq <= 0 Then Return -1

//Loop through

for llFileRowPos = 1 to llFilerowCount

	w_main.SetMicroHelp("Processing Work Order Record " + String(llFileRowPos) + " of " + String(llFilerowCount))


	//Field Name	Type	Req.	Default	Description
	//Record_ID	C(2)	Yes	“WH”	Work order master identifier
	//Record_ID	C(2)	Yes	“WD”	Work order detail identifier
	//Record_ID	C(2)	Yes	“WC”	Work order component identifier

	//Validate Rec Type is WH OR WD OR WC
	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col1"))
	If NOT (lsTemp = 'WH' OR lsTemp = 'WD' OR lsTemp = 'WC') Then
		gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Invalid Record Type: '" + lsTemp + "'. Record will not be processed.")
		lbError = True
		//Continue /*Process Next Record */
	End If

	Choose Case Upper(lsTemp)
	
		//Work Order Master
	
		Case 'WH' /*WO Header*/

			//Project ID	C(10)	Yes	N/A	Project identifier

			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col2"))

			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
				//SIMS will default ...
				lsProject = asproject	
			Else
				lsProject = lsTemp
			End If	
				
			
			//Order Type	C(1)	Yes	“S”	Must be valid order type
			
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col3"))
			
			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
				lsTemp = "S"	
			Else
				lsOrderType = lsTemp
			End If		
			
			
			//Order Date	Date	Yes	N/A	Order Date
			
//			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col4"))
			
//			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
//				gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Order Date is required. Record will not be processed.")
//				lbError = True
//				Continue		
//			Else
//				lsOrderDate = lsTemp
//			End If		
	
						
			//Wh Code	C(10)	Yes	Yes	Warehouse Code

			lsTemp = Upper(Trim(ldsImport.GetItemString(llFileRowPos, "col9")))
			
			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
				//Default...
				lsWarehouse = 'RB-SG'
			Else
				lsWarehouse = lsTemp
			End If		

		 // 4/2010  - now setting ord_date to local wh time
			ldtWHTime = f_getLocalWorldTime(lsWarehouse)
			lsOrderDate = string(ldtWHTime, 'mm-dd-yyyy hh:mm')
							
			
			//WorkOrder Number	C(30)	Yes	N/A	Work order number
			
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col7"))
			
			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
				gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - WorkOrder Number is required. Record will not be processed.")
				lbError = True
				Continue		
			Else
				lsOrderNumber = lsTemp
			End If								
				
				
			/* End Required */		
			
			liNewRow = 	ldsWOHeader.InsertRow(0)
			llOrderSeq ++
			llLineSeq = 0
			
			//New Record Defaults
			ldsWOHeader.SetItem(liNewRow,'project_id',lsProject)
			ldsWOHeader.SetItem(liNewRow,'wh_code',lsWarehouse)
			ldsWOheader.SetItem(liNewRow,'Supp_Code','RIVERBED') /*Supplier Code*/
// TAM 2012/05/25  Use Local Date/Time instead of system time
//			ldsWOHeader.SetItem(liNewRow,'Request_date',String(Today(),'YYMMDD'))
			ldsWOHeader.SetItem(liNewRow,'Request_Date', lsOrderDate)
			ldsWOHeader.SetItem(liNewRow,'edi_batch_seq_no',llbatchseq) /*batch seq No*/
			ldsWOHeader.SetItem(liNewRow,'order_seq_no',llOrderSeq) 
			ldsWOHeader.SetItem(liNewRow,'ftp_file_name',asPath) /*FTP File Name*/
			ldsWOHeader.SetItem(liNewRow,'Status_cd','N')
			ldsWOHeader.SetItem(liNewRow,'Last_user','SIMSEDI')
			ldsWOHeader.SetItem(liNewRow,'Order_No',lsOrderNumber)/*WorkOrder Number*/			
			ldsWOHeader.SetItem(liNewRow,'Order_type',lsOrderType) /*Order Typer*/
			ldsWOHeader.SetItem(liNewRow,'Ord_Date', lsOrderDate)
			ldsWOHeader.SetItem(liNewRow,'Inventory_Type','N') /*default to Normal*/
			ldsWOHeader.SetItem(liNewRow,'action_cd','A') /*Default to Add*/	

			
			//Sched Date	Date	No	N/A	Scheduled Delivery Date at Warehouse

			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col5"))
	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsWOHeader.SetItem(liNewRow,'arrival_date', lsTemp)
			End If	

			
			//Delivery Invoice Number	C(20)	No	N/A	Delivery Invoice Number
			
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col6"))
	
			//TAM  2011/12/07 - If Riverbed sends a delivery invoice number then we must reserve this inventory for a specific DO_NO.  To do this we will put the Delivery invoice number into the PO_NO in inventory.
			// If there is no Delivery Invoice Number then we will default PO_NO to "GENERIC".  We will then require Inventory to be picked by PO_NO on the delivery order.
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				lsSuppOrdNo = lsTemp
				ldsWOHeader.SetItem(liNewRow,'Supp_Order_No', lsTemp)
			Else
				lsSuppOrdNo = ''
			End If				
			
			
			//Remarks	C(250)	No	N/A	Freeform Remarks

			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col13"))
	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsWOHeader.SetItem(liNewRow,'Remark', lsTemp)
			End If	

			uf_process_userfields(10, 3, ldsImport, llFileRowPos, ldsWOheader, liNewRow)	

			//User Field4	C(250)	No	N/A	User Field
			
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col14"))

			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsWOHeader.SetItem(liNewRow,'User_Field4', lsTemp)
			End If		
			
			

		//Work Order Detail				
				
		CASE 'WD' /* detail*/

			//Project ID	C(10)	Yes	N/A	Project identifier
			
			//For WO Detail processsing, Project ID is required but not passed in. So, use default.
			lsProject = asProject
										

			//Order Number	C(20)	Yes	N/A	Work order number

			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col2"))
			
			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
				gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Order Number is required. Record will not be processed.")
				lbError = True
				Continue		
			Else
				
				//Make sure we have a header for this Detail...
				If ldsWOHeader.Find("Upper(order_no) = '" + Upper(lstemp) + "'",1, ldsWOHeader.RowCount()) = 0 Then
					gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Detail Order Number does not match header Order Number. Record will not be processed.")
					lbDetailError = True
				End If
					
				lsOrderNumber = lsTemp
			End If			

			
			//SKU	C(50)	Yes	N/A	Material number
			
			
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col3"))
			
			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
				gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Sku is required. Record will not be processed.")
				lbError = True
				Continue		
			Else
				lsSku = lsTemp
			End If			
			
			
			//Supp Code	C(20)	Yes	N/A	Supplier Code
			
			lsTemp = Upper(Trim(ldsImport.GetItemString(llFileRowPos, "col4")))
			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
				lsSupplier = 'RIVERBED'
			Else
				lsSupplier = lsTemp
			End If		
			
					
			SELECT supp_code
			INTO :lsSupplier
			FROM Item_Master
			WHERE Project_Id = 'RIVERBED'
			AND Sku = :lsSKU
			USING SQLCA;
					
			IF IsNull(lsSupplier) OR trim(lsSupplier) = '' THEN
				gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Item Master for SKU '" + lsSku + "' does not exist. Record will not be processed.")
				lbError = True
				Continue	
			END IF	
			
			//Line Item Number	N(6,0)	Yes	N/A	Item number of Work order document

			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col5"))
			
			//SIMS to simply increment Line Item Number for Riverbed
			llLineItemNo ++
			
			
			//Owner Code	C(10)	Yes	N/A	
			
			lsTemp = Upper(Trim(ldsImport.GetItemString(llFileRowPos, "col6")))
			
//			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
//				//SIMS to default to value in Item_Master
				
				Select Owner_id into :llOwner
				From Owner
				Where Project_id = 'RIVERBED' and owner_type = 'C' and Owner_cd = 'GENERIC';
	
//				
//				IF IsNull(llOwner) OR llOwner = 0 THEN
//					gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Owner Code is required. Record will not be processed.")
//					lbError = True
//					Continue	
//				ELSE
//					lsOwnerID = String(llOwner)
//				END IF	
				
//				lsOwnerID = '271980'
//			Else
//				lsOwnerID = lsTemp
//			End If											
				
			
			//Quantity	N(15,5)	Yes	N/A	Work order quantity

			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col7"))
			
			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
				gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Quantity is required. Record will not be processed.")
				lbError = True
				Continue		
			Else
				ldQuantity = Dec(lsTemp)
			End If			
		
			/* End Required */
		
		
			lbDetailError = False
			llNewDetailRow = 	ldsWODetail.InsertRow(0)
			llLineSeq ++
					
			//Add detail level defaults
			ldsWODetail.SetItem(llNewDetailRow,'order_seq_no',llOrderSeq) 
			ldsWODetail.SetItem(llNewDetailRow,'project_id', lsProject) /*project*/
			ldsWODetail.SetItem(llNewDetailRow,'status_cd', 'N') 
			ldsWODetail.SetItem(llNewDetailRow,'Inventory_Type', 'N') 
			ldsWODetail.SetItem(llNewDetailRow,'edi_batch_seq_no',llbatchseq) /*batch seq No*/
			ldsWODetail.SetItem(llNewDetailRow,"order_line_no",string(llLineSeq))
			ldsWODetail.SetItem(llNewDetailRow,'Order_No',lsOrderNumber)/*WorkOrder Number*/			
			ldsWODetail.SetItem(llNewDetailRow,'action_cd','A') /*Default to Add*/	
			ldsWODetail.SetItem(llNewDetailRow,'sku',lsSku) /*Sku*/	
			ldsWODetail.SetItem(llNewDetailRow,'Supp_Code',lsSupplier) /*Supplier Code*/	
			ldsWODetail.SetItem(llNewDetailRow,'Line_Item_No',llLineItemNo) /*Line_Item_No*/	
			ldsWODetail.SetItem(llNewDetailRow,'owner_id', lsOwnerID) /*Owner ID*/
			ldsWODetail.SetItem(llNewDetailRow,'Quantity', String(ldQuantity)) /*Quantity*/				
			IF lsSuppOrdNo <> '' Then
				ldsWODetail.SetItem(llNewDetailRow,'PO_NO', lsSuppOrdNo ) /*TAM 2011/12/07 lsSuppOrdNo from the header above*/	
			Else
				ldsWODetail.SetItem(llNewDetailRow,'PO_NO', 'GENERIC' ) /*TAM 2011/12/07 "GENERIC" if blank*/	
			End If

			//User Field1
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col8"))
			
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsWODetail.SetItem(llNewDetailRow,'user_field1', lsTemp) 
			End If			
		
			//User Field2
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col9"))
			
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsWODetail.SetItem(llNewDetailRow,'user_field2', lsTemp) 
			End If			

			//User Field3	C(30)	No	N/A	User Field  ***** NOTE user_field3 is 30 in workorder detail but only 20 in PO_Detail table.  We will pass it into user_field5 but ultimately write it in WD.UF3
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col10"))
			
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsWODetail.SetItem(llNewDetailRow,'user_field5', lsTemp) 
			End If			
			
			
			//User Field1	C(30) 	No	N/A	User Field
			//User Field2	C(30) 	No	N/A	User Field
			//User Field3	C(250)	No	N/A	User Field
			
//			uf_process_userfields(8, 3, ldsImport, llFileRowPos, ldsWODetail, llNewDetailRow)	

		
		//Work Order Component
		
		CASE 'WC' /*Component*/
			
			//SKU Parent	C(50)	Yes	N/A	
			
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col2"))

			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
				gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Parent SKU is required. Record will not be processed.")
				lbError = True
				Continue		
			Else
				lsSKUParent = lsTemp
			End If		
			
			//Supp Code Parent	C(20)	Yes	N/A	Parent's Supplier Code
			
			lsTemp = Upper(Trim(ldsImport.GetItemString(llFileRowPos, "col3")))
			
			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
				//SIMS to default to value in Item_Master...
				SELECT supp_code
				INTO :lsSupplierParent
				FROM Item_Master
				WHERE Project_Id = 'RIVERBED'
				AND Sku = :lsSKUParent
				USING SQLCA;
					
				IF IsNull(lsSupplierParent) OR trim(lsSupplierParent) = '' THEN
					gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Supp Code Parent is required. Record will not be processed.")
					lbError = True
					Continue	
				END IF	
					
			Else
				lsSupplierParent = lsTemp
			End If				
			
			
			//SKU Child	C(50)	Yes	N/A	
			
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col4"))

			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
				gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Child SKU is required. Record will not be processed.")
				lbError = True
				Continue		
			Else
				lsSKUChild = lsTemp
			End If		
			
			//Supp Code Child	C(20)	Yes	N/A	Child's Supplier Code
			
			lsTemp = Upper(Trim(ldsImport.GetItemString(llFileRowPos, "col5")))
			
			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
				//SIMS to default to value in Item_Master...
				SELECT supp_code
				INTO :lsSupplierChild
				FROM Item_Master
				WHERE Project_Id = 'RIVERBED'
				AND Sku = :lsSKUChild
				USING SQLCA;
				
				IF IsNull(lsSupplierChild) OR trim(lsSupplierChild) = '' THEN
					gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Supp Code Child is required. Record will not be processed.")
					lbError = True
					Continue	
				END IF
					
			Else
				lsSupplierChild = lsTemp
			End If				

			/* End Required */
			
			llNewBOMRow = ldsDOBOM.InsertRow(0)
			ldsDOBOM.SetITem(llNewBOMRow,'project_id',asProject) 
			ldsDOBOM.SetItem(llNewBOMRow,'edi_batch_seq_no',llbatchseq) 
			ldsDOBOM.SetItem(llNewBOMRow,'order_seq_no',llOrderSeq) 
			ldsDOBOM.SetItem(llNewBOMRow,'line_item_no',llLineItemNo) 
			ldsDOBOM.SetItem(llNewBOMRow,'sku_parent',lsSkuParent) /*Sku Parent*/
			ldsDOBOM.SetItem(llNewBOMRow,'Supp_Code_Parent',lsSupplierParent) /*Parent Supplier Code*/	
			ldsDOBOM.SetItem(llNewBOMRow,'sku_child',lsSkuChild) /*Sku Child*/
			ldsDOBOM.SetItem(llNewBOMRow,'Supp_Code_Child',lsSupplierChild) /*Child Supplier Code*/

			//Child Quantity 	N(15,5)	Yes	N/A	
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col6"))
			IF IsNull(lsTemp) OR trim(lsTemp) = '' THEN
				//Use Qty from WO Detail above... 
				ldsDOBOM.SetItem(llNewBOMRow,'Child_Qty',  ldQuantity)
			ELSE
				ldsDOBOM.SetItem(llNewBOMRow,'Child_Qty',  Dec(lsTemp))
			END IF			
			
			//User Field1	C(50) 	No	N/A	User Field
			
			uf_process_userfields(11, 1, ldsImport, llFileRowPos, ldsDOBOM, llNewBOMRow)
		
		
		CASE Else /* Invalid Rec Type*/
		
			gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Invalid Record Type: '" + lsTemp + "'. Record will not be processed.")
			Continue
		
	End Choose /*record Type*/
	
Next /*File record */
	
	
//Save the Changes 



SQLCA.DBParm = "disablebind =0"
lirc = ldsWOHeader.Update()
	
If liRC = 1 Then
	liRC = ldsWODetail.Update()
End If

If liRC = 1 Then
	liRC = ldsDOBOM.Update()
End If
SQLCA.DBParm = "disablebind =1"	

If liRC = 1 then
	Commit;
Else
	
	Rollback;
	lsLogOut = Space(17) + "- ***System Error!  Unable to Save new PO Records to database!"
	FileWrite(gilogFileNo,lsLogOut)
	gu_nvo_process_files.uf_writeError("- ***System Error!  Unable to Save new PO Records to database!")
	Return -1
End If

If lbError Then
	Return -1
Else
	Return 0
End If

end function

public function integer uf_load_trax_terms (ref datastore adw_importdw, integer adw_importdwcurrentrow, ref datastore adw_destdw, integer adw_destdwcurrentrow);
integer li_StartCol, li_UFIdx
string lsUf4,lsuf5,lsuf6,lsuf7	

	
			//User Field4	C(20)	No	N/A	Freight Term
			lsuf4 = Trim(adw_ImportDW.GetItemString(adw_ImportDWCurrentRow, "col42"))
			lsuf5 = Trim(adw_ImportDW.GetItemString(adw_ImportDWCurrentRow, "col43"))
			lsuf6 = Trim(adw_ImportDW.GetItemString(adw_ImportDWCurrentRow, "col44"))
			lsuf7 = Trim(adw_ImportDW.GetItemString(adw_ImportDWCurrentRow, "col45"))
	
			If UPPER(lsuf4) = 'SHIPPER' Then
				adw_DestDW.SetItem(adw_DestDWCurrentRow,'Freight_Terms', 'PREPAID')
				adw_DestDW.SetItem(adw_DestDWCurrentRow,'Trax_Acct_No', '')
			End If
						
			If UPPER(lsuf4) = 'RECIPIENT' Then
				adw_DestDW.SetItem(adw_DestDWCurrentRow,'Freight_Terms', 'COLLECT')
				If NOT(IsNull(lsuf5) OR trim(lsuf5) = '') Then
					adw_DestDW.SetItem(adw_DestDWCurrentRow,'Trax_Acct_No', lsuf5)
				End If	
			End If

			If UPPER(lsuf4) = 'THIRD PARTY' Then
				adw_DestDW.SetItem(adw_DestDWCurrentRow,'Freight_Terms', 'THIRDPARTY')
				If NOT(IsNull(lsuf5) OR trim(lsuf5) = '') Then
					adw_DestDW.SetItem(adw_DestDWCurrentRow,'Trax_Acct_No', lsuf5)
				End If	
			End If			

			If UPPER(lsuf6) = 'SHIPPER' Then
//				adw_DestDW.SetItem(adw_DestDWCurrentRow,'Trax_Duty_Terms', '')
				adw_DestDW.SetItem(adw_DestDWCurrentRow,'TRAX_DUTY_TERMS', 'SHIPPERDUTYVAT')
				adw_DestDW.SetItem(adw_DestDWCurrentRow,'Trax_Duty_Acct_No', '')
			End If

			If UPPER(lsuf6) = 'RECIPIENT' Then
				adw_DestDW.SetItem(adw_DestDWCurrentRow,'TRAX_DUTY_TERMS', 'CONSIGNEEDUTYVAT')
				If NOT(IsNull(lsuf7) OR trim(lsuf7) = '') Then
					adw_DestDW.SetItem(adw_DestDWCurrentRow,'Trax_Duty_Acct_No', lsuf7)
				End If	
			End If

			If UPPER(lsuf6) = 'THIRD PARTY' Then
				adw_DestDW.SetItem(adw_DestDWCurrentRow,'TRAX_DUTY_TERMS', 'THIRDPARTYDUTYVAT')
				If NOT(IsNull(lsuf7) OR trim(lsuf7) = '') Then
					adw_DestDW.SetItem(adw_DestDWCurrentRow,'Trax_Duty_Acct_No', lsuf7)
				End If	
			End If
	

RETURN 0
end function

on u_nvo_proc_riverbed.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_nvo_proc_riverbed.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

