HA$PBExportHeader$u_nvo_proc_philips_cls.sru
$PBExportComments$+ PHILIPSCLS Project
forward
global type u_nvo_proc_philips_cls from nonvisualobject
end type
end forward

global type u_nvo_proc_philips_cls from nonvisualobject
end type
global u_nvo_proc_philips_cls u_nvo_proc_philips_cls

type variables


end variables

forward prototypes
public function integer uf_process_files (string asproject, string aspath, string asfile, string asinifile)
public function integer uf_process_item_master (string aspath, string asproject)
public function integer uf_process_purchase_order (string aspath, string asproject)
public function string getphilipsinvtype (string asinvtype)
public function integer uf_process_dboh ()
public function integer uf_process_delivery_order (string aspath, string asproject)
public function integer uf_process_return_order (string aspath, string asproject)
public function string getphilipsdisposition (string asinvtype)
public function integer uf_process_daily_lot_info (string asproject, string asinifile, datetime ad_next_runtime_date)
public function integer uf_process_event_status_delivered (string aspath, string asproject)
public function str_parms getphilipssuppliertranslations (string asproject, string assupplier, string asinventorytype)
public function str_parms getxpoinventorytype (string asproject, string assupplier, string asinventorytype)
public function string remove_leading_zeros (string as_sku)
end prototypes

public function integer uf_process_files (string asproject, string aspath, string asfile, string asinifile);//23-Jan-2019  :Madhu S28355 Philips SG & MY BlueHeart Material Master
//16-Feb-2019 :Madhu S29552 Philips BlueHeart Outbound Order
int liRC

CHOOSE CASE Upper(left(asfile, 2))
	CASE 'IM'
		liRC = uf_process_item_master( aspath, asproject)
		
	CASE 'PM'
		liRC =uf_process_purchase_order(aspath, asproject)

		//Process any added PO's
		liRC = gu_nvo_process_files.uf_process_purchase_order(asproject) 

	CASE 'RM'
		liRC =uf_process_return_order(aspath, asproject)

		//Process any added PO's
		liRC = gu_nvo_process_files.uf_process_purchase_order(asproject) 

	CASE 'DM'
		liRC = uf_process_delivery_order(aspath, asproject)
		
		//Process any added Delivery Order's
		liRC = gu_nvo_process_files.uf_process_delivery_order( asproject)
	
	CASE 'DN' //TAM - 2019/02/28 - S29919 - Shipment Delivered Status update
		liRC = uf_process_event_status_delivered(aspath, asproject)
		
END CHOOSE

Return liRC
end function

public function integer uf_process_item_master (string aspath, string asproject);//23-Jan-2019 :Madhu S28355 Philips SG & MY BlueHeart Material Master (IM)

//process Item Master File
String		lsData, ls_Temp, lsLogOut, lsStringData, lsSKU, lsSupplier
Integer	liRC,	liFileNo
Long		llCount,	llPos, llOwner, llNew, llExist, llNewRow, llFileRowCount, llFileRowPos
Long		ll_Owner_Row, ll_owner_found

Boolean	lbNew, lbError, lbSave, lbUpdateDIMS

u_ds_datastore	 ldsItemOrig, ldsItem, ldsImport
datastore	ldsSuppOwner

ldsItemOrig = Create u_ds_datastore
ldsItemOrig.dataobject= 'd_baseline_unicode_item_master'

ldsItem = Create u_ds_datastore
ldsItem.dataobject= 'd_baseline_unicode_item_master'
ldsItem.SetTransObject(SQLCA)

ldsImport = Create u_ds_datastore
ldsImport.dataobject = 'd_generic_import'

ldsSuppOwner = Create u_ds_datastore
ldsSuppOwner.dataobject ='d_supplier_owner'

//Open and read the File In
lsLogOut = '      - Opening Item Master File: ' + asPath + String(Today(), "mm/dd/yyyy hh:mm:ss.fff")
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

liFileNo = FileOpen(asPath,LineMode!,Read!,LockReadWrite!)
If liFileNo < 0 Then
	lsLogOut = "-       ***Unable to Open Item Master File for Pandora Processing: " + asPath
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
	Return -99 /* we wont move to error directory if we can't open the file here*/
End If

//read file and load to datastore for processing
liRC = FileRead(liFileNo,lsStringData)

Do While liRC > 0
	llNewRow = ldsImport.InsertRow(0)
	ldsImport.SetItem(llNewRow,'rec_data',trim(lsStringData))
	liRC = FileRead(liFileNo,lsStringData)
Loop /*Next File record*/

FileClose(liFileNo)

//Row Count
llFileRowCount = ldsImport.RowCount()

For llfileRowPos = 1 to llFileRowCount

	lbUpdateDIMS = True // 2019/06/21 - TAM - S28355 - DE11241

	w_main.SetMicroHelp("Processing Item Master Records "+ string(llfileRowPos) + " of " +string(llFileRowCount))
	lbSave = True	
	lsData = trim(ldsImport.GetItemString(llFileRowPos,'rec_Data'))
	
	//Ignore EOF
	If lsData = "EOF" Then Continue
	
	//Make sure first Char is not a delimiter
	If Left(lsData,1) = '|' Then
		lsData = Right(lsData,Len(lsData) - 1)
	End If
	
	//Project
	If Pos(lsData, '|') > 0 Then
		ls_Temp =Left(lsData, (Pos(lsData, '|') - 1))
	else
		gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Data expected after 'Project Id' field. Record will not be processed.")
		lbError = True
		Continue		
	End If

	lsData = Right(lsData,(len(lsData) - (Len(ls_Temp) + 1))) //Strip off until the next delimeter

	//Sku
	If Pos(lsData,'|') > 0 Then
		ls_Temp = Left(lsData,(pos(lsData,'|') - 1))
		lsSKU = ls_Temp
	Else /*error*/
		gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Data expected after 'SKU' field. Record will not be processed.")
		lbError = True
		Continue		
	End If
	
	lsData = Right(lsData,(len(lsData) - (Len(ls_Temp) + 1))) //Strip off until the next delimeter

	//Supplier
	If Pos(lsData,'|') > 0 Then
		ls_Temp = Left(lsData,(pos(lsData,'|') - 1))
		lsSupplier = ls_Temp
	Else
		gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Data expected after 'Supplier' field. Record will not be processed.")
		lbError = True
		Continue
	End If

	lsData = Right(lsData,(len(lsData) - (Len(ls_Temp) + 1))) //Strip off until the next delimeter
	
	//Owner
	If Pos(lsData,'|') > 0 Then
		ls_Temp = Left(lsData,(pos(lsData,'|') - 1))
		llOwner = long(ls_Temp)
	End If
	
	// 2019/06/21 - TAM - S28355 - DE11241 - For SG10, SG27, SG71 and MY10.we dont want to update the DIMS and Weight on an Update
	// 2019/07/10 - TAM - S28355 - DE11629 - Added SG02 and MY01 .we dont want to update the DIMS and Weight on an Update
	// 2019/07/10 - DTS - S28355 - DE11629 - Added SG01 (as should have been done in previous change)
	If lsSupplier = 'SG00' or lsSupplier = 'SG03' or &
	   lsSupplier = 'SG01' or lsSupplier = 'SG02' or lsSupplier = 'MY01' or &
	   lsSupplier = 'SG10' or lsSupplier = 'SG27' or &
	   lsSupplier = 'SG71' or lsSupplier = 'MY10' Then lbUpdateDIMS = False

	//Retrieve for SKU - We will be updating across Suppliers
	llCount = ldsItem.Retrieve(asProject, lsSKU, lsSupplier)
	ldsItem.RowsCopy(1, ldsItem.RowCount(), Primary!, ldsItemOrig, 1, Primary!)
	llCount = ldsItem.RowCount()
		
	If llCount <= 0 Then
	
		llNew ++ /*add to new count*/
		lbNew = True
		llNewRow = ldsItem.InsertRow(0)
		ldsItem.SetItem(llNewRow, 'project_id', asProject)
		ldsItem.SetItem(llNewRow, 'SKU', lsSKU)
		
		If ldsSuppOwner.rowcount() > 0 Then ll_owner_found = ldsSuppOwner.find( "owner_cd ='"+lsSupplier+"'", 0, ldsSuppOwner.rowcount())

		If ldsSuppOwner.rowcount( ) = 0 or  ll_owner_found = 0  or llOwner = 0 Then
		
			//Get Default owner for Supplier
			Select owner_id into :llOwner
			From Owner with(nolock)
			Where project_id = :asProject and Owner_type = 'S' 
			and owner_cd = :lsSupplier
			using sqlca;
			
			ll_Owner_Row = ldsSuppOwner.insertrow( 0)
			ldsSuppOwner.setItem( ll_Owner_Row, 'owner_cd', lsSupplier)
			ldsSuppOwner.setItem( ll_Owner_Row, 'owner_id', llOwner)
		
		elseIf ll_owner_found > 0 Then
			llOwner = ldsSuppOwner.getItemNumber(ll_owner_found, 'owner_id')
		End If
		
		ldsItem.SetItem(llNewRow, 'supp_code',lsSupplier)
		ldsItem.SetItem(llNewRow, 'owner_id',llOwner)
		ldsItem.setItem(llNewRow, 'Initial_File_Name', asPath)
		
	else /*exists*/
		ldsItem.setItem( llCount, 'Update_File_Name', asPath) 
		ldsItem.setItem( llCount, 'Last_Sweeper_Update', today())
		
		llexist += llCount /*add to existing Count*/
		lbNew = False
		llNewRow =llCount //30-APR-2019 :Madhu DE10270 set existing row
	End IF //Record exists

	
	//Country_Of_Origin_Default
	lsData = Right(lsData,(len(lsData) - (Len(ls_Temp) + 1))) //Strip off until the next delimeter
	If Pos(lsData,'|') > 0 Then
		ls_Temp = Left(lsData,(pos(lsData,'|') - 1))
	Else 
		ls_Temp = lsData
	End If
	
	IF ls_Temp > ' ' Then 
		ldsItem.SetItem(llNewRow,'Country_Of_Origin_Default', ls_Temp)
	else
		ldsItem.SetItem(llNewRow,'Country_Of_Origin_Default', 'XX')
	End IF
	
	//Description 
	lsData = Right(lsData,(len(lsData) - (Len(ls_Temp) + 1))) //Strip off until the next delimeter
	If Pos(lsData,'|') > 0 Then
		ls_Temp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		ls_Temp = lsData
	End If

	IF ls_Temp > ' ' Then ldsItem.SetItem(llNewRow,'Description', ls_Temp)

	//Standard Cost
	lsData = Right(lsData,(len(lsData) - (Len(ls_Temp) + 1))) //Strip off until the next delimeter
	If Pos(lsData,'|') > 0 Then
		ls_Temp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		ls_Temp = lsData
	End If

	IF isnumber(Trim(ls_Temp)) Then ldsItem.SetItem(llNewRow,'Std_Cost', Dec(ls_Temp))
	
	//Standard Cost Old
	lsData = Right(lsData,(len(lsData) - (Len(ls_Temp) + 1))) //Strip off until the next delimeter
	If Pos(lsData,'|') > 0 Then
		ls_Temp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		ls_Temp = lsData
	End If

	IF isnumber(Trim(ls_Temp)) Then ldsItem.SetItem(llNewRow,'Std_Cost_Old', Dec(ls_Temp))
	
	//Average Cost
	lsData = Right(lsData,(len(lsData) - (Len(ls_Temp) + 1))) //Strip off until the next delimeter
	If Pos(lsData,'|') > 0 Then
		ls_Temp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		ls_Temp = lsData
	End If

	IF isnumber(Trim(ls_Temp)) Then ldsItem.SetItem(llNewRow,'Avg_Cost', Dec(ls_Temp))

	//uom_1
	lsData = Right(lsData,(len(lsData) - (Len(ls_Temp) + 1))) //Strip off until the next delimeter
	If Pos(lsData,'|') > 0 Then
		ls_Temp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		ls_Temp = lsData
	End If

	If IsNull(ls_Temp) OR trim(ls_Temp) = '' Then ls_Temp = "EA"
	ldsItem.SetItem(1,'UOM_1', ls_Temp)

	//length_1
	lsData = Right(lsData,(len(lsData) - (Len(ls_Temp) + 1))) //Strip off until the next delimeter
	If Pos(lsData,'|') > 0 Then
		ls_Temp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		ls_Temp = lsData
	End If

	// 2019/06/21 - TAM - S28355 - DE11241 -  /*only map if numeric*/
//	IF isnumber(Trim(ls_Temp)) Then ldsItem.SetItem(llNewRow,'Length_1', Dec(ls_Temp))
	IF isnumber(Trim(ls_Temp))  and (lbNew or lbUpdateDims) Then
		ldsItem.SetItem(llNewRow,'Length_1', Dec(ls_Temp))
	END IF
	
	//width_1
	lsData = Right(lsData,(len(lsData) - (Len(ls_Temp) + 1))) //Strip off until the next delimeter
	If Pos(lsData,'|') > 0 Then
		ls_Temp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		ls_Temp = lsData
	End If

	// 2019/06/21 - TAM - S28355 - DE11241 -  /*only map if numeric*/
//	IF isnumber(Trim(ls_Temp)) Then ldsItem.SetItem(llNewRow,'Width_1', Dec(ls_Temp))
	IF isnumber(Trim(ls_Temp))  and (lbNew or lbUpdateDims) Then
		ldsItem.SetItem(llNewRow,'Width_1', Dec(ls_Temp))
	END IF
	
	//height_1
	lsData = Right(lsData,(len(lsData) - (Len(ls_Temp) + 1))) //Strip off until the next delimeter
	If Pos(lsData,'|') > 0 Then
		ls_Temp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		ls_Temp = lsData
	End If

	// 2019/06/21 - TAM - S28355 - DE11241 -  /*only map if numeric*/
//	IF isnumber(Trim(ls_Temp)) Then ldsItem.SetItem(llNewRow,'Height_1', Dec(ls_Temp))
	IF isnumber(Trim(ls_Temp))  and (lbNew or lbUpdateDims) Then
		ldsItem.SetItem(llNewRow,'Height_1', Dec(ls_Temp))
	END IF
	
	//weight_1
	lsData = Right(lsData,(len(lsData) - (Len(ls_Temp) + 1))) //Strip off until the next delimeter
	If Pos(lsData,'|') > 0 Then
		ls_Temp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		ls_Temp = lsData
	End If

	// 2019/06/21 - TAM - S28355 - DE11241 -  /*only map if numeric*/
//	IF isnumber(Trim(ls_Temp)) Then ldsItem.SetItem(llNewRow,'Weight_1', Dec(ls_Temp))
	IF isnumber(Trim(ls_Temp))  and (lbNew or lbUpdateDims) Then
		ldsItem.SetItem(llNewRow,'Weight_1', Dec(ls_Temp))
	END IF
	
	//uom_2
	lsData = Right(lsData,(len(lsData) - (Len(ls_Temp) + 1))) //Strip off until the next delimeter
	If Pos(lsData,'|') > 0 Then
		ls_Temp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		ls_Temp = lsData
	End If

	IF ls_Temp > ' ' Then ldsItem.SetItem(llNewRow,'UOM_2', ls_Temp)
	
	//length_2
	lsData = Right(lsData,(len(lsData) - (Len(ls_Temp) + 1))) //Strip off until the next delimeter
	If Pos(lsData,'|') > 0 Then
		ls_Temp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		ls_Temp = lsData
	End If

	// 2019/06/21 - TAM - S28355 - DE11241 -  /*only map if numeric*/
//	IF isnumber(Trim(ls_Temp)) Then ldsItem.SetItem(llNewRow,'Length_2', Dec(ls_Temp))
	IF isnumber(Trim(ls_Temp))  and (lbNew or lbUpdateDims) Then
		ldsItem.SetItem(llNewRow,'Length_2', Dec(ls_Temp))
	END IF
	
	//width_2
	lsData = Right(lsData,(len(lsData) - (Len(ls_Temp) + 1))) //Strip off until the next delimeter
	If Pos(lsData,'|') > 0 Then
		ls_Temp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		ls_Temp = lsData
	End If

	// 2019/06/21 - TAM - S28355 - DE11241 -  /*only map if numeric*/
//	IF isnumber(Trim(ls_Temp)) Then ldsItem.SetItem(llNewRow,'Width_2', Dec(ls_Temp))
	IF isnumber(Trim(ls_Temp))  and (lbNew or lbUpdateDims) Then
		ldsItem.SetItem(llNewRow,'Width_2', Dec(ls_Temp))
	END IF
	
	//height_2
	lsData = Right(lsData,(len(lsData) - (Len(ls_Temp) + 1))) //Strip off until the next delimeter
	If Pos(lsData,'|') > 0 Then
		ls_Temp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		ls_Temp = lsData
	End If

	// 2019/06/21 - TAM - S28355 - DE11241 -  /*only map if numeric*/
//	IF isnumber(Trim(ls_Temp)) Then ldsItem.SetItem(llNewRow,'Height_2', Dec(ls_Temp))
	IF isnumber(Trim(ls_Temp))  and (lbNew or lbUpdateDims) Then
		ldsItem.SetItem(llNewRow,'Height_2', Dec(ls_Temp))
	END IF

	//weight_2
	lsData = Right(lsData,(len(lsData) - (Len(ls_Temp) + 1))) //Strip off until the next delimeter
	If Pos(lsData,'|') > 0 Then
		ls_Temp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		ls_Temp = lsData
	End If

	// 2019/06/21 - TAM - S28355 - DE11241 -  /*only map if numeric*/
//	IF isnumber(Trim(ls_Temp)) Then ldsItem.SetItem(llNewRow,'Weight_2', Dec(ls_Temp))
	IF isnumber(Trim(ls_Temp))  and (lbNew or lbUpdateDims) Then
		ldsItem.SetItem(llNewRow,'Weight_2', Dec(ls_Temp))
	END IF
	
	//qty_2
	lsData = Right(lsData,(len(lsData) - (Len(ls_Temp) + 1))) //Strip off until the next delimeter
	If Pos(lsData,'|') > 0 Then
		ls_Temp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		ls_Temp = lsData
	End If

	// 2019/06/21 - TAM - S28355 - DE11241 -  /*only map if numeric*/
//	IF isnumber(Trim(ls_Temp)) Then ldsItem.SetItem(llNewRow,'QTY_2', Dec(ls_Temp))
	IF isnumber(Trim(ls_Temp))  and (lbNew or lbUpdateDims) Then
		ldsItem.SetItem(llNewRow,'QTY_2', Dec(ls_Temp))
	END IF
	
	//uom_3
	lsData = Right(lsData,(len(lsData) - (Len(ls_Temp) + 1))) //Strip off until the next delimeter
	If Pos(lsData,'|') > 0 Then
		ls_Temp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		ls_Temp = lsData
	End If

	IF ls_Temp > ' ' Then ldsItem.SetItem(llNewRow,'UOM_3', ls_Temp)
	
	//length_3
	lsData = Right(lsData,(len(lsData) - (Len(ls_Temp) + 1))) //Strip off until the next delimeter
	If Pos(lsData,'|') > 0 Then
		ls_Temp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		ls_Temp = lsData
	End If

	// 2019/06/21 - TAM - S28355 - DE11241 -  /*only map if numeric*/
//	IF isnumber(Trim(ls_Temp)) Then ldsItem.SetItem(llNewRow,'Length_3', Dec(ls_Temp))
	IF isnumber(Trim(ls_Temp))  and (lbNew or lbUpdateDims) Then
		ldsItem.SetItem(llNewRow,'Length_3', Dec(ls_Temp))
	END IF
	
	//width_3
	lsData = Right(lsData,(len(lsData) - (Len(ls_Temp) + 1))) //Strip off until the next delimeter
	If Pos(lsData,'|') > 0 Then
		ls_Temp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		ls_Temp = lsData
	End If

	// 2019/06/21 - TAM - S28355 - DE11241 -  /*only map if numeric*/
//	IF isnumber(Trim(ls_Temp)) Then ldsItem.SetItem(llNewRow,'Width_3', Dec(ls_Temp))
	IF isnumber(Trim(ls_Temp))  and (lbNew or lbUpdateDims) Then
		ldsItem.SetItem(llNewRow,'Width_3', Dec(ls_Temp))
	END IF
	
	//height_3
	lsData = Right(lsData,(len(lsData) - (Len(ls_Temp) + 1))) //Strip off until the next delimeter
	If Pos(lsData,'|') > 0 Then
		ls_Temp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		ls_Temp = lsData
	End If

	// 2019/06/21 - TAM - S28355 - DE11241 -  /*only map if numeric*/
//	IF isnumber(Trim(ls_Temp)) Then ldsItem.SetItem(llNewRow,'Height_3', Dec(ls_Temp))
	IF isnumber(Trim(ls_Temp))  and (lbNew or lbUpdateDims) Then
		ldsItem.SetItem(llNewRow,'Height_3', Dec(ls_Temp))
	END IF
	
	//weight_3
	lsData = Right(lsData,(len(lsData) - (Len(ls_Temp) + 1))) //Strip off until the next delimeter
	If Pos(lsData,'|') > 0 Then
		ls_Temp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		ls_Temp = lsData
	End If

	// 2019/06/21 - TAM - S28355 - DE11241 -  /*only map if numeric*/
//	IF isnumber(Trim(ls_Temp)) Then ldsItem.SetItem(llNewRow,'Width_3', Dec(ls_Temp))
	IF isnumber(Trim(ls_Temp))  and (lbNew or lbUpdateDims) Then
		ldsItem.SetItem(llNewRow,'Width_3', Dec(ls_Temp))
	END IF
	
	//qty_3
	lsData = Right(lsData,(len(lsData) - (Len(ls_Temp) + 1))) //Strip off until the next delimeter
	If Pos(lsData,'|') > 0 Then
		ls_Temp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		ls_Temp = lsData
	End If

	// 2019/06/21 - TAM - S28355 - DE11241 -  /*only map if numeric*/
//	IF isnumber(Trim(ls_Temp)) Then ldsItem.SetItem(llNewRow,'QTY_3', Dec(ls_Temp))
	IF isnumber(Trim(ls_Temp))  and (lbNew or lbUpdateDims) Then
		ldsItem.SetItem(llNewRow,'QTY_3', Dec(ls_Temp))
	END IF
	
	//uom_4
	lsData = Right(lsData,(len(lsData) - (Len(ls_Temp) + 1))) //Strip off until the next delimeter
	If Pos(lsData,'|') > 0 Then
		ls_Temp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		ls_Temp = lsData
	End If

	IF ls_Temp >' ' Then ldsItem.SetItem(llNewRow,'UOM_4', ls_Temp)
	
	//length_4
	lsData = Right(lsData,(len(lsData) - (Len(ls_Temp) + 1))) //Strip off until the next delimeter
	If Pos(lsData,'|') > 0 Then
		ls_Temp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		ls_Temp = lsData
	End If

	// 2019/06/21 - TAM - S28355 - DE11241 -  /*only map if numeric*/
//	IF isnumber(Trim(ls_Temp)) Then ldsItem.SetItem(llNewRow,'Length_4', Dec(ls_Temp))
	IF isnumber(Trim(ls_Temp))  and (lbNew or lbUpdateDims) Then
		ldsItem.SetItem(llNewRow,'Length_4', Dec(ls_Temp))
	END IF
	
	//width_4
	lsData = Right(lsData,(len(lsData) - (Len(ls_Temp) + 1))) //Strip off until the next delimeter
	If Pos(lsData,'|') > 0 Then
		ls_Temp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		ls_Temp = lsData
	End If

	// 2019/06/21 - TAM - S28355 - DE11241 -  /*only map if numeric*/
//	IF isnumber(Trim(ls_Temp)) Then ldsItem.SetItem(llNewRow,'Width_4', Dec(ls_Temp))
	IF isnumber(Trim(ls_Temp))  and (lbNew or lbUpdateDims) Then
		ldsItem.SetItem(llNewRow,'Width_4', Dec(ls_Temp))
	END IF
	
	//height_4
	lsData = Right(lsData,(len(lsData) - (Len(ls_Temp) + 1))) //Strip off until the next delimeter
	If Pos(lsData,'|') > 0 Then
		ls_Temp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		ls_Temp = lsData
	End If

	// 2019/06/21 - TAM - S28355 - DE11241 -  /*only map if numeric*/
//	IF isnumber(Trim(ls_Temp)) Then ldsItem.SetItem(llNewRow,'Height_4', Dec(ls_Temp))
	IF isnumber(Trim(ls_Temp))  and (lbNew or lbUpdateDims) Then
		ldsItem.SetItem(llNewRow,'Height_4', Dec(ls_Temp))
	END IF
	
	//weight_4
	lsData = Right(lsData,(len(lsData) - (Len(ls_Temp) + 1))) //Strip off until the next delimeter
	If Pos(lsData,'|') > 0 Then
		ls_Temp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		ls_Temp = lsData
	End If

	// 2019/06/21 - TAM - S28355 - DE11241 -  /*only map if numeric*/
//	IF isnumber(Trim(ls_Temp)) Then ldsItem.SetItem(llNewRow,'Weight_4', Dec(ls_Temp))
	IF isnumber(Trim(ls_Temp))  and (lbNew or lbUpdateDims) Then
		ldsItem.SetItem(llNewRow,'Weight_4', Dec(ls_Temp))
	END IF
	
	//qty_4
	lsData = Right(lsData,(len(lsData) - (Len(ls_Temp) + 1))) //Strip off until the next delimeter
	If Pos(lsData,'|') > 0 Then
		ls_Temp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		ls_Temp = lsData
	End If

	// 2019/06/21 - TAM - S28355 - DE11241 -  /*only map if numeric*/
//	IF isnumber(Trim(ls_Temp)) Then ldsItem.SetItem(llNewRow,'QTY_4', Dec(ls_Temp))
	IF isnumber(Trim(ls_Temp))  and (lbNew or lbUpdateDims) Then
		ldsItem.SetItem(llNewRow,'QTY_4', Dec(ls_Temp))
	END IF
	
	//l_type
	lsData = Right(lsData,(len(lsData) - (Len(ls_Temp) + 1))) //Strip off until the next delimeter
	If Pos(lsData,'|') > 0 Then
		ls_Temp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		ls_Temp = lsData
	End If

	IF ls_Temp >' ' Then ldsItem.SetItem(llNewRow,'L_Type', ls_Temp)
	
	//l_code
	lsData = Right(lsData,(len(lsData) - (Len(ls_Temp) + 1))) //Strip off until the next delimeter
	If Pos(lsData,'|') > 0 Then
		ls_Temp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		ls_Temp = lsData
	End If

	IF ls_Temp >' ' Then ldsItem.SetItem(llNewRow,'L_Code', ls_Temp)
	
	//cc_freq
	lsData = Right(lsData,(len(lsData) - (Len(ls_Temp) + 1))) //Strip off until the next delimeter
	If Pos(lsData,'|') > 0 Then
		ls_Temp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		ls_Temp = lsData
	End If

	IF isnumber(Trim(ls_Temp)) Then ldsItem.SetItem(llNewRow,'CC_Freq', Dec(ls_Temp))
	
	//cc_trigger_qty
	lsData = Right(lsData,(len(lsData) - (Len(ls_Temp) + 1))) //Strip off until the next delimeter
	If Pos(lsData,'|') > 0 Then
		ls_Temp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		ls_Temp = lsData
	End If

	IF isnumber(Trim(ls_Temp)) Then ldsItem.SetItem(llNewRow,'CC_Trigger_Qty', Dec(ls_Temp))
	
	//shelf_life
	lsData = Right(lsData,(len(lsData) - (Len(ls_Temp) + 1))) //Strip off until the next delimeter
	If Pos(lsData,'|') > 0 Then
		ls_Temp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		ls_Temp = lsData
	End If

	IF isnumber(Trim(ls_Temp)) Then ldsItem.SetItem(llNewRow,'Shelf_Life', Dec(ls_Temp))
	
	//hs_code
	lsData = Right(lsData,(len(lsData) - (Len(ls_Temp) + 1))) //Strip off until the next delimeter
	If Pos(lsData,'|') > 0 Then
		ls_Temp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		ls_Temp = lsData
	End If

	IF ls_Temp >' ' Then ldsItem.SetItem(llNewRow,'HS_Code', ls_Temp)
	
	//tax_code
	lsData = Right(lsData,(len(lsData) - (Len(ls_Temp) + 1))) //Strip off until the next delimeter
	If Pos(lsData,'|') > 0 Then
		ls_Temp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		ls_Temp = lsData
	End If

	IF ls_Temp >' ' Then ldsItem.SetItem(llNewRow,'Tax_Code', ls_Temp)
	
	//user_field1
	lsData = Right(lsData,(len(lsData) - (Len(ls_Temp) + 1))) //Strip off until the next delimeter
	If Pos(lsData,'|') > 0 Then
		ls_Temp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		ls_Temp = lsData
	End If

	IF ls_Temp >' ' Then ldsItem.SetItem(llNewRow,'User_Field1', ls_Temp)
	
	//user_field2
	lsData = Right(lsData,(len(lsData) - (Len(ls_Temp) + 1))) //Strip off until the next delimeter
	If Pos(lsData,'|') > 0 Then
		ls_Temp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		ls_Temp = lsData
	End If

	IF ls_Temp >' ' Then ldsItem.SetItem(llNewRow,'User_Field2', ls_Temp)
	
	//user_field3
	lsData = Right(lsData,(len(lsData) - (Len(ls_Temp) + 1))) //Strip off until the next delimeter
	If Pos(lsData,'|') > 0 Then
		ls_Temp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		ls_Temp = lsData
	End If

	IF ls_Temp >' ' Then ldsItem.SetItem(llNewRow,'User_Field3', ls_Temp)
	
	//user_field4
	lsData = Right(lsData,(len(lsData) - (Len(ls_Temp) + 1))) //Strip off until the next delimeter
	If Pos(lsData,'|') > 0 Then
		ls_Temp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		ls_Temp = lsData
	End If

	IF ls_Temp >' ' Then ldsItem.SetItem(llNewRow,'User_Field4', ls_Temp)
	
	//user_field5
	lsData = Right(lsData,(len(lsData) - (Len(ls_Temp) + 1))) //Strip off until the next delimeter
	If Pos(lsData,'|') > 0 Then
		ls_Temp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		ls_Temp = lsData
	End If

	IF ls_Temp >' ' Then ldsItem.SetItem(llNewRow,'User_Field5', ls_Temp)
	
	//user_field6
	lsData = Right(lsData,(len(lsData) - (Len(ls_Temp) + 1))) //Strip off until the next delimeter
	If Pos(lsData,'|') > 0 Then
		ls_Temp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		ls_Temp = lsData
	End If

	IF ls_Temp >' ' Then ldsItem.SetItem(llNewRow,'User_Field6', ls_Temp)
	
	//user_field7
	lsData = Right(lsData,(len(lsData) - (Len(ls_Temp) + 1))) //Strip off until the next delimeter
	If Pos(lsData,'|') > 0 Then
		ls_Temp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		ls_Temp = lsData
	End If

	IF ls_Temp >' ' Then ldsItem.SetItem(llNewRow,'User_Field7', ls_Temp)
	
	//user_field8
	lsData = Right(lsData,(len(lsData) - (Len(ls_Temp) + 1))) //Strip off until the next delimeter
	If Pos(lsData,'|') > 0 Then
		ls_Temp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		ls_Temp = lsData
	End If

	// 2019/06/21 - TAM - S28355 - DE11241 -  /*only map if numeric*/
//	IF ls_Temp >' ' Then ldsItem.SetItem(llNewRow,'User_Field8', ls_Temp)
	If ls_Temp > '' and (lbNew or lbUpdateDims) Then
		ldsItem.SetItem(llNewRow,'User_Field8', ls_Temp)
	END IF
	
	//user_field9
	lsData = Right(lsData,(len(lsData) - (Len(ls_Temp) + 1))) //Strip off until the next delimeter
	If Pos(lsData,'|') > 0 Then
		ls_Temp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		ls_Temp = lsData
	End If

	IF ls_Temp >' ' Then ldsItem.SetItem(llNewRow,'User_Field9', ls_Temp)
	
	//last_user
	lsData = Right(lsData,(len(lsData) - (Len(ls_Temp) + 1))) //Strip off until the next delimeter
	If Pos(lsData,'|') > 0 Then
		ls_Temp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		ls_Temp = lsData
	End If

	IF 	NOT (IsNull(ls_Temp) OR ls_Temp ='') Then 
		ldsItem.SetItem(llNewRow,'Last_User', ls_Temp)
	else
		ldsItem.SetItem(llNewRow, 'Last_user', 'SIMSFP')
	End IF
	
	//last_update
	lsData = Right(lsData,(len(lsData) - (Len(ls_Temp) + 1))) //Strip off until the next delimeter
	If Pos(lsData,'|') > 0 Then
		ls_Temp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		ls_Temp = lsData
	End If

	IF NOT (IsNull(ls_Temp) OR ls_Temp ='') Then 
		ldsItem.SetItem(llNewRow,'Last_Update', DateTime(Left(ls_Temp,4) + "/" + Mid(ls_Temp,5,2) + "/" + Mid(ls_Temp,7,2)))
	else
		ldsItem.SetItem(llNewRow, 'Last_Update', DateTime(today() ,now()))
	End IF
	
	//grp
	lsData = Right(lsData,(len(lsData) - (Len(ls_Temp) + 1))) //Strip off until the next delimeter
	If Pos(lsData,'|') > 0 Then
		ls_Temp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		ls_Temp = lsData
	End If

	IF ls_Temp >' ' Then ldsItem.SetItem(llNewRow,'GRP', ls_Temp)
	
	//packaged_weight
	lsData = Right(lsData,(len(lsData) - (Len(ls_Temp) + 1))) //Strip off until the next delimeter
	If Pos(lsData,'|') > 0 Then
		ls_Temp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		ls_Temp = lsData
	End If

	IF isnumber(Trim(ls_Temp)) Then ldsItem.SetItem(llNewRow,'Packaged_Weight', Dec(ls_Temp))
	
	//unpackaged_weight
	lsData = Right(lsData,(len(lsData) - (Len(ls_Temp) + 1))) //Strip off until the next delimeter
	If Pos(lsData,'|') > 0 Then
		ls_Temp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		ls_Temp = lsData
	End If

	IF isnumber(Trim(ls_Temp)) Then ldsItem.SetItem(llNewRow,'Unpackaged_Weight', Dec(ls_Temp))
	
	//alternate_sku
	lsData = Right(lsData,(len(lsData) - (Len(ls_Temp) + 1))) //Strip off until the next delimeter
	If Pos(lsData,'|') > 0 Then
		ls_Temp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		ls_Temp = lsData
	End If

	IF ls_Temp >' '  Then ldsItem.SetItem(llNewRow,'Alternate_Sku', ls_Temp)
	
	//alternate_price
	lsData = Right(lsData,(len(lsData) - (Len(ls_Temp) + 1))) //Strip off until the next delimeter
	If Pos(lsData,'|') > 0 Then
		ls_Temp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		ls_Temp = lsData
	End If

	IF isnumber(Trim(ls_Temp)) Then ldsItem.SetItem(llNewRow,'Alternate_Price', Dec(ls_Temp))
	
	//lot_controlled_ind
	lsData = Right(lsData,(len(lsData) - (Len(ls_Temp) + 1))) //Strip off until the next delimeter
	If Pos(lsData,'|') > 0 Then
		ls_Temp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		ls_Temp = lsData
	End If

	IF ls_Temp >' ' Then ldsItem.SetItem(llNewRow,'Lot_Controlled_Ind', ls_Temp)
	
	//po_controlled_ind
	lsData = Right(lsData,(len(lsData) - (Len(ls_Temp) + 1))) //Strip off until the next delimeter
	If Pos(lsData,'|') > 0 Then
		ls_Temp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		ls_Temp = lsData
	End If

	IF ls_Temp >' ' Then ldsItem.SetItem(llNewRow,'PO_Controlled_Ind', ls_Temp)
	
	//po_no2_controlled_ind
	lsData = Right(lsData,(len(lsData) - (Len(ls_Temp) + 1))) //Strip off until the next delimeter
	If Pos(lsData,'|') > 0 Then
		ls_Temp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		ls_Temp = lsData
	End If

	IF ls_Temp >' ' Then ldsItem.SetItem(llNewRow,'PO_No2_Controlled_Ind', ls_Temp)
	
	//serialized_ind
	lsData = Right(lsData,(len(lsData) - (Len(ls_Temp) + 1))) //Strip off until the next delimeter
	If Pos(lsData,'|') > 0 Then
		ls_Temp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		ls_Temp = lsData
	End If

	IF ls_Temp >' ' Then ldsItem.SetItem(llNewRow,'Serialized_Ind', ls_Temp)
	
	//component_ind
	lsData = Right(lsData,(len(lsData) - (Len(ls_Temp) + 1))) //Strip off until the next delimeter
	If Pos(lsData,'|') > 0 Then
		ls_Temp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		ls_Temp = lsData
	End If

	IF ls_Temp >' ' Then ldsItem.SetItem(llNewRow,'Component_Ind', ls_Temp)
	
	//standard_of_measure
	lsData = Right(lsData,(len(lsData) - (Len(ls_Temp) + 1))) //Strip off until the next delimeter
	If Pos(lsData,'|') > 0 Then
		ls_Temp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		ls_Temp = lsData
	End If

	IF ls_Temp >' ' Then ldsItem.SetItem(llNewRow,'Standard_Of_Measure', ls_Temp)
	
	//item_delete_ind
	lsData = Right(lsData,(len(lsData) - (Len(ls_Temp) + 1))) //Strip off until the next delimeter
	If Pos(lsData,'|') > 0 Then
		ls_Temp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		ls_Temp = lsData
	End If

	IF ls_Temp >' ' Then ldsItem.SetItem(llNewRow,'Item_Delete_Ind', ls_Temp)
	
	//last_cycle_cnt_date
	lsData = Right(lsData,(len(lsData) - (Len(ls_Temp) + 1))) //Strip off until the next delimeter
	If Pos(lsData,'|') > 0 Then
		ls_Temp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		ls_Temp = lsData
	End If

	IF ls_Temp >' ' Then ldsItem.SetItem(llNewRow,'Last_Cycle_Cnt_Date', DateTime(Left(ls_Temp,4) + "/" + Mid(ls_Temp,5,2) + "/" + Mid(ls_Temp,7,2)))
	
	//hazard_text_cd
	lsData = Right(lsData,(len(lsData) - (Len(ls_Temp) + 1))) //Strip off until the next delimeter
	If Pos(lsData,'|') > 0 Then
		ls_Temp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		ls_Temp = lsData
	End If

	IF ls_Temp >' ' Then ldsItem.SetItem(llNewRow,'Hazard_Text_Cd', ls_Temp)
	
	//hazard_cd
	lsData = Right(lsData,(len(lsData) - (Len(ls_Temp) + 1))) //Strip off until the next delimeter
	If Pos(lsData,'|') > 0 Then
		ls_Temp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		ls_Temp = lsData
	End If

	IF ls_Temp >' ' Then ldsItem.SetItem(llNewRow,'Hazard_Cd', ls_Temp)
	
	//hazard_class
	lsData = Right(lsData,(len(lsData) - (Len(ls_Temp) + 1))) //Strip off until the next delimeter
	If Pos(lsData,'|') > 0 Then
		ls_Temp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		ls_Temp = lsData
	End If

	IF ls_Temp >' ' Then ldsItem.SetItem(llNewRow,'Hazard_Class', ls_Temp)
	
	//flash_point
	lsData = Right(lsData,(len(lsData) - (Len(ls_Temp) + 1))) //Strip off until the next delimeter
	If Pos(lsData,'|') > 0 Then
		ls_Temp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		ls_Temp = lsData
	End If

	IF isnumber(Trim(ls_Temp)) Then ldsItem.SetItem(llNewRow,'Flash_Point', Dec(ls_Temp))
	
	//expiration_controlled_ind
	lsData = Right(lsData,(len(lsData) - (Len(ls_Temp) + 1))) //Strip off until the next delimeter
	If Pos(lsData,'|') > 0 Then
		ls_Temp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		ls_Temp = lsData
	End If

	IF ls_Temp >' ' Then ldsItem.SetItem(llNewRow,'Expiration_Controlled_Ind', ls_Temp)
	
	//inventory_class
	lsData = Right(lsData,(len(lsData) - (Len(ls_Temp) + 1))) //Strip off until the next delimeter
	If Pos(lsData,'|') > 0 Then
		ls_Temp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		ls_Temp = lsData
	End If

	IF ls_Temp >' ' Then ldsItem.SetItem(llNewRow,'Inventory_Class', ls_Temp)
	
	//storage_code
	lsData = Right(lsData,(len(lsData) - (Len(ls_Temp) + 1))) //Strip off until the next delimeter
	If Pos(lsData,'|') > 0 Then
		ls_Temp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		ls_Temp = lsData
	End If

	IF ls_Temp >' ' Then ldsItem.SetItem(llNewRow,'Storage_Code', ls_Temp)
	
	//container_tracking_ind
	lsData = Right(lsData,(len(lsData) - (Len(ls_Temp) + 1))) //Strip off until the next delimeter
	If Pos(lsData,'|') > 0 Then
		ls_Temp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		ls_Temp = lsData
	End If

	IF ls_Temp >' ' Then ldsItem.SetItem(llNewRow,'Container_Tracking_Ind', ls_Temp)
	
	//freight_class
	lsData = Right(lsData,(len(lsData) - (Len(ls_Temp) + 1))) //Strip off until the next delimeter
	If Pos(lsData,'|') > 0 Then
		ls_Temp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		ls_Temp = lsData
	End If

	IF ls_Temp >' ' Then ldsItem.SetItem(llNewRow,'Freight_Class', ls_Temp)
	
	//part_upc_code
	lsData = Right(lsData,(len(lsData) - (Len(ls_Temp) + 1))) //Strip off until the next delimeter
	If Pos(lsData,'|') > 0 Then
		ls_Temp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		ls_Temp = lsData
	End If

	IF ls_Temp >' ' Then ldsItem.SetItem(llNewRow,'Part_UPC_Code', dec(ls_Temp))
	
	//expiration_tracking_type
	lsData = Right(lsData,(len(lsData) - (Len(ls_Temp) + 1))) //Strip off until the next delimeter
	If Pos(lsData,'|') > 0 Then
		ls_Temp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		ls_Temp = lsData
	End If

	IF ls_Temp >' ' Then ldsItem.SetItem(llNewRow,'Expiration_Tracking_Type', ls_Temp)
	
	//component_type
	lsData = Right(lsData,(len(lsData) - (Len(ls_Temp) + 1))) //Strip off until the next delimeter
	If Pos(lsData,'|') > 0 Then
		ls_Temp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		ls_Temp = lsData
	End If

	IF ls_Temp >' ' Then ldsItem.SetItem(llNewRow,'Component_Type', ls_Temp)
	
	//user_field10
	lsData = Right(lsData,(len(lsData) - (Len(ls_Temp) + 1))) //Strip off until the next delimeter
	If Pos(lsData,'|') > 0 Then
		ls_Temp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		ls_Temp = lsData
	End If

	IF ls_Temp >' ' Then ldsItem.SetItem(llNewRow,'User_Field10', ls_Temp)
	
	//user_field11
	lsData = Right(lsData,(len(lsData) - (Len(ls_Temp) + 1))) //Strip off until the next delimeter
	If Pos(lsData,'|') > 0 Then
		ls_Temp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		ls_Temp = lsData
	End If

	IF ls_Temp >' ' Then ldsItem.SetItem(llNewRow,'User_Field11', ls_Temp)
	
	//user_field12
	lsData = Right(lsData,(len(lsData) - (Len(ls_Temp) + 1))) //Strip off until the next delimeter
	If Pos(lsData,'|') > 0 Then
		ls_Temp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		ls_Temp = lsData
	End If

	IF ls_Temp >' ' Then ldsItem.SetItem(llNewRow,'User_Field12', ls_Temp)
	
	//user_field13
	lsData = Right(lsData,(len(lsData) - (Len(ls_Temp) + 1))) //Strip off until the next delimeter
	If Pos(lsData,'|') > 0 Then
		ls_Temp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		ls_Temp = lsData
	End If

	IF ls_Temp >' ' Then ldsItem.SetItem(llNewRow,'User_Field13', ls_Temp)
	
	//user_field14
	lsData = Right(lsData,(len(lsData) - (Len(ls_Temp) + 1))) //Strip off until the next delimeter
	If Pos(lsData,'|') > 0 Then
		ls_Temp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		ls_Temp = lsData
	End If

	IF ls_Temp >' ' Then ldsItem.SetItem(llNewRow,'User_Field14', ls_Temp)
	
	//user_field15
	lsData = Right(lsData,(len(lsData) - (Len(ls_Temp) + 1))) //Strip off until the next delimeter
	If Pos(lsData,'|') > 0 Then
		ls_Temp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		ls_Temp = lsData
	End If

	IF ls_Temp >' ' Then ldsItem.SetItem(llNewRow,'User_Field15', ls_Temp)
	
	//user_field16
	lsData = Right(lsData,(len(lsData) - (Len(ls_Temp) + 1))) //Strip off until the next delimeter
	If Pos(lsData,'|') > 0 Then
		ls_Temp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		ls_Temp = lsData
	End If

	IF ls_Temp >' ' Then ldsItem.SetItem(llNewRow,'User_Field16', ls_Temp)
	
	//user_field17
	lsData = Right(lsData,(len(lsData) - (Len(ls_Temp) + 1))) //Strip off until the next delimeter
	If Pos(lsData,'|') > 0 Then
		ls_Temp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		ls_Temp = lsData
	End If

	IF ls_Temp >' ' Then ldsItem.SetItem(llNewRow,'User_Field17', ls_Temp)
	
	//user_field18
	lsData = Right(lsData,(len(lsData) - (Len(ls_Temp) + 1))) //Strip off until the next delimeter
	If Pos(lsData,'|') > 0 Then
		ls_Temp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		ls_Temp = lsData
	End If

	IF ls_Temp >' ' Then ldsItem.SetItem(llNewRow,'User_Field18', ls_Temp)
	
	//user_field19
	lsData = Right(lsData,(len(lsData) - (Len(ls_Temp) + 1))) //Strip off until the next delimeter
	If Pos(lsData,'|') > 0 Then
		ls_Temp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		ls_Temp = lsData
	End If

	IF ls_Temp >' ' Then ldsItem.SetItem(llNewRow,'User_Field19', ls_Temp)
	
	//user_field20
	lsData = Right(lsData,(len(lsData) - (Len(ls_Temp) + 1))) //Strip off until the next delimeter
	If Pos(lsData,'|') > 0 Then
		ls_Temp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		ls_Temp = lsData
	End If

	IF ls_Temp >' ' Then ldsItem.SetItem(llNewRow,'User_Field20', ls_Temp)
	
	//marl_change_date
	lsData = Right(lsData,(len(lsData) - (Len(ls_Temp) + 1))) //Strip off until the next delimeter
	If Pos(lsData,'|') > 0 Then
		ls_Temp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		ls_Temp = lsData
	End If

	IF ls_Temp >' ' Then ldsItem.SetItem(llNewRow,'Marl_Change_Date', DateTime(Left(ls_Temp,4) + "/" + Mid(ls_Temp,5,2) + "/" + Mid(ls_Temp,7,2)))
	
	//quality_hold_change_date
	lsData = Right(lsData,(len(lsData) - (Len(ls_Temp) + 1))) //Strip off until the next delimeter
	If Pos(lsData,'|') > 0 Then
		ls_Temp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		ls_Temp = lsData
	End If

	IF ls_Temp >' ' Then ldsItem.SetItem(llNewRow,'Quality_Hold_Change_Date', DateTime(Left(ls_Temp,4) + "/" + Mid(ls_Temp,5,2) + "/" + Mid(ls_Temp,7,2)))
	
	//qa_check_ind
	lsData = Right(lsData,(len(lsData) - (Len(ls_Temp) + 1))) //Strip off until the next delimeter
	If Pos(lsData,'|') > 0 Then
		ls_Temp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		ls_Temp = lsData
	End If

	IF ls_Temp >' ' Then ldsItem.SetItem(llNewRow,'QA_Check_Ind', ls_Temp)
	
	//cc_group_code
	lsData = Right(lsData,(len(lsData) - (Len(ls_Temp) + 1))) //Strip off until the next delimeter
	If Pos(lsData,'|') > 0 Then
		ls_Temp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		ls_Temp = lsData
	End If

	IF ls_Temp >' ' Then ldsItem.SetItem(llNewRow,'CC_Group_Code', ls_Temp)
	
	//cc_class_code
	lsData = Right(lsData,(len(lsData) - (Len(ls_Temp) + 1))) //Strip off until the next delimeter
	If Pos(lsData,'|') > 0 Then
		ls_Temp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		ls_Temp = lsData
	End If

	IF ls_Temp >' ' Then ldsItem.SetItem(llNewRow,'CC_Class_Code', ls_Temp)
	
	//last_cc_no
	lsData = Right(lsData,(len(lsData) - (Len(ls_Temp) + 1))) //Strip off until the next delimeter
	If Pos(lsData,'|') > 0 Then
		ls_Temp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		ls_Temp = lsData
	End If

	IF ls_Temp >' ' Then ldsItem.SetItem(llNewRow,'Last_CC_No', ls_Temp)
	
	//interface_upd_req_ind
	lsData = Right(lsData,(len(lsData) - (Len(ls_Temp) + 1))) //Strip off until the next delimeter
	If Pos(lsData,'|') > 0 Then
		ls_Temp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		ls_Temp = lsData
	End If

	IF ls_Temp >' ' Then ldsItem.SetItem(llNewRow,'Interface_UPD_Req_Ind', ls_Temp)
	
	//dwg_upload
	lsData = Right(lsData,(len(lsData) - (Len(ls_Temp) + 1))) //Strip off until the next delimeter
	If Pos(lsData,'|') > 0 Then
		ls_Temp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		ls_Temp = lsData
	End If

	IF ls_Temp >' ' Then ldsItem.SetItem(llNewRow,'DWG_Upload', ls_Temp)
	
	//dwg_upload_timestamp
	lsData = Right(lsData,(len(lsData) - (Len(ls_Temp) + 1))) //Strip off until the next delimeter
	If Pos(lsData,'|') > 0 Then
		ls_Temp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		ls_Temp = lsData
	End If

	IF ls_Temp >' ' Then ldsItem.SetItem(llNewRow,'DWG_Upload_Timestamp', DateTime(ls_Temp))
	
	//native_description
	lsData = Right(lsData,(len(lsData) - (Len(ls_Temp) + 1))) //Strip off until the next delimeter
	If Pos(lsData,'|') > 0 Then
		ls_Temp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		ls_Temp = lsData
	End If

	IF ls_Temp >' ' Then ldsItem.SetItem(llNewRow,'Native_Description', ls_Temp)
	
	//create_user
	lsData = Right(lsData,(len(lsData) - (Len(ls_Temp) + 1))) //Strip off until the next delimeter
	If Pos(lsData,'|') > 0 Then
		ls_Temp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		ls_Temp = lsData
	End If

	IF NOT (IsNull(ls_Temp) OR ls_Temp= '') Then
		ldsItem.SetItem(llNewRow,'Create_User', ls_Temp)
	else
		ldsItem.SetItem(llNewRow,'Create_User', 'SIMSFP')
	End IF
	
	//no_of_children_for_parent
	lsData = Right(lsData,(len(lsData) - (Len(ls_Temp) + 1))) //Strip off until the next delimeter
	If Pos(lsData,'|') > 0 Then
		ls_Temp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		ls_Temp = lsData
	End If

	IF isnumber(Trim(ls_Temp)) Then ldsItem.SetItem(llNewRow,'No_Of_Children_For_Parent', Dec(ls_Temp))
	
	//Age
	lsData = Right(lsData,(len(lsData) - (Len(ls_Temp) + 1))) //Strip off until the next delimeter
	If Pos(lsData,'|') > 0 Then
		ls_Temp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		ls_Temp = lsData
	End If

	IF ls_Temp >' ' Then ldsItem.SetItem(llNewRow,'Age', dec(ls_Temp))
	
	//Brand
	lsData = Right(lsData,(len(lsData) - (Len(ls_Temp) + 1))) //Strip off until the next delimeter
	If Pos(lsData,'|') > 0 Then
		ls_Temp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		ls_Temp = lsData
	End If

	IF ls_Temp >' ' Then ldsItem.SetItem(llNewRow,'Brand', ls_Temp)
	
	//Color
	lsData = Right(lsData,(len(lsData) - (Len(ls_Temp) + 1))) //Strip off until the next delimeter
	If Pos(lsData,'|') > 0 Then
		ls_Temp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		ls_Temp = lsData
	End If

	IF ls_Temp >' ' Then ldsItem.SetItem(llNewRow,'Color', ls_Temp)
	
	//Color_Desc
	lsData = Right(lsData,(len(lsData) - (Len(ls_Temp) + 1))) //Strip off until the next delimeter
	If Pos(lsData,'|') > 0 Then
		ls_Temp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		ls_Temp = lsData
	End If

	IF ls_Temp >' ' Then ldsItem.SetItem(llNewRow,'Color_Desc', ls_Temp)
	
	//Gender
	lsData = Right(lsData,(len(lsData) - (Len(ls_Temp) + 1))) //Strip off until the next delimeter
	If Pos(lsData,'|') > 0 Then
		ls_Temp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		ls_Temp = lsData
	End If

	IF ls_Temp >' ' Then ldsItem.SetItem(llNewRow,'Gender', ls_Temp)
	
	//Material_Nbr
	lsData = Right(lsData,(len(lsData) - (Len(ls_Temp) + 1))) //Strip off until the next delimeter
	If Pos(lsData,'|') > 0 Then
		ls_Temp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		ls_Temp = lsData
	End If

	IF ls_Temp >' ' Then ldsItem.SetItem(llNewRow,'Material_Nbr', ls_Temp)
	
	//Product_Attribute
	lsData = Right(lsData,(len(lsData) - (Len(ls_Temp) + 1))) //Strip off until the next delimeter
	If Pos(lsData,'|') > 0 Then
		ls_Temp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		ls_Temp = lsData
	End If

	IF ls_Temp >' ' Then ldsItem.SetItem(llNewRow,'Product_Attribute', ls_Temp)
	
	//Season_Code
	lsData = Right(lsData,(len(lsData) - (Len(ls_Temp) + 1))) //Strip off until the next delimeter
	If Pos(lsData,'|') > 0 Then
		ls_Temp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		ls_Temp = lsData
	End If

	IF ls_Temp >' ' Then ldsItem.SetItem(llNewRow,'Season_Code', ls_Temp)
	
	//Size
	lsData = Right(lsData,(len(lsData) - (Len(ls_Temp) + 1))) //Strip off until the next delimeter
	If Pos(lsData,'|') > 0 Then
		ls_Temp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		ls_Temp = lsData
	End If

	IF ls_Temp >' ' Then ldsItem.SetItem(llNewRow,'Size', ls_Temp)
	
	//Style
	lsData = Right(lsData,(len(lsData) - (Len(ls_Temp) + 1))) //Strip off until the next delimeter
	If Pos(lsData,'|') > 0 Then
		ls_Temp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		ls_Temp = lsData
	End If

	IF ls_Temp >' ' Then ldsItem.SetItem(llNewRow,'Style', ls_Temp)
	
	//Commodity_Rail
	lsData = Right(lsData,(len(lsData) - (Len(ls_Temp) + 1))) //Strip off until the next delimeter
	If Pos(lsData,'|') > 0 Then
		ls_Temp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		ls_Temp = lsData
	End If

	IF ls_Temp >' ' Then ldsItem.SetItem(llNewRow,'Commodity_Rail', ls_Temp)
	
	//Commodity_Air
	lsData = Right(lsData,(len(lsData) - (Len(ls_Temp) + 1))) //Strip off until the next delimeter
	If Pos(lsData,'|') > 0 Then
		ls_Temp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		ls_Temp = lsData
	End If

	IF ls_Temp >' ' Then ldsItem.SetItem(llNewRow,'Commodity_Air', ls_Temp)
	
	//Commodity_Motor
	lsData = Right(lsData,(len(lsData) - (Len(ls_Temp) + 1))) //Strip off until the next delimeter
	If Pos(lsData,'|') > 0 Then
		ls_Temp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		ls_Temp = lsData
	End If

	IF ls_Temp >' ' Then ldsItem.SetItem(llNewRow,'Commodity_Motor', ls_Temp)
	
	//Dist_Channel
	lsData = Right(lsData,(len(lsData) - (Len(ls_Temp) + 1))) //Strip off until the next delimeter
	If Pos(lsData,'|') > 0 Then
		ls_Temp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		ls_Temp = lsData
	End If

	IF ls_Temp >' ' Then ldsItem.SetItem(llNewRow,'Dist_Channel', ls_Temp)
	
	//ECCN
	lsData = Right(lsData,(len(lsData) - (Len(ls_Temp) + 1))) //Strip off until the next delimeter
	If Pos(lsData,'|') > 0 Then
		ls_Temp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		ls_Temp = lsData
	End If

	IF ls_Temp >' ' Then ldsItem.SetItem(llNewRow,'ECCN', ls_Temp)
	
	//InterPack_Qty
	lsData = Right(lsData,(len(lsData) - (Len(ls_Temp) + 1))) //Strip off until the next delimeter
	If Pos(lsData,'|') > 0 Then
		ls_Temp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		ls_Temp = lsData
	End If

	IF isnumber(Trim(ls_Temp)) Then ldsItem.SetItem(llNewRow,'InterPack_Qty', Dec(ls_Temp))
	
	//UPC_Code2
		lsData = Right(lsData,(len(lsData) - (Len(ls_Temp) + 1))) //Strip off until the next delimeter
	If Pos(lsData,'|') > 0 Then
		ls_Temp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		ls_Temp = lsData
	End If

	IF ls_Temp >' ' Then ldsItem.SetItem(llNewRow,'UPC_Code2', ls_Temp)
	
	//UPC_Code3
	lsData = Right(lsData,(len(lsData) - (Len(ls_Temp) + 1))) //Strip off until the next delimeter
	If Pos(lsData,'|') > 0 Then
		ls_Temp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		ls_Temp = lsData
	End If

	IF ls_Temp >' ' Then ldsItem.SetItem(llNewRow,'UPC_Code3', ls_Temp)
	
	//UPC_Code4
	lsData = Right(lsData,(len(lsData) - (Len(ls_Temp) + 1))) //Strip off until the next delimeter
	If Pos(lsData,'|') > 0 Then
		ls_Temp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		ls_Temp = lsData
	End If

	IF ls_Temp >' ' Then ldsItem.SetItem(llNewRow,'UPC_Code4', ls_Temp)
	
	//Stackable
	lsData = Right(lsData,(len(lsData) - (Len(ls_Temp) + 1))) //Strip off until the next delimeter
	If Pos(lsData,'|') > 0 Then
		ls_Temp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		ls_Temp = lsData
	End If

	IF ls_Temp >' ' Then ldsItem.SetItem(llNewRow,'Stackable', ls_Temp)
	
	//Stackable_Height
	lsData = Right(lsData,(len(lsData) - (Len(ls_Temp) + 1))) //Strip off until the next delimeter
	If Pos(lsData,'|') > 0 Then
		ls_Temp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		ls_Temp = lsData
	End If

	IF isnumber(Trim(ls_Temp)) Then ldsItem.SetItem(llNewRow,'Stackable_Height', Dec(ls_Temp))
	

	//Save New Item to DB
	If lbSave = True then
		lirc = ldsItem.Update()
	else
		Rollback;
	End if
	
	IF liRC = 1 THEN
		Commit;
		
		lsLogOut ="Row: " + string(llfileRowPos) + " SKU: "+lsSku + " processed successfully!  - " + String(Today(), "mm/dd/yyyy hh:mm:ss.fff")
		gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
		FileWrite(gilogFileNo,lsLogOut)

	ELSE
		If lbSave = True then
			Rollback;
			lsLogOut = Space(17) + "- ***System Error!  Unable to Save new Item Master Record(s) to database!" +sqlca.sqlerrtext
			FileWrite(gilogFileNo,lsLogOut)
			gu_nvo_process_files.uf_writeError("- ***System Error!  Unable to Save new Item Master Record to database!")
			Return -1
			Continue
		End if
	END IF
	
Next /*File row to Process */

lsLogOut = Space(10) + String(llNew) + ' Item Records were successfully added and ' + String(llExist) + ' Records were updated.' + String(Today(), "mm/dd/yyyy hh:mm:ss.fff")
FileWrite(gilogFileNo,lsLogOut)

Destroy ldsItem 
Destroy ldsItemOrig
Destroy ldsImport
Destroy ldsSuppOwner

If lbError then
	Return -1
Else
	Return 0
End If
end function

public function integer uf_process_purchase_order (string aspath, string asproject);//28-Jan-2019 :Madhu S28685 - Philips SG & MY BlueHeart Purchase Order (PM)

String 	lsLogout, lsStringData, lsRecData, lsRecType, lsTemp, lsOrderNo, lsInvType, lsSuppCode
String		lsAction, ls_errors, sql_syntax, lsSku, lsUserLineItemNo, lsPrevOwnerCd, lsFind, lsOwnerCd
Integer	liFileNo, liRC
Long 		llNewRow, llBatchSeq, llRowCount, llRowPos, llOrderSeq, llLineSeq, llOWner, llNewDetailRow
Long		llNewExpRow, llExpOrderLine, ll_rm_count, llNewRoNoCount, llFindRow
Long		llDeleteRowCount, llDeleteRowPos
Boolean	lbError, lbDetailError, lb_treat_adds_as_updates
DateTime	ldtToday
ldtToday = DateTime(Today(),Now())

Str_parms lstr_parms

Datastore	ldsImport, ldsPOHeader, ldsPODetail, ldsPOExpansion, ldsRoNO

If Not isvalid(ldsImport) Then
	ldsImport = Create u_ds_datastore
	ldsImport.dataobject = 'd_generic_import'
End If

If Not isvalid(ldsPOHeader) Then
	ldsPOHeader = Create u_ds_datastore
	ldsPOHeader.dataobject= 'd_po_header'
	ldsPOHeader.SetTransObject(SQLCA)
End If

If Not isvalid(ldsPODetail) Then
	ldsPODetail = Create u_ds_datastore
	ldsPODetail.dataobject= 'd_po_detail'
	ldsPODetail.SetTransObject(SQLCA)
End If

If Not isvalid(ldsPOExpansion) Then
	ldsPOExpansion = Create u_ds_datastore
	ldsPOExpansion.dataobject= 'd_edi_inbound_expansion'
	ldsPOExpansion.SetTransObject(SQLCA)
End If

If Not isvalid(ldsRoNO) Then
	ldsRoNO = Create u_ds_datastore
End If

//Open and read the File In
lsLogOut = '      - Opening File for PHILIPSCLS Purchase Order Processing: ' + asPath
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

liFileNo = FileOpen(asPath,LineMode!,Read!,LockReadWrite!)
If liFileNo < 0 Then
	lsLogOut = "-       ***Unable to Open File for PHILIPSCLS Processing: " + asPath
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
	Return -99
End If

//read file and load to datastore for processing
liRC = FileRead(liFileNo,lsStringData)

Do While liRC > 0
	llNewRow = ldsImport.InsertRow(0)
	ldsImport.SetItem(llNewRow, 'rec_data',trim(lsStringData)) /*record data is the rest*/
	liRC = FileRead(liFileNo,lsStringData)
Loop /*Next File record*/

FileClose(liFileNo)

//Get the next available file sequence number
llBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asproject, 'EDI_Inbound_Header', 'EDI_Batch_Seq_No')
If llBatchSeq <= 0 Then Return -1

//records count
llRowCount = ldsImport.RowCount()

//loop through each record
For llRowPos = 1 to llRowCount
	
	lsRecData = trim(ldsImport.GetItemString(llRowPos,'rec_Data'))
	lsRecType = Left(lsRecData,2) /* rec type should be first 2 char of file*/	
	
	Choose Case Upper(lsRecType)
			
		Case 'PM' /*PO Header*/
			
			llNewRow = 	ldsPOHeader.InsertRow(0)
			llOrderSeq ++
			llLineSeq = 0
			
			//New Record Defaults
			ldsPOHeader.SetItem(llNewRow,  'EDI_Batch_Seq_No', llbatchseq) /*batch seq No*/
			ldsPOHeader.SetItem(llNewRow,  'Request_Date', String(Today(),'YYMMDD'))
			ldsPOHeader.SetItem(llNewRow,  'Order_Seq_No', llOrderSeq) 
			ldsPOHeader.SetItem(llNewRow,  'FTP_File_Name', asPath) /*FTP File Name*/
			ldsPOHeader.SetItem(llNewRow,  'Status_Cd', 'N')
			ldsPOHeader.SetItem(llNewRow,  'Last_User', 'SIMSEDI')
			ldsPOHeader.SetItem(llNewRow,  'Inventory_Type', 'N') /*default to Normal*/
					
			//Action Code
			lsRecData = Right(lsRecData,(len(lsRecData) - 3)) /*strip off to first column after rec type */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				lbError = True
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'Action Code' field. Record will not be processed.")
			End If
			
			lsAction = lsTemp
			ldsPOHeader.SetItem(llNewRow,  'Action_Cd', lsTemp) /* defaulting to add above */
			
			//Project Identifier is always PHILIPSCLS 
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			ldsPOHeader.SetItem(llNewRow, 'Project_Id',trim(lsTemp))
		
			//Warehouse Code
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData, '|') > 0 Then
				lsTemp =Left(lsRecData, (Pos(lsRecData, '|') -1))
			else
				lsTemp =lsRecData
			End If
			
			IF Pos(lsTemp, 'PHILIPS') > 0 Then
				ldsPOHeader.setItem(llNewRow,  'Wh_Code', trim(lsTemp))
			elseIf Pos(lsTemp, 'SG') > 0 Then
				ldsPOHeader.setItem(llNewRow,  'Wh_Code', 'PHILIPS')
			elseIf Pos(lsTemp, 'MY') > 0 Then
				ldsPOHeader.setItem(llNewRow,  'Wh_Code', 'PHILIPS-MY')
			End IF

			//Purchase Order No
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData, '|') > 0 Then
				lsTemp =Left(lsRecData, (Pos(lsRecData, '|') -1))
				ldsPOHeader.setItem(llNewRow,  'Order_No', trim(lsTemp))
			else
				lsTemp =lsRecData
			End If
			
			lsOrderNo = lsTemp
		
			//Order Type
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData, '|') > 0 Then
				lsTemp =Left(lsRecData, (Pos(lsRecData, '|') -1))
				ldsPOHeader.setItem(llNewRow,  'Order_Type', trim(lsTemp))
			else
				lsTemp =lsRecData
			End If

			//Supplier Code (Plant Code)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			else
				lbError = True
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'Supplier' field. Record will not be processed.")
			End If
		
			ldsPOHeader.SetItem(llNewRow, 'Supp_Code', trim(lsTemp))
					
			//Order Date
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData, '|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			else
				lbError = True
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'Order Date' field. Record will not be processed.")
			End If
			
			IF lsTemp >' ' THEN ldsPOHeader.SetItem(llNewRow, 'Ord_Date', Left(lsTemp,4) + "/" + Mid(lsTemp,5,2) + "/" + Mid(lsTemp,7,2))
			
			//Expected Delivery (Arrival) Date
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lbError = True
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'Arrival Date' field. Record will not be processed.")
			End If
					
			IF lsTemp >' ' THEN ldsPOHeader.SetItem(llNewRow, 'Arrival_Date', Left(lsTemp,4) + "/" + Mid(lsTemp,5,2) + "/" + Mid(lsTemp,7,2))
			
			//get count, if order already exists
			SELECT COUNT(*)
				INTO :ll_rm_count
			FROM receive_master with(nolock)
			WHERE Project_ID = :asproject
			AND (Supp_Invoice_No = :lsOrderNo)
			AND Ord_Status = 'N' 
			USING SQLCA;
			
			IF ll_rm_count = 1 and lsAction = 'A'  THEN	lb_treat_adds_as_updates = TRUE
			If lsAction = 'U' or lb_treat_adds_as_updates Then  //IF the Action is "U"pdate We need to issue a delete and then an Add for the entire order
			
				sql_syntax = "SELECT RO_No, SKU, line_item_no, user_line_Item_No FROM Receive_Detail with(nolock) "    
				sql_syntax += " Where RO_no in (select ro_no from receive_master with(nolock) where project_id ='"+asproject+"' and supp_invoice_no = '" + lsOrderNo + "'  and (Ord_Status = 'N' or Ord_Status = 'P'  ));"  
										
				ldsRoNo.Create(SQLCA.SyntaxFromSQL(sql_syntax,"", ls_errors))
				IF Len(ls_errors) > 0 THEN
					lsLogOut = "        *** Unable to create datastore for PHILIPSCLS Inbound Process.~r~r" + ls_errors
					FileWrite(gilogFileNo,lsLogOut)
					RETURN - 1
				END IF
				ldsRoNO.SetTransObject(SQLCA)
				llNewRoNoCount =ldsRoNo.Retrieve()
			End If


			//Carrier
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp =lsRecData
			End If
			
			ldsPOHeader.SetItem(llNewRow, 'Carrier',trim(lsTemp))

			//Supplier Invoice No
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp =lsRecData
			End If
			
			ldsPOHeader.SetItem(llNewRow, 'Supp_Order_No',trim(lsTemp))

			//AWB
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
					
			ldsPOHeader.SetItem(llNewRow, 'Awb_Bol_No', lsTemp)
			

			//Transport Mode
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
					
			ldsPOHeader.SetItem(llNewRow, 'Transport_Mode', lsTemp)
			
			//Remarks
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
					
			ldsPOHeader.SetItem(llNewRow, 'Remark', lsTemp)
			
			//User Field1
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
					
			ldsPOHeader.SetItem(llNewRow, 'User_Field1', lsTemp)
		
			//User Field2
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
					
			ldsPOHeader.SetItem(llNewRow, 'User_Field2', lsTemp)


			//User Field3
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
					
			ldsPOHeader.SetItem(llNewRow, 'User_Field3', lsTemp)

			//User Field4
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
					
			ldsPOHeader.SetItem(llNewRow, 'User_Field4', lsTemp)

			//User Field5
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
					
			ldsPOHeader.SetItem(llNewRow, 'User_Field5', lsTemp)

			//User Field6
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
					
			ldsPOHeader.SetItem(llNewRow, 'User_Field6', lsTemp)

			//User Field7
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
					
			ldsPOHeader.SetItem(llNewRow, 'User_Field7', lsTemp)

			//User Field8
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
					
			ldsPOHeader.SetItem(llNewRow, 'User_Field8', lsTemp)

			//User Field9
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
					
			ldsPOHeader.SetItem(llNewRow, 'User_Field9', lsTemp)

			//User Field10
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
					
			ldsPOHeader.SetItem(llNewRow, 'User_Field10', lsTemp)

			//User Field11
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
					
			ldsPOHeader.SetItem(llNewRow, 'User_Field11', lsTemp)

			//User Field12
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
					
			ldsPOHeader.SetItem(llNewRow, 'User_Field12', lsTemp)

			//User Field13
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
					
			ldsPOHeader.SetItem(llNewRow, 'User_Field13', lsTemp)

			//User Field14
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
					
			ldsPOHeader.SetItem(llNewRow, 'User_Field14', lsTemp)

			//User Field15
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
					
			ldsPOHeader.SetItem(llNewRow, 'User_Field15', lsTemp)

			//Rcv Slip Nbr
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			//18-Feb-2019 :Madhu DE8797 - assign order no to Rcv Slip Nbr.
			If IsNull(lsTemp) or lsTemp = '' or lsTemp =' ' Then
				ldsPOHeader.SetItem(llNewRow, 'Ship_Ref', lsOrderNo)
			else
				ldsPOHeader.SetItem(llNewRow, 'Ship_Ref', lsTemp)
			End If
			
			//Client_Cust_PO_NBR
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
					
			ldsPOHeader.SetItem(llNewRow, 'Client_Cust_PO_NBR', lsTemp)
			
			//Client_Invoice_Nbr
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
					
			ldsPOHeader.SetItem(llNewRow, 'Client_Invoice_Nbr', lsTemp)
			
			//Container_Nbr
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
					
			ldsPOHeader.SetItem(llNewRow, 'Container_Nbr', lsTemp)
			
			//Client_Order_Type
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
					
			ldsPOHeader.SetItem(llNewRow, 'Client_Order_Type', lsTemp)
			
			//Container_Type
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
					
			ldsPOHeader.SetItem(llNewRow, 'Container_Type', lsTemp)
			
			//From_Wh_Loc 
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
					
			ldsPOHeader.SetItem(llNewRow, 'From_Wh_Loc', lsTemp)
			
			//Seal_Nbr
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
					
			ldsPOHeader.SetItem(llNewRow, 'Seal_Nbr', lsTemp)
			
			//Vendor_Invoice_Nbr
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
					
			ldsPOHeader.SetItem(llNewRow, 'Vendor_Invoice_Nbr', lsTemp)

		CASE 'PD' /* detail*/
			
			lbDetailError = False
			llNewDetailRow = 	ldsPODetail.InsertRow(0)
			llLineSeq ++
					
			//Add detail level defaults
			ldsPODetail.SetItem(llNewDetailRow, 'EDI_Batch_Seq_No', llbatchseq) /*batch seq No*/
			ldsPODetail.SetItem(llNewDetailRow, 'Order_Seq_No', llOrderSeq) 
			ldsPODetail.SetItem(llNewDetailRow, 'Status_Cd', 'N') 
			ldsPODetail.SetItem(llNewDetailRow, "Order_Line_No", string(llLineSeq))
			
			//Action Code
			lsRecData = Right(lsRecData,(len(lsRecData) - 3)) /*strip off to first column after rec type */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'ACtion Code' field. Record will not be processed.")
				lbDetailError = True
			End If

			IF lb_treat_adds_as_updates Then
				ldsPODetail.SetItem(llNewDetailRow,'Action_Cd', 'U') 
			else
				ldsPODetail.SetItem(llNewDetailRow,'Action_Cd', lsTemp) //set Header Action Cd
			END IF
			
			//Project Identifier
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to first column after rec type */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'Project Identifier' field. Record will not be processed.")
				lbDetailError = True
			End If
						
			ldsPODetail.SetItem(llNewDetailRow, 'Project_Id', lsTemp)
			
			//Purchase Order Number
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'Order Number' field. Record will not be processed.")
				lbDetailError = True
			End If
			
			//Make sure we have a header for this Detail...
			If ldsPOHeader.Find("Upper(order_no) = '" + Upper(lstemp) + "'",1,ldsPOHeader.RowCount()) = 0 Then
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Detail Order Number does not match header ORder Number. Record will not be processed.")
				lbDetailError = True
			End If
			
			ldsPODetail.SetItem(llNewDetailRow, 'Order_No', trim(lsTemp))
			lsOrderNo = trim(lsTemp)

			//Supplier Code
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'Supplier Code' field. Record will not be processed.")
				lbDetailError = True
			End If
			
			lsSuppCode = lsTemp
			ldsPODetail.SetItem(llNewDetailRow, 'Supp_Code', trim(lsTemp))
						
			//Line Item Number
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'Line Item Number' field. Record will not be processed.")
				lbDetailError = True
			End If
						
			If Not isnumber(lsTemp) Then
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - 'Line Item Number' is not numeric. Record will not be processed.")
				lbDetailError = True
			Else
				ldsPODetail.SetItem(llNewDetailRow, 'Line_Item_No', Dec(trim(lsTemp)))
			End If
		
			//SKU
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Upper(Left(lsRecData,(pos(lsRecData,'|') - 1)))
			Else
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'SKU' field. Record will not be processed.")
				lbDetailError = True
			End If
			
			lsSku =lsTemp
			ldsPODetail.SetItem(llNewDetailRow, 'SKU', lsTemp)
		
			//Qty
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				lsTemp = lsRecData
			End If
		
			ldsPODetail.SetItem(llNewDetailRow, 'Quantity', trim(lsTemp))

			//Inventory Type
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			If IsNull(lsTemp) or lsTemp ='' Then 
				ldsPODetail.SetItem(llNewDetailRow, 'Inventory_Type', 'N')
			ELSE
				//TAM 2019/03/04 - Use A new table to create the Translation - Start
//				ldsPODetail.SetItem(llNewDetailRow, 'Inventory_Type', lsTemp)
				lstr_Parms = this.getxpoinventorytype( asProject, lsSuppCode, lsTemp)
				ldsPODetail.SetItem(llNewDetailRow, 'Inventory_Type', 	lstr_Parms.string_arg[1])
				//TAM 2019/03/04 - Use A new table to create the Translation - End
			END IF

			//Supplier's Material Number
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			ldsPODetail.SetItem(llNewDetailRow, 'Alternate_SKU', lsTemp) //Alternate_SKU???
			
			//Lot No 
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
						
			ldsPODetail.SetItem(llNewDetailRow,  'Lot_No', trim(lsTemp))
								
			//PO NO
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
						
			ldsPODetail.SetItem(llNewDetailRow, 'PO_No', lsTemp)
						
			//PO NO 2
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
						
			ldsPODetail.SetItem(llNewDetailRow, 'PO_No2', lsTemp)
							
			//Serial No
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
						
			ldsPODetail.SetItem(llNewDetailRow, 'Serial_No', '-') //Always set to blank
			
			//Expiration date
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			//18-Feb-2019 :Madhu DE8798 - Added DateTime format
			IF lsTemp ='' OR IsNull(lsTemp) THEN	
				ldsPODetail.SetItem(llNewDetailRow, 'Expiration_Date', DateTime('2999/12/31'))
			ELSE
				ldsPODetail.SetItem(llNewDetailRow, 'Expiration_Date', DateTime(Left(lsTemp,4) + "/" + Mid(lsTemp,5,2) + "/" + Mid(lsTemp,7,2)))
			END IF
				
			//User Line Item No
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			lsUserLineItemNo = lsTemp
			ldsPODetail.SetItem(llNewDetailRow, 'User_Line_Item_No', lsTemp)

			//User_Field1
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If

			ldsPODetail.SetItem(llNewDetailRow, 'User_Field1', lsTemp)

			//User_Field2
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If

			ldsPODetail.SetItem(llNewDetailRow, 'User_Field2', lsTemp)
			
			//User_Field3
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If

			ldsPODetail.SetItem(llNewDetailRow, 'User_Field3', lsTemp)
			
			//User_Field4
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If

			ldsPODetail.SetItem(llNewDetailRow, 'User_Field4', lsTemp)
			
			//User_Field5
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If

			ldsPODetail.SetItem(llNewDetailRow, 'User_Field5', lsTemp)
			
			//User_Field6
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If

			ldsPODetail.SetItem(llNewDetailRow, 'User_Field6', lsTemp)
			
			//Country_Of_Origin
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			IF NOT (lsTemp='' OR IsNull(lsTemp)) THEN
				ldsPODetail.SetItem(llNewDetailRow, 'Country_Of_Origin', lsTemp)
			ELSE
				ldsPODetail.SetItem(llNewDetailRow, 'Country_Of_Origin', 'XX')
			END IF

			//UOM
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			IF NOT (IsNull(lsTemp) OR lsTemp ='') THEN
				ldsPODetail.SetItem(llNewDetailRow, 'UOM', lsTemp)
			ELSE
				ldsPODetail.SetItem(llNewDetailRow, 'UOM', 'EA')
			END IF
					
			//Currency_Code
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
						
			ldsPODetail.SetItem(llNewDetailRow, 'Currency_Code', lsTemp)
			
			//Supplier_Order_Number
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
						
			ldsPODetail.SetItem(llNewDetailRow, 'Supplier_Order_Number', lsTemp)
			
			//Cust_PO_Nbr
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
						
			ldsPODetail.SetItem(llNewDetailRow, 'Cust_PO_Nbr', lsTemp)
			
			//Line_Container_Nbr
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
						
			ldsPODetail.SetItem(llNewDetailRow, 'Line_Container_Nbr', lsTemp)
			
			//Vendor_Line_Nbr
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
						
			ldsPODetail.SetItem(llNewDetailRow, 'Vendor_Line_Nbr', lsTemp)
			
			//Client_Line_Nbr
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
						
			ldsPODetail.SetItem(llNewDetailRow, 'Client_Line_Nbr', lsTemp)
			
			//Client_Cust_PO_NBR 
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
						
			ldsPODetail.SetItem(llNewDetailRow, 'Client_Cust_PO_NBR', lsTemp)
			
			//Owner Code
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			
			IF (lsPrevOwnerCd <> lsTemp OR lsTemp ='' OR IsNull(lsTemp)) THEN

				IF lsTemp ='' OR IsNull(lsTemp) THEN 
					lsOwnerCd = lsSuppCode
				ELSE
					lsOwnerCd = lsTemp					
				END IF
				
				SELECT Owner_id into :llOwner FROM Owner with(nolock)
				WHERE Project_Id = :asproject AND Owner_Type = 'S' AND owner_cd = :lsOwnerCd
				USING sqlca;
			END IF
			
			lsPrevOwnerCd = lsTemp
			
			ldsPODetail.SetItem(llNewDetailRow, 'Owner_Id', string(llOwner))
			
			//SSCC Nbr
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
						
			ldsPODetail.SetItem(llNewDetailRow, 'SSCC_Nbr', lsTemp)
			
			//Vintage
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
						
			ldsPODetail.SetItem(llNewDetailRow, 'Vintage', lsTemp)
			
			//Find detail records
			If  ldsPODetail.GetItemString(llNewDetailRow,'Action_Cd') = 'U' Then
				 lsFind = "upper(sku) = '" + upper(lsSku) +"'"
				 lsFind += " and user_line_item_no = '" + lsUserLineItemNo + "'"
				 llFindRow = ldsRoNo.Find(lsFind, 1, ldsRoNo.RowCount())
			
				If llFindRow > 0 Then 
					  // Change line item number for updated row to original line number found. 
					  ldsPODetail.SetItem(llNewDetailRow, 'Line_Item_No', ldsRoNo.GetItemNumber(llFindRow,'Line_Item_No'))
					  ldsRoNo.DeleteRow(llFindRow)
				 End If
			End If
			

			//If detail errors, delete the row...
			IF lbDetailError Then
				lbError = True
				ldsPODetail.DeleteRow(llNewDetailRow)
				Continue
			END IF
				
		CASE 'EX'
			
			llNewExpRow = ldsPOExpansion.InsertRow( 0)
			llExpOrderLine++
			
			ldsPOExpansion.SetItem(llNewExpRow,  'Project_Id', asproject)
			ldsPOExpansion.SetItem(llNewExpRow,  'EDI_Batch_Seq_No', llbatchseq)
			ldsPOExpansion.SetItem(llNewExpRow,  'Order_Seq_No', llOrderSeq)
			ldsPOExpansion.SetItem(llNewExpRow,  'Order_Line_No', llExpOrderLine)

			//Order No
			lsRecData = Right(lsRecData,(len(lsRecData) - 3)) /*strip off to first column after rec type */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			ldsPOExpansion.SetItem(llNewExpRow,  'Order_No', lsTemp)
			
			//Order User Line Item No
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to first column after rec type */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			ldsPOExpansion.SetItem(llNewExpRow,  'User_Line_Item_No', lsTemp)

			//Order Table
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to first column after rec type */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			ldsPOExpansion.SetItem(llNewExpRow,  'Order_Table', lsTemp)

			//Field_Name
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to first column after rec type */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			ldsPOExpansion.SetItem(llNewExpRow,  'Field_Name', lsTemp)


			//Field_Data
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to first column after rec type */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			ldsPOExpansion.SetItem(llNewExpRow,  'Field_Data', lsTemp)

			//Upload
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to first column after rec type */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			ldsPOExpansion.SetItem(llNewExpRow,  'Upload', lsTemp)

			
		CASE ELSE /* Invalid Rec Type*/
		
			gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Invalid Record Type: '" + lsRecType + "'. Record will not be processed.")
			Continue
		
	End Choose /*record Type*/
	
Next /*File record */

IF NOT lb_treat_adds_as_updates then
// Any Rows left in the Detail Datastore need to be deleted so create a delete detail Row for each on.
llDeleteRowCount = ldsRoNo.RowCount()
If  llDeleteRowCount > 0 Then
	For llDeleteRowPos = 1  to llDeleteRowCount 
		llNewDetailRow =  ldsPODetail.InsertRow(0)
		llLineSeq ++
		//Add detail level defaults
		ldsPODetail.SetItem(llNewDetailRow, 'Order_Seq_No', llOrderSeq) 
		ldsPODetail.SetItem(llNewDetailRow, 'Project_Id', upper(asproject)) /*project*/
		ldsPODetail.SetItem(llNewDetailRow, 'Status_Cd', 'N') 
		ldsPODetail.SetItem(llNewDetailRow, 'Inventory_Type', 'N') 
		ldsPODetail.SetItem(llNewDetailRow, 'EDI_Batch_Seq_No', llbatchseq) /*batch seq No*/
		ldsPODetail.SetItem(llNewDetailRow, 'Order_Line_No', string(llLineSeq))
		ldsPODetail.SetItem(llNewDetailRow, 'Action_Cd','D') 
		ldsPODetail.SetItem(llNewDetailRow, 'Line_Item_No', ldsRoNo.GetItemNumber(llDeleteRowPos,'line_item_no'))
		ldsPODetail.SetItem(llNewDetailRow, 'SKU', ldsRoNo.GetItemString(llDeleteRowPos,'SKU'))
		ldsPODetail.SetItem(llNewDetailRow, 'Order_No', lsOrderNo)
	Next
End If
End IF

//Save the Changes 
lirc = ldsPOHeader.Update()
	
If liRC = 1 Then
	liRC = ldsPODetail.Update()
End If

If liRC = 1 Then
	liRC = ldsPOExpansion.Update()
End If

If liRC = 1 then
	Commit;
Else
	Rollback;
	lsLogOut = Space(17) + "- ***System Error!  Unable to Save new PO Records to database! " +sqlca.sqlerrtext
	FileWrite(gilogFileNo,lsLogOut)
	gu_nvo_process_files.uf_writeError("- ***System Error!  Unable to Save new PO Records to database!")
	Return -1
End If

Destroy ldsPOHeader
Destroy ldsPODetail
Destroy ldsPOExpansion
Destroy ldsRoNO

If lbError Then
	Return -1
Else
	Return 0
End If


end function

public function string getphilipsinvtype (string asinvtype);
//Convert the Menlo Onventory Type into the Phillips code

String	lsPhilipsInvType
Choose case upper(asInvType)
		
	Case 'B'
		lsPhilipsInvType = 'B'
	Case 'C'
		lsPhilipsInvType = 'C'
	Case 'D'
		lsPhilipsInvType = 'DAM'
	Case 'K'
		lsPhilipsInvType = 'BLCK'
	Case 'L'
		lsPhilipsInvType = 'RETC'
	Case 'N'
		lsPhilipsInvType = 'MAIN'
	Case 'R'
		lsPhilipsInvType = 'VAS'
	Case 'S'
		lsPhilipsInvType = 'SCRP'
	Case 'G'
		lsPhilipsInvType = 'BWHS'
	Case 'J'
		lsPhilipsInvType = 'BOPN'
	Case 'F'
		lsPhilipsInvType = 'BBLK'
	Case 'E'
		lsPhilipsInvType = 'BDAM'
	Case Else
		lsPhilipsInvType = asInvType
End Choose

Return lsPhilipsInvType
end function

public function integer uf_process_dboh ();
//Process Daily Balance on Hand Confirmation File


Datastore	ldsOut,	&
				ldsboh
				
Long			llRowPos,	&
				llRowCount,	&
				llFindRow,	&
				llNewRow,   &
				llFileRowCount
				
String			lsOutString,	&
				lslogOut,	&
				lsProject,	&
				lsDate, &
				lsFilename, &
				lsWarehouse, &
				lsLastWarehouse, &
				lsSku, &
				lsPreviousSKU , &
				lsSupplier, &
				lsPreviousSupplier, &			
				lsInventory_Type
				
DEcimal		ldBatchSeq
Integer		liRC
DateTime	ldtNextRunTime
Date			ldtNextRunDate

String lsFileNamePath

Str_Parms lstr_Parms

ldsOut = Create Datastore
ldsOut.Dataobject = 'd_edi_generic_out'
lirc = ldsOut.SetTransobject(sqlca)

ldsboh = Create Datastore
ldsboh.Dataobject = 'd_philips_cls_dboh'
lirc = ldsboh.SetTransobject(sqlca)

lsProject = 'PHILIPSCLS'

lsLogOut = "- PROCESSING FUNCTION: '+lsproject+' BOH confirmation."
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
lsLogOut = ""
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/

//Retrive the BOH Data
gu_nvo_process_files.uf_write_log('Retrieving Balance on Hand Data.....') /*display msg to screen*/

llRowCOunt = ldsBOH.Retrieve(lsProject)

gu_nvo_process_files.uf_write_log(String(llRowCount) + ' Rows were retrieved for processing.') /*display msg to screen*/

//Write the rows to the generic output table - delimited by lsDelimitChar
gu_nvo_process_files.uf_write_log('Processing Balance on Hand Data.....') /*display msg to screen*/

For llRowPos = 1 to llRowCOunt

	lsSupplier = ldsboh.GetItemString(llRowPos,'Supp_Code')
	lsSku = ldsboh.GetItemString(llRowPos,'Sku')

	// Write a new file each time the Supplier Changes
	If lsPreviousSupplier <> lsSupplier Then //Write Header record

		//Get the Next Batch Seq Nbr - Used for all writing to generic tables
		sqlca.sp_next_avail_seq_no(lsproject,'EDI_Inbound_Header','EDI_Batch_Seq_No',ldBatchSeq)

		If ldBatchSeq <= 0 Then
			lsLogOut = "   ***Unable to retrive next available sequence number for '+lsproject+' BOH confirmation."
			FileWrite(gilogFileNo,lsLogOut)
			gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
			 Return -1
		End If

		Sleep(1) // Since the name of the file contains the time we want to wait one second for each new file to prevent a duplicate file name 
		lsDate = string(today(), "YYYYMMDDHHMMSS") 
		lsFilename = ("BH" + lsSupplier + lsDate+  ".dat")
		llFileRowCount = 1 //Keep a count of the number of rows written.  Start a new file when it reaches 500
		lsPreviousSupplier = lsSupplier
		lsPreviousSKU = lsSku


		llNewRow = ldsOut.insertRow(0)
		
		//Field Name	Type	Req.	Default	Description
		//Record_ID	C(2)	Yes	$$HEX1$$1c20$$ENDHEX$$BH$$HEX2$$1d200900$$ENDHEX$$Balance on hand identifier
	
		lsOutString = 'BH' + '|'
		lsOutString += lsDate + '|'
		lsOutString += lsSupplier	

		ldsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
		ldsOut.SetItem(llNewRow,'line_seq_no', llFileRowCount)
		ldsOut.SetItem(llNewRow,'batch_data', lsOutString)
		ldsOut.SetItem(llNewRow,'file_name', lsFilename)
		ldsOut.SetItem(llNewRow,'Project_id', 'PHILIPSCLS')

	End If

	//	Write a new file before we get to 500 rows. If we get past row 490 within the same supplier code then we want to write a new file.  We don't want to break on a SKU unless we have processed 
	// all inventory types.  There should not be more than 10 inventory types so by checking the sku change at 490 will keep us from writing over 500 lines
	If llFileRowCount > 490 and lsPreviousSKU <> lsSku then  
		//Get the Next Batch Seq Nbr - Used for all writing to generic tables
		sqlca.sp_next_avail_seq_no(lsproject,'EDI_Inbound_Header','EDI_Batch_Seq_No',ldBatchSeq)

		If ldBatchSeq <= 0 Then
			lsLogOut = "   ***Unable to retrive next available sequence number for '+lsproject+' BOH confirmation."
			FileWrite(gilogFileNo,lsLogOut)
			gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
			 Return -1
		End If

		Sleep(1) // Since the name of the file contains the time we want to wait one second for each new file to prevent a duplicate file name 
		lsDate = string(today(), "YYYYMMDDHHMMSS") 
		lsFilename = ("BH" + lsSupplier + lsDate+  ".dat")
		llFileRowCount = 1 //Keep a count of the number of rows written per file.  Start a new file when it reaches 500
		lsPreviousSupplier = lsSupplier
		lsPreviousSKU = lsSku


		llNewRow = ldsOut.insertRow(0)
		
		//Field Name	Type	Req.	Default	Description
		//Record_ID	C(2)	Yes	$$HEX1$$1c20$$ENDHEX$$BH$$HEX2$$1d200900$$ENDHEX$$Balance on hand identifier
	
		lsOutString = 'BH' + '|'
		lsOutString += lsDate + '|'
		lsOutString += lsSupplier	

		ldsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
		ldsOut.SetItem(llNewRow,'line_seq_no', llFileRowCount)
		ldsOut.SetItem(llNewRow,'batch_data', lsOutString)
		ldsOut.SetItem(llNewRow,'file_name', lsFilename)
		ldsOut.SetItem(llNewRow,'Project_id', lsProject)
	End If

	// Detail Rows
	llNewRow = ldsOut.insertRow(0)
	llFileRowCount ++ //Keep a count of the number of rows written.  Start a new file before it reaches 500

	lsOutString = 'BD' + '|'

	//GTIN  Item_master.user_field4 (not from part_upc_code)
	if IsNull(ldsboh.GetItemString(llRowPos,'user_field4'))  then
		lsOutString += '|'
	else	
	   lsOutString += ldsboh.GetItemString(llRowPos,'user_field4') + '|'
	end if		

	//SKU	
	lsOutString += ldsboh.GetItemString(llRowPos,'sku') + '|'

	//Quantity		
	//lsOutString += string(ldsboh.GetItemNumber(llRowPos,'avail_qty')+ ldsboh.GetItemNumber(llRowPos,'alloc_qty')) + '|'
	lsOutString += string(ldsboh.GetItemNumber(llRowPos,'avail_qty')) + '|'

	//Item Master UOM
	if IsNull(ldsboh.GetItemString(llRowPos,'uom_1')) OR Trim(ldsboh.GetItemString(llRowPos,'uom_1')) = ''  then
		lsOutString += '|'
	else	
	   lsOutString += ldsboh.GetItemString(llRowPos,'uom_1') + '|'
	end if		
	w_main.SetMicroHelp("Processing Record: "+ string(llRowPos) + " lsOutString1: " + lsOutString)
	
	//w_main.SetMicroHelp("Processing Record: "+ string(llRowPos) + " Supplier: " + lsSupplier + " SKU: " + lsSKU + " UOM1: " + Trim(ldsboh.GetItemString(llRowPos,'uom_1')))

//TAM 2019/03/04 - Use A new table to create the Translation - Start
	
	lsInventory_Type = ldsboh.GetItemString(llRowPos,'inventory_type')	

	lstr_Parms = this.getphilipssuppliertranslations( lsProject, lsSupplier, lsInventory_Type)
		
	lsOutString += 	lstr_Parms.string_arg[1] + '|' //Translated Inventory Type
	lsOutString += 	lstr_Parms.string_arg[2] //Translated Disposition
	
	w_main.SetMicroHelp("Processing Record: "+ string(llRowPos) + " lsOutString2: " + lsOutString)

	
	//Inventory Type	
//	lsOutString += getPhilipsInvType(ldsboh.GetItemString(llRowPos,'inventory_type')) + '|' /*Convert to Philips Inv Type */
	
	//Disposition Code	 
//	lsOutString += getPhilipsDisposition(ldsboh.GetItemString(llRowPos,'inventory_type')) /*Convert to Disposition */
//TAM 2019/03/04 - Use A new table to create the Translation - End
	
	ldsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	ldsOut.SetItem(llNewRow,'line_seq_no', llFileRowCount)
	ldsOut.SetItem(llNewRow,'batch_data', lsOutString)
	ldsOut.SetItem(llNewRow,'file_name', lsFilename)
	ldsOut.SetItem(llNewRow,'Project_id', lsProject)
	
next /*next output record */

	w_main.SetMicroHelp("Ready")

//Write the Outbound File - no need to save and re-retrieve - just use the currently loaded DW
gu_nvo_process_files.uf_process_flatfile_outbound(ldsOut,lsProject)

Return 0
end function

public function integer uf_process_delivery_order (string aspath, string asproject);//16-Feb-2019 :Madhu S29933 F13501 Philips BlueHeart Outbound Order
//22-APR-2019 :Madhu S32623 PhilipsCLS BlueHeart Load Delivery BOM

Datastore	ldsImport, ldsDOHeader, ldsDODetail,	ldsDOAddress, 	ldsDONotes, ldsDOExpansion, ldsDOBOM
String 	lsStringData, lsLogout, lsRecData, lsRecType, lsTemp, lsAction
String 	lsBillToName, lsBillToAddress1, lsBillToAddress2, lsBillToAddress3, lsBillToAddress4
String		lsBillToCity, lsBillToState, lsBillToZip, lsBillToCountry, lsBillToTel
String		lsOrder, lsNoteType, lsNoteText, lsSuppCode
String		lsSku, lsUF5, lsUF6, lsPrevUF6, lsParentSku, lsParentSuppCode
Integer	liFileNo,liRC
Long 		llNewRow, llBatchSeq, llRowCount, llRowPos, llOrderSeq, llLineSeq, llNewAddressRow
Long		llNewDetailRow, llOwner, llNewExpRow, llExpOrderLine, llRow, llDetailCount
Long		llNoteLine, llNoteSeqNo, llNewNotesRow, llNewBOMRow, llParentLineItemNo, llLineItemNo
DateTime	ldtToday, ldtOrderDate
Boolean		lbError, lbBillToAddress, lbDetailError, lbSoftBundle
Decimal	ldParentQty, ldQty
Str_Parms lstr_parms

ldtToday = DateTime(today(),Now())

//TAM 2019/03/07 - DE9294
Boolean	lbSoldToAddress 
String 	lsSoldToName, lsSoldToAddress1, lsSoldToAddress2, lsSoldToAddress3, lsSoldToAddress4
String		lsSoldToCity, lsSoldToState, lsSoldToZip, lsSoldToDistrict, lsSoldToCountry, lsSoldToTel, lsSoldToContact, lsSoldToEmail, lsSoldToFax

select Max(dateAdd( hour, 8,:ldtToday )) into :ldtOrderDate
from sysobjects;

IF Not IsValid(ldsImport) THEN
	ldsImport = Create u_ds_datastore
	ldsImport.dataobject = 'd_generic_import'
END IF

IF Not IsValid(ldsDOHeader) THEN
	ldsDOHeader = Create u_ds_datastore
	ldsDOHeader.dataobject = 'd_shp_header'
	ldsDOHeader.SetTransObject(SQLCA)
END IF

IF Not IsValid(ldsDODetail) THEN
	ldsDODetail = Create u_ds_datastore
	ldsDODetail.dataobject = 'd_shp_detail'
	ldsDODetail.SetTransObject(SQLCA)
END IF

IF Not IsValid(ldsDOAddress) THEN
	ldsDOAddress = Create u_ds_datastore
	ldsDOAddress.dataobject = 'd_mercator_do_address'
	ldsDOAddress.SetTransObject(SQLCA)
END IF

IF Not IsValid(ldsDONotes) THEN
	ldsDONotes = Create u_ds_datastore
	ldsDONotes.dataobject = 'd_mercator_do_notes'
	ldsDONotes.SetTransObject(SQLCA)
END IF

IF Not IsValid(ldsDOExpansion) THEN
	ldsDOExpansion = Create u_ds_datastore
	ldsDOExpansion.dataobject = 'd_edi_outbound_expansion'
	ldsDOExpansion.SetTransObject(SQLCA)
END IF

IF Not IsValid(ldsDOBOM) THEN
		ldsDOBOM = Create u_ds_datastore
		ldsDOBOM.dataobject ='d_delivery_bom'
		ldsDOBOM.SetTransObject(SQLCA)
END IF

//Open and read the File In
lsLogOut = '      - Opening File for PHILIPSCLS Delivery Order Processing: ' + asPath
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

liFileNo = FileOpen(asPath,LineMode!,Read!,LockReadWrite!)
If liFileNo < 0 Then
	lsLogOut = "-       ***Unable to Open File for PHILIPSCLS Processing: " + asPath
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
	Return -99
End If

//read file and load to datastore for processing
liRC = FileRead(liFileNo,lsStringData)

Do While liRC > 0
	llNewRow = ldsImport.InsertRow(0)
	ldsImport.setItem(llNewRow, 'rec_data',trim(lsStringData)) /*record data is the rest*/
	liRC = FileRead(liFileNo,lsStringData)
Loop /*Next File record*/

FileClose(liFileNo)

//Get the next available file sequence number
llBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asproject, 'EDI_Outbound_Header', 'EDI_Batch_Seq_No')
If llBatchSeq <= 0 Then Return -1

//records rowcount
llRowCount = ldsImport.RowCount()

//Process each Row
FOR llRowPos = 1 to llRowCount 
	
	lsRecData = ldsImport.getItemString(llRowpos, 'rec_data')
	lsRecType = Left(lsRecData,2)
	
	CHOOSE CASE Upper(lsRecType)
			
		//HEADER RECORD
		CASE 'DM' /* Header */

			llnewRow = ldsDOHeader.InsertRow(0)
			llOrderSeq ++
			llLineSeq = 0
			
			//Record Defaults
			ldsDOHeader.setItem(llNewRow,'EDI_Batch_Seq_No',llbatchseq) //EDI Batch Seq No
			ldsDOHeader.SetItem(llNewRow,  'Order_Seq_No', llOrderSeq)  //Order Seq No
			ldsDOHeader.SetItem(llNewRow,  'FTP_File_Name', asPath) //FTP File Name
			ldsDOHeader.SetItem(llNewRow,  'Status_Cd', 'N') //Status Cd
			ldsDOHeader.SetItem(llNewRow,  'Last_User', 'SIMSEDI') //Last User
			ldsDOHeader.SetItem(llNewRow,  'Inventory_Type', 'N') // Inventory Type
			ldsDOHeader.SetItem(llNewRow,  'OTM_Status', 'R') // OTM Status
			ldsDOHeader.setItem(llNewRow, 'Ord_Date',String(ldtOrderDate,'yyyy/mm/dd hh:mm'))

			//Action Code (DM002)
			lsRecData = Right(lsRecData,(len(lsRecData) - 3)) /*strip off to first column after rec type */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				lbError = True
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'Action Code' field. Record will not be processed.")
				ldsDOHeader.setItem(llNewRow,'status_cd','E')
			End If
			
			lsAction = lsTemp
			ldsDOHeader.setItem(llNewRow,  'Action_Cd', lsTemp)
			
			//Project Id (DM003)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lbError = True
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'Project Id' field. Record will not be processed.")
				ldsDOHeader.setItem(llNewRow,'status_cd','E')
			End If
			
			ldsDOHeader.setItem(llNewRow, 'Project_Id', trim(lsTemp))

			//Warehouse (DM004)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lbError = True
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'Warehouse' field. Record will not be processed.")
				ldsDOHeader.setItem(llNewRow,'status_cd','E')
			End If
			
			IF Pos(lsTemp, 'PHILIPS') > 0 Then
				ldsDOHeader.setItem(llNewRow,  'WH_Code', trim(lsTemp))
			elseIf Pos(lsTemp, 'SG') > 0 Then
				ldsDOHeader.setItem(llNewRow,  'WH_Code', 'PHILIPS')
			elseIf Pos(lsTemp, 'MY') > 0 Then
				ldsDOHeader.setItem(llNewRow,  'WH_Code', 'PHILIPS-MY')
			End IF
			
			//Invoice No (DM005)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lbError = True
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'Invoice No' field. Record will not be processed.")
				ldsDOHeader.setItem(llNewRow,'status_cd','E')
			End If
			
			ldsDOHeader.setItem(llNewRow, 'Invoice_No', trim(lsTemp))

			//Order Date (DM006)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lbError = True
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'Order Date' field. Record will not be processed.")
				ldsDOHeader.setItem(llNewRow,'status_cd','E')
			End If

			//dts F18218/S38884 - adding Time element to Ord_Date (now being passed as YYYYMMDD HH:MI:SS)
			//IF lsTemp >' ' THEN ldsDOHeader.SetItem(llNewRow, 'Ord_Date', Left(lsTemp,4) + "/" + Mid(lsTemp,5,2) + "/" + Mid(lsTemp,7,2))
			IF lsTemp >' ' THEN ldsDOHeader.SetItem(llNewRow, 'Ord_Date', Left(lsTemp,4) + "/" + Mid(lsTemp,5,2) + "/" + Mid(lsTemp,7,2) + Mid(lsTemp,9,9))

			//Delivery Date (DM007)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lbError = True
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'Delivery Date' field. Record will not be processed.")
				ldsDOHeader.setItem(llNewRow,'status_cd','E')
			End If

			IF lsTemp >' ' THEN ldsDOHeader.SetItem(llNewRow, 'Delivery_Date', Left(lsTemp,4) + "/" + Mid(lsTemp,5,2) + "/" + Mid(lsTemp,7,2))

			//Schedule Date (DM008)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lbError = True
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'Schedule Date' field. Record will not be processed.")
				ldsDOHeader.setItem(llNewRow,'status_cd','E')
			End If

			IF lsTemp >' ' THEN ldsDOHeader.SetItem(llNewRow, 'Schedule_Date', Left(lsTemp,4) + "/" + Mid(lsTemp,5,2) + "/" + Mid(lsTemp,7,2))

			//Cust Code (DM009)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lbError = True
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'Cust Code' field. Record will not be processed.")
				ldsDOHeader.setItem(llNewRow,'status_cd','E')
			End If
			
			ldsDOHeader.setItem(llNewRow, 'Cust_Code', trim(lsTemp))

			//Order Type (DM010)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			ldsDOHeader.setItem(llNewRow, 'Order_Type', trim(lsTemp))

			//Cust Order No (DM011)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			ldsDOHeader.setItem(llNewRow, 'Order_No', trim(lsTemp))
			
			//Carrier (DM012)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			ldsDOHeader.setItem(llNewRow, 'Carrier', trim(lsTemp))
			
			//Transport Mode (DM013)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
//			TAM - 2019/03/08 - Don't Load Transport Mode - Philips value is not valid.  Operations enters in client
//			ldsDOHeader.setItem(llNewRow, 'Transport_Mode', trim(lsTemp))
			
			//Ship Via (DM014)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			ldsDOHeader.setItem(llNewRow, 'Ship_Via', trim(lsTemp))
			
			//Frieght Terms (DM015)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			ldsDOHeader.setItem(llNewRow, 'Freight_Terms', trim(lsTemp))

			//Agent Info (DM016)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			ldsDOHeader.setItem(llNewRow, 'Agent_Info', trim(lsTemp))
			
			//ShipTo Name (DM017)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			ldsDOHeader.setItem(llNewRow, 'Cust_Name', trim(lsTemp))

			//ShipTo Address1 (DM018)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			ldsDOHeader.setItem(llNewRow, 'Address_1', trim(lsTemp))
			
			//ShipTo Address2 (DM019)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			ldsDOHeader.setItem(llNewRow, 'Address_2', trim(lsTemp))			
			
			//ShipTo Address3 (DM020)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			ldsDOHeader.setItem(llNewRow, 'Address_3', trim(lsTemp))
			
			//ShipTo Address4 (DM021)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			ldsDOHeader.setItem(llNewRow, 'Address_4', trim(lsTemp))
			
			//ShipTo City (DM022)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			ldsDOHeader.setItem(llNewRow, 'City', trim(lsTemp))
			
			//ShipTo State (DM023)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			ldsDOHeader.setItem(llNewRow, 'State', trim(lsTemp))
			
			//ShipTo Postal Code (DM024)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			ldsDOHeader.setItem(llNewRow, 'Zip', trim(lsTemp))
			
			//ShipTo Country (DM025)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			ldsDOHeader.setItem(llNewRow, 'Country', trim(lsTemp))
			
			//ShipTo Tel (DM026)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			ldsDOHeader.setItem(llNewRow, 'Tel', trim(lsTemp))
			
			//BillTo Name (DM027)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//If we have BillTo Informatio, we'll need to build Alt Address
			lbBillToAddress = False
			
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			If lsTemp > '' Then
				lbBillToAddress = True
				lsBillToName = trim(lsTemp)
			Else
				lsBillToName = ''
			End If
			
			//BillTo Address1 (DM028)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			If lsTemp > '' Then
				lbBillToAddress = True
				lsBillToAddress1 = trim(lsTemp)
			Else
				lsBillToAddress1 = ''
			End If
			
			//BillTo Address2 (DM029)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			If lsTemp > '' Then
				lbBillToAddress = True
				lsBillToAddress2 = trim(lsTemp)
			Else
				lsBillToAddress2 = ''
			End If

			//BillTo Address3 (DM030)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			If lsTemp > '' Then
				lbBillToAddress = True
				lsBillToAddress3 = trim(lsTemp)
			Else
				lsBillToAddress3 = ''
			End If

			//BillTo Address4 (DM031)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			If lsTemp > '' Then
				lbBillToAddress = True
				lsBillToAddress4 = trim(lsTemp)
			Else
				lsBillToAddress4 = ''
			End If

			//BillTo City (DM032)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			If lsTemp > '' Then
				lbBillToAddress = True
				lsBillToCity = trim(lsTemp)
			Else
				lsBillToCity = ''
			End If

			//BillTo State (DM033)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			If lsTemp > '' Then
				lbBillToAddress = True
				lsBillToState = trim(lsTemp)
			Else
				lsBillToState = ''
			End If

			//BillTo Postal Code (DM034)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			If lsTemp > '' Then
				lbBillToAddress = True
				lsBillToZip = trim(lsTemp)
			Else
				lsBillToZip = ''
			End If

			//BillTo Country (DM035)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			If lsTemp > '' Then
				lbBillToAddress = True
				lsBillToCountry = trim(lsTemp)
			Else
				lsBillToCountry = ''
			End If

			//BillTo Tel (DM036)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			If lsTemp > '' Then
				lbBillToAddress = True
				lsBillToTel = trim(lsTemp)
			Else
				lsBillToTel = ''
			End If
			
			//Remark (DM037)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			ldsDOHeader.setItem(llNewRow,'Remark',Trim(lsTemp))		

			//Shipping Instructions (DM038)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			ldsDOHeader.setItem(llNewRow,'Shipping_Instructions_Text',Trim(lsTemp))		

			//PackList Notes (DM039)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			ldsDOHeader.setItem(llNewRow,'Packlist_Notes_Text',Trim(lsTemp))

			//User Field2 (DM040)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			ldsDOHeader.setItem(llNewRow,'User_Field2',Trim(lsTemp))
			
			//User Field3 (DM041)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			ldsDOHeader.setItem(llNewRow,'User_Field3',Trim(lsTemp))
			
			//User Field4 (DM042)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			ldsDOHeader.setItem(llNewRow,'User_Field4',Trim(lsTemp))
			
			//User Field5 (DM043)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			ldsDOHeader.setItem(llNewRow,'User_Field5',Trim(lsTemp))
			
			//User Field6 (DM044)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			ldsDOHeader.setItem(llNewRow,'User_Field6',Trim(lsTemp))
			
			//User Field7 (DM045)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			ldsDOHeader.setItem(llNewRow,'User_Field7',Trim(lsTemp))
			
			//User Field8 (DM046)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			ldsDOHeader.setItem(llNewRow,'User_Field8',Trim(lsTemp))
			
			//User Field9 (DM047)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			ldsDOHeader.setItem(llNewRow,'User_Field9',Trim(lsTemp))
			
			//User Field10 (DM048)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			ldsDOHeader.setItem(llNewRow,'User_Field10',Trim(lsTemp))
			
			//User Field11 (DM049)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			ldsDOHeader.setItem(llNewRow,'User_Field11',Trim(lsTemp))
			
			//User Field12 (DM050)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			ldsDOHeader.setItem(llNewRow,'User_Field12',Trim(lsTemp))
			
			//User Field13 (DM051)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			ldsDOHeader.setItem(llNewRow,'User_Field13',Trim(lsTemp))
			
			//User Field14 (DM052)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			ldsDOHeader.setItem(llNewRow,'User_Field14',Trim(lsTemp))
			
			//User Field15 (DM053)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			ldsDOHeader.setItem(llNewRow,'User_Field15',Trim(lsTemp))
			
			//User Field16 (DM054)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			ldsDOHeader.setItem(llNewRow,'User_Field16',Trim(lsTemp))
			
			//User Field17 (DM055)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			ldsDOHeader.setItem(llNewRow,'User_Field17',Trim(lsTemp))
			
			//User Field18 (DM056)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			ldsDOHeader.setItem(llNewRow,'User_Field18',Trim(lsTemp))
			
			//Ship To Contact (DM057)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			ldsDOHeader.setItem(llNewRow,'Contact_Person',Trim(lsTemp))
			
			//Ship To Email (DM058)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			ldsDOHeader.setItem(llNewRow,'Email_Address',Trim(lsTemp))
			
			//User Field19 (DM059)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			ldsDOHeader.setItem(llNewRow,'User_Field19',Trim(lsTemp))
			
			//User Field20 (DM060)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			ldsDOHeader.setItem(llNewRow,'User_Field20',Trim(lsTemp))
			
			//User Field21 (DM061)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			ldsDOHeader.setItem(llNewRow,'User_Field21',Trim(lsTemp))
			
			//User Field22 (DM062)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			ldsDOHeader.setItem(llNewRow,'User_Field22',Trim(lsTemp))
			
			//Shipment Reference (DM063)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			ldsDOHeader.setItem(llNewRow,'Ship_Ref',Trim(lsTemp))
			
			//Department Code (DM064)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			ldsDOHeader.setItem(llNewRow,'Department_Code',Trim(lsTemp))
			
			//Division (DM065)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			ldsDOHeader.setItem(llNewRow,'Division',Trim(lsTemp))
			
			//Vendor (DM066)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			ldsDOHeader.setItem(llNewRow,'Vendor',Trim(lsTemp))
			
			//Request Date (DM067)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			IF lsTemp >' ' THEN ldsDOHeader.SetItem(llNewRow, 'Request_Date', Left(lsTemp,4) + "/" + Mid(lsTemp,5,2) + "/" + Mid(lsTemp,7,2))
			
			//Department Name (DM068)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			ldsDOHeader.setItem(llNewRow,'Department_Name',Trim(lsTemp))

			//Account Nbr (DM069)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			ldsDOHeader.setItem(llNewRow,'Account_Nbr',Trim(lsTemp))
			
			//ASN Number (DM070)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			ldsDOHeader.setItem(llNewRow,'ASN_Number',Trim(lsTemp))

			//Client Cust PO Nbr (DM071)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			ldsDOHeader.setItem(llNewRow,'Client_Cust_PO_Nbr',Trim(lsTemp))

			//Client Cust SO Nbr (DM072)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			ldsDOHeader.setItem(llNewRow,'Client_Cust_SO_Nbr',Trim(lsTemp))
			
			//Container Nbr (DM073)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			ldsDOHeader.setItem(llNewRow,'Container_Nbr',Trim(lsTemp))
			
			//Dock Code (DM074)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			ldsDOHeader.setItem(llNewRow,'Dock_Code',Trim(lsTemp))

			//Document Codes (DM075)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			ldsDOHeader.setItem(llNewRow,'Document_Codes',Trim(lsTemp))

			//Equipment Nbr (DM076)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			ldsDOHeader.setItem(llNewRow,'Equipment_Nbr',Trim(lsTemp))

			//FOB (DM077)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			ldsDOHeader.setItem(llNewRow,'FOB',Trim(lsTemp))
			
			//FOB_Bill_Duty_Acct (DM078)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			ldsDOHeader.setItem(llNewRow,'FOB_Bill_Duty_Acct',Trim(lsTemp))
			
			//FOB_Bill_Duty_Party (DM079)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			ldsDOHeader.setItem(llNewRow,'FOB_Bill_Duty_Party',Trim(lsTemp))
			
			//FOB_Bill_Freight_Party (DM080)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			ldsDOHeader.setItem(llNewRow,'FOB_Bill_Freight_Party',Trim(lsTemp))
			
			//FOB_Bill_Freight_To_Acct (DM081)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			ldsDOHeader.setItem(llNewRow,'FOB_Bill_Freight_To_Acct',Trim(lsTemp))
			
			//From_Wh_Loc (DM082)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			ldsDOHeader.setItem(llNewRow,'From_Wh_Loc',Trim(lsTemp))
			
			//Routing_Nbr (DM083)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			ldsDOHeader.setItem(llNewRow,'Routing_Nbr',Trim(lsTemp))
			
			//Seal_Nbr (DM084)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			ldsDOHeader.setItem(llNewRow,'Seal_Nbr',Trim(lsTemp))
			
			//Shipping_Route (DM085)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			ldsDOHeader.setItem(llNewRow,'Shipping_Route',Trim(lsTemp))

			//SLI_Nbr (DM086)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			ldsDOHeader.setItem(llNewRow,'SLI_Nbr',Trim(lsTemp))

			//Trax_Acct_No (DM087)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			ldsDOHeader.setItem(llNewRow,'Trax_Acct_No',Trim(lsTemp))
			
			//Trax_Duty_Terms (DM088)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			ldsDOHeader.setItem(llNewRow,'Trax_Duty_Terms',Trim(lsTemp))
			
			//Trax_Duty_Acct_No (DM089)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			ldsDOHeader.setItem(llNewRow,'Trax_Duty_Acct_No',Trim(lsTemp))
			
			//Currency_Code (DM090)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			ldsDOHeader.setItem(llNewRow,'Currency_Code',Trim(lsTemp))
			
			//Order_Tax_Amt (DM091)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			ldsDOHeader.setItem(llNewRow,'Order_Tax_Amt',Trim(lsTemp))

			//Order_Discount_Amt (DM092)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			ldsDOHeader.setItem(llNewRow,'Order_Discount_Amt', dec(lsTemp))

			//Shipping_Handling_Amt (DM093)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			ldsDOHeader.setItem(llNewRow,'Shipping_Handling_Amt', dec(lsTemp))

			//Shipment_Id (DM094)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			ldsDOHeader.setItem(llNewRow,'Shipment_Id',Trim(lsTemp))

//TAM - 2019/03/07 - DE9294 - Added Sold to Info
			
			//SoldTo Name(DM095)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			If lsTemp > '' Then
				lbSoldToAddress= True
				lsSoldToName = trim(lsTemp)
			Else
				lsSoldToName = ''
			End If
			
			//SoldTo Address1 (DM096)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			If lsTemp > '' Then
				lbSoldToAddress = True
				lsSoldToAddress1 = trim(lsTemp)
			Else
				lsSoldToAddress1 = ''
			End If
			
			//SoldTo Address2 (DM097)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			If lsTemp > '' Then
				lbSoldToAddress = True
				lsSoldToAddress2 = trim(lsTemp)
			Else
				lsSoldToAddress2 = ''
			End If

			//SoldTo Address3 (DM098)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			If lsTemp > '' Then
				lbSoldToAddress = True
				lsSoldToAddress3 = trim(lsTemp)
			Else
				lsSoldToAddress3 = ''
			End If

			//SoldTo Address4 (DM099)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			If lsTemp > '' Then
				lbSoldToAddress = True
				lsSoldToAddress4 = trim(lsTemp)
			Else
				lsSoldToAddress4 = ''
			End If

			//SoldTo City (DM0100)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			If lsTemp > '' Then
				lbSoldToAddress = True
				lsSoldToCity = trim(lsTemp)
			Else
				lsSoldToCity = ''
			End If

			//SoldTo State (DM101)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			If lsTemp > '' Then
				lbSoldToAddress = True
				lsSoldToState = trim(lsTemp)
			Else
				lsSoldToState = ''
			End If

			//SoldTo Postal Code (DM102)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			If lsTemp > '' Then
				lbSoldToAddress = True
				lsSoldToZip = trim(lsTemp)
			Else
				lsSoldToZip = ''
			End If

			//SoldTo District (DM103)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			If lsTemp > '' Then
				lbSoldToAddress = True
				lsSoldToDistrict = trim(lsTemp)
			Else
				lsSoldToDistrict = ''
			End If

			//SoldTo Country (DM104)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			If lsTemp > '' Then
				lbSoldToAddress = True
				lsSoldToCountry = trim(lsTemp)
			Else
				lsSoldToCountry = ''
			End If

			//SoldTo Tel (DM105)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			If lsTemp > '' Then
				lbSoldToAddress = True
				lsSoldToTel = trim(lsTemp)
			Else
				lsSoldToTel = ''
			End If
			
			
			//Sold To Contact (DM106)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			If lsTemp > '' Then
				lbSoldToAddress = True
				lsSoldToContact = trim(lsTemp)
			Else
				lsSoldToContact = ''
			End If
			
			//Sold To Email(DM107)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			If lsTemp > '' Then
				lbSoldToAddress = True
				lsSoldToEmail = trim(lsTemp)
			Else
				lsSoldToEmail = ''
			End If
	
			//Sold To Fax(DM108)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			If lsTemp > '' Then
				lbSoldToAddress = True
				lsSoldToFax = trim(lsTemp)
			Else
				lsSoldToFax = ''
			End If

			//If we have Bill To Information, create the Alt Address record
			If lbBillToAddress Then
				llNewAddressRow = ldsDOAddress.InsertRow(0)
				ldsDOAddress.setItem(llNewAddressRow, 'Project_Id', asproject) /*Project ID*/
				ldsDOAddress.setItem(llNewAddressRow, 'EDI_Batch_Seq_No', llbatchseq) /*batch seq No*/
				ldsDOAddress.setItem(llNewAddressRow,'Order_Seq_No',llOrderSeq) 
			
				ldsDOAddress.setItem(llNewAddressRow, 'Address_Type', 'BT') //BillTo Address
				ldsDOAddress.setItem(llNewAddressRow, 'Name', lsBillToName)
				ldsDOAddress.setItem(llNewAddressRow, 'Address_1', lsBillToAddress1)
				ldsDOAddress.setItem(llNewAddressRow, 'Address_2', lsBillToAddress2)
				ldsDOAddress.setItem(llNewAddressRow, 'Address_3', lsBillToAddress3)
				ldsDOAddress.setItem(llNewAddressRow, 'Address_4', lsBillToAddress4)
				ldsDOAddress.setItem(llNewAddressRow, 'City', lsBillToCity)
				ldsDOAddress.setItem(llNewAddressRow, 'State', lsBillToState)
				ldsDOAddress.setItem(llNewAddressRow, 'Zip', lsBillToZip)
				ldsDOAddress.setItem(llNewAddressRow, 'Country', lsBillToCountry)
					
			End If /*alt address exists*/
			
			//TAM - 2019/03/07 - DE9294 - Added Sold to Info
			//If we have Sold To Information, create the Alt Address record
			If lbSoldToAddress Then
				llNewAddressRow = ldsDOAddress.InsertRow(0)
				ldsDOAddress.setItem(llNewAddressRow, 'Project_Id', asproject) /*Project ID*/
				ldsDOAddress.setItem(llNewAddressRow, 'EDI_Batch_Seq_No', llbatchseq) /*batch seq No*/
				ldsDOAddress.setItem(llNewAddressRow,'Order_Seq_No',llOrderSeq) 
			
				ldsDOAddress.setItem(llNewAddressRow, 'Address_Type', 'ST') //SoldTo Address
				ldsDOAddress.setItem(llNewAddressRow, 'Name', lsSoldToName)
				ldsDOAddress.setItem(llNewAddressRow, 'Address_1', lsSoldToAddress1)
				ldsDOAddress.setItem(llNewAddressRow, 'Address_2', lsSoldToAddress2)
				ldsDOAddress.setItem(llNewAddressRow, 'Address_3', lsSoldToAddress3)
				ldsDOAddress.setItem(llNewAddressRow, 'Address_4', lsSoldToAddress4)
				ldsDOAddress.setItem(llNewAddressRow, 'City', lsSoldToCity)
				ldsDOAddress.setItem(llNewAddressRow, 'State', lsSoldToState)
				ldsDOAddress.setItem(llNewAddressRow, 'Zip', lsSoldToZip)
				ldsDOAddress.setItem(llNewAddressRow, 'District', lsSoldToDistrict)
				ldsDOAddress.setItem(llNewAddressRow, 'Country', lsSoldToCountry)
				ldsDOAddress.setItem(llNewAddressRow, 'Contact_Person', lsSoldToContact)
				ldsDOAddress.setItem(llNewAddressRow, 'Email_Address', lsSoldToEmail)
				ldsDOAddress.setItem(llNewAddressRow, 'Fax', lsSoldToFax)
			End If /*alt address exists*/
			
			
			
			
		// DETAIL RECORD
		CASE 'DD'

			llNewDetailRow = ldsDODetail.InsertRow(0)
			llLineSeq ++
						
			//Add detail level defaults
			ldsDODetail.setItem(llNewDetailRow, 'EDI_Batch_Seq_No', llbatchseq)
			ldsDODetail.setItem(llNewDetailRow, 'Order_Seq_No', llOrderSeq) 
			ldsDODetail.setItem(llNewDetailRow, 'Order_Line_No', String(llLineSeq))
			ldsDODetail.setItem(llNewDetailRow, 'Status_Cd', 'N')
			ldsDODetail.setItem(llNewDetailRow, 'Inventory_Type', 'N')
			
			ldsDODetail.setItem(llNewDetailRow, 'Line_Seq_No', llLineSeq) //09-MAY-2019 :Madhu DE10461 Added new column for sorting.

			//Action Code (DD002)
			lsRecData = Right(lsRecData,(len(lsRecData) - 3)) /*strip off to first column after rec type */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'ACtion Code' field. Record will not be processed.")
				lbDetailError = True
				ldsDODetail.setItem(llNewDetailRow, 'Status_Cd', 'E') 
				Continue /*Process Next Record */
			End If

			//ldsDODetail.SetItem(llNewDetailRow,'Status_Cd', lsTemp)
			
			//Project Id (DD003)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to first column after rec type */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'Project Id' field. Record will not be processed.")
				lbDetailError = True
				ldsDODetail.setItem(llNewDetailRow, 'Status_Cd', 'E') 
				Continue /*Process Next Record */
			End If
						
			ldsDODetail.SetItem(llNewDetailRow, 'Project_Id', lsTemp)
			
			//Invoice No (DD004)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to first column after rec type */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'Invoice No' field. Record will not be processed.")
				lbDetailError = True
				ldsDODetail.setItem(llNewDetailRow, 'Status_Cd', 'E') 
				Continue /*Process Next Record */
			End If
						
			ldsDODetail.SetItem(llNewDetailRow, 'Invoice_No', lsTemp)
			
			//Make sure we have a header for this Detail...
			If ldsDOHeader.Find("Upper(Invoice_No) = '" + Upper(lsTemp) + "'",1,ldsDOHeader.RowCount()) = 0 Then
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Detail Order Number does not match Header Order Number. Record will not be processed.")
				lbError = True
				ldsDODetail.setItem(llNewDetailRow,'status_cd','E')
			End If
			
			//Supp Code (DD005)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to first column after rec type */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'Supplier Code' field. Record will not be processed.")
				lbDetailError = True
				ldsDODetail.setItem(llNewDetailRow, 'Status_Cd', 'E') 
				Continue /*Process Next Record */
			End If
						
			lsSuppCode = lsTemp  //TAM 019/03/04
			ldsDODetail.SetItem(llNewDetailRow, 'Supp_Code', lsTemp)
			
			//Get the default owner for this Supplier
			llOwner = 0
			IF lsTemp >' ' THEN
				Select Owner_id into :llOwner
				From Owner with(nolock)
				Where Project_Id = :asproject and Owner_Type = 'S' and Owner_Cd = :lsTemp;
				
				If llOwner > 0 Then
					ldsDODetail.setItem(llNewDetailRow, 'Owner_Id', String(llOwner))
				End If
			ELSE
				ldsDODetail.setItem(llNewDetailRow, 'Owner_Id', String(llOwner))
			END IF

			//Line Item No (DD006)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to first column after rec type */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'Line Item No' field. Record will not be processed.")
				lbDetailError = True
				ldsDODetail.setItem(llNewDetailRow, 'Status_Cd', 'E') 
				Continue /*Process Next Record */
			End If
						
			ldsDODetail.SetItem(llNewDetailRow, 'Line_Item_No', dec(lsTemp))
			
			//Sku (DD007)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to first column after rec type */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'SKU' field. Record will not be processed.")
				lbDetailError = True
				ldsDODetail.setItem(llNewDetailRow, 'Status_Cd', 'E') 
				Continue /*Process Next Record */
			End If
						
			ldsDODetail.SetItem(llNewDetailRow, 'SKU', lsTemp)

			//Qty (DD008)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to first column after rec type */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'Quantity' field. Record will not be processed.")
				lbDetailError = True
				ldsDODetail.setItem(llNewDetailRow, 'Status_Cd', 'E') 
				Continue /*Process Next Record */
			End If
						
			ldsDODetail.SetItem(llNewDetailRow, 'Quantity', lsTemp)

			//Inventory Type (DD009)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to first column after rec type */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				lsTemp = lsRecData
			End If
						
			//08/2019 - Mike A -S36465 -F17598 - Outbound Delivery enhancement
			//Set the Inventory Type to UF7 for display purposes.
	
			ldsDODetail.SetItem(llNewDetailRow,'user_field7', Trim(lsTemp))
			
						
			//TAM 2019/03/04 - Use A new table to create the Translation Start
			//ldsDODetail.SetItem(llNewDetailRow, 'Inventory_Type', lsTemp)
			lstr_Parms = this.getxpoinventorytype( asProject, lsSuppCode, lsTemp)
			ldsDODetail.SetItem(llNewDetailRow, 'Inventory_Type', 	lstr_Parms.string_arg[1])
			//TAM 2019/03/04 - Use A new table to create the Translation - End
			
		
			
			
			//User Line Item No (DD010)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to first column after rec type */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				lsTemp = lsRecData
			End If
						
			ldsDODetail.SetItem(llNewDetailRow, 'User_Line_Item_No', lsTemp)
			
			//Alternate Sku (DD011)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to first column after rec type */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				lsTemp = lsRecData
			End If
						
			ldsDODetail.SetItem(llNewDetailRow, 'Alternate_Sku', lsTemp)
			
			//Cust Sku (DD012)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to first column after rec type */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				lsTemp = lsRecData
			End If
						
			ldsDODetail.SetItem(llNewDetailRow, 'Customer_Sku', lsTemp)
			
			//Lot No (DD013)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to first column after rec type */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				lsTemp = lsRecData
			End If
						
			ldsDODetail.SetItem(llNewDetailRow, 'Lot_No', lsTemp)
			
			//PO No (DD014)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to first column after rec type */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				lsTemp = lsRecData
			End If
						
			ldsDODetail.SetItem(llNewDetailRow, 'PO_No', lsTemp)
			
			//PO No2 (DD015)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to first column after rec type */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				lsTemp = lsRecData
			End If
						
			ldsDODetail.SetItem(llNewDetailRow, 'PO_No2', lsTemp)
			
			//Serial No (DD016)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to first column after rec type */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				lsTemp = lsRecData
			End If
						
			ldsDODetail.SetItem(llNewDetailRow, 'Serial_No', lsTemp)

			//Line Item Text (DD017)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to first column after rec type */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				lsTemp = lsRecData
			End If
						
			ldsDODetail.SetItem(llNewDetailRow, 'Line_Item_Notes', lsTemp)
			
			//User Field1 (DD018)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to first column after rec type */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				lsTemp = lsRecData
			End If
						
			ldsDODetail.SetItem(llNewDetailRow, 'User_Field1', lsTemp)

			//User Field2 (DD019)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to first column after rec type */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				lsTemp = lsRecData
			End If
						
			ldsDODetail.SetItem(llNewDetailRow, 'User_Field2', lsTemp)
			
			//User Field3 (DD020)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to first column after rec type */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				lsTemp = lsRecData
			End If
						
			ldsDODetail.SetItem(llNewDetailRow, 'User_Field3', lsTemp)
			
			//User Field4 (DD021)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to first column after rec type */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				lsTemp = lsRecData
			End If
						
			ldsDODetail.SetItem(llNewDetailRow, 'User_Field4', lsTemp)
			
			//User Field5 (DD022)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to first column after rec type */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				lsTemp = lsRecData
			End If
						
			ldsDODetail.SetItem(llNewDetailRow, 'User_Field5', lsTemp)
			
			//User Field6 (DD023)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to first column after rec type */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				lsTemp = lsRecData
			End If
						
			ldsDODetail.SetItem(llNewDetailRow, 'User_Field6', lsTemp)
			
			//User Field7 (DD024)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to first column after rec type */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				lsTemp = lsRecData
			End If
					
//			//08/2019 - Mike A -S36465 -F17598 - Outbound Delivery enhancement
			//Set the Inventory Type to UF7 for display purposes.
			//This is set above with Inventory_Type 		
					
//			ldsDODetail.SetItem(llNewDetailRow, 'User_Field7', lsTemp)
			
			//User Field8 (DD025)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to first column after rec type */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				lsTemp = lsRecData
			End If
						
			ldsDODetail.SetItem(llNewDetailRow, 'User_Field8', lsTemp)
			
			//UOM (DD026)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to first column after rec type */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				lsTemp = lsRecData
			End If
						
			ldsDODetail.SetItem(llNewDetailRow, 'UOM', lsTemp)

			//Unit Price (DD027)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to first column after rec type */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				lsTemp = lsRecData
			End If
						
			ldsDODetail.SetItem(llNewDetailRow, 'Price', lsTemp)

			//Client Cust Line No (DD028)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to first column after rec type */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				lsTemp = lsRecData
			End If
						
			ldsDODetail.SetItem(llNewDetailRow, 'Client_Cust_Line_No', lsTemp)
			
			//VAT Identifier (DD029)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to first column after rec type */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				lsTemp = lsRecData
			End If
						
			ldsDODetail.SetItem(llNewDetailRow, 'VAT_Identifier', lsTemp)

			//Buyer Part (DD030)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to first column after rec type */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				lsTemp = lsRecData
			End If
						
			ldsDODetail.SetItem(llNewDetailRow, 'Buyer_Part', lsTemp)

			//Vendor Part (DD031)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to first column after rec type */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				lsTemp = lsRecData
			End If
						
			ldsDODetail.SetItem(llNewDetailRow, 'Vendor_Part', lsTemp)
			
			//UPC (DD032)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to first column after rec type */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				lsTemp = lsRecData
			End If
						
			ldsDODetail.SetItem(llNewDetailRow, 'UPC', lsTemp)
			
			//EAN (DD033)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to first column after rec type */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				lsTemp = lsRecData
			End If
						
			ldsDODetail.SetItem(llNewDetailRow, 'EAN', lsTemp)
			
			//GTIN (DD034)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to first column after rec type */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				lsTemp = lsRecData
			End If
						
			ldsDODetail.SetItem(llNewDetailRow, 'GTIN', lsTemp)
			
			//Department_Name (DD035)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to first column after rec type */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				lsTemp = lsRecData
			End If
						
			ldsDODetail.SetItem(llNewDetailRow, 'Department_Name', lsTemp)
			
			//Division (DD036)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to first column after rec type */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				lsTemp = lsRecData
			End If
						
			ldsDODetail.SetItem(llNewDetailRow, 'Division', lsTemp)
			
			//CI_Value (DD037)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to first column after rec type */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				lsTemp = lsRecData
			End If
						
			ldsDODetail.SetItem(llNewDetailRow, 'CI_Value', lsTemp)
			
			//Currency (DD038)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to first column after rec type */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				lsTemp = lsRecData
			End If
						
			ldsDODetail.SetItem(llNewDetailRow, 'Currency', lsTemp)
			
			//Cust_Line_Nbr (DD039)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to first column after rec type */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				lsTemp = lsRecData
			End If
						
			ldsDODetail.SetItem(llNewDetailRow, 'Cust_Line_Nbr', lsTemp)
			
			//Client_Cust_Invoice (DD040)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to first column after rec type */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				lsTemp = lsRecData
			End If
						
			ldsDODetail.SetItem(llNewDetailRow, 'Client_Cust_Invoice', lsTemp)
			
			//Cust_PO_Nbr (DD041)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to first column after rec type */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				lsTemp = lsRecData
			End If
						
			ldsDODetail.SetItem(llNewDetailRow, 'Cust_PO_Nbr', lsTemp)

			//Delivery_Nbr (DD042)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to first column after rec type */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				lsTemp = lsRecData
			End If
						
			ldsDODetail.SetItem(llNewDetailRow, 'Delivery_Nbr', lsTemp)

			//Internal_Price (DD043)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to first column after rec type */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				lsTemp = lsRecData
			End If
						
			ldsDODetail.SetItem(llNewDetailRow, 'Internal_Price', lsTemp)

			//Client_Inv_Type (DD044)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to first column after rec type */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				lsTemp = lsRecData
			End If
						
			ldsDODetail.SetItem(llNewDetailRow, 'Client_Inv_Type', lsTemp)
			
			//Permit_Nbr (DD045)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to first column after rec type */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				lsTemp = lsRecData
			End If
						
			ldsDODetail.SetItem(llNewDetailRow, 'Permit_Nbr', lsTemp)
			
			//Packaging_Characteristics (DD046)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to first column after rec type */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				lsTemp = lsRecData
			End If
						
			ldsDODetail.SetItem(llNewDetailRow, 'Packaging_Characteristics', lsTemp)

			//Line_Total_Amt (DD047)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to first column after rec type */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				lsTemp = lsRecData
			End If
						
			If IsNumber (lsTemp) Then ldsDODetail.SetItem(llNewDetailRow, 'Line_Total_Amt',  dec(lsTemp))
			
			//Line_Tax_Amt (DD048)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to first column after rec type */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				lsTemp = lsRecData
			End If
						
			If IsNumber(lsTemp) Then ldsDODetail.SetItem(llNewDetailRow, 'Line_Tax_Amt',  dec(lsTemp))
			
			//Line_Discount_Amt (DD049)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to first column after rec type */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				lsTemp = lsRecData
			End If
						
			If IsNumber(lsTemp) Then ldsDODetail.SetItem(llNewDetailRow, 'Line_Discount_Amt',  dec(lsTemp))
			
			//Mark_For_Name (DD050)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to first column after rec type */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				lsTemp = lsRecData
			End If
						
			ldsDODetail.SetItem(llNewDetailRow, 'Mark_For_Name',  lsTemp)
			
			//Mark_For_Address_1 (DD051)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to first column after rec type */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				lsTemp = lsRecData
			End If
						
			ldsDODetail.SetItem(llNewDetailRow, 'Mark_For_Address_1',  lsTemp)
			
			//Mark_For_Address_2 (DD052)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to first column after rec type */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				lsTemp = lsRecData
			End If
						
			ldsDODetail.SetItem(llNewDetailRow, 'Mark_For_Address_2',  lsTemp)
			
			//Mark_For_Address_3 (DD053)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to first column after rec type */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				lsTemp = lsRecData
			End If
						
			ldsDODetail.SetItem(llNewDetailRow, 'Mark_For_Address_3',  lsTemp)
			
			//Mark_For_Address_4 (DD054)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to first column after rec type */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				lsTemp = lsRecData
			End If
						
			ldsDODetail.SetItem(llNewDetailRow, 'Mark_For_Address_4',  lsTemp)
			
			//Mark_For_City (DD055)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to first column after rec type */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				lsTemp = lsRecData
			End If
						
			ldsDODetail.SetItem(llNewDetailRow, 'Mark_For_City',  lsTemp)
			
			//Mark_For_State (DD056)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to first column after rec type */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				lsTemp = lsRecData
			End If
						
			ldsDODetail.SetItem(llNewDetailRow, 'Mark_For_State',  lsTemp)
			
			//Mark_For_Zip (DD057)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to first column after rec type */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				lsTemp = lsRecData
			End If
						
			ldsDODetail.SetItem(llNewDetailRow, 'Mark_For_Zip',  lsTemp)
			
			//Mark_For_Country (DD058)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to first column after rec type */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				lsTemp = lsRecData
			End If
						
			ldsDODetail.SetItem(llNewDetailRow, 'Mark_For_Country',  lsTemp)
	
		//Delivery Notes
		CASE	'DN' 
			//Action Code (DN002)
			lsRecData = Right(lsRecData,(len(lsRecData) - 3)) /*strip off to first column after rec type */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Notes Data expected after 'Action Code' field. Record will not be processed.")
				lbError = True
				Continue /*Process Next Record */
			End If

			//Project Id (DD003)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to first column after rec type */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Notes Data expected after 'Project Id' field. Record will not be processed.")
				lbError = True
				Continue /*Process Next Record */
			End If
					
			//Order No (DD004)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to first column after rec type */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Notes Data expected after 'Invoice No' field. Record will not be processed.")
				lbError = True
				Continue /*Process Next Record */
			End If
			
			lsOrder = lsTemp
			
			//Make sure we have a header for this Detail...
			If ldsDOHeader.Find("Upper(Invoice_No) = '" + Upper(lsOrder) + "'",1,ldsDOHeader.RowCount()) = 0 Then
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Notes Order Number does not match header Order Number. Note Record will not be processed (Delivery Order will still be loaded)..")
				Continue
			End If

			//Line Item Number (DD005)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to first column after rec type */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Notes Data expected after 'Line Item No' field. Record will not be processed.")
				lbError = True
				Continue /*Process Next Record */
			End If
			
			If IsNumber(lsTemp) Then
				llNoteLine = dec(lsTemp)
			else
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Delivery Notes 'Line Item' is not numeric: '"+lsTemp+"'. Record will not be processed.")
				lbError = True
				Continue /*Process Next Record */
			End If

			//Note Type (DD006)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to first column after rec type */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Notes Data expected after 'Note Type' field. Record will not be processed.")
				lbError = True
				Continue /*Process Next Record */
			End If
			
			lsNoteType = lsTemp
			
			//Note Sequence No (DD007)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to first column after rec type */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Notes Data expected after 'Note Sequence No' field. Record will not be processed.")
				lbError = True
				Continue /*Process Next Record */
			End If

			If IsNumber(lsTemp) Then
				llNoteSeqNo = dec(lsTemp)
			else
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Delivery Notes 'Note Sequence No' is not numeric: '"+lsTemp+"'. Record will not be processed.")
				lbError = True
				Continue /*Process Next Record */
			End If

			//Note Text (DD008)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to first column after rec type */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				lsTemp = lsRecData
			End If

			lsNoteText =lsTemp
			
			IF lsNoteText > "" THEN
				llNewNotesRow = ldsDONotes.InsertRow(0)
				ldsDONotes.setItem(llNewNotesRow, 'Project_Id', asproject)
				ldsDONotes.setItem(llNewNotesRow, 'EDI_Batch_Seq_No', llbatchseq)
				ldsDONotes.setItem(llNewNotesRow, 'Order_Seq_No', llOrderSeq) 
				ldsDONotes.setItem(llNewNotesRow, 'Note_Seq_No', llNoteSeqNo)
				ldsDONotes.setItem(llNewNotesRow, 'Invoice_No', lsOrder)
				ldsDONotes.setItem(llNewNotesRow, 'Note_Type', lsNoteType)
				ldsDONotes.setItem(llNewNotesRow, 'Line_Item_No', llNoteLine)
				ldsDONotes.setItem(llNewNotesRow, 'Note_Text', lsNoteText)
			END IF
		
		//Expansion Records
		CASE 'EX'
			llNewExpRow = ldsDOExpansion.InsertRow( 0)
			llExpOrderLine++
			
			ldsDOExpansion.SetItem(llNewExpRow,  'Project_Id', asproject)
			ldsDOExpansion.SetItem(llNewExpRow,  'EDI_Batch_Seq_No', llbatchseq)
			ldsDOExpansion.SetItem(llNewExpRow,  'Order_Seq_No', llOrderSeq)
			ldsDOExpansion.SetItem(llNewExpRow,  'Order_Line_No', llExpOrderLine)

			//Order No
			lsRecData = Right(lsRecData,(len(lsRecData) - 3)) /*strip off to first column after rec type */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			ldsDOExpansion.SetItem(llNewExpRow,  'Order_No', lsTemp)
			
			//Order User Line Item No
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to first column after rec type */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			ldsDOExpansion.SetItem(llNewExpRow,  'User_Line_Item_No', lsTemp)

			//Order Table
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to first column after rec type */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			ldsDOExpansion.SetItem(llNewExpRow,  'Order_Table', lsTemp)

			//Field_Name
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to first column after rec type */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			ldsDOExpansion.SetItem(llNewExpRow,  'Field_Name', lsTemp)


			//Field_Data
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to first column after rec type */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			ldsDOExpansion.SetItem(llNewExpRow,  'Field_Data', lsTemp)

			//Upload
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to first column after rec type */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			ldsDOExpansion.SetItem(llNewExpRow,  'Upload', lsTemp)

		CASE ELSE /*Invalid rec type */
			
			IF llRowPos < llRowCount Then
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Invalid Record Type: '" + lsRecType + "'. Record will not be processed (Delivery Order will still be loaded).")
				lbError = True
			End IF
		END CHOOSE
NEXT

//22-APR-2019 :Madhu S32623 PhilipsCLS BlueHeart Load Delivery BOM - START
//a. Sort by UF6, Line Seq No and Loop through EDI_Outbound_Detail records
//b. User_Field5 = Handling Instruction Code (NONPIC ,PIC)
//c. User_Field6 =Handling Instruction Text (001, 002 etc.,)

//d. Soft Bundle = Remove leading zero's and length(SKU) =7 and UF5 =NONPIC & UF6 (001, 002 etc.,)
//e. Hard Bundle = UF5 =PIC & UF6 (i.e., 001, 002 etc.,)
//f. Group Soft &Hard Bundle based on UF6 and move Hard Bunldes to Delivery BOM Table.
//g. Only Soft Bundles should be present in EDI_Outbound_Detail and Delivery_Detail Table.

ldsDODetail.setsort( "User_Field6 D, Line_Seq_No D") //09-MAY-2019 :Madhu DE10461 Added new column for sorting
ldsDODetail.sort( )
llDetailCount = ldsDODetail.rowcount( )

//Loop in reverse Order (NONPIC followed by PIC and 001 followed by 002 etc.,)
FOR llRow = llDetailCount to 1 Step -1
	
	lsSku = ldsDODetail.getItemString( llRow, 'SKU')
	lsSuppCode = ldsDODetail.getItemString( llRow, 'Supp_Code')
	lsUF5 = ldsDODetail.getItemString( llRow, 'User_Field5')
	lsUF6 = ldsDODetail.getItemString( llRow, 'User_Field6')
	llLineItemNo = ldsDODetail.getItemNumber( llRow, 'Line_Item_No')
	ldQty = Dec(ldsDODetail.getItemString( llRow, 'Quantity'))
	
	IF lsUF6 = '000' THEN continue
	
	//determine, whether the SKU is Soft Bundle or not	
	IF upper(lsUF5) ='NONPIC' and len(this.remove_leading_zeros( lsSKU)) =7 THEN
		lbSoftBundle = TRUE
		lsParentSku =lsSku
		lsParentSuppCode = lsSuppCode
		llParentLineItemNo = llLineItemNo
		ldParentQty = ldQty
		
	ELSEIF upper(lsUF5) ='NONPIC' and len(this.remove_leading_zeros( lsSKU)) <> 7 THEN
		lbSoftBundle = FALSE	
		
	//TAM 2019/05/07 - DE10394 - Need to check if Previous UF6 has changed
	ELSEIF upper(lsUF5) ='PIC' and len(this.remove_leading_zeros( lsSKU)) =7 and lsPrevUF6 <> lsUF6 THEN
		lbSoftBundle = FALSE //It is a hardbundle group
		
	END IF
	
	IF lbSoftBundle and upper(lsUF5) ='PIC' and lsPrevUF6 = lsUF6 THEN
		
		//Insert into Delivery BOM
		llNewBOMRow = ldsDOBOM.insertrow( 0)
		ldsDOBOM.setItem( llNewBOMRow, 'Project_Id', ldsDODetail.getItemString( llRow, 'Project_Id'))
		
		ldsDOBOM.setItem( llNewBOMRow, 'EDI_Batch_Seq_No', ldsDODetail.getItemNumber( llRow, 'EDI_Batch_Seq_No'))
		ldsDOBOM.setItem( llNewBOMRow, 'Order_Seq_No', ldsDODetail.getItemNumber( llRow, 'Order_Seq_No'))
		ldsDOBOM.setItem( llNewBOMRow, 'Line_Item_No', llParentLineItemNo)
		ldsDOBOM.setItem( llNewBOMRow, 'Child_Line_Item_No', llLineItemNo)
		ldsDOBOM.setItem( llNewBOMRow, 'Sku_Parent', lsParentSku)
		ldsDOBOM.setItem( llNewBOMRow, 'Sku_Child', lsSku)
		ldsDOBOM.setItem( llNewBOMRow, 'Supp_Code_Parent', lsParentSuppCode)
		ldsDOBOM.setItem( llNewBOMRow, 'Supp_Code_Child', ldsDODetail.getItemString( llRow, 'Supp_Code'))
		ldsDOBOM.setItem( llNewBOMRow, 'Child_Qty', ldQty /ldParentQty)
		ldsDOBOM.setItem( llNewBOMRow, 'User_Field1', ldsDODetail.getItemString( llRow, 'User_Field1'))
		ldsDOBOM.setItem( llNewBOMRow, 'User_Field2', ldsDODetail.getItemString( llRow, 'User_Field2'))
		ldsDOBOM.setItem( llNewBOMRow, 'User_Field3', ldsDODetail.getItemString( llRow, 'User_Field3'))
		ldsDOBOM.setItem( llNewBOMRow, 'User_Field4', ldsDODetail.getItemString( llRow, 'User_Field4'))
		ldsDOBOM.setItem( llNewBOMRow, 'User_Field5', ldsDODetail.getItemString( llRow, 'User_Field5'))
		ldsDOBOM.setItem( llNewBOMRow, 'User_Field6', ldsDODetail.getItemString( llRow, 'User_Field6'))
		ldsDOBOM.setItem( llNewBOMRow, 'Owner_Id', Dec(ldsDODetail.getItemString( llRow, 'Owner_Id')))
		ldsDOBOM.setItem( llNewBOMRow, 'Pick_Lot_No', ldsDODetail.getItemString( llRow, 'Lot_No'))
		ldsDOBOM.setItem( llNewBOMRow, 'Pick_Po_No', ldsDODetail.getItemString( llRow, 'Po_No'))
		ldsDOBOM.setItem( llNewBOMRow, 'Pick_Po_No2', ldsDODetail.getItemString( llRow, 'Po_No2'))
		ldsDOBOM.setItem( llNewBOMRow, 'Inventory_Type', ldsDODetail.getItemString( llRow, 'Inventory_Type'))
				
		//Delete current record
		ldsDODetail.deleterow( llRow)
		
	END IF
	
	lsPrevUF6 = lsUF6
	
NEXT

//22-APR-2019 :Madhu S32623 PhilipsCLS BlueHeart Load Delivery BOM - END

//Save Changes to Database
liRC = ldsDOHeader.Update()
IF liRC = 1 THEN liRC = ldsDODetail.Update()
IF liRC = 1 THEN liRC = ldsDOAddress.Update()
IF liRC = 1 THEN liRC = ldsDONotes.Update()
IF liRC = 1 THEN liRC = ldsDOBOM.Update()
IF liRC = 1 THEN liRC = ldsDOExpansion.Update()

IF liRC = 1 THEN
	Commit;
ELSE
	Rollback;
	lsLogOut =  "       ***System Error!  Unable to Save new Delivery Orders Records to database "
	FileWrite(gilogFileNo,lsLogOut)
	gu_nvo_process_files.uf_writeError(lsLogOut)
	Return -1
END IF

destroy ldsImport
destroy ldsDOHeader 
destroy ldsDODetail
destroy ldsDOAddress
destroy ldsDONotes
destroy ldsDOBOM
destroy ldsDOExpansion


IF lbError THEN 
	Return -1
ELSE
	Return 0
END IF
end function

public function integer uf_process_return_order (string aspath, string asproject);//17-Feb-2019 :Madhu S29553 - Philips SG & MY BlueHeart Return Order (RM)

String 	lsLogout, lsStringData, lsRecData, lsRecType, lsTemp, lsOrderNo, lsInvType, lsSuppCode
String		lsAction, ls_errors, sql_syntax, lsSku, lsUserLineItemNo, lsPrevOwnerCd, lsFind, lsOwnerCd
String		lsOrder, lsNoteText, lsNoteType
Integer	liFileNo, liRC
Long 		llNewRow, llBatchSeq, llRowCount, llRowPos, llOrderSeq, llLineSeq, llOWner, llNewDetailRow
Long		llNewExpRow, llExpOrderLine, ll_rm_count, llNewRoNoCount, llFindRow
Long		llDeleteRowCount, llDeleteRowPos, llNewAddressRow
Long		llNoteLine, llNoteSeq, llNewNotesRow
Boolean	lbError, lbDetailError, lb_treat_adds_as_updates
DateTime	ldtToday
ldtToday = DateTime(Today(),Now())
Str_Parms	lstr_Parms
Datastore	ldsImport, ldsROHeader, ldsRODetail, ldsROAddress, ldsRONotes,  ldsPOExpansion, ldsRoNO

If Not isvalid(ldsImport) Then
	ldsImport = Create u_ds_datastore
	ldsImport.dataobject = 'd_generic_import'
End If

If Not isvalid(ldsROHeader) Then
	ldsROHeader = Create u_ds_datastore
	ldsROHeader.dataobject= 'd_po_header'
	ldsROHeader.SetTransObject(SQLCA)
End If

If Not isvalid(ldsRODetail) Then
	ldsRODetail = Create u_ds_datastore
	ldsRODetail.dataobject= 'd_po_detail'
	ldsRODetail.SetTransObject(SQLCA)
End If

If Not isvalid(ldsROAddress) Then
	ldsROAddress = Create u_ds_datastore
	ldsROAddress.dataobject = 'd_mercator_ro_address'
	ldsROAddress.SetTransObject(SQLCA)
End If

If Not isvalid(ldsRONotes) Then
	ldsRONotes = Create u_ds_datastore
	ldsRONotes.dataobject = 'd_mercator_ro_notes'
	ldsRONotes.SetTransObject(SQLCA)
End If

If Not isvalid(ldsPOExpansion) Then
	ldsPOExpansion = Create u_ds_datastore
	ldsPOExpansion.dataobject= 'd_edi_inbound_expansion'
	ldsPOExpansion.SetTransObject(SQLCA)
End If

If Not isvalid(ldsRoNO) Then
	ldsRoNO = Create u_ds_datastore
End If

//Open and read the File In
lsLogOut = '      - Opening File for PHILIPSCLS Return Orders Processing: ' + asPath
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

liFileNo = FileOpen(asPath,LineMode!,Read!,LockReadWrite!)
If liFileNo < 0 Then
	lsLogOut = "-       ***Unable to Open File for PHILIPSCLS Processing: " + asPath
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
	Return -99
End If

//read file and load to datastore for processing
liRC = FileRead(liFileNo,lsStringData)

Do While liRC > 0
	llNewRow = ldsImport.InsertRow(0)
	ldsImport.SetItem(llNewRow, 'rec_data',trim(lsStringData)) /*record data is the rest*/
	liRC = FileRead(liFileNo,lsStringData)
Loop /*Next File record*/

FileClose(liFileNo)

//Get the next available file sequence number
llBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asproject, 'EDI_Inbound_Header', 'EDI_Batch_Seq_No')
If llBatchSeq <= 0 Then Return -1

//records count
llRowCount = ldsImport.RowCount()

//loop through each record
For llRowPos = 1 to llRowCount
	
	lsRecData = trim(ldsImport.GetItemString(llRowPos,'rec_Data'))
	lsRecType = Left(lsRecData,2) /* rec type should be first 2 char of file*/	
	
	Choose Case Upper(lsRecType)
			
		Case 'RM' /*PO Header*/
			
			llNewRow = 	ldsROHeader.InsertRow(0)
			llOrderSeq ++
			llLineSeq = 0
			
			//New Record Defaults
			ldsROHeader.SetItem(llNewRow,  'EDI_Batch_Seq_No', llbatchseq) /*batch seq No*/
			ldsROHeader.SetItem(llNewRow,  'Request_Date', String(Today(),'YYMMDD'))
			ldsROHeader.SetItem(llNewRow,  'Order_Seq_No', llOrderSeq) 
			ldsROHeader.SetItem(llNewRow,  'FTP_File_Name', asPath) /*FTP File Name*/
			ldsROHeader.SetItem(llNewRow,  'Status_Cd', 'N')
			ldsROHeader.SetItem(llNewRow,  'Last_User', 'SIMSEDI')
			ldsROHeader.SetItem(llNewRow,  'Inventory_Type', 'N') /*default to Normal*/
					
			//Action Code
			lsRecData = Right(lsRecData,(len(lsRecData) - 3)) /*strip off to first column after rec type */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				lbError = True
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'Action Code' field. Record will not be processed.")
			End If
			
			lsAction = lsTemp
			ldsROHeader.SetItem(llNewRow,  'Action_Cd', lsTemp) /* defaulting to add above */
			
			//Project Identifier is always PHILIPSCLS 
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			ldsROHeader.SetItem(llNewRow, 'Project_Id',trim(lsTemp))
		
			//Warehouse Code
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData, '|') > 0 Then
				lsTemp =Left(lsRecData, (Pos(lsRecData, '|') -1))
			else
				lsTemp =lsRecData
			End If
			
			IF Pos(lsTemp, 'PHILIPS') > 0 Then
				ldsROHeader.setItem(llNewRow,  'Wh_Code', trim(lsTemp))
			elseIf Pos(lsTemp, 'SG') > 0 Then
				ldsROHeader.setItem(llNewRow,  'Wh_Code', 'PHILIPS')
			elseIf Pos(lsTemp, 'MY') > 0 Then
				ldsROHeader.setItem(llNewRow,  'Wh_Code', 'PHILIPS-MY')
			End IF

			//Purchase Order No
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData, '|') > 0 Then
				lsTemp =Left(lsRecData, (Pos(lsRecData, '|') -1))
				ldsROHeader.setItem(llNewRow,  'Order_No', trim(lsTemp))
			else
				lsTemp =lsRecData
			End If
			
			lsOrderNo = lsTemp
		
			//Order Type
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData, '|') > 0 Then
				lsTemp =Left(lsRecData, (Pos(lsRecData, '|') -1))
				ldsROHeader.setItem(llNewRow,  'Order_Type', trim(lsTemp))
			else
				lsTemp =lsRecData
			End If

			//Supplier Code (Plant Code)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			else
				lbError = True
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'Supplier' field. Record will not be processed.")
			End If
		
			ldsROHeader.SetItem(llNewRow, 'Supp_Code', trim(lsTemp))
					
			//Order Date
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData, '|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			else
				lbError = True
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'Order Date' field. Record will not be processed.")
			End If
			
			IF lsTemp >' ' THEN ldsROHeader.SetItem(llNewRow, 'Ord_Date', Left(lsTemp,4) + "/" + Mid(lsTemp,5,2) + "/" + Mid(lsTemp,7,2))
			
			//Expected Delivery (Arrival) Date
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lbError = True
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'Arrival Date' field. Record will not be processed.")
			End If
					
			IF lsTemp >' ' THEN ldsROHeader.SetItem(llNewRow, 'Arrival_Date',Left(lsTemp,4) + "/" + Mid(lsTemp,5,2) + "/" + Mid(lsTemp,7,2))
			
			//get count, if order already exists
			SELECT COUNT(*)
				INTO :ll_rm_count
			FROM receive_master with(nolock)
			WHERE Project_ID = :asproject
			AND (Supp_Invoice_No = :lsOrderNo)
			AND Ord_Status = 'N' 
			USING SQLCA;
			
			IF ll_rm_count = 1 and lsAction = 'A'  THEN	lb_treat_adds_as_updates = TRUE
			If lsAction = 'U' or lb_treat_adds_as_updates Then  //IF the Action is "U"pdate We need to issue a delete and then an Add for the entire order
			
				sql_syntax = "SELECT RO_No, SKU, line_item_no, user_line_Item_No FROM Receive_Detail with(nolock) "    
				sql_syntax += " Where RO_no in (select ro_no from receive_master with(nolock) where project_id ='"+asproject+"' and supp_invoice_no = '" + lsOrderNo + "'  and (Ord_Status = 'N' or Ord_Status = 'P'  ));"  
										
				ldsRoNo.Create(SQLCA.SyntaxFromSQL(sql_syntax,"", ls_errors))
				IF Len(ls_errors) > 0 THEN
					lsLogOut = "        *** Unable to create datastore for PHILIPSCLS Inbound Process.~r~r" + ls_errors
					FileWrite(gilogFileNo,lsLogOut)
					RETURN - 1
				END IF
				ldsRoNO.SetTransObject(SQLCA)
				llNewRoNoCount =ldsRoNo.Retrieve()
			End If


			//Carrier
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp =lsRecData
			End If
			
			ldsROHeader.SetItem(llNewRow, 'Carrier',trim(lsTemp))

			//Supplier Invoice No
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp =lsRecData
			End If
			
			ldsROHeader.SetItem(llNewRow, 'Supp_Order_No',trim(lsTemp))

			//AWB
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
					
			ldsROHeader.SetItem(llNewRow, 'Awb_Bol_No', lsTemp)
			

			//Transport Mode
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
					
			ldsROHeader.SetItem(llNewRow, 'Transport_Mode', lsTemp)
			
			//Remarks
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
					
			ldsROHeader.SetItem(llNewRow, 'Remark', lsTemp)
			
			//User Field1
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
					
			ldsROHeader.SetItem(llNewRow, 'User_Field1', lsTemp)
		
			//User Field2
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
					
			ldsROHeader.SetItem(llNewRow, 'User_Field2', lsTemp)


			//User Field3
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
					
			ldsROHeader.SetItem(llNewRow, 'User_Field3', lsTemp)

			//User Field4
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
					
			ldsROHeader.SetItem(llNewRow, 'User_Field4', lsTemp)

			//User Field5
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
					
			ldsROHeader.SetItem(llNewRow, 'User_Field5', lsTemp)

			//User Field6
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
					
			ldsROHeader.SetItem(llNewRow, 'User_Field6', lsTemp)

			//User Field7
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
					
			ldsROHeader.SetItem(llNewRow, 'User_Field7', lsTemp)

			//User Field8
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
					
			ldsROHeader.SetItem(llNewRow, 'User_Field8', lsTemp)

			//User Field9
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
					
			ldsROHeader.SetItem(llNewRow, 'User_Field9', lsTemp)

			//User Field10
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
					
			ldsROHeader.SetItem(llNewRow, 'User_Field10', lsTemp)

			//User Field11
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
					
			ldsROHeader.SetItem(llNewRow, 'User_Field11', lsTemp)

			//User Field12
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
					
			ldsROHeader.SetItem(llNewRow, 'User_Field12', lsTemp)

			//User Field13
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
					
			ldsROHeader.SetItem(llNewRow, 'User_Field13', lsTemp)

			//User Field14
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
					
			ldsROHeader.SetItem(llNewRow, 'User_Field14', lsTemp)

			//User Field15
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
					
			ldsROHeader.SetItem(llNewRow, 'User_Field15', lsTemp)

			//Rcv Slip Nbr
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			//18-Feb-2019 :Madhu DE8797 - assign order no to Rcv Slip Nbr.
			If IsNull(lsTemp) or lsTemp = '' or lsTemp =' ' Then
				ldsROHeader.SetItem(llNewRow, 'Ship_Ref', lsOrderNo)
			else
				ldsROHeader.SetItem(llNewRow, 'Ship_Ref', lsTemp)
			End If
			
			//Client_Cust_PO_NBR
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
					
			ldsROHeader.SetItem(llNewRow, 'Client_Cust_PO_NBR', lsTemp)
			
			//Client_Invoice_Nbr
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
					
			ldsROHeader.SetItem(llNewRow, 'Client_Invoice_Nbr', lsTemp)
			
			//Container_Nbr
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
					
			ldsROHeader.SetItem(llNewRow, 'Container_Nbr', lsTemp)
			
			//Client_Order_Type
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
					
			ldsROHeader.SetItem(llNewRow, 'Client_Order_Type', lsTemp)
			
			//Container_Type
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
					
			ldsROHeader.SetItem(llNewRow, 'Container_Type', lsTemp)
			
			//From_Wh_Loc 
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
					
			ldsROHeader.SetItem(llNewRow, 'From_Wh_Loc', lsTemp)
			
			//Seal_Nbr
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
					
			ldsROHeader.SetItem(llNewRow, 'Seal_Nbr', lsTemp)
			
			//Vendor_Invoice_Nbr
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
					
			ldsROHeader.SetItem(llNewRow, 'Vendor_Invoice_Nbr', lsTemp)
			
			//Receive Alt Address
			llNewAddressRow = 	ldsROAddress.InsertRow(0)
			
			//New Record Defaults
			ldsROAddress.SetItem(llNewAddressRow, 'Project_Id', asproject) //Project Id
			ldsROAddress.SetItem(llNewAddressRow, 'EDI_Batch_Seq_No', llbatchseq) /*batch seq No*/
			//ldsROAddress.SetItem(llNewAddressRow, 'Order_Seq_No', llOrderSeq) 

			//Receive_Alt_Address.Address_Type
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
					
			ldsROAddress.SetItem(llNewAddressRow, 'Address_Type', lsTemp)
			
			//Receive_Alt_address.Name
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
					
			ldsROAddress.SetItem(llNewAddressRow, 'Name', lsTemp)

			//Receive_Alt_address.Address_1
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
					
			ldsROAddress.SetItem(llNewAddressRow, 'Address_1', lsTemp)

			//Receive_Alt_address.Address_2
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
					
			ldsROAddress.SetItem(llNewAddressRow, 'Address_2', lsTemp)

			//Receive_Alt_address.Address_3
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
					
			ldsROAddress.SetItem(llNewAddressRow, 'Address_3', lsTemp)

			//Receive_Alt_address.Address_4
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
					
			ldsROAddress.SetItem(llNewAddressRow, 'Address_4', lsTemp)

			//Receive_Alt_address.Address_5
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
					
			ldsROAddress.SetItem(llNewAddressRow, 'Address_5', lsTemp)

			//Receive_Alt_address.Address_6
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
					
			ldsROAddress.SetItem(llNewAddressRow, 'Address_6', lsTemp)

			//Receive_Alt_address.City
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
					
			ldsROAddress.SetItem(llNewAddressRow, 'City', lsTemp)

			//Receive_Alt_address.State
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
					
			ldsROAddress.SetItem(llNewAddressRow, 'State', lsTemp)

			//Receive_Alt_Address.Zip
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
					
			ldsROAddress.SetItem(llNewAddressRow, 'Zip', lsTemp)

			//Receive_Alt_Address.District
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
					
			ldsROAddress.SetItem(llNewAddressRow, 'District', lsTemp)

			//Receive_Alt_Address.Country
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
					
			ldsROAddress.SetItem(llNewAddressRow, 'Country', lsTemp)

			//Receive_Alt_Address.Tel
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
					
			ldsROAddress.SetItem(llNewAddressRow, 'Tel', lsTemp)

			//Receive_Alt_Address.Order_Seq_No
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
					
			//ldsROAddress.SetItem(llNewAddressRow, 'Order_Seq_No', long(lsTemp))
			ldsROAddress.SetItem(llNewAddressRow, 'Order_Seq_No', llOrderSeq)
			

			//Receive_Alt_Address.Contact_Person
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
					
			ldsROAddress.SetItem(llNewAddressRow, 'Contact_Person', lsTemp)

			//Receive_Alt_Address.Fax
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
					
			ldsROAddress.SetItem(llNewAddressRow, 'Fax', lsTemp)

			//Receive_Alt_Address.Email_Address
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
					
			ldsROAddress.SetItem(llNewAddressRow, 'Email_Address', lsTemp)

		CASE 'RD' /* detail*/
			
			lbDetailError = False
			llNewDetailRow = 	ldsRODetail.InsertRow(0)
			llLineSeq ++
					
			//Add detail level defaults
			ldsRODetail.SetItem(llNewDetailRow, 'EDI_Batch_Seq_No', llbatchseq) /*batch seq No*/
			ldsRODetail.SetItem(llNewDetailRow, 'Order_Seq_No', llOrderSeq) 
			ldsRODetail.SetItem(llNewDetailRow, 'Status_Cd', 'N') 
			ldsRODetail.SetItem(llNewDetailRow, "Order_Line_No", string(llLineSeq))
			
			//Action Code
			lsRecData = Right(lsRecData,(len(lsRecData) - 3)) /*strip off to first column after rec type */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'ACtion Code' field. Record will not be processed.")
				lbDetailError = True
			End If

			IF lb_treat_adds_as_updates Then
				ldsRODetail.SetItem(llNewDetailRow,'Action_Cd', 'U') 
			else
				ldsRODetail.SetItem(llNewDetailRow,'Action_Cd', lsTemp) //set Header Action Cd
			END IF
			
			//Project Identifier
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to first column after rec type */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'Project Identifier' field. Record will not be processed.")
				lbDetailError = True
			End If
						
			ldsRODetail.SetItem(llNewDetailRow, 'Project_Id', lsTemp)
			
			//Purchase Order Number
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'Order Number' field. Record will not be processed.")
				lbDetailError = True
			End If
			
			//Make sure we have a header for this Detail...
			If ldsROHeader.Find("Upper(order_no) = '" + Upper(lstemp) + "'",1,ldsROHeader.RowCount()) = 0 Then
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Detail Order Number does not match header ORder Number. Record will not be processed.")
				lbDetailError = True
			End If
			
			ldsRODetail.SetItem(llNewDetailRow, 'Order_No', trim(lsTemp))
			lsOrderNo = trim(lsTemp)

			//Supplier Code
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'Supplier Code' field. Record will not be processed.")
				lbDetailError = True
			End If
			
			lsSuppCode = lsTemp
			ldsRODetail.SetItem(llNewDetailRow, 'Supp_Code', trim(lsTemp))
						
			//Line Item Number
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'Line Item Number' field. Record will not be processed.")
				lbDetailError = True
			End If
						
			If Not isnumber(lsTemp) Then
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - 'Line Item Number' is not numeric. Record will not be processed.")
				lbDetailError = True
			Else
				ldsRODetail.SetItem(llNewDetailRow, 'Line_Item_No', Dec(trim(lsTemp)))
			End If
		
			//SKU
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Upper(Left(lsRecData,(pos(lsRecData,'|') - 1)))
			Else
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'SKU' field. Record will not be processed.")
				lbDetailError = True
			End If
			
			lsSku =lsTemp
			ldsRODetail.SetItem(llNewDetailRow, 'SKU', lsTemp)
		
			//Qty
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				lsTemp = lsRecData
			End If
		
			ldsRODetail.SetItem(llNewDetailRow, 'Quantity', trim(lsTemp))

			//Inventory Type
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			If IsNull(lsTemp) or lsTemp ='' Then 
				ldsRODetail.SetItem(llNewDetailRow, 'Inventory_Type', 'N')
			ELSE
				//TAM 2019/03/04 - Use A new table to create the Translation - Start
//				ldsRODetail.SetItem(llNewDetailRow, 'Inventory_Type', lsTemp)
				lstr_Parms = this.getxpoinventorytype( asProject, lsSuppCode, lsTemp)
				ldsRODetail.SetItem(llNewDetailRow, 'Inventory_Type', 	lstr_Parms.string_arg[1])
				//TAM 2019/03/04 - Use A new table to create the Translation - End
			END IF

			//Supplier's Material Number
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			ldsRODetail.SetItem(llNewDetailRow, 'Alternate_SKU', lsTemp) //Alternate_SKU???
			
			//Lot No 
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
						
			ldsRODetail.SetItem(llNewDetailRow,  'Lot_No', trim(lsTemp))
								
			//PO NO
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
						
			ldsRODetail.SetItem(llNewDetailRow, 'PO_No', lsTemp)
						
			//PO NO 2
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
						
			ldsRODetail.SetItem(llNewDetailRow, 'PO_No2', lsTemp)
							
			//Serial No
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
						
			ldsRODetail.SetItem(llNewDetailRow, 'Serial_No', '-') //Always set to blank
			
			//Expiration date
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			IF lsTemp ='' OR IsNull(lsTemp) THEN	
				ldsRODetail.SetItem(llNewDetailRow, 'Expiration_Date', DateTime('2999/12/31'))
			ELSE
				ldsRODetail.SetItem(llNewDetailRow, 'Expiration_Date', DateTime(Left(lsTemp,4) + "/" + Mid(lsTemp,5,2) + "/" + Mid(lsTemp,7,2)))
			END IF
				
			//User Line Item No
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			lsUserLineItemNo = lsTemp
			ldsRODetail.SetItem(llNewDetailRow, 'User_Line_Item_No', lsTemp)

			//User_Field1
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If

			ldsRODetail.SetItem(llNewDetailRow, 'User_Field1', lsTemp)

			//User_Field2
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If

			ldsRODetail.SetItem(llNewDetailRow, 'User_Field2', lsTemp)
			
			//User_Field3
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If

			ldsRODetail.SetItem(llNewDetailRow, 'User_Field3', lsTemp)
			
			//User_Field4
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If

			ldsRODetail.SetItem(llNewDetailRow, 'User_Field4', lsTemp)
			
			//User_Field5
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If

			ldsRODetail.SetItem(llNewDetailRow, 'User_Field5', lsTemp)
			
			//User_Field6
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If

			ldsRODetail.SetItem(llNewDetailRow, 'User_Field6', lsTemp)
			
			//Country_Of_Origin
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			IF NOT (lsTemp='' OR IsNull(lsTemp)) THEN
				ldsRODetail.SetItem(llNewDetailRow, 'Country_Of_Origin', lsTemp)
			ELSE
				ldsRODetail.SetItem(llNewDetailRow, 'Country_Of_Origin', 'XX')
			END IF

			//UOM
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			IF NOT (IsNull(lsTemp) OR lsTemp ='') THEN
				ldsRODetail.SetItem(llNewDetailRow, 'UOM', lsTemp)
			ELSE
				ldsRODetail.SetItem(llNewDetailRow, 'UOM', 'EA')
			END IF
					
			//Currency_Code
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
						
			ldsRODetail.SetItem(llNewDetailRow, 'Currency_Code', lsTemp)
			
			//Supplier_Order_Number
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
						
			ldsRODetail.SetItem(llNewDetailRow, 'Supplier_Order_Number', lsTemp)
			
			//Cust_PO_Nbr
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
						
			ldsRODetail.SetItem(llNewDetailRow, 'Cust_PO_Nbr', lsTemp)
			
			//Line_Container_Nbr
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
						
			ldsRODetail.SetItem(llNewDetailRow, 'Line_Container_Nbr', lsTemp)
			
			//Vendor_Line_Nbr
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
						
			ldsRODetail.SetItem(llNewDetailRow, 'Vendor_Line_Nbr', lsTemp)
			
			//Client_Line_Nbr
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
						
			ldsRODetail.SetItem(llNewDetailRow, 'Client_Line_Nbr', lsTemp)
			
			//Client_Cust_PO_NBR 
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
						
			ldsRODetail.SetItem(llNewDetailRow, 'Client_Cust_PO_NBR', lsTemp)
			
			//Owner Code
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			
			IF (lsPrevOwnerCd <> lsTemp OR lsTemp ='' OR IsNull(lsTemp)) THEN

				IF lsTemp ='' OR IsNull(lsTemp) THEN 
					lsOwnerCd = lsSuppCode
				ELSE
					lsOwnerCd = lsTemp					
				END IF
				
				SELECT Owner_id into :llOwner FROM Owner with(nolock)
				WHERE Project_Id = :asproject AND Owner_Type = 'S' AND owner_cd = :lsOwnerCd
				USING sqlca;
			END IF
			
			lsPrevOwnerCd = lsTemp
			
			ldsRODetail.SetItem(llNewDetailRow, 'Owner_Id', string(llOwner))
			
			//SSCC Nbr
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
						
			ldsRODetail.SetItem(llNewDetailRow, 'SSCC_Nbr', lsTemp)
			
			//Vintage
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
						
			ldsRODetail.SetItem(llNewDetailRow, 'Vintage', lsTemp)
			
			//Find detail records
			If  ldsRODetail.GetItemString(llNewDetailRow,'Action_Cd') = 'U' Then
				 lsFind = "upper(sku) = '" + upper(lsSku) +"'"
				 lsFind += " and user_line_item_no = '" + lsUserLineItemNo + "'"
				 llFindRow = ldsRoNo.Find(lsFind, 1, ldsRoNo.RowCount())
			
				If llFindRow > 0 Then 
					  // Change line item number for updated row to original line number found. 
					  ldsRODetail.SetItem(llNewDetailRow, 'Line_Item_No', ldsRoNo.GetItemNumber(llFindRow,'Line_Item_No'))
					  ldsRoNo.DeleteRow(llFindRow)
				 End If
			End If
			

			//If detail errors, delete the row...
			IF lbDetailError Then
				lbError = True
				ldsRODetail.DeleteRow(llNewDetailRow)
				Continue
			END IF
			
		CASE 'RN' //Receive Notes

			//Order No
			lsRecData = Right(lsRecData,(len(lsRecData) - 3)) /*strip off to next column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Notes Data expected after 'Order No' field. Record will not be processed.")
				lbError = True
			End If

			lsOrder = lsTemp
			
			//Make sure we have a header for this Notes...
			If ldsROHeader.Find("Upper(order_no) = '" + Upper(lsOrder) + "'",1,ldsROHeader.RowCount()) = 0 Then
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Notes Order Number does not match Header Order Number. Note Record will not be processed (Return Order will still be loaded)..")
				Continue
			End If
						
			//Line Number
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Notes Data expected after 'Line Number' field. Record will not be processed.")
				lbError = True
			End If

			If IsNumber(lsTemp) Then
				llNoteLine = Long(lsTemp)
			Else
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Return Notes 'Line Item' is not numeric: '" + lsTemp + "'. Note Record will not be processed (Return Order will still be loaded)..")
				lbError = True
				Continue
			End If
					
			//Note Type
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Notes Data expected after 'Note Type' field. Record will not be processed.")
				lbError = True
			End If
			
			lsNoteType = lsTemp
			
			//Note Sequence
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Notes Data expected after 'Note Sequence' field. Record will not be processed.")
				lbError = True
			End If
			
			If IsNumber(lsTemp) Then
				llNoteSeq = Long(lsTemp)
			Else
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Return Notes Seq Number' is not numeric: '" + lsTemp + "'. Note Record will not be processed (Return Order will still be loaded)..")
				lbError = True
				Continue
			End If

			//Note Text
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				lsTemp = lsRecData
			End If

			lsNoteText = lsTemp
			
			IF lsNoteText > "" THEN
				
				llNewNotesRow = 	ldsRONotes.InsertRow(0)

				//Add Notes defaults
				ldsRONotes.SetItem(llNewNotesRow, 'Project_Id', asproject) //Project Id
				ldsRONotes.SetItem(llNewNotesRow, 'EDI_Batch_Seq_No', llbatchseq) /*batch seq No*/
				ldsRONotes.SetItem(llNewNotesRow, 'Order_Seq_No', llOrderSeq) 

				ldsRONotes.SetItem(llNewNotesRow, 'Note_Seq_No', llNoteSeq)
				ldsRONotes.SetItem(llNewNotesRow, 'Invoice_No', lsOrder)
				ldsRONotes.SetItem(llNewNotesRow, 'Note_Type', lsNoteType)
				ldsRONotes.SetItem(llNewNotesRow, 'Line_Item_No', llNoteLine)
				ldsRONotes.SetItem(llNewNotesRow, 'Note_Text', lsNoteText)
				
			END IF

		CASE 'EX'
			
			llNewExpRow = ldsPOExpansion.InsertRow( 0)
			llExpOrderLine++
			
			ldsPOExpansion.SetItem(llNewExpRow,  'Project_Id', asproject)
			ldsPOExpansion.SetItem(llNewExpRow,  'EDI_Batch_Seq_No', llbatchseq)
			ldsPOExpansion.SetItem(llNewExpRow,  'Order_Seq_No', llOrderSeq)
			ldsPOExpansion.SetItem(llNewExpRow,  'Order_Line_No', llExpOrderLine)

			//Order No
			lsRecData = Right(lsRecData,(len(lsRecData) - 3)) /*strip off to first column after rec type */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			ldsPOExpansion.SetItem(llNewExpRow,  'Order_No', lsTemp)
			
			//Order User Line Item No
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to first column after rec type */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			ldsPOExpansion.SetItem(llNewExpRow,  'User_Line_Item_No', lsTemp)

			//Order Table
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to first column after rec type */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			ldsPOExpansion.SetItem(llNewExpRow,  'Order_Table', lsTemp)

			//Field_Name
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to first column after rec type */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			ldsPOExpansion.SetItem(llNewExpRow,  'Field_Name', lsTemp)


			//Field_Data
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to first column after rec type */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			ldsPOExpansion.SetItem(llNewExpRow,  'Field_Data', lsTemp)

			//Upload
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to first column after rec type */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			ldsPOExpansion.SetItem(llNewExpRow,  'Upload', lsTemp)

			
		CASE ELSE /* Invalid Rec Type*/
		
			gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Invalid Record Type: '" + lsRecType + "'. Record will not be processed.")
			Continue
		
	End Choose /*record Type*/
	
Next /*File record */

IF NOT lb_treat_adds_as_updates then
// Any Rows left in the Detail Datastore need to be deleted so create a delete detail Row for each on.
llDeleteRowCount = ldsRoNo.RowCount()
If  llDeleteRowCount > 0 Then
	For llDeleteRowPos = 1  to llDeleteRowCount 
		llNewDetailRow =  ldsRODetail.InsertRow(0)
		llLineSeq ++
		//Add detail level defaults
		ldsRODetail.SetItem(llNewDetailRow, 'Order_Seq_No', llOrderSeq) 
		ldsRODetail.SetItem(llNewDetailRow, 'Project_Id', upper(asproject)) /*project*/
		ldsRODetail.SetItem(llNewDetailRow, 'Status_Cd', 'N') 
		ldsRODetail.SetItem(llNewDetailRow, 'Inventory_Type', 'N') 
		ldsRODetail.SetItem(llNewDetailRow, 'EDI_Batch_Seq_No', llbatchseq) /*batch seq No*/
		ldsRODetail.SetItem(llNewDetailRow, 'Order_Line_No', string(llLineSeq))
		ldsRODetail.SetItem(llNewDetailRow, 'Action_Cd','D') 
		ldsRODetail.SetItem(llNewDetailRow, 'Line_Item_No', ldsRoNo.GetItemNumber(llDeleteRowPos,'line_item_no'))
		ldsRODetail.SetItem(llNewDetailRow, 'SKU', ldsRoNo.GetItemString(llDeleteRowPos,'SKU'))
		ldsRODetail.SetItem(llNewDetailRow, 'Order_No', lsOrderNo)
	Next
End If
End IF

//Save the Changes 
lirc = ldsROHeader.Update()
	
If liRC = 1 Then
	liRC = ldsRODetail.Update()
End If

If liRC = 1 Then
	ldsROAddress.Update()
End If

If liRC = 1 Then
	ldsRONotes.Update()
End If

If liRC = 1 Then
	liRC = ldsPOExpansion.Update()
End If

If liRC = 1 then
	Commit;
Else
	Rollback;
	lsLogOut = Space(17) + "- ***System Error!  Unable to Save new PO Records to database! " +sqlca.sqlerrtext
	FileWrite(gilogFileNo,lsLogOut)
	gu_nvo_process_files.uf_writeError("- ***System Error!  Unable to Save new PO Records to database!")
	Return -1
End If

Destroy ldsROHeader
Destroy ldsRODetail
Destroy ldsROAddress
Destroy ldsRONotes
Destroy ldsPOExpansion
Destroy ldsRoNO

If lbError Then
	Return -1
Else
	Return 0
End If


end function

public function string getphilipsdisposition (string asinvtype);
//Convert the Menlo Onventory Type into the Phillips code

String	lsPhilipsDisposition
Choose case upper(asInvType)
		
	Case 'B'
		lsPhilipsDisposition = 'sellable_accessible'
	Case 'C'
		lsPhilipsDisposition = 'sellable_accessible'
	Case 'D'
		lsPhilipsDisposition = 'non_sellable_damaged'
	Case 'K'
		lsPhilipsDisposition = 'non_sellable_other'
	Case 'L'
		lsPhilipsDisposition = 'returned'
	Case 'N'
		lsPhilipsDisposition = 'sellable_accessible'
	Case 'R'
		lsPhilipsDisposition = 'sellable_accessible'
	Case 'S'
		lsPhilipsDisposition = 'destroyed'
	Case Else
		lsPhilipsDisposition = ''
End Choose

Return lsPhilipsDisposition
end function

public function integer uf_process_daily_lot_info (string asproject, string asinifile, datetime ad_next_runtime_date);//28-FEB-2019 :Madhu S29975 PhilipsBlueHeart Daily Lot Info

//generate a file per plant code and don't exceed 500 records per file.

string	lsLogOut, lsFilename, ls_plant_code, lsOutString, ls_prev_plant_code
integer lirc
long	llRowPos, llRowCount, llNewRow, ll_threashold
decimal	ldBatchSeq
date	ld_StartDate, ld_EndDate
datetime ldt_today

boolean lbHeaderAdded

Datastore	ldsOut, ldslot
			
ldsOut = Create Datastore
ldsOut.Dataobject = 'd_edi_generic_out'
lirc = ldsOut.SetTransobject(sqlca)

ldslot = Create u_ds_datastore
ldslot.Dataobject = 'd_philips_cls_daily_lot'
lirc = ldslot.SetTransobject(sqlca)

lsLogOut = "- PROCESSING FUNCTION: "+asproject+" Daily Lot Info!"
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/

ld_StartDate = Date(ad_next_runtime_date) //current Date (2017-11-05 00:00:00)
ld_StartDate = RelativeDate(ld_StartDate, -1)  //Current Date (2017-11-04 00:00:00)
ld_EndDate = Date(ad_next_runtime_date) //current Date (2017-11-05 00:00:00)

//Get the Next Batch Seq Nbr - Used for all writing to generic tables
ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asproject, 'EDI_Generic_Outbound', 'EDI_Batch_Seq_No')

If ldBatchSeq <= 0 Then
	lsLogOut = "   ***Unable to retrive next available sequence number for "+asproject+" Daily Lot Info confirmation."
	FileWrite(gilogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
	 Return -1
End If

//Retrive the Lot Info Data
gu_nvo_process_files.uf_write_log('Retrieving Daily Lot Info Data.....')

llRowCount = ldslot.Retrieve(asproject, ld_StartDate, ld_EndDate)

gu_nvo_process_files.uf_write_log(String(llRowCount) + ' Rows were retrieved for processing.')
gu_nvo_process_files.uf_write_log('Processing Daily Lot Info Data.....')

lbHeaderAdded =FALSE

FOR llRowPos = 1 to llRowCount

	ls_plant_code = ldslot.getItemString(llRowPos, 'delivery_master_user_field3')

	IF 	((ls_prev_plant_code ='') OR ((ls_plant_code =ls_prev_plant_code) and ll_threashold <500 )) THEN
		
		IF lbHeaderAdded =FALSE THEN
			llNewRow = ldsOut.insertRow(0)
			lsOutString = 'LH|'
			
			ldt_today = datetime(today(),now())
			
			lsOutString += string(ldt_today,"YYYYMMDDHHMMSS") +'|'
			lsOutString += ldslot.getItemString(llRowPos, 'delivery_master_user_field3') //plant code

			lsFilename = ("LI" + ls_plant_code+ string(ldt_today,"YYYYMMDDHHMMSSfff") +".dat")
			ldsOut.SetItem(llNewRow,'file_name', lsFilename)
			ldsOut.SetItem(llNewRow,'Project_id', asproject)
			ldsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
			ldsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
			ldsOut.SetItem(llNewRow,'batch_data', lsOutString)

			ll_threashold++
			lbHeaderAdded =TRUE
		END IF
		
		llNewRow = ldsOut.insertRow(0)
		lsOutString ='LD|'
		lsOutString += ldslot.getItemString(llRowPos, 'delivery_picking_po_no2') +'|'
		lsOutString += ldslot.getItemString(llRowPos, 'delivery_master_invoice_no') +'|'
		lsOutString += string(ldslot.getItemNumber(llRowPos, 'delivery_picking_line_item_no')) +'|'
		lsOutString += ldslot.getItemString(llRowPos, 'delivery_detail_sku') +'|'
		lsOutString += string(ldslot.getItemNumber(llRowPos, 'total_qty')) +'|'
		lsOutString += ldslot.getItemString(llRowPos, 'delivery_detail_uom')
		
		ldsOut.SetItem(llNewRow,'file_name', lsFilename)
		ldsOut.SetItem(llNewRow,'Project_id', asproject)
		ldsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
		ldsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
		ldsOut.SetItem(llNewRow,'batch_data', lsOutString)
		
		ls_prev_plant_code = ls_plant_code
		ll_threashold++
		
	ELSE
		lbHeaderAdded =FALSE
		//Write the Outbound File - no need to save and re-retrieve - just use the currently loaded DW
		IF ldsOut.rowcount() > 0 Then 
			gu_nvo_process_files.uf_process_flatfile_outbound(ldsOut, asproject)
			
			ldsOut.reset( ) 	//reset datastore
			llRowPos = llRowPos -1 //reset to previous row
			ls_prev_plant_code = ''
			ll_threashold = 0
		END IF
	END IF
	
NEXT /*next output record */

//Last file
IF ldsOut.rowcount() > 0 Then  gu_nvo_process_files.uf_process_flatfile_outbound(ldsOut, asproject)

Return 0
end function

public function integer uf_process_event_status_delivered (string aspath, string asproject);//TAM: 2019/02/28  S29919 - Philips  BlueHeart Shipment Status Update(COR)

String 	lsLogout, lsStringData, lsRecData, lsTemp, lsOrderNo, lsSuppCode, lsDoNo, lsDeliveredDate, lsOrderStatus
String		ls_errors
Integer	liFileNo, liRC
Long 		llNewRow,  llRowCount, llRowPos
Boolean	lbError
DateTime	ldtToday
ldtToday = DateTime(Today(),Now())

DataStore ldsImport

If Not isvalid(ldsImport) Then
	ldsImport = Create u_ds_datastore
	ldsImport.dataobject = 'd_generic_import'
End If

//Open and read the File In
lsLogOut = '      - Opening File for PHILIPSCLS Shipment Delivered Status Processing: ' + asPath
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

liFileNo = FileOpen(asPath,LineMode!,Read!,LockReadWrite!)
If liFileNo < 0 Then
	lsLogOut = "-       ***Unable to Open File for PHILIPSCLS Processing: " + asPath
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
	Return -99
End If

//read file and load to datastore for processing
liRC = FileRead(liFileNo,lsStringData)

Do While liRC > 0
	llNewRow = ldsImport.InsertRow(0)
	ldsImport.SetItem(llNewRow, 'rec_data',trim(lsStringData)) /*record data is the rest*/
	liRC = FileRead(liFileNo,lsStringData)
Loop /*Next File record*/

FileClose(liFileNo)

//records count
llRowCount = ldsImport.RowCount()

//loop through each record
For llRowPos = 1 to llRowCount
	
	lsRecData = trim(ldsImport.GetItemString(llRowPos,'rec_Data'))

	//Purchase Order No
	If Pos(lsRecData,'+') > 0 Then
		lsTemp = Left(lsRecData,(pos(lsRecData,'+') - 1))
	Else
		lbError = True
		gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Order Number Data is Missing. Record will not be processed.")
	End If
	lsOrderNo = lsTemp
		
	//Supplier Code (Plant Code)
	lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
	If Pos(lsRecData,'+') > 0 Then
		lsTemp = Left(lsRecData,(pos(lsRecData,'+') - 1))
	else
		lbError = True
		gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'Supplier' field. Record will not be processed.")
	End If
		
	lsSuppCode = lsTemp
			
	//Start Date - Not Used but is a place holder before Complete date
	lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
	If Pos(lsRecData, '+') > 0 Then
		lsTemp =Left(lsRecData, (Pos(lsRecData, '+') -1))
	else
		lbError = True
		gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'Start Date' field. Record will not be processed.")
		lsRecData =''
	End If

	//Delivered Date 
	lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
	If len(lsRecData)> 0 Then
		lsDeliveredDate = lsRecData
		If Not IsDate(left(lsDeliveredDate,10)) Then // Make sure the Delivered date is a valid date format
			lbError = True
			gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " -  'Delivered Date: '" +  lsDeliveredDate + "' is Not a valid date format. Record will not be processed.")
		End If
			
	Else
		lbError = True
		gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " -  'Delivered Date field is Missing. Record will not be processed.")
	End if
		
	If lbError = False Then

	//Make Sure Order Exists and is in complete status
		SELECT Ord_Status, Do_No
	    INTO :lsOrderStatus, :lsDoNo   
		FROM Delivery_Master  
		WHERE Project_Id = :asProject  AND  Invoice_No = :lsOrderNo  AND  Ord_Status = 'C'  using sqlca  ;
		
		If lsOrderStatus <> 'C' then 
			lbError = True
			gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Order: " + lsOrderNo + "' is not found or is not in completed status. Record will not be processed.")

		//Update the Delivery Date and Create a batch transaction record
		Else
			
			//Create Batch Transaction Record
			Insert into Batch_Transaction (Project_Id, Trans_Type, Trans_Order_Id, Trans_Status, Trans_Parm,Trans_Create_Date)
			values (:asproject, 'ES', :lsDoNo, 'N','DELIVEREDDATE', :ldtToday)
			using sqlca;

			If Sqlca.sqlcode <> 0  Then
				lsLogOut = '      - Update Delivey Date -  Processing of uf_process_purchase_order_delivered  and Delivery Order: '+lsOrderNo + ' Unable to create Batch Transaction Record:  ' +sqlca.sqlerrtext
				gu_nvo_process_files.uf_writeError(lsLogOut)
				Return -1	
			End IF
			
			//Update Deliver Master with Delivered Date
			UPDATE Delivery_Master  
			SET Delivery_Date = :lsDeliveredDate, Ord_Status = 'D', Last_User = 'simsfp', Last_Update = :ldttoday  
			WHERE ( Project_Id = :asProject ) AND ( DO_No = :lsdono )  using sqlca;

			commit;
			
		End If
	End If
Next
		
If lbError Then
	Return -1
Else
	Return 0
End If

end function

public function str_parms getphilipssuppliertranslations (string asproject, string assupplier, string asinventorytype);long  ll_rows
string ls_sql, ls_error

//Convert the Menlo Inventory Type into the Phillips Inventory Type and Disposition Code


Str_Parms lstr_parms

Datastore lds_inventory_type

lds_inventory_type =create Datastore
ls_sql =" select * from Inventory_Type_Translation with(nolock) "
ls_sql +=" where Project_Id ='"+asproject+"' and supp_code ='"+assupplier+"'"
ls_sql += " and Inv_Type ='"+asinventorytype+"'"

lds_inventory_type.create( SQLCA.syntaxfromsql( ls_sql, "", ls_error))
lds_inventory_type.settransobject( SQLCA)
ll_rows = lds_inventory_type.retrieve( )

If ll_rows = 1 Then
		lstr_parms.string_arg[1] =lds_inventory_type.getItemString(1,'Client_Inv_Type')
		lstr_parms.string_arg[2] =lds_inventory_type.getItemString(1,'Client_Disposition_Code')
Else //Can't Translate
		lstr_parms.string_arg[1] = asInventorytype
		lstr_parms.string_arg[2] = ''
End If

destroy lds_inventory_type
Return lstr_parms

end function

public function str_parms getxpoinventorytype (string asproject, string assupplier, string asinventorytype);long  ll_rows
string ls_sql, ls_error

//Convert the Phillips Inventory Type into the  XPO Inventory Type

Str_Parms lstr_parms

Datastore lds_inventory_type

lds_inventory_type =create Datastore
ls_sql =" select * from Inventory_Type_Translation with(nolock) "
ls_sql +=" where Project_Id ='"+asproject+"' and supp_code ='"+assupplier+"'"
ls_sql += " and Client_Inv_Type ='"+asinventorytype+"'"

lds_inventory_type.create( SQLCA.syntaxfromsql( ls_sql, "", ls_error))
lds_inventory_type.settransobject( SQLCA)
ll_rows = lds_inventory_type.retrieve( )

If ll_rows = 1 Then
		lstr_parms.string_arg[1] =lds_inventory_type.getItemString(1,'Inv_Type')
Else //Can't Translate - return asinventorytype
		lstr_parms.string_arg[1] = asinventorytype
End If

destroy lds_inventory_type
Return lstr_parms

end function

public function string remove_leading_zeros (string as_sku);//22-APR-2019 :Madhu Philps BlueHeart Soft Bundle Hard Bundle Items
//Remove leading 0s.

DO
	IF left(as_sku, 1) = "0" THEN as_sku = mid(as_sku, 2)
LOOP UNTIL left(as_sku, 1) <> "0"

Return as_sku
end function

on u_nvo_proc_philips_cls.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_nvo_proc_philips_cls.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

