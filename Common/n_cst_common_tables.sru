HA$PBExportHeader$n_cst_common_tables.sru
$PBExportComments$-
forward
global type n_cst_common_tables from nonvisualobject
end type
end forward

global type n_cst_common_tables from nonvisualobject autoinstantiate
end type

type variables
Public:
   Boolean ib_open_location = False
	Decimal id_picking_seq
	String is_carrier_name,is_country_name,is_code_desc
	String is_mn_no
end variables

forward prototypes
public function integer of_item_master_sku_count (ref string as_sku, ref string as_supplier)
public function integer of_select_contry_master (string as_carrier_code)
public function integer of_select_location (ref string as_wh_code, ref string as_loc_code)
public function integer of_select_carrier_master (string as_carrier_code)
public function integer of_select_lookup_table ()
public function integer of_generate_pack ()
public function integer of_get_user_field6_dm (string as_wh_code, string as_inv_no)
end prototypes

public function integer of_item_master_sku_count (ref string as_sku, ref string as_supplier);//Count Item Master records for maching the criteria.
integer ll_cnt

Select Count(*) 
into :ll_cnt
From item_master
Where Project_id = :gs_project
and   sku = :as_sku
and   supp_code = :as_supplier;
Return ll_cnt
end function

public function integer of_select_contry_master (string as_carrier_code);//Selecting data from location table
//DGM 09/09/2003
Long ll_rtn 
ll_rtn = 1
//IF NOT ib_open_location THEN
	Select country_name 
	into :is_country_name
	From Country
	Where  ISO_Country_Cd  = :as_carrier_code
	or EMCN_Code = :as_carrier_code ;
	ib_open_location = TRUE
//END IF
Return ll_rtn
end function

public function integer of_select_location (ref string as_wh_code, ref string as_loc_code);//Selecting data from location table
//DGM 09/09/2003
Long ll_rtn 
ll_rtn = 1
//IF NOT ib_open_location THEN
	Select picking_seq 
	into :id_picking_seq
	From Location
	Where wh_code = :as_wh_code
	and   l_code  = :as_loc_code;
	ib_open_location = TRUE
//END IF
Return ll_rtn
end function

public function integer of_select_carrier_master (string as_carrier_code);//Selecting data from location table
//DGM 09/09/2003
Long ll_rtn 
ll_rtn = 1
//IF NOT ib_open_location THEN
	Select carrier_name 
	into :is_carrier_name
	From Carrier_Master
	Where project_id = :gs_project
	and   Carrier_Code  = :as_carrier_code;
	ib_open_location = TRUE
//END IF
Return ll_rtn
end function

public function integer of_select_lookup_table ();//Selecting data from location table
//DGM 09/09/2003
Long ll_rtn 
ll_rtn = 1
//IF NOT ib_open_location THEN
	Select Code_Descript 
	into :is_code_desc
	From Lookup_table
	Where project_id = :gs_project
	and   upper(Code_Type)  = "BOLDS"
	and   upper(Code_ID)    = "BOLDESC";
//	ib_open_location = TRUE
//END IF
Return ll_rtn
end function

public function integer of_generate_pack ();Return 1
end function

public function integer of_get_user_field6_dm (string as_wh_code, string as_inv_no);integer li_rtn
li_rtn =1

Select user_field6 
into :is_mn_no
from delivery_master
where wh_code = :as_wh_code and
project_id = :gs_project and
invoice_no = :as_inv_no;
Return li_rtn
end function

on n_cst_common_tables.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cst_common_tables.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

