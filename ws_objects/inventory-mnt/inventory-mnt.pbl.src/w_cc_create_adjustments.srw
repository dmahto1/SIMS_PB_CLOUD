$PBExportHeader$w_cc_create_adjustments.srw
$PBExportComments$Create Adjustments from CC window
forward
global type w_cc_create_adjustments from w_response_ancestor
end type
type dw_adjust from u_dw_ancestor within w_cc_create_adjustments
end type
type cb_select from commandbutton within w_cc_create_adjustments
end type
type cb_clear from commandbutton within w_cc_create_adjustments
end type
end forward

global type w_cc_create_adjustments from w_response_ancestor
integer width = 3831
integer height = 2068
string title = "Create CC Adjustment"
dw_adjust dw_adjust
cb_select cb_select
cb_clear cb_clear
end type
global w_cc_create_adjustments w_cc_create_adjustments

on w_cc_create_adjustments.create
int iCurrent
call super::create
this.dw_adjust=create dw_adjust
this.cb_select=create cb_select
this.cb_clear=create cb_clear
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_adjust
this.Control[iCurrent+2]=this.cb_select
this.Control[iCurrent+3]=this.cb_clear
end on

on w_cc_create_adjustments.destroy
call super::destroy
destroy(this.dw_adjust)
destroy(this.cb_select)
destroy(this.cb_clear)
end on

event ue_retrieve;call super::ue_retrieve;
//Get the CC_NO from the CC Window

String	lsCCNO, lsProject, lsWarehouse, lsSKU, lsSuppCode, lsCOO, lsInvType, lsLot, lsPO, lsPO2, lsContainer, lsSerial, lsLoc
Long	llOwnerID, llRowCount, llRowPos
Decimal	ldAvailQty
DateTime	ldtExpDT

lsCCNO = w_cc.idw_main.GetItemString(1, "CC_NO")

SetPointer(Hourglass!)
dw_adjust.SetRedraw(False)

dw_adjust.Retrieve(lsCCNO)

//Filter to only show rows with a Difference - if no rows, display msg
dw_adjust.SetFilter("difference <> 0") 
dw_adjust.Filter()



//Retrieve existing Content for each row - cant do in join because we don;t include RO_NO in CC Inventory anymore

llRowCount = dw_adjust.RowCount()
For llRowPos = 1 to llRowCount
	
	lsProject = dw_adjust.GetItemString(llRowPos,'Project_ID')
	lsWarehouse = dw_adjust.GetItemString(llRowPos,'wh_code')
	lsSKU = dw_adjust.GetItemString(llRowPos,'SKU')
	lsSuppCode = dw_adjust.GetItemString(llRowPos,'Supp_Code')
	lsCOO = dw_adjust.GetItemString(llRowPos,'Country_Of_Origin')
	lsInvType = dw_adjust.GetItemString(llRowPos,'Inventory_Type')
	lsLot = dw_adjust.GetItemString(llRowPos,'Lot_No')
	lsPO = dw_adjust.GetItemString(llRowPos,'PO_NO')
	lsPO2 = dw_adjust.GetItemString(llRowPos,'PO_NO2')
	lsContainer = dw_adjust.GetItemString(llRowPos,'Container_ID')
	lsSerial = dw_adjust.GetItemString(llRowPos,'Serial_No')
	llOwnerID = dw_adjust.GetItemNumber(llRowPos,'Owner_ID')
	lsLoc = dw_adjust.GetItemString(llRowPos,'l_code')
	ldtExpDT = dw_adjust.GetItemDateTime(llRowPos,'Expiration_Date')
	
	Select Sum(Avail_Qty) into :ldAvailQty
	From Content
	Where Project_id = :lsProject and wh_Code = :lsWarehouse and sku = :lsSKU and supp_Code = :lsSuppCode and Country_of_Origin = :lsCOO and
							Inventory_Type = :lsInvType and lot_no = :lsLot and po_no = :lsPO and po_no2 = :lsPO2 and Container_ID = :lsContainer and
							Serial_No = :lsSerial and Owner_Id = :llOwnerID and l_code = :lsLoc and Expiration_Date = :ldtExpDT
	Using SQLCA;
	
	If isnull(ldAvailQty) Then ldAvailQty = 0
	
	dw_adjust.SetItem(llRowPos,'current_content_qty',ldAvailQty)
	dw_adjust.SetItem(llRowPos,'new_content_qty',ldAvailQty + dw_Adjust.GetITemDecimal(llRowPos,'difference'))
	
Next

dw_adjust.SetRedraw(True)
SetPointer(Arrow!)
end event

event ue_postopen;call super::ue_postopen;
datawindowchild ldwc


If not isvalid(w_cc) Then
	Close(this)
End If

If w_cc.idw_main.RowCount() = 0 Then
	Messagebox('CC Adjust', 'Please select a valid Cycle Count',Stopsign!)
	Close(this)
End If

cb_ok.Enabled = False

dw_adjust.GetChild("reason",ldwc)
ldwc.SetTransObject(SQLCA)
ldwc.Retrieve(gs_project,'IA')
If ldwc.RowCount() = 0 Then
	ldwc.InsertRow(0)
End If

dw_adjust.GetChild("inventory_type",ldwc)
ldwc.SetTransObject(SQLCA)
ldwc.Retrieve(gs_project)

This.TriggerEvent('ue_retrieve')
end event

event closequery;call super::closequery;Long	llRowCount,	llRowPos, llRC, ll_owner,  llAdjustID, llContentPos, llContentCount, i
Str_parms	lstrparms
decimal 	ldDifference, ldOrigContentQty, ldNewContentQty
String	lsProject, lsType,	lsSerial,	lsLot, lsPO, lsWarehouse, lsSku, lsRef, lsReason, lsLoc,	lsRONO,  lspo2,  ls_container_ID, ls_supp, ls_coo,	 lsRemarks, lsFind, lsoldpo, lsErrText
DateTime	ldtToday, ldt_expiration_date 
Datastore	ldsContent

//Get out if canceled
If Istrparms.Cancelled Then
	Return 0
End IF

llRowCount = dw_adjust.RowCount()

If llRowCount = 0 Then Return 0

dw_adjust.AcceptText()

If dw_adjust.AcceptText() < 0 Then REturn 1

//If any new qty < 0, get out
If dw_adjust.Find("generate_adjustment = 1 and new_content_qty < 0",1,dw_adjust.RowCount()) > 0 Then
	MessageBox("Stock Adjustment_Create","One or more pending Adjustments will result in a negative inventory balance!",Stopsign!)
	REturn 1
End If

ldsContent = Create Datastore
ldsContent.dataobject = 'd_content_by_key_values'
ldsContent.SetTransObject(SQLCA)

//lsRef = dw_adjust.GetITemString(1,"ref_no")
lsReason  = dw_adjust.GetITemString(1,"Reason")
lsRemarks  = "Created from Cycle Count " + dw_adjust.GetITemString(1,"cc_no") 


SetPointer(Hourglass!)


Execute Immediate "Begin Transaction" using SQLCA; /* 11/04 - PCONKL - Auto Commit Turned on to eliminate DB locks*/
SQLCA.DBParm = "disablebind =0"

//For Each checked row, create an adjustment record and the batch transaction record
For llRowPos = 1 to llRowCount
	
	If dw_adjust.GetItemNumber(llRowPos,'Generate_Adjustment') <> 1 	Then Continue 	
		
	//Get Adjustment values
	lsProject = dw_adjust.GetITemString(llRowPos,"Project_id")
	lsWarehouse = dw_adjust.GetITemString(llRowPos,"wh_code")
		
	ldtToday = f_getLocalWorldTime( lsWarehouse ) 
	
	lsSku = dw_adjust.GetITemString(llRowPos,"sku")
	ls_supp = dw_adjust.GetITemString(llRowPos,"supp_code")
	lsType = dw_adjust.GetITemString(llRowPos,"inventory_type")
	lsSerial = dw_adjust.GetITemString(llRowPos,"serial_no")
	lslot = dw_adjust.GetITemString(llRowPos,"lot_no")
	lspo = dw_adjust.GetITemString(llRowPos,"po_no")
	lspo2 = dw_adjust.GetITemString(llRowPos,"po_no2")
	ls_container_ID  = dw_adjust.GetITemString(llRowPos,"container_ID")   
  	ldt_expiration_date  = dw_adjust.GetITemDatetime(llRowPos,"expiration_date")  
	ll_owner = dw_adjust.GetITemNumber(llRowPos,"owner_id")
	ls_coo = dw_adjust.GetITemString(llRowPos,"country_of_origin")
	lsloc = dw_adjust.GetITemString(llRowPos,"l_code")
	
	//User has entered the new Qty but that is relative to the current content Qty if it has changed since the retrieval. Calculate the difference based on current qty and qty at time of retrieval
	ldDifference = dw_adjust.getItemDecimal(llRowPos,'New_Content_Qty') - dw_adjust.getItemDecimal(llRowPos,'Current_Content_Qty')
		
	//REtrieve content. There may be multiple records (by RO_NO), if subtracting inventory, it may need to be split across records to avoid a negative qty, additions can go in the first
	llContentCount = ldscontent.retrieve(lsProject, lsWarehouse, lsSku,ls_supp,ll_owner,ls_coo,lsloc,lsType,lsSerial,lsLot,lsPO,lsPO2,ls_container_id,ldt_Expiration_Date  )
	
	For llContentPos = 1 to llContentCount
		
		lsRONO =  ldscontent.GetITemString(llContentPos,"ro_no")
		ldOrigContentQty = ldscontent.GetITemDecimal(llContentPos,'avail_qty')
		
		If ldDifference = 0 Then Continue
		
		//If difference is positive, add to the first record and be done. If Negative, we may need to split it across multiple content records to avoid going negative
		If ldDifference > 0 Then
			
			ldscontent.SetItem(llContentPos,'Avail_Qty', ldscontent.GetITemDecimal(llContentPos,'avail_Qty') + ldDifference)
			ldNewContentQty = ldscontent.GetITemDecimal(llContentPos,'avail_qty')
			ldDifference = 0 
			
		Else
			
			If ldscontent.GetITemDecimal(llContentPos,'avail_qty') + ldDifference >= 0 Then /* single COntent record being updated*/
				
				ldscontent.SetItem(llContentPos,'Avail_Qty', ldscontent.GetITemDecimal(llContentPos,'avail_Qty') + ldDifference)
				ldNewContentQty = ldscontent.GetITemDecimal(llContentPos,'avail_qty')
				ldDifference = 0 
				
			Else /* will need to apply difference to another content record*/
				
				ldDifference = ldDifference + ldscontent.GetITemDecimal(llContentPos,'avail_qty')
				ldscontent.SetItem(llContentPos,'Avail_Qty',0)
				ldNewContentQty = 0
				
			End If
			
		End If
		
		ldsContent.Update()
		
		If Sqlca.sqlcode <> 0  Then
			lsErrText =  sqlca.sqlerrtext
			Execute Immediate "ROLLBACK" using SQLCA;
			MessageBox("Stock Adjustment_Create","Unable to create new stock adjustment: ~r~r" + lsErrText)
			Return 1	
		End IF
		
		//Create an Adjustment Record
		Insert Into Adjustment (project_id,sku,Supp_Code,old_owner, owner_id,country_of_origin, old_country_of_origin,&
									wh_code,l_code,old_inventory_type,inventory_type,serial_no,lot_no,po_no,old_po_no,po_no2,old_po_no2,
									container_ID, expiration_date, ro_no,old_quantity,quantity,ref_no,reason,last_user,last_update, Adjustment_Type,
									old_lot_no,remarks) 
		values						(:gs_project,:lsSku,:ls_supp,:ll_Owner,:ll_owner,:ls_coo,:ls_coo,:lsWarehouse,:lsLoc,:lsType,:lsType, &
									:lsSerial,:lsLot,:lspo,:lspo,:lspo2,:lspo2,
									:ls_container_ID, :ldt_expiration_date,:lsRONO,:ldOrigContentQty,:ldNewContentQty,:lsRef,:lsReason,:gs_userid,:ldtToday,"Q",
									:lslot,:lsremarks) 
		Using SQLCA;
	
		
		If Sqlca.sqlcode <> 0  Then
			lsErrText =  sqlca.sqlerrtext
			Execute Immediate "ROLLBACK" using SQLCA;
			MessageBox("Stock Adjustment_Create","Unable to create new stock adjustment: ~r~r" + lsErrText)
			Return 1	
		End IF
		
		//Get the adjustment ID
		//Begin - Dinesh - 11/18/2024 - SIMS-596- CC Adjustment: Add Delay between Insert of Adjustment and Insert of Batch Transaction
		i=1
		DO WHILE i <= 10
			sleep (0.5)
			if llAdjustID <> 0 then
				i=10
			else
				Select Max(Adjust_no) into :llAdjustID
				From	 Adjustment
				Where project_id = :gs_project and ro_no = :lsrono and sku = :lsSku and supp_code = :ls_supp and last_user = :gs_userid and last_update = :ldtToday;
			end if
			i++
		Loop
		//End - Dinesh - 11/18/2024 - SIMS-596- CC Adjustment: Add Delay between Insert of Adjustment and Insert of Batch Transaction		
	
	Next /*Content record */
	
	//Update CC_Inventory record with just created adjustment - will just be last if multiples were created
	dw_adjust.SetItem(llRowPos,'Adjust_No',llAdjustID)
	dw_adjust.Update()
	
	Insert Into batch_Transaction (project_ID, Trans_Type, Trans_Order_ID, Trans_Status, Trans_Create_Date, Trans_Parm)
	Values(:gs_Project, 'MM', :llAdjustID,'N', :ldtToday, "")
	Using SQLCA;
		
	If Sqlca.sqlcode <> 0  Then
		lsErrText =  sqlca.sqlerrtext
		Execute Immediate "ROLLBACK" using SQLCA;
		MessageBox("Stock Adjustment_Create","Unable to create new stock adjustment: ~r~r" + lsErrText)
		Return 1	
	End IF

Next /* Checked Adjustment Record*/


//Commit Changes
Execute Immediate "COMMIT" using SQLCA;
If Sqlca.sqldbcode < 0 Then
	lsErrText =  sqlca.sqlerrtext
	Execute Immediate "ROLLBACK" using SQLCA;
	MessageBox("Stock Adjustment_Create","Unable to create new stock adjustment: ~r~r" + lsErrText)
	Return 1
End IF

SetPointer(arrow!)


end event

type cb_cancel from w_response_ancestor`cb_cancel within w_cc_create_adjustments
integer x = 2560
integer y = 1824
end type

type cb_ok from w_response_ancestor`cb_ok within w_cc_create_adjustments
integer x = 1591
integer y = 1824
integer width = 667
string text = "Create Adjustments"
end type

type dw_adjust from u_dw_ancestor within w_cc_create_adjustments
event ue_check_enabled ( )
integer x = 5
integer y = 28
integer width = 3790
integer height = 1724
boolean bringtotop = true
string dataobject = "d_create_cc_adjustment"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
end type

event ue_check_enabled();
If dw_adjust.Find("generate_adjustment = 1",1, dw_adjust.RowCount()) > 0 Then
	cb_ok.Enabled = True
Else
	cb_ok.Enabled = False
End If
end event

event itemchanged;call super::itemchanged;
If dwo.Name = 'generate_adjustment' Then
	This.PostEvent('ue_check_Enabled')
End If
end event

type cb_select from commandbutton within w_cc_create_adjustments
integer x = 50
integer y = 1776
integer width = 370
integer height = 92
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Select All"
end type

event clicked;Long	llRowCount, llRowPos

llRowCount = dw_adjust.RowCount()
For llRowPos = 1 to llRowCount
	
	If dw_adjust.GetiTEmNumber(llRowPos,'adjust_No') > 0 Then
		
	Else
		dw_adjust.SetItem(llRowPos,'generate_adjustment',1)
	End If
	
Next

If dw_adjust.Find("generate_adjustment = 1",1, dw_adjust.RowCount()) > 0 Then
	cb_ok.Enabled = True
Else
	cb_ok.Enabled = False
End If
end event

type cb_clear from commandbutton within w_cc_create_adjustments
integer x = 50
integer y = 1884
integer width = 370
integer height = 92
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Clear All"
end type

event clicked;Long	llRowCount, llRowPos

llRowCount = dw_adjust.RowCount()
For llRowPos = 1 to llRowCount
	dw_adjust.SetItem(llRowPos,'generate_adjustment',0)
Next

cb_ok.Enabled = False

end event

