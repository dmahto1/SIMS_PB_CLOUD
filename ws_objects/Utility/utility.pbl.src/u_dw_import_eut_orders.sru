$PBExportHeader$u_dw_import_eut_orders.sru
$PBExportComments$EUT (Outbound Orders) file
forward
global type u_dw_import_eut_orders from u_dw_import
end type
end forward

global type u_dw_import_eut_orders from u_dw_import
integer width = 3077
integer height = 1572
string dataobject = "d_import_eut_orders"
boolean border = false
borderstyle borderstyle = stylebox!
end type
global u_dw_import_eut_orders u_dw_import_eut_orders

type variables

Datastore	idsItem

string is_dw_name[]
end variables

forward prototypes
public function string wf_validate (long al_row)
public function integer wf_save ()
end prototypes

public function string wf_validate (long al_row);
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

u_ds	ldsDOMAster, ldsDODetail

boolean ib_fail = false	

ldsDOMAster = Create u_ds
ldsDOMAster.dataobject = 'd_do_master'
ldsDOMAster.SetTransObject(SQLCA)

ldsDODetail = Create u_ds
ldsDODetail.dataobject = 'd_do_Detail'
ldsDODetail.SetTransObject(SQLCA)

string ls_last_order_no = ""

datetime ldtToday

ldtToday = f_getLocalWorldTime( gs_default_wh ) 

llRowPos = 1 
llRowCount = This.RowCount()
llNew = 0
llCol = 1

SetPointer(Hourglass!)

// Loop For each column in first row -  get the row data (Delivery Order Master in first row) 


 long llRow
string lsShipToName, lsShipToAddress, lsSize


For llRow = 1 to this.RowCount()  

  IF this.GetItemString( llRow, "order_flag") <> "O" THEN CONTINUE


  IF trim(ls_last_order_no) <>  Trim(This.GetItemString(llRow,"order_number")) THEN


	  llLineItem = 1 // reset Detail Line Number
	  
	  
	  ls_last_order_no = Trim(This.GetItemString(llRow,"order_number"))
	  
	  lsShipToName = Trim(This.GetItemString(llRow,"ship_to_name"))
	  
	  lsAddr1 = ""
	  lsAddr2 = ""
	  lsAddr3 = ""
	  lsAddr4 = ""
	 
	  
	  lsShipToAddress = Trim(This.GetItemString(llRow,"ship_to_address"))
	  
	  integer li_Pos 
	  boolean lb_more_address = true
	  
	  li_Pos = Pos(lsShipToAddress, ",")
	  
	  //Address 1
	  if li_Pos > 0 then
		lsAddr1 = LeftTrim(left(lsShipToAddress, li_Pos - 1))
		lsShipToAddress = mid(lsShipToAddress, li_Pos + 1)
	  else
		lsAddr1 = 	LeftTrim(lsShipToAddress)
		lb_more_address = false
	  end if
	  
	  
	 //Address 2 
	  
	  if lb_more_address then
	  
		  li_Pos = Pos(lsShipToAddress, ",")  
		
			
		  if li_Pos > 0 then
			lsAddr2 = LeftTrim(left(lsShipToAddress, li_Pos - 1))
			lsShipToAddress = mid(lsShipToAddress, li_Pos + 1)
		  else
			lsAddr2 = 	LeftTrim(lsShipToAddress)
			lb_more_address = false		
		  end if 
	  end if
	
	
	//Address 3
		if lb_more_address then
	  
			li_Pos = Pos(lsShipToAddress, ",")  
		  
	
		  if li_Pos > 0 then
			lsAddr3 = LeftTrim(left(lsShipToAddress, li_Pos - 1))
			lsShipToAddress = mid(lsShipToAddress, li_Pos + 1)
		  else
			lsAddr3 = LeftTrim(	lsShipToAddress)
			lb_more_address = false			
		  end if 
		
		end if
		
	//Address4
		
	  if lb_more_address then
		lsAddr4 = 	LeftTrim(lsShipToAddress)
	  end if  
	  
	  
	  lsSuppCode = Trim(This.GetItemString(llRow,"supplier"))
	  
	  
		w_main.SetmicroHelp("Saving Master Record for " + string(lsShipToName))
		
		//Get the next available DONO
		sqlca.sp_next_avail_seq_no(gs_project,"Delivery_Master","DO_No" ,lddONO) 
		lsDoNO = gs_Project + String(Long(ldDoNo),"0000000") 
		llDoNoLength = len(lsDoNO)
		
	
		
		lsOrderNo = Trim(This.GetItemString(llRow,"order_number"))  //mid(lsDoNO, (llDoNoLength - 6), llDoNoLength) //Get The Invoice Number - last 7 digits of lsDoNO 

		
		/*Insert a new Delivery Master Record*/	
		lsSaveFile = Right(w_import.isImportFile,30) 

		lsCustName = this.GetItemString( llRow, "ship_to_name") 


		llHeaderRow = ldsDOmaster.InsertRow(0)
		ldsDOMAster.SetITem(llheaderRow,'do_no',lsDONO)
		ldsDOMAster.SetITem(llheaderRow,'Project_id',gs_project)
		
		datetime ld_ord_date, ld_delivery_date
		
		ld_ord_date = datetime(date(this.GetItemString( llRow, "order_date")), time ("00:00") )
		
		ldsDOMAster.SetITem(llheaderRow,'Ord_date',ld_ord_date)
		
		ld_delivery_date = datetime(date(this.GetItemString( llRow, "delivery_date")), time("00:00") )
		
		
		ldsDOMAster.SetITem(llheaderRow,'Delivery_Date', ld_delivery_date)
		
		string ls_Remark, ls_shipping_instruction
		
		ls_Remark = this.GetItemString( llRow, "remarks")
		ls_shipping_instruction = this.GetItemString( llRow, "shipping_instruction")
		
		ldsDOMAster.SetITem(llheaderRow,'Remark', ls_Remark)
		ldsDOMAster.SetITem(llheaderRow,'shipping_instructions', ls_shipping_instruction)
		
		
	
	
		SELECT Cust_Code INTO :lsCust FROM Customer WHERE Upper(Cust_Name) = :lsCustName   AND project_id = :gs_project  USING SQLCA;
		
		IF SQLCA.SQLCode = 100 THEN


			MessageBox ("Error", "Customer Name: " + lsCustName + " not found in the Customer table.")

			RETURN -1
			 
		END IF
		
		IF SQLCA.SQLCode < 0 THEN
				
			MessageBox ("Error", SQLCA.SQLErrText)
				
			RETURN -1
			
		END IF

		
		
		
		ldsDOMAster.SetITem(llheaderRow,'Ord_status',"N")

		lsOrdType = this.GetItemString( llRow, "department_store") 
		
		if Not IsNull(lsOrdType) AND trim(lsOrdType) <> "" then
			ldsDOMAster.SetITem(llheaderRow,'Ord_Type',lsOrdType)		
		else
			ldsDOMAster.SetITem(llheaderRow,'Ord_Type','S')
		end if
		
		
		ldsDOMAster.SetITem(llheaderRow,'Inventory_type',"N")
		ldsDOMAster.SetITem(llheaderRow,'Invoice_No',lsOrderNo)
		ldsDOMAster.SetITem(llheaderRow,'Cust_code',lsCust)
		ldsDOMAster.SetITem(llheaderRow,'Cust_Name',lsCustName)
		ldsDOMAster.SetITem(llheaderRow,'Address_1',lsAddr1)
		ldsDOMAster.SetITem(llheaderRow,'Address_2',lsAddr2)
		ldsDOMAster.SetITem(llheaderRow,'Address_3',lsAddr3)
		ldsDOMAster.SetITem(llheaderRow,'Address_4',lsAddr4)
		ldsDOMAster.SetITem(llheaderRow,'wh_code',gs_default_wh)
		ldsDOMAster.SetITem(llheaderRow,'LAst_user',gs_userid)
		ldsDOMAster.SetITem(llheaderRow,'LASt_Update',ldtToday)

		llNew ++
	
	END IF
	


	// Loop and Read all rows for each customer and add Delivery detail records when qty is more than zero 
	For llColPos = 5 to 59
		w_main.SetmicroHelp("Saving Column " + string(llColPos) + " of " + string(59)+ " for Customer:"  + string(lsCustName))

		llQty = Long(Trim(This.GetItemString(llRow,llColPos))) 	//Get Qty amount
			
		IF llQty > 0 then  
	
			lsSize = Upper(mid( is_dw_name[llColPos], 6))
			lsSku  = Trim(This.GetItemString(llRow,"article_no")) + "-" + Trim(This.GetItemString(llRow,"colour")) + "-" + lsSize  

					
			llFindRow = idsItem.Find("sku = '" + lsSKU + "'",1,idsItem.RowCount())
			
			If lLFindRow > 0 Then
				
				lsAltSku = idsItem.GetITEmString(lLFindRow,'alternate_sku')
				lsSuppCode =Trim(This.GetItemString(llRow,"supplier"))
				llOwner = idsItem.GetITEmNumber(lLFindRow,'Owner_ID')
				

			Else /*Item not found, don't create detail*/
				
				Messagebox("Import","Error saving Row: " + String(llRowPos) + " Item master record not found.~r~rNo changes made to database.")
				SetPointer(Arrow!)
				Return -1
		
			End If

			ld_price = Dec(GetItemString(llRow, "price_tag"))
						

				
		
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
			ldsDODetail.SetITem(lLDetailRow,"line_Item_no", llLineItem)
			

			llLineItem ++

		
		End If	/*Qty > 0*/
	
	Next /*Next Import Row*/

	
Next /*Next Import Column*/


IF ib_fail = true THEN
	
	RETURN -1
	
END IF 

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

on u_dw_import_eut_orders.create
call super::create
end on

on u_dw_import_eut_orders.destroy
call super::destroy
end on

event ue_pre_validate;call super::ue_pre_validate;
Long	llRowPos, llRowCount, llFindRow, llOwner, llNewRow, llColPos
String	lsSKU, lsAltSku, lsSuppCode, lsData, ls_Size, lsCustCode
String lsOrdType

If not isvalid(idsItem) Then
	idsItem = Create Datastore
	idsItem.dataobject = 'd_maintenance_itemMAster'
End If

string ls_obj_string, obj_holder, lsCustName
long tab_pos

integer li_column_id 


ls_obj_string = Describe(this,"datawindow.objects") 

tab_pos =  Pos(ls_obj_string,"~t") 
DO WHILE tab_pos > 0 
 obj_holder = Left(ls_obj_string, tab_pos -1 ) 
 
 IF (describe(this,obj_holder+".type") = "column") THEN 
   li_column_id =  integer(describe(this,obj_holder+".id"))
	
   is_dw_name[li_column_id]  = describe(this,obj_holder+".name")
 END IF 
 ls_obj_string = mid(ls_obj_string, (tab_pos + 1))
 tab_pos =  Pos(ls_obj_string,"~t") 
LOOP 

 obj_holder =ls_obj_string

 IF (describe(this,obj_holder+".type") = "column") THEN 
   li_column_id =  integer(describe(this,obj_holder+".id"))
	
   is_dw_name[li_column_id]  = describe(this,obj_holder+".name")
 END IF 


boolean ib_Fail = false
integer li_count

//Loop thru Items and preload into DS
lLRowCount = This.RowCount()

For llRowPOs = 1 to llRowCount
	
	w_main.SetMicroHelp("Retrieving ItemMaster information for row: " + String(lLRowPos))
	
	
	lsOrdType = this.GetItemString( llRowPOs, "department_store") 
		
	IF Not IsNull(lsOrdType) AND trim(lsOrdType) <> "" THEN	
		
	
		SELECT  Count(Delivery_Order_Type.Ord_Type) INTO :li_count
        FROM Delivery_Order_Type   
			Where Project_id = :gs_project AND Delivery_Order_Type.Ord_Type = :lsOrdType USING SQLCA;
			
		IF li_count <= 0 THEN
			
			ib_fail = true

			MessageBox ("Error", "Order Type: " + lsOrdType + " is not a valid order type.")
			
			
		END IF
	
	
	END IF
	
	
	lsCustName = Trim(Upper(this.GetItemString( llRowPOs, "ship_to_name")))
	
	SELECT Cust_Code INTO :lsCustCode FROM Customer WHERE Upper(Cust_Name) = :lsCustName  AND project_id = :gs_project  USING SQLCA;
	
			IF SQLCA.SQLCode = 100 THEN
				
					ib_fail = true

					MessageBox ("Error", "Customer Name: " + lsCustName + " not found in the Customer table.")

				
			END IF
			
			IF SQLCA.SQLCode < 0 THEN
				
					ib_fail = true
					
					MessageBox ("Error", SQLCA.SQLErrText)
				
			END IF
	
	
	FOR llColPos = 5 to 59
	
		lsData = This.GetITemString(llRowPOs,llColPos)

		If len(lsData) < 1 or lsData = '' or IsNull (lsData) Then
				// do nothing  - should be a blank column
			else	
				
				
				ls_Size = Upper(mid( is_dw_name[llColPos], 6))



				lsSku  = Trim(This.GetItemString(llRowPos,"article_no")) + "-" + Trim(This.GetItemString(llRowPos,"colour")) + "-" + ls_Size    /* Get First Part of SKU*/  
			
			
				lsSuppCode  = Trim(This.GetItemString(llRowPos,"supplier"))
			
			
		
				llFindRow = idsItem.Find(" sku = '" + lsSKU + "'",1,idsItem.RowCount())
			
				string lsDescription
			
							
				If llFindRow <= 0 Then /*first time sku is being loaded*/
			
				
								
					//Get the ALternate SKU (GMPD # for this SKU) & Supplier code &  Owner ID
					Select min(Alternate_sku), min(Owner_ID)
					Into	:lsAltSku, :llOwner
					From Item_MAster
					Where Project_id = :gs_project and sku = :lsSku and Supp_code = :lsSuppCode ;
					
					
			
					If isnull(llOwner)  Then
				
						ib_fail = true
	
						MessageBox ("Error", "Sku: " + lsSKU + " : Supplier: " + lsSuppCode + " not found in Item Master.")
	
	
						CONTINUE
				
					END IF
								
				
					If isnull(lsAltSku) or lsAltSku = '' Then lsAltSku = lsSku
								
	
				
				
					llNewRow = idsItem.InsertRow(0)
					idsItem.SetItem(llNewRow,'sku', lsSKU)
					idsItem.SetItem(llNewRow,'alternate_sku', lsAltSKU)
					idsItem.SetItem(llNewRow,'supp_Code', lsSuppCode)
					idsItem.SetItem(llNewRow,'owner_id', llOwner)
			
						
				End If



			end if
			

	NEXT

	
Next


w_main.SetMicroHelp("Ready")

IF ib_fail = true THEN
	
	RETURN -1
	
END IF


Return 0
end event

