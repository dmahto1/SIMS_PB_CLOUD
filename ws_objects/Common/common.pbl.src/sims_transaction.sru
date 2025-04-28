$PBExportHeader$sims_transaction.sru
forward
global type sims_transaction from transaction
end type
end forward

global type sims_transaction from transaction
end type
global sims_transaction sims_transaction

type prototypes
function long sp_item_master_supp_code_upd(string Project_ID,string SKU,string old_Supp_Code,string new_supp_code) RPCFUNC ALIAS FOR "dbo.sp_item_master_supp_code_upd"
function long sp_next_avail_seq_no(string Project_ID,string Table_Name,string Column_Name,ref dec next_seq_no) RPCFUNC ALIAS FOR "dbo.sp_next_avail_seq_no"
function Int sp_get_week(Date DateIn) RPCFUNC ALIAS FOR "dbo.sp_get_week"
function long sp_method_trace_log_upd(long Trans_ID, string project_id, string User_ID, string Object_Name, string Method_Desc)  RPCFUNC ALIAS FOR "dbo.sp_method_trace_log_upd"
function Int sp_content_qty_zero() RPCFUNC ALIAS FOR "dbo.sp_content_qty_zero"

//TimA 11/05/12
//Works much like the one in SIMS client but we are tracking Stored procedures here
//function long sp_method_trace_sp_log_upd(string Project_ID,string User_ID,string Object_Name,string Method_Desc,string System_No,string FTP_File_Name) RPCFUNC ALIAS FOR "dbo.sp_method_trace_sp_log_upd"
//Added SQl String
//08-Feb-2013 :Madhu - Added Invoice_No
//21-Oct-2014 :Madhu- Added SIMS_Version
//function long sp_method_trace_sp_log_upd(string Project_ID,string User_ID,string Object_Name,string Method_Desc,string System_No,string FTP_File_Name,string SQLString, string Invoice_No) RPCFUNC ALIAS FOR "dbo.sp_method_trace_sp_log_upd"
function long sp_method_trace_sp_log_upd(string Project_ID,string User_ID,string Object_Name,string Method_Desc,string System_No,string FTP_File_Name,string SQLString,string Invoice_NO,string SIMS_Version,string Machine_Name) RPCFUNC ALIAS FOR "dbo.sp_method_trace_sp_log_upd"
//function long sp_method_trace_sp_log_upd(string Project_ID,string User_ID,string Object_Name,string Method_Desc,string System_No,string FTP_File_Name,string SQLString,string Invoice_NO,ref long Trans_ID) RPCFUNC ALIAS FOR "dbo.sp_method_trace_sp_log_upd"


//New stored procedures for calculating the SSCC
//Pandora Iuuse #608
//function long sp_check_digit_build(string Project_Id,string CType,ref string Ret_No) RPCFUNC ALIAS FOR "dbo.sp_check_digit_build"
//TimA 05/21/15 added new Algorithm for Carrier Pro Number
function long sp_check_digit_build(string Project_Id,string CType,string ProAlgorithm,longlong ProNumber,ref string Ret_No) RPCFUNC ALIAS FOR "dbo.sp_check_digit_build"

function long sp_check_digit_calc(string SSCC_No,ref long rtn) RPCFUNC ALIAS FOR "dbo.sp_check_digit_calc"

//Pandora Issue #608 GailM Add sp_copy_to_sn_inventory stored procedure
function long sp_copy_to_sn_inventory(string Project_Id,string ro_no) RPCFUNC ALIAS FOR "dbo.sp_copy_to_sn_inventory"
function long SP_Pandora_MIM_Demand(string Warehouse_Loc) RPCFUNC ALIAS FOR "dbo.SP_Pandora_MIM_Demand"
// GailM 02/24/2015 - Pandora Issue #942 - Unit Qty on Vics BOL 
function long sp_get_carton_count(string Project_Id,string do_no) RPCFUNC ALIAS FOR "dbo.sp_get_carton_count"

function long sp_insert_update_content(string project_id,string sku, string supp_code,dec owner_id,string country_of_origin,string wh_code,string l_code,string inventory_type,string serial_no,string lot_no,string ro_no,string po_no, string po_no2,datetime expiration_date,dec avail_qty,dec component_qty,dec component_no,string reason_cd) RPCFUNC ALIAS FOR "dbo.sp_insert_update_content"
// GailM 06/15/2020 - Pandora Issue S45954 - Google DA Kitting move to Spoke Warehouse 
function long sp_merge_kitting_location_records(string Project_Id,string wh_code, String l_code, string sku, string ro_no, string country_of_origin, string po_no, string po_no2, string CntrId, dec owner_id) RPCFUNC ALIAS FOR "dbo.sp_merge_kitting_location_records"

end prototypes

on sims_transaction.create
call super::create
TriggerEvent( this, "constructor" )
end on

on sims_transaction.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

