HA$PBExportHeader$n_label_phx_brands.sru
forward
global type n_label_phx_brands from n_labels
end type
end forward

global type n_label_phx_brands from n_labels
end type
global n_label_phx_brands n_label_phx_brands

type variables
string isCartonNo


end variables

forward prototypes
public function integer print ()
end prototypes

public function integer print ();
//This function will print  Generic UCCS Shipping label

Str_parms	lStrparms
String	lsFormat,	&
			lsCartonBarcode,	&
			lsTemp,				&
			lsPrintText,		&
			lsAddr,ls_weight,ls_temp,	&
			lsUCCCarton,ls_ucc

String ls_dono,ls_upc,ls_coo , lssku
Long	llPrintJob,	&
		llPos,		&
		llPrintQty,	&
		llPrintPos,	&
		llCartonNo,	&
		llAddrPos,i,j,ll_no_of_copies,llPackFindRow
		
Integer	liFileNo, liCheck, liSkuCount
string ls_label_type, ls_sku[], lsPackFind, lsCartonNo 
BOOLEAN bAddSKU=FALSE

lstrparms = getparms()
//
//SELECT User_Field10 INTO :ls_label_type FROM Delivery_Master
//	WHERE DO_NO = :lstrparms.String_arg[40] USING SQLCA;
//
//ls_label_type = Upper(ls_label_type)

IF Pos( UPPER(lstrparms.String_arg[7]), 'BIG LOT', 1 ) > 0 OR Pos( UPPER(lstrparms.String_arg[7]), 'BIGLOT', 1 ) > 0 THEN	
	lsFormat = uf_read_label_Format('phx_brands_biglots_ship_zebra.txt') /* 2008/05/16 - MEA - Using Labelvision */
	ls_label_type = "BIG"

ELSEIF Pos( UPPER(lstrparms.String_arg[7]), 'CANADIAN TIRE', 1 ) > 0  THEN	   //OR Pos( UPPER(lstrparms.String_arg[7]), 'BIGLOT', 1 ) > 0
	lsFormat = uf_read_label_Format('PHX_BRNDS_Canadian_Tire_zebra_ship.DWN')	
	ls_label_type = "CNT"

ELSEIF Pos( UPPER(lstrparms.String_arg[7]), 'H. E. BUTT', 1 ) > 0  THEN	   //OR Pos( UPPER(lstrparms.String_arg[7]), 'BIGLOT', 1 ) > 0
	lsFormat = uf_read_label_Format("phx_brands_heb_ship_zebra.txt") /* 2010/09/14 - Jxlim - Using Labelvision */	
//	lsFormat = uf_read_label_Format('PHX_BRNDS_generic_zebra_ship_UCC.DWN') 
	ls_label_type = "HEB"

ELSEIF Pos( UPPER(lstrparms.String_arg[7]), 'K-MART', 1 ) > 0  OR Pos( UPPER(lstrparms.String_arg[7]), 'KMART', 1 ) > 0 THEN
	lsFormat = uf_read_label_Format('phx_brands_kmt_zebra_ship.txt') /* 2007/05/15 - TAM - Using Labelvision */
	ls_label_type = "KMT"

ELSEIF Pos( UPPER(lstrparms.String_arg[7]), 'LOBLAW', 1 ) > 0 OR Pos( UPPER(lstrparms.String_arg[7]), 'PROVIGO', 1 ) > 0 THEN	 //BCR 30-AUG-2011; Project ID - L11P027: We need to separate the processing for Loblaw and Provigo customers from the rest...

	lsFormat = uf_read_label_Format('Phx_Brands_Loblaw_zebra_ship_UCC.txt')
	//lsFormat = uf_read_label_Format('phx_brands_loblaw_ship_zebra.txt') /* 2008/05/16 - MEA - Using Labelvision */
	//ls_label_type = "LAM"
	lsFormat = uf_Replace(lsFormat,"~~weight~~",String(lstrparms.Long_Arg[5]) + "LBs / " + String(lstrparms.Long_Arg[6]) + "KGs")
	lsFormat = uf_Replace(lsFormat,"~~today~~",left(string(today(),"Mmm dd, yyyy"),15))
	lsFormat = uf_Replace(lsFormat,"~~ship_to_zip_BC~~","420"+left(lstrparms.String_Arg[41],12))
	lsFormat = uf_Replace(lsFormat,">=carton_no_bc>=", right(Lstrparms.String_arg[48],20)) 
	lsFormat = uf_Replace(lsFormat,"~~Carrier Name~~",left(lstrparms.String_Arg[25],30))

	bAddSKU = TRUE
	ls_label_type = "LOBLAW"
ELSEIF Pos( UPPER(lstrparms.String_arg[7]), 'SHOPPERS', 1 ) > 0  THEN
	lsFormat = uf_read_label_Format('PHX_BRNDS_Shoppers_zebra_ship.DWN')
	ls_label_type = "SDM"
	
ELSEIF Pos( UPPER(lstrparms.String_arg[7]), 'TARGET', 1 ) > 0  THEN
	lsFormat = uf_read_label_Format('PHX_BRNDS_target_zebra_ship.txt') /* 12/04 - PCONKL - Using Labelvision */
	ls_label_type =  "TAR"

ELSEIF Pos( UPPER(lstrparms.String_arg[7]), 'WALGREENS', 1 ) > 0  THEN
	return uf_phx_brands_wag_zebra_ship( lstrparms , Upper(ls_label_type) )
	ls_label_type =  "WGN"

ELSEIF Pos( UPPER(lstrparms.String_arg[7]), 'WAL-MART', 1 ) > 0 OR Pos( UPPER(lstrparms.String_arg[7]), 'WALMART', 1 ) > 0  OR Pos( UPPER(lstrparms.String_arg[7]), "SAM'S", 1 ) > 0 THEN
	lsFormat = uf_read_label_Format('PHX_BRNDS_wmt_zebra_ship.txt') /* 12/04 - PCONKL - Using Labelvision */
	ls_label_type =  "WMT"

ELSEIF Pos( UPPER(lstrparms.String_arg[7]), 'ZELLERS', 1 ) > 0 OR Pos( UPPER(lstrparms.String_arg[7]), "ZELLER'S", 1 ) > 0 THEN
	lsFormat = uf_read_label_Format('PHX_BRNDS_Zeller_zebra_ship.DWN')	
	ls_label_type =  "ZEL"

ELSEIF Pos( UPPER(lstrparms.String_arg[7]), 'HANCOCK', 1 ) > 0 THEN // OR Pos( UPPER(lstrparms.String_arg[7]), "ZELLER'S", 1 ) > 0
	lsFormat = uf_read_label_Format("phx_brands_hancock_ship_zebra.txt") /* 2010/09/14 - Jxlim - Using Labelvision */	
	lsFormat = uf_Replace(lsFormat,"~~ship_to_zip_BC~~","420"+left(lstrparms.String_Arg[41],12)) /*12/04 - PCONKL - LabelVision label*/
	ls_label_type =  "HAN"
	bAddSKU = TRUE

ELSEIF Pos( UPPER(lstrparms.String_arg[7]), 'ROUNDY', 1 ) > 0 THEN // OR Pos( UPPER(lstrparms.String_arg[7]), "ZELLER'S", 1 ) > 0
	lsFormat = uf_read_label_Format("phx_brands_roundys_ship_zebra.txt") /* 2010/09/14 - Jxlim - Using Labelvision */	
	lsFormat = uf_Replace(lsFormat,"~~ship_to_zip_BC~~","420"+left(lstrparms.String_Arg[41],12)) /*12/04 - PCONKL - LabelVision label*/
	lsFormat = uf_Replace(lsFormat,">=carton_no_BC>=", right(Lstrparms.String_arg[48],20)) 

	datastore lds_lot_no
	integer li_idx
	String ls_lot_no 
	
	lds_lot_no = create datastore;
	lds_lot_no.dataobject = "d_phxbrands_lot_no"
	lds_lot_no.SetTransObject(SQLCA)
	
	lds_lot_no.Retrieve( lstrparms.string_arg[59], lstrparms.string_arg[55])

	if lds_lot_no.RowCount() > 0 then
		
		if lds_lot_no.RowCount() = 1 then
			
			ls_lot_no = lds_lot_no.object.lot_no[1]
		else
			for li_idx= 1 to lds_lot_no.RowCount()
				
				if li_idx <> 1 then 	ls_lot_no = ls_lot_no + ","
			
				ls_lot_no = ls_lot_no + lds_lot_no.object.lot_no[li_idx]
			
			next
		end if
	
	end if

	If Isnull(ls_lot_no) then ls_lot_no = ''
	lsFormat = uf_Replace(lsFormat,"~~lot_no~~", ls_lot_no)
	
	ls_label_type =  "ROU"	
	bAddSKU = TRUE

//Comment True value shipping code
//Jxlim 10/04/2013 Truevalue GS1-128 Shiiping label used on pallets L13M046 KPB

ELSEIF ( Pos( UPPER(lstrparms.String_arg[7]), 'TRUEVALUE', 1 ) > 0 ) Or ( Pos( UPPER(lstrparms.String_arg[7]), 'TRUE VALUE', 1 )  > 0 )  THEN	
	lsFormat = uf_read_label_Format('phx_brands_truevalue_ship_zebra.txt') /* 2008/05/16 - MEA - Using Labelvision */
	ls_label_type = "TRV"   //TrueValue	
	lsFormat = uf_Replace(lsFormat,"~~bol_nbr~~",left(lstrparms.String_Arg[34],12)) //BOL
	lsFormat = uf_Replace(lsFormat,"~~sku~~",left(lstrparms.String_Arg[55],30))  //SKU	
	lsFormat = uf_Replace(lsFormat,"~~alloc_qty~~",lstrparms.String_Arg[51],12)  //QTY
	
//	lsFormat = uf_Replace(lsFormat,">;>=ship_to_zip_bc>=","420"+left(lstrparms.String_Arg[41],12))   //Jxlim 11/20/2013 to included Function code 1
	//lsFormat = uf_Replace(lsFormat,">;>8>=ship_to_zip_bc>=","420"+left(lstrparms.String_Arg[41],15))  //Jxlim Before 01/30/2014
	lsFormat = uf_Replace(lsFormat,">=ship_to_zip_bc>=","420"+left(lstrparms.String_Arg[41],15))  //Jxlim After 01/30/2014
	
//	lsFormat = uf_Replace(lsFormat,">;>=carton_no_bc>=", right(Lstrparms.String_arg[48],20))  //Jxlim 11/20/2013 to included Function code 1
//	lsFormat = uf_Replace(lsFormat,">;>8>=carton_no_bc>=", right(Lstrparms.String_arg[48],20)) //Jxlim Before 01/30/2014
	lsFormat = uf_Replace(lsFormat,">=carton_no_bc>=", right(Lstrparms.String_arg[48],20)) //Jxlim After 01/30/2014
	lsFormat = uf_Replace(lsFormat,"~~Carrier_name~~",left(lstrparms.String_Arg[62],30))	//Carrier name
	lsFormat = uf_Replace(lsFormat,"~~Carrier_code~~",left(lstrparms.String_Arg[61],30))  //SCAC Carrier code

//01-Nov-2014 :Madhu- Added for United Stationers -START
ELSEIF 	( Pos( UPPER(lstrparms.String_arg[7]), 'UNITED', 1 ) > 0 ) Or ( Pos( UPPER(lstrparms.String_arg[7]), 'UNITED', 1 )  > 0 )  THEN
	lsFormat = uf_read_label_Format('phx_brands_united_stationers.txt')
	ls_label_type = "UNITED"   //United Stationers	
	lsFormat = uf_Replace(lsFormat,"~~bol_nbr~~",left(lstrparms.String_Arg[34],12)) //BOL
	lsFormat = uf_Replace(lsFormat,"~~sku~~",left(lstrparms.String_Arg[55],30))  //SKU	
	lsFormat = uf_Replace(lsFormat,"~~Carrier_name~~",left(lstrparms.String_Arg[62],30))	//Carrier name
	lsFormat = uf_Replace(lsFormat,">;>=ship_to_zip_bc>=",left(lstrparms.String_Arg[41],12))
	lsFormat = uf_Replace(lsFormat,">;>=carton_no_bc>=", right(Lstrparms.String_arg[48],20)) 
//01-Nov-2014 :Madhu- Added for United Stationers -END

//14-APR-2015 :Madhu- Added for Essendant -START
ELSEIF 	( Pos( UPPER(lstrparms.String_arg[7]), 'ESSENDANT', 1 ) > 0 ) Or ( Pos( UPPER(lstrparms.String_arg[7]), 'ESSENDANT', 1 )  > 0 )  THEN
	lsFormat = uf_read_label_Format('phx_brands_united_stationers.txt')
	ls_label_type = "ESSENDANT"   //ESSENDANT Boston	
	lsFormat = uf_Replace(lsFormat,"~~bol_nbr~~",left(lstrparms.String_Arg[34],12)) //BOL
	lsFormat = uf_Replace(lsFormat,"~~sku~~",left(lstrparms.String_Arg[55],30))  //SKU	
	lsFormat = uf_Replace(lsFormat,"~~Carrier_name~~",left(lstrparms.String_Arg[62],30))	//Carrier name
	lsFormat = uf_Replace(lsFormat,">;>=ship_to_zip_bc>=",left(lstrparms.String_Arg[41],12))
	lsFormat = uf_Replace(lsFormat,">;>=carton_no_bc>=", right(Lstrparms.String_arg[48],20)) 
//14-APR-2015 :Madhu- Added for Essendant -END

		//nxjain 10/07/2013 TBD Shipping label on pallets L13M046 KPB
 ELSEIF Pos( UPPER(lstrparms.String_arg[7]), 'TBD', 1 ) > 0 OR Pos( UPPER(lstrparms.String_arg[7]), 'TBD', 1 ) > 0 THEN	
		lsFormat = uf_read_label_Format('phx_brands_TBD_ship_zebra.txt') /* 2008/05/16 - MEA - Using Labelvision */
		ls_label_type = "TBD"   //	
		lsFormat = uf_Replace(lsFormat,"~~bol_nbr~~",left(lstrparms.String_Arg[34],12)) //BOL
		lsFormat = uf_Replace(lsFormat,"~~sku~~",left(lstrparms.String_Arg[55],30))  //SKU	
		lsFormat = uf_Replace(lsFormat,"~~alloc_qty~~",lstrparms.String_Arg[51],12)  //QTY
		lsFormat = uf_Replace(lsFormat,">;>=ship_to_zip_bc>=","420"+left(lstrparms.String_Arg[41],12))
		lsFormat = uf_Replace(lsFormat,">;>=carton_no_bc>=", right(Lstrparms.String_arg[48],20)) 
		lsFormat = uf_Replace(lsFormat,">;>=store_bc>=", right(Lstrparms.String_arg[43],20) )
		lsFormat = uf_Replace(lsFormat,"~~Carrier_name~~",left(lstrparms.String_Arg[25],20))
		
		 ls_Dono	=	lstrparms.string_arg[40] 
 		 lssku	=	lstrparms.string_arg[55] 
			
		Select DD.User_Field2 , DP.Country_Of_Origin into :ls_upc , :ls_coo
		from Delivery_Packing DP,Delivery_Detail DD
		where DD.DO_No = DP.DO_No and DD.SKU =DP.SKU and	DD.DO_No =:ls_dono and dd.SKU =:lssku ;
			
	

	
		lsFormat = uf_Replace(lsFormat,"~~COO~~", ls_coo ,20)  //COO 
		lsFormat = uf_Replace(lsFormat,"~~upc~~",ls_upc,20)  //UPC	
		
ELSE		

	//Default
	//	lsFormat = uf_read_label_Format('generic_zebra_ship_UCC.DWN') 
	// TAM 11/12/04  Fix 9 digit postal code (420######)

	lsFormat = uf_read_label_Format('PHX_BRNDS_generic_zebra_ship_UCC.DWN') 

END IF
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
//MessageBox ("ok", 	ls_label_type)
	
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
lsFormat = uf_Replace(lsFormat,"~~invoice_no~~",Left(lstrparms.String_Arg[17],20))	

//Today's date 
lsFormat = uf_Replace(lsFormat,"~~today,0030~~",string(today(),"mmm dd, yyyy"))
	
//Carrier Name
lsFormat = uf_Replace(lsFormat,"~~carrier name,0040~~",left(lstrparms.String_Arg[25],40)) //Jxlim
lsFormat = uf_Replace(lsFormat,"~~carrier_name,0030~~",left(lstrparms.String_Arg[25],30))

lsFormat = uf_Replace(lsFormat,"~~carrier_name,0020~~",left(lstrparms.String_Arg[25],20))
lsFormat = uf_Replace(lsFormat,"~~carrier_name~~",left(lstrparms.String_Arg[25],20))



lsFormat = uf_Replace(lsFormat,"~~pro,0015~~",left(lstrparms.String_Arg[45],15))
lsFormat = uf_Replace(lsFormat,"~~pro~~",left(lstrparms.String_Arg[45],15)) //Jxlim 09/15/2010 added for pro number (HEB)

lsFormat = uf_Replace(lsFormat,"~~bol_nbr,0015~~",left(lstrparms.String_Arg[17],15))

lsFormat = uf_Replace(lsFormat,"~~bol_nbr~~",left(lstrparms.String_Arg[17],15))

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


IF ls_label_type = "BIG"  OR ls_label_type = "HAN"  OR ls_label_type = "ROU" THEN	

//	lsFormat = uf_Replace(lsFormat,"~~tot_off~~","1 of 2")	
	

//	lsFormat = uf_Replace(lsFormat,"~~sku~~",left(lstrparms.String_Arg[55],15))
//	lsFormat = uf_Replace(lsFormat,"~~sku_count~~","")
//	lsFormat = uf_Replace(lsFormat,"~~vpn~~","")
//	
//	lsFormat = uf_Replace(lsFormat,"~~upc~~",left(lstrparms.String_Arg[64],12))
//	lsFormat = uf_Replace(lsFormat,"~~upc_bc~~",left(lstrparms.String_Arg[64],12))	
//	
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

	lsFormat = uf_Replace(lsFormat,"~~store~~",left(lstrparms.String_Arg[63],5))
	
	
	lsFormat = uf_Replace(lsFormat,"~~store_bc~~","19" + left(lstrparms.String_Arg[63],5))	
	

	lsFormat = uf_Replace(lsFormat,"~~mark_for~~",left(lstrparms.String_Arg[63],5))		

	lsFormat = uf_Replace(lsFormat,">=carton_no_BC>=", right(Lstrparms.String_arg[48],20)) 
	
END IF



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

CHOOSE CASE Upper(ls_label_type)

CASE "ZEL"
//if ls_label_type = "ZEL" then
	lsFormat = uf_Replace(lsFormat,"~~carton_no_BC,0019~~", "00" + "1" + mid(right(Lstrparms.String_arg[48],18),2))
	lsFormat = uf_Replace(lsFormat,"~~carton_no_readable,0018~~","1"+ mid(right(Lstrparms.String_arg[48],18),2)) /* 00 already on label as text field but included in barcode*/

CASE "KMT"
	lsFormat = uf_Replace(lsFormat,"~~carton_no_bc~~", right(Lstrparms.String_arg[48],20)) /* 12/04 - PCONKL - Labelvision */
	lsFormat = uf_Replace(lsFormat,"~~carton_no_readable~~", String(Lstrparms.String_arg[48],"(@@) @ @@@@@@@ @@@@@@@@@ @")) /*  12/04 - LabelVision*/

CASE "BIG", "HAN"


	lsFormat = uf_Replace(lsFormat,"~~carton_no_bc~~", right(Lstrparms.String_arg[48],20))
	lsFormat = uf_Replace(lsFormat,"~~carton_no_readable~~", right(Lstrparms.String_arg[48],18))

	lsFormat = uf_Replace(lsFormat,"~~alt_sku~~", lstrparms.string_arg[58])
	


CASE ELSE
//else
//	Lstrparms.String_arg[48]='99  99999  99999  1'

	lsFormat = uf_Replace(lsFormat,"~~carton_no_BC,0019~~", right(Lstrparms.String_arg[48],20))
	lsFormat = uf_Replace(lsFormat,"~~carton_no_bc~~", right(Lstrparms.String_arg[48],20)) /* 12/04 - PCONKL - Labelvision */
	lsFormat = uf_Replace(lsFormat,"~~carton_no_readable,0018~~", right(Lstrparms.String_arg[48],18)) /* 00 already on label as text field but included in barcode*/
	lsFormat = uf_Replace(lsFormat,"~~carton_no_readable~~", right(Lstrparms.String_arg[48],18)) /*  12/04 - LabelVision*/

END CHOOSE
//end if 

string ls_Part_UPC_Code

If IsNull(ls_Part_UPC_Code) then ls_Part_UPC_Code = ''

ls_Part_UPC_Code = lstrparms.string_arg[52]

lsFormat = uf_Replace(lsFormat,"~~upc~~", ls_Part_UPC_Code)

IF ls_label_type = "BIG" THEN
	
	lsFormat = uf_Replace(lsFormat,"~~upc_bc~~", ls_Part_UPC_Code)	
	lsFormat = uf_Replace(lsFormat,"~~sku~~", Lstrparms.string_arg[55])	

END IF

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

////////////////////////////////////////////////////////////////////
//BCR 30-AUG-2011; Project ID - L11P027: We need to add up to 3 SKUs for each print job...
IF bAddSKU THEN

	//For each Carton No, find how many rows of it is on w_do.idw_pack, as well as their corresponding SKUs. 
  	//Then display all SKUs associated with this Carton, up to a max of 3, on the Shipping Label...
	//For next Carton, check to see if it's same as previous. If YES, don't send to printer (so we correctly print out one Label per Carton!)
  	//If NO, then repeat the process of finding how many rows of it, etc.
	
	lsCartonNo = lstrparms.String_Arg[12]
	
	//First check to see if you have processed this Carton No previously...
	IF isCartonNo = lsCartonNo THEN 
		//Close PrintJob...
		PrintClose(llPrintJob)
		RETURN 0
	END IF

     //Otherwise, continue...			
	lsPackFind = "Upper(carton_no) = '" + Upper(lsCartonNo) + "'" 
	llPackFindRow = w_do.idw_Pack.Find(lsPackFind,1, w_do.idw_pack.RowCount())
	
	//There is this ANNOYING  data inconsistency in SIMS whereby some Carton Nos are saved as numeric and some as string! Aaarrrgghhh!
	IF llPackFindRow = 0 THEN //This, ordinarily should not have been possible!
		//Re-run the above block as if Carton No is string
		//First, remove any leading zeros it might have been padded with...
		IF IsNumber(lstrparms.String_Arg[12]) THEN
			lsCartonNo = String(Long(lstrparms.String_Arg[12])) 
		END IF
	
		//First check to see if you have processed this Carton No previously...
		IF isCartonNo = lsCartonNo THEN 
			//Close PrintJob...
			PrintClose(llPrintJob)
			RETURN 0
		END IF
	
		//Otherwise, continue...			
		lsPackFind = "Upper(carton_no) = '" + Upper(lsCartonNo) + "'" 
		llPackFindRow = w_do.idw_Pack.Find(lsPackFind,1, w_do.idw_pack.RowCount())
	END IF
		
	Do While llPackFindRow > 0 
		//Initialize SKU count for this Carton No
		liSkuCount++
		ls_sku[liSkuCount] = w_do.idw_Pack.GetITemString(llPackFindRow,'SKU')
				
		//Exit loop after the 3rd SKU
		IF liSkuCount = 3 THEN EXIT
		
		//Otherwise, find next row...
		llPackFindRow++
		llPackFindRow = w_do.idw_Pack.Find(lsPackFind,llPackFindRow, w_do.idw_pack.RowCount()+1)
		
	LOOP
	
	//Save this Carton No in instance memory for later comparison...
	isCartonNo = lsCartonNo
	
	//Display up to 3 SKUs per Carton
	IF liSkuCount = 1 THEN
		lsFormat = uf_Replace(lsFormat,"~~sku~~", ls_sku[1])
	ELSEIF liSkuCount = 2 THEN
		lsFormat = uf_Replace(lsFormat,"~~sku~~", ls_sku[1]+', '+ls_sku[2])
	ELSEIF liSkuCount = 3 THEN
		lsFormat = uf_Replace(lsFormat,"~~sku~~", ls_sku[1]+', '+ls_sku[2]+', '+ls_sku[3])
	END IF
	

END IF //END of L11P027
////////////////////////////////////////////////////////////////////////
	
//No of copies
ll_no_of_copies = lstrparms.Long_Arg[1]
FOR i= 1 TO ll_no_of_copies
	lsFormat = uf_Replace(lsFormat,"~~tot_off,0030~~",left(lstrparms.String_Arg[28],30))
	lsFormat = uf_Replace(lsFormat,"~~tot_off~~",left(lstrparms.String_Arg[28],30))
	lsFormat = uf_Replace(lsFormat,"~~sku_count~~",left(lstrparms.String_Arg[57],30))
	PrintSend(llPrintJob, lsformat)	
	ls_temp= lstrparms.String_Arg[28]
NEXT
	
PrintClose(llPrintJob)
	

Return 0


end function

on n_label_phx_brands.create
call super::create
end on

on n_label_phx_brands.destroy
call super::destroy
end on

