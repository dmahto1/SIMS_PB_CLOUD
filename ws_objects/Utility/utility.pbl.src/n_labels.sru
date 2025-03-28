$PBExportHeader$n_labels.sru
$PBExportComments$Labels in native Printer Languages
forward
global type n_labels from nonvisualobject
end type
end forward

global type n_labels from nonvisualobject
end type
global n_labels n_labels

type variables
constant string isSSCC310 = '00885967'

integer iiLabelSequence
string isSSCCRawData
string isSSCCFormatted
String	isWarehouseSave
String	isUCCCompanyPrefix
String	isH2OUCCLabelFormat, iskendoShipLabelFormat, isGarminUCCLabelFormat, isRemaShipLabelFormat
String	isKendoUCCFormat
str_parms istrparms

protected:
string isLabelFormatFile
string isFormat
Boolean	ibPrinterSelected
String	isCustName, isAddress_1 ,isAddress_2,isAddress_3 ,isAddress_4 ,isCity ,isState ,isZip
end variables

forward prototypes
public function integer uf_nike_zebra_serial (ref any as_array)
public function integer uf_pulse_zebra_receive (ref any as_array)
public function integer uf_nike_zebra_part (ref any as_array)
public function integer uf_license_tag_intermec (ref any as_array)
public function integer uf_eni_zebra_ship (any as_array)
public function string uf_read_label_format (string asformat_name)
public function string uf_replace (string asstring, string asoldvalue, string asnewvalue)
public function integer uf_nike_zebra_ship (ref any as_array)
public function integer uf_license_tag_zebra (ref any as_array)
public function integer uf_generic_uccs_zebra (any as_array)
public function integer uf_linksys_zebra_ship (any as_array, string as_label)
public function integer uf_logitech_zebra_ship (any as_array, string as_label)
public function integer uf_license_tag_logitech (ref str_parms as_array)
public function integer uf_phx_brnds_zerba_ship (any as_array)
public function integer uf_valeo_blaster_part (ref any as_array, ref string as_labeltype)
public function integer uf_linksys_sqm_zebra_ship (any as_array, string as_label)
public function integer uf_phx_brands_wag_zebra_ship (any as_array, string aslabeltype)
public subroutine setlabelsequence (integer _value)
public function integer getlabelsequence ()
public function string getssccpos3to10 ()
public subroutine setssccvalues ()
public subroutine setssccrawdata (string _value)
public function string getssccrawdata ()
public subroutine setssccformatted (string _value)
public function string getssccformatted ()
public function string uf_replace (string asstring, string asoldvalue, string asnewvalue, integer ilength)
public function int print ()
public subroutine setparms (str_parms _parms)
public function str_parms getparms ()
public function string getlabelformat ()
public function integer setlabeladdress ()
public subroutine setlabelformat (string _format)
public subroutine setformat (string _format)
public function string getformat ()
public subroutine setlabelformatfile (string _format)
public function string getlabelformatfile ()
public function integer uf_scitex_zebra_ship (any as_array)
public function integer uf_bluecoat_shipping_intermec (any as_array)
public function integer uf_ingram_shipping_intermec (any as_array)
public function integer uf_generic_intermec_shipping_label (any as_array)
public function integer uf_sika_shipping_label_zebra (any as_array)
public function integer uf_emu_ceo_receiving_label ()
public function integer uf_license_tag_lam (ref str_parms _parms)
public function integer uf_lam_zebra_ship (any as_array)
public function integer uf_epson_zebra_ship ()
public function integer uf_runworld_zebra_ship (any as_array)
public function integer uf_pallet_do_info (any as_array)
public function integer uf_geistlich_bs_zebra_ship (any as_array)
public function integer uf_nyx_sscc_ship_label (any as_array)
public function string uf_write_label_format (string asformat_name, string asformat_newfile, string asbatfile, string asformatdata)
public function string uf_replace_label_text (string asstring, string asoldvalue, string asnewvalue)
public function integer uf_ariens_ucc_128_zerbra_ship ()
public function integer uf_friedrich_ucc_by_scan (integer ailine, string assku, string asserial)
public function string uf_friedrich_get_scc (string ascartonno, string asdono)
public function integer uf_friedrich_ucc_128_zebra_ship (any as_any)
public function string uf_ariens_get_scc (string ascartonno, string asdono)
public function integer uf_ariens_ucc_by_scan (integer ailine, string assku, string asserial, string ascarton)
public function integer uf_anki_uccs_zebra (any as_array)
public function integer uf_h2o_ucc_labels (any as_any)
public function integer uf_h2o_kohls_master (any as_any)
public function integer uf_kendo_ship (any as_any)
public function integer uf_garmin_ucc_labels (any as_any)
public function integer uf_pandora_shipping_label (any as_any)
public function integer uf_pandora_generic_shipping_label (any as_array)
public function integer uf_kendo_customer_ucc (any as_any)
public function any uf_bosch_ucc_128_zebra_ship (any as_any)
public function integer uf_rema_ship (any as_any)
public function integer uf_bosch_sscc_zebra (any as_any)
end prototypes

public function integer uf_nike_zebra_serial (ref any as_array);//This function will print  Nike serial Number labels for Zebra 

Str_parms	lStrparms
String	lsFormat,	&
			lsPrintText,	&
			lsStartingSN

Long	llPrintJob,	&
		llPrintQty,	&
		llPrintPos
		
		
Integer	liFileNo

lstrparms = as_array

//Load the format
lsFormat = uf_read_label_Format("Nike_zebra_serial.DWN")
lsPrintText = 'Nike Serial # Label'

//Format not loaded
If lsFormat = '' Then Return -1

//Open Printer File 
llPrintJob = PrintOpen(lsPrintText)
If llPrintJob <0 Then 
	Messagebox('Labels', 'Unable to open Printer file. Labels will not be printed')
	Return -1
End If

//Replace placeholders in Format with Field Values
	
//Starting Serial Number
lsStartingSN = "^SN" + lstrparms.String_arg[1] + ",1,Y"
lsFormat = uf_Replace(lsFormat,"~~serial_barcode,0010~~",lsStartingSN)

//Total Qty of labels to Print (multiply original requested qty * number per serial)
lsFormat = uf_Replace(lsFormat,"~~*QUANT,04~~",String(lstrparms.Long_Arg[1]))

//Copies of labels to Print (each Serial Number)
lsFormat = uf_Replace(lsFormat,"~~*COPIES,04~~",String(lstrparms.Long_Arg[2]))
	
//	//*** Debug Only
//	liFileNo = FileOpen("C:\temp\label.txt",StreamMode!,Write!,Shared!,Replace!)
//	FileWrite(liFileNo,lsFormat)
//	FileClose(liFileNo)
//	//*****

//Send to Printer
PrintSend(llPrintJob, lsformat)

PrintClose(llPrintJob)


Return 0
end function

public function integer uf_pulse_zebra_receive (ref any as_array);//This function will print  Nike Part label for Zebra 

Str_parms	lStrparms
String	lsFormat,	&
			lsCartonBarcode,	&
			lsTemp,				&
			lsPrintText,		&
			lsAddr

Long	llPrintJob,	&
		llPos,		&
		llPrintQty,	&
		llPrintPos,	&
		llCartonNo,	&
		llAddrPos
		
Integer	liFileNo

lstrparms = as_array

////Load the format
//lsFormat = uf_read_label_Format("Pulse_Zebra_Receive.DWN")
lsPrintText = 'Pulse Receiving Label'

lsFormat = lstrparms.String_Arg[1]

//Format not loaded
If lsFormat = '' Then Return -1

//Open Printer File 
llPrintJob = PrintOpen(lsPrintText)
If llPrintJob <0 Then 
	Messagebox('Labels', 'Unable to open Printer file. Labels will not be printed')
	Return -1
End If

//Replace placeholders in Format with Field Values
	
//Reference Nbr
lsFormat = uf_Replace(lsFormat,"~~REf_nbr,0020~~",Left(lstrparms.String_Arg[2],20))

//Expiration Date
lsFormat = uf_Replace(lsFormat,"~~exp_date,0012~~",Left(lstrparms.String_Arg[3],12))

//Inspection Code
lsFormat = uf_Replace(lsFormat,"~~inspection_cd,0005~~",Left(lstrparms.String_Arg[4],5))

//Storage Code
lsFormat = uf_Replace(lsFormat,"~~storage_cd,0005~~",Left(lstrparms.String_Arg[5],5))

//QTY/UOM
lsFormat = uf_Replace(lsFormat,"~~qty_uom,0018~~",Left(lstrparms.String_Arg[6],18))

//SKU
lsFormat = uf_Replace(lsFormat,"~~sku,0025~~",Left(lstrparms.String_Arg[7],25))

//PO NBR
lsFormat = uf_Replace(lsFormat,"~~po_nbr,0020~~",Left(lstrparms.String_Arg[8],20))

//ID NBR
lsFormat = uf_Replace(lsFormat,"~~ID_Nbr,0015~~",Left(lstrparms.String_Arg[9],15))

//Container ID
lsFormat = uf_Replace(lsFormat,"~~pkg_id,0015~~",Left(lstrparms.String_Arg[10],15))

//SKU Barcode
lsFormat = uf_Replace(lsFormat,"~~sku_barcode,0020~~",Left(lstrparms.String_Arg[7],20))

//Container ID barcode
lsFormat = uf_Replace(lsFormat,"~~pkg_id_barcode,0015~~",Left(lstrparms.String_Arg[10],15))

//Qty of labels to Print 
lsFormat = uf_Replace(lsFormat,"~~*QUANT,04~~",String(lstrparms.Long_Arg[1]))

//Copies of labels to Print 
lsFormat = uf_Replace(lsFormat,"~~*COPIES,04~~",String(lstrparms.Long_Arg[1]))

//Send to Printer
PrintSend(llPrintJob, lsformat)

PrintClose(llPrintJob)


Return 0
end function

public function integer uf_nike_zebra_part (ref any as_array);//This function will print  Nike Part label for Zebra 

Str_parms	lStrparms
String	lsFormat,	&
			lsCartonBarcode,	&
			lsTemp,				&
			lsPrintText,		&
			lsAddr

Long	llPrintJob,	&
		llPos,		&
		llPrintQty,	&
		llPrintPos,	&
		llCartonNo,	&
		llAddrPos
		
Integer	liFileNo

lstrparms = as_array

//Load the format
lsFormat = uf_read_label_Format("Nike_zebra_part.DWN")
lsPrintText = 'Nike part Label'

//Format not loaded
If lsFormat = '' Then Return -1

//Open Printer File 
llPrintJob = PrintOpen(lsPrintText)
If llPrintJob <0 Then 
	Messagebox('Labels', 'Unable to open Printer file. Labels will not be printed')
	Return -1
End If

//Replace placeholders in Format with Field Values
	
//Style
lsFormat = uf_Replace(lsFormat,"~~style,0006~~",Left(lstrparms.String_Arg[1],6))

//Color
lsFormat = uf_Replace(lsFormat,"~~color,0003~~",Left(lstrparms.String_Arg[2],3))

//Flex
lsFormat = uf_Replace(lsFormat,"~~flex,0003~~",Left(lstrparms.String_Arg[3],3))

//Desc 
lsFormat = uf_Replace(lsFormat,"~~description,0025~~",Left(lstrparms.String_Arg[4],25))

//UPC 
lsFormat = uf_Replace(lsFormat,"~~upc_barcode,0011~~",Left(lstrparms.String_Arg[5],11))

//Qty of labels to Print 
lsFormat = uf_Replace(lsFormat,"~~*QUANT,04~~",String(lstrparms.Long_Arg[1]))

//Copies of labels to Print 
lsFormat = uf_Replace(lsFormat,"~~*COPIES,04~~",String(lstrparms.Long_Arg[2]))

//Send to Printer
PrintSend(llPrintJob, lsformat)

PrintClose(llPrintJob)


Return 0
end function

public function integer uf_license_tag_intermec (ref any as_array);//This function will print  the License Tag for Intermec

Str_parms	lStrparms
String	lsFormat,	&
			lsFormat2,	&
			lsCartonBarcode,	&
			lsTemp,				&
			lsPrintText,		&
			lsAddr

Long	llPrintJob,	&
		llPos,		&
		llPrintQty,	&
		llPrintPos,	&
		llCartonNo,	&
		llAddrPos
		
Integer	liFileNo

DAteTime	ldtToday

ldtToday = DateTime(Today(),Now())

lstrparms = as_array

lsPrintText = 'License Tag Label'

lsFormat = lstrparms.String_Arg[1]	
//Format not loaded
If lsFormat = '' Then Return -1

//Open  Printer
llPrintJob = PrintOpen(lsPrintText)
If llPrintJob <0 Then 
	Messagebox('Labels', 'Unable to open Printer file. Labels will not be printed')
	Return -1
End If

//Replace placeholders in  DWN  FILE Format with Field Values   
//SKU
lsFormat = uf_Replace(lsFormat,"~~sku,0015~~",Left(lstrparms.String_Arg[4],20))
//Container ID
lsFormat = uf_Replace(lsFormat,"~~tag,0010~~",Right(lstrparms.String_Arg[6],10))
//misc_text3
lsFormat = uf_Replace(lsFormat,"~~misc_text3,0010~~","          ")
//HOLD
lsFormat = uf_Replace(lsFormat,"~~hold,0004~~","    ")

//Expiration Date
//3/20 - MikeA - DE15067 Remove EXP DT: for Kendo
IF upper(gs_project) ='KENDO' Then
	lsFormat = uf_Replace(lsFormat,"EXP DT:","") 
End IF

lsFormat = uf_Replace(lsFormat,"~~dt_expire,0010~~",Left(lstrparms.String_Arg[2],10))
//Lot NBR
lsFormat = uf_Replace(lsFormat,"~~lot,0015~~",Left(lstrparms.String_Arg[5],15))
//date Printed
lsFormat = uf_Replace(lsFormat,"~~dt_print,0010~~",String(ldtToday,'MM/DD/YYYY'))
//Location- misc_text2
lsFormat = uf_Replace(lsFormat,"~~misc_text2,0010~~",Left(lstrparms.String_Arg[8],10))
//UC3
lsFormat = uf_Replace(lsFormat,"~~uc3,0015~~","               ")
//UC2
lsFormat = uf_Replace(lsFormat,"~~uc2,0015~~","               ")
//UC1
lsFormat = uf_Replace(lsFormat,"~~uc1,0015~~","               ")
//misc_text1
lsFormat = uf_Replace(lsFormat,"~~misc_text1,0030~~","                              ")
//PKG
lsFormat = uf_Replace(lsFormat,"~~pkg,0006~~","      ")
//UOM
lsFormat = uf_Replace(lsFormat,"~~uom,0006~~",Left(lstrparms.String_Arg[7],6))
//QTY
lsFormat = uf_Replace(lsFormat,"~~qty,0013~~",Left(lstrparms.String_Arg[3],13))
//Description
lsFormat = uf_Replace(lsFormat,"~~sku_desc,0040~~",Left(lstrparms.String_Arg[9],40))
//Qty of labels to Print 
lsFormat = uf_Replace(lsFormat,"~~*QUANT,04~~",String(lstrparms.Long_Arg[1]))

//Send File to Printer
PrintSend(llPrintJob, lsformat)
PrintClose(llPrintJob)

Return 0
end function

public function integer uf_eni_zebra_ship (any as_array);//This function will print  ENI Shipping label for Zebra on 4x6 

Str_parms	lStrparms
String	lsFormat,	&
			lsCartonBarcode,	&
			lsTemp,				&
			lsPrintText,		&
			lsAddr,				&
			lsSKU,				&
			lsQty

Long	llPrintJob,	& 
		llPos,		&
		llPrintQty,	&
		llPrintPos,	&
		llCartonNo,	&
		llAddrPos
		
Integer	liFileNo

lstrparms = as_array

//Load the format 
lsFormat = uf_read_label_Format("ENI_zebra_ship_4x6.DWN")
lsPrintText = 'ENI Shipping 4x6'

lsTemp = lsFormat

//Format not loaded
If lsFormat = '' Then Return -1

//Open Printer File 
llPrintJob = PrintOpen(lsPrintText)
If llPrintJob <0 Then 
	Messagebox('Labels', 'Unable to open Printer file. Labels will not be printed')
	Return -1
End If

//Replace placeholders in Format with Field Values

//From Address - Roll up addresses if not all present

llAddrPos = 0

If lstrparms.String_Arg[2] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + ",0030~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[2],30))
End If

If lstrparms.String_Arg[3] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + ",0030~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[3],30))
End If

If lstrparms.String_Arg[4] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + ",0030~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[4],30))
End If

If lstrparms.String_Arg[5] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + ",0030~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[5],30))
End If

If lstrparms.String_Arg[6] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + ",0030~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[6],30))
End If

//To Address - Roll up addresses if not all present

llAddrPos = 0

If lstrparms.String_Arg[7] > ' ' Then
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + ",0045~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[7],45))
End If

If lstrparms.String_Arg[8] > ' ' Then
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + ",0045~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[8],45))
End If

If lstrparms.String_Arg[9] > ' ' Then
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + ",0045~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[9],45))
End If

If lstrparms.String_Arg[10] > ' ' Then
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + ",0045~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[10],45))
End If

If lstrparms.String_Arg[11] > ' ' Then
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + ",0045~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[11],45))
End If

If lstrparms.String_Arg[12] > ' ' Then
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + ",0045~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[12],45))
End If

If lstrparms.String_Arg[13] > ' ' Then
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + ",0045~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[13],45))
End If

//Cust Order Nbr 
lsFormat = uf_Replace(lsFormat,"~~cust_order,0020~~",left(lstrparms.String_Arg[14],20))

// SKU/QTY 1 - parse out '/'
lsSKU = Left(lstrparms.String_Arg[15],(pos(lstrparms.String_Arg[15],'/')) - 1)
lsQTY = Right(lstrparms.String_Arg[15],(len(lstrparms.String_Arg[15]) - pos(lstrparms.String_Arg[15],'/')))
lsFormat = uf_Replace(lsFormat,"~~sku_1,0030~~",lsSKU)
lsFormat = uf_Replace(lsFormat,"~~qty_1,0013~~",lsQTY)

// SKU/QTY 2
lsSKU = Left(lstrparms.String_Arg[16],(pos(lstrparms.String_Arg[16],'/')) - 1)
lsQTY = Right(lstrparms.String_Arg[16],(len(lstrparms.String_Arg[16]) - pos(lstrparms.String_Arg[16],'/')))
lsFormat = uf_Replace(lsFormat,"~~sku_2,0030~~",lsSKU)
lsFormat = uf_Replace(lsFormat,"~~qty_2,0013~~",lsQTY)

// SKU/QTY 3
lsSKU = Left(lstrparms.String_Arg[17],(pos(lstrparms.String_Arg[17],'/')) - 1)
lsQTY = Right(lstrparms.String_Arg[17],(len(lstrparms.String_Arg[17]) - pos(lstrparms.String_Arg[17],'/')))
lsFormat = uf_Replace(lsFormat,"~~sku_3,0030~~",lsSKU)
lsFormat = uf_Replace(lsFormat,"~~qty_3,0013~~",lsQTY)

// SKU/QTY 4
lsSKU = Left(lstrparms.String_Arg[18],(pos(lstrparms.String_Arg[18],'/')) - 1)
lsQTY = Right(lstrparms.String_Arg[18],(len(lstrparms.String_Arg[18]) - pos(lstrparms.String_Arg[18],'/')))
lsFormat = uf_Replace(lsFormat,"~~sku_4,0030~~",lsSKU)
lsFormat = uf_Replace(lsFormat,"~~qty_4,0013~~",lsQTY)

// SKU/QTY 5
lsSKU = Left(lstrparms.String_Arg[19],(pos(lstrparms.String_Arg[19],'/')) - 1)
lsQTY = Right(lstrparms.String_Arg[19],(len(lstrparms.String_Arg[19]) - pos(lstrparms.String_Arg[19],'/')))
lsFormat = uf_Replace(lsFormat,"~~sku_5,0030~~",lsSKU)
lsFormat = uf_Replace(lsFormat,"~~qty_5,0013~~",lsQTY)

// qty of labels to print
lsFormat = uf_Replace(lsFormat,"~~*QUANT,04~~",String(lstrparms.Long_Arg[1])) /*printer will print multiples of same label*/
llPrintQty = 1 /*only loop once*/

//Copies of Labels to Print
lsFormat = uf_Replace(lsFormat,"~~*COPIES,04~~",String(lstrparms.Long_Arg[2]))

//Send to Printer
PrintSend(llPrintJob, lsformat)


PrintClose(llPrintJob)

//Messagebox('??',lsFormat)

Return 0
end function

public function string uf_read_label_format (string asformat_name);
String	lsFormatData,	&
			lsFile
			
Integer	liFileNo

//Look in the labels sub-directory of the SIMS directory
//TimA 06/08/15 Added new global varable for path location of labels.

If gs_labelpath > '' Then
	lsFile = gs_labelpath  + asformat_name
else
	If gs_SysPath > '' Then
		lsFile = gs_syspath + 'labels\' + asformat_name
		//guido's local directory	gs_SysPath = "c:\pb7devl\sims32dev\" 
	Else
		lsFile = 'labels\' + asformat_name
	End If
End if

If Not FileExists(lsFile) Then
	Messagebox('Labels', 'Unable to load necessary label Format! - ' + lsfile)
	Return ''
End If

//Open the File - streammode will read entire file into 1 variable
liFileNo = FileOpen(lsFile,StreamMode!,Read!,Shared!)

If liFileNo < 0 Then
	Messagebox('Labels', 'Unable to load necessary label Format: "' + asFormat_Name + '"')
	Return ''
End If

FileRead(lifileNo, lsFormatData)
FileClose(liFileNo)
	if gs_project='GEISTLICH' then
		sleep(2)  
	end if // Dinesh - 11/23/2021 - DE24054- BOSH KENDO PRINTER ISSUE

//Messagebox('before',lsFormatData)

Return lsFormatData
end function

public function string uf_replace (string asstring, string asoldvalue, string asnewvalue);
String	lsString
Long	llPos


if isNull(asnewValue) Then Return asString

lsString = asString
llPos = Pos(lsString,asOldValue)

Do While llPos > 0 
	lsString = Replace(lsString,llPos,len(asOldValue), asNewValue) 
	llPos = Pos(lsString,asOldValue)
Loop

REturn lsString
end function

public function integer uf_nike_zebra_ship (ref any as_array);//This function will print  Nike Shipping label for Zebra on 4x6 or 4x4 depending on string_arg[1]

Str_parms	lStrparms
String	lsFormat,	&
			lsCartonBarcode,	&
			lsTemp,				&
			lsPrintText,		&
			lsAddr

Long	llPrintJob,	&
		llPos,		&
		llPrintQty,	&
		llPrintPos,	&
		llCartonNo,	&
		llAddrPos
		
Integer	liFileNo

lstrparms = as_array

//Load the format - String_arg[1] has the format - data is the same across label
Choose Case Upper(lstrParms.String_arg[1])
	Case 'A' /*4x6 Domestic*/
		lsFormat = uf_read_label_Format("Nike_zebra_ship_domestic_4x6.DWN")
		lsPrintText = 'Nike Shipping 4x6 (Domestic)'
	Case 'B' /*4x4 Domestic*/
		lsFormat = uf_read_label_Format("Nike_zebra_ship_domestic_4x4.DWN")
		lsPrintText = 'Nike Shipping 4x4 (Domestic)'
	Case 'C' /*4x4 International*/
		lsFormat = uf_read_label_Format("Nike_zebra_ship_international_4x4.DWN")
		lsPrintText = 'Nike Shipping 4x4 (International)'
End Choose

lsTemp = lsFormat

//Format not loaded
If lsFormat = '' Then Return -1

//Open Printer File 
llPrintJob = PrintOpen(lsPrintText)
If llPrintJob <0 Then 
	Messagebox('Labels', 'Unable to open Printer file. Labels will not be printed')
	Return -1
End If

//We are looping once for each Qty of label being printed - The carton number is changing so we need to bump after each one.
//The rest of the fields are static through the batch so only need to be replaced once - otherwise we would have to load the format each time

//Replace placeholders in Format with Field Values

//From Address - Roll up addresses if not all present

llAddrPos = 0

If lstrparms.String_Arg[2] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + ",0030~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[2],30))
End If

If lstrparms.String_Arg[3] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + ",0030~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[3],30))
End If

If lstrparms.String_Arg[4] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + ",0030~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[4],30))
End If

If lstrparms.String_Arg[5] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + ",0030~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[5],30))
End If

If lstrparms.String_Arg[6] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + ",0030~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[6],30))
End If

//To Address - Roll up addresses if not all present

llAddrPos = 0

If lstrparms.String_Arg[7] > ' ' Then
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + ",0045~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[7],45))
End If

If lstrparms.String_Arg[8] > ' ' Then
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + ",0045~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[8],45))
End If

If lstrparms.String_Arg[9] > ' ' Then
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + ",0045~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[9],45))
End If

If lstrparms.String_Arg[10] > ' ' Then
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + ",0045~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[10],45))
End If

If lstrparms.String_Arg[11] > ' ' Then
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + ",0045~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[11],45))
End If

If lstrparms.String_Arg[12] > ' ' Then
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + ",0045~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[12],45))
End If

If lstrparms.String_Arg[13] > ' ' Then
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + ",0045~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[13],45))
End If

//Carrier
lsFormat = uf_Replace(lsFormat,"~~carrier,0022~~",left(lstrparms.String_Arg[14],22))

//PO Nbr 
lsFormat = uf_Replace(lsFormat,"~~po_nbr,0015~~",left(lstrparms.String_Arg[15],15))
	
//PO ID 
lsFormat = uf_Replace(lsFormat,"~~poid,0015~~",Left(lstrparms.String_Arg[16],15))
	
//Color
lsFormat = uf_Replace(lsFormat,"~~color,0005~~",Left(lstrparms.String_Arg[17],5))

//Degree
lsFormat = uf_Replace(lsFormat,"~~degree,0005~~",left(lstrparms.String_Arg[18],5))

//Flex
lsFormat = uf_Replace(lsFormat,"~~flex,0005~~",Left(lstrparms.String_Arg[19],5))

//Style
lsFormat = uf_Replace(lsFormat,"~~style,0008~~",Left(lstrparms.String_Arg[20],8))

//uom
lsFormat = uf_Replace(lsFormat,"~~uom,0005~~",Left(lstrparms.String_Arg[21],5))

//Desc - May be split depending on length
If Len(lstrparms.String_Arg[22]) > 20 Then /*only first 20 will fit on first row*/
	lsFormat = uf_Replace(lsFormat,"~~desc1,0020~~",Left(lstrparms.String_Arg[22],20))
	lsFormat = uf_Replace(lsFormat,"~~desc2,0020~~",Right(lstrparms.String_arg[22],(len(lstrparms.String_arg[22]) - 20)))
Else
	lsFormat = uf_Replace(lsFormat,"~~desc1,0020~~",lstrparms.String_Arg[22])
	lsFormat = uf_Replace(lsFormat,"~~desc2,0020~~",' ')
End If

//Postal Code
lsFormat = uf_Replace(lsFormat,"~~postal_barcode,0008~~",Left(lstrparms.String_Arg[23],8))

//ISEG
lsFormat = uf_Replace(lsFormat,"~~iseg,0008~~",Left(lstrparms.String_Arg[25],8))

//Ship QTY
lsFormat = uf_Replace(lsFormat,"~~qty,0008~~",String(lstrparms.Long_Arg[3]))

//For the 2 Domestic labels, we need to bump carton Number so we'll loop (with qty of labels = 1 for each)
//For the International, there is no need to loop since we are not showing carton number - just set print qty - will be faster
Choose Case Upper(lstrParms.String_arg[1])
	Case 'A', 'B' /*Domestic*/
		lsFormat = uf_Replace(lsFormat,"~~*QUANT,04~~",'1') /*qty = 1, will loop*/
		llPrintQty = lstrparms.Long_Arg[1] /*loop for each qty bumping carton #*/
	Case 'C' /*4x4 International*/
		lsFormat = uf_Replace(lsFormat,"~~*QUANT,04~~",String(lstrparms.Long_Arg[1])) /*printer will print multiples of same label*/
		llPrintQty = 1 /*only loop once*/
End Choose

llCartonNo = Long(lstrparms.String_Arg[24]) /*Starting Carton # */

For llPrintPos = 1 to llPrintQty

	//Carton Nbr - If first time, replace. othwerwise we need to bump and replace - literal will not be present, find last carton used
	If llPrintPos = 1 then /*first label being printed*/
		lsFormat = uf_Replace(lsFormat,"~~carton_nbr,0009~~",string(llCartonNo,'000000000'))
	Else
		lsTemp = String(llCartonNo,'000000000')
		llCartonNo ++
		lsFormat = uf_Replace(lsFormat,lsTemp,string(llCartonNo,'000000000')) /*bump up and replace from previous value in format*/
	End If
	
	//Carton Barcode - Includes code type, package type, UCC Man ID and Carton Nbr - 
	If llPrintPos = 1 Then
		lsCartonbarcode = "(00) 0 0760778 " + string(llCartonNo,'000000000')
		lsFormat = uf_Replace(lsFormat,"~~carton_barcode,0022~~",lsCartonBarcode)
	Else
		lsTemp = lsCartonBarCode
		lsCartonbarcode = "(00) 0 0760778 " + string(llCartonNo,'000000000')
		lsFormat = uf_Replace(lsFormat,lsTemp,lsCartonBarcode)
	End If
	
	//Copies of Labels to Print
	lsFormat = uf_Replace(lsFormat,"~~*COPIES,04~~",String(lstrparms.Long_Arg[2]))

//	//*** Debug Only
//	liFileNo = FileOpen("C:\temp\label.txt",StreamMode!,Write!,Shared!,Replace!)
//	FileWrite(liFileNo,lsFormat)
//	FileClose(liFileNo)
//	//*****

	//Send to Printer
	PrintSend(llPrintJob, lsformat)

Next /*Next printed Label*/

PrintClose(llPrintJob)

//Messagebox('??',lsFormat)

Return 0
end function

public function integer uf_license_tag_zebra (ref any as_array);//This function will print  the License Tag for Zebra 

Str_parms	lStrparms
String	lsFormat,	&
			lsCartonBarcode,	&
			lsTemp,				&
			lsPrintText,		&
			lsAddr

Long	llPrintJob,	&
		llPos,		&
		llPrintQty,	&
		llPrintPos,	&
		llCartonNo,	&
		llAddrPos
		
Integer	liFileNo

DAteTime	ldtToday

ldtToday = DateTime(Today(),Now())

lstrparms = as_array

////Load the format
//lsFormat = uf_read_label_Format("Pulse_Zebra_Receive.DWN")
lsPrintText = 'License Tag Label'

lsFormat = lstrparms.String_Arg[1]

//Format not loaded
If lsFormat = '' Then Return -1

//Open Printer File 
llPrintJob = PrintOpen(lsPrintText)
If llPrintJob <0 Then 
	Messagebox('Labels', 'Unable to open Printer file. Labels will not be printed')
	Return -1
End If

//Replace placeholders in Format with Field Values
	
// 04/16 - PCONKL - Added mappings for new baseline Zebra format

//Expiration Date
lsFormat = uf_Replace(lsFormat,"~~dt_expire~~",Left(lstrparms.String_Arg[2],10))

//3/20 - MikeA - DE15067 Remove EXP DT: for Kendo
IF upper(gs_project) ='KENDO' Then
	lsFormat = uf_Replace(lsFormat,"EXP DT:","") 
End IF

lsFormat = uf_Replace(lsFormat,"~~exp_dt~~",Left(lstrparms.String_Arg[2],10)) /* new format*/

//QTY
lsFormat = uf_Replace(lsFormat,"~~qty~~",Left(lstrparms.String_Arg[3],13))
lsFormat = uf_Replace(lsFormat,"~~Qty~~",Left(lstrparms.String_Arg[3],13)) /* new format*/

//SKU
lsFormat = uf_Replace(lsFormat,"~~sku~~",Left(lstrparms.String_Arg[4],20))


//SKU Barcode
lsFormat = uf_Replace(lsFormat,"~~SKU_BARCODE~~",Left(lstrparms.String_Arg[4],20))
lsFormat = uf_Replace(lsFormat,"~~SKU_bc~~",Left(lstrparms.String_Arg[4],50)) /*new format*/

//Lot NBR
lsFormat = uf_Replace(lsFormat,"~~lot~~",Left(lstrparms.String_Arg[5],15))
lsFormat = uf_Replace(lsFormat,"~~lot_no~~",Left(lstrparms.String_Arg[5],50)) /* new format*/

//Container ID
lsFormat = uf_Replace(lsFormat,"~~tag~~",Right(lstrparms.String_Arg[6],10))

//TAM 2010/11/08  Add Container Barcode
lsFormat = uf_Replace(lsFormat,"~~tag_bc~~",Right(lstrparms.String_Arg[6],10))
lsFormat = uf_Replace(lsFormat,"~~container_id_bc~~",Left(lstrparms.String_Arg[6],15)) /* new format*/
 
//UOM
lsFormat = uf_Replace(lsFormat,"~~uom~~",Left(lstrparms.String_Arg[7],6))
lsFormat = uf_Replace(lsFormat,"~~UOM~~",Left(lstrparms.String_Arg[7],6)) /* new format*/

//Location
lsFormat = uf_Replace(lsFormat,"~~misc_text2~~",Left(lstrparms.String_Arg[8],10))


//Description
lsFormat = uf_Replace(lsFormat,"~~sku_desc~~",Left(lstrparms.String_Arg[9],40))
lsFormat = uf_Replace(lsFormat,"~~Description~~",Left(lstrparms.String_Arg[9],40)) /* new format*/

//date Printed
lsFormat = uf_Replace(lsFormat,"~~dt_print~~",String(ldtToday,'MM/DD/YYYY'))
lsFormat = uf_Replace(lsFormat,"~~print_date~~",String(ldtToday,'MM/DD/YYYY')) /* new format*/

////Serial barcode
//lsFormat = uf_Replace(lsFormat,"~~SERIAL_BARCODE~~",Left(lstrparms.String_Arg[6],15))

//Location
lsFormat = uf_Replace(lsFormat,"~~loc~~",Left(lstrparms.String_Arg[8],15))
lsFormat = uf_Replace(lsFormat,"~~location~~",Left(lstrparms.String_Arg[8],10)) /* new format*/

//04/16 - PCONKL - Added PO,PO2, Inv Type and Order Nbr
lsFormat = uf_Replace(lsFormat,"~~po_no~~",Left(lstrparms.String_Arg[14],50)) /* PO - new format*/
lsFormat = uf_Replace(lsFormat,"~~po_no2~~",Left(lstrparms.String_Arg[15],50)) /* PO2 - new format*/
lsFormat = uf_Replace(lsFormat,"~~inv_type~~",Left(lstrparms.String_Arg[16],50)) /* Inv Type - new format*/
lsFormat = uf_Replace(lsFormat,"~~order_nbr~~",Left(lstrparms.String_Arg[17],50)) /* Order Nbr - new format*/

//Qty of labels to Print 
lsFormat = uf_Replace(lsFormat,"~~*QUANT~~",String(lstrparms.Long_Arg[1]))

//Copies of labels to Print 
lsFormat = uf_Replace(lsFormat,"~~*COPIES~~",String(lstrparms.Long_Arg[1]))

//Send to Printer
PrintSend(llPrintJob, lsformat)

PrintClose(llPrintJob)


Return 0
end function

public function integer uf_generic_uccs_zebra (any as_array);
//This function will print  Generic UCCS Shipping label

Str_parms	lStrparms
String	lsFormat,	&
			lsCartonBarcode,	&
			lsTemp,				&
			lsPrintText,		&
			lsAddr,ls_weight,ls_temp,	&
			lsUCCCarton

Long	llPrintJob,	&
		llPos,		&
		llPrintQty,	&
		llPrintPos,	&
		llCartonNo,	&
		llAddrPos,i,j,ll_no_of_copies
		
Integer	liFileNo, liCheck


lstrparms = as_array

lsFormat = uf_read_label_Format('generic_zebra_ship_UCC.DWN') 
		
	
lsPrintText = 'UCCS Ship - Zebra'


//Open Printer File 
llPrintJob = PrintOpen(lsPrintText)
	
If llPrintJob <0 Then 
	Messagebox('Labels', 'Unable to open Printer file. Labels will not be printed')
	Return -1
End If

//We are looping once for each Qty of label being printed - The carton number is changing so we need to bump after each one.
//Replace placeholders in Format with Field Values

//From Address - Roll up addresses if not all present
	
llAddrPos = 0

If lstrparms.String_Arg[2] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + ",0030~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[2],30))
End If
	
If lstrparms.String_Arg[3] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + ",0030~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[3],30))
End If

If lstrparms.String_Arg[4] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + ",0030~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[4],30))
End If

If lstrparms.String_Arg[5] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + ",0030~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[5],30))
End If
	
If lstrparms.String_Arg[31] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + ",0030~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[31],45))
End If
	
If lstrparms.String_Arg[6] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + ",0030~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[6],30))
End If

If lstrparms.String_Arg[29] > ' ' Then 
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + ",0030~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[29],45))
End If

//To Address - Roll up addresses if not all present

llAddrPos = 0

If lstrparms.String_Arg[7] > ' ' Then
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + ",0045~~" //Customer Name
	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[7],45))
End If

If lstrparms.String_Arg[8] > ' ' Then
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + ",0045~~" //Address1
	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[8],45))
End If

If lstrparms.String_Arg[9] > ' ' Then
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + ",0045~~" //Address2
	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[9],45))
End If

If lstrparms.String_Arg[10] > ' ' Then
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + ",0045~~" //Address3
	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[10],45))
End If

If lstrparms.String_Arg[32] > ' ' Then //Address4
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + ",0045~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[32],45))
End If

If lstrparms.String_Arg[11] > ' ' Then //City,state,zip
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + ",0045~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[11],45))
End If

If lstrparms.String_Arg[30] > ' ' Then //To Country
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + ",0045~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[30],45))
End If

//Ship To Post Code
lsFormat = uf_Replace(lsFormat,"~~ship_to_zip,0012~~",left(lstrparms.String_Arg[33],12)) /* 12/03 - PCONKL - For UCCS Label */
	
//Ship To Post Code (BARCODE)	
lsFormat = uf_Replace(lsFormat,"~~ship_to_zip_BC,0008~~",left(lstrparms.String_Arg[33],12)) /* 12/03 - PCONKL - For UCCS Label */
	
//Jxlim 05/25/2012 Jira SIM-705 for Riverbed
If gs_project ='RIVERBED' Then
	//AWB
	lsFormat = uf_Replace(lsFormat,"~~bol_nbr,0020~~",lstrparms.String_Arg[34]) /* 12/03 - PCONKL - For UCCS Label */
Else
	//AWB
	lsFormat = uf_Replace(lsFormat,"~~bol_nbr,0020~~",left(lstrparms.String_Arg[34],12)) /* 12/03 - PCONKL - For UCCS Label */
End If
		
//Carton no (UCCS Label) - 
If  lstrparms.String_Arg[35] > '' Then
	lsUCCCarton = "0" + lstrparms.String_Arg[35] + Right(String(Long(lstrparms.String_Arg[12]),'000000000'),9) /*Prepend UCCS Info - 0 (futire use) + Warehouse Prefix + Company Prefix) */		
	liCheck = f_calc_uccs_check_Digit(lsUCCCarton) /*calculate the check digit*/
	If liCheck >=0 Then
		lsuccCarton = "00" + lsUccCarton + String(liCheck) /* add 00 at beginning (not part of check digit calculation but included as tag */
	Else
		lsUccCarton = String(Long(lstrparms.String_Arg[12]),'00000000000000000000')
	End If
Else
	lsUccCarton = String(Long(lstrparms.String_Arg[12]),'00000000000000000000')
End If

IF gs_project = "MAQUET" THEN

	lsFormat = uf_Replace(lsFormat,"(00)","")
	lsFormat = uf_Replace(lsFormat,"~~carton_no_BC,0019~~", left(lstrparms.String_Arg[27],30))
	lsFormat = uf_Replace(lsFormat,"~~carton_no_readable,0018~~",left(lstrparms.String_Arg[27],30)) /* 00 already on label as text field but included in barcode*/

ELSEIF Upper(gs_project) ='REMA' THEN //26-MAR-2018 :Madhu Rema -Update process for printing pallet labels
	lsUccCarton = "0"+lstrparms.String_Arg[12]
	lsFormat = uf_Replace(lsFormat,"(00)","")
	lsFormat = uf_Replace(lsFormat,"~~carton_no_BC,0019~~", lsUccCarton)
	lsFormat = uf_Replace(lsFormat,"~~carton_no_readable,0018~~", lsUccCarton)
	
ELSE
	
	lsFormat = uf_Replace(lsFormat,"~~carton_no_BC,0019~~",lsUCCCarton)
	lsFormat = uf_Replace(lsFormat,"~~carton_no_readable,0018~~",Right(lsUCCCarton,18)) /* 00 already on label as text field but included in barcode*/
	
END IF
	
//Po No
lsFormat = uf_Replace(lsFormat,"~~po_nbr,0030~~",left(lstrparms.String_Arg[13],30))

//Cust No
lsFormat = uf_Replace(lsFormat,"~~sku_no,0030~~",left(lstrparms.String_Arg[14],30))//Alternate sku

//Weight	
//26-MAR-2018 :Madhu Rema -Update process for printing pallet labels
IF upper(gs_project) <> 'REMA' THEN
	ls_weight = String(lstrparms.Long_Arg[5]) + "/" + String(lstrparms.Long_Arg[6])
	lsFormat = uf_Replace(lsFormat,"~~weight,0008~~",ls_weight )
	lsFormat = uf_Replace(lsFormat,"~~weight_lbs_no,0030~~",String(lstrparms.Long_Arg[5]))
	lsFormat = uf_Replace(lsFormat,"~~weight_kgs_no,0030~~",String(lstrparms.Long_Arg[6]))
	lsFormat = uf_Replace(lsFormat,"~~weight,0030~~",String(lstrparms.Long_Arg[5]) + "LBs / " + String(lstrparms.Long_Arg[6]) + "KGs") /* 12/03 - PCONKL - Weight for UCCS */
END IF	

//Invoice NO
lsFormat = uf_Replace(lsFormat,"~~invoice_no,0030~~",Left(lstrparms.String_Arg[17],20))	

//Today's date 
lsFormat = uf_Replace(lsFormat,"~~today,0030~~",string(today(),"mmm dd, yyyy"))
	
//Carrier Name
lsFormat = uf_Replace(lsFormat,"~~carrier_name,0030~~",left(lstrparms.String_Arg[25],30))
	
//Tracking shipper No
lsFormat = uf_Replace(lsFormat,"~~tracker_id,0030~~",left(lstrparms.String_Arg[27],30))
	
//No of copies
ll_no_of_copies = lstrparms.Long_Arg[1]
FOR i= 1 TO ll_no_of_copies
	lsFormat = uf_Replace(lsFormat,"~~tot_off,0030~~",left(lstrparms.String_Arg[28],30))
	PrintSend(llPrintJob, lsformat)	
	ls_temp= lstrparms.String_Arg[28]
NEXT
	
PrintClose(llPrintJob)
	

Return 0


end function

public function integer uf_linksys_zebra_ship (any as_array, string as_label);
//This function will print  Generic UCCS Shipping label

Str_parms	lStrparms
String	lsFormat,	&
			lsCartonBarcode,	&
			lsTemp,				&
			lsPrintText,		&
			lsAddr,ls_weight,ls_temp,	&
			lsUCCCarton, ls_type

Long	llPrintJob,	&
		llPos,		&
		llPrintQty,	&
		llPrintPos,	&
		llCartonNo,	&
		llAddrPos,i,j,ll_no_of_copies
		
Integer	liFileNo, liCheck


lstrparms = as_array


CHOOSE CASE upper(trim(as_label))
		
// pvh - 10/04/05
CASE 'SQM' // STAPLES/QUILL/MEDICAL ARTS
	as_label = 'LINKSYS_SQM_ZEBRA_SHIP.DWN'
	return uf_linksys_sqm_zebra_ship( as_array, as_label )
	
CASE 'CUST1'
	as_label = 'Linksys_zebra_ship_OfficeDepot.DWN'
	ls_type = "OFFICE"
	
CASE 'GENB'
	as_label = 'Linksys_zebra_ship_Ingram.DWN'	
	ls_type = "INGRAM"
CASE 'PARTIAL'
	as_label = 'Linksys_zebra_ship_Partial.DWN'
	ls_type = "PARTIAL"
CASE 'SHIP'
	as_label = 'Linksys_zebra_ship_Shipping.DWN'
	ls_type = "SHIP"	
CASE ELSE
	as_label = 'Linksys_zebra_ship_Generic.DWN'
	ls_type = "GENERIC"
END CHOOSE


//Messagebox (as_label, as_label)

lsFormat = uf_read_label_Format(as_label) 
		
	
lsPrintText = 'UCCS Ship - Zebra'


//Open Printer File 
llPrintJob = PrintOpen(lsPrintText)
	
If llPrintJob <0 Then 
	Messagebox('Labels', 'Unable to open Printer file. Labels will not be printed')
	Return -1
End If

//We are looping once for each Qty of label being printed - The carton number is changing so we need to bump after each one.
//Replace placeholders in Format with Field Values

//From Address - Roll up addresses if not all present
	
llAddrPos = 0

If lstrparms.String_Arg[2] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + ",0030~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[2],30))
End If
	
If lstrparms.String_Arg[3] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + ",0030~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[3],30))
End If

If lstrparms.String_Arg[4] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + ",0030~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[4],30))
End If

If lstrparms.String_Arg[5] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + ",0030~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[5],30))
End If
	
If lstrparms.String_Arg[31] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + ",0030~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[31],45))
End If
	
If lstrparms.String_Arg[6] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + ",0030~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[6],30))
End If

If lstrparms.String_Arg[29] > ' ' Then 
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + ",0030~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[29],45))
End If

//To Address - Roll up addresses if not all present

llAddrPos = 0

If lstrparms.String_Arg[7] > ' ' Then
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + ",0045~~" //Customer Name
	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[7],45))
End If

If lstrparms.String_Arg[8] > ' ' Then
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + ",0045~~" //Address1
	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[8],45))
End If

If lstrparms.String_Arg[9] > ' ' Then
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + ",0045~~" //Address2
	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[9],45))
End If

If lstrparms.String_Arg[10] > ' ' Then
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + ",0045~~" //Address3
	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[10],45))
End If

If lstrparms.String_Arg[32] > ' ' Then //Address4
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + ",0045~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[32],45))
End If

If lstrparms.String_Arg[11] > ' ' Then //City,state,zip
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + ",0045~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[11],45))
End If

If lstrparms.String_Arg[30] > ' ' Then //To Country
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + ",0045~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[30],45))
End If

//Ship To Post Code
lsFormat = uf_Replace(lsFormat,"~~ship_to_zip,0012~~",left(lstrparms.String_Arg[33],12)) /* 12/03 - PCONKL - For UCCS Label */
	
//Ship To Post Code (BARCODE)	//Trey  added "DI" of (420) to Barcode
lsFormat = uf_Replace(lsFormat,"~~ship_to_zip_BC,0008~~",'420' + left(lstrparms.String_Arg[33],8)) /* 12/03 - PCONKL - For UCCS Label */
	
//AWB
lsFormat = uf_Replace(lsFormat,"~~bol_nbr,0020~~",left(lstrparms.String_Arg[34],12)) /* 12/03 - PCONKL - For UCCS Label */

if ls_type = "GENERIC" then

	lsFormat = uf_Replace(lsFormat,"~~carton_no_BC,0019~~",'')
	lsFormat = uf_Replace(lsFormat,"~~carton_no_readable,0018~~",'') /* 00 already on label as text field but included in barcode*/

else
	//Trey added "DI" of 00 to Barcode	
	lsFormat = uf_Replace(lsFormat,"~~carton_no_BC,0019~~",Lstrparms.String_arg[48])
	lsFormat = uf_Replace(lsFormat,"~~carton_no_readable,0018~~",Right(Lstrparms.String_arg[48],18)) /* 00 already on label as text field but included in barcode*/

end if
//CHOOSE CASE upper(ls_type)

//CASE "OFFICE"

IF ls_type <> 'SHIP' THEN
	
	//Po No
	lsFormat = uf_Replace(lsFormat,"~~po_nbr,0030~~",left(lstrparms.String_Arg[13],30))

	
	//Cust No
	lsFormat = uf_Replace(lsFormat,"~~sku_no,0030~~",left(lstrparms.String_Arg[14],30))//Alternate sku
	
	//Weight	
	ls_weight = String(lstrparms.Long_Arg[5]) + "/" + String(lstrparms.Long_Arg[6])
	lsFormat = uf_Replace(lsFormat,"~~weight,0008~~",ls_weight )
	lsFormat = uf_Replace(lsFormat,"~~weight_lbs_no,0030~~",String(lstrparms.Long_Arg[5]))
	lsFormat = uf_Replace(lsFormat,"~~weight_kgs_no,0030~~",String(lstrparms.Long_Arg[6]))
	lsFormat = uf_Replace(lsFormat,"~~weight,0030~~",String(lstrparms.Long_Arg[5]) + "LBs / " + String(lstrparms.Long_Arg[6]) + "KGs") /* 12/03 - PCONKL - Weight for UCCS */
		
	
	//Invoice NO
	lsFormat = uf_Replace(lsFormat,"~~invoice_no,0030~~",Left(lstrparms.String_Arg[17],30))	
	
	//Today's date 
	lsFormat = uf_Replace(lsFormat,"~~today,0030~~",string(today(),"mmm dd, yyyy"))
		
	//Carrier Name
	lsFormat = uf_Replace(lsFormat,"~~carrier_name,0030~~",left(lstrparms.String_Arg[25],30))
		
	//Tracking shipper No
	lsFormat = uf_Replace(lsFormat,"~~tracker_id,0030~~",left(lstrparms.String_Arg[45],30))

END IF

CHOOSE CASE upper(ls_type)
CASE "OFFICE" 
	//User_Field6 // TAM use AWBBOL instead of User field 6.  We are not changing the label just the value that print (Arg 45 not 36)
//	lsFormat = uf_Replace(lsFormat,"~~user_field6,0020~~",left(lstrparms.String_Arg[36],20))
	//User_Field6
	lsFormat = uf_Replace(lsFormat,"~~user_field6,0020~~",left(lstrparms.String_Arg[45],20))

	//Case Count
	//lsFormat = uf_Replace(lsFormat,"~~case_count,0030~~",left(lstrparms.String_Arg[37],30))

CASE "SHIP"

	lsFormat = uf_Replace(lsFormat,"~~carton,0020~~","Carton " + left(lstrparms.String_Arg[28],20))
	//Invoice NO
	lsFormat = uf_Replace(lsFormat,"~~invoice_no,0030~~",Left(lstrparms.String_Arg[17],30))	

	lsFormat = uf_Replace(lsFormat,"~~po_nbr,0015~~",left(lstrparms.String_Arg[13],15))
	
	
CASE ELSE //CASE "INGRAM"

	//User_Field4
	lsFormat = uf_Replace(lsFormat,"~~user_field4,0020~~",left(lstrparms.String_Arg[17],20))

	IF ls_type = "GENERIC" OR ls_type = "INGRAM" then
		//Complete Date
		
		lsFormat = uf_Replace(lsFormat,"~~complete_date,0025~~",left(lstrparms.String_Arg[50],30))
	ELSE
		lsFormat = uf_Replace(lsFormat,"~~complete_date,0025~~",left(lstrparms.String_Arg[39],30))
		
	END IF

	//Carrier Name
	lsFormat = uf_Replace(lsFormat,"~~carrier_name_3,0030~~",left(lstrparms.String_Arg[25],30))
	
	//Tracking shipper No
	lsFormat = uf_Replace(lsFormat,"~~tracker_id_BC,0020~~",left(lstrparms.String_Arg[45],20))
	

	//Carton No
	lsFormat = uf_Replace(lsFormat,"~~userfield_4po,0025~~",left(lstrparms.String_Arg[13],25))
	
	//Item No
	lsFormat = uf_Replace(lsFormat,"~~item_no,0015~~",left(lstrparms.String_Arg[40],15))

	//Weight
	lsFormat = uf_Replace(lsFormat,"~~weight_eng,0008~~",String(lstrparms.Long_Arg[5]))

	
	//country
	lsFormat = uf_Replace(lsFormat,"~~made_in,0020~~",left(lstrparms.String_Arg[41], 20))

	//desc
	lsFormat = uf_Replace(lsFormat,"~~description,0025~~",left(lstrparms.String_Arg[42], 25))

	
	
	
END CHOOSE

IF upper(ls_type) = 'PARTIAL' then


	//Model
	lsFormat = uf_Replace(lsFormat,"~~model_no,0012~~",left(lstrparms.String_Arg[40], 12))	
	
	//country
	lsFormat = uf_Replace(lsFormat,"~~made_in,0015~~",left(lstrparms.String_Arg[41], 15))

	//Qty
	lsFormat = uf_Replace(lsFormat,"~~qty_no,0007~~", string(lstrparms.Long_Arg[10]))
	lsFormat = uf_Replace(lsFormat,"~~qty_no_BC,0007~~", string(lstrparms.Long_Arg[10]))

	//UPC
	lsFormat = uf_Replace(lsFormat,"~~upc_BC,0019~~",left(lstrparms.String_Arg[43], 19))
	lsFormat = uf_Replace(lsFormat,"~~upc_readable,0018~~",left(lstrparms.String_Arg[43], 18))

	//Weight
	lsFormat = uf_Replace(lsFormat,"~~weight_partial,0008~~",string(lstrparms.Long_Arg[11]) + ' lbs')

	
end if
	
//No of copies
ll_no_of_copies = lstrparms.Long_Arg[1]
FOR i= 1 TO ll_no_of_copies
	lsFormat = uf_Replace(lsFormat,"~~tot_off,0015~~",left(lstrparms.String_Arg[28],30))
	PrintSend(llPrintJob, lsformat)	
	ls_temp= lstrparms.String_Arg[28]
NEXT
	
PrintClose(llPrintJob)
	

Return 0


end function

public function integer uf_logitech_zebra_ship (any as_array, string as_label);
//This function will print  Generic UCCS Shipping label

Str_parms	lStrparms
String	lsFormat,	&
			lsCartonBarcode,	&
			lsTemp,				&
			lsPrintText,		&
			lsAddr,ls_weight,ls_temp,	&
			lsUCCCarton, ls_type

Long	llPrintJob,	&
		llPos,		&
		llPrintQty,	&
		llPrintPos,	&
		llCartonNo,	&
		llAddrPos,i,j,ll_no_of_copies
		
Integer	liFileNo, liCheck


lstrparms = as_array

as_label = 'Logitech_zebra_ship_Generic.DWN'
ls_type = "GENERIC"


//Messagebox ("ok", as_label)

lsFormat = uf_read_label_Format(as_label) 
		
	
lsPrintText = 'UCCS Ship - Zebra'


//Open Printer File 
llPrintJob = PrintOpen(lsPrintText)
	
If llPrintJob <0 Then 
	Messagebox('Labels', 'Unable to open Printer file. Labels will not be printed')
	Return -1
End If

//We are looping once for each Qty of label being printed - The carton number is changing so we need to bump after each one.
//Replace placeholders in Format with Field Values

//From Address - Roll up addresses if not all present
	
llAddrPos = 0

If lstrparms.String_Arg[2] > ' ' AND trim(lstrparms.String_Arg[2]) <> 'X' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + ",0030~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[2],30))
End If
	
If lstrparms.String_Arg[3] > ' ' AND trim(lstrparms.String_Arg[3]) <> 'X' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + ",0030~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[3],30))
End If

If lstrparms.String_Arg[4] > ' ' AND trim(lstrparms.String_Arg[4]) <> 'X' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + ",0030~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[4],30))
End If

If lstrparms.String_Arg[5] > ' ' AND trim(lstrparms.String_Arg[5]) <> 'X' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + ",0030~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[5],30))
End If
	
If lstrparms.String_Arg[31] > ' ' AND trim(lstrparms.String_Arg[31]) <> 'X' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + ",0030~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[31],45))
End If
	
If lstrparms.String_Arg[6] > ' ' AND trim(lstrparms.String_Arg[6]) <> 'X' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + ",0030~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[6],30))
End If

If lstrparms.String_Arg[29] > ' ' AND trim(lstrparms.String_Arg[29]) <> 'X' Then 
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + ",0030~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[29],45))
End If

//To Address - Roll up addresses if not all present

llAddrPos = 0

If lstrparms.String_Arg[7] > ' ' AND trim(lstrparms.String_Arg[7]) <> 'X' Then
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + ",0045~~" //Customer Name
	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[7],45))
End If

If lstrparms.String_Arg[8] > ' ' AND trim(lstrparms.String_Arg[8]) <> 'X'  Then
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + ",0045~~" //Address1
	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[8],45))
End If

If lstrparms.String_Arg[9] > ' ' AND trim(lstrparms.String_Arg[9]) <> 'X' Then
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + ",0045~~" //Address2
	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[9],45))
End If

If lstrparms.String_Arg[10] > ' ' AND trim(lstrparms.String_Arg[10]) <> 'X' Then
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + ",0045~~" //Address3
	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[10],45))
End If

If lstrparms.String_Arg[32] > ' ' AND trim(lstrparms.String_Arg[32]) <> 'X' Then //Address4
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + ",0045~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[32],45))
End If

If lstrparms.String_Arg[11] > ' ' AND trim(lstrparms.String_Arg[11]) <> 'X' Then //City,state,zip
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + ",0045~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[11],45))
End If

If lstrparms.String_Arg[30] > ' ' AND trim(lstrparms.String_Arg[30]) <> 'X'  Then //To Country
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + ",0045~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[30],45))
End If

//Ship To Post Code
lsFormat = uf_Replace(lsFormat,"~~ship_to_zip,0012~~",left(lstrparms.String_Arg[33],12)) /* 12/03 - PCONKL - For UCCS Label */
	
//Ship To Post Code (BARCODE)	//Trey  added "DI" of (420) to Barcode
lsFormat = uf_Replace(lsFormat,"~~ship_to_zip_BC,0008~~",'420' + left(lstrparms.String_Arg[33],8)) /* 12/03 - PCONKL - For UCCS Label */
	
//AWB
lsFormat = uf_Replace(lsFormat,"~~bol_nbr,0030~~",left(lstrparms.String_Arg[62],30)) /* 12/03 - PCONKL - For UCCS Label */
	
		
//(UCCS Label 128) - 
//If  lstrparms.String_Arg[35] > '' Then
//	lsUCCCarton = "0" + lstrparms.String_Arg[35] + Right(String(Long(lstrparms.String_Arg[12]),'000000000'),9) /*Prepend UCCS Info - 0 (futire use) + Warehouse Prefix + Company Prefix) */		
//	liCheck = f_calc_uccs_check_Digit(lsUCCCarton) /*calculate the check digit*/
//	If liCheck >=0 Then
//		lsuccCarton = "00" + lsUccCarton + String(liCheck) /* add 00 at beginning (not part of check digit calculation but included as tag */
//	Else
//		lsUccCarton = String(Long(lstrparms.String_Arg[12]),'00000000000000000000')
//	End If
//Else
//	lsUccCarton = String(Long(lstrparms.String_Arg[12]),'00000000000000000000')
//End If

//string ls_carton_pallet
//
//integer li_inc_number = 1
//
//li_inc_number = li_inc_number + 1
//
//ls_carton_pallet = "0"
//
//string ls_check_digit, ls_rtn_digit, lsUccCarton_View
//
//ls_check_digit = ls_carton_pallet + "1745883" + right(string(today(),"YYYY"),1) + string(today(),"MM") + string(today(),"DD") + string(li_inc_number, "0000") 
//
//ls_rtn_digit = string(f_calc_uccs_check_Digit(ls_check_digit))
//
//lsUccCarton = ls_carton_pallet + "1745883" + right(string(today(),"YYYY"),1) + string(today(),"MM") + string(today(),"DD") + string(li_inc_number, "0000") + ls_rtn_digit
//





if ls_type = "GENERIC" then

	lsFormat = uf_Replace(lsFormat,"~~carton_no_BC,0019~~",'')
	lsFormat = uf_Replace(lsFormat,"~~carton_no_readable,0018~~",'') /* 00 already on label as text field but included in barcode*/


else
	//Trey added "DI" of 00 to Barcode	
	lsFormat = uf_Replace(lsFormat,"~~carton_no_BC,0019~~",Lstrparms.String_arg[48])
	lsFormat = uf_Replace(lsFormat,"~~carton_no_readable,0018~~",Right(Lstrparms.String_arg[48],18)) /* 00 already on label as text field but included in barcode*/

end if
//CHOOSE CASE upper(ls_type)

//CASE "OFFICE"

IF ls_type <> 'SHIP' THEN
	
	//Po No
	lsFormat = uf_Replace(lsFormat,"~~po_nbr,0030~~",left(lstrparms.String_Arg[13],30))

	
	//Cust No
	lsFormat = uf_Replace(lsFormat,"~~sku_no,0030~~",left(lstrparms.String_Arg[14],30))//Alternate sku
	
	//Weight	
	ls_weight = String(lstrparms.Long_Arg[5]) + "/" + String(lstrparms.Long_Arg[6])
	lsFormat = uf_Replace(lsFormat,"~~weight,0008~~",ls_weight )
	lsFormat = uf_Replace(lsFormat,"~~weight_lbs_no,0030~~",String(lstrparms.Long_Arg[5]))
	lsFormat = uf_Replace(lsFormat,"~~weight_kgs_no,0030~~",String(lstrparms.Long_Arg[6]))
	lsFormat = uf_Replace(lsFormat,"~~weight,0030~~",String(lstrparms.String_Arg[70]) + "LBs / " + String(lstrparms.String_Arg[71]) + "KGs") /* 12/03 - PCONKL - Weight for UCCS */
		
	
	//Invoice NO
	lsFormat = uf_Replace(lsFormat,"~~invoice_no,0030~~",Left(lstrparms.String_Arg[17],30))	

	lsFormat = uf_Replace(lsFormat,"~~so_no,0030~~",Left(lstrparms.String_Arg[60],30))	
	
	
	//Today's date 
	lsFormat = uf_Replace(lsFormat,"~~today,0030~~",string(today(),"mmm dd, yyyy"))
		
	//Carrier Name
	lsFormat = uf_Replace(lsFormat,"~~carrier_name,0030~~",left(lstrparms.String_Arg[25],30))
		

END IF

CHOOSE CASE upper(ls_type)
CASE "OFFICE" 
	//User_Field6
	lsFormat = uf_Replace(lsFormat,"~~user_field6,0020~~",left(lstrparms.String_Arg[36],20))

	//Case Count
	//lsFormat = uf_Replace(lsFormat,"~~case_count,0030~~",left(lstrparms.String_Arg[37],30))

CASE "SHIP"

	lsFormat = uf_Replace(lsFormat,"~~carton,0020~~","Carton " + left(lstrparms.String_Arg[28],20))
	//Invoice NO
	lsFormat = uf_Replace(lsFormat,"~~invoice_no,0030~~",Left(lstrparms.String_Arg[17],30))	

	lsFormat = uf_Replace(lsFormat,"~~po_nbr,0015~~",left(lstrparms.String_Arg[13],15))
	
	
CASE ELSE //CASE "INGRAM"

	//User_Field4
	lsFormat = uf_Replace(lsFormat,"~~user_field4,0020~~",left(lstrparms.String_Arg[17],20))

	//Complete Date
	lsFormat = uf_Replace(lsFormat,"~~complete_date,0025~~",left(lstrparms.String_Arg[39],30))

	//Carrier Name
	lsFormat = uf_Replace(lsFormat,"~~carrier_name_3,0030~~",left(lstrparms.String_Arg[25],30))
	
	//Tracking shipper No
	

	//Carton No
	lsFormat = uf_Replace(lsFormat,"~~userfield_4po,0025~~",left(lstrparms.String_Arg[13],25))
	
	//Item No
	lsFormat = uf_Replace(lsFormat,"~~item_no,0015~~",left(lstrparms.String_Arg[40],15))

	//Weight
	lsFormat = uf_Replace(lsFormat,"~~weight_eng,0008~~",String(lstrparms.Long_Arg[5]))

	
	//country
	lsFormat = uf_Replace(lsFormat,"~~made_in,0020~~",left(lstrparms.String_Arg[41], 20))

	//desc
	lsFormat = uf_Replace(lsFormat,"~~description,0025~~",left(lstrparms.String_Arg[42], 25))

	
	
	
END CHOOSE

IF upper(ls_type) = 'PARTIAL' then


	//Model
	lsFormat = uf_Replace(lsFormat,"~~model_no,0012~~",left(lstrparms.String_Arg[40], 12))	
	
	//country
	lsFormat = uf_Replace(lsFormat,"~~made_in,0015~~",left(lstrparms.String_Arg[41], 15))

	//Qty
	lsFormat = uf_Replace(lsFormat,"~~qty_no,0007~~", string(lstrparms.Long_Arg[10]))
	lsFormat = uf_Replace(lsFormat,"~~qty_no_BC,0007~~", string(lstrparms.Long_Arg[10]))

	//UPC
	lsFormat = uf_Replace(lsFormat,"~~upc_BC,0019~~",left(lstrparms.String_Arg[43], 19))
	lsFormat = uf_Replace(lsFormat,"~~upc_readable,0018~~",left(lstrparms.String_Arg[43], 18))

	//Weight
	lsFormat = uf_Replace(lsFormat,"~~weight_partial,0008~~",string(lstrparms.Long_Arg[11]) + ' lbs')

	
end if

lsFormat = uf_Replace(lsFormat,"~~bol_nbr,0030~~",left(lstrparms.String_Arg[62],30)) /* 12/03 - PCONKL - For UCCS Label */


//Tracking shipper No
lsFormat = uf_Replace(lsFormat,"~~tracker_id,0030~~",left(lstrparms.String_Arg[61],30))

lsFormat = uf_Replace(lsFormat,"~~tracker_id_BC,0020~~",left(lstrparms.String_Arg[61],20))

lsFormat = uf_Replace(lsFormat,"~~pro_no,0030~~",left(lstrparms.String_Arg[80],30))

	
	
	
	
//No of copies
ll_no_of_copies = lstrparms.Long_Arg[1]
FOR i= 1 TO ll_no_of_copies
	PrintSend(llPrintJob,"^XA^MCY^XZ")
	lsFormat = uf_Replace(lsFormat,"~~tot_off,0015~~",left(lstrparms.String_Arg[28],30))
	PrintSend(llPrintJob, lsformat)	
	PrintSend(llPrintJob,"^XA^MCY^XZ")	
	ls_temp= lstrparms.String_Arg[28]
NEXT
	
PrintClose(llPrintJob)
	

Return 0


end function

public function integer uf_license_tag_logitech (ref str_parms as_array);//This function will print  the License Tag for Zebra 

Str_parms	lStrparms
String	lsFormat,	&
			lsCartonBarcode,	&
			lsTemp,				&
			lsPrintText,		&
			lsAddr

Long	llPrintJob,	&
		llPos,		&
		llPrintQty,	&
		llPrintPos,	&
		llCartonNo,	&
		llAddrPos
		
Integer	liFileNo

DAteTime	ldtToday

ldtToday = DateTime(Today(),Now())

lstrparms = as_array

////Load the format
//lsFormat = uf_read_label_Format("Pulse_Zebra_Receive.DWN")
lsPrintText = 'License Tag Label'

lsFormat = lstrparms.String_Arg[1]

//Format not loaded
If lsFormat = '' Then Return -1

//Open Printer File 
llPrintJob = PrintOpen(lsPrintText)
If llPrintJob <0 Then 
	Messagebox('Labels', 'Unable to open Printer file. Labels will not be printed')
	Return -1
End If

//Replace placeholders in Format with Field Values
	

//Expiration Date
lsFormat = uf_Replace(lsFormat,"~~dt_expire,0010~~",Left(lstrparms.String_Arg[2],10))

//QTY
lsFormat = uf_Replace(lsFormat,"~~qty,0013~~",Left(lstrparms.String_Arg[3],13))

//SKU
lsFormat = uf_Replace(lsFormat,"~~sku,0020~~",Left(lstrparms.String_Arg[4],20))

//Lot NBR
lsFormat = uf_Replace(lsFormat,"~~lot,0015~~",Left(lstrparms.String_Arg[5],15))

//Container ID
lsFormat = uf_Replace(lsFormat,"~~tag,0010~~",Right(lstrparms.String_Arg[6],10))

//UOM
lsFormat = uf_Replace(lsFormat,"~~uom,0006~~",Left(lstrparms.String_Arg[7],6))

//Location
lsFormat = uf_Replace(lsFormat,"~~misc_text2,0010~~",Left(lstrparms.String_Arg[8],10))

//Description
lsFormat = uf_Replace(lsFormat,"~~sku_desc,0040~~",Left(lstrparms.String_Arg[9],40))

//date Printed
lsFormat = uf_Replace(lsFormat,"~~dt_print,0010~~",String(ldtToday,'MM/DD/YYYY'))

////SKU Barcode
//lsFormat = uf_Replace(lsFormat,"~~sku_barcode,0020~~",Left(lstrparms.String_Arg[7],20))
//
////Container ID barcode
//lsFormat = uf_Replace(lsFormat,"~~pkg_id_barcode,0015~~",Left(lstrparms.String_Arg[6],15))
//
//Unit of Measure
//lsFormat = uf_Replace(lsFormat,"~~pkg_id_barcode,0015~~",Left(lstrparms.String_Arg[7],15))

//Location
//lsFormat = uf_Replace(lsFormat,"~~pkg_id_barcode,0015~~",Left(lstrparms.String_Arg[8],15))

//Description
//lsFormat = uf_Replace(lsFormat,"~~pkg_id_barcode,0015~~",Left(lstrparms.String_Arg[9],15))

lsFormat = uf_Replace(lsFormat,"~~uc1,0015~~",Left(lstrparms.String_Arg[10],15))
lsFormat = uf_Replace(lsFormat,"~~uc2,0015~~",Left(lstrparms.String_Arg[11],15))
lsFormat = uf_Replace(lsFormat,"~~uc3,0015~~",Left(lstrparms.String_Arg[12],15))

lsFormat = uf_Replace(lsFormat,"~~lot,0020~~",Left(lstrparms.String_Arg[5],20))


lsFormat = uf_Replace(lsFormat,"~~hold,0030~~",Left(lstrparms.String_Arg[13],30))


//Qty of labels to Print 
lsFormat = uf_Replace(lsFormat,"~~*QUANT,04~~",String(lstrparms.Long_Arg[1]))

//Copies of labels to Print 
lsFormat = uf_Replace(lsFormat,"~~*COPIES,04~~",String(lstrparms.Long_Arg[1]))

//Send to Printer
PrintSend(llPrintJob, lsformat)

PrintClose(llPrintJob)


Return 0
end function

public function integer uf_phx_brnds_zerba_ship (any as_array);
//This function will print  Generic UCCS Shipping label

Str_parms	lStrparms
String	lsFormat,	&
			lsCartonBarcode,	&
			lsTemp,				&
			lsPrintText,		&
			lsAddr,ls_weight,ls_temp,	&
			lsUCCCarton,ls_ucc

Long	llPrintJob,	&
		llPos,		&
		llPrintQty,	&
		llPrintPos,	&
		llCartonNo,	&
		llAddrPos,i,j,ll_no_of_copies
		
Integer	liFileNo, liCheck
	

lstrparms = as_array

string ls_label_type

SELECT User_Field10 INTO :ls_label_type FROM Delivery_Master
	WHERE DO_NO = :lstrparms.String_arg[40] USING SQLCA;

//Messagebox ("label", ls_label_type)

CHOOSE CASE Upper(ls_label_type)

CASE "ZEL"
	lsFormat = uf_read_label_Format('PHX_BRNDS_Zeller_zebra_ship.DWN')	
CASE "CNT"
	lsFormat = uf_read_label_Format('PHX_BRNDS_Canadian_Tire_zebra_ship.DWN')	
CASE "SDM"
	lsFormat = uf_read_label_Format('PHX_BRNDS_Shoppers_zebra_ship.DWN')
CASE "TAR"
	lsFormat = uf_read_label_Format('PHX_BRNDS_target_zebra_ship.txt') /* 12/04 - PCONKL - Using Labelvision */
CASE "WMT"
	lsFormat = uf_read_label_Format('PHX_BRNDS_wmt_zebra_ship.txt') /* 12/04 - PCONKL - Using Labelvision */
	
// pvh - 11/15/05
CASE 'WGN'  // WALGREENS 
	return uf_phx_brands_wag_zebra_ship( as_array, Upper(ls_label_type) )

CASE ELSE
//	lsFormat = uf_read_label_Format('generic_zebra_ship_UCC.DWN') 
// TAM 11/12/04  Fix 9 digit postal code (420######)
	lsFormat = uf_read_label_Format('PHX_BRNDS_generic_zebra_ship_UCC.DWN') 
END CHOOSE	
	
lsPrintText = 'UCCS Ship - Zebra'


//Open Printer File 
llPrintJob = PrintOpen(lsPrintText)
	
If llPrintJob <0 Then 
	Messagebox('Labels', 'Unable to open Printer file. Labels will not be printed')
	Return -1
End If

//We are looping once for each Qty of label being printed - The carton number is changing so we need to bump after each one.
//Replace placeholders in Format with Field Values

//From Address - Roll up addresses if not all present
	
llAddrPos = 0

If lstrparms.String_Arg[2] > ' ' Then
	
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + ",0030~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[2],30))
	
	// 12/04 - PCONKL - Labelvision labels don't contain comma and field length in name
	lsAddr = "~~from_addr" + String(llAddrPos) + "~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[2],30))
	
End If
	
If lstrparms.String_Arg[3] > ' ' Then
	
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + ",0030~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[3],30))
	
	lsAddr = "~~from_addr" + String(llAddrPos) + "~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[3],30))
	
End If

If lstrparms.String_Arg[4] > ' ' Then
	
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + ",0030~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[4],30))
	
	lsAddr = "~~from_addr" + String(llAddrPos) + "~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[4],30))
	
End If

If lstrparms.String_Arg[5] > ' ' Then
	
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + ",0030~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[5],30))
	
	lsAddr = "~~from_addr" + String(llAddrPos) + "~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[5],30))
	
End If
	
If lstrparms.String_Arg[31] > ' ' Then
	
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + ",0030~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[31],45))
	
	lsAddr = "~~from_addr" + String(llAddrPos) + "~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[31],45))
	
End If
	
If lstrparms.String_Arg[6] > ' ' Then
	
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + ",0030~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[6],30))
	
	lsAddr = "~~from_addr" + String(llAddrPos) + "~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[6],30))
	
End If

If lstrparms.String_Arg[29] > ' ' Then 
	
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + ",0030~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[29],45))
	
	lsAddr = "~~from_addr" + String(llAddrPos) + "~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[29],45))
	
End If

//To Address - Roll up addresses if not all present

llAddrPos = 0

If lstrparms.String_Arg[7] > ' ' Then
	
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + ",0045~~" //Customer Name
	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[7],45))
	
	// 12/04 - PCONKL - Labelvision labels don't contain comma and field length in name
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~" //Customer Name
	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[7],45))
	
End If

If lstrparms.String_Arg[8] > ' ' Then
	
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + ",0045~~" //Address1
	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[8],45))
	
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~" //Address1
	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[8],45))
	
End If

If lstrparms.String_Arg[9] > ' ' Then
	
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + ",0045~~" //Address2
	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[9],45))
	
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~" //Address2
	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[9],45))
	
End If

If lstrparms.String_Arg[10] > ' ' Then
	
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + ",0045~~" //Address3
	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[10],45))
	
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~" //Address3
	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[10],45))
	
End If

If lstrparms.String_Arg[32] > ' ' Then //Address4

	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + ",0045~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[32],45))
	
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[32],45))
	
End If

If lstrparms.String_Arg[11] > ' ' Then //City,state,zip

	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + ",0045~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[11],45))
	
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[11],45))
	
End If

If lstrparms.String_Arg[30] > ' ' Then //To Country

	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + ",0045~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[30],45))
	
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[30],45))
	
End If

//Ship To Post Code
//lsFormat = uf_Replace(lsFormat,"~~ship_to_zip,0012~~",left(lstrparms.String_Arg[33],12)) /* 12/03 - PCONKL - For UCCS Label */
	
//Ship To Post Code (BARCODE)	
//lsFormat = uf_Replace(lsFormat,"~~ship_to_zip_BC,0008~~",left(lstrparms.String_Arg[33],8)) /* 12/03 - PCONKL - For UCCS Label */
	
//AWB
lsFormat = uf_Replace(lsFormat,"~~bol_nbr,0020~~",left(lstrparms.String_Arg[34],12)) /* 12/03 - PCONKL - For UCCS Label */
		
////Carton no (UCCS Label) - 
//If  lstrparms.String_Arg[35] > '' Then
//	lsUCCCarton = "0" + lstrparms.String_Arg[35] + Right(String(Long(lstrparms.String_Arg[12]),'000000000'),9) /*Prepend UCCS Info - 0 (futire use) + Warehouse Prefix + Company Prefix) */		
//	liCheck = f_calc_uccs_check_Digit(lsUCCCarton) /*calculate the check digit*/
//	If liCheck >=0 Then
//		lsuccCarton = "00" + lsUccCarton + String(liCheck) /* add 00 at beginning (not part of check digit calculation but included as tag */
//	Else
//		lsUccCarton = String(Long(lstrparms.String_Arg[12]),'00000000000000000000')
//	End If
//Else
//	lsUccCarton = String(Long(lstrparms.String_Arg[12]),'00000000000000000000')
//End If
//	
//lsFormat = uf_Replace(lsFormat,"~~carton_no_BC,0019~~",lsUCCCarton)
//lsFormat = uf_Replace(lsFormat,"~~carton_no_readable,0018~~",Right(lsUCCCarton,18)) /* 00 already on label as text field but included in barcode*/
//	
	
//Po No
lsFormat = uf_Replace(lsFormat,"~~po_nbr,0030~~",left(lstrparms.String_Arg[13],30))
lsFormat = uf_Replace(lsFormat,"~~po_nbr~~",left(lstrparms.String_Arg[13],30)) /* 12/04 - PCONKL -Labelvision labels*/

//Cust No
lsFormat = uf_Replace(lsFormat,"~~sku_no,0030~~",left(lstrparms.String_Arg[14],30))//Alternate sku

//Weight	
ls_weight = String(lstrparms.Long_Arg[5]) + "/" + String(lstrparms.Long_Arg[6])
lsFormat = uf_Replace(lsFormat,"~~weight,0008~~",ls_weight )
lsFormat = uf_Replace(lsFormat,"~~weight_lbs_no,0030~~",String(lstrparms.Long_Arg[5]))
lsFormat = uf_Replace(lsFormat,"~~weight_kgs_no,0030~~",String(lstrparms.Long_Arg[6]))
lsFormat = uf_Replace(lsFormat,"~~weight,0030~~",String(lstrparms.Long_Arg[5]) + "LBs / " + String(lstrparms.Long_Arg[6]) + "KGs") /* 12/03 - PCONKL - Weight for UCCS */
	
/* 12/04 - PCONKL - Target Casepack*/
lsFormat = uf_Replace(lsFormat,"~~casepack~~",String(lstrparms.Long_Arg[7]) )

//Invoice NO
lsFormat = uf_Replace(lsFormat,"~~invoice_no,0030~~",Left(lstrparms.String_Arg[17],20))	

//Today's date 
lsFormat = uf_Replace(lsFormat,"~~today,0030~~",string(today(),"mmm dd, yyyy"))
	
//Carrier Name
lsFormat = uf_Replace(lsFormat,"~~carrier_name,0030~~",left(lstrparms.String_Arg[25],30))

lsFormat = uf_Replace(lsFormat,"~~carrier_name,0020~~",left(lstrparms.String_Arg[25],20))

lsFormat = uf_Replace(lsFormat,"~~pro,0015~~",left(lstrparms.String_Arg[45],15))

lsFormat = uf_Replace(lsFormat,"~~bol_nbr,0015~~",left(lstrparms.String_Arg[17],15))

string ls_cat

If IsNull(lstrparms.String_Arg[42]) then lstrparms.String_Arg[42] = ""
If IsNull(lstrparms.String_Arg[43]) then lstrparms.String_Arg[43] = ""

lsFormat = uf_Replace(lsFormat,"~~cat,0030~~",left(lstrparms.String_Arg[42] + " " + lstrparms.String_Arg[43],30))
lsFormat = uf_Replace(lsFormat,"~~dbci~~",left(lstrparms.String_Arg[42],9)) /* 12/04 - PCONKL - Target DPCI */

lsFormat = uf_Replace(lsFormat,"~~po_nbr,0030~~",left( lstrparms.String_Arg[13],30))


lsFormat = uf_Replace(lsFormat,"~~ship_to_zip,0012~~",left(lstrparms.String_Arg[41],12))
lsFormat = uf_Replace(lsFormat,"~~ship_to_Zip~~",left(lstrparms.String_Arg[41],12)) /* 12/04 - PCONKL - Labelvision */

// TAM 11/12/04 fix 9 digit postal
lsFormat = uf_Replace(lsFormat,"~~ship_to_zip_BC,0008~~","420"+left(lstrparms.String_Arg[41],12))
lsFormat = uf_Replace(lsFormat,"~~ship_to_zip_BC,0012~~","420"+left(lstrparms.String_Arg[41],12))

lsFormat = uf_Replace(lsFormat,"~~ship_to_zip_bc~~","420"+left(lstrparms.String_Arg[41],12)) /*12/04 - PCONKL - LabelVision label*/


lsFormat = uf_Replace(lsFormat,"~~ship_date,0015~~",left(string(today(),"Mmm dd, yyyy"),15))
lsFormat = uf_Replace(lsFormat,"~~ctc_po,0015~~",left(Lstrparms.String_arg[13],15))


lsFormat = uf_Replace(lsFormat,"~~carton_no_BC2,0019~~", "420"+left(lstrparms.String_Arg[41],12))

lsFormat = uf_Replace(lsFormat,"~~destination,0012~~",left(lstrparms.String_Arg[44],12))
lsFormat = uf_Replace(lsFormat,"~~destination_bc,0008~~","91" + trim(left(trim(lstrparms.String_Arg[44]),12)))
lsFormat = uf_Replace(lsFormat,"~~destination_bc,0012~~","91" + trim(left(trim(lstrparms.String_Arg[44]),12)))

if Upper(ls_label_type) = "ZEL" then
	lsFormat = uf_Replace(lsFormat,"~~store,0008~~","ZL" + left(lstrparms.String_Arg[44],6))
else
	lsFormat = uf_Replace(lsFormat,"~~store,0006~~",left(lstrparms.String_Arg[44],6))
end if


//Trey added "DI" of 00 to Barcode	

if ls_label_type = "ZEL" then
	lsFormat = uf_Replace(lsFormat,"~~carton_no_BC,0019~~", "00" + "1" + mid(right(Lstrparms.String_arg[48],18),2))
	lsFormat = uf_Replace(lsFormat,"~~carton_no_readable,0018~~","1"+ mid(right(Lstrparms.String_arg[48],18),2)) /* 00 already on label as text field but included in barcode*/
else
//	Lstrparms.String_arg[48]='99  99999  99999  1'

	lsFormat = uf_Replace(lsFormat,"~~carton_no_BC,0019~~", right(Lstrparms.String_arg[48],20))
	lsFormat = uf_Replace(lsFormat,"~~carton_no_bc~~", right(Lstrparms.String_arg[48],20)) /* 12/04 - PCONKL - Labelvision */
	lsFormat = uf_Replace(lsFormat,"~~carton_no_readable,0018~~", right(Lstrparms.String_arg[48],18)) /* 00 already on label as text field but included in barcode*/
	lsFormat = uf_Replace(lsFormat,"~~carton_no_readable~~", right(Lstrparms.String_arg[48],18)) /*  12/04 - LabelVision*/

end if 


lsFormat = uf_Replace(lsFormat,"~~user_field3,0047~~", right(Lstrparms.String_arg[42],10))
lsFormat = uf_Replace(lsFormat,"~~user_field4,0048~~", right(Lstrparms.String_arg[43],10))
//lsFormat = uf_Replace(lsFormat,"~~user_field5,0049~~", right(Lstrparms.String_arg[55],10))
lsFormat = uf_Replace(lsFormat,"~~user_field6,0050~~", right(Lstrparms.String_arg[45],10))
ls_ucc = right(Lstrparms.String_arg[46],14)
ls_ucc = mid(ls_ucc,1,1) + '  ' + mid(ls_ucc,2,2) + '  ' + mid(ls_ucc,4,5) +& 
'  ' + mid(ls_ucc,9,5) + '  ' + mid(ls_ucc,14,1)
lsFormat = uf_Replace(lsFormat,"~~user_field7,0045~~", ls_ucc)

	


//	
	
//Tracking shipper No
lsFormat = uf_Replace(lsFormat,"~~tracker_id,0030~~",left(lstrparms.String_Arg[27],30))
	
//No of copies
ll_no_of_copies = lstrparms.Long_Arg[1]
FOR i= 1 TO ll_no_of_copies
	lsFormat = uf_Replace(lsFormat,"~~tot_off,0030~~",left(lstrparms.String_Arg[28],30))
	PrintSend(llPrintJob, lsformat)	
	ls_temp= lstrparms.String_Arg[28]
NEXT
	
PrintClose(llPrintJob)
	

Return 0


end function

public function integer uf_valeo_blaster_part (ref any as_array, ref string as_labeltype);//GAP 0403 This function will print Valeo Part label for Blaster

Str_parms	lStrparms
String	lsFormat,	&
			lsCartonBarcode,	&
			lsTemp,				&
			lsPrintText,		& 
			lsAddr

Long	llPrintJob,	&
		llPos,		&
		llPrintQty,	&
		llPrintPos,	&
		llCartonNo,	&
		llAddrPos
		
Integer	liFileNo

lstrparms = as_array

string lsDesc

//Load the format
lsFormat = uf_read_label_Format("Valeo_blaster_ford.txt")
if as_labeltype = "Ford Master"  then lsFormat = uf_read_label_Format("Valeo_blaster_fordmaster.txt")
if as_labeltype = "Other Label"  then lsFormat = uf_read_label_Format("Valeo_blaster_other.txt")
if as_labeltype = "Mixed Load"  then lsFormat = uf_read_label_Format("Valeo_blaster_mixed.txt")
if as_labeltype = "Destination"  then lsFormat = uf_read_label_Format("Valeo_blaster_destination.txt")
if as_labeltype = "Freightliner Part" then lsFormat = uf_read_label_Format("Valeo_blaster_FL_Part.txt")
if as_labeltype = "Freightliner Master" then lsFormat = uf_read_label_Format("Valeo_blaster_FL_Master.txt")

if as_labeltype = "Ford Master - 2D Blaster" then lsFormat = uf_read_label_Format("Valeo_blaster_MasterLbl.txt")
if as_labeltype = "Ford Container - 2D Blaster" then lsFormat = uf_read_label_Format("Valeo_blaster_ContainerLbl.txt")


//
//


lsPrintText = 'VALEOD SHIP LABEL'

//Format not loaded
If lsFormat = '' Then Return -1

//Open Printer File 
llPrintJob = PrintOpen(lsPrintText)

If llPrintJob <0 Then 
	Messagebox('Labels', 'Unable to open Printer file. Labels will not be printed')
	Return -1
End If

//Replace placeholders in Format with Field Values
	
//PARTNO
If lstrparms.String_Arg[1] > ' ' Then
	lsFormat = uf_Replace(lsFormat,"~~PARTNO~~",string(lstrparms.String_Arg[1]))
else
	lsFormat = uf_Replace(lsFormat,"~~PARTNO~~",space(1))
end if

//QTY
If lstrparms.String_Arg[2] > ' ' Then
	lsFormat = uf_Replace(lsFormat,"~~QTY~~",string(lstrparms.String_Arg[2]))
else
	lsFormat = uf_Replace(lsFormat,"~~QTY~~",space(1))
end if

//PARSEDSKU
If lstrparms.String_Arg[3] > ' ' Then
	lsFormat = uf_Replace(lsFormat,"~~PARSEDSKU~~",string(lstrparms.String_Arg[3]))
else
	lsFormat = uf_Replace(lsFormat,"~~PARSEDSKU~~",space(1))
end if

//SUPSKU
If lstrparms.String_Arg[4] > ' ' Then
	lsFormat = uf_Replace(lsFormat,"~~SUPSKU~~",string(lstrparms.String_Arg[4]))
else
	lsFormat = uf_Replace(lsFormat,"~~SUPSKU~~",space(1))
end if


//SUPPLIER
If lstrparms.String_Arg[5] > ' ' Then
	lsFormat = uf_Replace(lsFormat,"~~SUPPLIER~~",string(lstrparms.String_Arg[5]))
else
	lsFormat = uf_Replace(lsFormat,"~~SUPPLIER~~",space(1))
end if

//RCODE
If lstrparms.String_Arg[6] > ' ' Then
	lsFormat = uf_Replace(lsFormat,"~~RCODE~~",string(lstrparms.String_Arg[6]))
else
	lsFormat = uf_Replace(lsFormat,"~~RCODE~~",space(1))
end if

//LFEED
If lstrparms.String_Arg[7] > ' ' Then
	lsFormat = uf_Replace(lsFormat,"~~LFEED~~",string(lstrparms.String_Arg[7]))
else
	lsFormat = uf_Replace(lsFormat,"~~LFEED~~",space(1))
end if

//SERIAL
If lstrparms.String_Arg[8] > ' ' Then
	lsFormat = uf_Replace(lsFormat,"~~SERIAL~~",string(lstrparms.String_Arg[8]))
else
	lsFormat = uf_Replace(lsFormat,"~~SERIAL~~",space(1))
end if

//DESTCODE
If lstrparms.String_Arg[9] > ' ' Then
	lsFormat = uf_Replace(lsFormat,"~~DESTCODE~~",string(lstrparms.String_Arg[9]))
else
	lsFormat = uf_Replace(lsFormat,"~~DESTCODE~~",space(1))
end if

//CUSTNAME
If lstrparms.String_Arg[10] > ' ' Then
	lsFormat = uf_Replace(lsFormat,"~~SHIPTO~~",string(lstrparms.String_Arg[10]))
else
	lsFormat = uf_Replace(lsFormat,"~~SHIPTO~~",space(1))
end if

//PLANTCODE
If lstrparms.String_Arg[11] > ' ' Then
	lsFormat = uf_Replace(lsFormat,"~~PLANTBARCODE~~",string(lstrparms.String_Arg[11]))
else
	lsFormat = uf_Replace(lsFormat,"~~PLANTBARCODE~~",space(1))
end if

//ADDR1
If lstrparms.String_Arg[12] > ' ' Then
	lsFormat = uf_Replace(lsFormat,"~~ADDR1~~",string(lstrparms.String_Arg[12]))
else
	lsFormat = uf_Replace(lsFormat,"~~ADDR1~~",space(1))
end if

//ADDR2
If lstrparms.String_Arg[13] > ' ' Then
	lsFormat = uf_Replace(lsFormat,"~~ADDR2~~",string(lstrparms.String_Arg[13]))
else
	lsFormat = uf_Replace(lsFormat,"~~ADDR2~~",space(1))
end if

//DOCKID
If lstrparms.String_Arg[14] > ' ' Then
	lsFormat = uf_Replace(lsFormat,"~~DOCKID~~",string(lstrparms.String_Arg[14]))
else
	lsFormat = uf_Replace(lsFormat,"~~DOCKID~~",space(1))
end if

//For Mixed Load label...
if as_labeltype = "Mixed Load" or as_labeltype = "Freightliner Part" or as_labeltype = "Freightliner Master" or as_labeltype = "Ford Master - 2D Blaster" then
	//Invoice
	If lstrparms.String_Arg[15] > ' ' Then
		lsFormat = uf_Replace(lsFormat,"~~SHIPMENT~~",string(lstrparms.String_Arg[15]))
	else
		lsFormat = uf_Replace(lsFormat,"~~SHIPMENT~~",space(1))
	end if
	
	//Ship-From Name
	If lstrparms.String_Arg[16] > ' ' Then
		lsFormat = uf_Replace(lsFormat,"~~SHIPFROM~~",string(lstrparms.String_Arg[16]))
	else
		lsFormat = uf_Replace(lsFormat,"~~SHIPFROM~~",space(1))
	end if
	
	//Ship-From Telephone
	If lstrparms.String_Arg[17] > ' ' Then
		lsFormat = uf_Replace(lsFormat,"~~PHONE~~",string(lstrparms.String_Arg[17]))
	else
		lsFormat = uf_Replace(lsFormat,"~~PHONE~~",space(1))
	end if

	// for 'Freightliner Part' and "Freightliner Master" Labels...
	if as_labeltype = "Freightliner Part" or as_labeltype = "Freightliner Master" then
		/* dts - 9/13/04 - For Freightliner Part label 
		   dts - 9/24/04 - Added 'Freightliner Master' label 
			(like 'Other', but with Description instead of Alt Sku...) */
		If lstrparms.String_Arg[18] > ' ' Then
			lsFormat = uf_Replace(lsFormat,"~~PONUMBER~~",string(lstrparms.String_Arg[18]))
		else
			lsFormat = uf_Replace(lsFormat,"~~PONUMBER~~",space(1))
		end if

	end if

elseif as_labeltype = "Destination" then
	//For 'Destination' label...
	//Cust_Code
	If lstrparms.String_Arg[15] > ' ' Then
		lsFormat = uf_Replace(lsFormat,"~~CUSTCODE~~",string(lstrparms.String_Arg[15]))
	else
		lsFormat = uf_Replace(lsFormat,"~~CUSTCODE~~",space(1))
	end if

	//ADDR3 (city/state/zip, since ADDR2 is used for dm.address_2 for Destination label)
	If lstrparms.String_Arg[16] > ' ' Then
		lsFormat = uf_Replace(lsFormat,"~~ADDR3~~",string(lstrparms.String_Arg[16]))
	else
		lsFormat = uf_Replace(lsFormat,"~~ADDR3~~",space(1))
	end if
	

end if

If lstrparms.String_Arg[19] > ' ' Then
	lsDesc = string(lstrparms.String_Arg[19])
	lsFormat = uf_Replace(lsFormat,"~~DESCRIPTION1~~", left(lsDesc,20))
	if len(lsDesc)>20 then
		lsFormat = uf_Replace(lsFormat,"~~DESCRIPTION2~~", mid(lsDesc,21,20))
	else
		lsFormat = uf_Replace(lsFormat,"~~DESCRIPTION2~~",space(1))
	end if
else
	lsFormat = uf_Replace(lsFormat,"~~DESCRIPTION1~~",space(1))
	lsFormat = uf_Replace(lsFormat,"~~DESCRIPTION2~~",space(1))
end if


//SHIPDATE
lsFormat = uf_Replace(lsFormat,"~~SHIPDATE~~",string(today()))


If lstrparms.String_Arg[20] > ' ' Then
	lsFormat = uf_Replace(lsFormat,"~~SHIPADDR1~~",string(lstrparms.String_Arg[20]))
else
	lsFormat = uf_Replace(lsFormat,"~~SHIPADDR1~~",space(1))
end if

If lstrparms.String_Arg[21] > ' ' Then
	lsFormat = uf_Replace(lsFormat,"~~SHIPADDR2~~",string(lstrparms.String_Arg[21]))
else
	lsFormat = uf_Replace(lsFormat,"~~SHIPADDR2~~",space(1))
end if

If lstrparms.String_Arg[22] > ' ' Then
	lsFormat = uf_Replace(lsFormat,"~~SHIPADDR3~~",string(lstrparms.String_Arg[22]))
else
	lsFormat = uf_Replace(lsFormat,"~~SHIPADDR3~~",space(1))
end if


//Qty of labels to Print 
If String(lstrparms.Long_Arg[1]) > ' ' Then
	lsFormat = uf_Replace(lsFormat,"~~lblCount~~",String(lstrparms.Long_Arg[1]))
else
	lsFormat = uf_Replace(lsFormat,"~~lblCount~~",space(1))
end if

//Copies of labels to Print 
If String(lstrparms.Long_Arg[2]) > ' ' Then
	lsFormat = uf_Replace(lsFormat,"~~lblCount~~",String(lstrparms.Long_Arg[2]))
else
	lsFormat = uf_Replace(lsFormat,"~~lblCount~~",space(1))
end if

//Send to Printer 
PrintSend(llPrintJob, lsformat)

PrintClose(llPrintJob)


Return 0
end function

public function integer uf_linksys_sqm_zebra_ship (any as_array, string as_label);//This function will print  Generic UCCS Shipping label

Str_parms	lStrparms
string	lsSpaces
String	lsFormat,	&
			lsCartonBarcode,	&
			lsTemp,				&
			lsPrintText,		&
			lsAddr,ls_weight,ls_temp,	&
			lsUCCCarton, ls_type

Long	llPrintJob,	&
		llPos,		&
		llPrintQty,	&
		llPrintPos,	&
		llCartonNo,	&
		llAddrPos,i,j,ll_no_of_copies
		
Integer	liFileNo, liCheck

integer index
string sBegin 
string send 

sBegin = '*fromadr'
sEnd = '*'

lstrparms = as_array

lsFormat = uf_read_label_Format(as_label) 
	
lsPrintText = 'UCCS Ship - Zebra'

//Open Printer File 
llPrintJob = PrintOpen(lsPrintText)
	
If llPrintJob <0 Then 
	Messagebox('Labels', 'Unable to open Printer file. Labels will not be printed')
	Return -1
End If

//We are looping once for each Qty of label being printed - The carton number is changing so we need to bump after each one.
//Replace placeholders in Format with Field Values

//From Address - Roll up addresses if not all present
	
llAddrPos = 0

sBegin = '*fromadr'
sEnd = '*'

If len( Trim( lstrparms.String_Arg[2] ) ) > 0 Then
	llAddrPos ++
	lsAddr = sBegin + String(llAddrPos) + sEnd
	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[2],30))
End If

If len( Trim( lstrparms.String_Arg[3] ) ) > 0 Then	
	llAddrPos ++
	lsAddr = sBegin + String(llAddrPos) + sEnd
	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[3],30))
End If

If len( Trim( lstrparms.String_Arg[4] ) ) > 0 Then
	llAddrPos ++
	lsAddr = sBegin + String(llAddrPos) + sEnd
	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[4],30))
End If

If len( Trim( lstrparms.String_Arg[5] ) ) > 0 Then
	llAddrPos ++
	lsAddr = sBegin + String(llAddrPos) + sEnd
	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[5],30))
End If

If len( Trim( lstrparms.String_Arg[31] ) ) > 0 Then	
	llAddrPos ++
	lsAddr = sBegin + String(llAddrPos) + sEnd
	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[31],45))
End If

If len( Trim( lstrparms.String_Arg[6] ) ) > 0 Then	
	llAddrPos ++
	lsAddr = sBegin + String(llAddrPos) + sEnd
	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[6],30))
End If

If len( Trim( lstrparms.String_Arg[29] ) ) > 0 Then
	llAddrPos ++
	lsAddr = sBegin + String(llAddrPos) + sEnd
	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[29],45))
End If

//To Address - Roll up addresses if not all present

llAddrPos = 0
sBegin = '*to_addr'

If len( Trim( lstrparms.String_Arg[7] ) ) > 0 Then
	llAddrPos ++
	lsAddr = sBegin + String(llAddrPos) + sEnd
	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[7],45))
End If

If len( Trim( lstrparms.String_Arg[8] ) ) > 0 Then
	llAddrPos ++
	lsAddr = sBegin + String(llAddrPos) + sEnd
	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[8],45))
End If

If len( Trim( lstrparms.String_Arg[9] ) ) > 0 Then
	llAddrPos ++
	lsAddr = sBegin + String(llAddrPos) + sEnd
	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[9],45))
End If

If len( Trim( lstrparms.String_Arg[10] ) ) > 0 Then
	llAddrPos ++
	lsAddr = sBegin + String(llAddrPos) + sEnd
	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[10],45))
End If

If len( Trim( lstrparms.String_Arg[32] ) ) > 0 Then
	llAddrPos ++
	lsAddr = sBegin + String(llAddrPos) + sEnd
	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[32],45))
End If

If len( Trim( lstrparms.String_Arg[11] ) ) > 0 Then
	llAddrPos ++
	lsAddr = sBegin + String(llAddrPos) + sEnd
	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[11],45))
End If

If len( Trim( lstrparms.String_Arg[30] ) ) > 0 Then
	llAddrPos ++
	lsAddr = sBegin + String(llAddrPos) + sEnd
	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[30],45))
End If

// replace any open address with spaces
sBegin = '*fromadr'
sEnd = '*'
for index = 1 to 5
	lsAddr = sBegin + String(index) + sEnd
	lsFormat = uf_Replace(lsFormat,lsAddr,lsSpaces )
next
sBegin = '*to_addr'
for index = 1 to 5
	lsAddr = sBegin + String(index) + sEnd
	lsFormat = uf_Replace(lsFormat,lsAddr,lsSpaces )
next

lsFormat = uf_Replace(lsFormat,"*2345678901234*",left(lstrparms.String_Arg[33],15)) 
lsFormat = uf_Replace(lsFormat,"*420xxxxxxxxxx*",'420' + left(lstrparms.String_Arg[33],12)) 
lsFormat = uf_Replace(lsFormat,"*CARRIERNAME*",left(lstrparms.String_Arg[25],20)) 
lsFormat = uf_Replace(lsFormat,"*BLNBR*",left(lstrparms.String_Arg[45],12)) 
lsFormat = uf_Replace(lsFormat,"*PRONBR*",left(lstrparms.String_Arg[36],12)) 
lsFormat = uf_Replace(lsFormat,"*SKU*",left(lstrparms.String_Arg[40],50)) 
lsFormat = uf_Replace(lsFormat,"*8010000000000001*",Lstrparms.String_arg[48] )
lsFormat = uf_Replace(lsFormat,"*2345000001234567*",Right(Lstrparms.String_arg[48],18)) 
lsFormat = uf_Replace(lsFormat,"*CASEPACK*",Right(Lstrparms.String_arg[28],40)) 
lsFormat = uf_Replace(lsFormat,"*PONBR*",left(lstrparms.String_Arg[13],30))
lsFormat = uf_Replace(lsFormat,"*MODEL*",left(lstrparms.String_Arg[40],30))
//lsFormat = uf_Replace(lsFormat,"*PKGID*",left(lstrparms.String_Arg[ 60 ],18))
lsFormat = uf_Replace(lsFormat,"*MIXED/PARTIAL*",left(lstrparms.String_Arg[61],20)) 

//No of copies
ll_no_of_copies = lstrparms.Long_Arg[1]
FOR i= 1 TO ll_no_of_copies
//	lsFormat = uf_Replace(lsFormat,"~~tot_off,0015~~",left(lstrparms.String_Arg[28],30))
	PrintSend(llPrintJob, lsformat)	
	ls_temp= lstrparms.String_Arg[28]
NEXT
	
PrintClose(llPrintJob)
	

Return 0


end function

public function integer uf_phx_brands_wag_zebra_ship (any as_array, string aslabeltype);// uf_phx_brands_wag_zebra_ship()

//This function will print  Generic UCCS Shipping label

Str_parms	lStrparms
String	lsFormat,	&
			lsCartonBarcode,	&
			lsTemp,				&
			lsPrintText,		&
			lsAddr,ls_weight,ls_temp,	&
			lsUCCCarton,ls_ucc

Long	llPrintJob,	&
		llPos,		&
		llPrintQty,	&
		llPrintPos,	&
		llCartonNo,	&
		llAddrPos,i,j,ll_no_of_copies
		
Integer	liFileNo, liCheck
	
string lsFor
string lsWarehouseID
string lsDuns
string lsweight

lstrparms = as_array
	
// pvh - 11/15/05
lsFormat = uf_read_label_Format('phx_brands_walgreen_zebra_ship.txt')
lsPrintText = 'Walgreens UCCS Ship - Zebra'

//Open Printer File 
llPrintJob = PrintOpen(lsPrintText)
	
If llPrintJob <0 Then 
	Messagebox('Labels', 'Unable to open Printer file. Labels will not be printed')
	Return -1
End If

// Set the walgreens 4 digit warehouse id
lsWarehouseID =  Upper(left( Trim(Lstrparms.String_arg[60] ) , 4))
if isNull( lsWarehouseID ) or  len( lsWarehouseID ) =  0 then lsWarehouseID = space(4)

// Set the duns
lsDuns = Trim( Lstrparms.String_arg[63]  )
if isNull( lsDuns ) or len( lsDuns ) = 0 then lsDuns = space( 9 )

// set Weight
if IsNull( lstrparms.Long_Arg[5] ) then lstrparms.Long_Arg[5] = 0
lsweight = String( lstrparms.Long_Arg[5] )

//
//We are looping once for each Qty of label being printed - The carton number is changing so we need to bump after each one.
//Replace placeholders in Format with Field Values

//From Address - Roll up addresses if not all present
//
// Zone A
//
llAddrPos = 0

If lstrparms.String_Arg[2] > ' ' Then
	llAddrPos ++
	lsAddr = "*from_addr" + String(llAddrPos) + "*"
	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[2],25))
End If
	
If lstrparms.String_Arg[3] > ' ' Then
	llAddrPos ++
	lsAddr = "*from_addr" + String(llAddrPos) + "*"
	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[3],25))
End If

If lstrparms.String_Arg[4] > ' ' Then
	llAddrPos ++
	lsAddr = "*from_addr" + String(llAddrPos) + "*"
	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[4],25))
End If

If lstrparms.String_Arg[5] > ' ' Then
	llAddrPos ++
	lsAddr = "*from_addr" + String(llAddrPos) + "*"
	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[5],25))
End If
	
If lstrparms.String_Arg[6] > ' ' Then
	llAddrPos ++
	lsAddr = "*from_addr" + String(llAddrPos) + "*"
	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[6],25))
End If
//
// zap all the left over from address fields
//
llAddrPos ++ // move beyond last entry
do while llAddrPos < 6
	lsAddr = "*from_addr" + String(llAddrPos) + "*"
	lsFormat = uf_Replace(lsFormat,lsAddr,space(25))
	llAddrPos ++
loop
//
// Zone B
//
//	
// To Address - Roll up addresses if not all present
//
llAddrPos = 0
If lstrparms.String_Arg[7] > ' ' Then
	llAddrPos ++
	lsAddr = "*to_addr" + String(llAddrPos) + "*" // Customer Name - addr_1
	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[7],45))
	
End If

// we validated the warehouse id earlier, there will be data
llAddrPos ++
lsAddr = "*to_addr" + String(llAddrPos) + "*" // Walgreens 4 digit warehouse id
lsFormat = uf_Replace(lsFormat,lsAddr, lsWarehouseID )

If lstrparms.String_Arg[8] > ' ' Then
	llAddrPos ++
	lsAddr = "*to_addr" + String(llAddrPos) + "*"  // street 1 - addr_3
	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[8],45))
End If
If lstrparms.String_Arg[9] > ' ' Then
	llAddrPos ++
	lsAddr = "*to_addr" + String(llAddrPos) + "*" // street 2 - addr_4
	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[9],45))
End If
If lstrparms.String_Arg[11] > ' ' Then
	llAddrPos ++
	lsAddr = "*to_addr" + String(llAddrPos) + "*"  //city state zip country  - addr_5
	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[11],45))
End If
//
// zap all the left over from address fields
//
llAddrPos ++ // move beyond last entry
do while llAddrPos < 6
	lsAddr = "*to_addr" + String(llAddrPos) + "*"
	lsFormat = uf_Replace(lsFormat,lsAddr,space(30))
	llAddrPos ++
loop
//
// Zone C
//
//Ship To Post Code
lsFormat = uf_Replace(lsFormat,"*ship2post*",left(lstrparms.String_Arg[33],12), 12 ) 
//Ship To Post Code (BARCODE)	
lsFormat = uf_Replace(lsFormat,"*ship2postbarcode*",left(lstrparms.String_Arg[41],12)) 
//
// Zone D
//
lsFormat = uf_Replace(lsFormat,"*carriername*",left(lstrparms.String_Arg[62],30),30)
lsFormat = uf_Replace(lsFormat,"*carrierscac*",Upper( left(lstrparms.String_Arg[61],20 ) ) ,20)
lsFormat = uf_Replace(lsFormat,"*pro*",left(lstrparms.String_Arg[45],15),15)
lsFormat = uf_Replace(lsFormat,"*invoice*",left(lstrparms.String_Arg[17],15),15)
//
// Zone E
//
lsFormat = uf_Replace(lsFormat,"*custorderno*",left(lstrparms.String_Arg[13],12),12)
lsFormat = uf_Replace(lsFormat,"*weight*", lsweight  )
//
// Zone F
//
lsFormat = uf_Replace(lsFormat,"*vendor*",left(lstrparms.String_Arg[64],30),30)
lsFormat = uf_Replace(lsFormat,"*90vendorbc*",left(lstrparms.String_Arg[64],30)) 
//
// Zone G
//
lsFor = lsDuns + lsWarehouseID
lsFormat = uf_Replace(lsFormat,"*for91hr*",lsFor, len( lsFor))
lsFormat = uf_Replace(lsFormat,"*for91bc*",lsFor, len( lsFor))
// 
// Zone H
//
lsFormat = uf_Replace(lsFormat,"*id*", lsWarehouseID )
//
// Zone I
//
setSSCCValues()
lsFormat = uf_Replace(lsFormat,"(00) 9 9999999 999999999 9",getSSCCFormatted( ) )
lsFormat = uf_Replace(lsFormat,"800999999999999999995",getSSCCRawData( ) )
//No of copies
ll_no_of_copies = lstrparms.Long_Arg[1]
FOR i= 1 TO ll_no_of_copies
	PrintSend(llPrintJob, lsformat)	
	ls_temp= lstrparms.String_Arg[28]
NEXT
	
PrintClose(llPrintJob)
	

Return 0


end function

public subroutine setlabelsequence (integer _value);// setLabelSequence( integer _value )

if _value > 9999 then _value = 1
iiLabelSequence = _value

end subroutine

public function integer getlabelsequence ();// integer = getLabelSequence()
return iiLabelSequence

end function

public function string getssccpos3to10 ();// string = getSCCpos3to10()
return isSSCC310

end function

public subroutine setssccvalues ();// setSSCCValues()

// (00) 9 9999999 999999999.9

/*
Position
 1- 2 			(00), Parenthesis not counted as positions but print on label
 3-10			Hardcode '00885967 '
11				last digit of today's year
12-13		todays month
14-15 		todays day
16-19		Sequential number, incremented by 1 ( one ) for every label printed, wrap to 0001when after it hits 9999
20				calculated check digit
*/
string parens = '(00) '
string seqFormat = '0000'
string pos11
string pos1213
string pos1415
string pos1619
string rawdata

pos11 		= right( String( year( today() )),1)
pos1213 	= String( month( today() ), "00" )
pos1415 	= String( day( today() ), "00" )
pos1619 	= String( getLabelSequence(), seqFormat )

rawdata = getSSCCpos3to10() + pos11 + pos1213 + pos1415 + pos1619
rawdata += String ( f_calc_uccs_check_digit( rawdata ) )

setSSCCRawData( rawdata )
setSSCCFormatted( parens + string( LongLong( rawdata) , '0 0000000 000000000 0' ))

return



end subroutine

public subroutine setssccrawdata (string _value);// setSSCCRawData( string _value )
isSSCCRawData = _value

end subroutine

public function string getssccrawdata ();// string = getSSCCRawData()
return isSSCCRawData

end function

public subroutine setssccformatted (string _value);// setSSCCFormatted( string _value )
isSSCCFormatted = _value

end subroutine

public function string getssccformatted ();// string = getSSCCFormatted()
return isSSCCFormatted

end function

public function string uf_replace (string asstring, string asoldvalue, string asnewvalue, integer ilength);// string = uf_replace( string asstring, string asoldvalue, string asnewvalue, integer ilength )

String	lsString
Long	llPos

if isNull( asNewValue) then asNewValue = space( ilength )

lsString = asString
llPos = Pos(lsString,asOldValue)

Do While llPos > 0 
	lsString = Replace(lsString,llPos,len(asOldValue), asNewValue) 
	llPos = Pos(lsString,asOldValue)
Loop

REturn lsString
end function

public function int print ();// int = print()

return 0

end function

public subroutine setparms (str_parms _parms);// setParms( str_parms _parms )
istrparms = _parms

end subroutine

public function str_parms getparms ();// str_parms = getParms()
return istrparms

end function

public function string getlabelformat ();// string = getLabelFormatFile()
return isLabelFormatFile

end function

public function integer setlabeladdress ();// integer = setLabelAddress()
return 0

end function

public subroutine setlabelformat (string _format);// setLabelFormatFile( string _format )
isLabelFormatFile = _format

end subroutine

public subroutine setformat (string _format);// setformat( string _format )
isformat = _format

end subroutine

public function string getformat ();// string = getformat()
return isformat

end function

public subroutine setlabelformatfile (string _format);// setLabelFormatFile( string _format )
isLabelFormatFile = _format

end subroutine

public function string getlabelformatfile ();// string = getLabelFormatFile()
return isLabelFormatFile

end function

public function integer uf_scitex_zebra_ship (any as_array);
//This function will print  Generic UCCS Shipping label

Str_parms	lStrparms
String	lsFormat,	&
			lsCartonBarcode,	&
			lsTemp,				&
			lsPrintText,		&
			lsAddr,ls_weight,ls_temp,	&
			lsUCCCarton

Long	llPrintJob,	&
		llPos,		&
		llPrintQty,	&
		llPrintPos,	&
		llCartonNo,	&
		llAddrPos,i,j,ll_no_of_copies
		
Integer	liFileNo, liCheck


lstrparms = as_array

lsFormat = uf_read_label_Format('scitex_shipping_label.txt')

	
lsPrintText = 'Scitex Ship - Zebra'


//Open Printer File 
llPrintJob = PrintOpen(lsPrintText)
	
If llPrintJob <0 Then 
	Messagebox('Labels', 'Unable to open Printer file. Labels will not be printed')
	Return -1
End If

//We are looping once for each Qty of label being printed - The carton number is changing so we need to bump after each one.
//Replace placeholders in Format with Field Values

//From Address - Roll up addresses if not all present
	
llAddrPos = 0

If lstrparms.String_Arg[2] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + "~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[2],30))
End If
	
If lstrparms.String_Arg[3] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + "~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[3],30))
End If

If lstrparms.String_Arg[4] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + "~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[4],30))
End If

If lstrparms.String_Arg[6] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + "~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[6],30))
End If

For llAddrPos = llAddrPos to 5 /*each detail row */
	lsAddr = "~~from_addr" + String(llAddrPos) + "~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,'',30)
Next

//To Address - Roll up addresses if not all present

llAddrPos = 0

If lstrparms.String_Arg[7] > ' ' Then //Customer Name
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos)  + "~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[7],45))
End If

If lstrparms.String_Arg[8] > ' ' Then //Address 1
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[8],45))
End If

If lstrparms.String_Arg[9] > ' ' Then //Address 2
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~" 
	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[9],45))
End If

If lstrparms.String_Arg[11] > ' ' Then //City,state,zip
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~"  
	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[11],45))
End If

If lstrparms.String_Arg[30] > ' ' Then //To Country
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~" 
	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[30],45))
End If

For llAddrPos = llAddrPos to 5 /*each detail row */
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,'',30)
Next
	
//Ship To Post Code (BARCODE)	
//lsFormat = uf_Replace(lsFormat,"~~ship_to_zip_BC,0008~~",left(lstrparms.String_Arg[33],8)) /* 12/03 - PCONKL - For UCCS Label */
	
	
//User Field4
If lstrparms.String_Arg[34] > ' ' Then 
	lsFormat = uf_Replace(lsFormat,"~~user_field4~~",left(lstrparms.String_Arg[34],30))
	lsFormat = uf_Replace(lsFormat,"~~user_field4_bc~~",left(lstrparms.String_Arg[34],30))
Else
	lsFormat = uf_Replace(lsFormat,"~~user_field4~~",'',30)
	lsFormat = uf_Replace(lsFormat,"~~user_field4_bc~~",'',30)
End If	


//Cust Order No
If lstrparms.String_Arg[13] > ' ' Then 
	lsFormat = uf_Replace(lsFormat,"~~cust_order_no~~",left(lstrparms.String_Arg[13],30))
	lsFormat = uf_Replace(lsFormat,"~~cust_order_no2~~",left(lstrparms.String_Arg[13],30))
	lsFormat = uf_Replace(lsFormat,"~~cust_order_no2_bc~~",left(lstrparms.String_Arg[13],30))
else
	lsFormat = uf_Replace(lsFormat,"~~cust_order_no~~",'',30)
	lsFormat = uf_Replace(lsFormat,"~~cust_order_no2~~",'',30)
	lsFormat = uf_Replace(lsFormat,"~~cust_order_no2_bc~~",'',30)
end if

//Invoice NO
	lsFormat = uf_Replace(lsFormat,"~~invoice_no~~",Left(lstrparms.String_Arg[17],20))	
	lsFormat = uf_Replace(lsFormat,"~~invoice_no2~~",Left(lstrparms.String_Arg[17],20))	
	lsFormat = uf_Replace(lsFormat,"~~invoice_no_bc~~",Left(lstrparms.String_Arg[17],20))	

//Request Date
lsFormat = uf_Replace(lsFormat,"~~request_date~~",Left(lstrparms.String_Arg[18],20))	
	
//Last User
lsFormat = uf_Replace(lsFormat,"~~last_user~~",Left(lstrparms.String_Arg[19],20))	
	
//Agent Info
If lstrparms.String_Arg[20] > ' ' Then 
	lsFormat = uf_Replace(lsFormat,"~~agent_info~~",Left(lstrparms.String_Arg[20],20))	
	lsFormat = uf_Replace(lsFormat,"~~agent_info_bc~~",Left(lstrparms.String_Arg[20],20))	
else
	lsFormat = uf_Replace(lsFormat,"~~agent_info~~",'',20)	
	lsFormat = uf_Replace(lsFormat,"~~agent_info_bc~~",'',20)	

end if

//Carrier Name
If lstrparms.String_Arg[25] > ' ' Then 
	lsFormat = uf_Replace(lsFormat,"~~carrier~~",left(lstrparms.String_Arg[25],30))
else
	lsFormat = uf_Replace(lsFormat,"~~carrier~~",'',30)
end if
	
//No of copies
ll_no_of_copies = lstrparms.Long_Arg[1]
FOR i= 1 TO ll_no_of_copies
//	lsFormat = uf_Replace(lsFormat,"~~tot_off,0030~~",left(lstrparms.String_Arg[28],30))
	PrintSend(llPrintJob, lsformat)	
	ls_temp= lstrparms.String_Arg[28]
NEXT

PrintClose(llPrintJob)
	

Return 0


end function

public function integer uf_bluecoat_shipping_intermec (any as_array);
//This function will print  Bluecoat Shipping label on an intermec printer

Str_parms	lStrparms
String	lsFormat,	&
			lsCartonBarcode,	&
			lsTemp,				&
			lsPrintText,		&
			lsAddr,ls_weight,ls_temp,	&
			lsUCCCarton

Long	llPrintJob,	&
		llPos,		&
		llPrintQty,	&
		llPrintPos,	&
		llCartonNo,	&
		llAddrPos,i,j,ll_no_of_copies
		
Integer	liFileNo, liCheck


lstrparms = as_array

lsFormat = uf_read_label_Format('bluecoat_intermec_shipping_label.txt') 
		
	
lsPrintText = 'UCCS Ship - INTERMEC'


//Open Printer File 
llPrintJob = PrintOpen(lsPrintText)
	
If llPrintJob <0 Then 
	Messagebox('Labels', 'Unable to open Printer file. Labels will not be printed')
	Return -1
End If

//We are looping once for each Qty of label being printed - The carton number is changing so we need to bump after each one.
//Replace placeholders in Format with Field Values

//From Address - Roll up addresses if not all present
	
llAddrPos = 0

If lstrparms.String_Arg[2] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + "~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[2],30))
End If
	
If lstrparms.String_Arg[3] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + "~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[3],30))
End If

If lstrparms.String_Arg[4] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + "~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[4],30))
End If

If lstrparms.String_Arg[5] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + "~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[5],30))
End If
	
If lstrparms.String_Arg[31] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + "~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[31],45))
End If
	
If lstrparms.String_Arg[6] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + "~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[6],30))
End If

If lstrparms.String_Arg[29] > ' ' Then 
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + "~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[29],45))
End If

do while llAddrPos < 5
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + "~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,'')
loop
	
//To Address - Roll up addresses if not all present

llAddrPos = 0

If lstrparms.String_Arg[7] > ' ' Then
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~" //Customer Name
	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[7],45))
End If

If lstrparms.String_Arg[8] > ' ' Then
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~" //Address1
	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[8],45))
End If

If lstrparms.String_Arg[9] > ' ' Then
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~" //Address2
	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[9],45))
End If

If lstrparms.String_Arg[10] > ' ' Then
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~" //Address3
	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[10],45))
End If

If lstrparms.String_Arg[32] > ' ' Then //Address4
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[32],45))
End If

If lstrparms.String_Arg[11] > ' ' Then //City,state,zip
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[11],45))
End If

If lstrparms.String_Arg[30] > ' ' Then //To Country
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[30],45))
End If

do while llAddrPos < 5
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,'')
loop

//Ship To Post Code and Barcode
If  lstrparms.String_Arg[33] > '' Then
lsFormat = uf_Replace(lsFormat,"~~ship2postzip~~",left(lstrparms.String_Arg[33],12)) 
lsFormat = uf_Replace(lsFormat,"~~ship2postbarcode~~",left(lstrparms.String_Arg[33],8))
Else
lsFormat = uf_Replace(lsFormat,"~~ship2postzip~~",'') 
lsFormat = uf_Replace(lsFormat,"~~ship2postbarcode~~",'') 
End If
	
//AWB
If  lstrparms.String_Arg[34] > '' Then
lsFormat = uf_Replace(lsFormat,"~~awb_bol_nbr~~",left(lstrparms.String_Arg[34],12)) /* 12/03 - PCONKL - For UCCS Label */
Else
lsFormat = uf_Replace(lsFormat,"~~awb_bol_nbr~~",left(lstrparms.String_Arg[34],12)) /* 12/03 - PCONKL - For UCCS Label */
End If

//Carton no (UCCS Label) - 
If  lstrparms.String_Arg[35] > '' Then
	lsUCCCarton = "0" + lstrparms.String_Arg[35] + Right(String(Long(lstrparms.String_Arg[12]),'000000000'),9) /*Prepend UCCS Info - 0 (futire use) + Warehouse Prefix + Company Prefix) */		
	liCheck = f_calc_uccs_check_Digit(lsUCCCarton) /*calculate the check digit*/
	If liCheck >=0 Then
		lsuccCarton = "00" + lsUccCarton + String(liCheck) /* add 00 at beginning (not part of check digit calculation but included as tag */
	Else
		lsUccCarton = String(Long(lstrparms.String_Arg[12]),'00000000000000000000')
	End If
Else
	lsUccCarton = String(Long(lstrparms.String_Arg[12]),'00000000000000000000')
End If
	
lsFormat = uf_Replace(lsFormat,"~~carton_nbr_barcode~~",lsUCCCarton)
lsFormat = uf_Replace(lsFormat,"~~carton_nbr~~",Right(lsUCCCarton,18)) /* 00 already on label as text field but included in barcode*/
	
	
//Customer_order_number
If  lstrparms.String_Arg[13] > '' Then
lsFormat = uf_Replace(lsFormat,"~~Cust_order_nbr~~",left(lstrparms.String_Arg[13],30))
Else
lsFormat = uf_Replace(lsFormat,"~~Cust_order_nbr~~",'')
End If

//Sku
lsFormat = uf_Replace(lsFormat,"~~sku_no~~",left(lstrparms.String_Arg[14],30))//Alternate sku

//Weight	
If isNull(lstrparms.Long_Arg[5]) Then lstrparms.Long_Arg[5] = 0
If isNull(lstrparms.Long_Arg[6]) Then lstrparms.Long_Arg[6] = 0

lsFormat = uf_Replace(lsFormat,"~~Weight~~",String(lstrparms.Long_Arg[5],'######.###0') + "LBs / " + String(lstrparms.Long_Arg[6],'######.###0') + "KGs") /* 12/03 - PCONKL - Weight for UCCS */
	

//Invoice NO
If  lstrparms.String_Arg[17] > '' Then
lsFormat = uf_Replace(lsFormat,"~~sales_order_nbr~~",Left(lstrparms.String_Arg[17],20))	
Else
lsFormat = uf_Replace(lsFormat,"~~sales_order_nbr~~",'')	
End If

//Today's date 
lsFormat = uf_Replace(lsFormat,"~~Ship_Date~~",string(today(),"mmm dd, yyyy"))
	
//Carrier Name
If  lstrparms.String_Arg[25] > '' Then
lsFormat = uf_Replace(lsFormat,"~~Carrier~~",left(lstrparms.String_Arg[25],30))
Else
lsFormat = uf_Replace(lsFormat,"~~Carrier~~",'')
End If

//Tracking shipper No
lsFormat = uf_Replace(lsFormat,"~~tracker_id~~",left(lstrparms.String_Arg[27],30))
	
//No of copies
ll_no_of_copies = lstrparms.Long_Arg[1]
FOR i= 1 TO ll_no_of_copies
	lsFormat = uf_Replace(lsFormat,"~~Box~~",left(lstrparms.String_Arg[28],30))
	PrintSend(llPrintJob, lsformat)	
	ls_temp= lstrparms.String_Arg[28]
NEXT
	
PrintClose(llPrintJob)
	

Return 0


end function

public function integer uf_ingram_shipping_intermec (any as_array);
//This function will print  Ingram Shipping label on an intermec printer

Str_parms	lStrparms
String	lsFormat,	&
			lsCartonBarcode,	&
			lsTemp,				&
			lsPrintText,		&
			lsAddr,ls_weight,ls_temp,	&
			lsUCCCarton

Long	llPrintJob,	&
		llPos,		&
		llPrintQty,	&
		llPrintPos,	&
		llCartonNo,	&
		llAddrPos,i,j,ll_no_of_copies
		
Integer	liFileNo, liCheck


lstrparms = as_array

lsFormat = uf_read_label_Format('ingram_intermec_shipping_label.txt') 
		
	
lsPrintText = 'UCCS Ship - INTERMEC'


//Open Printer File 
llPrintJob = PrintOpen(lsPrintText)
	
If llPrintJob <0 Then 
	Messagebox('Labels', 'Unable to open Printer file. Labels will not be printed')
	Return -1
End If

//We are looping once for each Qty of label being printed - The carton number is changing so we need to bump after each one.
//Replace placeholders in Format with Field Values

//From Address - Roll up addresses if not all present
	
llAddrPos = 0

If lstrparms.String_Arg[2] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + "~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[2],30))
End If
	
If lstrparms.String_Arg[3] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + "~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[3],30))
End If

If lstrparms.String_Arg[4] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + "~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[4],30))
End If

If lstrparms.String_Arg[5] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + "~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[5],30))
End If
	
If lstrparms.String_Arg[31] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + "~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[31],45))
End If
	
If lstrparms.String_Arg[6] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + "~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[6],30))
End If

If lstrparms.String_Arg[29] > ' ' Then 
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + "~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[29],45))
End If

do while llAddrPos < 5
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + "~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,'')
loop
	
//To Address - Roll up addresses if not all present

llAddrPos = 0

If lstrparms.String_Arg[7] > ' ' Then
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~" //Customer Name
	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[7],45))
End If

If lstrparms.String_Arg[8] > ' ' Then
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~" //Address1
	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[8],45))
End If

If lstrparms.String_Arg[9] > ' ' Then
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~" //Address2
	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[9],45))
End If

If lstrparms.String_Arg[10] > ' ' Then
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~" //Address3
	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[10],45))
End If

If lstrparms.String_Arg[32] > ' ' Then //Address4
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[32],45))
End If

If lstrparms.String_Arg[11] > ' ' Then //City,state,zip
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[11],45))
End If

If lstrparms.String_Arg[30] > ' ' Then //To Country
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[30],45))
End If

do while llAddrPos < 5
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,'')
loop

//Ship To Post Code and Barcode
If  lstrparms.String_Arg[33] > '' Then
lsFormat = uf_Replace(lsFormat,"~~ship2postzip~~",left(lstrparms.String_Arg[33],12)) 
lsFormat = uf_Replace(lsFormat,"~~ship2postbarcode~~",left(lstrparms.String_Arg[33],8))
Else
lsFormat = uf_Replace(lsFormat,"~~ship2postzip~~",'') 
lsFormat = uf_Replace(lsFormat,"~~ship2postbarcode~~",'') 
End If
	
//AWB
If  lstrparms.String_Arg[34] > '' Then
lsFormat = uf_Replace(lsFormat,"~~awb_bol_nbr~~",left(lstrparms.String_Arg[34],12)) /* 12/03 - PCONKL - For UCCS Label */
Else
lsFormat = uf_Replace(lsFormat,"~~awb_bol_nbr~~",left(lstrparms.String_Arg[34],12)) /* 12/03 - PCONKL - For UCCS Label */
End If

//Carton no (UCCS Label) - 
If  lstrparms.String_Arg[35] > '' Then
	lsUCCCarton = "0" + lstrparms.String_Arg[35] + Right(String(Long(lstrparms.String_Arg[12]),'000000000'),9) /*Prepend UCCS Info - 0 (futire use) + Warehouse Prefix + Company Prefix) */		
	liCheck = f_calc_uccs_check_Digit(lsUCCCarton) /*calculate the check digit*/
	If liCheck >=0 Then
		lsuccCarton = "00" + lsUccCarton + String(liCheck) /* add 00 at beginning (not part of check digit calculation but included as tag */
	Else
		lsUccCarton = String(Long(lstrparms.String_Arg[12]),'00000000000000000000')
	End If
Else
	lsUccCarton = String(Long(lstrparms.String_Arg[12]),'00000000000000000000')
End If
	
lsFormat = uf_Replace(lsFormat,"~~carton_nbr_barcode~~",lsUCCCarton)
lsFormat = uf_Replace(lsFormat,"~~carton_nbr~~",Right(lsUCCCarton,18)) /* 00 already on label as text field but included in barcode*/
	
	
//Customer_order_number
If  lstrparms.String_Arg[13] > '' Then
	lsFormat = uf_Replace(lsFormat,"~~Cust_order_nbr~~",left(lstrparms.String_Arg[13],30))
Else
	lsFormat = uf_Replace(lsFormat,"~~Cust_order_nbr~~",'')
End If

//Ship Ref
If  lstrparms.String_Arg[14] > '' Then
	lsFormat = uf_Replace(lsFormat,"~~ship_ref~~",left(lstrparms.String_Arg[14],30))
Else
	lsFormat = uf_Replace(lsFormat,"~~ship_ref~~",'')
End IF
//Transport Mode
If  lstrparms.String_Arg[15] > '' Then
	lsFormat = uf_Replace(lsFormat,"~~schedule_code~~",left(lstrparms.String_Arg[15],30))
Else
	lsFormat = uf_Replace(lsFormat,"~~schedule_code~~",'')
End IF

//Freight Terms
If  lstrparms.String_Arg[18] > '' Then
	lsFormat = uf_Replace(lsFormat,"~~freight_terms~~",left(lstrparms.String_Arg[18],30))
Else
	lsFormat = uf_Replace(lsFormat,"~~freight_terms~~",'')
End IF

//Packing List Inclosed
If  lstrparms.String_Arg[19] > '' Then
	lsFormat = uf_Replace(lsFormat,"~~pack_slip_text1~~",left(lstrparms.String_Arg[19],30))
	lsFormat = uf_Replace(lsFormat,"~~pack_slip_text2~~",left(lstrparms.String_Arg[20],30))
Else
	lsFormat = uf_Replace(lsFormat,"~~pack_slip_text1~~",'')
	lsFormat = uf_Replace(lsFormat,"~~pack_slip_text2~~",'')
End IF

//Piece Count
	lsFormat = uf_Replace(lsFormat,"~~piece_count~~",String(lstrparms.Long_Arg[1],'#####'))

//Weight	
If isNull(lstrparms.Long_Arg[5]) Then lstrparms.Long_Arg[5] = 0
If isNull(lstrparms.Long_Arg[6]) Then lstrparms.Long_Arg[6] = 0

lsFormat = uf_Replace(lsFormat,"~~Weight~~",String(lstrparms.Long_Arg[5],'######.#0')) /* 12/03 - PCONKL - Weight for UCCS */
	

//Invoice NO
If  lstrparms.String_Arg[17] > '' Then
lsFormat = uf_Replace(lsFormat,"~~sales_order_nbr~~",Left(lstrparms.String_Arg[17],20))	
Else
lsFormat = uf_Replace(lsFormat,"~~sales_order_nbr~~",'')	
End If

//Today's date 
lsFormat = uf_Replace(lsFormat,"~~Ship_Date~~",string(today(),"yyyy/mm/dd"))
lsFormat = uf_Replace(lsFormat,"~~Time~~",string(now(),"hh:mm"))
	
//Carrier Name
If  lstrparms.String_Arg[25] > '' Then
lsFormat = uf_Replace(lsFormat,"~~Carrier~~",left(lstrparms.String_Arg[25],30))
Else
lsFormat = uf_Replace(lsFormat,"~~Carrier~~",'')
End If

//Tracking shipper No
If  lstrparms.String_Arg[27] > '' Then
	lsFormat = uf_Replace(lsFormat,"~~tracker_id~~",left(lstrparms.String_Arg[27],30))
	lsFormat = uf_Replace(lsFormat,"~~tracking_id_bc~~",left(lstrparms.String_Arg[27],30))
Else	
		lsFormat = uf_Replace(lsFormat,"~~tracker_id~~",'')
	lsFormat = uf_Replace(lsFormat,"~~tracking_id_bc~~",'')

End If
	
//No of copies
ll_no_of_copies = lstrparms.Long_Arg[1]
FOR i= 1 TO ll_no_of_copies
	lsFormat = uf_Replace(lsFormat,"~~Box~~",left(lstrparms.String_Arg[28],30))
	PrintSend(llPrintJob, lsformat)	
	ls_temp= lstrparms.String_Arg[28]
NEXT
	
PrintClose(llPrintJob)
	

Return 0


end function

public function integer uf_generic_intermec_shipping_label (any as_array);
//This function will print Generic Shipping label on an intermec printer

Str_parms	lStrparms
String	lsFormat,	&
			lsCartonBarcode,	&
			lsTemp,				&
			lsPrintText,		&
			lsAddr,ls_weight,ls_temp,	&
			lsUCCCarton

Long	llPrintJob,	&
		llPos,		&
		llPrintQty,	&
		llPrintPos,	&
		llCartonNo,	&
		llAddrPos,i,j,ll_no_of_copies
		
Integer	liFileNo, liCheck


lstrparms = as_array

lsFormat = uf_read_label_Format('generic_intermec_shipping_label.txt') 
		
	
lsPrintText = 'UCCS Ship - INTERMEC'


//Open Printer File 
llPrintJob = PrintOpen(lsPrintText)
	
If llPrintJob <0 Then 
	Messagebox('Labels', 'Unable to open Printer file. Labels will not be printed')
	Return -1
End If

//We are looping once for each Qty of label being printed - The carton number is changing so we need to bump after each one.
//Replace placeholders in Format with Field Values

//From Address - Roll up addresses if not all present
	
llAddrPos = 0

If lstrparms.String_Arg[2] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + "~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[2],30))
End If
	
If lstrparms.String_Arg[3] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + "~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[3],30))
End If

If lstrparms.String_Arg[4] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + "~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[4],30))
End If

If lstrparms.String_Arg[5] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + "~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[5],30))
End If
	
If lstrparms.String_Arg[31] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + "~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[31],45))
End If
	
If lstrparms.String_Arg[6] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + "~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[6],30))
End If

If lstrparms.String_Arg[29] > ' ' Then 
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + "~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[29],45))
End If

do while llAddrPos < 5
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + "~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,'')
loop
	
//To Address - Roll up addresses if not all present

llAddrPos = 0

If lstrparms.String_Arg[7] > ' ' Then
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~" //Customer Name
	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[7],45))
End If

If lstrparms.String_Arg[8] > ' ' Then
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~" //Address1
	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[8],45))
End If

If lstrparms.String_Arg[9] > ' ' Then
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~" //Address2
	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[9],45))
End If

If lstrparms.String_Arg[10] > ' ' Then
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~" //Address3
	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[10],45))
End If

If lstrparms.String_Arg[32] > ' ' Then //Address4
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[32],45))
End If

If lstrparms.String_Arg[11] > ' ' Then //City,state,zip
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[11],45))
End If

If lstrparms.String_Arg[30] > ' ' Then //To Country
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[30],45))
End If

do while llAddrPos < 5
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,'')
loop

//Ship To Post Code and Barcode
If  lstrparms.String_Arg[33] > '' Then
lsFormat = uf_Replace(lsFormat,"~~ship2postzip~~",left(lstrparms.String_Arg[33],12)) 
lsFormat = uf_Replace(lsFormat,"~~ship2postbarcode~~",left(lstrparms.String_Arg[33],8))
Else
lsFormat = uf_Replace(lsFormat,"~~ship2postzip~~",'') 
lsFormat = uf_Replace(lsFormat,"~~ship2postbarcode~~",'') 
End If
	
//AWB
If  lstrparms.String_Arg[34] > '' Then
lsFormat = uf_Replace(lsFormat,"~~awb_bol_nbr~~",left(lstrparms.String_Arg[34],12)) /* 12/03 - PCONKL - For UCCS Label */
Else
lsFormat = uf_Replace(lsFormat,"~~awb_bol_nbr~~",'')
End If

//Carton no (UCCS Label) - 
If  lstrparms.String_Arg[35] > '' Then
	lsUCCCarton = "0" + lstrparms.String_Arg[35] + Right(String(Long(lstrparms.String_Arg[12]),'000000000'),9) /*Prepend UCCS Info - 0 (futire use) + Warehouse Prefix + Company Prefix) */		
	liCheck = f_calc_uccs_check_Digit(lsUCCCarton) /*calculate the check digit*/
	If liCheck >=0 Then
		lsuccCarton = "00" + lsUccCarton + String(liCheck) /* add 00 at beginning (not part of check digit calculation but included as tag */
	Else
		lsUccCarton = String(Long(lstrparms.String_Arg[12]),'00000000000000000000')
	End If
Else
	lsUccCarton = String(Long(lstrparms.String_Arg[12]),'00000000000000000000')
End If
	
lsFormat = uf_Replace(lsFormat,"~~carton_nbr_barcode~~",lsUCCCarton)
lsFormat = uf_Replace(lsFormat,"~~carton_nbr~~",Right(lsUCCCarton,18)) /* 00 already on label as text field but included in barcode*/
	
	
//Customer_order_number
If  lstrparms.String_Arg[13] > '' Then
lsFormat = uf_Replace(lsFormat,"~~Cust_order_nbr~~",left(lstrparms.String_Arg[13],30))
Else
lsFormat = uf_Replace(lsFormat,"~~Cust_order_nbr~~",'')
End If

//Sku
lsFormat = uf_Replace(lsFormat,"~~sku_no~~",left(lstrparms.String_Arg[14],30))//Alternate sku

//Weight	
If isNull(lstrparms.Long_Arg[5]) Then lstrparms.Long_Arg[5] = 0
If isNull(lstrparms.Long_Arg[6]) Then lstrparms.Long_Arg[6] = 0

lsFormat = uf_Replace(lsFormat,"~~Weight~~",String(lstrparms.Long_Arg[5],'######.###0') + "LBs / " + String(lstrparms.Long_Arg[6],'######.###0') + "KGs") /* 12/03 - PCONKL - Weight for UCCS */
	

//Invoice NO
If  lstrparms.String_Arg[17] > '' Then
lsFormat = uf_Replace(lsFormat,"~~sales_order_nbr~~",Left(lstrparms.String_Arg[17],20))	
Else
lsFormat = uf_Replace(lsFormat,"~~sales_order_nbr~~",'')	
End If

//Today's date 
lsFormat = uf_Replace(lsFormat,"~~Ship_Date~~",string(today(),"mmm dd, yyyy"))
	
//Carrier Name
If  lstrparms.String_Arg[25] > '' Then
lsFormat = uf_Replace(lsFormat,"~~Carrier~~",left(lstrparms.String_Arg[25],30))
Else
lsFormat = uf_Replace(lsFormat,"~~Carrier~~",'')
End If

//Tracking shipper No
If  lstrparms.String_Arg[27] > '' Then
lsFormat = uf_Replace(lsFormat,"~~tracker_id~~",left(lstrparms.String_Arg[27],30))
Else
lsFormat = uf_Replace(lsFormat,"~~tracker_id~~",'')
End If
	
//No of copies
ll_no_of_copies = lstrparms.Long_Arg[1]
FOR i= 1 TO ll_no_of_copies
	lsFormat = uf_Replace(lsFormat,"~~Box~~",left(lstrparms.String_Arg[28],30))
	PrintSend(llPrintJob, lsformat)	
	ls_temp= lstrparms.String_Arg[28]
NEXT
	
PrintClose(llPrintJob)
	

Return 0


end function

public function integer uf_sika_shipping_label_zebra (any as_array);
//This function will print Sika Shipping label

Str_parms	lStrparms
String	lsFormat,	&
			lsCartonBarcode,	&
			lsTemp,				&
			lsPrintText,		&
			lsAddr,ls_weight,ls_temp,	&
			lsUCCCarton

Long	llPrintJob,	&
		llPos,		&
		llPrintQty,	&
		llPrintPos,	&
		llCartonNo,	&
		llAddrPos,i,j,ll_no_of_copies
		
Integer	liFileNo, liCheck


lstrparms = as_array

lsFormat = uf_read_label_Format('Sika_Ship_Zebra.DWN') 
		
	
lsPrintText = 'UCCS Sika Ship - Zebra'


//Open Printer File 
llPrintJob = PrintOpen(lsPrintText)
	
If llPrintJob <0 Then 
	Messagebox('Labels', 'Unable to open Printer file. Labels will not be printed')
	Return -1
End If

//We are looping once for each Qty of label being printed - The carton number is changing so we need to bump after each one.
//Replace placeholders in Format with Field Values

//From Address - Roll up addresses if not all present
	
llAddrPos = 0

If lstrparms.String_Arg[2] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) 
	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[2],30))
End If
	
If lstrparms.String_Arg[3] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) 
	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[3],30))
End If

If lstrparms.String_Arg[4] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos)
	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[4],30))
End If

If lstrparms.String_Arg[5] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) 
	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[5],30))
End If
	
If lstrparms.String_Arg[31] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) 
	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[31],45))
End If
	
If lstrparms.String_Arg[6] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) 
	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[6],30))
End If

If lstrparms.String_Arg[29] > ' ' Then 
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos)
	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[29],45))
End If

//To Address - Roll up addresses if not all present

llAddrPos = 0

If lstrparms.String_Arg[7] > ' ' Then
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos)  //Customer Name
	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[7],45))
End If

If lstrparms.String_Arg[8] > ' ' Then
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) //Address1
	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[8],45))
End If

If lstrparms.String_Arg[9] > ' ' Then
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) //Address2
	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[9],45))
End If

If lstrparms.String_Arg[10] > ' ' Then
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos)   //Address3
	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[10],45))
End If

If lstrparms.String_Arg[32] > ' ' Then //Address4
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) 
	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[32],45))
End If

If lstrparms.String_Arg[11] > ' ' Then //City,state,zip
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) 
	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[11],45))
End If

If lstrparms.String_Arg[30] > ' ' Then //To Country
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) 
	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[30],45))
End If

	
	
		
////Carton no (UCCS Label) - 
//If  lstrparms.String_Arg[35] > '' Then
//	lsUCCCarton = "0" + lstrparms.String_Arg[35] + Right(String(Long(lstrparms.String_Arg[12]),'000000000'),9) /*Prepend UCCS Info - 0 (futire use) + Warehouse Prefix + Company Prefix) */		
//	liCheck = f_calc_uccs_check_Digit(lsUCCCarton) /*calculate the check digit*/
//	If liCheck >=0 Then
//		lsuccCarton = "00" + lsUccCarton + String(liCheck) /* add 00 at beginning (not part of check digit calculation but included as tag */
//	Else
//		lsUccCarton = String(Long(lstrparms.String_Arg[12]),'00000000000000000000')
//	End If
//Else
//	lsUccCarton = String(Long(lstrparms.String_Arg[12]),'00000000000000000000')
//End If
//	

lsFormat = uf_Replace(lsFormat,"~~carton_no_BC~~",lstrparms.String_Arg[12])
	
//Customer Order No
lsFormat = uf_Replace(lsFormat,"~~invoice_no~~",Left(lstrparms.String_Arg[17],20))	

	
//Po No
lsFormat = uf_Replace(lsFormat,"~~po_nbr~~",left(lstrparms.String_Arg[13],30))



	
//Carrier Name
lsFormat = uf_Replace(lsFormat,"~~carrier_name~~",left(lstrparms.String_Arg[25],30))
	
	
//No of copies
ll_no_of_copies = lstrparms.Long_Arg[1]
FOR i= 1 TO ll_no_of_copies
	lsFormat = uf_Replace(lsFormat,"~~tot_off~~",left(lstrparms.String_Arg[28],30))
	PrintSend(llPrintJob, lsformat)	
	ls_temp= lstrparms.String_Arg[28]
NEXT
	
PrintClose(llPrintJob)
	

Return 0


end function

public function integer uf_emu_ceo_receiving_label ();//This function will print  a receiving label for EMU-CEO (Converse)

String	lsFormat,	&
			lsLabel,		&
			lsLabelPrint,	&
			lsPrintText

Long	llPrintJob, llRowPos, llRowCount
Date	ldtPutawayStart
Integer	liFileNo
str_parms	lstrParms


//Load the format
lsFormat = uf_read_label_Format("EMU_CEO_Putaway.txt")
lsPrintText = 'EMU-CEO Putaway Label'


lsLabel = lsFormat

//Format not loaded
If lsFormat = '' Then Return -1

//Get the printer
OpenWithParm(w_label_print_options, lStrParms)
Lstrparms = Message.PowerObjectParm		  
If lstrParms.Cancelled Then Return 0
		
//Open Printer File 
llPrintJob = PrintOpen(lsPrintText)
If llPrintJob <0 Then 
	Messagebox('Labels', 'Unable to open Printer file. Labels will not be printed')
	Return -1
End If


//Loop for each Putaway Row
llRowCount = w_ro.idw_putaway.RowCount()
For lLRowPos = 1 to llRowCount
	
	lsLabel = lsFormat
	
	// Order Nbr
	lsLabel = uf_Replace(lsLabel,"~~ORDER_NO~~",w_ro.idw_Main.GetITemString(1,'Supp_invoice_No')) 
	
	//Putaway Start
	If Not isnull(w_ro.idw_Main.GetITemDateTime(1,'complete_Date'))  Then
		ldtPutawayStart = Date(w_ro.idw_Main.GetITemDateTime(1,'complete_Date'))
	ElseIf Not isnull(w_ro.idw_Main.GetITemDateTime(1,'putaway_start_time'))  Then
		ldtPutawayStart = Date(w_ro.idw_Main.GetITemDateTime(1,'putaway_start_time'))
	Else
		ldtPutawayStart = Date(Now())
	End If
	
	lsLabel = uf_Replace(lsLabel,"~~putaway_start~~",String(ldtPutawayStart,"mm/dd/yyyy"))
	
	//Supplier
	lsLabel = uf_Replace(lsLabel,"~~supp_code~~",w_ro.idw_Putaway.GetITemString(llRowPos,'supp_code')) 
	
	//SKU
	lsLabel = uf_Replace(lsLabel,"~~SKU~~",w_ro.idw_Putaway.GetITemString(llRowPos,'sku'))
	
	//Qty
	If Not isnull(w_ro.idw_Putaway.GetITemNumber(llRowPos,'quantity')) Then
		lsLabel = uf_Replace(lsLabel,"~~qty~~",String(w_ro.idw_Putaway.GetITemNumber(llRowPos,'quantity')))
	End If
	
	//Location
	If Not isnull(w_ro.idw_Putaway.GetITemString(llRowPos,'l_code')) Then
		lsLabel = uf_Replace(lsLabel,"~~l_code~~",String(w_ro.idw_Putaway.GetITemString(llRowPos,'l_code')))
	End If
	
	//Print the current label
	PrintSend(llPrintJob, lsLabel)
		
Next /*Putaway Row */


PrintClose(llPrintJob)

Return 0
end function

public function integer uf_license_tag_lam (ref str_parms _parms);//
// uf_license_tag_lam( any as_array )
//
//This function will print  the License Tag for Lam-SG 
//

Str_parms	lStrparms

String		lsFormat
String		lsPrintText
Long			llPrintJob
long 			copies
int 			index
//
lstrparms = _parms
//
// lstrparms.String_arg[n] where n = 
//
//  1 = label format
//  2 = Expiration Date
//  3 = Quantity
//  4 = Sku
//  5 = Lot No
//  6 = Container (Tag)
//  7 = Uom
//  8 = Location Code
//  9 = Sku Desc
// 10 = Serial
//
// Lstrparms.Long_arg[1] = number of copies

////Load the format
lsPrintText = 'LAM SG License Tag Label'
lsFormat = lstrparms.String_Arg[1]
//Format not loaded
If lsFormat = '' Then Return -1

//Open Printer File 
llPrintJob = PrintOpen(lsPrintText)
If llPrintJob <0 Then 
	Messagebox('Labels', 'Unable to open Printer file. Labels will not be printed')
	Return -1
End If

//Replace placeholders in Format with Field Values

//Container ID
//lsFormat = uf_Replace(lsFormat,"~~tag~~",Right(lstrparms.String_Arg[6],25) )

//date Printed
lsFormat = uf_Replace(lsFormat,"~~dt_print~~",String(Today(),'MM/DD/YYYY'),10)

//QTY
if len(lstrparms.String_Arg[3]) > 0 then
	lsFormat = uf_Replace(lsFormat,"~~qty~~",Left(lstrparms.String_Arg[3],13))
else
	lsFormat = uf_Replace(lsFormat,"~~qty~~","0")
end if

//UOM
if len(lstrparms.String_Arg[7]) > 0 then
	lsFormat = uf_Replace(lsFormat,"~~uom~~",Left(lstrparms.String_Arg[7],6))
else
	lsFormat = uf_Replace(lsFormat,"~~uom~~"," ")
end if

//Location
if len(lstrparms.String_Arg[8]) > 0 then
	lsFormat = uf_Replace(lsFormat,"~~loc~~",Left(lstrparms.String_Arg[8],10))
else
	lsFormat = uf_Replace(lsFormat,"~~loc~~"," ")
end if

//SKU
if len(lstrparms.String_Arg[4]) > 0 then
	lsFormat = uf_Replace(lsFormat,"~~sku~~",Left(lstrparms.String_Arg[4],20))
else
	lsFormat = uf_Replace(lsFormat,"~~sku~~"," ")
end if

//Description
if len(lstrparms.String_Arg[9]) > 0 then
	lsFormat = uf_Replace(lsFormat,"~~part_desc~~",Left(lstrparms.String_Arg[9],40))
else
	lsFormat = uf_Replace(lsFormat,"~~part_desc~~"," ")
end if

// UC1
// UC2
// UC3
// Hold Code
// LOT

if len(lstrparms.String_Arg[5]) > 0 then
	lsFormat = uf_Replace(lsFormat,"~~lot~~",Left(lstrparms.String_Arg[5],10))
else
	lsFormat = uf_Replace(lsFormat,"~~lot~~"," ")
end if

// Expire Date
if len(lstrparms.String_Arg[2]) > 0 then
	lsFormat = uf_Replace(lsFormat,"~~exp_date~~",Left(lstrparms.String_Arg[2],14))
else
	lsFormat = uf_Replace(lsFormat,"~~exp_date~~"," ")
end if

// Serial Number
if Len(lstrparms.String_Arg[10]) > 0  then
	lsFormat = uf_Replace(lsFormat,"~~serial~~",Left(lstrparms.String_Arg[10],50))
else
	lsFormat = uf_Replace(lsFormat,"~~serial~~","")
end if

copies = lstrparms.Long_Arg[1]
if isNull(copies) then copies = 1
//Send to Printer
for index = 1 to copies
	PrintSend(llPrintJob, lsformat)
next

PrintClose(llPrintJob)


Return 0
end function

public function integer uf_lam_zebra_ship (any as_array);
//This function will print  LAM UCCS Shipping label

Str_parms	lStrparms

String		lsFormat, lsPrintText, ls_replace_data
Long		llPrintJob, copies
int 			index

lstrparms = as_array
//
// lstrparms.String_arg[n] where n = 
//
//  1 = label format
//  2 = qty
//  3 = sku
//  4 = cust_part
//  5 = do_no
//  6 = po_no
//  7 = delivery_date		
			
//
// Lstrparms.Long_arg[1] = number of copies

////Load the format
lsPrintText = 'LAM UCCS Ship - Zebra'
lsFormat = uf_read_label_Format('LAM_Ship_Zebra.txt') 
ls_replace_data ="^B3R,N,102,N,N^FD~~sku_bc~~^FS"

//Format not loaded
If lsFormat = '' Then Return -1

//Open Printer File 
llPrintJob = PrintOpen(lsPrintText)
If llPrintJob <0 Then 
	Messagebox('Labels', 'Unable to open Printer file. Labels will not be printed')
	Return -1
End If

//Replace placeholders in Format with Field Values

//Container ID
//lsFormat = uf_Replace(lsFormat,"~~tag~~",Right(lstrparms.String_Arg[6],25) )



//QTY
if len(lstrparms.String_Arg[2]) > 0 then
	lsFormat = uf_Replace(lsFormat,"~~qty~~",Left(lstrparms.String_Arg[2],13))
else
	lsFormat = uf_Replace(lsFormat,"~~qty~~","0")
end if


//SKU  -//28-Dec-2018 :Madhu S27404 Added SKU Barcode
if len(lstrparms.String_Arg[3]) > 0 then
	lsFormat = uf_Replace(lsFormat,"~~sku~~",Left(lstrparms.String_Arg[3],30))
	lsFormat = uf_Replace(lsFormat,"~~sku_bc~~", Left(lstrparms.String_Arg[3],30))
else
	lsFormat = uf_Replace(lsFormat,"~~sku~~"," ")
	lsFormat = uf_Replace(lsFormat, ls_replace_data , "^FD^FS")
end if

//cust_part
if len(lstrparms.String_Arg[4]) > 0 then
	lsFormat = uf_Replace(lsFormat,"~~cust_part~~",Left(lstrparms.String_Arg[4],40))
else
	lsFormat = uf_Replace(lsFormat,"~~cust_part~~"," ")
end if

//do_no

if len(lstrparms.String_Arg[5]) > 0 then
	lsFormat = uf_Replace(lsFormat,"~~do_no~~",Left(lstrparms.String_Arg[5],20))
else
	lsFormat = uf_Replace(lsFormat,"~~do_no~~"," ")
end if

// po_no

if len(lstrparms.String_Arg[6]) > 0 then
	lsFormat = uf_Replace(lsFormat,"~~po_no~~",Left(lstrparms.String_Arg[6],30))
else
	lsFormat = uf_Replace(lsFormat,"~~po_no~~"," ")
end if

// delivery_date

if len(lstrparms.String_Arg[7]) > 0 then
	lsFormat = uf_Replace(lsFormat,"~~delivery_date~~",Left(lstrparms.String_Arg[7],9))
else
	lsFormat = uf_Replace(lsFormat,"~~delivery_date~~"," ")
end if

if len(lstrparms.String_Arg[8]) > 0 AND trim(lstrparms.String_Arg[8]) = "C" then
	lsFormat = uf_Replace(lsFormat,"~~header~~", "Consignment")
else
	lsFormat = uf_Replace(lsFormat,"~~header~~"," ")
end if


if len(lstrparms.String_Arg[9]) > 0 then
	lsFormat = uf_Replace(lsFormat,"~~line_no~~", Left(lstrparms.String_Arg[9],9))
else
	lsFormat = uf_Replace(lsFormat,"~~line_no~~"," ")
end if

copies = lstrparms.Long_Arg[1]
if isNull(copies) then copies = 1
//Send to Printer
for index = 1 to copies
	PrintSend(llPrintJob, lsformat)
next

PrintClose(llPrintJob)


Return 0
end function

public function integer uf_epson_zebra_ship ();//This function will print  Generic UCCS Shipping label

Str_parms	lStrparms
String	lsFormat,	&
			lsCartonBarcode,	&
			lsTemp,				&
			lsPrintText,		&
			lsAddr,ls_weight,ls_temp,	&
			lsUCCCarton,ls_ucc

Long	llPrintJob,	&
		llPos,		&
		llPrintQty,	&
		llPrintPos,	&
		llCartonNo,	&
		llAddrPos,i,j,ll_no_of_copies
		
Integer	liFileNo, liCheck
string ls_label_type	

lstrparms = getparms()

SELECT Cust_Code INTO :ls_label_type FROM Delivery_Master
	WHERE DO_NO = :lstrparms.String_arg[40] USING SQLCA;

ls_label_type = Upper(ls_label_type)

CHOOSE CASE ls_label_type
CASE "TARGET" 
	lsFormat = uf_read_label_Format('EPSON_target_zebra_ship.txt') 
CASE "WALMART"
	lsFormat = uf_read_label_Format('EPSON_walmart_zebra_ship.txt')
CASE "BESTBUY"
	lsFormat = uf_read_label_Format('EPSON_bestbuy_zebra_ship.txt') 
CASE "OFFICEDEPOT", "OFFICEMAX"
	lsFormat = uf_read_label_Format('EPSON_office_zebra_ship.txt')
CASE "SAMYS"
	lsFormat = uf_read_label_Format('EPSON_samys_zebra_ship.txt')
CASE "APPLE"
	lsFormat = uf_read_label_Format('EPSON_apple_zebra_ship.txt')
CASE "STAPLES"
	lsFormat = uf_read_label_Format('EPSON_staples_zebra_ship.txt')

CASE ELSE
//	lsFormat = uf_read_label_Format('generic_zebra_ship_UCC.DWN') 
// TAM 11/12/04  Fix 9 digit postal code (420######)
	lsFormat = uf_read_label_Format('PHX_BRNDS_generic_zebra_ship_UCC.DWN') 
END CHOOSE	
	
lsPrintText = 'UCCS Ship - Zebra'


//Open Printer File 
llPrintJob = PrintOpen(lsPrintText)
	
If llPrintJob <0 Then 
	Messagebox('Labels', 'Unable to open Printer file. Labels will not be printed')
	Return -1
End If

//We are looping once for each Qty of label being printed - The carton number is changing so we need to bump after each one.
//Replace placeholders in Format with Field Values

//From Address - Roll up addresses if not all present
	
llAddrPos = 0


If lstrparms.String_Arg[2] > ' ' Then
	
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + ",0030~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[2],30))
	
	// 12/04 - PCONKL - Labelvision labels don't contain comma and field length in name
	lsAddr = "~~from_addr" + String(llAddrPos) + "~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[2],30))

End If
	
If lstrparms.String_Arg[3] > ' ' Then
	
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + ",0030~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[3],30))
	
	lsAddr = "~~from_addr" + String(llAddrPos) + "~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[3],30))
	
End If


If lstrparms.String_Arg[4] > ' ' Then
	
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + ",0030~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[4],30))
	
	lsAddr = "~~from_addr" + String(llAddrPos) + "~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[4],30))
	
End If

If lstrparms.String_Arg[5] > ' ' Then
	
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + ",0030~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[5],30))
	
	lsAddr = "~~from_addr" + String(llAddrPos) + "~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[5],30))
	
End If
	
If lstrparms.String_Arg[31] > ' ' Then
	
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + ",0030~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[31],45))
	
	lsAddr = "~~from_addr" + String(llAddrPos) + "~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[31],45))
		
End If
	
If lstrparms.String_Arg[6] > ' ' Then
	
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + ",0030~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[6],30))
	
	lsAddr = "~~from_addr" + String(llAddrPos) + "~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[6],30))
	
End If

If lstrparms.String_Arg[29] > ' ' Then 
	
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + ",0030~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[29],45))
	
	lsAddr = "~~from_addr" + String(llAddrPos) + "~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[29],45))
	
End If


//To Address - Roll up addresses if not all present

llAddrPos = 0

If lstrparms.String_Arg[7] > ' ' Then
	
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + ",0045~~" //Customer Name
	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[7],45))
	
	// 12/04 - PCONKL - Labelvision labels don't contain comma and field length in name
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~" //Customer Name
	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[7],45))

End If

If lstrparms.String_Arg[8] > ' ' Then
	
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + ",0045~~" //Address1
	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[8],45))
	
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~" //Address1
	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[8],45))
	
End If

If lstrparms.String_Arg[9] > ' ' Then
	
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + ",0045~~" //Address2
	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[9],45))
	
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~" //Address2
	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[9],45))
	
End If

If lstrparms.String_Arg[10] > ' ' Then
	
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + ",0045~~" //Address3
	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[10],45))
	
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~" //Address3
	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[10],45))
	
End If

If lstrparms.String_Arg[32] > ' ' Then //Address4

	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + ",0045~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[32],45))
	
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[32],45))
	
End If

If lstrparms.String_Arg[11] > ' ' Then //City,state,zip

	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + ",0045~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[11],45))
	
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[11],45))
	
End If

If lstrparms.String_Arg[30] > ' ' Then //To Country

	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + ",0045~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[30],45))
	
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[30],45))
	
End If

//Ship To Post Code
//lsFormat = uf_Replace(lsFormat,"~~ship_to_zip,0012~~",left(lstrparms.String_Arg[33],12)) /* 12/03 - PCONKL - For UCCS Label */
	
//Ship To Post Code (BARCODE)	
//lsFormat = uf_Replace(lsFormat,"~~ship_to_zip_BC,0008~~",left(lstrparms.String_Arg[33],8)) /* 12/03 - PCONKL - For UCCS Label */
	
//AWB
lsFormat = uf_Replace(lsFormat,"~~bol_nbr,0020~~",left(lstrparms.String_Arg[34],12)) /* 12/03 - PCONKL - For UCCS Label */
		
////Carton no (UCCS Label) - 
//If  lstrparms.String_Arg[35] > '' Then
//	lsUCCCarton = "0" + lstrparms.String_Arg[35] + Right(String(Long(lstrparms.String_Arg[12]),'000000000'),9) /*Prepend UCCS Info - 0 (futire use) + Warehouse Prefix + Company Prefix) */		
//	liCheck = f_calc_uccs_check_Digit(lsUCCCarton) /*calculate the check digit*/
//	If liCheck >=0 Then
//		lsuccCarton = "00" + lsUccCarton + String(liCheck) /* add 00 at beginning (not part of check digit calculation but included as tag */
//	Else
//		lsUccCarton = String(Long(lstrparms.String_Arg[12]),'00000000000000000000')
//	End If
//Else
//	lsUccCarton = String(Long(lstrparms.String_Arg[12]),'00000000000000000000')
//End If
//	
//lsFormat = uf_Replace(lsFormat,"~~carton_no_BC,0019~~",lsUCCCarton)
//lsFormat = uf_Replace(lsFormat,"~~carton_no_readable,0018~~",Right(lsUCCCarton,18)) /* 00 already on label as text field but included in barcode*/
//	
	
//Po No
lsFormat = uf_Replace(lsFormat,"~~po_nbr,0030~~",left(lstrparms.String_Arg[13],30))
lsFormat = uf_Replace(lsFormat,"~~po_nbr~~",left(lstrparms.String_Arg[13],30)) /* 12/04 - PCONKL -Labelvision labels*/

//Cust No
lsFormat = uf_Replace(lsFormat,"~~sku_no,0030~~",left(lstrparms.String_Arg[14],30))//Alternate sku

//Weight	
ls_weight = String(lstrparms.Long_Arg[5]) + "/" + String(lstrparms.Long_Arg[6])
lsFormat = uf_Replace(lsFormat,"~~weight,0008~~",ls_weight )
lsFormat = uf_Replace(lsFormat,"~~weight_lbs_no,0030~~",String(lstrparms.Long_Arg[5]))
lsFormat = uf_Replace(lsFormat,"~~weight_kgs_no,0030~~",String(lstrparms.Long_Arg[6]))
lsFormat = uf_Replace(lsFormat,"~~weight,0030~~",String(lstrparms.Long_Arg[5]) + "LBs / " + String(lstrparms.Long_Arg[6]) + "KGs") /* 12/03 - PCONKL - Weight for UCCS */
	
/* 12/04 - PCONKL - Target Casepack*/
//lsFormat = uf_Replace(lsFormat,"~~casepack~~",String(lstrparms.Long_Arg[7]) )

//Invoice NO
lsFormat = uf_Replace(lsFormat,"~~invoice_no,0030~~",Left(lstrparms.String_Arg[17],20))	
lsFormat = uf_Replace(lsFormat,"~~invoice_no~~",Left(lstrparms.String_Arg[17],20))	

//Today's date 
lsFormat = uf_Replace(lsFormat,"~~today,0030~~",string(today(),"mmm dd, yyyy"))
	
//Carrier Name
lsFormat = uf_Replace(lsFormat,"~~carrier_name,0030~~",left(lstrparms.String_Arg[25],30))

lsFormat = uf_Replace(lsFormat,"~~carrier_name,0020~~",left(lstrparms.String_Arg[25],20))
lsFormat = uf_Replace(lsFormat,"~~carrier_name~~",left(lstrparms.String_Arg[25],20))


lsFormat = uf_Replace(lsFormat,"~~casepack~~",left(lstrparms.String_Arg[57],20))
lsFormat = uf_Replace(lsFormat,"~~style~~",left(lstrparms.String_Arg[58],20))
lsFormat = uf_Replace(lsFormat,"~~dbci~~",left(lstrparms.String_Arg[59],20))



lsFormat = uf_Replace(lsFormat,"~~pro,0015~~",left(lstrparms.String_Arg[45],15))
lsFormat = uf_Replace(lsFormat,"~~pro~~",left(lstrparms.String_Arg[45],15))

lsFormat = uf_Replace(lsFormat,"~~bol_nbr,0015~~",left(lstrparms.String_Arg[34],15))

lsFormat = uf_Replace(lsFormat,"~~bol_nbr~~",left(lstrparms.String_Arg[34],15))

string ls_cat

If IsNull(lstrparms.String_Arg[42]) then lstrparms.String_Arg[42] = ""
If IsNull(lstrparms.String_Arg[43]) then lstrparms.String_Arg[43] = ""

lsFormat = uf_Replace(lsFormat,"~~cat,0030~~",left(lstrparms.String_Arg[42] + " " + lstrparms.String_Arg[43],30))
lsFormat = uf_Replace(lsFormat,"~~dbci~~",left(lstrparms.String_Arg[42],9)) /* 12/04 - PCONKL - Target DPCI */

lsFormat = uf_Replace(lsFormat,"~~po_nbr,0030~~",left( lstrparms.String_Arg[13],30))


lsFormat = uf_Replace(lsFormat,"~~ship_to_zip,0012~~",left(lstrparms.String_Arg[41],12))
lsFormat = uf_Replace(lsFormat,"~~ship_to_Zip~~",left(lstrparms.String_Arg[41],12)) /* 12/04 - PCONKL - Labelvision */
lsFormat = uf_Replace(lsFormat,"~~ship_to_zip~~",left(lstrparms.String_Arg[41],12))


// TAM 11/12/04 fix 9 digit postal
lsFormat = uf_Replace(lsFormat,"~~ship_to_zip_BC,0008~~","420"+left(lstrparms.String_Arg[41],12))
lsFormat = uf_Replace(lsFormat,"~~ship_to_zip_BC,0012~~","420"+left(lstrparms.String_Arg[41],12))

//lsFormat = uf_Replace(lsFormat,"~~ship_to_zip_bc~~","420"+left(lstrparms.String_Arg[41],12)) /*12/04 - PCONKL - LabelVision label*/
lsFormat = uf_Replace(lsFormat,">=ship_to_zip_bc>=","420"+left(lstrparms.String_Arg[41],12)) /*12/04 - PCONKL - LabelVision label*/


lsFormat = uf_Replace(lsFormat,"~~ship_date,0015~~",left(string(today(),"Mmm dd, yyyy"),15))
lsFormat = uf_Replace(lsFormat,"~~ctc_po,0015~~",left(Lstrparms.String_arg[13],15))

lsFormat = uf_Replace(lsFormat,"~~sku~~",left(lstrparms.String_Arg[55],20))

lsFormat = uf_Replace(lsFormat,"~~carton_no_BC2,0019~~", "420"+left(lstrparms.String_Arg[41],12))

if Upper(ls_label_type) = "SDM" then

	lsFormat = uf_Replace(lsFormat,"~~destination,0012~~",left(lstrparms.String_Arg[56],12))
	lsFormat = uf_Replace(lsFormat,"~~destination_bc,0008~~","91" + trim(left(trim(lstrparms.String_Arg[56]),12)))
	lsFormat = uf_Replace(lsFormat,"~~destination_bc,0012~~","91" + trim(left(trim(lstrparms.String_Arg[56]),12)))

	lsFormat = uf_Replace(lsFormat,"~~store,0006~~",left(lstrparms.String_Arg[56],6))

else

	lsFormat = uf_Replace(lsFormat,"~~destination,0012~~",left(lstrparms.String_Arg[44],12))
	lsFormat = uf_Replace(lsFormat,"~~destination_bc,0008~~","91" + trim(left(trim(lstrparms.String_Arg[44]),12)))
	lsFormat = uf_Replace(lsFormat,"~~destination_bc,0012~~","91" + trim(left(trim(lstrparms.String_Arg[44]),12)))


	if Upper(ls_label_type) = "ZEL" then
		lsFormat = uf_Replace(lsFormat,"~~store,0008~~","ZL" + left(lstrparms.String_Arg[44],6))
	else
		lsFormat = uf_Replace(lsFormat,"~~store,0006~~",left(lstrparms.String_Arg[44],6))
	end if

end if



IF ls_label_type = 'LAM' then
	

	lsFormat = uf_Replace(lsFormat,"~~sku_count~~","")
	lsFormat = uf_Replace(lsFormat,"~~vpn~~","")
	
	lsFormat = uf_Replace(lsFormat,"~~upc~~",left(lstrparms.String_Arg[64],12))
	lsFormat = uf_Replace(lsFormat,"~~upc_bc~~",left(lstrparms.String_Arg[64],12))	
	
	if Pos(lsFormat,"~~to_addr4~~") > 0 THEN
		lsFormat = uf_Replace(lsFormat,"~~to_addr4~~","")
	end if
	
	if Pos(lsFormat,"~~to_addr5~~") > 0 THEN
		lsFormat = uf_Replace(lsFormat,"~~to_addr5~~","")
	end if

	if Pos(lsFormat,"~~from_addr4~~") > 0 THEN
		lsFormat = uf_Replace(lsFormat,"~~from_addr4~~","")
	end if
	
	if Pos(lsFormat,"~~from_addr5~~") > 0 THEN	
		lsFormat = uf_Replace(lsFormat,"~~from_addr5~~","")
	end if

	
	lsFormat = uf_Replace(lsFormat,"~~store~~",trim(lstrparms.String_Arg[43]))
	
	
	lsFormat = uf_Replace(lsFormat,"~~store_bc~~","19" + trim(lstrparms.String_Arg[43]))	

	if Pos(lsFormat,"~~store~~") > 0 THEN	
		lsFormat = uf_Replace(lsFormat,"~~store~~","")
	end if
	
	if Pos(lsFormat,"~~store_bc~~") > 0 THEN	
		lsFormat = uf_Replace(lsFormat,"~~store_bc~~","")
	end if	

	lsFormat = uf_Replace(lsFormat,"~~user_field6~~",trim(lstrparms.String_Arg[45]))

	if Pos(lsFormat,"~~user_field6~~") > 0 THEN	
		lsFormat = uf_Replace(lsFormat,"~~user_field6~~","")
	end if	


	

END IF



//Trey added "DI" of 00 to Barcode	
//TAM 2007/06/12 Made into case statement for KMART and Added KMART Logic


lsFormat = uf_Replace(lsFormat,"~~carton_no_BC,0019~~", left(Lstrparms.String_arg[48],20))

//lsFormat = uf_Replace(lsFormat,"~~carton_no_bc~~", right(Lstrparms.String_arg[48],20)) /* 12/04 - PCONKL - Labelvision */
lsFormat = uf_Replace(lsFormat,">;>=carton_no_bc>=", left(Lstrparms.String_arg[48],20)) /* 12/04 - PCONKL - Labelvision */

lsFormat = uf_Replace(lsFormat,"~~carton_no_readable,0018~~", left(mid(Lstrparms.String_arg[48],3),18)) /* 00 already on label as text field but included in barcode*/

string ls_upc_readable, lsTempUPC

lsTempUPC = mid(Lstrparms.String_arg[48],3)

ls_upc_readable = left( lsTempUPC, 1) + " " + mid(lsTempUPC, 2, 7) + " " + mid(lsTempUPC, 9, 9) + " " + mid(lsTempUPC, 18, 1)

lsFormat = uf_Replace(lsFormat,"~~carton_no_readable~~", ls_upc_readable) /*  12/04 - LabelVision*/



lsFormat = uf_Replace(lsFormat,"~~user_field3,0047~~", right(Lstrparms.String_arg[42],10))
lsFormat = uf_Replace(lsFormat,"~~user_field4,0048~~", right(Lstrparms.String_arg[43],10))
//lsFormat = uf_Replace(lsFormat,"~~user_field5,0049~~", right(Lstrparms.String_arg[55],10))
lsFormat = uf_Replace(lsFormat,"~~user_field6,0050~~", right(Lstrparms.String_arg[45],10))
ls_ucc = right(Lstrparms.String_arg[46],14)
ls_ucc = mid(ls_ucc,1,1) + '  ' + mid(ls_ucc,2,2) + '  ' + mid(ls_ucc,4,5) +& 
'  ' + mid(ls_ucc,9,5) + '  ' + mid(ls_ucc,14,1)
lsFormat = uf_Replace(lsFormat,"~~user_field7,0045~~", ls_ucc)

	


//	
	
//Tracking shipper No
lsFormat = uf_Replace(lsFormat,"~~tracker_id,0030~~",left(lstrparms.String_Arg[27],30))
	
//No of copies
ll_no_of_copies = lstrparms.Long_Arg[1]
FOR i= 1 TO ll_no_of_copies
	lsFormat = uf_Replace(lsFormat,"~~tot_off,0030~~",left(lstrparms.String_Arg[28],30))
	lsFormat = uf_Replace(lsFormat,"~~tot_off~~",left(lstrparms.String_Arg[28],30))
	PrintSend(llPrintJob, lsformat)	
	ls_temp= lstrparms.String_Arg[28]
NEXT
	
PrintClose(llPrintJob)
	

Return 0


end function

public function integer uf_runworld_zebra_ship (any as_array);
//BCR 7-SEP-2011: This function will print  Run-World Shipping labels

Str_parms	lStrparms
String	lsFormat,	&
			lsCartonBarcode,	&
			lsTemp,				&
			lsPrintText,		&
			lsAddr,ls_weight,ls_temp,	&
			lsUCCCarton

Long	llPrintJob,	&
		llPos,		&
		llPrintQty,	&
		llPrintPos,	&
		llCartonNo,	&
		llAddrPos,i,j,ll_no_of_copies
		
Integer	liFileNo, liCheck

lstrparms = as_array


//Set text file
lsFormat = uf_read_label_Format('Run_World_zebra_ship_generic.txt') 
		
lsPrintText = 'UCCS Ship - Zebra'


//Open Printer File 
llPrintJob = PrintOpen(lsPrintText)
	
If llPrintJob <0 Then 
	Messagebox('Labels', 'Unable to open Printer file. Labels will not be printed')
	Return -1
End If

//We are looping once for each Qty of label being printed - The carton number is changing so we need to bump after each one.
//Replace placeholders in Format with Field Values

//To Address - Roll up addresses if not all present

llAddrPos = 0

If lstrparms.String_Arg[7] > ' ' Then
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~" //Customer Name
	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[7],45))
End If

If lstrparms.String_Arg[8] > ' ' Then
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~" //Address1
	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[8],45))
End If

If lstrparms.String_Arg[9] > ' ' Then
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~" //Address2
	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[9],45))
End If

If lstrparms.String_Arg[10] > ' ' Then
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~" //Address3
	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[10],45))
End If

If lstrparms.String_Arg[32] > ' ' Then //Address4
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[32],45))
End If

If lstrparms.String_Arg[11] > ' ' Then //City,state,zip
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[11],45))
End If

If lstrparms.String_Arg[30] > ' ' Then //To Country
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[30],45))
End If

//AWB
lsFormat = uf_Replace(lsFormat,"~~bol_nbr~~",left(lstrparms.String_Arg[34],12)) 
		
//Invoice NO
lsFormat = uf_Replace(lsFormat,"~~invoice_no~~",Left(lstrparms.String_Arg[17],20))	

//BCR 12-OCT-2011: Ship Date should be Request Date on w_do...

////Today's date 
//lsFormat = uf_Replace(lsFormat,"~~today~~",string(today(),"mmm dd, yyyy"))
//Today's date 
lsFormat = uf_Replace(lsFormat,"~~today~~",string(lstrparms.DateTime_Arg[1],"mmm dd, yyyy"))
	
//Carrier Name
lsFormat = uf_Replace(lsFormat,"~~carrier_name~~",left(lstrparms.String_Arg[25],30))
	
//Tracking shipper No
lsFormat = uf_Replace(lsFormat,"~~tracker_id~~",left(lstrparms.String_Arg[27],30))
	
//No of copies
ll_no_of_copies = lstrparms.Long_Arg[1]
FOR i= 1 TO ll_no_of_copies
	lsFormat = uf_Replace(lsFormat,"~~tot_off~~",left(lstrparms.String_Arg[28],30))
	PrintSend(llPrintJob, lsformat)	
	ls_temp= lstrparms.String_Arg[28]
NEXT
	
PrintClose(llPrintJob)
	

Return 0


end function

public function integer uf_pallet_do_info (any as_array);// uf_pallet_do_info() This function will print Generic Pallet DO info label
// ET3 2012-09    Pandora pallet label

// ET3 2013-02-05 Pandora 570 - add GPN from row 1 of Detail tab of w_do

Str_parms	lStrparms
String lsFormat 
STRING lsPrintText 
STRING lsDONO
STRING lsGPN
STRING lsClientCustPONbr //TAM
STRING lsInvoiceNo //TAM

Long	llPrintJob 
LONG  i = 0
LONG  ll_no_of_copies = 1
		
Integer	liFileNo, liCheck


lstrparms = as_array


//TAM 216/08/16 Added new field for Pandora- *Note DONO = DONO
If Upper( gs_project ) = 'PANDORA' then
	lsInvoiceNo = lstrparms.String_arg[1]
	lsDONO = lstrparms.String_arg[3]
	lsClientCustPONbr = lstrparms.String_arg[4]
Else
	lsDONO = lstrparms.String_arg[1]
End If

// LTK  20150521  Now the GPN is optionally sent
if UpperBound( lstrparms.String_arg ) >= 2 then
	lsGPN  = lstrparms.String_arg[2]
end if


//TAM 216/08/16 Added new label format for PANDORA
If Upper( gs_project ) = 'PANDORA' then
	lsFormat = uf_read_label_Format('Pandora_Delivery_Barcode_Label.txt') 
else
	lsFormat = uf_read_label_Format('pallet_do_info.txt') 
end if			
lsPrintText = 'Pallet DO Info - Zebra'

//Open Printer File 
llPrintJob = PrintOpen(lsPrintText)
	
If llPrintJob <0 Then 
	Messagebox('Labels', 'Unable to open Printer file. Labels will not be printed')
	Return -1
End If

//Replace placeholders in Format with Field Values
IF (NOT IsNull(lsDONO)) AND (TRIM(lsDONO) > '' ) THEN
	//TAM 216/08/16 Added new label format for PANDORA
	lsFormat = uf_replace( lsFormat, "~~DO_NO~~", lsDONO )
	lsFormat = uf_replace( lsFormat, "~~DO_NO_BC~~", lsDONO )
	lsFormat = uf_replace( lsFormat, "~~PRINT_DATE~~", STRING(DATE(TODAY())) )
	lsFormat = uf_replace( lsFormat, "~~GPN~~", lsGPN )

	//TAM 216/08/16 Added new label format for PANDORA
	lsFormat = uf_replace( lsFormat, "~~INVOICE_NO~~", lsInvoiceNo )
	lsFormat = uf_replace( lsFormat, "~~INVOICE_NO_BC~~", lsInvoiceNo )
	lsFormat = uf_replace( lsFormat, "~~CLIENT_CUST_PO_NBR~~", lsClientCustPONbr )
	lsFormat = uf_replace( lsFormat, "~~CLIENT_CUST_PO_NBR_BC~~", lsClientCustPONbr )
	
	// LTK  20150521  If the GPN is not sent, clear the GPN tag from the label
	if Len(lsGPN) = 0 then
		lsFormat = uf_replace( lsFormat, "GPN:", "" )
	end if

ELSE 
	RETURN -1
	
END IF
	
//No of copies
ll_no_of_copies = lstrparms.Long_Arg[1]

FOR i= 1 TO ll_no_of_copies
	PrintSend(llPrintJob, lsformat)	
NEXT
	
PrintClose(llPrintJob)

Return 0


end function

public function integer uf_geistlich_bs_zebra_ship (any as_array);
//This function will print  Generic UCCS Shipping label

Str_parms	lStrparms
String	lsFormat,	&
			lsCartonBarcode,	&
			lsTemp,				&
			lsPrintText,		&
			lsAddr,ls_weight,ls_temp,	&
			lsUCCCarton

Long	llPrintJob,	&
		llPos,		&
		llPrintQty,	&
		llPrintPos,	&
		llCartonNo,	&
		llAddrPos,i,j,ll_no_of_copies
		
Integer	liFileNo, liCheck


lstrparms = as_array

lsFormat = uf_read_label_Format('geistlich_bs_shipping_label.txt')

	
lsPrintText = 'Geistlich_ Buffalo_Supply_Ship - Zebra'


//Open Printer File 
llPrintJob = PrintOpen(lsPrintText)
	
If llPrintJob <0 Then 
	Messagebox('Labels', 'Unable to open Printer file. Labels will not be printed')
	Return -1
End If

//We are looping once for each Qty of label being printed - The carton number is changing so we need to bump after each one.
//Replace placeholders in Format with Field Values

//From Address - Roll up addresses if not all present
	
llAddrPos = 0


//To Address - Roll up addresses if not all present

llAddrPos = 0

If lstrparms.String_Arg[7] > ' ' Then //Customer Name
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos)  + "~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[7],45))
End If

If lstrparms.String_Arg[8] > ' ' Then //Address 1
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[8],45))
End If

If lstrparms.String_Arg[9] > ' ' Then //Address 2
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~" 
	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[9],45))
End If

If lstrparms.String_Arg[11] > ' ' Then //City,state,zip
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~"  
	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[11],45))
End If

If lstrparms.String_Arg[30] > ' ' Then //To Country
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~" 
	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[30],45))
End If

For llAddrPos = llAddrPos to 5 /*each detail row */
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,'',30)
Next
	
	
//User Field2
If lstrparms.String_Arg[19] > ' ' Then 
	lsFormat = uf_Replace(lsFormat,"~~user_field2~~",left(lstrparms.String_Arg[19],30))
Else
	lsFormat = uf_Replace(lsFormat,"~~user_field2~~",'',30)
End If	
//User Field5
If lstrparms.String_Arg[34] > ' ' Then 
	lsFormat = uf_Replace(lsFormat,"~~user_field5~~",left(lstrparms.String_Arg[34],50))
Else
	lsFormat = uf_Replace(lsFormat,"~~user_field5~~",'',30)
End If	
//User Field15
If lstrparms.String_Arg[25] > ' ' Then 
	lsFormat = uf_Replace(lsFormat,"~~user_field15~~",left(lstrparms.String_Arg[25],30))
Else
	lsFormat = uf_Replace(lsFormat,"~~user_field15~~",'',30)
End If	
//User Field19
If lstrparms.String_Arg[20] > ' ' Then 
	lsFormat = uf_Replace(lsFormat,"~~user_field19~~",left(lstrparms.String_Arg[20],30))
Else
	lsFormat = uf_Replace(lsFormat,"~~user_field19~~",'',30)
End If	


//Cust Order No
If lstrparms.String_Arg[13] > ' ' Then 
	lsFormat = uf_Replace(lsFormat,"~~cust_order_no~~",left(lstrparms.String_Arg[13],30))
	lsFormat = uf_Replace(lsFormat,"~~cust_order_no2~~",left(lstrparms.String_Arg[13],30))
	lsFormat = uf_Replace(lsFormat,"~~cust_order_no2_bc~~",left(lstrparms.String_Arg[13],30))
else
	lsFormat = uf_Replace(lsFormat,"~~cust_order_no~~",'',30)
	lsFormat = uf_Replace(lsFormat,"~~cust_order_no2~~",'',30)
	lsFormat = uf_Replace(lsFormat,"~~cust_order_no2_bc~~",'',30)
end if

	
//No of copies
ll_no_of_copies = lstrparms.Long_Arg[1]
FOR i= 1 TO ll_no_of_copies
//	lsFormat = uf_Replace(lsFormat,"~~tot_off,0030~~",left(lstrparms.String_Arg[28],30))
	PrintSend(llPrintJob, lsformat)	
	ls_temp= lstrparms.String_Arg[28]
NEXT
	
PrintClose(llPrintJob)
	

Return 0


end function

public function integer uf_nyx_sscc_ship_label (any as_array);//Jxlim 06/27/2013 This function will print NYX SSCC Shipping label

Str_parms	lStrparms
String		lsFormat,	&
			lsCartonBarcode,	&
			lsTemp,				&
			lsPrintText,		&
			lsAddr,ls_weight,ls_temp,	&
			lsUCCCarton, lsFileName, lsNewFile, lsBatFile, lsWriteData, lsDono,lsCarton, lsUCCCarton_space

Long	llPrintJob,	&
		llPos,		&
		llPrintQty,	&
		llPrintPos,	&
		llCartonNo,	&
		llAddrPos,i,j,ll_no_of_copies,  &
		llRowCount, lRow
		
Integer	liFileNo, liCheck

lstrparms = as_array

datastore ldw_content_label
ldw_content_label = CREATE datastore;
ldw_content_label.dataobject = "d_nyx_sscc_ship_label_unicode"
ldw_content_label.SetTransObject(SQLCA)

ldw_content_label.Modify("DataWindow.Print.quality=1")
lsPrintText = 'NYX SSCC-18 Ship - Zebra'

//Open Printer File 
llPrintJob = PrintOpen(lsPrintText)
	
If llPrintJob <0 Then 
	Messagebox('Labels', 'Unable to open Printer file. Labels will not be printed')
	Return -1
End If

If lstrparms.String_Arg[38] > ' ' Then
	lsDono = Trim(lstrparms.String_Arg[38])
End If

If  lstrparms.String_Arg[35] > '' Then	
	lsCarton = trim(lstrparms.String_Arg[35] )
End If

ldw_content_label.Retrieve(gs_project, lsDono, lsCarton)
llRowCount=ldw_content_label.RowCount()

//Carton no (SSCC-18 Label) - NYX  00 + 3 + 7 digits company prefix+9digits serial+1 digit check=18 (exclude 00)
If  lstrparms.String_Arg[35] > '' Then		//Jxlim 06/28/2013 NYX 7 digits company prefix
	lsUCCCarton = "3" + lstrparms.String_Arg[35] + Right(String(Long(lstrparms.String_Arg[12]),'000000000'),9) /*Prepend UCCS Info - 0 (future use) + Warehouse Prefix + Company Prefix) */		
	liCheck = f_calc_uccs_check_Digit(lsUCCCarton) /*calculate the check digit*/
	If liCheck >=0 Then
		lsuccCarton = "00" + lsUccCarton + String(liCheck) /* add 00 at beginning (not part of check digit calculation but included as tag */
	Else
		lsUccCarton = String(Long(lstrparms.String_Arg[12]),'00000000000000000000')
	End If
Else
	lsUccCarton = String(Long(lstrparms.String_Arg[12]),'00000000000000000000')
End If

//SSCC field adding space
lsUCCCarton_space = Right(lsUCCCarton,18)
lsUCCCarton_space = Left(lsUCCCarton,1) + " " + Mid(lsUCCCarton,2,7) + " " + Mid(lsUCCCarton,9,9) + " " + Mid(lsUCCCarton,18,1) 

For lRow = 1 to llRowcount
		ldw_content_label.SetItem(lRow, "c_sscc", lsUCCCarton)			//Print the SSCC-18 with prefix by 00 completed code
		ldw_content_label.SetItem(lRow, "cf_cartonbarcode", lsUCCCarton)	//Print the SSCC-18 barcode
		ldw_content_label.SetItem(lRow, "carton_no", lsUCCCarton_space)		//Print the SSCC-18 with prefix with space
//Print content label
//If llRowcount > 0 THEN	
		PrintDataWindow ( llPrintJob, ldw_content_label )		
//END IF
Next

ldw_content_label.Reset()

DESTROY ldw_content_label		

PrintClose(llPrintJob)

Return 0

//lstrparms = as_array
//lsFormat = uf_read_label_Format('NYX_SSCC-18_shipping_label.txt')   //Jxlim not using this, changed to print from dw instead of printsend(text)
//lsPrintText = 'NYX SSCC-18 Ship - Zebra'

//We are looping once for each Qty of label being printed - The carton number is changing so we need to bump after each one.
//Replace placeholders in Format with Field Values

////From Address - Roll up addresses if not all present
//	
//llAddrPos = 0
//
//If lstrparms.String_Arg[2] > ' ' Then
//	llAddrPos ++
//	lsAddr = "~~from_addr" + String(llAddrPos) + "~~"
//	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[2],30))
//End If
//	
//If lstrparms.String_Arg[3] > ' ' Then
//	llAddrPos ++
//	lsAddr = "~~from_addr" + String(llAddrPos) + "~~"
//	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[3],30))
//End If
//
//If lstrparms.String_Arg[4] > ' ' Then
//	llAddrPos ++
//	lsAddr = "~~from_addr" + String(llAddrPos) + "~~"
//	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[4],30))
//End If
//
//If lstrparms.String_Arg[5] > ' ' Then
//	llAddrPos ++
//	lsAddr = "~~from_addr" + String(llAddrPos) + "~~"
//	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[5],30))
//End If
//	
//If lstrparms.String_Arg[31] > ' ' Then
//	llAddrPos ++
//	lsAddr = "~~from_addr" + String(llAddrPos) + "~~"
//	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[31],45))
//End If
//	
//If lstrparms.String_Arg[6] > ' ' Then
//	llAddrPos ++
//	lsAddr = "~~from_addr" + String(llAddrPos) + "~~"
//	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[6],30))
//End If
//
//If lstrparms.String_Arg[29] > ' ' Then 
//	llAddrPos ++
//	lsAddr = "~~from_addr" + String(llAddrPos) + "~~"
//	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[29],45))
//End If
//
////To Address - Roll up addresses if not all present
//
//llAddrPos = 0
//
//If lstrparms.String_Arg[7] > ' ' Then
//	llAddrPos ++
//	lsAddr = "~~to_addr" + String(llAddrPos) + "~~"  //Customer Name
//	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[7],45))
//End If
//
////Jxlim 06/27/2013 Pull delivery_master.user_field2 for Customer Store code
//If lstrparms.String_Arg[36] > ' ' Then
//	llAddrPos ++
//	lsAddr = "~~to_addr" + String(llAddrPos) + "~~"  //Customer Store code
//	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[36],45))
//End If
//
//If lstrparms.String_Arg[8] > ' ' Then
//	llAddrPos ++
//	lsAddr = "~~to_addr" + String(llAddrPos) + "~~"  //Address1
//	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[8],45))
//End If
//
//If lstrparms.String_Arg[9] > ' ' Then
//	llAddrPos ++
//	lsAddr = "~~to_addr" + String(llAddrPos) + "~~"  //Address2
//	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[9],45))
//End If
//
//If lstrparms.String_Arg[10] > ' ' Then
//	llAddrPos ++
//	lsAddr = "~~to_addr" + String(llAddrPos) + "~~"  //Address3
//	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[10],45))
//End If
//
//If lstrparms.String_Arg[32] > ' ' Then //Address4
//	llAddrPos ++
//	lsAddr = "~~to_addr" + String(llAddrPos) + "~~"
//	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[32],45))
//End If
//
//If lstrparms.String_Arg[11] > ' ' Then //City,state,zip
//	llAddrPos ++
//	lsAddr = "~~to_addr" + String(llAddrPos) + "~~"
//	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[11],45))
//End If
//
//If lstrparms.String_Arg[30] > ' ' Then //To Country
//	llAddrPos ++
//	lsAddr = "~~to_addr" + String(llAddrPos) + "~~"
//	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[30],45))
//End If
//
////Jxlim 07/02/2013 Customer Name(Dynamic)  concatenate with Order No as a column label: 
//If lstrparms.String_Arg[37] > ' ' Then //Customer Po Nbr
//	lsFormat = uf_Replace(lsFormat,"~~Cust_po_nbr~~",left(lstrparms.String_Arg[37],60))
//End If
//
//If lstrparms.String_Arg[13] > ' ' Then //Customer Po Nbr
//	lsFormat = uf_Replace(lsFormat,"~~po_nbr~~",left(lstrparms.String_Arg[13],30))
//End If
//
//If lstrparms.String_Arg[15] > ' ' Then //Packing List Nbr
//	lsFormat = uf_Replace(lsFormat,"~~Packing_list_no~~",left(lstrparms.String_Arg[15],30))
//End If
//
//If lstrparms.String_Arg[28] > ' ' Then //Carton no 1 of n  (Packing Carton no)
//	lsFormat = uf_Replace(lsFormat,"~~tot_off~~",left(lstrparms.String_Arg[28],30))	
//End If
//
////Carton no (SSCC-18 Label) - NYX  00 + 3 + 7 digits company prefix+9digits serial+1 digit check=18 (exclude 00)
//If  lstrparms.String_Arg[35] > '' Then		//Jxlim 06/28/2013 NYX 7 digits company prefix
//	lsUCCCarton = "3" + lstrparms.String_Arg[35] + Right(String(Long(lstrparms.String_Arg[12]),'000000000'),9) /*Prepend UCCS Info - 0 (future use) + Warehouse Prefix + Company Prefix) */		
//	liCheck = f_calc_uccs_check_Digit(lsUCCCarton) /*calculate the check digit*/
//	If liCheck >=0 Then
//		lsuccCarton = "00" + lsUccCarton + String(liCheck) /* add 00 at beginning (not part of check digit calculation but included as tag */
//	Else
//		lsUccCarton = String(Long(lstrparms.String_Arg[12]),'00000000000000000000')
//	End If
//Else
//	lsUccCarton = String(Long(lstrparms.String_Arg[12]),'00000000000000000000')
//End If
//
////Jxlim 06/28/2013 NYX -NVE/SSCC -18 barcode
//lsFormat = uf_Replace(lsFormat,"~~NVE_SSCC_18_bc~~",lsUCCCarton)  			//Print the SSCC-18 prefix by 00 completed code
//lsFormat= uf_Replace(lsFormat,">;>=NVE_SSCC_18_bc>=", lsUCCCarton)		//Print the SSCC-18 barcode
//
////SSCC field adding space
//lsUCCCarton = Right(lsUCCCarton,18)
//lsUCCCarton = Left(lsUCCCarton,1) + " " + Mid(lsUCCCarton,2,7) + " " + Mid(lsUCCCarton,9,9) + " " + Mid(lsUCCCarton,18,1) 
////lsFormat = uf_Replace(lsFormat,"~~NVE~~",Right(lsUCCCarton,18)) /* 00 already on label as text field but included in barcode*/
//lsFormat = uf_Replace(lsFormat,"~~NVE~~",lsUCCCarton) /* 00 already on label as text field but included in barcode*/
////Jxlim 06/25/2013 End of lsFormat using text for label to send to Zebra printer


//Jxlim 07/09/2013 Jxlim PrintSend() skip special characters.  Have to find out alternate solution to print special character
//lsFileName = 'NYX_SSCC-18_shipping_label.txt'
//lsNewFile ='NYX_SSCC-18_shipping_label_data.txt' 
//lsBatFile ='NYXlabel.bat'
//lsWriteData = uf_write_label_Format(lsFileName, lsNewFile, lsBatFile, lsformat) 

//lsFormat =" ~h1BX~ "  + lsFormat
//PrintSend(Job, "~h1BX~255~040", 255)
//PrintDataWindow(Job, dw_1)

////No of copies
//ll_no_of_copies = lstrparms.Long_Arg[1]
//
//FOR i= 1 TO ll_no_of_copies
//	//PrintSend(llPrintJob, lsformat)	  //Jxlim PrintSend() skip special characters.  Have to find out alternate solution to print special character		
//NEXT
//	
//PrintClose(llPrintJob)

//Return 0
end function

public function string uf_write_label_format (string asformat_name, string asformat_newfile, string asbatfile, string asformatdata);//Jxlim 07/10/2013 Write label to a new file to print from .bat file
String	lsFormatData,	&
			lsFile, lsNewfile, lsBatFile
			
Integer	liFileNo, liRC

//Look in the labels sub-directory of the SIMS directory
//TimA 06/08/15 Added new global varable for path location of labels.
If gs_labelpath > '' Then
	lsFile = gs_labelpath  + asformat_name
	lsNewFile = gs_labelpath  + asformat_newfile
	lsBatFile = gs_labelpath  + asbatfile
Else
	If gs_SysPath > '' Then
		lsFile = gs_syspath + 'labels\' + asformat_name
		lsNewFile = gs_syspath + 'labels\' + asformat_newfile
		lsBatFile = gs_syspath + 'labels\' + asbatfile
		//guido's local directory	gs_SysPath = "c:\pb7devl\sims32dev\" 
	Else
		lsFile = 'labels\' + asformat_name
		lsNewFile = 'labels\' + asformat_newfile
		lsBatFile =  'labels\' + asbatfile
	End If
End if
If Not FileExists(lsFile) Then
	Messagebox('Labels', 'This file does not exist! - ' + lsfile)
	Return ''
End If

If Not FileExists(lsNewFile) Then
	Messagebox('New Data Labels', 'This file does not exist! - ' + lsnewFile)
	Return ''
End If

If Not FileExists(lsBatFile) Then
	Messagebox('Bat file Labels', 'This file does not exist! - ' + lsBatFile)
	Return ''
End If

//working
Blob Blb
//Blb = Blob(asFormatData, EncodingUTF16BE!)
Blb = Blob(asFormatData, EncodingUTF16LE!)    //Jxlim 07/10/2013 Convert string to Unicode  (save as unicode)
//Blb = Blob(asFormatData, EncodingUTF8!)    //Jxlim 07/10/2013 Convert string to Unicode  (save as UTF8)
//Open the File - Streammode will read entire file into 1 variable
liFileNo =FileOpen(lsNewFile, StreamMode!, Write!, LockWrite!, Replace!)  //Jxlim 07/10/2013 only for UTF8 usage; StreamMode must convert string value to Blob
//liFileNo =FileOpen(lsNewFile,LineMode!,Write!,LockREadWrite!,Replace!,EncodingUTF16LE!) //Jxlim 07/10/2013 only for unicode usage  (doesn't work)

If liFileNo < 0 Then	
	Messagebox('Labels', 'Unable to load necessary label Format: "' + asFormat_newfile + '"')
	Return ''
End If

//StreamMode must convert string to Blob in order to read and write
//Blob Blb
//Blb = Blob(asFormatData, EncodingUTF16LE!)    //Jxlim 07/10/2013 Convert string to Unicode  (save as unicode)
liRC = FileWriteEx(lifileNo, blb)	
//liRC = FileWriteEx(lifileNo, asFormatData)		
If liRC < 0 Then
	Messagebox('Labels', 'Unable to write data to label format file: '  + lsNewFile)
End If

FileClose(liFileNo)  ////working


//Try this
//Blob Blb
//Blb = Blob(asFormatData, EncodingUTF16LE!)    //Jxlim 07/10/2013 Convert string to Unicode  (save as unicode)
//Blb = Blob(asFormatData, EncodingUTF8!)    //Jxlim 07/10/2013 Convert string to Unicode  (save as UTF8)
//Open the File - Streammode will read entire file into 1 variable
//liFileNo =FileOpen(lsNewFile, StreamMode!, Write!, LockWrite!, Replace!)  //Jxlim 07/10/2013 only for UTF8 usage; StreamMode must convert string value to Blob
//liFileNo =FileOpen(lsNewFile,LineMode!,Write!,LockREadWrite!,Replace!,EncodingUTF16LE!) //Jxlim 07/10/2013 only for unicode usage  (doesn't work)
//
//If liFileNo < 0 Then	
//	Messagebox('Labels', 'Unable to load necessary label Format: "' + asFormat_newfile + '"')
//	Return ''
//End If
//
//StreamMode must convert string to Blob in order to read and write
//Blob Blb
//Blb = Blob(asFormatData, EncodingUTF16LE!)    //Jxlim 07/10/2013 Convert string to Unicode  (save as unicode)
//liRC = FileWriteEx(lifileNo, blb)	
//liRC = FileWriteEx(lifileNo, asFormatData)		
//If liRC < 0 Then
//	Messagebox('Labels', 'Unable to write data to label format file: '  + lsNewFile)
//End If
//
//FileClose(liFileNo)  ////try this


//run command bat file for print label
long liret
liret = run(lsBatFile)
If liret < 0 Then
	Messagebox('Labels', 'Unable to print label '  + lsNewFile)
Else
	Messagebox('Labels', 'Print label  successfull'  + lsNewFile)
End If

//Messagebox('before',lsFormatData)

Return lsFormatData

end function

public function string uf_replace_label_text (string asstring, string asoldvalue, string asnewvalue);
//Replace lable text on the label
String	lsString
Long	llPos


if isNull(asnewValue) Then Return asString

lsString = asString
llPos = Pos(lsString,asOldValue)

Do While llPos > 0 
	lsString = Replace(lsString,llPos,len(asOldValue), asNewValue) 
	llPos = Pos(lsString,asOldValue,llPos+len(asOldValue))
Loop

Return lsString
end function

public function integer uf_ariens_ucc_128_zerbra_ship ();
//This function will print  Generic UCCS Shipping label

Str_parms	lStrparms
String	lsFormatUCC_128,	&
			lsCartonBarcode,	&
			lsTemp,				&
			lsPrintText,		&
			lsAddr,ls_weight,ls_temp,	&
			lsUCCCarton,ls_ucc, lsFormatHomeDepot1, lsFormatHomeDepot, lsFormatGrainger

Long	llPrintJob,	&
		llPos,		&
		llPrintQty,	&
		llPrintPos,	&
		llCartonNo,	&
		llAddrPos,i,j,ll_no_of_copies
		
Integer	liFileNo, liCheck
string ls_label_type	

lstrparms = getparms()

//ls_label_type = Upper(lstrparms.String_arg[67])

//CHOOSE CASE ls_label_type

//CASE "BESTBUY"
	//for proof of concept I combind two labels into one call. lsFormatHomeDepot should be in it's on function
	//Jxlim 04/16/2014 Rename .txt. the same as .lbl file name
	//lsFormatUCC_128 = uf_read_label_Format('Ariens_SSCC_zebra_ship.txt') 
	lsFormatUCC_128 = uf_read_label_Format('Ariens_SSCC_Label.txt')
	lsFormatHomeDepot1 = uf_read_label_Format('Ariens_home_depot_cross_doc.txt') 
	lsFormatHomeDepot = lsFormatHomeDepot1	
	lsFormatGrainger = uf_read_label_Format('Ariens_Granger.txt') 
//END CHOOSE	
	
//Open Printer File 
llPrintJob = PrintOpen(lsPrintText)
	
If llPrintJob <0 Then 
	Messagebox('Labels', 'Unable to open Printer file. Labels will not be printed')
	Return -1
End If


//From Address - Roll up addresses if not all present
llAddrPos = 0

If lstrparms.String_Arg[2] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + "~~"
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,lsAddr,Left(lstrparms.String_Arg[2],30))
	lsFormatHomeDepot = uf_Replace(lsFormatHomeDepot,lsAddr,Left(lstrparms.String_Arg[2],30))
End If
	
If lstrparms.String_Arg[3] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + "~~"
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,lsAddr,Left(lstrparms.String_Arg[3],30))
	lsFormatHomeDepot = uf_Replace(lsFormatHomeDepot,lsAddr,Left(lstrparms.String_Arg[3],30))
End If

If lstrparms.String_Arg[4] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + "~~"
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,lsAddr,Left(lstrparms.String_Arg[4],30))
	lsFormatHomeDepot = uf_Replace(lsFormatHomeDepot,lsAddr,Left(lstrparms.String_Arg[4],30))
End If

If lstrparms.String_Arg[5] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + "~~"
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,lsAddr,Left(lstrparms.String_Arg[5],30))
	lsFormatHomeDepot = uf_Replace(lsFormatHomeDepot,lsAddr,Left(lstrparms.String_Arg[5],30))
End If

If lstrparms.String_Arg[6] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + "~~"
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,lsAddr,Left(lstrparms.String_Arg[6],30))
	lsFormatHomeDepot = uf_Replace(lsFormatHomeDepot,lsAddr,Left(lstrparms.String_Arg[6],30))
End If

If lstrparms.String_Arg[7] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + "~~"
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,lsAddr,Left(lstrparms.String_Arg[7],30))
	lsFormatHomeDepot = uf_Replace(lsFormatHomeDepot,lsAddr,Left(lstrparms.String_Arg[7],30))
End If

//Po No and B/L number
//Jxlim 04/16/2014  Print barcode for carrier_pro_mo
//This is confusion, changed to read carrier_pro_no instead of po_nbr
//lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~po_nbr~~",left(lstrparms.String_Arg[11],30))
lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~carrier_pro_no~~",left(lstrparms.String_Arg[11],30))	
lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,">;>=carrier_pro_no_bc>=", left(Lstrparms.String_arg[11],30))  

//lsFormatHomeDepot = uf_Replace(lsFormatHomeDepot,"~~po_nbr~~",left(lstrparms.String_Arg[11],30))	
lsFormatHomeDepot = uf_Replace(lsFormatHomeDepot,"~~carrier_pro_no~~",left(lstrparms.String_Arg[11],30))	

lsFormatHomeDepot = uf_replace_label_text(lsFormatHomeDepot,"PRO:",Left("",45)) //Blank out the PRO on the Pallet Label
lsFormatHomeDepot = uf_replace_label_text(lsFormatHomeDepot,"B_L_Number:",Left("",45)) //Blank out the PRO on the Pallet Label
	
lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~B_L_Number~~",left(lstrparms.String_Arg[10],30))	
lsFormatHomeDepot = uf_Replace(lsFormatHomeDepot,"~~B_L_Number~~",left(lstrparms.String_Arg[10],30))	

//To Address - Roll up addresses if not all present
llAddrPos = 0

If lstrparms.String_Arg[12] > ' ' Then
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~" //Warehouse Name
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,lsAddr,Left(lstrparms.String_Arg[12],45))
	lsFormatHomeDepot = uf_Replace(lsFormatHomeDepot,lsAddr,Left(lstrparms.String_Arg[12],45))
End If

If lstrparms.String_Arg[13] > ' ' Then
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~" //Address1
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,lsAddr,Left(lstrparms.String_Arg[13],45))
	lsFormatHomeDepot = uf_Replace(lsFormatHomeDepot,lsAddr,Left(lstrparms.String_Arg[13],45))	
End If

If lstrparms.String_Arg[14] > ' ' Then
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~" //Address2
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,lsAddr,left(lstrparms.String_Arg[14],45))
	lsFormatHomeDepot = uf_Replace(lsFormatHomeDepot,lsAddr,left(lstrparms.String_Arg[14],45))
End If

If lstrparms.String_Arg[15] > ' ' Then
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~" //Address3
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,lsAddr,Left(lstrparms.String_Arg[15],45))
	lsFormatHomeDepot = uf_Replace(lsFormatHomeDepot,lsAddr,Left(lstrparms.String_Arg[15],45))
End If

If lstrparms.String_Arg[16] > ' ' Then //Address5
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~"
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,lsAddr,left(lstrparms.String_Arg[16],45))
	lsFormatHomeDepot = uf_Replace(lsFormatHomeDepot,lsAddr,left(lstrparms.String_Arg[16],45))
End If

If lstrparms.String_Arg[17] > ' ' Then //Address5
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~"
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,lsAddr,left(lstrparms.String_Arg[17],45))
	lsFormatHomeDepot = uf_Replace(lsFormatHomeDepot,lsAddr,left(lstrparms.String_Arg[17],45))
End If
	
//Carrier
lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~carrier_name~~",left(lstrparms.String_Arg[24],30))
lsFormatHomeDepot = uf_Replace(lsFormatHomeDepot,"~~carrier_name~~",left(lstrparms.String_Arg[24],30))

lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~order_number~~",left( lstrparms.String_Arg[23],30))
lsFormatHomeDepot = uf_Replace(lsFormatHomeDepot,"~~order_number~~",left( lstrparms.String_Arg[23],30))

lsFormatUCC_128 = uf_replace_label_text(lsFormatUCC_128,"QTY:",Left("",45)) //Blank out the QTY on the Pallet Label
lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~quantity~~",left("",30))

lsFormatHomeDepot = uf_Replace(lsFormatHomeDepot,"~~quantity~~",left( lstrparms.String_Arg[25],30))

//lsFormatUCC_128 = uf_replace_label_text(lsFormatUCC_128,"Serial Shipping Container Code",Left("PALLET: Serial Shipping Container Code",45))
lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~carton_no_readable~~", left(Lstrparms.String_arg[48],20))
lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,">;>=carton_no_bc>=", left(Lstrparms.String_arg[48],20)) 

//lsFormatHomeDepot = uf_replace_label_text(lsFormatHomeDepot,"Serial Shipping Container Code",Left("CONTAINER: Serial Shipping Container Code",45))
//lsFormatHomeDepot = uf_Replace(lsFormatHomeDepot,"~~carton_no_readable~~", left(Lstrparms.String_arg[49],20))
//lsFormatHomeDepot= uf_Replace(lsFormatHomeDepot,">;>=carton_no_bc>=", left(Lstrparms.String_arg[49],20)) 

//UPC
lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~UPC~~",left( lstrparms.String_Arg[20],30))
lsFormatHomeDepot = uf_Replace(lsFormatHomeDepot,"~~UPC~~",left( lstrparms.String_Arg[20],30))

//TAM - 2014/09/23 - Added Alternate Sku to the SSCC label
//Alt_SKU
If Trim(lstrparms.String_Arg[20]) <> Trim(lstrparms.String_Arg[61]) and lstrparms.String_Arg[61]<> '' then
	string lsaltsku 
	lsAltSku = "PART NO: " + left( lstrparms.String_Arg[61],30)
	//lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~alt_sku~~",left( lstrparms.String_Arg[61],30))
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~alt_sku~~",lsAltSku)
End If

//lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~customer_no~~",left( lstrparms.String_Arg[21],30))  //TimA 08/27/13 Take this out we are using the pro_num now
lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~customer_no~~",left( lstrparms.String_Arg[21],30)) /* 08/13 - PCONKL- this is now the Serial Number*/

//Jxlim 04/22/2014 This is confusion use po_nbr instead of pro_num because this is cust_order_no not pro_num 
//lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~pro_num~~",left( lstrparms.String_Arg[26],30))
lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~po_nbr~~",left( lstrparms.String_Arg[26],30))

//lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~pro_type~~",left( lstrparms.String_Arg[27],30)) //Hard Coded in the label
lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~carton_tot~~",left( lstrparms.String_Arg[28],30))

lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~tot_off~~",left( lstrparms.String_Arg[29],30))
lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~tot~~",left( lstrparms.String_Arg[30],30))

//Ariens_home_depot_cross_doc label

//Jxlim 04/22/2014 This is confusion use po_nbr instead of pro_num because this is cust_order_no not pro_num
//lsFormatHomeDepot = uf_Replace(lsFormatHomeDepot,"~~pro_num~~",left( lstrparms.String_Arg[26],30))
lsFormatHomeDepot = uf_Replace(lsFormatHomeDepot,"~~po_nbr~~",left( lstrparms.String_Arg[26],30))

//lsFormatHomeDepot = uf_Replace(lsFormatHomeDepot,"~~pro_type~~",left( lstrparms.String_Arg[34],30)) //Hard Coded in the label
lsFormatHomeDepot = uf_Replace(lsFormatHomeDepot,"~~carton_tot~~",left( lstrparms.String_Arg[28],30))
lsFormatHomeDepot = uf_Replace(lsFormatHomeDepot,"~~store_no~~",left( lstrparms.String_Arg[31],30))
lsFormatHomeDepot = uf_Replace(lsFormatHomeDepot,"~~tot_off~~",left( lstrparms.String_Arg[29],30))
lsFormatHomeDepot = uf_Replace(lsFormatHomeDepot,"~~tot~~",left( lstrparms.String_Arg[30],30))
lsFormatHomeDepot = uf_Replace(lsFormatHomeDepot,"~~carton_no_readable~~", left(Lstrparms.String_arg[48],20))
lsFormatHomeDepot= uf_Replace(lsFormatHomeDepot,">;>=carton_no_bc>=", left(Lstrparms.String_arg[48],20))

//Grainger Label
lsFormatGrainger = uf_Replace(lsFormatGrainger,"~~User_Field1~~", left('(' + Lstrparms.String_arg[62] + ') ' + Lstrparms.String_arg[61],20))
lsFormatGrainger= uf_Replace(lsFormatGrainger,">=User_Field1_BC>=", left(Lstrparms.String_arg[62] + ' ' + Lstrparms.String_arg[61],20))
lsFormatGrainger = uf_Replace(lsFormatGrainger,"~~sku~~", left(Lstrparms.String_arg[20],20))

//No of copies
ll_no_of_copies = lstrparms.Long_Arg[1]
FOR i= 1 TO ll_no_of_copies

	//If lstrparms.String_arg[65] = 'Y' then //Print the  label
If lstrparms.String_Arg[60] = 'GRAINGER' then
	PrintSend(llPrintJob, lsFormatGrainger) //Second label	
Else
		If Isnull(lstrparms.String_Arg[70]) or Pos(lstrparms.String_Arg[70], 'AD2') = 0 then
			PrintSend(llPrintJob, lsFormatUCC_128)	
		Else
			PrintSend(llPrintJob, lsFormatHomeDepot) //Second label	
		End if
	End if
//	End if
//	If lstrparms.String_arg[66] = 'Y' then //Print the Container label	
//		PrintSend(llPrintJob, lsFormatHomeDepot)	
//	End if
	ls_temp= lstrparms.String_Arg[28]
NEXT
	
PrintClose(llPrintJob)

Return 0



end function

public function integer uf_friedrich_ucc_by_scan (integer ailine, string assku, string asserial);
Str_Parms	lstrparms
n_labels	lu_labels
Long	llQty, llRowCount, llRowPos
Any	lsAny
Long liRC,llPackFindRow
String lsRoNo, lsDoNo, lsPallet, lsContainer, lsNextPallet,lsCityStateZip,lsWHCityStateZip
String lsPrintLable, lsPrintCarton,lsCustomer,lsWarehouse
string ls_vics_bol_no,  ls_awb_bol_no,lsSSCC
n_warehouse l_nwarehouse 
n_cst_common_tables ln_common_tables

//If we haven't already prompted for a printer, do so now
If Not ibPrinterSelected Then
				
	OpenWithParm(w_label_print_options,lStrParms)
	Lstrparms = Message.PowerObjectParm	
				
	If  lstrparms.cancelled Then
		Return 0	
	End If
	
	ibPrinterSelected = True
				
End If
			
//Get THe  PAcking ROw from the Line Item passed in
llPackFindRow = w_do.idw_pack.Find("Line_Item_No = " + string(ailine),1,w_do.idw_pack.RowCount())

ls_awb_bol_no =  w_do.idw_Main.GetItemString(1, "awb_bol_no")
lsDoNo = w_do.idw_Main.GetITemString(1,'Do_No')
			
//lstrparms.String_arg[70] = w_do.idw_Main.GetITemString(1,'User_Field7')
			
//If isLabelName = 'GRAINGER' then
//	If Pos(lstrparms.String_Arg[70], 'PR2') > 0 then
//			lstrparms.String_arg[60] = isLabelName
//	End if
//End if
			
//lstrparms.String_arg[65] = 'OUTBOUND'
		

llQty = 1
							
//Ship From
lsWarehouse = w_do.idw_main.getItemString(1,'wh_code')

If lsWarehouse <> isWarehouseSave Then
				
	SELECT  wh_name  , Address_1 ,Address_2  ,Address_3  ,Address_4   ,City  ,State  ,Zip
	INTO :isCustName, :isAddress_1 ,:isAddress_2, :isAddress_3 ,:isAddress_4 ,:isCity ,:isState ,:isZip
	FROM Warehouse where  wh_Code = :lsWarehouse;
	
	isWarehouseSave = lsWarehouse
	
End If
	
	
lstrParms.String_arg[2] = isCustName
Lstrparms.String_arg[3] = isAddress_1
Lstrparms.String_arg[4] = isAddress_2
Lstrparms.String_arg[5] = isAddress_3
Lstrparms.String_arg[6] = isAddress_4
If Not isnull(isCity) Then lsCityStateZip = isCity + ', '
If Not isnull(isState) Then lsCityStateZip += isState + ' '
If Not isnull(isZip) Then lsCityStateZip += isZip + ' '
Lstrparms.String_arg[7] = lsCityStateZip			
	
							
lstrparms.String_arg[10]  = w_do.idw_Main.GetItemString(1,'awb_bol_no')
lstrparms.String_arg[11]  = w_do.idw_Main.GetItemString(1,'User_Field5')
					
lstrparms.String_arg[63] = lsPallet
//lstrparms.String_arg[64] = lsContainer
lstrparms.String_arg[20] =asSKU
lstrparms.String_arg[21] = asSerial
				
//Ship To
Lstrparms.String_arg[13] = w_do.idw_Main.GetItemString(1,'Cust_name')
Lstrparms.String_arg[14] = w_do.idw_Main.GetItemString(1,'address_1')
Lstrparms.String_arg[15] = w_do.idw_Main.GetItemString(1,'address_2')
Lstrparms.String_arg[16] = w_do.idw_Main.GetItemString(1,'address_3')
Lstrparms.String_arg[32] = w_do.idw_Main.GetItemString(1,'address_4')
						
//Compute TO City,State & Zip
lsCityStateZip = ''
If Not isnull(w_do.idw_Main.GetItemString(1,'City')) Then lsCityStateZip = w_do.idw_Main.GetItemString(1,'City') + ', '
If Not isnull(w_do.idw_Main.GetItemString(1,'State')) Then lsCityStateZip += w_do.idw_Main.GetItemString(1,'State') + ' '
If Not isnull(w_do.idw_Main.GetItemString(1,'Zip')) Then lsCityStateZip += w_do.idw_Main.GetItemString(1,'Zip') + ' '
Lstrparms.String_arg[17] = lsCityStateZip					
				
lstrparms.String_arg[40] = lsDoNo					

If llPackFindRow > 0 Then
	Lstrparms.String_arg[48] = uf_friedrich_get_scc( w_do.idw_Pack.GetItemString(llPackFindRow,'Carton_no'), lsDoNo)
End If
				
//Lstrparms.String_arg[49] = lsContainer
Lstrparms.String_arg[23] = w_do.idw_Main.GetItemString(1,'Invoice_No')
Lstrparms.String_arg[24] = w_do.idw_Main.GetItemString(1,'carrier')
Lstrparms.String_arg[10] = w_do.idw_Main.GetItemString(1,'Awb_Bol')
Lstrparms.String_arg[11] = w_do.idw_Main.GetItemString(1,'carrier_pro_no') /*User_Field7 Pro Jxlim 04/02/2014 Replaced with Carrier_Pro_No name field*/

//Lstrparms.String_arg[25] = String(dw_label.GetItemNumber(llRowPos,'quantity'))
Lstrparms.String_arg[25] = '1'
				
If w_do.idw_MAin.GetItemString(1,'Cust_Order_No') > '' Then
	Lstrparms.String_arg[26] = w_do.idw_Main.GetItemString(1,'Cust_Order_No')
Else
	Lstrparms.String_arg[26] = "         "
End If
				
If llPackFindRow > 0 Then
	Lstrparms.String_arg[28] = w_do.idw_Pack.GetItemString(llPackFindRow,'Carton_No') //Carton tot
End If
				
	
//Pallet 1 of 1
//Lstrparms.String_arg[29] = String(llRowPos) //tot_off
//Lstrparms.String_arg[30] = String(llRowCount) //tot
Lstrparms.String_arg[29] = '1'
Lstrparms.String_arg[30] = '1'

//Lstrparms.String_arg[1] = String(dw_label.GetItemNumber(llRowPos,'c_print_qty'))
Lstrparms.String_arg[1] = '1'
				
//This is used for the Grainger label
lstrparms.String_arg[61] = w_do.idw_Pack.GetItemString(llRowPos,'Alternate_SKU')

//lstrparms.String_arg[62] = String(dw_label.GetItemNumber(llRowPos,'Quantity'))
lstrparms.String_arg[62] = '1'
					
//lstrparms.string_arg[65] = lsPrintLable
//lstrparms.string_arg[66] = lsPrintCarton
//lstrparms.string_arg[67] = 'BESTBUY'
				
lstrparms.Long_Arg[1] = 1 /*qty of labels to print*/

setLabelSequence( llRowPos )
				
lsAny=lstrparms		
				

//setparms( lsAny )
uf_friedrich_ucc_128_zebra_ship(lsAny)


Return 0
end function

public function string uf_friedrich_get_scc (string ascartonno, string asdono);String lsCartonNo ,lsUCCS,lsDONO,lsOutString,lsDelimitChar
Long liCartonNo,liCheck

lsCartonNo = asCartonNo
lsDONO = asDono
lsDelimitChar = char(9)

//                                                lsCartonNo = idsdoPack.GetItemString(llRowPos, 'Carton_No')

IF IsNull(isUCCCompanyPrefix) or isUCCCompanyPrefix = '' Then
	
	SELECT Project.UCC_Company_Prefix 
	INTO :isUCCCompanyPrefix 
	FROM Project 
	WHERE Project_ID = :gs_project USING SQLCA;
	
End If

IF IsNull(isUCCCompanyPrefix) Then isUCCCompanyPrefix = ''

																
If IsNull(lsCartonNo) then lsCartonNo = ''
If lsCartonNo <> '' Then
	
	/* per Ariens, The base is $$HEX1$$1820$$ENDHEX$$0000751058000000000N$$HEX2$$18202000$$ENDHEX$$where N is the check digit.
     lsUCCS must be 17 digits long....
    using 00751058 for Company code, preceding that by '00' so need 9 digits for serial of carton
    using last 5 of do_no and then carton numbers, formatted to 4 digits
    */
	 
    //the string function to pad 0's for the carton number doesn't work (returning only '0000')
    liCartonNo = integer(lsCartonNo)
   lsCartonNo = right(lsDONO, 5) + string(liCartonNo, '0000')
   lsUCCS =  trim((isUCCCompanyPrefix +  lsCartonNo))
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

public function integer uf_friedrich_ucc_128_zebra_ship (any as_any);//This function will print  Generic UCCS Shipping label

Str_parms	lStrparms
String	lsFormatUCC_128,	&
			lsCartonBarcode,	&
			lsTemp,				&
			lsPrintText,		&
			lsAddr,ls_weight,ls_temp,	&
			lsUCCCarton,ls_ucc,  lsFormatGrainger, lsFormatJohnstone,lsFormatBluestem,lsFormatBBB //28-Apr-2015 :Madhu- Added Bed Bath & Beyond Label.

Long	llPrintJob,	&
		llPos,		&
		llPrintQty,	&
		llPrintPos,	&
		llCartonNo,	&
		llAddrPos,i,j,ll_no_of_copies
		
Integer	liFileNo, liCheck
string ls_label_type	

lStrparms = as_any
//lstrparms = getparms()

	lsFormatUCC_128 = uf_read_label_Format('Friedrich_SSCC_zebra_ship.txt') 
	lsFormatGrainger = uf_read_label_Format('Friedrich_Grainger.txt') 
	lsFormatJohnstone = uf_read_label_Format('Friedrich_Johnstone.txt') 
	lsFormatBluestem = uf_read_label_Format('Friedrich_Bluestem.txt') //10-Sep-2014 : Madhu- Added new label
	lsFormatBBB = uf_read_label_Format('Friedrich_BBB_SSCC_zebra_ship.txt') //28-Apr-2015 :Madhu- Added Bed Bath & Beyond Label.

//END CHOOSE	
	
//Open Printer File 
llPrintJob = PrintOpen(lsPrintText)
	
If llPrintJob <0 Then 
	Messagebox('Labels', 'Unable to open Printer file. Labels will not be printed')
	Return -1
End If


//From Address - Roll up addresses if not all present
llAddrPos = 0

If lstrparms.String_Arg[2] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + "~~" //Customer WH Name
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,lsAddr,Left(lstrparms.String_Arg[2],30))
	lsFormatBBB = uf_Replace(lsFormatBBB,lsAddr,Left(lstrparms.String_Arg[2],30)) //28-Apr-2015 :Madhu- Added Bed Bath & Beyond Label.
End If
	
If lstrparms.String_Arg[3] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + "~~" //Address1
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,lsAddr,Left(lstrparms.String_Arg[3],30))
	lsFormatBBB = uf_Replace(lsFormatBBB,lsAddr,Left(lstrparms.String_Arg[3],30)) //28-Apr-2015 :Madhu- Added Bed Bath & Beyond Label.
End If

If lstrparms.String_Arg[4] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + "~~" //Address2
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,lsAddr,Left(lstrparms.String_Arg[4],30))
	lsFormatBBB = uf_Replace(lsFormatBBB,lsAddr,Left(lstrparms.String_Arg[4],30)) //28-Apr-2015 :Madhu- Added Bed Bath & Beyond Label.
End If

If lstrparms.String_Arg[5] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + "~~" //Address3
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,lsAddr,Left(lstrparms.String_Arg[5],30))
	lsFormatBBB = uf_Replace(lsFormatBBB,lsAddr,Left(lstrparms.String_Arg[5],30)) //28-Apr-2015 :Madhu- Added Bed Bath & Beyond Label.
End If

If lstrparms.String_Arg[6] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + "~~" //Address4
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,lsAddr,Left(lstrparms.String_Arg[6],30))
	lsFormatBBB = uf_Replace(lsFormatBBB,lsAddr,Left(lstrparms.String_Arg[6],30)) //28-Apr-2015 :Madhu- Added Bed Bath & Beyond Label.
End If

If lstrparms.String_Arg[7] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + "~~" //Address5
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,lsAddr,Left(lstrparms.String_Arg[7],30))
	lsFormatBBB = uf_Replace(lsFormatBBB,lsAddr,Left(lstrparms.String_Arg[7],30)) //28-Apr-2015 :Madhu- Added Bed Bath & Beyond Label.
End If

//Po No and B/L number
lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~po_nbr~~",left(lstrparms.String_Arg[11],30))	
lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~bol_nbr~~",left(lstrparms.String_Arg[10],30))	

//To Address - Roll up addresses if not all present
llAddrPos = 0

If lstrparms.String_Arg[12] > ' ' Then
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~" //Warehouse Name
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,lsAddr,Left(lstrparms.String_Arg[12],45))
	lsFormatBBB = uf_Replace(lsFormatBBB,lsAddr,Left(lstrparms.String_Arg[12],45)) //28-Apr-2015 :Madhu- Added Bed Bath & Beyond Label.
End If

If lstrparms.String_Arg[13] > ' ' Then
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~" //Address1
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,lsAddr,Left(lstrparms.String_Arg[13],45))
	lsFormatBBB = uf_Replace(lsFormatBBB,lsAddr,Left(lstrparms.String_Arg[13],45)) //28-Apr-2015 :Madhu- Added Bed Bath & Beyond Label.
End If

If lstrparms.String_Arg[14] > ' ' Then
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~" //Address2
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,lsAddr,left(lstrparms.String_Arg[14],45))
	lsFormatBBB = uf_Replace(lsFormatBBB,lsAddr,left(lstrparms.String_Arg[14],45)) //28-Apr-2015 :Madhu- Added Bed Bath & Beyond Label.
End If

If lstrparms.String_Arg[15] > ' ' Then
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~" //Address3
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,lsAddr,Left(lstrparms.String_Arg[15],45))
	lsFormatBBB = uf_Replace(lsFormatBBB,lsAddr,Left(lstrparms.String_Arg[15],45)) //28-Apr-2015 :Madhu- Added Bed Bath & Beyond Label.
End If

If lstrparms.String_Arg[16] > ' ' Then //Address4
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~"
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,lsAddr,left(lstrparms.String_Arg[16],45))
	lsFormatBBB = uf_Replace(lsFormatBBB,lsAddr,left(lstrparms.String_Arg[16],45)) //28-Apr-2015 :Madhu- Added Bed Bath & Beyond Label.
End If

If lstrparms.String_Arg[17] > ' ' Then //Address5
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~"
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,lsAddr,left(lstrparms.String_Arg[17],45))
	lsFormatBBB = uf_Replace(lsFormatBBB,lsAddr,left(lstrparms.String_Arg[17],45)) //28-Apr-2015 :Madhu- Added Bed Bath & Beyond Label.
End If
	
lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~sku~~", left(Lstrparms.String_arg[20],20))//Sku
lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~upc~~",left( lstrparms.String_Arg[21],30))//Alternate Sku
lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~invoice_no~~",left( lstrparms.String_Arg[23],30))//Order No
lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~carrier_name~~",left(lstrparms.String_Arg[24],30))//Carrier
lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~pro~~",left( lstrparms.String_Arg[26],30))

//TAM Added Pro Barcode
lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~pro_bc~~", left(Lstrparms.String_arg[26],30))

//lsFormatUCC_128 = uf_replace_label_text(lsFormatUCC_128,"QTY:",Left("",45)) //Blank out the QTY on the Pallet Label
//lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~quantity~~",left("",30))

lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~carton_no_readable~~", left(Lstrparms.String_arg[48],20))
lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,">;>=carton_no_BC>=", left(Lstrparms.String_arg[48],20)) 

lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~ship_to_zip~~", left(Lstrparms.String_arg[33],20))
lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~ship_to_zip_BC~~", left(Lstrparms.String_arg[33],20))
lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,">;>=ship_to_zip>=", left(Lstrparms.String_arg[33],20)) 


//??lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~customer_no~~",left( lstrparms.String_Arg[21],30)) /* 08/13 - PCONKL- this is now the Serial Number*/

//lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~pro_type~~",left( lstrparms.String_Arg[27],30)) //Hard Coded in the label
lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~carton_tot~~",left( lstrparms.String_Arg[28],30))

lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~tot_off~~",left( lstrparms.String_Arg[29],30))
lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~tot~~",left( lstrparms.String_Arg[30],30))


//Grainger Label
//Tam 07/2014 - Change qty(arg 62) to hardcoded 1
//lsFormatGrainger = uf_Replace(lsFormatGrainger,"~~User_Field1~~", left('(' + Lstrparms.String_arg[62] + ') ' + Lstrparms.String_arg[21],20))
//lsFormatGrainger= uf_Replace(lsFormatGrainger,">=User_Field1_BC>=", left(Lstrparms.String_arg[62] + ' ' + Lstrparms.String_arg[21],20))
lsFormatGrainger = uf_Replace(lsFormatGrainger,"~~User_Field1~~", left('(1) ' + Lstrparms.String_arg[21],20))
lsFormatGrainger= uf_Replace(lsFormatGrainger,">=User_Field1_BC>=", left('1 ' + Lstrparms.String_arg[21],20))
lsFormatGrainger = uf_Replace(lsFormatGrainger,"~~sku~~", left(Lstrparms.String_arg[20],20))

//Johnstone Label
lsFormatJohnstone = uf_Replace(lsFormatJohnstone,"~~Alternate~~", left(Lstrparms.String_arg[21],20))
lsFormatJohnstone= uf_Replace(lsFormatJohnstone,"~~SKU_barcode~~", left(Lstrparms.String_arg[20],20))
lsFormatJohnstone = uf_Replace(lsFormatJohnstone,"~~SKU~~", left(Lstrparms.String_arg[20],20))

//Bluestem Label
//10-Sep-2014 : Madhu- Added code for BLUE STEM Label -START
//ship To address
lsFormatBluestem =uf_Replace(lsFormatBluestem,"~~cust_name~~",left(Lstrparms.String_arg[12],20))
lsFormatBluestem =uf_Replace(lsFormatBluestem,"~~address_1~~",left(Lstrparms.String_arg[13],20))
lsFormatBluestem =uf_Replace(lsFormatBluestem,"~~address_2~~",left(Lstrparms.String_arg[14],20))
lsFormatBluestem =uf_Replace(lsFormatBluestem,"~~address_3~~",left(Lstrparms.String_arg[15],20))
lsFormatBluestem =uf_Replace(lsFormatBluestem,"~~address_4~~",left(Lstrparms.String_arg[16],20))
lsFormatBluestem =uf_Replace(lsFormatBluestem,"~~city~~",left(Lstrparms.String_arg[17],20))
lsFormatBluestem =uf_Replace(lsFormatBluestem,"~~po_no~~",left(lstrparms.String_Arg[11],20))


//print 10 pair of SKU +Qty values on label
lsFormatBluestem =uf_Replace(lsFormatBluestem,"~~sku~~",left(lstrparms.String_Arg[36],20))
lsFormatBluestem =uf_Replace(lsFormatBluestem,"~~qty~~",left(lstrparms.String_Arg[37],20))
lsFormatBluestem =uf_Replace(lsFormatBluestem,"~~sku1~~",left(lstrparms.String_Arg[38],20))
lsFormatBluestem =uf_Replace(lsFormatBluestem,"~~qty1~~",left(lstrparms.String_Arg[39],20))
lsFormatBluestem =uf_Replace(lsFormatBluestem,"~~sku2~~",left(lstrparms.String_Arg[40],20))
lsFormatBluestem =uf_Replace(lsFormatBluestem,"~~qty2~~",left(lstrparms.String_Arg[41],20))
lsFormatBluestem =uf_Replace(lsFormatBluestem,"~~sku3~~",left(lstrparms.String_Arg[42],20))
lsFormatBluestem =uf_Replace(lsFormatBluestem,"~~qty3~~",left(lstrparms.String_Arg[43],20))
lsFormatBluestem =uf_Replace(lsFormatBluestem,"~~sku4~~",left(lstrparms.String_Arg[44],20))
lsFormatBluestem =uf_Replace(lsFormatBluestem,"~~qty4~~",left(lstrparms.String_Arg[45],20))
lsFormatBluestem =uf_Replace(lsFormatBluestem,"~~sku5~~",left(lstrparms.String_Arg[46],20))
lsFormatBluestem =uf_Replace(lsFormatBluestem,"~~qty5~~",left(lstrparms.String_Arg[47],20))
lsFormatBluestem =uf_Replace(lsFormatBluestem,"~~sku6~~",left(lstrparms.String_Arg[48],20))
lsFormatBluestem =uf_Replace(lsFormatBluestem,"~~qty6~~",left(lstrparms.String_Arg[49],20))
lsFormatBluestem =uf_Replace(lsFormatBluestem,"~~sku7~~",left(lstrparms.String_Arg[50],20))
lsFormatBluestem =uf_Replace(lsFormatBluestem,"~~qty7~~",left(lstrparms.String_Arg[51],20))
lsFormatBluestem =uf_Replace(lsFormatBluestem,"~~sku8~~",left(lstrparms.String_Arg[52],20))
lsFormatBluestem =uf_Replace(lsFormatBluestem,"~~qty8~~",left(lstrparms.String_Arg[53],20))
lsFormatBluestem =uf_Replace(lsFormatBluestem,"~~sku9~~",left(lstrparms.String_Arg[54],20))
lsFormatBluestem =uf_Replace(lsFormatBluestem,"~~qty9~~",left(lstrparms.String_Arg[55],20))
lsFormatBluestem =uf_Replace(lsFormatBluestem,"~~sku10~~",left(lstrparms.String_Arg[56],20))
lsFormatBluestem =uf_Replace(lsFormatBluestem,"~~qty10~~",left(lstrparms.String_Arg[57],20))

//Print Total qty of each carton and MIXED SKU YES /No.
lsFormatBluestem =uf_Replace(lsFormatBluestem,"~~totalqty~~",left(lstrparms.String_Arg[58],20))
lsFormatBluestem =uf_Replace(lsFormatBluestem,"~~msg_text~~",left(lstrparms.String_Arg[59],20))

//10-Sep-2014 : Madhu- Added code for BLUE STEM Label -END

//28-Apr-2015 :Madhu- Added Bed Bath & Beyond Label -START

lsFormatBBB = uf_Replace(lsFormatBBB,"~~cons_no~~",left(lstrparms.String_Arg[18],30)) //B/L

lsFormatBBB = uf_Replace(lsFormatBBB,"~~upc~~",left( lstrparms.String_Arg[21],30))//Alternate Sku
lsFormatBBB = uf_Replace(lsFormatBBB,"~~upc_BC~~",left( lstrparms.String_Arg[21],30))//Alternate Sku
lsFormatBBB = uf_Replace(lsFormatBBB,"~~scac~~",left(lstrparms.String_Arg[24],30))//Scac
lsFormatBBB = uf_Replace(lsFormatBBB,"~~pro~~",left( lstrparms.String_Arg[26],30))
lsFormatBBB = uf_Replace(lsFormatBBB,"~~store~~",left( lstrparms.String_Arg[19],30))
lsFormatBBB = uf_Replace(lsFormatBBB,"~~description~~",left( lstrparms.String_Arg[28],30))
lsFormatBBB =uf_Replace(lsFormatBBB,"~~qty~~",left(lstrparms.String_Arg[58],20))

lsFormatBBB = uf_Replace(lsFormatBBB,"~~carton_no_readable~~", left(Lstrparms.String_arg[48],20))
lsFormatBBB = uf_Replace(lsFormatBBB,">;>=carton_no_BC>=", left(Lstrparms.String_arg[48],20)) 

lsFormatBBB = uf_Replace(lsFormatBBB,"~~ship_to_zip~~", left(Lstrparms.String_arg[33],20))
lsFormatBBB = uf_Replace(lsFormatBBB,"~~ship_to_zip_BC~~", left(Lstrparms.String_arg[33],20))
lsFormatBBB = uf_Replace(lsFormatBBB,">;>=ship_to_zip>=", left(Lstrparms.String_arg[33],20)) 

lsFormatBBB =uf_Replace(lsFormatBBB,"~~po_nbr~~",left(lstrparms.String_Arg[11],20))
lsFormatBBB =uf_Replace(lsFormatBBB,"~~po_nbr_BC~~",left(lstrparms.String_Arg[11],20))

lsFormatBBB =uf_Replace(lsFormatBBB,"~~shipping_instructions~~",left(lstrparms.String_Arg[25],20))

lsFormatBBB =uf_Replace(lsFormatBBB,"~~carton_total~~",left(lstrparms.String_Arg[34],30))

//28-Apr-2015 :Madhu- Added Bed Bath & Beyond Label -END

//No of copies  *removed from here and put in the calling window
//ll_no_of_copies = lstrparms.Long_Arg[1]
//FOR i= 1 TO ll_no_of_copies

	If lstrparms.String_Arg[60] = 'GRAINGER' then
		PrintSend(llPrintJob, lsFormatGrainger) //Second label	
	ElseIf lstrparms.String_Arg[60] = 'JOHNSTONE' then
		PrintSend(llPrintJob, lsFormatJohnstone) //Second label	
	ElseIf lstrparms.String_Arg[60] = 'BLUESTEM' then
		PrintSend(llPrintJob, lsFormatBluestem) //Second label		
	ElseIf lstrparms.String_Arg[60] ='BEDBATH' then
		PrintSend(llPrintJob, lsFormatBBB) //Second label
	Else
		PrintSend(llPrintJob, lsFormatUCC_128)	
	End if

//	ls_temp= lstrparms.String_Arg[28]
//NEXT
	
PrintClose(llPrintJob)

Return 0



end function

public function string uf_ariens_get_scc (string ascartonno, string asdono);String lsCartonNo ,lsUCCS,lsDONO,lsOutString,lsDelimitChar
Long liCartonNo,liCheck

lsCartonNo = asCartonNo
lsDONO = asDono
lsDelimitChar = char(9)

//                                                lsCartonNo = idsdoPack.GetItemString(llRowPos, 'Carton_No')

IF IsNull(isUCCCompanyPrefix) or isUCCCompanyPrefix = '' Then
	
	SELECT Project.UCC_Company_Prefix 
	INTO :isUCCCompanyPrefix 
	FROM Project 
	WHERE Project_ID = :gs_project USING SQLCA;
	
End If

IF IsNull(isUCCCompanyPrefix) Then isUCCCompanyPrefix = ''

																
If IsNull(lsCartonNo) then lsCartonNo = ''
If lsCartonNo <> '' Then
	
	/* per Ariens, The base is $$HEX1$$1820$$ENDHEX$$0000751058000000000N$$HEX2$$18202000$$ENDHEX$$where N is the check digit.
     lsUCCS must be 17 digits long....
    using 00751058 for Company code, preceding that by '00' so need 9 digits for serial of carton
    using last 5 of do_no and then carton numbers, formatted to 4 digits
    */
	 
    //the string function to pad 0's for the carton number doesn't work (returning only '0000')
    liCartonNo = integer(lsCartonNo)
   lsCartonNo = right(lsDONO, 5) + string(liCartonNo, '0000')
   lsUCCS =  trim((isUCCCompanyPrefix +  lsCartonNo))
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

public function integer uf_ariens_ucc_by_scan (integer ailine, string assku, string asserial, string ascarton);
Str_Parms	lstrparms
n_labels	lu_labels
Long	llQty, llRowCount, llRowPos
Any	lsAny
Long liRC,llPackFindRow
String lsRoNo, lsDoNo, lsPallet, lsContainer, lsNextPallet,lsCityStateZip,lsWHCityStateZip
String lsPrintLable, lsPrintCarton,lsCustomer,lsWarehouse
string ls_vics_bol_no,  ls_awb_bol_no,lsSSCC
n_warehouse l_nwarehouse 
n_cst_common_tables ln_common_tables

//If we haven't already prompted for a printer, do so now
If Not ibPrinterSelected Then
				
	OpenWithParm(w_label_print_options,lStrParms)
	Lstrparms = Message.PowerObjectParm	
				
	If  lstrparms.cancelled Then
		Return 0	
	End If
	
	ibPrinterSelected = True
				
End If
			
//Get THe  PAcking ROw from the Line Item passed in
//llPackFindRow = w_do.idw_pack.Find("Line_Item_No = " + string(ailine) ,1,w_do.idw_pack.RowCount()) //06-Mar-2014 :Madhu- commented for Ariens SSCC
llPackFindRow = w_do.idw_pack.Find("Line_Item_No = " + string(ailine) + " and Carton_no = '" + ascarton +"'" ,1,w_do.idw_pack.RowCount()) //06-Mar-2014 :Madhu- Added for Ariens SSCC

ls_awb_bol_no =  w_do.idw_Main.GetItemString(1, "awb_bol_no")
lsDoNo = w_do.idw_Main.GetITemString(1,'Do_No')
			
lstrparms.String_arg[70] = w_do.idw_Main.GetITemString(1,'User_Field7')
			
//If isLabelName = 'GRAINGER' then
//	If Pos(lstrparms.String_Arg[70], 'PR2') > 0 then
//			lstrparms.String_arg[60] = isLabelName
//	End if
//End if
			
//lstrparms.String_arg[65] = 'OUTBOUND'
		

llQty = 1
							
//Ship From
lsWarehouse = w_do.idw_main.getItemString(1,'wh_code')

If lsWarehouse <> isWarehouseSave Then
				
	SELECT  wh_name  , Address_1 ,Address_2  ,Address_3  ,Address_4   ,City  ,State  ,Zip
	INTO :isCustName, :isAddress_1 ,:isAddress_2, :isAddress_3 ,:isAddress_4 ,:isCity ,:isState ,:isZip
	FROM Warehouse where  wh_Code = :lsWarehouse;
	
	isWarehouseSave = lsWarehouse
	
End If
	
	
lstrParms.String_arg[2] = isCustName
Lstrparms.String_arg[3] = isAddress_1
Lstrparms.String_arg[4] = isAddress_2
Lstrparms.String_arg[5] = isAddress_3
Lstrparms.String_arg[6] = isAddress_4
If Not isnull(isCity) Then lsCityStateZip = isCity + ', '
If Not isnull(isState) Then lsCityStateZip += isState + ' '
If Not isnull(isZip) Then lsCityStateZip += isZip + ' '
Lstrparms.String_arg[7] = lsCityStateZip			
	
							
lstrparms.String_arg[10]  = w_do.idw_Main.GetItemString(1,'awb_bol_no')
//Jxlim 03/27/2014 Replaced user_field5 with Carrier_pro_no name field
//lstrparms.String_arg[11]  = w_do.idw_Main.GetItemString(1,'User_Field5')
lstrparms.String_arg[11]  = w_do.idw_Main.GetItemString(1,'Carrier_pro_no')
					
lstrparms.String_arg[63] = lsPallet
//lstrparms.String_arg[64] = lsContainer
lstrparms.String_arg[20] =asSKU
lstrparms.String_arg[21] = asSerial
				
//Ship To
Lstrparms.String_arg[13] = w_do.idw_Main.GetItemString(1,'Cust_name')
Lstrparms.String_arg[14] = w_do.idw_Main.GetItemString(1,'address_1')
Lstrparms.String_arg[15] = w_do.idw_Main.GetItemString(1,'address_2')
Lstrparms.String_arg[16] = w_do.idw_Main.GetItemString(1,'address_3')
Lstrparms.String_arg[32] = w_do.idw_Main.GetItemString(1,'address_4')
						
//Compute TO City,State & Zip
lsCityStateZip = ''
If Not isnull(w_do.idw_Main.GetItemString(1,'City')) Then lsCityStateZip = w_do.idw_Main.GetItemString(1,'City') + ', '
If Not isnull(w_do.idw_Main.GetItemString(1,'State')) Then lsCityStateZip += w_do.idw_Main.GetItemString(1,'State') + ' '
If Not isnull(w_do.idw_Main.GetItemString(1,'Zip')) Then lsCityStateZip += w_do.idw_Main.GetItemString(1,'Zip') + ' '
Lstrparms.String_arg[17] = lsCityStateZip					
				
lstrparms.String_arg[40] = lsDoNo					

If llPackFindRow > 0 Then
	Lstrparms.String_arg[48] = uf_ariens_get_scc( w_do.idw_Pack.GetItemString(llPackFindRow,'Carton_no'), lsDoNo) //06-Mar-2014 :Madhu- commented for Ariens SSCC
End If
				
//Lstrparms.String_arg[49] = lsContainer
Lstrparms.String_arg[23] = w_do.idw_Main.GetItemString(1,'Invoice_No')
Lstrparms.String_arg[24] = w_do.idw_Main.GetItemString(1,'carrier')

//Lstrparms.String_arg[25] = String(dw_label.GetItemNumber(llRowPos,'quantity'))
Lstrparms.String_arg[25] = '1'
				
If w_do.idw_MAin.GetItemString(1,'Cust_Order_No') > '' Then
	Lstrparms.String_arg[26] = w_do.idw_Main.GetItemString(1,'Cust_Order_No')
Else
	Lstrparms.String_arg[26] = "         "
End If
				
If llPackFindRow > 0 Then
//	Lstrparms.String_arg[28] = w_do.idw_Pack.GetItemString(llPackFindRow,'Carton_No') //Carton tot //06-Mar-2014 :Madhu- commented for Ariens SSCC
	Lstrparms.String_arg[28] = '1'  //06-Mar-2014 :Madhu- Added for Ariens SSCC
End If
				
	
//Pallet 1 of 1
//Lstrparms.String_arg[29] = String(llRowPos) //tot_off
//Lstrparms.String_arg[30] = String(llRowCount) //tot
Lstrparms.String_arg[29] = '1'
Lstrparms.String_arg[30] = '1'

//Lstrparms.String_arg[1] = String(dw_label.GetItemNumber(llRowPos,'c_print_qty'))
Lstrparms.String_arg[1] = '1'
				
//This is used for the Grainger label
//lstrparms.String_arg[61] = dw_label.GetItemString(llRowPos,'Alternate_SKU')

//lstrparms.String_arg[62] = String(dw_label.GetItemNumber(llRowPos,'Quantity'))
lstrparms.String_arg[62] = '1'
					
//lstrparms.string_arg[65] = lsPrintLable
//lstrparms.string_arg[66] = lsPrintCarton
//lstrparms.string_arg[67] = 'BESTBUY'
				
lstrparms.Long_Arg[1] = 1 /*qty of labels to print*/

setLabelSequence( llRowPos )
				
lsAny=lstrparms		
				

setparms( lsAny )
uf_ariens_ucc_128_zerbra_ship()


Return 0

end function

public function integer uf_anki_uccs_zebra (any as_array);
//05-Oct-2014 :Madhu- Printing SSCC-128 carton Label for ANKI

Str_parms	lStrparms
String	lsFormat_Amazon_UCC_128,	&
			lsFormat_Toys_R_US_UCC_128, &
			lsFormat_Toys_R_US_UCC_128_EU, &
			lsPrintText,		&
			lsAddr, &
			ls_custname

Long	llPrintJob,	&
		llAddrPos,i,j,ll_no_of_copies
		

//lstrparms = getparms()
lstrparms = as_array

lsFormat_Amazon_UCC_128 = uf_read_label_Format('Anki_Amazon_Carton_SSCC18_Label.txt')
lsFormat_Toys_R_US_UCC_128 = uf_read_label_Format('Anki_Toys_R_US_SSCC18_Label.txt')

//TAM 08/2015 - Added European TRU label.  Cloned below fro existing TRU label. TRU EU label needs 2 additional fields not on TRU label. 
lsFormat_Toys_R_US_UCC_128_EU = uf_read_label_Format('Anki_Toys_R_US_SSCC18_EU_Label.txt') 


//Open Printer File 
llPrintJob = PrintOpen(lsPrintText)
	
If llPrintJob <0 Then 
	Messagebox('Labels', 'Unable to open Printer file. Labels will not be printed')
	Return -1
End If


//From Address - Roll up addresses if not all present
llAddrPos = 0

If lstrparms.String_Arg[2] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + "~~"
	lsFormat_Amazon_UCC_128 = uf_Replace(lsFormat_Amazon_UCC_128,lsAddr,Left(lstrparms.String_Arg[2],30))
	lsFormat_Toys_R_US_UCC_128 = uf_Replace(lsFormat_Toys_R_US_UCC_128,lsAddr,Left(lstrparms.String_Arg[2],30))
	lsFormat_Toys_R_US_UCC_128_EU = uf_Replace(lsFormat_Toys_R_US_UCC_128_EU,lsAddr,Left(lstrparms.String_Arg[2],30))
End If
	
If lstrparms.String_Arg[3] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + "~~"
	lsFormat_Amazon_UCC_128 = uf_Replace(lsFormat_Amazon_UCC_128,lsAddr,Left(lstrparms.String_Arg[3],30))
	lsFormat_Toys_R_US_UCC_128 = uf_Replace(lsFormat_Toys_R_US_UCC_128,lsAddr,Left(lstrparms.String_Arg[3],30))
	lsFormat_Toys_R_US_UCC_128_EU = uf_Replace(lsFormat_Toys_R_US_UCC_128_EU,lsAddr,Left(lstrparms.String_Arg[3],30))
End If

If lstrparms.String_Arg[4] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + "~~"
	lsFormat_Amazon_UCC_128 = uf_Replace(lsFormat_Amazon_UCC_128,lsAddr,Left(lstrparms.String_Arg[4],30))
	lsFormat_Toys_R_US_UCC_128 = uf_Replace(lsFormat_Toys_R_US_UCC_128,lsAddr,Left(lstrparms.String_Arg[4],30))
	lsFormat_Toys_R_US_UCC_128_EU = uf_Replace(lsFormat_Toys_R_US_UCC_128_EU,lsAddr,Left(lstrparms.String_Arg[4],30))
End If

If lstrparms.String_Arg[5] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + "~~"
	lsFormat_Amazon_UCC_128 = uf_Replace(lsFormat_Amazon_UCC_128,lsAddr,Left(lstrparms.String_Arg[5],30))
	lsFormat_Toys_R_US_UCC_128 = uf_Replace(lsFormat_Toys_R_US_UCC_128,lsAddr,Left(lstrparms.String_Arg[5],30))
	lsFormat_Toys_R_US_UCC_128_EU = uf_Replace(lsFormat_Toys_R_US_UCC_128_EU,lsAddr,Left(lstrparms.String_Arg[5],30))
End If

If lstrparms.String_Arg[6] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + "~~"
	lsFormat_Amazon_UCC_128 = uf_Replace(lsFormat_Amazon_UCC_128,lsAddr,Left(lstrparms.String_Arg[6],30))
	lsFormat_Toys_R_US_UCC_128 = uf_Replace(lsFormat_Toys_R_US_UCC_128,lsAddr,Left(lstrparms.String_Arg[6],30))
	lsFormat_Toys_R_US_UCC_128_EU = uf_Replace(lsFormat_Toys_R_US_UCC_128_EU,lsAddr,Left(lstrparms.String_Arg[6],30))
End If

If lstrparms.String_Arg[7] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + "~~"
	lsFormat_Amazon_UCC_128 = uf_Replace(lsFormat_Amazon_UCC_128,lsAddr,Left(lstrparms.String_Arg[7],30))
	lsFormat_Toys_R_US_UCC_128 = uf_Replace(lsFormat_Toys_R_US_UCC_128,lsAddr,Left(lstrparms.String_Arg[7],30))
	lsFormat_Toys_R_US_UCC_128_EU = uf_Replace(lsFormat_Toys_R_US_UCC_128_EU,lsAddr,Left(lstrparms.String_Arg[7],30))
End If

lsFormat_Amazon_UCC_128 = uf_Replace(lsFormat_Amazon_UCC_128,"~~carrier_pro_no~~",left(lstrparms.String_Arg[11],30))	
lsFormat_Amazon_UCC_128 = uf_Replace(lsFormat_Amazon_UCC_128,">;>=carrier_pro_no_bc>=", left(Lstrparms.String_arg[11],30))  

lsFormat_Toys_R_US_UCC_128 = uf_Replace(lsFormat_Toys_R_US_UCC_128,"~~carrier_pro_no~~",left(lstrparms.String_Arg[11],30))	
lsFormat_Toys_R_US_UCC_128_EU = uf_Replace(lsFormat_Toys_R_US_UCC_128_EU,"~~carrier_pro_no~~",left(lstrparms.String_Arg[11],30))	

//To Address - Roll up addresses if not all present
llAddrPos = 0

If lstrparms.String_Arg[13] > ' ' Then
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~" //Warehouse Name
	lsFormat_Amazon_UCC_128 = uf_Replace(lsFormat_Amazon_UCC_128,lsAddr,Left(lstrparms.String_Arg[13],45))
	lsFormat_Toys_R_US_UCC_128 = uf_Replace(lsFormat_Toys_R_US_UCC_128,lsAddr,Left(lstrparms.String_Arg[13],45))
	lsFormat_Toys_R_US_UCC_128_EU = uf_Replace(lsFormat_Toys_R_US_UCC_128_EU,lsAddr,Left(lstrparms.String_Arg[13],45))
End If

If lstrparms.String_Arg[14] > ' ' Then
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~" //Address1
	lsFormat_Amazon_UCC_128 = uf_Replace(lsFormat_Amazon_UCC_128,lsAddr,Left(lstrparms.String_Arg[14],45))
	lsFormat_Toys_R_US_UCC_128 = uf_Replace(lsFormat_Toys_R_US_UCC_128,lsAddr,Left(lstrparms.String_Arg[14],45))
	lsFormat_Toys_R_US_UCC_128_EU = uf_Replace(lsFormat_Toys_R_US_UCC_128_EU,lsAddr,Left(lstrparms.String_Arg[14],45))
End If

If lstrparms.String_Arg[15] > ' ' Then
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~" //Address2
	lsFormat_Amazon_UCC_128 = uf_Replace(lsFormat_Amazon_UCC_128,lsAddr,left(lstrparms.String_Arg[15],45))
	lsFormat_Toys_R_US_UCC_128 = uf_Replace(lsFormat_Toys_R_US_UCC_128,lsAddr,left(lstrparms.String_Arg[15],45))
	lsFormat_Toys_R_US_UCC_128_EU = uf_Replace(lsFormat_Toys_R_US_UCC_128_EU,lsAddr,left(lstrparms.String_Arg[15],45))
End If

If lstrparms.String_Arg[16] > ' ' Then
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~" //Address3
	lsFormat_Amazon_UCC_128 = uf_Replace(lsFormat_Amazon_UCC_128,lsAddr,Left(lstrparms.String_Arg[16],45))
	lsFormat_Toys_R_US_UCC_128 = uf_Replace(lsFormat_Toys_R_US_UCC_128,lsAddr,Left(lstrparms.String_Arg[16],45))
	lsFormat_Toys_R_US_UCC_128_EU = uf_Replace(lsFormat_Toys_R_US_UCC_128_EU,lsAddr,Left(lstrparms.String_Arg[16],45))
End If

If lstrparms.String_Arg[17] > ' ' Then //Address4
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~"
	lsFormat_Amazon_UCC_128 = uf_Replace(lsFormat_Amazon_UCC_128,lsAddr,left(lstrparms.String_Arg[17],45))
	lsFormat_Toys_R_US_UCC_128 = uf_Replace(lsFormat_Toys_R_US_UCC_128,lsAddr,left(lstrparms.String_Arg[17],45))
	lsFormat_Toys_R_US_UCC_128_EU = uf_Replace(lsFormat_Toys_R_US_UCC_128_EU,lsAddr,left(lstrparms.String_Arg[17],45))
End If

If lstrparms.String_Arg[18] > ' ' Then //Address5
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~"
	lsFormat_Amazon_UCC_128 = uf_Replace(lsFormat_Amazon_UCC_128,lsAddr,left(lstrparms.String_Arg[18],45))
	lsFormat_Toys_R_US_UCC_128 = uf_Replace(lsFormat_Toys_R_US_UCC_128,lsAddr,left(lstrparms.String_Arg[18],45))
	lsFormat_Toys_R_US_UCC_128_EU = uf_Replace(lsFormat_Toys_R_US_UCC_128_EU,lsAddr,left(lstrparms.String_Arg[18],45))
End If
	
//Carrier ,bol, prono, pono related information
lsFormat_Amazon_UCC_128 = uf_Replace(lsFormat_Amazon_UCC_128,"~~Carrier_name~~",left(lstrparms.String_Arg[24],30))
lsFormat_Amazon_UCC_128 = uf_Replace(lsFormat_Amazon_UCC_128,"~~pro~~",left(lstrparms.String_Arg[11],30))
lsFormat_Amazon_UCC_128 = uf_Replace(lsFormat_Amazon_UCC_128,"~~bol_nbr~~",left( lstrparms.String_Arg[10],30))
lsFormat_Amazon_UCC_128 = uf_Replace(lsFormat_Amazon_UCC_128,">;>=bol_nbr_bc>=", left(Lstrparms.String_arg[10],30)) 
lsFormat_Amazon_UCC_128 = uf_Replace(lsFormat_Amazon_UCC_128,"~~invoice_no~~",left(lstrparms.String_Arg[23],30))
lsFormat_Amazon_UCC_128 = uf_Replace(lsFormat_Amazon_UCC_128,"~~alloc_qty~~",left(lstrparms.String_Arg[31],30))

lsFormat_Toys_R_US_UCC_128 = uf_Replace(lsFormat_Toys_R_US_UCC_128,"~~Carrier_name~~",left(lstrparms.String_Arg[24],30))
lsFormat_Toys_R_US_UCC_128 = uf_Replace(lsFormat_Toys_R_US_UCC_128,"~~pro~~",left(lstrparms.String_Arg[11],30))
lsFormat_Toys_R_US_UCC_128 = uf_Replace(lsFormat_Toys_R_US_UCC_128,"~~bol_nbr~~",left( lstrparms.String_Arg[10],30))
lsFormat_Toys_R_US_UCC_128 = uf_Replace(lsFormat_Toys_R_US_UCC_128,"~~invoice_no~~",left(lstrparms.String_Arg[23],30))
lsFormat_Toys_R_US_UCC_128 = uf_Replace(lsFormat_Toys_R_US_UCC_128,"~~alloc_qty~~",left(lstrparms.String_Arg[31],30))

lsFormat_Toys_R_US_UCC_128_EU = uf_Replace(lsFormat_Toys_R_US_UCC_128_EU,"~~Carrier_name~~",left(lstrparms.String_Arg[24],30))
lsFormat_Toys_R_US_UCC_128_EU = uf_Replace(lsFormat_Toys_R_US_UCC_128_EU,"~~pro~~",left(lstrparms.String_Arg[11],30))
lsFormat_Toys_R_US_UCC_128_EU = uf_Replace(lsFormat_Toys_R_US_UCC_128_EU,"~~bol_nbr~~",left( lstrparms.String_Arg[10],30))
lsFormat_Toys_R_US_UCC_128_EU = uf_Replace(lsFormat_Toys_R_US_UCC_128_EU,"~~invoice_no~~",left(lstrparms.String_Arg[23],30))
lsFormat_Toys_R_US_UCC_128_EU = uf_Replace(lsFormat_Toys_R_US_UCC_128_EU,"~~alloc_qty~~",left(lstrparms.String_Arg[31],30))

//Location
lsFormat_Toys_R_US_UCC_128 = uf_Replace(lsFormat_Toys_R_US_UCC_128,"~~loc~~",left( lstrparms.String_Arg[36],30))
lsFormat_Toys_R_US_UCC_128 = uf_Replace(lsFormat_Toys_R_US_UCC_128,">;>=loc_bc>=", left(Lstrparms.String_arg[36],30)) 

lsFormat_Toys_R_US_UCC_128_EU = uf_Replace(lsFormat_Toys_R_US_UCC_128_EU,"~~loc~~",left( lstrparms.String_Arg[36],30))
lsFormat_Toys_R_US_UCC_128_EU = uf_Replace(lsFormat_Toys_R_US_UCC_128_EU,">;>=loc_bc>=", left(Lstrparms.String_arg[36],30)) 

//Po No
lsFormat_Toys_R_US_UCC_128 = uf_Replace(lsFormat_Toys_R_US_UCC_128,"~~po_nbr~~",left( lstrparms.String_Arg[22],30))
lsFormat_Toys_R_US_UCC_128_EU = uf_Replace(lsFormat_Toys_R_US_UCC_128_EU,"~~po_nbr~~",left( lstrparms.String_Arg[22],30))

//SSCC related information
lsFormat_Amazon_UCC_128 = uf_Replace(lsFormat_Amazon_UCC_128,"~~carton_no_readable~~", left(Lstrparms.String_arg[30],20))
lsFormat_Amazon_UCC_128 = uf_Replace(lsFormat_Amazon_UCC_128,">;>=carton_no_bc>=", left(Lstrparms.String_arg[30],20)) 

lsFormat_Toys_R_US_UCC_128 = uf_Replace(lsFormat_Toys_R_US_UCC_128,"~~carton_no_readable~~", left(Lstrparms.String_arg[30],20))
lsFormat_Toys_R_US_UCC_128 = uf_Replace(lsFormat_Toys_R_US_UCC_128,">;>=carton_no_bc>=", left(Lstrparms.String_arg[30],20)) 

lsFormat_Toys_R_US_UCC_128_EU = uf_Replace(lsFormat_Toys_R_US_UCC_128_EU,"~~carton_no_readable~~", left(Lstrparms.String_arg[30],20))
lsFormat_Toys_R_US_UCC_128_EU = uf_Replace(lsFormat_Toys_R_US_UCC_128_EU,">;>=carton_no_bc>=", left(Lstrparms.String_arg[30],20)) 

//ship To zip and barcode related information
lsFormat_Amazon_UCC_128 = uf_Replace(lsFormat_Amazon_UCC_128,"~~ship_to_Zip~~", left(Lstrparms.String_arg[33],20))
lsFormat_Amazon_UCC_128 = uf_Replace(lsFormat_Amazon_UCC_128,">;>=ship_to_zip_bc>=", left(Lstrparms.String_arg[33],20)) 

lsFormat_Toys_R_US_UCC_128 = uf_Replace(lsFormat_Toys_R_US_UCC_128,"~~ship_to_Zip~~", left(Lstrparms.String_arg[33],20))
lsFormat_Toys_R_US_UCC_128 = uf_Replace(lsFormat_Toys_R_US_UCC_128,">;>=ship_to_zip_bc>=", left(Lstrparms.String_arg[33],20)) 

lsFormat_Toys_R_US_UCC_128_EU = uf_Replace(lsFormat_Toys_R_US_UCC_128_EU,"~~ship_to_Zip~~", left(Lstrparms.String_arg[33],20))
lsFormat_Toys_R_US_UCC_128_EU = uf_Replace(lsFormat_Toys_R_US_UCC_128_EU,">;>=ship_to_zip_bc>=", left(Lstrparms.String_arg[33],20)) 

//If UPC Code value not present on Item Master, print SKU on label
If lstrparms.String_Arg[32]<> '' then
	lsFormat_Amazon_UCC_128 = uf_Replace(lsFormat_Amazon_UCC_128,"~~upc~~",left(lstrparms.String_Arg[32],30)) //print UPC value /MIXED SKUS
//TAM 08/15 - Removed UPC from printing for TRU Lsbel(always use SKU) Per Fred Somers' request.
//	lsFormat_Toys_R_US_UCC_128 = uf_Replace(lsFormat_Toys_R_US_UCC_128,"~~sku~~",left(lstrparms.String_Arg[32],30)) //print UPC value /MIXED SKUS.
	lsFormat_Toys_R_US_UCC_128 = uf_Replace(lsFormat_Toys_R_US_UCC_128,"~~sku~~",left(lstrparms.String_Arg[20],30)) //print SKU value /MIXED SKUS.
	lsFormat_Toys_R_US_UCC_128_EU = uf_Replace(lsFormat_Toys_R_US_UCC_128_EU,"~~sku~~",left(lstrparms.String_Arg[20],30)) //print SKU value /MIXED SKUS.
ELSE
	lsFormat_Amazon_UCC_128 = uf_Replace(lsFormat_Amazon_UCC_128,"~~upc~~",left(lstrparms.String_Arg[20],30)) //print SKU value
	lsFormat_Toys_R_US_UCC_128 = uf_Replace(lsFormat_Toys_R_US_UCC_128,"~~sku~~",left(lstrparms.String_Arg[20],30)) //print SKU value
	lsFormat_Toys_R_US_UCC_128_EU = uf_Replace(lsFormat_Toys_R_US_UCC_128_EU,"~~sku~~",left(lstrparms.String_Arg[20],30)) //print SKU value
End If

//carton 1 of 1
lsFormat_Amazon_UCC_128 = uf_Replace(lsFormat_Amazon_UCC_128,"~~carton_count~~",left( lstrparms.String_Arg[34],30))
lsFormat_Amazon_UCC_128 = uf_Replace(lsFormat_Amazon_UCC_128,"~~carton_total~~",left( lstrparms.String_Arg[35],30))

lsFormat_Toys_R_US_UCC_128 = uf_Replace(lsFormat_Toys_R_US_UCC_128,"~~carton_count~~",left( lstrparms.String_Arg[34],30))
lsFormat_Toys_R_US_UCC_128 = uf_Replace(lsFormat_Toys_R_US_UCC_128,"~~carton_total~~",left( lstrparms.String_Arg[35],30))

lsFormat_Toys_R_US_UCC_128_EU = uf_Replace(lsFormat_Toys_R_US_UCC_128_EU,"~~carton_count~~",left( lstrparms.String_Arg[34],30))
lsFormat_Toys_R_US_UCC_128_EU = uf_Replace(lsFormat_Toys_R_US_UCC_128_EU,"~~carton_total~~",left( lstrparms.String_Arg[35],30))

// TAM 08/2015 - Added 2 new Fields
lsFormat_Amazon_UCC_128 = uf_Replace(lsFormat_Amazon_UCC_128,"~~mfg_part~~",left( lstrparms.String_Arg[37],30))
lsFormat_Amazon_UCC_128 = uf_Replace(lsFormat_Amazon_UCC_128,"~~stock_keep_nbr~~",left( lstrparms.String_Arg[38],30))

lsFormat_Toys_R_US_UCC_128 = uf_Replace(lsFormat_Toys_R_US_UCC_128,"~~mfg_part~~",left( lstrparms.String_Arg[37],30))
lsFormat_Toys_R_US_UCC_128 = uf_Replace(lsFormat_Toys_R_US_UCC_128,"~~stock_keep_nbr~~",left( lstrparms.String_Arg[38],30))

lsFormat_Toys_R_US_UCC_128_EU = uf_Replace(lsFormat_Toys_R_US_UCC_128_EU,"~~mfg_part~~",left(lstrparms.String_Arg[37],30))
lsFormat_Toys_R_US_UCC_128_EU = uf_Replace(lsFormat_Toys_R_US_UCC_128_EU,"~~stock_keep_nbr~~",left(lstrparms.String_Arg[38],30))

//print no of copies
ll_no_of_copies = lstrparms.Long_Arg[1]
FOR i= 1 TO ll_no_of_copies
 IF Upper(lstrparms.String_Arg[60]) = 'TOYS R US' THEN
	PrintSend(llPrintJob, lsFormat_Toys_R_US_UCC_128)	
ELSE
	 IF Upper(lstrparms.String_Arg[60]) = 'TOYS R US EU' THEN
		PrintSend(llPrintJob, lsFormat_Toys_R_US_UCC_128_EU)	
	ELSE
		PrintSend(llPrintJob, lsFormat_Amazon_UCC_128)
	END IF
END IF
NEXT
PrintClose(llPrintJob)

Return 0


//14-Oct-2014 : Madhu- comented for ANKI- We designed a new custom label for ANKI
//This function will print  Anki UCCS Shipping label

/*Str_parms	lStrparms
String	lsFormat,	&
			lsCartonBarcode,	&
			lsTemp,				&
			lsPrintText,		&
			lsAddr,ls_weight,ls_temp,	&
			lsUCCCarton

Long	llPrintJob,	&
		llPos,		&
		llPrintQty,	&
		llPrintPos,	&
		llCartonNo,	&
		llAddrPos,i,j,ll_no_of_copies
		
Integer	liFileNo, liCheck


lstrparms = as_array

lsFormat = uf_read_label_Format('anki_zebra_ship_UCC.DWN') 
		
	
lsPrintText = 'UCCS Ship - Zebra'


//Open Printer File 
llPrintJob = PrintOpen(lsPrintText)
	
If llPrintJob <0 Then 
	Messagebox('Labels', 'Unable to open Printer file. Labels will not be printed')
	Return -1
End If

//We are looping once for each Qty of label being printed - The carton number is changing so we need to bump after each one.
//Replace placeholders in Format with Field Values

//From Address - Roll up addresses if not all present
	
llAddrPos = 0

If lstrparms.String_Arg[2] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + ",0030~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[2],30))
End If
	
If lstrparms.String_Arg[3] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + ",0030~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[3],30))
End If

If lstrparms.String_Arg[4] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + ",0030~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[4],30))
End If

If lstrparms.String_Arg[5] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + ",0030~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[5],30))
End If
	
If lstrparms.String_Arg[31] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + ",0030~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[31],45))
End If
	
If lstrparms.String_Arg[6] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + ",0030~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[6],30))
End If

If lstrparms.String_Arg[29] > ' ' Then 
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + ",0030~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[29],45))
End If

//To Address - Roll up addresses if not all present

llAddrPos = 0

If lstrparms.String_Arg[7] > ' ' Then
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + ",0045~~" //Customer Name
	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[7],45))
End If

If lstrparms.String_Arg[8] > ' ' Then
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + ",0045~~" //Address1
	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[8],45))
End If

If lstrparms.String_Arg[9] > ' ' Then
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + ",0045~~" //Address2
	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[9],45))
End If

If lstrparms.String_Arg[10] > ' ' Then
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + ",0045~~" //Address3
	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[10],45))
End If

If lstrparms.String_Arg[32] > ' ' Then //Address4
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + ",0045~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[32],45))
End If

If lstrparms.String_Arg[11] > ' ' Then //City,state,zip
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + ",0045~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[11],45))
End If

If lstrparms.String_Arg[30] > ' ' Then //To Country
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + ",0045~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[30],45))
End If

//Ship To Post Code
lsFormat = uf_Replace(lsFormat,"~~ship_to_zip,0012~~",left(lstrparms.String_Arg[33],12)) /* 12/03 - PCONKL - For UCCS Label */
	
//Ship To Post Code (BARCODE)	
lsFormat = uf_Replace(lsFormat,"~~ship_to_zip_BC,0008~~",left(lstrparms.String_Arg[33],8)) /* 12/03 - PCONKL - For UCCS Label */
	
//Jxlim 05/25/2012 Jira SIM-705 for Riverbed
If gs_project ='RIVERBED' Then
	//AWB
	lsFormat = uf_Replace(lsFormat,"~~bol_nbr,0020~~",lstrparms.String_Arg[34]) /* 12/03 - PCONKL - For UCCS Label */
Else
	//AWB
	lsFormat = uf_Replace(lsFormat,"~~bol_nbr,0020~~",left(lstrparms.String_Arg[34],12)) /* 12/03 - PCONKL - For UCCS Label */
End If
		
//Carton no (UCCS Label) - 
If  lstrparms.String_Arg[35] > '' Then
	lsUCCCarton = "0" + lstrparms.String_Arg[35] + Right(String(Long(lstrparms.String_Arg[12]),'000000000'),9) /*Prepend UCCS Info - 0 (futire use) + Warehouse Prefix + Company Prefix) */		
	liCheck = f_calc_uccs_check_Digit(lsUCCCarton) /*calculate the check digit*/
	If liCheck >=0 Then
		lsuccCarton = "00" + lsUccCarton + String(liCheck) /* add 00 at beginning (not part of check digit calculation but included as tag */
	Else
		lsUccCarton = String(Long(lstrparms.String_Arg[12]),'00000000000000000000')
	End If
Else
	lsUccCarton = String(Long(lstrparms.String_Arg[12]),'00000000000000000000')
End If

IF gs_project = "MAQUET" THEN

	lsFormat = uf_Replace(lsFormat,"(00)","")
	lsFormat = uf_Replace(lsFormat,"~~carton_no_BC,0019~~",left(lstrparms.String_Arg[27],30))
	lsFormat = uf_Replace(lsFormat,"~~carton_no_readable,0018~~",left(lstrparms.String_Arg[27],30)) /* 00 already on label as text field but included in barcode*/

	
ELSE
	
	lsFormat = uf_Replace(lsFormat,"~~carton_no_BC,0019~~",lsUCCCarton)
	lsFormat = uf_Replace(lsFormat,"~~carton_no_readable,0018~~",Right(lsUCCCarton,18)) /* 00 already on label as text field but included in barcode*/
	
END IF
	
//Po No
//Jxlim 09/10/2014 Anki use dm.user_field14 instead of cust_ord_no for Ecommerce ID as non unique Anki cust order nbr
lsFormat = uf_Replace(lsFormat,"~~po_nbr,0030~~",lstrparms.String_Arg[36])

//Cust No
lsFormat = uf_Replace(lsFormat,"~~sku_no,0030~~",left(lstrparms.String_Arg[14],30))//Alternate sku

//Weight	
ls_weight = String(lstrparms.Long_Arg[5]) + "/" + String(lstrparms.Long_Arg[6])
lsFormat = uf_Replace(lsFormat,"~~weight,0008~~",ls_weight )
lsFormat = uf_Replace(lsFormat,"~~weight_lbs_no,0030~~",String(lstrparms.Long_Arg[5]))
lsFormat = uf_Replace(lsFormat,"~~weight_kgs_no,0030~~",String(lstrparms.Long_Arg[6]))
lsFormat = uf_Replace(lsFormat,"~~weight,0030~~",String(lstrparms.Long_Arg[5]) + "LBs / " + String(lstrparms.Long_Arg[6]) + "KGs") /* 12/03 - PCONKL - Weight for UCCS */
	

//Invoice NO
lsFormat = uf_Replace(lsFormat,"~~invoice_no,0030~~",Left(lstrparms.String_Arg[17],20))	

//Today's date 
lsFormat = uf_Replace(lsFormat,"~~today,0030~~",string(today(),"mmm dd, yyyy"))
	
//Carrier Name
lsFormat = uf_Replace(lsFormat,"~~carrier_name,0030~~",left(lstrparms.String_Arg[25],30))
	
//Tracking shipper No
lsFormat = uf_Replace(lsFormat,"~~tracker_id,0030~~",left(lstrparms.String_Arg[27],30))
	
//No of copies
ll_no_of_copies = lstrparms.Long_Arg[1]
FOR i= 1 TO ll_no_of_copies
	lsFormat = uf_Replace(lsFormat,"~~tot_off,0030~~",left(lstrparms.String_Arg[28],30))
	PrintSend(llPrintJob, lsformat)	
	ls_temp= lstrparms.String_Arg[28]
NEXT
	
PrintClose(llPrintJob)
	

Return 0

*/



end function

public function integer uf_h2o_ucc_labels (any as_any);//This function will print  H2O UCCS Shipping labels

Str_parms	lStrparms
String		lsFormatUCC_128,	&
			lsCartonBarcode,	&
			lsTemp,				&
			lsPrintText,		&
			lsAddr,ls_weight,ls_temp,	&
			lsUCCCarton,ls_ucc, lsSKU, lsUPC

Long	llPrintJob,	&
		llPos,		&
		llPrintQty,	&
		llCount,	&
		llCartonNo,	&
		llAddrPos,i,j,ll_no_of_copies
		
Integer	liFileNo, liCheck
string ls_label_type	

lStrparms = as_any

//Only read the format from server once...
If isH2OUCCLabelFormat = '' or isnull(isH2OUCCLabelFormat) Then

	//GailM 11/09/2017 SIMSPEVS-896 - HCL h2o Plus - New UCC128/GS1 label for Walgreens
	//09-Mar-2017 :Madhu -PEVS -504 - Kohl's -Label - START 
	If  Pos(upper(lstrparms.String_Arg[12]),'KOHL') > 0 Then
		isH2OUCCLabelFormat = uf_read_label_Format('H2O_Kohl_SSCC_zebra_ship.txt')		
	Elseif lstrparms.String_Arg[30] = '20435' Or  lstrparms.String_Arg[30] = '20339' Or  lstrparms.String_Arg[30] = '20340'   Then 
		// Walgreens will also work for Duane Reade for this label
		isH2OUCCLabelFormat = uf_read_label_Format('H2O_Walgreen_SSCC_zebra_ship.txt')		
	Else
		isH2OUCCLabelFormat = uf_read_label_Format('H2O_SSCC_zebra_ship.txt')
	End If
	//09-Mar-2017 :Madhu -PEVS -504 - Kohl's -Label - END
	
End If
	
lsFormatUCC_128 = isH2OUCCLabelFormat
	
//Open Printer File 
llPrintJob = PrintOpen(lsPrintText)
	
If llPrintJob <0 Then 
	Messagebox('Labels', 'Unable to open Printer file. Labels will not be printed')
	Return -1
End If


//From Address - Roll up addresses if not all present
llAddrPos = 0

If lstrparms.String_Arg[2] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + "~~" //Customer WH Name
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,lsAddr,Left(lstrparms.String_Arg[2],30))
End If
	
If lstrparms.String_Arg[3] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + "~~" //Address1
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,lsAddr,Left(lstrparms.String_Arg[3],30))
End If

If lstrparms.String_Arg[4] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + "~~" //Address2
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,lsAddr,Left(lstrparms.String_Arg[4],30))
	
End If

If lstrparms.String_Arg[5] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + "~~" //Address3
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,lsAddr,Left(lstrparms.String_Arg[5],30))
	
End If

If lstrparms.String_Arg[6] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + "~~" //Address4
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,lsAddr,Left(lstrparms.String_Arg[6],30))
	
End If

If lstrparms.String_Arg[7] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + "~~" //Address5
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,lsAddr,Left(lstrparms.String_Arg[7],30))
	
End If

//Po No and B/L number
lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~po_nbr~~",left(lstrparms.String_Arg[11],30))	
lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~bol_nbr~~",left(lstrparms.String_Arg[10],30))	

//SCAC Code and Market Vendor for Walgreens
lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~scac~~",left(lstrparms.String_Arg[60],30))	
lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~vendor~~", left(lstrparms.String_Arg[61],30))

//To Address - Roll up addresses if not all present
llAddrPos = 0

If lstrparms.String_Arg[12] > ' ' Then
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~" //Warehouse Name
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,lsAddr,Left(lstrparms.String_Arg[12],45))

End If

If lstrparms.String_Arg[13] > ' ' Then
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~" //Address1
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,lsAddr,Left(lstrparms.String_Arg[13],45))

End If

If lstrparms.String_Arg[14] > ' ' Then
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~" //Address2
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,lsAddr,left(lstrparms.String_Arg[14],45))

End If

If lstrparms.String_Arg[15] > ' ' Then
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~" //Address3
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,lsAddr,Left(lstrparms.String_Arg[15],45))

End If

If lstrparms.String_Arg[16] > ' ' Then //Address4
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~"
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,lsAddr,left(lstrparms.String_Arg[16],45))
	
End If

If lstrparms.String_Arg[17] > ' ' Then //Address5
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~"
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,lsAddr,left(lstrparms.String_Arg[17],45))
	
End If

//SKU and UPC only visible for MCX
// 02/16- PCONKL - Added SKU to Ulta
// 05/16 - PCONKL - Added Kohl's

//SKU
If Pos(upper(lstrparms.String_Arg[12]),'MCX') > 0 or Pos(upper(lstrparms.String_Arg[12]),'MARINE CORPS EXCHANGE') > 0 or  lstrparms.String_Arg[30] = '20325' or & 
	Pos(upper(lstrparms.String_Arg[12]),'KOHLS') > 0 or   lstrparms.String_Arg[30] = '20425' or & 
	Pos(upper(lstrparms.String_Arg[12]),'ULTA')  > 0 or   lstrparms.String_Arg[30] = '05062' Then /*Customer name contains MCX or Ulta or KOHLS*/
	
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~sku~~", left(lstrparms.String_Arg[20],20))//Sku
		
Else /* make tag invisible*/
	
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"^FDSKU:^FS","^FD^FS")
	
End If

//UPC - o nly for MCX
If Pos(upper(lstrparms.String_Arg[12]),'MCX') > 0 or Pos(upper(lstrparms.String_Arg[12]),'MARINE CORPS EXCHANGE') > 0 or  lstrparms.String_Arg[30] = '20325' Then /*Customer name contains MCX or Ulta */
	
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~upc~~",left( lstrparms.String_Arg[21],30))//UPC
	
Else /* make tag invisible*/
		lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"^FDUPC:^FS","^FD^FS")
End If

// 02/16 - PCONKL - Added Description for ULTA
If Pos(upper(lstrparms.String_Arg[12]),'ULTA')  > 0 or   lstrparms.String_Arg[30] = '05062' Then /*Customer name contains  Ulta */
	
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~description~~", left(lstrparms.String_Arg[27],40))
		
Else /* make tag invisible*/
	
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"^FDItem Desc:^FS","^FD^FS")
	
End If

//Mark For Name only visible for ULTA 
If Pos(upper(lstrparms.String_Arg[12]),'ULTA')  > 0 or   lstrparms.String_Arg[30] = '05062' Then /*Customer name contains  Ulta */
	
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~mark_for_name~~", left(lstrparms.String_Arg[28],20))
		
Else /* make tag invisible*/
	
	//lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"^FDFor:^FS","^FD^FS") //09-Mar-2017 :Madhu -PEVS -504 - Kohl's -Label commented
	
End If

//Mark For Store barcode only visible for ULTA 
//GailM 11/09/2017 SIMSPEVS-896 - HCL h2o Plus - New UCC128/GS1 label for Walgreens
If Pos(upper(lstrparms.String_Arg[12]),'ULTA')  > 0 or   lstrparms.String_Arg[23] = '05062' or &
	 Pos(upper(lstrparms.String_Arg[12]),'WALGREEN')  > 0 or   lstrparms.String_Arg[23] = '20435' or &
	 lstrparms.String_Arg[30] = '20339' or lstrparms.String_Arg[30] = '20340' Then /*Customer name contains  Ulta & Walgreen (Duane Reade works with Walgreens) */
	
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~mark_for_store_BC~~", left(lstrparms.String_Arg[23],10))
		
Else /* make tag invisible*/
	
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"^FO31,699^BY2,3.0,102^B3N,N,102,N,N^FD~~mark_for_store_BC~~^FS","") /* this will need to be updated if column moves at all*/
	
End If

//Department visible for Stage, Kohls, Bonton, Von Maur
If Pos(upper(lstrparms.String_Arg[12]),'STAGE') > 0 or Pos(upper(lstrparms.String_Arg[12]),'KOHL') > 0 or Pos(upper(lstrparms.String_Arg[12]),'BONTON') > 0 or &
	 Pos(upper(lstrparms.String_Arg[12]),'BON-TON') > 0 or Pos(upper(lstrparms.String_Arg[12]),'MAUR') > 0 or  lstrparms.String_Arg[30] = '20324' or  lstrparms.String_Arg[30] = '20425' &
	 or  lstrparms.String_Arg[30] = '05066' or  lstrparms.String_Arg[30] = '10511' Then
	
		lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~dept~~",left( lstrparms.String_Arg[22],30))//Department
		
Else /*make tag invisible*/
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"^FDDept:^FS","^FD^FS")
End If

//If Mark for not present, blank out Literal. May also change the Literal for certain customers
lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~store~~",left( lstrparms.String_Arg[23],30))//Mark For/Store

If lstrparms.String_Arg[23] = '' or isnull(lstrparms.String_Arg[23]) Then
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"^FDStore:^FS", "^FD^FS")
elseIf (Pos(upper(lstrparms.String_Arg[12]),'MCX') > 0 or Pos(upper(lstrparms.String_Arg[12]),'MARINE CORPS EXCHANGE') > 0 or  lstrparms.String_Arg[30] = '20325') Then
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"^FDStore:^FS", "^FDMark For:^FS") /*store labeled 'Mark For' for MCX*/
End If

//We may need to make Qty visible for certain customers only
lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~qty~~",left( lstrparms.String_Arg[62],30)) /*carton Qty*/

lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~carrier_name~~",left(lstrparms.String_Arg[24],30))//Carrier
lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~pro~~",left( lstrparms.String_Arg[26],30))

//09-Mar-2017 :Madhu -PEVS -504 - Kohl's -Label -START
if(Pos(Upper(lstrparms.String_Arg[12]),'KOHL') > 0) Then

	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~carton_no_readable~~", left(Lstrparms.String_arg[48],20))
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,">=carton_no_BC>=", "00"+left(Lstrparms.String_arg[48],20)) //Barcode should read 20 digits
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~ship_to_zip~~", left(Lstrparms.String_arg[33],20))
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,">=ship_to_zip_BC>=", "420"+left(Lstrparms.String_arg[33],5))
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,">;>=ship_to_zip>=", left(Lstrparms.String_arg[33],20)) 
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,">=mark_for_store_BC>=", "91"+"0"+left(lstrparms.String_Arg[23],10))
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~store~~",left( lstrparms.String_Arg[23],30))//Mark For/Store
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128, "~~supp_code~~", left(lstrparms.String_Arg[30],20)) //Supplier
	
		if upper(lstrparms.String_Arg[45]) ='BULKLABEL' then
				lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"^FDStyle:^FS","^FD^FS") //make Invisible
				lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"^FDColor:^FS","^FD^FS") //make Invisible
				lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"^FDSize:^FS","^FD^FS") //make Invisible
		else
				lsFormatUCC_128 = uf_Replace(lsFormatUCC_128, "~~style~~", left(lstrparms.String_Arg[40],20)) //Style
				lsFormatUCC_128 = uf_Replace(lsFormatUCC_128, "~~color~~", left(lstrparms.String_Arg[41],20)) //Color
				lsFormatUCC_128 = uf_Replace(lsFormatUCC_128, "~~size~~", left(lstrparms.String_Arg[42],20)) //Size

		end if
		
elseIf	(Pos(Upper(lstrparms.String_Arg[12]),'WALGREENS' ) > 0)  or   lstrparms.String_Arg[23] = '20435' or &
	 lstrparms.String_Arg[30] = '20339' or lstrparms.String_Arg[30] = '20340' Then					// Duane Reade works with Walgreens
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~carton_no_readable~~", left(Lstrparms.String_arg[48],20))
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,">=carton_no_BC>=", "00"+left(Lstrparms.String_arg[48],20)) //Barcode should read 20 digits
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~ship_to_zip~~", left(Lstrparms.String_arg[33],20))
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,">=ship_to_zip_BC>=", "420"+left(Lstrparms.String_arg[33],5))
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,">;>=ship_to_zip>=", left(Lstrparms.String_arg[33],20)) 
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,">=mark_for_store_BC>=", "91"+"0"+left(lstrparms.String_Arg[23],10))
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~store~~",left( lstrparms.String_Arg[23],30))//Mark For/Store
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128, "~~supp_code~~", left(lstrparms.String_Arg[30],20)) //Supplier

else
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~carton_no_readable~~", left(Lstrparms.String_arg[48],20))
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,">;>=carton_no_BC>=", left(Lstrparms.String_arg[48],20))
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~ship_to_zip~~", left(Lstrparms.String_arg[33],20))
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~ship_to_zip_BC~~", left(Lstrparms.String_arg[33],5)) /*only want to BC 5 digits*/
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~store~~",left( lstrparms.String_Arg[23],30))//Mark For/Store
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"^FDFor:^FS","^FD^FS")
End If

//09-Mar-2017 :Madhu -PEVS -504 - Kohl's -Label -END

//lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~carton_tot~~",left( lstrparms.String_Arg[28],30))

lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~tot_off~~",left( lstrparms.String_Arg[34],30)) /* x of y */


PrintSend(llPrintJob, lsFormatUCC_128)	

PrintClose(llPrintJob)

Return 0



end function

public function integer uf_h2o_kohls_master (any as_any);
//Print Kohl's Master Carton and list of Stores label

Datastore	ldsStores
String			sql_syntax, Errors, lsStoreLabelFormat, lsFormatUCC_128, lsCurrentLabel, lsDONO, lsConsolNo, lsStoreTag, lsAddr
Long			llStoreCOunt, llStorePos, llPrintJob, llLabelPos, llAddrPos
Str_parms	lStrparms


lStrparms = as_any

lsDONO = lstrParms.String_Arg[18]
lsConsolNo = lstrParms.String_Arg[19]

//Retrieve the unique store numbers (detail UF 1) for this order and any other order on the shipment (Consolidation_No)
ldsStores = Create Datastore
sql_syntax = "SELECT Distinct User_Field1 from delivery_Detail " 
sql_syntax += " Where  "

If lsConSolNo > '' Then
	sql_syntax += "DO_NO in (Select do_no from DElivery_Master where project_id = 'H2O' and Consolidation_No = '" + lsConsolNo + "')"
Else
	sql_syntax += "DO_NO = '" + lsDONO + "'"
End If

sql_syntax += " And User_Field1> ''"
sql_syntax += " Order By User_Field1"

ldsStores.Create(SQLCA.SyntaxFromSQL(sql_syntax,"", ERRORS))
IF Len(ERRORS) > 0 THEN
  
  Messagebox('Labels', 'Unable to retrieve list of stores. Master Store Label will not be printed~r~r' + Errors)
  RETURN - 1
	
END IF

ldsStores.SetTransObject(SQLCA)
llStoreCOunt = ldsStores.Retrieve()


//Open Printer File 
llPrintJob = PrintOpen()
	
If llPrintJob <0 Then 
	Messagebox('Labels', 'Unable to open Printer file. Labels will not be printed')
	Return -1
End If

//Print the Master UCC Label
lsFormatUCC_128 = uf_read_label_Format('H2O_Kohl_Master_zebra_ship.txt') 

//From Address - Roll up addresses if not all present
llAddrPos = 0

If lstrparms.String_Arg[2] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + "~~" //Customer  Name
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,lsAddr,Left(lstrparms.String_Arg[2],30))
End If
	
If lstrparms.String_Arg[3] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + "~~" //Address1
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,lsAddr,Left(lstrparms.String_Arg[3],30))
End If

If lstrparms.String_Arg[4] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + "~~" //Address2
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,lsAddr,Left(lstrparms.String_Arg[4],30))
	
End If

If lstrparms.String_Arg[5] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + "~~" //Address3
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,lsAddr,Left(lstrparms.String_Arg[5],30))
	
End If

If lstrparms.String_Arg[6] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + "~~" //Address4
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,lsAddr,Left(lstrparms.String_Arg[6],30))
	
End If

If lstrparms.String_Arg[7] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + "~~" //Address5
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,lsAddr,Left(lstrparms.String_Arg[7],30))
	
End If

//Po No and B/L number
lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~po_nbr~~",left(lstrparms.String_Arg[11],30))	
lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~bol_nbr~~",left(lstrparms.String_Arg[10],30))	

//To Address - Roll up addresses if not all present
llAddrPos = 0

If lstrparms.String_Arg[12] > ' ' Then
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~" //Customer Name
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,lsAddr,Left(lstrparms.String_Arg[12],45))

End If

If lstrparms.String_Arg[13] > ' ' Then
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~" //Address1
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,lsAddr,Left(lstrparms.String_Arg[13],45))

End If

If lstrparms.String_Arg[14] > ' ' Then
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~" //Address2
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,lsAddr,left(lstrparms.String_Arg[14],45))

End If

If lstrparms.String_Arg[15] > ' ' Then
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~" //Address3
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,lsAddr,Left(lstrparms.String_Arg[15],45))

End If

If lstrparms.String_Arg[16] > ' ' Then //Address4
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~"
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,lsAddr,left(lstrparms.String_Arg[16],45))
	
End If

If lstrparms.String_Arg[17] > ' ' Then //Address5
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~"
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,lsAddr,left(lstrparms.String_Arg[17],45))
	
End If

//Department 
lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~dept~~",left( lstrparms.String_Arg[22],30))//Department
		
//TODO - Need total order Qty
lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~qty~~",left( lstrparms.String_Arg[62],30)) /*carton Qty*/

lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~carrier_name~~",left(lstrparms.String_Arg[24],30))//Carrier
lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~pro~~",left( lstrparms.String_Arg[26],30))
lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~ship_to_zip~~", left(Lstrparms.String_arg[33],20))
lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~ship_to_zip_BC~~", left(Lstrparms.String_arg[33],20))
lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,">;>=ship_to_zip>=", left(Lstrparms.String_arg[33],20)) 

PrintSend(llPrintJob, lsFormatUCC_128)

//Print one or more Store Listing labels

If llStoreCount < 1 Then
	Messagebox('Labels', 'No Mark for Stores retrieved. Store Label will not be printed' )
 	RETURN 0
End If

lsStoreLabelFormat = uf_read_label_Format('H2O_Kohls_Store_List.txt') 

//11 stores per label 
llLabelPos = 0
lsCurrentLabel = lsStoreLabelFormat

For llStorePos = 1 to llStoreCount
	
	llLabelPos ++
	
	If llLabelPos > 11 Then /* new label needed - print current/Full one*/
	
		PrintSend(llPrintJob, lsCurrentLabel)	
		lsCurrentLabel = lsStoreLabelFormat
		llLabelPos = 1
		
	End If
	
	lsStoreTag = "~~store_" + String(llLabelPos) + "~~"
	lsCurrentLabel = uf_Replace(lsCurrentLabel,lsStoreTag,ldsStores.GetITemString(llStorePos,"User_Field1"))  /*Store*/
	
Next

PrintSend(llPrintJob, lsCurrentLabel)	/*Last/Only*/

PrintClose(llPrintJob)

Return 0
end function

public function integer uf_kendo_ship (any as_any);//This function will print  kendo Shipping labels

Str_parms	lStrparms
String		lsFormatUCC_128,	&
			lsCartonBarcode,	&
			lsTemp,				&
			lsPrintText,		&
			lsAddr,ls_weight,ls_temp,	&
			lsUCCCarton,ls_ucc, lsSKU, lsUPC

Long	llPrintJob,	&
		llPos,		&
		llPrintQty,	&
		llCount,	&
		llCartonNo,	&
		llAddrPos,i,j,ll_no_of_copies
		
Integer	liFileNo, liCheck
string ls_label_type	

lStrparms = as_any

//Only read the format from server once...
If iskendoShipLabelFormat = '' or isnull(iskendoShipLabelFormat) Then
	iskendoShipLabelFormat = uf_read_label_Format('kendo_zebra_ship.txt') 
End If
	
lsFormatUCC_128 = iskendoShipLabelFormat
	
//Open Printer File 
llPrintJob = PrintOpen(lsPrintText)
	
If llPrintJob <0 Then 
	Messagebox('Labels', 'Unable to open Printer file. Labels will not be printed')
	Return -1
End If


//From Address - Roll up addresses if not all present
llAddrPos = 0

If lstrparms.String_Arg[2] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + "~~" //Customer WH Name
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,lsAddr,Left(lstrparms.String_Arg[2],30))
End If
	
If lstrparms.String_Arg[3] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + "~~" //Address1
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,lsAddr,Left(lstrparms.String_Arg[3],30))
End If

If lstrparms.String_Arg[4] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + "~~" //Address2
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,lsAddr,Left(lstrparms.String_Arg[4],30))
	
End If

If lstrparms.String_Arg[5] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + "~~" //Address3
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,lsAddr,Left(lstrparms.String_Arg[5],30))
	
End If

If lstrparms.String_Arg[6] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + "~~" //Address4
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,lsAddr,Left(lstrparms.String_Arg[6],30))
	
End If

If lstrparms.String_Arg[7] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + "~~" //Address5
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,lsAddr,Left(lstrparms.String_Arg[7],30))
	
End If

//Po No  number
lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~po_nbr~~",left(lstrparms.String_Arg[11],30))
lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~po_nbr_bc~~",left(lstrparms.String_Arg[11],30))

//SO Number
lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~sales_order~~",left(lstrparms.String_Arg[23],30))

//To Address - Roll up addresses if not all present
llAddrPos = 0

If lstrparms.String_Arg[12] > ' ' Then
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~" //Warehouse Name
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,lsAddr,Left(lstrparms.String_Arg[12],45))

End If

If lstrparms.String_Arg[13] > ' ' Then
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~" //Address1
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,lsAddr,Left(lstrparms.String_Arg[13],45))

End If

If lstrparms.String_Arg[14] > ' ' Then
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~" //Address2
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,lsAddr,left(lstrparms.String_Arg[14],45))

End If

If lstrparms.String_Arg[15] > ' ' Then
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~" //Address3
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,lsAddr,Left(lstrparms.String_Arg[15],45))

End If

If lstrparms.String_Arg[16] > ' ' Then //Address4
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~"
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,lsAddr,left(lstrparms.String_Arg[16],45))
	
End If

If lstrparms.String_Arg[17] > ' ' Then //Address5
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~"
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,lsAddr,left(lstrparms.String_Arg[17],45))
	
End If


//GailM 2/1/2019 S28941 F13496 - I2134 - KDO - Kendo - MIXED Term on Labels with Multiple SKUs
//SKU
lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~sku~~", left(lstrparms.String_Arg[20],20))//Sku
If lstrparms.String_Arg[20] = "MIXED" Then
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"^BY2,2.5,102^B3N,N,102,N,N^FD~~sku_bc~~","^A0N,28,14^FD~~sku_bc~~")
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~sku_bc~~", "")//Barcoded Sku
Else
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~sku_bc~~", left(lstrparms.String_Arg[20],20))//Barcoded Sku
End If

//UPC 
If Pos(lstrparms.String_Arg[21], "MIXED") > 0 Then		//Can have leading blanks for proper placement on label
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"^BY3,2.0,100^BUN,100,Y,N","^A0N,34,41") 	//Do not print BarCode
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~upc~~",lstrparms.String_Arg[21])//UPC
Else
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~upc~~",left( lstrparms.String_Arg[21],30))//UPC
End If

// Description - may need to be split into multiple  lines
If lstrparms.String_Arg[27] = "MIXED" Then
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~description~~", "MIXED")
Else
	If Len(lstrparms.String_Arg[27]) > 25  Then
		lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~description~~", left(lstrparms.String_Arg[27],25))
		lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~description_2~~", Mid(lstrparms.String_Arg[27],26,25))
	Else
		lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~description~~", lstrparms.String_Arg[27])
	End If
End If

//Qty 
lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~qty~~",left( lstrparms.String_Arg[62],30)) /*carton Qty*/

// carton x of y
lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~tot_off~~",left( lstrparms.String_Arg[34],30)) /* x of y */

//Lot_no (Batch Code)		S32180 
If lstrparms.String_Arg[27] = "MIXED" Then
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~lot_no~~", "MIXED")
	//lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~lot_no_bc~~","    ")
Else
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~lot_no~~",left( lstrparms.String_Arg[28],30))
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~lot_no_bc~~",left( lstrparms.String_Arg[28],30))
End If

//Manufacture Date
If lstrparms.String_Arg[28] = "MIXED" Then
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~manufacture_date~~", "MIXED")	
Else
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~manufacture_date~~",left( lstrparms.String_Arg[18],30))
End If

//DE10122 GailM 4/17/2019 Remove EXP Date from both
	//Exp Date
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~exp_dt~~","     ")
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"EXP Date", "     ")   //Remove Label

//DE9589 GailM 3/27/2019 Print number of copies
For i = 1 to lstrparms.Long_Arg[1]
	PrintSend(llPrintJob, lsFormatUCC_128)	
Next

PrintClose(llPrintJob)

Return 0



end function

public function integer uf_garmin_ucc_labels (any as_any);//This function will print  GARMIN UCCS Shipping labels

Str_parms	lStrparms
String		lsFormatUCC_128,	&
			lsCartonBarcode,	&
			lsTemp,				&
			lsPrintText,		&
			lsAddr,ls_weight,ls_temp,	&
			lsUCCCarton,ls_ucc, lsSKU, lsUPC

Long	llPrintJob,	&
		llPos,		&
		llPrintQty,	&
		llCount,	&
		llCartonNo,	&
		llAddrPos,i,j,ll_no_of_copies
		
Integer	liFileNo, liCheck
string ls_label_type	

lStrparms = as_any

//Only read the format from server once...
If isGarminUCCLabelFormat = '' or isnull(isGarminUCCLabelFormat) Then
	isGarminUCCLabelFormat = uf_read_label_Format('Garmin_SSCC_zebra_ship.txt') 
End If
	
lsFormatUCC_128 = isGarminUCCLabelFormat
	
//Open Printer File 
llPrintJob = PrintOpen(lsPrintText)
	
If llPrintJob <0 Then 
	Messagebox('Labels', 'Unable to open Printer file. Labels will not be printed')
	Return -1
End If


//From Address - Roll up addresses if not all present
llAddrPos = 0

If lstrparms.String_Arg[2] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + "~~" //Customer WH Name
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,lsAddr,Left(lstrparms.String_Arg[2],30))
End If
	
If lstrparms.String_Arg[3] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + "~~" //Address1
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,lsAddr,Left(lstrparms.String_Arg[3],30))
End If

If lstrparms.String_Arg[4] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + "~~" //Address2
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,lsAddr,Left(lstrparms.String_Arg[4],30))
	
End If

If lstrparms.String_Arg[5] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + "~~" //Address3
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,lsAddr,Left(lstrparms.String_Arg[5],30))
	
End If

If lstrparms.String_Arg[6] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + "~~" //Address4
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,lsAddr,Left(lstrparms.String_Arg[6],30))
	
End If

If lstrparms.String_Arg[7] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + "~~" //Address5
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,lsAddr,Left(lstrparms.String_Arg[7],30))
	
End If

//Po No and B/L number
//lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~po_nbr~~",left(lstrparms.String_Arg[11],30))	
lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~po_nbr~~",left(lstrparms.String_Arg[19],30))  //PO Number is the Consol Number
//lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~bol_nbr~~",left(lstrparms.String_Arg[10],30))	

//To Address - Roll up addresses if not all present
llAddrPos = 0

If lstrparms.String_Arg[12] > ' ' Then
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~" //Warehouse Name
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,lsAddr,Left(lstrparms.String_Arg[12],45))

End If

If lstrparms.String_Arg[13] > ' ' Then
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~" //Address1
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,lsAddr,Left(lstrparms.String_Arg[13],45))

End If

If lstrparms.String_Arg[14] > ' ' Then
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~" //Address2
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,lsAddr,left(lstrparms.String_Arg[14],45))

End If

If lstrparms.String_Arg[15] > ' ' Then
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~" //Address3
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,lsAddr,Left(lstrparms.String_Arg[15],45))

End If

If lstrparms.String_Arg[16] > ' ' Then //Address4
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~"
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,lsAddr,left(lstrparms.String_Arg[16],45))
	
End If

If lstrparms.String_Arg[17] > ' ' Then //Address5
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~"
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,lsAddr,left(lstrparms.String_Arg[17],45))
	
End If


//SKU
lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~sku~~", left(lstrparms.String_Arg[20],20))//Sku
lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~upc~~",left( lstrparms.String_Arg[21],30))//UPC
lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~description~~", left(lstrparms.String_Arg[27],40))
lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~mark_for_name~~", left(lstrparms.String_Arg[28],20))
lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~store~~",left( lstrparms.String_Arg[23],30))//Mark For/Store

//We may need to make Qty visible for certain customers only
lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~qty~~",left( lstrparms.String_Arg[62],30)) /*carton Qty*/

lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~carrier_name~~",left(lstrparms.String_Arg[24],30))//Carrier
lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~pro~~",left( lstrparms.String_Arg[26],30))
lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~carton_no_readable~~", left(Lstrparms.String_arg[48],20))
lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,">;>=carton_no_BC>=", left(Lstrparms.String_arg[48],20)) 
lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~ship_to_zip~~", left(Lstrparms.String_arg[33],20))
lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~ship_to_zip_BC~~", left(Lstrparms.String_arg[33],5)) /*only want to BC 5 digits*/
lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,">;>=ship_to_zip>=", left(Lstrparms.String_arg[33],20)) 



//lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~carton_tot~~",left( lstrparms.String_Arg[28],30))

lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~tot_off~~",left( lstrparms.String_Arg[34],30)) /* x of y */


PrintSend(llPrintJob, lsFormatUCC_128)	

PrintClose(llPrintJob)

Return 0



end function

public function integer uf_pandora_shipping_label (any as_any);//This function will print Pandora Shipping labels

Str_parms	lStrparms
String		lsLabelFormat,	&
			lsCartonBarcode,	&
			lsTemp,				&
			lsPrintText,		&
			lsAddr,ls_weight,ls_temp,	&
			lsUCCCarton,ls_ucc, lsSKU, lsUPC

Long	llPrintJob,	&
		llPos,		&
		llPrintQty,	&
		llCount,	&
		llCartonNo,	&
		llAddrPos,i,j,ll_no_of_copies
		
Integer	liFileNo, liCheck
string ls_label_type	

lStrparms = as_any
//Only read the format from server once...
If lsLabelFormat = '' or isnull(lsLabelFormat) Then
//IF the Item is flagged as Dangerous print the label with the Dangerouse goods logo
	If lstrparms.String_Arg[48] = 'Y' Then	
		lsLabelFormat = uf_read_label_Format('pandora_shipping_label.txt') 
	Else
		lsLabelFormat = uf_read_label_Format('pandora_shipping_label_no_dg_logo.txt') 
	End If
End If
	
	
//Open Printer File 
llPrintJob = PrintOpen(lsPrintText)
	
If llPrintJob <0 Then 
	Messagebox('Labels', 'Unable to open Printer file. Labels will not be printed')
	Return -1
End If


//From Address - Roll up addresses if not all present
llAddrPos = 0

If lstrparms.String_Arg[2] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + "~~" //Customer WH Name
	lsLabelFormat = uf_Replace(lsLabelFormat,lsAddr,Left(lstrparms.String_Arg[2],30))
End If
	
If lstrparms.String_Arg[3] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + "~~" //Address1
	lsLabelFormat = uf_Replace(lsLabelFormat,lsAddr,Left(lstrparms.String_Arg[3],30))
End If

If lstrparms.String_Arg[4] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + "~~" //Address2
	lsLabelFormat = uf_Replace(lsLabelFormat,lsAddr,Left(lstrparms.String_Arg[4],30))
	
End If

If lstrparms.String_Arg[5] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + "~~" //Address3
	lsLabelFormat = uf_Replace(lsLabelFormat,lsAddr,Left(lstrparms.String_Arg[5],30))
	
End If

If lstrparms.String_Arg[6] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + "~~" //Address4
	lsLabelFormat = uf_Replace(lsLabelFormat,lsAddr,Left(lstrparms.String_Arg[6],30))
	
End If

If lstrparms.String_Arg[7] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + "~~" //Address5
	lsLabelFormat = uf_Replace(lsLabelFormat,lsAddr,Left(lstrparms.String_Arg[7],30))
	
End If

//Po No and B/L number
//lsLabelFormat = uf_Replace(lsLabelFormat,"~~po_nbr~~",left(lstrparms.String_Arg[19],30))  //PO Number is the Consol Number

//To Address - Roll up addresses if not all present
llAddrPos = 0

If lstrparms.String_Arg[12] > ' ' Then
	llAddrPos ++
	lsAddr = "~~ship_addr" + String(llAddrPos) + "~~" //Warehouse Name
	lsLabelFormat = uf_Replace(lsLabelFormat,lsAddr,Left(lstrparms.String_Arg[12],45))

End If

If lstrparms.String_Arg[13] > ' ' Then
	llAddrPos ++
	lsAddr = "~~ship_addr" + String(llAddrPos) + "~~" //Address1
	lsLabelFormat = uf_Replace(lsLabelFormat,lsAddr,Left(lstrparms.String_Arg[13],45))

End If

If lstrparms.String_Arg[14] > ' ' Then
	llAddrPos ++
	lsAddr = "~~ship_addr" + String(llAddrPos) + "~~" //Address2
	lsLabelFormat = uf_Replace(lsLabelFormat,lsAddr,left(lstrparms.String_Arg[14],45))

End If

If lstrparms.String_Arg[15] > ' ' Then
	llAddrPos ++
	lsAddr = "~~ship_addr" + String(llAddrPos) + "~~" //Address3
	lsLabelFormat = uf_Replace(lsLabelFormat,lsAddr,Left(lstrparms.String_Arg[15],45))

End If

If lstrparms.String_Arg[16] > ' ' Then //Address4
	llAddrPos ++
	lsAddr = "~~ship_addr" + String(llAddrPos) + "~~"
	lsLabelFormat = uf_Replace(lsLabelFormat,lsAddr,left(lstrparms.String_Arg[16],45))
	
End If

If lstrparms.String_Arg[17] > ' ' Then //Address5
	llAddrPos ++
	lsAddr = "~~ship_addr" + String(llAddrPos) + "~~"
	lsLabelFormat = uf_Replace(lsLabelFormat,lsAddr,left(lstrparms.String_Arg[17],45))
	
End If


lsLabelFormat = uf_Replace(lsLabelFormat,">=alt_sku>=", left(Lstrparms.String_arg[20],20))//AltSku Bar Code
lsLabelFormat = uf_Replace(lsLabelFormat,"~~alt_sku~~",left( lstrparms.String_Arg[20],30))//AltSku
lsLabelFormat = uf_Replace(lsLabelFormat,"~~sku_desc~~", left(lstrparms.String_Arg[44],40))//Description
lsLabelFormat = uf_Replace(lsLabelFormat,"~~ord_type~~", left(lstrparms.String_Arg[65],20))//Shipment type
//lsLabelFormat = uf_Replace(lsLabelFormat,">;>=oid>=", left(Lstrparms.String_arg[23],20)) //Invoice_no Bar Code
lsLabelFormat = uf_Replace(lsLabelFormat,">=oid>=", left(Lstrparms.String_arg[23],20)) //Invoice_no Bar Code
lsLabelFormat = uf_Replace(lsLabelFormat,"~~oid~~",left( lstrparms.String_Arg[23],30))//Invoice_no
lsLabelFormat = uf_Replace(lsLabelFormat,">=dt_expire>=", left(Lstrparms.String_arg[47],20)) //Expiry Bar Code
lsLabelFormat = uf_Replace(lsLabelFormat,"~~dt_expire~~",left( lstrparms.String_Arg[47],30))//Expiry
lsLabelFormat = uf_Replace(lsLabelFormat,">=do_no>=", left(Lstrparms.String_arg[40],20)) //Do_No Bar Code
lsLabelFormat = uf_Replace(lsLabelFormat,"~~do_no~~",left( lstrparms.String_Arg[40],30))//Do_No
lsLabelFormat = uf_Replace(lsLabelFormat,"~~dt_print~~",left( lstrparms.String_Arg[50],30))//Date Printed
lsLabelFormat = uf_Replace(lsLabelFormat,"~~box_x~~",left( lstrparms.String_Arg[51],30)) /* x of y */
lsLabelFormat = uf_Replace(lsLabelFormat,"~~box_of_y~~",left( lstrparms.String_Arg[52],30)) /* x of y */
lsLabelFormat = uf_Replace(lsLabelFormat,">=ord_lno>=", left(Lstrparms.String_arg[41],20)) //Ord_Line_No Bar Code
lsLabelFormat = uf_Replace(lsLabelFormat,"~~ord_lno~~",left( lstrparms.String_Arg[41],30))//Ord_line_No
lsLabelFormat = uf_Replace(lsLabelFormat,"~~route_cmt1~~",left( lstrparms.String_Arg[53],30))//Serialized "Y" or "N"
lsLabelFormat = uf_Replace(lsLabelFormat,"~~cont~~", '000000000000000000' )//Container
lsLabelFormat = uf_Replace(lsLabelFormat,">=cont>=", '000000000000000000' )//Container
lsLabelFormat = uf_Replace(lsLabelFormat,">=vendor_order_nbr>=", left(Lstrparms.String_arg[45],20)) //vendor_order_nbr Bar Code
lsLabelFormat = uf_Replace(lsLabelFormat,"~~vendor_order_nbr~~",left( lstrparms.String_Arg[45],20))//vendor_order_nbr


//Do following fields twice to format the pkg id
lsLabelFormat = uf_Replace(lsLabelFormat,">=sku>=", left(Lstrparms.String_arg[42],20)) //SKU Bar Code
lsLabelFormat = uf_Replace(lsLabelFormat,"~~sku~~", left(lstrparms.String_Arg[42],20))//Sku
lsLabelFormat = uf_Replace(lsLabelFormat,">=uc3>=", left(Lstrparms.String_arg[43],20)) //COO Bar Code
lsLabelFormat = uf_Replace(lsLabelFormat,"~~uc3~~",left( lstrparms.String_Arg[43],30))//COO
lsLabelFormat = uf_Replace(lsLabelFormat,"~~qty~~",left( lstrparms.String_Arg[25],30)) /*carton Qty*/
lsLabelFormat = uf_Replace(lsLabelFormat,">=qty>=", left(Lstrparms.String_arg[25],20)) //Carton Quantity

lsLabelFormat = uf_Replace(lsLabelFormat,">=sku>=", left(Lstrparms.String_arg[42],20)) //SKU Bar Code
lsLabelFormat = uf_Replace(lsLabelFormat,"~~sku~~", left(lstrparms.String_Arg[42],20))//Sku
lsLabelFormat = uf_Replace(lsLabelFormat,">=uc3>=", left(Lstrparms.String_arg[43],20)) //COO Bar Code
lsLabelFormat = uf_Replace(lsLabelFormat,"~~uc3~~",left( lstrparms.String_Arg[43],30))//COO
lsLabelFormat = uf_Replace(lsLabelFormat,"~~qty~~",left( lstrparms.String_Arg[25],30)) /*carton Qty*/
lsLabelFormat = uf_Replace(lsLabelFormat,">=qty>=", left(Lstrparms.String_arg[25],20)) //Carton Quantity

//lsLabelFormat = uf_Replace(lsLabelFormat,"~~carrier_name~~",left(lstrparms.String_Arg[24],30))//Carrier
//lsLabelFormat = uf_Replace(lsLabelFormat,"~~pro~~",left( lstrparms.String_Arg[26],30))
//lsLabelFormat = uf_Replace(lsLabelFormat,"~~carton_no_readable~~", left(Lstrparms.String_arg[48],20))
//lsLabelFormat = uf_Replace(lsLabelFormat,">;>=carton_no_BC>=", left(Lstrparms.String_arg[48],20)) 
//lsLabelFormat = uf_Replace(lsLabelFormat,"~~ship_to_zip~~", left(Lstrparms.String_arg[33],20))
//lsLabelFormat = uf_Replace(lsLabelFormat,"~~ship_to_zip_BC~~", left(Lstrparms.String_arg[33],5)) /*only want to BC 5 digits*/
//lsLabelFormat = uf_Replace(lsLabelFormat,">;>=ship_to_zip>=", left(Lstrparms.String_arg[33],20)) 

//lsLabelFormat = uf_Replace(lsLabelFormat,"~~carton_tot~~",left( lstrparms.String_Arg[28],30))

//lsLabelFormat = uf_Replace(lsLabelFormat,"~~tot_off~~",left( lstrparms.String_Arg[34],30)) /* x of y */


PrintSend(llPrintJob, lsLabelFormat)	

PrintClose(llPrintJob)

Return 0



end function

public function integer uf_pandora_generic_shipping_label (any as_array);
//This function will print  Generic UCCS Shipping label

Str_parms	lStrparms
String	lsFormat,	&
			lsCartonBarcode,	&
			lsTemp,				&
			lsPrintText,		&
			lsAddr,ls_weight,ls_temp,	&
			lsUCCCarton

Long	llPrintJob,	&
		llPos,		&
		llPrintQty,	&
		llPrintPos,	&
		llCartonNo,	&
		llAddrPos,i,j,ll_no_of_copies
		
Integer	liFileNo, liCheck


lstrparms = as_array

lsFormat = uf_read_label_Format('Pandora_generic_shipping_label.txt') 
		
	
lsPrintText = 'UCCS Ship - Zebra'


//Open Printer File 
llPrintJob = PrintOpen(lsPrintText)
	
If llPrintJob <0 Then 
	Messagebox('Labels', 'Unable to open Printer file. Labels will not be printed')
	Return -1
End If

//We are looping once for each Qty of label being printed - The carton number is changing so we need to bump after each one.
//Replace placeholders in Format with Field Values

//From Address - Roll up addresses if not all present
	
llAddrPos = 0

If lstrparms.String_Arg[2] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + "~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[2],30))
End If

If lstrparms.String_Arg[3] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + "~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[3],30))
End If

If lstrparms.String_Arg[4] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + "~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[4],30))
End If

If lstrparms.String_Arg[5] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + "~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[5],30))
End If
	
If lstrparms.String_Arg[31] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + "~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[31],45))
End If
	
If lstrparms.String_Arg[6] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + "~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[6],30))
End If

If lstrparms.String_Arg[29] > ' ' Then 
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + "~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[29],45))
End If

//To Address - Roll up addresses if not all present

llAddrPos = 0

If lstrparms.String_Arg[7] > ' ' Then
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~" //Customer Name
	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[7],45))
End If

If lstrparms.String_Arg[8] > ' ' Then
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~" //Address1
	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[8],45))
End If

If lstrparms.String_Arg[9] > ' ' Then
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~" //Address2
	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[9],45))
End If

If lstrparms.String_Arg[10] > ' ' Then
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~" //Address3
	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[10],45))
End If

If lstrparms.String_Arg[32] > ' ' Then //Address4
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[32],45))
End If

If lstrparms.String_Arg[11] > ' ' Then //City,state,zip
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[11],45))
End If

If lstrparms.String_Arg[30] > ' ' Then //To Country
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[30],45))
End If

//Ship To Post Code
lsFormat = uf_Replace(lsFormat,"~~ship2postzip~~",left(lstrparms.String_Arg[33],12)) /* 12/03 - PCONKL - For UCCS Label */
	
//Ship To Post Code (BARCODE)	
lsFormat = uf_Replace(lsFormat,"~~ship2postbarcode~~",left(lstrparms.String_Arg[33],8)) /* 12/03 - PCONKL - For UCCS Label */
	
//AWB
lsFormat = uf_Replace(lsFormat,"~~awb_bol_nbr~~",left(lstrparms.String_Arg[34],12)) /* 12/03 - PCONKL - For UCCS Label */
		
//Carton no (UCCS Label) - 
If  lstrparms.String_Arg[35] > '' Then
	lsUCCCarton = "0" + lstrparms.String_Arg[35] + Right(String(Long(lstrparms.String_Arg[12]),'000000000'),9) /*Prepend UCCS Info - 0 (futire use) + Warehouse Prefix + Company Prefix) */		
	liCheck = f_calc_uccs_check_Digit(lsUCCCarton) /*calculate the check digit*/
	If liCheck >=0 Then
		lsuccCarton = "00" + lsUccCarton + String(liCheck) /* add 00 at beginning (not part of check digit calculation but included as tag */
	Else
		lsUccCarton = String(Long(lstrparms.String_Arg[12]),'00000000000000000000')
	End If
Else
	lsUccCarton = String(Long(lstrparms.String_Arg[12]),'00000000000000000000')
End If
lsFormat = uf_Replace(lsFormat,"~~carton_nbr_barcode~~",lsUCCCarton)
lsFormat = uf_Replace(lsFormat,"~~carton_nbr~~",Right(lsUCCCarton,18)) /* 00 already on label as text field but included in barcode*/
	
//Customer Order Nbr
lsFormat = uf_Replace(lsFormat,"~~Cust_order_nbr~~",left(lstrparms.String_Arg[13],30))

//Sku
lsFormat = uf_Replace(lsFormat,"~~sku_no~~",left(lstrparms.String_Arg[14],30))//Alternate sku

//Weight	
ls_weight = String(lstrparms.Long_Arg[5]) + "/" + String(lstrparms.Long_Arg[6])
lsFormat = uf_Replace(lsFormat,"~~Weight~~",ls_weight )
lsFormat = uf_Replace(lsFormat,"~~Weight_lbs_no~~",String(lstrparms.Long_Arg[5]))
lsFormat = uf_Replace(lsFormat,"~~Weight_kgs_no~~",String(lstrparms.Long_Arg[6]))
lsFormat = uf_Replace(lsFormat,"~~Weight~~",String(lstrparms.Long_Arg[5]) + "LBs / " + String(lstrparms.Long_Arg[6]) + "KGs") /* 12/03 - PCONKL - Weight for UCCS */
	

//Invoice NO
lsFormat = uf_Replace(lsFormat,"~~sales_order_nbr~~",Left(lstrparms.String_Arg[17],20))	

//Vendor Order Nbr
lsFormat = uf_Replace(lsFormat,"~~Client_Cust_Po_Nbr~~",Left(lstrparms.String_Arg[45],20))	

//Do_No
lsFormat = uf_Replace(lsFormat,"~~Do_No~~",left( lstrparms.String_Arg[21],30))

//Today's date 
lsFormat = uf_Replace(lsFormat,"~~Ship_Date~~",string(today(),"mmm dd, yyyy"))
	
//Carrier Name
lsFormat = uf_Replace(lsFormat,"~~Carrier~~",left(lstrparms.String_Arg[25],30))
	
//Tracking shipper No
lsFormat = uf_Replace(lsFormat,"~~tracker_id~~",left(lstrparms.String_Arg[27],30))

//19-AUG-2018 :Madhu S22720 - TMS Load Plan Details
lsFormat = uf_Replace(lsFormat,"~~load_id~~", lstrparms.String_Arg[37])
lsFormat = uf_Replace(lsFormat,"~~stop_id~~", String(lstrparms.Long_Arg[7]))
lsFormat = uf_Replace(lsFormat,"~~load_sequence~~", String(lstrparms.Long_Arg[8]))
	
//No of copies
ll_no_of_copies = lstrparms.Long_Arg[1]
FOR i= 1 TO ll_no_of_copies
	lsFormat = uf_Replace(lsFormat,"~~Box~~",left(lstrparms.String_Arg[28],30))
	PrintSend(llPrintJob, lsformat)	
	ls_temp= lstrparms.String_Arg[28]
NEXT
	
PrintClose(llPrintJob)
	

Return 0


end function

public function integer uf_kendo_customer_ucc (any as_any);//This function will print  kendo UCC labels for Neimen Marcus, JC Penny or Sephora

Str_parms	lStrparms
String		lsFormatUCC_128,	&
			lsCartonBarcode,	&
			lsTemp,				&
			lsPrintText,		&
			lsAddr,ls_weight,ls_temp,	&
			lsUCCCarton,ls_ucc, lsSKU, lsUPC

Long	llPrintJob,	&
		llPos,		&
		llPrintQty,	&
		llCount,	&
		llCartonNo,	&
		llAddrPos,i,j,ll_no_of_copies
		
Integer	liFileNo, liCheck
string ls_label_type	

lStrparms = as_any

//Only read the format from server once...
If isKendoUCCFormat = '' or isnull(isKendoUCCFormat) Then
	
	// Load correct customer format
	//01-JUNE-2017 :Madhu PEVS-641 Added Kendo Sephora US SSCC Label
	If lStrParms.String_arg[38] = "NM" Then
		isKendoUCCFormat = uf_read_label_Format('kendo_NM_SSCC_zebra.txt') 
	ElseIf lStrParms.String_arg[38] = "JCP" Then
		//isKendoUCCFormat = uf_read_label_Format('Kendo_JCP_SSCC_zebra.txt')  //18-JUNE-2017 :Madhu -PEVS-651 -Commented
		isKendoUCCFormat = uf_read_label_Format('Kendo_JCP_US_SSCC_zebra.txt') //18-JUNE-2017 :Madhu -PEVS-651 -Added
	ElseIf lStrParms.String_arg[38] = "SEP" Then
		isKendoUCCFormat = uf_read_label_Format('kendo_Sephora_SSCC_zebra.txt') 
	ElseIf lStrParms.String_arg[38] = "SEP-US" Then
		isKendoUCCFormat = uf_read_label_Format('kendo_Sephora_US_SSCC_zebra.txt') 
	ElseIf lStrParms.String_arg[38] = "ULTA" Then
		isKendoUCCFormat = uf_read_label_Format('Kendo_Ulta_US_SSCC_zebra.txt') 
		 // 	Dhirendra-S59217- Kendo: Target New Label----Start 
	ElseIf lStrParms.String_arg[38] = "TARGET" Then
		isKendoUCCFormat = uf_read_label_Format('Kendo_TARGET_US_SSCC_zebra.txt')
		 // 	Dhirendra-S59217- Kendo: Target New Label----END 
	End If
	
End If
	
lsFormatUCC_128 = isKendoUCCFormat
	
//Open Printer File 
llPrintJob = PrintOpen(lsPrintText)
	
If llPrintJob <0 Then 
	Messagebox('Labels', 'Unable to open Printer file. Labels will not be printed')
	Return -1
End If


//From Address - Roll up addresses if not all present
llAddrPos = 0

If lstrparms.String_Arg[2] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + "~~" //Customer WH Name
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,lsAddr,Left(lstrparms.String_Arg[2],30))
End If
	
If lstrparms.String_Arg[3] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + "~~" //Address1
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,lsAddr,Left(lstrparms.String_Arg[3],30))
End If

If lstrparms.String_Arg[4] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + "~~" //Address2
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,lsAddr,Left(lstrparms.String_Arg[4],30))
	
End If

If lstrparms.String_Arg[5] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + "~~" //Address3
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,lsAddr,Left(lstrparms.String_Arg[5],30))
	
End If

If lstrparms.String_Arg[6] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + "~~" //Address4
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,lsAddr,Left(lstrparms.String_Arg[6],30))
	
End If

If lstrparms.String_Arg[7] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + "~~" //Address5
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,lsAddr,Left(lstrparms.String_Arg[7],30))
	
End If

//Po No  number
lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~po_nbr~~",left(lstrparms.String_Arg[11],30))


//To Address - Roll up addresses if not all present
llAddrPos = 0

If lstrparms.String_Arg[12] > ' ' Then
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~" //Warehouse Name
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,lsAddr,Left(lstrparms.String_Arg[12],45))

End If

If lstrparms.String_Arg[13] > ' ' Then
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~" //Address1
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,lsAddr,Left(lstrparms.String_Arg[13],45))

End If

If lstrparms.String_Arg[14] > ' ' Then
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~" //Address2
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,lsAddr,left(lstrparms.String_Arg[14],45))

End If

If lstrparms.String_Arg[15] > ' ' Then
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~" //Address3
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,lsAddr,Left(lstrparms.String_Arg[15],45))

End If

If lstrparms.String_Arg[16] > ' ' Then //Address4
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~"
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,lsAddr,left(lstrparms.String_Arg[16],45))
	
End If

If lstrparms.String_Arg[17] > ' ' Then //Address5
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~"
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,lsAddr,left(lstrparms.String_Arg[17],45))
	
End If

//Zip
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~ship_to_zip~~", left(lstrparms.String_Arg[33],10))
	
//29-Mar-2017 :Madhu -SIMSPEVS-542 - Make Sephora Label to GS1-128 Format -START
If ((lStrParms.String_arg[38] = "SEP")  OR (lStrParms.String_arg[38] = "SEP-US")) Then
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,">=ship_to_zip_BC>=", "420" +left(trim(lstrparms.String_Arg[33]),10)) /*Zip*/
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,">=mark_for_store_BC>=","91"+left( lstrparms.String_Arg[26],30)) /* Store BC */
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,">=carton_no_BC>=",left( lstrparms.String_Arg[36],20)) /* SSCC */
//GailM 9/11/2020 - S49678 F24970 I3021 KDO - Kendo: New Client-Specific Carton Label (Ulta Beauty)
elseIf (lStrParms.String_arg[38] = "ULTA") Then
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,">=ship_to_zip_bc>=", "420" +left(trim(lstrparms.String_Arg[33]),10)) /*Zip*/
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~carton_count~~",left( lstrparms.String_Arg[34],30)) /* x of y */
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,">=carton_no_bc>=",left( lstrparms.String_Arg[36],20)) /* SSCC */
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~Carrier_name~~",left( lstrparms.String_Arg[35],30)) /* Carrier */
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,">=loc_bc>=",left( lstrparms.String_Arg[26],30)) /* Store from user_field3 */
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~loc_bc~~",left( lstrparms.String_Arg[26],30)) /* Store from user_field3 */
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~loc~~",left( lstrparms.String_Arg[12],30)) /* Store Name */
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~alloc_qty~~",left( lstrparms.String_Arg[62],30)) /*carton Qty*/
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~partial~~",left( lstrparms.String_Arg[43],30)) /*PARTIAL*/
 // 	Dhirendra-S59217- Kendo: Target New Label----Start     
elseIf (lStrParms.String_arg[38] = "TARGET") Then
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,">=ship_to_zip_bc>=", "420" +left(trim(lstrparms.String_Arg[33]),10)) /*Zip*/
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~carton_count~~",left( lstrparms.String_Arg[34],30)) /* x of y */
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,">=carton_no_bc>=",left( lstrparms.String_Arg[36],20)) /* SSCC */
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~Carrier_name~~",left( lstrparms.String_Arg[35],30)) /* Carrier */
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,">=loc_bc>=",left( lstrparms.String_Arg[26],30)) /* Store from user_field3 */
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~loc_bc~~",left( lstrparms.String_Arg[26],30)) /* Store from user_field3 */
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~loc~~",left( lstrparms.String_Arg[12],30)) /* Store Name */
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~alloc_qty~~",left( lstrparms.String_Arg[62],30)) /*carton Qty*/
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~partial~~",left( lstrparms.String_Arg[43],30)) /*PARTIAL*/
 // 	Dhirendra-S59217- Kendo: Target New Label----END     
//18-JUNE-2017 :Madhu- SIMEPEVS-651 -Added JCPenny Label -START
elseIf (lStrParms.String_arg[38] = "JCP") Then
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,">=ship_to_zip_BC>=", "420" +left(trim(lstrparms.String_Arg[33]),10)) /*Zip*/
//	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,">=mark_for_store_BC>=","91"+"0"+left( trim(lstrparms.String_Arg[26]),30)) /* Store BC */
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,">=carton_no_BC>=",left( lstrparms.String_Arg[36],20)) /* SSCC */
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~lot~~",left( lstrparms.String_Arg[28],30)) //Lot No

	//TAM 10/17/2017 - New Store variable(padded with '0's) used for JCP Store Barcode Text /Start
	String lsStore
	lsStore = Upper(Trim(lstrparms.String_Arg[26]))
	Do while len(lsStore) < 6
		lsStore = '0' + lsStore
	Loop
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~store1~~",lsStore) /* Barcode Store Text*/ 
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,">=mark_for_store_BC>=","91" + lsStore) /* Store BC */
	//TAM 10/17/2017 - New Store variable used for JCP Store BC Text /End

	//TAM 10/17/2017 - Need to replace the Supplier Name with a hardcoded value /Start
//	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~supp_name~~",left( lstrparms.String_Arg[41],30)) //Supp Code
	String lsSuppName
	lsSuppName = Upper(Trim(lstrparms.String_Arg[41]))
	choose case lsSuppName
		case 'KENDO'
			lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~supp_name~~",'47878') //Supp Code
		case 'OLE'
			lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~supp_name~~",'164749') //Supp Code
		case 'FENTY'
			lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~supp_name~~",'136119') //Supp Code
		case else 
			lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~supp_name~~",left( lstrparms.String_Arg[41],30)) //Supp Code
	end choose
	//TAM 10/17/2017 - Need to replace the Supplier Name with a hardcoded value /End

//18-JUNE-2017 :Madhu- SIMEPEVS-651 -Added JCPenny Label -END
else
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~ship_to_zip_BC~~", left(lstrparms.String_Arg[33],10)) /*Zip*/
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~mark_for_store_BC~~",left( lstrparms.String_Arg[26],30)) /* Store BC */
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,">;>=carton_no_BC>=",left( lstrparms.String_Arg[36],20)) /* SSCC */
End If
//29-Mar-2017 :Madhu -SIMSPEVS-542 - Make Sephora Label to GS1-128 Format -START

//SKU
lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~sku~~", left(lstrparms.String_Arg[20],20))//Sku
lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~sku_bc~~", left(lstrparms.String_Arg[20],20))//Barcoded Sku

//UPC 
lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~upc~~",left( lstrparms.String_Arg[21],30))//UPC

//Qty 
lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~qty~~",left( lstrparms.String_Arg[62],30)) /*carton Qty*/

// carton x of y
lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~tot_off~~",left( lstrparms.String_Arg[34],30)) /* x of y */

lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~dept~~",left( lstrparms.String_Arg[24],30)) /* Department */
lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~Division~~",left( lstrparms.String_Arg[25],30)) /* Division */
lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~store~~",left( lstrparms.String_Arg[26],30)) /* Store */
//lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~mark_for_store_BC~~",left( lstrparms.String_Arg[26],30)) /* Store BC */ //29-Mar-2017 :Madhu -SIMSPEVS-542 - Make Sephora Label to GS1-128 Format
lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~vendor_part~~",left( lstrparms.String_Arg[29],30)) /* Vendor Part */
lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~bol_nbr~~",left( lstrparms.String_Arg[31],30)) /* BOL */
lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~pro~~",left( lstrparms.String_Arg[32],30)) /* Pro */
lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~carrier_name~~",left( lstrparms.String_Arg[35],30)) /* Carrier */
//lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,">;>=carton_no_BC>=",left( lstrparms.String_Arg[36],20)) /* SSCC */ //29-Mar-2017 :Madhu -SIMSPEVS-542 - Make Sephora Label to GS1-128 Format
//lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~carton_no_readable~~",left( lstrparms.String_Arg[36],20)) /* SSCC */
lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~carton_no_readable~~",Right(Trim( lstrparms.String_Arg[36]),18)) /* SSCC */
lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~size~~",left( lstrparms.String_Arg[39],20)) /* Size */
lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~color~~",left( lstrparms.String_Arg[40],20)) /* Color */
lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~style~~",left( lstrparms.String_Arg[42],20)) /* Style */
lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~desc~~",left( lstrparms.String_Arg[27],20)) /* Description */


//SSCC Number - If already assigned (reprint), use that. Otherwise we need to assign it here

PrintSend(llPrintJob, lsFormatUCC_128)	

PrintClose(llPrintJob)

Return 0



end function

public function any uf_bosch_ucc_128_zebra_ship (any as_any);//This function will print  Generic UCCS Shipping label
		//TAM 2018/07 - S20380 - Added BSH - Bosch - The Home Depot Ship Label

Str_parms	lStrparms
String	lsFormatUCC_128,	&
	lsFormatUCC_128_Sears,	&
	lsFormatUCC_128_BestBuy,	&
	lsFormatUCC_128_Lowes,	&
	lsFormatUCC_128_Home_Depot,	&
	lsProLabel, &
	lsGS1_BestBuy, &
	lsPart_Sears, &
	lsTracking, &
	lsCartonBarcode,	&
	lsTemp,				&
	lsPrintText,		&
	lsAddr,ls_weight,ls_temp,	&
	lsUCCCarton,ls_ucc, ls_replace_home_depot_data

Long	llPrintJob,	&
		llPos,		&
		llPrintQty,	&
		llPrintPos,	&
		llCartonNo,	&
		llAddrPos,i,j,ll_no_of_copies
		
Integer	liFileNo, liCheck
string ls_label_type	

lStrparms = as_any
//lstrparms = getparms()

lsFormatUCC_128_Sears = uf_read_label_Format('Bosch_Sears_SSCC_Zebra_Ship.txt') 
lsFormatUCC_128_BestBuy = uf_read_label_Format('Bosch_Bestbuy_SSCC_Zebra_Ship.txt') 
lsFormatUCC_128 = uf_read_label_Format('Bosch_SSCC_Zebra_Ship.txt') 
lsFormatUCC_128_Lowes = uf_read_label_Format('Bosch_Lowes_SSCC_Zebra_Ship.txt') 
lsFormatUCC_128_Home_Depot = uf_read_label_Format('Bosch_Home_Depot_SSCC_Zebra_Ship.txt') 
//lsGS1_BestBuy = uf_read_label_Format('Bosch_Bestbuy_GS1.txt') 
lsPart_Sears = uf_read_label_Format('Bosch_Sears_Part.txt') 
lsTracking = uf_read_label_Format('Bosch_Carrier_Pro_Label.txt') 
lsProLabel =  uf_read_label_Format('Bosch_Pro_Zebra_Ship.txt') 
//END CHOOSE	

ls_replace_home_depot_data ="^B3N,N,89,N,N^FD~~pro_bc~~^FS"
	
//Open Printer File 
//llPrintJob = PrintOpen(lsPrintText)
//	
//If llPrintJob <0 Then 
//	Messagebox('Labels', 'Unable to open Printer file. Labels will not be printed')
//	Return -1
//End If


//From Address - Roll up addresses if not all present
llAddrPos = 0

If lstrparms.String_Arg[2] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + "~~"
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,lsAddr,Left(lstrparms.String_Arg[2],30))
	lsFormatUCC_128_Bestbuy = uf_Replace(lsFormatUCC_128_Bestbuy,lsAddr,Left(lstrparms.String_Arg[2],30))
	lsFormatUCC_128_Sears = uf_Replace(lsFormatUCC_128_Sears,lsAddr,Left(lstrparms.String_Arg[2],30))
	lsFormatUCC_128_Lowes = uf_Replace(lsFormatUCC_128_Lowes,lsAddr,Left(lstrparms.String_Arg[2],30))
	lsFormatUCC_128_Home_Depot = uf_Replace(lsFormatUCC_128_Home_Depot,lsAddr,Left(lstrparms.String_Arg[2],30))
	lsProLabel = uf_Replace(lsProLabel,lsAddr,Left(lstrparms.String_Arg[2],30))
//	lsGS1_Bestbuy = uf_Replace(lsGS1_Bestbuy,lsAddr,Left(lstrparms.String_Arg[2],30))
End If
	
If lstrparms.String_Arg[3] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + "~~"
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,lsAddr,Left(lstrparms.String_Arg[3],30))
	lsFormatUCC_128_Bestbuy = uf_Replace(lsFormatUCC_128_Bestbuy,lsAddr,Left(lstrparms.String_Arg[3],30))
	lsFormatUCC_128_Sears = uf_Replace(lsFormatUCC_128_Sears,lsAddr,Left(lstrparms.String_Arg[3],30))
	lsFormatUCC_128_Lowes = uf_Replace(lsFormatUCC_128_Lowes,lsAddr,Left(lstrparms.String_Arg[3],30))
	lsFormatUCC_128_Home_Depot = uf_Replace(lsFormatUCC_128_Home_Depot,lsAddr,Left(lstrparms.String_Arg[3],30))
	lsProLabel = uf_Replace(lsProLabel,lsAddr,Left(lstrparms.String_Arg[3],30))
//	lsGS1_Bestbuy = uf_Replace(lsGS1_Bestbuy,lsAddr,Left(lstrparms.String_Arg[3],30))
End If

If lstrparms.String_Arg[4] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + "~~"
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,lsAddr,Left(lstrparms.String_Arg[4],30))
	lsFormatUCC_128_Bestbuy = uf_Replace(lsFormatUCC_128_Bestbuy,lsAddr,Left(lstrparms.String_Arg[4],30))
	lsFormatUCC_128_Sears = uf_Replace(lsFormatUCC_128_Sears,lsAddr,Left(lstrparms.String_Arg[4],30))
	lsFormatUCC_128_Lowes = uf_Replace(lsFormatUCC_128_Lowes,lsAddr,Left(lstrparms.String_Arg[4],30))
	lsFormatUCC_128_Home_Depot = uf_Replace(lsFormatUCC_128_Home_Depot,lsAddr,Left(lstrparms.String_Arg[4],30))
	lsProLabel = uf_Replace(lsProLabel,lsAddr,Left(lstrparms.String_Arg[4],30))
//	lsGS1_Bestbuy = uf_Replace(lsGS1_Bestbuy,lsAddr,Left(lstrparms.String_Arg[4],30))
End If

If lstrparms.String_Arg[5] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + "~~"
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,lsAddr,Left(lstrparms.String_Arg[5],30))
	lsFormatUCC_128_Bestbuy = uf_Replace(lsFormatUCC_128_Bestbuy,lsAddr,Left(lstrparms.String_Arg[5],30))
	lsFormatUCC_128_Sears = uf_Replace(lsFormatUCC_128_Sears,lsAddr,Left(lstrparms.String_Arg[5],30))
	lsFormatUCC_128_Lowes = uf_Replace(lsFormatUCC_128_Lowes,lsAddr,Left(lstrparms.String_Arg[5],30))
	lsFormatUCC_128_Home_Depot = uf_Replace(lsFormatUCC_128_Home_Depot,lsAddr,Left(lstrparms.String_Arg[5],30))
	lsProLabel = uf_Replace(lsProLabel,lsAddr,Left(lstrparms.String_Arg[5],30))
//	lsGS1_Bestbuy = uf_Replace(lsGS1_Bestbuy,lsAddr,Left(lstrparms.String_Arg[5],30))
End If

If lstrparms.String_Arg[6] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + "~~"
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,lsAddr,Left(lstrparms.String_Arg[6],30))
	lsFormatUCC_128_Bestbuy = uf_Replace(lsFormatUCC_128_Bestbuy,lsAddr,Left(lstrparms.String_Arg[6],30))
	lsFormatUCC_128_Sears = uf_Replace(lsFormatUCC_128_Sears,lsAddr,Left(lstrparms.String_Arg[6],30))
	lsFormatUCC_128_Lowes = uf_Replace(lsFormatUCC_128_Lowes,lsAddr,Left(lstrparms.String_Arg[6],30))
	lsFormatUCC_128_Home_Depot = uf_Replace(lsFormatUCC_128_Home_Depot,lsAddr,Left(lstrparms.String_Arg[6],30))
	lsProLabel = uf_Replace(lsProLabel,lsAddr,Left(lstrparms.String_Arg[6],30))
//	lsGS1_Bestbuy = uf_Replace(lsGS1_Bestbuy,lsAddr,Left(lstrparms.String_Arg[6],30))
End If

If lstrparms.String_Arg[7] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + "~~"
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,lsAddr,Left(lstrparms.String_Arg[7],30))
	lsFormatUCC_128_Bestbuy = uf_Replace(lsFormatUCC_128_Bestbuy,lsAddr,Left(lstrparms.String_Arg[7],30))
	lsFormatUCC_128_Sears = uf_Replace(lsFormatUCC_128_Sears,lsAddr,Left(lstrparms.String_Arg[7],30))
	lsFormatUCC_128_Lowes = uf_Replace(lsFormatUCC_128_Lowes,lsAddr,Left(lstrparms.String_Arg[7],30))
	lsFormatUCC_128_Home_Depot = uf_Replace(lsFormatUCC_128_Home_Depot,lsAddr,Left(lstrparms.String_Arg[7],30))
	lsProLabel = uf_Replace(lsProLabel,lsAddr,Left(lstrparms.String_Arg[7],30))
//	lsGS1_Bestbuy = uf_Replace(lsGS1_Bestbuy,lsAddr,Left(lstrparms.String_Arg[7],30))
End If

//Po No and B/L number
lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~po_nbr~~",left(lstrparms.String_Arg[11],30))	
lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~bol_nbr~~",left(lstrparms.String_Arg[10],30))	
lsFormatUCC_128_Bestbuy = uf_Replace(lsFormatUCC_128_Bestbuy,"~~po_nbr~~",left(lstrparms.String_Arg[11],30))	
lsFormatUCC_128_Bestbuy = uf_Replace(lsFormatUCC_128_BestBuy,"~~bol_nbr~~",left(lstrparms.String_Arg[10],30))	
lsFormatUCC_128_Sears = uf_Replace(lsFormatUCC_128_Sears,"~~po_nbr~~",left(lstrparms.String_Arg[11],30))	
lsFormatUCC_128_Sears = uf_Replace(lsFormatUCC_128_Sears,"~~bol_nbr~~",left(lstrparms.String_Arg[10],30))	
lsFormatUCC_128_Lowes = uf_Replace(lsFormatUCC_128_Lowes,"~~po_nbr~~",left(lstrparms.String_Arg[11],30))	
lsFormatUCC_128_Lowes = uf_Replace(lsFormatUCC_128_Lowes,"~~bol_nbr~~",left(lstrparms.String_Arg[10],30))	
lsFormatUCC_128_Home_Depot = uf_Replace(lsFormatUCC_128_Home_Depot,"~~po_nbr~~",left(lstrparms.String_Arg[11],30))	
lsFormatUCC_128_Home_Depot = uf_Replace(lsFormatUCC_128_Home_Depot,"~~bol_nbr~~",left(lstrparms.String_Arg[10],30))	
lsProLabel = uf_Replace(lsProLabel,"~~po_nbr~~",left(lstrparms.String_Arg[11],30))	
lsProLabel = uf_Replace(lsProLabel,"~~bol_nbr~~",left(lstrparms.String_Arg[10],30))	
//lsGs1_Bestbuy = uf_Replace(lsGs1_Bestbuy,"~~po_nbr~~",left(lstrparms.String_Arg[11],30))	
//lsGs1_Bestbuy = uf_Replace(lsGs1_BestBuy,"~~bol_nbr~~",left(lstrparms.String_Arg[10],30))	

//To Address - Roll up addresses if not all present
llAddrPos = 0

If lstrparms.String_Arg[12] > ' ' Then
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~" //Warehouse Name
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,lsAddr,Left(lstrparms.String_Arg[12],45))
	lsFormatUCC_128_Bestbuy = uf_Replace(lsFormatUCC_128_Bestbuy,lsAddr,Left(lstrparms.String_Arg[12],30))
	lsFormatUCC_128_Sears = uf_Replace(lsFormatUCC_128_Sears,lsAddr,Left(lstrparms.String_Arg[12],30))
	lsFormatUCC_128_Lowes = uf_Replace(lsFormatUCC_128_Lowes,lsAddr,Left(lstrparms.String_Arg[12],30))
	lsFormatUCC_128_Home_Depot = uf_Replace(lsFormatUCC_128_Home_Depot,lsAddr,Left(lstrparms.String_Arg[12],30))
	lsProLabel = uf_Replace(lsProLabel,lsAddr,Left(lstrparms.String_Arg[12],30))
//	lsGS1_Bestbuy = uf_Replace(lsGS1_Bestbuy,lsAddr,Left(lstrparms.String_Arg[12],30))
End If

If lstrparms.String_Arg[13] > ' ' Then
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~" //Address1
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,lsAddr,Left(lstrparms.String_Arg[13],45))
	lsFormatUCC_128_Bestbuy = uf_Replace(lsFormatUCC_128_Bestbuy,lsAddr,Left(lstrparms.String_Arg[13],30))
	lsFormatUCC_128_Sears = uf_Replace(lsFormatUCC_128_Sears,lsAddr,Left(lstrparms.String_Arg[13],30))
	lsFormatUCC_128_Lowes = uf_Replace(lsFormatUCC_128_Lowes,lsAddr,Left(lstrparms.String_Arg[13],30))
	lsFormatUCC_128_Home_Depot = uf_Replace(lsFormatUCC_128_Home_Depot,lsAddr,Left(lstrparms.String_Arg[13],30))
	lsProLabel = uf_Replace(lsProLabel,lsAddr,Left(lstrparms.String_Arg[13],30))
//	lsGS1_Bestbuy = uf_Replace(lsGS1_Bestbuy,lsAddr,Left(lstrparms.String_Arg[13],30))
End If

If lstrparms.String_Arg[14] > ' ' Then
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~" //Address2
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,lsAddr,left(lstrparms.String_Arg[14],45))
	lsFormatUCC_128_Bestbuy = uf_Replace(lsFormatUCC_128_Bestbuy,lsAddr,Left(lstrparms.String_Arg[14],30))
	lsFormatUCC_128_Sears = uf_Replace(lsFormatUCC_128_Sears,lsAddr,Left(lstrparms.String_Arg[14],30))
	lsFormatUCC_128_Lowes = uf_Replace(lsFormatUCC_128_Lowes,lsAddr,Left(lstrparms.String_Arg[14],30))
	lsFormatUCC_128_Home_Depot = uf_Replace(lsFormatUCC_128_Home_Depot,lsAddr,Left(lstrparms.String_Arg[14],30))
	lsProLabel = uf_Replace(lsProLabel,lsAddr,Left(lstrparms.String_Arg[14],30))
//	lsGS1_Bestbuy = uf_Replace(lsGS1_Bestbuy,lsAddr,Left(lstrparms.String_Arg[14],30))
End If

If lstrparms.String_Arg[15] > ' ' Then
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~" //Address3
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,lsAddr,Left(lstrparms.String_Arg[15],45))
	lsFormatUCC_128_Bestbuy = uf_Replace(lsFormatUCC_128_Bestbuy,lsAddr,Left(lstrparms.String_Arg[15],30))
	lsFormatUCC_128_Sears = uf_Replace(lsFormatUCC_128_Sears,lsAddr,Left(lstrparms.String_Arg[15],30))
	lsFormatUCC_128_Lowes = uf_Replace(lsFormatUCC_128_Lowes,lsAddr,Left(lstrparms.String_Arg[15],30))
	lsFormatUCC_128_Home_Depot = uf_Replace(lsFormatUCC_128_Home_Depot,lsAddr,Left(lstrparms.String_Arg[15],30))
	lsProLabel = uf_Replace(lsProLabel,lsAddr,Left(lstrparms.String_Arg[15],30))
//	lsGS1_Bestbuy = uf_Replace(lsGS1_Bestbuy,lsAddr,Left(lstrparms.String_Arg[15],30))
End If

If lstrparms.String_Arg[16] > ' ' Then //Address5
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~"
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,lsAddr,left(lstrparms.String_Arg[16],45))
	lsFormatUCC_128_Bestbuy = uf_Replace(lsFormatUCC_128_Bestbuy,lsAddr,Left(lstrparms.String_Arg[16],30))
	lsFormatUCC_128_Sears = uf_Replace(lsFormatUCC_128_Sears,lsAddr,Left(lstrparms.String_Arg[16],30))
	lsFormatUCC_128_Lowes = uf_Replace(lsFormatUCC_128_Lowes,lsAddr,Left(lstrparms.String_Arg[16],30))
	lsFormatUCC_128_Home_Depot = uf_Replace(lsFormatUCC_128_Home_Depot,lsAddr,Left(lstrparms.String_Arg[16],30))
	lsProLabel = uf_Replace(lsProLabel,lsAddr,Left(lstrparms.String_Arg[16],30))
//	lsGS1_Bestbuy = uf_Replace(lsGS1_Bestbuy,lsAddr,Left(lstrparms.String_Arg[16],30))
End If

If lstrparms.String_Arg[17] > ' ' Then //Address5
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~"
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,lsAddr,left(lstrparms.String_Arg[17],45))
	lsFormatUCC_128_Bestbuy = uf_Replace(lsFormatUCC_128_Bestbuy,lsAddr,Left(lstrparms.String_Arg[17],30))
	lsFormatUCC_128_Sears = uf_Replace(lsFormatUCC_128_Sears,lsAddr,Left(lstrparms.String_Arg[17],30))
	lsFormatUCC_128_Lowes = uf_Replace(lsFormatUCC_128_Lowes,lsAddr,Left(lstrparms.String_Arg[17],30))
	lsFormatUCC_128_Home_Depot = uf_Replace(lsFormatUCC_128_Home_Depot,lsAddr,Left(lstrparms.String_Arg[17],30))
	lsProLabel = uf_Replace(lsProLabel,lsAddr,Left(lstrparms.String_Arg[17],30))
//	lsGS1_Bestbuy = uf_Replace(lsGS1_Bestbuy,lsAddr,Left(lstrparms.String_Arg[17],30))
End If
	
//SOLD To Address - Roll up addresses if not all present
llAddrPos = 0

If lstrparms.String_Arg[48] > ' ' Then
	llAddrPos ++
	lsAddr = "~~soldto_addr" + String(llAddrPos) + "~~" //SOLD TO Name
	lsFormatUCC_128_Home_Depot = uf_Replace(lsFormatUCC_128_Home_Depot,lsAddr,Left(lstrparms.String_Arg[48],30))
	lsProLabel = uf_Replace(lsProLabel,lsAddr,Left(lstrparms.String_Arg[12],30))
//	lsGS1_Bestbuy = uf_Replace(lsGS1_Bestbuy,lsAddr,Left(lstrparms.String_Arg[12],30))
End If

If lstrparms.String_Arg[49] > ' ' Then
	llAddrPos ++
	lsAddr = "~~soldto_addr" + String(llAddrPos) + "~~" //Address1
	lsFormatUCC_128_Home_Depot = uf_Replace(lsFormatUCC_128_Home_Depot,lsAddr,Left(lstrparms.String_Arg[49],30))
End If

If lstrparms.String_Arg[50] > ' ' Then
	llAddrPos ++
	lsAddr = "~~soldto_addr" + String(llAddrPos) + "~~" //Address2
	lsFormatUCC_128_Home_Depot = uf_Replace(lsFormatUCC_128_Home_Depot,lsAddr,Left(lstrparms.String_Arg[50],30))
End If

If lstrparms.String_Arg[51] > ' ' Then
	llAddrPos ++
	lsAddr = "~~soldto_addr" + String(llAddrPos) + "~~" //Address3
	lsFormatUCC_128_Home_Depot = uf_Replace(lsFormatUCC_128_Home_Depot,lsAddr,Left(lstrparms.String_Arg[51],30))
End If

If lstrparms.String_Arg[52] > ' ' Then //Address5
	llAddrPos ++
	lsAddr = "~~soldto_addr" + String(llAddrPos) + "~~"
	lsFormatUCC_128_Home_Depot = uf_Replace(lsFormatUCC_128_Home_Depot,lsAddr,Left(lstrparms.String_Arg[52],30))
End If

If lstrparms.String_Arg[53] > ' ' Then //Address5
	llAddrPos ++
	lsAddr = "~~soldto_addr" + String(llAddrPos) + "~~"
	lsFormatUCC_128_Home_Depot = uf_Replace(lsFormatUCC_128_Home_Depot,lsAddr,Left(lstrparms.String_Arg[53],30))
End If



lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~sku~~", left(Lstrparms.String_arg[20],20))//Sku
lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~upc~~",left( lstrparms.String_Arg[21],30))//Alternate Sku
lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~invoice_no~~",left( lstrparms.String_Arg[23],30))//Order No
lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~invoice_no_bc~~",left( lstrparms.String_Arg[23],30))//Order No
lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,">;>=invoice_no_bc>=", left(Lstrparms.String_arg[23],30))
lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~carrier_name~~",left(lstrparms.String_Arg[24],30))//Carrier
lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~pro~~",left( lstrparms.String_Arg[26],30))
//TAM Added Pro Barcode
lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~pro_bc~~", left(Lstrparms.String_arg[26],30))
lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,">;>=pro_bc>=", left(Lstrparms.String_arg[26],30))

//lsFormatUCC_128 = uf_replace_label_text(lsFormatUCC_128,"QTY:",Left("",45)) //Blank out the QTY on the Pallet Label
//lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~quantity~~",left("",30))

lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~carton_no_readable~~", left(Lstrparms.String_arg[48],20))
lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~carton_no_BC~~", left(Lstrparms.String_arg[48],20)) 
lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,">;>=carton_no_BC>=", left(Lstrparms.String_arg[48],20)) 
lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~ship_to_zip~~", left(Lstrparms.String_arg[33],20))
lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~ship_to_zip_BC~~", left(Lstrparms.String_arg[33],20))
lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,">;>=ship_to_zip>=", left(Lstrparms.String_arg[33],20)) 

//??lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~customer_no~~",left( lstrparms.String_Arg[21],30)) /* 08/13 - PCONKL- this is now the Serial Number*/

//lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~pro_type~~",left( lstrparms.String_Arg[27],30)) //Hard Coded in the label
lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~carton_tot~~",left( lstrparms.String_Arg[28],30))
lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~tot_off~~",left( lstrparms.String_Arg[29],30))
lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~tot~~",left( lstrparms.String_Arg[30],30))
	
lsProLabel = uf_Replace(lsProLabel,"~~sku~~", left(Lstrparms.String_arg[20],20))//Sku
lsProLabel = uf_Replace(lsProLabel,"~~upc~~",left( lstrparms.String_Arg[21],30))//Alternate Sku
lsProLabel = uf_Replace(lsProLabel,"~~invoice_no~~",left( lstrparms.String_Arg[23],30))//Order No
lsProLabel = uf_Replace(lsProLabel,"~~invoice_bc~~",left( lstrparms.String_Arg[23],30))//Order No
lsProLabel = uf_Replace(lsProLabel,">;>=invoice_no_bc>=", left(Lstrparms.String_arg[23],30))
lsProLabel = uf_Replace(lsProLabel,"~~carrier_name~~",left(lstrparms.String_Arg[24],30))//Carrier
lsProLabel = uf_Replace(lsProLabel,"~~pro~~",left( lstrparms.String_Arg[26],30))
lsProLabel = uf_Replace(lsProLabel,"~~pro_bc~~", left(Lstrparms.String_arg[26],30))
lsProLabel = uf_Replace(lsProLabel,">;>=pro_bc>=", left(Lstrparms.String_arg[26],30))
lsProLabel = uf_Replace(lsProLabel,"~~carton_no_readable~~", left(Lstrparms.String_arg[48],20))
lsProLabel = uf_Replace(lsProLabel,"~~carton_no_BC~~", left(Lstrparms.String_arg[48],20)) 
lsProLabel = uf_Replace(lsProLabel,">;>=carton_no_BC>=", left(Lstrparms.String_arg[48],20)) 
lsProLabel = uf_Replace(lsProLabel,"~~ship_to_zip~~", left(Lstrparms.String_arg[33],20))
lsProLabel = uf_Replace(lsProLabel,"~~ship_to_zip_BC~~", left(Lstrparms.String_arg[33],20))
lsProLabel = uf_Replace(lsProLabel,">;>=ship_to_zip>=", left(Lstrparms.String_arg[33],20)) 
lsProLabel = uf_Replace(lsProLabel,"~~carton_tot~~",left( lstrparms.String_Arg[28],30))
lsProLabel = uf_Replace(lsProLabel,"~~tot_off~~",left( lstrparms.String_Arg[29],30))
lsProLabel = uf_Replace(lsProLabel,"~~tot~~",left( lstrparms.String_Arg[30],30))
lsProLabel = uf_Replace(lsProLabel,"~~alloc_qty~~",left( lstrparms.String_Arg[62],30))
lsProLabel = uf_Replace(lsProLabel,"~~today~~",string(today(),"mm/dd/yyyy hh:mm:ss "))

lsFormatUCC_128_Bestbuy = uf_Replace(lsFormatUCC_128_Bestbuy,"~~sku~~", left(Lstrparms.String_arg[20],20))//Sku
lsFormatUCC_128_Bestbuy = uf_Replace(lsFormatUCC_128_Bestbuy,"~~upc~~",left( lstrparms.String_Arg[21],30))//Alternate Sku
lsFormatUCC_128_Bestbuy = uf_Replace(lsFormatUCC_128_Bestbuy,"~~invoice_no~~",left( lstrparms.String_Arg[23],30))//Order No
lsFormatUCC_128_Bestbuy = uf_Replace(lsFormatUCC_128_Bestbuy,"~~invoice_no_bc~~",left( lstrparms.String_Arg[23],30))//Order No
lsFormatUCC_128_Bestbuy = uf_Replace(lsFormatUCC_128_BestBuy,">;>=invoice_bc>=", left(Lstrparms.String_arg[23],30))
lsFormatUCC_128_BestBuy = uf_Replace(lsFormatUCC_128_Bestbuy,"~~carrier_name~~",left(lstrparms.String_Arg[24],30))//Carrier
lsFormatUCC_128_BestBuy = uf_Replace(lsFormatUCC_128_Bestbuy,"~~pro~~",left( lstrparms.String_Arg[26],30))
lsFormatUCC_128_Bestbuy = uf_Replace(lsFormatUCC_128_Bestbuy,"~~pro_bc~~", left(Lstrparms.String_arg[26],30))
lsFormatUCC_128_Bestbuy = uf_Replace(lsFormatUCC_128_Bestbuy,">;>=pro_bc>=", left(Lstrparms.String_arg[26],30))
lsFormatUCC_128_Bestbuy = uf_Replace(lsFormatUCC_128_Bestbuy,"~~carton_no_readable~~", left(Lstrparms.String_arg[48],20))
lsFormatUCC_128_Bestbuy = uf_Replace(lsFormatUCC_128_Bestbuy,"~~carton_no_BC~~", left(Lstrparms.String_arg[48],20)) 
lsFormatUCC_128_Bestbuy = uf_Replace(lsFormatUCC_128_Bestbuy,">;>=carton_no_BC>=", left(Lstrparms.String_arg[48],20)) 
lsFormatUCC_128_Bestbuy = uf_Replace(lsFormatUCC_128_Bestbuy,"~~ship_to_zip~~", left(Lstrparms.String_arg[33],20))
lsFormatUCC_128_Bestbuy = uf_Replace(lsFormatUCC_128_Bestbuy,"~~ship_to_zip_BC~~", left(Lstrparms.String_arg[33],20))
lsFormatUCC_128_Bestbuy = uf_Replace(lsFormatUCC_128_Bestbuy,">;>=ship_to_zip>=", left(Lstrparms.String_arg[33],20)) 
lsFormatUCC_128_Bestbuy = uf_Replace(lsFormatUCC_128_Bestbuy,"~~carton_tot~~",left( lstrparms.String_Arg[28],30))
lsFormatUCC_128_Bestbuy = uf_Replace(lsFormatUCC_128_Bestbuy,"~~tot_off~~",left( lstrparms.String_Arg[29],30))
lsFormatUCC_128_Bestbuy = uf_Replace(lsFormatUCC_128_Bestbuy,"~~tot~~",left( lstrparms.String_Arg[30],30))
lsFormatUCC_128_Bestbuy = uf_Replace(lsFormatUCC_128_Bestbuy,"~~alloc_qty~~",left( lstrparms.String_Arg[62],30))
lsFormatUCC_128_Bestbuy = uf_Replace(lsFormatUCC_128_Bestbuy,"~~today~~",string(today(),"mm/dd/yyyy hh:mm:ss "))

lsFormatUCC_128_Sears = uf_Replace(lsFormatUCC_128_Sears,"~~sku~~", left(Lstrparms.String_arg[20],20))//Sku
lsFormatUCC_128_Sears = uf_Replace(lsFormatUCC_128_Sears,"~~upc~~",left( lstrparms.String_Arg[21],30))//Alternate Sku
lsFormatUCC_128_Sears = uf_Replace(lsFormatUCC_128_Sears,"~~invoice_no~~",left( lstrparms.String_Arg[23],30))//Order No
lsFormatUCC_128_Sears = uf_Replace(lsFormatUCC_128_Sears,"~~invoice_bc~~",left( lstrparms.String_Arg[23],30))//Order No
lsFormatUCC_128_Sears = uf_Replace(lsFormatUCC_128_Sears,">;>=invoice_bc>=", left(Lstrparms.String_arg[23],30))
lsFormatUCC_128_Sears = uf_Replace(lsFormatUCC_128_Sears,"~~carrier_name~~",left(lstrparms.String_Arg[24],30))//Carrier
lsFormatUCC_128_Sears = uf_Replace(lsFormatUCC_128_Sears,"~~pro~~",left( lstrparms.String_Arg[26],30))
lsFormatUCC_128_Sears = uf_Replace(lsFormatUCC_128_Sears,"~~pro_bc~~", left(Lstrparms.String_arg[26],30))
lsFormatUCC_128_Sears = uf_Replace(lsFormatUCC_128_Sears,">;>=pro_bc>=", left(Lstrparms.String_arg[26],30))
lsFormatUCC_128_Sears = uf_Replace(lsFormatUCC_128_Sears,"~~carton_no_readable~~", left(Lstrparms.String_arg[48],20))
lsFormatUCC_128_Sears = uf_Replace(lsFormatUCC_128_Sears,"~~carton_no_BC~~", left(Lstrparms.String_arg[48],20)) 
lsFormatUCC_128_Sears = uf_Replace(lsFormatUCC_128_Sears,">;>=carton_no_BC>=", left(Lstrparms.String_arg[48],20)) 
lsFormatUCC_128_Sears = uf_Replace(lsFormatUCC_128_Sears,"~~ship_to_zip~~", left(Lstrparms.String_arg[33],20))
lsFormatUCC_128_Sears = uf_Replace(lsFormatUCC_128_Sears,"~~ship_to_zip_BC~~", left(Lstrparms.String_arg[33],20))
lsFormatUCC_128_Sears = uf_Replace(lsFormatUCC_128_Sears,">;>=ship_to_zip>=", left(Lstrparms.String_arg[33],20)) 
lsFormatUCC_128_Sears = uf_Replace(lsFormatUCC_128_Sears,"~~carton_tot~~",left( lstrparms.String_Arg[28],30))
lsFormatUCC_128_Sears = uf_Replace(lsFormatUCC_128_Sears,"~~tot_off~~",left( lstrparms.String_Arg[29],30))
lsFormatUCC_128_Sears = uf_Replace(lsFormatUCC_128_Sears,"~~tot~~",left( lstrparms.String_Arg[30],30))
lsFormatUCC_128_Sears = uf_Replace(lsFormatUCC_128_Sears,"~~dept~~",left( lstrparms.String_Arg[40],30))//Department
lsFormatUCC_128_Sears = uf_Replace(lsFormatUCC_128_Sears,"~~today~~",string(today(),"mm/dd/yyyy hh:mm:ss "))

lsFormatUCC_128_Lowes = uf_Replace(lsFormatUCC_128_Lowes,"~~sku~~", left(Lstrparms.String_arg[20],20))//Sku
lsFormatUCC_128_Lowes = uf_Replace(lsFormatUCC_128_Lowes,"~~upc~~",left( lstrparms.String_Arg[21],30))//Alternate Sku
lsFormatUCC_128_Lowes = uf_Replace(lsFormatUCC_128_Lowes,"~~invoice_no~~",left( lstrparms.String_Arg[23],30))//Order No
lsFormatUCC_128_Lowes = uf_Replace(lsFormatUCC_128_Lowes,"~~invoice_bc~~",left( lstrparms.String_Arg[23],30))//Order No
lsFormatUCC_128_Lowes = uf_Replace(lsFormatUCC_128_Lowes,">;>=invoice_bc>=",left(Lstrparms.String_arg[23],30))
lsFormatUCC_128_Lowes = uf_Replace(lsFormatUCC_128_Lowes,"~~carrier_name~~",left(lstrparms.String_Arg[24],30))//Carrier
lsFormatUCC_128_Lowes = uf_Replace(lsFormatUCC_128_Lowes,"~~pro~~",left( lstrparms.String_Arg[26],30))
lsFormatUCC_128_Lowes = uf_Replace(lsFormatUCC_128_Lowes,"~~pro_bc~~", left(Lstrparms.String_arg[26],30))
lsFormatUCC_128_Lowes = uf_Replace(lsFormatUCC_128_Lowes,">;>=pro_bc>=", left(Lstrparms.String_arg[26],30))
lsFormatUCC_128_Lowes = uf_Replace(lsFormatUCC_128_Lowes,"~~carton_no_readable~~", left(Lstrparms.String_arg[48],20))
lsFormatUCC_128_Lowes = uf_Replace(lsFormatUCC_128_Lowes,"~~carton_no_BC~~", left(Lstrparms.String_arg[48],20)) 
lsFormatUCC_128_Lowes = uf_Replace(lsFormatUCC_128_Lowes,">;>=carton_no_BC>=", left(Lstrparms.String_arg[48],20)) 
lsFormatUCC_128_Lowes = uf_Replace(lsFormatUCC_128_Lowes,"~~ship_to_zip~~", left(Lstrparms.String_arg[33],20))
lsFormatUCC_128_Lowes = uf_Replace(lsFormatUCC_128_Lowes,"~~ship_to_zip_BC~~", left(Lstrparms.String_arg[33],20))
lsFormatUCC_128_Lowes = uf_Replace(lsFormatUCC_128_Lowes,">;>=ship_to_zip>=", left(Lstrparms.String_arg[33],20)) 
lsFormatUCC_128_Lowes = uf_Replace(lsFormatUCC_128_Lowes,"~~carton_tot~~",left( lstrparms.String_Arg[28],30))
lsFormatUCC_128_Lowes = uf_Replace(lsFormatUCC_128_Lowes,"~~tot_off~~",left( lstrparms.String_Arg[29],30))
lsFormatUCC_128_Lowes = uf_Replace(lsFormatUCC_128_Lowes,"~~tot~~",left( lstrparms.String_Arg[30],30))
lsFormatUCC_128_Lowes = uf_Replace(lsFormatUCC_128_Lowes,"~~alloc_qty~~",left( lstrparms.String_Arg[62],30) +" Piece")
lsFormatUCC_128_Lowes = uf_Replace(lsFormatUCC_128_Lowes,"~~today~~",string(today(),"mm/dd/yyyy hh:mm:ss "))

lsFormatUCC_128_Home_Depot = uf_Replace(lsFormatUCC_128_Home_Depot,"~~sku~~", left(Lstrparms.String_arg[20],20))//Sku
lsFormatUCC_128_Home_Depot = uf_Replace(lsFormatUCC_128_Home_Depot,"~~sku_bc~~", left(Lstrparms.String_arg[20],20))//Sku
lsFormatUCC_128_Home_Depot = uf_Replace(lsFormatUCC_128_Home_Depot,">;>=sku_bc>=", left(Lstrparms.String_arg[20],20)) 
lsFormatUCC_128_Home_Depot = uf_Replace(lsFormatUCC_128_Home_Depot,"~~upc~~",left( lstrparms.String_Arg[21],30))//Alternate Sku
lsFormatUCC_128_Home_Depot = uf_Replace(lsFormatUCC_128_Home_Depot,"~~invoice_no~~",left( lstrparms.String_Arg[23],30))//Order No
lsFormatUCC_128_Home_Depot = uf_Replace(lsFormatUCC_128_Home_Depot,"~~invoice_bc~~",left( lstrparms.String_Arg[23],30))//Order No
lsFormatUCC_128_Home_Depot = uf_Replace(lsFormatUCC_128_Home_Depot,">;>=invoice_bc>=",left(Lstrparms.String_arg[23],30))
lsFormatUCC_128_Home_Depot = uf_Replace(lsFormatUCC_128_Home_Depot,"~~carrier_name~~",left(lstrparms.String_Arg[24],30))//Carrier

//30-Nov-2018 :Madhu S26642 Add Assign Carrier Pro for Home Depo Labels - START
IF Pos(lstrparms.String_Arg[24], 'ABF') > 0 THEN
	lsFormatUCC_128_Home_Depot = uf_Replace(lsFormatUCC_128_Home_Depot,"~~pro~~",left( lstrparms.String_Arg[26],30))
	lsFormatUCC_128_Home_Depot = uf_Replace(lsFormatUCC_128_Home_Depot,"~~pro_bc~~", left(Lstrparms.String_arg[26],30))
ELSE
	lsFormatUCC_128_Home_Depot = uf_Replace(lsFormatUCC_128_Home_Depot,"~~pro~~","")
	lsFormatUCC_128_Home_Depot = uf_Replace(lsFormatUCC_128_Home_Depot, ls_replace_home_depot_data, "^FD^FS")
END IF
//30-Nov-2018 :Madhu S26642 Add Assign Carrier Pro for Home Depo Labels - END

lsFormatUCC_128_Home_Depot = uf_Replace(lsFormatUCC_128_Home_Depot,"~~carton_no_readable~~", left(Lstrparms.String_arg[48],20))
lsFormatUCC_128_Home_Depot = uf_Replace(lsFormatUCC_128_Home_Depot,"~~carton_no_BC~~", left(Lstrparms.String_arg[48],20)) 
lsFormatUCC_128_Home_Depot = uf_Replace(lsFormatUCC_128_Home_Depot,">;>=carton_no_BC>=", left(Lstrparms.String_arg[48],20)) 
lsFormatUCC_128_Home_Depot = uf_Replace(lsFormatUCC_128_Home_Depot,"~~ship_to_zip~~", left(Lstrparms.String_arg[33],20))
lsFormatUCC_128_Home_Depot = uf_Replace(lsFormatUCC_128_Home_Depot,"~~ship_to_zip_BC~~", left(Lstrparms.String_arg[33],20))
lsFormatUCC_128_Home_Depot = uf_Replace(lsFormatUCC_128_Home_Depot,">;>=ship_to_zip>=", left(Lstrparms.String_arg[33],20)) 
lsFormatUCC_128_Home_Depot = uf_Replace(lsFormatUCC_128_Home_Depot,"~~carton_tot~~",left( lstrparms.String_Arg[28],30))
lsFormatUCC_128_Home_Depot = uf_Replace(lsFormatUCC_128_Home_Depot,"~~tot_off~~",left( lstrparms.String_Arg[29],30))
lsFormatUCC_128_Home_Depot = uf_Replace(lsFormatUCC_128_Home_Depot,"~~tot~~",left( lstrparms.String_Arg[30],30))
lsFormatUCC_128_Home_Depot = uf_Replace(lsFormatUCC_128_Home_Depot,"~~alloc_qty~~",left( lstrparms.String_Arg[62],30) +" Piece")
lsFormatUCC_128_Home_Depot = uf_Replace(lsFormatUCC_128_Home_Depot,"~~today~~",string(today(),"mm/dd/yyyy hh:mm:ss "))
lsFormatUCC_128_Home_Depot = uf_Replace(lsFormatUCC_128_Home_Depot,"~~ship_date~~",string(today(),"mm/dd/yyyy"))

If Not isNull(lstrparms.String_Arg[45]) then
	lsFormatUCC_128_Home_Depot = uf_Replace(lsFormatUCC_128_Home_Depot,"~~Serial_No~~",left( lstrparms.String_Arg[45],40))
	lsFormatUCC_128_Home_Depot = uf_Replace(lsFormatUCC_128_Home_Depot,"~~Serial_No_bc~~",left( lstrparms.String_Arg[45],40))
	lsFormatUCC_128_Home_Depot = uf_Replace(lsFormatUCC_128_Home_Depot,">;>=Serial_No_bc>=", left(Lstrparms.String_arg[45],40)) 
Else 
	lsFormatUCC_128_Home_Depot = uf_Replace(lsFormatUCC_128_Home_Depot,"~~Serial_No~~",'')
End If

If Not isNull(lstrparms.String_Arg[46]) then
	lsFormatUCC_128_Home_Depot = uf_Replace(lsFormatUCC_128_Home_Depot,"~~user_field5~~",left( lstrparms.String_Arg[46],40))
	lsFormatUCC_128_Home_Depot = uf_Replace(lsFormatUCC_128_Home_Depot,"~~user_field5_bc~~",left( lstrparms.String_Arg[46],40))
	lsFormatUCC_128_Home_Depot = uf_Replace(lsFormatUCC_128_Home_Depot,">;>=user_field5_bc>=", left(Lstrparms.String_arg[46],40)) 
Else 
	lsFormatUCC_128_Home_Depot = uf_Replace(lsFormatUCC_128_Home_Depot,"~~user_field5~~",'')
End If

If Not isNull(lstrparms.String_Arg[47]) then
	lsFormatUCC_128_Home_Depot = uf_Replace(lsFormatUCC_128_Home_Depot,"~~delivery_date~~",left( lstrparms.String_Arg[47],40))
Else 
	lsFormatUCC_128_Home_Depot = uf_Replace(lsFormatUCC_128_Home_Depot,"~~delivery_date~~",'')
End If
//lsGs1_Bestbuy = uf_Replace(lsGs1_Bestbuy,"~~sku~~", left(Lstrparms.String_arg[20],20))//Sku
//lsGs1_Bestbuy = uf_Replace(lsGs1_Bestbuy,"~~upc~~",left( lstrparms.String_Arg[21],30))//Alternate Sku
//lsGs1_Bestbuy = uf_Replace(lsGs1_Bestbuy,"~~invoice_no~~",left( lstrparms.String_Arg[23],30))//Order No
//lsGs1_Bestbuy = uf_Replace(lsGs1_Bestbuy,"~~invoice_bc~~",left( lstrparms.String_Arg[23],30))//Order No
//lsGs1_Bestbuy = uf_Replace(lsGs1_Bestbuy,">;>=invoice_bc>=",left(Lstrparms.String_arg[23],30))
//lsGs1_Bestbuy = uf_Replace(lsGs1_Bestbuy,"~~carrier_name~~",left(lstrparms.String_Arg[24],30))//Carrier
//lsGs1_Bestbuy = uf_Replace(lsGs1_Bestbuy,"~~pro~~",left( lstrparms.String_Arg[26],30))
//lsGs1_Bestbuy = uf_Replace(lsGs1_Bestbuy,"~~pro_bc~~", left(Lstrparms.String_arg[26],30))
//lsGs1_Bestbuy = uf_Replace(lsGs1_Bestbuy,">;>=pro_bc>=", left(Lstrparms.String_arg[26],30))
//lsGs1_Bestbuy = uf_Replace(lsGs1_Bestbuy,"~~carton_no_readable~~", left(Lstrparms.String_arg[48],20))
//lsGs1_Bestbuy = uf_Replace(lsGs1_Bestbuy,">;>=carton_no_BC>=", left(Lstrparms.String_arg[48],20)) 
//lsGs1_Bestbuy = uf_Replace(lsGs1_Bestbuy,"~~ship_to_zip~~", left(Lstrparms.String_arg[33],20))
//lsGs1_Bestbuy = uf_Replace(lsGs1_Bestbuy,"~~ship_to_zip_BC~~", left(Lstrparms.String_arg[33],20))
//lsGs1_Bestbuy = uf_Replace(lsGs1_Bestbuy,">;>=ship_to_zip>=", left(Lstrparms.String_arg[33],20)) 
//lsGs1_Bestbuy = uf_Replace(lsGs1_Bestbuy,"~~carton_tot~~",left( lstrparms.String_Arg[28],30))
//lsGs1_Bestbuy = uf_Replace(lsGs1_Bestbuy,"~~tot_off~~",left( lstrparms.String_Arg[29],30))
//lsGs1_Bestbuy = uf_Replace(lsGs1_Bestbuy,"~~tot~~",left( lstrparms.String_Arg[30],30))
//lsGs1_Bestbuy = uf_Replace(lsGs1_Bestbuy,"~~alloc_qty~~",left( lstrparms.String_Arg[62],30) +" Piece")
//lsGs1_Bestbuy = uf_Replace(lsGs1_Bestbuy,"~~today~~",string(today(),"mm/dd/yyyy hh:mm:ss "))


//Sears Part
lsPart_Sears = uf_Replace(lsPart_Sears,"~~sku~~", left(Lstrparms.String_arg[20],20))
lsPart_Sears = uf_Replace(lsPart_Sears,"~~upc~~",left( lstrparms.String_Arg[21],30))//Alternate Sku
lsPart_Sears = uf_Replace(lsPart_Sears,"~~Dept~~",left( lstrparms.String_Arg[40],30))//Department
lsPart_Sears = uf_Replace(lsPart_Sears,"~~store~~",left( lstrparms.String_Arg[42],30))//Store
lsPart_Sears = uf_Replace(lsPart_Sears,"~~store_bc~~",left( lstrparms.String_Arg[42],30))//Store
lsPart_Sears = uf_Replace(lsPart_Sears,">=store_bc>=", left('1 ' + Lstrparms.String_arg[42],20))//Store BC

//Tracking Label 
lsTracking = uf_Replace(lsTracking,"~~pro~~",left( lstrparms.String_Arg[26],30))
lsTracking = uf_Replace(lsTracking,"~~pro_bc~~", left(Lstrparms.String_arg[26],30))
lsTracking = uf_Replace(lsTracking,">;>=pro_bc>=", left(Lstrparms.String_arg[26],30))

	If lstrparms.String_Arg[60] = 'SEARSPART' then
		Lstrparms.String_arg[58] = lsPart_Sears
	ElseIf lstrparms.String_Arg[60] = 'SEARS_UCC' then
		Lstrparms.String_arg[58] = lsFormatUCC_128_Sears
		Lstrparms.String_arg[59] = lsTracking   //Tracking as Second label	
	ElseIf lstrparms.String_Arg[60] = 'BESTBUY_UCC' then
		Lstrparms.String_arg[58] = lsFormatUCC_128_BestBuy
	//ElseIf lstrparms.String_Arg[60] = 'BESTBUY_GS1' then
		//	PrintSend(llPrintJob,lsFormatUCC_GS1_BestBuy) //Best Buy Gs1	
		//	PrintSend(llPrintJob,lsProLabel) //ProLabel as 2nd label	
	ElseIf lstrparms.String_Arg[60] = 'LOWES_UCC' then
		Lstrparms.String_arg[58] = lsFormatUCC_128_Lowes
	ElseIf lstrparms.String_Arg[60] = 'THD_UCC' then
		Lstrparms.String_arg[58] = lsFormatUCC_128_Home_Depot
		Lstrparms.String_arg[59] = lsProLabel   //Standard as Second label	- TAM 2018/09 - S23898
	Else 
		Lstrparms.String_arg[58] = lsProLabel
	End if

return Lstrparms



end function

public function integer uf_rema_ship (any as_any);//02-JULY-2018 :Madhu S20885 F8792 Print Shipping Label

Str_parms	lStrparms
String		lsFormatUCC_128,	&
			lsCartonBarcode,	&
			lsTemp,				&
			lsPrintText,		&
			lsAddr,ls_weight,ls_temp,	&
			lsUCCCarton,ls_ucc, lsSKU, lsUPC

Long	llPrintJob,	&
		llPos,		&
		llPrintQty,	&
		llCount,	&
		llCartonNo,	&
		llAddrPos,i,j,ll_no_of_copies
		
Integer	liFileNo, liCheck
string ls_label_type	

lStrparms = as_any


//Only read the format from server once...
If isRemaShipLabelFormat = '' or isnull(isRemaShipLabelFormat) Then
	isRemaShipLabelFormat = uf_read_label_Format('rema_zebra_ship.txt') 
End If
	
lsFormatUCC_128 = isRemaShipLabelFormat
	
//Open Printer File 
llPrintJob = PrintOpen(lsPrintText)
	
If llPrintJob <0 Then 
	Messagebox('Labels', 'Unable to open Printer file. Labels will not be printed')
	Return -1
End If


//From Address - Roll up addresses if not all present
llAddrPos = 0

If lstrparms.String_Arg[2] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + "~~" //Customer WH Name
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,lsAddr,Left(lstrparms.String_Arg[2],30))
End If
	
If lstrparms.String_Arg[3] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + "~~" //Address1
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,lsAddr,Left(lstrparms.String_Arg[3],30))
End If

If lstrparms.String_Arg[4] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + "~~" //Address2
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,lsAddr,Left(lstrparms.String_Arg[4],30))
	
End If

If lstrparms.String_Arg[5] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + "~~" //Address3
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,lsAddr,Left(lstrparms.String_Arg[5],30))
	
End If

If lstrparms.String_Arg[6] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + "~~" //Address4
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,lsAddr,Left(lstrparms.String_Arg[6],30))
	
End If

If lstrparms.String_Arg[7] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + "~~" //Address5
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,lsAddr,Left(lstrparms.String_Arg[7],30))
	
End If

//To Address - Roll up addresses if not all present
llAddrPos = 0

If lstrparms.String_Arg[12] > ' ' Then
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~" //Warehouse Name
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,lsAddr,Left(lstrparms.String_Arg[12],45))

End If

If lstrparms.String_Arg[13] > ' ' Then
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~" //Address1
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,lsAddr,Left(lstrparms.String_Arg[13],45))

End If

If lstrparms.String_Arg[14] > ' ' Then
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~" //Address2
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,lsAddr,left(lstrparms.String_Arg[14],45))

End If

If lstrparms.String_Arg[15] > ' ' Then
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~" //Address3
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,lsAddr,Left(lstrparms.String_Arg[15],45))

End If

If lstrparms.String_Arg[16] > ' ' Then //Address4
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~"
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,lsAddr,left(lstrparms.String_Arg[16],45))
	
End If

If lstrparms.String_Arg[17] > ' ' Then //Address5
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~"
	lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,lsAddr,left(lstrparms.String_Arg[17],45))
	
End If


lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~gtin~~", left(lstrparms.String_Arg[19],20)) //GTIN
lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~sku~~",left( lstrparms.String_Arg[20],30)) //SKU
lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~pack_lot_no~~",left( lstrparms.String_Arg[21],30)) //Pack Lot No
lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~exp_date~~",left( lstrparms.String_Arg[22],30)) //Expiration Date
lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~qty~~",left( lstrparms.String_Arg[23],30))  //Qty
lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~description~~",left( lstrparms.String_Arg[24],30)) //Description

lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~pack_sscc_no~~",left( lstrparms.String_Arg[25],30)) //Pack SSCC No
lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,">;>=pack_sscc_no_bc>=",left( lstrparms.String_Arg[25],30)) //Pack SSCC No

lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~concatenate~~", lstrparms.String_Arg[26]) //First Barcode
lsFormatUCC_128 = uf_Replace(lsFormatUCC_128,"~~concatenate_bc~~", lstrparms.String_Arg[27]) //First Barcode



PrintSend(llPrintJob, lsFormatUCC_128)	

PrintClose(llPrintJob)

Return 0



end function

public function integer uf_bosch_sscc_zebra (any as_any);


Str_parms	lStrparms
String	lsFormat_sscc_label,	&
			lsFormat_Toys_R_US_UCC_128, &
			lsFormat_Toys_R_US_UCC_128_EU, &
			lsPrintText,		&
			lsAddr, &
			ls_custname,lsSSCCCarton

Long	llPrintJob,	&
		llAddrPos,i,j,ll_no_of_copies
		
int liCheck
		

//lstrparms = getparms()
lstrparms = as_any
// Begin Dinesh - 03/28/2023- SIMS-168 - SIMS - BOSCH COSTCO SSCC LABEL

if  isnull(lstrparms.String_Arg[38]) or  lstrparms.String_Arg[38]='' then
	messagebox('Label print SSCC',"This customer does not exists, Please add this customer first to print the SSCC Labels")
	return 0
end if
	
if lstrparms.String_Arg[38]='5010010306' or lstrparms.String_Arg[38]='5010011702' or lstrparms.String_Arg[38]='5010010424' or  lstrparms.String_Arg[38]='5010014084' or lstrparms.String_Arg[38]='5010011598'  then // Dinesh - 04/19/2023- SIMS-216 - SIMS - BOSCH SSCC LABEL
	
	lsFormat_sscc_label = uf_read_label_Format('bosch_sscc_ship_label_print_lowes.txt')
	
//elseif  lstrparms.String_Arg[38]='5010142573' then // Dinesh - 04/13/2023 -SIMS-168 - SIMS - BOSCH COSTCO SSCC LABEL
	//lsFormat_sscc_label = uf_read_label_Format('bosch_sscc_ship_label_print_costco.txt') // Dinesh - 04/13/2023 -SIMS-168 - SIMS - BOSCH COSTCO SSCC LABEL
else
	lsFormat_sscc_label = uf_read_label_Format('bosch_sscc_ship_label_print_costco.txt') // Dinesh - 04/13/2023 -SIMS-168 - SIMS - BOSCH COSTCO SSCC LABEL
end if// Dinesh - 07/19/2023 -SIMS-168 - SIMS - BOSCH COSTCO SSCC LABEL// Need to make this available for all customers

// End Dinesh - 03/28/2023- SIMS-168 - SIMS - BOSCH COSTCO SSCC LABEL
//lsFormat_Toys_R_US_UCC_128 = uf_read_label_Format('Anki_Toys_R_US_SSCC18_Label.txt')

//TAM 08/2015 - Added European TRU label.  Cloned below fro existing TRU label. TRU EU label needs 2 additional fields not on TRU label. 
//lsFormat_Toys_R_US_UCC_128_EU = uf_read_label_Format('Anki_Toys_R_US_SSCC18_EU_Label.txt') 


//Open Printer File 
llPrintJob = PrintOpen(lsPrintText)
	
If llPrintJob <0 Then 
	Messagebox('Labels', 'Unable to open Printer file. Labels will not be printed')
	Return -1
End If


//From Address - Roll up addresses if not all present
llAddrPos = 0

If lstrparms.String_Arg[2] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + "~~"
	lsFormat_sscc_label = uf_Replace(lsFormat_sscc_label,lsAddr,Left(lstrparms.String_Arg[2],30))
//	lsFormat_Toys_R_US_UCC_128 = uf_Replace(lsFormat_Toys_R_US_UCC_128,lsAddr,Left(lstrparms.String_Arg[2],30))
//	lsFormat_Toys_R_US_UCC_128_EU = uf_Replace(lsFormat_Toys_R_US_UCC_128_EU,lsAddr,Left(lstrparms.String_Arg[2],30))
End If
	
If lstrparms.String_Arg[3] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + "~~"
	lsFormat_sscc_label = uf_Replace(lsFormat_sscc_label,lsAddr,Left(lstrparms.String_Arg[3],30))
//	lsFormat_Toys_R_US_UCC_128 = uf_Replace(lsFormat_Toys_R_US_UCC_128,lsAddr,Left(lstrparms.String_Arg[3],30))
//	lsFormat_Toys_R_US_UCC_128_EU = uf_Replace(lsFormat_Toys_R_US_UCC_128_EU,lsAddr,Left(lstrparms.String_Arg[3],30))
End If

If lstrparms.String_Arg[4] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + "~~"
	lsFormat_sscc_label = uf_Replace(lsFormat_sscc_label,lsAddr,Left(lstrparms.String_Arg[4],30))
//	lsFormat_Toys_R_US_UCC_128 = uf_Replace(lsFormat_Toys_R_US_UCC_128,lsAddr,Left(lstrparms.String_Arg[4],30))
//	lsFormat_Toys_R_US_UCC_128_EU = uf_Replace(lsFormat_Toys_R_US_UCC_128_EU,lsAddr,Left(lstrparms.String_Arg[4],30))
End If

If lstrparms.String_Arg[5] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + "~~"
	lsFormat_sscc_label = uf_Replace(lsFormat_sscc_label,lsAddr,Left(lstrparms.String_Arg[5],30))
//	lsFormat_Toys_R_US_UCC_128 = uf_Replace(lsFormat_Toys_R_US_UCC_128,lsAddr,Left(lstrparms.String_Arg[5],30))
//	lsFormat_Toys_R_US_UCC_128_EU = uf_Replace(lsFormat_Toys_R_US_UCC_128_EU,lsAddr,Left(lstrparms.String_Arg[5],30))
End If

If lstrparms.String_Arg[6] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + "~~"
	lsFormat_sscc_label = uf_Replace(lsFormat_sscc_label,lsAddr,Left(lstrparms.String_Arg[6],30))
//	lsFormat_Toys_R_US_UCC_128 = uf_Replace(lsFormat_Toys_R_US_UCC_128,lsAddr,Left(lstrparms.String_Arg[6],30))
//	lsFormat_Toys_R_US_UCC_128_EU = uf_Replace(lsFormat_Toys_R_US_UCC_128_EU,lsAddr,Left(lstrparms.String_Arg[6],30))
End If

If lstrparms.String_Arg[7] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + "~~"
	lsFormat_sscc_label = uf_Replace(lsFormat_sscc_label,lsAddr,Left(lstrparms.String_Arg[7],30))
//	lsFormat_Toys_R_US_UCC_128 = uf_Replace(lsFormat_Toys_R_US_UCC_128,lsAddr,Left(lstrparms.String_Arg[7],30))
//	lsFormat_Toys_R_US_UCC_128_EU = uf_Replace(lsFormat_Toys_R_US_UCC_128_EU,lsAddr,Left(lstrparms.String_Arg[7],30))
End If

lsFormat_sscc_label = uf_Replace(lsFormat_sscc_label,"~~carrier_pro_no~~",left(lstrparms.String_Arg[11],30))	
lsFormat_sscc_label = uf_Replace(lsFormat_sscc_label,">;>=carrier_pro_no_bc>=", left(Lstrparms.String_arg[11],30))  

//lsFormat_Toys_R_US_UCC_128 = uf_Replace(lsFormat_Toys_R_US_UCC_128,"~~carrier_pro_no~~",left(lstrparms.String_Arg[11],30))	
//lsFormat_Toys_R_US_UCC_128_EU = uf_Replace(lsFormat_Toys_R_US_UCC_128_EU,"~~carrier_pro_no~~",left(lstrparms.String_Arg[11],30))	
//
//To Address - Roll up addresses if not all present
llAddrPos = 0

If lstrparms.String_Arg[13] > ' ' Then
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~" //Warehouse Name
	lsFormat_sscc_label = uf_Replace(lsFormat_sscc_label,lsAddr,Left(lstrparms.String_Arg[13],45))
//	lsFormat_Toys_R_US_UCC_128 = uf_Replace(lsFormat_Toys_R_US_UCC_128,lsAddr,Left(lstrparms.String_Arg[13],45))
//	lsFormat_Toys_R_US_UCC_128_EU = uf_Replace(lsFormat_Toys_R_US_UCC_128_EU,lsAddr,Left(lstrparms.String_Arg[13],45))
End If

If lstrparms.String_Arg[14] > ' ' Then
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~" //Address1
	lsFormat_sscc_label = uf_Replace(lsFormat_sscc_label,lsAddr,Left(lstrparms.String_Arg[14],45))
//	lsFormat_Toys_R_US_UCC_128 = uf_Replace(lsFormat_Toys_R_US_UCC_128,lsAddr,Left(lstrparms.String_Arg[14],45))
//	lsFormat_Toys_R_US_UCC_128_EU = uf_Replace(lsFormat_Toys_R_US_UCC_128_EU,lsAddr,Left(lstrparms.String_Arg[14],45))
End If

If lstrparms.String_Arg[15] > ' ' Then
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~" //Address2
	lsFormat_sscc_label = uf_Replace(lsFormat_sscc_label,lsAddr,left(lstrparms.String_Arg[15],45))
//	lsFormat_Toys_R_US_UCC_128 = uf_Replace(lsFormat_Toys_R_US_UCC_128,lsAddr,left(lstrparms.String_Arg[15],45))
//	lsFormat_Toys_R_US_UCC_128_EU = uf_Replace(lsFormat_Toys_R_US_UCC_128_EU,lsAddr,left(lstrparms.String_Arg[15],45))
End If

If lstrparms.String_Arg[16] > ' ' Then
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~" //Address3
	lsFormat_sscc_label = uf_Replace(lsFormat_sscc_label,lsAddr,Left(lstrparms.String_Arg[16],45))
//	lsFormat_Toys_R_US_UCC_128 = uf_Replace(lsFormat_Toys_R_US_UCC_128,lsAddr,Left(lstrparms.String_Arg[16],45))
//	lsFormat_Toys_R_US_UCC_128_EU = uf_Replace(lsFormat_Toys_R_US_UCC_128_EU,lsAddr,Left(lstrparms.String_Arg[16],45))
End If

If lstrparms.String_Arg[17] > ' ' Then //Address4
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~"
	lsFormat_sscc_label = uf_Replace(lsFormat_sscc_label,lsAddr,left(lstrparms.String_Arg[17],45))
//	lsFormat_Toys_R_US_UCC_128 = uf_Replace(lsFormat_Toys_R_US_UCC_128,lsAddr,left(lstrparms.String_Arg[17],45))
//	lsFormat_Toys_R_US_UCC_128_EU = uf_Replace(lsFormat_Toys_R_US_UCC_128_EU,lsAddr,left(lstrparms.String_Arg[17],45))
End If

If lstrparms.String_Arg[18] > ' ' Then //Address5
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~"
	lsFormat_sscc_label = uf_Replace(lsFormat_sscc_label,lsAddr,left(lstrparms.String_Arg[18],45))
//	lsFormat_Toys_R_US_UCC_128 = uf_Replace(lsFormat_Toys_R_US_UCC_128,lsAddr,left(lstrparms.String_Arg[18],45))
//	lsFormat_Toys_R_US_UCC_128_EU = uf_Replace(lsFormat_Toys_R_US_UCC_128_EU,lsAddr,left(lstrparms.String_Arg[18],45))
End If
	
//Carrier ,bol, prono, pono related information
lsFormat_sscc_label = uf_Replace(lsFormat_sscc_label,"~~Carrier_name~~",left(lstrparms.String_Arg[24],30))
lsFormat_sscc_label = uf_Replace(lsFormat_sscc_label,"~~pro~~",left(lstrparms.String_Arg[11],30))
lsFormat_sscc_label = uf_Replace(lsFormat_sscc_label,"~~bol_nbr~~",left( lstrparms.String_Arg[10],30))
lsFormat_sscc_label = uf_Replace(lsFormat_sscc_label,">;>=bol_nbr_bc>=", left(Lstrparms.String_arg[10],30)) 
lsFormat_sscc_label = uf_Replace(lsFormat_sscc_label,"~~invoice_no~~",left(lstrparms.String_Arg[23],30))
lsFormat_sscc_label = uf_Replace(lsFormat_sscc_label,"~~alloc_qty~~",left(lstrparms.String_Arg[31],30))

//SSCC related information
lsFormat_sscc_label = uf_Replace(lsFormat_sscc_label,"~~carton_no_readable~~", left(Lstrparms.String_arg[30],20))
lsFormat_sscc_label = uf_Replace(lsFormat_sscc_label,">;>=carton_no_bc>=", left(Lstrparms.String_arg[30],20)) 


//lsFormat_Toys_R_US_UCC_128 = uf_Replace(lsFormat_Toys_R_US_UCC_128,"~~carton_no_readable~~", left(Lstrparms.String_arg[30],20))
//lsFormat_Toys_R_US_UCC_128 = uf_Replace(lsFormat_Toys_R_US_UCC_128,">;>=carton_no_bc>=", left(Lstrparms.String_arg[30],20)) 
//
//lsFormat_Toys_R_US_UCC_128_EU = uf_Replace(lsFormat_Toys_R_US_UCC_128_EU,"~~carton_no_readable~~", left(Lstrparms.String_arg[30],20))
//lsFormat_Toys_R_US_UCC_128_EU = uf_Replace(lsFormat_Toys_R_US_UCC_128_EU,">;>=carton_no_bc>=", left(Lstrparms.String_arg[30],20)) 

//ship To zip and barcode related information
lsFormat_sscc_label = uf_Replace(lsFormat_sscc_label,"~~ship_to_Zip~~", left(Lstrparms.String_arg[33],20))
lsFormat_sscc_label = uf_Replace(lsFormat_sscc_label,">;>=ship_to_zip_bc>=", left(Lstrparms.String_arg[33],20)) 


	lsFormat_sscc_label = uf_Replace(lsFormat_sscc_label,"~~upc~~",left(lstrparms.String_Arg[20],30)) //print SKU value



//lsFormat_sscc_label = uf_Replace(lsFormat_sscc_label,"~~carton_count~~",left( lstrparms.String_Arg[34],30))
//lsFormat_sscc_label = uf_Replace(lsFormat_sscc_label,"~~carton_total~~",left( lstrparms.String_Arg[35],30))
lsFormat_sscc_label = uf_Replace(lsFormat_sscc_label,"~~qty_count~~",left( lstrparms.String_Arg[34],30))
lsFormat_sscc_label = uf_Replace(lsFormat_sscc_label,"~~qty_total~~",left( lstrparms.String_Arg[35],30))
lsFormat_sscc_label = uf_Replace(lsFormat_sscc_label,"~~alternate_sku~~",left(lstrparms.String_Arg[25],45)) // Dinesh - 07/24/2023- SIMS-168-SIMS BOSCH SSCC LABEL
lsFormat_sscc_label = uf_Replace(lsFormat_sscc_label,"~~user_field21~~",left(lstrparms.String_Arg[26],45)) // Dinesh - 07/24/2023- SIMS-168-SIMS BOSCH SSCC LABEL


// TAM 08/2015 - Added 2 new Fields
lsFormat_sscc_label = uf_Replace(lsFormat_sscc_label,"~~cust_code~~",Right(lstrparms.String_Arg[60],5)) // Dinesh - 10/25/2022- SIMS-107-SIMS BOSCH SSCC LABEL
lsFormat_sscc_label = uf_Replace(lsFormat_sscc_label,">;>=cust_code_no>=",left( lstrparms.String_Arg[38],30)) // - 10/25/2022 - SIMS-107-SIMS BOSCH SSCC LABEL
//alternate SKU - Costco customer
lsFormat_sscc_label = uf_Replace(lsFormat_sscc_label,"~~user_field1~~",left( lstrparms.String_Arg[37],30))  // Dinesh - 03/28/2023- SIMS-168- SIMS - BOSCH COSTCO SSCC LABEL
lsFormat_sscc_label = uf_Replace(lsFormat_sscc_label,">;>=alternate_sku_ddetail>=",left(lstrparms.String_Arg[25],45))    // Dinesh - 03/28/2023- SIMS-168- SIMS - BOSCH COSTCO SSCC LABEL
//lsFormat_sscc_label = uf_Replace(lsFormat_sscc_label,"~~cust_name~~",left( lstrparms.String_Arg[60],30)) 
lsFormat_sscc_label = uf_Replace(lsFormat_sscc_label,"~~cust_name~~",Right(lstrparms.String_Arg[60],5)) 
//left(w_do.idw_Main.GetITemString(1,'Cust_Code'),7)
//lsFormat_sscc_label = uf_Replace(lsFormat_sscc_label,"~~mfg_part~~",left( lstrparms.String_Arg[37],30))
//lsFormat_sscc_label = uf_Replace(lsFormat_sscc_label,"~~stock_keep_nbr~~",left( lstrparms.String_Arg[38],30))


//lsFormat_Toys_R_US_UCC_128 = uf_Replace(lsFormat_Toys_R_US_UCC_128,"~~mfg_part~~",left( lstrparms.String_Arg[37],30))
//lsFormat_Toys_R_US_UCC_128 = uf_Replace(lsFormat_Toys_R_US_UCC_128,"~~stock_keep_nbr~~",left( lstrparms.String_Arg[38],30))
//
//lsFormat_Toys_R_US_UCC_128_EU = uf_Replace(lsFormat_Toys_R_US_UCC_128_EU,"~~mfg_part~~",left(lstrparms.String_Arg[37],30))
//lsFormat_Toys_R_US_UCC_128_EU = uf_Replace(lsFormat_Toys_R_US_UCC_128_EU,"~~stock_keep_nbr~~",left(lstrparms.String_Arg[38],30))

//Carton no (SSCC Label) - 
//If  lstrparms.String_Arg[35] > '' Then
//	lsSSCCCarton = "0" + lstrparms.String_Arg[35] + Right(String(Long(lstrparms.String_Arg[12]),'000000000'),9) /*Prepend UCCS Info - 0 (futire use) + Warehouse Prefix + Company Prefix) */		
//	liCheck = f_calc_uccs_check_Digit(lsSSCCCarton) /*calculate the check digit*/
//	If liCheck >=0 Then
//		lsSSCCCarton = "00" + lsSSCCCarton + String(liCheck) /* add 00 at beginning (not part of check digit calculation but included as tag */
//	Else
//		lsSSCCCarton = String(Long(lstrparms.String_Arg[12]),'00000000000000000000')
//	End If
//Else
//	lsSSCCCarton = String(Long(lstrparms.String_Arg[12]),'00000000000000000000')
//End If

//print no of copies
ll_no_of_copies = lstrparms.Long_Arg[1]
FOR i= 1 TO ll_no_of_copies

		PrintSend(llPrintJob, lsFormat_sscc_label)
	//END IF
//END IF
NEXT
PrintClose(llPrintJob)

Return 0


//14-Oct-2014 : Madhu- comented for ANKI- We designed a new custom label for ANKI
//This function will print  Anki UCCS Shipping label

/*Str_parms	lStrparms
String	lsFormat,	&
			lsCartonBarcode,	&
			lsTemp,				&
			lsPrintText,		&
			lsAddr,ls_weight,ls_temp,	&
			lsUCCCarton

Long	llPrintJob,	&
		llPos,		&
		llPrintQty,	&
		llPrintPos,	&
		llCartonNo,	&
		llAddrPos,i,j,ll_no_of_copies
		
Integer	liFileNo, liCheck


lstrparms = as_array

lsFormat = uf_read_label_Format('anki_zebra_ship_UCC.DWN') 
		
	
lsPrintText = 'UCCS Ship - Zebra'


//Open Printer File 
llPrintJob = PrintOpen(lsPrintText)
	
If llPrintJob <0 Then 
	Messagebox('Labels', 'Unable to open Printer file. Labels will not be printed')
	Return -1
End If

//We are looping once for each Qty of label being printed - The carton number is changing so we need to bump after each one.
//Replace placeholders in Format with Field Values

//From Address - Roll up addresses if not all present
	
llAddrPos = 0

If lstrparms.String_Arg[2] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + ",0030~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[2],30))
End If
	
If lstrparms.String_Arg[3] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + ",0030~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[3],30))
End If

If lstrparms.String_Arg[4] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + ",0030~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[4],30))
End If

If lstrparms.String_Arg[5] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + ",0030~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[5],30))
End If
	
If lstrparms.String_Arg[31] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + ",0030~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[31],45))
End If
	
If lstrparms.String_Arg[6] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + ",0030~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[6],30))
End If

If lstrparms.String_Arg[29] > ' ' Then 
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + ",0030~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[29],45))
End If

//To Address - Roll up addresses if not all present

llAddrPos = 0

If lstrparms.String_Arg[7] > ' ' Then
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + ",0045~~" //Customer Name
	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[7],45))
End If

If lstrparms.String_Arg[8] > ' ' Then
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + ",0045~~" //Address1
	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[8],45))
End If

If lstrparms.String_Arg[9] > ' ' Then
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + ",0045~~" //Address2
	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[9],45))
End If

If lstrparms.String_Arg[10] > ' ' Then
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + ",0045~~" //Address3
	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[10],45))
End If

If lstrparms.String_Arg[32] > ' ' Then //Address4
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + ",0045~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[32],45))
End If

If lstrparms.String_Arg[11] > ' ' Then //City,state,zip
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + ",0045~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[11],45))
End If

If lstrparms.String_Arg[30] > ' ' Then //To Country
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + ",0045~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[30],45))
End If

//Ship To Post Code
lsFormat = uf_Replace(lsFormat,"~~ship_to_zip,0012~~",left(lstrparms.String_Arg[33],12)) /* 12/03 - PCONKL - For UCCS Label */
	
//Ship To Post Code (BARCODE)	
lsFormat = uf_Replace(lsFormat,"~~ship_to_zip_BC,0008~~",left(lstrparms.String_Arg[33],8)) /* 12/03 - PCONKL - For UCCS Label */
	
//Jxlim 05/25/2012 Jira SIM-705 for Riverbed
If gs_project ='RIVERBED' Then
	//AWB
	lsFormat = uf_Replace(lsFormat,"~~bol_nbr,0020~~",lstrparms.String_Arg[34]) /* 12/03 - PCONKL - For UCCS Label */
Else
	//AWB
	lsFormat = uf_Replace(lsFormat,"~~bol_nbr,0020~~",left(lstrparms.String_Arg[34],12)) /* 12/03 - PCONKL - For UCCS Label */
End If
		
//Carton no (UCCS Label) - 
If  lstrparms.String_Arg[35] > '' Then
	lsUCCCarton = "0" + lstrparms.String_Arg[35] + Right(String(Long(lstrparms.String_Arg[12]),'000000000'),9) /*Prepend UCCS Info - 0 (futire use) + Warehouse Prefix + Company Prefix) */		
	liCheck = f_calc_uccs_check_Digit(lsUCCCarton) /*calculate the check digit*/
	If liCheck >=0 Then
		lsuccCarton = "00" + lsUccCarton + String(liCheck) /* add 00 at beginning (not part of check digit calculation but included as tag */
	Else
		lsUccCarton = String(Long(lstrparms.String_Arg[12]),'00000000000000000000')
	End If
Else
	lsUccCarton = String(Long(lstrparms.String_Arg[12]),'00000000000000000000')
End If

IF gs_project = "MAQUET" THEN

	lsFormat = uf_Replace(lsFormat,"(00)","")
	lsFormat = uf_Replace(lsFormat,"~~carton_no_BC,0019~~",left(lstrparms.String_Arg[27],30))
	lsFormat = uf_Replace(lsFormat,"~~carton_no_readable,0018~~",left(lstrparms.String_Arg[27],30)) /* 00 already on label as text field but included in barcode*/

	
ELSE
	
	lsFormat = uf_Replace(lsFormat,"~~carton_no_BC,0019~~",lsUCCCarton)
	lsFormat = uf_Replace(lsFormat,"~~carton_no_readable,0018~~",Right(lsUCCCarton,18)) /* 00 already on label as text field but included in barcode*/
	
END IF
	
//Po No
//Jxlim 09/10/2014 Anki use dm.user_field14 instead of cust_ord_no for Ecommerce ID as non unique Anki cust order nbr
lsFormat = uf_Replace(lsFormat,"~~po_nbr,0030~~",lstrparms.String_Arg[36])

//Cust No
lsFormat = uf_Replace(lsFormat,"~~sku_no,0030~~",left(lstrparms.String_Arg[14],30))//Alternate sku

//Weight	
ls_weight = String(lstrparms.Long_Arg[5]) + "/" + String(lstrparms.Long_Arg[6])
lsFormat = uf_Replace(lsFormat,"~~weight,0008~~",ls_weight )
lsFormat = uf_Replace(lsFormat,"~~weight_lbs_no,0030~~",String(lstrparms.Long_Arg[5]))
lsFormat = uf_Replace(lsFormat,"~~weight_kgs_no,0030~~",String(lstrparms.Long_Arg[6]))
lsFormat = uf_Replace(lsFormat,"~~weight,0030~~",String(lstrparms.Long_Arg[5]) + "LBs / " + String(lstrparms.Long_Arg[6]) + "KGs") /* 12/03 - PCONKL - Weight for UCCS */
	

//Invoice NO
lsFormat = uf_Replace(lsFormat,"~~invoice_no,0030~~",Left(lstrparms.String_Arg[17],20))	

//Today's date 
lsFormat = uf_Replace(lsFormat,"~~today,0030~~",string(today(),"mmm dd, yyyy"))
	
//Carrier Name
lsFormat = uf_Replace(lsFormat,"~~carrier_name,0030~~",left(lstrparms.String_Arg[25],30))
	
//Tracking shipper No
lsFormat = uf_Replace(lsFormat,"~~tracker_id,0030~~",left(lstrparms.String_Arg[27],30))
	
//No of copies
ll_no_of_copies = lstrparms.Long_Arg[1]
FOR i= 1 TO ll_no_of_copies
	lsFormat = uf_Replace(lsFormat,"~~tot_off,0030~~",left(lstrparms.String_Arg[28],30))
	PrintSend(llPrintJob, lsformat)	
	ls_temp= lstrparms.String_Arg[28]
NEXT
	
PrintClose(llPrintJob)
	

Return 0

*/



end function

on n_labels.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_labels.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

