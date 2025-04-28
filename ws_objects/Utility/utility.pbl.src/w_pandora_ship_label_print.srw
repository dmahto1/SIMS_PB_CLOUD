$PBExportHeader$w_pandora_ship_label_print.srw
forward
global type w_pandora_ship_label_print from w_main_ancestor
end type
type cb_print from commandbutton within w_pandora_ship_label_print
end type
type cb_selectall from commandbutton within w_pandora_ship_label_print
end type
type cb_clear from commandbutton within w_pandora_ship_label_print
end type
type dw_label from u_dw_ancestor within w_pandora_ship_label_print
end type
end forward

global type w_pandora_ship_label_print from w_main_ancestor
boolean visible = false
integer width = 5792
integer height = 1800
string title = "Shipping Labels"
string menuname = ""
event ue_print ( )
cb_print cb_print
cb_selectall cb_selectall
cb_clear cb_clear
dw_label dw_label
end type
global w_pandora_ship_label_print w_pandora_ship_label_print

type variables
n_warehouse i_nwarehouse
n_labels	invo_labels
String	isUCCSCompanyPrefix, isUCCSWHPrefix

String isCustName,isAddress_1, isAddress_2 ,isAddress_3 ,isAddress_4 ,isCity ,isState ,isZip
String isWHName, isWHAddress_1, isWHAddress_2 , isWHAddress_3 , isWHAddress_4 , isWHCity , isWHState , isWHZip

String	isOrigSql
String isDoNo

String isOrderType
end variables

forward prototypes
public subroutine uf_fromcustomer (string as_from)
public subroutine uf_towarehouse (string as_to)
end prototypes

event ue_print();Str_Parms	lstrparms
Long	llQty, llRowCount, llRowPos
Any	lsAny
Long liRC
String lsErrText,lsMsg
String lsRoNo, lsDoNo, lsPallet, lsContainer, lsNextPallet,lsCityStateZip,lsWHCityStateZip
String lsPrintLable, lsPrintCarton,lsCustomer,lsWarehouse
string ls_vics_bol_no,  ls_awb_bol_no,lsSSCC

n_warehouse l_nwarehouse 
n_cst_common_tables ln_common_tables

Dw_Label.AcceptText()

If dw_label.Find("c_print_ind = 'Y'",1,dw_label.RowCount()) = 0 Then
	MessageBox('Labels',"at least one row must be selected for printing!")
	Return
End If

OpenWithParm(w_label_print_options,lStrParms)
Lstrparms = Message.PowerObjectParm		  
If lstrParms.Cancelled Then Return 

If  IsValid(w_do)  then
	lsDoNo = dw_label.GetITemString(1,'Do_No')
End if

//Print each detail Row 
llRowCount = dw_label.RowCount()
For llRowPos = 1 to llRowCount /*each detail row */
			
	IF dw_label.object.c_print_ind[llRowPos] = 'Y' THEN 
					
		llQty = dw_label.object.quantity[llRowPos] 
		Lstrparms.Long_arg[1] = llQty
					
		//Ship From
		lsCustomer = dw_label.object.user_field2[ llRowPos] 
		If Len(lsCustomer) > 0 then
			uf_FromCustomer(lsCustomer)
			If isCustName = '' or IsNull(isCustName) then
				isCustName = lsCustomer
			End if
			LstrParms.String_arg[2] = isCustName
		
			Lstrparms.String_arg[3] = isAddress_1
			Lstrparms.String_arg[4] = isAddress_2
			Lstrparms.String_arg[5] = isAddress_3
			Lstrparms.String_arg[6] = isAddress_4
			If Not isnull(isCity) Then lsCityStateZip = isCity + ', '
			If Not isnull(isState) Then lsCityStateZip += isState + ' '
			If Not isnull(isZip) Then lsCityStateZip += isZip + ' '
			Lstrparms.String_arg[7] = lsCityStateZip			
		End if
			
		//Ship To
		Lstrparms.String_arg[13] = dw_label.GetItemString(llRowPos,'Cust_name')
		Lstrparms.String_arg[14] = dw_label.GetItemString(llRowPos,'address_1')
		Lstrparms.String_arg[15] = dw_label.GetItemString(llRowPos,'address_2')
		Lstrparms.String_arg[16] = dw_label.GetItemString(llRowPos,'address_3')
		Lstrparms.String_arg[32] = dw_label.GetItemString(llRowPos,'address_4')
					
		//Compute TO City,State & Zip
		lsCityStateZip = ''
		If Not isnull(dw_label.GetItemString(llRowPos,'City')) Then lsCityStateZip = dw_label.GetItemString(llRowPos,'City') + ', '
		If Not isnull(dw_label.GetItemString(llRowPos,'State')) Then lsCityStateZip += dw_label.GetItemString(llRowPos,'State') + ' '
		If Not isnull(dw_label.GetItemString(llRowPos,'Zip')) Then lsCityStateZip += dw_label.GetItemString(llRowPos,'Zip') + ' '
		Lstrparms.String_arg[17] = lsCityStateZip					
				

		lstrparms.String_arg[20] = dw_label.GetItemString(llRowPos,'Alternate_SKU')
		lstrparms.String_arg[40] = lsDoNo					
		lstrparms.String_arg[41] = String(dw_label.GetItemNumber(llRowPos,'line_item_no' ), '#####0' )
		lstrparms.String_arg[42] = dw_label.GetItemString(llRowPos,'SKU')
		lstrparms.String_arg[43] = dw_label.GetItemString(llRowPos,'country_of_origin')
		lstrparms.String_arg[44] = dw_label.GetItemString(llRowPos,'description')
		lstrparms.String_arg[45] = dw_label.GetItemString(llRowPos,'client_cust_po_nbr')
		lstrparms.String_arg[47] = string(dw_label.GetItemDateTime(llRowPos,'pack_expiration_date' ),'MMDDYYYY' )
		if dw_label.GetItemString(llRowPos,'hazard_cd') <> '' and not isnull(dw_label.GetItemString(llRowPos,'hazard_cd') )then
			lstrparms.String_arg[48] = 'Y'
		else
			lstrparms.String_arg[48] = 'N'
		end if
		
			
		lstrparms.String_arg[50] = string(today(),'MMDDYYYY' )
		lstrparms.String_Arg[51] = String(llRowPos) 
		lstrparms.String_Arg[52] = String(llRowCount)

		Lstrparms.String_arg[23] = dw_label.GetItemString(llRowPos,'Invoice_No')
		Lstrparms.String_arg[25] = String(llQty,'#####0')
		Lstrparms.String_arg[65] = dw_label.GetItemString(llRowPos,'Ord_Type')
		If dw_label.GetItemString(llRowPos,'serialized_ind') = 'O' or dw_label.GetItemString(llRowPos,'serialized_ind') = 'B' Then
			Lstrparms.String_arg[53] = 'Y'
		Else
			Lstrparms.String_arg[53] = 'N'
		End If	

		invo_labels.setLabelSequence( llRowPos )
		
		lsAny=lstrparms		
					
		invo_labels.setparms( lsAny )
		invo_labels.uf_pandora_shipping_label(lsAny)
	End if	 //End if for 'Y' to print
Next /*detail row to Print*/		
			



end event

public subroutine uf_fromcustomer (string as_from);//SetNull(isCustName)
//SetNull(isAddress_1)
//SetNull(isAddress_2)
//SetNull(isAddress_3)
//SetNull(isAddress_4)
//SetNull(isCity)
//SetNull(isState)
//SetNull(isZip)

SELECT 
//	   Project_ID
//      ,Cust_Code
//      ,Customer_Type
      Cust_Name
      ,Address_1
      ,Address_2
      ,Address_3
      ,Address_4
      ,City
      ,State
      ,Zip

//      ,Country
//      ,Contact_Person
//      ,Tel
//      ,Fax
//      ,Email_Address
//      ,Remark
//      ,Priority
//      ,User_Field1
//      ,User_Field2
//      ,User_Field3
//      ,Last_User
//      ,Last_Update
//      ,Price_Class
//      ,Tax_Class
//      ,Discount
//      ,Export_Control_Commodity_No
//      ,Harmonized_Code
//      ,VAT_Id
//      ,user_field4
//      ,user_field5
//      ,user_field6
//      ,User_Field7
//      ,User_Field8
//      ,User_Field9
//      ,User_Field10
//      ,CCC_Enabled_Ind
//      ,DWG_UPLOAD
//      ,DWG_UPLOAD_TIMESTAMP
//      ,uid
//      ,version
INTO :isCustName,:isAddress_1 ,:isAddress_2,:isAddress_3 ,:isAddress_4 ,:isCity ,:isState ,:isZip

FROM Customer where Project_ID = 'PANDORA' and Cust_Code = :as_From;
end subroutine

public subroutine uf_towarehouse (string as_to);//SetNull(isWHName)
//SetNull(isWHAddress_1)
//SetNull(isWHAddress_2)
//SetNull(isWHAddress_3)
//SetNull(isWHAddress_4)
//SetNull(isWHCity)
//SetNull(isWHState)
//SetNull(isWHZip)

SELECT 
//	   WH_Code
      WH_Name
//      ,WH_Type
      ,Address_1
      ,Address_2
      ,Address_3
      ,Address_4
      ,City
      ,State
      ,Zip
//      ,Country
//      ,Tel
//      ,Fax
//      ,Contact_Person
//      ,Remark
//      ,Last_User
//      ,Last_Update
//      ,User_Field1
//      ,User_Field2
//      ,User_Field3
//      ,Email_Address
//      ,UCC_Location_Prefix
//      ,Shipment_Enabled_Ind
//      ,Fwd_Pick_Email_Notification
//      ,GMT_Offset
//      ,DST_Flag
//      ,Trax_Enable_Ind
//      ,Trax_Label_Print_Dest
//      ,Dylght_Svngs_Time_Start
//      ,Dylght_Svngs_Time_End
//      ,Car_Priority_Pick_Ind
//      ,Transaction_Group
INTO :isWHName, :isWHAddress_1 , :isWHAddress_2 , :isWHAddress_3 , :isWHAddress_4 , :isWHCity , :isWHState , :isWHZip		

FROM Warehouse where WH_Code = :as_to;
string lstest
lstest = ''



end subroutine

on w_pandora_ship_label_print.create
int iCurrent
call super::create
this.cb_print=create cb_print
this.cb_selectall=create cb_selectall
this.cb_clear=create cb_clear
this.dw_label=create dw_label
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_print
this.Control[iCurrent+2]=this.cb_selectall
this.Control[iCurrent+3]=this.cb_clear
this.Control[iCurrent+4]=this.dw_label
end on

on w_pandora_ship_label_print.destroy
call super::destroy
destroy(this.cb_print)
destroy(this.cb_selectall)
destroy(this.cb_clear)
destroy(this.dw_label)
end on

event ue_postopen;call super::ue_postopen;
invo_labels = Create n_labels
i_nwarehouse = Create n_warehouse

cb_print.Enabled = False

isOrigSql = dw_label.GetSqlSelect()
//Choose case gs_ActiveWindow
//	Case  'IN'
//		This.Title = 'SSCC Labels Inbound'
//		isOrderType = 'INBOUND'
//	Case  'OUT'
//		This.Title = 'SSCC Labels Outbound'
//		isOrderType = 'OUTBOUND'
//	Case Else
//		Messagebox("Labels","You must have either the Inbound or Outbound Order screen open to print SSCC labels.")
//		Return
//End Choose
//
//This.TriggerEvent('ue_retrieve')


//We can only print based on DO_NO - User must have valid order open to pass DO_NO in from w_DO
If isVAlid(w_do) Then
	if w_do.idw_main.RowCOunt() > 0 Then
		isDoNo = w_do.idw_main.GetITemString(1,'do_no')
	End If
End If

If isNUll(isDONO) or  isDoNO = '' Then
	Messagebox('Labels','You must have an order retrieved in the Delivery Order Window~rbefore you can print labels!')
Else
	This.TriggerEvent('ue_retrieve')
End If





end event

event ue_retrieve;call super::ue_retrieve;cb_print.Enabled = False

If isdono > '' Then
	dw_label.Retrieve(isdono)
End If


If dw_label.RowCOunt() > 0 Then
Else
	Messagebox('Labels','Order Not found or Packing List not yet generated!')
	Return
End If



end event

event ue_selectall;call super::ue_selectall;Long	llRowPos,	&
		llRowCount
		
String ls_SKU, ls_SKU_Parent
		
dw_label.SetRedraw(False)

llRowCount = dw_label.RowCount()

If llRowCount > 0 Then

	For llRowPos = 1 to llRowCount
	
		 ls_SKU				= dw_label.GetItemString( llRowPos , "SKU"			) 
		// ls_SKU_Parent		= dw_label.GetItemString( llRowPos , "SKU_Parent"	)  //22-Jul-2016: Madhu - No column found
	 
		 If IsNull(  ls_SKU ) 			or Trim( ls_SKU ) = '' 			Then  ls_SKU = ''
		// If IsNull(   ls_SKU_Parent ) 	or Trim( ls_SKU_Parent ) = '' 	Then 	ls_SKU_Parent = '' //22-Jul-2016: Madhu - No column found
	 
		// If  ls_SKU <> '' and ls_SKU_Parent <> '' and   ls_SKU =  ls_SKU_Parent Then dw_label.SetITem(llRowPos,'c_print_ind','Y') //22-Jul-2016: Madhu - No column found
		If ls_SKU <> '' Then dw_label.SetITem(llRowPos,'c_print_ind','Y') //22-Jul-2016 :Madhu - Added to select all Rows.
	 
	Next
	
End If

dw_label.SetRedraw(True)

cb_print.Enabled = True

end event

event ue_unselectall;call super::ue_unselectall;Long	llRowPos,	&
		llRowCount
		
String   ls_SKU,  ls_SKU_Parent
		
dw_label.SetRedraw(False)

llRowCount = dw_label.RowCount()

If llRowCount > 0 Then

	For llRowPos = 1 to llRowCount
	
		 ls_SKU				= dw_label.GetItemString( llRowPos , "SKU"			) 
		 //ls_SKU_Parent		= dw_label.GetItemString( llRowPos , "SKU_Parent"	)  //22-Jul-2016: Madhu - No column found
	 
		 If IsNull(  ls_SKU ) 			or Trim( ls_SKU ) = '' 			Then  ls_SKU = ''
		// If IsNull(   ls_SKU_Parent ) 	or Trim( ls_SKU_Parent ) = '' 	Then 	ls_SKU_Parent = '' //22-Jul-2016: Madhu - No column found
	 
	   // If  ls_SKU <> '' and ls_SKU_Parent <> '' and   ls_SKU =  ls_SKU_Parent Then dw_label.SetITem(llRowPos,'c_print_ind','N') //22-Jul-2016: Madhu - No column found
		If  ls_SKU <> ''  Then dw_label.SetITem(llRowPos,'c_print_ind','N') //22-Jul-2016: Madhu - Added to Unselect all rows

	Next
	
End If

dw_label.SetRedraw(True)

cb_print.Enabled = True

end event

event resize;call super::resize;dw_label.Resize(workspacewidth() - 50,workspaceHeight()-150)
end event

event close;call super::close;IF ISVALID(i_nwarehouse) THEN Destroy(i_nwarehouse)
end event

type cb_cancel from w_main_ancestor`cb_cancel within w_pandora_ship_label_print
boolean visible = false
integer x = 1938
integer y = 1392
integer height = 80
end type

type cb_ok from w_main_ancestor`cb_ok within w_pandora_ship_label_print
integer x = 3666
integer y = 28
integer height = 80
integer textsize = -9
boolean default = false
end type

type cb_print from commandbutton within w_pandora_ship_label_print
integer x = 1531
integer y = 32
integer width = 329
integer height = 80
integer taborder = 30
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Print"
end type

event clicked;Parent.TriggerEvent('ue_Print')
end event

type cb_selectall from commandbutton within w_pandora_ship_label_print
integer x = 37
integer y = 32
integer width = 338
integer height = 80
integer taborder = 20
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Select All"
end type

event clicked;Parent.Event ue_selectall()

end event

type cb_clear from commandbutton within w_pandora_ship_label_print
integer x = 393
integer y = 32
integer width = 338
integer height = 80
integer taborder = 30
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Clear All"
end type

event clicked;Parent.Event ue_unselectall()
end event

type dw_label from u_dw_ancestor within w_pandora_ship_label_print
integer x = 9
integer y = 140
integer width = 5701
integer height = 1516
string dataobject = "d_pandora_shipping_labels_outbound"
boolean controlmenu = true
boolean hscrollbar = true
boolean vscrollbar = true
end type

event itemchanged;call super::itemchanged;
Choose Case Upper(dwo.name)
		
	Case "COUNTRY_OF_ORIGIN_DEFAULT"
		
		If data > "" Then
			
			If f_get_country_name(data) = "" Then
				Messagebox("Labels", "Invalid Country of Origin")
				Return 1
			End If
			
		End If
		
End Choose

If upper(dwo.Name) = 'C_PRINT_IND' and data = 'Y' Then cb_print.Enabled = True
end event

event itemerror;call super::itemerror;return 1
end event

event constructor;call super::constructor;
DatawindowChild	ldwc

This.GetChild('user_field11',ldwc)

ldwc.SetTransObject(SQLCA)

ldwc.Retrieve(gs_project,'PTLBL')
end event

event process_enter;call super::process_enter;
Send(Handle(This),256,9,Long(0,0))
end event

