$PBExportHeader$w_exportordertest.srw
forward
global type w_exportordertest from window
end type
type cb_refresh from commandbutton within w_exportordertest
end type
type rb_3 from radiobutton within w_exportordertest
end type
type rb_2 from radiobutton within w_exportordertest
end type
type rb_other from radiobutton within w_exportordertest
end type
type rb_test from radiobutton within w_exportordertest
end type
type rb_dev from radiobutton within w_exportordertest
end type
type sle_2 from singlelineedit within w_exportordertest
end type
type st_3 from statictext within w_exportordertest
end type
type rb_delivery from radiobutton within w_exportordertest
end type
type rb_receive from radiobutton within w_exportordertest
end type
type st_2 from statictext within w_exportordertest
end type
type cb_verify from commandbutton within w_exportordertest
end type
type cb_close from commandbutton within w_exportordertest
end type
type st_1 from statictext within w_exportordertest
end type
type sle_1 from singlelineedit within w_exportordertest
end type
type cb_submit from commandbutton within w_exportordertest
end type
type gb_2 from groupbox within w_exportordertest
end type
type gb_3 from groupbox within w_exportordertest
end type
type gb_1 from groupbox within w_exportordertest
end type
type datastore_1 from datastore within w_exportordertest
end type
end forward

global type w_exportordertest from window
integer width = 2322
integer height = 1964
boolean titlebar = true
string title = "Import Orders from PROD"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
event ue_postopen ( )
cb_refresh cb_refresh
rb_3 rb_3
rb_2 rb_2
rb_other rb_other
rb_test rb_test
rb_dev rb_dev
sle_2 sle_2
st_3 st_3
rb_delivery rb_delivery
rb_receive rb_receive
st_2 st_2
cb_verify cb_verify
cb_close cb_close
st_1 st_1
sle_1 sle_1
cb_submit cb_submit
gb_2 gb_2
gb_3 gb_3
gb_1 gb_1
datastore_1 datastore_1
end type
global w_exportordertest w_exportordertest

type variables
transaction itr_Prod ,  itr_Test
string  is_sysno,is_invno

end variables

forward prototypes
public function integer of_copysupplier (string ls_prdsuppcode)
public function integer of_copyitemmaster (string ls_prdsku, string ls_prdsuppcode)
public function integer of_copyreceivemaster (string ls_rono)
public function integer of_copyreceivedetail (string ls_rono, string ls_status)
public function integer of_copywarehouse (string ls_wh_code)
public function integer of_copyitemgroup (string ls_grp)
public function integer of_copydeliverymaster (string ls_dono)
public function integer of_copydeliverydetail (string ls_dono, string ls_status)
public function integer of_copyowner (long ll_prdownerid)
public subroutine of_connect ()
public subroutine of_disconnect ()
public function integer of_copylocation (string ls_lcode, string ls_wh_code)
public function integer of_roprocess ()
public function integer of_doprocess ()
public function integer of_copycontent (string ls_prdsku, string ls_prdsuppcode, string ls_prdwh_code)
public subroutine of_connect_target ()
end prototypes

public function integer of_copysupplier (string ls_prdsuppcode);
string ls_projectid,ls_suppcode,ls_suppname,ls_addr1,ls_addr2,ls_addr3,ls_addr4,ls_city,ls_state,ls_zip,ls_country,ls_con_person,ls_tel
string ls_fax,ls_email,ls_remark,ls_export,ls_harmonized,ls_vat,ls_user1,ls_user2,ls_user3,ls_luser,ls_lupdate,ls_user4,ls_user5,ls_user6
string ls_dwg_upload,ls_dwg_upload_time

String ls_sql, ls_syntax, dwsyntax_str,lsErrText,presentation_str
integer li_count
Long ll_row

Datetime		ldToday
ldToday = f_getLocalWorldTime( gs_default_wh ) 

DataStore lds_copysupplier

SELECT COUNT(*) INTO :li_count
FROM SUPPLIER
WHERE PROJECT_ID = :gs_project
AND SUPP_CODE =:LS_PRDSUPPCODE
using itr_test;

IF li_count =0 THEN
	
	presentation_str = "style(type=grid)"
	lds_copysupplier = CREATE datastore
	ls_sql =   " SELECT PROJECT_ID,SUPP_CODE,SUPP_NAME,ADDRESS_1,ADDRESS_2,ADDRESS_3,ADDRESS_4,CITY,STATE,ZIP," &
				+"COUNTRY,CONTACT_PERSON,TEL,FAX,EMAIL_ADDRESS,REMARK,EXPORT_CONTROL_COMMODITY_NO,HARMONIZED_CODE," &
				+"VAT_ID,USER_FIELD1,USER_FIELD2,USER_FIELD3,LAST_USER,LAST_UPDATE,USER_FIELD4,USER_FIELD5,USER_FIELD6,"&
				+"DWG_UPLOAD,DWG_UPLOAD_TIMESTAMP "
	ls_sql += " FROM dbo.SUPPLIER "
	ls_sql += " WHERE project_id = '" + gs_project + "' "
	ls_sql += " AND SUPP_CODE = '" + LS_PRDSUPPCODE + "' "

	dwsyntax_str = SQLCA.SyntaxFromSQL(ls_sql, presentation_str, lsErrText)
	lds_copysupplier.Create( dwsyntax_str, lsErrText)
	lds_copysupplier.SetTransObject(itr_prod);	


IF lsErrText <> '' THEN
MessageBox( 'Error...', lsErrText )
RETURN 1
END IF

lds_copysupplier.Retrieve( )

FOR ll_row = 1 TO lds_copysupplier.RowCount( )
ls_projectid = lds_copysupplier.GetItemString( ll_row, 'PROJECT_ID' )
ls_suppcode = lds_copysupplier.GetItemString( ll_row, 'SUPP_CODE' )
ls_suppname = lds_copysupplier.GetItemString( ll_row, 'SUPP_NAME' )
ls_addr1 = lds_copysupplier.GetItemString( ll_row, 'ADDRESS_1' )
ls_addr2 = lds_copysupplier.GetItemString( ll_row, 'ADDRESS_2' )
ls_addr3 = lds_copysupplier.GetItemString( ll_row, 'ADDRESS_3' )
ls_addr4 = lds_copysupplier.GetItemString( ll_row, 'ADDRESS_4' )
ls_city = lds_copysupplier.GetItemString( ll_row, 'CITY' )
ls_state = lds_copysupplier.GetItemString( ll_row, 'STATE' )
ls_zip = lds_copysupplier.GetItemString( ll_row, 'ZIP' )
ls_country = lds_copysupplier.GetItemString( ll_row, 'COUNTRY' )
ls_con_person = lds_copysupplier.GetItemString( ll_row, 'CONTACT_PERSON' )
ls_tel = lds_copysupplier.GetItemString( ll_row, 'TEL' )
ls_fax = lds_copysupplier.GetItemString( ll_row, 'FAX' )
ls_email = lds_copysupplier.GetItemString( ll_row, 'EMAIL_ADDRESS' )
ls_remark = lds_copysupplier.GetItemString( ll_row, 'REMARK' )
ls_export = lds_copysupplier.GetItemString( ll_row, 'EXPORT_CONTROL_COMMODITY_NO' )
ls_harmonized = lds_copysupplier.GetItemString( ll_row, 'HARMONIZED_CODE' )
ls_vat = lds_copysupplier.GetItemString( ll_row, 'VAT_ID' )
ls_user1 = lds_copysupplier.GetItemString( ll_row, 'USER_FIELD1' )
ls_user2 = lds_copysupplier.GetItemString( ll_row, 'USER_FIELD2' )
ls_user3 = lds_copysupplier.GetItemString( ll_row, 'USER_FIELD3' )
ls_luser = lds_copysupplier.GetItemString( ll_row, 'LAST_USER' )

ls_user4 = lds_copysupplier.GetItemString( ll_row, 'USER_FIELD4' )
ls_user5 = lds_copysupplier.GetItemString( ll_row, 'USER_FIELD5' )
ls_user6 = lds_copysupplier.GetItemString( ll_row, 'USER_FIELD6' )
ls_dwg_upload = lds_copysupplier.GetItemString( ll_row, 'DWG_UPLOAD' )

	INSERT INTO SUPPLIER (
			PROJECT_ID,SUPP_CODE,SUPP_NAME,ADDRESS_1,ADDRESS_2,ADDRESS_3,ADDRESS_4,CITY,STATE,ZIP,
			COUNTRY,CONTACT_PERSON,TEL,FAX,EMAIL_ADDRESS,REMARK,EXPORT_CONTROL_COMMODITY_NO,HARMONIZED_CODE,
			VAT_ID,USER_FIELD1,USER_FIELD2,USER_FIELD3,LAST_USER,LAST_UPDATE,USER_FIELD4,USER_FIELD5,USER_FIELD6,
			DWG_UPLOAD,DWG_UPLOAD_TIMESTAMP )
	VALUES (:ls_projectid,:ls_suppcode,:ls_suppname,:ls_addr1,:ls_addr2,:ls_addr3,:ls_addr4,:ls_city,:ls_state,:ls_zip,:ls_country,:ls_con_person,:ls_tel,
			 :ls_fax,:ls_email,:ls_remark,:ls_export,:ls_harmonized,:ls_vat,:ls_user1,:ls_user2,:ls_user3,:ls_luser,:ldToday,:ls_user4,:ls_user5,:ls_user6,
			 :ls_dwg_upload,:ldToday)
	USING itr_test;


if itr_test.sqlcode = -1 then
	messagebox("Database Error",itr_test.sqlerrtext,Exclamation!)
rollback;
return -1
else
commit;
end if


st_2.Text = st_2.Text + 'r' + "Record is inserted into Supplier with supp_code  " + ls_suppcode
NEXT
DESTROY lds_copysupplier
END IF

return 1
end function

public function integer of_copyitemmaster (string ls_prdsku, string ls_prdsuppcode);string ls_projectid,ls_sku,ls_suppcode,ls_owner,ls_countryoforigin,ls_desc,ls_ownertype,ls_owner_cd,ls_luser
string ls_uom1,ls_uom2,ls_uom3,ls_uom4,ls_ltype,ls_lcode
string ls_hscode,ls_taxcode,ls_userfield1,ls_userfield2,ls_userfield3,ls_userfield4,ls_userfield5,ls_userfield6,ls_userfield7
string ls_userfield8,ls_userfield9,ls_lastuser,ls_grp,ls_altsku
string ls_lotcontrol,ls_pocontrol,ls_pono2control,ls_serialized,ls_component,ls_stdofmeasuer
string ls_Hazard_Text_Cd,ls_Hazard_Cd,ls_Hazard_Class,ls_itemdelind
string ls_Expiration_Controlled_Ind,ls_Inventory_Class,ls_Storage_Code,ls_Container_Tracking_Ind,ls_Freight_Class
string ls_Expiration_Tracking_Type,ls_Component_Type,ls_User_Field10,ls_User_Field11,ls_User_Field12,ls_User_Field13,ls_User_Field14,ls_User_Field15
string ls_User_Field16,ls_User_Field17,ls_User_Field18,ls_User_Field19,ls_User_Field20
string ls_QA_Check_Ind,ls_CC_Group_Code,ls_CC_Class_Code,ls_Last_CC_No,ls_Interface_Upd_Req_Ind,ls_DWG_Upload
string ls_Native_Description,ls_No_Of_Children_For_Parent,ls_Create_User

long ll_stdcost,ll_stdcostold,ll_avg,ll_ownerid,ll_cctriqty
long ll_length1,ll_width1,ll_height1,ll_weight1,ll_qty1
long ll_length2,ll_width2,ll_height2,ll_weight2,ll_qty2
long ll_length3,ll_width3,ll_height3,ll_weight3,ll_qty3
long ll_length4,ll_width4,ll_height4,ll_weight4,ll_qty4

int li_ccfreq,li_shelf,li_packwght,li_unpackwght,li_altprice,li_Flash_Point,li_Part_UPC_Code,li_count

Datetime ld_Last_Cycle_Cnt_Date,ld_Marl_Change_Date,ld_Quality_Hold_Change_Date,ldToday


ldToday = f_getLocalWorldTime( gs_default_wh ) 

SELECT  COUNT(*) into :li_count
FROM ITEM_MASTER
WHERE PROJECT_ID = :gs_project
AND   SKU		 = :ls_prdsku
AND   Supp_Code	 = :ls_prdsuppcode
using itr_test;

IF li_count =0 THEN
	SELECT PROJECT_ID,SKU,SUPP_CODE, Owner_Id ,COUNTRY_OF_ORIGIN_DEFAULT,DESCRIPTION, STD_COST, STD_COST_OLD,
			AVG_COST,  UOM_1,   LENGTH_1,   WIDTH_1,   HEIGHT_1,   WEIGHT_1,   UOM_2,   LENGTH_2,   WIDTH_2,   HEIGHT_2,   WEIGHT_2,
			QTY_2,   UOM_3,   LENGTH_3,   WIDTH_3,   HEIGHT_3,   WEIGHT_3,   QTY_3,   UOM_4,   LENGTH_4,   WIDTH_4,   HEIGHT_4,   WEIGHT_4,   QTY_4,
			L_TYPE,   L_CODE,   CC_FREQ,   CC_TRIGGER_QTY,   SHELF_LIFE,   HS_CODE,   TAX_CODE,   USER_FIELD1,   USER_FIELD2,   USER_FIELD3,   USER_FIELD4,   USER_FIELD5,
			USER_FIELD6,  USER_FIELD7,   USER_FIELD8,   USER_FIELD9,   LAST_USER,      GRP,   PACKAGED_WEIGHT,   UNPACKAGED_WEIGHT,   ALTERNATE_SKU, 
			ALTERNATE_PRICE,  LOT_CONTROLLED_IND,   PO_CONTROLLED_IND,   PO_NO2_CONTROLLED_IND,   SERIALIZED_IND,   COMPONENT_IND,   STANDARD_OF_MEASURE,
			ITEM_DELETE_IND,   LAST_CYCLE_CNT_DATE,   HAZARD_TEXT_CD,   HAZARD_CD,   HAZARD_CLASS,   FLASH_POINT,   EXPIRATION_CONTROLLED_IND,
			INVENTORY_CLASS,  STORAGE_CODE,   CONTAINER_TRACKING_IND,   FREIGHT_CLASS,   PART_UPC_CODE,   EXPIRATION_TRACKING_TYPE,   COMPONENT_TYPE,   USER_FIELD10,
			USER_FIELD11,   USER_FIELD12,   USER_FIELD13,   USER_FIELD14,   USER_FIELD15,   USER_FIELD16,   USER_FIELD17,   USER_FIELD18,   USER_FIELD19,
			USER_FIELD20,   MARL_CHANGE_DATE,   QUALITY_HOLD_CHANGE_DATE,   QA_CHECK_IND,   CC_GROUP_CODE,   CC_CLASS_CODE,   LAST_CC_NO,   INTERFACE_UPD_REQ_IND,
			DWG_UPLOAD,      NATIVE_DESCRIPTION,   CREATE_USER,    NO_OF_CHILDREN_FOR_PARENT
	
	INTO :ls_projectid,:ls_sku,:ls_suppcode,:ll_ownerid,:ls_countryoforigin,:ls_desc,:ll_stdcost,:ll_stdcostold,:ll_avg,
			:ls_uom1,:ll_length1,:ll_width1,:ll_height1,:ll_weight1,:ls_uom2,:ll_length2,:ll_width2,:ll_height2,:ll_weight2,:ll_qty2,:ls_uom3,
			:ll_length3,:ll_width3,:ll_height3,:ll_weight3,:ll_qty3,:ls_uom4,:ll_length4,:ll_width4,:ll_height4,:ll_weight4,:ll_qty4,:ls_ltype,:ls_lcode,
 			:li_ccfreq,:ll_cctriqty,:li_shelf,:ls_hscode,:ls_taxcode,:ls_userfield1,:ls_userfield2,:ls_userfield3,:ls_userfield4,:ls_userfield5,
			:ls_userfield6,:ls_userfield7,:ls_userfield8,:ls_userfield9,:ls_lastuser,:ls_grp,:li_packwght,:li_unpackwght,:ls_altsku,:li_altprice,
			:ls_lotcontrol,:ls_pocontrol,:ls_pono2control,:ls_serialized,:ls_component,:ls_stdofmeasuer,:ls_itemdelind,:ld_Last_Cycle_Cnt_Date,:ls_Hazard_Text_Cd,:ls_Hazard_Cd,:ls_Hazard_Class,
			:li_Flash_Point,:ls_Expiration_Controlled_Ind,:ls_Inventory_Class,:ls_Storage_Code,:ls_Container_Tracking_Ind,:ls_Freight_Class,:li_Part_UPC_Code,
			:ls_Expiration_Tracking_Type,:ls_Component_Type,:ls_User_Field10,:ls_User_Field11,:ls_User_Field12,:ls_User_Field13,:ls_User_Field14,:ls_User_Field15,
			:ls_User_Field16,:ls_User_Field17,:ls_User_Field18,:ls_User_Field19,:ls_User_Field20,:ld_Marl_Change_Date,:ld_Quality_Hold_Change_Date,:ls_QA_Check_Ind,:ls_CC_Group_Code,:ls_CC_Class_Code,:ls_Last_CC_No,:ls_Interface_Upd_Req_Ind,
			:ls_DWG_Upload,:ls_Native_Description,:ls_Create_User,:ls_No_Of_Children_For_Parent
				
	
	FROM Item_Master
	WHERE project_id =:gs_project
	AND sku =:ls_prdsku 
	AND supp_code =:ls_prdsuppcode
using itr_Prod;

long ll_owner_id
select max (owner_id)  into :ll_owner_id
from owner
where  DWG_UPLOAD ='X'
and project_id =:gs_project
using itr_Test;


IF ll_owner_id <> ll_ownerid THEN
	ll_ownerid =ll_owner_id
END IF

	INSERT INTO ITEM_MASTER 
		(PROJECT_ID,SKU,   SUPP_CODE, Owner_Id ,   COUNTRY_OF_ORIGIN_DEFAULT,   DESCRIPTION,   STD_COST,  STD_COST_OLD,   
		AVG_COST,  UOM_1,   LENGTH_1,   WIDTH_1,   HEIGHT_1,   WEIGHT_1,   UOM_2,   LENGTH_2,   WIDTH_2,   HEIGHT_2,   WEIGHT_2,   
		QTY_2,   UOM_3,   LENGTH_3,   WIDTH_3,   HEIGHT_3,   WEIGHT_3,   QTY_3,   UOM_4,   LENGTH_4,   WIDTH_4,   HEIGHT_4,   WEIGHT_4,   QTY_4,   
		L_TYPE,   L_CODE,   CC_FREQ,   CC_TRIGGER_QTY,   SHELF_LIFE,   HS_CODE,   TAX_CODE,   USER_FIELD1,   USER_FIELD2,   USER_FIELD3,   USER_FIELD4,   USER_FIELD5,   
		USER_FIELD6,  USER_FIELD7,   USER_FIELD8,   USER_FIELD9,   LAST_USER,   LAST_UPDATE,   GRP,   PACKAGED_WEIGHT,   UNPACKAGED_WEIGHT,   ALTERNATE_SKU,   
		ALTERNATE_PRICE,  LOT_CONTROLLED_IND,   PO_CONTROLLED_IND,   PO_NO2_CONTROLLED_IND,   SERIALIZED_IND,   COMPONENT_IND,   STANDARD_OF_MEASURE,   
		ITEM_DELETE_IND,   LAST_CYCLE_CNT_DATE,   HAZARD_TEXT_CD,   HAZARD_CD,   HAZARD_CLASS,   FLASH_POINT,   EXPIRATION_CONTROLLED_IND,   
		INVENTORY_CLASS,  STORAGE_CODE,   CONTAINER_TRACKING_IND,   FREIGHT_CLASS,   PART_UPC_CODE,   EXPIRATION_TRACKING_TYPE,   COMPONENT_TYPE,   USER_FIELD10,   
		USER_FIELD11,   USER_FIELD12,   USER_FIELD13,   USER_FIELD14,   USER_FIELD15,   USER_FIELD16,   USER_FIELD17,   USER_FIELD18,   USER_FIELD19,   
		USER_FIELD20,   MARL_CHANGE_DATE,   QUALITY_HOLD_CHANGE_DATE,   QA_CHECK_IND,   CC_GROUP_CODE,   CC_CLASS_CODE,   LAST_CC_NO,   INTERFACE_UPD_REQ_IND,   
		DWG_UPLOAD,   DWG_UPLOAD_TIMESTAMP,   NATIVE_DESCRIPTION,   CREATE_USER,   CREATE_TIME ,NO_OF_CHILDREN_FOR_PARENT)

	values (:ls_projectid,:ls_sku,:ls_suppcode,:ll_ownerid,:ls_countryoforigin,:ls_desc,:ll_stdcost,:ll_stdcostold,:ll_avg,
		:ls_uom1,:ll_length1,:ll_width1,:ll_height1,:ll_weight1,:ls_uom2,:ll_length2,:ll_width2,:ll_height2,:ll_weight2,:ll_qty2,:ls_uom3,
		:ll_length3,:ll_width3,:ll_height3,:ll_weight3,:ll_qty3,:ls_uom4,:ll_length4,:ll_width4,:ll_height4,:ll_weight4,:ll_qty4,:ls_ltype,:ls_lcode,
		:li_ccfreq,:ll_cctriqty,:li_shelf,:ls_hscode,:ls_taxcode,:ls_userfield1,:ls_userfield2,:ls_userfield3,:ls_userfield4,:ls_userfield5,
		:ls_userfield6,:ls_userfield7,:ls_userfield8,:ls_userfield9,:ls_lastuser,:ldToday,:ls_grp,:li_packwght,:li_unpackwght,:ls_altsku,:li_altprice,
		:ls_lotcontrol,:ls_pocontrol,:ls_pono2control,:ls_serialized,:ls_component,:ls_stdofmeasuer,:ls_itemdelind,:ld_Last_Cycle_Cnt_Date,:ls_Hazard_Text_Cd,:ls_Hazard_Cd,:ls_Hazard_Class,
		:li_Flash_Point,:ls_Expiration_Controlled_Ind,:ls_Inventory_Class,:ls_Storage_Code,:ls_Container_Tracking_Ind,:ls_Freight_Class,:li_Part_UPC_Code,
		:ls_Expiration_Tracking_Type,:ls_Component_Type,:ls_User_Field10,:ls_User_Field11,:ls_User_Field12,:ls_User_Field13,:ls_User_Field14,:ls_User_Field15,
		:ls_User_Field16,:ls_User_Field17,:ls_User_Field18,:ls_User_Field19,:ls_User_Field20,:ld_Marl_Change_Date,:ld_Quality_Hold_Change_Date,:ls_QA_Check_Ind,:ls_CC_Group_Code,:ls_CC_Class_Code,:ls_Last_CC_No,:ls_Interface_Upd_Req_Ind,
		:ls_DWG_Upload,:ldToday,:ls_Native_Description,:gs_userid,:ldToday,:ls_No_Of_Children_For_Parent)
USING itr_Test;

if itr_test.sqlcode = -1 then
	messagebox("Database Error",itr_test.sqlerrtext,Exclamation!)
rollback;
return -1;
else
commit;
end if
st_2.Text = st_2.Text + 'r' +  "Record is inserted into Item_Master with the combination of  sku  " + ls_prdsku +" and suppcode"+ls_prdsuppcode


END IF

IF li_count > 0 THEN

select max(owner_id)  into :ll_owner_id
from owner
where  DWG_UPLOAD ='X'
and project_id =:gs_project
using itr_Test;

UPDATE item_master set owner_id =:ll_owner_id WHERE project_id =:gs_project
	AND sku =:ls_prdsku 	AND supp_code =:ls_prdsuppcode
using itr_Test;

END IF
return 1
end function

public function integer of_copyreceivemaster (string ls_rono);string ls_project_Id,ls_Ord_Status,ls_Ord_Type,ls_Inventory_Type,ls_WH_Code
string ls_Supp_Code,ls_Supp_Order_No,ls_Supp_Invoice_No,ls_Ship_Via,ls_Ship_Ref,ls_Remark
string ls_User_Field1,ls_User_Field2,ls_User_Field3,ls_User_Field4,ls_User_Field5,ls_User_Field6,ls_User_Field7,ls_User_Field8,ls_Agent_Info,ls_Carrier_Tracking_No
string ls_Customs_Doc,ls_Export_Control_Commodity_No,ls_Harmonized_Code,ls_Transport_Mode,ls_VAT_Id,ls_Last_User
string ls_Carrier,ls_Awb_Bol_No,ls_Standard_Of_Measure,ls_VOR_Shipment_Ind,ls_Line_Of_Business,ls_GLS_TR_ID,ls_Consolidation_No,ls_Consolidate_From_Wh_Code,ls_Scanner_Id,ls_Scanner_Status
string ls_File_Transmit_Ind,ls_Ship_No,ls_DO_No,ls_DWG_Upload,ls_Create_User,ls_User_Field9,ls_User_Field10
string ls_User_Field11,ls_User_Field12,ls_User_Field13,ls_User_Field14,ls_User_Field15,ls_Crossdock_Ind,ls_User_Field16,ls_User_Field17

Datetime ld_Ord_Date,ld_Complete_Date,ld_Request_Date,ld_Arrival_Date,ldToday,ld_Putaway_Start_Time,ld_Customer_Sent_Date
long ll_Back_Order_No,ll_Ctn_Cnt,ll_Weight,ll_Shipping_Carton_Volume,ll_EDI_Batch_Seq_No,ll_Delivery_Note_Print_Count,ll_no

ldToday = f_getLocalWorldTime( gs_default_wh ) 

	//creating new RONO
	/*ll_no = g.of_next_db_seq(gs_project,'Receive_Master','RO_No')
	If ll_no <= 0 Then
		messagebox('error',"Unable to retrieve the next available order Number!")
		Return -1
	End If
	
	is_rono_new = Trim(Left(gs_project,9)) + String(ll_no,"000000")	*/
	


select  PROJECT_ID,ORD_DATE,COMPLETE_DATE,REQUEST_DATE,ARRIVAL_DATE,ORD_STATUS,ORD_TYPE,INVENTORY_TYPE,WH_CODE,
		SUPP_CODE,SUPP_ORDER_NO,BACK_ORDER_NO,SUPP_INVOICE_NO,SHIP_VIA,SHIP_REF,CTN_CNT,WEIGHT,REMARK,USER_FIELD1,USER_FIELD2,
		USER_FIELD3,USER_FIELD4,USER_FIELD5,USER_FIELD6,USER_FIELD7,USER_FIELD8,AGENT_INFO,CARRIER_TRACKING_NO,CUSTOMS_DOC,
		EXPORT_CONTROL_COMMODITY_NO,HARMONIZED_CODE,TRANSPORT_MODE,SHIPPING_CARTON_VOLUME,VAT_ID,LAST_USER,
		EDI_BATCH_SEQ_NO,CARRIER,AWB_BOL_NO,STANDARD_OF_MEASURE,VOR_SHIPMENT_IND,LINE_OF_BUSINESS,GLS_TR_ID,CONSOLIDATION_NO,
		CONSOLIDATE_FROM_WH_CODE,SCANNER_ID,SCANNER_STATUS,FILE_TRANSMIT_IND,SHIP_NO,DO_NO,PUTAWAY_START_TIME,
		CREATE_USER,USER_FIELD9,USER_FIELD10,USER_FIELD11,DWG_UPLOAD,DELIVERY_NOTE_PRINT_COUNT,USER_FIELD12,
		USER_FIELD13,USER_FIELD14,USER_FIELD15,CUSTOMER_SENT_DATE,CROSSDOCK_IND,USER_FIELD16,USER_FIELD17

INTO :ls_project_Id,:ld_Ord_Date,:ld_Complete_Date,:ld_Request_Date,:ld_Arrival_Date,:ls_Ord_Status,:ls_Ord_Type,:ls_Inventory_Type,:ls_WH_Code,
		:ls_Supp_Code,:ls_Supp_Order_No,:ll_Back_Order_No,:ls_Supp_Invoice_No,:ls_Ship_Via,:ls_Ship_Ref,:ll_Ctn_Cnt,:ll_Weight,:ls_Remark,
		:ls_User_Field1,:ls_User_Field2,:ls_User_Field3,:ls_User_Field4,:ls_User_Field5,:ls_User_Field6,:ls_User_Field7,:ls_User_Field8,:ls_Agent_Info,:ls_Carrier_Tracking_No,
		:ls_Customs_Doc,:ls_Export_Control_Commodity_No,:ls_Harmonized_Code,:ls_Transport_Mode,:ll_Shipping_Carton_Volume,:ls_VAT_Id,:ls_Last_User,:ll_EDI_Batch_Seq_No,
		:ls_Carrier,:ls_Awb_Bol_No,:ls_Standard_Of_Measure,:ls_VOR_Shipment_Ind,:ls_Line_Of_Business,:ls_GLS_TR_ID,:ls_Consolidation_No,:ls_Consolidate_From_Wh_Code,:ls_Scanner_Id,
		:ls_Scanner_Status,:ls_File_Transmit_Ind,:ls_Ship_No,:ls_DO_No,:ld_Putaway_Start_Time,:ls_Create_User,:ls_User_Field9,:ls_User_Field10,
		:ls_User_Field11,:ls_DWG_Upload,:ll_Delivery_Note_Print_Count,:ls_User_Field12,:ls_User_Field13,:ls_User_Field14,:ls_User_Field15,:ld_Customer_Sent_Date,:ls_Crossdock_Ind,:ls_User_Field16,:ls_User_Field17
from receive_master
where ro_no =:ls_rono
and project_id=:gs_project
using  itr_prod;

INSERT INTO RECEIVE_MASTER 
		(RO_NO,PROJECT_ID,ORD_DATE,COMPLETE_DATE,REQUEST_DATE,ARRIVAL_DATE,ORD_STATUS,ORD_TYPE,INVENTORY_TYPE,WH_CODE,
		SUPP_CODE,SUPP_ORDER_NO,BACK_ORDER_NO,SUPP_INVOICE_NO,SHIP_VIA,SHIP_REF,CTN_CNT,WEIGHT,REMARK,USER_FIELD1,USER_FIELD2,
		USER_FIELD3,USER_FIELD4,USER_FIELD5,USER_FIELD6,USER_FIELD7,USER_FIELD8,AGENT_INFO,CARRIER_TRACKING_NO,CUSTOMS_DOC,
		EXPORT_CONTROL_COMMODITY_NO,HARMONIZED_CODE,TRANSPORT_MODE,SHIPPING_CARTON_VOLUME,VAT_ID,LAST_USER,LAST_UPDATE,
		EDI_BATCH_SEQ_NO,CARRIER,AWB_BOL_NO,STANDARD_OF_MEASURE,VOR_SHIPMENT_IND,LINE_OF_BUSINESS,GLS_TR_ID,CONSOLIDATION_NO,
		CONSOLIDATE_FROM_WH_CODE,SCANNER_ID,SCANNER_STATUS,FILE_TRANSMIT_IND,SHIP_NO,DO_NO,PUTAWAY_START_TIME,CREATE_TIME,
		CREATE_USER,USER_FIELD9,USER_FIELD10,USER_FIELD11,DWG_UPLOAD,DWG_UPLOAD_TIMESTAMP,DELIVERY_NOTE_PRINT_COUNT,USER_FIELD12,
		USER_FIELD13,USER_FIELD14,USER_FIELD15,CUSTOMER_SENT_DATE,CROSSDOCK_IND,USER_FIELD16,USER_FIELD17)
		
	VALUES (:ls_rono,:ls_project_Id,:ld_Ord_Date,:ld_Complete_Date,:ld_Request_Date,:ld_Arrival_Date,:ls_Ord_Status,:ls_Ord_Type,:ls_Inventory_Type,:ls_WH_Code,
		:ls_Supp_Code,:ls_Supp_Order_No,:ll_Back_Order_No,:ls_Supp_Invoice_No,:ls_Ship_Via,:ls_Ship_Ref,:ll_Ctn_Cnt,:ll_Weight,:ls_Remark,
		:ls_User_Field1,:ls_User_Field2,:ls_User_Field3,:ls_User_Field4,:ls_User_Field5,:ls_User_Field6,:ls_User_Field7,:ls_User_Field8,:ls_Agent_Info,:ls_Carrier_Tracking_No,
		:ls_Customs_Doc,:ls_Export_Control_Commodity_No,:ls_Harmonized_Code,:ls_Transport_Mode,:ll_Shipping_Carton_Volume,:ls_VAT_Id,:ls_Last_User,:ldToday,:ll_EDI_Batch_Seq_No,
		:ls_Carrier,:ls_Awb_Bol_No,:ls_Standard_Of_Measure,:ls_VOR_Shipment_Ind,:ls_Line_Of_Business,:ls_GLS_TR_ID,:ls_Consolidation_No,:ls_Consolidate_From_Wh_Code,:ls_Scanner_Id,:ls_Scanner_Status,
		:ls_File_Transmit_Ind,:ls_Ship_No,:ls_DO_No,:ld_Putaway_Start_Time,:ldToday,:gs_userid,:ls_User_Field9,:ls_User_Field10,
		:ls_User_Field11,:ls_DWG_Upload,:ldToday,:ll_Delivery_Note_Print_Count,:ls_User_Field12,:ls_User_Field13,:ls_User_Field14,:ls_User_Field15,:ld_Customer_Sent_Date,:ls_Crossdock_Ind,:ls_User_Field16,:ls_User_Field17)

using itr_test;

if itr_test.sqlcode = -1 then
	messagebox("Database Error",itr_test.sqlerrtext,Exclamation!)
rollback;
return -1
else
commit;
end if

st_2.Text = st_2.Text + 'r' +  "Record is inserted into Recieve_master "

Return 1;
end function

public function integer of_copyreceivedetail (string ls_rono, string ls_status);
DataStore lds_copyreceivedetail

string ls_SKU,ls_Supp_Code,ls_Country_Of_Origin,ls_Alternate_Sku
string ls_UOM,ls_User_Field1,ls_User_Field2,ls_Standard_Of_Measure,ls_GLS_SO_ID,ls_User_Line_Item_No
string ls_User_Field3,ls_User_Field4,ls_User_Field5,ls_User_Field6,ls_Exp_Serial_No

long ll_Owner_Id,ll_Req_Qty,ll_Alloc_Qty,ll_Damage_Qty,ll_Cost,ll_Line_Item_No,ll_GLS_SO_Line,ll_row,ll_ownerid
int li_count

string presentation_str,ls_sql,dwsyntax_str,lsErrText

SELECT COUNT(*) INTO :li_count
FROM RECEIVE_DETAIL
WHERE RO_NO =:ls_rono
using  itr_test;
		
		 
IF li_count =0 THEN
	
	presentation_str = "style(type=grid)"
	lds_copyreceivedetail = CREATE datastore
	ls_sql =   " SELECT SKU,SUPP_CODE,OWNER_ID,COUNTRY_OF_ORIGIN,ALTERNATE_SKU,REQ_QTY,ALLOC_QTY,DAMAGE_QTY,UOM,COST," &
				+"USER_FIELD1,USER_FIELD2,STANDARD_OF_MEASURE,LINE_ITEM_NO,GLS_SO_ID,GLS_SO_LINE,USER_LINE_ITEM_NO," &
				+"USER_FIELD3,USER_FIELD4,USER_FIELD5,USER_FIELD6,EXP_SERIAL_NO "
	ls_sql += " FROM dbo.Receive_Detail "
	ls_sql += " WHERE ro_no = '" + ls_rono + "' "

	dwsyntax_str = SQLCA.SyntaxFromSQL(ls_sql, presentation_str, lsErrText)
	lds_copyreceivedetail.Create( dwsyntax_str, lsErrText)
	lds_copyreceivedetail.SetTransObject(itr_prod);	


IF lsErrText <> '' THEN
MessageBox( 'Error...', lsErrText )
RETURN 1
END IF

lds_copyreceivedetail.Retrieve( )

FOR ll_row = 1 TO lds_copyreceivedetail.RowCount( )
ls_SKU = lds_copyreceivedetail.GetItemString( ll_row, 'SKU' )
ls_Supp_Code = lds_copyreceivedetail.GetItemString( ll_row, 'Supp_Code' )
ll_Owner_Id = lds_copyreceivedetail.GetItemNumber( ll_row, 'Owner_Id' )
ls_Country_Of_Origin = lds_copyreceivedetail.GetItemString( ll_row, 'Country_Of_Origin' )
ls_Alternate_Sku = lds_copyreceivedetail.GetItemString( ll_row, 'Alternate_Sku' )
ll_Req_Qty = lds_copyreceivedetail.GetItemNumber( ll_row, 'Req_Qty' )
ll_Alloc_Qty = lds_copyreceivedetail.GetItemNumber( ll_row, 'Alloc_Qty' )
ll_Damage_Qty = lds_copyreceivedetail.GetItemNumber( ll_row, 'Damage_Qty' )
ls_UOM = lds_copyreceivedetail.GetItemString( ll_row, 'UOM' )
ll_Cost = lds_copyreceivedetail.GetItemNumber( ll_row, 'Cost' )

ls_User_Field1 = lds_copyreceivedetail.GetItemString( ll_row, 'User_Field1' )
ls_User_Field2 = lds_copyreceivedetail.GetItemString( ll_row, 'User_Field2' )
ls_Standard_Of_Measure = lds_copyreceivedetail.GetItemString( ll_row, 'Standard_Of_Measure' )
ll_Line_Item_No = lds_copyreceivedetail.GetItemNumber( ll_row, 'Line_Item_No' )
ls_GLS_SO_ID = lds_copyreceivedetail.GetItemString( ll_row, 'GLS_SO_ID' )
ll_GLS_SO_Line = lds_copyreceivedetail.GetItemNumber( ll_row, 'GLS_SO_Line' )
ls_User_Line_Item_No = lds_copyreceivedetail.GetItemString( ll_row, 'User_Line_Item_No' )
ls_User_Field3 = lds_copyreceivedetail.GetItemString( ll_row, 'User_Field3' )
ls_User_Field4 = lds_copyreceivedetail.GetItemString( ll_row, 'User_Field4' )
ls_User_Field5 = lds_copyreceivedetail.GetItemString( ll_row, 'User_Field5' )
ls_User_Field6 = lds_copyreceivedetail.GetItemString( ll_row, 'User_Field6' )
ls_Exp_Serial_No = lds_copyreceivedetail.GetItemString( ll_row, 'Exp_Serial_No' )

select owner_id into :ll_ownerid from item_master where sku=:ls_sku and project_id=:gs_project and supp_code=:ls_Supp_Code
using itr_test;

IF ll_Owner_Id <> ll_ownerid THEN
	ll_Owner_Id=ll_ownerid
END IF;


	INSERT INTO RECEIVE_DETAIL 
		(RO_NO,SKU,SUPP_CODE,OWNER_ID,COUNTRY_OF_ORIGIN,ALTERNATE_SKU,REQ_QTY,ALLOC_QTY,DAMAGE_QTY,UOM,COST,
		USER_FIELD1,USER_FIELD2,STANDARD_OF_MEASURE,LINE_ITEM_NO,GLS_SO_ID,GLS_SO_LINE,USER_LINE_ITEM_NO,
		USER_FIELD3,USER_FIELD4,USER_FIELD5,USER_FIELD6,EXP_SERIAL_NO)
		
	VALUES (:ls_rono,:ls_SKU,:ls_Supp_Code,:ll_Owner_Id,:ls_Country_Of_Origin,:ls_Alternate_Sku,:ll_Req_Qty,'0',:ll_Damage_Qty,
		:ls_UOM,:ll_Cost,:ls_User_Field1,:ls_User_Field2,:ls_Standard_Of_Measure,:ll_Line_Item_No,:ls_GLS_SO_ID,:ll_GLS_SO_Line,:ls_User_Line_Item_No,
		:ls_User_Field3,:ls_User_Field4,:ls_User_Field5,:ls_User_Field6,:ls_Exp_Serial_No)
		
	USING itr_test;

if itr_test.sqlcode = -1 then
	messagebox("Database Error",itr_test.sqlerrtext,Exclamation!)
rollback;
return -1
else
commit;
end if

st_2.Text =  st_2.Text + 'r' + "Record is inserted into Recieve_detail for sku " +ls_sku

NEXT
DESTROY lds_copyreceivedetail
END IF


IF ls_status ='C' then
	UPDATE Receive_Master SET ORD_STATUS ='N' WHERE  RO_NO=:ls_rono using itr_test;
END if


return 1
end function

public function integer of_copywarehouse (string ls_wh_code);
string ls_WH_Name,ls_WH_Type,ls_Address_1,ls_Address_2,ls_Address_3,ls_Address_4,ls_City,ls_State,ls_Zip,ls_Country
string ls_Tel,ls_Fax,ls_Contact_Person,ls_Remark,ls_Last_User,ls_User_Field1,ls_User_Field2,ls_User_Field3,ls_Email_Address,ls_UCC_Location_Prefix
string ls_Shipment_Enabled_Ind,ls_Fwd_Pick_Email_Notification,ls_DST_Flag,ls_Trax_Enable_Ind,ls_Trax_Label_Print_Dest
string ls_Car_Priority_Pick_Ind,ls_Transaction_Group
Datetime ld_Dylght_Svngs_Time_Start,ld_Dylght_Svngs_Time_End
long ll_GMT_Offset

Datetime		ldToday
ldToday = f_getLocalWorldTime( gs_default_wh ) 

select WH_Code,WH_Name,WH_Type,Address_1,Address_2,Address_3,Address_4,City,State,Zip,Country,Tel,Fax,
Contact_Person,Remark,Last_User,User_Field1,User_Field2,User_Field3,Email_Address,UCC_Location_Prefix,
Shipment_Enabled_Ind,Fwd_Pick_Email_Notification,GMT_Offset,DST_Flag,Trax_Enable_Ind,Trax_Label_Print_Dest,
Dylght_Svngs_Time_Start,Dylght_Svngs_Time_End,Car_Priority_Pick_Ind,Transaction_Group
INTO :ls_WH_Code,:ls_WH_Name,:ls_WH_Type,:ls_Address_1,:ls_Address_2,:ls_Address_3,:ls_Address_4,:ls_City,:ls_State,:ls_Zip,:ls_Country,
:ls_Tel,:ls_Fax,:ls_Contact_Person,:ls_Remark,:ls_Last_User,:ls_User_Field1,:ls_User_Field2,:ls_User_Field3,:ls_Email_Address,:ls_UCC_Location_Prefix,
:ls_Shipment_Enabled_Ind,:ls_Fwd_Pick_Email_Notification,:ll_GMT_Offset,:ls_DST_Flag,:ls_Trax_Enable_Ind,:ls_Trax_Label_Print_Dest,
:ld_Dylght_Svngs_Time_Start,:ld_Dylght_Svngs_Time_End,:ls_Car_Priority_Pick_Ind,:ls_Transaction_Group
from warehouse
where wh_code =:ls_wh_code
using  itr_prod;


INSERT INTO WAREHOUSE (WH_Code,WH_Name,WH_Type,Address_1,Address_2,Address_3,Address_4,City,State,Zip,Country,Tel,Fax,
Contact_Person,Remark,Last_User,Last_Update,User_Field1,User_Field2,User_Field3,Email_Address,UCC_Location_Prefix,
Shipment_Enabled_Ind,Fwd_Pick_Email_Notification,GMT_Offset,DST_Flag,Trax_Enable_Ind,Trax_Label_Print_Dest,
Dylght_Svngs_Time_Start,Dylght_Svngs_Time_End,Car_Priority_Pick_Ind,Transaction_Group)
VALUES (:ls_WH_Code,:ls_WH_Name,:ls_WH_Type,:ls_Address_1,:ls_Address_2,:ls_Address_3,:ls_Address_4,:ls_City,:ls_State,:ls_Zip,:ls_Country,
:ls_Tel,:ls_Fax,:ls_Contact_Person,:ls_Remark,:ls_Last_User,:ldToday,:ls_User_Field1,:ls_User_Field2,:ls_User_Field3,:ls_Email_Address,:ls_UCC_Location_Prefix,
:ls_Shipment_Enabled_Ind,:ls_Fwd_Pick_Email_Notification,:ll_GMT_Offset,:ls_DST_Flag,:ls_Trax_Enable_Ind,:ls_Trax_Label_Print_Dest,
:ld_Dylght_Svngs_Time_Start,:ld_Dylght_Svngs_Time_End,:ls_Car_Priority_Pick_Ind,:ls_Transaction_Group)
using itr_test;

if itr_Test.sqlcode = -1 then
	messagebox("Database Error",itr_test.sqlerrtext,Exclamation!)
rollback;
return -1
else
commit;
end if

st_2.Text =  st_2.Text + 'r' + "Record is inserted into warehouse with wh_code " + ls_wh_code
return 1
end function

public function integer of_copyitemgroup (string ls_grp);Datetime		ldToday
ldToday = f_getLocalWorldTime( gs_default_wh ) 

string ls_Grp_Desc,ls_Last_User
Datetime Last_Update


select Grp_Desc,Last_User
 into :ls_Grp_Desc,:ls_Last_User
from item_group
where project_id=:gs_project
and grp =:ls_grp
using itr_prod;

INSERT INTO ITEM_GROUP (Project_Id,Grp,Grp_Desc,Last_User,Last_Update)
VALUES (:gs_project,:ls_grp,:ls_Grp_Desc,:gs_userid,:ldToday)
using itr_test;

if itr_test.sqlcode = -1 then
	messagebox("Database Error",itr_test.sqlerrtext,Exclamation!)
rollback;
return -1
else
commit;
end if

st_2.Text =  st_2.Text + 'r' + "Record is inserted into Item_group with grp " + ls_grp
return 1

end function

public function integer of_copydeliverymaster (string ls_dono);string ls_DO_No,ls_Project_Id,ls_Ord_Type,ls_Ord_Status,ls_WH_Code,ls_Inventory_Type,ls_Cust_Order_No,ls_Cust_Code,ls_Last_User
string ls_Cust_Name,ls_Address_Code,ls_Address_1,ls_Address_2,ls_Address_3,ls_Address_4,ls_City,ls_State,ls_Zip,ls_Country,ls_Contact_Person
string ls_Tel,ls_Fax,ls_Email_Address,ls_Remark,ls_Ship_Via,ls_Ship_Ref,ls_Invoice_No,ls_Carrier,ls_Freight_Terms,ls_User_Field1,ls_User_Field2
string ls_User_Field3,ls_User_Field4,ls_User_Field5,ls_User_Field6,ls_User_Field7,ls_User_Field8,ls_Agent_Info,ls_Carrier_Tracking_No,ls_Customs_Doc
string ls_Export_Control_Commodity_No,ls_Harmonized_Code,ls_Transport_Mode,ls_Awb_Bol_No,ls_VAT_Id,ls_File_Transmit_Ind,ls_Standard_Of_Measure
string ls_Description,ls_Type_Of_Product,ls_Type_Of_Service,ls_Type_Of_Payment,ls_Delivery_Confirm_Ind,ls_Confirmation_Ind,ls_Gemini_Ind
string ls_Shipping_Instructions,ls_OM_Note_Code_Text,ls_Packlist_Notes,ls_District,ls_Gemini_Order_No,ls_VOR_Shipment_Ind,ls_Line_Of_Business
string ls_Consolidation_No,ls_Consolidate_To_Wh_Code,ls_Scanner_Id,ls_Scanner_Status,ls_GLS_TR_ID,ls_Forecast_Release_No,ls_Trader_Id,ls_Factory_Id
string ls_Contract_Owner_Id,ls_User_Field9,ls_User_Field10,ls_User_Field11,ls_User_Field12,ls_User_Field13,ls_User_Field14,ls_User_Field15
string ls_DWG_Upload,ls_Create_User,ls_User_Field16,ls_User_Field17,ls_User_Field18,ls_Crossdock_Ind,ls_User_Field19,ls_User_Field20,ls_User_Field21
string ls_User_Field22,ls_Trax_Acct_No,ls_Return_Tracking_No,ls_Otm_status,ls_Trax_Duty_Terms,ls_Trax_Duty_Acct_No,ls_Trax_Pack_Location

long ll_Priority,ll_Back_Order_No,ll_Freight_Cost,ll_Ctn_Cnt,ll_Weight,ll_Shipping_Carton_Volume,ll_EDI_Batch_Seq_No,ll_Declared_Value
long ll_Batch_Pick_Id,ll_Delivery_Note_Print_Count,ll_Pick_List_Print_Count,ll_Pack_List_Print_Count,ll_Carton_Label_Print_Count

Datetime ld_Ord_Date,ld_Complete_Date,ld_Pick_Start,ld_Pick_Complete,ld_Schedule_Date,ld_Request_Date,ld_Delivery_Date,ld_Receive_Date
Datetime ld_Freight_ETD,ld_Freight_ETA,ld_Freight_ATD,ld_Freight_ATA,ld_Gemini_Export_Datetime,ld_EDM_Generate_Datetime,ld_Customs_Clearance_Date,ld_Carrier_Notified_Date
datetime ld_DWG_Upload_Timestamp,ld_Customer_Sent_Date,ld_OTM_Call_Date,ld_OTM_Receive_Date,ldToday


ldToday = f_getLocalWorldTime( gs_default_wh ) 


SELECT
DO_No,Project_Id,Ord_Type,Priority,Ord_Date,Complete_Date,Pick_Start,Pick_Complete,Schedule_Date,Request_Date,Delivery_Date,
Receive_Date,Ord_Status,WH_Code,Inventory_Type,Cust_Order_No,Back_Order_No,Cust_Code,Cust_Name,Address_Code,Address_1,Address_2,
Address_3,Address_4,City,State,Zip,Country,Contact_Person,Tel,Fax,Email_Address,Remark,Ship_Via,Ship_Ref,Invoice_No,Carrier,
Freight_Terms,Freight_ETD,Freight_ETA,Freight_ATD,Freight_ATA,Freight_Cost,Ctn_Cnt,Weight,User_Field1,User_Field2,User_Field3,
User_Field4,User_Field5,User_Field6,User_Field7,User_Field8,Agent_Info,Carrier_Tracking_No,Customs_Doc,Export_Control_Commodity_No,
Harmonized_Code,Transport_Mode,Shipping_Carton_Volume,Awb_Bol_No,VAT_Id,Last_User,File_Transmit_Ind,EDI_Batch_Seq_No,
Standard_Of_Measure,Description,Type_Of_Product,Type_Of_Service,Type_Of_Payment,Declared_Value,Delivery_Confirm_Ind,Confirmation_Ind,
Gemini_Ind,Gemini_Export_Datetime,Shipping_Instructions,OM_Note_Code_Text,Packlist_Notes,District,EDM_Generate_Datetime,Gemini_Order_No,
VOR_Shipment_Ind,Batch_Pick_Id,Line_Of_Business,Consolidation_No,Consolidate_To_Wh_Code,Scanner_Id,Scanner_Status,GLS_TR_ID,Customs_Clearance_Date,
Carrier_Notified_Date,Forecast_Release_No,Trader_Id,Factory_Id,Contract_Owner_Id,User_Field9,User_Field10,User_Field11,User_Field12,User_Field13,User_Field14,
User_Field15,DWG_Upload,DWG_Upload_Timestamp,Create_User,Delivery_Note_Print_Count,User_Field16,User_Field17,User_Field18,Customer_Sent_Date,Crossdock_Ind,
User_Field19,User_Field20,User_Field21,User_Field22,Trax_Acct_No,Return_Tracking_No,Pick_List_Print_Count,Pack_List_Print_Count,Carton_Label_Print_Count,
Otm_status,Trax_Duty_Terms,Trax_Duty_Acct_No,OTM_Call_Date,OTM_Receive_Date,Trax_Pack_Location

INTO 
:ls_DO_No,:ls_Project_Id,:ls_Ord_Type,:ll_Priority,:ld_Ord_Date,:ld_Complete_Date,:ld_Pick_Start,:ld_Pick_Complete,:ld_Schedule_Date,:ld_Request_Date,
:ld_Delivery_Date,:ld_Receive_Date,:ls_Ord_Status,:ls_WH_Code,:ls_Inventory_Type,:ls_Cust_Order_No,:ll_Back_Order_No,:ls_Cust_Code,:ls_Cust_Name,:ls_Address_Code,
:ls_Address_1,:ls_Address_2,:ls_Address_3,:ls_Address_4,:ls_City,:ls_State,:ls_Zip,:ls_Country,:ls_Contact_Person,:ls_Tel,:ls_Fax,:ls_Email_Address,:ls_Remark,
:ls_Ship_Via,:ls_Ship_Ref,:ls_Invoice_No,:ls_Carrier,:ls_Freight_Terms,:ld_Freight_ETD,:ld_Freight_ETA,:ld_Freight_ATD,:ld_Freight_ATA,:ll_Freight_Cost,:ll_Ctn_Cnt,
:ll_Weight,:ls_User_Field1,:ls_User_Field2,:ls_User_Field3,:ls_User_Field4,:ls_User_Field5,:ls_User_Field6,:ls_User_Field7,:ls_User_Field8,:ls_Agent_Info,
:ls_Carrier_Tracking_No,:ls_Customs_Doc,:ls_Export_Control_Commodity_No,:ls_Harmonized_Code,:ls_Transport_Mode,:ll_Shipping_Carton_Volume,:ls_Awb_Bol_No,:ls_VAT_Id,
:ls_Last_User,:ls_File_Transmit_Ind,:ll_EDI_Batch_Seq_No,:ls_Standard_Of_Measure,:ls_Description,:ls_Type_Of_Product,:ls_Type_Of_Service,:ls_Type_Of_Payment,
:ll_Declared_Value,:ls_Delivery_Confirm_Ind,:ls_Confirmation_Ind,:ls_Gemini_Ind,:ld_Gemini_Export_Datetime,:ls_Shipping_Instructions,:ls_OM_Note_Code_Text,:ls_Packlist_Notes,
:ls_District,:ld_EDM_Generate_Datetime,:ls_Gemini_Order_No,:ls_VOR_Shipment_Ind,:ll_Batch_Pick_Id,:ls_Line_Of_Business,:ls_Consolidation_No,:ls_Consolidate_To_Wh_Code,
:ls_Scanner_Id,:ls_Scanner_Status,:ls_GLS_TR_ID,:ld_Customs_Clearance_Date,:ld_Carrier_Notified_Date,:ls_Forecast_Release_No,:ls_Trader_Id,:ls_Factory_Id,:ls_Contract_Owner_Id,
:ls_User_Field9,:ls_User_Field10,:ls_User_Field11,:ls_User_Field12,:ls_User_Field13,:ls_User_Field14,:ls_User_Field15,:ls_DWG_Upload,:ld_DWG_Upload_Timestamp,:ls_Create_User,
:ll_Delivery_Note_Print_Count,:ls_User_Field16,:ls_User_Field17,:ls_User_Field18,:ld_Customer_Sent_Date,:ls_Crossdock_Ind,:ls_User_Field19,:ls_User_Field20,:ls_User_Field21,
:ls_User_Field22,:ls_Trax_Acct_No,:ls_Return_Tracking_No,:ll_Pick_List_Print_Count,:ll_Pack_List_Print_Count,:ll_Carton_Label_Print_Count,:ls_Otm_status,:ls_Trax_Duty_Terms,
:ls_Trax_Duty_Acct_No,:ld_OTM_Call_Date,:ld_OTM_Receive_Date,:ls_Trax_Pack_Location
from delivery_master
where do_no =:ls_dono
and project_id=:gs_project
using itr_prod;

INSERT INTO DELIVERY_MASTER (
DO_No,Project_Id,Ord_Type,Priority,Ord_Date,Complete_Date,Pick_Start,Pick_Complete,Schedule_Date,Request_Date,Delivery_Date,
Receive_Date,Ord_Status,WH_Code,Inventory_Type,Cust_Order_No,Back_Order_No,Cust_Code,Cust_Name,Address_Code,Address_1,Address_2,
Address_3,Address_4,City,State,Zip,Country,Contact_Person,Tel,Fax,Email_Address,Remark,Ship_Via,Ship_Ref,Invoice_No,Carrier,
Freight_Terms,Freight_ETD,Freight_ETA,Freight_ATD,Freight_ATA,Freight_Cost,Ctn_Cnt,Weight,User_Field1,User_Field2,User_Field3,
User_Field4,User_Field5,User_Field6,User_Field7,User_Field8,Agent_Info,Carrier_Tracking_No,Customs_Doc,Export_Control_Commodity_No,
Harmonized_Code,Transport_Mode,Shipping_Carton_Volume,Awb_Bol_No,VAT_Id,Last_User,Last_Update,File_Transmit_Ind,EDI_Batch_Seq_No,
Standard_Of_Measure,Description,Type_Of_Product,Type_Of_Service,Type_Of_Payment,Declared_Value,Delivery_Confirm_Ind,Confirmation_Ind,
Gemini_Ind,Gemini_Export_Datetime,Shipping_Instructions,OM_Note_Code_Text,Packlist_Notes,District,EDM_Generate_Datetime,Gemini_Order_No,
VOR_Shipment_Ind,Batch_Pick_Id,Line_Of_Business,Consolidation_No,Consolidate_To_Wh_Code,Scanner_Id,Scanner_Status,GLS_TR_ID,Customs_Clearance_Date,
Carrier_Notified_Date,Forecast_Release_No,Trader_Id,Factory_Id,Contract_Owner_Id,User_Field9,User_Field10,User_Field11,User_Field12,User_Field13,User_Field14,
User_Field15,DWG_Upload,DWG_Upload_Timestamp,Create_Time,Create_User,Delivery_Note_Print_Count,User_Field16,User_Field17,User_Field18,Customer_Sent_Date,Crossdock_Ind,
User_Field19,User_Field20,User_Field21,User_Field22,Trax_Acct_No,Return_Tracking_No,Pick_List_Print_Count,Pack_List_Print_Count,Carton_Label_Print_Count,
Otm_status,Trax_Duty_Terms,Trax_Duty_Acct_No,OTM_Call_Date,OTM_Receive_Date,Trax_Pack_Location )

VALUES (
:ls_DO_No,:ls_Project_Id,:ls_Ord_Type,:ll_Priority,:ld_Ord_Date,:ld_Complete_Date,:ld_Pick_Start,:ld_Pick_Complete,:ld_Schedule_Date,:ld_Request_Date,
:ld_Delivery_Date,:ld_Receive_Date,:ls_Ord_Status,:ls_WH_Code,:ls_Inventory_Type,:ls_Cust_Order_No,:ll_Back_Order_No,:ls_Cust_Code,:ls_Cust_Name,:ls_Address_Code,
:ls_Address_1,:ls_Address_2,:ls_Address_3,:ls_Address_4,:ls_City,:ls_State,:ls_Zip,:ls_Country,:ls_Contact_Person,:ls_Tel,:ls_Fax,:ls_Email_Address,:ls_Remark,
:ls_Ship_Via,:ls_Ship_Ref,:ls_Invoice_No,:ls_Carrier,:ls_Freight_Terms,:ld_Freight_ETD,:ld_Freight_ETA,:ld_Freight_ATD,:ld_Freight_ATA,:ll_Freight_Cost,:ll_Ctn_Cnt,
:ll_Weight,:ls_User_Field1,:ls_User_Field2,:ls_User_Field3,:ls_User_Field4,:ls_User_Field5,:ls_User_Field6,:ls_User_Field7,:ls_User_Field8,:ls_Agent_Info,
:ls_Carrier_Tracking_No,:ls_Customs_Doc,:ls_Export_Control_Commodity_No,:ls_Harmonized_Code,:ls_Transport_Mode,:ll_Shipping_Carton_Volume,:ls_Awb_Bol_No,:ls_VAT_Id,
:ls_Last_User,:ldToday,:ls_File_Transmit_Ind,:ll_EDI_Batch_Seq_No,:ls_Standard_Of_Measure,:ls_Description,:ls_Type_Of_Product,:ls_Type_Of_Service,:ls_Type_Of_Payment,
:ll_Declared_Value,:ls_Delivery_Confirm_Ind,:ls_Confirmation_Ind,:ls_Gemini_Ind,:ld_Gemini_Export_Datetime,:ls_Shipping_Instructions,:ls_OM_Note_Code_Text,:ls_Packlist_Notes,
:ls_District,:ld_EDM_Generate_Datetime,:ls_Gemini_Order_No,:ls_VOR_Shipment_Ind,:ll_Batch_Pick_Id,:ls_Line_Of_Business,:ls_Consolidation_No,:ls_Consolidate_To_Wh_Code,
:ls_Scanner_Id,:ls_Scanner_Status,:ls_GLS_TR_ID,:ld_Customs_Clearance_Date,:ld_Carrier_Notified_Date,:ls_Forecast_Release_No,:ls_Trader_Id,:ls_Factory_Id,:ls_Contract_Owner_Id,
:ls_User_Field9,:ls_User_Field10,:ls_User_Field11,:ls_User_Field12,:ls_User_Field13,:ls_User_Field14,:ls_User_Field15,:ls_DWG_Upload,:ld_DWG_Upload_Timestamp,:ldToday,:gs_userid,
:ll_Delivery_Note_Print_Count,:ls_User_Field16,:ls_User_Field17,:ls_User_Field18,:ld_Customer_Sent_Date,:ls_Crossdock_Ind,:ls_User_Field19,:ls_User_Field20,:ls_User_Field21,
:ls_User_Field22,:ls_Trax_Acct_No,:ls_Return_Tracking_No,:ll_Pick_List_Print_Count,:ll_Pack_List_Print_Count,:ll_Carton_Label_Print_Count,:ls_Otm_status,:ls_Trax_Duty_Terms,
:ls_Trax_Duty_Acct_No,:ld_OTM_Call_Date,:ld_OTM_Receive_Date,:ls_Trax_Pack_Location)

using itr_test;

if itr_Test.sqlcode = -1 then
	messagebox("Database Error",itr_test.sqlerrtext,Exclamation!)
rollback;
return -1
else
commit;
end if

st_2.Text =  st_2.Text + 'r' + "Record is inserted into Delivery_master "

Return 1;
end function

public function integer of_copydeliverydetail (string ls_dono, string ls_status);DataStore lds_copydeliverydetail

string ls_SKU,ls_Supp_Code,ls_Alternate_Sku,ls_UOM,ls_User_Field1,ls_User_Field2,ls_Standard_Of_Measure,ls_Line_Item_Notes
string ls_GLS_SO_ID,ls_User_Field3,ls_Currency_Code,ls_Contract_No,ls_Commodity_Code
string ls_User_Field4,ls_User_Field5,ls_User_Field6,ls_User_Field7,ls_User_Field8,ls_Pick_Lot_No,ls_Pick_PO_No,ls_pick_po_no2
string ls_User_line_Item_No,ls_Customer_Sku

long ll_Owner_Id,ll_Req_Qty,ll_Alloc_Qty,ll_Price,ll_Cost,ll_Tax,ll_GLS_SO_Line,ll_Accepted_Qty,ll_row,ll_Line_Item_No,ll_ownerid

int li_count

string presentation_str,ls_sql,dwsyntax_str,lsErrText

SELECT COUNT(*) INTO :li_count
FROM DELIVERY_DETAIL
WHERE DO_NO =:ls_dono
using itr_test;
		
		 
IF li_count =0 THEN
	
	presentation_str = "style(type=grid)"
	lds_copydeliverydetail = CREATE datastore
	ls_sql =   " SELECT DO_No,SKU,Supp_Code,Owner_Id,Alternate_Sku,Req_Qty,Alloc_Qty,UOM,Price,Cost,User_Field1,User_Field2," &
				+"Tax,Standard_Of_Measure,Line_Item_Notes,Line_Item_No,GLS_SO_ID,GLS_SO_Line,User_Field3,Currency_Code," &
				+"Contract_No,Commodity_Code,User_Field4,User_Field5,User_Field6,User_Field7,User_Field8,Pick_Lot_No,"&
				+"Pick_PO_No,pick_po_no2,Accepted_Qty,User_line_Item_No,Customer_Sku"
				
	ls_sql += " FROM dbo.Delivery_Detail "
	ls_sql += " WHERE do_no = '" + ls_dono + "' "

	dwsyntax_str = SQLCA.SyntaxFromSQL(ls_sql, presentation_str, lsErrText)
	lds_copydeliverydetail.Create( dwsyntax_str, lsErrText)
	lds_copydeliverydetail.SetTransObject(itr_prod);	


IF lsErrText <> '' THEN
MessageBox( 'Error...', lsErrText )
RETURN 1
END IF

lds_copydeliverydetail.Retrieve( )

FOR ll_row = 1 TO lds_copydeliverydetail.RowCount( )
ls_SKU = lds_copydeliverydetail.GetItemString( ll_row, 'SKU' )
ls_Supp_Code = lds_copydeliverydetail.GetItemString( ll_row, 'Supp_Code' )
ll_Owner_Id = lds_copydeliverydetail.GetItemNumber( ll_row, 'Owner_Id' )
ls_Alternate_Sku = lds_copydeliverydetail.GetItemString( ll_row, 'Alternate_Sku' )
ll_Req_Qty = lds_copydeliverydetail.GetItemNumber( ll_row, 'Req_Qty' )
//ll_Alloc_Qty = lds_copydeliverydetail.GetItemNumber( ll_row, 'Alloc_Qty' )

ls_UOM = lds_copydeliverydetail.GetItemString( ll_row, 'UOM' )
ll_Price = lds_copydeliverydetail.GetItemNumber( ll_row, 'Price' )
ll_Cost = lds_copydeliverydetail.GetItemNumber( ll_row, 'Cost' )

ls_User_Field1 = lds_copydeliverydetail.GetItemString( ll_row, 'User_Field1' )
ls_User_Field2 = lds_copydeliverydetail.GetItemString( ll_row, 'User_Field2' )
ll_Tax = lds_copydeliverydetail.GetItemNumber( ll_row, 'Tax' )
ls_Standard_Of_Measure = lds_copydeliverydetail.GetItemString( ll_row, 'Standard_Of_Measure' )
ls_Line_Item_Notes = lds_copydeliverydetail.GetItemString( ll_row, 'Line_Item_Notes' )
ll_Line_Item_No = lds_copydeliverydetail.GetItemNumber( ll_row, 'Line_Item_No' )
ls_GLS_SO_ID = lds_copydeliverydetail.GetItemString( ll_row, 'GLS_SO_ID' )
ll_GLS_SO_Line = lds_copydeliverydetail.GetItemNumber( ll_row, 'GLS_SO_Line' )
ls_User_Field3 = lds_copydeliverydetail.GetItemString( ll_row, 'User_Field3' )
ls_Currency_Code = lds_copydeliverydetail.GetItemString( ll_row, 'Currency_Code' )
ls_Contract_No = lds_copydeliverydetail.GetItemString( ll_row, 'Contract_No' )
ls_Commodity_Code = lds_copydeliverydetail.GetItemString( ll_row, 'Commodity_Code' )

ls_User_Field4 = lds_copydeliverydetail.GetItemString( ll_row, 'User_Field4' )
ls_User_Field5 = lds_copydeliverydetail.GetItemString( ll_row, 'User_Field5' )
ls_User_Field6 = lds_copydeliverydetail.GetItemString( ll_row, 'User_Field6' )
ls_User_Field7 = lds_copydeliverydetail.GetItemString( ll_row, 'User_Field7' )
ls_User_Field8 = lds_copydeliverydetail.GetItemString( ll_row, 'User_Field8' )

ls_Pick_Lot_No = lds_copydeliverydetail.GetItemString( ll_row, 'Pick_Lot_No' )
ls_Pick_PO_No = lds_copydeliverydetail.GetItemString( ll_row, 'Pick_PO_No' )
ls_pick_po_no2 = lds_copydeliverydetail.GetItemString( ll_row, 'pick_po_no2' )

ll_Accepted_Qty = lds_copydeliverydetail.GetItemNumber( ll_row, 'Accepted_Qty' )
ls_User_line_Item_No = lds_copydeliverydetail.GetItemString( ll_row, 'User_line_Item_No' )
ls_Customer_Sku = lds_copydeliverydetail.GetItemString( ll_row, 'Customer_Sku' )

select owner_id into :ll_ownerid from item_master where sku=:ls_sku and project_id=:gs_project and supp_code=:ls_Supp_Code
using itr_test;

IF ll_Owner_Id <> ll_ownerid THEN
	ll_Owner_Id=ll_ownerid
END IF;


	INSERT INTO DELIVERY_DETAIL 
		(DO_No,SKU,Supp_Code,Owner_Id,Alternate_Sku,Req_Qty,Alloc_Qty,UOM,Price,Cost,User_Field1,User_Field2,
		Tax,Standard_Of_Measure,Line_Item_Notes,Line_Item_No,GLS_SO_ID,GLS_SO_Line,User_Field3,Currency_Code,
		Contract_No,Commodity_Code,User_Field4,User_Field5,User_Field6,User_Field7,User_Field8,Pick_Lot_No,
		Pick_PO_No,pick_po_no2,Accepted_Qty,User_line_Item_No,Customer_Sku)
		
	VALUES (:ls_DONo,:ls_SKU,:ls_Supp_Code,:ll_Owner_Id,:ls_Alternate_Sku,:ll_Req_Qty,'0',
		:ls_UOM,:ll_Price,:ll_Cost,:ls_User_Field1,:ls_User_Field2,:ll_Tax,:ls_Standard_Of_Measure,:ls_Line_Item_Notes,
		:ll_Line_Item_No,:ls_GLS_SO_ID,:ll_GLS_SO_Line,:ls_User_Field3,:ls_Currency_Code,:ls_Contract_No,:ls_Commodity_Code,
		:ls_User_Field4,:ls_User_Field5,:ls_User_Field6,:ls_User_Field7,:ls_User_Field8,:ls_Pick_Lot_No,:ls_Pick_PO_No,:ls_pick_po_no2,
		:ll_Accepted_Qty,:ls_User_line_Item_No,:ls_Customer_Sku)
		
	USING itr_test;

/*if itr_test.sqlcode = -1 then
	messagebox("Database Error",itr_test.sqlerrtext,Exclamation!)
rollback;
else
commit;
end if*/
st_2.Text =  st_2.Text + 'r' + "Record is inserted into Delivery_detail for sku " +ls_sku

NEXT
DESTROY lds_copydeliverydetail
END IF


IF ls_status ='C' then
	UPDATE Delivery_Master SET ORD_STATUS ='N' WHERE  DO_NO=:ls_dono using itr_test;
END if


return 1
end function

public function integer of_copyowner (long ll_prdownerid);
string ls_projectid,ls_suppcode,ls_suppname,ls_addr1,ls_addr2,ls_addr3,ls_addr4,ls_city,ls_state,ls_zip,ls_country,ls_con_person,ls_tel
string ls_fax,ls_email,ls_remark,ls_export,ls_harmonized,ls_vat,ls_user1,ls_user2,ls_user3,ls_luser,ls_lupdate,ls_user4,ls_user5,ls_user6
string ls_dwg_upload,ls_dwg_upload_time,ls_ownertype,ls_owner_cd,ls_ownerid

String ls_sql, ls_syntax, dwsyntax_str,lsErrText,presentation_str
integer li_count
Long ll_row


Datetime		ldToday
ldToday = f_getLocalWorldTime( gs_default_wh ) 

DataStore lds_copyowner


SELECT COUNT(*) into :li_count
FROM OWNER
WHERE  OWNER_ID =:LL_PRDOWNERID
using itr_test;

SELECT Project_id  into :ls_projectid
FROM OWNER
WHERE  OWNER_ID =:LL_PRDOWNERID
using itr_test;

	
IF ((li_count =0) OR (li_count >0 and gs_project <> ls_projectid)) THEN	
	
	SELECT OWNER_TYPE,OWNER_CD ,LAST_USER ,	DWG_UPLOAD
	 INTO :ls_ownertype,:ls_owner_cd,:ls_luser,:ls_dwg_upload
	FROM dbo.OWNER
	WHERE project_id = :gs_project 
	AND owner_id = :LL_PRDOWNERID
	using itr_prod;

//check already owner id is exist with this project id + 'X'
select count(*) into :li_count
from owner
where project_id =:gs_project
and  DWG_UPLOAD ='X'
using itr_Test;

IF li_count =0 THEN

INSERT INTO OWNER (PROJECT_ID,OWNER_TYPE,OWNER_CD ,LAST_USER ,	LAST_UPDATE ,DWG_UPLOAD,DWG_UPLOAD_TIMESTAMP )
	VALUES (:gs_project,:ls_ownertype,:ls_owner_cd,:gs_userid,:ldToday,'X',:ldToday)	
	using itr_Test;

if itr_Test.sqlcode = -1 then
	messagebox("Database Error",itr_Test.sqlerrtext,Exclamation!)
	rollback;
	return -1
	
else
	commit;
end if

END IF

//st_2.Text = "Record is inserted into Owner with ownercode  " + string(ll_prdownerid)

END IF

return 1
end function

public subroutine of_connect ();itr_Prod = CREATE transaction
itr_Prod.DBMS = "SNC SQL Native Client(OLE DB)"
itr_Prod.LogPass ="$got2LUVsims"
itr_Prod.ServerName = "SIMSDB.menlolog.com"
itr_Prod.LogId = "sims"
itr_Prod.AutoCommit = true
itr_Prod.DBParm = "Database='SIMS33Prd',TrimSpaces=1,ProviderString = 'MARS Connection=False'"

CONNECT USING itr_Prod ;

end subroutine

public subroutine of_disconnect ();
disconnect using  itr_prod;
disconnect using  itr_Test;
end subroutine

public function integer of_copylocation (string ls_lcode, string ls_wh_code);string ls_WH_Code1,ls_L_Code,ls_L_Type,ls_Project_Reserved,ls_User_Field1
string 	ls_User_Field2,ls_User_Field3,ls_Last_User,ls_Standard_Of_Measure,ls_Zone_Id,ls_SKU_Reserved
string	ls_Storage_Type_Cd,ls_Equipment_Type_Cd,ls_Location_Available_Ind,ls_Validate_Weight_Ind,ls_Validate_Dims_Ind
string	ls_CC_Rnd_Cnt_Ind,ls_Loc_Non_Pickable_Ind
long  ll_Length,ll_Width,ll_Height,ll_CBM,ll_Weight_Capacity,ll_Priority,ll_Picking_Seq,ll_CC_Rnd_Loc_Nbr,ll_uid,ll_version
Datetime 	ldToday,ld_Last_Cycle_Cnt_Date,ld_Last_Rnd_Cycle_Count_Date

ldToday = f_getLocalWorldTime( gs_default_wh ) 

select  WH_Code,L_Code,L_Type,Length,Width,Height,CBM,Weight_Capacity,Priority,Project_Reserved,User_Field1,
		 User_Field2,User_Field3,Last_User,Standard_Of_Measure,Zone_Id,Picking_Seq,SKU_Reserved,Last_Cycle_Cnt_Date,
		 Storage_Type_Cd,Equipment_Type_Cd,Location_Available_Ind,Validate_Weight_Ind,Validate_Dims_Ind,Last_Rnd_Cycle_Count_Date,
		 CC_Rnd_Cnt_Ind,CC_Rnd_Loc_Nbr,Loc_Non_Pickable_Ind
INTO  :ls_WH_Code1,:ls_L_Code,:ls_L_Type,:ll_Length,:ll_Width,:ll_Height,:ll_CBM,:ll_Weight_Capacity,:ll_Priority,:ls_Project_Reserved,:ls_User_Field1,
		:ls_User_Field2,:ls_User_Field3,:ls_Last_User,:ls_Standard_Of_Measure,:ls_Zone_Id,:ll_Picking_Seq,:ls_SKU_Reserved,:ld_Last_Cycle_Cnt_Date,
		:ls_Storage_Type_Cd,:ls_Equipment_Type_Cd,:ls_Location_Available_Ind,:ls_Validate_Weight_Ind,:ls_Validate_Dims_Ind,:ld_Last_Rnd_Cycle_Count_Date,
		:ls_CC_Rnd_Cnt_Ind,:ll_CC_Rnd_Loc_Nbr,:ls_Loc_Non_Pickable_Ind
FROM Location
WHERE L_Code = :ls_lcode
and wh_code =:ls_WH_Code
using itr_Prod;

INSERT INTO LOCATION 
		 (WH_Code,L_Code,L_Type,Length,Width,Height,CBM,Weight_Capacity,Priority,Project_Reserved,User_Field1,
		 User_Field2,User_Field3,Last_User,Last_Update,Standard_Of_Measure,Zone_Id,Picking_Seq,SKU_Reserved,Last_Cycle_Cnt_Date,
		 Storage_Type_Cd,Equipment_Type_Cd,Location_Available_Ind,Validate_Weight_Ind,Validate_Dims_Ind,Last_Rnd_Cycle_Count_Date,
		 CC_Rnd_Cnt_Ind,CC_Rnd_Loc_Nbr,Loc_Non_Pickable_Ind)
VALUES (:ls_WH_Code1,:ls_L_Code,:ls_L_Type,:ll_Length,:ll_Width,:ll_Height,:ll_CBM,:ll_Weight_Capacity,:ll_Priority,:ls_Project_Reserved,:ls_User_Field1,
		:ls_User_Field2,:ls_User_Field3,:gs_userid,:ldToday,:ls_Standard_Of_Measure,:ls_Zone_Id,:ll_Picking_Seq,:ls_SKU_Reserved,:ld_Last_Cycle_Cnt_Date,
		:ls_Storage_Type_Cd,:ls_Equipment_Type_Cd,:ls_Location_Available_Ind,:ls_Validate_Weight_Ind,:ls_Validate_Dims_Ind,:ld_Last_Rnd_Cycle_Count_Date,
		:ls_CC_Rnd_Cnt_Ind,:ll_CC_Rnd_Loc_Nbr,:ls_Loc_Non_Pickable_Ind)		
using itr_Test;		

if itr_Test.sqlcode = -1 then
	messagebox("Database Error",itr_Test.sqlerrtext,Exclamation!)
rollback;
return -1
else
commit;
end if


return 1
end function

public function integer of_roprocess ();string  ls_rono  ,ls_invoiceno, ls_sku , ls_supp_code , ls_owner_id  ,ls_item_grp , ls_supp_cd , ls_ownerid,ls_status,ls_orderno
string  LS_PRDSUPPCODE,LS_PRDOWNERID,LS_TSTOWNERID,LS_PRDSKU,ls_wh_code,ls_lcode,ls_ord
string ls_projectid,ls_ord_Type,ls_ord_Type_Desc, ls_Last_User,ls_multiple_Supplier_Ind,ls_Backorder_Type_Ind

string ls_project_id,ls_grp,ls_dono ,LS_PRDOWNERID1
integer li_count
long LL_PRDSKU,LL_PRDSUPPCODE,LL_PRDOWNERID,LL_PRDOWNERID2


Datetime ldToday
ldToday = f_getLocalWorldTime( gs_default_wh ) 

ls_orderno =sle_1.text

	
	select count(*) into :li_count
	from receive_master 
	where supp_invoice_no = :ls_orderno 
	and project_id =:gs_project
	using itr_Prod ;

	IF li_count =0 then
		MessageBox("Invalid Data", " Please enter valid Information "    ,Stopsign!)
		Return 0
	end if 



	//get the RONO and status from PROD db
	select RO_NO, ord_status,wh_code into :ls_rono,:ls_status ,:ls_wh_code
	from receive_master 
	where supp_invoice_no = :ls_orderno and project_id=:gs_project
	using itr_Prod ;

	//get the count from Test db of RO_NO
	select  count(*) into :li_count
	from receive_master
	where RO_NO = :ls_rono and project_id=:gs_project
	using itr_Test;

	IF li_count > 0 THEN
		MessageBox("RO_NO", "Receiving Order:"  +  ls_rono  +  " is already exists in Test db",Stopsign!)
		Return 0
	END IF

	SetMicroHelp("Process is initiated.....")

	/*1. CURSOR ->  TO INSERT OWNER  RECORDS      */
	DECLARE CURR_GET_OWNERID CURSOR FOR
		SELECT DISTINCT OWNER_ID
		FROM RECEIVE_DETAIL
		WHERE RO_NO = :ls_rono
		using itr_prod;

	OPEN CURR_GET_OWNERID;

	DO WHILE itr_prod.sqlcode = 0 
	FETCH NEXT  CURR_GET_OWNERID INTO :LL_PRDOWNERID;
	
	if itr_Prod.sqlcode < 0 then 
		MessageBox("Fetch Error",itr_Prod.sqlerrtext) 
	elseif itr_Prod.sqlcode = 0 then 
		of_copyowner(LL_PRDOWNERID) //inserting record
	if itr_Prod.sqlcode <> 0 then 
		MessageBox("select",  itr_Prod.sqlerrtext) 
	end if 
	end if 

	LOOP 
	CLOSE CURR_GET_OWNERID;

	/*2. CURSOR -> TO INSERT SUPPLIER RECORDS*/
	DECLARE CURR_GET_SUPPCODE  CURSOR FOR 
		SELECT DISTINCT SUPP_CODE 
		FROM RECEIVE_DETAIL
		WHERE RO_NO = :ls_rono
		USING itr_Prod ;
	
	OPEN CURR_GET_SUPPCODE;

	DO WHILE itr_Prod.sqlcode = 0 
	FETCH NEXT  CURR_GET_SUPPCODE INTO :LS_PRDSUPPCODE;

	if itr_Prod.sqlcode < 0 then 
		MessageBox("Fetch Error",itr_Prod.sqlerrtext) 
	elseif itr_Prod.sqlcode = 0 then 
		of_copysupplier(ls_prdsuppcode)  //Inserting supp record
	if itr_Prod.sqlcode <> 0 then 
		MessageBox("select",  itr_Prod.sqlerrtext) 
	end if 
	end if 

	LOOP 
	CLOSE CURR_GET_SUPPCODE;
	
	/*3. INSERT RECORD INTO WAREHOUSE */		
	select count(*) into :li_count
	from warehouse
	where wh_code= :ls_wh_code
	using itr_test;

	IF li_count =0 THEN
		of_copywarehouse(ls_wh_code) //insert into WH
	END IF

	/*4.CUROSR -> TO INSERT ITEM-MASTER*/
		
	DECLARE CURR_GET_ITEM_MASTER CURSOR FOR
		SELECT DISTINCT SKU ,SUPP_CODE
		FROM RECEIVE_DETAIL
		WHERE RO_NO = :ls_rono
		using itr_Prod;
	
	OPEN CURR_GET_ITEM_MASTER;
	DO WHILE itr_Prod.sqlcode = 0 
	FETCH NEXT  CURR_GET_ITEM_MASTER INTO :LS_PRDSKU,:LS_PRDSUPPCODE;

	if itr_Prod.sqlcode < 0 then 
		MessageBox("Fetch Error",itr_Prod.sqlerrtext) 
	elseif itr_Prod.sqlcode = 0 then 
	
	/*5.INSERT RECORDS INTO LOCATION*/
			select L_code,grp into :ls_lcode,:ls_grp
			from Item_master
			where sku=:LS_PRDSKU
			using itr_Prod;
	
	IF  ls_lcode <>' ' OR ls_lcode <> '' OR ls_lcode <>'NULL' then
			select count(*) into :li_count
			from location
			where l_code= :ls_lcode
			using itr_Test;
			
			select wh_code into :ls_wh_code
			from location
			where l_code =:ls_lcode
			using itr_Prod;
			
		IF li_count =0 then
			of_copylocation(ls_lcode,ls_wh_code)
		end if
	end if
	
	/*6. INSERT RECORDS INTO ITEM GROUP */
	IF ls_grp <>' ' OR ls_grp <>'' OR ls_grp <>'NULL' then
		select count(*) into :li_count
		from item_group
		where grp =:ls_grp
		and project_id =:gs_project
		using itr_Test;
	
		IF li_count =0 then
			of_copyitemgroup(ls_grp)
		END IF
	END IF	
	
	of_copyitemmaster(ls_prdsku,ls_prdsuppcode) //insert records into Item Master

	end if 

	LOOP 
	CLOSE CURR_GET_ITEM_MASTER;

	/*7. Receive order type -*/

	//get the ordtype from prod db
	SELECT  ord_type into :ls_ord
	FROM RECEIVE_master
	WHERE RO_NO = :ls_rono
	using itr_Prod;

	//get the count of ordtype from test db
	select  COUNT(*) into :li_count
	from  Receive_Order_Type
	where Project_Id = :gs_project and Ord_Type = :ls_ord
	using itr_Test;
						

	IF li_count  = 0 then
		select  Project_Id, Ord_Type,Ord_Type_Desc, Last_User,  Multiple_Supplier_Ind,Backorder_Type_Ind
			into :ls_projectid,:ls_ord_Type,:ls_ord_Type_Desc, :ls_Last_User, :ls_multiple_Supplier_Ind,:ls_Backorder_Type_Ind
		from Receive_order_type
		where Project_Id = :gs_project and Ord_Type = :ls_ord
		using itr_Prod;
			
	Insert into Receive_Order_Type 
			(Project_Id, Ord_Type,Ord_Type_Desc, Last_User, Last_Update, Multiple_Supplier_Ind,Backorder_Type_Ind ) 
	values (:ls_projectid,:ls_ord_Type,:ls_ord_Type_Desc, :gs_userid, :ldToday,:ls_multiple_Supplier_Ind,:ls_Backorder_Type_Ind)
	 using itr_Test;
	End	if	

	/*8. Inserting records into Receive_Master and Receive_Detail*/
	of_copyreceivemaster(ls_rono) 
	of_copyreceivedetail(ls_rono,ls_status) 

st_2.text = st_2.Text + 'r' + "Successfully Receiving records are inserted"

return 1
end function

public function integer of_doprocess ();string  ls_rono  ,ls_invoiceno, ls_sku , ls_supp_code , ls_owner_id  ,ls_item_grp , ls_supp_cd , ls_ownerid,ls_status,ls_orderno
string  LS_PRDSUPPCODE,LS_PRDOWNERID,LS_TSTOWNERID,LS_PRDSKU,ls_wh_code,ls_lcode,ls_ord
string ls_projectid,ls_ord_Type,ls_ord_Type_Desc, ls_Last_User,ls_multiple_Supplier_Ind,ls_Backorder_Type_Ind

string ls_project_id,ls_grp,ls_dono ,LS_PRDOWNERID1
integer li_count
long LL_PRDSKU,LL_PRDSUPPCODE,LL_PRDOWNERID,LL_PRDOWNERID2


Datetime ldToday
ldToday = f_getLocalWorldTime( gs_default_wh ) 

ls_orderno =sle_1.text

	
SetPointer(HourGlass!)
select count(*) into :li_count
from delivery_master 
where invoice_no = :ls_orderno 
and project_id =:gs_project
using itr_Prod ;

IF li_count =0 then
	MessageBox("Invalid Data", " Please enter valid  information "    ,Stopsign!)
	Return 0
end if 

//get the DONO and status from PROD db
select DO_NO, ord_status,wh_code into :ls_dono,:ls_status ,:ls_wh_code
from delivery_master 
where invoice_no = :ls_orderno and project_id=:gs_project
using itr_Prod ;


//get the count from Test db of DO_NO
select  count(*) into :li_count
from Delivery_master
where DO_NO = :ls_dono and invoice_no=:ls_orderno and project_id=:gs_project
using itr_Test;

IF li_count > 0 THEN
	MessageBox("DO_NO", "Delivery Order:"  +  ls_dono  +  " is already exists in Test db",Stopsign!)
	Return 0
END IF

SetMicroHelp("Process is initiated.....")

/*9. CURSOR ->  TO INSERT OWNER  RECORDS      */
DECLARE CURR_GET_OWNERID3 CURSOR FOR
	SELECT DISTINCT OWNER_ID
	FROM DELIVERY_DETAIL
	WHERE dO_NO = :ls_dono
	using itr_Prod;

OPEN CURR_GET_OWNERID3;

DO WHILE itr_Prod.sqlcode = 0 
FETCH NEXT  CURR_GET_OWNERID3 INTO :LL_PRDOWNERID;

if itr_Prod.sqlcode < 0 then 
	MessageBox("Fetch Error",itr_Prod.sqlerrtext) 
elseif itr_Prod.sqlcode = 0 then 
	of_copyowner(LL_PRDOWNERID) //inserting record
if itr_Prod.sqlcode <> 0 then 
	MessageBox("select",  itr_Prod.sqlerrtext) 
end if 
end if 

LOOP 
CLOSE CURR_GET_OWNERID3;

/*9.A. CURSOR ->  TO INSERT OWNER  RECORDS      */
DECLARE CURR_GET_OWNERID1 CURSOR FOR
	SELECT DISTINCT SKU
	FROM DELIVERY_DETAIL
	WHERE dO_NO = :ls_dono
	using itr_Prod;

OPEN CURR_GET_OWNERID1;
DO WHILE itr_Prod.sqlcode = 0 		
FETCH NEXT  CURR_GET_OWNERID1 INTO :LS_PRDOWNERID1;

	DECLARE CURR_GET_OWNERID2 CURSOR FOR
		SELECT DISTINCT OWNER_ID
		FROM ITEM_MASTER
		WHERE SKU = :LS_PRDOWNERID1
		AND Project_id= :gs_project
		using itr_Prod;

	OPEN CURR_GET_OWNERID2;
	FETCH NEXT  CURR_GET_OWNERID2 INTO :LL_PRDOWNERID2;

	DO WHILE itr_Prod.sqlcode = 0
	if itr_Prod.sqlcode < 0 then 
		MessageBox("Fetch Error",itr_Prod.sqlerrtext) 
	elseif itr_Prod.sqlcode = 0 then 
		of_copyowner(LL_PRDOWNERID2) //inserting record
	if itr_Prod.sqlcode <> 0 then 
		MessageBox("select",  itr_Prod.sqlerrtext) 
	end if 
	end if 

	FETCH NEXT  CURR_GET_OWNERID2 INTO :LL_PRDOWNERID2;
	LOOP 
	CLOSE CURR_GET_OWNERID2;

FETCH NEXT  CURR_GET_OWNERID1 INTO :LS_PRDOWNERID1;
LOOP
CLOSE CURR_GET_OWNERID1;


/*10. CURSOR -> TO INSERT SUPPLIER RECORDS*/
DECLARE CURR_GET_SUPPCODE1  CURSOR FOR 
	SELECT DISTINCT SUPP_CODE 
	FROM DELIVERY_DETAIL
	WHERE DO_NO = :ls_dono
	USING itr_Prod ;

OPEN CURR_GET_SUPPCODE1;
DO WHILE itr_Prod.sqlcode = 0 
FETCH NEXT  CURR_GET_SUPPCODE1 INTO :LS_PRDSUPPCODE;

if itr_Prod.sqlcode < 0 then 
	MessageBox("Fetch Error",itr_Prod.sqlerrtext) 
elseif itr_Prod.sqlcode = 0 then 
	of_copysupplier(ls_prdsuppcode)  //Inserting supp record
if itr_Prod.sqlcode <> 0 then 
	MessageBox("select",  itr_Prod.sqlerrtext) 
end if 
end if 

LOOP 
CLOSE CURR_GET_SUPPCODE1;
	

/*11. INSERT RECORD INTO WAREHOUSE */		
select count(*) into :li_count
from warehouse
where wh_code= :ls_wh_code
using itr_Test;

IF li_count =0 THEN
	of_copywarehouse(ls_wh_code) //insert into WH
END IF

/*12.CUROSR -> TO INSERT ITEM-MASTER*/
DECLARE CURR_GET_ITEM_MASTER1 CURSOR FOR
	SELECT DISTINCT SKU ,SUPP_CODE
	FROM DELIVERY_DETAIL
	WHERE DO_NO = :ls_dono
	using itr_Prod;

OPEN CURR_GET_ITEM_MASTER1;

DO WHILE itr_Prod.sqlcode = 0 
FETCH NEXT  CURR_GET_ITEM_MASTER1 INTO :LS_PRDSKU,:LS_PRDSUPPCODE;

if itr_Prod.sqlcode < 0 then 
	MessageBox("Fetch Error",itr_Prod.sqlerrtext) 
elseif itr_Prod.sqlcode = 0 then 

/*13.INSERT RECORDS INTO LOCATION*/
	select L_code,grp into :ls_lcode,:ls_grp
	from Item_master
	where sku=:LS_PRDSKU
	using itr_Prod;


IF  ls_lcode <>' ' OR ls_lcode <> '' OR ls_lcode <>'NULL' then
	select count(*) into :li_count
	from location
	where l_code= :ls_lcode
	using itr_Test;	

	select wh_code into :ls_wh_code
	from location
	where l_code =:ls_lcode
	using itr_Prod;
	

	IF li_count =0 then
		of_copylocation(ls_lcode,ls_wh_code)
	end if
end if

/*14. INSERT RECORDS INTO ITEM GROUP */
IF ls_grp <>' ' OR ls_grp <>'' OR ls_grp <>'NULL' then
	select count(*) into :li_count
	from item_group
	where grp =:ls_grp
	and project_id =:gs_project
	using itr_Test;

IF li_count =0 then
	of_copyitemgroup(ls_grp)
END IF
END IF	

/*15. INSERT RECORDS INTO CONTENT*/

//of_copyitemmaster(ls_prdsku,ls_prdsuppcode) //insert records into Item Master
of_copycontent(ls_prdsku,ls_prdsuppcode,ls_wh_code) //insert records into content
//of_copycontent(ls_prdsku,ls_prdsuppcode) //insert records into content

end if 

LOOP 
CLOSE CURR_GET_ITEM_MASTER1;


/*16. Inserting records into Receive_Master and Receive_Detail*/
of_copydeliverymaster(ls_dono) 
of_copydeliverydetail(ls_dono,ls_status)

st_2.text = st_2.Text + 'r' + "Successfully Delivery orders are inserted"

return 1
end function

public function integer of_copycontent (string ls_prdsku, string ls_prdsuppcode, string ls_prdwh_code);string ls_projectid,ls_SKU,ls_Supp_Code,ls_Country_Of_Origin,ls_WH_Code,ls_L_Code,ls_Inventory_Type
string ls_Serial_No,ls_Lot_No,ls_RO_No,ls_PO_No,ls_PO_No2,ls_Reason_Cd,ls_Last_User,ls_Container_Id,ls_Old_Inventory_Type
string ls_Old_Country_Of_Origin,ls_CC_No,ls_status
string  dwsyntax_str,ls_sql, presentation_str, lsErrText

long ll_Owner_Id,ll_Avail_Qty,ll_Component_Qty,ll_Component_No,ll_Cntnr_Length,ll_Cntnr_Width,ll_Cntnr_Height,ll_Cntnr_Weight,ll_row,ll_ownerid
int li_count


Datetime ldToday,ld_Expiration_Date
ldToday = f_getLocalWorldTime( gs_default_wh ) 

DataStore lds_copycontent

SELECT COUNT(*) INTO :li_count
FROM CONTENT
WHERE PROJECT_ID = :gs_project
AND SKU =:ls_prdsku
AND SUPP_CODE =:ls_prdsuppcode
AND WH_CODE =:ls_prdwh_code
using itr_Test;

IF li_count =0 THEN
	
	presentation_str = "style(type=grid)"
	lds_copycontent = CREATE datastore
	ls_sql =   " SELECT Project_Id,SKU,Supp_Code,Owner_Id,Country_Of_Origin,WH_Code,L_Code,Inventory_Type,Serial_No," &
				+"Lot_No,RO_No,PO_No,PO_No2,Reason_Cd,Avail_Qty,Component_Qty,Last_User,Component_No,Container_Id,Expiration_Date," &
				+"Cntnr_Length,Cntnr_Width,Cntnr_Height,Cntnr_Weight,Old_Inventory_Type,Old_Country_Of_Origin,CC_No"

	ls_sql += " FROM dbo.CONTENT "
	ls_sql += " WHERE project_id = '" + gs_project + "' "
	ls_sql += " AND SKU = '" + ls_prdsku + "' "
	ls_sql += " AND SUPP_CODE = '" + ls_prdsuppcode + "' "
	ls_sql += " AND WH_CODE = '" + ls_prdwh_code + "' "

	dwsyntax_str = SQLCA.SyntaxFromSQL(ls_sql, presentation_str, lsErrText)
	lds_copycontent.Create( dwsyntax_str, lsErrText)
	lds_copycontent.SetTransObject(itr_prod);	


IF lsErrText <> '' THEN
MessageBox( 'Error...', lsErrText )
RETURN 1
END IF

lds_copycontent.Retrieve( )
li_count =lds_copycontent.RowCount( )
IF li_count = 0 THEN
	IF MessageBox ("No Inventory available in PROD", "No Inventory with combination of SKU -" + ls_prdsku +  "  SuppCode- " + ls_prdsuppcode + "  WHCode " + ls_prdwh_code + " Do you want to continue?", Question!, YesNo!,1)=2 THEN
		rollback;
		RETURN -1

	END IF
END IF

FOR ll_row = 1 TO lds_copycontent.RowCount( )
ls_projectid = lds_copycontent.GetItemString( ll_row, 'PROJECT_ID' )
ls_SKU = lds_copycontent.GetItemString( ll_row, 'SKU' )
ls_Supp_Code = lds_copycontent.GetItemString( ll_row, 'Supp_Code' )
ll_Owner_Id = lds_copycontent.GetItemNumber( ll_row, 'Owner_Id' )
ls_Country_Of_Origin = lds_copycontent.GetItemString( ll_row, 'Country_Of_Origin' )
ls_WH_Code = lds_copycontent.GetItemString( ll_row, 'WH_Code' )
ls_L_Code = lds_copycontent.GetItemString( ll_row, 'L_Code' )
ls_Inventory_Type = lds_copycontent.GetItemString( ll_row, 'Inventory_Type' )
ls_Serial_No = lds_copycontent.GetItemString( ll_row, 'Serial_No' )
ls_Lot_No = lds_copycontent.GetItemString( ll_row, 'Lot_No' )
ls_RO_No = lds_copycontent.GetItemString( ll_row, 'RO_No' )
ls_PO_No = lds_copycontent.GetItemString( ll_row, 'PO_No' )
ls_PO_No2 = lds_copycontent.GetItemString( ll_row, 'PO_No2' )
ls_Reason_Cd = lds_copycontent.GetItemString( ll_row, 'Reason_Cd' )
ll_Avail_Qty = lds_copycontent.GetItemNumber( ll_row, 'Avail_Qty' )
ll_Component_Qty = lds_copycontent.GetItemNumber( ll_row, 'Component_Qty' )
ls_Last_User = lds_copycontent.GetItemString( ll_row, 'Last_User' )
ll_Component_No = lds_copycontent.GetItemNumber( ll_row, 'Component_No' )
ls_Container_Id = lds_copycontent.GetItemString( ll_row, 'Container_Id' )
ld_Expiration_Date = lds_copycontent.GetItemDatetime( ll_row, 'Expiration_Date' )
ll_Cntnr_Length = lds_copycontent.GetItemNumber( ll_row, 'Cntnr_Length' )
ll_Cntnr_Width = lds_copycontent.GetItemNumber( ll_row, 'Cntnr_Width' )
ll_Cntnr_Height = lds_copycontent.GetItemNumber( ll_row, 'Cntnr_Height' )

ll_Cntnr_Weight = lds_copycontent.GetItemNumber( ll_row, 'Cntnr_Weight' )
ls_Old_Inventory_Type = lds_copycontent.GetItemString( ll_row, 'Old_Inventory_Type' )
ls_Old_Country_Of_Origin = lds_copycontent.GetItemString( ll_row, 'Old_Country_Of_Origin' )
ls_CC_No = lds_copycontent.GetItemString( ll_row, 'CC_No' )

select count(*) into :li_count 	from location 	where l_code= :ls_L_Code and wh_code= :ls_WH_Code
using itr_Test;
				
IF li_count =0 then
		of_copylocation(ls_L_Code,ls_WH_Code)
end if

select count(*) into :li_count from item_master where  sku=:ls_sku and supp_code=:ls_Supp_Code
using itr_Test;

IF li_count =0 THEN
	of_copyitemmaster(ls_sku,ls_Supp_Code) //insert records into Item Master
END IF
	

select owner_id into :ll_ownerid from item_master where sku=:ls_sku and project_id=:gs_project and supp_code=:ls_Supp_Code
using itr_test;

IF ll_Owner_Id <> ll_ownerid THEN
	ll_Owner_Id=ll_ownerid
END IF;

select count(*) into :li_count from receive_master where ro_no =:ls_RO_No
using itr_Test;

IF li_count =0 THEN
	select ord_status into :ls_status from receive_master where ro_no =:ls_RO_No
	using itr_Prod;
	
	of_copyreceivemaster(ls_RO_No) 
	of_copyreceivedetail(ls_RO_No,ls_status) 
END IF


	INSERT INTO CONTENT (
			Project_Id,SKU,Supp_Code,Owner_Id,Country_Of_Origin,WH_Code,L_Code,Inventory_Type,Serial_No,Lot_No,RO_No,PO_No,PO_No2,Reason_Cd,
			Avail_Qty,Component_Qty,Last_User,Last_Update,Component_No,Container_Id,Expiration_Date,
			Cntnr_Length,Cntnr_Width,Cntnr_Height,Cntnr_Weight,Old_Inventory_Type,Old_Country_Of_Origin,CC_No )

	VALUES (:ls_ProjectId,:ls_SKU,:ls_Supp_Code,:ll_Owner_Id,:ls_Country_Of_Origin,:ls_WH_Code,:ls_L_Code,:ls_Inventory_Type,
		:ls_Serial_No,:ls_Lot_No,:ls_RO_No,:ls_PO_No,:ls_PO_No2,:ls_Reason_Cd,:ll_Avail_Qty,:ll_Component_Qty,:ls_Last_User,
		:ldToday,:ll_Component_No,:ls_Container_Id,:ld_Expiration_Date,:ll_Cntnr_Length,:ll_Cntnr_Width,:ll_Cntnr_Height,:ll_Cntnr_Weight,
		:ls_Old_Inventory_Type,:ls_Old_Country_Of_Origin,:ls_CC_No)
	USING itr_Test;


if itr_Test.sqlcode = -1 then
	messagebox("Database Error",itr_Test.sqlerrtext,Exclamation!)
rollback;
return -1
else
commit;
end if


NEXT
DESTROY lds_copycontent
END IF


return 1
end function

public subroutine of_connect_target ();itr_Test = create transaction
itr_Test.DBMS = "SNC SQL Native Client(OLE DB)"	

if rb_test.checked then
	itr_Test.LogPass = "$got2LUVsims"
	itr_Test.ServerName = "DCXVTSQ038"
	itr_Test.LogId = "sims"
	itr_Test.AutoCommit = True
	itr_Test.DBParm = "Database='sims33test',Provider='SQLNCLI10',TrustServerCertificate=1"
end if
	
if rb_dev.checked then

	itr_Test.LogPass = "$got2LUVsims"
	itr_Test.ServerName = "DCXVTSQ038"
	itr_Test.LogId = "sims"
	itr_Test.AutoCommit = True
	itr_Test.DBParm = "Database='sims33dev',Provider='SQLNCLI10',TrustServerCertificate=1"
end if
	
CONNECT USING itr_Test;

end subroutine

on w_exportordertest.create
this.cb_refresh=create cb_refresh
this.rb_3=create rb_3
this.rb_2=create rb_2
this.rb_other=create rb_other
this.rb_test=create rb_test
this.rb_dev=create rb_dev
this.sle_2=create sle_2
this.st_3=create st_3
this.rb_delivery=create rb_delivery
this.rb_receive=create rb_receive
this.st_2=create st_2
this.cb_verify=create cb_verify
this.cb_close=create cb_close
this.st_1=create st_1
this.sle_1=create sle_1
this.cb_submit=create cb_submit
this.gb_2=create gb_2
this.gb_3=create gb_3
this.gb_1=create gb_1
this.datastore_1=create datastore_1
this.Control[]={this.cb_refresh,&
this.rb_3,&
this.rb_2,&
this.rb_other,&
this.rb_test,&
this.rb_dev,&
this.sle_2,&
this.st_3,&
this.rb_delivery,&
this.rb_receive,&
this.st_2,&
this.cb_verify,&
this.cb_close,&
this.st_1,&
this.sle_1,&
this.cb_submit,&
this.gb_2,&
this.gb_3,&
this.gb_1}
end on

on w_exportordertest.destroy
destroy(this.cb_refresh)
destroy(this.rb_3)
destroy(this.rb_2)
destroy(this.rb_other)
destroy(this.rb_test)
destroy(this.rb_dev)
destroy(this.sle_2)
destroy(this.st_3)
destroy(this.rb_delivery)
destroy(this.rb_receive)
destroy(this.st_2)
destroy(this.cb_verify)
destroy(this.cb_close)
destroy(this.st_1)
destroy(this.sle_1)
destroy(this.cb_submit)
destroy(this.gb_2)
destroy(this.gb_3)
destroy(this.gb_1)
destroy(this.datastore_1)
end on

event open;
cb_refresh.PostEvent("clicked")
end event

type cb_refresh from commandbutton within w_exportordertest
integer x = 1577
integer y = 1532
integer width = 402
integer height = 116
integer taborder = 60
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Refresh"
end type

event clicked;SetMicroHelp("Connecting to PROD DB.....")
of_connect()
of_connect_target()
// Connect to the Prod db

string ls_invno

if NOT (isvalid(w_do) or  isvalid(w_ro)) then 
	Messagebox("Info","Order window should be open to copy")
	cb_submit.enabled = false
	cb_verify.enabled = false
	return
end if

if isvalid(w_do) then
	is_sysno = w_do.idw_main.GetITemString(1,'do_no')
	rb_delivery.checked = true
	select invoice_no into :ls_invno	from delivery_master where do_no = :is_sysno and project_id=:gs_project using itr_Prod ;	
end if

if isvalid(w_ro) then
	is_sysno = w_ro.idw_main.GetITemString(1,'ro_no')
	rb_receive.checked = true
	select supp_invoice_no into :ls_invno	from receive_master where ro_no = :is_sysno and project_id=:gs_project using itr_Prod ;		
end if

cb_verify.enabled = True
sle_1.text = ls_invno
sle_2.text = is_sysno

end event

type rb_3 from radiobutton within w_exportordertest
integer x = 91
integer y = 316
integer width = 347
integer height = 80
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 134217730
long backcolor = 67108864
boolean enabled = false
string text = "Single"
boolean checked = true
end type

type rb_2 from radiobutton within w_exportordertest
integer x = 439
integer y = 320
integer width = 334
integer height = 80
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 134217730
long backcolor = 67108864
boolean enabled = false
string text = "Multiple"
end type

type rb_other from radiobutton within w_exportordertest
integer x = 1285
integer y = 492
integer width = 805
integer height = 80
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 134217730
long backcolor = 67108864
boolean enabled = false
string text = "Other Master Records"
end type

type rb_test from radiobutton within w_exportordertest
integer x = 46
integer y = 84
integer width = 315
integer height = 80
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 134217730
long backcolor = 67108864
string text = "Test"
boolean checked = true
end type

type rb_dev from radiobutton within w_exportordertest
integer x = 425
integer y = 84
integer width = 247
integer height = 80
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 134217730
long backcolor = 67108864
string text = "Dev"
end type

type sle_2 from singlelineedit within w_exportordertest
integer x = 974
integer y = 736
integer width = 681
integer height = 96
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 12632256
textcase textcase = upper!
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type st_3 from statictext within w_exportordertest
integer y = 628
integer width = 731
integer height = 96
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 8388608
long backcolor = 67108864
boolean enabled = false
string text = "Order No (Invoice No):"
boolean focusrectangle = false
end type

type rb_delivery from radiobutton within w_exportordertest
integer x = 649
integer y = 492
integer width = 622
integer height = 80
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 134217730
long backcolor = 67108864
boolean enabled = false
string text = "Delivery Order"
end type

type rb_receive from radiobutton within w_exportordertest
integer x = 27
integer y = 492
integer width = 635
integer height = 80
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 134217730
long backcolor = 67108864
boolean enabled = false
string text = "Receiving Order"
end type

type st_2 from statictext within w_exportordertest
integer x = 105
integer y = 884
integer width = 2021
integer height = 608
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 134217730
long backcolor = 67108864
long bordercolor = 16777215
boolean focusrectangle = false
end type

type cb_verify from commandbutton within w_exportordertest
integer x = 741
integer y = 1528
integer width = 402
integer height = 116
integer taborder = 50
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "VERI&FY"
end type

event clicked;/*
* Author:  Madhu KrushnamRaju
* Purpose:  copy the data from PROD db to TEST db of Inbound and Outbound Orders
*/

SetMicroHelp("Connecting to PROD DB.....")
// Connect to the Prod db
transaction ltr_Prod
ltr_Prod = CREATE transaction
ltr_Prod.DBMS = "SNC SQL Native Client(OLE DB)"
ltr_Prod.LogPass ="$got2LUVsims"
ltr_Prod.ServerName = "SIMSDB.menlolog.com"
ltr_Prod.LogId = "sims"
ltr_Prod.AutoCommit = true
ltr_Prod.DBParm = "Database='SIMS33Prd',TrimSpaces=1,ProviderString = 'MARS Connection=False'"
CONNECT USING ltr_Prod ;

string  ls_orderno
int li_count

ls_orderno =sle_1.text

SetPointer(HourGlass!)

IF rb_Receive.checked=true then   /*process for  Inbound Orders*/
	
	select count(*) into :li_count
	from receive_master 
	where ro_no = :is_sysno 
	and project_id =:gs_project
	using ltr_Prod ;
	
	IF li_count =0 then
		MessageBox("Invalid Data", " Please enter valid  project id/Invoice no/OrderType "    ,Stopsign!)
		Return 1
	end if 

	select count(*) into :li_count
	from receive_master 
	where ro_no = :is_sysno 
	and project_id =:gs_project
	using itr_test ;
	
	IF li_count > 0 then
		MessageBox("Invalid Data", " Already Exist in Target DB"    ,Stopsign!)
		Return 1
	end if 

	
else  /*Outbound Order Process -START*/

	select count(*) into :li_count
	from delivery_master 
	where do_no = :is_sysno 
	and project_id =:gs_project
	using ltr_Prod ;

	IF li_count =0 then
		MessageBox("Invalid Data", " Please enter valid  project id/Invoice no/OrderType "    ,Stopsign!)
		Return 1
	end if 


	select count(*) into :li_count
	from delivery_master 
	where do_no = :is_sysno 
	and project_id =:gs_project
	using itr_test ;

	IF li_count > 0 then
		MessageBox("Invalid Data", " Already Exist in Target DB"    ,Stopsign!)
		Return 1
	end if 
end if


MessageBox("Verified","Entered information is valid, please click on SUBMIT button to continue further")
cb_submit.enabled = true
return 1;
end event

type cb_close from commandbutton within w_exportordertest
integer x = 1161
integer y = 1528
integer width = 402
integer height = 112
integer taborder = 40
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Close"
end type

event clicked;close(parent)
end event

type st_1 from statictext within w_exportordertest
integer y = 744
integer width = 731
integer height = 96
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 8388608
long backcolor = 67108864
boolean enabled = false
string text = "System Order No"
boolean focusrectangle = false
end type

type sle_1 from singlelineedit within w_exportordertest
integer x = 974
integer y = 624
integer width = 681
integer height = 96
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 12632256
textcase textcase = upper!
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type cb_submit from commandbutton within w_exportordertest
integer x = 297
integer y = 1528
integer width = 402
integer height = 112
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "SUBMIT"
end type

event clicked;/*
* Author:  Madhu KrushnamRaju
* Purpose:  copy the data from PROD db to TEST db of Inbound and Outbound Orders
*/



SetPointer(HourGlass!)

IF rb_Receive.checked=false and  rb_delivery.checked=false then 
	MessageBox("Order Type", " Please select any one of Order Type "    ,Stopsign!)
	Return 1
END IF
	

IF rb_Receive.checked=true then   
	of_roprocess()
else 
	 of_doprocess()
end if
enabled = false
end event

type gb_2 from groupbox within w_exportordertest
boolean visible = false
integer y = 8
integer width = 713
integer height = 200
integer taborder = 40
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 134217730
long backcolor = 67108864
boolean enabled = false
string text = "Target Database"
end type

type gb_3 from groupbox within w_exportordertest
integer y = 252
integer width = 827
integer height = 156
integer taborder = 40
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 134217730
long backcolor = 67108864
boolean enabled = false
end type

type gb_1 from groupbox within w_exportordertest
integer y = 432
integer width = 2107
integer height = 156
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 134217730
long backcolor = 67108864
boolean enabled = false
string text = "Record Type"
end type

type datastore_1 from datastore within w_exportordertest descriptor "pb_nvo" = "true" 
end type

on datastore_1.create
call super::create
TriggerEvent( this, "constructor" )
end on

on datastore_1.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

