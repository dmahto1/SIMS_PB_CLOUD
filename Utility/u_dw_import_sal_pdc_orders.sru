HA$PBExportHeader$u_dw_import_sal_pdc_orders.sru
$PBExportComments$Satillo PDC (Outbound Orders) file
forward
global type u_dw_import_sal_pdc_orders from u_dw_import
end type
end forward

global type u_dw_import_sal_pdc_orders from u_dw_import
integer width = 3077
integer height = 1572
string dataobject = "d_import_sal_pdc_orders"
boolean border = false
borderstyle borderstyle = stylebox!
end type
global u_dw_import_sal_pdc_orders u_dw_import_sal_pdc_orders

type variables

Datastore	idsItem
end variables

forward prototypes
public function string wf_validate (long al_row)
public function integer wf_save ()
end prototypes

public function string wf_validate (long al_row);// 02/02 GPIEDRA - Validate PDC (Outbound Orders) layout for SALTILLO PDC 
String 	lsRowData, 	&
			lsData,		&
			lsSKU
integer 	llColPos
Long		llCount, llFindRow

	FOR llColPos = 1 to 32
		 
		If al_row = 1 and llColPos >= 3 then //Customer ID  must be present and valid*/
		
			lsRowData = 'Cust' + string(llColPos - 2)
			lsData = This.GetITemString(al_row,lsRowData)
			
			If len(lsData) < 1 or lsData = '' or IsNull (lsData) Then
				// do nothing  - should be a blank column
			else	
				Select Count(*) into :llCount
				From Customer
				Where project_id = :gs_Project and cust_code = :lsData;
				If llCount < 1 Then
					This.SetFocus()
					This.SetRow(al_row)
					This.SetColumn(llColPos)
					This.SelectText(1,50)
					return "'Customer # is Invalid."
				End if
				
			end if
			
		
		
		Elseif al_row <> 1 and llColPos = 1 then
			
			// 04/06 - PCONKL - Only need to pass thru SKU's once - skus loaded in ue_pre_validate for use here and in wf_update
			
			lsSku = Trim(This.GetItemString(al_row,"part_number")) /* GetPart Number*/  
			llFindRow = idsItem.Find("sku = '" + lsSKU + "'",1,idsItem.RowCount())
			
			If llFindRow < 1 Then
				This.SetFocus()
				This.SetRow(al_row)
				This.SetColumn(llColPos)
				This.SelectText(1,50)
				return "'SKU is Invalid."
			End if	
//			
//			lsData = This.GetITemString(al_row,'part_number') /* Part Number must be valid*/	
//			Select Count(*) into :llCount
//			From Customer, Item_Master
//			Where Customer.project_id = :gs_Project and Item_Master.SKU = :lsData;
//			If llCount < 1 Then
//					This.SetFocus()
//					This.SetRow(al_row)
//					This.SetColumn(llColPos)
//					This.SelectText(1,50)
//					return "'SKU # is Invalid."
//			End if	
			
		Elseif al_row <> 1 and  llColPos = 2	then // lsData = This.GetITemString(al_row,'onhand_qty')  
			
			//QTY on Hand  must be valid*/
			
		Elseif al_row <> 1 and  llColPos >= 3 then //Numeric order amount must be valid*/	
				
			lsRowData = 'Cust' + string(llColPos - 2)
			lsData = This.GetITemString(al_row,lsRowData)
			
			If len(lsData) >= 1 and Long(lsData) <= 0 Then
					This.SetFocus()
					This.SetRow(al_row)
					This.SetColumn(llColPos)
					This.SelectText(1,50)
						return "'Order amount must be numeric"
			End if
			
		End If
		
	NEXT

iscurrvalcolumn = ''
return ''

end function

public function integer wf_save ();Long	llColPos,	&
		llCol,		&
		llLineItem, &
		llDoNoLength, &
		llNew,		&
		llOwner,		&
		llQty, 		&		
		llRowCount,	&
		llRowPos,	&
		llNewRow,	&
		llFindRow,	&
		llheaderRow,	&
		llDetailRow
		
String 	lsRowData,  &
			lsAltSku, 	&
			lsCust,				&
				lsCustName, 	&
				lsAddr1,			&
				lsAddr2,			&
				lsAddr3,			&
				lsAddr4,			&
				lsCity,			&
				lsState,			&
				lsZip,			&
				lsCountry,		&
			lsDoNO,				&
			lsErrText,			&
			lsOrderNo,			&
			ls_pclass, 			&
			lsQty,				&
			lsSuppCode,			&
			lsSku,				&
			lsSQL, 				&
			ls_tcode,			&
			ls_tclass,			&
			lsSaveFile,			&
			lsCustOrderNo,		&
			lsOrdType,		&
			lsCarrier,		&
			lsSchedCode,		&
			lsSHipVia 

Decimal 	ld_price, 			&
			ld_tax,				& 
			ld_discount, 		&
			ldDoNo

Integer	liRC

Datastore	ldsDOMAster, ldsDODetail

//ldsItem = Create Datastore
//ldsItem.dataobject = 'd_maintenance_itemMAster'
//ldsItem.InsertRow(0) /*three is no item for the first row*/


ldsDOMAster = Create Datastore
ldsDOMAster.dataobject = 'd_do_master'
ldsDOMAster.SetTransObject(SQLCA)

ldsDODetail = Create Datastore
ldsDODetail.dataobject = 'd_do_Detail'
ldsDODetail.SetTransObject(SQLCA)

// pvh 02.15.06 - gmt
datetime ldtToday
ldtToday = f_getLocalWorldTime( gs_default_wh ) 

llRowPos = 1 
llRowCount = This.RowCount()
llNew = 0
llCol = 1

SetPointer(Hourglass!)

// Loop For each column in first row -  get the row data (Delivery Order Master in first row) 

//Execute Immediate "Begin Transaction" using SQLCA; /* 11/04 - PCONKL - Auto Commit Turned on to eliminate DB locks*/

For llColPos = 3 to 32  
	
  llLineItem = 1 // reset Detail Line Number
  lsCust = Trim(This.GetItemString(1,llColPos)) /* Get Customer Number */ 
  
  If lsCust <> '' then // do when customer exists
		
		w_main.SetmicroHelp("Saving Master Record for " + string(lsCust))
		
		//Get the next available DONO
		sqlca.sp_next_avail_seq_no(gs_project,"Delivery_Master","DO_No" ,lddONO) 
		lsDoNO = gs_Project + String(Long(ldDoNo),"0000000") 
		llDoNoLength = len(lsDoNO)
		lsOrderNo = mid(lsDoNO, (llDoNoLength - 6), llDoNoLength) //Get The Invoice Number - last 7 digits of lsDoNO 

		//03/06 - PCONKL - for GM_MI_DAT, prefix order # with cust code and a 'C'
		if gs_project = 'GM_MI_DAT' Then
			lsOrderNo = lsCust + 'C' + lsOrderNo
		End If
		
		/*create a new header*/            
		// Get Customer information, tax class, price class,  discount
		Select Cust_Name, address_1, address_2, address_3, address_4, city, state, zip, country, price_class, tax_class, discount
		Into	:lsCustName, :lsAddr1, :lsaddr2, :lsAddr3, :lsAddr4, :lsCity, :lsState, :lsZip, :lsCountry, :ls_pclass, :ls_tclass, :ld_discount
		From Customer
		Where Project_id = :gs_project and Cust_code = :lsCust;
		
		If IsNull(ld_discount) Then ld_discount = 0
		
		// 03/06 - PCONKL - GM_MI_DAT defaulting fields differently than Monterray//Saltillo
		If gs_project = 'GM_MI_DAT' Then
			
			lsCustOrderNo = ""
			lsOrdType = 'C' /*Consignment*/
			lsCarrier = "SCHN"
			lsSchedCode = ""
			lsSHipVia = ""
		Else
			
			lsCustOrderNo = "TERRESTRE"
			lsOrdType = 'S'
			lsCarrier = "TUM"
			lsSchedCode = "SECOND DAY"
			lsShipVia = "LAND"
			
		End If
		
		/*Insert a new Delivery Master Record*/	
		lsSaveFile = Right(w_import.isImportFile,30) /* 08/02 - PConkl - we are only saving the right most 30 cahr to maintain uniqueness for large file names */
		
//		Insert Into Delivery_Master (Do_no, Project_id,Ord_date,Ord_status,Ord_Type,Inventory_type,Cust_Order_No,
//						Cust_code, Cust_Name, Address_1, Address_2, Address_3, Address_4, City, State, Zip, Country,
//						wh_code,Ship_Via, Invoice_No,Carrier,Freight_Terms,Freight_Cost,User_Field1,LAst_user,LASt_Update, User_Field8 )
//		Values (:lsDONO,:gs_project,:ldtToday,'N',:lsOrdType,'N',:lsCustOrderNo,
//					:lsCust, :lsCustName, :lsAddr1, :lsAddr2, :lsAddr3, :lsAddr4, :lsCity, :lsState, :lsZip, :lsCountry,
//					:gs_default_wh,:lsShipVia,:lsOrderNo,:lsCarrier,'PREPAID',0,:lsSchedCode,:gs_userid,:ldtToday,:lsSaveFile)
//		Using SQLCA;

		llHeaderRow = ldsDOmaster.InsertRow(0)
		ldsDOMAster.SetITem(llheaderRow,'do_no',lsDONO)
		ldsDOMAster.SetITem(llheaderRow,'Project_id',gs_project)
		ldsDOMAster.SetITem(llheaderRow,'Ord_date',ldtToday)
		ldsDOMAster.SetITem(llheaderRow,'Ord_status',"N")
		ldsDOMAster.SetITem(llheaderRow,'Ord_Type',lsOrdType)
		ldsDOMAster.SetITem(llheaderRow,'Inventory_type',"N")
		ldsDOMAster.SetITem(llheaderRow,'Cust_Order_No',lsCustOrderNo)
		ldsDOMAster.SetITem(llheaderRow,'Cust_code',lsCust)
		ldsDOMAster.SetITem(llheaderRow,'Cust_Name',lsCustName)
		ldsDOMAster.SetITem(llheaderRow,'Address_1',lsAddr1)
		ldsDOMAster.SetITem(llheaderRow,'Address_2',lsAddr2)
		ldsDOMAster.SetITem(llheaderRow,'Address_3',lsAddr3)
		ldsDOMAster.SetITem(llheaderRow,'Address_4',lsAddr4)
		ldsDOMAster.SetITem(llheaderRow,'City',lsCity)
		ldsDOMAster.SetITem(llheaderRow,'State',lsState)
		ldsDOMAster.SetITem(llheaderRow,'Zip',lsZip)
		ldsDOMAster.SetITem(llheaderRow,'Country',lsCountry)
		ldsDOMAster.SetITem(llheaderRow,'wh_code',gs_default_wh)
		ldsDOMAster.SetITem(llheaderRow,'Ship_Via',lsShipVia)
		ldsDOMAster.SetITem(llheaderRow,'Invoice_No',lsOrderNo)
		ldsDOMAster.SetITem(llheaderRow,'Carrier',lsCarrier)
		ldsDOMAster.SetITem(llheaderRow,'Freight_Terms','PREPAID')
		ldsDOMAster.SetITem(llheaderRow,'Freight_Cost',0)
		ldsDOMAster.SetITem(llheaderRow,'User_Field1',lsSchedCode)
		ldsDOMAster.SetITem(llheaderRow,'LAst_user',gs_userid)
		ldsDOMAster.SetITem(llheaderRow,'LASt_Update',ldtToday)
		ldsDOMAster.SetITem(llheaderRow,'User_Field8',lsSaveFile)
		
		
//		If sqlca.sqlcode <> 0 Then
//			lsErrText = sqlca.sqlerrtext /*text will be lost after rollback*/
//			Execute Immediate "ROLLBACK" using SQLCA;
//			Messagebox("Import","Error saving Row: " + String(llRowPos) + " Unable to save new Delivery Master record to database!~r~r" + lsErrText)
//			SetPointer(Arrow!)
//			Return -1
//		else
			llNew ++
//		End If	

		// Loop and Read all rows for each customer and add Delivery detail records when qty is more than zero 
		For llRowPos = 2 to llRowCount   

			w_main.SetmicroHelp("Saving Row " + string(llRowPos) + " of " + string(llRowCount)+ " for Customer:"  + string(lsCust))
	
			lsRowData = "Cust" + string(llColPos - 2)
			llQty = Long(Trim(This.GetItemString(llRowPos,lsRowData))) 	//Get Qty amount
				
			IF llQty > 0 then  
		
				lsSku = Trim(This.GetItemString(llRowPos,"part_number")) /* GetPart Number*/  
						
				llFindRow = idsItem.Find("sku = '" + lsSKU + "'",1,idsItem.RowCount())
				
				If lLFindRow > 0 Then
					
					lsAltSku = idsItem.GetITEmString(lLFindRow,'alternate_sku')
					lsSuppCode = idsItem.GetITEmString(lLFindRow,'supp_code')
					llOwner = idsItem.GetITEmNumber(lLFindRow,'Owner_ID')
					

				Else /*Item not found, don't create detail*/
					
					Messagebox("Import","Error saving Row: " + String(llRowPos) + " Item master record not found.~r~rNo changes made to database.")
					SetPointer(Arrow!)
					Return -1
//					
//					//Get the ALternate SKU (GMPD # for this SKU) & Supplier code &  Owner ID
//					Select Alternate_sku, Supp_code, Owner_ID
//					Into	:lsAltSku, :lsSuppCode, :llOwner
//					From Item_MAster
//					Where Project_id = :gs_project and sku = :lsSku;
//					
//					If isnull(lsAltSku) or lsAltSku = '' Then lsAltSku = lsSku
//					
//					llNewRow = ldsItem.InsertRow(0)
//					ldsItem.SetItem(llNewRow,'sku', lsSKU)
//					ldsItem.SetItem(llNewRow,'alternate_sku', lsAltSKU)
//					ldsItem.SetItem(llNewRow,'supp_Code', lsSuppCode)
//					ldsItem.SetItem(llNewRow,'owner_id', llOwner)
			
				End If
							
				// Get Price and tax
				If gs_Project = 'GM_MI_DAT' Then
				
					ld_price = 0
					ld_tax = 0
				
				Else
				
					SELECT Price_Master.Price_1,   
						(IsNull(Tax_Master.Tax_1,0) + IsNull(Tax_Master.Tax_2,0) +    
						IsNull(Tax_Master.Tax_3,0) + IsNull(Tax_Master.Tax_4,0) +    
						IsNull(Tax_Master.Tax_5,0)) Into :ld_price, :ld_tax     
					FROM Item_Master
				   INNER JOIN Price_Master
					  ON Item_Master.Project_ID = Price_Master.Project_ID 
					 AND Item_Master.SKU = Price_Master.SKU   
					 AND Item_Master.Supp_code = Price_Master.Supp_code 
					LEFT OUTER JOIN Tax_Master  
					  ON Item_Master.Tax_Code = Tax_Master.Tax_Code
					WHERE ( ( Price_Master.Project_ID = :gs_project ) AND  
						( Price_Master.SKU = :lsSku ) AND  
						( Price_Master.Supp_code = :lsSuppCode ) AND
						( Price_Master.Price_Class = :ls_pclass ) AND  
						( Tax_Master.Tax_Class = :ls_tclass )) ;
					If sqlca.sqlcode = 0 Then
						ld_price = ld_price * (1 - ld_discount)
						// ld_tax = ?
					End If
					
				End If
			
				llDetailRow = ldsDODetail.InsertRow(0)
				ldsDODetail.SetITem(lLDetailRow,"do_no", lsdoNo)
				ldsDODetail.SetITem(lLDetailRow,"sku", lsSKU)
				ldsDODetail.SetITem(lLDetailRow,"supp_code", lsSuppCode)
				ldsDODetail.SetITem(lLDetailRow,"Owner_id", llOwner)
				ldsDODetail.SetITem(lLDetailRow,"Alternate_sku", lsAltSKU)
				ldsDODetail.SetITem(lLDetailRow,"req_qty", llQty)
				ldsDODetail.SetITem(lLDetailRow,"alloc_qty", 0)
				ldsDODetail.SetITem(lLDetailRow,"uom", 'EA')
				ldsDODetail.SetITem(lLDetailRow,"price", ld_price)
				ldsDODetail.SetITem(lLDetailRow,"cost",0)
				ldsDODetail.SetITem(lLDetailRow,"tax", ld_tax)
				ldsDODetail.SetITem(lLDetailRow,"line_Item_no", llLineItem)
				
//				//Insert the Delivery DEtail Record
//				Insert Into Delivery_Detail (do_no, sku, supp_code, Owner_id, Alternate_sku, req_qty, alloc_qty, uom, price, cost, tax, line_Item_no)
//				Values							(:lsdoNo, :lsSKU,:lsSuppCode, :llOwner, :lsAltSKU, :llQty, 0,  'EA', :ld_price, 0, :ld_tax, :llLineItem) 
//				Using SQLCA;
//	
//				If sqlca.sqlcode <> 0 Then
//					lsErrText = sqlca.sqlerrtext /*text will be lost after rollback*/
//					Execute Immediate "ROLLBACK" using SQLCA;
//					Messagebox("Import","Error saving Row: " + String(llRowPos) + " Unable to save new Delivery Detail record to database!~r~r" + lsErrText)
//					SetPointer(Arrow!)
//					Return -1
//				else
					llLineItem ++
//				End If
			
			End If	/*Qty > 0*/
		
		Next /*Next Import Row*/
		
	end if
	
Next /*Next Import Column*/

//save changes to DB
Execute Immediate "Begin Transaction" using SQLCA; /* 11/04 - PCONKL - Auto Commit Turned on to eliminate DB locks*/

w_main.SetmicroHelp("Updating Database...")

liRC = ldsDOMaster.Update()

If liRC = 1 then
	liRC = ldsDODetail.Update()
End If

If liRC = 1 Then
	Execute Immediate "COMMIT" using SQLCA;
	If sqlca.sqlcode <> 0 Then
		MessageBox("Import","Unable to Commit changes! No changes made to Database!")
		Return -1
	End If
Else
	lsErrText = sqlca.sqlerrtext /*text will be lost after rollback*/
	Execute Immediate "ROLLBACK" using SQLCA;
	Messagebox("Import","Error saving Row: " + String(llRowPos) + " Unable to save new Delivery Detail record to database!~r~r" + lsErrText)
	SetPointer(Arrow!)
	Return -1
End If

MessageBox("Import","Records saved.~r~rDelivery Orders Added : " + String(llNew))
w_main.SetmicroHelp("Ready")
SetPointer(Arrow!)
Return 0

end function

on u_dw_import_sal_pdc_orders.create
call super::create
end on

on u_dw_import_sal_pdc_orders.destroy
call super::destroy
end on

event ue_pre_validate;call super::ue_pre_validate;
Long	llRowPos, llRowCount, llFindRow, llOwner, llNewRow
String	lsSKU, lsAltSku, lsSuppCode

If not isvalid(idsItem) Then
	idsItem = Create Datastore
	idsItem.dataobject = 'd_maintenance_itemMAster'
End If

//Loop thru Items and preload into DS
lLRowCount = This.RowCount()
For llRowPOs = 1 to llRowCount
	
	w_main.SetMicroHelp("Retrieving ItemMaster information for row: " + String(lLRowPos))
	
	lsSku = Trim(This.GetItemString(llRowPos,"part_number")) /* GetPart Number*/  
						
	llFindRow = idsItem.Find("sku = '" + lsSKU + "'",1,idsItem.RowCount())
				
	If llFindRow <= 0 Then /*first time sku is being loaded*/
					
		//Get the ALternate SKU (GMPD # for this SKU) & Supplier code &  Owner ID
		Select min(Alternate_sku), min(Supp_code), min(Owner_ID)
		Into	:lsAltSku, :lsSuppCode, :llOwner
		From Item_MAster
		Where Project_id = :gs_project and sku = :lsSku;
					
		If isnull(lsSuppCode) or lsSuppCode = '' Then Continue /* if no supplier, then no item master was retrieved*/
		
		If isnull(lsAltSku) or lsAltSku = '' Then lsAltSku = lsSku
					
		llNewRow = idsItem.InsertRow(0)
		idsItem.SetItem(llNewRow,'sku', lsSKU)
		idsItem.SetItem(llNewRow,'alternate_sku', lsAltSKU)
		idsItem.SetItem(llNewRow,'supp_Code', lsSuppCode)
		idsItem.SetItem(llNewRow,'owner_id', llOwner)
			
	End If
	
Next

w_main.SetMicroHelp("Ready")

Return 0
end event

