HA$PBExportHeader$w_klonelab_carton_label.srw
forward
global type w_klonelab_carton_label from w_main_ancestor
end type
type cb_print from commandbutton within w_klonelab_carton_label
end type
type cb_selectall from commandbutton within w_klonelab_carton_label
end type
type cb_clear from commandbutton within w_klonelab_carton_label
end type
type dw_label from u_dw_ancestor within w_klonelab_carton_label
end type
type dw_label_select from datawindow within w_klonelab_carton_label
end type
type cb_save from commandbutton within w_klonelab_carton_label
end type
type dw_carton_require from datawindow within w_klonelab_carton_label
end type
end forward

global type w_klonelab_carton_label from w_main_ancestor
boolean visible = false
integer width = 5285
integer height = 2888
string title = "KloneLab Container Labels"
string menuname = ""
boolean center = true
event ue_print ( )
cb_print cb_print
cb_selectall cb_selectall
cb_clear cb_clear
dw_label dw_label
dw_label_select dw_label_select
cb_save cb_save
dw_carton_require dw_carton_require
end type
global w_klonelab_carton_label w_klonelab_carton_label

type variables
n_warehouse i_nwarehouse
n_labels	invo_labels
n_3com_labels	invo_3com_labels

String	isOrigSql


end variables

event ue_print();Str_Parms	lstrparms
n_labels	lu_labels
string ls_uf5, ls_uf6, ls_PartInfo
integer liTextCurrentRow
integer li_Sku_Idx, liMaxRowCount, liIdx
integer li_label_total_lines

//To Address - Roll up addresses if not all present
string   lsCityStateZip

liMaxRowCount = 50

Long	llQty, llRowCount, llRowPos, ll_rtn, llPrintJob, llFindRow, llPrintPos, llPrintCount, ld_Qunatity
		
Any	lsAny

String	lsformat, lsFormatSave, lsPrinter, lsLabel, lsLabelPrint, lsPrintText,  &
			lsCurrentLabel, lsLabelType, lsDateCode, lsKlone_sku_desc_color, lsTemp
Integer	liMsg


lu_labels = Create n_labels

Dw_Label.AcceptText()

dw_label_select.AcceptText()


datastore lds_sku
lds_sku = create datastore
lds_sku.dataobject = "d_klonelab_carton_labels_sku_detail_nolock"
lds_sku.SetTransObject(SQLCA)


datastore lds_column
lds_column = create datastore
lds_column.dataobject = "d_klonelab_carton_labels_carton_req_nolock"
lds_column.SetTransObject(SQLCA)




lsLabelType = dw_label_select.GetITEmString(1,'label')

//IF IsNull(lsLabelType) or Trim(lsLabelType) = '' then
//		
//	MessageBox ("Invalid label", "Please select a label type.")
//		
//	dw_label_select.SetFocus()	
//		
//	Return
//		
//End IF

llRowCount = dw_label.RowCount()


OpenWithParm(w_label_print_options,lStrParms)
Lstrparms = Message.PowerObjectParm		  
If lstrParms.Cancelled Then
	Return
End If
			
lsPrintText = 'KloneLab Part Labels '


integer liColIdx, liColRowCount
string lsAcctNum, lsCartonNo, lsCust_Code, lsDisplayText
string lsCust_Name, lsAddress_1, lsAddress_2, lsAddress_3, lsAddress_4,	lsCity, lsState, lsZip, ls_User_Field9, ls_User_Field10


lsAcctNum = w_do.idw_main.GetItemString( 1, "user_field2")

Select 
	Cust_Code, Cust_Name, Address_1, Address_2, Address_3, Address_4, 
	City, State, Zip, User_Field9, User_Field10
INTO 
	:lsCust_Code, :lsCust_Name, :lsAddress_1, :lsAddress_2, :lsAddress_3, :lsAddress_4,
	:lsCity, :lsState, :lsZip, :ls_User_Field9, :ls_User_Field10
FROM Customer Where project_ID = 'KLONELAB' and ( User_Field1 = :lsAcctNum or User_Field2 = :lsAcctNum) USING SQLCA;

IF SQLCA.SQLCode = 100 THEN
	
	MessageBox ("Unable to Print Carton Label", "The account number on the order cannot be linked to a customer.")
	RETURN
	
END IF

//ls_User_Field10 =  "Klone_Generic_Carton_Zebra_SmallFont.txt"
liColRowCount = lds_column.Retrieve( gs_project, lsCust_Code, 'C')

if liColRowCount <= 0 then
	MessageBox ("Unable to Print Carton Label", "There are no data items for this customer ("+lsCust_Code+") assigned to the carton label.")
	RETURN
end if

//Open Printer File 
llPrintJob = PrintOpen(lsPrintText)

If llPrintJob <0 Then 
	Messagebox('Labels', 'Unable to open Printer file. Labels will not be printed')
	Return
End If



For llRowPos = 1 to llRowCount /*each detail row */
			
	If dw_label.GetITEmString(llRowPos,'c_print_ind') <> 'Y' Then Continue
		
			lsformat = ls_User_Field10
			
			CHOOSE CASE UPPER(lsformat)
			CASE "KLONE_GENERIC_CARTON_ZEBRA_SMALLFONT.TXT"
				li_label_total_lines = 47
			CASE "KLONE_GENERIC_CARTON_ZEBRA_BIGFONT.TXT"
				li_label_total_lines = 22
			END CHOOSE
		
			lsLabel = lu_labels.uf_read_label_Format(lsFormat)
			
			If lsLabel = "" Then Return
		
			lsCurrentLabel= lsLabel
		
			lsCartonNo = dw_label.GetItemString(llRowPos,'carton_no')

			//Header

			liTextCurrentRow = 0


			FOR liColIdx = 1 to liColRowCount 

				lsDisplayText = lds_column.GetItemString( liColIdx, "display_text")

				CHOOSE CASE Upper(lsDisplayText)	
						
						
				CASE 'TEXT'
					
						liTextCurrentRow = liTextCurrentRow + 1
					
						lsTemp =  lds_column.GetItemString( liColIdx, "Data_Value")
						
						If IsNull(lsTemp) then lsTemp = ''
					
						lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel, "~~headertext"+string(liTextCurrentRow)+"~~", lsTemp) 						
						
						
						
				CASE 'PO'
					
						liTextCurrentRow = liTextCurrentRow + 1
					
						lsTemp = dw_label.GetItemString(llRowPos,'delivery_master_po_number')
						
						If IsNull(lsTemp) then lsTemp = ''
					
						lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel, "~~headertext"+string(liTextCurrentRow)+"~~", "PO #: " + lsTemp) 
						
					//Carton n of n
	
//					CASE 'CARTONOF'
//						
//						//string(integer(left(dw_label.GetItemString(llRowPos,'carton_no'),3)))
//					
//						liTextCurrentRow = liTextCurrentRow + 1
//						
//						lsTemp = "Carton " +  string(llRowPos) + " of " + string(dw_label.GetItemNumber(llRowPos,'total_cartons'))
//					
//						If IsNull(lsTemp) then lsTemp = ''
//					
//						lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel, "~~headertext"+string(liTextCurrentRow)+"~~", lsTemp) 
//						
//						
//				CASE 'STOREREADY'
//					
//						liTextCurrentRow = liTextCurrentRow + 1
//					
//						lsTemp = dw_label.GetItemString(llRowPos,'store_ready')
//						
//						If IsNull(lsTemp) then lsTemp = ''
//					
//						lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel, "~~headertext"+string(liTextCurrentRow)+"~~", "Store Ready: " + lsTemp) 
//						
//				
//				CASE 'PRETICKETED'
//					
//						liTextCurrentRow = liTextCurrentRow + 1
//					
//						lsTemp = dw_label.GetItemString(llRowPos,'pre_ticketed')
//						
//						If IsNull(lsTemp) then lsTemp = ''
//					
//						lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel, "~~headertext"+string(liTextCurrentRow)+"~~", "Pre-ticketed: " + lsTemp) 

				//Store Number	
						
				CASE 'STORENUM'
					
						liTextCurrentRow = liTextCurrentRow + 1
					
						lsTemp = dw_label.GetItemString(llRowPos,'delivery_master_store_number')
						
						If IsNull(lsTemp) then lsTemp = ''
					
						lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel, "~~headertext"+string(liTextCurrentRow)+"~~", "Store #: " + lsTemp) 						
						
						

				//BOL Number
						
				CASE 'BOL'
					
						liTextCurrentRow = liTextCurrentRow + 1
					
						lsTemp = dw_label.GetItemString(llRowPos,'delivery_master_bol_number')
						
						If IsNull(lsTemp) then lsTemp = ''
					
						lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel, "~~headertext"+string(liTextCurrentRow)+"~~", "BOL #: " + lsTemp) 	
						
				
				CASE 'VENDORNAME'					
					
					If lsCust_Name > ' '  Then
						liTextCurrentRow = liTextCurrentRow + 1
						lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel, "~~headertext"+string(liTextCurrentRow)+"~~", "VENDOR: " + lsCust_Name) 	
					End If
						
				CASE 'CUSTNAME'
					
					lsTemp = dw_label.GetItemString(llRowPos,'delivery_master_cust_name')

					IF IsNull(lsTemp) then lsTemp = ''
						
					If lsCust_Name > ' '  Then
						liTextCurrentRow = liTextCurrentRow + 1
						lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel, "~~headertext"+string(liTextCurrentRow)+"~~", "CUST: " + lsTemp) 	
					End If						
						
						
				CASE 'VENDORADDRESS'
					
					
					//From Address - Roll up addresses if not all present
					
					liTextCurrentRow = liTextCurrentRow + 1
					lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel, "~~headertext"+string(liTextCurrentRow)+"~~", "Vendor Address: ") 	
					
					
					If lsCust_Name > ' '  Then
						liTextCurrentRow = liTextCurrentRow + 1
						lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel, "~~headertext"+string(liTextCurrentRow)+"~~", lsCust_Name) 	
					End If
					
					
					If lsAddress_1 > ' '  Then
						liTextCurrentRow = liTextCurrentRow + 1
						lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel, "~~headertext"+string(liTextCurrentRow)+"~~",  lsAddress_1) 	
					End If
					
					
					If lsAddress_2 > ' '  Then
						liTextCurrentRow = liTextCurrentRow + 1
						lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel, "~~headertext"+string(liTextCurrentRow)+"~~",  lsAddress_2) 	
					End If
					
					If lsAddress_3 > ' '  Then
						liTextCurrentRow = liTextCurrentRow + 1
						lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel, "~~headertext"+string(liTextCurrentRow)+"~~",  lsAddress_3) 	
					End If
					
					If lsAddress_4 > ' '  Then
						liTextCurrentRow = liTextCurrentRow + 1
						lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel, "~~headertext"+string(liTextCurrentRow)+"~~",  lsAddress_4) 	
					End If
					
					lsCityStateZip = ''
					If Not isnull(lsCity) Then lsCityStateZip = lsCity + ', '
					If Not isnull(lsState) Then lsCityStateZip += lsState + ' '
					If Not isnull(lsZip) Then lsCityStateZip +=  lsZip + ' '
					
					
					If lsCityStateZip > ' '  Then
						liTextCurrentRow = liTextCurrentRow + 1
						lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel, "~~headertext"+string(liTextCurrentRow)+"~~",  lsCityStateZip) 	
					End If
					
					//Make Extra Line
			
					liTextCurrentRow = liTextCurrentRow + 1
							
					lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel, "~~headertext"+string(liTextCurrentRow)+"~~", "") 


				CASE 'SHIPTOADDRESS'
					
					
					liTextCurrentRow = liTextCurrentRow + 1
					lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel, "~~headertext"+string(liTextCurrentRow)+"~~",  "Ship To Address: ") 

			
					lsTemp = dw_label.GetItemString(llRowPos,'delivery_master_cust_name')
			
					If IsNull(lsTemp) then lsTemp = ''

					liTextCurrentRow = liTextCurrentRow + 1
					lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel, "~~headertext"+string(liTextCurrentRow)+"~~", lsTemp)  

			
			
					lsTemp = dw_label.GetItemString(llRowPos,'delivery_master_address_1')
					
					If lsTemp > ' '  Then
						liTextCurrentRow = liTextCurrentRow + 1
						lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel, "~~headertext"+string(liTextCurrentRow)+"~~",  lsTemp)  
					End If
			
			
			
					lsTemp = dw_label.GetItemString(llRowPos,'delivery_master_address_2')
			
					If lsTemp > ' '  Then
						liTextCurrentRow = liTextCurrentRow + 1
						lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel, "~~headertext"+string(liTextCurrentRow)+"~~",  lsTemp)  
					End If
			
					lsTemp = dw_label.GetItemString(llRowPos,'delivery_master_address_3')
			
					If lsTemp > ' '  Then
						liTextCurrentRow = liTextCurrentRow + 1
						lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel, "~~headertext"+string(liTextCurrentRow)+"~~",  lsTemp)  
					End If
			
			
					lsTemp = dw_label.GetItemString(llRowPos,'delivery_master_address_4')
			
					If lsTemp > ' '  Then
						liTextCurrentRow = liTextCurrentRow + 1
						lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel, "~~headertext"+string(liTextCurrentRow)+"~~",  lsTemp)  
					End If
			
					lsCityStateZip = ''
					If Not isnull(dw_label.GetItemString(llRowPos,'delivery_master_City')) Then lsCityStateZip = dw_label.GetItemString(llRowPos,'delivery_master_City') + ', '
					If Not isnull(dw_label.GetItemString(llRowPos,'delivery_master_State')) Then lsCityStateZip += dw_label.GetItemString(llRowPos,'delivery_master_State') + ' '
					If Not isnull(dw_label.GetItemString(llRowPos,'delivery_master_Zip')) Then lsCityStateZip += dw_label.GetItemString(llRowPos,'delivery_master_Zip') + ' '
					
					
			If lsCityStateZip > ' '  Then
				liTextCurrentRow = liTextCurrentRow + 1
				lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel, "~~headertext"+string(liTextCurrentRow)+"~~",  lsCityStateZip)  
			End If
		

			
			//Make Extra Line
			
			liTextCurrentRow = liTextCurrentRow + 1
							
			lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel, "~~headertext"+string(liTextCurrentRow)+"~~", "") 

		
		END CHOOSE
		
		
		next


		//Sku (Detail)
			
		lds_sku.Retrieve(w_do.idw_main.GetITemString(1,'do_no'), lsCartonNo)

		//Make Extra Line

		liTextCurrentRow = liTextCurrentRow + 1
				
		lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel, "~~headertext"+string(liTextCurrentRow)+"~~", "") 
	

		for li_Sku_Idx = 1 to lds_sku.RowCount()
			
			if li_Sku_Idx < 6 then 
				
			FOR liColIdx = 1 to liColRowCount 

				lsDisplayText = lds_column.GetItemString( liColIdx, "display_text")


				CHOOSE CASE Upper(lsDisplayText)	
						
				CASE 'SKUMATRIX'
						
						
					//Vendor Sku
				
					String lsTemp2
				
					liTextCurrentRow = liTextCurrentRow + 1
				
					lsTemp =  lds_sku.GetItemString(li_Sku_Idx,'delivery_packing_sku')
					lsTemp2 =  string(lds_sku.GetItemNumber(li_Sku_Idx,'delivery_packing_quantity'))
					
					If IsNull(lsTemp) then lsTemp = ''
					If IsNull(lsTemp2) then lsTemp2 = ''
				
					lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel, "~~headertext"+string(liTextCurrentRow)+"~~", "Sku: " + lsTemp + " Qty: " + lsTemp2 )
					

					liTextCurrentRow = liTextCurrentRow + 1
				
					lsTemp =  lds_sku.GetItemString(li_Sku_Idx,'item_master_description')
					lsTemp2  =  lds_sku.GetItemString(li_Sku_Idx,'item_master_size')
					
					If IsNull(lsTemp) then lsTemp = ''
					If IsNull(lsTemp2) then lsTemp2 = ''
				
					lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel, "~~headertext"+string(liTextCurrentRow)+"~~", "Desc: " + lsTemp + " Size: " + lsTemp2 )

						
					liTextCurrentRow = liTextCurrentRow + 1
				
					lsTemp =  lds_sku.GetItemString(li_Sku_Idx,'item_master_color')
					lsTemp2 =  lds_sku.GetItemString(li_Sku_Idx,'item_master_department_number')
					
					If IsNull(lsTemp) then lsTemp = ''
					If IsNull(lsTemp2) then lsTemp2 = ''
				
					lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel, "~~headertext"+string(liTextCurrentRow)+"~~", "Color: " + lsTemp + " Dept: " + lsTemp2 )	
						
						
						
				CASE 'VENDORSKU'
					
					//Vendor Sku
				
					liTextCurrentRow = liTextCurrentRow + 1
				
					lsTemp =  lds_sku.GetItemString(li_Sku_Idx,'delivery_packing_sku')
					
					If IsNull(lsTemp) then lsTemp = ''
				
					lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel, "~~headertext"+string(liTextCurrentRow)+"~~", "Sku: " + lsTemp) 
				
					
				CASE 'CUSTSKU'
					

					//Cust Sku
				
					liTextCurrentRow = liTextCurrentRow + 1
				
					lsTemp =  lds_sku.GetItemString(li_Sku_Idx,'item_master_alternate_sku')
					
					If IsNull(lsTemp) then lsTemp = ''
				
					lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel, "~~headertext"+string(liTextCurrentRow)+"~~", "Cust Sku: " + lsTemp) 
			
					
					
					
				CASE 'SKUDESC'
					
					
					//Description
				
					liTextCurrentRow = liTextCurrentRow + 1
				
					lsTemp =  lds_sku.GetItemString(li_Sku_Idx,'item_master_description')
					
					If IsNull(lsTemp) then lsTemp = ''
				
					lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel, "~~headertext"+string(liTextCurrentRow)+"~~", "Desc: " + lsTemp) 

					
				CASE 'COLOR'
					
					
					//Color
				
					liTextCurrentRow = liTextCurrentRow + 1
				
					lsTemp =  lds_sku.GetItemString(li_Sku_Idx,'item_master_color')
					
					If IsNull(lsTemp) then lsTemp = ''
				
					lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel, "~~headertext"+string(liTextCurrentRow)+"~~", "Color: " + lsTemp) 
					
					
				CASE 'SIZE'
					
					//Size
				
					liTextCurrentRow = liTextCurrentRow + 1
				
					lsTemp =  lds_sku.GetItemString(li_Sku_Idx,'item_master_size')
					
					If IsNull(lsTemp) then lsTemp = ''
				
					lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel, "~~headertext"+string(liTextCurrentRow)+"~~", "Size: " + lsTemp) 
				
					
				CASE 'QUANTITY'

					//Quantity
				
					liTextCurrentRow = liTextCurrentRow + 1
				
					lsTemp =  string(lds_sku.GetItemNumber(li_Sku_Idx,'delivery_packing_quantity'))
					
					
					If IsNull(lsTemp) then lsTemp = ''
				
					lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel, "~~headertext"+string(liTextCurrentRow)+"~~", "Qty: " + lsTemp) 
	
					
				CASE 'DEPT'
					
					
					//Department Number
				
					liTextCurrentRow = liTextCurrentRow + 1
				
					lsTemp =  lds_sku.GetItemString(li_Sku_Idx,'item_master_department_number')
					
					If IsNull(lsTemp) then lsTemp = ''
				
					lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel, "~~headertext"+string(liTextCurrentRow)+"~~", "Dept: " + lsTemp) 
					
					
				CASE 'COO'
					
					//Country of Origin
				
					liTextCurrentRow = liTextCurrentRow + 1
				
					lsTemp =  lds_sku.GetItemString(li_Sku_Idx,'item_master_country_of_origin_default')
					
					If IsNull(lsTemp) then lsTemp = ''
				
					lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel, "~~headertext"+string(liTextCurrentRow)+"~~", "Country of Origin: " + lsTemp) 
						
					

				END CHOOSE


			Next	
								

		
		
			end if
			
			

							
			
			
		


Next


//--
			
			//Make Extra Line
			
			liTextCurrentRow = liTextCurrentRow + 1
							
			lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel, "~~headertext"+string(liTextCurrentRow)+"~~", "") 


			FOR liColIdx = 1 to liColRowCount 

				lsDisplayText = lds_column.GetItemString( liColIdx, "display_text")

				CHOOSE CASE Upper(lsDisplayText)				
	
					CASE 'CARTONOF'
						
						//string(integer(left(dw_label.GetItemString(llRowPos,'carton_no'),3)))
					
						liTextCurrentRow = liTextCurrentRow + 1
						
						lsTemp = "Carton " +  string(llRowPos) + " of " + string(dw_label.GetItemNumber(llRowPos,'total_cartons'))
					
						If IsNull(lsTemp) then lsTemp = ''
					
						lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel, "~~headertext"+string(li_label_total_lines)+"~~", lsTemp) 
						
						
				CASE 'STOREREADY'
					
						liTextCurrentRow = liTextCurrentRow + 1
					
						lsTemp = dw_label.GetItemString(llRowPos,'store_ready')
						
						If IsNull(lsTemp) then lsTemp = ''
					
						lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel, "~~headertext"+string(li_label_total_lines -1)+"~~", "Store Ready: " + lsTemp) 
						
				
				CASE 'PRETICKETED'
					
						liTextCurrentRow = liTextCurrentRow + 1
					
						lsTemp = dw_label.GetItemString(llRowPos,'pre_ticketed')
						
						If IsNull(lsTemp) then lsTemp = ''
					
						lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel, "~~headertext"+string(li_label_total_lines - 2)+"~~", "Pre-ticketed: " + lsTemp) 



		
		END CHOOSE
		
	Next

//--







				//Empty out an remaining rows.
		
				for liIdx =  1 to li_label_total_lines
					
					lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel, "~~headertext"+string(liIdx)+"~~", "") 
				
				next

//MessageBox ("label", lsCurrentLabel)



	
	
	//	MessageBox (lsformat, lsCurrentLabel) 

	
	integer liPos	
		
	llPrintCount = dw_label.GetITemNUmber(llRowPos,'no_of_copies')	
		
	liPos = Pos(lsCurrentLabel, "^PQ", 1)
	
	if liPos > 0 then
		
		lsCurrentLabel = left(lsCurrentLabel,(liPos + 2)) + string(llPrintCount) + mid(lsCurrentLabel,(liPos + 4))
		
	end if	
		
	
	lsLabelPrint = lsCurrentLabel

	PrintSend(llPrintJob, lsLabelPrint)	
			
Next /*detail row to Print*/

//End If


PrintClose(llPrintJob)

//
////Send the format to the printer...
//If lsLabelPrint > "" Then
//		
//
//
//		
//		
//		
//End If
		










end event

on w_klonelab_carton_label.create
int iCurrent
call super::create
this.cb_print=create cb_print
this.cb_selectall=create cb_selectall
this.cb_clear=create cb_clear
this.dw_label=create dw_label
this.dw_label_select=create dw_label_select
this.cb_save=create cb_save
this.dw_carton_require=create dw_carton_require
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_print
this.Control[iCurrent+2]=this.cb_selectall
this.Control[iCurrent+3]=this.cb_clear
this.Control[iCurrent+4]=this.dw_label
this.Control[iCurrent+5]=this.dw_label_select
this.Control[iCurrent+6]=this.cb_save
this.Control[iCurrent+7]=this.dw_carton_require
end on

on w_klonelab_carton_label.destroy
call super::destroy
destroy(this.cb_print)
destroy(this.cb_selectall)
destroy(this.cb_clear)
destroy(this.dw_label)
destroy(this.dw_label_select)
destroy(this.cb_save)
destroy(this.dw_carton_require)
end on

event ue_postopen;call super::ue_postopen;
String lsCustCode


datastore lds_column
lds_column = create datastore
lds_column.dataobject = "d_klonelab_carton_labels_carton_req_nolock"
lds_column.SetTransObject(SQLCA)

dw_label_select.InsertRow(0)

invo_labels = Create n_labels
i_nwarehouse = Create n_warehouse

cb_print.Enabled = False

isOrigSql = dw_label.GetSqlSelect()

IF not isvalid(w_do) Then
	Messagebox("Labels","You must have an open Delivery Order to print part labels.")
	Return 
End If

This.TriggerEvent('ue_retrieve')



string lsAcctNum, lsCust_Code

lsAcctNum = w_do.idw_main.GetItemString( 1, "user_field2")

Select 
	Cust_Code
INTO  :lsCust_Code
FROM Customer Where project_ID = :gs_project and ( User_Field1 = :lsAcctNum or User_Field2 = :lsAcctNum) USING SQLCA;


dw_carton_require.SetTransObject(SQLCA)
dw_carton_require.Retrieve(gs_project, lsCust_Code, 'R')


lds_column.Retrieve( gs_project, lsCust_Code, 'C')

if lds_column.Find( "display_text='STOREREADY'", 1, lds_column.RowCount()) > 0 then
	dw_label.Object.store_ready.visible=true
end if

if lds_column.Find( "display_text='PRETICKETED'", 1, lds_column.RowCount()) > 0 then
	dw_label.Object.pre_ticketed.visible=true
end if


						

		



end event

event ue_retrieve;call super::ue_retrieve;

If not isvalid(w_do) Then Return
If w_do.idw_main.RowCount() < 1 then return

dw_label.Retrieve(w_do.idw_main.GetITemString(1,'do_no'))

//o	Select (checkbox)
//o	No of Copies (Default to line item Qty)
//o	Line Item
//o	SKU
//-	Dropdown to select label format to print (I don$$HEX1$$1920$$ENDHEX$$t believe we will have a customer master or Order field to get the format from $$HEX2$$13202000$$ENDHEX$$they will need to manually choose )
//

string lsAcctNum, ls_User_Field7
integer li_idx

lsAcctNum = w_do.idw_main.GetItemString( 1, "user_field2")

Select 
	User_Field7
INTO 
	:ls_User_Field7
FROM Customer Where project_ID = 'KLONELAB' and ( User_Field1 = :lsAcctNum or User_Field2 = :lsAcctNum) USING SQLCA;


if integer(ls_User_Field7) > 1 then
	for li_idx = 1 to dw_label.RowCount()
		dw_label.SetItem(li_idx,"no_of_copies", integer(ls_User_Field7) )
	next
end if

cb_print.Enabled = True


end event

event ue_selectall;call super::ue_selectall;Long	llRowPos,	&
		llRowCount
		
		
dw_label.SetRedraw(False)

llRowCount = dw_label.RowCount()

If llRowCount > 0 Then

	For llRowPos = 1 to llRowCount

	 
		dw_label.SetITem(llRowPos,'c_print_ind','Y')
	 
	Next
	
End If

dw_label.SetRedraw(True)

cb_print.Enabled = True

end event

event ue_unselectall;call super::ue_unselectall;Long	llRowPos,	&
		llRowCount
		
		
dw_label.SetRedraw(False)

llRowCount = dw_label.RowCount()

If llRowCount > 0 Then

	For llRowPos = 1 to llRowCount
	
	 
		dw_label.SetITem(llRowPos,'c_print_ind','N')

	Next
	
End If

dw_label.SetRedraw(True)

cb_print.Enabled = True

end event

event resize;call super::resize;//dw_label.Resize(workspacewidth() - 50,workspaceHeight()-150)
end event

event close;call super::close;IF ISVALID(i_nwarehouse) THEN Destroy(i_nwarehouse)
end event

type cb_cancel from w_main_ancestor`cb_cancel within w_klonelab_carton_label
boolean visible = false
integer x = 1938
integer y = 1392
integer height = 80
end type

type cb_ok from w_main_ancestor`cb_ok within w_klonelab_carton_label
integer x = 1609
integer y = 32
integer height = 80
integer textsize = -9
boolean default = false
end type

type cb_print from commandbutton within w_klonelab_carton_label
integer x = 923
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

type cb_selectall from commandbutton within w_klonelab_carton_label
integer x = 14
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

type cb_clear from commandbutton within w_klonelab_carton_label
integer x = 370
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

type dw_label from u_dw_ancestor within w_klonelab_carton_label
integer x = 9
integer y = 148
integer width = 5179
integer height = 1424
string dataobject = "d_klonelab_carton_labels_nolock"
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

event process_enter;call super::process_enter;
Send(Handle(This),256,9,Long(0,0))
end event

type dw_label_select from datawindow within w_klonelab_carton_label
boolean visible = false
integer x = 91
integer y = 152
integer width = 1842
integer height = 124
integer taborder = 20
boolean bringtotop = true
string title = "none"
string dataobject = "d_klonelab_label_select"
boolean border = false
end type

event itemchanged;

Choose case  lower(dwo.name)
		
Case "label"

	if data = "Sears Canada" then

		if dw_label.dataobject <> "d_klonelab_part_labels_nolock_pack" then
			
			dw_label.dataobject = "d_klonelab_part_labels_nolock_pack"

			dw_label.SetTransObject(SQLCA)
			
			SetPointer(Hourglass!)

			parent.TriggerEvent('ue_retrieve')
			
		end if

	else

		if dw_label.dataobject <> "d_klonelab_part_labels_nolock" then
			
			dw_label.dataobject = "d_klonelab_part_labels_nolock"
			
			dw_label.SetTransObject(SQLCA)

			SetPointer(Hourglass!)

			parent.TriggerEvent('ue_retrieve')
			
		end if
	
	
	end if


End choose
end event

type cb_save from commandbutton within w_klonelab_carton_label
integer x = 55
integer y = 2112
integer width = 402
integer height = 104
integer taborder = 40
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Save"
end type

event clicked;
dw_carton_require.Update()
end event

type dw_carton_require from datawindow within w_klonelab_carton_label
integer x = 14
integer y = 1596
integer width = 5147
integer height = 1144
integer taborder = 30
boolean bringtotop = true
string title = "none"
string dataobject = "d_klonelab_carton_labels_carton_req_nolock"
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

