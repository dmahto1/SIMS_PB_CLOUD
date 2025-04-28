$PBExportHeader$w_ariens_sscc_label_print.srw
forward
global type w_ariens_sscc_label_print from w_main_ancestor
end type
type cb_print from commandbutton within w_ariens_sscc_label_print
end type
type cb_selectall from commandbutton within w_ariens_sscc_label_print
end type
type cb_clear from commandbutton within w_ariens_sscc_label_print
end type
type dw_label from u_dw_ancestor within w_ariens_sscc_label_print
end type
type cbx_pallet from checkbox within w_ariens_sscc_label_print
end type
type cbx_container from checkbox within w_ariens_sscc_label_print
end type
end forward

global type w_ariens_sscc_label_print from w_main_ancestor
boolean visible = false
integer width = 3127
integer height = 1804
string title = "SSCC Labels"
string menuname = ""
event ue_print ( )
cb_print cb_print
cb_selectall cb_selectall
cb_clear cb_clear
dw_label dw_label
cbx_pallet cbx_pallet
cbx_container cbx_container
end type
global w_ariens_sscc_label_print w_ariens_sscc_label_print

type variables
n_warehouse i_nwarehouse
n_labels	invo_labels
n_3com_labels	invo_3com_labels
String	isUCCSCompanyPrefix, isUCCSWHPrefix

String isCustName,isAddress_1, isAddress_2 ,isAddress_3 ,isAddress_4 ,isCity ,isState ,isZip
String isWHName, isWHAddress_1, isWHAddress_2 , isWHAddress_3 , isWHAddress_4 , isWHCity , isWHState , isWHZip

String	isOrigSql


String isOrderType
String isLabelName
end variables

forward prototypes
public subroutine uf_fromcustomer (string as_from)
public subroutine uf_towarehouse (string as_to)
public function string uf_getsscc (string ascartonno, string asdono)
end prototypes

event ue_print();Str_Parms	lstrparms
n_labels	lu_labels
Long	llQty, llRowCount, llRowPos
Any	lsAny
Long liRC
String lsErrText,lsMsg
String lsRoNo, lsDoNo, lsPallet, lsContainer, lsNextPallet,lsCityStateZip,lsWHCityStateZip
String lsPrintLable, lsPrintCarton,lsCustomer,lsWarehouse
string ls_vics_bol_no,  ls_awb_bol_no,lsSSCC

n_warehouse l_nwarehouse 
n_cst_common_tables ln_common_tables
lu_labels 		= Create n_labels

Dw_Label.AcceptText()

If isLabelName = 'GRAINGER' then
	lstrparms.String_arg[70] = dw_label.GetITemString(1,'User_Field7')
	If Isnull(lstrparms.String_Arg[70])  or Pos(lstrparms.String_Arg[70], 'PR2') = 0 Then
		lsMsg = "No Grainger label required for this order"
	    	MessageBox('Label Error', lsMsg)
		Return	
	End if
End if

If dw_label.Find("c_print_ind = 'Y'",1,dw_label.RowCount()) = 0 Then
	MessageBox('Labels',"at least one row must be selected for printing!")
	Return
End If

If isOrderType = 'OUTBOUND' Then
	//ls_vics_bol_no = '00007510580014500013'
	//ls_vics_bol_no = dw_label.GetItemString(llRowPos,'vics_bol_no')
	ls_awb_bol_no =  dw_label.GetItemString(1, "awb_bol_no")
	
//	IF IsNull(ls_vics_bol_no) OR Trim(ls_vics_bol_no) = '' then
//		ls_vics_bol_no = i_nwarehouse.of_get_sscc_bol(gs_project,'BOL_No')
//		If ls_vics_bol_no = '' OR IsNull(ls_vics_bol_no) Then
//			MessageBox ("Error", "There was a problem creating the SSCC Number.  Please check with support")
//			Return
//		End if
//	End if
	
//	 If IsNull(ls_awb_bol_no) OR Trim(ls_awb_bol_no) = '' THEN
//		  MessageBox ("Warning", "AWB/BOL # field or BOL # Fields are blank")
//		  //if MessageBox ("Warning", "AWB/BOL # field and PRO/tracking # Fields are blank. Are you sure you want to continue to Print Labels?",  Exclamation!, YesNo!, 2 ) = 2 then
//			 Return
//		//end if
//	END IF
End if

OpenWithParm(w_label_print_options,lStrParms)
Lstrparms = Message.PowerObjectParm		  
If lstrParms.Cancelled Then Return 

Choose Case isOrderType
		//This was copied from Pandora.  Incase they want to use this with inbound orders.
		
//	Case 'INBOUND'
//
//		If  IsValid(w_ro)  then
//			lsRoNo = dw_label.GetITemString(1,'Ro_No')
//		End if
//		lstrparms.String_arg[65] = isOrderType
//
//		//Print each detail Row 
//		llRowCount = dw_label.RowCount()
//		For llRowPos = 1 to llRowCount /*each detail row */
//			
//			IF dw_label.object.c_print_ind[llRowPos] = 'Y' THEN 
//			
//				lsPallet = dw_label.object.po_no2[llRowPos]
//				lsContainer = dw_label.object.container_id[llRowPos]
//				
//				llQty = dw_label.object.quantity[llRowPos] 
//				Lstrparms.Long_arg[1] = llQty
//
//				//From Customer
//				lsCustomer = dw_label.object.user_field6[ llRowPos] 
//				If Len(lsCustomer) > 0 then
//					uf_FromCustomer(lsCustomer)
//					If isCustName = '' or IsNull(isCustName) then
//						isCustName = lsCustomer
//					End if
//				  LstrParms.String_arg[2] = isCustName
//			
//					Lstrparms.String_arg[3] = isAddress_1
//					Lstrparms.String_arg[4] = isAddress_2
//					Lstrparms.String_arg[5] = isAddress_3
//					Lstrparms.String_arg[6] = isAddress_4
//					If Not isnull(isCity) Then lsCityStateZip = isCity + ', '
//					If Not isnull(isState) Then lsCityStateZip += isState + ' '
//					If Not isnull(isZip) Then lsCityStateZip += isZip + ' '
//					Lstrparms.String_arg[7] = lsCityStateZip			
//				
//				End if
//				
//				lstrparms.String_arg[63] = lsPallet
//				lstrparms.String_arg[64] = lsContainer
//				lstrparms.String_arg[20] = dw_label.GetItemString(llRowPos,'Alternate_SKU')
//								
//				//From Customer
//				lsWarehouse = dw_label.object.wh_code[ llRowPos] 
//				If Len(lsWarehouse) > 0 then
//					uf_ToWarehouse(lsWarehouse)
//					If isWHName = '' or IsNull(isWHName) then
//						isWHName = lsWarehouse
//					End if
//				  LstrParms.String_arg[12] = isWHName
//			
//					Lstrparms.String_arg[13] = isWHAddress_1
//					Lstrparms.String_arg[14] = isWHAddress_2		
//					Lstrparms.String_arg[15] = isWHAddress_3
//					Lstrparms.String_arg[16] = isWHAddress_4
//					If Not isnull(isWHCity) Then lsWHCityStateZip = isWHCity + ', '
//					If Not isnull(isWHState) Then lsWHCityStateZip += isWHState + ' '
//					If Not isnull(isWHZip) Then lsWHCityStateZip += isWHZip + ' '
//					Lstrparms.String_arg[17] = lsWHCityStateZip			
//				End if
//				lstrparms.String_arg[40] = lsRoNo
//				Lstrparms.String_arg[48] = lsPallet
//				Lstrparms.String_arg[49] = lsContainer
//					
//				Lstrparms.String_arg[23] = dw_label.GetItemString(llRowPos,'Supp_Invoice_No')
//				Lstrparms.String_arg[24] = dw_label.GetItemString(llRowPos,'carrier')
//				Lstrparms.String_arg[25] = String(dw_label.GetItemNumber(llRowPos,'quantity'))
//
//				If lsNextPallet <> lsPallet then 
//					lsNextPallet = lsPallet	
//
//					If This.cbx_pallet.checked = True then
//						lsPrintLable = 'Y'
//					else
//						lsPrintLable = 'N'
//					End if
//					If This.cbx_container.checked = True then					
//						lsPrintCarton = 'Y'
//					Else
//						lsPrintCarton = 'N'
//					End if
//				Else
//					lsPrintLable = 'N'
//					If This.cbx_container.checked = False then										
//						lsPrintCarton = 'N'
//					End if
//				End if		
//				lstrparms.string_arg[65] = lsPrintLable
//				lstrparms.string_arg[66] = lsPrintCarton
//				lstrparms.string_arg[67] = 'BESTBUY'
//				lu_labels.setLabelSequence( llRowPos )
//
//				lsAny=lstrparms		
//					
//				lu_labels.setparms( lsAny )
//				lu_Labels.uf_ariens_ucc_128_zerbra_ship()
//				
//				
//			End if	 //End if for 'Y' to print
//		Next /*detail row to Print*/
	Case 'OUTBOUND'
		If  IsValid(w_do)  then
			lsDoNo = dw_label.GetITemString(1,'Do_No')
			
			lstrparms.String_arg[70] = dw_label.GetITemString(1,'User_Field7')
			
			If isLabelName = 'GRAINGER' then
				If Pos(lstrparms.String_Arg[70], 'PR2') > 0 then
						lstrparms.String_arg[60] = isLabelName
				End if
			End if
			
			//dw_label.SetITem(1,'vics_bol_no',ls_vics_bol_no)
			dw_label.accepttext( )

//			Execute Immediate "Begin Transaction" using SQLCA; 
//			liRC = dw_label.Update(True,True)
//			If liRC < 0 then
//				lsErrText = sqlca.sqlerrtext
//				Execute Immediate "ROLLBACK" using SQLCA; 
//				lsMsg = "Unable to save Delivery Master Record with vics_bol_no!~r~r " + lsErrText
//		     	MessageBox('Error', lsMsg)
//				SetMicroHelp("Save failed!")
//				Return
//			Else
//				Execute Immediate "COMMIT" using SQLCA; 
//			End if
		End if
		lstrparms.String_arg[65] = isOrderType
		


		//Print each detail Row 
		llRowCount = dw_label.RowCount()
		For llRowPos = 1 to llRowCount /*each detail row */
			
			IF dw_label.object.c_print_ind[llRowPos] = 'Y' THEN 
					
				//lsPallet = dw_label.object.po_no2[llRowPos]
				//lsContainer = dw_label.object.container_id[llRowPos]
					
				llQty = dw_label.object.quantity[llRowPos] 
				//Lstrparms.Long_arg[1] = llQty
					
				//Ship From
				lsCustomer = dw_label.object.wh_code[ llRowPos] 
				
				If Len(lsCustomer) > 0 then
					uf_FromCustomer(lsCustomer)
					If isCustName = '' or IsNull(isCustName) then
						isCustName = lsCustomer
					End if
					LstrParms.String_arg[2] = isCustName
					
//					isAddress_1 = dw_label.object.Address_1[ llRowPos] 
//					isAddress_2 = dw_label.object.Address_2[ llRowPos] 					
////					isAddress_2	=	'1222 EHLERS RD'
//					isCity = dw_label.object.City[ llRowPos] 					
//					isState = dw_label.object.State[ llRowPos] 					
//					isZip = dw_label.object.Zip[ llRowPos] 					
//					isCity = 'NEEHAH'
//					isState = 'WI'
//					isZip = '54956'
					
					Lstrparms.String_arg[3] = isAddress_1
					Lstrparms.String_arg[4] = isAddress_2
					Lstrparms.String_arg[5] = isAddress_3
					Lstrparms.String_arg[6] = isAddress_4
					If Not isnull(isCity) Then lsCityStateZip = isCity + ', '
					If Not isnull(isState) Then lsCityStateZip += isState + ' '
					If Not isnull(isZip) Then lsCityStateZip += isZip + ' '
					Lstrparms.String_arg[7] = lsCityStateZip			
				End if				
								
				lstrparms.String_arg[10]  = dw_label.GetItemString(llRowPos,'awb_bol_no')
				//Jxlim 04/01/2014 Jxlim Replaced user_field5 with Carrier_Pro_No -Ariens
				//lstrparms.String_arg[11]  = dw_label.GetItemString(llRowPos,'User_Field5')
				lstrparms.String_arg[11]  = dw_label.GetItemString(llRowPos,'Carrier_Pro_No')
					
				lstrparms.String_arg[63] = lsPallet
				lstrparms.String_arg[64] = lsContainer
				lstrparms.String_arg[20] = dw_label.GetItemString(llRowPos,'SKU')
				
				// 08/13 - PCONKL - now using serial number on label instead of ORder Number
			//	lstrparms.String_arg[21] = dw_label.GetItemString(llRowPos,'Cust_Order_No')
				lstrparms.String_arg[21] = dw_label.GetItemString(llRowPos,'serial_no')
				
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
				
				lstrparms.String_arg[40] = lsDoNo					

				//Lstrparms.String_arg[48] = lsPallet
				//Lstrparms.String_arg[48] = ls_vics_bol_no
				Lstrparms.String_arg[48] = uf_getsscc( dw_label.GetItemString(llRowPos,'Carton_no'), lsDoNo)
				
				Lstrparms.String_arg[49] = lsContainer
				Lstrparms.String_arg[23] = dw_label.GetItemString(llRowPos,'Invoice_No')
				Lstrparms.String_arg[24] = dw_label.GetItemString(llRowPos,'carrier')
				Lstrparms.String_arg[25] = String(dw_label.GetItemNumber(llRowPos,'quantity'))
				
				If dw_label.GetItemString(llRowPos,'Cust_Order_No') > '' Then
					Lstrparms.String_arg[26] = dw_label.GetItemString(llRowPos,'Cust_Order_No')
				Else
					Lstrparms.String_arg[26] = "         "
				End If
				
//				Lstrparms.String_arg[27] = 'DEALER/DST' //PO Type  //Hard coded in the Lable
				Lstrparms.String_arg[28] = dw_label.GetItemString(llRowPos,'Carton_No') //Carton tot
				
				//**This info is for the Home Depot Cross Doc label
//				Lstrparms.String_arg[31] = '07118' //Store Number **This is for the Home Depot Cross Doc label
//				Lstrparms.String_arg[33] = '30048733' //PO Number
//				Lstrparms.String_arg[34] = 'CROSS DOC' //PO Type  //Hard coded in the Lable
				
				//Pallet 1 of 1
				Lstrparms.String_arg[29] = String(llRowPos) //tot_off
				Lstrparms.String_arg[30] = String(llRowCount) //tot
				Lstrparms.String_arg[1] = String(dw_label.GetItemNumber(llRowPos,'c_print_qty'))
				
				//This is used for the Grainger label
				lstrparms.String_arg[61] = dw_label.GetItemString(llRowPos,'Alternate_SKU')
				lstrparms.String_arg[62] = String(dw_label.GetItemNumber(llRowPos,'Quantity'))
					
				If lsNextPallet <> lsPallet then 
					lsNextPallet = lsPallet	

					If This.cbx_pallet.checked = True then
						lsPrintLable = 'Y'
					else
						lsPrintLable = 'N'
					End if
					If This.cbx_container.checked = True then					
						lsPrintCarton = 'Y'
					Else
						lsPrintCarton = 'N'
					End if
				Else
					lsPrintLable = 'N'
					If This.cbx_container.checked = False then										
						lsPrintCarton = 'N'
					End if
				End if		
				lstrparms.string_arg[65] = lsPrintLable
				lstrparms.string_arg[66] = lsPrintCarton
				lstrparms.string_arg[67] = 'BESTBUY'
				
				lu_labels.setLabelSequence( llRowPos )
				
				lsAny=lstrparms		
					
				lu_labels.setparms( lsAny )
				lu_Labels.uf_ariens_ucc_128_zerbra_ship()

			End if	 //End if for 'Y' to print
		Next /*detail row to Print*/		
			
End Choose


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
     // Cust_Name
	  wh_name
     , Address_1
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
//INTO :isCustName,:isAddress_1 ,:isAddress_2,:isAddress_3 ,:isAddress_4 ,:isCity ,:isState ,:isZip
INTO :isCustName, :isAddress_1 ,:isAddress_2,:isAddress_3 ,:isAddress_4 ,:isCity ,:isState ,:isZip

//FROM Customer where Project_ID = 'ARIENS' and Cust_Code = :as_From;
FROM Warehouse where  wh_Code = :as_From;
string lstest
lstest = ''
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

public function string uf_getsscc (string ascartonno, string asdono);String lsCartonNo ,lsUCCS,lsDONO,lsUCCCompanyPrefix,lsOutString,lsDelimitChar
Long liCartonNo,liCheck

lsCartonNo = asCartonNo
lsDONO = asDono
lsDelimitChar = char(9)

//                                                lsCartonNo = idsdoPack.GetItemString(llRowPos, 'Carton_No')
SELECT Project.UCC_Company_Prefix INTO :lsUCCCompanyPrefix FROM Project WHERE Project_ID = :gs_project USING SQLCA;
                                IF IsNull(lsUCCCompanyPrefix) Then lsUCCCompanyPrefix = ''

																
                                                If IsNull(lsCartonNo) then lsCartonNo = ''
                                                If lsCartonNo <> '' Then
                                                                /* per Ariens, The base is ‘0000751058000000000N‘ where N is the check digit.
                                                                lsUCCS must be 17 digits long....
                                                                using 00751058 for Company code, preceding that by '00' so need 9 digits for serial of carton
                                                                using last 5 of do_no and then carton numbers, formatted to 4 digits
                                                                */
                                                                //the string function to pad 0's for the carton number doesn't work (returning only '0000')
                                                                liCartonNo = integer(lsCartonNo)
                                                                lsCartonNo = right(lsDONO, 5) + string(liCartonNo, '0000')
                                                                lsUCCS =  trim((lsUCCCompanyPrefix +  lsCartonNo))
                                                                //From BaseLine
                                                                liCheck = f_calc_uccs_check_Digit(lsUCCS) 
                                                                If liCheck >=0 Then
                                                                                lsUCCS = "00" + lsUCCS + String(liCheck) /* add 00 at beginning (not part of check digit calculation but included as tag */
                                                                Else
                                                                                lsUCCS = "00" + String(lsUCCS, '00000000000000000000') + "0"
                                                                End IF
                                                                lsOutString += lsUCCS  + lsDelimitChar
																				end if

Return lsOutString
end function

on w_ariens_sscc_label_print.create
int iCurrent
call super::create
this.cb_print=create cb_print
this.cb_selectall=create cb_selectall
this.cb_clear=create cb_clear
this.dw_label=create dw_label
this.cbx_pallet=create cbx_pallet
this.cbx_container=create cbx_container
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_print
this.Control[iCurrent+2]=this.cb_selectall
this.Control[iCurrent+3]=this.cb_clear
this.Control[iCurrent+4]=this.dw_label
this.Control[iCurrent+5]=this.cbx_pallet
this.Control[iCurrent+6]=this.cbx_container
end on

on w_ariens_sscc_label_print.destroy
call super::destroy
destroy(this.cb_print)
destroy(this.cb_selectall)
destroy(this.cb_clear)
destroy(this.dw_label)
destroy(this.cbx_pallet)
destroy(this.cbx_container)
end on

event ue_postopen;call super::ue_postopen;
invo_labels = Create n_labels
i_nwarehouse = Create n_warehouse

cb_print.Enabled = False

isOrigSql = dw_label.GetSqlSelect()

IstrParms = message.powerobjectparm
If IsValid(message.powerobjectparm) then
	isLabelName = IstrParms.String_arg[1]
End if
Choose case gs_ActiveWindow
//	Case  'IN'
//		This.Title = 'SSCC Labels Inbound'
//		isOrderType = 'INBOUND'
	Case  'OUT'
		This.Title = 'SSCC Labels Outbound'
		isOrderType = 'OUTBOUND'
	Case Else
		Messagebox("Labels","You must have the Outbound Order screen open to print SSCC labels.")
		Return
End Choose

This.TriggerEvent('ue_retrieve')
end event

event ue_retrieve;call super::ue_retrieve;
Choose case isOrderType 
//	Case 'INBOUND' 
//		If not isvalid(w_ro) Then Return
//			dw_label.DataObject = 'd_ariens_sscc_labels_inbound'
//			dw_label.SetTransObject(sqlca)
//		If w_ro.idw_main.RowCount() < 1 then return
//
//		dw_label.Retrieve(w_ro.idw_main.GetITemString(1,'ro_no'))
//		dw_label.setSort("po_no2,container_id")
//		dw_label.sort()
	Case 'OUTBOUND'
		If not isvalid(w_do) Then Return
			dw_label.DataObject = 'd_ariens_ucc_128_labels_outbound'
			dw_label.SetTransObject(sqlca)
			If w_do.idw_main.RowCount() < 1 then return
			dw_label.Retrieve(w_do.idw_main.GetITemString(1,'Do_no'))		
End Choose

//dw_label.SetFilter('SKU = SKU_Parent')	
//dw_label.Filter()

cb_print.Enabled = True


end event

event ue_selectall;call super::ue_selectall;Long	llRowPos,	&
		llRowCount
		
String ls_SKU, ls_SKU_Parent
		
dw_label.SetRedraw(False)

llRowCount = dw_label.RowCount()

If llRowCount > 0 Then

	For llRowPos = 1 to llRowCount
	
		 ls_SKU				= dw_label.GetItemString( llRowPos , "SKU"			) 
		 //ls_SKU_Parent		= dw_label.GetItemString( llRowPos , "SKU_Parent"	) 
	 
		 If IsNull(  ls_SKU ) 			or Trim( ls_SKU ) = '' 			Then  ls_SKU = ''
		 //If IsNull(   ls_SKU_Parent ) 	or Trim( ls_SKU_Parent ) = '' 	Then 	ls_SKU_Parent = ''
	 
//		 If  ls_SKU <> '' and ls_SKU_Parent <> '' and   ls_SKU =  ls_SKU_Parent Then dw_label.SetITem(llRowPos,'c_print_ind','Y')
	 	If  ls_SKU <> ''   Then dw_label.SetITem(llRowPos,'c_print_ind','Y')
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
		// ls_SKU_Parent		= dw_label.GetItemString( llRowPos , "SKU_Parent"	) 
	 
		 If IsNull(  ls_SKU ) 			or Trim( ls_SKU ) = '' 			Then  ls_SKU = ''
		 //If IsNull(   ls_SKU_Parent ) 	or Trim( ls_SKU_Parent ) = '' 	Then 	ls_SKU_Parent = ''
	 
//		If  ls_SKU <> '' and ls_SKU_Parent <> '' and   ls_SKU =  ls_SKU_Parent Then dw_label.SetITem(llRowPos,'c_print_ind','N')
		If  ls_SKU <> ''  Then dw_label.SetITem(llRowPos,'c_print_ind','N')

	Next
	
End If

dw_label.SetRedraw(True)

cb_print.Enabled = True

end event

event resize;call super::resize;dw_label.Resize(workspacewidth() - 50,workspaceHeight()-150)
end event

event close;call super::close;IF ISVALID(i_nwarehouse) THEN Destroy(i_nwarehouse)
end event

type cb_cancel from w_main_ancestor`cb_cancel within w_ariens_sscc_label_print
boolean visible = false
integer x = 1938
integer y = 1392
integer height = 80
end type

type cb_ok from w_main_ancestor`cb_ok within w_ariens_sscc_label_print
boolean visible = false
integer x = 1371
integer y = 32
integer height = 80
integer textsize = -9
boolean default = false
end type

type cb_print from commandbutton within w_ariens_sscc_label_print
integer x = 891
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

type cb_selectall from commandbutton within w_ariens_sscc_label_print
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

type cb_clear from commandbutton within w_ariens_sscc_label_print
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

type dw_label from u_dw_ancestor within w_ariens_sscc_label_print
integer x = 9
integer y = 140
integer width = 3045
integer height = 1516
string dataobject = "d_ariens_ucc_128_labels_outbound"
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

type cbx_pallet from checkbox within w_ariens_sscc_label_print
boolean visible = false
integer x = 1856
integer y = 28
integer width = 649
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Pallet Labels Only"
boolean checked = true
end type

type cbx_container from checkbox within w_ariens_sscc_label_print
boolean visible = false
integer x = 2368
integer y = 28
integer width = 649
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Container Labels Only"
end type

