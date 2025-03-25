HA$PBExportHeader$u_dw_import_ws_so_bms.sru
$PBExportComments$Import Wine and Spirit SO for Bacardi
forward
global type u_dw_import_ws_so_bms from u_dw_import
end type
end forward

global type u_dw_import_ws_so_bms from u_dw_import
integer width = 3077
integer height = 1572
string dataobject = "d_import_ws_fixedlength_data"
end type
global u_dw_import_ws_so_bms u_dw_import_ws_so_bms

type variables
String is_bonded_wh, isskuHold
end variables

forward prototypes
public function string wf_validate (long al_row)
public function integer wf_save ()
end prototypes

public function string wf_validate (long al_row);String	lsSKU, lsWarehouse, lsOrderNo,  lstemp
			
Long		llCount


	
//Validate SKU  
lsSKU = Trim(mid(This.getItemString(al_row,"import_data"),58,18))

If isnull(lsSKU) Then
	This.Setfocus()
	This.SetColumn("sku")
	iscurrvalcolumn = "sku"
	return "SKU can not be null!"
Else
	llcount=0
	Select COUNT(*)
	Into	:llCount
	FRom Item_Master
	Where Project_id = :gs_Project and sku = :lsSKU;
	
	If llCount <= 0 Then
		This.Setfocus()
		This.SetColumn("import_data")
		iscurrvalcolumn = "import_data"
		return "'Invalid SKU"
	End If
	
End If /* Sku */


isSKUHold = lsSKU


//Order date Must be a A Date
lsTEMP = Trim(mid(This.getItemString(al_row, "import_data"),48,10))
If not isnull(lsTEMP) and not isdate(lsTEMP) Then
	This.Setfocus()
		This.SetColumn("import_data")
		iscurrvalcolumn = "import_data"
	return "'Order Date' must be a date!"
End If

REturn ''








end function

public function integer wf_save ();

Long	llRowCount,	llRowPos, llOrdqty, llOwnerID, llLineItem,	&
		llqty2, llReqQTY, llUserLineItem, llHeaderRow, llNew, llDetailRow, llCount
Integer	liRC
	
		
String	lsErrText, lsDONO, lsSKU, lsPickLot,  &
			lsSupplier, lsOrderNo,  lsWarehouse, lsOwnerCd, lsCOO, lsUOM1, lsUOM2, lslocCode, lsReqUOM, lsOrdUOM, lsReqQTY, lsOrdQTY, lsHSCode, &
			lsPackSize, lsVolume, lsshp_rep, lsInvType,lsOrder_Type, lsCustCd, lsCust_Order_No, &
			lsCust_Name, lsCust_Add1, lsCust_Add2, lsCust_Add3, lsCust_Add4, lsCust_City, lsCust_State, lsCust_Zip, lsCust_Country, lsContact_Person, lsRemarks, lsTel, lsinventory_type, &
			lsAlt_Sku, lsPick_Lot, lsSaveFile
			
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

lsWarehouse = 'WS-DP'

ldtScheduled_Date = DateTime(Date('1900/01/01'), time('00:00:00')) 


ldToday = f_getLocalWorldTime( lsWarehouse ) 


For llRowPos = 1 to this.RowCount()  


	SetPointer(Hourglass!)

	//If Customer Order Number Changes create a new order 

	IF trim(lsCust_Order_No) <>  Trim(Mid(This.GetItemString(llRowPos,"import_data"),38,10)) THEN  //Check Customer Order Number 
		llLineItem = 1 // reset Detail Line Number

		lsCust_Order_No = Trim(mid(This.GetItemString(llRowPos,'import_data'),38,10))  //Customer Number
		lsCust_Name = Trim(Mid(This.GetItemString(llRowPos,"import_data"),1,37))  //Cust Name	
				
		SELECT Cust_Code, Address_1, Address_2, Address_3, Address_4, City, State, Zip, Country, Contact_Person, Tel
		INTO :lsCustCd,  :lsCust_Add1 ,:lsCust_Add2 ,:lsCust_Add3 ,:lsCust_Add4 ,:lsCust_City ,:lsCust_State ,:lsCust_Zip ,:lsCust_Country , :lsContact_Person ,:lsTel
		FROM Customer WHERE Upper(Cust_Name) = :lsCust_Name   AND project_id = :gs_project  USING SQLCA;

		If not isnull(Trim(mid(This.GetItemString(llRowPos,'import_data'),48,10)))  Then  //Order Date
			ldtOrd_Date = DateTime(Date(Trim(mid(This.GetItemString(llRowPos,'import_data'),48,10))), time('00:00:00'))
		Else
			ldtOrd_Date = ldToday
		End If

		//Get the next available RONO
		sqlca.sp_next_avail_seq_no(gs_project,"Delivery_Master","DO_No" ,ldDONO)//get the next available DO_NO
		lsDoNO = gs_Project + String(Long(ldDoNo),"000000") 

		//TAM - W&S 2010/12  -   Order Number is Formatted.  We will not allow entry into this field.  
		//Format is (WH_CODE(3rd and 4TH Char)) + "S" + (Year(2 digit)) + (Month(2 Digit)) + (4 Digit Running number from Lookup table) 
		//Left 3 characters = WS- for Wine and Spirt.
		lsOrderNo =  Mid(gs_project,4,2) + '-S' + String(Today,'YYMM') + String(ldDONO,"0000")

		/*Insert a new Delivery Master Record*/	
		lsSaveFile = Right(w_import.isImportFile,30) /* 08/02 - PConkl - we are only saving the right most 30 cahr to maintain uniqueness for large file names */
			
		
		llHeaderRow = ldsDOmaster.InsertRow(0)
		ldsDOMAster.SetITem(llheaderRow,'do_no',lsDONO)
		ldsDOMAster.SetITem(llheaderRow,'Project_id',gs_project)
		ldsDOMAster.SetITem(llheaderRow,'Ord_date',ldtord_date)
		ldsDOMAster.SetITem(llheaderRow,'cust_order_no', lsCust_Order_No)	
		ldsDOMAster.SetITem(llheaderRow,'wh_code',lsWarehouse)
		ldsDOMAster.SetITem(llheaderRow,'Ord_status',"N")
		ldsDOMAster.SetITem(llheaderRow,'Ord_Type','S')
		ldsDOMAster.SetITem(llheaderRow,'Inventory_type',"N")
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
		llNew ++

	End If  // End New Header Customer Name Change

//Detail  Record
	
	w_main.SetmicroHelp("Saving Row " + string(llRowPos) + " of " + string(llRowCount))
		
	lsSKU = 		Upper(trim(Mid(This.GetItemString(llRowPos,'import_data'),58,18)))  //SKU
	lsOrdQty =	Upper(trim(mid(This.GetItemString(llRowPos,'import_data'),123,8)))  //Order Quantity
	llOrdQty = dec(lsOrdQty)

	//Get the Values from Item Master

	Select COUNT(*), Supp_Code
	Into	:llCount, :lssupplier
	FRom Item_Master
	Where PRoject_id = :gs_Project and SKU = :lsSKU
	Group By Supp_Code;

	IF	llcount <> 1 Then // If more than one supplier per sku then default to BMS since they are not sending supplier in the file
		lssupplier = 'BMS'
	ENd if
	
//Get the owner 
Select Owner_ID into :llOwnerID
From OWner
Where PRoject_id = :gs_Project and Owner_CD = :lsSupplier and OWner_type = 'S';

	//Get the Values from Item Master
	Select Alternate_Sku, UOM_1,  HS_Code, User_Field11 
	into :lsAlt_Sku, :lsUOM1, :lsHSCode, :lsPackSize
	From Item_Master
	Where PRoject_id = :gs_Project and SKU = :lsSKU and Supp_code = :lssupplier;

	// write the  Detail Record.
			llDetailRow = ldsDODetail.InsertRow(0)
			ldsDODetail.SetITem(llDetailRow,"do_no", lsdoNo)
			ldsDODetail.SetITem(lLDetailRow,"sku", lsSKU)
			ldsDODetail.SetITem(lLDetailRow,"supp_code", lsSupplier)
			ldsDODetail.SetITem(lLDetailRow,"Owner_id", llOwnerID)
			ldsDODetail.SetITem(lLDetailRow,"Alternate_sku", lsSKU)
			ldsDODetail.SetITem(lLDetailRow,"req_qty", llOrdQty)
			ldsDODetail.SetITem(lLDetailRow,"uom", lsUOM1)
			ldsDODetail.SetITem(lLDetailRow,"alloc_qty", 0)
			ldsDODetail.SetITem(lLDetailRow,"User_Field1", lsOrdQTY)
			ldsDODetail.SetITem(lLDetailRow,"User_Field2", lsUOM1)
			ldsDODetail.SetITem(lLDetailRow,"User_Field3", 'DP') //TAM W&S 2011/05/16
			ldsDODetail.SetITem(lLDetailRow,"User_Field5", lsHSCode)
			ldsDODetail.SetITem(lLDetailRow,"User_Field7", lsPackSize)
			ldsDODetail.SetITem(lLDetailRow,"Pick_Lot_No", 'DP')
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





end function

on u_dw_import_ws_so_bms.create
call super::create
end on

on u_dw_import_ws_so_bms.destroy
call super::destroy
end on

event ue_pre_validate;call super::ue_pre_validate;
This.Sort()
// pvh - 01/21/06
return 0
end event

