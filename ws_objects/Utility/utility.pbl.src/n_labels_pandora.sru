$PBExportHeader$n_labels_pandora.sru
$PBExportComments$Labels in native Printer Languages
forward
global type n_labels_pandora from nonvisualobject
end type
end forward

global type n_labels_pandora from nonvisualobject
end type
global n_labels_pandora n_labels_pandora

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
public function string uf_read_label_format (string asformat_name)
public function string uf_replace (string asstring, string asoldvalue, string asnewvalue)
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
public function integer uf_sscc_zerbra_ship ()
public function string uf_replace_label_text (string asstring, string asoldvalue, string asnewvalue)
public function str_parms uf_split_serialno_by_length (str_parms as_str_serial_no, long al_length)
public function string uf_generate_sscc (string as_pallet_container_id)
public function integer uf_print_2d_barcode_label (str_parms astr_serial_parms, string as_sku, string as_wh, string as_pallet_container_id, string as_label_text)
public function long uf_print_label_data (string as_print_text, string as_print_data)
public function integer uf_print_google_shipping_label (any as_array)
public function integer uf_print_qr_barcode_label (any as_array)
public function integer ue_print_include_pallet_sscc_label (any as_array)
public function integer uf_print_pallet_container_label (any as_array)
public function integer uf_print_generic_address_label (any as_array)
public function any uf_print_label_data (string as_print_text, string as_print_data, any astr_print_parms)
end prototypes

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
sleep(5)

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
	llPos = Pos(lsString,asOldValue,llPos+1)
Loop

REturn lsString
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
//GailM 9/4/2019 S36897/F17762/I1304 Google SSCC Nbr Format Update - remove (00) from display
setSSCCRawData( rawdata )
setSSCCFormatted( string( LongLong( rawdata) , '0 0000000 000000000 0' ))
//setSSCCFormatted( parens + string( LongLong( rawdata) , '0 0000000 000000000 0' ))

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
	llPos = Pos(lsString,asOldValue,llPos+1)
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

public function integer uf_sscc_zerbra_ship ();//This function will print  Generic UCCS Shipping label

Str_parms	lStrparms
String	lsFormatPallet,	&
			lsCartonBarcode,	&
			lsTemp,				&
			lsPrintText,		&
			lsAddr,ls_weight,ls_temp,	&
			lsUCCCarton,ls_ucc, lsFormatContainer, lsPalletId, lsContainerId,lsPalletIdBc, lsContainerIdBc

Long	llPrintJob,	&
		llPos,		&
		llPrintQty,	&
		llPrintPos,	&
		llCartonNo,	&
		llAddrPos,i,j,ll_no_of_copies
		
Integer	liFileNo, liCheck
string ls_label_type	

lstrparms = getparms()

ls_label_type = Upper(lstrparms.String_arg[67])

CHOOSE CASE ls_label_type

CASE "BESTBUY"
	lsFormatPallet = uf_read_label_Format('PANDORA_SSCC_Bestbuy_zebra_ship.txt') 
	lsFormatContainer = lsFormatPallet	

END CHOOSE	
	
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
	lsFormatPallet = uf_Replace(lsFormatPallet,lsAddr,Left(lstrparms.String_Arg[2],30))
	lsFormatContainer = uf_Replace(lsFormatContainer,lsAddr,Left(lstrparms.String_Arg[2],30))
End If
	
If lstrparms.String_Arg[3] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + "~~"
	lsFormatPallet = uf_Replace(lsFormatPallet,lsAddr,Left(lstrparms.String_Arg[3],30))
	lsFormatContainer = uf_Replace(lsFormatContainer,lsAddr,Left(lstrparms.String_Arg[3],30))
End If

If lstrparms.String_Arg[4] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + "~~"
	lsFormatPallet = uf_Replace(lsFormatPallet,lsAddr,Left(lstrparms.String_Arg[4],30))
	lsFormatContainer = uf_Replace(lsFormatContainer,lsAddr,Left(lstrparms.String_Arg[4],30))
End If

If lstrparms.String_Arg[5] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + "~~"
	lsFormatPallet = uf_Replace(lsFormatPallet,lsAddr,Left(lstrparms.String_Arg[5],30))
	lsFormatContainer = uf_Replace(lsFormatContainer,lsAddr,Left(lstrparms.String_Arg[5],30))
End If

If lstrparms.String_Arg[6] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + "~~"
	lsFormatPallet = uf_Replace(lsFormatPallet,lsAddr,Left(lstrparms.String_Arg[6],30))
	lsFormatContainer = uf_Replace(lsFormatContainer,lsAddr,Left(lstrparms.String_Arg[6],30))
End If

If lstrparms.String_Arg[7] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + "~~"
	lsFormatPallet = uf_Replace(lsFormatPallet,lsAddr,Left(lstrparms.String_Arg[7],30))
	lsFormatContainer = uf_Replace(lsFormatContainer,lsAddr,Left(lstrparms.String_Arg[7],30))
End If

//Po No and B/L number
lsFormatPallet = uf_Replace(lsFormatPallet,"~~po_nbr~~",left(lstrparms.String_Arg[10],30))	
lsFormatContainer = uf_Replace(lsFormatContainer,"~~po_nbr~~",left(lstrparms.String_Arg[10],30))	
lsFormatContainer = uf_replace_label_text(lsFormatContainer,"PRO:",Left("",45)) //Blank out the PRO on the Pallet Label
lsFormatContainer = uf_replace_label_text(lsFormatContainer,"B_L_Number:",Left("",45)) //Blank out the PRO on the Pallet Label
	
lsFormatPallet = uf_Replace(lsFormatPallet,"~~B_L_Number~~",left(lstrparms.String_Arg[11],30))	
lsFormatContainer = uf_Replace(lsFormatContainer,"~~B_L_Number~~",left(lstrparms.String_Arg[11],30))	

//To Address - Roll up addresses if not all present
llAddrPos = 0

If lstrparms.String_Arg[12] > ' ' Then
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~" //Warehouse Name
	lsFormatPallet = uf_Replace(lsFormatPallet,lsAddr,Left(lstrparms.String_Arg[12],45))
	lsFormatContainer = uf_Replace(lsFormatContainer,lsAddr,Left(lstrparms.String_Arg[12],45))
End If

If lstrparms.String_Arg[13] > ' ' Then
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~" //Address1
	lsFormatPallet = uf_Replace(lsFormatPallet,lsAddr,Left(lstrparms.String_Arg[13],45))
	lsFormatContainer = uf_Replace(lsFormatContainer,lsAddr,Left(lstrparms.String_Arg[13],45))	
End If

If lstrparms.String_Arg[14] > ' ' Then
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~" //Address2
	lsFormatPallet = uf_Replace(lsFormatPallet,lsAddr,left(lstrparms.String_Arg[14],45))
	lsFormatContainer = uf_Replace(lsFormatContainer,lsAddr,left(lstrparms.String_Arg[14],45))
End If

If lstrparms.String_Arg[15] > ' ' Then
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~" //Address3
	lsFormatPallet = uf_Replace(lsFormatPallet,lsAddr,Left(lstrparms.String_Arg[15],45))
	lsFormatContainer = uf_Replace(lsFormatContainer,lsAddr,Left(lstrparms.String_Arg[15],45))
End If

If lstrparms.String_Arg[16] > ' ' Then //Address5
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~"
	lsFormatPallet = uf_Replace(lsFormatPallet,lsAddr,left(lstrparms.String_Arg[16],45))
	lsFormatContainer = uf_Replace(lsFormatContainer,lsAddr,left(lstrparms.String_Arg[16],45))
End If

If lstrparms.String_Arg[17] > ' ' Then //Address5
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~"
	lsFormatPallet = uf_Replace(lsFormatPallet,lsAddr,left(lstrparms.String_Arg[17],45))
	lsFormatContainer = uf_Replace(lsFormatContainer,lsAddr,left(lstrparms.String_Arg[17],45))
End If
	
//Carrier
lsFormatPallet = uf_Replace(lsFormatPallet,"~~carrier_name~~",left(lstrparms.String_Arg[24],30))
lsFormatContainer = uf_Replace(lsFormatContainer,"~~carrier_name~~",left(lstrparms.String_Arg[24],30))

lsFormatPallet = uf_Replace(lsFormatPallet,"~~order_number~~",left( lstrparms.String_Arg[23],30))
lsFormatContainer = uf_Replace(lsFormatContainer,"~~order_number~~",left( lstrparms.String_Arg[23],30))

lsFormatPallet = uf_replace_label_text(lsFormatPallet,"QTY:",Left("",45)) //Blank out the QTY on the Pallet Label
lsFormatPallet = uf_Replace(lsFormatPallet,"~~quantity~~",left("",30))

lsFormatContainer = uf_Replace(lsFormatContainer,"~~quantity~~",left( lstrparms.String_Arg[25],30))

lsFormatPallet = uf_replace_label_text(lsFormatPallet,"Serial Shipping Container Code",Left("PALLET: Serial Shipping Container Code",45))

//TimA 08/22/13 Because the Pallet and Containers could have 20 or 18 characters
//we need to padd the leading zeros
If Len(Lstrparms.String_arg[48]) <= 18 then
	lsPalletId = '(00) ' +  left(Lstrparms.String_arg[48],20)
	lsPalletIdBc = '00' +  left(Lstrparms.String_arg[48],20)
Else
	lsPalletId = '(' + left(Lstrparms.String_arg[48],2) + ') ' + left(Mid(Lstrparms.String_arg[48],3,18),20)
	lsPalletIdBc = left(Lstrparms.String_arg[48],20)
End if
//lsFormatPallet = uf_Replace(lsFormatPallet,"~~carton_no_readable~~", left(Lstrparms.String_arg[48],20))
//lsFormatPallet = uf_Replace(lsFormatPallet,">;>=carton_no_bc>=", left(Lstrparms.String_arg[48],20)) 
lsFormatPallet = uf_Replace(lsFormatPallet,"~~carton_no_readable~~", lsPalletId)
lsFormatPallet = uf_Replace(lsFormatPallet,">;>=carton_no_bc>=", lsPalletIdBc) 

lsFormatContainer = uf_replace_label_text(lsFormatContainer,"Serial Shipping Container Code",Left("CONTAINER: Serial Shipping Container Code",45))

If Len(Lstrparms.String_arg[49]) <= 18 then
	lsContainerId = '(00) ' +  left(Lstrparms.String_arg[49],20)
	lsContainerIdBc = '00' +  left(Lstrparms.String_arg[49],20)
Else
	lsContainerId = '(' + left(Lstrparms.String_arg[49],2) + ') ' + left(Lstrparms.String_arg[49],20)
	lsContainerIdBc = left(Lstrparms.String_arg[49],20)
End if
lsFormatContainer = uf_Replace(lsFormatContainer,"~~carton_no_readable~~", lsContainerId)
lsFormatContainer= uf_Replace(lsFormatContainer,">;>=carton_no_bc>=", lsContainerIdBc) 
//lsFormatContainer = uf_Replace(lsFormatContainer,"~~carton_no_readable~~", left(Lstrparms.String_arg[49],20))
//lsFormatContainer= uf_Replace(lsFormatContainer,">;>=carton_no_bc>=", left(Lstrparms.String_arg[49],20)) 

//UPC
lsFormatPallet = uf_Replace(lsFormatPallet,"~~UPC~~",left( lstrparms.String_Arg[20],30))
lsFormatContainer = uf_Replace(lsFormatContainer,"~~UPC~~",left( lstrparms.String_Arg[20],30))

//No of copies
ll_no_of_copies = lstrparms.Long_Arg[1]
FOR i= 1 TO ll_no_of_copies

	If lstrparms.String_arg[65] = 'Y' then //Print the Pallet label
		PrintSend(llPrintJob, lsFormatPallet)	
	End if
	If lstrparms.String_arg[66] = 'Y' then //Print the Container label	
		PrintSend(llPrintJob, lsFormatContainer)	
	End if
	ls_temp= lstrparms.String_Arg[28]
NEXT
	
PrintClose(llPrintJob)

Return 0


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

public function str_parms uf_split_serialno_by_length (str_parms as_str_serial_no, long al_length);//02-MAR-2018 :Madhu S16401 F6390- Pandora 2D Barcode.
//Split Serial No's against 2D Barcode length and print multiple labels.

str_parms ls_str_parms
string ls_serial_concat, ls_prev_serial_concat, ls_serial_no, ls_new_serialNo
long 	llRowPos, ll_serial_length, ll_total_carton_count, ll_Serial_Count
boolean lbNextCarton

ll_Serial_Count = upperBound(as_str_serial_no.string_arg[])

FOR llRowPos =1 to ll_Serial_Count

	ls_prev_serial_concat = ls_serial_concat	
	ls_serial_no = as_str_serial_no.string_arg[llRowPos] //get Serial No
	
	ls_serial_concat += ls_serial_no //concat serial No
	
	ll_serial_length =len(ls_serial_concat)
	IF ll_serial_length <= al_length Then
		ls_serial_concat +=","
		lbNextCarton = False
	else
		lbNextCarton = True
	End IF
	
	//if New Carton Required, stored concatenated SN into Str_Parms
	If lbNextCarton Then
		ls_new_serialNo = Left(ls_prev_serial_concat, len(ls_prev_serial_concat) -1) //remove comma at the end
		llRowPos = llRowPos -1 //starts from previous row
		
		//Re-set the variables.
		ls_prev_serial_concat =''
		ls_serial_concat =''
		
		ls_str_parms.string_arg[UpperBound(ls_str_parms.string_arg[]) + 1] =ls_new_serialNo
	End If
	
	//assign LeftOver Serial No's into Str_Parms
	IF (llRowPos = ll_Serial_Count) and lbNextCarton =False Then
		ls_new_serialNo = Left(ls_serial_concat, len(ls_serial_concat) -1) //remove comma at the end
		ls_str_parms.string_arg[UpperBound(ls_str_parms.string_arg[])+ 1] =ls_new_serialNo
	End IF

NEXT

Return ls_str_parms
end function

public function string uf_generate_sscc (string as_pallet_container_id);//01-MAR-2018 :Madhu F6390 - 2D Barcode generation
//generate SSCC (18 digit) No.

String lsContainer_Id ,lsUCCS, lsOutString, lsDelimitChar, lsUCCSCompanyPrefix
Long liCartonNo,liCheck

lsContainer_Id = as_pallet_container_Id
lsDelimitChar = char(9)

select UCC_Company_Prefix into :lsUCCSCompanyPrefix 
from Project with(nolock)
where Project_ID = :gs_project 
using SQLCA;

IF IsNull(lsUCCSCompanyPrefix) Then lsUCCSCompanyPrefix = '00000000'
IF IsNull(lsContainer_Id) Then lsContainer_Id = '000000000'
IF lsContainer_Id <> '' Then
		 
   liCartonNo = long(lsContainer_Id)
   lsContainer_Id =string(liCartonNo, '000000000') 
   lsUCCS =  trim((lsUCCSCompanyPrefix +  lsContainer_Id))
   liCheck = f_calc_uccs_check_Digit(lsUCCS) 
	
   If liCheck >=0 Then
   		lsUCCS = lsUCCS + String(liCheck)
   Else
     	lsUCCS = String(lsUCCS, '00000000000000000') + "0"
   End IF
   
	lsOutString += lsUCCS  + lsDelimitChar
	
end if

Return lsOutString
end function

public function integer uf_print_2d_barcode_label (str_parms astr_serial_parms, string as_sku, string as_wh, string as_pallet_container_id, string as_label_text);//05-MAR-2018 :Madhu  S16401 F6390 -Print 2D Barcode
string ls_sscc, ls_coo, lsFormat, lsLabel, lsCurrentLabel, lsLabelPrint
long ll_row, ll_Rowcount, ll_Return
str_parms lstr_serial_data, lstr_parms

//split serial no's by length into multiple labels.
lstr_serial_data = this.uf_split_serialno_by_length( astr_serial_parms, 1500)
ll_Rowcount =UpperBound(lstr_serial_data.string_arg[])

//generate SSCC
ls_sscc = this.uf_generate_sscc( as_pallet_container_Id)

select Top 1 Country_Of_Origin into :ls_coo 
from Content with(nolock) where Project_Id=:gs_project  and wh_code= :as_wh
and sku=:as_sku and container_Id = :as_pallet_container_Id
using sqlca;

//read Label Format
lsFormat = "Pandora_2D_Barcode_Label.txt"
lsLabel = this.uf_read_label_Format(lsFormat)

If lsLabel = "" Then Return -1
	
//Preparing Print Label Data
For ll_row = 1 to ll_Rowcount
	lsCurrentLabel = lsLabel
	lsCurrentLabel = this.uf_replace(lsCurrentLabel,"~~label_text~~", as_label_text)
	lsCurrentLabel = this.uf_replace(lsCurrentLabel,"_7Eserial_5Fno_5Fbc_7E", lstr_serial_data.string_arg[ll_row])
	lsCurrentLabel = this.uf_replace(lsCurrentLabel,"~~cont~~", ls_sscc)
	lsCurrentLabel = this.uf_replace(lsCurrentLabel,">=cont>=", ls_sscc)
	
	lsCurrentLabel = this.uf_replace(lsCurrentLabel,"~~carton_Id~~", as_pallet_container_Id)
	lsCurrentLabel = this.uf_replace(lsCurrentLabel,"~~sku~~", as_sku)
	lsCurrentLabel = this.uf_replace(lsCurrentLabel,">=sku>=", as_sku)
		
	lsCurrentLabel = this.uf_replace(lsCurrentLabel,"~~qty~~", string(ll_Rowcount))
	lsCurrentLabel = this.uf_replace(lsCurrentLabel,">=qty>=", string(ll_Rowcount))
		
	lsCurrentLabel = this.uf_replace(lsCurrentLabel,"~~uc3~~", left(ls_coo, 2))
	lsCurrentLabel = this.uf_replace(lsCurrentLabel,">=uc3>=", left(ls_coo, 2))
	
	lsCurrentLabel = this.uf_replace(lsCurrentLabel,"~~count~~", string(ll_row))
	lsCurrentLabel = this.uf_replace(lsCurrentLabel,"~~count_total~~", string(ll_Rowcount))
	
	lsLabelPrint += lsCurrentLabel
Next

//Print Label
ll_Return = this.uf_print_label_data(  'Pandora 2D Barcode Part Labels ', lsLabelPrint)

Return ll_Return
end function

public function long uf_print_label_data (string as_print_text, string as_print_data);//27-FEB-2018 Madhu S16401 F6390 - 2D Barcode
//Print Label
long llPrintJob
str_parms lstr_parms

IF as_print_data > "" Then
	OpenWithParm(w_label_print_options,lstr_parms)
	lstr_parms = Message.PowerObjectParm		  
	
	IF lstr_parms.Cancelled Then
		Return -1
	End IF
	
	//Open Printer File 
	llPrintJob = PrintOpen( as_print_text)
	IF llPrintJob <0 Then 
		Messagebox('Labels', 'Unable to open Printer file. Labels will not be printed')
		Return -1
	End IF
	
	PrintSend(llPrintJob, as_print_data)	
	PrintClose(llPrintJob)
End IF

Return 0
end function

public function integer uf_print_google_shipping_label (any as_array);//07-SEP-2018 :Madhu S23255 Shipping Labels
//Print Google Shipping Label

Str_parms	lStrparms
String	 lsFormat, lsPrintText, lsAddr,ls_temp, ls_QA_check_Ind
Long	llPrintJob, llAddrPos, i ,ll_no_of_copies

lstrparms = as_array

ls_QA_check_Ind = lstrparms.String_arg[28]

If IsNull( ls_QA_Check_Ind) Then ls_QA_Check_Ind ='X'

If ls_QA_check_Ind ='M'  and lstrparms.boolean_arg[1] =True Then
	lsFormat = uf_read_label_Format('Google_Shipping_Label_DG_Logo_200_DPI.txt') 
elseIf ls_QA_check_Ind <> 'M'  and lstrparms.boolean_arg[1] =True Then
	lsFormat = uf_read_label_Format('Google_Shipping_Label_No_DG_Logo_200_DPI.txt') 
elseIf ls_QA_check_Ind ='M'  and lstrparms.boolean_arg[2] =True Then
	lsFormat = uf_read_label_Format('Google_Shipping_Label_DG_Logo_300_DPI.txt') 
elseIf ls_QA_check_Ind <> 'M'  and lstrparms.boolean_arg[2] =True Then					//Gailm 11/16/2018 300dpi would never print
	lsFormat = uf_read_label_Format('Google_Shipping_Label_No_DG_Logo_300_DPI.txt') 	
End If

lsPrintText = 'Google Shipping Label'

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
	
If lstrparms.String_Arg[6] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + "~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[6],30))
End If
	
If lstrparms.String_Arg[7] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + "~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[7],45))
End If

//To Address - Roll up addresses if not all present
llAddrPos = 0

If lstrparms.String_Arg[8] > ' ' Then
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~" //Customer Name
	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[8],45))
End If

If lstrparms.String_Arg[9] > ' ' Then
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~" //Address1
	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[9],45))
End If

If lstrparms.String_Arg[10] > ' ' Then
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~" //Address2
	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[10],45))
End If

If lstrparms.String_Arg[11] > ' ' Then
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~" //Address3
	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[11],45))
End If

If lstrparms.String_Arg[12] > ' ' Then //Address4
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[12],45))
End If

If lstrparms.String_Arg[14] > ' ' Then //City,state,zip
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[14],45))
End If

lsFormat = uf_Replace(lsFormat,"~~serial_tracked~~",left(lstrparms.String_Arg[15],1))
lsFormat = uf_Replace(lsFormat,"~~dt_print~~", string(today(),'MM/DD/YYYY'))
//lsFormat = uf_Replace(lsFormat,"~~sku~~", lstrparms.String_Arg[17])
lsFormat = uf_Replace(lsFormat,"~~sku~~", left(lstrparms.String_Arg[17],30)) // Dinesh S64720- Google - SIMS - Buy Sell Project
lsFormat = uf_Replace(lsFormat,"~~dt_expire~~", string(lstrparms.datetime_arg[1]))
lsFormat = uf_Replace(lsFormat,"~~alt_sku~~",left(lstrparms.String_Arg[18],30))
lsFormat = uf_Replace(lsFormat,"~~coo~~", left(lstrparms.String_Arg[19],30))
lsFormat = uf_Replace(lsFormat,"~~sku_desc~~",left(lstrparms.String_Arg[20],30))
lsFormat = uf_Replace(lsFormat,"~~sku_desc1~~",left(lstrparms.String_Arg[21],30))
lsFormat = uf_Replace(lsFormat,"~~sku_desc2~~",left(lstrparms.String_Arg[22],30))
lsFormat = uf_Replace(lsFormat,"~~sku_desc3~~",left(lstrparms.String_Arg[23],30))
lsFormat = uf_Replace(lsFormat,"~~sku_desc4~~",left(lstrparms.String_Arg[24],30))

If lstrparms.Long_arg[2] < 10 Then
	lsFormat = uf_Replace(lsFormat,"~~qty~~", string(lstrparms.Long_arg[2] ,'00'))
else
	lsFormat = uf_Replace(lsFormat,"~~qty~~", string(lstrparms.Long_arg[2]))
End If

//lsFormat = uf_Replace(lsFormat,"~~cust_order_no~~",left(lstrparms.String_Arg[25],30))
lsFormat = uf_Replace(lsFormat,"~~client_cust_so_nbr~~",left(lstrparms.String_Arg[25],30)) // Dinesh 02/14/2022- DE24740-Google - SIMS Prod - Not able to print shipping Labels at Picking Status
lsFormat = uf_Replace(lsFormat,"~~line_item_no~~", string(lstrparms.Long_arg[3]))
//lsFormat = uf_Replace(lsFormat,"~~client_cust_po_no~~",left(lstrparms.String_Arg[26],30))
lsFormat = uf_Replace(lsFormat,"~~cust_order_no~~",left(lstrparms.String_Arg[26],30)) // Dinesh 02/14/2022 - DE24740-Google - SIMS Prod - Not able to print shipping Labels at Picking Status
lsFormat = uf_Replace(lsFormat,"~~pack_sscc_no~~",left(lstrparms.String_Arg[27],30))
	
	
//No of copies
ll_no_of_copies = lstrparms.Long_Arg[1]
FOR i= 1 TO ll_no_of_copies
	lsFormat = uf_Replace(lsFormat,"~~pack_count~~",left(lstrparms.String_Arg[29],30))
	PrintSend(llPrintJob, lsformat)	
	ls_temp= lstrparms.String_Arg[29]
NEXT
	
PrintClose(llPrintJob)
	

Return 0
end function

public function integer uf_print_qr_barcode_label (any as_array);//07-SEP-2018 :Madhu S23255 Shipping Labels
//Print QR Barcode Label

Str_parms	lStrparms
String	 lsFormat, lsPrintText, lsAddr,ls_temp, ls_QA_check_Ind
Long	llPrintJob, llAddrPos, i ,ll_no_of_copies

lstrparms = as_array


If lstrparms.boolean_arg[1] =True Then
	lsFormat = uf_read_label_Format('Pandora_QR_Barcode_Label_200_DPI.txt') 
else
	lsFormat = uf_read_label_Format('Pandora_QR_Barcode_Label_300_DPI.txt') 	
End If

lsPrintText = 'QR Barcode Shipping Label'

//Open Printer File 
llPrintJob = PrintOpen(lsPrintText)
	
If llPrintJob <0 Then 
	Messagebox('Labels', 'Unable to open Printer file. Labels will not be printed')
	Return -1
End If

lsFormat = uf_Replace(lsFormat,"~~label_name~~", lstrparms.String_Arg[1])
lsFormat = uf_Replace(lsFormat,"_7eserial_5fno_7e", lstrparms.String_Arg[2])
lsFormat = uf_Replace(lsFormat,"~~pallet_id~~", lstrparms.String_Arg[3])
lsFormat = uf_Replace(lsFormat,"~~print_x_of_y~~", lstrparms.String_Arg[4])

//No of copies
ll_no_of_copies = lstrparms.Long_Arg[1]
FOR i= 1 TO ll_no_of_copies
	PrintSend(llPrintJob, lsformat)	
NEXT
	
PrintClose(llPrintJob)
	
Return 0
end function

public function integer ue_print_include_pallet_sscc_label (any as_array);//07-SEP-2018 :Madhu S23255 Shipping Labels
//Print Include Pallet SSCC Label

Str_parms	lStrparms
String	lsFormat, lsCartonBarcode,	lsTemp, lsPrintText, lsAddr,ls_weight,ls_temp, 	lsUCCCarton
Long	llPrintJob, llPos,	 llPrintQty, llPrintPos, llCartonNo, llAddrPos,i,j,ll_no_of_copies
Integer	liFileNo, liCheck


lstrparms = as_array

//read label format
IF lstrparms.boolean_arg[1] = True THEN
	lsFormat = uf_read_label_Format('Pandora_generic_shipping_label.txt') 
ELSE
	lsFormat = uf_read_label_Format('Pandora_Generic_Shipping_Label_300_DPI.txt') 
END IF
	
lsPrintText = 'Include Pallet SSCC Label'
llPrintJob = PrintOpen(lsPrintText) //Open Printer File

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
	
If lstrparms.String_Arg[7] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + "~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[7],45))
End If
	
If lstrparms.String_Arg[6] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + "~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[6],30))
End If

//To Address - Roll up addresses if not all present

llAddrPos = 0

If lstrparms.String_Arg[8] > ' ' Then
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~" //Customer Name
	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[8],45))
End If

If lstrparms.String_Arg[9] > ' ' Then
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~" //Address1
	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[9],45))
End If

If lstrparms.String_Arg[10] > ' ' Then
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~" //Address2
	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[10],45))
End If

If lstrparms.String_Arg[11] > ' ' Then
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~" //Address3
	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[11],45))
End If

If lstrparms.String_Arg[12] > ' ' Then //Address4
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[12],45))
End If

If lstrparms.String_Arg[14] > ' ' Then //City,state,zip
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[14],45))
End If

If lstrparms.String_Arg[13] > ' ' Then //To zip
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[13],45))
End If


lsFormat = uf_Replace(lsFormat,"~~ship2postzip~~",left(lstrparms.String_Arg[13],12)) //Ship To Post Code
lsFormat = uf_Replace(lsFormat,"~~ship2postbarcode~~",left(lstrparms.String_Arg[13],8)) //Ship To Post Code (BARCODE)	

lsFormat = uf_Replace(lsFormat,"~~Carrier~~",left(lstrparms.String_Arg[15],30)) //Carrier Name
lsFormat = uf_Replace(lsFormat,"~~awb_bol_nbr~~",left(lstrparms.String_Arg[16],12)) //AWB
lsFormat = uf_Replace(lsFormat,"~~load_id~~", lstrparms.String_Arg[17]) //Load Id
lsFormat = uf_Replace(lsFormat,"~~stop_id~~", String(lstrparms.Long_Arg[7])) //Stop Id
lsFormat = uf_Replace(lsFormat,"~~load_sequence~~", String(lstrparms.Long_Arg[8])) //Load Sequence
		
lsFormat = uf_Replace(lsFormat,"~~sales_order_nbr~~",Left(lstrparms.String_Arg[18],20)) //Order No
lsFormat = uf_Replace(lsFormat,"~~Cust_order_nbr~~",left(lstrparms.String_Arg[19],30)) //Customer Order Nbr
lsFormat = uf_Replace(lsFormat,"~~Do_No~~",left( lstrparms.String_Arg[20],30)) //Shipment Id (Do No)
lsFormat = uf_Replace(lsFormat,"~~tracker_id~~",left(lstrparms.String_Arg[21],30)) //Tracking shipper No
lsFormat = uf_Replace(lsFormat,"~~Client_Cust_Po_Nbr~~",Left(lstrparms.String_Arg[22],20)) //Vendor Order Nbr
lsFormat = uf_Replace(lsFormat,"~~Ship_Date~~",string(today(),"mmm dd, yyyy")) //Ship Date (//Today's date )

ls_weight = String(lstrparms.Long_Arg[5]) + "/" + String(lstrparms.Long_Arg[6])
lsFormat = uf_Replace(lsFormat,"~~Weight~~",ls_weight )
lsFormat = uf_Replace(lsFormat,"~~Weight_lbs_no~~",String(lstrparms.Long_Arg[5]))
lsFormat = uf_Replace(lsFormat,"~~Weight_kgs_no~~",String(lstrparms.Long_Arg[6]))
lsFormat = uf_Replace(lsFormat,"~~Weight~~",String(lstrparms.Long_Arg[5]) + "LBs / " + String(lstrparms.Long_Arg[6]) + "KGs") //Weight
	
lsFormat = uf_Replace(lsFormat,"~~carton_nbr_barcode~~",lstrparms.String_Arg[23])
lsFormat = uf_Replace(lsFormat,"~~carton_nbr~~",Right(lstrparms.String_Arg[23],18))

//No of copies
ll_no_of_copies = lstrparms.Long_Arg[1]
FOR i= 1 TO ll_no_of_copies
	lsFormat = uf_Replace(lsFormat,"~~Box~~",left(lstrparms.String_Arg[24],30)) //Box
	PrintSend(llPrintJob, lsformat)	
	ls_temp= lstrparms.String_Arg[24]
NEXT
	
PrintClose(llPrintJob)
	

Return 0
end function

public function integer uf_print_pallet_container_label (any as_array);//07-SEP-2018 :Madhu S23255 Shipping Labels
//Print Pallet Container Id Label

Str_parms	lStrparms
String	 lsFormat, lsPrintText, ls_replace_data, ls_temp, ls_label_data
Long	llPrintJob, i, ll_no_of_copies

lstrparms = as_array


If  lstrparms.boolean_arg[1] =True Then
	lsFormat = uf_read_label_Format('Pandora_Nested_Pallet_Carton_Label_200_DPI.txt') 
	ls_replace_data ="^B3R,N,68,N,N^FD~~container_id_"
else
	lsFormat = uf_read_label_Format('Pandora_Nested_Pallet_Carton_Label_300_DPI.txt')
	ls_replace_data ="^B3R,N,100,N,N^FD~~container_id_"
End If

lsPrintText = 'Pallet Container Label'

//Open Printer File 
llPrintJob = PrintOpen(lsPrintText)
	
If llPrintJob <0 Then 
	Messagebox('Labels', 'Unable to open Printer file. Labels will not be printed')
	Return -1
End If

lsFormat = uf_Replace(lsFormat,"~~pallet_id~~", lstrparms.String_Arg[8])

//container_Id_1
IF lstrparms.String_Arg[1] > '' THEN
	lsFormat = uf_Replace(lsFormat,"~~container_id_1~~", lstrparms.String_Arg[1])	
ELSE
	//replace label data
	ls_label_data =ls_replace_data+string(1)+"~~^FS"
	lsFormat = uf_Replace(lsFormat, ls_label_data, "^FD^FS")
END IF

//container_Id_2
IF lstrparms.String_Arg[2] > '' THEN
	lsFormat = uf_Replace(lsFormat,"~~container_id_2~~", lstrparms.String_Arg[2])	
ELSE
	//replace label data
	ls_label_data =ls_replace_data+string(2)+"~~^FS"
	lsFormat = uf_Replace(lsFormat, ls_label_data, "^FD^FS")
END IF

//container_Id_3
IF lstrparms.String_Arg[3] > '' THEN
	lsFormat = uf_Replace(lsFormat,"~~container_id_3~~", lstrparms.String_Arg[3])	
ELSE
	//replace label data
	ls_label_data =ls_replace_data+string(3)+"~~^FS"
	lsFormat = uf_Replace(lsFormat, ls_label_data, "^FD^FS")
END IF

//container_Id_4
IF lstrparms.String_Arg[4] > '' THEN
	lsFormat = uf_Replace(lsFormat,"~~container_id_4~~", lstrparms.String_Arg[4])	
ELSE
	//replace label data
	ls_label_data =ls_replace_data+string(4)+"~~^FS"
	lsFormat = uf_Replace(lsFormat, ls_label_data, "^FD^FS")
END IF

//container_Id_5
IF lstrparms.String_Arg[5] > '' THEN
	lsFormat = uf_Replace(lsFormat,"~~container_id_5~~", lstrparms.String_Arg[5])	
ELSE
	//replace label data
	ls_label_data =ls_replace_data+string(5)+"~~^FS"
	lsFormat = uf_Replace(lsFormat, ls_label_data, "^FD^FS")
END IF

//container_Id_6
IF lstrparms.String_Arg[6] > '' THEN
	lsFormat = uf_Replace(lsFormat,"~~container_id_6~~", lstrparms.String_Arg[6])	
ELSE
	//replace label data
	ls_label_data =ls_replace_data+string(6)+"~~^FS"
	lsFormat = uf_Replace(lsFormat, ls_label_data, "^FD^FS")
END IF

//container_Id_7
IF lstrparms.String_Arg[7] > '' THEN
	lsFormat = uf_Replace(lsFormat,"~~container_id_7~~", lstrparms.String_Arg[7])	
ELSE
	//replace label data
	ls_label_data =ls_replace_data+string(7)+"~~^FS"
	lsFormat = uf_Replace(lsFormat, ls_label_data, "^FD^FS")
END IF

lsFormat = uf_Replace(lsFormat,"~~print_x_of_y~~", lstrparms.String_Arg[9])	

//No of copies
ll_no_of_copies = lstrparms.Long_Arg[1]
FOR i= 1 TO ll_no_of_copies
	PrintSend(llPrintJob, lsformat)	
NEXT
	
PrintClose(llPrintJob)
	
Return 0
end function

public function integer uf_print_generic_address_label (any as_array);//07-SEP-2018 :Madhu S23255 Shipping Labels
//Print Generic Address Shipping Label

Str_parms	lStrparms
string	lsFormat, lsCartonBarcode, 	lsTemp, lsPrintText, lsAddr,ls_weight,ls_temp, 	lsUCCCarton
long	llPrintJob, llPos, llPrintQty, llPrintPos, llCartonNo, llAddrPos, i, j, ll_no_of_copies
Integer	liFileNo, liCheck

lstrparms = as_array

If  lstrparms.boolean_arg[1] =True Then
	lsFormat = uf_read_label_Format('Pandora_Generic_Shipping_Label.txt') 
else
	lsFormat = uf_read_label_Format('Pandora_Generic_Shipping_Label_300_DPI.txt') 	
End If

lsPrintText = 'Generic Address Shipping Label'

llPrintJob = PrintOpen(lsPrintText) //Open Printer File 

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
	
If lstrparms.String_Arg[7] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + "~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[7],45))
End If
	
If lstrparms.String_Arg[6] > ' ' Then
	llAddrPos ++
	lsAddr = "~~from_addr" + String(llAddrPos) + "~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[6],30))
End If

//To Address - Roll up addresses if not all present
llAddrPos = 0

If lstrparms.String_Arg[8] > ' ' Then
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~" //Customer Name
	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[8],45))
End If

If lstrparms.String_Arg[9] > ' ' Then
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~" //Address1
	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[9],45))
End If

If lstrparms.String_Arg[10] > ' ' Then
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~" //Address2
	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[10],45))
End If

If lstrparms.String_Arg[11] > ' ' Then
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~" //Address3
	lsFormat = uf_Replace(lsFormat,lsAddr,Left(lstrparms.String_Arg[11],45))
End If

If lstrparms.String_Arg[12] > ' ' Then //Address4
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[12],45))
End If

If lstrparms.String_Arg[14] > ' ' Then //City,state,zip
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[14],45))
End If

If lstrparms.String_Arg[13] > ' ' Then //To zip
	llAddrPos ++
	lsAddr = "~~to_addr" + String(llAddrPos) + "~~"
	lsFormat = uf_Replace(lsFormat,lsAddr,left(lstrparms.String_Arg[13],45))
End If


lsFormat = uf_Replace(lsFormat,"~~ship2postzip~~",left(lstrparms.String_Arg[13],12)) //Ship To Post Code
lsFormat = uf_Replace(lsFormat,"~~ship2postbarcode~~",left(lstrparms.String_Arg[13],8)) //Ship To Post Code (BARCODE)	

lsFormat = uf_Replace(lsFormat,"~~Carrier~~",left(lstrparms.String_Arg[15],30)) //Carrier Name
lsFormat = uf_Replace(lsFormat,"~~awb_bol_nbr~~",left(lstrparms.String_Arg[16],12)) //AWB
lsFormat = uf_Replace(lsFormat,"~~load_id~~", lstrparms.String_Arg[17]) //Load Id
lsFormat = uf_Replace(lsFormat,"~~stop_id~~", String(lstrparms.Long_Arg[7])) //Stop Id
lsFormat = uf_Replace(lsFormat,"~~load_sequence~~", String(lstrparms.Long_Arg[8])) //Load Sequence
		
lsFormat = uf_Replace(lsFormat,"~~sales_order_nbr~~",Left(lstrparms.String_Arg[18],20)) //Order No
lsFormat = uf_Replace(lsFormat,"~~Cust_order_nbr~~",left(lstrparms.String_Arg[19],30)) //Customer Order Nbr
lsFormat = uf_Replace(lsFormat,"~~Do_No~~",left( lstrparms.String_Arg[20],30)) //Shipment Id (Do No)
lsFormat = uf_Replace(lsFormat,"~~tracker_id~~",left(lstrparms.String_Arg[21],30)) //Tracking shipper No
lsFormat = uf_Replace(lsFormat,"~~Client_Cust_Po_Nbr~~",Left(lstrparms.String_Arg[22],20)) //Vendor Order Nbr
lsFormat = uf_Replace(lsFormat,"~~Ship_Date~~",string(today(),"mmm dd, yyyy")) //Ship Date (//Today's date )
ls_weight = String(lstrparms.Long_Arg[5]) + "/" + String(lstrparms.Long_Arg[6])
//ls_weight = String(lstrparms.Long_Arg[5]) + " Lbs" + "/" + String(lstrparms.Long_Arg[6]) + " Kgs" // Dinesh - 03/20/2025- SIMS-680- Google - SIMS - Shipping Label
lsFormat = uf_Replace(lsFormat,"~~Weight~~",ls_weight )
lsFormat = uf_Replace(lsFormat,"~~Weight_lbs_no~~",String(lstrparms.Long_Arg[5]))
lsFormat = uf_Replace(lsFormat,"~~Weight_kgs_no~~",String(lstrparms.Long_Arg[6]))
lsFormat = uf_Replace(lsFormat,"~~Weight~~",String(lstrparms.Long_Arg[5]) + " LBs / " + String(lstrparms.Long_Arg[6]) + " KGs") //Weight
	
lsFormat = uf_Replace(lsFormat,"~~carton_nbr_barcode~~",lstrparms.String_Arg[23])
lsFormat = uf_Replace(lsFormat,"~~carton_nbr~~",Right(lstrparms.String_Arg[23],18))

//Carton no (UCCS Label) - 
//27-SEP-2018 :Madhu DE6536 - UCC Company prefix should be 8 digits.
If  lstrparms.String_Arg[25] > '' Then
	lsUCCCarton = Right(String(Double(lstrparms.String_Arg[25]),'00000000'),8) + Right(String(Double(lstrparms.String_Arg[23]),'000000000'),9)
	liCheck = f_calc_uccs_check_Digit(lsUCCCarton) /*calculate the check digit*/
	If liCheck >=0 Then
		lsuccCarton = "00" + lsUccCarton + String(liCheck) /* add 00 at beginning (not part of check digit calculation but included as tag */
	Else
		lsUccCarton = String(Double(lstrparms.String_Arg[23]),'00000000000000000000')
	End If
Else
	lsUccCarton = String(Double(lstrparms.String_Arg[23]),'00000000000000000000')
End If

lsFormat = uf_Replace(lsFormat,"~~carton_nbr_barcode~~",lsUCCCarton)
lsFormat = uf_Replace(lsFormat,"~~carton_nbr~~",Right(lsUCCCarton,18)) /* 00 already on label as text field but included in barcode*/
	
	
//No of copies
ll_no_of_copies = lstrparms.Long_Arg[1]
FOR i= 1 TO ll_no_of_copies
	lsFormat = uf_Replace(lsFormat,"~~Box~~",left(lstrparms.String_Arg[24],30))
	PrintSend(llPrintJob, lsformat)	
	ls_temp= lstrparms.String_Arg[24]
NEXT

PrintClose(llPrintJob)
	
Return 0
end function

public function any uf_print_label_data (string as_print_text, string as_print_data, any astr_print_parms);//GailM 2/18/2019 S29708 F142103 I1104 Split labels for one label per print call.  
long llPrintJob
str_parms lstr_parms

str_parms lstr_print_parms 
lstr_print_parms = astr_print_parms

If as_print_data > "" Then
	If Upperbound(lstr_print_parms.Long_arg) = 0 Then		//Set print options only one time per session
		OpenWithParm(w_label_print_options, lstr_parms)
		lstr_parms = Message.powerobjectparm
		lstr_print_parms = lstr_parms
		lstr_print_parms.Boolean_arg[1] = True
	Else
		If Not lstr_print_parms.Boolean_arg[1] Then
			OpenWithParm(w_label_print_options, lstr_parms)
			lstr_parms = Message.powerobjectparm
			lstr_print_parms = lstr_parms
			lstr_print_parms.Boolean_arg[1] = True
		Else
			lstr_parms = lstr_print_parms
		End If
	End If

	If lstr_parms.Cancelled Then
		Return lstr_parms
	End If

	//Open Printer File
	llPrintJob = PrintOpen( as_print_text )
	If llPrintJob < 0 Then
		MessageBox('Labels','Unable to open Printer file.  Labels will not be printed')
		Return lstr_parms
	End If
	
	PrintSend(llPrintJob, as_print_data)
	PrintClose(llPrintJob)
	
End If

Return lstr_print_parms


end function

on n_labels_pandora.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_labels_pandora.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

