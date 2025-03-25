$PBExportHeader$u_nvo_edi_confirmations.sru
$PBExportComments$Process any outbound edi confirmation transactions
forward
global type u_nvo_edi_confirmations from nonvisualobject
end type
end forward

global type u_nvo_edi_confirmations from nonvisualobject
end type
global u_nvo_edi_confirmations u_nvo_edi_confirmations

type variables
Integer	iiFileNo, &
			iiTotalQty, &
			iiCountQty
DataStore	idsDefaults
end variables

forward prototypes
public function integer uf_pod (ref datawindow adw_main, ref datawindow adw_other, ref datawindow adw_pick)
public function integer uf_export_to_fedex (ref datawindow adw_main, ref datawindow adw_detail, ref datawindow adw_defaults, ref datawindow adw_pack)
public function integer uf_export_to_fedex_batch (ref datawindow adw_detail, ref datawindow adw_pack, integer alpackrow)
public function integer uf_export_to_ups (ref datawindow adw_main, ref datawindow adw_detail, ref datawindow adw_defaults, ref datawindow adw_pack)
public function integer uf_export_to_ups_batch (ref datawindow adw_detail, ref datawindow adw_pack, integer alpackrow)
public function integer uf_stock_adjustment (ref datawindow adw_adjustment)
public function integer uf_goods_receipt_confirmation (ref datawindow adw_main, ref datawindow adw_detail, ref datawindow adw_putaway)
public function integer uf_workorder_confirmation (ref datawindow adw_main, ref datawindow adw_detail, ref datawindow adw_pick)
public function integer uf_edm (ref window aw_do, ref datawindow adw_main, ref datawindow adw_detail, ref datawindow adw_pack)
public function integer uf_goods_issue_confirmation (ref datawindow adw_main, ref datawindow adw_detail, ref datawindow adw_pick, ref datawindow adw_pack)
end prototypes

public function integer uf_pod (ref datawindow adw_main, ref datawindow adw_other, ref datawindow adw_pick);
//Create a POD transaction for the proper project

Integer	liRC
//u_nvo_edi_confirmations_dellkorea	lu_nvo_dellkorea

Choose Case Upper(gs_project)
				
	Case 'DELLKOREA'
		
		//lu_nvo_dellkorea = Create u_nvo_edi_confirmations_dellkorea
		//liRC = lu_nvo_dellkorea.uf_pod(adw_main, adw_other,adw_pick)
							
End Choose

Return liRC
end function

public function integer uf_export_to_fedex (ref datawindow adw_main, ref datawindow adw_detail, ref datawindow adw_defaults, ref datawindow adw_pack);//Export order info to Fedex One order at a time

String	lsFile,	&
			lsPath,	&
			lsRecData[],	&
			lsLookup,	&
			lsFind, &
			lsMissingFields,	&
			lsCustName,	&
			lsCustCode,	&
			lsContact,	&
			lsPhone,		&
			lsAddr1,		&
			lsAddr2,		&
			lsCity,		&
			lsState,		&
			lsZip,		&
			lsCountry,	&
			ls_reference, &
			ls_shipyear, 	&
			ls_shipmonth, 	&
			ls_shipday, 	&
			ls_schCode
			
Integer	liRC,				&
			liFileNo,		&
			liTotalPrice,	&
			liTotalWeight, &
			liTotalQty, 	&  
			i				, 	&
			l				, 	&
			q

Long		llFindRow,		&
			llRowPos,		&
			llRowCount,		&
			llTotalWeight,	&
			llArrayPos,		&
			llHeight,		&
			llWidth,			&
			llLentgh,		&
			llGirth,			&
			llNewROw, 		&
			llDetailFindRow
			
decimal{2}	ldTotalPrice,		&
				ldTotalWeight
				
date ldt_carrier_ship_date

Datastore	ldsDimensions			

//Write data to array - we will write to file at end if successfull
//Export data to File - some data comes from Lookup Table (Code ID = 'FEDEX'), other from order info

//See if there is  default file in the lookup table, otherwise prompt for file
llFindRow = adw_defaults.Find("Upper(Code_ID) = 'DFILENAME'",1,adw_defaults.RowCount())
If llFindRow > 0 Then
	lsPath = adw_defaults.GetITemString(llFindRow,'code_descript')
End If

If lspath > '' Then
Else /*Prompt for File*/
	liRC = GetFileSaveName('Save FEDEX File To:',lsPath, lsFile)
	If liRC < 1 Then REturn -1
End If

//Try and open the File
liFileNo = FileOpen(lsPath,LineMode!,Write!,LockReadWrite!,Append!)

If liFileNo <= 0 Then
	Do While liFileNo <= 0
		Messagebox('FEDEX Export','Unable to Open/Create File: ' + lsPath + ' for export to FEDEX')
		liRC = GetFileSaveName('Save FEDEX File To:',lsPath, lsFile)
		If liRC < 1 Then REturn -1
		liFileNo = FileOpen(lsPath,LineMode!,Write!,LockReadWrite!,Append!)
	Loop
End If
				
// gap 09/2002 - capture the carrier ship date
ldt_carrier_ship_date = date(w_do.tab_main.tabpage_carrier.em_carrier_ship_date.text)

iiTotalQty = adw_pack.Object.compute_2[1] /*Capture Total QTY to keep track of Labels per Order*/

llRowCount = adw_pack.RowCount()  
If adw_Defaults.AcceptText() < 0 Then return -1
l = 1 // GAP 11/02 set label count
i = 0 
do until i = llRowCount    /*GAP 9/02  loop to print multiple labels as per QTY (GM_M ONLY)*/
	 i ++
	 q = 0
	 liTotalQty = 1
	 If upper(Left(gs_project,4)) = 'GM_MO' Then liTotalQty = adw_pack.GetITemNumber(i,'quantity')  // GAP 11/02 get quantity for each row/item
 do until q = liTotalQty    /*GAP 11/02  loop to print labels as per QTY (GM_M ONLY)*/	
	ls_reference = "" // *GAP 11/02 CLEAR Reference field
	
	//Find an Order Detail record that corresponds to this Packing row for Header level Information
	lsFind = "Upper(do_no) = '" + Upper(adw_pack.GetItemString(i,'do_no')) + "'"
	lsFind += " and Upper(sku) = '" + Upper(adw_pack.GetItemString(i,'sku')) + "'"
	//lsFind += " and Upper(supp_code) = '" + Upper(adw_pack.GetItemString(i,'supp_code')) + "'"
	lsFind += " and line_item_no = " + String(adw_pack.GetItemNumber(i,'line_Item_no'))
	llDetailFindRow = adw_Detail.Find(lsFind,1,adw_Detail.RowCount())
	
	llArrayPos = 1
	If upper(gs_project) = 'GM_HAHN' Then 
		iiTotalQty = 1 /*GAP 9/02  do NOT print multiple labels for HAHN*/
		lsRecData[llarrayPos] = '0,"051"' /*trans Type*/
		llArrayPos ++
		lsRecData[llarrayPos] = '1,"' + Right(adw_main.GetITemString(1,'do_no'),6) + '"' /*Trans ID*/
	else  // GAP 8/02 
		lsRecData[llarrayPos] = '0,"020"' /* GAP 8/2002 trans Type*/ 
		llArrayPos ++
		lsRecData[llarrayPos] = '1,"' + Right(adw_main.GetITemString(1,'do_no'),7) + "|" + string(adw_pack.GetITemString(i,'carton_no')) + "|" + string(adw_pack.GetItemNumber(i,'line_Item_no')) + "|" + adw_main.GetItemString(1,'cust_order_no') + '"' 
	end if

	//GM Hahn - we need to retrieve the customer address information from the VOR dealer NUmber (USER Field 6)
	//Otherwise, we will take the customer information from the DO - Country Code still coming from Customer on DO
	If upper(gs_project) = 'GM_HAHN' Then
	
		lsCustCode = adw_main.GetItemString(1,'user_field6')
		If lsCustCode > '' Then
		
			Select Cust_Name, Contact_Person, Address_1, Address_2, City, State, Zip, Tel
			Into	:lsCustName, :lsContact, :lsAddr1, :lsAddr2, :lsCity, :lsState, :lsZip, :lsPhone
			From Customer
			Where Project_id = :gs_project and cust_code = :lsCustCode
			Using SQLCA;
				
			/* 11, Customer Name*/
			llArrayPos ++
			If lsCustName > '' Then
			lsRecData[llArrayPos] = '11,"' +  lsCustName + '"' 
			Else
			lsRecData[llArrayPos] = '11,""'
			lsMissingFields += ", Customer Name" /*we will let user know data is missing*/
			End If

			/* 12, Contact Name  // GAP 6-2002  Commentee out per email request by Hahn
			llArrayPos ++
			If lsContact > '' Then
			lsRecData[llArrayPos] = '12,"' + lsContact + '"'
			Else
			lsRecData[llArrayPos] = '12,"N/A"'
			End If */
				
			/* 13, Cust Address 1*/
			llArrayPos ++
			If lsAddr1 > '' Then
				lsRecData[llArrayPos] = '13,"' +  lsAddr1 + '"' 
			Else
				lsRecData[llArrayPos] = '13,""'
				lsMissingFields += ", Address 1" /*we will let user know data is missing*/
			End If
				
			/* 14, Cust Address 2*/
			llArrayPos ++
			If lsAddr2 > '' Then
				lsRecData[llArrayPos] = '14,"' +  lsAddr2 + '"' 
			Else
				lsRecData[llArrayPos] = '14,""'
			End If
				
			/* 15, Cust City*/
			llArrayPos ++
			If lsCity > '' Then
				lsRecData[llArrayPos] = '15,"' +  lsCity + '"' 
			Else
				lsRecData[llArrayPos] = '15,""'
				lsMissingFields += ", City" /*we will let user know data is missing*/
			End If
				
			/* 16, Cust State*/
			llArrayPos ++
			If lsState > '' Then
				lsRecData[llArrayPos] = '16,"' +  lsState + '"' 
			Else
				lsRecData[llArrayPos] = '16,""'
				lsMissingFields += ", State" /*we will let user know data is missing*/
			End If
				
			/* 17, Cust Zip*/
			llArrayPos ++
			If lsZip > '' Then
				lsRecData[llArrayPos] = '17,"' +  lsZip + '"' 
			Else
				lsRecData[llArrayPos] = '17,""'
				lsMissingFields += ", Zip" /*we will let user know data is missing*/
			End If
				
			/* 18, Cust Phone*/
			llArrayPos ++
			If lsPhone > '' Then
				lsRecData[llArrayPos] = '18,"' +  lsPhone + '"' 
			Else
				lsRecData[llArrayPos] = '18,"000"'
			End If
				
		Else /*Customer Not present -  warn user*/

			lsMissingFields += ", Customer Not present"
		
		End If /*VOR Dealer # present*/
	
	Else /*Not GM Hahn, take Address from DElivery Order Screen */
		
		/*Customer Name*/
		llArrayPos ++
		If Not isnull(adw_main.GetItemString(1,'cust_name')) Then
			lsRecData[llArrayPos] = '11,"' +  adw_main.GetItemString(1,'cust_name') + '"' 
		Else
			lsRecData[llArrayPos] = '11,""'
		End If
				
		llArrayPos ++
		lsRecData[llArrayPos] = '12,"' /*Contact Name*/
		If adw_main.GetItemString(1,'contact_person') > ' ' Then
			lsRecData[llArrayPos] += adw_main.GetItemString(1,'contact_person') + '"'
		Else
			lsRecData[llArrayPos] += 'N/A"'
		End If

		/*Address 1*/
		llArrayPos ++
		If Not isnull(adw_main.GetItemString(1,'address_1')) Then
			lsRecData[llArrayPos] = '13,"' +  adw_main.GetItemString(1,'address_1') + '"' 
		Else
			lsRecData[llArrayPos] = '13,""'
		End If
		
		/*Address 2*/
		llArrayPos ++
		If Not isnull(adw_main.GetItemString(1,'address_2')) Then
			lsRecData[llArrayPos] = '14,"' +  adw_main.GetItemString(1,'address_2') + '"' 
		Else
			lsRecData[llArrayPos] = '14,""'
		End If
		
		/*City*/
		llArrayPos ++
		If Not isnull(adw_main.GetItemString(1,'City')) Then
			lsRecData[llArrayPos] = '15,"' +  adw_main.GetItemString(1,'City') + '"' 
		Else
			lsRecData[llArrayPos] = '15,""'
		End If
		
		/*State*/
		llArrayPos ++
		If Not isnull(adw_main.GetItemString(1,'State')) Then
			lsRecData[llArrayPos] = '16,"' +  adw_main.GetItemString(1,'state') + '"' 
		Else
			lsRecData[llArrayPos] = '16,""'
		End If
		
		/*Zip*/
		llArrayPos ++
		If Not isnull(adw_main.GetItemString(1,'zip')) Then
			lsZip = adw_main.GetItemString(1,'zip')	
			lsRecData[llArrayPos] = '17,"' +  Left (lsZip, 5 ) + '"' 			
		Else
			lsRecData[llArrayPos] = '17,"00000"'
		End If
		
		/*Phone*/
		llArrayPos ++
		If Not isnull(adw_main.GetItemString(1,'tel')) Then
			lsPhone = adw_main.GetItemString(1,'tel')	
			lsRecData[llArrayPos] = '17,"' +  String (Left(lsPhone, 10),"0000000000" ) + '"' 		
			lsRecData[llArrayPos] = '18,"' +  adw_main.GetItemString(1,'tel') + '"' 
		Else
			lsRecData[llArrayPos] = '18,"0000000000"'
		End If
		
	End If

	lsCountry = adw_main.GetItemString(1,'Country')
	If isNUll(lsCountry) Then lsCountry = ''

	/* Field 19 - Destination Business Code - (USer Field 6)*/
	If Upper(gs_project) = 'GM_HAHN' Then
	llArrayPos ++
		If Not isnull(adw_main.GetItemString(1,'user_field6')) Then
			lsRecData[llArrayPos] = '19,"' +  adw_main.GetItemString(1,'user_field6') + '"' 
		Else
			lsRecData[llArrayPos] = '19,""'
		End If
	End If

	/* Field 20 - Payor Account NUmber - Get from lookup table - Based on Ship To Country*/
	If Upper(gs_project) = 'GM_HAHN' Then
		llArrayPos ++
		lsLookup = '20-'
		If Not isnull(lsCountry) Then
			lsLookup += Left(lsCountry,2)
		End If
		llFindRow = adw_defaults.Find("Code_ID = '" + lsLookup + "'",1,adw_defaults.RowCount())
		If llFindRow > 0 Then
			lsRecData[llArrayPos] = '20,"' +  adw_defaults.GetITemString(llFindRow,'code_descript') + '"'
		Else
			lsRecData[llArrayPos] = '20,""'
			lsMissingFields += ", Payor Account NUmbe" /*we will let user know data is missing*/
		End If
	End If

	/* - GAP 7/2002  21 - Package Weight */
	liTotalWeight = adw_pack.Object.c_weight[i]
	ldTotalWeight = adw_pack.Object.c_weight[i]
	ldTotalWeight = ldTotalWeight - liTotalWeight
	if ldTotalWeight > 0 then liTotalWeight = liTotalWeight + 1
	if liTotalWeight < 1 then liTotalWeight = 1

	If Upper(Left(gs_project,4)) = 'GM_M'  Then  
		llArrayPos ++
		lsRecData[llArrayPos] = '21,"' +  String(liTotalWeight,'###0') + '"'  	
	end if 

	/* Field 22 - Service Code - Get from lookup Table*/
	If Upper(gs_project) = 'GM_HAHN' Then
		llArrayPos ++
		lsLookup = '22'
		llFindRow = adw_defaults.Find("Code_ID = '" + lsLookup + "'",1,adw_defaults.RowCount())
		If llFindRow > 0 Then
			lsRecData[llArrayPos] = '22,"' +  adw_defaults.GetITemString(llFindRow,'code_descript') + '"'
		Else
			lsRecData[llArrayPos] = '22,""'
			lsMissingFields += ", Service Code" /*we will let user know data is missing*/
		End If
	End If

	/* Field 23 - Payment Code - Get from lookup Table*/
	llArrayPos ++
	lsLookup = '23'
	llFindRow = adw_defaults.Find("Code_ID = '" + lsLookup + "'",1,adw_defaults.RowCount())
	If llFindRow > 0 Then
		lsRecData[llArrayPos] = '23,"' +  adw_defaults.GetITemString(llFindRow,'code_descript') + '"'
	Else
		lsRecData[llArrayPos] = '23,""'
		lsMissingFields += ", Payment Code" /*we will let user know data is missing*/
	End If

	/*Field 24 - (Actual) Carrier ship date -  em_carrier_ship_date - "YYYYMMDD"   */
	If Upper(Left(gs_project,4)) = 'GM_M'  Then  
		ls_shipyear = String ( Year (ldt_carrier_ship_date), '0000' )
		ls_shipmonth = String (Month (ldt_carrier_ship_date), '00' )
		ls_shipday = String (Day (ldt_carrier_ship_date), '00' )
		llArrayPos ++
		lsRecData[llArrayPos] = '24,"' +  ls_shipyear +  ls_shipmonth + ls_shipday + '"'
	end if

	/*Field 25 - Reference Notes */
	Choose Case Upper(Left(gs_PRoject,4))
		Case 'GM_H' /*GM Hahn is using 2 vor ref fields (User 5 + User 7) */
			If Not isnull(adw_main.GetItemString(1,'User_Field5')) Then
				ls_reference += adw_main.GetItemString(1,'User_Field5') + ' // '
			Else
				ls_reference += ' // '
			End If
			If Not isnull(adw_main.GetItemString(1,'User_Field7')) Then
				ls_reference += adw_main.GetItemString(1,'User_Field7') + '"'
			Else
				ls_reference += '"'
			End If
		Case 'GM_M' /*GM_M - we want to concatonate the order number and SKU to aid Pickers */
			If Not isnull(adw_main.GetItemString(1,'cust_order_no')) Then
				ls_reference += adw_main.GetItemString(1,'cust_order_no') + ' '
			Else
				ls_reference += ' '
			End If
			If Not isnull(adw_pack.GetItemString(i,'sku')) Then
				ls_reference += adw_pack.GetItemString(i,'sku') + ' '  
			Else
				ls_reference += ' '
			End If
			If upper(Left(gs_project,4)) = 'GM_MO' Then ls_reference += String(l) + '/' + String(iiTotalQty) + '"'
		Case Else
			ls_reference += '"'
	End Choose
	l ++
	llArrayPos ++
	lsRecData[llArrayPos] = '25,"' + ls_reference

	/* - GAP 7/2002   26 - Declared value*/
	If Upper(Left(gs_project,4)) = 'GM_M' Then  
		llArrayPos ++
		If Not isnull(adw_detail.GetITemDecimal(llDetailFindRow,'Price')) then 
			ldTotalPrice = adw_detail.GetITemDecimal(llDetailFindRow,'Price')
		else 
			ldTotalPrice = 0
		end if
		if ldTotalPrice < 1 then ldTotalPrice = 1
		liTotalPrice = ldTotalPrice
		lsRecData[llArrayPos] = '26,"' + String(liTotalPrice,'#000') + '"'
	end if

	/*Field 50 - Country*/
	llArrayPos ++
	lsRecData[llArrayPos] = '50,"'
	If Not isnull(lsCountry) Then
		lsRecData[llArrayPos] += Left(lsCountry,2) + '"'
	Else
		lsRecData[llArrayPos] += '"'
		lsMissingFields += ", Country" /*we will let user know data is missing*/ 
	End If

	/* - GAP 6/2002    Height, Width, Lentgh dimentions*/
	If Upper(Left(gs_project,4)) = 'GM_M'  Then 
	
		//08/02 - Pconkl - Make sure dimensions are in proper order (lengh > width > height)
		ldsDimensions = Create DataStore
		ldsDimensions.dataobject = 'd_dimension_sort'
		llNewRow = ldsDimensions.InsertRow(0)
		ldsDimensions.SetItem(llNewRow,'dimension',adw_pack.Object.length[i])
		llNewRow = ldsDimensions.InsertRow(0)
		ldsDimensions.SetItem(llNewRow,'dimension',adw_pack.Object.width[i])
		llNewRow = ldsDimensions.InsertRow(0)
		ldsDimensions.SetItem(llNewRow,'dimension',adw_pack.Object.height[i])
		ldsDimensions.Sort()
		lllentgh = ldsDimensions.GetITemNumber(1,'dimension')
		llWidth = ldsDimensions.GetITemNumber(2,'dimension')
		llheight = ldsDimensions.GetITemNumber(3,'dimension')
		llGirth = llLentgh + (2*llHeight) + (2*llWidth)
	
		IF liTotalWeight >= 150 or llGirth > 165 then
			IF llHeight > 0 then
				llArrayPos ++
				lsRecData[llArrayPos] = '57,"' +  String(llHeight) + '"' /* 57 - HIEGHT */
			else  
				lsRecData[llArrayPos] = '57,""'
			End if
			IF llWidth > 0 then 
				llArrayPos ++
				lsRecData[llArrayPos] = '58,"' +  String(llWidth) + '"'  /* 58 - WIDTH*/
			else 
				lsRecData[llArrayPos] = '58,""'
			End if
			IF llLentgh > 0 then 
				llArrayPos ++
				lsRecData[llArrayPos] = '59,"' +  String(llLentgh) + '"' /* 59 - LENTGH*/
			else 
				lsRecData[llArrayPos] = '59,""'
			End if
		End if
	end if

	If upper(gs_project) = 'GM_HAHN' Then 
		/* Field 68 - Currency - Get from lookup Table*/
		llArrayPos ++
		lsLookup = '68'
		llFindRow = adw_defaults.Find("Code_ID = '" + lsLookup + "'",1,adw_defaults.RowCount())
		If llFindRow > 0 Then
			lsRecData[llArrayPos] = '68,"' +  adw_defaults.GetITemString(llFindRow,'code_descript') + '"'
		Else
			lsRecData[llArrayPos] = '68,""'
			lsMissingFields += ", Currency" /*we will let user know data is missing*/
		End If

		/* Field 70 - Duty Tax - Get from lookup Table*/
		llArrayPos ++
		lsLookup = '70'
		llFindRow = adw_defaults.Find("Code_ID = '" + lsLookup + "'",1,adw_defaults.RowCount())
		If llFindRow > 0 Then
			lsRecData[llArrayPos] = '70,"' +  adw_defaults.GetITemString(llFindRow,'code_descript') + '"'
		Else
			lsRecData[llArrayPos] = '70,""'
			lsMissingFields += ", Duty Tax" /*we will let user know data is missing*/
		End If

		/* Field 71 - Duty Tax Account - Get from lookup table - Based on Ship To Country*/
		llArrayPos ++
		lsLookup = '71-'
		If Not isnull(lsCountry) Then
			lsLookup += Left(lsCountry,2)
		End If
		llFindRow = adw_defaults.Find("Code_ID = '" + lsLookup + "'",1,adw_defaults.RowCount())
		If llFindRow > 0 Then
			lsRecData[llArrayPos] = '71,"' +  adw_defaults.GetITemString(llFindRow,'code_descript') + '"'
		Else
			lsRecData[llArrayPos] = '71,""'
			lsMissingFields += ", Duty Tax Account" /*we will let user know data is missing*/
		End If

		/* Field 72 - Terms of Sale - Get from lookup Table*/
		llArrayPos ++
		lsLookup = '72'
		llFindRow = adw_defaults.Find("Code_ID = '" + lsLookup + "'",1,adw_defaults.RowCount())
		If llFindRow > 0 Then
			lsRecData[llArrayPos] = '72,"' +  adw_defaults.GetITemString(llFindRow,'code_descript') + '"'
		Else
			lsRecData[llArrayPos] = '72,""'
			lsMissingFields += ", Terms of Sale" /*we will let user know data is missing*/
		End If
	
		/* Field 75 - Weight Type - Get from lookup Table*/
		llArrayPos ++
		lsLookup = '75'
		llFindRow = adw_defaults.Find("Code_ID = '" + lsLookup + "'",1,adw_defaults.RowCount())
		If llFindRow > 0 Then
			lsRecData[llArrayPos] = '75,"' +  adw_defaults.GetITemString(llFindRow,'code_descript') + '"'
		Else
			lsRecData[llArrayPos] = '75,""'
			lsMissingFields += ", Weight Type" /*we will let user know data is missing*/
		End If
	
		/* Field 79 - Package Desc 1 - Get from lookup Table*/
		llArrayPos ++
		lsLookup = '79'
		llFindRow = adw_defaults.Find("Code_ID = '" + lsLookup + "'",1,adw_defaults.RowCount())
		If llFindRow > 0 Then
			lsRecData[llArrayPos] = '79,"' +  adw_defaults.GetITemString(llFindRow,'code_descript') + '"'
		Else
			lsRecData[llArrayPos] = '79,""'
			lsMissingFields += ", Package Desc" /*we will let user know data is missing*/
		End If

		/* Field 80 - Country of Manufacture - Get from lookup Table*/
		llArrayPos ++
		lsLookup = '80'
		llFindRow = adw_defaults.Find("Code_ID = '" + lsLookup + "'",1,adw_defaults.RowCount())
		If llFindRow > 0 Then
			lsRecData[llArrayPos] = '80,"' +  adw_defaults.GetITemString(llFindRow,'code_descript') + '"'
		Else
			lsRecData[llArrayPos] = '80,""'
			lsMissingFields += ", Country of Manufacture" /*we will let user know data is missing*/
		End If

		/*Field 112 - Weight - take from computed field on PackList*/
		llArrayPos ++
		If Not isnull(adw_pack.Object.c_weight[1]) Then
			lsRecData[llArrayPos] = '112,"' +  String(adw_pack.Object.c_weight[1],'#####.00') + '"' 
		Else
			lsRecData[llArrayPos] = '112,""'
		End If
	End If

	/*Field 116 - package Count - take from computed field on Pack*/
	llArrayPos ++
	If Not isnull(adw_pack.Object.c_Carton_count[1]) Then
		lsRecData[llArrayPos] = '116,"' +  String(adw_pack.Object.c_Carton_count[1]) + '"' 
	Else
		lsRecData[llArrayPos] = '116,""'
	End If
	If Upper(Left(gs_project,4)) = 'GM_M'  Then  lsRecData[llArrayPos] = '116,"1"'

	/* - GAP 6/2002   Detroit/Satillo defaults*/
	If Upper(Left(gs_project,4)) = 'GM_M'  Then  
		llArrayPos ++
		lsRecData[llArrayPos] = '117,"US"' 		/* 117 - Shipper Country*/
		llArrayPos ++
		lsRecData[llArrayPos] = '1273,"01"' 	/* 1273 - Customer packaging*/
		llArrayPos ++
	
		ls_schCode = adw_main.GetITemString(1,'user_field1')
			CHOOSE CASE adw_main.GetITemString(1,'user_field1')
		 	CASE "B", "E/TRK", "F", "L", "N" , "Q" 	/*FEDEX GROUND*/
				ls_schCode = "GROUND"
		//		 	CASE "V", "V/OVN", "V/TRK", "V/AFR"			/*FEDEX 2ND DAY AIR*/
			END CHOOSE
		lsRecData[llArrayPos] = '1274,"03"' 	/* 1274 - service type (2ND DAY)*/
		IF liTotalWeight >= 150 or llGirth > 165 then lsRecData[llArrayPos] = '1274,"80"' /* (2ND DAY/FREIGHT)*/
		IF (liTotalWeight <= 150 and lllentgh <= 108  and llGirth <= 130) and ls_schCode = "GROUND" then 
			lsRecData[llArrayPos] = '1274,"92"' /* (GROUND)*/
			llArrayPos ++  								/* 3002 - display Sims Order Number in popup window Field*/
			lsRecData[llArrayPos] = '3002,"' + adw_main.GetItemString(1,'invoice_no') + '"' 
			llArrayPos ++  								/* 3003 - display Reference Notes in popup window Field*/
			lsRecData[llArrayPos] = '3003,"' + ls_reference
		end if
		llArrayPos ++  								/* 2132 - display Sims Order Number on PCKG CNT 1 Field*/
		lsRecData[llArrayPos] = '2132,"' + adw_main.GetItemString(1,'invoice_no') + '"' 
		llArrayPos ++
		lsRecData[llArrayPos] = '99,""' 			/* - 99 - End of transaction*/
	end if

	//If any required fields are missing, warn and get out
	If lsMissingFields > '' Then
		lsMissingFields = Right(lsMissingFields,(Len(lsMissingFields) - 1)) /*strip off first comma*/
		MessageBox(lsPath,'The following fields were not not set from default values ~rand MUST be entered before sending this file:~r~r' + lsMissingFields)
		Return -1
	End If

	//Write the rows to the file
	For llArrayPos = 1 to Upperbound(lsRecData)
		liRC = FileWrite(liFileNo,lsRecData[llArrayPos])
		If liRC < 0 Then
			MessageBox('FEDEX Export','Unable to write to Fedex File. File was not exported.')
			Return -1
		End If
	Next
	q ++
 loop

loop

//Close the File
liRC = FileClose(liFileNo)
If liRC < 0 Then
	messagebox('FEDEX Export',"Unable to Close File: " + lsPath + ". ~r~rFile Not exported!")
	Return -1
End If

Messagebox('Fedex Export','Order successfully exported to:~r' + lsPath)

Return 0

end function

public function integer uf_export_to_fedex_batch (ref datawindow adw_detail, ref datawindow adw_pack, integer alpackrow);//Export order info to Fedex Powership - From Batch Picking (Exporting a Single Pack Row at a time)

String	lsFile,	&
			lsPath,	&
			lsRecData[],	&
			lsLookup,	&
			lsMissingFields,	&
			lsCustName,	&
			lsCustCode,	&
			lsContact,	&
			lsPhone,		&
			lsAddr1,		&
			lsAddr2,		&
			lsCity,		&
			lsState,		&
			lsZip,		&
			lsCountry,	&
			lsFind, 		&
			ls_reference, &
			ls_shipyear, &
			ls_shipmonth, &
			ls_shipday , &
			ls_schCode
			
Integer	liRC,	&
			liTotalPrice, &
			liTotalWeight

Long		llFindRow,	&
			llRowPos,	&
			llArrayPos,	&
			llDetailFindRow,	&
			llHeight,	&
			llWidth,		&
			llLentgh,	&
			llGirth,		&
			llNewROw

decimal{2}	ldTotalPrice, &
				ldTotalWeight
date ldt_carrier_ship_date

Datastore	ldsDimensions

SetPointer(Hourglass!)

// gap 09/2002 - capture the carrier ship date
ldt_carrier_ship_date = date(w_batch_pick.tab_main.tabpage_pack.em_carrier_ship_date.text)


//If the Current Row passed in is 0, we only want to close the file
If alPackRow = 0 Then
	if iiFileNo > 0 Then
		liRC = FileClose(iiFileNo)
		If liRC > 0 Then
			Messagebox('Fedex','Records successfully written to FEDEX Export File.')
		Else
			Messagebox('Fedex','Unable to write records to FEDEX Export File.')
		End If
	End If
	
	Return 0
	
End If

//If the Fedex Defaults Datastore hasn't already been created, create and retrieve
If not isvalid(idsDefaults) Then
	idsDefaults = Create Datastore
	idsDefaults.Dataobject = 'd_carrier_default_fedex'
	idsDefaults.SetTransObject(SQLCA)
	idsDefaults.Retrieve(gs_project)
End If

If idsDefaults.RowCount() < 0 Then Return -1

llArrayPos = 0

//Write data to array - we will write to file at end if successfull
//Export data to File - some data comes from Lookup Table (Code ID = 'FEDEX'), other from order info

//Find an Order Detail record that corresponds to this Packing row for Header level Information
lsFind = "Upper(do_no) = '" + Upper(adw_pack.GetItemString(alPackRow,'do_no')) + "'"
lsFind += " and Upper(sku) = '" + Upper(adw_pack.GetItemString(alPackRow,'sku')) + "'"
//lsFind += " and Upper(supp_code) = '" + Upper(adw_pack.GetItemString(alPackRow,'supp_code')) + "'"
lsFind += " and line_item_no = " + String(adw_pack.GetItemNumber(alPackRow,'line_Item_no'))

iiTotalQty = adw_pack.GetItemNumber(alPackRow,'compute_4') /*Capture Sum of QTY by Invoice # to keep track of Labels per Order*/
llDetailFindRow = adw_Detail.Find(lsFind,1,adw_Detail.RowCount())
If lLDetailFindRow <= 0 Then Return -1 /*should never happen*/

If upper(gs_project) = 'GM_HAHN' Then 
	llArrayPos ++
	lsRecData[llarrayPos] = '0,"051"' /*trans Type*/
	llArrayPos ++
	lsRecData[llarrayPos] = '1,"' + Right(adw_detail.GetITemString(llDetailFindRow,'do_no'),6) + '"' /*Trans ID*/
else  // GAP 8/02 
	llArrayPos ++
	lsRecData[llarrayPos] = '0,"020"' /* GAP 6/2002 trans Type*/ 
	iiCountQty += 1
	llArrayPos ++
	lsRecData[llarrayPos] = '1,"' + Right(adw_detail.GetITemString(llDetailFindRow,'do_no'),7) + "|" + string(adw_pack.GetITemString(alPackRow,'carton_no')) + "|" + string(adw_pack.GetItemNumber(alPackRow,'line_Item_no')) + "|" + adw_detail.GetITemString(llDetailFindRow,'cust_order_no') + '"' 
end if

//GM Hahn - we need to retrieve the customer address information from the VOR dealer NUmber (USER Field 6)
//Otherwise, we will take the customer information from the DO - Country Code still coming from Customer on DO
If upper(gs_project) = 'GM_HAHN' Then
	
	lsCustCode = adw_detail.GetITemString(llDetailFindRow,'user_field6')
	If lsCustCode > '' Then
		
		Select Cust_Name, Contact_Person, Address_1, Address_2, City, State, Zip, Tel
		Into	:lsCustName, :lsContact, :lsAddr1, :lsAddr2, :lsCity, :lsState, :lsZip, :lsPhone
		From Customer
		Where Project_id = :gs_project and cust_code = :lsCustCode
		Using SQLCA;
			
		/* 11, Customer Name*/
		llArrayPos ++
		If lsCustName > '' Then
			lsRecData[llArrayPos] = '11,"' +  lsCustName + '"' 
		Else
			lsRecData[llArrayPos] = '11,""'
			lsMissingFields += ", Customer Name" /*we will let user know data is missing*/
		End If
		
		/* 12, Contact Name    // gap 6-2002 commented out per email request by hahn
		llArrayPos ++
		If lsContact > '' Then
			lsRecData[llArrayPos] = '12,"' + lsContact + '"'
		Else
			lsRecData[llArrayPos] = '12,"N/A"'
		End If */	
		
		/* 13, Cust Address 1*/
		llArrayPos ++
		If lsAddr1 > '' Then
			lsRecData[llArrayPos] = '13,"' +  lsAddr1 + '"' 
		Else
			lsRecData[llArrayPos] = '13,""'
			lsMissingFields += ", Cust Address 1" /*we will let user know data is missing*/
		End If
				
		/* 14, Cust Address 2*/
		llArrayPos ++
		If lsAddr2 > '' Then
			lsRecData[llArrayPos] = '14,"' +  lsAddr2 + '"' 
		Else
			lsRecData[llArrayPos] = '14,""'
		End If
				
		/* 15, Cust City*/
		llArrayPos ++
		If lsCity > '' Then
			lsRecData[llArrayPos] = '15,"' +  lsCity + '"' 
		Else
			lsRecData[llArrayPos] = '15,""'
			lsMissingFields += ", City" /*we will let user know data is missing*/
		End If
				
		/* 16, Cust State*/
		llArrayPos ++
		If lsState > '' Then
			lsRecData[llArrayPos] = '16,"' +  lsState + '"' 
		Else
			lsRecData[llArrayPos] = '16,""'
			lsMissingFields += ", State" /*we will let user know data is missing*/
		End If
				
		/* 17, Cust Zip*/
		llArrayPos ++
		If lsZip > '' Then
			lsRecData[llArrayPos] = '17,"' +  lsZip + '"' 
		Else
			lsRecData[llArrayPos] = '17,""'
			lsMissingFields += ", Zip" /*we will let user know data is missing*/
		End If
				
		/* 18, Cust Phone*/
		llArrayPos ++
		If lsPhone > '' Then
			lsRecData[llArrayPos] = '18,"' +  lsPhone + '"' 
		Else
			lsRecData[llArrayPos] = '18,"000"'
		End If
				
	Else /*Customer Not present -  warn user*/

		lsMissingFields += ", Customer Not present"
		
	End If /*VOR Dealer # present*/
	
Else /*Not GM Hahn, take Address from DElivery Order Screen */
		
		/*Customer Name*/
		llArrayPos ++
		If Not isnull(adw_detail.GetITemString(llDetailFindRow,'cust_name')) Then
			lsRecData[llArrayPos] = '11,"' +  adw_detail.GetITemString(llDetailFindRow,'cust_name') + '"' 
		Else
			lsRecData[llArrayPos] = '11,""'
		End If

 		/*Contact Name*/
		llArrayPos ++
		lsRecData[llArrayPos] = '12,"'
		If adw_detail.GetITemString(llDetailFindRow,'contact_person') > ' ' Then
			lsRecData[llArrayPos] += adw_detail.GetITemString(llDetailFindRow,'contact_person') + '"'
		Else
			lsRecData[llArrayPos] += 'N/A"'
		End If
		
		/*Address 1*/
		llArrayPos ++
		If Not isnull(adw_detail.GetITemString(llDetailFindRow,'address_1')) Then
			lsRecData[llArrayPos] = '13,"' +  adw_detail.GetITemString(llDetailFindRow,'address_1') + '"' 
		Else
			lsRecData[llArrayPos] = '13,""'
		End If
		
		/*Address 2*/
		llArrayPos ++
		If Not isnull(adw_detail.GetITemString(llDetailFindRow,'address_2')) Then
			lsRecData[llArrayPos] = '14,"' +  adw_detail.GetITemString(llDetailFindRow,'address_2') + '"' 
		Else
			lsRecData[llArrayPos] = '14,""'
		End If
		
		/*City*/
		llArrayPos ++
		If Not isnull(adw_detail.GetITemString(llDetailFindRow,'City')) Then
			lsRecData[llArrayPos] = '15,"' +  adw_detail.GetITemString(llDetailFindRow,'City') + '"' 
		Else
			lsRecData[llArrayPos] = '15,""'
		End If
		
		/*State*/
		llArrayPos ++
		If Not isnull(adw_detail.GetITemString(llDetailFindRow,'State')) Then
			lsRecData[llArrayPos] = '16,"' +  adw_detail.GetITemString(llDetailFindRow,'state') + '"' 
		Else
			lsRecData[llArrayPos] = '16,""'
		End If
		
		/*Zip*/
		llArrayPos ++
		If Not isnull(adw_detail.GetITemString(llDetailFindRow,'zip')) Then
			lsZip = adw_detail.GetITemString(llDetailFindRow,'zip')
			lsRecData[llArrayPos] = '17,"' +  Left (lsZip, 5 ) + '"' 
	Else
			lsRecData[llArrayPos] = '17,"00000"'
		End If
		
		/*Phone*/
		llArrayPos ++
		If Not isnull(adw_detail.GetITemString(llDetailFindRow,'tel')) Then
			lsPhone = adw_detail.GetITemString(llDetailFindRow,'tel')
			lsRecData[llArrayPos] = '18,"' + String(Left (lsPhone, 10 ),'0000000000') + '"'
		Else
			lsRecData[llArrayPos] = '18,"0000000000"'
		End If
		
End If

lsCountry = adw_detail.GetITemString(llDetailFindRow,'Country')
If isNUll(lsCountry) Then lsCOuntry = ''

/* Field 19 - Destination Business Code - (USer Field 6)*/
If Upper(gs_project) = 'GM_HAHN' Then
	llArrayPos ++
	If Not isnull(adw_detail.GetITemString(llDetailFindRow,'user_field6')) Then
		lsRecData[llArrayPos] = '19,"' +  adw_detail.GetITemString(llDetailFindRow,'user_field6') + '"' 
	Else
		lsRecData[llArrayPos] = '19,""'
	End If
End If

/* Field 20 - Payor Account NUmber - Get from lookup table - Based on Ship To Country*/
If upper(gs_project) = 'GM_HAHN' Then 
	llArrayPos ++
	lsLookup = '20-'
	If Not isnull(lsCountry) Then
	lsLookup += Left(lsCountry,2)
	End If
	llFindRow = idsDefaults.Find("Code_ID = '" + lsLookup + "'",1,idsDefaults.RowCount())
	If llFindRow > 0 Then
	lsRecData[llArrayPos] = '20,"' +  idsDefaults.GetITemString(llFindRow,'code_descript') + '"'
	Else
	lsRecData[llArrayPos] = '20,""'
	lsMissingFields += ", Payor Account" /*we will let user know data is missing*/
	End If
end if

/* - GAP 6/2002  21 - Package Weight */
liTotalWeight = adw_pack.getItemNumber(alPackRow,'weight_net')
ldTotalWeight = adw_pack.getItemNumber(alPackRow,'weight_net')
ldTotalWeight = ldTotalWeight - liTotalWeight
if ldTotalWeight > 0 then liTotalWeight = liTotalWeight + 1
if liTotalWeight < 1 then liTotalWeight = 1
If Upper(Left(gs_project,4)) = 'GM_M'  Then  
	llArrayPos ++
	lsRecData[llArrayPos] = '21,"' +  String(liTotalWeight,'###0') + '"'  	
end if 

/* Field 22 - Service Code - Get from lookup Table*/
If upper(gs_project) = 'GM_HAHN' Then 
	llArrayPos ++
	lsLookup = '22'
	llFindRow = idsDefaults.Find("Code_ID = '" + lsLookup + "'",1,idsDefaults.RowCount())
	If llFindRow > 0 Then
		lsRecData[llArrayPos] = '22,"' +  idsDefaults.GetITemString(llFindRow,'code_descript') + '"'
	Else
		lsRecData[llArrayPos] = '22,""' 
		lsMissingFields += ", Service Code" /*we will let user know data is missing*/
	End If
End if

/* Field 23 - Payment Code - Get from lookup Table*/
llArrayPos ++
lsLookup = '23'
llFindRow = idsDefaults.Find("Code_ID = '" + lsLookup + "'",1,idsDefaults.RowCount())
If llFindRow > 0 Then
	lsRecData[llArrayPos] = '23,"' +  idsDefaults.GetITemString(llFindRow,'code_descript') + '"'
Else
	lsRecData[llArrayPos] = '23,""'
	lsMissingFields += ", Payment Code" /*we will let user know data is missing*/
End If

/*Field 24 - (Actual) Carrier ship date -  em_carrier_ship_date - "YYYYMMDD"   */
ls_shipyear = String ( Year (ldt_carrier_ship_date), '0000' )
ls_shipmonth = String (Month (ldt_carrier_ship_date), '00' )
ls_shipday = String (Day (ldt_carrier_ship_date), '00' )
llArrayPos ++
lsRecData[llArrayPos] = '24,"' +  ls_shipyear +  ls_shipmonth + ls_shipday + '"'

/*Field 25 - Reference Notes */
Choose Case Upper(Left(gs_PRoject,4))
	Case 'GM_H' /*GM Hahn is using 2 vor ref fields (User 5 + User 7) */
		
		If Not isnull(adw_detail.GetITemString(llDetailFindRow,'User_Field5')) Then
			ls_reference += adw_detail.GetITemString(llDetailFindRow,'User_Field5') + ' '
		Else
			ls_reference += ' '
		End If
		If Not isnull(adw_detail.GetITemString(llDetailFindRow,'User_Field7')) Then
			ls_reference += adw_detail.GetITemString(llDetailFindRow,'User_Field7') + '"'
		Else
			ls_reference += '"'
		End If
	Case 'GM_M' /*GM_M - we want to concatonate the cust number and SKU to aid Pickers */
		If Not isnull(adw_detail.GetITemString(llDetailFindRow,'cust_order_no')) Then
			ls_reference += adw_detail.GetITemString(llDetailFindRow,'cust_order_no') + ' '
		Else
			ls_reference += ' '
		End If
		If Not isnull(adw_detail.GetITemString(llDetailFindRow,'sku')) Then
			ls_reference += adw_detail.GetITemString(llDetailFindRow,'sku') + ' '
		Else
			ls_reference += ' '
		End If
		If upper(Left(gs_project,4)) = 'GM_MO' Then ls_reference += String(iiCountQty) + '-' + String(iiTotalQty) + '"'
		If iiCountQty = iiTotalQty then iiCountQty = 0
	Case Else
		ls_reference += '"'
End Choose
llArrayPos ++
lsRecData[llArrayPos] = '25,"' + ls_reference

/* - GAP 7/2002   26 - Declared value*/
If Upper(Left(gs_project,4)) = 'GM_M'  Then  
	llArrayPos ++
	If Not isnull(adw_detail.GetITemDecimal(llDetailFindRow,'Price')) then 
			ldTotalPrice = adw_detail.GetITemDecimal(llDetailFindRow,'Price')
	else 
			ldTotalPrice = 0
	end if
	if ldTotalPrice < 1 then ldTotalPrice = 1
	liTotalPrice = ldTotalPrice
	lsRecData[llArrayPos] = '26,"' + String(liTotalPrice,'#000') + '"'
end if

/*Field 50 - Country*/
llArrayPos ++
lsRecData[llArrayPos] = '50,"'
If Not isnull(lsCountry) Then
	lsRecData[llArrayPos] += Left(lsCountry,2) + '"'
Else
	lsRecData[llArrayPos] += '"'
	lsMissingFields += ", Country" /*we will let user know data is missing*/ 
End If

/* - GAP 6/2002    Height, Width, Lentgh dimentions*/
If Upper(Left(gs_project,4)) = 'GM_M'    then
	
	//08/02 - Pconkl - Make sure dimensions are in proper order (lengh > width > height)
	ldsDimensions = Create DataStore
	ldsDimensions.dataobject = 'd_dimension_sort'
	llNewRow = ldsDimensions.InsertRow(0)
	ldsDimensions.SetItem(llNewRow,'dimension',adw_pack.getItemNumber(alPackRow,'length'))
	llNewRow = ldsDimensions.InsertRow(0)
	ldsDimensions.SetItem(llNewRow,'dimension',adw_pack.getItemNumber(alPackRow,'width'))
	llNewRow = ldsDimensions.InsertRow(0)
	ldsDimensions.SetItem(llNewRow,'dimension',adw_pack.getItemNumber(alPackRow,'height'))
	ldsDimensions.Sort()

	lllentgh = ldsDimensions.GetITemNumber(1,'dimension')
	llWidth = ldsDimensions.GetITemNumber(2,'dimension')
	llheight = ldsDimensions.GetITemNumber(3,'dimension')
	
	llGirth = llLentgh + (2*llHeight) + (2*llWidth)
	
	IF liTotalWeight >= 150 or llGirth > 165 then
		IF llHeight > 0 then
			llArrayPos ++
			lsRecData[llArrayPos] = '57,"' +  String(llHeight) + '"' /* 57 - HIEGHT */
		else  
			lsRecData[llArrayPos] = '57,""'
		End if
		IF llWidth > 0 then 
			llArrayPos ++
			lsRecData[llArrayPos] = '58,"' +  String(llWidth) + '"'  /* 58 - WIDTH*/
		else 
			lsRecData[llArrayPos] = '58,""'
		End if
		IF llLentgh > 0 then 
			llArrayPos ++
			lsRecData[llArrayPos] = '59,"' +  String(llLentgh) + '"' /* 59 - LENTGH*/
		else 
			lsRecData[llArrayPos] = '59,""'
		End if
	End if
end if

If upper(gs_project) = 'GM_HAHN' Then 
	/* Field 68 - Currency - Get from lookup Table*/
	llArrayPos ++
	lsLookup = '68'
	llFindRow = idsDefaults.Find("Code_ID = '" + lsLookup + "'",1,idsDefaults.RowCount())
	If llFindRow > 0 Then
		lsRecData[llArrayPos] = '68,"' +  idsDefaults.GetITemString(llFindRow,'code_descript') + '"'
	Else
		lsRecData[llArrayPos] = '68,""'
		lsMissingFields += ", Currency" /*we will let user know data is missing*/
	End If

	/* Field 70 - Duty Tax - Get from lookup Table*/
	llArrayPos ++
	lsLookup = '70'
	llFindRow = idsDefaults.Find("Code_ID = '" + lsLookup + "'",1,idsDefaults.RowCount())
	If llFindRow > 0 Then
		lsRecData[llArrayPos] = '70,"' +  idsDefaults.GetITemString(llFindRow,'code_descript') + '"'
	Else
		lsRecData[llArrayPos] = '70,""'
		lsMissingFields += ", Duty Tax" /*we will let user know data is missing*/
	End If

	/* Field 71 - Duty Tax Account - Get from lookup table - Based on Ship To Country*/
	llArrayPos ++
	lsLookup = '71-'
	If Not isnull(lsCountry) Then
		lsLookup += Left(lsCountry,2)
	End If
	llFindRow = idsDefaults.Find("Code_ID = '" + lsLookup + "'",1,idsDefaults.RowCount())
	If llFindRow > 0 Then
		lsRecData[llArrayPos] = '71,"' +  idsDefaults.GetITemString(llFindRow,'code_descript') + '"'
	Else
		lsRecData[llArrayPos] = '71,""'
		lsMissingFields += ", Duty Tax Account" /*we will let user know data is missing*/
	End If

	/* Field 72 - Terms of Sale - Get from lookup Table*/
	llArrayPos ++
	lsLookup = '72'
	llFindRow = idsDefaults.Find("Code_ID = '" + lsLookup + "'",1,idsDefaults.RowCount())
	If llFindRow > 0 Then
		lsRecData[llArrayPos] = '72,"' +  idsDefaults.GetITemString(llFindRow,'code_descript') + '"'
	Else
		lsRecData[llArrayPos] = '72,""'
		lsMissingFields += ", Terms of Sale" /*we will let user know data is missing*/
	End If

	/* Field 75 - Weight Type - Get from lookup Table*/
	llArrayPos ++
	lsLookup = '75'
	llFindRow = idsDefaults.Find("Code_ID = '" + lsLookup + "'",1,idsDefaults.RowCount())
	If llFindRow > 0 Then
		lsRecData[llArrayPos] = '75,"' +  idsDefaults.GetITemString(llFindRow,'code_descript') + '"'
	Else
		lsRecData[llArrayPos] = '75,""'
		lsMissingFields += ", Weight Type" /*we will let user know data is missing*/
	End If

	/* Field 79 - Package Desc 1 - Get from lookup Table*/
	llArrayPos ++
	lsLookup = '79'
	llFindRow = idsDefaults.Find("Code_ID = '" + lsLookup + "'",1,idsDefaults.RowCount())
	If llFindRow > 0 Then
		lsRecData[llArrayPos] = '79,"' +  idsDefaults.GetITemString(llFindRow,'code_descript') + '"'
	Else
		lsRecData[llArrayPos] = '79,""'
		lsMissingFields += ", Package Desc 1" /*we will let user know data is missing*/
	End If

	/* Field 80 - Country of Manufacture - Get from lookup Table*/
	llArrayPos ++
	lsLookup = '80'
	llFindRow = idsDefaults.Find("Code_ID = '" + lsLookup + "'",1,idsDefaults.RowCount())
	If llFindRow > 0 Then
		lsRecData[llArrayPos] = '80,"' +  idsDefaults.GetITemString(llFindRow,'code_descript') + '"'
	Else
		lsRecData[llArrayPos] = '80,""'
		lsMissingFields += ", Country of Manufacture" /*we will let user know data is missing*/
	End If

	/*Field 112 - Weight - Take Net weight - we will create a label for 'EACH' */
	llArrayPos ++
	If Not isnull(adw_pack.getItemNumber(alPackRow,'weight_net')) Then
		lsRecData[llArrayPos] = '112,"' +  String(adw_pack.getItemNumber(alPackRow,'weight_net'),'#####.00') + '"' 
	Else
		lsRecData[llArrayPos] = '112,""'
	End If

End if

/*Field 116 - package Count - will always be 1 (we are printing a label for EACH unit)*/
llArrayPos ++
lsRecData[llArrayPos] = '116,"1"'

/* - GAP 6/2002   Satillo defaults*/
If Upper(Left(gs_project,4)) = 'GM_M'  Then  
	llArrayPos ++
	lsRecData[llArrayPos] = '117,"US"' 		/* 117 - Shipper Country*/
	llArrayPos ++
	lsRecData[llArrayPos] = '1273,"01"' 	/* 1273 - Customer packaging*/
	llArrayPos ++
	ls_schCode = adw_detail.GetITemString(llDetailFindRow,'user_field1')
			CHOOSE CASE adw_detail.GetITemString(llDetailFindRow,'user_field1')
		 	CASE "B", "E/TRK", "F", "L", "N" , "Q" 	/*FEDEX GROUND*/
				ls_schCode = "GROUND"
//		 	CASE "V", "V/OVN", "V/TRK", "V/AFR"			/*FEDEX 2ND DAY AIR*/
			END CHOOSE
	lsRecData[llArrayPos] = '1274,"03"' 	/* 1274 - service type (2ND DAY)*/
	IF liTotalWeight > 150 or llGirth > 165 then lsRecData[llArrayPos] = '1274,"80"' /* (2ND DAY/FREIGHT)*/
	IF (liTotalWeight <= 150 and lllentgh <= 108  and llGirth <= 130) and ls_schCode = "GROUND" then 
		lsRecData[llArrayPos] = '1274,"92"' /* (GROUND)*/
		llArrayPos ++  								/* 3002 - display Sims Order Number in pop up window Field*/
		lsRecData[llArrayPos] = '3002,"' +  adw_detail.GetITemString(llDetailFindRow,'invoice_no') + '"' 
		llArrayPos ++  								/* 3002 - display Reference Notes in pop up window Field*/
		lsRecData[llArrayPos] = '3003,"' + ls_reference		
	end if
	llArrayPos ++  								/* 2132 - display Sims Order Number on PCKG CNT 1 Field*/
	lsRecData[llArrayPos] = '2132,"' +  adw_detail.GetITemString(llDetailFindRow,'invoice_no') + '"' 
	llArrayPos ++
	lsRecData[llArrayPos] = '99,""' 			/* - 99 - End of transaction*/
end if

If iiFileNo <=0 or isnull(iiFileNo) Then /*if file number is > 0 then the file is already open from a previous call here - will close when done*/

	//See if there is  default file in the lookup table, otherwise prompt for file
	llFindRow = idsDefaults.Find("Upper(Code_ID) = 'DFILENAME'",1,idsDefaults.RowCount())
	If llFindRow > 0 Then
		lsPath = idsDefaults.GetITemString(llFindRow,'code_descript')
	End If

	If lspath > '' Then
	Else /*Prompt for File*/
		liRC = GetFileSaveName('Save FEDEX File To:',lsPath, lsFile)
		If liRC < 1 Then REturn -1
	End If

	//Try and open the File 
	iiFileNo = FileOpen(lsPath,LineMode!,Write!,LockReadWrite!,Append!)

	If iiFileNo <= 0 Then
		Do While iiFileNo <= 0
			Messagebox('FEDEX Export','Unable to Open/Create File: ' + lsPath + ' for export to FEDEX')
			liRC = GetFileSaveName('Save FEDEX File To:',lsPath, lsFile)
			If liRC < 1 Then REturn -1
			iiFileNo = FileOpen(lsPath,LineMode!,Write!,LockReadWrite!,Append!)
		Loop
	End If
	
End If /*File not already Opened*/

//Write the rows to the file
For llArrayPos = 1 to Upperbound(lsRecData)
	liRC = FileWrite(iiFileNo,lsRecData[llArrayPos])
	If liRC < 0 Then
		MessageBox('FEDEX Export','Unable to write to Fedex File. File was not exported.')
		Return -1
	End If
Next

Return 0
end function

public function integer uf_export_to_ups (ref datawindow adw_main, ref datawindow adw_detail, ref datawindow adw_defaults, ref datawindow adw_pack);//GAP 10-03 Export order info to UPS One order at a time

String	lsFile,	&
			lsPath,	&
			lsRecData,	&
			lsLookup,	&
			lsFind, &
			lsMissingFields,	&
			lsCustOrderNo, &
			lsCustCode,	&
			lsCustName,	&
			lsContact,	&
			lsPhone,		&
			lsAddr1,		&
			lsAddr2,		&
			lsAddr3,		&
			lsCity,		&
			lsState,		&
			lsZip,		&
			lsCountry,	&
			lsCountryName, &
			ls_reference, &
			ls_shipyear, 	&
			ls_shipmonth, 	&
			ls_shipday, 	&
			ls_schCode, 	&
			lsCarton
			
Integer	liRC,				&
			liFileNo,		&
			liTotalPrice,	&
			liTotalWeight, &
			liTotalQty, 	&  
			i				, 	&
			q

Long		llFindRow,		&
			llRowPos,		&
			llRowCount,		&
			llCarton,	&
			llCartonCount,	&
			llTotalWeight,	&
			llHeight,		&
			llWidth,			&
			llLentgh,		&
			llGirth,			&
			llNewROw, 		&
			llDetailFindRow
			
decimal{2}	ldTotalPrice,		&
				ldTotalWeight
				
date ldt_carrier_ship_date

Datastore	ldsDimensions			

//Export data to File - some data comes from Lookup Table (Code ID = 'UPS'), other from order info

/*See if there is  default Export file in the lookup table, otherwise prompt for file*/
llFindRow = adw_defaults.Find("Upper(Code_ID) = 'DFILENAME'",1,adw_defaults.RowCount())
If llFindRow > 0 Then
	lsPath = adw_defaults.GetITemString(llFindRow,'code_descript')
End If
if lspath > '' Then
Else /*Prompt for File*/
	liRC = GetFileSaveName('Save UPS File To:',lsPath, lsFile)
	If liRC < 1 Then REturn -1
End If

//Try and open the Export File
liFileNo = FileOpen(lsPath,LineMode!,Write!,LockReadWrite!,Replace!)
If liFileNo <= 0 Then
	Do While liFileNo <= 0
		Messagebox('UPS Export','Unable to Open/Create File: ' + lsPath + ' for export to UPS')
		liRC = GetFileSaveName('Save UPS File To:',lsPath, lsFile)
		If liRC < 1 Then REturn -1
		liFileNo = FileOpen(lsPath,LineMode!,Write!,LockReadWrite!,Append!)
	Loop
End If
				
iiTotalQty = adw_pack.Object.compute_2[1] /*Capture Total QTY in Packing List*/
llRowCount = adw_pack.RowCount()  /*Capture Total rows in Packing List*/

If adw_Defaults.AcceptText() < 0 Then return -1

// GET SHIP TO
If Not isnull(adw_main.GetItemString(1,'cust_name')) Then 		lsCustName = adw_main.GetItemString(1,'cust_name') 		
If Not isnull(adw_main.GetItemString(1,'contact_person')) Then lsContact=  adw_main.GetItemString(1,'contact_person') 		
If Not isnull(adw_main.GetItemString(1,'address_1')) Then		lsAddr1= adw_main.GetItemString(1,'address_1')  
If Not isnull(adw_main.GetItemString(1,'address_2')) Then		lsAddr2= adw_main.GetItemString(1,'address_2')  
If Not isnull(adw_main.GetItemString(1,'address_3')) Then		lsAddr3= adw_main.GetItemString(1,'address_3')  
If Not isnull(adw_main.GetItemString(1,'City')) Then				lsCity =  adw_main.GetItemString(1,'City') 
If Not isnull(adw_main.GetItemString(1,'State')) Then				lsState=  adw_main.GetItemString(1,'state')
If Not isnull(adw_main.GetItemString(1,'zip')) Then				lsZip = adw_main.GetItemString(1,'zip')	
If Not isnull(adw_main.GetItemString(1,'tel')) Then				lsPhone = adw_main.GetItemString(1,'tel')	
If Not isnull(adw_main.GetItemString(1,'Country')) Then			lsCountry = adw_main.GetItemString(1,'Country')	

// Get Country Name
Select DISTINCT Country_Name into :lsCountryName
FRom Country
Where ISO_Country_Cd = :lsCountry or Designating_Code = :lsCountry
Using SQLCA;
IF ISNULL(lsCountry) or lsCountry  = "" then 
	Messagebox('UPS Export','Unable to Find a valid Country Code for export to UPS')
	FileClose(liFileNo) //Close the File
	REturn -1
end if

i = 1 // GAP 10-03 set Rowcount/Carton Count
do while i <= llRowCount /*GAP 9/02  loop to print one label per Carton*/
 if lsCarton <> adw_pack.GetITemSTRING(i,'carton_no') then 
	 lsCarton = adw_pack.GetITemSTRING(i,'carton_no')
	 q = 0 // GAP 10-03 Total QTY
	 liTotalQty = 1 /*GAP 9/02  do NOT print multiple labels */
//	 liTotalQty = adw_pack.GetITemNumber(i,'quantity')  // GAP 11/02 get quantity for each row/item for multiple labels
  do until q = liTotalQty    /*GAP 11/02  loop to print labels as per QTY (GM_M ONLY)*/	
	//Find an Order Detail record that corresponds to this Packing row for Header level Information
	lsFind = "Upper(do_no) = '" + Upper(adw_pack.GetItemString(i,'do_no')) + "'"
	lsFind += " and Upper(sku) = '" + Upper(adw_pack.GetItemString(i,'sku')) + "'"
	//lsFind += " and Upper(supp_code) = '" + Upper(adw_pack.GetItemString(i,'supp_code')) + "'"
	lsFind += " and line_item_no = " + String(adw_pack.GetItemNumber(i,'line_Item_no'))
	llDetailFindRow = adw_Detail.Find(lsFind,1,adw_Detail.RowCount())

/*	
	// Service Code (C22) 
	lsLookup = '22' //Get from lookup Table
	llFindRow = adw_defaults.Find("Code_ID = '" + lsLookup + "'",1,adw_defaults.RowCount())
	If llFindRow > 0 Then
			lsRecData+= ',"' +  adw_defaults.GetITemString(llFindRow,'code_descript') + '"'
	Else
		lsRecData+= ',""'
		lsMissingFields += ", Service Code" /*we will let user know data is missing*/
	End If
	/* service type */
	lsRecData+= '1,"03"' 	// (2ND DAY)
	IF liTotalWeight >= 150 or llGirth > 165 then lsRecData+= '1274,"80"' /* (2ND DAY/FREIGHT)*/
	IF (liTotalWeight <= 150 and lllentgh <= 108  and llGirth <= 130) and ls_schCode = "GROUND" then 
			lsRecData+= ',"92"' /* (GROUND)*/
	end if 
*/
	//SHIP TO
		/*Customer Name (C35)*/
		lsRecData= '"' + lsCustName + space(35 - len(lsCustName))  + '"'  
		/*Contact/Attention Name (C35)*/		
		lsRecData+= ',"' + lsContact + space(35 - len(lsContact)) + '"' 
		/*Address 1 (C35)*/
		lsRecData+= ',"' + lsAddr1 + space(35 - len(lsAddr1)) + '"' 
		/*Address 2 (C35)*/
		lsRecData+= ',"' + lsAddr2 + space(35 - len(lsAddr2)) + '"' 
		/*Address 3 (C35)*/
		lsRecData+= ',"' + lsAddr3 + space(35 - len(lsAddr3)) + '"' 
		/*City (C30)*/
		lsRecData+= ',"' + lsCity + space(30 - len(lsCity)) + '"' 
		/*State (C5)*/
		lsRecData+= ',"' + lsState  + space(5 - len(lsState)) + '"' 
		/*Zip (C10)*/
		lsRecData+= ',"' + lsZip + space(10 - len(lsZip)) + '"' 
		/*Phone (C15)*/
		lsRecData+= ',"' +  lsPhone + space(15 - len(lsPhone)) + '"' 
		/*COUNTRY (C50)*/
		lsRecData+= ',"' +  lsCountryName + space(50 - len(lsCountryName)) + '"' 
	
	//Package Info	
		/*Merchandise Description (C35) UPS HAS ROOM FOR Description field */
		
		/* - GAP 6/2002   Package Weight (C5) */  
		liTotalWeight = adw_pack.GetItemNumber(i,'weight_gross')
		ldTotalWeight = adw_pack.GetItemNumber(i,'weight_gross')
		ldTotalWeight = ldTotalWeight - liTotalWeight
		if ldTotalWeight > 0 then liTotalWeight = liTotalWeight + 1
		if liTotalWeight < 1 then liTotalWeight = 1
		If isnull(liTotalWeight) Then liTotalWeight = 0
		lsRecData+= ',"' +  String(liTotalWeight,'00000') + '"'  	
		
		/* Make sure dimensions are in proper order (lengh > width > height) (C3) */
		ldsDimensions = Create DataStore
		ldsDimensions.dataobject = 'd_dimension_sort'
		llNewRow = ldsDimensions.InsertRow(0)
		If isnull(adw_pack.Object.length[i]) Then 
			ldsDimensions.SetItem(llNewRow,'dimension',0)
		else
			ldsDimensions.SetItem(llNewRow,'dimension',adw_pack.Object.length[i])	
		end if
		llNewRow = ldsDimensions.InsertRow(0)
		If isnull(adw_pack.Object.width[i]) Then 
			ldsDimensions.SetItem(llNewRow,'dimension',0)
		else
			ldsDimensions.SetItem(llNewRow,'dimension',adw_pack.Object.width[i])
		end if
		llNewRow = ldsDimensions.InsertRow(0)
		If isnull(adw_pack.Object.height[i]) Then 
			ldsDimensions.SetItem(llNewRow,'dimension',0)
		else
			ldsDimensions.SetItem(llNewRow,'dimension',adw_pack.Object.height[i])
		end if
		ldsDimensions.Sort()
		lllentgh = ldsDimensions.GetITemNumber(1,'dimension')
		llWidth = ldsDimensions.GetITemNumber(2,'dimension')
		llheight = ldsDimensions.GetITemNumber(3,'dimension')
		llGirth = llLentgh + (2*llHeight) + (2*llWidth)

	//	IF liTotalWeight >= 150 or llGirth > 165 then //FEDEX RULES - NEED TO GATHER UPS RULES BEFORE APPLYING LOGIC HERE 
			lsRecData+= ',"' +  String(llLentgh,'000') + '"' /* LENTGH*/
			lsRecData+= ',"' +  String(llWidth,'000') + '"'  /* WIDTH */
			lsRecData+= ',"' +  String(llHeight,'000') + '"' /* HEIGHT*/
	// end if
	
	//Reference 1-5 Info	(C35)
		//Reference 1 - DONO
		ls_reference = "DONO:" + Right(adw_main.GetITemString(1,'do_no'),7)
		lsRecData+= ',"' + ls_reference  + space(35 - len(ls_reference)) + '"'
		//Reference 2 - Sims Order Number
		ls_reference = "INVOICE#" + adw_main.GetItemString(1,'invoice_no') 
		lsRecData+= ',"' + ls_reference  + space(35 - len(ls_reference)) + '"'
		//Reference 3 - CUST ORDER NO
		If Not isnull(adw_main.GetItemString(1,'cust_order_no')) Then
			lsCustOrderNo = adw_main.GetItemString(1,'cust_order_no')
		End If
		ls_reference = "CUSTORD#" + lsCustOrderNo 
		lsRecData+= ',"' + ls_reference  + space(35 - len(ls_reference)) + '"'
		//Reference 4 - LINE ITEM | CARTON NO
		ls_reference = "LINE#" + string(adw_pack.GetItemNumber(i,'line_Item_no')) + " CRTN#" + string(adw_pack.GetITemString(i,'carton_no'))
		lsRecData+= ',"' + ls_reference  + space(35 - len(ls_reference)) + '"'
		//Reference 5 - SKU | QTY to aid Pickers 
		ls_reference = "SKU:" + adw_pack.GetItemString(i,'sku') + " QTY:" + string(adw_pack.GetItemNumber(i,'quantity'), '0')
		lsRecData+= ',"' + ls_reference  + space(35 - len(ls_reference)) + '"' 
		
/* FUTURE POSSIBILITIES .......
		/* (Actual) Carrier ship date -  em_carrier_ship_date - "YYYYMMDD"   */
		ldt_carrier_ship_date = date(w_do.tab_main.tabpage_carrier.em_carrier_ship_date.text)
		If Upper(Left(gs_project,4)) = 'GM_M'  Then  
			ls_shipyear = String ( Year (ldt_carrier_ship_date), '0000' )
			ls_shipmonth = String (Month (ldt_carrier_ship_date), '00' )
			ls_shipday = String (Day (ldt_carrier_ship_date), '00' )
			lsRecData+= ',"' +  ls_shipyear +  ls_shipmonth + ls_shipday + '"'
		end if
		
		/* Carton Count - take from computed field on Pack*/
		If Not isnull(adw_pack.Object.c_Carton_count[1]) Then
			llCartonCount= adw_pack.Object.c_Carton_count[1]
		Else
			llCartonCount = 0
		End If
		
		/* Payor Account NUmber - Get from lookup table - Based on Ship To Country */
		lsLookup = '20-'
		If Not isnull(lsCountry) Then
			lsLookup += Left(lsCountry,2)
		End If
		llFindRow = adw_defaults.Find("Code_ID = '" + lsLookup + "'",1,adw_defaults.RowCount())
		If llFindRow > 0 Then
			lsRecData+= ',"' +  adw_defaults.GetITemString(llFindRow,'code_descript') + '"'
		Else
			lsRecData+= ',""'
			lsMissingFields += ",Payor Account NUmber " /*we will let user know data is missing*/
		End If

		/* Payment Code - Get from lookup Table*/
		lsLookup = '23'
		llFindRow = adw_defaults.Find("Code_ID = '" + lsLookup + "'",1,adw_defaults.RowCount())
		If llFindRow > 0 Then
			lsRecData+= ',"' +  adw_defaults.GetITemString(llFindRow,'code_descript') + '"'
		Else
			lsRecData+= ',""'
			lsMissingFields += ", Payment Code" /*we will let user know data is missing*/
		End If

		/* Declared value*/
		If Not isnull(adw_detail.GetITemDecimal(llDetailFindRow,'Price')) then 
			ldTotalPrice = adw_detail.GetITemDecimal(llDetailFindRow,'Price')
		else 
			ldTotalPrice = 0
		end if
		if ldTotalPrice < 1 then ldTotalPrice = 1
		liTotalPrice = ldTotalPrice
		lsRecData+= ',"' + String(liTotalPrice,'#000') + '"'

		/* Currency - Get from lookup Table*/
		lsLookup = '68'
		llFindRow = adw_defaults.Find("Code_ID = '" + lsLookup + "'",1,adw_defaults.RowCount())
		If llFindRow > 0 Then
			lsRecData+= '68,"' +  adw_defaults.GetITemString(llFindRow,'code_descript') + '"'
		Else
			lsRecData+= '68,""'
			lsMissingFields += ", Currency " /*we will let user know data is missing*/
		End If

		/* Duty Tax - Get from lookup Table*/
		lsLookup = '70'
		llFindRow = adw_defaults.Find("Code_ID = '" + lsLookup + "'",1,adw_defaults.RowCount())
		If llFindRow > 0 Then
			lsRecData+= '70,"' +  adw_defaults.GetITemString(llFindRow,'code_descript') + '"'
		Else
			lsRecData+= '70,""'
			lsMissingFields += ", Duty Tax" /*we will let user know data is missing*/
		End If

		/* Duty Tax Account - Get from lookup table - Based on Ship To Country*/
		lsLookup = '71-'
		If Not isnull(lsCountry) Then
			lsLookup += Left(lsCountry,2)
		End If
		llFindRow = adw_defaults.Find("Code_ID = '" + lsLookup + "'",1,adw_defaults.RowCount())
		If llFindRow > 0 Then
			lsRecData+= '71,"' +  adw_defaults.GetITemString(llFindRow,'code_descript') + '"'
		Else
			lsRecData+= '71,""'
			lsMissingFields += ", Duty Tax Account" /*we will let user know data is missing*/
		End If

		/* Terms of Sale - Get from lookup Table*/
		lsLookup = '72'
		llFindRow = adw_defaults.Find("Code_ID = '" + lsLookup + "'",1,adw_defaults.RowCount())
		If llFindRow > 0 Then
			lsRecData+= '72,"' +  adw_defaults.GetITemString(llFindRow,'code_descript') + '"'
		Else
			lsRecData+= '72,""'
			lsMissingFields += ", Terms of Sale" /*we will let user know data is missing*/
		End If
	
		/* Weight Type - Get from lookup Table*/
		lsLookup = '75'
		llFindRow = adw_defaults.Find("Code_ID = '" + lsLookup + "'",1,adw_defaults.RowCount())
		If llFindRow > 0 Then
			lsRecData+= '75,"' +  adw_defaults.GetITemString(llFindRow,'code_descript') + '"'
		Else
			lsRecData+= '75,""'
			lsMissingFields += ", Weight Type" /*we will let user know data is missing*/
		End If
	
		/* Package Desc 1 - Get from lookup Table*/
		lsLookup = '79'
		llFindRow = adw_defaults.Find("Code_ID = '" + lsLookup + "'",1,adw_defaults.RowCount())
		If llFindRow > 0 Then
			lsRecData+= '79,"' +  adw_defaults.GetITemString(llFindRow,'code_descript') + '"'
		Else
			lsRecData+= '79,""'
			lsMissingFields += ", Package Desc 1" /*we will let user know data is missing*/
		End If

		/* Country of Manufacture - Get from lookup Table*/
		lsLookup = '80'
		llFindRow = adw_defaults.Find("Code_ID = '" + lsLookup + "'",1,adw_defaults.RowCount())
		If llFindRow > 0 Then
			lsRecData+= '80,"' +  adw_defaults.GetITemString(llFindRow,'code_descript') + '"'
		Else
			lsRecData+= '80,""'
			lsMissingFields += ", ountry of Manufacture" /*we will let user know data is missing*/
		End If

		/* Satillo defaults*/
		lsRecData+= ',"US"' 	/* Shipper Country*/
		lsRecData+= ',"01"' 	/* Customer packaging*/
		ls_schCode = adw_main.GetITemString(1,'user_field1')
			CHOOSE CASE adw_main.GetITemString(1,'user_field1')
		 	CASE "B", "E/TRK", "F", "L", "N" , "Q" 	/*FEDEX GROUND*/
				ls_schCode = "GROUND"
		 	CASE "V", "V/OVN", "V/TRK", "V/AFR"			/*FEDEX 2ND DAY AIR*/
			END CHOOSE
*/
	//If any required fields are missing, warn and get out
	If lsMissingFields > '' Then
		lsMissingFields = Right(lsMissingFields,(Len(lsMissingFields) - 1)) /*strip off first comma*/
		MessageBox(lsPath,'The following fields were not not set from default values ~rand MUST be entered before sending this file:~r~r' + lsMissingFields)
		Return -1
	End If

	//Write the rows to the file
		liRC = FileWrite(liFileNo,lsRecData)
		If liRC < 0 Then
			MessageBox('UPS Export','Unable to write to UPS File. File was not exported.')
			Return -1
		End If
	q ++
  loop
 end if
 i ++ // GAP 10-03 Rowcount
loop

//Close the File
liRC = FileClose(liFileNo)
If liRC < 0 Then
	messagebox('UPS Export',"Unable to Close File: " + lsPath + ". ~r~rFile Not exported!")
	Return -1
End If

Messagebox('UPS Export','Order successfully exported to:~r' + lsPath)
Return 0


end function

public function integer uf_export_to_ups_batch (ref datawindow adw_detail, ref datawindow adw_pack, integer alpackrow);//Export order info to UPS Worldship - From Batch Picking (Exporting a Single Pack Row at a time)
   
String	lsFile,	&
			lsPath,	&
			lsRecData,	&
			lsLookup,	&
			lsMissingFields,	& 
			lsCustName,	&
			lsCustCode,	&
			lsContact,	&
			lsPhone,		&
			lsAddr1,		&
			lsAddr2,		&
			lsAddr3, 	&
			lsCity,		&
			lsState,		&
			lsZip,		&
			lsCountry,	&
			lsCountryName, &
			lsFind, 		&
			lsCustOrderNo, &
			ls_reference, &
			ls_shipyear, &
			ls_shipmonth, &
			ls_shipday , &
			ls_schCode
			
Integer	liRC,	&
			liTotalPrice, &
			liTotalWeight

Long		llFindRow,	&
			llRowPos,	&
			llDetailFindRow,	&
			llHeight,	&
			llWidth,		&
			llLentgh,	&
			llGirth,		&
			llNewROw

decimal{2}	ldTotalPrice, &
				ldTotalWeight
date ldt_carrier_ship_date

Datastore	ldsDimensions

SetPointer(Hourglass!)

// gap 09/2002 - capture the carrier ship date
ldt_carrier_ship_date = date(w_batch_pick.tab_main.tabpage_pack.em_carrier_ship_date.text)

//If the Current Row passed in is 0, we only want to close the file
If alPackRow = 0 Then
	if iiFileNo > 0 Then
		liRC = FileClose(iiFileNo)
		If liRC > 0 Then
			Messagebox('UPS','Records successfully written to UPS Export File.')
		Else
			Messagebox('UPS','Unable to write records to UPS Export File.')
		End If
	End If
	
	Return 0
	
End If

//If the UPS Defaults Datastore hasn't already been created, create and retrieve
If not isvalid(idsDefaults) Then
	idsDefaults = Create Datastore
	idsDefaults.Dataobject = 'd_carrier_default_UPS'
	idsDefaults.SetTransObject(SQLCA)
	idsDefaults.Retrieve(gs_project)
End If

If idsDefaults.RowCount() < 0 Then Return -1

//Find an Order Detail record that corresponds to this Packing row for Header level Information
lsFind = "Upper(do_no) = '" + Upper(adw_pack.GetItemString(alPackRow,'do_no')) + "'"
lsFind += " and Upper(sku) = '" + Upper(adw_pack.GetItemString(alPackRow,'sku')) + "'"
//lsFind += " and Upper(supp_code) = '" + Upper(adw_pack.GetItemString(alPackRow,'supp_code')) + "'"
lsFind += " and line_item_no = " + String(adw_pack.GetItemNumber(alPackRow,'line_Item_no'))

iiTotalQty = adw_pack.GetItemNumber(alPackRow,'compute_4') /*Capture Sum of QTY per Order*/
llDetailFindRow = adw_Detail.Find(lsFind,1,adw_Detail.RowCount())
If lLDetailFindRow <= 0 Then Return -1 /*should never happen*/

// GET SHIP TO
If Not isnull(adw_detail.GetITemString(llDetailFindRow,'cust_name')) 		Then 	lsCustName = adw_detail.GetITemString(llDetailFindRow,'cust_name')		
If Not isnull(adw_detail.GetITemString(llDetailFindRow,'contact_person')) 	Then 	lsContact=  adw_detail.GetITemString(llDetailFindRow,'contact_person')		
If Not isnull(adw_detail.GetITemString(llDetailFindRow,'address_1')) 		Then	lsAddr1= adw_detail.GetITemString(llDetailFindRow,'address_1') 
If Not isnull(adw_detail.GetITemString(llDetailFindRow,'address_2')) 		Then	lsAddr2= adw_detail.GetITemString(llDetailFindRow,'address_2')  
If Not isnull(adw_detail.GetITemString(llDetailFindRow,'address_3')) 		Then	lsAddr3= adw_detail.GetITemString(llDetailFindRow,'address_3') 
If Not isnull(adw_detail.GetITemString(llDetailFindRow,'City')) 				Then	lsCity =  adw_detail.GetITemString(llDetailFindRow,'City') 
If Not isnull(adw_detail.GetITemString(llDetailFindRow,'state')) 				Then	lsState=  adw_detail.GetITemString(llDetailFindRow,'state')
If Not isnull(adw_detail.GetITemString(llDetailFindRow,'zip')) 				Then	lsZip = adw_detail.GetITemString(llDetailFindRow,'zip')	
If Not isnull(adw_detail.GetITemString(llDetailFindRow,'tel')) 				Then	lsPhone = adw_detail.GetITemString(llDetailFindRow,'tel')	
If Not isnull(adw_detail.GetITemString(llDetailFindRow,'Country')) 			Then	lsCountry = adw_detail.GetITemString(llDetailFindRow,'Country')	

// Get Country Name
Select DISTINCT Country_Name into :lsCountryName
FRom Country
Where ISO_Country_Cd = :lsCountry or Designating_Code = :lsCountry
Using SQLCA;
IF ISNULL(lsCountry) or lsCountry  = "" then 
	ls_reference = "Unable to Find a valid Country Code for Packing Row: " + string(alPackRow)
	Messagebox('UPS Export',ls_reference,exclamation!)
	FileClose(iiFileNo) //Close the File
	REturn -1
end if

/* w_do
i = 1 // GAP 10-03 set Rowcount/Carton Count
do while i <= llRowCount /*GAP 9/02  loop to print one label per Carton*/
 if lsCarton <> adw_pack.GetITemSTRING(i,'carton_no') then 
	 lsCarton = adw_pack.GetITemSTRING(i,'carton_no')
	 q = 0 // GAP 10-03 Total QTY
	 liTotalQty = 1 /*GAP 9/02  do NOT print multiple labels */
//	 liTotalQty = adw_pack.GetITemNumber(i,'quantity')  // GAP 11/02 get quantity for each row/item for multiple labels
  do until q = liTotalQty    /*GAP 11/02  loop to print labels as per QTY (GM_M ONLY)*/	
	//Find an Order Detail record that corresponds to this Packing row for Header level Information
	lsFind = "Upper(do_no) = '" + Upper(adw_pack.GetItemString(i,'do_no')) + "'"
	lsFind += " and Upper(sku) = '" + Upper(adw_pack.GetItemString(i,'sku')) + "'"
	//lsFind += " and Upper(supp_code) = '" + Upper(adw_pack.GetItemString(i,'supp_code')) + "'"
	lsFind += " and line_item_no = " + String(adw_pack.GetItemNumber(i,'line_Item_no'))
	llDetailFindRow = adw_Detail.Find(lsFind,1,adw_Detail.RowCount())
*/
/*	
	// Service Code (C22) 
	lsLookup = '22' //Get from lookup Table
	llFindRow = adw_defaults.Find("Code_ID = '" + lsLookup + "'",1,adw_defaults.RowCount())
	If llFindRow > 0 Then
			lsRecData+= ',"' +  adw_defaults.GetITemString(llFindRow,'code_descript') + '"'
	Else
		lsRecData+= ',""'
		lsMissingFields += ", Service Code" /*we will let user know data is missing*/
	End If
	/* service type */
	lsRecData+= '1,"03"' 	// (2ND DAY)
	IF liTotalWeight >= 150 or llGirth > 165 then lsRecData+= '1274,"80"' /* (2ND DAY/FREIGHT)*/
	IF (liTotalWeight <= 150 and lllentgh <= 108  and llGirth <= 130) and ls_schCode = "GROUND" then 
			lsRecData+= ',"92"' /* (GROUND)*/
	end if 
*/
	//SHIP TO
		/*Customer Name (C35)*/
		lsRecData= '"' + lsCustName + space(35 - len(lsCustName))  + '"'  
		/*Contact/Attention Name (C35)*/		
		lsRecData+= ',"' + lsContact + space(35 - len(lsContact)) + '"' 
		/*Address 1 (C35)*/
		lsRecData+= ',"' + lsAddr1 + space(35 - len(lsAddr1)) + '"' 
		/*Address 2 (C35)*/
		lsRecData+= ',"' + lsAddr2 + space(35 - len(lsAddr2)) + '"' 
		/*Address 3 (C35)*/
		lsRecData+= ',"' + lsAddr3 + space(35 - len(lsAddr3)) + '"' 
		/*City (C30)*/
		lsRecData+= ',"' + lsCity + space(30 - len(lsCity)) + '"' 
		/*State (C5)*/
		lsRecData+= ',"' + lsState  + space(5 - len(lsState)) + '"' 
		/*Zip (C10)*/
		lsRecData+= ',"' + lsZip + space(10 - len(lsZip)) + '"' 
		/*Phone (C15)*/
		lsRecData+= ',"' +  lsPhone + space(15 - len(lsPhone)) + '"' 
		/*COUNTRY (C50)*/
		lsRecData+= ',"' +  lsCountryName + space(50 - len(lsCountryName)) + '"' 
	
	//Package Info	
		/*Merchandise Description (C35) UPS HAS ROOM FOR Description field */
		
		/* - GAP 6/2002   Package Weight (C5) */  
		liTotalWeight = adw_pack.getItemNumber(alPackRow,'weight_gross') // integer value
		ldTotalWeight = adw_pack.getItemNumber(alPackRow,'weight_gross') // decimal value
		ldTotalWeight = ldTotalWeight - liTotalWeight
		if ldTotalWeight > 0 then liTotalWeight = liTotalWeight + 1
		if liTotalWeight < 1 then liTotalWeight = 1
		If isnull(liTotalWeight) Then liTotalWeight = 0
		lsRecData+= ',"' +  String(liTotalWeight,'00000') + '"'  	
		
		/* Make sure dimensions are in proper order (lengh > width > height) (C3) */
		ldsDimensions = Create DataStore
		ldsDimensions.dataobject = 'd_dimension_sort'
		llNewRow = ldsDimensions.InsertRow(0)
		If isnull(adw_pack.getItemNumber(alPackRow,'length')) Then 
			ldsDimensions.SetItem(llNewRow,'dimension',0)
		else
			ldsDimensions.SetItem(llNewRow,'dimension',adw_pack.getItemNumber(alPackRow,'length'))	
		end if
		llNewRow = ldsDimensions.InsertRow(0)
		If isnull(adw_pack.getItemNumber(alPackRow,'width')) Then 
			ldsDimensions.SetItem(llNewRow,'dimension',0)
		else
			ldsDimensions.SetItem(llNewRow,'dimension',adw_pack.getItemNumber(alPackRow,'width'))
		end if
		llNewRow = ldsDimensions.InsertRow(0)
		If isnull(adw_pack.getItemNumber(alPackRow,'height')) Then 
			ldsDimensions.SetItem(llNewRow,'dimension',0)
		else
			ldsDimensions.SetItem(llNewRow,'dimension',adw_pack.getItemNumber(alPackRow,'height'))
		end if
		ldsDimensions.Sort()
		lllentgh = ldsDimensions.GetITemNumber(1,'dimension')
		llWidth = ldsDimensions.GetITemNumber(2,'dimension')
		llheight = ldsDimensions.GetITemNumber(3,'dimension')
		llGirth = llLentgh + (2*llHeight) + (2*llWidth)

	//	IF liTotalWeight >= 150 or llGirth > 165 then //UPS RULES - NEED TO GATHER UPS RULES BEFORE APPLYING LOGIC HERE 
			lsRecData+= ',"' +  String(llLentgh,'000') + '"' /* LENTGH*/
			lsRecData+= ',"' +  String(llWidth,'000') + '"'  /* WIDTH */
			lsRecData+= ',"' +  String(llHeight,'000') + '"' /* HEIGHT*/
	// end if
	
	//Reference 1-5 Info	(C35)
		//Reference 1 - DONO
		ls_reference = "DONO:" + right(adw_detail.GetITemString(llDetailFindRow,'do_no'),7)
		lsRecData+= ',"' + ls_reference  + space(35 - len(ls_reference)) + '"'
		//Reference 2 - Sims Order Number
		ls_reference = "INVOICE#" + adw_detail.GetITemString(llDetailFindRow,'invoice_no')
		lsRecData+= ',"' + ls_reference  + space(35 - len(ls_reference)) + '"'
		//Reference 3 - CUST ORDER NO
		If Not isnull(adw_detail.GetITemString(llDetailFindRow,'cust_order_no')) Then
			lsCustOrderNo = adw_detail.GetITemString(llDetailFindRow,'cust_order_no')
		End If
		ls_reference = "CUSTORD#" + lsCustOrderNo 
		lsRecData+= ',"' + ls_reference  + space(35 - len(ls_reference)) + '"'
		//Reference 4 - LINE ITEM | CARTON NO
		ls_reference = "LINE#" + string(adw_pack.GetItemNumber(alPackRow,'line_Item_no')) + " CRTN#" + string(adw_pack.GetITemString(alPackRow,'carton_no'))
		lsRecData+= ',"' + ls_reference  + space(35 - len(ls_reference)) + '"'
		//Reference 5 - SKU | QTY to aid Pickers  
		ls_reference = "SKU:" + adw_detail.GetITemString(llDetailFindRow,'sku')  + " QTY:" + string(adw_pack.GetItemNumber(alPackRow,'quantity'), '0')
		lsRecData+= ',"' + ls_reference  + space(35 - len(ls_reference)) + '"' 

		
/* FUTURE POSSIBILITIES .......

/*  Destination Business Code - (USer Field 6)*/
If Upper(gs_project) = 'GM_HAHN' Then
	If Not isnull(adw_detail.GetITemString(llDetailFindRow,'user_field6')) Then
		lsRecData = adw_detail.GetITemString(llDetailFindRow,'user_field6') 
	Else
		lsRecData  =  
	End If
End If

/*  Payor Account NUmber - Get from lookup table - Based on Ship To Country*/
If upper(gs_project) = 'GM_HAHN' Then 
	lsLookup = '20-'
	If Not isnull(lsCountry) Then
	lsLookup += Left(lsCountry,2)
	End If
	llFindRow = idsDefaults.Find("Code_ID = '" + lsLookup + "'",1,idsDefaults.RowCount())
	If llFindRow > 0 Then
	lsRecData = ' +  idsDefaults.GetITemString(llFindRow,'code_descript') + '"'
	Else
	lsMissingFields += ", Payor Account" /*we will let user know data is missing*/
	End If
end if


/* Field 22 - Service Code - Get from lookup Table*/
If upper(gs_project) = 'GM_HAHN' Then 
	lsLookup = '22'
	llFindRow = idsDefaults.Find("Code_ID = '" + lsLookup + "'",1,idsDefaults.RowCount())
	If llFindRow > 0 Then
		lsRecData = '22,"' +  idsDefaults.GetITemString(llFindRow,'code_descript') + '"'
	Else
		lsRecData = '22,""' 
		lsMissingFields += ", Service Code" /*we will let user know data is missing*/
	End If
End if

/* Field 23 - Payment Code - Get from lookup Table*/
lsLookup = '23'
llFindRow = idsDefaults.Find("Code_ID = '" + lsLookup + "'",1,idsDefaults.RowCount())
If llFindRow > 0 Then
	lsRecData = '23,"' +  idsDefaults.GetITemString(llFindRow,'code_descript') + '"'
Else
	lsRecData = '23,""'
	lsMissingFields += ", Payment Code" /*we will let user know data is missing*/
End If

/*Field 24 - (Actual) Carrier ship date -  em_carrier_ship_date - "YYYYMMDD"   */
ls_shipyear = String ( Year (ldt_carrier_ship_date), '0000' )
ls_shipmonth = String (Month (ldt_carrier_ship_date), '00' )
ls_shipday = String (Day (ldt_carrier_ship_date), '00' )
lsRecData = '24,"' +  ls_shipyear +  ls_shipmonth + ls_shipday + '"'

/* - GAP 7/2002   26 - Declared value*/
If Not isnull(adw_detail.GetITemDecimal(llDetailFindRow,'Price')) then 
			ldTotalPrice = adw_detail.GetITemDecimal(llDetailFindRow,'Price')
	else 
			ldTotalPrice = 0
end if
	if ldTotalPrice < 1 then ldTotalPrice = 1
	liTotalPrice = ldTotalPrice
	lsRecData = '26,"' + String(liTotalPrice,'#000') + '"'
end if

/*Field 50 - Country*/
lsRecData = '50,"'
If Not isnull(lsCountry) Then
	lsRecData += Left(lsCountry,2) + '"'
Else
	lsRecData += '"'
	lsMissingFields += ", Country" /*we will let user know data is missing*/ 
End If

/* Field 68 - Currency - Get from lookup Table*/
	lsLookup = '68'
	llFindRow = idsDefaults.Find("Code_ID = '" + lsLookup + "'",1,idsDefaults.RowCount())
	If llFindRow > 0 Then
		lsRecData = '68,"' +  idsDefaults.GetITemString(llFindRow,'code_descript') + '"'
	Else
		lsRecData = '68,""'
		lsMissingFields += ", Currency" /*we will let user know data is missing*/
	End If

/* Field 70 - Duty Tax - Get from lookup Table*/
	lsLookup = '70'
	llFindRow = idsDefaults.Find("Code_ID = '" + lsLookup + "'",1,idsDefaults.RowCount())
	If llFindRow > 0 Then
		lsRecData = '70,"' +  idsDefaults.GetITemString(llFindRow,'code_descript') + '"'
	Else
		lsRecData = '70,""'
		lsMissingFields += ", Duty Tax" /*we will let user know data is missing*/
	End If

/* Field 71 - Duty Tax Account - Get from lookup table - Based on Ship To Country*/
	lsLookup = '71-'
	If Not isnull(lsCountry) Then
		lsLookup += Left(lsCountry,2)
	End If
	llFindRow = idsDefaults.Find("Code_ID = '" + lsLookup + "'",1,idsDefaults.RowCount())
	If llFindRow > 0 Then
		lsRecData = '71,"' +  idsDefaults.GetITemString(llFindRow,'code_descript') + '"'
	Else
		lsRecData = '71,""'
		lsMissingFields += ", Duty Tax Account" /*we will let user know data is missing*/
	End If

/* Field 72 - Terms of Sale - Get from lookup Table*/
	lsLookup = '72'
	llFindRow = idsDefaults.Find("Code_ID = '" + lsLookup + "'",1,idsDefaults.RowCount())
	If llFindRow > 0 Then
		lsRecData = '72,"' +  idsDefaults.GetITemString(llFindRow,'code_descript') + '"'
	Else
		lsRecData = '72,""'
		lsMissingFields += ", Terms of Sale" /*we will let user know data is missing*/
	End If

/* Field 75 - Weight Type - Get from lookup Table*/
	lsLookup = '75'
	llFindRow = idsDefaults.Find("Code_ID = '" + lsLookup + "'",1,idsDefaults.RowCount())
	If llFindRow > 0 Then
		lsRecData = '75,"' +  idsDefaults.GetITemString(llFindRow,'code_descript') + '"'
	Else
		lsRecData = '75,""'
		lsMissingFields += ", Weight Type" /*we will let user know data is missing*/
	End If

/* Field 79 - Package Desc 1 - Get from lookup Table*/
	lsLookup = '79'
	llFindRow = idsDefaults.Find("Code_ID = '" + lsLookup + "'",1,idsDefaults.RowCount())
	If llFindRow > 0 Then
		lsRecData = '79,"' +  idsDefaults.GetITemString(llFindRow,'code_descript') + '"'
	Else
		lsRecData = '79,""'
		lsMissingFields += ", Package Desc 1" /*we will let user know data is missing*/
	End If

/* Field 80 - Country of Manufacture - Get from lookup Table*/
	lsLookup = '80'
	llFindRow = idsDefaults.Find("Code_ID = '" + lsLookup + "'",1,idsDefaults.RowCount())
	If llFindRow > 0 Then
		lsRecData = '80,"' +  idsDefaults.GetITemString(llFindRow,'code_descript') + '"'
	Else
		lsRecData = '80,""'
		lsMissingFields += ", Country of Manufacture" /*we will let user know data is missing*/
	End If

/*Field 112 - Weight - Take Net weight - we will create a label for 'EACH' */
	If Not isnull(adw_pack.getItemNumber(alPackRow,'weight_net')) Then
		lsRecData = '112,"' +  String(adw_pack.getItemNumber(alPackRow,'weight_net'),'#####.00') + '"' 
	Else
		lsRecData = '112,""'
	End If

End if

/*Field 116 - package Count - will always be 1 (we are printing a label for EACH unit)*/
lsRecData = '116,"1"'

/* - GAP 6/2002   Satillo defaults*/
If Upper(Left(gs_project,4)) = 'GM_M'  Then  
	llArrayPos ++
	lsRecData = '117,"US"' 		/* 117 - Shipper Country*/
	llArrayPos ++
	lsRecData = '1273,"01"' 	/* 1273 - Customer packaging*/
	llArrayPos ++
	ls_schCode = adw_detail.GetITemString(llDetailFindRow,'user_field1')
			CHOOSE CASE adw_detail.GetITemString(llDetailFindRow,'user_field1')
		 	CASE "B", "E/TRK", "F", "L", "N" , "Q" 	/*UPS GROUND*/
				ls_schCode = "GROUND"
//		 	CASE "V", "V/OVN", "V/TRK", "V/AFR"			/*UPS 2ND DAY AIR*/
			END CHOOSE
	lsRecData = '1274,"03"' 	/* 1274 - service type (2ND DAY)*/
	IF liTotalWeight > 150 or llGirth > 165 then lsRecData = '1274,"80"' /* (2ND DAY/FREIGHT)*/
	IF (liTotalWeight <= 150 and lllentgh <= 108  and llGirth <= 130) and ls_schCode = "GROUND" then 
		lsRecData = '1274,"92"' /* (GROUND)*/
		llArrayPos ++  								/* 3002 - display Sims Order Number in pop up window Field*/
		lsRecData = '3002,"' +  adw_detail.GetITemString(llDetailFindRow,'invoice_no') + '"' 
		llArrayPos ++  								/* 3002 - display Reference Notes in pop up window Field*/
		lsRecData = '3003,"' + ls_reference		
	end if
	llArrayPos ++  								/* 2132 - display Sims Order Number on PCKG CNT 1 Field*/
	lsRecData = '2132,"' +  adw_detail.GetITemString(llDetailFindRow,'invoice_no') + '"' 
	llArrayPos ++
	lsRecData = '99,""' 			/* - 99 - End of transaction*/
end if
*/

If iiFileNo <=0 or isnull(iiFileNo) Then /*if file number is > 0 then the file is already open from a previous call here - will close when done*/

	//See if there is  default file in the lookup table, otherwise prompt for file
	llFindRow = idsDefaults.Find("Upper(Code_ID) = 'DFILENAME'",1,idsDefaults.RowCount())
	If llFindRow > 0 Then
		lsPath = idsDefaults.GetITemString(llFindRow,'code_descript')
	End If

	If lspath > '' Then
	Else /*Prompt for File*/
		liRC = GetFileSaveName('Save UPS File To:',lsPath, lsFile)
		If liRC < 1 Then REturn -1
	End If

	//Try and open the File 
	iiFileNo = FileOpen(lsPath,LineMode!,Write!,LockReadWrite!,Replace!)

	If iiFileNo <= 0 Then
		Do While iiFileNo <= 0
			Messagebox('UPS Export','Unable to Open/Create File: ' + lsPath + ' for export to UPS')
			liRC = GetFileSaveName('Save UPS File To:',lsPath, lsFile)
			If liRC < 1 Then REturn -1
			iiFileNo = FileOpen(lsPath,LineMode!,Write!,LockReadWrite!,Append!)
		Loop
	End If
	
End If /*File not already Opened*/

//Write the rows to the file
liRC = FileWrite(iiFileNo,lsRecData)
If liRC < 0 Then
		MessageBox('UPS Export','Unable to write to UPS File. File was not exported.')
		Return -1
End If

Return 0
end function

public function integer uf_stock_adjustment (ref datawindow adw_adjustment);
//Process a Good Issue confirmation Transaction for the proper project
Integer	liRC
//u_nvo_edi_confirmations_Nortel	lu_nvo_Nortel
//u_nvo_edi_confirmations_3com_Nash	lu_nvo_3comNAsh

//Choose Case Upper(gs_project)
//		
//	Case 'NORTEL'
//		
//		lu_nvo_Nortel = Create u_nvo_edi_confirmations_Nortel
//		liRC = lu_nvo_Nortel.uf_nortel_mm(adw_adjustment)
//		
//	Case '3COM_NASH' /* 09/03 - PCONKL */
//		
//		lu_nvo_3comNAsh = Create u_nvo_edi_confirmations_3com_Nash
//		liRC = lu_nvo_3comNAsh.uf_adjustment_MM(adw_adjustment)
//		
//End Choose


Return 0

end function

public function integer uf_goods_receipt_confirmation (ref datawindow adw_main, ref datawindow adw_detail, ref datawindow adw_putaway);//Process a Good Receipts Transaction for the proper project
Integer	liRC
//u_nvo_edi_confirmations_Nortel		lu_nvo_Nortel
//u_nvo_edi_confirmations_leroysomer	lu_nvo_leroysomer
//u_nvo_edi_confirmations_dellkorea	lu_nvo_dellkorea
//u_nvo_edi_confirmations_Pulse			lu_nvo_Pulse
//u_nvo_edi_confirmations_3com_nash	lu_nvo_3com
//u_nvo_edi_confirmations_KNFilters	lu_nvo_KNFilters
//u_nvo_edi_confirmations_Phoenix		lu_nvo_Phoenix

Choose Case Upper(gs_project)
		
//	Case 'NORTEL'
//		
//		lu_nvo_nortel = Create u_nvo_edi_confirmations_Nortel
//		//Either process as a normal order or a return order (return from Customer)
//		If adw_main.GetItemString(1,'ord_type') = 'X' Then /* a return*/
//			liRC = lu_nvo_Nortel.uf_nortel_rt(adw_main, adw_detail)
//		Else
//			liRC = lu_nvo_Nortel.uf_nortel_gr(adw_main, adw_detail, adw_putaway)
//		End If
		
//	Case 'LEROYSOMER'
//		
//		lu_nvo_leroysomer = Create u_nvo_edi_confirmations_leroysomer
//		//Either process as a normal order or a return order (return from Customer)
//		If adw_main.GetItemString(1,'ord_type') = 'X' Then /* a return*/
//			
//		Else
//			liRC = lu_nvo_leroysomer.uf_goods_receipt(adw_main,adw_putaway)
//		End If
		
	Case 'DELLKOREA'
		
//		lu_nvo_dellkorea = Create u_nvo_edi_confirmations_dellKorea
//		liRC = lu_nvo_dellkorea.uf_goods_receipt(adw_main,adw_putaway)
		
	Case 'PULSE'
		
//		lu_nvo_Pulse = Create u_nvo_edi_confirmations_Pulse
//		liRC = lu_nvo_Pulse.uf_gls_po_mr(adw_main, adw_detail, adw_putaway) /*PO MR back to GLS */
		
//	Case '3COM_NASH'
//		
//		lu_nvo_3com = Create u_nvo_edi_confirmations_3com_NAsh
//		//Either process as a normal order or a return order (return from Customer)
//		If adw_main.GetItemString(1,'ord_type') = 'X' Then /* a return*/
//			liRC = lu_nvo_3com.uf_process_goods_return(adw_main,adw_putaway)
//		Else
//			liRC = lu_nvo_3com.uf_goods_receipt(adw_main,adw_putaway)
//		End If

End Choose


Return 0

end function

public function integer uf_workorder_confirmation (ref datawindow adw_main, ref datawindow adw_detail, ref datawindow adw_pick);// we may need to send a transaction when the workorder is confirmed
Integer	liRC

//u_nvo_edi_confirmations_3com_Nash	lu_nvo_3com_nash

//Choose Case Upper(gs_project)
//									
//	Case '3COM_NASH'
//		
//		lu_nvo_3com_nash = Create u_nvo_edi_confirmations_3com_Nash
//		liRC = lu_nvo_3com_nash.uf_owner_change_workorder(adw_main, adw_pick)
//		
//End Choose


Return 0

end function

public function integer uf_edm (ref window aw_do, ref datawindow adw_main, ref datawindow adw_detail, ref datawindow adw_pack);Integer	liRC

//u_nvo_edi_confirmations_Nortel	lu_nvo_Nortel

//process EDM (export Document) collaboration for the proper project

Choose Case Upper(gs_project)
		
	Case 'NORTEL'
		
//		lu_nvo_Nortel = Create u_nvo_edi_confirmations_Nortel
//		liRC = lu_nvo_Nortel.uf_nortel_edm(aw_do,adw_main,adw_detail,adw_pack)
		
End CHoose

//Remove any applied filter and resort
adw_pack.Setfilter('')
adw_pack.Filter()
adw_pack.Sort()
adw_pack.GroupCalc()

Return liRC
end function

public function integer uf_goods_issue_confirmation (ref datawindow adw_main, ref datawindow adw_detail, ref datawindow adw_pick, ref datawindow adw_pack);
//Process a Good Issue confirmation Transaction for the proper project
Integer	liRC
//u_nvo_edi_confirmations_Nortel		lu_nvo_Nortel
//u_nvo_edi_confirmations_leroysomer	lu_nvo_leroysomer
//u_nvo_edi_confirmations_dellkorea	lu_nvo_dellkorea
//u_nvo_edi_confirmations_valeod		lu_nvo_valeod
//u_nvo_edi_confirmations_3com_Nash	lu_nvo_3com_nash
//u_nvo_edi_confirmations_Ambit			lu_nvo_Ambit
//dts u_nvo_edi_confirmations_hillman		lu_nvo_Hillman
//u_nvo_edi_confirmations_KNFilters	lu_nvo_KNFilters

Choose Case Upper(gs_project)
		
	Case 'NORTEL'
		
//		lu_nvo_Nortel = Create u_nvo_edi_confirmations_Nortel
//		liRC = lu_nvo_nortel.uf_nortel_gi(adw_main, adw_detail, adw_pick)
		
//	Case 'LEROYSOMER'
//		
//		lu_nvo_leroysomer = Create u_nvo_edi_confirmations_leroysomer
//		liRC = lu_nvo_leroysomer.uf_goods_Issue(adw_main, adw_detail, adw_pick)
		
	Case 'DELLKOREA'
		
//		lu_nvo_dellkorea = Create u_nvo_edi_confirmations_dellkorea
//		liRC = lu_nvo_dellkorea.uf_goods_Issue(adw_main, adw_detail, adw_pick)
		
	Case 'VALEOD'
		
//		lu_nvo_valeod = Create u_nvo_edi_confirmations_valeod
//		liRC = lu_nvo_valeod.uf_goods_Issue(adw_main, adw_detail, adw_pick, adw_Pack)
							
//	Case '3COM_NASH'
//		
//		lu_nvo_3com_nash = Create u_nvo_edi_confirmations_3com_Nash
//		liRC = lu_nvo_3com_nash.uf_goods_Issue(adw_main, adw_detail, adw_pick, adw_Pack)
//		
//	Case 'AMBIT'
//		
//		lu_nvo_ambit = Create u_nvo_edi_confirmations_ambit
//		liRC = lu_nvo_ambit.uf_goods_Issue(adw_main, adw_detail, adw_pick)
		
/*	Case 'HILLMAN'
		 
		lu_nvo_Hillman = Create u_nvo_edi_confirmations_hillman
		liRC = lu_nvo_Hillman.uf_goods_Issue(adw_main, adw_detail, adw_pick, adw_Pack)
*/		

End Choose


Return 0

end function

on u_nvo_edi_confirmations.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_nvo_edi_confirmations.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

