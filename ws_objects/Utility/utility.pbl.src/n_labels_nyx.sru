$PBExportHeader$n_labels_nyx.sru
$PBExportComments$Labels in native Printer Languages
forward
global type n_labels_nyx from nonvisualobject
end type
end forward

global type n_labels_nyx from nonvisualobject
end type
global n_labels_nyx n_labels_nyx

type variables
constant string isSSCC310 = '00885967'

integer iiLabelSequence
string isSSCCRawData
string isSSCCFormatted


str_parms istrparms

protected:
string isLabelFormatFile
string isFormat


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
public function integer uf_emu-ceo_receiving_label ()
public function integer uf_license_tag_lam (ref str_parms _parms)
public function integer uf_lam_zebra_ship (any as_array)
public function integer uf_epson_zebra_ship ()
public function integer uf_runworld_zebra_ship (any as_array)
public function integer uf_pallet_do_info (any as_array)
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
If gs_SysPath > '' Then
	lsFile = gs_syspath + 'labels\' + asformat_name
	//guido's local directory	gs_SysPath = "c:\pb7devl\sims32dev\" 
Else
	lsFile = 'labels\' + asformat_name
End If


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
	

//Expiration Date
lsFormat = uf_Replace(lsFormat,"~~dt_expire~~",Left(lstrparms.String_Arg[2],10))

//QTY
lsFormat = uf_Replace(lsFormat,"~~qty~~",Left(lstrparms.String_Arg[3],13))

//SKU
lsFormat = uf_Replace(lsFormat,"~~sku~~",Left(lstrparms.String_Arg[4],20))

//SKU Barcode
lsFormat = uf_Replace(lsFormat,"~~SKU_BARCODE~~",Left(lstrparms.String_Arg[4],20))

//Lot NBR
lsFormat = uf_Replace(lsFormat,"~~lot~~",Left(lstrparms.String_Arg[5],15))

//Container ID
lsFormat = uf_Replace(lsFormat,"~~tag~~",Right(lstrparms.String_Arg[6],10))

//TAM 2010/11/08  Add Container Barcode
lsFormat = uf_Replace(lsFormat,"~~tag_bc~~",Right(lstrparms.String_Arg[6],10))
 
//UOM
lsFormat = uf_Replace(lsFormat,"~~uom~~",Left(lstrparms.String_Arg[7],6))

//Location
lsFormat = uf_Replace(lsFormat,"~~misc_text2~~",Left(lstrparms.String_Arg[8],10))

//Description
lsFormat = uf_Replace(lsFormat,"~~sku_desc~~",Left(lstrparms.String_Arg[9],40))

//date Printed
lsFormat = uf_Replace(lsFormat,"~~dt_print~~",String(ldtToday,'MM/DD/YYYY'))

////Serial barcode
//lsFormat = uf_Replace(lsFormat,"~~SERIAL_BARCODE~~",Left(lstrparms.String_Arg[6],15))

//Location
lsFormat = uf_Replace(lsFormat,"~~loc~~",Left(lstrparms.String_Arg[8],15))

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

public function integer uf_emu-ceo_receiving_label ();//This function will print  a receiving label for EMU-CEO (Converse)

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

String		lsFormat
String		lsPrintText
Long			llPrintJob
long 			copies
int 			index
//
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


//SKU
if len(lstrparms.String_Arg[3]) > 0 then
	lsFormat = uf_Replace(lsFormat,"~~sku~~",Left(lstrparms.String_Arg[3],30))
else
	lsFormat = uf_Replace(lsFormat,"~~sku~~"," ")
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

Str_parms	lStrparms
String lsFormat 
STRING lsPrintText 
STRING lsDONO

Long	llPrintJob 
LONG  i = 0
LONG  ll_no_of_copies = 1
		
Integer	liFileNo, liCheck


lstrparms = as_array

lsDONO = lstrparms.String_arg[1]

lsFormat = uf_read_label_Format('pallet_do_info.txt') 
			
lsPrintText = 'Pallet DO Info - Zebra'

//Open Printer File 
llPrintJob = PrintOpen(lsPrintText)
	
If llPrintJob <0 Then 
	Messagebox('Labels', 'Unable to open Printer file. Labels will not be printed')
	Return -1
End If

//Replace placeholders in Format with Field Values
IF (NOT IsNull(lsDONO)) AND (TRIM(lsDONO) > '' ) THEN
	lsFormat = uf_replace( lsFormat, "~~DO_NO~~", lsDONO )
	lsFormat = uf_replace( lsFormat, "~~DO_NO_BC~~", lsDONO )
	lsFormat = uf_replace( lsFormat, "~~PRINT_DATE~~", STRING(DATE(TODAY())) )

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

on n_labels_nyx.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_labels_nyx.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

