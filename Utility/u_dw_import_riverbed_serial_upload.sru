HA$PBExportHeader$u_dw_import_riverbed_serial_upload.sru
$PBExportComments$+Newly added Import function to upload Serial No's for Riverbed.
forward
global type u_dw_import_riverbed_serial_upload from u_dw_import
end type
end forward

global type u_dw_import_riverbed_serial_upload from u_dw_import
integer width = 3840
integer height = 1992
string title = "Serial Upload"
string dataobject = "d_import_riverbed_serial_upload"
end type
global u_dw_import_riverbed_serial_upload u_dw_import_riverbed_serial_upload

type variables
u_nvo_carton_serial_scanning iuo_carton_serial_scanning
end variables

forward prototypes
public function string wf_validate (long al_row)
public function integer wf_save ()
end prototypes

public function string wf_validate (long al_row);//06-Jan-2014: Madhu -Added code to validation against uploaded Serial No's

String lsOrderNo,lsSku,lsQty,lsCarton,lsMac_Id,lsSerial_No,lsprefix,is_title,lsLineNo,lsdono,lspreviousorder,lsfind
long llcount,llrowcount, llserialcount,llcarton,lllinecount,lleligiblecount,llfindrow
long count =0

iuo_carton_serial_scanning = Create u_nvo_carton_serial_scanning

Choose Case iscurrvalcolumn
Case "OrderNo"
	goto lsOrderNo
Case "LineNo"
	goto lsLineNo
Case "Carton"
	goto lsCarton
Case "Sku"
	goto lsSku
Case "Qty"
	goto lsQty
Case "Mac_Id"
	goto lsMac_Id
Case "Serial_No"
	goto lsSerial_No

iscurrvalcolumn = ' '
return ' '
End Choose


lsOrderNo:
If this.getItemString(al_row,"OrderNo") >' ' and (Not isnull(this.getItemString(al_row,"OrderNo")))  Then
	lsOrderNo =this.getItemString(al_row,"OrderNo")
	
	select count(*) into :llcount from Delivery_Master
	where Project_Id =:gs_project and Invoice_No =:lsOrderNo and Ord_Status ='A'
	using SQLCA;

	If llCount <= 0 Then
		This.Setfocus()
		This.SetColumn("OrderNo")
		iscurrvalcolumn = "OrderNo"
		Return "Order No is not in Packing Status!"
	End If

	If len(trim(This.getItemString(al_row,"OrderNo"))) > 20 Then
		This.Setfocus()
		This.SetColumn("OrderNo")
		iscurrvalcolumn = "OrderNo"
		Return "Order No is > 20 Characters"
	End If
ELSE
	return "'Order No' can not be null!"		
End if

lsLineNo:
//check whether record exists in packlist or not
If this.getItemString(al_row,"LineNo") >' ' and (Not isnull(this.getItemString(al_row,"LineNo"))) Then
	
	lsOrderNo = this.getItemString(al_row,"OrderNo")
	lsLineNo =this.getItemString(al_row,"LineNo")	
	lsCarton =this.getItemString(al_row,"Carton")
	lsSku =this.getItemString(al_row,"Sku")

	//check whether record  exists or not
	select count(*) into :lllinecount from Delivery_Packing
	where Delivery_Packing.sku =:lsSku
	and Delivery_Packing.line_item_no =:lsLineNo 
	and Delivery_Packing.Carton_No =:lsCarton
	and Delivery_Packing.Do_No in (select Do_No from Delivery_Master where Project_Id=:gs_project and Invoice_No =:lsOrderNo and Ord_Status='A')
	using sqlca;
	
	If lllinecount <=0 Then
		this.setFocus()
		this.setColumn("LineNo")
		iscurrvalcolumn ="LineNo"
		Return "Line No # " + lsLineNo + " Carton # "+ lsCarton + " Sku # "+ lsSku + " is not existed on Delivery Packing!..." 
	End If
	
	If len(trim(This.getItemString(al_row,"LineNo"))) > 5 Then
		This.Setfocus()
		This.SetColumn("LineNo")
		iscurrvalcolumn = "LineNo"
		Return "Line No is > 5 Characters"
	End If
	
Else
	return "Line No can not be nul!"
End if

lsCarton:
If this.getItemString(al_row,"Carton") > ' ' and (Not isnull(this.getItemString(al_row,"Carton"))) Then
	lsSku =this.getItemString(al_row,"Sku")
	lsOrderNo =this.getItemString(al_row,"OrderNo")
	lsCarton =this.getItemString(al_row,"Carton")
	
//	check whether carton exists or not
	select count(*) into :llcarton
	from Delivery_Packing
	where Sku =:lsSku and Carton_No =:lsCarton 
	and Do_No in (select Do_No from Delivery_Master where Project_Id =:gs_project and Invoice_No =:lsOrderNo)
	using SQLCA;
	
	If llcarton <=0 Then
		this.SetFocus()
		this.SetColumn("Carton")
		iscurrvalcolumn ="Carton"
		return "Carton No " + lsCarton + " is not assgined with Sku " + lsSku + " in Delivery Packing!"
	End if
	
ELSE
	Return "Carton No can't be null!"
End if 

If len(trim(this.getItemString(al_row,"Carton"))) > 25 Then
		this.Setfocus()
		this.SetColumn("Carton")
		iscurrvalcolumn ="Carton"
		Return "Carton length shouldn't exceed 25 characters"
End if

lsSku:
If this.getItemString(al_row,"Sku") > ' ' and (Not isnull(this.getItemString(al_row,"Sku"))) Then
	lsSku =this.getItemString(al_row,"Sku")
	lsOrderNo =this.getItemString(al_row,"OrderNo")
	lsCarton =this.getItemString(al_row,"Carton")
	lsLineNo =this.getItemString(al_row,"LineNo")	
	
	select count(*) into :llrowcount from Delivery_Packing 
	where sku= :lsSku
	and Do_No in (select Do_No from Delivery_Master where Project_Id =:gs_project and Invoice_No =:lsOrderNo)
	using sqlca;

	If llrowcount > 0 Then
		//get Do_No value from Delivery Master
		select Do_No into :lsdono from Delivery_Master where Project_Id=:gs_project and Invoice_No =:lsOrderNo  using sqlca;
	
		//check whether record is eligible for Serial Nbr scanning
		select count(*) into :lllinecount from Delivery_Packing, Item_Master
		where Delivery_Packing.Do_No =:lsdono and Delivery_Packing.sku =:lsSku
		and Delivery_Packing.line_item_no =:lsLineNo and Delivery_Packing.Carton_No =:lsCarton
		and Delivery_Packing.sku =Item_Master.sku
		and Delivery_Packing.supp_code =Item_Master.supp_code
		and Item_Master.Serialized_Ind IN ('Y','B','O')
		using sqlca;

		If lllinecount <=0 Then
			this.SetFocus()
			this.SetColumn("Sku")
			iscurrvalcolumn ="Sku"
			return "Sku # "+ lsSku+ " is not eligible for Serial Nbr scanning..."
		End if 
	else
		this.SetFocus()
		this.SetColumn("Sku")
		iscurrvalcolumn ="Sku"
		return "SKU doesn't exists in Delivery Packing.."
	End if 
	
ELSE
	Return "Sku can't be null!"
End if 

If len(trim(this.getItemString(al_row,"Sku"))) > 50 Then
	this.Setfocus()
	this.SetColumn("Sku")
	iscurrvalcolumn ="Sku"
	Return "Sku length shouldn't exceed 50 characters"
End if

lsQty:
If this.getItemString(al_row,"Qty") > ' ' and (Not isnumber(this.getItemString(al_row,"Qty"))) Then
	this.Setfocus()
	this.SetColumn("Qty")
	iscurrvalcolumn ="Qty"
	Return "Qty must be numeric!"
End if 

If  long(this.getItemString(al_row,"Qty")) <> 1 then
	Return "Qty value should be equal to 1"
end if 

lsMac_Id:
If this.getItemString(al_row,"Mac_Id") > ' ' and (Not isnull(this.getItemString(al_row,"Mac_Id"))) Then
	If len(trim(this.getItemString(al_row,"Mac_Id"))) > 50 Then
		this.Setfocus()
		this.SetColumn("Mac_Id")
		iscurrvalcolumn ="Mac_Id"
		Return "Hardware Serial No length shouldn't exceed 50 characters"
	End if
ELSE
	Return "Hardware Serial No can't be null!"
End if 

lsSerial_No:
If this.getItemString(al_row,"Serial_No") > ' ' and (Not isnull(this.getItemString(al_row,"Serial_No"))) Then
	lsSku =this.getItemString(al_row,"Sku")
	lsSerial_No =this.getItemString(al_row,"Serial_No")

	If iuo_carton_serial_scanning.uf_validate_serial_Prefix(LEFT(this.GetItemString(al_row,"Sku"),9),lsSerial_No) = False Then
		this.Setfocus()
		this.SetColumn("Serial_No")
		iscurrvalcolumn ="Serial_No"
		Return "Invalid Software Serial No prefix for this SKU!"
	End If

	SELECT count(*)  
	INTO :llserialcount  
	FROM Delivery_Serial_Detail  
	WHERE  Supplier_Substitute = :gs_project AND Serial_No = :lsSerial_No 
	USING SQLCA;

	If llserialcount > 0  Then
		this.Setfocus()
		this.SetColumn("Serial_No")
		iscurrvalcolumn ="Serial_No"
		Return "Software Serial No has already been used for another order!"
	End If
ELSE
	Return "Software Serial No can't be null!"
End if 

If len(trim(this.getItemString(al_row,"Serial_No"))) > 100 Then
	this.Setfocus()
	this.SetColumn("Serial_No")
	iscurrvalcolumn ="Serial_No"
	return "Software Serial No length shouldn't exceed 50 characters"
End if

//validation against imported records against each order vs eligible Delivery packing records count
If lspreviousorder <> lsOrderNo Then
//get count -how many records are imported against each order
	lsFind = "OrderNo = '" + this.GetItemString(al_row,'OrderNo') + "'"
	llFindRow =  this.Find(lsFind,0,this.RowCount())
	Do While llFindRow >0 
		llFindRow = this.Find(lsFind,llFindRow+1,this.RowCount()+1)
		count++
	Loop

//get count of eligible records for serial nbr scanning from Delivery Packing
select count(*) into :lleligiblecount from Delivery_Packing, Item_Master
where Delivery_Packing.Do_No in (select Do_No from Delivery_Master where Project_Id =:gs_project and Invoice_No =:lsOrderNo) 
and Delivery_Packing.sku =Item_Master.sku
and Delivery_Packing.supp_code =Item_Master.supp_code
and Item_Master.Serialized_Ind IN ('Y','B','O')
using sqlca;

If count <> lleligiblecount Then
	this.Setfocus()
	this.SetColumn("OrderNo")
	iscurrvalcolumn ="OrderNo"
	return "Imported order #" +lsOrderNo+ " count is "+ string(count) + " out of " +string(lleligiblecount) + " eligibile Serial Nbr scanned records in Packing..."
End if

End If

lspreviousorder =lsOrderNo

end function

public function integer wf_save ();//06-Jan-2014 :Madhu- Added code to Insert records into Delivery Serial Table

String lsOrderNo,lsCarton,lsSku,lsQty,lsMac_Id,lsSerial_No,lsLineNo
String lsFind,lsErrorText,ls_DoNo
long	llRowCount,llRowPos,llFindRow,ll_duplicaterow,llId_No,llnew,ll_Id_rowcount,llIdcount
String sql_syntax,ls_Insert
long 	ll_curPos =1
Datastore lddeliverypickingdetail

llnew =0
ll_duplicaterow=0

llRowCount =this.Rowcount()

Execute Immediate " Begin Transaction " using SQLCA;

For llRowPos =1 to llRowCount
	w_main.SetmicroHelp("Saving Row " + string(llRowPos) + " of " + string(llRowCount))
	
	lsOrderNo = this.getItemString (llRowPos,"OrderNo")
	lsLineNo = this.getItemString (llRowPos,"LineNo")
	lsCarton =this.getItemString(llRowPos,"Carton")
	lsSku =this.getItemString(llRowPos,"Sku")
	lsQty =this.getItemString(llRowPos,"Qty")
	lsMac_Id =this.getItemString(llRowPos,"Mac_Id")
	lsSerial_No =this.getItemString(llRowPos,"Serial_No")
	
	//Don't allow to update Duplicate Order+sku+Serialno
	lsFind = "OrderNo = '" + this.GetItemString(llRowPos,'OrderNo') + "' and Sku = '" + this.GetItemString(llRowPos,'Sku') + "' and Serial_No = '" + this.GetItemString(llRowPos,'Serial_No') + "'"
	llFindRow =  this.Find(lsFind,0,this.RowCount())

	Do While llFindRow >0 
		llFindRow = this.Find(lsFind,llFindRow+1,this.RowCount()+1)
		
		IF llFindRow >1 Then
			ll_duplicaterow =llFindRow
		END IF
	Loop

If (ll_duplicaterow <> llRowPos) Then

	//Get Do_No from Delivery_Master Table
	select Do_No into :ls_DoNo from Delivery_Master with (nolock) where Project_Id=:gs_project and Invoice_No=:lsOrderNo using sqlca;
	
	//Create DataStore for Delivery Picking Detail table
	lddeliverypickingdetail = Create Datastore
	sql_syntax ="select sku,line_item_no,Quantity,Id_No from Delivery_Picking_Detail with (nolock) where Do_No='"+ls_DoNo+"' and Sku ='" + lsSku +"' and Line_Item_No = '" + lsLineNo + "'"
	lddeliverypickingdetail.create( SQLCA.SyntaxFromSQL(sql_syntax," ",lsErrorText))
	
	If Len(lsErrorText) > 0 Then
		Return -1
	else
		lddeliverypickingdetail.SetTransObject(SQLCA)
		ll_Id_rowcount =lddeliverypickingdetail.retrieve()
	END IF
	
	//Let Assume, if we've multilple rows with same sku + line item no
	If 	ll_Id_rowcount > 1 Then
		//Re-write the code to set corresponding ID_No to all rows, if sku has more than one row & assigned with multiple Id_No's
		//	select Id_No into :llId_No from Delivery_Picking_Detail
		//	where Do_No in (select Do_No from Delivery_Master where Project_Id =:gs_project and Invoice_No =:lsOrderNo)
		//	and sku =:lsSku and Line_Item_No =:lsLineNo
		//	using sqlca;

		// Get Id_No value from current row of Delivery Picking Detail DataStore
		llId_No=lddeliverypickingdetail.getITemNumber( ll_curPos,'Id_No')
		
		//Get Count of records from Delivery Serial Detail with combination of sku + Id_No. It shouldn't be greater than pick row qty.
		select count(*) into :llIdcount from Delivery_Serial_Detail with (nolock) where Id_No=:llId_No and Supplier_Substitute ='RIVERBED' using SQLCA;
		
		If  (llIdcount + 1) > lddeliverypickingdetail.getITemNumber( ll_curPos,'Quantity') Then
				ll_curPos++
				llId_No=lddeliverypickingdetail.getITemNumber( ll_curPos,'Id_No')
		END IF
		
		//Insert records into Delivery Serial Detail table
		INSERT INTO Delivery_Serial_Detail (Id_No, Serial_No,Quantity,Component_Sequence_No,Carton_No,MAC_Id,Supplier_Substitute)
		VALUES (:llId_No,:lsSerial_No,:lsQty,'999',:lsCarton,:lsMac_Id,'RIVERBED')
		using sqlca;
		
		If sqlca.sqlcode <> 0 Then
			this.SetRow(llRowPos)
			this.ScrollToRow(llRowPos)
			lsErrorText = sqlca.sqlerrtext /*error text lost in rollback*/
			Execute Immediate "ROLLBACK" using SQLCA;
			Messagebox("Import","Unable to save changes to database!~r~r" + lsErrortext)
			SetPointer(Arrow!)
			Return -1
		else
			llnew++
		End If
	ELSE  
			//If a record has only one row per sku + line item no then Insert records into Delivery Serial Detail table
			llId_No=lddeliverypickingdetail.getITemNumber( 1,'Id_No')
			
			INSERT INTO Delivery_Serial_Detail (Id_No, Serial_No,Quantity,Component_Sequence_No,Carton_No,MAC_Id,Supplier_Substitute)
			VALUES (:llId_No,:lsSerial_No,:lsQty,'999',:lsCarton,:lsMac_Id,'RIVERBED')
			using sqlca;
			
			If sqlca.sqlcode <> 0 Then
				this.SetRow(llRowPos)
				this.ScrollToRow(llRowPos)
				lsErrorText = sqlca.sqlerrtext /*error text lost in rollback*/
				Execute Immediate "ROLLBACK" using SQLCA;
				Messagebox("Import","Unable to save changes to database!~r~r" + lsErrortext)
				SetPointer(Arrow!)
				Return -1
			else
				llnew++
			End If
	END IF
	
ELSE
	MessageBox("Import","Doesn't allow to upload Serial No against Duplicate Order ~r~r" +lsOrderNo+ "  at row  " +string(ll_duplicaterow))
END IF

Next

Execute Immediate "COMMIT" using SQLCA;

If sqlca.sqlcode <> 0 Then
	MessageBox("Import","Unable to Commit changes! No changes made to Database")
	Return -1
End if 

MessageBox("Import","Records saved.~r~rRecords Inserted: " + String(llnew) + "")
w_main.SetmicroHelp("READY")

destroy lddeliverypickingdetail
return 0
end function

on u_dw_import_riverbed_serial_upload.create
call super::create
end on

on u_dw_import_riverbed_serial_upload.destroy
call super::destroy
end on

