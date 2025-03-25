$PBExportHeader$u_nvo_proc_runnerworld.sru
forward
global type u_nvo_proc_runnerworld from nonvisualobject
end type
end forward

global type u_nvo_proc_runnerworld from nonvisualobject
end type
global u_nvo_proc_runnerworld u_nvo_proc_runnerworld

forward prototypes
public function integer uf_process_dboh ()
public function string getrunworldinvtype (string asinvtype)
end prototypes

public function integer uf_process_dboh ();//24-Apr-2013 :Madhu - Added code to generate BOH for RUN-WORLD

Integer	liRC, liFileNo
Long	llRowCount, llRowPos, llNewRow,  llQty
String	lsOutString,  lsLogOut,  lsFIleName, lsSupplierSave, lsSupplier
string ERRORS, sql_syntax
string	lsBondedWhsInvTypes
Decimal	ldBatchSeq
Datastore	 ldsInv, ldsOut
DateTime	ldtToday, ldtNow

//Convert GMT to SIN Time
ldtNow = DateTime(today(),Now())
select Max(dateAdd( hour, 8,:ldtNow )) into :ldtToday
from sysobjects;

lsLogOut = ""
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
lsLogOut = "- PROCESSING FUNCTION: RUN-WORLD Daily Inventory Snapshot File... " 
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
lsLogOut = ""
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/

//Create datastore
ldsInv = Create Datastore

ldsOut = Create Datastore
ldsOut.Dataobject = 'd_edi_generic_out'

sql_syntax = "SELECT WH_Code, SKU,Supp_code,  inventory_type,   Sum( Avail_Qty  ) + Sum( alloc_Qty  )  as 'total_qty'   " 
sql_syntax += "from Content_Summary"
sql_syntax += " Where Project_ID = 'RUN-WORLD'"
sql_syntax += " Group by Wh_Code, SKU,Supp_code, Inventory_Type "
sql_syntax += " Having Sum( Avail_Qty  ) + Sum( alloc_Qty  )   > 0 "
sql_syntax += " Order by wh_code, Supp_code, SKU;  "

ldsInv.Create(SQLCA.SyntaxFromSQL(sql_syntax,"", ERRORS))
IF Len(ERRORS) > 0 THEN
   lsLogOut = "        *** Unable to create datastore for RUN-WORLD Inventory Snapshot ID data.~r~r" + Errors
	FileWrite(gilogFileNo,lsLogOut)
   RETURN - 1
END IF

lirc = ldsInv.SetTransobject(sqlca)

//Retrieve the Inv Data
lsLogout = 'Retrieving Inventory Data.....'
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(giLogFileNo,lsLogOut)

llRowCount = ldsInv.Retrieve()


lsLogOut = String(llRowCount) + ' Rows were retrieved for processing.'
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(gilogFileNo,lsLogOut)

For llRowPos = 1 to llRowCOunt
	
	lsSUpplier = ldsInv.GetItemString(llRowPos,'supp_code')
	
	If lsSupplier <> lsSupplierSave Then
		
		//Write Previous supplier if any data
		If ldsOut.RowCount() > 0 Then
			gu_nvo_process_files.uf_process_flatfile_outbound(ldsOut,'RUN-WORLD')
			ldsOut.Reset()
		End If
		
		//Next File Sequence #...
		ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no("RUN-WORLD",'EDI_Generic_Outbound','EDI_Batch_Seq_No')
		If ldBatchSeq <= 0 Then
			lsLogOut = "        *** Unable to retrieve the next available sequence number for RUN-WORLD BOH file. Confirmation will not be sent'"
			FileWrite(gilogFileNo,lsLogOut)
			Return -1
		End If
	
	End If /* Supplier Chnaged*/
	
	
	llNewRow = ldsOut.insertRow(0)
	lsOutString = 'BH|' /*rec type = balance on Hand Confirmation*/
	lsOutString += String(ldtToday,'YYYYMMDDHHMM') + "|"
	lsOutString += ldsInv.GetItemString(llRowPos,'sku') + '|'
	lsOutString += string(ldsInv.GetItemNumber(llRowPos,'total_qty'),'############0')  + '|'
	lsOutString += ldsInv.GetItemString(llRowPos,'supp_code') + '|'
	lsOutString += getrunworldinvtype(ldsInv.GetItemString(llRowPos,'inventory_type')) /*Convert to Run-World Type */
	
	ldsOut.SetItem(llNewRow,'Project_id', 'RUN-WORLD')
	ldsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	ldsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	ldsOut.SetItem(llNewRow,'batch_data', lsOutString)
	ldsOut.SetItem(llNewRow,'file_name', 'BH' + String(ldbatchSeq,'000000') + ".DAT")
	
	lsSupplierSave = lsSupplier
	
Next /*next output record */

//Write last/Only
If ldsOut.RowCount() > 0 Then
	gu_nvo_process_files.uf_process_flatfile_outbound(ldsOut,'RUN-WORLD')
End If
end function

public function string getrunworldinvtype (string asinvtype);
//Convert the Menlo Onventory Type into the Phillips code

String	lsrunworldInvType
Choose case upper(asInvType)
		
	Case '8'
		lsrunworldInvType = 'COMPONENT CHILD'
	Case 'D'
		lsrunworldInvType = 'DAMAGED'
	Case 'H'
		lsrunworldInvType = 'HOLD'
	Case 'N'
		lsrunworldInvType = 'Normal'
	Case Else
		lsrunworldInvType = asInvType
End Choose

Return lsrunworldInvType


end function

on u_nvo_proc_runnerworld.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_nvo_proc_runnerworld.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

