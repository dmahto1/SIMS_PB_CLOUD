$PBExportHeader$w_pandora_part_label_print.srw
forward
global type w_pandora_part_label_print from w_main_ancestor
end type
type cb_print from commandbutton within w_pandora_part_label_print
end type
type cb_selectall from commandbutton within w_pandora_part_label_print
end type
type cb_clear from commandbutton within w_pandora_part_label_print
end type
type cbx_show_comp from checkbox within w_pandora_part_label_print
end type
type cbx_part_label from checkbox within w_pandora_part_label_print
end type
type cbx_2d_barcode from checkbox within w_pandora_part_label_print
end type
type gb_1 from groupbox within w_pandora_part_label_print
end type
type dw_label from u_dw_ancestor within w_pandora_part_label_print
end type
type rb_200 from radiobutton within w_pandora_part_label_print
end type
type rb_300 from radiobutton within w_pandora_part_label_print
end type
type cbx_delta_label from checkbox within w_pandora_part_label_print
end type
type cbx_pallet_label from checkbox within w_pandora_part_label_print
end type
type cbx_carton_label from checkbox within w_pandora_part_label_print
end type
type cbx_nested_label from checkbox within w_pandora_part_label_print
end type
type gb_2d_barcode from groupbox within w_pandora_part_label_print
end type
end forward

global type w_pandora_part_label_print from w_main_ancestor
boolean visible = false
integer width = 4832
integer height = 1940
string title = "Pandora Part Labels"
string menuname = ""
event ue_print ( )
event ue_print_part_label ( )
event ue_print_2d_barcode ( )
event ue_print_inventory_part_label ( )
event ue_print_inventory_delta_label ( )
event ue_print_2d_pallet_label ( )
event ue_print_2d_carton_label ( )
event ue_print_2d_pallet_carton_label ( )
event ue_print_part_child_label ( )
cb_print cb_print
cb_selectall cb_selectall
cb_clear cb_clear
cbx_show_comp cbx_show_comp
cbx_part_label cbx_part_label
cbx_2d_barcode cbx_2d_barcode
gb_1 gb_1
dw_label dw_label
rb_200 rb_200
rb_300 rb_300
cbx_delta_label cbx_delta_label
cbx_pallet_label cbx_pallet_label
cbx_carton_label cbx_carton_label
cbx_nested_label cbx_nested_label
gb_2d_barcode gb_2d_barcode
end type
global w_pandora_part_label_print w_pandora_part_label_print

type variables
n_warehouse i_nwarehouse
n_labels	invo_labels
n_3com_labels	invo_3com_labels
n_labels_pandora iu_labels

String	isOrigSql , is_wh_code ,is_own_cd

str_parms istr_print_parms

constant long il_size_limit = 32000
end variables

forward prototypes
public function str_parms uf_split_serialno_by_length (any asseriallist, long allength)
end prototypes

event ue_print();//26-FEB-2018 :Madhu F-6390 Print 2D Barcode and Part Label


//Wrapped existing Part Label code into ue_print_part_label()
IF f_retrieve_parm("PANDORA", "FOOTPRINT", "FOOTPRINT_LABELS" ,"USER_UPDATEABLE_IND") = 'N'  THEN
	If cbx_part_label.checked Then this.event ue_print_part_label( )
ELSE
	If cbx_part_label.checked Then this.event ue_print_inventory_part_label( )
	this.event ue_print_part_child_label()
END IF

//Print Delta Label
If cbx_delta_label.checked Then this.event ue_print_inventory_delta_label()

//Print Pallet Label
If cbx_pallet_label.checked Then this.event ue_print_2d_pallet_label()

//Print Carton Label
If cbx_carton_label.checked Then this.event ue_print_2d_carton_label()

//Print Nested Pallet Carton Label
If cbx_nested_label.checked Then this.event ue_print_2d_pallet_carton_label()


//Print 2D Barcode
//If cbx_2d_barcode.checked Then this.event ue_print_2d_barcode( )
end event

event ue_print_part_label();Str_Parms	lstrparms
n_labels_pandora	lu_labels
n_labels_pandora	lu_Child_Labels
nvo_country lnvo_c
string ls_coo, ls_userfield1, ls_seriallotno, ls_boxid, ls_owner

Long	llQty,	&
		llRowCount,	&
		llRowPos, &
		ll_rtn, llPrintJob, llFindRow, ll_ownerid
		
Any	lsAny

String	lsFormat, 		lsFormatSave, 			lsPrinter, ls_desc, ls_userfield114, ls_ownercd,ls_owncd
String	lsChildFormat, 	lsChildFormatSave

String lsLabel, 			lsLabelPrint, 		lsPrintText, 			lsCurrentLabel
String lsChildLabel,	lsChildLabelPrint,	lsChildPrintText, 	lsChildCurrentLabel

string ls_serial_no, ls_alt_sku, ls_comment, ls_lot_no, ls_box_id, ls_SKU, ls_Child_SKU

string ls_Child_SKU1,  ls_Child_SKU2,  ls_Child_SKU3,  ls_Child_SKU4 
string ls_Child_Serial_Number1,  ls_Child_Serial_Number2,  ls_Child_Serial_Number3,  ls_Child_Serial_Number4 
string ls_XOFY, ls_filter

Integer	liMsg, li_Number_Of_Child_Labels,  li_Child_Label_Counter, li_Number_Of_Children, li_X, li_Y, li_component_no

long ll_label_quantity

//TimA 08/15/2011 Pandora issue #227
String ls_Sort
String ls_l_code, ls_project_code //TAM 2017/04


lu_labels 		= Create n_labels_pandora
lu_child_labels  = Create n_labels_pandora

Dw_Label.AcceptText()

// TAM 04/2017 - Change label to us a standard label for Print and Reprint
// GailM 4/18/2018 S17648 F7366 I712 PDA SIMS new version of the label for 300 DPI in ZPL
If rb_200.checked = True Then
	lsFormat 		= "pandora_part_label_common.txt"
Else
	lsFormat 		= "pandora_part_label_300dpi.txt"	
End If

lsChildFormat 	= "PANDORA_child_PART_LABEL_XOFY.txt"

lsLabel 		= lu_Labels.uf_read_label_Format(			lsFormat)
lsChildLabel 	= lu_Child_Labels.uf_read_label_Format(	lsChildFormat)

If lsLabel 		= "" Then Return
If lsChildLabel 	= "" Then Return

dw_label.SetFilter("c_print_ind = 'Y'")
dw_label.Filter()

//TimA 08/15/2011 Pandora issue #227
//Added a sort to the filer.  The problem was serial number was not included and if all the rose have the same SKU then they would 
//randomly sorted by sku and not serial number.
ls_Sort = "Line_item_no, l_code, sku_parent, component_no, component_ind desc, sku, container_id, serial_no"
dw_label.SetSort(ls_Sort)
dw_label.Sort( )

//Print each detail Row
llRowCount = dw_label.RowCount()

// Create the country object.
lnvo_c = Create nvo_country

If llRowCount > 0 Then

	For llRowPos = 1 to llRowCount /*each detail row */
	
			//load current label from the template (we can resuse template until format changes)
			lsCurrentLabel			= lsLabel
			lsChildCurrentLabel 	= lsChildLabel 
			
			// Get the COO.
			ls_coo = dw_label.GetITemString(llRowPos,'country_of_origin')
			
			// If the COO is 3 chars,
			IF len(ls_coo) = 3 then
				
				// Convert to 2 char COO.
				lnvo_c.f_exchangecodes(ls_coo, ls_coo)
				
			End If
	
			ls_SKU = dw_label.GetITemString(llRowPos,'sku')
			lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~SKU~~",ls_SKU) /* Part*/
			lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~SKUBARCODE~~",dw_label.GetITemString(llRowPos,'sku')) /* Barcoded Part*/
			lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~COO~~", ls_coo) /* Part*/
			lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~QTY~~", String(dw_label.GetITemNumber(llRowPos,'quantity'))) /* Part*/
			
			ls_seriallotno = dw_label.GetITemString(llRowPos,'lot_no')
			If Isnull(ls_seriallotno) OR trim(ls_seriallotno) = '-' OR trim(ls_seriallotno) = 'NA' OR trim(ls_seriallotno) = 'N/A'  OR trim(ls_seriallotno) = '' THEN 
				
				ls_seriallotno = dw_label.GetITemString(llRowPos,'serial_no')
			End If

			If Isnull(ls_seriallotno) OR trim(ls_seriallotno) = '-' THEN ls_seriallotno = ''
			
			lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~SERIAL~~", ls_seriallotno) /* Serial*/
			lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~SERIALBARCODE~~", ls_seriallotno) /* Barcoded Serial*/
			li_component_no = dw_label.GetITemNumber(llRowPos,'Component_no')

			ls_alt_sku = dw_label.GetITemString(llRowPos,'alternate_sku')
			If Isnull(ls_alt_sku) THEN 
				ls_alt_sku = ''
			Else
				ls_alt_sku = Left(ls_alt_sku,25)		//GailM 11/19/2018
			End If			
			lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~ALT_SKU~~", ls_alt_sku)

			ls_comment = dw_label.GetITemString(llRowPos,'comment')
			If Isnull(ls_comment) THEN ls_comment = ''
			lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~COMMENT~~", ls_comment)	
	
			lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~DATE~~", string(today(),'YYYY-MM-DD')) 

			ls_box_id = dw_label.GetITemString(llRowPos,'container_id')
			If Isnull(ls_box_id) THEN ls_box_id = ''
			lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~BOXID~~", ls_box_id)
					
			ll_label_quantity = dw_label.GetITemNUmber(llRowPos,'c_print_qty')
			
			// Get the owner code- Nxjain05302016	
		 If (is_wh_code ='PND_AMSTER' OR is_wh_code='PND_WESTP' OR is_wh_code='PND_SRIJK') then
			lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~OWNER~~", is_own_cd)
			//nxjain end  
		end if 
	
			If ll_label_quantity >= 1 Then
				lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"^PQ1,","^PQ" + string(ll_label_quantity) + ",")
			End If
			
//			// Get the owner ID.
			ll_ownerid = dw_label.GetITemNUmber(llRowPos,'item_master_owner_id')
			
			// Get the owner.
			ls_owner = dw_label.GetItemstring ( llRowPos, "receive_master_user_field2" )
			
			if Pos ( ls_Owner, "(" ) > 0 then
				ls_ownercd = Left ( ls_owner, Len ( ls_owner ) - ( Len ( ls_owner ) - Pos ( ls_owner, "(" ) + 1 ) )
			else
				ls_OwnerCd = ls_Owner
			end if
			
			// Get user_field1 for this owner.
			Select user_field1
			INTO :ls_userfield1 
			from customer
			where customer.project_id = 'pandora' 
			and customer.cust_code = :ls_ownercd
			using sqlca;
			
			// If this customer is NOT 'NPI',
			if NOT trim(ls_userfield1) =  "NPI" then
			
				// Get the description.
				SELECT description, USER_FIELD14
				INTO :ls_desc, :ls_userfield114
				FROM ITEM_MASTER 
				WHERE PROJECT_ID = 'PANDORA' 
				AND OWNER_ID =  :ll_ownerid
				AND SKU = :ls_SKU
				using sqlca;
			
				// Correct for Nulls.
				If isnull(ls_desc) then ls_desc = ""
				if isnull(ls_userfield114) then ls_userfield114 = ""
		
				// Replace the label placeholder with the item description.
				lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~DESCRIPTION~~", ls_desc) //05-May-2017 :Madhu PEVS-541 -Part Description
				lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~DESCRIPTION1~~", Ls_userfield114)  //05-May-2017 :Madhu PEVS-541 -Part Description
			End If
	
			//lsLabelPrint += lsCurrentLabel //14-Apr-2017 :Madhu -SIMSPEVS-506PandoraPartLabels-Re-design
			
			// Get the box ID (container ID)
			ls_boxid = dw_label.GetITemstring(llRowPos,'container_id')
//			lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~BOXID~~", ls_desc + "" + ls_boxid) //TAM 04/2017
			
	// TAM 04/2017 - Change label to us a standard label for Print and Reprint
			ls_l_code =dw_label.GetItemString(llRowPos, "l_code")
			ls_owner = dw_label.GetItemstring ( llRowPos, "receive_master_user_field2" )
			IF ISNull(ls_l_code) THEN ls_l_code = ""

			ls_project_code =dw_label.GetItemString(llRowPos, "po_no")
			IF ISNull(ls_project_code) THEN ls_project_code = ""

			lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~BOXID~~", ls_boxid)
			lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~BOXIDBARCODE~~", ls_box_id)
			lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~L_CODE~~", ls_l_code)
			lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~OWNER_CD~~", ls_OwnerCd)
			lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~PROJECT_CODE~~", ls_project_code)
			lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~COOBARCODE~~", ls_coo) /* COO */
			lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~Qty~~", String(dw_label.GetITemNumber(llRowPos,'quantity'))) /* Part*/
			if isnull(ls_userfield114) then ls_userfield114 = ""
			lsCurrentLabel = lu_labels.uf_replace ( lsCurrentLabel, "~~description~~", ls_desc ) //05-May-2017 :Madhu PEVS-541 -Part Description
			lsCurrentLabel = lu_labels.uf_replace ( lsCurrentLabel, "~~description1~~", Ls_userfield114 ) //05-May-2017 :Madhu PEVS-541 -Part Description
			lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~SKU_barcode~~", ls_sku) /* Barcoded Part*/
			lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~reprint~~", '' ) /* */
		
			lsLabelPrint += lsCurrentLabel //14-Apr-2017 :Madhu -SIMSPEVS-506PandoraPartLabels-Re-design
			
			ls_filter = 'SKU <> SKU_Parent and  Component_no='+Trim(String(li_component_no))
			
			dw_label.SetFilter(ls_filter)
			dw_label.Filter()
			
			li_Number_Of_Children = dw_label.RowCount()
			li_Child_Label_Counter = 0
			li_Y =  li_Number_Of_Children / 3
			
			If Mod(li_Number_Of_Children,  3 ) > 0 Then li_Y = li_Y + 1

			For li_X = 1 To li_Y
				
				    lsChildCurrentLabel  = lsChildLabel
				
					ls_Child_SKU1					= 	''
			 		ls_Child_Serial_Number1		= 	''			  
			 		ls_Child_SKU2					=	''
					ls_Child_Serial_Number2 	=	''				 
			 	 	ls_Child_SKU3 					=	''
			     	ls_Child_Serial_Number3		=	''			 
			      	ls_Child_SKU4					=	''
			      	ls_Child_Serial_Number4		=	''
							
				   	li_Child_Label_Counter =  li_Child_Label_Counter + 1
						
					IF li_Child_Label_Counter <=	li_Number_Of_Children Then
				
			 				ls_Child_SKU1					= 	dw_label.GetITemString(	li_Child_Label_Counter,		'sku')
			 				ls_Child_Serial_Number1		=	dw_label.GetITemString( li_Child_Label_Counter,		'serial_no')
					 
					End If
					
					 li_Child_Label_Counter =  li_Child_Label_Counter + 1
			  
					IF li_Child_Label_Counter <=	li_Number_Of_Children Then
							  
			 				ls_Child_SKU2					=	dw_label.GetITemString( li_Child_Label_Counter,	'sku')
							ls_Child_Serial_Number2 	=	dw_label.GetITemString( li_Child_Label_Counter,	'serial_no')

					End If
					
					li_Child_Label_Counter =  li_Child_Label_Counter + 1
				 
					IF li_Child_Label_Counter <=	li_Number_Of_Children Then
							  
			 	 			ls_Child_SKU3 					=	dw_label.GetITemString(li_Child_Label_Counter,	'sku')
			     			ls_Child_Serial_Number3		=	dw_label.GetITemString(li_Child_Label_Counter,	'serial_no')
					  
					End If  
					
					lsChildCurrentLabel 	=lu_Child_Labels.uf_replace(lsChildCurrentLabel,"~~PARENTSKUTEXT~~",							ls_SKU) /* Parent Part*/
					lsChildCurrentLabel 	= lu_Child_Labels.uf_replace(lsChildCurrentLabel,"~~PARENTSKUBARCODE~~",					ls_SKU) /* Parent Barcoded Part*/

					lsChildCurrentLabel	= lu_Child_Labels.uf_replace(lsChildCurrentLabel,"~~PARENTSERIALNUMBERTEXT~~", 		ls_serial_no) /* Parent Serial*/
					lsChildCurrentLabel 	= lu_Child_Labels.uf_replace(lsChildCurrentLabel,"~~PARENTSERIALNUMBERBARCODE~~", 	ls_serial_no) /* Parent Barcoded Serial*/
					
					lsChildCurrentLabel 	= lu_Child_Labels.uf_replace(lsChildCurrentLabel ,'~~CHILDSKU1~~',								ls_Child_SKU1 ) /* Part*/
					lsChildCurrentLabel	= lu_Child_Labels.uf_replace(lsChildCurrentLabel ,"~~CHILDSKUBARCODE1~~", 					ls_Child_SKU1 ) /* Barcoded Part*/
			
					lsChildCurrentLabel 	= lu_Child_Labels.uf_replace(lsChildCurrentLabel,"~~CHILDSERIAL1~~",							ls_Child_Serial_Number1) /* Serial*/
					lsChildCurrentLabel	= lu_Child_Labels.uf_replace(lsChildCurrentLabel,"~~CHILDSERIALBARCODE1~~",				ls_Child_Serial_Number1) /* Barcoded Serial*/
	
					lsChildCurrentLabel 	= lu_Child_Labels.uf_replace(lsChildCurrentLabel ,'~~CHILDSKU2~~',								ls_Child_SKU2 ) /* Part*/
					lsChildCurrentLabel	= lu_Child_Labels.uf_replace(lsChildCurrentLabel ,"~~CHILDSKUBARCODE2~~", 					ls_Child_SKU2 ) /* Barcoded Part*/
			
					lsChildCurrentLabel 	= lu_Child_Labels.uf_replace(lsChildCurrentLabel,"~~CHILDSERIAL2~~",							ls_Child_Serial_Number2) /* Serial*/
					lsChildCurrentLabel	= lu_Child_Labels.uf_replace(lsChildCurrentLabel,"~~CHILDSERIALBARCODE2~~",				ls_Child_Serial_Number2) /* Barcoded Serial*/
					
					lsChildCurrentLabel 	= lu_Child_Labels.uf_replace(lsChildCurrentLabel ,'~~CHILDSKU3~~',								ls_Child_SKU3 ) /* Part*/
					lsChildCurrentLabel	= lu_Child_Labels.uf_replace(lsChildCurrentLabel ,"~~CHILDSKUBARCODE3~~", 					ls_Child_SKU3 ) /* Barcoded Part*/
			
					lsChildCurrentLabel 	= lu_Child_Labels.uf_replace(lsChildCurrentLabel,"~~CHILDSERIAL3~~",							ls_Child_Serial_Number3) /* Serial*/
					lsChildCurrentLabel	= lu_Child_Labels.uf_replace(lsChildCurrentLabel,"~~CHILDSERIALBARCODE3~~",				ls_Child_Serial_Number3) /* Barcoded Serial*/
					
					 ls_XOFY = String( li_X ) + ' Of ' +String( li_Y	)	
					 
					lsChildCurrentLabel 	= lu_Child_Labels.uf_replace(lsChildCurrentLabel,"~~Box~~",								ls_XOFY )
					lsLabelPrint += lsChildCurrentLabel	
					
			Next
			
			dw_label.SetFilter("c_print_ind = 'Y'")
			dw_label.Filter()
			
	Next /*detail row to Print*/

//Send the format to the printer...
	If lsLabelPrint > "" Then
		
		OpenWithParm(w_label_print_options,lStrParms)
		Lstrparms = Message.PowerObjectParm		  
		If lstrParms.Cancelled Then
			
			IF cbx_show_comp.Checked Then
				dw_label.SetFilter('')	
				dw_label.Filter()
			Else
				dw_label.	SetFilter('SKU = SKU_Parent')	
				dw_label.Filter()
			End If
			
			 dw_label.SetRedraw(TRUE)
			Return
		End If
				
		lsPrintText = 'Pandora Part Labels '
		
		//Open Printer File 
		llPrintJob = PrintOpen(lsPrintText)
			
		If llPrintJob <0 Then 
			Messagebox('Labels', 'Unable to open Printer file. Labels will not be printed')
			
			IF cbx_show_comp.Checked Then
				dw_label.SetFilter('')	
				dw_label.Filter()
			Else
				dw_label.	SetFilter('SKU = SKU_Parent')	
				dw_label.Filter()
			End If
			
			 dw_label.SetRedraw(TRUE)
			Return
		End If 
		
		PrintSend(llPrintJob, lsLabelPrint)	
		PrintClose(llPrintJob)
				
	End If
		
End If

// Destroy the country object.
Destroy lnvo_c

IF cbx_show_comp.Checked Then
	dw_label.SetFilter('')	
	dw_label.Filter()
Else
	dw_label.	SetFilter('SKU = SKU_Parent')	
	dw_label.Filter()
End If

//TimA 08/15/2011 Pandora issue #227
dw_label.SetRedraw(TRUE)
dw_label.SetSort(ls_Sort)
dw_label.Sort( )
end event

event ue_print_2d_barcode();//27-FEB-2018 Madhu S16401 F6390 - 2D Barcode

Str_Parms	lstrparms, lstrParms_containerId, lstr_serialList, ls_str_serial_data, ls_str_empty
long	llRowCount,	llRowPos, llPrintJob, ll_row, ll_cont_row, ll_New_row, ll_Return
String lsLabel, lsLabelPrint, lsPrintText, lsCurrentLabel, ls_pkg_Id, ls_sscc
String ls_sku, lsFormat, ls_coo, ls_Sort, lsFilter, ls_prev_container_Id , ls_container_Id

n_labels_pandora	lu_labels
lu_labels = Create n_labels_pandora

Datastore lds_label_data
lds_label_data =create Datastore
lds_label_data.dataobject ='d_pandora_2d_barcode_label_data'

dw_label.accepttext( )

lsFormat = "Pandora_2D_Barcode_Label.txt"
lsLabel = lu_Labels.uf_read_label_Format(lsFormat)

If lsLabel = "" Then Return

dw_label.SetFilter("c_print_ind = 'Y'")
dw_label.Filter()

//since it is a container Label, sort selected records by container Id.
ls_Sort = "container_id"
dw_label.SetSort(ls_Sort)
dw_label.Sort( )
llRowCount = dw_label.RowCount()

For ll_row =1 to llRowCount
	ls_container_Id = dw_label.getItemstring( ll_row, 'container_id')
	IF ( ls_prev_container_Id <> ls_container_Id) THEN
		lstrParms_containerId.string_arg[UpperBound(lstrParms_containerId.string_arg) +1] = ls_container_Id
	END IF
	ls_prev_container_Id = ls_container_Id
Next

//get each container Id records from dw_label and loop through.
IF UpperBound(lstrParms_containerId.string_arg[]) > 0 THEN
	
	FOR ll_cont_row =1 to UpperBound(lstrParms_containerId.string_arg[])
		ls_container_Id =	lstrParms_containerId.string_arg[ll_cont_row]
		
		lsFilter ="container_id ='"+ls_container_Id+"' and c_print_ind = 'Y'"
		dw_label.setfilter( lsFilter)
		dw_label.filter( )
		llRowCount = dw_label.rowcount( )
		
		FOR llRowPos = 1 to llRowCount
			ls_sku =trim(dw_label.getItemstring( llRowPos, 'sku'))
			ls_coo = left(dw_label.getItemstring( llRowPos, 'country_of_origin'),2)
			lstr_serialList.string_arg[llRowPos] = trim(dw_label.getItemstring( llRowPos, 'serial_no')) //get serial No
		Next
		
		//split SN's against size of PDF417 limit and return required labels count
		ls_str_serial_data = lu_labels.uf_split_serialno_by_length( lstr_serialList , 1500)
		
		//generate SSCC No.
		ls_sscc = lu_labels.uf_generate_sscc( ls_container_Id)
				
		For ll_row =1 to UpperBound(ls_str_serial_data.String_arg[])
			ll_New_row =lds_label_data.insertrow( 0)
			lds_label_data.setItem( ll_New_row, 'sku', ls_sku)
			lds_label_data.setItem( ll_New_row, 'carton_id', ls_container_Id)
			lds_label_data.setItem( ll_New_row, 'label_text', "CARTON LABEL")
			lds_label_data.setItem( ll_New_row, 'serial_no', ls_str_serial_data.String_arg[ll_row])
			lds_label_data.setItem( ll_New_row, 'sscc_no', ls_sscc)
			lds_label_data.setItem( ll_New_row, 'coo', ls_coo)
			lds_label_data.setItem( ll_New_row, 'print_x', string(ll_row))
			lds_label_data.setItem( ll_New_row, 'print_y', string(UpperBound(ls_str_serial_data.String_arg[])))
		NEXT
		
		//empty str_parms
		lstr_serialList =ls_str_empty
		ls_str_serial_data = ls_str_empty
	NEXT
END IF

//Preparing print Label Data against above created data store.
llRowCount =lds_label_data.rowcount( )
For llRowPos = 1 to llRowCount
	lsCurrentLabel= lsLabel
	lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~label_text~~", lds_label_data.getItemString( llRowPos, 'label_text'))
	lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"_7Eserial_5Fno_5Fbc_7E", lds_label_data.getItemString( llRowPos, 'serial_no'))

	lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~cont~~", lds_label_data.getItemString( llRowPos, 'sscc_no'))
	lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,">=cont>=", lds_label_data.getItemString( llRowPos, 'sscc_no'))
	
	lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~carton_Id~~", lds_label_data.getItemString( llRowPos, 'carton_id'))
	
	lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~sku~~", lds_label_data.getItemString( llRowPos, 'sku'))
	lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,">=sku>=", lds_label_data.getItemString( llRowPos, 'sku'))
		
	lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~qty~~", string(llRowCount))
	lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,">=qty>=", string(llRowCount))
		
	lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~uc3~~", lds_label_data.getItemString( llRowPos, 'coo'))
	lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,">=uc3>=", lds_label_data.getItemString( llRowPos, 'coo'))
				
	lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~count~~", lds_label_data.getItemString( llRowPos, 'print_x'))
	lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~count_total~~", lds_label_data.getItemString( llRowPos, 'print_y'))
	
	lsLabelPrint += lsCurrentLabel
NEXT

//Print Label
ll_Return =lu_labels.uf_print_label_data( 'Pandora 2D Barcode Part Labels ', lsLabelPrint)
	
//Reset Label Filter
dw_label.setfilter( "")
dw_label.filter( )
dw_label.rowcount( )

dw_label.SetRedraw(TRUE)
dw_label.SetSort(ls_Sort)
dw_label.Sort( )

destroy lds_label_data
destroy lu_labels
end event

event ue_print_inventory_part_label();//25-JULY-2018 :Madhu S21780 Label consolidation - Print Inventory Part Labels

string ls_sort, ls_QA_Check_Ind, ls_format, ls_part_label
string ls_container_Id, ls_sku, ls_sku_desc, ls_description, ls_description1, ls_description2, ls_description3, ls_description4
string ls_coo, ls_owner_cd, ls_owner, ls_alt_sku, ls_serialized_ind, ls_po_no, ls_uf14, ls_complete_description, ls_exp_Ind
string ls_label_print, ls_print_text, ls_filter, ls_expiry_data

long ll_Row, ll_Row_Count, ll_qty, ll_print_job, ll_desc_length, ll_count, ll_remain_length, ll_Return
long ll_copy_count, ll_label_length, ll_label_files, ll_labels_per_file

int liInx1, liInx2

str_parms lps_reset
lps_reset.Boolean_arg[1] = False

datetime ldt_exp_date
datetime ldtToday

nvo_country lnvo_country
lnvo_country = create nvo_country

dw_label.accepttext( )

dw_label.setfilter( "c_print_ind ='Y'")
dw_label.filter( )

ls_sort = "Line_item_no, l_code, sku_parent, sku, container_id"
dw_label.setsort( ls_sort)
dw_label.sort( )

//Print each detail Row
ll_Row_Count = dw_label.rowcount( )

//Loop through each record
For ll_Row = 1 to ll_Row_Count
	
	If Upperbound(istr_print_parms.Long_arg) > 0 Then
		istr_print_parms.Long_arg[1] = dw_label.GetItemNumber(ll_Row, 'c_print_qty')
	End If
	
	ls_QA_Check_Ind = dw_label.getItemString( ll_Row, 'item_master_qa_check_ind')
	
	If IsNull( ls_QA_Check_Ind) Then ls_QA_Check_Ind ='X'
	
	//assign appropriate label format
	IF ls_QA_Check_Ind = 'M'  and rb_200.checked = True THEN
		ls_format ="Pandora_Inventory_Label_DG_Logo_200_DPI.txt"
		ls_expiry_data ="^B3R,N,53,N,N^FD~~dt_expire~~^FS"
	
	elseIf ls_QA_Check_Ind <> 'M' and rb_200.checked = True THEN
		ls_format ="Pandora_Inventory_Label_No_DG_Logo_200_DPI.txt"
		ls_expiry_data ="^B3R,N,53,N,N^FD~~dt_expire~~^FS"
	
	elseIf ls_QA_Check_Ind = 'M' and rb_300.checked = True THEN
		ls_format ="Pandora_Inventory_Label_DG_Logo_300_DPI.txt"
		ls_expiry_data ="^B3R,N,78,N,N^FD~~dt_expire~~^FS"
	
	elseIf ls_QA_Check_Ind <> 'M' and rb_300.checked = True THEN
		ls_format ="Pandora_Inventory_Label_No_DG_Logo_300_DPI.txt"
		ls_expiry_data ="^B3R,N,78,N,N^FD~~dt_expire~~^FS"
	End IF
	
	//read label format
	ls_part_label = iu_labels.uf_read_label_Format(ls_format)
	If ls_part_label ="" Then Return
	
	//re-set value to blank instead NULL
	ls_description ='' 
	ls_description1 ='' 
	ls_description2 =''
	ls_description3 ='' 
	ls_description4 =''
	
	ls_container_Id = dw_label.getItemString( ll_Row, 'container_id') //container Id
	ls_sku = dw_label.getItemString( ll_Row, 'sku') 	//sku
	ls_sku_desc = dw_label.getItemString( ll_Row, 'description') //description
	ls_uf14 = dw_label.getItemString( ll_Row, 'item_master_user_field14') //User Field14		
	
	If (not isnull(ls_sku_desc) and len(ls_sku_desc) > 0 ) Then ls_complete_description = ls_sku_desc
	If (not isnull(ls_uf14) and len(ls_uf14) > 0 ) Then ls_complete_description += ls_uf14
	
	//split the description into multiple fields. Each field can hold upto 50 chars.
	ll_count =0
	ll_remain_length = len(ls_complete_description)
	
	DO WHILE ll_remain_length > 0
		ll_count++
		
		CHOOSE CASE ll_count
		
		CASE 1  //1-50
			IF ll_remain_length > 50 Then
				ls_description = left(ls_complete_description, 50)
				ll_remain_length = ll_remain_length -50
			ELSE
				ls_description = left(ls_complete_description, ll_remain_length)
				ll_remain_length = 0
			END IF
		
		CASE 2 //51-100
			IF ll_remain_length > 50 Then
				ls_description1 = Mid(ls_complete_description, 51, 50)
				ll_remain_length = ll_remain_length -50
			ELSE
				ls_description1 = Mid(ls_complete_description, 51, ll_remain_length)
				ll_remain_length = 0
			END IF
		
		CASE 3 //101-150
			IF ll_remain_length > 50 Then
				ls_description2 = Mid(ls_complete_description, 101, 50)
				ll_remain_length = ll_remain_length -50
			ELSE
				ls_description2 = Mid(ls_complete_description, 101, ll_remain_length)
				ll_remain_length = 0
			END IF
		
		CASE 4 //151-200
			IF ll_remain_length > 50 Then
				ls_description3 = Mid(ls_complete_description, 151, 50)
				ll_remain_length = ll_remain_length -50
			ELSE
				ls_description3 = Mid(ls_complete_description, 151, ll_remain_length)
				ll_remain_length = 0
			END IF
		
		CASE 5 //201-250
			IF ll_remain_length > 50 Then
				ls_description4 = Mid(ls_complete_description, 201, 50)
				ll_remain_length = ll_remain_length -50
			ELSE
				ls_description4 = Mid(ls_complete_description, 201, ll_remain_length)
				ll_remain_length = 0
			END IF
		END CHOOSE
	LOOP
	
	ls_coo = dw_label.getItemString( ll_Row, 'country_of_origin') //coo
	
	// If the COO is 3 chars then Convert to 2 char.
	If len(ls_coo) = 3 then lnvo_country.f_exchangecodes(ls_coo, ls_coo)
	
	ll_qty = dw_label.getItemNumber(ll_Row,'quantity') //Qty
	ls_po_no = dw_label.getItemString( ll_Row, 'po_no') //Po No
	
	// Get the owner.
	ls_owner = dw_label.getItemString ( ll_Row, "receive_master_user_field2" ) //Owner Code
	
	if Pos ( ls_owner, "(" ) > 0 then
		ls_owner_cd = Left ( ls_owner, Len ( ls_owner ) - ( Len ( ls_owner ) - Pos ( ls_owner, "(" ) + 1 ) )
	else
		ls_owner_cd = ls_owner
	end if
	
	ls_alt_sku = dw_label.GetITemString(ll_Row,'alternate_sku') //alternate sku
	If Isnull(ls_alt_sku) THEN ls_alt_sku = ''
	
	ldt_exp_date = dw_label.getItemdateTime( ll_Row, "receive_putaway_expiration_date") //expiration date
	ls_serialized_Ind =  dw_label.getItemString ( ll_Row, "serialized_ind" ) //serialized Ind
	ls_exp_Ind =  dw_label.getItemString ( ll_Row, "item_master_expiration_controlled_ind" ) //Expiration Controlled Ind
	
	//replace label format data
	If ls_container_Id <> '-' Then ls_part_label = iu_labels.uf_replace(ls_part_label,"~~container_id~~",  ls_container_Id)
	ls_part_label = iu_labels.uf_replace(ls_part_label,"~~sku~~", ls_sku) 
	ls_part_label = iu_labels.uf_replace(ls_part_label,"~~sku_desc~~", ls_description)
	ls_part_label = iu_labels.uf_replace(ls_part_label,"~~sku_desc1~~", ls_description1)
	ls_part_label = iu_labels.uf_replace(ls_part_label,"~~sku_desc2~~", ls_description2)
	ls_part_label = iu_labels.uf_replace(ls_part_label,"~~sku_desc3~~", ls_description3)
	ls_part_label = iu_labels.uf_replace(ls_part_label,"~~sku_desc4~~", ls_description4)
	
	If ll_qty < 10 Then
		ls_part_label = iu_labels.uf_replace(ls_part_label,"~~qty~~", string(ll_qty ,'00'))
	else
		ls_part_label = iu_labels.uf_replace(ls_part_label,"~~qty~~", string(ll_qty))
	End If
	
	ls_part_label = iu_labels.uf_replace(ls_part_label,"~~uc3~~", ls_coo)
	ls_part_label = iu_labels.uf_replace(ls_part_label,"~~po_no~~", ls_po_no)
	ls_part_label = iu_labels.uf_replace(ls_part_label,"~~owner_code~~", ls_owner_cd)
	ls_part_label = iu_labels.uf_replace(ls_part_label,"~~alt_sku~~", ls_alt_sku)
	
	If ls_exp_Ind ='Y' and string(ldt_exp_date, 'MM/DD/YYYY') <> '12/31/2999' Then 
		ls_part_label = iu_labels.uf_replace(ls_part_label,"~~dt_expire~~", string(ldt_exp_date, 'MM/DD/YYYY'))
	else
		ls_part_label = iu_labels.uf_replace(ls_part_label, ls_expiry_data, "^FD^FS") //make Invisible
	End If
	
	ls_part_label = iu_labels.uf_replace(ls_part_label,"~~user_name~~", gs_userid)
	ls_part_label = iu_labels.uf_replace(ls_part_label,"~~route_cmt1~~", ls_serialized_Ind)
	
	ldtToday = f_getLocalWorldTime(is_wh_code)
	
	ls_part_label = iu_labels.uf_replace(ls_part_label,"~~dt_print~~", string(ldtToday,'MM/DD/YYYY'))
	
	ll_copy_count = dw_label.GetItemNumber(ll_Row, 'c_print_qty')
	ll_label_length = Len(ls_part_label)
	ll_labels_per_file = il_size_limit / ll_label_length
	ll_label_files = (ll_copy_count / ll_labels_per_file) + 1

	DO WHILE ll_copy_count > 0
		ls_label_print = ""
		If ll_copy_count <= ll_labels_per_file Then
			For liInx1 = 1 to ll_copy_count
				ls_label_print += ls_part_label
			Next
		Else
			For liInx1 = 1 to ll_labels_per_file
				ls_label_print += ls_part_label
			Next
		End If
		ll_copy_count = ll_copy_count - ll_labels_per_file
		istr_print_parms = iu_labels.uf_print_label_data( 'Pandora 2D Barcode Pallet Labels ', ls_label_print, istr_print_parms)
		ls_label_print = ""
	LOOP
	
Next

// Reset copies to zero for next use
//istr_print_parms.String_arg[1] = ""
istr_print_parms = lps_reset
//istr_print_parms.Long_arg[1] = 0
	
//Reset Label Filter
dw_label.setfilter( "")
dw_label.filter( )
dw_label.rowcount( )

dw_label.SetRedraw(TRUE)
dw_label.SetSort(ls_Sort)
dw_label.Sort( )

// Destroy the country object.
destroy lnvo_country
end event

event ue_print_inventory_delta_label();//25-JULY-2018 :Madhu S21780 Label consolidation - Print Delta Labels

string ls_sort, ls_format, ls_label, ls_delta_label
string ls_container_Id, ls_po_no, ls_owner, ls_owner_cd
string ls_label_print, ls_print_text

long ll_Row, ll_Row_Count, ll_Return, ll_label_quantity

dw_label.accepttext( )

//remove filter, if any
dw_label.setfilter( "")
dw_label.filter( )

dw_label.setfilter( "c_print_ind ='Y'")
dw_label.filter( )

ls_sort = "Line_item_no, l_code, sku_parent, sku, container_id"
dw_label.setsort( ls_sort)
dw_label.sort( )

//Print each detail Row
ll_Row_Count = dw_label.rowcount( )

//Loop through each record
For ll_Row = 1 to ll_Row_Count
	
	ll_label_quantity = dw_label.GetITemNUmber(ll_Row,'c_print_qty') //10/04/2019 - MikeA - DE12877 - SIMS - Google - Part label print doesn't print multiple quantities (Delta label)
		
	//Assign appropriate format
	IF rb_200.checked = True THEN
		ls_format ="Pandora_Delta_Label_200_DPI.txt"
	else
		ls_format ="Pandora_Delta_Label_300_DPI.txt"
	End IF
			
	//read label format
	ls_label = iu_labels.uf_read_label_Format(ls_format)

	If ls_label ="" Then Return
	ls_delta_label = ls_label //store label format
	
	ls_container_Id = dw_label.getItemString( ll_Row, 'container_id') //container Id
	ls_po_no = dw_label.getItemString( ll_Row, 'po_no') //Po No

	// Get the owner.
	ls_owner = dw_label.getItemString ( ll_Row, "receive_master_user_field2" ) //Owner Code
	
	if Pos ( ls_owner, "(" ) > 0 then
		ls_owner_cd = Left ( ls_owner, Len ( ls_owner ) - ( Len ( ls_owner ) - Pos ( ls_owner, "(" ) + 1 ) )
	else
		ls_owner_cd = ls_owner
	end if

	//replace label format data
	If ls_container_Id <> '-' Then ls_delta_label = iu_labels.uf_replace(ls_delta_label,"~~container_id~~",  ls_container_Id)
	ls_delta_label = iu_labels.uf_replace(ls_delta_label,"~~po_no~~", ls_po_no)
	ls_delta_label = iu_labels.uf_replace(ls_delta_label,"~~owner_code~~", ls_owner_cd)
	ls_delta_label = iu_labels.uf_replace(ls_delta_label,"~~user_name~~", gs_userid)
	ls_delta_label = iu_labels.uf_replace(ls_delta_label,"~~dt_print~~", string(today(),'YYYY-MM-DD HH:MM:SS'))

	If ll_label_quantity >= 1 Then
			ls_delta_label = iu_labels.uf_replace(ls_delta_label,"^PQ1,","^PQ" + string(ll_label_quantity) + ",")
	End If	
	
	ls_label_print += ls_delta_label
Next

//Print Label
ll_Return =iu_labels.uf_print_label_data( 'Pandora Delta Labels ', ls_label_print)
	
//Reset Label Filter
dw_label.setfilter( "")
dw_label.filter( )
dw_label.rowcount( )

dw_label.SetRedraw(TRUE)
dw_label.SetSort(ls_Sort)
dw_label.Sort( )
end event

event ue_print_2d_pallet_label();//28-JULY-2018 :Madhu S21780 Label Consolidation - Pallet Label
//a. Print Pallet Label, if PoNo2 Tracking Ind =Y and Serial No's exist

Str_Parms	lstrparms, lstrParms_palletId, lstr_serialList, ls_str_serial_data, ls_str_empty
long	llRowCount,	llRowPos, llPrintJob, ll_row, ll_cont_row, ll_New_row, ll_Return, ll_max_limit
long	llPutawaySerialRows, llSerialRowPos, llSerialRows, llRow
String lsLabel, lsLabelPrint, lsPrintText, lsCurrentLabel, ls_pkg_Id, ls_sscc, ls_max_limit
String ls_sku, lsFormat, ls_coo, ls_Sort, lsFilter, ls_prev_pallet_Id , ls_pallet_Id, lsSerialNo

Datastore lds_label_data
lds_label_data =create Datastore
lds_label_data.dataobject ='d_pandora_2d_barcode_label_data'

dw_label.accepttext( )

//get MAX Limit of QR Barcode from Look Up Table
ls_max_limit =f_retrieve_parm(gs_project, 'QRBARCODE','MAX')
If IsNumber(ls_max_limit) Then ll_max_limit =long(ls_max_limit)

If rb_200.checked =True Then
	lsFormat = "Pandora_QR_Barcode_Label_200_DPI.txt"
else
	lsFormat = "Pandora_QR_Barcode_Label_300_DPI.txt"
End If

lsLabel = iu_labels.uf_read_label_Format(lsFormat)

If lsLabel = "" Then Return

dw_label.SetFilter("c_print_ind = 'Y' and item_master_po_no2_controlled_ind ='Y' ")
dw_label.Filter()

//since it is a Pallet Label, sort selected records by Pallet Id.
ls_Sort = "receive_putaway_po_no2"
dw_label.SetSort(ls_Sort)
dw_label.Sort( )
llRowCount = dw_label.RowCount()

For ll_row =1 to llRowCount
	ls_pallet_Id = dw_label.getItemstring( ll_row, 'receive_putaway_po_no2')
	IF ( ls_prev_pallet_Id <> ls_pallet_Id) THEN
		lstrParms_palletId.string_arg[UpperBound(lstrParms_palletId.string_arg) +1] = ls_pallet_Id
	END IF
	ls_prev_pallet_Id = ls_pallet_Id
Next

//get each pallet Id records from dw_label and loop through.
IF UpperBound(lstrParms_palletId.string_arg[]) > 0 THEN
	
	FOR ll_cont_row =1 to UpperBound(lstrParms_palletId.string_arg[])
		ls_pallet_Id =	lstrParms_palletId.string_arg[ll_cont_row]
		
		IF isvalid(w_ro) Then //Receiving
			w_ro.idw_putaway.setfilter("po_no2 ='"+ls_pallet_Id+"'")
			w_ro.idw_putaway.filter()
					
			FOR llRowPos = 1 to w_ro.idw_putaway.rowcount()
				ls_sku =trim(w_ro.idw_putaway.getItemstring( llRowPos, 'sku'))
				ls_coo = left(w_ro.idw_putaway.getItemstring( llRowPos, 'country_of_origin'),2)
				If w_ro.idw_rma_serial.RowCount() > 0 Then
					w_ro.idw_rma_serial.setfilter("po_no2 ='"+ls_pallet_Id+"'")
					w_ro.idw_rma_serial.filter()
					llSerialRows = w_ro.idw_rma_serial.RowCount()
					llRow = 1
					For llSerialRowPos = 1 to llSerialRows
						lsSerialNo = trim(w_ro.idw_rma_serial.getItemstring( llSerialRowPos, 'serial_no')) //get serial No
						If Not isNull(lsSerialNo) Then
							lstr_serialList.string_arg[llSerialRowPos] = lsSerialNo
							llRow++
						End If
					Next
				Else
					lstr_serialList.string_arg[llRowPos] = trim(w_ro.idw_putaway.getItemstring( llRowPos, 'serial_no')) //get serial No
				End If
			Next
			
			w_ro.idw_putaway.setfilter("")
			w_ro.idw_putaway.filter()
			w_ro.idw_rma_serial.setfilter("")
			w_ro.idw_rma_serial.filter()
			
		ELSEIF isvalid(w_tran) THEN //Transfer
			w_tran.idw_detail.setfilter("po_no2 ='"+ls_pallet_Id+"'")
			w_tran.idw_detail.filter()
					
			FOR llRowPos = 1 to w_tran.idw_detail.rowcount()
				ls_sku =trim(w_tran.idw_detail.getItemstring( llRowPos, 'sku'))
				ls_coo = left(w_tran.idw_detail.getItemstring( llRowPos, 'country_of_origin'),2)
				lstr_serialList.string_arg[llRowPos] = trim(w_tran.idw_detail.getItemstring( llRowPos, 'serial_no')) //get serial No
			Next
			
			w_tran.idw_detail.setfilter("")
			w_tran.idw_detail.filter()

		ELSEIF isvalid(w_owner_change) THEN //Owner change
			w_owner_change.idw_detail.setfilter("po_no2 ='"+ls_pallet_Id+"'")
			w_owner_change.idw_detail.filter()
					
			FOR llRowPos = 1 to w_owner_change.idw_detail.rowcount()
				ls_sku =trim(w_owner_change.idw_detail.getItemstring( llRowPos, 'sku'))
				ls_coo = left(w_owner_change.idw_detail.getItemstring( llRowPos, 'country_of_origin'),2)
				lstr_serialList.string_arg[llRowPos] = trim(w_owner_change.idw_detail.getItemstring( llRowPos, 'serial_no')) //get serial No
			Next
			
			w_owner_change.idw_detail.setfilter("")
			w_owner_change.idw_detail.filter()
		End IF
		
		//split SN's against size of PDF417 limit and return required labels count
		ls_str_serial_data = iu_labels.uf_split_serialno_by_length( lstr_serialList , ll_max_limit)
		
		//generate SSCC No.
		ls_sscc = iu_labels.uf_generate_sscc( ls_pallet_Id)
				
		For ll_row =1 to UpperBound(ls_str_serial_data.String_arg[])
			ll_New_row =lds_label_data.insertrow( 0)
			lds_label_data.setItem( ll_New_row, 'sku', ls_sku)
			lds_label_data.setItem( ll_New_row, 'pallet_id', ls_pallet_Id)
			lds_label_data.setItem( ll_New_row, 'label_text', "PALLET LABEL")
			lds_label_data.setItem( ll_New_row, 'serial_no', ls_str_serial_data.String_arg[ll_row])
			lds_label_data.setItem( ll_New_row, 'sscc_no', ls_pallet_Id)
			lds_label_data.setItem( ll_New_row, 'coo', ls_coo)
			lds_label_data.setItem( ll_New_row, 'print_x', string(ll_row))
			lds_label_data.setItem( ll_New_row, 'print_y', string(UpperBound(ls_str_serial_data.String_arg[])))
		NEXT
		
		//empty str_parms
		lstr_serialList =ls_str_empty
		ls_str_serial_data = ls_str_empty
	NEXT
END IF

//Preparing print Label Data against above created data store.
llRowCount =lds_label_data.rowcount( )
For llRowPos = 1 to llRowCount
	lsCurrentLabel= lsLabel
	lsCurrentLabel = iu_labels.uf_replace(lsCurrentLabel,"~~label_name~~", lds_label_data.getItemString( llRowPos, 'label_text'))
	lsCurrentLabel = iu_labels.uf_replace(lsCurrentLabel,"_7eserial_5fno_7e", lds_label_data.getItemString( llRowPos, 'serial_no'))

	lsCurrentLabel = iu_labels.uf_replace(lsCurrentLabel,"~~pallet_id~~", lds_label_data.getItemString( llRowPos, 'pallet_id'))
	lsCurrentLabel = iu_labels.uf_replace(lsCurrentLabel,"~~print_x_of_y~~", lds_label_data.getItemString( llRowPos, 'print_x') +' OF '+ lds_label_data.getItemString( llRowPos, 'print_y'))
	
	lsLabelPrint += lsCurrentLabel
NEXT

//Print Label
ll_Return =iu_labels.uf_print_label_data( 'Pandora 2D Barcode Pallet Labels ', lsLabelPrint)
	
//Reset Label Filter
dw_label.setfilter( "")
dw_label.filter( )
dw_label.rowcount( )

dw_label.SetRedraw(TRUE)
dw_label.SetSort(ls_Sort)
dw_label.Sort( )

destroy lds_label_data
end event

event ue_print_2d_carton_label();//28-JULY-2018 :Madhu S21780 Label Consolidation - Print Carton Label
//b. Print Carton Label, if Container Controlled Ind =Y and Serial No's exist

Str_Parms	lstrparms, lstrParms_containerId, lstr_serialList, ls_str_serial_data, ls_str_empty
long	llRowCount,	llRowPos, llPrintJob, ll_row, ll_cont_row, ll_New_row, ll_Return, ll_max_limit
String lsLabel, lsLabelPrint, lsPrintText, lsCurrentLabel, ls_pkg_Id, ls_sscc, ls_pallet_Id, ls_max_limit
String ls_sku, lsFormat, ls_coo, ls_Sort, lsFilter, ls_prev_container_Id , ls_container_Id
String lsSerialNo
long 	llSerialRows, llSerialRowPos, llRow
Datastore lds_label_data
lds_label_data =create Datastore
lds_label_data.dataobject ='d_pandora_2d_barcode_label_data'

dw_label.accepttext( )

//get MAX Limit of QR Barcode from Look Up Table
ls_max_limit =f_retrieve_parm(gs_project, 'QRBARCODE','MAX')
If IsNumber(ls_max_limit) Then ll_max_limit =long(ls_max_limit)

If rb_200.checked =True Then
	lsFormat = "Pandora_QR_Barcode_Label_200_DPI.txt"
else
	lsFormat = "Pandora_QR_Barcode_Label_300_DPI.txt"
End If

lsLabel = iu_labels.uf_read_label_Format(lsFormat)

If lsLabel = "" Then Return

dw_label.SetFilter("c_print_ind = 'Y'")
dw_label.Filter()

//since it is a container Label, sort selected records by container Id.
ls_Sort = "receive_putaway_po_no2, container_id"
dw_label.SetSort(ls_Sort)
dw_label.Sort( )
llRowCount = dw_label.RowCount()


For ll_row =1 to llRowCount
	ls_container_Id = dw_label.getItemstring( ll_row, 'container_id')
	IF ( ls_prev_container_Id <> ls_container_Id) THEN
		lstrParms_containerId.string_arg[UpperBound(lstrParms_containerId.string_arg) +1] = ls_container_Id
	END IF
	ls_prev_container_Id = ls_container_Id
Next

//get each container Id records from dw_label and loop through.
IF UpperBound(lstrParms_containerId.string_arg[]) > 0 THEN
	
	FOR ll_cont_row =1 to UpperBound(lstrParms_containerId.string_arg[])
		ls_container_Id =	lstrParms_containerId.string_arg[ll_cont_row]
		
		IF isvalid(w_ro) Then //Receiving
			w_ro.idw_putaway.setfilter("container_id ='"+ls_container_Id+"'")
			w_ro.idw_putaway.filter()
					
			FOR llRowPos = 1 to w_ro.idw_putaway.rowcount()
				ls_sku =trim(w_ro.idw_putaway.getItemstring( llRowPos, 'sku'))
				ls_coo = left(w_ro.idw_putaway.getItemstring( llRowPos, 'country_of_origin'),2)
				ls_pallet_Id = trim(w_ro.idw_putaway.getItemstring( llRowPos, 'po_no2'))
				If w_ro.idw_rma_serial.RowCount() > 0 Then
					w_ro.idw_rma_serial.SetFilter("container_id ='"+ls_container_Id+"'")
					w_ro.idw_rma_serial.filter()
					llSerialRows = w_ro.idw_rma_serial.RowCount()
					llRow = 1		//If SerialNumberIsNull do not print
					For llSerialRowPos = 1 to llSerialRows 
						lsSerialNo = trim(w_ro.idw_rma_serial.getItemstring( llSerialRowPos, 'serial_no')) //get serial No
						If Not isNull(lsSerialNo) Then
							lstr_serialList.string_arg[llRow] = lsSerialNo
							llRow++
						End If
					Next
				Else
					lstr_serialList.string_arg[llRowPos] = trim(w_ro.idw_putaway.getItemstring( llRowPos, 'serial_no')) //get serial No
				End If
			Next
			
			w_ro.idw_putaway.setfilter("")
			w_ro.idw_putaway.filter()
			w_ro.idw_rma_serial.setfilter("")
			w_ro.idw_rma_serial.filter()
			
		ELSEIF isvalid(w_tran) THEN //Transfer
			w_tran.idw_detail.setfilter("container_id ='"+ls_container_Id+"'")
			w_tran.idw_detail.filter()
					
			FOR llRowPos = 1 to w_tran.idw_detail.rowcount()
				ls_sku =trim(w_tran.idw_detail.getItemstring( llRowPos, 'sku'))
				ls_coo = left(w_tran.idw_detail.getItemstring( llRowPos, 'country_of_origin'),2)
				lstr_serialList.string_arg[llRowPos] = trim(w_tran.idw_detail.getItemstring( llRowPos, 'serial_no')) //get serial No
				ls_pallet_Id = trim(w_tran.idw_detail.getItemstring( llRowPos, 'po_no2'))
			Next
			
			w_tran.idw_detail.setfilter("")
			w_tran.idw_detail.filter()

		ELSEIF isvalid(w_owner_change) THEN //Owner change
			w_owner_change.idw_detail.setfilter("container_id ='"+ls_container_Id+"'")
			w_owner_change.idw_detail.filter()
					
			FOR llRowPos = 1 to w_owner_change.idw_detail.rowcount()
				ls_sku =trim(w_owner_change.idw_detail.getItemstring( llRowPos, 'sku'))
				ls_coo = left(w_owner_change.idw_detail.getItemstring( llRowPos, 'country_of_origin'),2)
				lstr_serialList.string_arg[llRowPos] = trim(w_owner_change.idw_detail.getItemstring( llRowPos, 'serial_no')) //get serial No
				ls_pallet_Id = trim(w_owner_change.idw_detail.getItemstring( llRowPos, 'po_no2'))
			Next
			
			w_owner_change.idw_detail.setfilter("")
			w_owner_change.idw_detail.filter()
		End IF
		
		//split SN's against size of PDF417 limit and return required labels count
		ls_str_serial_data = iu_labels.uf_split_serialno_by_length( lstr_serialList , ll_max_limit)
		
		//generate SSCC No.
		ls_sscc = iu_labels.uf_generate_sscc( ls_container_Id)
				
		For ll_row =1 to UpperBound(ls_str_serial_data.String_arg[])
			ll_New_row =lds_label_data.insertrow( 0)
			lds_label_data.setItem( ll_New_row, 'sku', ls_sku)
			lds_label_data.setItem( ll_New_row, 'carton_id', ls_container_Id)
			lds_label_data.setItem( ll_New_row, 'label_text', "CARTON LABEL")
			lds_label_data.setItem( ll_New_row, 'serial_no', ls_str_serial_data.String_arg[ll_row])
			lds_label_data.setItem( ll_New_row, 'sscc_no', ls_container_Id)	//	GailM 11/14/2018	DE7236 Changed SSCC on label from ls_pallet_Id to ls_container_id

			lds_label_data.setItem( ll_New_row, 'coo', ls_coo)
			lds_label_data.setItem( ll_New_row, 'print_x', string(ll_row))
			lds_label_data.setItem( ll_New_row, 'print_y', string(UpperBound(ls_str_serial_data.String_arg[])))
		NEXT
		
		//empty str_parms
		lstr_serialList =ls_str_empty
		ls_str_serial_data = ls_str_empty
	NEXT
END IF

//Preparing print Label Data against above created data store.
llRowCount =lds_label_data.rowcount( )
For llRowPos = 1 to llRowCount
	lsCurrentLabel= lsLabel
	lsCurrentLabel = iu_labels.uf_replace(lsCurrentLabel,"~~label_name~~", lds_label_data.getItemString( llRowPos, 'label_text'))
	lsCurrentLabel = iu_labels.uf_replace(lsCurrentLabel,"_7eserial_5fno_7e", lds_label_data.getItemString( llRowPos, 'serial_no'))

	lsCurrentLabel = iu_labels.uf_replace(lsCurrentLabel,"~~pallet_id~~", lds_label_data.getItemString( llRowPos, 'sscc_no'))
	lsCurrentLabel = iu_labels.uf_replace(lsCurrentLabel,"~~print_x_of_y~~", lds_label_data.getItemString( llRowPos, 'print_x') +' OF '+ lds_label_data.getItemString( llRowPos, 'print_y'))
	
	lsLabelPrint += lsCurrentLabel
NEXT

//Print Label
ll_Return =iu_labels.uf_print_label_data( 'Pandora 2D Barcode Carton Labels ', lsLabelPrint)
	
//Reset Label Filter
dw_label.setfilter( "")
dw_label.filter( )
dw_label.rowcount( )

dw_label.SetRedraw(TRUE)
dw_label.SetSort(ls_Sort)
dw_label.Sort( )

destroy lds_label_data
end event

event ue_print_2d_pallet_carton_label();//28-JULY-2018 :Madhu S21780 Label Consolidation - Nested Pallet Carton Label
// Print Nested Container ID Label, if PoNo2 associated with multiple Container Id's.

Str_Parms lstrParms_palletId, lstrParms_containerId, ls_str_empty
long	llRowCount,	ll_row, ll_cont_row, ll_Return, ll_print_x
String lsLabel, lsLabelPrint, lsPrintText, lsCurrentLabel
String lsFormat, ls_Sort, ls_label_data, ls_replace_data
String ls_pallet_Id, ls_prev_pallet_Id, ls_container_id, ls_prev_container_id

long ll_pallet_row, ll_row_count, ll_remain_count, ll_label_count, ll_cont_id, ll_replace_row

IF rb_200.checked = True THEN
	lsFormat = "Pandora_Nested_Pallet_Carton_Label_200_DPI.txt"
	ls_replace_data ="^B3R,N,68,N,N^FD~~container_id_"
ELSE
	lsFormat = "Pandora_Nested_Pallet_Carton_Label_300_DPI.txt"
	ls_replace_data ="^B3R,N,100,N,N^FD~~container_id_"
END IF

lsLabel = iu_labels.uf_read_label_Format(lsFormat)

IF lsLabel = "" Then Return
lsCurrentLabel= lsLabel //read current label

dw_label.accepttext( )
dw_label.SetFilter("c_print_ind = 'Y' and item_master_po_no2_controlled_ind ='Y' and item_master_container_tracking_ind ='Y' ")
dw_label.Filter()

//since it is a Nested Pallet container Label, sort selected records by Pallet and container Id.
ls_Sort = "receive_putaway_po_no2, container_id"
dw_label.SetSort(ls_Sort)
dw_label.Sort( )
llRowCount = dw_label.RowCount()

//get distinct Pallet Id
For ll_row =1 to llRowCount
	ls_pallet_Id = dw_label.getItemstring( ll_row, 'receive_putaway_po_no2')
	IF ( ls_prev_pallet_Id <> ls_pallet_Id) THEN
		lstrParms_palletId.string_arg[UpperBound(lstrParms_palletId.string_arg) +1] = ls_pallet_Id
	END IF
	ls_prev_pallet_Id = ls_pallet_Id
Next

//get distinct container Id list against each Pallet Id
IF UpperBound(lstrParms_palletId.string_arg[]) > 0 Then

	For ll_pallet_row = 1 to UpperBound(lstrParms_palletId.string_arg[])
		
		lsCurrentLabel= lsLabel //re-set label format
		ls_pallet_Id = lstrParms_palletId.string_arg[ll_pallet_row]
		
		//reset filter
		dw_label.SetFilter("")
		dw_label.Filter()
		
		//apply filter
		dw_label.SetFilter("c_print_ind = 'Y' and receive_putaway_po_no2 ='"+ls_pallet_Id+"'")
		dw_label.Filter()
		
		//get distinct container Id
		For ll_row =1 to dw_label.rowcount( )
			ls_container_Id = dw_label.getItemstring( ll_row, 'container_id')
			IF ( ls_prev_container_Id <> ls_container_Id) THEN
				lstrParms_containerId.string_arg[UpperBound(lstrParms_containerId.string_arg) +1] = ls_container_Id
			END IF
			ls_prev_container_Id = ls_container_Id
		Next
		
		//determine how many labels are required (x of y)
		ll_label_count =0
		ll_cont_id = 0
		ll_print_x = 1
		ll_remain_count = UpperBound(lstrParms_containerId.string_arg[])
		
		DO WHILE ll_remain_count > 0 
			ll_label_count++
			ll_remain_count = ll_remain_count -7
		LOOP
		
		FOR ll_cont_row = 1 to UpperBound(lstrParms_containerId.string_arg[])
		
			//each label print only 7 carton No's, If it exceeds push to next label.
			If ll_cont_id > 6  then 	
				lsLabelPrint += lsCurrentLabel
				lsCurrentLabel= lsLabel
				ll_cont_id = 1
				ll_print_x++
			else
				ll_cont_id++
			end If
			
			ls_label_data ="~~container_id_"+string(ll_cont_id)+"~~"
			
			//replace label data
			lsCurrentLabel = iu_labels.uf_replace(lsCurrentLabel, "~~pallet_id~~" , ls_pallet_Id)
			lsCurrentLabel = iu_labels.uf_replace(lsCurrentLabel, ls_label_data , lstrParms_containerId.string_arg[ll_cont_row])
			lsCurrentLabel = iu_labels.uf_replace(lsCurrentLabel, "~~print_x_of_y~~" , string(ll_print_x) +' OF '+ string(ll_label_count))
		NEXT
		
		 //make Invisible
		FOR ll_replace_row = ll_cont_id+1 to 7

			//replace label data
			ls_label_data =ls_replace_data+string(ll_replace_row)+"~~^FS"
			lsCurrentLabel = iu_labels.uf_replace(lsCurrentLabel, ls_label_data ,"^FD^FS")
		NEXT
		
		//empty str_parms
		lstrParms_containerId =ls_str_empty
		lsLabelPrint += lsCurrentLabel
	NEXT
End IF

//Print Label
ll_Return =iu_labels.uf_print_label_data( 'Pandora Nested Pallet Container Id Labels ', lsLabelPrint)
	
//Reset Label Filter
dw_label.setfilter( "")
dw_label.filter( )
dw_label.rowcount( )

dw_label.SetRedraw(TRUE)
dw_label.SetSort(ls_Sort)
dw_label.Sort( )
end event

event ue_print_part_child_label();//25-JULY-2018 :Madhu S21780 Label consolidation - Print Inventory Part Child Labels

string ls_sort, ls_sku, ls_label_print, ls_filter, ls_child_label, ls_child_format, ls_Child_Current_Label
string ls_Child_SKU1, ls_Child_Serial_Number1, ls_Child_SKU2, ls_Child_Serial_Number2, ls_Child_SKU3, ls_Child_Serial_Number3
string	ls_Child_SKU4, 	ls_Child_Serial_Number4, ls_serial_no, ls_xofy, lslabelprint

long ll_Row, ll_Row_Count, ll_component_no, ll_Number_Of_Children, ll_Child_Label_Counter, ll_x, ll_y, ll_Return

//datetime ldt_exp_date

n_labels_pandora lu_child_labels
lu_child_labels  = Create n_labels_pandora

dw_label.accepttext( )

//remove filter, if any
dw_label.setfilter( "")
dw_label.filter( )

//read label format
ls_child_format = "PANDORA_child_PART_LABEL_XOFY.txt"
ls_child_label = lu_Child_Labels.uf_read_label_Format(ls_child_format)
If ls_child_label ="" Then Return
	
dw_label.setfilter( "c_print_ind ='Y'")
dw_label.filter( )

ls_sort = "Line_item_no, l_code, sku_parent, sku, container_id"
dw_label.setsort( ls_sort)
dw_label.sort( )

//Print each detail Row
ll_Row_Count = dw_label.rowcount( )

//Loop through each record
For ll_Row = 1 to ll_Row_Count
	
	ll_component_no = dw_label.GetItemNumber(ll_Row,'Component_no') //component No
	ls_filter = 'SKU <> SKU_Parent and  Component_no='+trim(String(ll_component_no))
	dw_label.SetFilter(ls_filter)
	dw_label.Filter()
	
	ll_Number_Of_Children = dw_label.RowCount()
	ll_Child_Label_Counter = 0
	ll_y =  ll_Number_Of_Children / 3
	
	If Mod(ll_Number_Of_Children,  3 ) > 0 Then ll_y = ll_y + 1
	
	For ll_x = 1 To ll_y
	
		ls_Child_Current_Label = ls_child_label
		
		ls_Child_SKU1					= 	''
		ls_Child_Serial_Number1		= 	''			  
		ls_Child_SKU2					=	''
		ls_Child_Serial_Number2 	=	''				 
		ls_Child_SKU3 					=	''
		ls_Child_Serial_Number3		=	''			 
		ls_Child_SKU4					=	''
		ls_Child_Serial_Number4		=	''
		
		ll_Child_Label_Counter =  ll_Child_Label_Counter + 1
		
		IF ll_Child_Label_Counter <=	ll_Number_Of_Children Then
			ls_Child_SKU1					= 	dw_label.GetITemString(	ll_Child_Label_Counter, 'sku')
			ls_Child_Serial_Number1		=	dw_label.GetITemString( ll_Child_Label_Counter, 'serial_no')
		End If
		
		ll_Child_Label_Counter =  ll_Child_Label_Counter + 1
		
		IF ll_Child_Label_Counter <=	ll_Number_Of_Children Then
			ls_Child_SKU2					=	dw_label.GetITemString( ll_Child_Label_Counter,	'sku')
			ls_Child_Serial_Number2 	=	dw_label.GetITemString( ll_Child_Label_Counter,	'serial_no')
		End If
		
		ll_Child_Label_Counter =  ll_Child_Label_Counter + 1
		
		IF ll_Child_Label_Counter <=	ll_Number_Of_Children Then
			ls_Child_SKU3 					=	dw_label.GetITemString(ll_Child_Label_Counter,	'sku')
			ls_Child_Serial_Number3		=	dw_label.GetITemString(ll_Child_Label_Counter,	'serial_no')
		End If  
		
		ls_Child_Current_Label 	= lu_Child_Labels.uf_replace(ls_Child_Current_Label,"~~PARENTSKUTEXT~~", ls_SKU) /* Parent Part*/
		ls_Child_Current_Label 	= lu_Child_Labels.uf_replace(ls_Child_Current_Label,"~~PARENTSKUBARCODE~~", ls_SKU) /* Parent Barcoded Part*/
		
		ls_Child_Current_Label	= lu_Child_Labels.uf_replace(ls_Child_Current_Label,"~~PARENTSERIALNUMBERTEXT~~", ls_serial_no) /* Parent Serial*/
		ls_Child_Current_Label 	= lu_Child_Labels.uf_replace(ls_Child_Current_Label,"~~PARENTSERIALNUMBERBARCODE~~", ls_serial_no) /* Parent Barcoded Serial*/
		
		ls_Child_Current_Label 	= lu_Child_Labels.uf_replace(ls_Child_Current_Label ,'~~CHILDSKU1~~', ls_Child_SKU1 ) /* Part*/
		ls_Child_Current_Label	= lu_Child_Labels.uf_replace(ls_Child_Current_Label ,"~~CHILDSKUBARCODE1~~", ls_Child_SKU1 ) /* Barcoded Part*/
		
		ls_Child_Current_Label 	= lu_Child_Labels.uf_replace(ls_Child_Current_Label,"~~CHILDSERIAL1~~", ls_Child_Serial_Number1) /* Serial*/
		ls_Child_Current_Label	= lu_Child_Labels.uf_replace(ls_Child_Current_Label,"~~CHILDSERIALBARCODE1~~", ls_Child_Serial_Number1) /* Barcoded Serial*/
		
		ls_Child_Current_Label 	= lu_Child_Labels.uf_replace(ls_Child_Current_Label ,'~~CHILDSKU2~~', ls_Child_SKU2 ) /* Part*/
		ls_Child_Current_Label	= lu_Child_Labels.uf_replace(ls_Child_Current_Label ,"~~CHILDSKUBARCODE2~~", ls_Child_SKU2 ) /* Barcoded Part*/
		
		ls_Child_Current_Label 	= lu_Child_Labels.uf_replace(ls_Child_Current_Label,"~~CHILDSERIAL2~~", ls_Child_Serial_Number2) /* Serial*/
		ls_Child_Current_Label	= lu_Child_Labels.uf_replace(ls_Child_Current_Label,"~~CHILDSERIALBARCODE2~~", ls_Child_Serial_Number2) /* Barcoded Serial*/
		
		ls_Child_Current_Label 	= lu_Child_Labels.uf_replace(ls_Child_Current_Label ,'~~CHILDSKU3~~', ls_Child_SKU3 ) /* Part*/
		ls_Child_Current_Label	= lu_Child_Labels.uf_replace(ls_Child_Current_Label ,"~~CHILDSKUBARCODE3~~", ls_Child_SKU3 ) /* Barcoded Part*/
		
		ls_Child_Current_Label 	= lu_Child_Labels.uf_replace(ls_Child_Current_Label,"~~CHILDSERIAL3~~", ls_Child_Serial_Number3) /* Serial*/
		ls_Child_Current_Label	= lu_Child_Labels.uf_replace(ls_Child_Current_Label,"~~CHILDSERIALBARCODE3~~", ls_Child_Serial_Number3) /* Barcoded Serial*/
		
		ls_XOFY = String( ll_x ) + ' Of ' +String( ll_y)	
		
		ls_Child_Current_Label 	= lu_Child_Labels.uf_replace(ls_Child_Current_Label,"~~Box~~",ls_XOFY )
		ls_label_print += ls_Child_Current_Label	
		
	Next
	
	dw_label.SetFilter("c_print_ind = 'Y'")
	dw_label.Filter()
	
Next

//Print Label
ll_Return =iu_labels.uf_print_label_data( 'Pandora 2D Barcode Pallet Labels ', ls_label_print)
	
//Reset Label Filter
IF cbx_show_comp.Checked Then
	dw_label.setfilter( "")
	dw_label.filter( )
else
	dw_label.SetFilter('SKU = SKU_Parent')	
	dw_label.Filter()
End If
	
dw_label.rowcount( )

dw_label.SetRedraw(TRUE)
dw_label.SetSort(ls_Sort)
dw_label.Sort( )

// Destroy the country object.
destroy lu_child_labels
end event

public function str_parms uf_split_serialno_by_length (any asseriallist, long allength);str_parms ls_str_parms, ls_str_serial
string ls_serial_concat, ls_prev_serial_concat, ls_serial_no, ls_new_serialNo
boolean lbNextCarton
long llRowPos, ll_serial_length, ll_total_carton_count, llRowCount

ls_str_serial =asseriallist
llRowCount = upperBound(asseriallist)
FOR llRowPos =1 to llRowCount

			
			ls_prev_serial_concat = ls_serial_concat	
			ls_serial_no = ls_str_serial.string_arg[llRowPos]
//			ls_serial_no = asseriallist[llRowPos]
			ls_serial_concat += ls_serial_no //concat serial No
			
			ll_serial_length =len(ls_serial_concat)
			If ll_serial_length <= allength Then
				ls_serial_concat +=","
				lbNextCarton = False
				
			else
				lbNextCarton = True
			End If

			If lbNextCarton Then
				ls_new_serialNo = Left(ls_prev_serial_concat, len(ls_prev_serial_concat) -1) //remove comma at the end
				llRowPos = llRowPos -1 //starts from previous row
				ll_total_carton_count++
				ls_prev_serial_concat =''
				ls_serial_concat =''
				ls_str_parms.string_arg[UpperBound(ls_str_parms.string_arg[])+ 1] =ls_new_serialNo
			End If
			
			//generate label for any left over serial no's
			If (llRowPos = llRowCount) and lbNextCarton =False Then
				ls_new_serialNo = Left(ls_serial_concat, len(ls_serial_concat) -1) //remove comma at the end
				ll_total_carton_count++
				ls_str_parms.string_arg[UpperBound(ls_str_parms.string_arg[])+ 1] =ls_new_serialNo
			End If
			
			//ls_coo = left(dw_label.getItemstring( llRowPos, 'country_of_origin'),2)
		NEXT
return ls_str_parms
end function

on w_pandora_part_label_print.create
int iCurrent
call super::create
this.cb_print=create cb_print
this.cb_selectall=create cb_selectall
this.cb_clear=create cb_clear
this.cbx_show_comp=create cbx_show_comp
this.cbx_part_label=create cbx_part_label
this.cbx_2d_barcode=create cbx_2d_barcode
this.gb_1=create gb_1
this.dw_label=create dw_label
this.rb_200=create rb_200
this.rb_300=create rb_300
this.cbx_delta_label=create cbx_delta_label
this.cbx_pallet_label=create cbx_pallet_label
this.cbx_carton_label=create cbx_carton_label
this.cbx_nested_label=create cbx_nested_label
this.gb_2d_barcode=create gb_2d_barcode
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_print
this.Control[iCurrent+2]=this.cb_selectall
this.Control[iCurrent+3]=this.cb_clear
this.Control[iCurrent+4]=this.cbx_show_comp
this.Control[iCurrent+5]=this.cbx_part_label
this.Control[iCurrent+6]=this.cbx_2d_barcode
this.Control[iCurrent+7]=this.gb_1
this.Control[iCurrent+8]=this.dw_label
this.Control[iCurrent+9]=this.rb_200
this.Control[iCurrent+10]=this.rb_300
this.Control[iCurrent+11]=this.cbx_delta_label
this.Control[iCurrent+12]=this.cbx_pallet_label
this.Control[iCurrent+13]=this.cbx_carton_label
this.Control[iCurrent+14]=this.cbx_nested_label
this.Control[iCurrent+15]=this.gb_2d_barcode
end on

on w_pandora_part_label_print.destroy
call super::destroy
destroy(this.cb_print)
destroy(this.cb_selectall)
destroy(this.cb_clear)
destroy(this.cbx_show_comp)
destroy(this.cbx_part_label)
destroy(this.cbx_2d_barcode)
destroy(this.gb_1)
destroy(this.dw_label)
destroy(this.rb_200)
destroy(this.rb_300)
destroy(this.cbx_delta_label)
destroy(this.cbx_pallet_label)
destroy(this.cbx_carton_label)
destroy(this.cbx_nested_label)
destroy(this.gb_2d_barcode)
end on

event ue_postopen;call super::ue_postopen;
invo_labels = Create n_labels
i_nwarehouse = Create n_warehouse
iu_labels = Create n_labels_pandora

cb_print.Enabled = False
cbx_delta_label.checked = False
cbx_pallet_label.checked = False
cbx_carton_label.checked = False
cbx_nested_label.checked = False

//GailM 4/5/2018 S17648 F7366 I712 PDA SIMS new version of the label for 300 DPI in ZPL
// Initialize label resolution to 200dpi
rb_200.checked = True

//TAM 02/2017 - Added Part Label Print from a transfer order as well.
//TAM 04/2017 - Added Part Label Print from a SOC order as well.
IF not isvalid(w_ro) and not isvalid(w_tran) and not isvalid(w_owner_change) Then
	Messagebox("Labels","You must have an open Receiving Order, Transfer Order or SOC to print part labels.")
End If

//If W_RO is open then the dw_label is the default
IF isvalid(w_ro) and not isvalid(w_owner_change) and not isvalid(w_tran) Then //If Inbound open its DW

	if f_retrieve_parm("PANDORA", "FOOTPRINT", "FOOTPRINT_LABELS" ,"USER_UPDATEABLE_IND") = 'N'  then
		dw_label.dataobject = 'd_pandora_part_labels_no_label_consolidation'
	else
		dw_label.dataobject = 'd_pandora_part_labels_nolock'
	end if

	dw_label.settransobject( sqlca ) 

ElseIF not isvalid(w_ro) and not isvalid(w_owner_change) and isvalid(w_tran) Then //If Transfer open its DW
	dw_label.dataobject = 'd_pandora_part_labels_transfer_nolock'
	dw_label.settransobject( sqlca ) 
ElseIF not isvalid(w_ro) and not isvalid(w_tran) and isvalid(w_owner_change) Then //If OC open  its DW
	dw_label.dataobject = 'd_pandora_part_labels_owner_change_nolock'
	dw_label.settransobject( sqlca ) 
Else
	IF isvalid(w_tran) and isvalid(w_owner_change) Then //Can't have a transfer and and SOC open
		Messagebox("Labels","A Transfer Order and SOC are both Open.  You must close one of those to print part labels.")
	End If
End If
	
isOrigSql = dw_label.GetSqlSelect()

This.TriggerEvent('ue_retrieve')
end event

event ue_retrieve;call super::ue_retrieve;String ls_ro_no

// TAM 02/2017 - Added Print from a transfer order as well
// TAM 02/2017 - Added Print from a SOC order as well
//If not isvalid(w_ro) and not isvalid(w_tran) Then Return
If not isvalid(w_ro) and not isvalid(w_tran) and not isvalid(w_owner_change) Then Return

If isvalid(w_ro) Then
	If w_ro.idw_main.RowCount() < 1 then return
	dw_label.Retrieve(w_ro.idw_main.GetITemString(1,'ro_no'))
	
	//28-JULY-2018 :Madhu S21780 check Default Labels
	If w_ro.ib_vendor_label_compliant Then 
		cbx_delta_label.checked = True

	elseIf dw_label.find( "item_master_po_no2_controlled_ind ='Y' ", 1, dw_label.rowcount( )) > 0 Then
		cbx_pallet_label.checked = True
		
	elseIf dw_label.find( "item_master_container_tracking_ind ='Y' ", 1, dw_label.rowcount( )) > 0 Then
		cbx_carton_label.checked = True
	End If
	
Else
	If isvalid(w_tran) Then
		If w_tran.idw_main.RowCount() < 1 then return
		dw_label.Retrieve(w_tran.idw_main.GetITemString(1,'to_no'))
	Else
		If isvalid(w_owner_change) Then
			If w_owner_change.idw_main.RowCount() < 1 then return
			dw_label.Retrieve(w_owner_change.idw_main.GetITemString(1,'to_no'))
		End If
	End If
End If

dw_label.SetFilter('SKU = SKU_Parent')	
dw_label.Filter()

cb_print.Enabled = True

If isvalid(w_ro) Then
	ls_ro_no = w_ro.idw_main.GetITemString(1,'ro_no')

	Select TOP 1 Wh_code , Owner_Cd
	into :is_wh_code  , :is_own_cd
	From Receive_master Rm, Receive_Detail RD, Owner O
	where Rm.RO_No =RD.ro_no and 
		RD.owner_id =O.Owner_Id and 
		rm.ro_no =:ls_ro_no ;
Else
	If isvalid(w_tran) Then
		ls_ro_no = w_tran.idw_main.GetITemString(1,'to_no')
	Else
		ls_ro_no = w_owner_change.idw_main.GetITemString(1,'to_no')
	End If

	Select TOP 1 D_Warehouse , Owner_Cd
	into :is_wh_code  , :is_own_cd
	From Transfer_master Tm, Transfer_Detail TD, Owner O
	where Tm.TO_No =TD.To_no and 
		TD.owner_id =O.Owner_Id and 
		tm.to_no =:ls_ro_no ;
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
		 ls_SKU_Parent		= dw_label.GetItemString( llRowPos , "SKU_Parent"	) 
	 
		 If IsNull(  ls_SKU ) 			or Trim( ls_SKU ) = '' 			Then  ls_SKU = ''
		 If IsNull(   ls_SKU_Parent ) 	or Trim( ls_SKU_Parent ) = '' 	Then 	ls_SKU_Parent = ''
	 
		 If  ls_SKU <> '' and ls_SKU_Parent <> '' and   ls_SKU =  ls_SKU_Parent Then dw_label.SetITem(llRowPos,'c_print_ind','Y')
	 
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
		 ls_SKU_Parent		= dw_label.GetItemString( llRowPos , "SKU_Parent"	) 
	 
		 If IsNull(  ls_SKU ) 			or Trim( ls_SKU ) = '' 			Then  ls_SKU = ''
		 If IsNull(   ls_SKU_Parent ) 	or Trim( ls_SKU_Parent ) = '' 	Then 	ls_SKU_Parent = ''
	 
		If  ls_SKU <> '' and ls_SKU_Parent <> '' and   ls_SKU =  ls_SKU_Parent Then dw_label.SetITem(llRowPos,'c_print_ind','N')

	Next
	
End If

dw_label.SetRedraw(True)

cb_print.Enabled = True

end event

event resize;call super::resize;dw_label.Resize(workspacewidth() - 50,workspaceHeight()-250)
end event

event close;call super::close;IF ISVALID(i_nwarehouse) THEN Destroy(i_nwarehouse)
end event

type cb_cancel from w_main_ancestor`cb_cancel within w_pandora_part_label_print
boolean visible = false
integer x = 1938
integer y = 1392
integer height = 80
end type

type cb_ok from w_main_ancestor`cb_ok within w_pandora_part_label_print
integer x = 1211
integer y = 32
integer height = 80
integer textsize = -9
boolean default = false
end type

type cb_print from commandbutton within w_pandora_part_label_print
integer x = 841
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

type cb_selectall from commandbutton within w_pandora_part_label_print
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

type cb_clear from commandbutton within w_pandora_part_label_print
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

type cbx_show_comp from checkbox within w_pandora_part_label_print
integer x = 3982
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
string text = "Show Components"
end type

event clicked;IF cbx_show_comp.Checked Then
	dw_label.SetFilter('')	
	dw_label.Filter()
Else
	dw_label.	SetFilter('SKU = SKU_Parent')	
	dw_label.Filter()
End If




end event

type cbx_part_label from checkbox within w_pandora_part_label_print
integer x = 2194
integer y = 32
integer width = 407
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "&Part Label"
end type

type cbx_2d_barcode from checkbox within w_pandora_part_label_print
boolean visible = false
integer x = 3986
integer y = 96
integer width = 421
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "&2D Barcode"
end type

type gb_1 from groupbox within w_pandora_part_label_print
integer x = 1573
integer width = 549
integer height = 172
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Label Resolution"
end type

type dw_label from u_dw_ancestor within w_pandora_part_label_print
integer x = 9
integer y = 224
integer width = 4727
integer height = 1612
string dataobject = "d_pandora_part_labels_nolock"
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

type rb_200 from radiobutton within w_pandora_part_label_print
integer x = 1659
integer y = 48
integer width = 402
integer height = 52
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "200dpi"
end type

type rb_300 from radiobutton within w_pandora_part_label_print
integer x = 1659
integer y = 96
integer width = 343
integer height = 76
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "300dpi"
end type

type cbx_delta_label from checkbox within w_pandora_part_label_print
integer x = 2194
integer y = 124
integer width = 407
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "&Delta Label"
end type

type cbx_pallet_label from checkbox within w_pandora_part_label_print
integer x = 2752
integer y = 76
integer width = 425
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "&Pallet Label"
end type

type cbx_carton_label from checkbox within w_pandora_part_label_print
integer x = 3355
integer y = 76
integer width = 453
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "&Carton Label"
end type

type cbx_nested_label from checkbox within w_pandora_part_label_print
integer x = 2752
integer y = 140
integer width = 1051
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "&Nested Pallet Carton Label"
end type

type gb_2d_barcode from groupbox within w_pandora_part_label_print
integer x = 2670
integer width = 1289
integer height = 224
integer taborder = 20
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "2D Barcode"
end type

