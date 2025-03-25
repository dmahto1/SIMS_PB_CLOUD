HA$PBExportHeader$sims_transaction.sru
forward
global type sims_transaction from transaction
end type
end forward

global type sims_transaction from transaction
end type
global sims_transaction sims_transaction

type prototypes
function long sp_next_avail_seq_no(string Project_ID,string Table_Name,string Column_Name,ref dec next_seq_no) RPCFUNC ALIAS FOR "dbo.sp_next_avail_seq_no"
Function	INT sp_val_edi_inbound() RPCFUNC ALIAS FOR "sp_val_edi_inbound"
Function	INT sp_val_edi_outbound() RPCFUNC ALIAS FOR "sp_val_edi_outbound"

// 02/15/2010 ujh  Stock Owner Change project
Function long sp_auto_soc(string aInputCode, string aRecDataSOC, ref string aReturnTxt, ref long aReturnCode, ref long aNumReceived, ref long aNumIgnored, ref string aListIgnored, ref long aNumProcessed, ref string aListProcessed ) RPCFUNC ALIAS FOR "dbo.sp_auto_stockowner_change"

// 05/25/2010 ujh  Disk Erase project
Function long sp_auto_soc_DiskErase(string aInputCode, string aRecDataSOC, ref string aReturnTxt, ref long aReturnCode, ref long aNumReceived, ref long aNumIgnored, ref string aListIgnored, ref long aNumProcessed, ref string aListProcessed ) RPCFUNC ALIAS FOR "dbo.sp_auto_soc_diskerase"

// 06/14/2010 ujh  HWOPS change of inventory type:  5000 records
Function long sp_Auto_HWOPS_InvTypeProj(string aInputCode, string aRecDataSOC, ref string aReturnTxt, ref long aReturnCode, ref long aNumReceived, ref long aNumIgnored, ref string aListIgnored, ref long aNumProcessed, ref string aListProcessed ) RPCFUNC ALIAS FOR "dbo.Sp_Auto_HWOPS_InvTypeProj"

// Jxlim 07/07/2011 Stock Owner Change cycle count BRD #233
//Jxlim 07/28/2011 Commented out setting value before trigger sp, passing the ls_ccno and ls_ccline to sp to process the cc auto soc
//Function long sp_auto_soc_cc(string aInputCode, string aRecDataSOC, ref string aReturnTxt, ref long aReturnCode, ref long aNumReceived, ref long aNumIgnored, ref string aListIgnored, ref long aNumProcessed, ref string aListProcessed ) RPCFUNC ALIAS FOR "dbo.sp_auto_soc_cc"
Function long sp_auto_soc_cc(string aInputCode, string aRecDataSOC, string accno, long accline, ref string aReturnTxt, ref long aReturnCode, ref long aNumReceived, ref long aNumIgnored, ref string aListIgnored, ref long aNumProcessed, ref string aListProcessed ) RPCFUNC ALIAS FOR "dbo.sp_auto_soc_cc"

//TimA 06/06/12
//Works much like the one in SIMS client but we are tracking Stored procedures here
//function long sp_method_trace_log_upd(long Trans_ID, string project_id, string User_ID, string Object_Name, string Method_Desc)  RPCFUNC ALIAS FOR "dbo.sp_method_trace_log_upd"	
//function long sp_method_trace_sp_log_upd(string Project_ID,string User_ID,string Object_Name,string Method_Desc,string System_No,string FTP_File_Name) RPCFUNC ALIAS FOR "dbo.sp_method_trace_sp_log_upd"

//TimA 03/04/13 added the modified stored procedure that uses invoice number.
function long sp_method_trace_sp_log_upd(string Project_ID,string User_ID,string Object_Name,string Method_Desc,string System_No,string FTP_File_Name,string SQLString, string Invoice_No) RPCFUNC ALIAS FOR "dbo.sp_method_trace_sp_log_upd"

//TimA 08/01/13 LPN Project #608 Update the carton Serial table with either Do_No or Ro_No
//Type_No should be 'D' or 'R'.  (Delivery or Receiving)
function long sp_carton_serial_update(string Project_Id,string Carton_Id,string Serial_No,string Sku,datetime update_date,string Type_No,string System_No) RPCFUNC ALIAS FOR "dbo.sp_carton_serial_update"

//GailM 04/30/2014 - Remove LPN serial numbers from serial_number_inventory table in 3b13 at uf_gi_rose
function long sp_delete_from_sn_inventory(string Project_Id,string Do_No) RPCFUNC ALIAS FOR "dbo.sp_delete_from_sn_inventory"


end prototypes
on sims_transaction.create
call super::create
TriggerEvent( this, "constructor" )
end on

on sims_transaction.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

