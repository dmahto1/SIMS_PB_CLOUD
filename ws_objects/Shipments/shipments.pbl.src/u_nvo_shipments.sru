$PBExportHeader$u_nvo_shipments.sru
$PBExportComments$Process Shipments (Track/Trace)
forward
global type u_nvo_shipments from nonvisualobject
end type
end forward

global type u_nvo_shipments from nonvisualobject
end type
global u_nvo_shipments u_nvo_shipments

type variables

DataStore	idsDetail, IdsOrder
end variables

forward prototypes
public function integer uf_validate_outbound (ref datawindow adw_main, ref datawindow adw_pack)
public function string uf_create_outbound_shipment (ref datawindow adw_main, ref datawindow adw_detail, ref datawindow adw_pack)
public function integer uf_add_inbound_order (ref datawindow adw_main, ref datawindow adw_detail, string asrono)
public function string uf_create_inbound_shipment (ref datawindow adw_main, ref datawindow adw_detail)
public function integer uf_validate_inbound (ref datawindow adw_main, integer ai_details)
public function boolean uf_nonworkday (date adt_date, string as_country)
public function date uf_get_eta (date adt_departuredate, string as_project, string as_wh, string as_carrier, string as_country, string as_zip)
public function integer uf_update_etd (string as_shipno, datetime adt_etd)
public function date uf_get_etd (date adt_start, string as_project, string as_wh, string as_carrier, string as_country)
public function integer uf_add_outbound_order (ref datawindow adw_main, ref datawindow adw_detail, string asdono)
public function integer uf_add_outbound_orderlevel (ref datawindow adw_main, ref datawindow adw_outbound_orderlevel, string asdono)
end prototypes

public function integer uf_validate_outbound (ref datawindow adw_main, ref datawindow adw_pack);string lsCarrier
integer liCarrier

if adw_Main.RowCount() = 0 then return 0

//AWB is required
If isNull(adw_Main.GetItemString(1,'awb_bol_no')) or adw_Main.GetItemString(1,'awb_bol_no') = '' Then
	Messagebox("Shipments","AWB BOL NBR is required before creating a shipment!")
	adw_main.SetFocus()
	adw_main.SetColumn('awb_bol_no')
	Return -1
End If

//Carrier is required
lsCarrier = adw_Main.GetItemString(1,'Carrier')
If isNull(adw_Main.GetItemString(1,'Carrier')) or adw_Main.GetItemString(1,'Carrier') = '' Then
	Messagebox("Shipments","Carrier is required before creating a shipment!")
	adw_main.SetFocus()
	adw_main.SetColumn('Carrier')
	Return -1
else
	select count(carrier_code) into :liCarrier
	from carrier_master
	Where project_id = :gs_project
	and carrier_code = :lsCarrier
	Using SQLCA;

	If liCarrier < 1 Then	
		Messagebox("Shipments","Carrier must be set up in Carrier Table before creating a shipment!")
		adw_main.SetFocus()
		adw_main.SetColumn('Carrier')
		Return -1
	end if
End If

//Zip is required
If isNull(adw_Main.GetItemString(1,'Zip')) or adw_Main.GetItemString(1,'Zip') = '' Then
	Messagebox("Shipments","Ship to Zip/Postal Code is required before creating a shipment!")
	adw_main.SetFocus()
	adw_main.SetColumn('Zip')
	Return -2
End If

//Packing list must be generated...
If adw_Pack.RowCount() = 0 Then
	Messagebox("Shipments","The Packing List must be generated before creating a shipment!")
	Return -1
End If

Return 0
end function

public function string uf_create_outbound_shipment (ref datawindow adw_main, ref datawindow adw_detail, ref datawindow adw_pack);
// We will either update an existing Shipment based on Carrier/AWB/Zip Code or create a new one.

String	lsAWB, lsCarrier, lsZip, lsDoNo, lsShipNo, lsWarehouse, lsSKU, lsInvoice,  lsUOM, lsTerms,	&
			lsFromName, LsFromaddr1, lsFromAddr2, lsFromAddr3, lsFromAddr4, lsFromCity, lsFromState,	&
			lsFromZip, lsFromCountry, lsFromContact, lsFromFax, lsFromTel, lsFromEmail,					&
			lsToName, LsToaddr1, lsToAddr2, lsToAddr3, lsToAddr4, lsToCity, lsToState,	&
			lsToZip, lsToCountry, lsToContact, lsToFax, lsToTel, lsToEmail, lsErrText

Long	llCount, llRowCount, llRowPos, llShipLineNo, llOrderLineNo, llID, llCartonCount, llExistCartonCount, llFindRow

Decimal	ldShipQty, ldPrice, ldWeight, ldExistWeight

DateTime	ldtToday, ldtETD
Date ldtETA // 03/01/07 - now selectively calculating Freight_ETA

If adw_main.RowCount() <= 0 Then Return ''

lsInvoice = adw_main.GetItemString(1,'Invoice_No')
lsWarehouse = adw_main.GetItemString(1,'wh_Code')

// pvh 02.15.06 - gmt
ldtToday = f_getLocalWorldTime( lsWarehouse ) 


lsAWB = adw_main.GetItemString(1,'awb_bol_no')
lsCarrier = adw_main.GetItemString(1,'carrier')
lsZip = adw_main.GetItemString(1,'Zip')
lsDoNo = adw_main.GetItemString(1,'do_no')
lsTerms = adw_main.GetItemString(1,'Freight_Terms')
//dts 02/07/07 - Now using Complete_Date, then Freight_ETD, then Schedule_Date
//dts 03/07/07 - Now just using complete_date and Freight_ETD if order is not complete
ldtETD = adw_main.GetItemDateTime(1,'Complete_Date')

if isnull(ldtETD) and adw_main.GetItemString(1,'Ord_Status') <> 'C' then
	ldtETD = adw_main.GetItemDateTime(1,'Freight_ETD')
end if
//if isnull(ldtETD) then
//	ldtETD = adw_main.GetItemDateTime(1,'Schedule_Date')
//end if

//We may have already added this Order to a shipment previously.
lsShipNo = ''

Select Max(ship_no) into :lsShipNo
from Shipment_line_item 
Where RODO_No = :lsDoNo
Using SQLCA;

//If shipment line exists, Return Shipment ID and DO/RO will open the Shipment Window
If lsShipNo > '' Then
	Return lsShipNo
End If

// 03/01/07
SetNull(ldtETA)
if not IsNull(ldtETD) and g.ibEtaMaintEnabled then
	lsToCountry = adw_main.GetItemString(1,'Country') //grabbing dest. country here instead of below (actually, in addition to)
	//ETD may slide based on carrier departure days.
	ldtETD = datetime(uf_Get_ETD(date(ldtETD), gs_Project, lsWarehouse, lsCarrier, lsToCountry))
	ldtETA = uf_Get_ETA(date(ldtETD), gs_Project, lsWarehouse, lsCarrier, lsToCountry, lsZip)
end if

//This order is not already on a shipment. We will either add this order to an existing shipment or create a new one.
lsShipNo = ''

//Validate that necessary fields are present before creating/Updating Shipment
//dts - now called from w_do.ue_process_shipments (to occur before 'Save' prompt)
//If uf_validate_Outbound(adw_Main, adw_Pack) < 0 Then Return "-1"

Select Max(S.ship_no) into :lsShipNo
From Shipment S, Shipment_Location SL
Where S.ship_no = SL.Ship_no and Project_id = :gs_project and Carrier_code = :lsCarrier 
		and Awb_Bol_no = :lsAWB and Zip = :lsZip and Location_Type = 'D'
Using SQLCA;

//We need total weight and carton count and UOM - If we are updating an existing shipment header, we will add to current total
//Select Sum(weight_gross), Count(distinct Carton_no), Min(standard_of_measure) 
//Into :ldWeight, :llCartonCount, :lsUOM
Select Min(standard_of_measure) 
Into :lsUOM
From Delivery_Packing
Where do_no = :lsDoNo;

/* dts - 04/24/07 - Items packed in the same container each have the total gross weight in Weight_Gross
	 - Now just grabbing the weight from 'c_weight on the Packing data window */
llCartonCount = adw_pack.GetItemNumber(1, "c_carton_count")
ldWeight = adw_pack.GetItemNumber(1, "c_weight")
	
If lsUOM = 'E' Then /*English*/
	lsUOM = 'L' /*pounds*/
Else /*Metric*/
	lsUOM = 'K' /*Kilos*/
End If

// If shipment doesn't exist, we will need to create a shipment header and location records first
If lsShipNo = '' or isnull(lsShipNo) Then
		
	//get the next available shipment ID
	llID = g.of_next_db_seq(gs_project,'Shipment','Ship_No')
	lsShipNO = gs_project + String(llID,'000000')

	//Create the Shipment Header Record

  /* dts 05/05/06 - no longer defaulting ord_satus to 'N'
  (thought to be 'New' but actually 'No paper work Received ...') */
  
   Execute Immediate "BEGIN TRANSACTION" using SQLCA;
	
	Insert Into Shipment (Ship_No, wh_Code, Project_ID, Carrier_Code, Ord_date, est_Ctn_Cnt,  Est_weight,  Est_weight_uom,  Create_user_date,
								Create_User, Last_user, Last_Update, ord_Status_date, Ord_Status, Freight_terms, awb_bol_no, Ord_Type,
								//3/1/07 Freight_etd,  Est_weight_Qualifier)
								Freight_etd,  Freight_ETA, Est_weight_Qualifier)
	Values					(:lsShipNo, :lsWarehouse, :gs_Project, :lsCarrier, :ldtToday, :llCartonCount, :ldWeight, :lsUOM,  :ldtToday,
								:gs_userid, :gs_userid, :ldtToday, :ldtToday, 'NA', :lsTerms, :lsAWB, 'O',
								//3/1/07 :ldtETD,  'G')
								:ldtETD,  :ldtETA, 'G')
	Using SQLCA;
	
	If sqlca.sqlcode <> 0 Then
		lsErrText = sqlca.sqlerrtext /*error text lost in rollback*/
		Execute Immediate "ROLLBACK" using SQLCA;
		Messagebox('Shipments',"Unable to save Shipment Header record to database!~r~r" + lsErrtext)
		Return "-1"
	End If
	
	//Create the Origin Location (from WH)
	
	//Warehouse address is available in Project Warehouse DS
	llFindRow = g.ids_project_warehouse.Find("Upper(wh_Code) = '" + Upper(lsWarehouse) + "'",1,g.ids_project_warehouse.RowCount())
	If llFindRow > 0 Then
		lsFromName = g.ids_project_warehouse.getITemString(llFindRow,'wh_name')
		lsFromAddr1 = g.ids_project_warehouse.getITemString(llFindRow,'Address_1')
		lsFromAddr2 = g.ids_project_warehouse.getITemString(llFindRow,'Address_2')
		lsFromAddr3 = g.ids_project_warehouse.getITemString(llFindRow,'Address_3')
		lsFromAddr4 = g.ids_project_warehouse.getITemString(llFindRow,'Address_4')
		lsFromCity = g.ids_project_warehouse.getITemString(llFindRow,'City')
		lsFromState = g.ids_project_warehouse.getITemString(llFindRow,'State')
		lsFromZip = g.ids_project_warehouse.getITemString(llFindRow,'Zip')
		lsFromCountry = g.ids_project_warehouse.getITemString(llFindRow,'Country')
		lsFromtel = g.ids_project_warehouse.getITemString(llFindRow,'Tel')
		lsFromFax = g.ids_project_warehouse.getITemString(llFindRow,'Fax')
		lsFromContact = g.ids_project_warehouse.getITemString(llFindRow,'Contact_Person')
		lsFromEmail = g.ids_project_warehouse.getITemString(llFindRow,'Email_address')
	End If
	
	Insert Into Shipment_Location (Ship_No, Location_Type, Name, Address_1, address_2, Address_3, Address_4, City,
												State, Zip, Country, Contact_person, Fax, Tel, Email_address)
	Values								(:lsShipNo, 'O', :lsFromName, :LsFromaddr1, :lsFromAddr2, :lsFromAddr3, :lsFromAddr4, :lsFromCity, 
												:lsFromState, :lsFromZip, :lsFromCountry, :lsFromContact, :lsFromFax, :lsFromTel, :lsFromEmail)
	Using SQLCA;
	
	If sqlca.sqlcode <> 0 Then
		lsErrText = sqlca.sqlerrtext /*error text lost in rollback*/
		Execute Immediate "ROLLBACK" using SQLCA;
		Messagebox('Shipments',"Unable to save Shipment Location (Source) record to database!~r~r" + lsErrtext)
		Return "-1"
	End If
	
	//Create the Dest Location Address
	
	//Ship To address coming from Delivery Order
	lsToName = adw_main.GetItemString(1,'Cust_name')
	lsToAddr1 = adw_main.GetItemString(1,'Address_1')
	lsToAddr2 = adw_main.GetItemString(1,'Address_2')
	lsToAddr3 = adw_main.GetItemString(1,'Address_3')
	lsToAddr4 = adw_main.GetItemString(1,'Address_4')
	lsToCity = adw_main.GetItemString(1,'City')
	lsToState = adw_main.GetItemString(1,'State')
	lsToZip = adw_main.GetItemString(1,'Zip')
	lsToCountry = adw_main.GetItemString(1,'Country')
	lsTotel = adw_main.GetItemString(1,'Tel')
	lsToFax = adw_main.GetItemString(1,'Fax')
	lsToContact = adw_main.GetItemString(1,'Contact_Person')
		
	Insert Into Shipment_Location (Ship_No, Location_Type, Name, Address_1, address_2, Address_3, Address_4, City,
												State, Zip, Country, Contact_person, Fax, Tel)
	Values								(:lsShipNo, 'D', :lsToName, :LsToaddr1, :lsToAddr2, :lsToAddr3, :lsToAddr4, :lsToCity, 
												:lsToState, :lsToZip, :lsToCountry, :lsToContact, :lsToFax, :lsToTel)
	Using SQLCA;		
	
	If sqlca.sqlcode <> 0 Then
		lsErrText = sqlca.sqlerrtext /*error text lost in rollback*/
		Execute Immediate "ROLLBACK" using SQLCA;
		Messagebox('Shipments',"Unable to save Shipment Location (Destination) record to database!~r~r" + lsErrtext)
		Return "-1"
	End If
	
Else /* Shipment Exists - Add Weights and carton count to existing Shipment Header, update Freight ETD */
				// - 3/01/07 - May also update Freight_ETA
	
	Select Weight, Ctn_Cnt into :ldExistWeight, :llExistCartonCount
	From Shipment
	Where Ship_no = :lsShipNo;
	
	ldExistWeight += ldWeight
	llExistCartonCount += llCartonCount
	
	Update Shipment
	Set Weight = :ldExistWeight, Est_weight = :ldWeight, Ctn_Cnt = :llExistCartonCount,
			Est_ctn_cnt = :llExistCartonCount, freight_etd = :ldtETD, Freight_ETA = :ldtETA
	Where Ship_no = :lsShipNo			// 03/28/07
	Using SQLCA;
	
	If sqlca.sqlcode <> 0 Then
		lsErrText = sqlca.sqlerrtext /*error text lost in rollback*/
		Execute Immediate "ROLLBACK" using SQLCA;
		Messagebox('Shipments',"Unable to save Updated Shipment Header record to database!~r~r" + lsErrtext)
		Return "-1"
	End If
	
End If /*Shipment Header didn't already exist */

//Create a Shipment_Line_Item record for each order Detail

//Get the max Shipment Line Item Number
//dts 02/24/06 Select Max(ship_line_no) into :llShipLineNo
Select Max(cast(ship_line_no as numeric)) into :llShipLineNo
From Shipment_Line_Item
Where Ship_no = :lsShipNo;

If isNull(llShipLineNo) Then llShipLineNo = 0

llRowCount = adw_detail.RowCOunt()
For llRowPos = 1 to llRowCount
	
	lsSku = adw_detail.GetItemString(llRowPos,'SKU')
	llOrderLineNo = adw_detail.GetItemNumber(llRowPos,'line_item_no')
	ldShipQty = adw_detail.GetItemNumber(llRowPos,'alloc_qty')
	ldPrice = adw_detail.GetItemNumber(llRowPos,'Price')
	
	llShipLineNo ++
	
	Insert Into Shipment_line_Item  (Ship_no, ship_line_No, SKU, Quantity, Price, Last_user, Last_Update, 
												Create_user, Create_USer_Date, Line_Item_Nbr, Invoice_no, RODO_No, Line_Item_No)
								Values	(:lsShipNo, :llShipLineNo, :lsSKU, :ldShipQty, :ldPrice, :gs_userid, :ldtToday,
												:gs_userid, :ldtToday, :llShipLineNo, :lsInvoice, :lsDoNo, :llOrderLineNo)
	Using SQLCA;

	If sqlca.sqlcode <> 0 Then
		lsErrText = sqlca.sqlerrtext /*error text lost in rollback*/
		Execute Immediate "ROLLBACK" using SQLCA;
		Messagebox('Shipments',"Unable to save Shipment Detail record to database!~r~r" + lsErrtext)
		Return "-1"
	End If

Next /* Next Order Detail */

//Commit the changes
Execute Immediate "COMMIT" using SQLCA;


Return lsShipNo /* RO/DO will open Shiment based on Ship ID returned */
end function

public function integer uf_add_inbound_order (ref datawindow adw_main, ref datawindow adw_detail, string asrono);
// Add Inbound orders to a shipment

//Add an inbound order from passed RO (asRONO) to Passed Shipment  (asShipNo)

Long	llRowCount, llRowPos, llShipLineNo, llOrderLineNo, llNewRow, llCartonCount, llExistCartonCount
Decimal	ldPrice, ldShipQty, ldWEight, ldExistWeight
String	lsShipNo, lsSKU, lsInvoiceNo, lsErrText
DateTime	ldtToday
DatawindowChild ldwc


// pvh 02.15.06 - gmt
ldtToday = f_getLocalWorldTime( gs_default_wh ) 

//If we have already added this DO_NO to the current shipment, get out
If adw_detail.Find("Upper(rodo_no) = '" + Upper(asRONO) + "'",1, adw_detail.RowCount()) > 0 Then Return 0

//add the selected Ro_NO to the current Shipment
If Not isvalid(idsDetail) Then
	idsDetail = Create Datastore
	idsDetail.dataobject = 'd_ship_ro_detail'
	idsDetail.SetTransObject(SQLCA)
End If

lsShipNo = adw_main.GetItemString(1,'ship_no')

Select Supp_Invoice_NO into :lsInvoiceNo
From Receive_Master where ro_no = :asroNo;

//We need the Max line Number
If adw_Detail.RowCount() > 0 Then
	adw_detail.Sort()
	llShipLineNo = adw_detail.GetITemNumber(adw_Detail.RowCount(),'Line_Item_Nbr')
Else
	llShipLineNo = 0
End IF

//Create a Shipment Line Record for each Delivery Detail Record
//Retrieve the Deliivery Detail records for this DO_NO
llRowCount = idsDetail.Retrieve(asrONo)
For llRowPos = 1 to llRowCount
	
	lsSKu = idsDetail.GetITemString(llRowPos,'SKU')
	llOrderLineNo = idsDetail.GetITemNumber(llRowPos,'line_item_no')
	ldShipQty = idsDetail.GetITemNumber(llRowPos,'req_qty')
	ldPrice = idsDetail.GetITemNumber(llRowPos,'Cost')
	
	llShipLineNo ++
	
	llNewRow = adw_Detail.InsertRow(0)
	adw_Detail.SetITem(llNewRow,'Ship_No',lsSHipNo)
	adw_Detail.SetITem(llNewRow,'ship_line_no',String(llShipLineNo))
	adw_Detail.SetITem(llNewRow,'SKU',lsSKU)
	adw_Detail.SetITem(llNewRow,'Quantity',ldShipQty)
	adw_Detail.SetITem(llNewRow,'Price',ldPrice)
	adw_Detail.SetITem(llNewRow,'LAst_User',gs_UserID)
	adw_Detail.SetITem(llNewRow,'LASt_Update',ldtToday)
	adw_Detail.SetITem(llNewRow,'Create_User',gs_UserID)
	adw_Detail.SetITem(llNewRow,'Create_User_date',ldtToday)
	adw_Detail.SetITem(llNewRow,'Line_Item_Nbr',llShipLineNo)
	adw_Detail.SetITem(llNewRow,'Invoice_No',lsInvoiceNo)
	adw_Detail.SetITem(llNewRow,'RODO_No',asRoNo)
	adw_Detail.SetITem(llNewRow,'Line_Item_No',llOrderLineNo)
	
Next /*Receive Detail Record */

////We need total weight and carton count and UOM -  add to current total
//Select Sum(weight_gross), Count(distinct Carton_no)  Into :ldWeight, :llCartonCount
//From Delivery_Packing
//Where do_no = :asDoNo;

//llExistCartonCount = adw_main.GetITemNumber(1,'est_ctn_cnt')
//If isnull(llExistCartonCount) Then llExistCartonCount = 0
//llCartonCount += llExistCartonCount
//adw_Main.SetItem(1,'est_ctn_cnt',llCartonCount)
//
//ldExistWeight = adw_main.GetITemDEcimal(1,'est_weight')
//If isnull(ldExistWeight) Then ldExistWeight = 0
//ldWeight += ldExistWEight
//adw_Main.SetItem(1,'est_weight',ldWeight)
	
REturn 0
end function

public function string uf_create_inbound_shipment (ref datawindow adw_main, ref datawindow adw_detail);// We will either update an existing Shipment based on Carrier/AWB/Zip Code or create a new one.

String	lsAWB, lsCarrier, lsRoNo, lsShipNo, lsWarehouse, lsSKU, lsInvoice,  lsUOM, lsTerms,	&
			lsFromName, LsFromaddr1, lsFromAddr2, lsFromAddr3, lsFromAddr4, lsFromCity, lsFromState,	&
			lsFromZip, lsFromCountry, lsFromContact, lsFromFax, lsFromTel, lsFromEmail,	&
			lsToName, LsToaddr1, lsToAddr2, lsToAddr3, lsToAddr4, lsToCity, lsToState,	&
			lsToZip, lsToCountry, lsToContact, lsToFax, lsToTel, lsToEmail, lsErrText

Long	llCount, llRowCount, llRowPos, llShipLineNo, llOrderLineNo, llID, llCartonCount, llExistCartonCount, llFindRow

Decimal	ldShipQty, ldPrice, ldWeight, ldExistWeight

DateTime	ldtToday, ldtETD


If adw_main.RowCount() <= 0 Then Return ''

lsInvoice = adw_main.GetItemString(1,'Supp_Invoice_No')
lsWarehouse = adw_main.GetItemString(1,'wh_Code')
// pvh 02.15.06 - gmt
ldtToday = f_getLocalWorldTime( lsWarehouse ) 

//
lsAWB = adw_main.GetItemString(1,'awb_bol_no')
lsCarrier = adw_main.GetItemString(1,'carrier')
//dts lsZip = adw_main.GetITemString(1,'Zip')
lsRoNo = adw_main.GetItemString(1,'ro_no')
//dts lsTerms = adw_main.GetITemString(1,'Freight_Terms')
//dts ldtETD = adw_main.GetITemDateTime(1,'Freight_ETD')

//Ship From address coming from supplier (What about Returns???)
lsFromName = adw_main.GetItemString(1,'supp_code') //use FromName to temporarily store supp_code...
Select Address_1, Address_2, Address_3, Address_4, City, State, Zip, Country, Tel, Fax, Contact_Person, Email_Address
into :lsFromAddr1, :lsFromAddr2, :lsFromAddr3, :lsFromAddr4, :lsFromCity, :lsFromState, :lsFromZip, :lsFromCountry, :lsFromTel, :lsFromFax, :lsFromContact, :lsFromEmail
from supplier 
Where project_id = :gs_project
and supp_code = :lsFromName
Using SQLCA;
lsFromName = adw_main.GetItemString(1,'supp_name')


//We may have already added this Order to a shipment previously.
lsShipNo = ''
//dts - what if there are no lines (due to error or otherwise)?
Select Max(ship_no) into :lsShipNo
from Shipment_line_item 
Where RODO_No = :lsRoNo
Using SQLCA;

//If shipment line exists, Return Shipment ID and DO/RO will open the Shipment Window
If lsShipNo > '' Then
	//messagebox ("TEMPO - u_nvo_shipments.uf_create_inbound", "Order already on shipment " +lsShipNo)
	Return lsShipNo
End If
//messagebox ("TEMPO - u_nvo_shipments.uf_create_inbound", "Order NOT already on shipment.")
//This order is not already on a shipment. We will either add this order to an existing shipment or create a new one.
lsShipNo = ''

//Validate that necessary fields are present before creating/Updating Shipment
//dts - now called from w_ro.ue_process_shipments (to occur before 'Save' prompt)
//If uf_validate_Inbound(adw_Main, adw_detail.RowCount()) < 0 Then Return "-1"

Select Max(Shipment.ship_no) into :lsShipNo
From Shipment, Shipment_Location
Where Shipment.ship_no = Shipment_location.Ship_no and Project_id = :gs_project and Carrier_code = :lsCarrier 
		and Awb_Bol_no = :lsAWB and Zip = :lsFromZip and Location_Type = 'O'  //dts - changed 'D' to 'O'
Using SQLCA;

//We need total weight and carton count and UOM - If we are updating an existing shipment header, we will add to current total
//Select Sum(weight_gross), Count(distinct Carton_no), Min(standard_of_measure) Into :ldWeight, :llCartonCount, :lsUOM
//From Delivery_Packing
/*dts - use Container_ID for inbound (instead of carton_no)?
 			- what about standard_of_measure?  */
Select Sum(weight_gross) Into :ldWeight //TEMPO- using-->, :llCartonCount, :lsUOM
from Receive_putaway
Where ro_no = :lsRoNo;
	
/*dts	
If lsUOM = 'E' Then /*English*/
	lsUOM = 'L' /*pounds*/
Else /*Metric*/
	lsUOM = 'K' /*Kilos*/
End If
*/

// If shipment doesn't exist, we will need to create a shipment header and location records first
If lsShipNo = '' or isnull(lsShipNo) Then
	
	//get the next available shipment ID
	llID = g.of_next_db_seq(gs_project,'Shipment','Ship_No')
	lsShipNO = gs_project + String(llID,'000000')
				
  /* dts 05/05/06 - no longer defaulting ord_satus to 'N'
     (thought to be 'New' but actually 'No paper work ...') */
	  
	 Execute Immediate "BEGIN TRANSACTION" using SQLCA;
	 
	Insert Into Shipment (Ship_No, wh_Code, Project_ID, Carrier_Code, Ord_date, est_Ctn_Cnt,  Est_weight,  Create_user_date,
								Create_User, Last_user, Last_Update, ord_Status_date, Ord_Status, Freight_terms, awb_bol_no, Ord_Type,
								Freight_etd,  Est_weight_Qualifier)
	Values					(:lsShipNo, :lsWarehouse, :gs_Project, :lsCarrier, :ldtToday, :llCartonCount, :ldWeight,  :ldtToday,
								:gs_userid, :gs_userid, :ldtToday, :ldtToday, 'NA', :lsTerms, :lsAWB, 'I',
								:ldtETD,  'G')
	Using SQLCA;
	
	If sqlca.sqlcode <> 0 Then
		lsErrText = sqlca.sqlerrtext /*error text lost in rollback*/
		Execute Immediate "ROLLBACK" using SQLCA;
		Messagebox('Shipments',"Unable to save Shipment Header record to database!~r~r" + lsErrtext)
		Return "-1"
	End If
	
	//Create the Destination Location (from WH)	
	//Warehouse address is available in Project Warehouse DS
	llFindRow = g.ids_project_warehouse.Find("Upper(wh_Code) = '" + Upper(lsWarehouse) + "'",1,g.ids_project_warehouse.RowCount())
	If llFindRow > 0 Then
		lsToName = g.ids_project_warehouse.getITemString(llFindRow,'wh_name')
		lsToAddr1 = g.ids_project_warehouse.getITemString(llFindRow,'Address_1')
		lsToAddr2 = g.ids_project_warehouse.getITemString(llFindRow,'Address_2')
		lsToAddr3 = g.ids_project_warehouse.getITemString(llFindRow,'Address_3')
		lsToAddr4 = g.ids_project_warehouse.getITemString(llFindRow,'Address_4')
		lsToCity = g.ids_project_warehouse.getITemString(llFindRow,'City')
		lsToState = g.ids_project_warehouse.getITemString(llFindRow,'State')
		lsToZip = g.ids_project_warehouse.getITemString(llFindRow,'Zip')
		lsToCountry = g.ids_project_warehouse.getITemString(llFindRow,'Country')
		lsToTel = g.ids_project_warehouse.getITemString(llFindRow,'Tel')
		lsToFax = g.ids_project_warehouse.getITemString(llFindRow,'Fax')
		lsToContact = g.ids_project_warehouse.getITemString(llFindRow,'Contact_Person')
		lsToEmail = g.ids_project_warehouse.getITemString(llFindRow,'Email_address')
	End If
	
	Insert Into Shipment_Location (Ship_No, Location_Type, Name, Address_1, address_2, Address_3, Address_4, City,
												State, Zip, Country, Contact_person, Fax, Tel, Email_address)
	Values								(:lsShipNo, 'D', :lsToName, :lsToaddr1, :lsToAddr2, :lsToAddr3, :lsToAddr4, :lsToCity, 
												:lsToState, :lsToZip, :lsToCountry, :lsToContact, :lsToFax, :lsToTel, :lsToEmail)
	Using SQLCA;
	
	If sqlca.sqlcode <> 0 Then
		lsErrText = sqlca.sqlerrtext /*error text lost in rollback*/
		Execute Immediate "ROLLBACK" using SQLCA;
		Messagebox('Shipments',"Unable to save Shipment Location (Destination) record to database!~r~r" + lsErrtext)
		Return "-1"
	End If
	
	//Create the Origin Location Address
	Insert Into Shipment_Location (Ship_No, Location_Type, Name, Address_1, address_2, Address_3, Address_4, City,
												State, Zip, Country, Contact_person, Fax, Tel)
	Values								(:lsShipNo, 'O', :lsFromName, :lsFromAddr1, :lsFromAddr2, :lsFromAddr3, :lsFromAddr4, :lsFromCity, 
												:lsFromState, :lsFromZip, :lsFromCountry, :lsFromContact, :lsFromFax, :lsFromTel)
	Using SQLCA;		
	
	If sqlca.sqlcode <> 0 Then
		lsErrText = sqlca.sqlerrtext /*error text lost in rollback*/
		Execute Immediate "ROLLBACK" using SQLCA;
		Messagebox('Shipments',"Unable to save Shipment Location (Origin) record to database!~r~r" + lsErrtext)
		Return "-1"
	End If
	
Else /* Shipment Exists - Add Weights and carton count to existing Shipment Header, update Freight ETD */
  
	Select Weight, Ctn_Cnt into :ldExistWeight, :llExistCartonCount
	From Shipment
	Where Ship_no = :lsShipNo;
	
	ldExistWeight += ldWeight
	llExistCartonCount += llCartonCount
	
	Update Shipment
	Set Weight = :ldExistWEight, Est_weight = :ldWeight, Ctn_Cnt = :llExistCartonCount,
			Est_ctn_cnt = :llExistCartonCount, freight_etd = :ldtetd
	Using SQLCA;
	
	If sqlca.sqlcode <> 0 Then
		lsErrText = sqlca.sqlerrtext /*error text lost in rollback*/
		Execute Immediate "ROLLBACK" using SQLCA;
		Messagebox('Shipments',"Unable to save Updated Shipment Header record to database!~r~r" + lsErrtext)
		Return "-1"
	End If
	
End If /*Shipment Header didn't already exist */

//Create a Shipment_Line_Item record for each order Detail

//Get the max Shipment Line Item Number
//dts 02/24/06 Select Max(ship_line_no) into :llShipLineNo
Select Max(cast(ship_line_no as numeric)) into :llShipLineNo
From Shipment_Line_Item
Where Ship_no = :lsShipNo;

If isNull(llShipLineNo) Then llShipLineNo = 0

// pvh 02.15.06 - gmt
ldtToday = f_getLocalWorldTime( lsWarehouse )

llRowCount = adw_detail.RowCOunt()
For llRowPos = 1 to llRowCount
	
	lsSKU = adw_detail.GetITemString(llRowPos,'SKU')
	llOrderLineNo = adw_detail.GetITemNumber(llRowPos,'line_item_no')
	ldShipQty = adw_detail.GetITemNumber(llRowPos,'alloc_qty')
	//ldPrice = adw_detail.GetITemNumber(llRowPos,'Price')
	ldPrice = adw_detail.GetITemNumber(llRowPos,'Cost')
	
	llShipLineNo ++

	Insert Into Shipment_line_Item  (Ship_no, ship_line_No, SKU, Quantity, Price, Last_user, Last_Update, 
												Create_user, Create_User_Date, Line_Item_Nbr, Invoice_No, RODO_No, Line_Item_No)
								Values	(:lsShipNo, :llShipLineNo, :lsSKU, :ldShipQty, :ldPrice, :gs_userid, :ldtToday,
												:gs_userid, :ldtToday, :llShipLineNo, :lsInvoice, :lsRoNo, :llOrderLineNo)
	Using SQLCA;

	If sqlca.sqlcode <> 0 Then
		lsErrText = sqlca.sqlerrtext /*error text lost in rollback*/
		Execute Immediate "ROLLBACK" using SQLCA;
		Messagebox('Shipments',"Unable to save Shipment Detail record to database!~r~r" + lsErrtext)
		Return "-1"
	End If

Next /* Next Order Detail */

//Commit the changes
Execute Immediate "COMMIT" using SQLCA;


Return lsSHipNo /* RO/DO will open Shiment based on Ship ID returned */
end function

public function integer uf_validate_inbound (ref datawindow adw_main, integer ai_details);string lsCarrier
integer liCarrier

if adw_Main.RowCount() = 0 then return 0

//AWB is required
If isNull(adw_Main.GetItemString(1,'awb_bol_no')) or adw_Main.GetItemString(1,'awb_bol_no') = '' Then
	Messagebox("Shipments","AWB/BOL NBR is required before creating a shipment!")
	adw_main.SetFocus()
	adw_main.SetColumn('awb_bol_no')
	Return -1
End If

//Carrier is required
lsCarrier = adw_Main.GetITemString(1,'Carrier')
If isNull(lsCarrier) or lsCarrier = '' Then
	Messagebox("Shipments","Carrier is required before creating a shipment!")
	adw_main.SetFocus()
	adw_main.SetColumn('Carrier')
	Return -1
else
	select count(carrier_code) into :liCarrier
	from carrier_master
	Where project_id = :gs_project
	and carrier_code = :lsCarrier
	Using SQLCA;

	If liCarrier < 1 Then	
		Messagebox("Shipments","Carrier must be set up in Carrier Table before creating a shipment!")
		adw_main.SetFocus()
		adw_main.SetColumn('Carrier')
		Return -1
	end if
End If

//Zip is required
/*
If isNull(adw_Main.GetITemString(1,'Zip')) or adw_Main.GetITemString(1,'Zip') = '' Then
	Messagebox("Shipments","Ship to Zip/Postal Code is required before creating a shipment!")
	adw_main.SetFocus()
	adw_main.SetColumn('Zip')
	Return -1
End If
*/

//Must have Detail Rows
If ai_Details = 0 Then
	Messagebox("Shipments","There must be Order Detail rows before creating a shipment!")
	Return -1
End If

Return 0
end function

public function boolean uf_nonworkday (date adt_date, string as_country);integer li_Count

//is the day in question a weekend?
if DayNumber(adt_date) = 1 or DayNumber(adt_date) = 7 then
	return true
else
	//is the day in question a holiday (for the destination country)?
	select count(holiday) into :li_Count
	from Country_Holidays
	where dest_country_code = :as_Country
//	where Project_id = :gs_Project
	//and wh_code = :a_WH
	//and dest_country_code = :a_Country
	and holiday = :adt_date
	using SQLCA;
	
	if li_count > 0 then
		return true
	else
		return false
	end if
end if
end function

public function date uf_get_eta (date adt_departuredate, string as_project, string as_wh, string as_carrier, string as_country, string as_zip);/*
adt_departuredate, as_project, as_wh, as_carrier, as_country, as_zip
Calculate the ETA (Estimated Time of Arrival) based on:
 - the departure date
 - Transit Time for the carrier to the particular Zip (or country default)
 - Holidays (for the destination country)
 - Departure Days to the destination country for the carrier
 
 - If no Transit Time record exists (for Project/WH/Carrier/Country/Zip)
     use Default Transit Time for Carrier-Country
 - If no Default Transit Time exists, prompt user to enter ETA
*/

Date ldt_Etd, ldt_Eta, ldt_Temp
integer li_TransitTime, li_Holidays, i
string ls_dono

ldt_Etd = date(adt_DepartureDate)


//find transit time for zip...
// 12345 should be found within '11' - '12' but it won't so string some '9's to zip_range_end
select Transit_Time into :li_TransitTime
from Transit_Time
where Project_id = :as_Project
and wh_code = :as_WH
and carrier_code = :as_Carrier
and country_code = :as_Country
and zip_range_start <= :as_zip and zip_range_end + '99999' >= :as_zip
Using SQLCA;

//if no TransitTime for zip, find default for carrier/country...
if li_TransitTime = 0 then
	select Default_Transit_Time into :li_TransitTime
	from Carrier_Country
	where Project_id = :as_Project
	and wh_code = :as_WH
	and carrier_code = :as_Carrier
	and country_code = :as_Country
	Using SQLCA;
end if

if li_TransitTime > 0 then
	//Add a day for Non Work Day (weekend day or dest. country holiday)
	/* Not adding day for holiday during transit time
		- just adding day if ETA is holiday */
	for i = 0 to li_TransitTime
		//if uf_NonWorkDay(RelativeDate(ldt_Etd, i), as_Country) then
		ldt_Temp = RelativeDate(ldt_Etd, i)
		if DayNumber(ldt_Temp) = 1 or DayNumber(ldt_Temp) = 7 then
			//is day in question a weekend? If so, add a day to Transit time
			li_TransitTime ++
		end if
	next

	ldt_Eta = RelativeDate(ldt_Etd, li_TransitTime)
	//is ETA a holiday? If so, find next workday...
	do while uf_NonWorkDay(ldt_Eta, as_Country)
		ldt_Eta = RelativeDate(ldt_Eta, 1)
	loop
else
//TEMPO!!! suppressed for fixing Shipment data	messagebox("Get ETA", "Can't Calculate ETA!~n~nYou must enter an ETA (on the Shipment) for Web Visibility (use the Freight ETA field).")
	setnull(ldt_Eta)
end if

return ldt_Eta


end function

public function integer uf_update_etd (string as_shipno, datetime adt_etd);update shipment
set freight_etd = :adt_ETD
where ship_no = :as_ShipNo
using sqlca;

return 0
end function

public function date uf_get_etd (date adt_start, string as_project, string as_wh, string as_carrier, string as_country);//set ETD to the next valid departure day for given date and carrier/country combo.
date ldt_ETD, ldtTemp
string lsSun, lsMon, lsTue, lsWed, lsThu, lsFri, lsSat
string lsDepartures
integer liDay, i

//select Depart_Sunday, Depart_Monday, Depart_Tuesday, Depart_Wednesday, Depart_Thursday, Depart_Friday, Depart_Saturday
//into :lsSun, :lsMon, :lsTue, :lsWed, :lsThu, :lsFri, :lsSat

/*string together the numeric representation of the valid departure days...
	- ?is Sunday always DayNumber 1 (for PB)? */
select 
 case when Depart_Sunday = 'y' then '1' else '' end
+ case when Depart_Monday = 'y' then '2' else '' end
+ case when Depart_Tuesday = 'y' then '3' else '' end
+ case when Depart_Wednesday = 'y' then '4' else '' end
+ case when Depart_Thursday = 'y' then '5' else '' end
+ case when Depart_Friday = 'y' then '6' else '' end
+ case when Depart_Saturday = 'y' then '7' else '' end
into :lsDepartures
from Carrier_Country
where Project_id = :as_Project
and wh_code = :as_WH
and carrier_code = :as_Carrier
and country_code = :as_Country
Using SQLCA;

//then find the next day whose DayNumber is in the string of valid departure days
if isnull(lsDepartures) or lsDepartures = "" then
	// if it's null, then there is no data for the carrer-country
	return adt_start
else
	ldtTemp = adt_Start
	ldt_ETD = ldtTemp
	i = 7
	do while i > 0
		liDay = DayNumber(ldtTemp)
		if pos(lsDepartures, string(liDay)) > 0 then
			ldt_ETD = ldtTemp
			i = 0
		else
			ldtTemp = RelativeDate(ldtTemp, 1)
		end if
		i = i -1
	loop
	//warning: not bumping for holiday (origin or destination)
	return ldt_ETD
end if


end function

public function integer uf_add_outbound_order (ref datawindow adw_main, ref datawindow adw_detail, string asdono);//Add an outbound order from passed DO (asONO) to Passed Shipment  (asShipNo)

Long	llRowCount, llRowPos, llShipLineNo, llOrderLineNo, llNewRow, llCartonCount, llExistCartonCount
Decimal	ldPrice, ldShipQty, ldWeight, ldExistWeight
String	lsShipNo, lsSKU, lsInvoiceNo, lsErrText
DateTime	ldtToday
DatawindowChild ldwc

// pvh 02.15.06 - gmt
ldtToday = f_getLocalWorldTime( gs_default_wh ) 

//If we have already added this DO_NO to the current shipment, get out
If adw_detail.Find("Upper(rodo_no) = '" + Upper(asDONO) + "'",1, adw_detail.RowCount()) > 0 Then Return 0

//add the selected do_NO to the current Shipment
If Not isvalid(idsDetail) Then
	idsDetail = Create Datastore
	idsDetail.dataobject = 'd_ship_do_detail'
	idsDetail.SetTransObject(SQLCA)
End If

lsShipNo = adw_main.GetItemString(1,'ship_no')

Select Invoice_NO into :lsInvoiceNo
From Delivery_Master where do_no = :asDoNo;

//We need the Max line Number
If adw_Detail.RowCount() > 0 Then
	adw_detail.Sort()
	llShipLineNo = adw_detail.GetItemNumber(adw_Detail.RowCount(),'Line_Item_Nbr')
Else
	llShipLineNo = 0
End IF

//Create a Shipment Line Record for each Delivery Detail Record
//Retrieve the Deliivery Detail records for this DO_NO
llRowCount = idsDetail.Retrieve(asDONo)
For llRowPos = 1 to llRowCount
	
	lsSKU = idsDetail.GetItemString(llRowPos,'SKU')
	llOrderLineNo = idsDetail.GetItemNumber(llRowPos,'line_item_no')
	ldShipQty = idsDetail.GetItemNumber(llRowPos,'alloc_qty')
	ldPrice = idsDetail.GetItemNumber(llRowPos,'Price')
	
	llShipLineNo ++
	
	llNewRow = adw_Detail.InsertRow(0)
	adw_Detail.SetItem(llNewRow,'Ship_No',lsSHipNo)
	adw_Detail.SetItem(llNewRow,'ship_line_no',String(llShipLineNo))
	adw_Detail.SetItem(llNewRow,'SKU',lsSKU)
	adw_Detail.SetItem(llNewRow,'Quantity',ldShipQty)
	adw_Detail.SetItem(llNewRow,'Price',ldPrice)
	adw_Detail.SetItem(llNewRow,'LAst_User',gs_UserID)
	adw_Detail.SetItem(llNewRow,'LASt_Update',ldtToday)
	adw_Detail.SetItem(llNewRow,'Create_User',gs_UserID)
	adw_Detail.SetItem(llNewRow,'Create_User_date',ldtToday)
	adw_Detail.SetItem(llNewRow,'Line_Item_Nbr',llShipLineNo)
	adw_Detail.SetItem(llNewRow,'Invoice_No',lsInvoiceNo)
	adw_Detail.SetItem(llNewRow,'RODO_No',asDoNo)
	adw_Detail.SetItem(llNewRow,'Line_Item_No',llOrderLineNo)
	
Next /*Delivery Detail Record */

//We need total weight and carton count and UOM -  add to current total
Select Sum(weight_gross), Count(distinct Carton_no)  Into :ldWeight, :llCartonCount
From Delivery_Packing
Where do_no = :asDoNo;

llExistCartonCount = adw_main.GetITemNumber(1,'est_ctn_cnt')
If isnull(llExistCartonCount) Then llExistCartonCount = 0
llCartonCount += llExistCartonCount
adw_Main.SetItem(1,'est_ctn_cnt',llCartonCount)

ldExistWeight = adw_main.GetItemDecimal(1,'est_weight')
If isnull(ldExistWeight) Then ldExistWeight = 0
ldWeight += ldExistWEight
adw_Main.SetItem(1,'est_weight',ldWeight)
	
Return 0
end function

public function integer uf_add_outbound_orderlevel (ref datawindow adw_main, ref datawindow adw_outbound_orderlevel, string asdono);//Add an outbound order from passed DO (asONO) to Passed Shipment  (asShipNo)

Long	llRowCount, llRowPos, llShipLineNo, llOrderLineNo, llNewRow, llCartonCount, llExistCartonCount
Decimal	ldPrice, ldShipQty, ldWeight, ldExistWeight
String		lsShipNo, lsSKU, lsInvoiceNo, lsErrText
String 		lsOrd_status, lsOtm_status
DateTime	ldtToday
DatawindowChild ldwc

// pvh 02.15.06 - gmt
ldtToday = f_getLocalWorldTime( gs_default_wh ) 

//If we have already added this DO_NO to the current shipment, get out
If adw_outbound_orderlevel.Find("Upper(rodo_no) = '" + Upper(asDONO) + "'",1, adw_outbound_orderlevel.RowCount()) > 0 Then Return 0

//add the selected do_NO to the current Shipment
If Not isvalid(idsDetail) Then
	idsOrder = Create Datastore
	idsOrder.dataobject = 'd_ship_do_orderlevel'
	idsOrder.SetTransObject(SQLCA)
End If

lsShipNo = adw_main.GetItemString(1,'ship_no')
////Jxlim 01/03/2012 BRD #337
//If 		gs_project = 'PANDORA' Then
//		Select 	Invoice_NO, Otm_status
//			Into   :lsInvoiceNo, :lsOtm_status
//		From		Delivery_Master where do_no = :asDoNo;
//Else
//	Select Invoice_NO into :lsInvoiceNo
//	From Delivery_Master where do_no = :asDoNo;
//End If

//We need the Max line Number
If adw_outbound_orderlevel.RowCount() > 0 Then
	adw_outbound_orderlevel.Sort()
	//llShipLineNo = adw_outbound_orderlevel.GetItemNumber(adw_outbound_orderlevel.RowCount(),'Line_Item_Nbr')   //Jxlim BRD #337
	llShipLineNo = adw_outbound_orderlevel.GetItemNumber(adw_outbound_orderlevel.RowCount(),'Ship_Line_Nbr')
Else
	llShipLineNo = 0
End IF

//Create a Shipment Line Record for each Delivery Detail Record
//Retrieve the Deliivery Detail records for this DO_NO
llRowCount = idsOrder.Retrieve(asDONo)
For llRowPos = 1 to llRowCount	
	lsInvoiceNo = idsOrder.GetItemString(llRowPos,'Invoice_no')
	lsOrd_status = idsOrder.GetItemString(llRowPos,'Ord_status')
	lsOtm_status = idsOrder.GetItemString(llRowPos,'Otm_status')	
	llShipLineNo ++	
	
	llNewRow = adw_outbound_orderlevel.InsertRow(0)
	adw_outbound_orderlevel.SetItem(llNewRow,'Ship_No',lsSHipNo)
	adw_outbound_orderlevel.SetItem(llNewRow,'ship_line_nbr',String(llShipLineNo))
	adw_outbound_orderlevel.SetItem(llNewRow,'Invoice_No',lsInvoiceNo)
	adw_outbound_orderlevel.SetItem(llNewRow,'RODO_No',asDoNo)
	adw_outbound_orderlevel.SetItem(llNewRow,'Ord_status',lsOrd_status)
	adw_outbound_orderlevel.SetItem(llNewRow,'Otm_status',lsOtm_status)	
Next /*Delivery Order Record */

//We need total weight and carton count and UOM -  add to current total
Select Sum(weight_gross), Count(distinct Carton_no)  Into :ldWeight, :llCartonCount
From Delivery_Packing
Where do_no = :asDoNo;

llExistCartonCount = adw_main.GetITemNumber(1,'est_ctn_cnt')
If isnull(llExistCartonCount) Then llExistCartonCount = 0
llCartonCount += llExistCartonCount
adw_Main.SetItem(1,'est_ctn_cnt',llCartonCount)

ldExistWeight = adw_main.GetItemDecimal(1,'est_weight')
If isnull(ldExistWeight) Then ldExistWeight = 0
ldWeight += ldExistWEight
adw_Main.SetItem(1,'est_weight',ldWeight)
	
Return 0
end function

on u_nvo_shipments.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_nvo_shipments.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

