HA$PBExportHeader$w_load_gm_asn.srw
$PBExportComments$Load ASNS from GM IMS system
forward
global type w_load_gm_asn from w_main_ancestor
end type
type dw_asn from datawindow within w_load_gm_asn
end type
type cb_print from commandbutton within w_load_gm_asn
end type
type cb_scrape from commandbutton within w_load_gm_asn
end type
type cb_1 from commandbutton within w_load_gm_asn
end type
type cb_2 from commandbutton within w_load_gm_asn
end type
type cb_3 from commandbutton within w_load_gm_asn
end type
end forward

global type w_load_gm_asn from w_main_ancestor
integer width = 3287
integer height = 2032
string title = "Load GM ASN~'s"
event ue_scrape ( )
event ue_print ( )
event ue_save ( )
dw_asn dw_asn
cb_print cb_print
cb_scrape cb_scrape
cb_1 cb_1
cb_2 cb_2
cb_3 cb_3
end type
global w_load_gm_asn w_load_gm_asn

type variables

Boolean	ibChanged
end variables

forward prototypes
public function integer wf_validate ()
end prototypes

event ue_scrape();
String	lsFile, lsRun, lsUser, lsPassword, lsResponse, lsErrorText, lsStatusMsg, lsStatusMsgSave, lsMsg, lsTempMsg, lsTemp, lsSQL,	&
			presentation_str, dwsyntax_str
Integer	liFileNo, liStatusFileNo, licurrPos, liMaxPos, liPos, liRC, liMSG
Long	llRowPos, llRowCount,  llBeginPos, llEndPos
Boolean	lbFileExists
Datastore	ldsOpenOrders
u_nvo_gm_ims	luIMS

luIMS = Create u_nvo_gm_ims

//Disable the timeout functionality since this may take longer than the default timeout
g.setProjectIdleTime( 30000 ) /*aproximately 8 hours - can't go much larger in an integer)*/

//User ID and Password are coming from USer File
Select gm_ims_logonID, gm_ims_password
into	:lsUser, :lsPassword
from Usertable
where USerID = :gs_UserID;

If lsUser = "" or lsPassword = "" Then
	MEssagebox("Load ASN", "GM IMS USer ID and Password are required before proceeding~r(They are entered on User Maintenance)",StopSign!)
	Return 
End If

//Retrieve Open orders to pass into Macro so we don't re-scrape what we already have...
ldsOpenOrders = Create Datastore
presentation_str = "style(type=grid)"
lsSQl = "Select supp_invoice_no from Receive_master where project_id = 'GM_MI_DAT' and Ord_status in ('N', 'P')" 

dwsyntax_str = SQLCA.SyntaxFromSQL(lsSQL, presentation_str, lsErrorText)
ldsOpenOrders.Create( dwsyntax_str, lsErrorText)
ldsOpenOrders.SetTransObject(SQLCA)

w_main.SetMicrohelp("Retrieving Open Orders...")

ldsOpenOrders.Retrieve()

w_main.SetMicrohelp(String(ldsOpenOrders.RowCount()) + " Open orders Retrieved...")

//Look in the Macros sub-directory of the SIMS directory
If gs_SysPath > '' Then
	lsFile = gs_syspath + 'Macros\' + 'GM_IMS_ASN_Load.ebm'
	
Else
	lsFile = 'Macros\' + 'GM_IMS_ASN_Load.ebm'
End If

If Not FileExists(lsFile) Then
	Messagebox("Load ASN", 'Unable to Find Macro Format (GM_IMS_ASN_Load.ebm)!')
	Return 
End If

//We can't call the Macro with parms - We need to create a .ini file with the variables
liFileNo = FileOpen(gs_syspath + 'Macros\' + 'GM_IMS_ASN_Load.ini',LineMode!,Write!,LockReadWrite!,Replace!)
If liFileNo < 0 Then
	Messagebox("Load ASN","Unable to create Macro .ini File")
	Return 
End If

SetPointer(Hourglass!)
w_main.SetMicrohelp("Retrieving ASN data from IMS")

//Write User ID and Password to .ini file
FileWrite(liFileNo,lsUser)
FileWrite(liFileNo,lsPassword)

//Pass all of the open orders to the macro so we don't re-scrape
llRowCount = ldsOpenOrders.RowCount()
For llRowPos = 1 to llRowCount
	If ldsOpenOrders.GetITemString(llRowPos,'supp_invoice_no') > "" Then
		FileWrite(liFileNo,ldsOpenOrders.GetITemString(llRowPos,'supp_invoice_no'))
	End If
Next

FileClose(liFileNo) /*close .ini file */

//Delete files from previous run if exists...
If FileExists(gs_syspath + 'Macros\' + 'ASN_Load.tmp') Then
	FileDelete(gs_syspath + 'Macros\' + 'ASN_Load.tmp')
End If

If FileExists(gs_syspath + 'Macros\' + 'ASN_Load.xml') Then
	FileDelete(gs_syspath + 'Macros\' + 'ASN_Load.xml')
End If

If FileExists(gs_syspath + 'Macros\' + 'ASN_Load_Status.txt') Then
	FileDelete(gs_syspath + 'Macros\' + 'ASN_Load_Status.txt')
End If

//clear the DW from a previous scrape
dw_Asn.Reset()


//Run the Macro
lsRun = 'ebrun.exe ' + gs_syspath + 'Macros\' + 'GM_IMS_ASN_LOAD.ebm' 
Run(lsRun,Normal!)

//Open status 
Open(w_ims_status)
w_ims_status.title = "IMS - ASN"

//Wait for the output file to be created.

lbFileExists = False
Do Until lbFileExists
	
	Yield()
	
	//Get the macro status from the status file
	liStatusFileNo = FileOpen(gs_syspath + 'Macros\' + 'ASN_Load_Status.txt',LineMode!,Read!,Shared!)
	If liStatusFileNo > 0 Then
		
		FileRead(liStatusFileNo,lsStatusMsg)
		
		If isvalid(w_ims_status) and lsStatusMsg <> lsStatusMsgSave Then
			
			//If pipe seperated, we have a pos and max pos for the status bar
			If Pos(lsStatusMsg,'|') > 0 Then
				
				lsTempMsg = lsStatusMsg
				liPOs = Pos(lsTempMsg,'|')
				liCurrPos = Long(Left(lsTempMsg,(liPos - 1)))
				lsTempMsg = Right(lsTempMsg,(len(lsTempMsg) - liPos))
				
				liPOs = Pos(lsTempMsg,'|')
				liMaxPos = Long(Left(lsTempMsg,(liPos - 1)))
				lsTempMsg = Right(lsTempMsg,(len(lsTempMsg) - liPos))
				
				lsMSg = lsTempMsg
				
				w_ims_status.hpb_status.Position = liCurrPos
				w_ims_status.hpb_status.MaxPosition = liMaxPos
				
			Else
				
				lsMsg = lsStatusMsg
				
			End If
			
			w_ims_status.st_status.Text = lsMsg
			
		End If /*Status msg updated */
		
		lsStatusMsgSave = lsStatusMsg
		FileClose(liStatusFileNo)
		
	End IF /*Status file read*/
		
	//If popup window has been closed, get out...
	If not isvalid(w_ims_Status) Then Return
			

	lbFileExists = FileExists(gs_syspath + 'Macros\' + 'ASN_Load.xml')
	If lbFileExists Then
		w_ims_status.st_status.Text = "Copying data, PLEASE WAIT..."
		Sleep(5) /*Make sure file completely written...*/
	End If
	
Loop

Close(w_ims_status)

//Read the file
liFileNo = FileOpen(gs_syspath + 'Macros\' + 'ASN_Load.xml',StreamMode!,Read!)

liRC = FileRead(liFileNo,lsTemp)
Do While liRC > 0
	lsResponse += lsTemp
	liRC = FileRead(liFileNo,lsTemp)
Loop
	
FileClose(liFileNo)

Setpointer(Arrow!)
w_main.SetMicrohelp("Ready")

//Process return XML...

//If we don't have an end marker, something went wrong...
If Pos(Upper(lsResponse),"</GM_IMS_RESPONSE>") = 0 Then
	Messagebox("Load ASN", "The GM IMS system did not return a valid response.~r~rNo ASN's updated")
	Return 
End IF

//Check for errors...
If Pos(Upper(lsResponse),"ERRORTEXT") > 0 Then
	
	llBeginPos = Pos(Upper(lsResponse),"ERRORTEXT") + 11
	llEndPos = Pos(Upper(lsResponse),"'",llbeginPos + 1)
	
	lsErrorText = MId(lsResponse,llBeginPos,(llEndPos - llBeginPos))
	
	Messagebox("Load ASN", "The GM IMS system returned the following error:~r~r" + lsErrorText + "~r~rNo updates applied to ASN's")
	Return 
	
End If

//See if any items were returned...
If Pos(Upper(lsResponse),"<ASNLINE>") = 0 Then
	Messagebox("Load ASN", "The GM IMS system did not return any ASN's to update.")
	Return 
End IF

//Show the item information that was returned for user verification and update

//dw_Asn.SetRedraw(False)
dw_asn.ImportString(xml!,lsResponse)

dw_asn.SetSort("SKU A")
dw_Asn.Sort()

//For each unique SKU, we want to scrape the BOM, Contract and COO - This will also create any new Item masters that aren't yet in SIMS
liRC = luIms.uf_verify_bom(w_load_gm_asn, dw_asn)

dw_asn.SetSort("bol_nbr A, Line_Item_No A")
dw_Asn.Sort()

dw_Asn.SetRedraw(True)

dw_asn.GroupCalc()

If liRC < 0 Then
	liMSG = MessageBox("Load ASN", "Unable to process BOM, COO and Contract information?~r~rSave ASN's anyway?",Question!,YesNo!,1)
	If liMSG = 1 Then
		liRC = 0
	Else
		liRC = -1
	End If
End If

//Save changes automatically
If liRC = 0 Then
	This.TriggerEvent('ue_save')
End If

end event

event ue_print();
Openwithparm(w_dw_print_options,dw_asn) 
end event

event ue_save();Long	llRowPos, llRowCount, llLineItem, llQty, llNewRow, llNo, llCount, llOwner, llFindRow, llUPC, llQty2
Integer	liRC
String	lsOrder, lsOrderSave, lsRONO, lsSKU, lsSupplier, lsSUpplierSave, lsValidSupplier, lsRcvSlipNbr, lsErrText, lsCOO, lsContract,	&
			lsTempSupplier, lsDesc, lsUF1, lsUF8, lsUF9, lsUF10, lsUF12, lsCrap
Date		ldtShipDate
DateTime	ldtToday
Boolean	lbValidSupplier
u_ds_Ancestor	ldsReceiveMaster, ldsReceiveDetail, ldsitemMaster

ldtToday = DateTime(today(),Now())

SetPointer(Hourglass!)

ldsReceivemaster = Create u_ds_Ancestor
ldsReceivemaster.Dataobject = 'd_ro_master'
ldsReceiveMaster.SetTransObject(SQLCA)

ldsReceiveDetail = Create u_ds_Ancestor
ldsReceiveDetail.Dataobject = 'd_ro_Detail'
ldsReceiveDetail.SetTransObject(SQLCA)

ldsitemMaster = Create u_ds_Ancestor
ldsitemMaster.Dataobject = 'd_maintenance_itemmaster'
ldsitemMaster.SetTransObject(SQLCA)


//Loop through and add new orders/lines as needed
llRowCount = dw_Asn.RowCount()
For llRowPos = 1 to llRowCount
	
	w_main.SetMicroHelp("Processing row " + String(llRowPOs) + " of " + String(llRowCount))
	
	lsOrder = dw_asn.GetITEmString(llRowPos,'bol_nbr')
	lsSku = dw_asn.GetITEmString(llRowPos,'Sku')
	lsSupplier = dw_asn.GetITEmString(llRowPos,'supp_code')
	lsRcvSlipNbr = dw_asn.GetITEmString(llRowPos,'rcv_slip_nbr')
	lsContract = dw_asn.GetITEmString(llRowPos,'User_Field3')
	llLineItem = dw_asn.GetITEmNumber(llRowPos,'Line_ITem_No')
	llQty = dw_asn.GetITEmNumber(llRowPos,'Qty')
	ldtShipDate = dw_asn.GetITEmDate(llRowPos,'Ship_Date')
	
	//Validate Supplier if changed 
	If lsSupplier <> lsSUpplierSave Then
				
		Select supp_code into :lsValidSupplier
		From Supplier
		Where Project_id = :gs_Project and supp_Code = :lsSupplier;
				
		//If No valid Supplier, try with a leading zero
		If lsValidSupplier = "" or isnull(lsValidSupplier) Then
			
			lsSupplier = "0" + lsSupplier
			
			Select supp_code into :lsValidSupplier
			From Supplier
			Where Project_id = :gs_Project and supp_Code = :lsSupplier;
			
			If lsValidSupplier = "" or isnull(lsValidSupplier) Then	Continue
			
		End If
		
	End IF
	
	lsSupplierSave = lsSupplier
	
	//Create a Receive_MAster if order number has changed 
	If lsOrder <> lsOrderSave Then
				
		//Get the next available RONO
		llno = g.of_next_db_seq(gs_project,'Receive_Master','RO_No')
		If llno <= 0 Then
			messagebox("Load ASN's","Unable to retrieve the next available Receive order Number (RO_NO)!~r~rNo ASN's saved to database")
			Return 
		End If
	
		lsRONO = Trim(Left(gs_project,9)) + String(llno,"000000")
			
		llNewRow = ldsReceiveMAster.InsertRow(0)
		ldsReceiveMaster.SetITem(llNewRow,'ro_no',lsRONO)
		ldsReceiveMaster.SetITem(llNewRow,'project_id',gs_project)
		ldsReceiveMaster.SetITem(llNewRow,'ord_status',"N")
		ldsReceiveMaster.SetITem(llNewRow,'ord_type',"S")
		ldsReceiveMaster.SetITem(llNewRow,'inventory_type',"N")
		ldsReceiveMaster.SetITem(llNewRow,'supp_invoice_No',lsOrder)
		ldsReceiveMaster.SetITem(llNewRow,'supp_Code',lsValidSupplier)
		ldsReceiveMaster.SetITem(llNewRow,'ship_Ref',lsRcvSlipNbr)
		ldsReceiveMaster.SetITem(llNewRow,'wh_code',gs_default_wh)
		ldsReceiveMaster.SetITem(llNewRow,'request_date',ldtShipDate)
		ldsReceiveMaster.SetITem(llNewRow,'ord_date',ldtToday)
		ldsReceiveMaster.SetITem(llNewRow,'last_user','GM-IMS')
		ldsReceiveMaster.SetITem(llNewRow,'last_Update',ldtToday)
		ldsReceiveMaster.SetITem(llNewRow,'User_field1',String(ldtToday,"mm/dd/yyyy")) /*IMS Verify Date*/
						
	End If /*Order Changed*/
	
	lsOrderSave = lsOrder
	
	//Build the REceive DEtail Record
		
	//We need COO & owner (also validates SKU)
	lsCrap = ""
		
	Select sku, Country_of_Origin_Default, Owner_id 
	into :lsCrap, :lsCOO, :llOwner
	From ITem_MAster
	Where Project_id = :gs_Project and sku = :lsSKU and supp_Code = :lsValidSupplier;
		
	If lsCrap = "" or isnull(lsCrap)  Then /*ItemMaster doesn't exist for this supplier, add...*/
		
		//See if we already added it to the DS for insertion below...
		If ldsItemMAster.Find("Upper(Sku) = '" + Upper(Trim(lsSKU)) + "' and Upper(supp_code) = '" + Upper(Trim(lsValidSupplier)) + "'",1,ldsItemMAster.RowCount()) = 0 Then
			
			Select min(supp_code) into :lsTempSupplier
			From Item_master
			Where Project_id = :gs_project and sku = :lsSKU;
		
			If lsTempSupplier > "" Then
			
				Select Description, User_Field8, USer_Field9, USer_Field10, USer_Field1, USer_Field12, Part_upc_Code, qty_2, Country_of_Origin_Default, Owner_id
				Into   :lsDesc, :lsUF8, :lsUF9, :lsUF10, :lsUF1, :lsUF12, :llUPC, :llQty2, :lsCOO, :llOwner
				From Item_MAster
				Where Project_id = :gs_project and sku = :lsSKU and supp_code = :lsTempSupplier;
			
				If lsDesc = "" or isnull(lsDesc) Then Continue /*item not found*/
			
				llNewRow = ldsItemMAster.InsertRow(0)
				ldsItemMAster.SetITem(llNewRow,'Project_id', gs_project)
				ldsItemMAster.SetITem(llNewRow,'sku', lsSKU)
				ldsItemMAster.SetITem(llNewRow,'supp_Code', lsValidSupplier)
				ldsItemMAster.SetITem(llNewRow,'Description', lsDesc)
				ldsItemMAster.SetITem(llNewRow,'owner_id', llOwner)
				ldsItemMAster.SetITem(llNewRow,'country_of_origin_default', lsCOO)
				ldsItemMAster.SetITem(llNewRow,'user_field1', lsUF1)
				ldsItemMAster.SetITem(llNewRow,'user_field8', lsUF8)
				ldsItemMAster.SetITem(llNewRow,'user_field9', lsUF9)
				ldsItemMAster.SetITem(llNewRow,'user_field10', lsUF10)
				ldsItemMAster.SetITem(llNewRow,'user_field12', lsUF12)
				ldsItemMAster.SetITem(llNewRow,'qty_2', llQty2)
				ldsItemMAster.SetITem(llNewRow,'uom_2', 'PKG')
				ldsItemMAster.SetITem(llNewRow,'last_user',gs_userID)
				ldsItemMAster.SetITem(llNewRow,'last_Update',ldtToday)
			
			Else /* no items for any supplier*/
			
				Continue
			
			End If
			
		End If /*not already added to DS*/
					
	End If /*No item*/
		
	// 02/07 - PCONKL - check for duplicate lines - don't roll up qty?
	If ldsReceiveDetail.Find("Upper(ro_no) = '" + Upper(lsRONO) + "' and Line_Item_NO = " + String(llLineITem) + " and Upper(SKU) = '" + Upper(lsSKU) + "'",1, ldsREceiveDetail.RowCount()) = 0 Then
		
		llNewRow = ldsReceiveDEtail.InsertRow(0)
		ldsReceiveDetail.SetItem(llNewRow,'ro_no',lsRONO)
		ldsReceiveDetail.SetItem(llNewRow,'Line_Item_No',llLineITem)
		ldsReceiveDetail.SetItem(llNewRow,'sku',lsSKU)
		ldsReceiveDetail.SetItem(llNewRow,'alternate_sku',lsSKU)
		ldsReceiveDetail.SetItem(llNewRow,'supp_Code',lsValidSupplier)
		ldsReceiveDetail.SetItem(llNewRow,'country_of_Origin',lsCOO)
		ldsReceiveDetail.SetItem(llNewRow,'user_field3',lsContract)
		ldsReceiveDetail.SetItem(llNewRow,'owner_id',llOwner)
		ldsReceiveDetail.SetItem(llNewRow,'req_qty',llQty)
		
	End If
		
Next /*ASN row*/

//Save the changes to the DB

//We may have created headers with no details - if so, delete
llRowCount = ldsReceiveMASter.RowCount()
For lLRowPos = llRowCount to 1 step - 1
	
	If ldsReceiveDetail.Find("ro_no = '" + ldsReceiveMaster.GetITEmString(llRowPos,'ro_no') + "'",1,ldsReceiveDetail.RowCount()) = 0 Then
		ldsREceiveMaster.DeleteRow(llRowPos)
	End IF
	
next

w_main.SetMicroHelp("Saving changes to database...")

Execute Immediate "Begin Transaction" using SQLCA; /*  - Auto Commit Turned on to eliminate DB locks*/

liRC = ldsItemMAster.Update()
If liRC < 1 Then
	lsErrText = ldsItemMAster.wf_get_error_Text()
	Execute Immediate "ROLLBACK" using SQLCA;
	Messagebox("Load ASN's"," Unable to save new Item Master records to database!~r~r" + lsErrText)
	SetPointer(Arrow!)
	Return
End If

Execute Immediate "COMMIT" using SQLCA;
If sqlca.sqlcode <> 0 Then
	MessageBox("Load ASN's","Unable to Commit changes! No changes made to Database!")
	Return
End If


Execute Immediate "Begin Transaction" using SQLCA; /*  - Auto Commit Turned on to eliminate DB locks*/
	
liRC = ldsReceiveMaster.Update()
If liRC < 1 Then
	lsErrText = ldsREceiveMaster.wf_get_error_Text()
	Execute Immediate "ROLLBACK" using SQLCA;
	Messagebox("Load ASN's"," Unable to save new Receive Master records to database!~r~r" + lsErrText)
	SetPointer(Arrow!)
	Return
End If

liRC = ldsReceiveDetail.Update()
If liRC < 1 Then
	lsErrText = ldsREceiveDetail.wf_get_error_Text()
	Execute Immediate "ROLLBACK" using SQLCA;
	Messagebox("Load ASN's"," Unable to save new Receive Detail records to database!~r~r" + lsErrText)
	SetPointer(Arrow!)
	Return
End If

Execute Immediate "COMMIT" using SQLCA;
If sqlca.sqlcode <> 0 Then
	MessageBox("Load ASN's","Unable to Commit changes! No changes made to Database!")
	Return
End If


ibChanged = False
SetPointer(Arrow!)
w_main.SetMicroHelp("Ready")

Messagebox("ASN", "ASN's successfully loaded!")

end event

public function integer wf_validate ();
Long	llRowPOs, llRowCount, llQty, llLineITem, llCount

String	 lsSKU,  lsSupplier

SetPointer(Hourglass!)
dw_asn.SetRedraw(False)

//Only need to validate SKU - we are only scraping orders that we don't already have in SIMS

dw_asn.SetSort("Sku A")
dw_Asn.Sort()

llRowCount = dw_asn.RowCount()
For llRowPOs = 1 to llRowCount
	
	w_main.SetMicroHelp("Validating Row " + String(llRowPos) + " of " + String(lLRowCount))
			
	lsSKU = dw_Asn.GetITemString(llRowPOs,'SKU')
	lsSupplier = dw_Asn.GetITemString(llRowPOs,'Supp_Code')
	
		
	lsSUpplier = '%' + lsSupplier /*may or may not have a leading zero*/
	
	Select Count(*) into :llCount
	From ITem_MAster
	Where Project_id = :gs_Project and sku = :lsSKU and supp_Code Like :lsSupplier;
		
	//If SKU not found, add to list and we will scrape for Item Info at end...
	If llCount = 0 Then
		
		
		
		
	End If
		
	
Next /*ASN Row*/

dw_asn.SetSort("bol_nbr A, lie_item_no A")
dw_Asn.Sort()

dw_asn.SetRedraw(True)
w_main.SetMicroHelp("Ready")
SetPointer(Arrow!)

Return 0
end function

on w_load_gm_asn.create
int iCurrent
call super::create
this.dw_asn=create dw_asn
this.cb_print=create cb_print
this.cb_scrape=create cb_scrape
this.cb_1=create cb_1
this.cb_2=create cb_2
this.cb_3=create cb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_asn
this.Control[iCurrent+2]=this.cb_print
this.Control[iCurrent+3]=this.cb_scrape
this.Control[iCurrent+4]=this.cb_1
this.Control[iCurrent+5]=this.cb_2
this.Control[iCurrent+6]=this.cb_3
end on

on w_load_gm_asn.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_asn)
destroy(this.cb_print)
destroy(this.cb_scrape)
destroy(this.cb_1)
destroy(this.cb_2)
destroy(this.cb_3)
end on

event resize;call super::resize;
dw_asn.Resize(workspacewidth() - 30,workspaceHeight()-150)
end event

event closequery;call super::closequery;
If ibChanged Then
	If Messagebox("Load ASN's","Save ASN changes?",Question!,YesNo!,1) = 1 Then
		This.TriggerEvent('ue_Save')
	End If
End IF
end event

type cb_cancel from w_main_ancestor`cb_cancel within w_load_gm_asn
boolean visible = false
integer x = 2039
integer y = 336
end type

type cb_ok from w_main_ancestor`cb_ok within w_load_gm_asn
boolean visible = false
integer x = 2455
integer y = 348
integer width = 293
integer height = 80
integer textsize = -9
end type

type dw_asn from datawindow within w_load_gm_asn
event ue_filter ( )
integer x = 9
integer y = 148
integer width = 3218
integer height = 1436
integer taborder = 10
boolean bringtotop = true
string title = "none"
string dataobject = "d_load_gm_asn"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cb_print from commandbutton within w_load_gm_asn
integer x = 859
integer y = 36
integer width = 293
integer height = 80
integer taborder = 20
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Print"
end type

event clicked;
Parent.TriggerEvent('ue_Print')
end event

type cb_scrape from commandbutton within w_load_gm_asn
integer x = 123
integer y = 40
integer width = 576
integer height = 80
integer taborder = 20
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Scrape and Save..."
end type

event clicked;PArent.TriggerEvent('ue_scrape')
end event

type cb_1 from commandbutton within w_load_gm_asn
boolean visible = false
integer x = 1262
integer y = 16
integer width = 402
integer height = 112
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Load ASN"
end type

event clicked;
Integer	liFileNo, liRC
Long	llBeginPos, llEndPos
String	lsTemp, lsResponse, lsErrorText,lsFile, lsPAth

GetFileOpenName("Open ASN File",lsPAth,lsFile)

//Read the file
liFileNo = FileOpen(lsPath,StreamMode!,Read!)

liRC = FileRead(liFileNo,lsTemp)
Do While liRC > 0
	lsResponse += lsTemp
	liRC = FileRead(liFileNo,lsTemp)
Loop
	
FileClose(liFileNo)

Setpointer(Arrow!)
w_main.SetMicrohelp("Ready")

//Process return XML...

//If we don't have an end marker, something went wrong...
If Pos(Upper(lsResponse),"</GM_IMS_RESPONSE>") = 0 Then
	Messagebox("Load ASN", "The GM IMS system did not return a valid response.~r~rNo ASN's updated")
	Return 
End IF

//Check for errors...
If Pos(Upper(lsResponse),"ERRORTEXT") > 0 Then
	
	llBeginPos = Pos(Upper(lsResponse),"ERRORTEXT") + 11
	llEndPos = Pos(Upper(lsResponse),"'",llbeginPos + 1)
	
	lsErrorText = MId(lsResponse,llBeginPos,(llEndPos - llBeginPos))
	
	Messagebox("Load ASN", "The GM IMS system returned the following error:~r~r" + lsErrorText + "~r~rNo updates applied to ASN's")
	Return 
	
End If

//See if any items were returned...
If Pos(Upper(lsResponse),"<ASNLINE>") = 0 Then
	Messagebox("Load ASN", "The GM IMS system did not return any ASN's to update.")
	Return 
End IF

//Show the item information that was returned for user verification and update

//dw_Asn.SetRedraw(False)
dw_asn.ImportString(xml!,lsResponse)

//dw_asn.SetSort("SKU A")
//dw_Asn.Sort()
end event

type cb_2 from commandbutton within w_load_gm_asn
boolean visible = false
integer x = 1815
integer y = 20
integer width = 402
integer height = 112
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Load BOM"
end type

event clicked;
Integer liRC, liMsg, liFileNo
String	lsPAth,lsFile, lsTemp, lsResponse, lsErrorText, lsSKU, lsSupplierContract, lsMenloContract, lsCoo, lsContract
Long	llBeginPos, llEndPos, llRowCount, llRowPos, llFindRow
Datastore ldsBom
u_nvo_gm_ims	luIMS

luIMS = Create u_nvo_gm_ims

dw_asn.SetSort("bol_nbr A, Line_Item_No A")
dw_Asn.Sort()

GetFileOpenName("Open BOM File",lsPAth,lsFile)

//Read the file
liFileNo = FileOpen(lsPAth,StreamMode!,Read!)

liRC = FileRead(liFileNo,lsTemp)
Do While liRC > 0
	lsResponse += lsTemp
	liRC = FileRead(liFileNo,lsTemp)
Loop

FileClose(liFileNo)

//Cleanse the XML (remove any special characters
w_main.SetMicrohelp("Parsing XML...")
lsREsponse = f_cleanse_xml(lsResponse)

Setpointer(Arrow!)
w_main.SetMicrohelp("Ready")

//Process return XML...

//Messagebox("",lsREsponse)

//If we don't have an end marker, something went wrong...
If Pos(Upper(lsResponse),"</GM_IMS_RESPONSE>") = 0 Then
	Messagebox("", "The GM IMS system did not return a valid response.~r~rNo updates applied to Item Master")
	Return -1
End IF

//Check for errors...
If Pos(Upper(lsResponse),"ERRORTEXT") > 0 Then
	
	llBeginPos = Pos(Upper(lsResponse),"ERRORTEXT") + 11
	llEndPos = Pos(Upper(lsResponse),"'",llbeginPos + 1)
	
	lsErrorText = MId(lsResponse,llBeginPos,(llEndPos - llBeginPos))
	
	Messagebox("", "The GM IMS system returned the following error:~r~r" + lsErrorText + "~r~rNo updates applied to Item Master")
	Return -1
	
End If

//See if any items were returned...
If Pos(Upper(lsResponse),"<PARENTITEM>") = 0 Then
	Messagebox("", "The GM IMS system did not return any items to update.~r~rNo updates applied to Item Master")
	Return -1
End IF

//Load DS from XML
ldsBom = Create DataStore
ldsBom.dataobject = 'd_load_gm_bom'
ldsBom.SetTransObject(SQLCA)
liRC = ldsBOM.ImportString(xml!,lsResponse)


dw_Asn.SetRedraw(True)

dw_asn.GroupCalc()

If liRC < 0 Then
	liMSG = MessageBox("Load ASN", "Unable to process BOM, COO and Contract information?~r~rSave ASN's anyway?",Question!,YesNo!,1)
	If liMSG = 1 Then
		liRC = 0
	Else
		liRC = -1
	End If
		
End If

llRowCount = ldsBOM.RowCount()
For llRowpOs = 1 to llRowCount
	
	lsSKU = ldsbom.getITemString(llRowPos, 'parent_sku')
	lsSupplierContract = ldsbom.getITemString(llRowPos, 'supplier_Contract')
	lsMenloContract = ldsbom.getITemString(llRowPos, 'Menlo_Contract')
	
	//validate COO returned from IMS
	lsCOO = ldsbom.getITemString(llRowPos, 'COO')
	If f_get_country_name(lsCOO) = "" Then
		lsCOO = 'XXX'
	End If
	
	If lsSupplierContract > "" Then
		lsContract = "S = '" + lsSupplierContract + "' "
	End If
	
	If lsMEnloContract > "" THen
		
		If lsContract > "" Then
			lsContract += ", M = " + lsMEnloContract
		Else
			lsContract = "M = " + lsMEnloContract
		End If
		
	End IF
	
	If lsContract > "" Then
		
		llFindRow = w_load_gm_asn.dw_asn.Find("Upper(Sku) = '" + Upper(lsSKU) + "'",1, w_load_gm_asn.dw_asn.rowcount())
		Do While llFindRow > 0
			
			w_load_gm_asn.dw_asn.SetITem(llFindRow,'User_Field3', lsContract)
			
			If lsCOO > "" and lsCOO <> 'XXX' Then
				w_load_gm_asn.dw_asn.SetITem(llFindRow,'Country_of_Origin', lsCoo)
			End If
			
			llFindRow ++
			If llFindRow > w_load_gm_asn.dw_asn.rowcount() Then
				llFindRow = 0
			Else
				llFindRow = w_load_gm_asn.dw_asn.Find("Upper(Sku) = '" + Upper(lsSKU) + "'",llFindRow, w_load_gm_asn.dw_asn.rowcount())
			End If
			
		Loop
			
	End If
	
Next /* Detail Row */

luIms.uf_update_bom(lsREsponse, w_load_gm_asn)
end event

type cb_3 from commandbutton within w_load_gm_asn
boolean visible = false
integer x = 2391
integer y = 28
integer width = 402
integer height = 112
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Save"
end type

event clicked;
w_load_gm_Asn.TriggerEvent('ue_Save')
end event

