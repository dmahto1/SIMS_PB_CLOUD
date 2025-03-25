HA$PBExportHeader$n_label_phx_brands_mwl.sru
$PBExportComments$North West Iiquidators
forward
global type n_label_phx_brands_mwl from n_label_phx_brands
end type
end forward

global type n_label_phx_brands_mwl from n_label_phx_brands
end type
global n_label_phx_brands_mwl n_label_phx_brands_mwl

forward prototypes
public function integer print ()
public function integer setlabeladdress ()
end prototypes

public function integer print ();// int = print()

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

lsFormat = uf_read_label_Format( getLabelFormatFile() )	
if lsFormat = "" then return -1

setFormat( lsFormat )

lsPrintText = 'UCCS Ship - NWL Zebra'

//Open Printer File 
llPrintJob = PrintOpen(lsPrintText)
	
If llPrintJob <0 Then 
	Messagebox('Labels', 'Unable to open Printer file. Labels will not be printed')
	Return -1
End If

if setLabelAddress() < 0 then return -1
lsFormat = getFormat()

// Field C - Carrier ...
//Carrier Name - not used
//lsFormat = uf_Replace(lsFormat,"~~carrier_name~~",left(lstrparms.String_Arg[62],30))
// B/L
lsFormat = uf_Replace(lsFormat,"~~invoice~~",left(lstrparms.String_Arg[34],12))
// SCAC
lsFormat = uf_Replace(lsFormat,"~~scac~~", left(lstrparms.String_Arg[61],12))
// PRO Number
lsFormat = uf_Replace(lsFormat,"~~pro~~",left(lstrparms.String_Arg[45],15))

// Field D - Postal Zip
//Ship To Post Code
lsFormat = uf_Replace(lsFormat,"~~ship2postzip~~",left(lstrparms.String_Arg[33],12)) 
//Ship To Post Code (BARCODE)	
lsFormat = uf_Replace(lsFormat,"~~ship2postbarcode~~",left(lstrparms.String_Arg[33],8)) 
	
// Field E - Po Number
//Po No
lsFormat = uf_Replace(lsFormat,"~~custorderno~~",left(lstrparms.String_Arg[13],30)) 
// Po No Barcode
lsFormat = uf_Replace(lsFormat,"~~custorderno~~",left(lstrparms.String_Arg[13],30)) 
// NWL Vendor #
lsFormat = uf_Replace(lsFormat,"~~nwlvendor~~",left(lstrparms.String_Arg[50],30)) 

// Field F - QTY UPC
//Qty
lsFormat = uf_Replace(lsFormat,"~~QTY~~",lstrparms.string_arg[51] ,10)
// UPC - readable
lsFormat = uf_Replace(lsFormat,"~~upcreadable~~",lstrparms.string_arg[52] ,10)
// UPC Barcode
lsFormat = uf_Replace(lsFormat,"~~UPC~~",lstrparms.string_arg[52] ,10)
// Item Description
lsFormat = uf_Replace(lsFormat,"~~Description~~",lstrparms.string_arg[53] ,30)

// Field H - Store info
// Store
lsFormat = uf_Replace(lsFormat,"~~store~~",lstrparms.string_arg[54] ,3)
// Store Barcode
lsFormat = uf_Replace(lsFormat,"~~storebc~~",lstrparms.string_arg[54] ,3)

// Field I SSCC 18
setSSCCValues()
lsFormat = uf_Replace(lsFormat,"~~sscchr~~",getSSCCFormatted( ) )
lsFormat = uf_Replace(lsFormat,"~~sscc18bc~~",getSSCCRawData( ) )

//No of copies
ll_no_of_copies = lstrparms.Long_Arg[1]
FOR i= 1 TO ll_no_of_copies
	PrintSend(llPrintJob, lsformat)	
	ls_temp= lstrparms.String_Arg[28]
NEXT
		
PrintClose(llPrintJob)
	

Return 0


end function

public function integer setlabeladdress ();// int = setLabelAddress()

Str_parms		lStrparms
String			lsFormat
String			lsAddr
Long				llAddrPos
		
Integer	liFileNo, liCheck
string ls_label_type	

lstrparms = getparms()

lsFormat = getFormat() 

//Replace placeholders in Format with Field Values

//From Address - Roll up addresses if not all present
	
llAddrPos = 0

If lstrparms.String_Arg[2] > ' ' Then  // addr 1
	
	llAddrPos ++
	// 12/04 - PCONKL - Labelvision labels don't contain comma and field length in name
	lsAddr = "~~from_addr" + String(llAddrPos) + "~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[2],30))
	
End If
	
If lstrparms.String_Arg[3] > ' ' Then // addr 2
	
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + "~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[3],30))
	
End If

If lstrparms.String_Arg[4] > ' ' Then // addr 3
	
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + "~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[4],30))
	
End If

If lstrparms.String_Arg[5] > ' ' Then // addr 4
	
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + "~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[5],30))
	
End If
	
If lstrparms.String_Arg[6] > ' ' Then
	
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + "~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[6],30))
	
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

setFormat( lsFormat )

return 0

end function

on n_label_phx_brands_mwl.create
call super::create
end on

on n_label_phx_brands_mwl.destroy
call super::destroy
end on

event constructor;call super::constructor;setLabelFormatFile( 'NWL_phx_brands_zebra')

end event

