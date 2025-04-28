$PBExportHeader$u_dw_import_ws_so.sru
$PBExportComments$Import Wine and Spirit SO
forward
global type u_dw_import_ws_so from u_dw_import
end type
end forward

global type u_dw_import_ws_so from u_dw_import
integer width = 3077
integer height = 1572
string dataobject = "d_import_ws_so"
end type
global u_dw_import_ws_so u_dw_import_ws_so

type variables
String is_bonded_wh, isskuHold
end variables

forward prototypes
public function string wf_validate (long al_row)
public function integer wf_save ()
end prototypes

public function string wf_validate (long al_row);
String	lsSKU, lsWarehouse, lsOrderNo, lsSupplier, lsUom_1, lsUom_2, lsUOM, lstemp
Long		llCount

// validate warehouse code
lswarehouse = Trim(This.getItemString(al_row,"wh_code"))

If isnull(lswarehouse) Then
	This.Setfocus()
	This.SetColumn("wh_code")
	iscurrvalcolumn = "wh_code"
	return "'Warehouse Not Found!"
End If

Select COUNT(*), wh_type
Into	:llCount, :is_bonded_wh
FRom warehouse
Where wh_Code = :lswarehouse
Group By wh_type;
		
If llCount <= 0 Then
	This.Setfocus()
	This.SetColumn("wh_code")
	iscurrvalcolumn = "wh_code"
	return "'Invalid Warehouse"
End If


//SKU and Supplier must be set up in item master
lssku = trim( this.object.SKU[ al_row ] )

If isnull(lsSKU) Then
	This.Setfocus()
	This.SetColumn("sku")
	iscurrvalcolumn = "sku"
	return "SKU can not be null!"
Else
	lsSupplier = This.getItemString(al_row,"supplier")
	llcount=0
	Select COUNT(*), Uom_1, Uom_2
	Into	:llCount, :lsUom_1, :lsUom_2
	FRom Item_Master
	Where Project_id = :gs_Project and sku = :lsSKU and supp_code = :lsSupplier
	Group By Uom_1, Uom_2;
	
	If llCount <= 0 Then
		This.Setfocus()
		This.SetColumn("sku")
		iscurrvalcolumn = "sku"
		return "'Invalid SKU"
	End If
End If

//Validate UOM
lsuom = This.getItemString(al_row,"req_uom")
If  isnull(lsuom) or lsuom = ' ' Then
	This.Setfocus()
	This.SetColumn("req_uom")
	iscurrvalcolumn = "req_uom"
	Return "UOM is required!"
Else

	If lsUom <> lsUOM_1 and lsuom <> lsUOM_2 Then
		This.Setfocus()
		This.SetColumn("req_uom")
		iscurrvalcolumn = "req_uom"
		Return "UOM is not valid!"
	End If
		
End If /*UOM Validate*/

//Schedule date Must be a A Date
lsTEMP = This.getItemString(al_row, "schedule_date")
If not isnull(lsTEMP) and not isdate(lsTEMP) Then
	This.Setfocus()
	This.SetColumn("schedule_date")
	iscurrvalcolumn = "schedule_date"
	return "'Scheduled Date' must be a date!"
End If

//Order date Must be a A Date
lsTEMP = This.getItemString(al_row, "order_date")
If not isnull(lsTEMP) and not isdate(lsTEMP) Then
	This.Setfocus()
	This.SetColumn("order_date")
	iscurrvalcolumn = "order_date"
	return "'Order Date' must be a date!"
End If

return ''

end function

public function integer wf_save ();
Long	llRowCount,	llRowPos, llOrdqty, llNewDetail,llOwnerID, llLineItem,	&
		llqty2, llReqQTY, llUserLineItem, llHeaderRow, llDetailRow, llnew
	
Integer lirc

String	lsErrText, lsDONO, lsSKU, lsPickLot,  &
			lsSupplier, lsOrderNo,  lsWarehouse, lsOwnerCd, lsCOO, lsUOM1, lsUOM2, lslocCode, lsReqUOM, lsOrdUOM, lsReqQTY, lsOrdQTY, lsHSCode, &
			lsPackSize, lsVolume, lsshp_rep, lsInvType,lsOrder_Type, lsCustCd, lsCust_Order_No, lsCarrier,lsFreight_terms, lsUF2, lsUF3, lsUF4, lsUF5, lsUF6, lsUF7, lsUF8, lsUF9, lsUF10, &
			lsCust_Name, lsCust_Add1, lsCust_Add2, lsCust_Add3, lsCust_Add4, lsCust_City, lsCust_State, lsCust_Zip, lsCust_Country, lsContact_Person, lsRemarks, lsTel, lsinventory_type, &
			lsAlt_Sku, lsDtl_UF3, lsPick_Lot, lssavefile, lsShip_Ref_No
			
DateTime ldtScheduled_Date, ldtExpiration_Date, ldtOrd_Date 
			
Decimal	ldDONo
			
DateTime		ldToday


u_ds	ldsDOMAster, ldsDODetail

ldsDOMAster = Create u_ds
ldsDOMAster.dataobject = 'd_do_master'
ldsDOMAster.SetTransObject(SQLCA)

ldsDODetail = Create u_ds
ldsDODetail.dataobject = 'd_do_Detail'
ldsDODetail.SetTransObject(SQLCA)


llNew = 0
llLineItem = 1 // reset Detail Line Number

llRowCount = This.RowCount()
If llRowCount <= 0 Then Return 0



// pvh 02.15.06 - gmt
ldToday = f_getLocalWorldTime( lsWarehouse ) 


For llRowPos = 1 to this.RowCount()  


	SetPointer(Hourglass!)

	//If Customer Order Changes create a new order 

	IF trim(lsCust_Order_No) <>  Trim(This.GetItemString(llRowPos,"cust_order_no")) THEN
		lsCust_Order_No = This.GetItemString(llRowPos,'cust_order_no')
		llLineItem = 1 // reset Detail Line Number

		lsWarehouse = This.GetItemString(llRowPos,'wh_code')
		lsOrder_Type = This.GetItemString(llRowPos,'order_type')
		lsSupplier = This.GetItemString(llRowPos,'Supplier')
		lsinventory_type = This.GetItemString(llRowPos,'Inventory_Type')
		lsCustCd = This.GetItemString(llRowPos,'cust_code')
		lsCust_Order_No = This.GetItemString(llRowPos,'cust_order_no')
		lsShip_Ref_No = This.GetItemString(llRowPos,'ship_ref_no')
		lsCarrier = This.GetItemString(llRowPos,'carrier')
		lsFreight_terms = This.GetItemString(llRowPos,'freight_terms')
		lsUF2 = This.GetItemString(llRowPos,'user_field2')
		lsUF3 = This.GetItemString(llRowPos,'user_field3')
		lsUF4 = This.GetItemString(llRowPos,'user_field4')
		lsUF5 = This.GetItemString(llRowPos,'user_field5')
		lsUF6 = This.GetItemString(llRowPos,'user_field6')
		lsUF7 = This.GetItemString(llRowPos,'user_field7')
		lsUF8 = This.GetItemString(llRowPos,'user_field8')
		lsUF9 = This.GetItemString(llRowPos,'user_field9')
		lsUF10 = This.GetItemString(llRowPos,'user_field10')
		lsCust_Name = This.GetItemString(llRowPos,'cust_name')
		lsCust_Add1 = This.GetItemString(llRowPos,'cust_addr1')
		lsCust_Add2 = This.GetItemString(llRowPos,'cust_addr2')
		lsCust_Add3 = This.GetItemString(llRowPos,'cust_addr3')
		lsCust_Add4 = This.GetItemString(llRowPos,'cust_addr4')
		lsCust_City = This.GetItemString(llRowPos,'cust_city')
		lsCust_State = This.GetItemString(llRowPos,'cust_state')
		lsCust_Country = This.GetItemString(llRowPos,'cust_country')
		lsCust_Zip = This.GetItemString(llRowPos,'cust_zip')
		lsContact_Person = This.GetItemString(llRowPos,'contact_person')
		lsTel = This.GetItemString(llRowPos,'tel')
		lsRemarks = This.GetItemString(llRowPos,'remarks')

		string lssceddt
		lssceddt =  string(This.GetItemString(llRowPos,'schedule_date'), 'YYYYMMDD')
		If not isnull(This.GetItemString(llRowPos,'schedule_date'))  Then
			ldtScheduled_Date = DateTime(Date(This.GetItemString(llRowPos,'schedule_date')), time('00:00:00'))
		Else
			ldtScheduled_Date = DateTime(Date('1900/01/01'), time('00:00:00')) 
		End If

		If not isnull(This.GetItemString(llRowPos,'order_date'))  Then
			ldtOrd_Date = DateTime(Date(This.GetItemString(llRowPos,'order_date')), time('00:00:00'))
		Else
			ldtOrd_Date = ldToday
		End If


	//Get the default owner 
		Select Owner_ID into :llOwnerID
		From OWner
		Where PRoject_id = :gs_Project and Owner_CD = :lsOwnerCd and OWner_type = 'S';

	//Get the next available RONO
		sqlca.sp_next_avail_seq_no(gs_project,"Delivery_Master","DO_No" ,ldDONO)//get the next available DO_NO
		lsDoNO = gs_Project + String(Long(ldDoNo),"000000") 


	//TAM - W&S 2010/12  -   Order Number is Formatted.  We will not allow entry into this field.  
	//Format is (WH_CODE(3rd and 4TH Char)) + "S" + (Year(2 digit)) + (Month(2 Digit)) + (4 Digit Running number from Lookup table) 
	// New Baseline.  If the Supplier Invoice code is Not specified as Supplier specific it will return 'NA' and behave like it use to
	//Left 3 characters = WS- for Wine and Spirt.
		lsOrderNo =  Mid(gs_project,4,2) + '-S' + String(Today,'YYMM') + String(ldDONO,"0000")

		
		//Cust Name	
	
		SELECT Cust_Name
		INTO :lsCust_Name
		FROM Customer WHERE Upper(Cust_Code) = :lsCustCd   AND project_id = :gs_project  USING SQLCA;
			
		IF SQLCA.SQLCode = 100 THEN
			MessageBox ("Error", "Customer Cd: " + lsCustCd + " not found in the Customer table.")
			RETURN -1
		END IF
			
		IF SQLCA.SQLCode < 0 THEN
			MessageBox ("Error - Customer Cd -" + lsCustCd, SQLCA.SQLErrText)
			RETURN -1
		END IF

		/*Insert a new Delivery Master Record*/	
		lsSaveFile = Right(w_import.isImportFile,30) /* 08/02 - PConkl - we are only saving the right most 30 cahr to maintain uniqueness for large file names */
			
		llHeaderRow = ldsDOmaster.InsertRow(0)
		ldsDOMAster.SetITem(llheaderRow,'do_no',lsDONO)
		ldsDOMAster.SetITem(llheaderRow,'Project_id',gs_project)
		ldsDOMAster.SetITem(llheaderRow,'Ord_date',ldtord_date)
		ldsDOMAster.SetITem(llheaderRow,'Schedule_Date',ldtScheduled_Date)
		ldsDOMAster.SetITem(llheaderRow,'cust_order_no', lsCust_Order_No)	
		ldsDOMAster.SetITem(llheaderRow,'wh_code',lsWarehouse)
		ldsDOMAster.SetITem(llheaderRow,'Ord_status','N')
		ldsDOMAster.SetITem(llheaderRow,'Ord_Type','S')
		ldsDOMAster.SetITem(llheaderRow,'Inventory_type',lsInventory_Type)
		ldsDOMAster.SetITem(llheaderRow,'Invoice_No',lsOrderNo)
		ldsDOMAster.SetITem(llheaderRow,'Cust_code',lsCustCd)
		ldsDOMAster.SetITem(llheaderRow,'Cust_Name',lsCust_Name)
		ldsDOMAster.SetITem(llheaderRow,'Address_1',lsCust_Add1)
		ldsDOMAster.SetITem(llheaderRow,'Address_2',lsCust_Add2)
		ldsDOMAster.SetITem(llheaderRow,'Address_3',lsCust_Add3)
		ldsDOMAster.SetITem(llheaderRow,'Address_4',lsCust_Add4)
		ldsDOMAster.SetITem(llheaderRow,'City',lsCust_City)
		ldsDOMAster.SetITem(llheaderRow,'State',lsCust_State)
		ldsDOMAster.SetITem(llheaderRow,'Zip',lsCust_Zip)
		ldsDOMAster.SetITem(llheaderRow,'Country',lsCust_Country)
		ldsDOMAster.SetITem(llheaderRow,'Contact_Person',lsContact_Person)
		ldsDOMAster.SetITem(llheaderRow,'Tel',lsTel)
		ldsDOMAster.SetITem(llheaderRow,'LAst_user',gs_userid)
		ldsDOMAster.SetITem(llheaderRow,'LASt_Update',ldToday)
		ldsDOMAster.SetITem(llheaderRow,'Carrier',lsCarrier)
		ldsDOMAster.SetITem(llheaderRow,'freight_terms',lsFreight_terms)
		ldsDOMAster.SetITem(llheaderRow,'User_Field2',lsUf2)
		ldsDOMAster.SetITem(llheaderRow,'User_Field3',lsUf3)
		ldsDOMAster.SetITem(llheaderRow,'User_Field4',lsUf4)
		ldsDOMAster.SetITem(llheaderRow,'User_Field5',lsUf5)
//		ldsDOMAster.SetITem(llheaderRow,'User_Field6',lsUf6)
		ldsDOMAster.SetITem(llheaderRow,'Ship_Ref',lsShip_Ref_No)
		ldsDOMAster.SetITem(llheaderRow,'User_Field7',lsUf7)
		ldsDOMAster.SetITem(llheaderRow,'User_Field8',lsUf8)
		ldsDOMAster.SetITem(llheaderRow,'User_Field9',lsUf9)
		ldsDOMAster.SetITem(llheaderRow,'User_Field10',lsUf10)
		ldsDOMAster.SetITem(llheaderRow,'Remark',lsremarks)
		llNew ++

//lsSupplier = This.GetItemString(llRowPos,'Supplier')

	End If  // End New Header Customer Name Change

//Detail  Record
	
	w_main.SetmicroHelp("Saving Row " + string(llRowPos) + " of " + string(llRowCount))
		

	lsSKU = Upper(left(trim(This.GetItemString(llRowPos,"SKU")),50))
	lsSupplier = Upper(left(trim(This.GetItemString(1,'supplier')),50))
	lsOrdQty = Upper(left(trim(This.GetItemString(llRowPos,"req_qty")),100))
	llOrdQty = dec(Upper(left(trim(This.GetItemString(llRowPos,"req_qty")),100)))
	lsOrdUOM = Upper(left(trim(This.GetItemString(llRowPos,"req_uom")),100))
	lsDtl_UF3 = Upper(left(trim(This.GetItemString(llRowPos,"ship_ref_no")),100))
	lsPick_Lot = Upper(left(trim(This.GetItemString(llRowPos,"lot_No")),100))
	lsInvType = Upper(left(trim(This.GetItemString(llRowPos,"inventory_type")),1))
	
	
//	//Get the Values from Item Master
	Select Alternate_Sku, UOM_1, UOM_2, QTY_2, HS_Code, User_Field11 
	into :lsAlt_Sku, :lsUOM1, :lsUOM2, :llqty2, :lsHSCode, :lsPackSize
	From Item_Master
	Where PRoject_id = :gs_Project and SKU = :lsSKU and Supp_code = :lssupplier;
		
//  Calculate Quantity by checking UOM = UOM_2 from Item Master
		If lsUOM2 = lsOrdUOM Then 
			llReqQTY = llOrdQty*llqty2
			lsReqUOM = lsUOM1
		Else
			llReqQTY = llordQty
			lsReqUOM = lsUOM1
		End If

//Get the default owner 
Select Owner_ID into :llOwnerID
From OWner
Where PRoject_id = :gs_Project and Owner_CD = :lsSupplier and OWner_type = 'S';
	
// Non Bonded Warehouse defaults lot No to "DP"  
	If is_bonded_wh = 'B'Then
		lsPick_Lot = Upper(left(trim(This.GetItemString(llRowPos,"lot_no")),20))
	Else
		lsPickLot = 'DP'
		lsDtl_UF3 = 'DP' //TAM 04/29/2011 - Default UF3(PERMIT NUMBER) to DP on Non Bonded Warehouse
	End If 	

	

	// write the  Detail Record.
			llDetailRow = ldsDODetail.InsertRow(0)
			ldsDODetail.SetITem(llDetailRow,"do_no", lsdoNo)
			ldsDODetail.SetITem(lLDetailRow,"sku", lsSKU)
			ldsDODetail.SetITem(lLDetailRow,"supp_code", lsSupplier)
			ldsDODetail.SetITem(lLDetailRow,"Owner_id", llOwnerID)
			ldsDODetail.SetITem(lLDetailRow,"Alternate_sku", lsSKU)
			ldsDODetail.SetITem(lLDetailRow,"req_qty", llReqQty)
			ldsDODetail.SetITem(lLDetailRow,"uom", lsReqUOM)
			ldsDODetail.SetITem(lLDetailRow,"alloc_qty", 0)
			ldsDODetail.SetITem(lLDetailRow,"User_Field1", lsOrdQTY)
			ldsDODetail.SetITem(lLDetailRow,"User_Field2", lsOrdUOM)
			ldsDODetail.SetITem(lLDetailRow,"User_Field3", lsDtl_UF3) //TAM 04/29/2011 - Default UF3(PERMIT NUMBER) to DP on Non Bonded Warehouse
			ldsDODetail.SetITem(lLDetailRow,"User_Field5", lsHSCode)
			ldsDODetail.SetITem(lLDetailRow,"User_Field7", lsPackSize)
			ldsDODetail.SetITem(lLDetailRow,"Pick_Lot_No", lsPick_Lot)
			ldsDODetail.SetITem(lLDetailRow,"cost",0)
			ldsDODetail.SetITem(lLDetailRow,"line_Item_no", llLineItem)
			llLineItem ++
Next /*Import Row */


//save changes to DB
Execute Immediate "Begin Transaction" using SQLCA; 


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


//llNewDetail = 0
//llLineItem = 1
//
//llRowCount = This.RowCount()
//If llRowCount <= 0 Then Return 0
//
//lsWarehouse = This.GetItemString(1,'wh_code')
//lsOrder_Type = This.GetItemString(1,'order_type')
//lsSupplier = This.GetItemString(1,'Supplier')
//lsinventory_type = This.GetItemString(1,'Inventory_Type')
//lsCustCd = This.GetItemString(1,'cust_code')
//lsCust_Order_No = This.GetItemString(1,'cust_order_no')
//lsCarrier = This.GetItemString(1,'carrier')
//lsFreight_terms = This.GetItemString(1,'freight_terms')
//lsUF2 = This.GetItemString(1,'user_field2')
//lsUF3 = This.GetItemString(1,'user_field3')
//lsUF4 = This.GetItemString(1,'user_field4')
//lsUF5 = This.GetItemString(1,'user_field5')
//lsUF6 = This.GetItemString(1,'user_field6')
//lsUF7 = This.GetItemString(1,'user_field7')
//lsUF8 = This.GetItemString(1,'user_field8')
//lsUF9 = This.GetItemString(1,'user_field9')
//lsUF10 = This.GetItemString(1,'user_field10')
//lsCust_Name = This.GetItemString(1,'cust_name')
//lsCust_Add1 = This.GetItemString(1,'cust_addr1')
//lsCust_Add2 = This.GetItemString(1,'cust_addr2')
//lsCust_Add3 = This.GetItemString(1,'cust_addr3')
//lsCust_Add4 = This.GetItemString(1,'cust_addr4')
//lsCust_City = This.GetItemString(1,'cust_city')
//lsCust_State = This.GetItemString(1,'cust_state')
//lsCust_Country = This.GetItemString(1,'cust_country')
//lsCust_Zip = This.GetItemString(1,'cust_zip')
//lsContact_Person = This.GetItemString(1,'contact_person')
//lsTel = This.GetItemString(1,'tel')
//lsRemarks = This.GetItemString(1,'remarks')
//
//string lssceddt
//lssceddt =  string(This.GetItemString(1,'schedule_date'), 'YYYYMMDD')
//If not isnull(This.GetItemString(1,'schedule_date'))  Then
////	ldtScheduled_Date = DateTime(Date(String(This.GetItemString(1,'scheduled_date'), 'YYYYMMDD')), time('00:00:00'))
//	ldtScheduled_Date = DateTime(Date(This.GetItemString(1,'schedule_date')), time('00:00:00'))
//Else
//	ldtScheduled_Date = DateTime(Date('1900/01/01'), time('00:00:00')) 
//	
//End If
//
//// pvh 02.15.06 - gmt
//ldToday = f_getLocalWorldTime( lsWarehouse ) 
//
//If not isnull(This.GetItemString(1,'order_date'))  Then
////	ldtOrd_Date = DateTime(Date(String(This.GetItemString(1,'order_date'), 'YYYY/MM/DD')), time('00:00:00'))
//	ldtOrd_Date = DateTime(Date(This.GetItemString(1,'order_date')), time('00:00:00'))
//Else
//	ldtOrd_Date = ldToday
//End If
//
//SetPointer(Hourglass!)
//
////Get the default owner 
//Select Owner_ID into :llOwnerID
//From OWner
//Where PRoject_id = :gs_Project and Owner_CD = :lsOwnerCd and OWner_type = 'S';
//
////Get the next available RONO
//sqlca.sp_next_avail_seq_no(gs_project,"Delivery_Master","DO_No" ,ldDONO)//get the next available DO_NO
//lsDoNO = gs_Project + String(Long(ldDoNo),"000000") 
//
//
////TAM - W&S 2010/12  -   Order Number is Formatted.  We will not allow entry into this field.  
////Format is (WH_CODE(3rd and 4TH Char)) + "S" + (Year(2 digit)) + (Month(2 Digit)) + (4 Digit Running number from Lookup table) 
//// New Baseline.  If the Supplier Invoice code is Not specified as Supplier specific it will return 'NA' and behave like it use to
////Left 3 characters = WS- for Wine and Spirt.
//lsOrderNo =  Mid(gs_project,4,2) + '-S' + String(Today,'YYMM') + String(ldDONO,"0000")
//	
//
//
//Execute Immediate "Begin Transaction" using SQLCA; /* 11/04 - PCONKL - Auto Commit Turned on to eliminate DB locks*/
//
////Create the Delivery Master Record - Only one order per import file
//Insert Into Delivery_Master (DO_No, Project_ID,  Ord_Type, Invoice_No, Request_Date, Schedule_Date, Ord_Status, WH_Code, Inventory_Type, Cust_Order_No, Cust_Code, 
//			Carrier, Freight_Terms, User_Field2, User_Field3, User_Field4, User_Field5, User_Field6, User_Field7, User_Field8, User_Field9, User_Field10, 
//			Cust_Name,  Address_1, Address_2, Address_3, Address_4, City, State, Country, Zip, Contact_Person, Tel, Remark, Freight_Cost)
//		Values	(:lsDONO, :gs_Project, :lsOrder_Type , :lsOrderNo, :ldtOrd_Date, :ldtScheduled_Date, 'N', :lsWarehouse , :lsInventory_Type,  :lsCust_Order_No , :lsCustCd , 
//			:lsCarrier , :lsFreight_terms , :lsUF2 , :lsUF3 ,:lsUF4 ,:lsUF5 ,:lsUF6 ,:lsUF7 ,:lsUF8 ,:lsUF9 ,:lsUF10 ,
//			:lsCust_Name ,:lsCust_Add1 ,:lsCust_Add2 ,:lsCust_Add3 ,:lsCust_Add4 ,:lsCust_City ,:lsCust_State ,:lsCust_Country ,:lsCust_Zip ,:lsContact_Person ,:lsTel ,:lsRemarks, 0)
//Using SQLCA;
//
//If sqlca.sqlcode <> 0 Then
//	This.SetRow(llRowPos)
//	This.ScrollToRow(llRowPos)
//	lsErrText = sqlca.sqlerrtext /*error text lost in rollback*/
//	Execute Immediate "ROLLBACK" using SQLCA;
//	Messagebox("Import","Unable to Save new Delivery Order header Record to Database.~r~r" + lsErrtext)
//	SetPointer(Arrow!)
//	Return -1
//End If
//
////For Each Record
//For llRowPos = 1 to llRowCOunt
//	
//	w_main.SetmicroHelp("Saving Row " + string(llRowPos) + " of " + string(llRowCount))
//		
//	lsSKU = Upper(left(trim(This.GetItemString(llRowPos,"SKU")),50))
//	lsSupplier = Upper(left(trim(This.GetItemString(1,'supplier')),50))
//	lsOrdQty = Upper(left(trim(This.GetItemString(llRowPos,"req_qty")),100))
//	llOrdQty = dec(Upper(left(trim(This.GetItemString(llRowPos,"req_qty")),100)))
//	lsOrdUOM = Upper(left(trim(This.GetItemString(llRowPos,"req_uom")),100))
//	lsDtl_UF3 = Upper(left(trim(This.GetItemString(llRowPos,"ship_ref_no")),100))
//	lsPick_Lot = Upper(left(trim(This.GetItemString(llRowPos,"lot_No")),100))
//	lsInvType = Upper(left(trim(This.GetItemString(llRowPos,"inventory_type")),1))
//	
////	lsReqUOM = Upper(left(trim(This.GetItemString(llRowPos,"uom2")),10))
////	lsReqQty = Upper(left(trim(This.GetItemString(llRowPos,"quantity")),20))
////	llReqQTY = dec(This.GetItemString(llRowPos, "quantity"))
//
//
//	
//	//Get the Values from Item Master
//	Select Alternate_Sku, UOM_1, UOM_2, QTY_2, HS_Code, User_Field11 
//	into :lsAlt_Sku, :lsUOM1, :lsUOM2, :llqty2, :lsHSCode, :lsPackSize
//	From Item_Master
//	Where PRoject_id = :gs_Project and SKU = :lsSKU and Supp_code = :lssupplier;
//		
////  Calculate Quantity by checking UOM = UOM_2 from Item Master
//		If lsUOM2 = lsOrdUOM Then 
//			llReqQTY = llOrdQty*llqty2
//			lsReqUOM = lsUOM1
//		Else
//			llReqQTY = llordQty
//			lsReqUOM = lsUOM1
//		End If
//
////Get the default owner 
//Select Owner_ID into :llOwnerID
//From OWner
//Where PRoject_id = :gs_Project and Owner_CD = :lsSupplier and OWner_type = 'S';
//	
//	
//// Non Bonded Warehouse defaults lot No to "DP"
//	If is_bonded_wh = 'B'Then
//		lsPick_Lot = Upper(left(trim(This.GetItemString(llRowPos,"lot_no")),20))
//	Else
//		lsPickLot = 'DP'
//	End If 	
//
//	// write the  Detail Record.
//				
//		Insert Into Delivery_Detail (do_no, SKU, Supp_code, Alternate_Sku, Owner_ID, line_item_no, Req_Qty, UOM, Alloc_QTY, User_Field1, User_Field2, User_Field3, User_Field5, User_Field7, Pick_Lot_No)
//		Values	(:lsdoNo, :lsSKU, :lssupplier, :lssku, :llOwnerID, :llLineItem, :llReQQty, :lsReqUOM, 0, :lsOrdQTY, :lsOrdUOM, :lsDtl_UF3, :lsHSCode, :lsPackSize, :lsPick_lot)
//		Using SQLCA;
////		
//		If sqlca.sqlcode <> 0 Then
//			This.SetRow(llRowPos)
//			This.ScrollToRow(llRowPos)
//			lsErrText = sqlca.sqlerrtext /*error text lost in rollback*/
//			Execute Immediate "ROLLBACK" using SQLCA;
//			Messagebox("Import","Error exists in row " + string(llRowPos) +  ". Unable to save changes to database!~r~rUse the Validate function to catch these errors before saving.~r~r" + lsErrtext)
//			SetPointer(Arrow!)
//			Return -1
//		Else
//			llnewDetail ++
//		End If			
//			
//		llLineItem ++
//		
//Next /*Import Row */
//
//
//Execute Immediate "COMMIT" using SQLCA;
//If sqlca.sqlcode <> 0 Then
//	MessageBox("Import","Unable to Commit changes! No changes made to Database!")
//	Return -1
//End If
//
//MessageBox("Import","Delivery Orders Created: 1" + "~r~rNew Detail Records Added: " + String(llNewDetail))
//w_main.SetmicroHelp("Ready")
//SetPointer(Arrow!)
//Return 0
//
//

end function

on u_dw_import_ws_so.create
call super::create
end on

on u_dw_import_ws_so.destroy
call super::destroy
end on

event ue_pre_validate;call super::ue_pre_validate;
This.Sort()
// pvh - 01/21/06
return 0
end event

