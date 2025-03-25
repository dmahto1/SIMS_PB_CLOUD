$PBExportHeader$u_nvo_bobcat_consolidation.sru
$PBExportComments$Bobcat Consolidation functions
forward
global type u_nvo_bobcat_consolidation from nonvisualobject
end type
end forward

global type u_nvo_bobcat_consolidation from nonvisualobject
end type
global u_nvo_bobcat_consolidation u_nvo_bobcat_consolidation

forward prototypes
public function integer uf_ship_all (ref datawindow adwmain, ref datawindow adwdetail)
public function integer uf_create_inbound (ref datawindow adwmain)
end prototypes

public function integer uf_ship_all (ref datawindow adwmain, ref datawindow adwdetail);
//Create Order Detail ROws for All All inventory

Datastore	ldsContent
String	lsSQl, lsErrorText, presentation_str, dwsyntax_str, lsSKU, lsSupplier
long	llRowCount, llRowPos, llNewRow, llFindROw

//Retrieve all Inventory grouped by SKU.
ldsContent = Create Datastore
lsSQL =  "Select Content.SKU, Content.Supp_code, Content.Owner_ID, uom_1, Sum(Avail_Qty) as avail_qty from Content, Item_Master "
lsSQL += " Where Content.Project_id = '" + gs_Project + "' and wh_Code = '" + adwMain.GetITemString(1,'wh_code') + "'"
lsSQL += " And Content.Project_Id = item_Master.Project_id and Content.SKU = Item_MAster.SKU and Content.Supp_Code = Item_MAster.Supp_code "
lsSql += " Group By Content.SKU, Content.Supp_Code, Content.Owner_ID, uom_1 "

presentation_str = "style(type=grid)"
dwsyntax_str = SQLCA.SyntaxFromSQL(lsSQL, presentation_str, lsErrorText)

ldsContent.Create( dwsyntax_str, lsErrorText)
ldsContent.SetTransObject(SQLCA)

SetPointer(Hourglass!)

llRowCount = ldsContent.Retrieve()

//For each Content record, Create an Order Detail Record
For llRowPos = 1 to llRowCOunt
	
	//If user reruns, we may have rows already - if so, update qty, otherwise insert new row
	lsSKU = ldsContent.GetITemString(llRowPos,'SKU')
	lsSupplier = ldsContent.GetITemString(llRowPos,'Supp_Code')
	
	llFindRow = adwDetail.Find("Upper(SKU) = '" + Upper(lsSKU) + "' and Upper(Supp_code) = '" + Upper(lsSupplier) + "'",1, adwdetail.RowCount())
	If llFindRow > 0 Then
		adwDetail.SetITem(llFindROw, 'req_qty', ldsContent.GetITemNumber(llRowPos,'avail_qty'))
	Else
		llNewRow = adwDetail.InsertRow(0)
		adwDetail.SetITem(llNewRow, 'line_item_no', llNewRow)
		adwDetail.SetITem(llNewRow, 'SKU', lsSKU)
		adwDetail.SetITem(llNewRow, 'Alternate_SKU', lsSKU) /*set ALt SKU to Primary*/
		adwDetail.SetITem(llNewRow, 'Supp_Code', lsSupplier)
		adwDetail.SetITem(llNewRow, 'Owner_ID', ldsContent.GetITemNumber(llRowPos,'Owner_ID'))
		adwDetail.SetITem(llNewRow, 'req_qty', ldsContent.GetITemNumber(llRowPos,'avail_qty'))
		adwDetail.SetITem(llNewRow, 'uom', ldsContent.GetITemString(llRowPos,'uom_1'))
	End IF
	
Next /*Content Record*/
	
	
SetPointer(ARrow!)


REturn 0
end function

public function integer uf_create_inbound (ref datawindow adwmain);//Create matching Inbound order into receiving Warehouse

Long			llNo, llRowCount, llRowPos, llFindRow, llNewRow, llLineItemNo, llOwner
String		lsDONO, lsOrderNo, lsCarrier, lsWarehouse, lsAWB, lsSKU, lsSupplier, lsPO, lsDORONO, lsNewRoNO, lsErrText, lsSQL, &
				presentation_str, dwsyntax_str, lsCOO, lsInvoiceNo
string		lsOrdType //dts - 08/25/05
DateTime		ldtToday
Decimal		ldQTY
Integer		liRC
Datastore	ldsDetail, ldsPickDetail

ldsDetail = Create Datastore
ldsDetail.Dataobject = 'd_ro_detail'
ldsDetail.SetTransObject(SQLCA)

// pvh 02.15.06 - gmt
//ldtToday = DateTime(today(),Now())

lsDONO = adwMain.GetITemString(1,'do_no')

//Retrieve the Delivery Picking records for this order
ldsPickDetail = Create Datastore
lsSQL =  "Select Line_Item_No, SKU, Supp_Code, Owner_ID, Country_of_Origin, ro_no, Quantity from Delivery_Picking_Detail "
lsSQL += " Where do_no = '" + lsDONO + "'"

presentation_str = "style(type=grid)"

dwsyntax_str = SQLCA.SyntaxFromSQL(lsSQL, presentation_str, lsErrText)

ldsPickDetail.Create( dwsyntax_str, lsErrText)
ldsPickDetail.SetTransObject(SQLCA)

//Create a new Receive Master Record

//generate ro_no
llno = g.of_next_db_seq(gs_project,'Receive_Master','RO_No')
If llno <= 0 Then
	messagebox("Receive Order","Unable to retrieve the next available order Number!")
	Return -1
End If
	
lsNewRONO = Trim(Left(gs_project,9)) + String(llno,"000000")
lsOrderNo = String(llNo,'000000')
lsCarrier = adwMain.GetItemString(1,'carrier') 
lsInvoiceNo = adwMain.GetItemString(1,'Invoice_no') 
lsAWB = adwMain.GetItemString(1,'awb_bol_no') 
lsWarehouse = adwMain.GetItemString(1,'cust_Code') //wf_validation will validate that cust_code in Delivery Master is a valid warehouse code for receiving into
lsOrdType = adwMain.GetItemString(1,'ord_type') 

// pvh - 02/15/06 - gmt
ldtToday = f_getLocalWorldTime( lsWarehouse ) 

Execute Immediate "Begin Transaction" using SQLCA; /* 11/04 - PCONKL - Auto Commit Turned on to eliminate DB locks*/

//Supplier is hard-coded as 'N/A' since there could be multiple suppliers on the outbound order
//look to see if 'N/A' exists for this project and create if it doesn't
select supp_code into :lsSupplier
from supplier
where project_id = :gs_Project
and supp_code = 'N/A';

If isNull(lsSupplier) or lsSupplier = '' Then 
	insert into supplier(Project_id, Supp_code, Supp_Name, last_user, last_update)
	values (:gs_Project, 'N/A', 'Used For Warehouse Transfer', :gs_userid, :ldtToday)
	Using SQLCA;
end if

Insert Into Receive_Master (ro_no, project_id, ord_date, ord_status, ord_type, Inventory_type, wh_Code, Supp_Code, 
										Supp_Invoice_No, carrier, awb_bol_no, USer_field1, Request_Date,	Last_user, Last_Update)
										
//					Values		(:lsNewRONO, :gs_Project, :ldtToday, "N", "C", "N", :lsWareHouse, "BOBCAT", 
					Values		(:lsNewRONO, :gs_Project, :ldtToday, "N", :lsOrdType, "N", :lsWareHouse, "N/A", 
										:lsOrderNo, :lsCarrier, :lsAWB, :lsInvoiceNo, :ldtToday, :gs_userid, :ldtToday)
Using SQLCA;

If sqlca.sqlcode <> 0 Then
	lsErrText = sqlca.sqlerrtext /*text will be lost after rollback*/
	Execute Immediate "ROLLBACK" using SQLCA;
	Messagebox("Create Inbound", "Unable to save new Receiving Order to database!~r~r" + lsErrText)
	Return -1
End If

//Create a Receive Detail record for each SKU - loop by Pick Detail so we can include original PO (from RO_NO)

llRowCount = ldsPickDetail.Retrieve()
For llRowPos = 1 to lLRowCount
	
	lsSKU = ldsPickDetail.GetITemString(llRowPos,'SKU')
	lsSupplier = ldsPickDetail.GetITemString(llRowPos,'supp_Code')
	lsCoo = ldsPickDetail.GetITemString(llRowPos,'Country_of_Origin')
	ldQTY = ldsPickDetail.GetITemNumber(llRowPos,'Quantity')
	llLineItemNo = ldsPickDetail.GetITemNumber(llRowPos,'Line_ITem_No')
	llOwner = ldsPickDetail.GetITemNumber(llRowPos,'Owner_ID')
	
	//Get the original PO Number for this stock
	lsDORONO = ldsPickDetail.GetITemString(llRowPos,'ro_no')
	
	Select Supp_invoice_No into :lsPO
	From Receive_Master
	Where ro_no = :lsDORONO;
	
	If isNull(lsPO) Then lsPO = ''
	
	//Rollup to SKU/Supplier
	llFindRow = ldsDetail.Find("Upper(sku) = '" + Upper(lsSKU) + "' and Upper(Supp_Code) = '" + Upper(lsSupplier) + "'",1, ldsDetail.RowCount())
	
	If llFindRow > 0 Then
		
		ldsDetail.SetITem(llFindRow, 'Req_Qty',(ldsDetail.GetItemNumber(llFindRow,'req_Qty') + ldQty))
		ldsDetail.SetITem(llFindRow, 'User_field1',ldsDetail.GetItemString(llFindRow,'User_field1') + ', ' + lsPO)
		
	Else
		
		llNewRow = ldsDetail.InsertRow(0)
		ldsDetail.SetItem(llNewRow,'ro_no',lsNewRONO)
		ldsDetail.SetItem(llNewRow,'Line_Item_No',llLineITemNO)
		ldsDetail.SetItem(llNewRow,'sku',lsSKU)
		ldsDetail.SetItem(llNewRow,'alternate_sku',lsSKU)
		ldsDetail.SetItem(llNewRow,'supp_Code',lsSUpplier)
		ldsDetail.SetItem(llNewRow,'req_qty',ldQty)
		ldsDetail.SetItem(llNewRow,'owner_ID',llOwner)
		ldsDetail.SetItem(llNewRow,'Country_of_Origin',lsCOO)
		ldsDetail.SetItem(llNewRow,'User_Field1',lsPO)
		
	End If
	
Next /*Pick Detail Record */

//Update Details
liRC = ldsDetail.Update()
If liRC = 1 Then
	Execute Immediate "COMMIT" using SQLCA;
Else
	lsErrText = sqlca.sqlerrtext
	Execute Immediate "ROLLBACK" using SQLCA;
	Messagebox("Consolidation","Unable to save new Receiving Order Detail records to database!~r~r" + lsErrText)
	Return -1
End If

MessageBox("Consolidation","Matching Inbound order successfully created for " + lswarehouse)

Return 0
end function

on u_nvo_bobcat_consolidation.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_nvo_bobcat_consolidation.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

