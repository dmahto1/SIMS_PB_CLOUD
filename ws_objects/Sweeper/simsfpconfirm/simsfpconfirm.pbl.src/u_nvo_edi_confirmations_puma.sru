$PBExportHeader$u_nvo_edi_confirmations_puma.sru
$PBExportComments$Process outbound edi confirmation transactions for PUMA
forward
global type u_nvo_edi_confirmations_puma from nonvisualobject
end type
end forward

global type u_nvo_edi_confirmations_puma from nonvisualobject
end type
global u_nvo_edi_confirmations_puma u_nvo_edi_confirmations_puma

type variables

String	isGIFileName, isTRFileName, isGRFileName, isINVFileName
Datastore	idsDOMain, idsDODetail, idsDOPick, idsDOPack, idsOut, idsAdjustment,idsROMain, idsRODetail, idsROPutaway, idsGR

string lsDelimitChar
end variables

forward prototypes
public function integer uf_gr (string asproject, string asrono)
public function integer uf_gi (string asproject, string asdono)
end prototypes

public function integer uf_gr (string asproject, string asrono);//TAM 2013/10: Process the Puma Inbound Order Report.

Datastore	lds_Rpt
				
Long			llRowCount
				
String			lslogOut, lsWarehouse, lsFileName, lsFileNamePath,lsFileNameArchivePath

Integer		liRC

lds_Rpt = Create Datastore
lds_Rpt.Dataobject = 'd_puma_gr'
lirc = lds_Rpt.SetTransobject(sqlca)

lsLogOut = ""
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
lsLogOut = "- PROCESSING FUNCTION:  PUMA Inbound Order Report! *****Start ******"
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
lsLogOut = ""
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/

//Retrieve the Data
lsLogout = 'Retrieving  PUMA Inbound Order Report Data for order# '+ asrono
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(giLogFileNo,lsLogOut)

llRowCount = lds_Rpt.Retrieve(asproject,asrono)
lsWarehouse=  lds_Rpt.GetItemString(1,'wh_code') 

lsLogOut = String(llRowCount) + ' Rows were retrieved for order: ' + asrono + ' / ' + lds_Rpt.GetItemString(1,'receive_master_Supp_Invoice_No') 
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(gilogFileNo,lsLogOut)

//Write the rows to the generic output table - delimited by '~t'
lsLogOut = 'Processing  PUMA Inbound Order Report Data.....'
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(gilogFileNo,lsLogOut)


lsFileName =  lsWarehouse + '-Inbound-PO' + String(DateTime( today(), now()), "yyyymmddhhmmss") + '.xlsx'
lsFileNamePath = ProfileString(gsInifile, 'Puma', 'ftpfiledirout','') + '\' + lsFileName
lsFileNamePath = ProfileString(gsInifile, 'Puma', 'archivedirectory','') + '\' + lsFileName

// Start

oleobject xl,xs
long pos,ll_cnt,i
String lineout[1 to 47],lineout1[1 to 47]
xl = CREATE OleObject
xl.ConnectToNewObject("Excel.Application")

xl.workbooks.Add()
xs = xl.application.workbooks(1).worksheets(1)

lineout[1] = "project_id"
lineout[2] = "wh_name"
lineout[3] = "supp_name"
lineout[4] = "Supp_Code"
lineout[5] = "Supp_Invoice_No"
lineout[6] = "Arrival_Date"
lineout[7] = "Request_Date"
lineout[8] = "Line_Item_No"
lineout[9] = "Ord_Type"
lineout[10] = "SKU"
lineout[11] = "alternate_sku"
lineout[12] = "Req_Qty"
lineout[13] = "Alloc_Qty"
lineout[14] = "Ship_Ref"
lineout[15] = "Damage_Qty"
lineout[16] = "User_Field1"
lineout[17] = "User_Field2"
lineout[18] = "Complete_Date"
lineout[19] = "Order_Date"
lineout[20] = "ord_status"
lineout[21] = "cf_owner_Name"
lineout[22] = "Ro_NO"
lineout[23] = "User_Field7"
lineout[24] = "Grp"
lineout[25] = "description"
lineout[26] = "native_description"
lineout[27] = "WH_Code"

pos = 1 
xs.range('a' + String(pos) + ':aa' +  String(pos)).Value = lineout



ll_cnt = lds_rpt.rowcount()

For i = 1 to ll_cnt
	pos += 1  
	xs.rows(pos + 1).Insert
	lineout1[1] = lineout[1]

		lineout[1] = lds_Rpt.GetItemString(i, "receive_master_project_id")
	lineout[2] = lds_Rpt.GetItemString(i, "wh_name")
	lineout[3] = lds_Rpt.GetItemString(i, "receive_master_supp_name")
	lineout[4] = lds_Rpt.GetItemString(i, "receive_master_Supp_Code")
	lineout[5] = lds_Rpt.GetItemString(i, "receive_master_Supp_Invoice_No")
	lineout[6] = lds_Rpt.GetItemString(i, "receive_master_Arrival_Date")
	lineout[7] = lds_Rpt.GetItemString(i, "receive_master_Request_Date")
	lineout[8] = String(lds_Rpt.GetItemNumber(i, "receive_Detail_Line_Item_No"))
	lineout[9] = lds_Rpt.GetItemString(i, "Ord_Type")
	lineout[10] = lds_Rpt.GetItemString(i, "receive_Detail_SKU")
	lineout[11] = lds_Rpt.GetItemString(i, "receive_Detail_alternate_sku")
	lineout[12] = String(lds_Rpt.GetItemNumber(i, "receive_Detail_Req_Qty"))
	lineout[13] = String(lds_Rpt.GetItemNumber(i,"receive_Detail_Alloc_Qty"))
	lineout[14] = lds_Rpt.GetItemString(i,"receive_master_Ship_Ref")
	lineout[15] = String(lds_Rpt.GetItemNumber(i, "receive_Detail_Damage_Qty"))
	lineout[16] = lds_Rpt.GetItemString(i, "receive_Detail_User_Field1")
	lineout[17] = lds_Rpt.GetItemString(i, "receive_Detail_User_Field2")
	lineout[18] = lds_Rpt.GetItemString(i, "receive_Master_Complete_Date")
	lineout[19] = lds_Rpt.GetItemString(i, "order_date")
	lineout[20] = lds_Rpt.GetItemString(i, "receive_master_ord_status")
	lineout[21] = lds_Rpt.GetItemString(i, "cf_owner_Name")
	lineout[22] = lds_Rpt.GetItemString(i, "receive_master_Ro_NO")
	lineout[23] = lds_Rpt.GetItemString(i, "User_Field7")
	lineout[24] = lds_Rpt.GetItemString(i, "Grp")
	lineout[25] = lds_Rpt.GetItemString(i, "description")
	lineout[26] = lds_Rpt.GetItemString(i, "native_description")
	lineout[27] = lds_Rpt.GetItemString(i, "WH_Code")

	xs.range('a' + String(pos) + ':aa' +  String(pos)).Value = lineout
	
Next
lsFileNamePath = ProfileString(gsInifile, 'Puma', 'ftpfiledirout','') + '\' + lsFileName
lsFileNameArchivePath = ProfileString(gsInifile, 'Puma', 'archivedirectory','') + '\' + lsFileName
gsFileName = lsFileNameArchivePath
lsLogOut = lsFileNamePath + ' is processing'
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(gilogFileNo,lsLogOut)

lsLogOut = lsFileNameArchivePath + ' Copied to Archive'
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(gilogFileNo,lsLogOut)

lsLogOut = ""
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
lsLogOut = "- PROCESSING FUNCTION:  PUMA Inbound Order Report! *****End ******"
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
lsLogOut = ""
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/


xl.application.displayalerts = "False"
xl.activeworkbook.saveas(lsFileNameArchivePath)
xl.activeworkbook.saveas(lsFileNamePath)
xl.application.displayalerts = "True"
xl.activeworkbook.close() 
xl.Application.quit  
xl.DisconnectObject()
DESTROY xl


Return 0


end function

public function integer uf_gi (string asproject, string asdono);
//TAM 2013/10: Process the Puma Outbound Order Report.

Datastore	lds_Rpt
				
Long			llRowCount
				
String			lslogOut, lsWarehouse,	 lsFileName, lsfilenamepath,lsFileNamePathArchive

Integer		liRC

//This function runs on a scheduled basis - Run from the scheduler, not the .ini file

lds_Rpt = Create Datastore
lds_Rpt.Dataobject = 'd_puma_gi'
lirc = lds_Rpt.SetTransobject(sqlca)

lsLogOut = ""
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/

lsLogOut = "- PROCESSING FUNCTION:  PUMA Outbound Order Report!  ***********Start**************"
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/

lsLogOut = ""
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/

//Retrieve the Data
lsLogout = 'Retrieving  PUMA Outbound Order Report Data for Order  ' + asdono
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(giLogFileNo,lsLogOut)

llRowCount = lds_Rpt.Retrieve(asproject,asdono)
lsWarehouse=  lds_Rpt.GetItemString(1, 'wh_code' ) 

lsLogOut = String(llRowCount) + ' Rows of order ' + asdono + ' / '  + lds_Rpt.GetItemString(1, 'Invoice_No') + ' were retrieved for processing.'
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(gilogFileNo,lsLogOut)

//Write the rows to the generic output table - delimited by '~t'
lsLogOut = 'Processing  PUMA Outbound Order Report Data.....'
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(gilogFileNo,lsLogOut)

lsFileName =  lsWarehouse + '-Outbound-SO' + String(DateTime( today(), now()), "yyyymmddhhmmss") + '.xlsx'  //SARUN2014FEB27 Puma requested to genereate excel file which is compatible with office7
lsFileNamePath = ProfileString(gsInifile, 'Puma', 'ftpfiledirout','') + '\' + lsFileName
lsFileNamePath = ProfileString(gsInifile, 'Puma', 'archivedirectory','') + '\' + lsFileName

// Start

oleobject xl,xs
long pos,ll_cnt,i
String lineout[1 to 47],lineout1[1 to 47]
xl = CREATE OleObject
xl.ConnectToNewObject("Excel.Application")

xl.workbooks.Add()

xs = xl.application.workbooks(1).worksheets(1)

lineout[1] = 'Project_ID'
lineout[2] = 'DO_No'
lineout[3] = 'Wh_NAME'
lineout[4] = 'Invoice_No'
lineout[5] = 'Ord_Type'
lineout[6] = 'Ord_Status'
lineout[7] = 'Order_date'
lineout[8] = 'request_Date'
lineout[9] = 'Schedule_Date'
lineout[10] = 'Complete_Date'
lineout[11] = 'Cust_Code'
lineout[12] = 'Cust_Name'
lineout[13] = 'Cust_Order_No'
lineout[14] = 'Carrier'
lineout[15] = 'Priority'
lineout[16] = 'Remark'
lineout[17] = 'Carrier_Notified_date'
lineout[18] = 'User_Field6'
lineout[19] = 'Country'
lineout[20] = 'Zip'
lineout[21] = 'Ord_Type_Desc'
lineout[22] = 'Line_Item_No'
lineout[23] = 'SKU'
lineout[24] = 'Req_Qty'
lineout[25] = 'Alloc_Qty'
lineout[26] = 'Price'
lineout[27] = 'L_Code'
lineout[28] = 'Serial_No'
lineout[29] = 'Lot_No'
lineout[30] = 'PO_No'
lineout[31] = 'PO_No2'
lineout[32] = 'Container_ID'
lineout[33] = 'Expiration_date'
lineout[34] = 'Quantity'
lineout[35] = 'Owner_ID'
lineout[36] = 'cf_owner_Name'
lineout[37] = 'Extended_Price'
lineout[38] = 'Length_1'
lineout[39] = 'Width_1'
lineout[40] = 'Height_1'
lineout[41] = 'Weight_1'
lineout[42] = 'Grp'
lineout[43] = 'User_Field8'
lineout[44] = 'User_Field18'
lineout[45] = 'Description'
lineout[46] = 'Native_Description'
lineout[47] = 'wh_code'
pos = 1 
xs.range('a' + String(pos) + ':au' +  String(pos)).Value = lineout



ll_cnt = lds_rpt.rowcount()

For i = 1 to ll_cnt
	pos += 1  
	xs.rows(pos + 1).Insert
		lineout1[1] = lineout[1]
		lineout[1] = lds_Rpt.GetItemString(i, 'delivery_master_Project_ID')
		lineout[2] = lds_Rpt.GetItemString(i, 'DO_No')
		lineout[3] = lds_Rpt.GetItemString(i, 'Wh_NAME')
		lineout[4] = lds_Rpt.GetItemString(i, 'Invoice_No')
		lineout[5] = lds_Rpt.GetItemString(i, 'delivery_master_Ord_Type')
		lineout[6] = lds_Rpt.GetItemString(i, 'Ord_Status')
		lineout[7] = String(lds_Rpt.GetItemString(i, 'Order_date'))
		lineout[8] = String(lds_Rpt.GetItemString(i, 'delivery_master_request_Date'))
		lineout[9] = String(lds_Rpt.GetItemString(i, 'delivery_master_Schedule_Date'))
		lineout[10] = String(lds_Rpt.GetItemString(i, 'delivery_master_Complete_Date'))
		lineout[11] = String(lds_Rpt.GetItemString(i, 'delivery_master_Cust_Code'))
		lineout[12] = String(lds_Rpt.GetItemString(i, 'delivery_master_Cust_Name'))
		lineout[13] = lds_Rpt.GetItemString(i, 'delivery_master_Cust_Order_No')
		lineout[14] = lds_Rpt.GetItemString(i, 'Carrier')
		lineout[15] = String(lds_Rpt.GetItemNumber(i, 'Priority'))
		lineout[16] = lds_Rpt.GetItemString(i, 'delivery_master_Remark')
		lineout[17] = String(lds_Rpt.GetItemString(i, 'Carrier_Notified_date'))
		lineout[18] = lds_Rpt.GetItemString(i, 'User_Field6')
		lineout[19] = lds_Rpt.GetItemString(i, 'Country')
		lineout[20] = lds_Rpt.GetItemString(i, 'Zip')
		lineout[21] = lds_Rpt.GetItemString(i, 'Ord_Type_Desc')
		lineout[22] = String(lds_Rpt.GetItemNumber(i, 'delivery_detail_Line_Item_No'))
		lineout[23] = lds_Rpt.GetItemString(i, 'delivery_detail_SKU')
		lineout[24] = String(lds_Rpt.GetItemNumber(i, 'delivery_detail_Req_Qty'))
		lineout[25] = String(lds_Rpt.GetItemNumber(i, 'delivery_detail_Alloc_Qty'))
		lineout[26] = String(lds_Rpt.GetItemNumber(i, 'Price'))
		lineout[27] = lds_Rpt.GetItemString(i, 'delivery_picking_L_Code')
		lineout[28] = lds_Rpt.GetItemString(i, 'delivery_picking_Serial_No')
		lineout[29] = lds_Rpt.GetItemString(i, 'delivery_picking_Lot_No')
		lineout[30] = lds_Rpt.GetItemString(i, 'delivery_picking_PO_No')
		lineout[31] = lds_Rpt.GetItemString(i, 'delivery_picking_PO_No2')
		lineout[32] = lds_Rpt.GetItemString(i, 'delivery_picking_Container_ID')
		lineout[33] = String(lds_Rpt.GetItemString(i, 'delivery_picking_Expiration_date'))
		lineout[34] = String(lds_Rpt.GetItemNumber(i, 'delivery_picking_Quantity'))
		lineout[35] = String(lds_Rpt.GetItemNumber(i, 'Owner_ID'))
		lineout[36] = lds_Rpt.GetItemString(i, 'cf_owner_Name')
		lineout[37] = String(lds_Rpt.GetItemNumber(i, 'Extended_Price'))
		lineout[38] = String(lds_Rpt.GetItemNumber(i, 'Length_1'))
		lineout[39] = String(lds_Rpt.GetItemNumber(i, 'Width_1'))
		lineout[40] = String(lds_Rpt.GetItemNumber(i, 'Height_1'))
		lineout[41] = String(lds_Rpt.GetItemNumber(i, 'Weight_1'))
		lineout[42] = lds_Rpt.GetItemString(i, 'Grp')
		lineout[43] = lds_Rpt.GetItemString(i, 'User_Field8')
		lineout[44] = lds_Rpt.GetItemString(i, 'User_Field18')
		lineout[45] = lds_Rpt.GetItemString(i, 'Description')
		lineout[46] = lds_Rpt.GetItemString(i, 'Native_Description')
		lineout[47] = lds_Rpt.GetItemString(i, 'wh_code')

	xs.range('a' + String(pos) + ':au' +  String(pos)).Value = lineout
	
Next

lsFileNamePath = ProfileString(gsInifile, 'Puma', 'ftpfiledirout','') + '\' + lsFileName
lsLogOut = lsFileNamePath + ' is processing'
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(gilogFileNo,lsLogOut)

lsFileNamePathArchive = ProfileString(gsInifile, 'Puma', 'archivedirectory','') + '\' + lsFileName
lsLogOut = lsFileNamePathArchive + ' has been moved to Archive '
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(gilogFileNo,lsLogOut)
gsFileName = lsFileNamePathArchive

lsLogOut = ""
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/

lsLogOut = "- PROCESSING FUNCTION:  PUMA Outbound Order Report!  ***********End**************"
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/

lsLogOut = ""
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/


xl.application.displayalerts = "False"
xl.activeworkbook.saveas(lsFileNamePathArchive)

xl.activeworkbook.saveas(lsFileNamePath)
xl.activeworkbook.close() 
xl.application.displayalerts = "True"
xl.Application.quit  
xl.DisconnectObject()
DESTROY xl


Return 0


end function

on u_nvo_edi_confirmations_puma.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_nvo_edi_confirmations_puma.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;lsDelimitChar = char(9)
end event

