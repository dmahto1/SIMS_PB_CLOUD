$PBExportHeader$u_nvo_proc_sg_muser.sru
forward
global type u_nvo_proc_sg_muser from nonvisualobject
end type
end forward

global type u_nvo_proc_sg_muser from nonvisualobject
end type
global u_nvo_proc_sg_muser u_nvo_proc_sg_muser

type variables

				



end variables

forward prototypes
public function integer uf_process_dboh ()
public function string nonull (string as_str)
end prototypes

public function integer uf_process_dboh ();//Process the Daily Balance on Hand Report

String			sql_syntax, ERRORS, lsLogOut, lsOutString, lsFileName, lsWarehouseSave
Long			llRowPos, llRowCount, llNewRow
Int				liRC
Datastore	ldsBOH, ldsOut
Date			ldToday

ldToday = Today()

lsLogOut = "      Creating SG-MUSER Daily Balance on Hand File... " 
FileWrite(gilogFileNo,lsLogOut)

ldsOut = Create Datastore
ldsOut.Dataobject = 'd_edi_generic_out'

ldsboh = Create Datastore
//Jxlim 12/21/2010 Added Item_Master.Description and Content_Summary.Serial_no
//JXLIM 07/01/2010 Added 3 fields (ItemMaster.UserField8, Volume and ItemMaster.Group)
sql_syntax = "select complete_Date, Arrival_date, Supp_Invoice_No,  Content_Summary.wh_code, Content_Summary.sku, Content_Summary.supp_code, Content_Summary.l_Code, Content_Summary.Lot_No,  Content_Summary.Po_No, "
sql_syntax +=	" Content_Summary.po_no2, Content_Summary.serial_no, Content_Summary.Expiration_Date,  Content_Summary.Inventory_Type,  " 
sql_syntax += " Sum(Content_Summary.Avail_Qty) as avail_qty , Sum(Content_Summary.alloc_Qty) as Alloc_Qty,  "
sql_syntax += "Item_Master.Length_1, Item_Master.Width_1, Item_Master.Height_1, Item_MAster.Weight_1, "
sql_syntax += "Item_Master.User_Field8, "
sql_syntax +=  "CASE WHEN (Item_master.Length_1*Item_master.Height_1*Item_master.Width_1)/1000000  > 0 THEN ((Item_master.Length_1*Item_master.Height_1*Item_master.Width_1)/1000000 * (Sum(Content_Summary.Avail_Qty) + Sum(Content_Summary.Alloc_Qty))) ELSE ((Sum(Content_Summary.Avail_Qty) + Sum(Content_Summary.Alloc_Qty)) * Item_MAster.User_field8) END As Volume, "
sql_syntax += "Item_Master.Grp, Item_Master.Description, Item_Master.UOM_1"
sql_syntax += "  From Receive_Master, Content_Summary, Item_Master "
sql_syntax += "  Where Content_Summary.Project_id = 'SG-MUSER'  and "
sql_syntax += " Content_Summary.Project_id = Receive_MAster.Project_ID and Content_Summary.ro_no = Receive_Master.ro_no "
sql_syntax += " and Content_Summary.project_id = Item_MAster.Project_id and Content_Summary.SKU = Item_Master.SKU and Content_Summary.supp_code = Item_MAster.Supp_code "
sql_syntax += " Group By  complete_Date, Arrival_date, Supp_Invoice_No,  Content_Summary.wh_code, Content_Summary.sku, Content_Summary.supp_code, Content_Summary.l_Code, Content_Summary.Lot_No,  Content_Summary.Po_No, "
sql_syntax +=	" Content_Summary.po_no2, Content_Summary.Serial_no, Content_Summary.Expiration_Date,  Content_Summary.Inventory_Type,  Item_Master.Length_1, Item_Master.Width_1, Item_Master.Height_1, Item_MAster.Weight_1, Item_Master.User_Field8, Grp, Description,Item_Master.UOM_1" 
sql_syntax += " Having Sum( Content_Summary.Avail_Qty  ) > 0 or  Sum( Content_Summary.alloc_Qty  ) > 0 "
sql_syntax += " Order by Content_Summary.wh_Code "

ldsboh.Create(SQLCA.SyntaxFromSQL(sql_syntax,"", ERRORS))

IF Len(ERRORS) > 0 THEN
 	 lsLogOut = "        *** Unable to create datastore for SG-MUSER  (BOH Data).~r~r" + Errors
	FileWrite(gilogFileNo,lsLogOut)
 	 RETURN - 1
END IF

lirc = ldsboh.SetTransobject(sqlca)

lLRowCount = ldsBoh.Retrieve()


lsLogOut = "    - " + String(ldsboh) + " inventory records retrieved for  processing..."
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/

For llRowPos = 1 to lLRowCount /*Each Inv Record*/
	
	//If warehouse changed, write a seperate file for each
	If ldsBoh.GetITemString(llRowPos,'wh_code') <> lsWarehouseSave Then
		
		//Write the previous file (if not the first time through)
		If ldsOut.RowCount() > 0 Then
			gu_nvo_process_files.uf_process_flatfile_outbound(ldsOut,'SG-MUSER')
			ldsOut.Reset()
		End If

		lsFileName = "SG-MUSER-Daily- BOH-" + ldsBoh.GetITemString(llRowPos,'wh_code')  + "-" + + String(ldToday,"mm-dd-yyyy") + ".csv"
		
		//Add a column Header Row*/
		llNewRow = ldsOut.insertRow(0)
		//Jxlim 12/21/2010 Added Item_Master.Description and Content_Summary.Serial_no
		//JXLIM 07/01/2010 Added 3 labels (ItemMaster.UserField8, Volume and ItemMaster.Group)
		lsOutString = "WH Code,SKU,Description,Supplier Code,Date Received,Arrival Date,Order Nbr,Location,Lot Nbr,PO Nbr, PO Nbr2,Serial Nbr,Exp Date,Inventory Type,Avail Qty,Alloc Qty,Length1,Width1,Height1,Weight1, User_Field8,Volume,Item Group,UOM_1"

		ldsOut.SetItem(llNewRow,'Project_id', 'SG-MUSER')
		ldsOut.SetItem(llNewRow,'edi_batch_seq_no', 1)
		ldsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
		ldsOut.SetItem(llNewRow,'batch_data', lsOutString)
		ldsOut.SetItem(llNewRow,'file_name', lsFileName)
				
	End If  /*Warehouse changed */
		
	llNewRow = ldsOut.insertRow(0)
	
	lsOutString = ldsBoh.GetITemString(llRowPos,'wh_code') + ","
	lsOutString += ldsBoh.GetITemString(llRowPos,'sku') + ","
	//Jxlim 12/21/2010 Added Description field and seria_no
	lsOutString += ldsBoh.GetITemString(llRowPos,'Description') + ","
	lsOutString += ldsBoh.GetITemString(llRowPos,'supp_code') + ","
	lsOutString += String(ldsBoh.GetITemDateTime(llRowPos,'complete_date'),'yyyy-mm-dd') + ","
	lsOutString += String(ldsBoh.GetITemDateTime(llRowPos,'arrival_date'),'yyyy-mm-dd') + ","
	lsOutString += ldsBoh.GetITemString(llRowPos,'supp_invoice_no') + ","
	lsOutString += ldsBoh.GetITemString(llRowPos,'l_code') + ","
	lsOutString += ldsBoh.GetITemString(llRowPos,'lot_no') + ","
	lsOutString += ldsBoh.GetITemString(llRowPos,'po_no') + ","
	lsOutString += ldsBoh.GetITemString(llRowPos,'po_no2') + ","
	lsOutString += ldsBoh.GetITemString(llRowPos,'serial_no') + ","
	lsOutString += String(ldsBoh.GetITemDateTime(llRowPos,'expiration_date'),'mm/dd/yyyy') + ","
	lsOutString += ldsBoh.GetITemString(llRowPos,'Inventory_Type') + ","
	lsOutString += nonull(String(ldsBoh.GetITemNumber(llRowPos,'avail_qty'))) + ","
	lsOutString += nonull(String(ldsBoh.GetITemNumber(llRowPos,'alloc_qty'))) + ","
	lsOutString += nonull(String(ldsBoh.GetITemNumber(llRowPos,'length_1'))) + ","
	lsOutString += nonull(String(ldsBoh.GetITemNumber(llRowPos,'width_1')))  + ","
	lsOutString += nonull(String(ldsBoh.GetITemNumber(llRowPos,'Height_1'))) + ","
	lsOutString += nonull(String(ldsBoh.GetITemNumber(llRowPos,'weight_1'))) + ","
	//JXLIM 07/01/2010 Added 3 fields (ItemMaster.UserField8, Volume and ItemMaster.Group)
	lsOutString += nonull(ldsBoh.GetITemString(llRowPos,'User_Field8')) + ","
	lsOutString +=  nonull(String(ldsBoh.GetITemNumber(llRowPos,'Volume'))) + ","
	lsOutString += nonull(ldsBoh.GetITemString(llRowPos,'Grp')) + ","

//MEA - 12/18/2011 - Added	
//We have a change request from the user to insert the ‘UOM1’ field into the BOH report at the last column (X) in the Excel file. 	
	lsOutString += nonull(ldsBoh.GetITemString(llRowPos,'UOM_1'))
	
	
	ldsOut.SetItem(llNewRow,'Project_id', 'SG-MUSER')
	ldsOut.SetItem(llNewRow,'edi_batch_seq_no', 1)
	ldsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	ldsOut.SetItem(llNewRow,'batch_data', lsOutString)
	ldsOut.SetItem(llNewRow,'file_name', lsFileName)
		
	lsWarehouseSave = ldsBoh.GetITemString(llRowPos,'wh_code')
	
Next /*Inventory Record*/

//Last/Only warehouse
If ldsOut.RowCount() > 0 Then
	gu_nvo_process_files.uf_process_flatfile_outbound(ldsOut,'SG-MUSER')
End If
		

REturn 0
end function

public function string nonull (string as_str);as_str = trim(as_str)
if isnull(as_str) or as_str = '-' then
	return ""
else
	return as_str
end if

end function

on u_nvo_proc_sg_muser.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_nvo_proc_sg_muser.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

