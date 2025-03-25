$PBExportHeader$u_nvo_proc_klonelab.sru
forward
global type u_nvo_proc_klonelab from nonvisualobject
end type
end forward

global type u_nvo_proc_klonelab from nonvisualobject
end type
global u_nvo_proc_klonelab u_nvo_proc_klonelab

type prototypes

Function Long MultiByteToWideChar(UnsignedLong CodePage, Ulong dwFlags, string lpMultiByteStr, Long cbMultiByte,  REF blob lpWideCharStr, Long cchWideChar) Library "kernel32.dll" alias for "MultiByteToWideChar;Ansi" 

end prototypes

type variables

string lsDelimitChar

datastore ids_nike_sku_serialized_ind 

u_nvo_proc_baseline_unicode 	iu_nvo_proc_baseline_unicode
end variables

forward prototypes
public function integer uf_process_files (string asproject, string aspath, string asfile, string asinifile)
public function integer uf_replace_quote (ref string as_string)
protected function integer uf_process_delivery_order (string aspath, string asproject)
end prototypes

public function integer uf_process_files (string asproject, string aspath, string asfile, string asinifile);//Process the correct file type based on the first 4 characters of the file name

String	lsLogOut,	&
			lsSaveFileName, &
			lsPOLineCountFileName
			
Integer	liRC
integer 	liLoadRet, liProcessRet
Boolean	bRet

u_nvo_proc_baseline_unicode		lu_nvo_proc_baseline_unicode

Choose Case Upper(Left(asFile,2))
		
	Case  'PM'  
		
		lu_nvo_proc_baseline_unicode = Create u_nvo_proc_baseline_unicode	
		
		liRC = lu_nvo_proc_baseline_unicode.uf_process_purchase_order(asPath, asProject)
	
		//Process any added PO's
		//We need to change to project. This will be changed after testing.
		liRC = gu_nvo_process_files.uf_process_purchase_order(asProject)  //asProject

	Case  'DM'  
		
		liLoadRet = uf_process_delivery_order(asPath, asProject)
			
		//Process any added SO's
		liProcessRet = gu_nvo_process_files.uf_process_Delivery_order(asProject)
		
		
		if liLoadRet = -1 OR liProcessRet = -1 then liRC = -1 else liRC = 0
		

		
	Case 'IM'
		
		lu_nvo_proc_baseline_unicode = Create u_nvo_proc_baseline_unicode	
		
		liRC = lu_nvo_proc_baseline_unicode.uf_Process_ItemMaster(asPath, asProject)
		

	Case  'RM'  
		
		lu_nvo_proc_baseline_unicode = Create u_nvo_proc_baseline_unicode	
		
		liRC = lu_nvo_proc_baseline_unicode.uf_return_order(asPath, asProject)
	
		//Process any added PO's
		//We need to change to project. This will be changed after testing.
		liRC = gu_nvo_process_files.uf_process_purchase_order('CHINASIMS')  //asProject
		
		

	Case Else /*Invalid file type*/
		
		lsLogOut = "        Invalid File Type: " + asFile + " - File will not be processed."
		FileWrite(gilogFileNo,lsLogOut)
		gu_nvo_process_files.uf_writeError(lsLogout)
		Return -1
		
End Choose

Return liRC
end function

public function integer uf_replace_quote (ref string as_string);string lsquote, lsreplace_with

lsquote = "'"
lsreplace_with = "~~~'"

long ll_start_pos, len_lsquote
ll_start_pos=1
len_lsquote = len(lsquote) 

//find the first occurrence of ls_quote... 
ll_start_pos = Pos(as_string ,lsquote,ll_start_pos) 

//only enter the loop if you find whats in lsquote
DO WHILE ll_start_pos > 0 
	 //replace llsquote with lsreplace_with ... 
	 as_string = Replace(as_string,ll_start_pos,Len_lsquote,lsreplace_with) 
	 //find the next occurrence of lsquote
	ll_start_pos = Pos(as_string,lsquote,ll_start_pos+Len(lsreplace_with)) 
LOOP 

return 0
end function

protected function integer uf_process_delivery_order (string aspath, string asproject);
string ls_null, ls_date,lsShippingInstruction
string ls_find
integer licount
boolean lb_error_order_sku = false
datetime ldtToday, ldtOrderDate,ld_date
long llRowCount, llbatchseq, llOrderSeq
integer liIdx, liFind

SetNull(ls_null)

//Process Delivery Order


u_ds_datastore 	ldsSOheader,	ldsSOdetail, ldsDOAddress, ldsDONotes
u_ds_datastore 	ldsImport

integer lirc
boolean lberror
string lslogout

//Call the generic load

u_nvo_proc_baseline_unicode lu_nvo_proc_baseline_unicode

lu_nvo_proc_baseline_unicode = create u_nvo_proc_baseline_unicode	


lirc = lu_nvo_proc_baseline_unicode.uf_load_delivery_order(aspath, asproject, ldsImport, ldsSOheader, ldsSOdetail, ldsDOAddress, ldsDONotes)	
	
IF lirc = -1 then lbError = true else lbError = false	

//

//Put check for cust_code in there.

//o	Do a lookup against Lookup Table to retrieve the TRAX Pack Location
//	Based on Project_id, Code_Type = “traxPackLocation” and Code_Id = new value from trax_acct_no. If a value exists in Code_Descript, copy it to “trax_pack_location” (field being added to d_baseline_Unicode_shp_header)
//	Only move the account number from UF11 to trax_acct_no if no entry is found in the lookup table. This will indicate 3rd party billing using the default Pack Location.
//	If no entry is found and we are setting trax_acct_no, we also want to set freight_terms to “THIRDPARTY”
//	If we are setting the Freight Terms to “THIRDPARTY”, we also want to create a Trax 3rd Party Address record if the Bill To Address record has been created.
//•	The baseline logic creates a Delivery_address record with address_type = ‘BT’ if the Bill to fields are present. In the new custom NVO, We want to update the Address_Type to ‘3P’ if we created a ‘BT’ record.

String lsTRAXAcctNo, lsTRAXPackLocation


llRowCount = ldsSOheader.RowCount()




string lsCustCode, lsFreightTerms


For liIdx =  1 to ldsSOheader.RowCount() 
	
	
	//Set Format for delivery_date

	ls_date =  ldsSOheader.GetItemString( liIdx, "ord_date")
	
	if len(ls_date) >= 8 then
		 ls_date = left(ls_date,4) + "/" + mid(ls_date,5,2) + "/" +  mid(ls_date,7,2) + " 00:00:00"
		 ldsSOheader.SetItem( liIdx, "ord_date",ls_date)
	end if 
	
	//TAM 2015/06/12 Set Format for request_date

	ls_date =  ldsSOheader.GetItemString( liIdx, "request_date")
	
	if len(ls_date) = 8 then
//		 ls_date = mid(ls_date,7,2)  + "/" + mid(ls_date,5,2) + "/" +  left(ls_date,4)
		 ls_date = left(ls_date,4) + "/" + mid(ls_date,5,2) + "/" +  mid(ls_date,7,2) 
		 ldsSOheader.SetItem( liIdx, "request_date",ls_date)
	end if 

	
	
	
	lsCustCode = ldsSOHeader.GetItemString(liIdx, "Cust_Code")

	if IsNull(lsCustCode) or Trim(lsCustCode) = '' then 
		ldsSOHeader.SetItem(liIdx, "Cust_Code", '0')            
	end if
	
	lsFreightTerms = ldsSOHeader.GetItemString(liIdx, "Freight_Terms")
	
	CHOOSE CASE Trim(lsFreightTerms)
	
	CASE 'PP'
		ldsSOHeader.SetItem(liIdx, "Freight_Terms", 'PREPAID')                       
	CASE 'CC'
       	 ldsSOHeader.SetItem(liIdx, "Freight_Terms", 'COLLECT')
	CASE 'TP'	
		ldsSOHeader.SetItem(liIdx, "Freight_Terms", 'THIRDPARTY')
		
		llbatchseq = ldsSOHeader.GetItemNumber(liIdx,'edi_batch_seq_no')
		llOrderSeq = ldsSOHeader.GetItemNumber(liIdx,'order_seq_no')
	
		
		//The baseline logic creates a Delivery_address record with address_type = ‘BT’ if the Bill to fields are present. In the new custom NVO, We want to update the Address_Type to ‘3P’ if we created a ‘BT’ record.
			 	
		liFind = 0	 
			 
		liFind =  ldsDOAddress.Find("edi_batch_seq_no = " + string(llbatchseq) + " and order_seq_no = " + string(llOrderSeq), liFind + 1,  ldsDOAddress.RowCount())
		
		DO 
			
			if liFind > 0 then
				ldsDOAddress.SetItem(liFind,'address_type','3P') 
				
				if liFind < ldsDOAddress.RowCount() then 
				
					liFind =  ldsDOAddress.Find("edi_batch_seq_no = " + string(llbatchseq) + " and order_seq_no = " + string(llOrderSeq), liFind + 1,  ldsDOAddress.RowCount())

				end if

			end if
			
			
			
		LOOP UNTIL liFind = 0 or  liFind >= ldsDOAddress.RowCount()
		
		
	END CHOOSE


	lsTRAXAcctNo = ldsSOHeader.GetItemString(liIdx, "user_field11")

	SELECT Code_Descript INTO :lsTRAXPackLocation FROM Lookup_Table With (NoLock)
		WHERE Project_ID = :asproject AND
				Code_Type = 'traxPackLocation' AND
				Code_Id = :lsTRAXAcctNo 
		USING SQLCA;
	
	lsLogOut = "SQLCA: " + String(SQLCA.SQLCode)
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/ 
	
	IF SQLCA.SQLCode >= 0 THEN
					
		IF SQLCA.SQLCode = 100 THEN
		
			//Not Found
			
			//Only move the account number from UF11 to trax_acct_no if no entry is found in the lookup table. This will indicate 3rd party billing using the default Pack Location.

			 ldsSOHeader.SetItem(liIdx, "trax_acct_no", ldsSOHeader.GetItemString(liIdx,"user_field11"))
			 
			 
			 //If no entry is found and we are setting trax_acct_no, we also want to set freight_terms to 'THIRDPARTY'
			 
//			  ldsSOHeader.SetItem(liIdx, "freight_terms", 'THIRDPARTY')	
				
		ELSE
			
			//Found
			
			If Not IsNull(lsTRAXPackLocation) and Trim(lsTRAXPackLocation) <> '' then
				 ldsSOHeader.SetItem(liIdx, "trax_pack_location",lsTRAXPackLocation)
			End IF
			
		END IF
	
	ELSE
		
		//Error
		
	END IF

	
	//SARUN2013DEC05  Converting Shipping insturction to dates and Mapping Start and Cancel Dates to  Freight_ETD,Freight_ATA http://team/sites/simsteam/wiki/Documents/Customers/KloneLab/Klone%20Changes%20-%20start%20and%20cancel%20date%20mapping.docx

	If ldsSOHeader.GetItemString(liIdx,'shipping_instructions_text') > ' ' Then
		lsShippingInstruction = ldsSOHeader.GetItemString(liIdx,'shipping_instructions_text') 

		 ld_date = datetime(left(lsShippingInstruction,10) + " 00:00:00")
		 ldsSOheader.SetItem( liIdx, "Freight_ETD",ld_date)
		 ld_date = datetime(mid(lsShippingInstruction,14,10) + " 00:00:00")
		 ldsSOheader.SetItem( liIdx, "Freight_ATA",ld_date)

	End If


NEXT

//Need to change to Order Type to 'M' 

string lsJNoteType

For liIdx =  1 to ldsDONotes.RowCount() 
	
	if ldsDONotes.GetItemString(liIdx, "note_type") = 'MR' then
	
		llbatchseq = ldsDONotes.GetItemNumber(liIdx,'edi_batch_seq_no')
		llOrderSeq = ldsDONotes.GetItemNumber(liIdx,'order_seq_no')
	
		liFind =  ldsSOheader.Find("edi_batch_seq_no = " + string(llbatchseq)  + " and order_seq_no = " + string(llOrderSeq), liFind + 1,  ldsSOheader.RowCount())

		if liFind > 0 then
			 ldsSOHeader.SetItem(liFind,'Order_Type','M')
		end if
	
	end if
	
Next

//Save the Changes 
SQLCA.DBParm = "disablebind =0"
lirc = ldsSOheader.Update()
SQLCA.DBParm = "disablebind =1"

	
If liRC = 1 Then
//	SQLCA.DBParm = "disablebind =0"
	liRC = ldsSOdetail.Update()
//	SQLCA.DBParm = "disablebind =1"
	
ELSE
	lsLogOut = Space(17) + "- ***System Error!  Unable to Save new SO Header Records to database!"
	FileWrite(gilogFileNo,lsLogOut)
	gu_nvo_process_files.uf_writeError("- ***System Error!  Unable to Save new SO Records to database!")
	Return -1
End If



If liRC = 1 Then
	
//	Execute Immediate "COMMIT" using SQLCA; COMMIT USING SQLCA;
	SQLCA.DBParm = "disablebind =0"
	liRC = ldsDOAddress.Update()
	SQLCA.DBParm = "disablebind =1"
ELSE	
//	Execute Immediate "ROLLBACK" using SQLCA;
	lsLogOut = Space(17) + "- ***System Error!  Unable to Save new SO Detail Records to database!"
	FileWrite(gilogFileNo,lsLogOut)
	gu_nvo_process_files.uf_writeError("- ***System Error!  Unable to Save new SO Records to database!")
	Return -1
End If

//BCR 12-DEC-2011: For Geistlich...
If liRC = 1 Then
	SQLCA.DBParm = "disablebind =0"
	liRC = ldsDONotes.Update()
	SQLCA.DBParm = "disablebind =1"	
ELSE
	lsLogOut = Space(17) + "- ***System Error!  Unable to Save new DO Address Records to database!"
	FileWrite(gilogFileNo,lsLogOut)
	gu_nvo_process_files.uf_writeError("- ***System Error!  Unable to Save new SO Records to database!")
	Return -1
End If
//END

	
If liRC = 1 then
//	Commit;
Else
	
//	Execute Immediate "ROLLBACK" using SQLCA; 
	lsLogOut = Space(17) + "- ***System Error!  Unable to Save new SO Records to database!"
	FileWrite(gilogFileNo,lsLogOut)
	gu_nvo_process_files.uf_writeError("- ***System Error!  Unable to Save new SO Records to database!")
	Return -1
End If

If lbError Then
	Return -1
Else
	Return 0
End If

end function

on u_nvo_proc_klonelab.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_nvo_proc_klonelab.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;
lsDelimitChar = char(9)
end event

