$PBExportHeader$u_nvo_custom_validations.sru
$PBExportComments$Project Level Validations
forward
global type u_nvo_custom_validations from nonvisualobject
end type
end forward

global type u_nvo_custom_validations from nonvisualobject
end type
global u_nvo_custom_validations u_nvo_custom_validations

forward prototypes
public function integer uf_check_confirm ()
public function integer uf_new_do_defaults (ref datawindow adw_main)
public function integer uf_outbound_validate_serial_generate ()
end prototypes

public function integer uf_check_confirm ();Long	llRowCOunt,	llRowPos, llRoNo,	llLineItem,	llOwner, ll_line_item_no, llcount, ll_row, ll_idx,ll_findrow


String	lsOrdStatus,  	ls_user_field1, lsTemp, ls_cust_order_no, ls_carrier, &
			ls_user_field8, ls_Supp_Code, ls_SKU, lsCustomer, lsTermsCode, lsProject, lsWarehouse, lsRateInd, lsWarehouseType, lsUF1
Boolean	lbNotCarton 
DateTime ldt_schedule_datetime, ldtToday
String ls_country_code, lsSiteID, lsFind
int blank_emc_codes
string ls_do_no
Datastore	lds_compare
String ls_DWG_UPLOAD
Decimal ldReqQty,ldAllocQty //29-Apr-2015 :Madhu- Added for FRIEDRICH
String	lsCustName, lsGTIN // TAM 2018/11/13 - S25743 
//common fields
ls_carrier = w_do.idw_main.GetITemString(1,'Carrier')

//Check project level edits before confirmation

Choose Case Upper(gs_project)
		
	Case 'GEISTLICH'	
		//GailM 5/7/2018 - Geistlich GI File processing - Allowed to confirm order without Packing List
		If w_do.idw_pack.rowcount() = 0 Then
			w_do.wf_display_message("Cannot confirm order without pack list.  Generate Pack List.")  
			w_do.tab_main.selecttab( 5 )
			w_do.tab_main.tabpage_pack.cb_pack_generate.SetFocus( )
			Return -1
		End If


	Case 'PHXBRANDS'

		//MA 01/08 - Added Check
		//CHEP and Half PALLETS must be a whole Number
		
		string ls_user_field
		
					
		ls_user_field = w_do.idw_other.GetITemString(1,'User_field9')
		
		If not isnull(ls_user_field) Then
		
			If not IsNumber(ls_user_field) or (integer(ls_user_field) <> dec(ls_user_field)) Then
				w_do.wf_display_message('CHEP PALLETS must be a whole Number.')   //MEA - 5/13 - Added Multi-Confirm
//				MessageBox(w_do.is_title,'CHEP PALLETS must be a whole Number.')
				w_do.tab_main.selecttab(2)
				f_setfocus(w_do.idw_other,1,"User_field9")
				Return -1
			End If

			If Pos(ls_user_field, ".",1) > 0 then
				w_do.wf_display_message("CHEP PALLETS cannot contain a '.'.")   //MEA - 5/13 - Added Multi-Confirm				
//				MessageBox(w_do.is_title,"CHEP PALLETS cannot contain a '.'.")
				w_do.tab_main.selecttab(2)
				f_setfocus(w_do.idw_other,1,"User_field9")
				Return -1				
				
			End IF		
		
		End If		
		

		ls_user_field = w_do.idw_other.GetITemString(1,'User_field11')
		
		If not isnull(ls_user_field) Then
		
			If not IsNumber(ls_user_field) or (integer(ls_user_field) <> dec(ls_user_field)) Then
				w_do.wf_display_message('HALF PALLETS must be a whole Number.')   //MEA - 5/13 - Added Multi-Confirm				
				//MessageBox(w_do.is_title,'HALF PALLETS must be a whole Number.')
				w_do.tab_main.selecttab(2)
				f_setfocus(w_do.idw_other,1,"User_field11")
				Return -1
			End If
			
			If Pos(ls_user_field, ".",1) > 0 then
				w_do.wf_display_message("HALF PALLETS cannot contain a '.'.")   //MEA - 5/13 - Added Multi-Confirm
				//MessageBox(w_do.is_title,"HALF PALLETS cannot contain a '.'.")
				w_do.tab_main.selecttab(2)
				f_setfocus(w_do.idw_other,1,"User_field11")
				Return -1				
				
			End IF
		
		End If			
		
	
		//Packing list must be present 
		llRowCount = w_do.idw_Pack.RowCount()
		
		If llRowCount <= 0 Then
			w_do.wf_display_message('You must generate the Packing List before you can confirm the order.')   //MEA - 5/13 - Added Multi-Confirm
//			MessageBox(w_do.is_title,'You must generate the Packing List before you can confirm the order.')
			w_do.tab_main.selecttab(5)
			Return -1
		End If
		
		//Validate packing fields
		For llRowPos = 1 to llRowCount
			
			//Carton Type is required
			If isnull(w_do.idw_pack.GetITemString(llRowPos,'carton_type')) or w_do.idw_pack.GetITemString(llRowPos,'carton_type') = '' Then
				w_do.wf_display_message('Carton Type is Required.')   //MEA - 5/13 - Added Multi-Confirm
				//MessageBox(w_do.is_title,'Carton Type is Required.')
				w_do.tab_main.selecttab(5)
				f_setfocus(w_do.idw_pack,llRowPos,"carton_type")
				Return -1
			End If
			
			//Carton Number is required
			If isnull(w_do.idw_pack.GetITemString(llRowPos,'carton_no')) or w_do.idw_pack.GetITemString(llRowPos,'carton_no') = '' Then
				w_do.wf_display_message('Carton Number is Required.')   //MEA - 5/13 - Added Multi-Confirm
				//MessageBox(w_do.is_title,'Carton Number is Required.')
				w_do.tab_main.selecttab(5)
				f_setfocus(w_do.idw_pack,llRowPos,"carton_no")
				Return -1
			End If
			
		Next
		
		
// TAM 08/04 - Added Logitech Validation
	Case 'LOGITECH'
		
		// If Return to Vendor(Supplier)
		If w_do.idw_main.GEtITemString(1,'Ord_Type') = 'X' or w_do.idw_main.GEtITemString(1,'Ord_Type') = 'E' or w_do.idw_main.GEtITemString(1,'Ord_Type') = 'I' Then

			//User Field 8 (Original Ro No)
			ls_user_field8 = w_do.idw_Other.GetITemString(1,'User_Field8')
			If isnull(ls_user_field8) or ls_user_field8 = '' Then
				w_do.wf_display_message('Original Receiving Order Number is required.')   //MEA - 5/13 - Added Multi-Confirm
				//MessageBox(w_do.is_title,'Original Receiving Order Number is required.')
				w_do.tab_main.SelectTab(1)
				f_setfocus(w_do.idw_other,1,"User_Field8")
				Return - 1
			End If

			SELECT count(*)  
	   	INTO :llCount  
 			FROM Receive_Master  
			WHERE ( Project_ID = 'LOGITECH' ) AND  
      	( RO_No = :ls_user_field8 ) ;
		
			//Ro No does not exist
			If llCount < 1 Then
				w_do.wf_display_message('Original Receiving Order Number does not exist.')   //MEA - 5/13 - Added Multi-Confirm
	//			MessageBox(w_do.is_title,'Original Receiving Order Number does not exist.')
				w_do.tab_main.SelectTab(1)
				f_setfocus(w_do.idw_other,1,"User_Field8")
				Return - 1
			End If

			//Supplier Invoice # is required
			If isnull(w_do.idw_Main.GetITemString(1,'invoice_no')) or w_do.idw_main.GetITemString(1,'invoice_no') = '' Then
				w_do.wf_display_message('Invoice number is required.')   //MEA - 5/13 - Added Multi-Confirm
//				MessageBox(w_do.is_title,'Invoice number is required.')
				w_do.tab_main.SelectTab(1)
				f_setfocus(w_do.idw_main,1,"invoice_no")
				Return - 1
			End If

			//Detail SKU and Line Item Number must match against original PO
			llRowCount = w_do.idw_Pack.RowCount()
		
			If llRowCount <= 0 Then
				w_do.wf_display_message('You must enter the Details before you can confirm the order.')   //MEA - 5/13 - Added Multi-Confirm
				//MessageBox(w_do.is_title,'You must enter the Details before you can confirm the order.')
				w_do.tab_main.SelectTab(3)
				Return -1
			End If
		
			//Validate Detail fields
			For llRowPos = 1 to llRowCount

				ls_Supp_Code = w_do.idw_detail.GetITemString(llRowPos,'supp_code')
				ll_line_item_no = w_do.idw_detail.GetItemnumber(llRowPos,'line_item_no')
				ls_SKU = w_do.idw_detail.GetItemString(llRowPos,'SKU')
			
				//Line Item number is required
				If isnull(w_do.idw_detail.GetItemNumber(llRowPos,'line_item_no')) or w_do.idw_detail.GetItemNumber(llRowPos,'line_item_no') < 1 Then
					MessageBox(w_do.is_title,'Line Number is Required.')
					w_do.tab_main.SelectTab(3)
					f_setfocus(w_do.idw_detail,llRowPos,"line_item_no")
					Return -1
				End If
			
				//SKU is required
				If isnull(w_do.idw_detail.GetITemString(llRowPos,'sku')) or w_do.idw_detail.GetITemString(llRowPos,'sku') = '' Then
					MessageBox(w_do.is_title,'SKU is Required.')
					w_do.tab_main.SelectTab(3)
					f_setfocus(w_do.idw_detail,llRowPos,"SKU")
					Return -1
				End If

				// Validate against original RO_NO, Supplier, SKU, Line Number
				SELECT count(*)  
	   		INTO :llCount  
 				FROM Receive_Detail  
				WHERE (RO_No = :ls_user_field8) AND  
						(Supp_Code = :ls_supp_code) AND 
						(line_item_no = :ll_line_item_no) AND 
						(SKU = :ls_SKU) ;

				If llRowCount <= 0 Then
					w_do.wf_display_message('The Line Number, SKU and Supplier Code Combination is not found on the original receiving order.')   //MEA - 5/13 - Added Multi-Confirm
//					MessageBox(w_do.is_title,'The Line Number, SKU and Supplier Code Combination is not found on the original receiving order.')
					w_do.tab_main.SelectTab(3)
					Return -1
				End If
			
			Next /*Next Detail*/
	
		End if /*Return*/
		
		// Carrier must be validated againast the Carrier Table
		Select Count(*) into :llCount
		From Carrier_Master
		Where Project_id = :gs_project and carrier_code = :ls_carrier;
		
		If lLCount < 1 Then
			w_do.wf_display_message('Carrier is invalid. Please select a valid carrier from the dropdown list.')   //MEA - 5/13 - Added Multi-Confirm
//			MessageBox(w_do.is_title,'Carrier is invalid. Please select a valid carrier from the dropdown list.')
			w_do.tab_main.SelectTab(2)
			f_setfocus(w_do.idw_other,1,"Carrier")
			Return - 1
		End If
		

	Case 'SIKA'
		//BOL Is required
		If isnull(w_do.idw_Other.GetItemString(1,'awb_bol_no')) or w_do.idw_Other.GetItemString(1,'awb_bol_no') = '' Then
			w_do.wf_display_message('BOL Number is Required.')   //MEA - 5/13 - Added Multi-Confirm
			//MessageBox(w_do.is_title,'BOL Number is Required.')
			w_do.tab_main.SelectTab(2)
			f_setfocus(w_do.idw_other,1,"awb_bol_no")
			Return -1
		End If

		//is Trailer required? 
		If isnull(w_do.idw_Other.GetItemString(1,'user_field7')) or w_do.idw_Other.GetItemString(1,'user_field7') = '' Then
			w_do.wf_display_message('Trailer is Required.')   //MEA - 5/13 - Added Multi-Confirm
//			MessageBox(w_do.is_title,'Trailer is Required.')
			w_do.tab_main.SelectTab(2)
			f_setfocus(w_do.idw_other,1,"user_field7")
			Return -1
		End If

		//Packing list must be present 
		llRowCount = w_do.idw_Pack.RowCount()
		If llRowCount <= 0 Then
			w_do.wf_display_message('You must generate the Packing List before you can confirm the order.')   //MEA - 5/13 - Added Multi-Confirm
//			MessageBox(w_do.is_title,'You must generate the Packing List before you can confirm the order.')
			w_do.tab_main.selecttab(5)
			Return -1
		End If
		
		//Validate packing fields
		/*
		For llRowPos = 1 to llRowCount
			//Carton Type is required
			If isnull(w_do.idw_pack.GetITemString(llRowPos,'carton_type')) or w_do.idw_pack.GetITemString(llRowPos,'carton_type') = '' Then
				MessageBox(w_do.is_title,'Carton Type is Required.')
				w_do.tab_main.selecttab(5)
				f_setfocus(w_do.idw_pack,llRowPos,"carton_type")
				Return -1
			End If
			//Carton Number is required
			If isnull(w_do.idw_pack.GetITemString(llRowPos,'carton_no')) or w_do.idw_pack.GetITemString(llRowPos,'carton_no') = '' Then
				MessageBox(w_do.is_title,'Carton Number is Required.')
				w_do.tab_main.selecttab(5)
				f_setfocus(w_do.idw_pack,llRowPos,"carton_no")
				Return -1
			End If
		Next
		*/

	//20-Dec-2013 :Madhu- Added condition for Ariens -START
		
	CASE 'SATURN'
		
		//Validate required Detail Fields
		llRowCOunt = w_do.idw_Detail.RowCount()
		For llRowPos = 1 to llRowCount
			
			
			IF gs_project = "SATURN" THEN
				
				
				//MA - 02/08 - Added Check
				//the KNA BAN number delivery_detail.User_Field1 has only been used once for that SKU
				
				//search all completed orders  (delivery_Master.ord_status = C or D) for each SKU in the 
				//order being confirmed, check to see that the KAN BAN/SKU combination does not exist in any of them
				
				ls_user_field1 = trim(w_do.idw_detail.GetITemString(llRowPos,'user_field1'))
				ls_SKU = w_do.idw_detail.GetItemString(llRowPos,'SKU')
				
				
				If NOT isnull(ls_user_field1) AND ls_user_field1 <> '' Then
				
					SELECT Count(Delivery_Detail.User_Field1) INTO :llcount 
						FROM Delivery_Detail,
							  Delivery_Master
							WHERE Delivery_Detail.User_Field1 = :ls_user_field1 AND Delivery_Detail.SKU = :ls_SKU AND
								   Delivery_Master.Do_No = Delivery_Detail.Do_No and Delivery_Master.ord_status <> 'V';

				
//				search all completed orders  (delivery_Master.ord_status = C or D) for each SKU in the order being confirmed, check to see that the KAN BAN/SKU combination does not exist in any of them
				
				
			
					If lLCount > 1 Then
							w_do.wf_display_message('The KNA BAN number can only been used once for this SKU.')   //MEA - 5/13 - Added Multi-Confirm
							//MessageBox(w_do.is_title,'The KNA BAN number can only been used once for this SKU.')
							w_do.tab_main.SelectTab(3)
							f_setfocus(w_do.idw_detail,llRowPos,"user_field1")
							Return - 1
					End IF
				
				END IF
				
			END IF	
			
			
			
		Next /*Next detail Row*/
		
	/* 12/12 - PCONKl - added TPV */ /* 6/13 - added FUNAI */ /*TAM 2015/03 added GIBSON*/
	//1-FEB-2019 :Madhu S28945 Added PHILIPSCLS
	//GailM 11/18/2020 S51441/F26536/I2978 PhilipsDA mimic PHILIPSCLS in Outbound order
	Case 'PHILIPS-SG', 'PHILIPSCLS', 'PHILIPS-DA', 'TPV', 'FUNAI', 'GIBSON'
		llRowCount = w_do.idw_Pack.RowCount()
		
		If llRowCount <= 0 Then
			w_do.wf_display_message('You must generate the Packing List before you can confirm the order.')   //MEA - 5/13 - Added Multi-Confirm
			//MessageBox(w_do.is_title,'You must generate the Packing List before you can confirm the order.')
			w_do.tab_main.selecttab(5)
			Return -1
		End If

	//MEA - 5/13 - Multi-Confirm not added for Pandora

	Case 'PANDORA'
		
		string ls_transport_mode, ls_freight_terms

		//Make Transport Mode mandatory for Outbound.
		
		ls_transport_mode = w_do.idw_Other.GetItemString( 1,"transport_mode")

		IF IsNull(ls_transport_mode) OR trim(ls_transport_mode) = "" THEN

			MessageBox(w_do.is_title,'Transport Mode is required.')
			w_do.tab_main.SelectTab(2)
			f_setfocus(w_do.idw_other,1,"transport_mode")
			Return - 1	
			
		END IF
		
		//Make Freight_terms mandatory for Outbound.
		
		ls_freight_terms = w_do.idw_Other.GetItemString( 1,"freight_terms")

		IF IsNull(ls_freight_terms) OR trim(ls_freight_terms) = "" THEN

			MessageBox (w_do.is_title, "Freight Terms is required.")
			w_do.tab_main.SelectTab(2)
			w_do.idw_Other.SetColumn("freight_terms")
			w_do.idw_Other.SetFocus()
			return -1		
			
		END IF
	
		string ls_name, ls_city, ls_address_1
		
		ls_name = w_do.idw_main.GetItemString( 1,"cust_name")
		
		IF ISNull(ls_name) OR Trim(ls_name) = "" THEN
			MessageBox(w_do.is_title,'The Ship-To Cust Name is required.')
			w_do.tab_main.tabpage_main.tab_address.SelectTab(1)
			w_do.tab_main.tabpage_main.tab_address.tabpage_shipto.dw_shipto.SetColumn("cust_name")			
			w_do.tab_main.tabpage_main.tab_address.tabpage_shipto.dw_shipto.SetFocus()
			Return - 1			
		END IF
		
		ls_city = w_do.idw_main.GetItemString( 1,"city")
		
		IF ISNull(ls_city) OR Trim(ls_city) = "" THEN
			MessageBox(w_do.is_title,'The Ship-To City is required.')
			w_do.tab_main.tabpage_main.tab_address.SelectTab(1)
			w_do.tab_main.tabpage_main.tab_address.tabpage_shipto.dw_shipto.SetColumn("city")			
			w_do.tab_main.tabpage_main.tab_address.tabpage_shipto.dw_shipto.SetFocus()
			Return - 1			
		END IF
			

		ls_address_1 = w_do.idw_main.GetItemString( 1,"address_1")
		
		IF ISNull(ls_address_1) OR Trim(ls_address_1) = "" THEN
			MessageBox(w_do.is_title,'The Ship-To Address is required.')
			w_do.tab_main.tabpage_main.tab_address.SelectTab(1)
			w_do.tab_main.tabpage_main.tab_address.tabpage_shipto.dw_shipto.SetColumn("address_1")			
			w_do.tab_main.tabpage_main.tab_address.tabpage_shipto.dw_shipto.SetFocus()
			Return - 1			
		END IF		
		
		
		ls_country_code = w_do.idw_main.GetItemString( 1,"country")
		
		IF ISNull(ls_country_code) OR Trim(ls_country_code) = "" THEN
			MessageBox(w_do.is_title,'The Ship-To country code is required.')
			w_do.tab_main.tabpage_main.tab_address.SelectTab(1)
			w_do.tab_main.tabpage_main.tab_address.tabpage_shipto.dw_shipto.SetColumn("country")			
			w_do.tab_main.tabpage_main.tab_address.tabpage_shipto.dw_shipto.SetFocus()
			Return - 1			
		END IF
				
		
		
		//Country Code
		
		If NOT isnull(ls_country_code) AND Trim(ls_country_code) <> '' Then
					
			SELECT Count(ISO_Country_Cd) INTO :llcount 
							FROM Country
								WHERE Designating_Code = :ls_country_code USING SQLCA;
					
					
			If lLCount <= 0 Then
					MessageBox(w_do.is_title,'The Ship-To country code is invalid.')
					w_do.tab_main.tabpage_main.tab_address.SelectTab(1)
					w_do.tab_main.tabpage_main.tab_address.tabpage_shipto.dw_shipto.SetColumn("country")			
					w_do.tab_main.tabpage_main.tab_address.tabpage_shipto.dw_shipto.SetFocus()
					Return - 1
			End IF
				
		END IF
		
		
		lswarehouse = w_do.idw_main.GetITemString(1,'wh_Code')
		
		string ls_From_Country_Code
		
		SELECT Country INTO :ls_From_Country_Code
			FROM warehouse WHERE wh_code = :lswarehouse USING SQLCA;
			
		IF SQLCA.SQLCode < 0 THEN
			MessageBox ("DB Error", SQLCA.SQLErrText)
		END IF
		
		//Only check when Ship To and Ship From are not US.
		// - 09-14-09 - Per Ian, now requiring price for all outbound orders.
		
		// IF IsNull(ls_From_Country_Code) THEN ls_From_Country_Code = ''
		
		// IF Upper(ls_country_code) <> 'US' OR ls_From_Country_Code <> 'US'  THEN

			//Validate required Detail Fields
			llRowCOunt = w_do.idw_Detail.RowCount()
			For llRowPos = 1 to llRowCount
				//Price
				If isnull(w_do.idw_detail.GetITemDecimal(llRowPos,'price')) or w_do.idw_detail.GetITemDecimal(llRowPos,'price') = 0 Then
					MessageBox(w_do.is_title,"Price is required.")
					w_do.tab_main.SelectTab(3)
					f_setfocus(w_do.idw_detail,llRowPos,"price")
					Return -1
				End If
				
			Next /*Next detail Row*/

		//END IF


//***************************************//
//MStuart - babycare emc functionality                         //
//                                                                              //
//***************************************//





CASE "KLONELAB"
	
	//Check to make sure the Shipping Tracking ID is filled in for all rows.
	
	
//	If we can get it, then it would be good to check all the relevant points in order:
//
//•	At Ready to Ship (and Ship confirm): Packed OK (all lines in cartons)?
//•	At UCC-128 label Print: Rdy to ship done? 
//•	At Ship confirm: UCC-128 Labels printed? ( or at least web app launched) 
//
//Could the indicator be overloaded in the UF for UCC-128? I think the current value is “LBL”, maybe we could make it “LBLP” when they attempt to print it. All other logic could check for non-blank or both values.
//

	
	IF   w_do.idw_main.GetItemString(1,'user_field13') = 'Y'  AND &
		(w_do.is_Ready_Or_Confirm = "CONFIRM" OR w_do.is_Ready_Or_Confirm = "BOTH") AND &
		(w_do.idw_main.GetItemString(1,"ord_status") <> 'R' AND w_do.idw_main.GetItemString(1,"ord_status") <> 'C') then
	
		w_do.wf_display_message("A UCC-128 label is required. You must first 'Ready To Ship' and print the label before you confirm.")   //MEA - 5/13 - Added Multi-Confirm
		//MessageBox ("Validation Error", "A UCC-128 label is required. You must first 'Ready To Ship' and print the label before you confirm.")
		RETURN -1
	
	END IF

	IF  w_do.idw_main.GetItemString(1,'user_field13') = 'Y'  AND &
		(w_do.is_Ready_Or_Confirm = "CONFIRM" OR w_do.is_Ready_Or_Confirm = "BOTH") THEN

		ls_do_no = w_do.idw_main.GetITemString(1,'do_no')

		SELECT DWG_UPLOAD INTO :ls_DWG_UPLOAD FROM Delivery_Master With (NoLock) Where Do_no = :ls_do_no;
		
		IF IsNull(ls_DWG_UPLOAD) or trim(ls_DWG_UPLOAD) = '' Then

			w_do.wf_display_message("A UCC-128 label is required. You must print the label before you confirm.")   //MEA - 5/13 - Added Multi-Confirm
			//MessageBox ("Validation Error", "A UCC-128 label is required. You must print the label before you confirm.")
			RETURN -1

			
			
		End IF

	END IF
	
	// 08/13 - PCONKL - If USer Field 2 (Customer Number) = 112490 or 111511, Freight_Eta must be filled in
	IF  w_do.idw_main.GetItemString(1,'user_field2') = '112490' or w_do.idw_main.GetItemString(1,'user_field2') = '111511' Then
		
		If IsNull(w_do.idw_main.GetItemDateTime(1,'freight_eta')) then
			w_do.wf_display_message("Estimated Delivery DT must be filled in for this Customer'.") 
			RETURN -1
		End If
		
	End If

	IF w_do.idw_pack.RowCount() <= 0 then
		w_do.wf_display_message("Packing Rows are required before you can 'Ready to Ship' or 'Confirm'.")   //MEA - 5/13 - Added Multi-Confirm
		//MessageBox ("Validation Error", "Packing Rows are required before you can 'Ready to Ship' or 'Confirm'.")
		RETURN -1
		
	END IF

	string ls_CartonNo, ls_ShipperTrackingId

	FOR ll_Idx = 1 to w_do.idw_pack.RowCount() 
		
		ls_CartonNo =  w_do.idw_pack.GetItemString(ll_idx, "carton_no")
		
		if IsNull(ls_CartonNo) or trim(ls_CartonNo) = '' then
			w_do.wf_display_message("Packing Row("+string(ll_Idx)+") has no carton number.")   //MEA - 5/13 - Added Multi-Confirm
			//MessageBox ("Validation Error", "Packing Row("+string(ll_Idx)+") has no carton number.")
			RETURN -1
		end if
		
		ls_ShipperTrackingId = w_do.idw_pack.GetItemString(ll_idx, "shipper_tracking_id")

		if IsNull(ls_ShipperTrackingId) or trim(ls_ShipperTrackingId) = '' then
			w_do.wf_display_message("Packing Row("+string(ll_Idx)+") has no shipper tracking id.")   //MEA - 5/13 - Added Multi-Confirm
			//MessageBox ("Validation Error", "Packing Row("+string(ll_Idx)+") has no shipper tracking id.")
			RETURN -1
		end if		
		
		
	NEXT
	

	Case 'PHYSIO-MAA', 'PHYSIO-XD'
		
		 boolean lb_sims_can_print = true		// If DM.Packlist_Notes begins with an underscore '_' then SIMS cannot print the CI and Physio must print due to leagal requirements
		 												// Only check validation below if SIMS can print the CI

		if w_do.idw_main.RowCount() >= 1 then
			lb_sims_can_print = ( Left(String(w_do.idw_main.Object.Packlist_Notes[1]), 1) <> "_" ) or IsNull(w_do.idw_main.Object.Packlist_Notes[1])
		end if

		if Upper(Trim(w_do.idw_other.GetITemString(1,'User_field20'))) = 'Y' and lb_sims_can_print then
			String ls_retrieved_ind, ls_invoice_encoded
			
			SELECT Retrieved_Ind, Invoice_Encoded
			INTO :ls_retrieved_ind, :ls_invoice_encoded
			FROM Commercial_Invoice
			WHERE project_id = :gs_Project 
			AND do_no = :w_do.is_dono
			USING SQLCA;
		
			if sqlca.sqlcode = 0 then			
				if IsNull(ls_retrieved_ind) or ls_retrieved_ind <> 'Y' then
					w_do.wf_display_message("Documents required, please print documents!")
					return -1
				elseif IsNull(ls_invoice_encoded) or Len(Trim(ls_invoice_encoded)) = 0 then
					//w_do.wf_display_message("Documents required, please request documents again or contact your supervisor!");
					//return 0 //03-Apr-2014 :Madhu- Don't confirm an order.
					//return -1 //03-Apr-2014 :Madhu- Don't confirm an order 
					
					// LTK 20140404   The intent here is to *allow* confirmation when the CI cannot be retrieved because of unforseen consequences (communication problems, etc.).
					// Zero is returned here by default (batch mode) to allow confirmation.  However, the user if given the option to halt confirmation when not in batch mode.
					if w_do.ib_batchconfirmmode then
						w_do.wf_display_message("Documents required, please request documents again or contact your supervisor!");
						return 0
					else
						if MessageBox(w_do.is_title, "Documents required, please request documents again or contact your supervisor! ~r~rDo you want to continue the confirmation anyway?", Question!,YESNO!,2) = 1 then
							return 0
						else
							return -1
						end if
					end if
				end if
			elseif sqlca.sqlcode = 100 then
				w_do.wf_display_message("Documents required, please request documents!")
				return -1
			elseif sqlca.sqlcode = -1 then
				w_do.wf_display_message("Error retrieving Commercial Invoice.")
				return -1
			end if
		end if

//29-Apr-2015 :Madhu- Short Pick on FG finished goods -START
CASE 'FRIEDRICH'

	IF w_do.idw_other.getitemstring(1,'User_Field6') ='FG' THEN
		FOR llRowPos = 1 to w_do.idw_detail.RowCount() 
			ldReqQty = w_do.idw_detail.getitemnumber(llRowPos,'req_qty')
			ldAllocQty = w_do.idw_detail.getitemnumber(llRowPos,'alloc_qty')

			IF ((ldReqQty > ldAllocQty) and (ldReqQty > 0) and (w_do.idw_pick.rowcount() > 0 ))THEN
				w_do.wf_display_message("Cannot confirm short ship orders!");
				w_do.tab_main.selecttab(2)
				f_setfocus(w_do.idw_other,1,"User_field6")
				Return -1
			END IF
	Next
END IF	
//29-Apr-2015 :Madhu- Short Pick on FG finished goods -END	

//21-Jul-2016 :Madhu- Validate DD.UF1 should match DP.UF1 - START
CASE 'H2O'
	//Get required values from Delivery Detail
	For llRowPos = 1 to w_do.idw_detail.RowCount() 
		
		// 08/16 - PCONKL - Don;t validate if nothing allocated for line
		If w_do.idw_detail.getItemNumber(llRowPos,'alloc_qty') = 0 or isnull(w_do.idw_detail.getItemNumber(llRowPos,'alloc_qty')) Then Continue
		
		ls_SKU =w_do.idw_detail.getItemString(llRowPos,'sku')
		ls_Supp_Code =w_do.idw_detail.getItemString(llRowPos,'supp_code')
		lsUF1 =w_do.idw_detail.getItemString(llRowPos,'user_field1')
		llLineItem =w_do.idw_detail.getItemNumber(llRowPos,'Line_Item_No')
		
		//Find an appropriate record on Delivery Packing
		lsFind ="upper(sku) ='"+ls_SKU+"' and Line_Item_No ="+string(llLineItem)+" and supp_code='" +ls_Supp_Code +"' and user_field1= '"+lsUF1+"'"
		ll_findrow =w_do.idw_pack.find(lsFind,1,w_do.idw_pack.rowcount())
		
		//Prompt an error message, if couldn't find a record.
		If ll_findrow <=0 THEN
			w_do.wf_display_message("Store/Mark For = " +lsUF1+" doesn't match on Pack List ~r~n~n Please regenerate Pack List.")
			w_do.tab_main.SelectTab(5)
			f_setfocus(w_do.idw_pack,llLineItem,"user_field1")
			Return -1
		END IF
		
	NEXT

// TAM 2018/11/13 - S25743 - For Rema - If Customer Name Like '%SWS%' (Subway) don't allow Confirm if a GTIN is missing
CASE 'REMA'
	lsCustName =  w_do.idw_main.GetItemString(1,'cust_name')

	If Pos(lsCustName, "SWS",1) > 0 then
		FOR llRowPos = 1 to w_do.idw_detail.RowCount()
			lsGtin 		= w_do.idw_detail.GetItemString(llRowPos,"GTIN")
		   	If lsGtin = '' or isnull(lsGtin) Then
				w_do.wf_display_message("GTIN Cannot Be Blank at Row "+string(llRowPos) +" of Order Detail.~r~rPlease Enter a GTIN then Save." )
				return -1
			End If
		Next /*Next detail Row*/
	End If

//21-Jul-2016 :Madhu- Validate DD.UF1 should match DP.UF1 - END
End Choose
	
Return 0
end function

public function integer uf_new_do_defaults (ref datawindow adw_main);
//Add any project level new Delivery Order defaults

Choose Case Upper(gs_Project)
		
	Case 'BOBCAT'
		
		adw_main.SetItem(1,"ord_type",'C') 
		adw_main.SetItem(1,"USer_field5",'LONG BEACH') 
		adw_main.SetItem(1,"User_field6",'SHANGHAI') 
		adw_main.SetItem(1,"freight_terms",'NET 90') 
		
End CHoose

Return 0
end function

public function integer uf_outbound_validate_serial_generate ();
//Validations before generating Serial List on W_DO

Choose Case upper(gs_Project)
		
	Case 'ARIENS'
		
		If  w_do.idw_Pack.RowCount() = 0 Then
			messagebox(w_do.is_title,'Pack List must be generated before generating Serial # list!')
			Return - 1
		End If
		
		//Jxlim 03/26/2014 Replace dm.User_field5 with carrier_pro_no name field
		//PRO required
		//If w_do.Idw_Main.GetITemString(1,'user_field5') = '' or isnull(w_do.Idw_Main.GetITemString(1,'user_field5')) Then
		If  w_do.Idw_Main.GetITemString(1,'carrier_pro_no') = '' or isnull(w_do.Idw_Main.GetITemString(1,'carrier_pro_no')) Then
			messagebox(w_do.is_title,'PRO #, AWB # and Carrier required before scanning Serial Numbers (required on label)')
			Return - 1
		End If
		
		//AWB required
		If w_do.Idw_Main.GetITemString(1,'AWB_Bol_no') = '' or isnull(w_do.Idw_Main.GetITemString(1,'AWB_Bol_no')) Then
			messagebox(w_do.is_title,'PRO #, AWB #and Carrier required before scanning Serial Numbers (required on label)')
			Return - 1
		End If

		//Carrier required
		If w_do.Idw_Main.GetITemString(1,'carrier') = '' or isnull(w_do.Idw_Main.GetITemString(1,'carrier')) Then
			messagebox(w_do.is_title,'PRO #, AWB # and Carrier required before scanning Serial Numbers (required on label)')
			Return - 1
		End If
		
End Choose

Return 0
end function

on u_nvo_custom_validations.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_nvo_custom_validations.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

