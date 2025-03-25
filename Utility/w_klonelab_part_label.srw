HA$PBExportHeader$w_klonelab_part_label.srw
forward
global type w_klonelab_part_label from w_main_ancestor
end type
type cb_print from commandbutton within w_klonelab_part_label
end type
type cb_selectall from commandbutton within w_klonelab_part_label
end type
type cb_clear from commandbutton within w_klonelab_part_label
end type
type dw_label from u_dw_ancestor within w_klonelab_part_label
end type
type dw_label_select from datawindow within w_klonelab_part_label
end type
end forward

global type w_klonelab_part_label from w_main_ancestor
boolean visible = false
integer width = 2304
integer height = 2248
string title = "KloneLab Part Labels"
string menuname = ""
boolean center = true
event ue_print ( )
cb_print cb_print
cb_selectall cb_selectall
cb_clear cb_clear
dw_label dw_label
dw_label_select dw_label_select
end type
global w_klonelab_part_label w_klonelab_part_label

type variables
n_warehouse i_nwarehouse
n_labels	invo_labels
n_3com_labels	invo_3com_labels

String	isOrigSql 
long ido_no


end variables

event ue_print();Str_Parms	lstrparms
n_labels	lu_labels
string ls_uf5, ls_uf6, ls_PartInfo, lsTemp ,ls_ordtype

Long	llQty, llRowCount, llRowPos, ll_rtn, llPrintJob, llFindRow, llPrintPos, llPrintCount, ld_Qunatity , ld_Carton,llCar_no
		
Any	lsAny

String	lsformat, lsFormatSave, lsPrinter, lsLabel, lsLabelPrint, lsPrintText,  &
			lsCurrentLabel, lsLabelType, lsDateCode, lsKlone_sku_desc_color ,lsCountryName ,ls_city ,ls_dc_prefix
Integer	liMsg
datastore dw_labels

lu_labels = Create n_labels

Dw_Label.AcceptText()

dw_label_select.AcceptText()

lsLabelType = dw_label_select.GetITEmString(1,'label')

IF IsNull(lsLabelType) or Trim(lsLabelType) = '' then
		
	MessageBox ("Invalid label", "Please select a label type.")
		
	dw_label_select.SetFocus()	
		
	Return
		
End IF

llRowCount = dw_label.RowCount()


OpenWithParm(w_label_print_options,lStrParms)
Lstrparms = Message.PowerObjectParm		  
If lstrParms.Cancelled Then
	Return
End If
			
lsPrintText = 'KloneLab Part Labels '

//Open Printer File 
llPrintJob = PrintOpen(lsPrintText)

If llPrintJob <0 Then 
	Messagebox('Labels', 'Unable to open Printer file. Labels will not be printed')
	Return
End If


For llRowPos = 1 to llRowCount /*each detail row */
			
	If dw_label.GetITEmString(llRowPos,'c_print_ind') <> 'Y' Then Continue

	
	CHOOSE CASE trim(lsLabelType)

//Nxjain Start 
	CASE "BASS PRO SHOPS INC"
		lsformat = "Klonelab_bass_pro_shops_inc.txt"
		
		lsLabel = lu_labels.uf_read_label_Format(lsFormat)
		
		If lsLabel = "" Then Return
		
		lsCurrentLabel= lsLabel
		
		lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~Wh_add1~~", dw_label.GetITemString(llRowPos,'Addr1') ) //Ware house Add 1
		
		lsTemp = dw_label.GetITemString(llRowPos,'Addr2') 
		lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~wh_add2~~", dw_label.GetITemString(llRowPos,'Addr2') )//Wh_add2
		
		If isnull (lsTemp) or (lsTemp ='') then 
			lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~wh_add2~~" ,dw_label.GetITemString(llRowPos,'wh_zip') )   //Wh_Zip
		else 
			lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~wh_zip~~" ,dw_label.GetITemString(llRowPos,'wh_zip') )   //Wh_Zip
		end if 
	
		lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~Cust_name~~" ,dw_label.GetITemString(llRowPos,'Cust_name') )   //Cust_name 
		lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~Cust_add1~~", dw_label.GetITemString(llRowPos,'Cust_Addr1') ) //Ware house Add 1
		lsTemp = dw_label.GetITemString(llRowPos,'Cust_Addr2') 
		lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~Cust_add2~~", dw_label.GetITemString(llRowPos,'Cust_Addr2') )//Cust_Addr1
		
		If isnull (lsTemp) or (lsTemp ='') then 
			lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~Cust_add2~~" ,dw_label.GetITemString(llRowPos,'cust_zip') )   //Cust_Addr2
		else 
			lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~Cust_zip~~" ,dw_label.GetITemString(llRowPos,'cust_zip') )   //Cust_zip
		end if 
		
		lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~PO~~" ,dw_label.GetITemString(llRowPos,'cust_order_no') )   //Po_No
		lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~upc~~",dw_label.GetITemString(llRowPos,'Upc')) /* Upc*/
		lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~Cust_sku~~",dw_label.GetITemString(llRowPos,'sku')) /* Cust_sku*/		
		ld_Qunatity = dw_label.GetITemNumber(llRowPos,'delivery_detail_qty')
		
		ls_PartInfo =  String( ld_Qunatity)
		lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~Qunatity~~",ls_PartInfo)
		
		lsCountryName = f_get_country_Name( dw_label.GetITemString(llRowPos,'country_of_Origin'))
		lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~COO~~",lsCountryName)
		ld_Carton =dw_label.GetITemNumber(llRowPos,'Total_Cartons')
		
		lstemp =  String( ld_Carton)
		lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~Carton_id~~",lstemp)
		

	
	CASE "FRED MEYER INC"
		
			lsformat = "Klonelab_fred_meyer.txt"
	
			lsLabel = lu_labels.uf_read_label_Format(lsFormat)
			
			If lsLabel = "" Then Return
		
			lsCurrentLabel= lsLabel
		
			
			lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~Cust_Name~~" ,dw_label.GetITemString(llRowPos,'Cust_name') )   //Cust_name 
			
			lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~Cust_Add1~~", dw_label.GetITemString(llRowPos,'Cust_Addr1') ) //Ware house Add 1
				
			lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~Cust_Add2~~", dw_label.GetITemString(llRowPos,'Cust_Addr2') )//Cust_Addr1

			lsTemp = dw_label.GetITemString(llRowPos,'Cust_Addr3') 
			
			lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~Cust_Add3~~", dw_label.GetITemString(llRowPos,'Cust_Addr3') )//Cust_Addr1
			
			If isnull (lsTemp) or (lsTemp ='') then 
				lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~Cust_Add3~~" ,dw_label.GetITemString(llRowPos,'cust_zip') )   //Cust_Addr2
			else 
				lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~Cust_zip~~" ,dw_label.GetITemString(llRowPos,'cust_zip') )   //Cust_zip
			end if 
			
			lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~PO~~" ,dw_label.GetITemString(llRowPos,'cust_order_no') )   //Po_No
			
  	 			
		lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~Cust_sku~~",dw_label.GetITemString(llRowPos,'sku')) /* Cust_sku*/		
			
	
		lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~size~~",dw_label.GetITemString(llRowPos,'Size')) /* Size*/
		
		
			ld_Qunatity = dw_label.GetITemNumber(llRowPos,'delivery_detail_qty')
	
			ls_PartInfo =  String( ld_Qunatity)
				
			lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~Qunatity~~",ls_PartInfo)
			
			 ld_Carton =dw_label.GetITemNumber(llRowPos,'Total_Cartons')
			 
		 	lstemp =  String( ld_Carton)
					
			lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~Carton_id~~",lstemp)
		
		
	
		CASE "GRAND RAPIDS DISTRIBUTION"
		
			lsformat = "Klonelab_grand_rapids.txt"
	
			lsLabel = lu_labels.uf_read_label_Format(lsFormat)
			
			If lsLabel = "" Then Return
		
			lsCurrentLabel= lsLabel
		
			
			lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~wh_add1~~", dw_label.GetITemString(llRowPos,'Addr1') ) //Ware house Add 1
		
			lsTemp = dw_label.GetITemString(llRowPos,'Addr2') 
			lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~wh_add2~~", dw_label.GetITemString(llRowPos,'Addr2') )//Wh_add2
			
			If isnull (lsTemp) or (lsTemp ='') then 
				lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~wh_add2~~" ,dw_label.GetITemString(llRowPos,'wh_zip') )   //Wh_Zip
			else 
				lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~wh_zip~~" ,dw_label.GetITemString(llRowPos,'wh_zip') )   //Wh_Zip
			end if 
			
	
			lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~Cust_name~~" ,dw_label.GetITemString(llRowPos,'Cust_name') )   //Cust_name 
			
			lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~Cust_add1~~", dw_label.GetITemString(llRowPos,'Cust_Addr1') ) //Ware house Add 1
		
			lsTemp = dw_label.GetITemString(llRowPos,'Cust_Addr2') 
			lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~Cust_add2~~", dw_label.GetITemString(llRowPos,'Cust_Addr2') )//Cust_Addr1
			
			If isnull (lsTemp) or (lsTemp ='') then 
				lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~Cust_add2~~" ,dw_label.GetITemString(llRowPos,'cust_zip') )   //Cust_Addr2
			else 
				lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~Cust_zip~~" ,dw_label.GetITemString(llRowPos,'cust_zip') )   //Cust_zip
			end if 
			
			lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~PO~~" ,dw_label.GetITemString(llRowPos,'cust_order_no') )   //Po_No
		
	 		lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~UPC~~",dw_label.GetITemString(llRowPos,'Upc')) /* Upc*/
		
		lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~Size~~",dw_label.GetITemString(llRowPos,'Size')) /* Size*/
	
	dec  ls_length ,ls_weight,ls_height ,ls_gross ,ls_Weight_Gross
		
		ls_length =dw_label.GetITemnumber(llRowPos,'length') /* length*/
		ls_weight=dw_label.GetITemnumber(llRowPos,'Width') /* weight */
		ls_height=dw_label.GetITemnumber(llRowPos,'height') /* height*/
		ls_Weight_Gross=dw_label.GetITemnumber(llRowPos,'Weight_Gross') 
		
		lstemp = String(ls_length) +'X' +String (ls_weight) +'X'+string (ls_height)
	
		lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~Lenght~~",lstemp)
		
		lstemp = string (ls_Weight_Gross)
	
		lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~gross~~",lstemp)
	
	
	
	
	CASE "Innotrac Nevada"
		
			lsformat = "Klonelab_innotrac_nevada.txt"
	
			lsLabel = lu_labels.uf_read_label_Format(lsFormat)
			
			If lsLabel = "" Then Return
		
			lsCurrentLabel= lsLabel
		
			
			lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~Cust_name~~" ,dw_label.GetITemString(llRowPos,'Cust_name') )   //Cust_name 
			
			lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~Cust_add1~~", dw_label.GetITemString(llRowPos,'Cust_Addr1') ) //Ware house Add 1
				
			lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~Cust_add2~~", dw_label.GetITemString(llRowPos,'Cust_Addr2') )//Cust_Addr1

			lsTemp = dw_label.GetITemString(llRowPos,'Cust_Addr3') 
			
			lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~Cust_add3~~", dw_label.GetITemString(llRowPos,'Cust_Addr3') )//Cust_Addr1
			
			If isnull (lsTemp) or (lsTemp ='') then 
				lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~Cust_add3~~" ,dw_label.GetITemString(llRowPos,'cust_zip') )   //Cust_Addr2
			else 
				lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~Cust_zip~~" ,dw_label.GetITemString(llRowPos,'cust_zip') )   //Cust_zip
			end if 
			
			lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~PO~~" ,dw_label.GetITemString(llRowPos,'cust_order_no') )   //Po_No
			
  	 			
		lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~Cust_sku~~",dw_label.GetITemString(llRowPos,'sku')) /* Cust_sku*/		
		
		lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~Size~~",dw_label.GetITemString(llRowPos,'Size')) /* Size*/

		lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~SKU_DES~~",dw_label.GetITemString(llRowPos,'Description')) /* Description*/
		
		lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~Color~~",dw_label.GetITemString(llRowPos,'Color')) /* Color*/

		lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~upc~~",dw_label.GetITemString(llRowPos,'Upc')) /* Upc*/
		
		lsCountryName = f_get_country_Name( dw_label.GetITemString(llRowPos,'country_of_Origin'))
	
		lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~COO~~",lsCountryName)
			
			
		ld_Qunatity = dw_label.GetITemNumber(llRowPos,'delivery_detail_qty')
	
		ls_PartInfo =  String( ld_Qunatity)
		
		lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~Qty~~",ls_PartInfo)
			
		 ld_Carton =dw_label.GetITemNumber(llRowPos,'Total_Cartons')
		 
		lstemp =  String( ld_Carton)
				
		lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~Carton_id~~",lstemp)
		
	
	
	CASE "MARSHALLS -Atlanta DC"
		
			lsformat = "Klonelab_Marshalls_atlanta_dc.txt"
	
			lsLabel = lu_labels.uf_read_label_Format(lsFormat)
			
			If lsLabel = "" Then Return
		
			lsCurrentLabel= lsLabel
		
			
			lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~Cust_name~~" ,dw_label.GetITemString(llRowPos,'Cust_name') )   //Cust_name 
			
			lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~Cust_add1~~", dw_label.GetITemString(llRowPos,'Cust_Addr1') ) //Ware house Add 1
				
			lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~Cust_add2~~", dw_label.GetITemString(llRowPos,'Cust_Addr2') )//Cust_Addr1

			lsTemp = dw_label.GetITemString(llRowPos,'Cust_Addr3') 
			
			lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~Cust_add3~~", dw_label.GetITemString(llRowPos,'Cust_Addr3') )//Cust_Addr1
			
			If isnull (lsTemp) or (lsTemp ='') then 
				lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~Cust_add3~~" ,dw_label.GetITemString(llRowPos,'cust_zip') )   //Cust_Addr2
			else 
				lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~Cust_zip~~" ,dw_label.GetITemString(llRowPos,'cust_zip') )   //Cust_zip
			end if 
			
			lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~PO~~" ,dw_label.GetITemString(llRowPos,'cust_order_no') )   //Po_No
			
  	 			
			lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~Cust_sku~~",dw_label.GetITemString(llRowPos,'sku')) /* Cust_sku*/		
			
			lsCountryName = f_get_country_Name( dw_label.GetITemString(llRowPos,'country_of_Origin'))
		
			lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~COO~~",lsCountryName)
			
			lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~department~~",dw_label.GetITemString(llRowPos,'Dept')) /* Dept*/
			
			lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~Size~~",dw_label.GetITemString(llRowPos,'Size')) /* Size*/
			
			
			lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~vendor_style~~",dw_label.GetITemString(llRowPos,'Vendor_style')) /* Vendor_style*/
			
			lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~Color~~",dw_label.GetITemString(llRowPos,'Color')) /* Color*/
			
			
		ld_Qunatity = dw_label.GetITemNumber(llRowPos,'delivery_detail_qty')
	
		ls_PartInfo =  String( ld_Qunatity)
		
		lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~Qunatity~~",ls_PartInfo)
			
		 ld_Carton =dw_label.GetITemNumber(llRowPos,'Total_Cartons')
		 
		lstemp =  String( ld_Carton)
				
		lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~Carton_id~~",lstemp)

		ls_city = dw_label.GetITemstring(llRowPos,'city')			
		
		If (ls_city= 'North Las Vegas')  or (ls_city ='NORTH LAS VEGAS') then
		ls_dc_prefix = '01'
	elseif (ls_city= 'Atlanta')  or (ls_city ='ATLANTA')then
		ls_dc_prefix = '07'			
	elseif (ls_city= 'Bridgewater')  or (ls_city ='BRIDGEWATER') then
		ls_dc_prefix = '06'
	elseif (ls_city= 'Woburn')  or (ls_city ='WOBURN') then
		ls_dc_prefix = '08'
	elseif (ls_city= 'Worcester')  or (ls_city ='WORCESTER') then
		ls_dc_prefix = '60'
	elseif (ls_city= 'Evansville')  or (ls_city ='EVANSVILLE') then
		ls_dc_prefix = '70'
	elseif (ls_city= 'Charlotte ')  or (ls_city ='CHARLOTTE') then
		ls_dc_prefix = '40'
	else 
		ls_dc_prefix = ''
	end if 
	
		lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~DC_perfix~~",ls_dc_prefix)

CASE "Shoe Show, Inc-Musical"			
	
	ls_ordtype = dw_label.GetITemString(llRowPos,'ord_type')
	
	if (ls_ordtype ='M') then 
	
		lsformat = "Klonelab_shoe_show_musical.txt"
		lsLabel = lu_labels.uf_read_label_Format(lsFormat)
		
		If lsLabel = "" Then Return
		
		lsCurrentLabel= lsLabel
		
		lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~Cust_name~~" ,dw_label.GetITemString(llRowPos,'Cust_name') )   //Cust_name 
		lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~Cust_add1~~", dw_label.GetITemString(llRowPos,'Cust_Addr1') ) //Ware house Add 1
		lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~Cust_add2~~", dw_label.GetITemString(llRowPos,'Cust_Addr2') )//Cust_Addr1
		lsTemp = dw_label.GetITemString(llRowPos,'Cust_Addr2') 
		
		
		If isnull (lsTemp) or (lsTemp ='') then 
			lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~Cust_add2~~" ,dw_label.GetITemString(llRowPos,'cust_zip') )   //Cust_Addr2
		else 
			lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~Cust_zip~~" ,dw_label.GetITemString(llRowPos,'cust_zip') )   //Cust_zip
		end if 
		
		lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~PO~~" ,dw_label.GetITemString(llRowPos,'cust_order_no') )   //Po_No
		
		//lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~Cust_sku~~",dw_label.GetITemString(llRowPos,'sku')) /* Cust_sku*/			

String ls_sku ,ls_temp ,ls_size
int ll_len,ll_len1 ,llRow


		ls_sku = dw_label.GetITemString(llRowPos,'sku')
		ls_size =dw_label.GetITemString(llRowPos,'Size')
		
		ll_len	 = len(ls_sku)  
		ll_len1 = len(ls_size)
		
		ls_temp = mid (ls_sku , 1 , (ll_len - (ll_len1 +1)))

		lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~Cust_sku~~",ls_temp)/* Cust_sku*/			
		
	
	For 	llRow = 1 to llRowCount

		if llRow =1 then
				lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~S1~~",dw_label.GetITemString(llRow,'Size')) /* Size*/
		
		ld_Qunatity = dw_label.GetITemNumber(llRow,'delivery_detail_qty')
		ls_PartInfo =  String( ld_Qunatity)
		lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~Q1~~",ls_PartInfo)
			
		elseif llRow =2 then
			lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~S2~~",dw_label.GetITemString(llRow,'Size')) /* Size*/
			
			
		ld_Qunatity = dw_label.GetITemNumber(llRow,'delivery_detail_qty')
		ls_PartInfo =  String( ld_Qunatity)
		lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~Q2~~",ls_PartInfo)
			
		elseif llRow =3 then
			lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~S3~~",dw_label.GetITemString(llRow,'Size')) /* Size*/
			
			
		ld_Qunatity = dw_label.GetITemNumber(llRow,'delivery_detail_qty')
		ls_PartInfo =  String( ld_Qunatity)
		lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~Q3~~",ls_PartInfo)
			
		elseif llRow =4 then
			lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~S4~~",dw_label.GetITemString(llRow,'Size')) /* Size*/
			
			
		ld_Qunatity = dw_label.GetITemNumber(llRow,'delivery_detail_qty')
		ls_PartInfo =  String( ld_Qunatity)
		lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~Q4~~",ls_PartInfo)
			
		elseif llRow =5 then
			lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~S5~~",dw_label.GetITemString(llRow,'Size')) /* Size*/
			
			
		ld_Qunatity = dw_label.GetITemNumber(llRow,'delivery_detail_qty')
		ls_PartInfo =  String( ld_Qunatity)
		lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~Q5~~",ls_PartInfo)
			
		elseif llRow =6 then
			lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~S6~~",dw_label.GetITemString(llRow,'Size')) /* Size*/
			
		ld_Qunatity = dw_label.GetITemNumber(llRow,'delivery_detail_qty')
		ls_PartInfo =  String( ld_Qunatity)
		lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~Q6~~",ls_PartInfo)
			
		elseif llRow =7 then
			lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~S7~~",dw_label.GetITemString(llRow,'Size')) /* Size*/
			
			
		ld_Qunatity = dw_label.GetITemNumber(llRow,'delivery_detail_qty')
		ls_PartInfo =  String( ld_Qunatity)
		lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~Q7~~",ls_PartInfo)
			
		elseif llRow =8 then
			lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~S8~~",dw_label.GetITemString(llRow,'Size')) /* Size*/
			
		ld_Qunatity = dw_label.GetITemNumber(llRow,'delivery_detail_qty')
		ls_PartInfo =  String( ld_Qunatity)
		lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~Q8~~",ls_PartInfo)	
		
		End if 

next 
	
		ld_Qunatity = dw_label.GetITemNumber(llRowPos,'delivery_detail_qty')
		
		ls_PartInfo =  String( ld_Qunatity)
		
		lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~Qunatity~~",ls_PartInfo)
		
		
		ld_Carton =dw_label.GetITemNumber(llRowPos,'Total_Cartons')
		
		lstemp =  String( ld_Carton)
		
		lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~Carton_id~~",lstemp)
		
		ls_weight=dw_label.GetITemnumber(1,'Width') /* width */

		lstemp = string (ls_weight)

		lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~Width~~",lstemp)
		
		int i  ,j=1
		llCar_no = dw_label.GetITemNUmber(llRowPos,'no_of_copies')
		
		For i = 1 to llCar_no
		
		lstemp = string (j)

		lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~T1~~",lstemp)
		
		j++
		
	next 

			
	else 
		MessageBox (title , "Please check the order type and try with musical order type ")
		
	End if 



//End  2014-29-05  nxjain 


CASE "Shoe Show, Inc"
		
			lsformat = "Klonelab_shoe_show.txt"
	
			lsLabel = lu_labels.uf_read_label_Format(lsFormat)
			
			If lsLabel = "" Then Return
		
			lsCurrentLabel= lsLabel
		
			
			lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~Cust_name~~" ,dw_label.GetITemString(llRowPos,'Cust_name') )   //Cust_name 
			
			lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~Cust_add1~~", dw_label.GetITemString(llRowPos,'Cust_Addr1') ) //Ware house Add 1
				
			lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~Cust_add2~~", dw_label.GetITemString(llRowPos,'Cust_Addr2') )//Cust_Addr1

			lsTemp = dw_label.GetITemString(llRowPos,'Cust_Addr2') 
			
			If isnull (lsTemp) or (lsTemp ='') then 
				lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~Cust_add2~~" ,dw_label.GetITemString(llRowPos,'cust_zip') )   //Cust_Addr2
			else 
				lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~Cust_zip~~" ,dw_label.GetITemString(llRowPos,'cust_zip') )   //Cust_zip
			end if 
			
			lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~PO~~" ,dw_label.GetITemString(llRowPos,'cust_order_no') )   //Po_No
			
  	 			
			lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~Cust_sku~~",dw_label.GetITemString(llRowPos,'sku')) /* Cust_sku*/			
	
			lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~Size~~",dw_label.GetITemString(llRowPos,'Size')) /* Size*/
			
			
		ld_Qunatity = dw_label.GetITemNumber(llRowPos,'delivery_detail_qty')
	
		ls_PartInfo =  String( ld_Qunatity)
		
		lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~Qunatity~~",ls_PartInfo)
			
		 ld_Carton =dw_label.GetITemNumber(llRowPos,'Total_Cartons')
		 
		lstemp =  String( ld_Carton)
				
		lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~Carton_id~~",lstemp)
		
		lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~Width~~",lstemp)
		
	
	//NXjain	 End 
	
	//Start 2014-03-03  nxjain 
		CASE "Zullily Vendor"
		
			lsformat = "klonelab_zulily_vendor.txt"
	
		
			lsLabel = lu_labels.uf_read_label_Format(lsFormat)
			
			If lsLabel = "" Then Return
		
			lsCurrentLabel= lsLabel
		
			lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~to_addr1~~", dw_label.GetITemString(llRowPos,'cust_name') ) //Cust name

			lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~to_addr2~~", dw_label.GetITemString(llRowPos,'Cust_Addr1') ) //Cust Add1 
			lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~to_addr3~~", dw_label.GetITemString(llRowPos,'cust_Addr2') ) //Cust Add 2
			lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~to_addr4~~", dw_label.GetITemString(llRowPos,'cust_zip') ) //Cust Zip

			lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~po_nbr~~", dw_label.GetITemString(llRowPos,'PO') ) //PO
			lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~Carrier_load~~", dw_label.GetITemString(llRowPos,'Carrier_load') ) //Carrier load
			

		ld_Qunatity = dw_label.GetITemNumber(llRowPos,'delivery_detail_qty')
			
		ls_PartInfo =  String( ld_Qunatity)
		
		lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~Qty~~",ls_PartInfo)
			
		 ld_Carton =dw_label.GetITemNumber(llRowPos,'Total_Cartons')
		 
		lstemp =  String( ld_Carton)
				
		lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~no_of_cart~~",lstemp)
	



CASE "KARMALOOP, INC"
		
			lsformat = "klonelab_karmaloop_inc.txt"
	
		
			lsLabel = lu_labels.uf_read_label_Format(lsFormat)
			
			If lsLabel = "" Then Return
		
			lsCurrentLabel= lsLabel

			lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~po_nbr~~", dw_label.GetITemString(llRowPos,'PO') ) //PO
			lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~Size~~",dw_label.GetITemString(llRowPos,'Size')) /* Size*/
			lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~Style~~",dw_label.GetITemString(llRowPos,'Color')) /* Color*/
				

		ld_Qunatity = dw_label.GetITemNumber(llRowPos,'delivery_detail_qty')
			
		ls_PartInfo =  String( ld_Qunatity)
		
		lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~Qty~~",ls_PartInfo)
			
		 ld_Carton =dw_label.GetITemNumber(llRowPos,'Total_Cartons')
		 
		lstemp =  String( ld_Carton)
				
		lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~no_of_cart~~",lstemp)
	
	//NXjain End :-2014-05-03 


		CASE "CCS-Direct"
		
			lsformat = "Klone_CCS_Direct_Zebra.txt"
		
			lsLabel = lu_labels.uf_read_label_Format(lsFormat)
			
			If lsLabel = "" Then Return
		
			lsCurrentLabel= lsLabel
		
			lsKlone_sku_desc_color = dw_label.GetITemString(llRowPos,'Klone_sku_desc_color')
		
			lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~cust_sku~~",dw_label.GetITemString(llRowPos,'Cust_sku')) /* Cust_sku*/		
			lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~klone_sku_desc_color~~", left(lsKlone_sku_desc_color,40)) 
			lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~klone_sku_desc_color2~~", mid(lsKlone_sku_desc_color,41))    //dw_label.GetITemString(llRowPos,'Klone_sku_desc_color')) /* Klone_sku_desc_color*/
			lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~cust_size~~",dw_label.GetITemString(llRowPos,'Cust_Size')) /* Cust_Size*/
			lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~cust_sku_size~~",dw_label.GetITemString(llRowPos,'Cust_sku_size')) /* Cust_sku_size*/
	
			
			lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~cust_sku_size_barcode~~",dw_label.GetITemString(llRowPos,'Cust_sku_size')) /* Barcoded Cust_sku_size*/

		CASE "CCS-Retail"

			lsformat = "Klone_CCS_retail_Zebra.txt"
		
			lsLabel = lu_labels.uf_read_label_Format(lsFormat)
			
			If lsLabel = "" Then Return
		
			lsCurrentLabel= lsLabel
		
			lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~cust_sku~~",dw_label.GetITemString(llRowPos,'Cust_sku')) /* Cust_sku*/		
			lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~cust_size~~",dw_label.GetITemString(llRowPos,'Cust_Size')) /* Cust_Size*/
			
			lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~desc1~~",dw_label.GetITemString(llRowPos,'Desc1')) /* Desc1*/
			lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~desc2~~",dw_label.GetITemString(llRowPos,'Desc2')) /* Desc2*/
	
			lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~upc~~",dw_label.GetITemString(llRowPos,'Upc')) /* Upc*/

			lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~price~~", String(dw_label.GetITemNumber(llRowPos,'Price'), "$ 0.00")) /* Price*/
		
	CASE "Famous Footwear"

			lsformat = "Klone_famous_footwear_Zebra.txt"
		
			lsLabel = lu_labels.uf_read_label_Format(lsFormat)
			
			If lsLabel = "" Then Return
		
			lsCurrentLabel= lsLabel
		
			lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~Price~~", String(dw_label.GetITemNumber(llRowPos,'Price'), "$ 0.00")) /* Price*/
		
		
		CASE "Stage Stores"

			lsformat = "Klone_Stage_Zebra.txt"
		
			lsLabel = lu_labels.uf_read_label_Format(lsFormat)
			
			If lsLabel = "" Then Return
		
			lsCurrentLabel= lsLabel
			
			lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~Price~~", String(dw_label.GetITemNumber(llRowPos,'price'), "$ 0.00")) /* price*/
			
		
			lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~dept~~",dw_label.GetITemString(llRowPos,'Dept')) /* Dept*/
			
			lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~class~~",dw_label.GetITemString(llRowPos,'Class')) /* Class*/


		CASE "Sportsman$$HEX1$$1920$$ENDHEX$$s Guide"

			lsformat = "Klone_sportsman_Zebra.txt"
		
			lsLabel = lu_labels.uf_read_label_Format(lsFormat)
			
			If lsLabel = "" Then Return
		
			lsCurrentLabel= lsLabel
				
			lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~description~~",dw_label.GetITemString(llRowPos,'Description')) /* Description*/
			
			lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~sku~~",dw_label.GetITemString(llRowPos,'Cust_sku')) /* Cust_sku*/


		CASE "BlueStem"

			lsformat = "Klone_Bluestem_Zebra.txt"
		
			lsLabel = lu_labels.uf_read_label_Format(lsFormat)
			
			If lsLabel = "" Then Return
		
			lsCurrentLabel= lsLabel
			
			lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~cust_sku~~",dw_label.GetITemString(llRowPos,'Cust_sku')) /* Cust_sku*/


		CASE "Bob$$HEX1$$1920$$ENDHEX$$s Stores"

			lsformat = "Klone_bobs_Zebra.txt"
		
			lsLabel = lu_labels.uf_read_label_Format(lsFormat)
			
			If lsLabel = "" Then Return
		
			lsCurrentLabel= lsLabel
		
//			lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~department~~",dw_label.GetITemString(llRowPos,'dept')) /* dept*/		 Item master 

			lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~department~~",dw_label.GetITemString(llRowPos,'style')) /* dept*/		 
			lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~season~~",dw_label.GetITemString(llRowPos,'Season')) /* Season*/
			
			lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~vendor_style~~",dw_label.GetITemString(llRowPos,'Vendor_style')) /* Vendor_style*/
			lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~color~~",dw_label.GetITemString(llRowPos,'Color')) /* Color*/
	
			lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~upc~~",dw_label.GetITemString(llRowPos,'Upc')) /* Upc*/

			lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~size~~",dw_label.GetITemString(llRowPos,'Size')) /* Size*/

			lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~price~~", String(dw_label.GetITemNumber(llRowPos,'Price'), "$ 0.00")) /* Price*/

			lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~shoebox_nbr~~",dw_label.GetITemString(llRowPos,'Shoebox_nbr')) /* Shoebox_nbr*/

		CASE "Fred Meyer"

			lsformat = "Klone_fredmeyer_Zebra.txt"
		
			lsLabel = lu_labels.uf_read_label_Format(lsFormat)
			
			If lsLabel = "" Then Return
		
			lsCurrentLabel= lsLabel
			
			lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~cust_sku~~",dw_label.GetITemString(llRowPos,'Cust_sku')) /* Cust_sku*/
	
			lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~price~~", String(dw_label.GetITemNumber(llRowPos,'Price'), "$ 0.00")) /* Price*/	
	
	

	CASE "Mason Shoe Company"

			lsformat = "Klone_mason_Zebra.txt"
		
			lsLabel = lu_labels.uf_read_label_Format(lsFormat)
			
			If lsLabel = "" Then Return
		
			lsCurrentLabel= lsLabel
			
			lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~cust_sku~~",dw_label.GetITemString(llRowPos,'Cust_sku')) /* Cust_sku*/
			
			lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~klone_color~~",dw_label.GetITemString(llRowPos,'Color')) /* Color*/			
	
			lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~klone_size~~",dw_label.GetITemString(llRowPos,'Size')) /* Size*/
			
			lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~upc~~",dw_label.GetITemString(llRowPos,'Upc')) /* Upc*/			


	CASE "Genesco"

			lsformat = "Klone_genesco_Zebra.txt"
		
			lsLabel = lu_labels.uf_read_label_Format(lsFormat)
			
			If lsLabel = "" Then Return
		
			lsCurrentLabel= lsLabel
			
			lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~cust_sku~~",dw_label.GetITemString(llRowPos,'Cust_sku')) /* Cust_sku*/



	CASE "Sears Canada"

			lsformat = "Klone_sears_can_Zebra.txt"
		
			lsLabel = lu_labels.uf_read_label_Format(lsFormat)
			
			If lsLabel = "" Then Return
		
			lsCurrentLabel= lsLabel
			
			ls_uf5 = dw_label.GetITemString(llRowPos,'user_field5')
			
			if IsNull(ls_uf5) then ls_uf5 = ""
			
			
			ls_uf6 = dw_label.GetITemString(llRowPos,'user_field6')
			
			if IsNull(ls_uf6) then ls_uf6 = ""
			

			//Part_info -> DD.UF6 + <space> + DD.UF5 + <space> + Delivery_Packing.Quantity
			
			ld_Qunatity = dw_label.GetITemNumber(llRowPos,'delivery_packing_quantity')
			
			If IsNull(ld_Qunatity) then ld_Qunatity = 0
			
			
			ls_PartInfo = ls_uf6 + " "  + ls_uf5 + " " + String( ld_Qunatity)
			
			
			lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~part_info~~", ls_PartInfo) /* Cust_sku*/

		
	CASE "Shoe Carnival"
		
		lsformat =  "Klone_Shoe_Carnival_Zebra.txt"

		lsLabel = lu_labels.uf_read_label_Format(lsFormat)
			
		If lsLabel = "" Then Return
		
		lsCurrentLabel= lsLabel
			
		lsDateCode = 	String(Month(RelativeDate ( today(), 7 )), "00") + Right(String( Year(RelativeDate ( today(), 7 )), "0"),1)
			
			
		lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~date_code1~~", left(lsDateCode,1)) /* Date Code*/
		lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~date_code2~~", mid(lsDateCode,2,1)) /* Date Code*/
		lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~date_code3~~", right(lsDateCode,1)) /* Date Code*/
	
		lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~price~~", String(dw_label.GetITemNumber(llRowPos,'Price'), "$###.##")) /* Price*/	

		lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~color~~", left(dw_label.GetITemString(llRowPos,'Color'),14)) /* Color*/
		
		lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~style~~", left(dw_label.GetITemString(llRowPos,'Description'),14)) /* Color2*/

//		lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~style~~",dw_label.GetITemString(llRowPos,'style')) /* Color*/
	
		string lsUpc
	
		lsUpc = dw_label.GetITemString(llRowPos,'Upc')
		
		lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~upc~~", lsUpc) /* Upc*/
		
		lsUpc = left(lsUpc, 6) + "         " +  mid(lsUpc, 7)
		
		lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~upc_text~~", lsUpc) /* Upc*/
		

		lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~size~~",dw_label.GetITemString(llRowPos,'Size')) /* Size*/

	
	CASE "JCPenney"	


			lsformat = "Klone_JCPenney_Zebra.txt"
		
			lsLabel = lu_labels.uf_read_label_Format(lsFormat)
			
			If lsLabel = "" Then Return
		
			lsCurrentLabel= lsLabel
			
			lsTemp = String(dw_label.GetITemNumber(llRowPos,'Price'), "$0")
			
			Choose case len(lsTemp)
				Case 1
					lsTemp = "  " + lsTemp
				Case 2
					lsTemp =  " " + lsTemp

			End Choose
			
			
			lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~price~~", lsTemp) /* Price*/




	END CHOOSE
	
	
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

on w_klonelab_part_label.create
int iCurrent
call super::create
this.cb_print=create cb_print
this.cb_selectall=create cb_selectall
this.cb_clear=create cb_clear
this.dw_label=create dw_label
this.dw_label_select=create dw_label_select
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_print
this.Control[iCurrent+2]=this.cb_selectall
this.Control[iCurrent+3]=this.cb_clear
this.Control[iCurrent+4]=this.dw_label
this.Control[iCurrent+5]=this.dw_label_select
end on

on w_klonelab_part_label.destroy
call super::destroy
destroy(this.cb_print)
destroy(this.cb_selectall)
destroy(this.cb_clear)
destroy(this.dw_label)
destroy(this.dw_label_select)
end on

event ue_postopen;call super::ue_postopen;
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

String lsLabel,lsCustCode

lsCustCode = trim(w_do.idw_main.GetItemString( 1, "cust_code"))

//Choose case Customer Code for Automatic Label selection.

CHOOSE CASE lsCustCode
	
	CASE '133209'		//Bluestem	133209 
		lsLabel = "BlueStem"
	
	CASE '115653'		//Bob's Stores	115653
		lsLabel = "Bob$$HEX1$$1920$$ENDHEX$$s Stores"

	CASE '117105'		//CCS Direct	117105
		lsLabel = "CCS-Direct"

	CASE '111676', '112083'			//CCS Retail	111676    	//Eastbay	112083 (Same as CCS-Retail)
		lsLabel = "CCS-Retail"

	CASE '0263141'		//Famous Footwear	0263141
		lsLabel =  "Famous Footwear"
	

	CASE '8254'		//Fred Meyer INC	8254  
		lsLabel =  "Fred Meyer"
	
	CASE '111511'		//Genesco/Journey's	111511
		lsLabel = "Genesco"

	CASE '258219'		//Mason Shoe Company	258219
		lsLabel = "Mason Shoe Company"		
	
	CASE '1000009'		//Sears Canada	1000009
		lsLabel = "Sears Canada"
	
	CASE '112409'		//Shoe Carnival	112409
		lsLabel = "Shoe Carnival"	
	
	CASE '120220'		//Sportsman's Guide	120220
		lsLabel =  "Sportsman$$HEX1$$1920$$ENDHEX$$s Guide"		
	

	CASE '331101', '550426'		//Stage Stores, Inc	331101 //Stage Stores, Inc - Peebles	550426
		lsLabel = "Stage Stores"	



END CHOOSE

dw_label_select.SetItem(1,'label', lsLabel)


	
	

		



end event

event ue_retrieve;call super::ue_retrieve;
String ls_custname

If not isvalid(w_do) Then Return
If w_do.idw_main.RowCount() < 1 then return

ido_no =dw_label.Retrieve(w_do.idw_main.GetITemString(1,'do_no'))

ls_custname =w_do.idw_main.GetITemString(1,'cust_name')

//CHOOSE CASE trim(ls_custname)
//
//	CASE "BASS PRO SHOPS INC"
//	
//	dw_label_select.GetITEmString(1,'BASS PRO SHOPS INC')
//	dw_label_select.AcceptText()
//		
////	dw_label_select.='BASS PRO SHOPS (4 X6)'
//		
//	END CHOOSE
		




//o	Select (checkbox)
//o	No of Copies (Default to line item Qty)
//o	Line Item
//o	SKU
//-	Dropdown to select label format to print (I don$$HEX1$$1920$$ENDHEX$$t believe we will have a customer master or Order field to get the format from $$HEX2$$13202000$$ENDHEX$$they will need to manually choose )
//



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

event resize;call super::resize;dw_label.Resize(workspacewidth() - 50,workspaceHeight()-150)
end event

event close;call super::close;IF ISVALID(i_nwarehouse) THEN Destroy(i_nwarehouse)
end event

type cb_cancel from w_main_ancestor`cb_cancel within w_klonelab_part_label
boolean visible = false
integer x = 1938
integer y = 1392
integer height = 80
end type

type cb_ok from w_main_ancestor`cb_ok within w_klonelab_part_label
integer x = 1632
integer y = 32
integer height = 80
integer textsize = -9
boolean default = false
end type

type cb_print from commandbutton within w_klonelab_part_label
integer x = 946
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

type cb_selectall from commandbutton within w_klonelab_part_label
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

type cb_clear from commandbutton within w_klonelab_part_label
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

type dw_label from u_dw_ancestor within w_klonelab_part_label
integer x = 18
integer y = 292
integer width = 2213
integer height = 1820
string dataobject = "d_klonelab_part_labels_nolock"
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

type dw_label_select from datawindow within w_klonelab_part_label
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

