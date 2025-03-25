HA$PBExportHeader$u_dw_import_ams_do.sru
forward
global type u_dw_import_ams_do from u_dw_import
end type
end forward

global type u_dw_import_ams_do from u_dw_import
string dataobject = "d_import_asm_muser"
end type
global u_dw_import_ams_do u_dw_import_ams_do

type variables
constant integer success = 0
constant integer failure = -1

string isDono
string isOrderNo

end variables

forward prototypes
public function string wf_validate (long al_row)
public function integer wf_save ()
public subroutine setordernumber (string _value)
public function string getdono ()
public function string getordernumber ()
public subroutine setdono ()
public function integer dodonoheader (integer index)
public function integer dodonodetail (integer _index, integer _lineitemnumber)
end prototypes

public function string wf_validate (long al_row);// string = wf_validate( long al_row )
string lsMsg
string apot
string testing
string warehouse

lsMsg = ''

// material (sku) must be set up in item master
testing = trim( this.object.material[ al_row ] )

SELECT dbo.Item_Master.SKU  
INTO :apot
FROM dbo.Item_Master  
WHERE ( dbo.Item_Master.Project_ID = 'AMS-MUSER' )
AND ( dbo.Item_Master.SKU = :testing ) ;
if sqlca.sqlcode = 100 then
	lsMsg = "Material not found in Item Master"
	return lsMsg
end if
if sqlca.sqlcode < 0 then
	lsMsg = "Datebase Error Validating Material" 
	return lsMsg
end if

// validate warehouse code
warehouse = trim( this.object.wh_code[ al_row ] )
SELECT dbo.Warehouse.WH_Code  
INTO :apot  
FROM dbo.Warehouse  
WHERE dbo.Warehouse.WH_Code = :warehouse   ;
if sqlca.sqlcode = 100 then
	lsMsg = "Warehouse Code not found."
	return lsMsg
end if
if sqlca.sqlcode < 0 then
	lsMsg = "Datebase Error Validating Warehouse Code" 
	return lsMsg
end if

// validate putaway location
//testing = trim( this.object.putaway_location[ al_row ] )
//SELECT dbo.Location.L_Code  
//INTO :apot
//FROM dbo.Location  
//WHERE ( dbo.Location.WH_Code = :warehouse ) AND  
//( dbo.Location.L_Code = :testing )   ;
//if sqlca.sqlcode = 100 then
//	lsMsg = "Location Code not found."
//	return lsMsg
//end if
//if sqlca.sqlcode < 0 then
//	lsMsg = "Datebase Error Validating Location Code" 
//	return lsMsg
//end if
//
return lsMsg

end function

public function integer wf_save ();// integer = wf_save()

string		lsCust
string 		lsCustBreak
datetime 	ldtToday
int 			index
int				lineItemNumber
long 			llRowCount
long			llNew

ldtToday = f_getLocalWorldTime( gs_default_wh ) 

llRowCount = This.RowCount()
llNew = 0

SetPointer(Hourglass!)

this.setsort( "cust_code ASC" )
this.sort()

Execute Immediate "Begin Transaction" using SQLCA; 

lsCust = Trim(this.object.cust_code[ 1 ]) /* Get Customer Number */ 
lsCustBreak = "*"
for index = 1 to llRowCount
	lsCust = Trim(this.object.cust_code[ index ]) /* Get Customer Number */ 
	w_main.SetmicroHelp("Saving Master Record for " + string(lsCust))
	if lsCust <> lsCustBreak then
		setDoNo()
		if doDoNoHeader( index ) = failure then return failure
		llNew++
		lsCustBreak = lsCust
		lineItemNumber = 0
	end if
	lineItemNumber++
	if doDoNoDetail( index , lineItemNumber )= failure then return failure
Next 	

Execute Immediate "COMMIT" using SQLCA;
If sqlca.sqlcode <> 0 Then
	MessageBox("Import","Unable to Commit changes! No changes made to Database!")
	Return -1
End If

MessageBox("Import","Records saved.~r~rDelivery Orders Added : " + String(llNew))

w_main.SetmicroHelp("Ready")

SetPointer(Arrow!)

Return success

end function

public subroutine setordernumber (string _value);//setOrderNumber( string _value )

if isNull( _value ) then _value = ''
isorderno = _value

end subroutine

public function string getdono ();// string = getDono()
return isDono

end function

public function string getordernumber ();// string = getOrderNumber()
return isorderno


end function

public subroutine setdono ();// setDoNo(  )
decimal lddONO
string lsDoNo
string lsorderno

//Get the next available DONO
sqlca.sp_next_avail_seq_no(gs_project,"Delivery_Master","DO_No" ,lddONO) 
lsDoNO = gs_Project + String(Long(ldDoNo),"0000000") 
lsOrderNo = mid(lsDoNO, ( len( lsDoNO ) - 6), len( lsDoNO )) //Get The Invoice Number - last 7 digits of lsDoNO 

setOrderNumber( lsOrderNo )
isDono = lsDoNo

return 


end subroutine

public function integer dodonoheader (integer index);// doDoNoHeader( int index )

string	cust
string	custName
string	custAdr1
string	custcity		
string	custstate
string	custzip		
string	carrier
string	Dono
string	warehouse
string	orderno
string 	lsErrText
datetime ldtToday

ldtToday = f_getLocalWorldTime( gs_default_wh ) 
// 
// grab the data
//
cust				= Trim( this.object.cust_code[ index ] )
custName		= Trim( this.object.cust_name[ index ] )
custAdr1		= Trim( this.object.cust_addr1[ index ] )
custcity			= Trim( this.object.cust_city[ index ] )
custstate		= Trim( this.object.cust_state[ index ] )
custzip			= Trim( this.object.cust_zip[ index ] )
carrier			= Trim( this.object.carrier[ index ] )	
warehouse	= Trim( this.object.wh_code[ index ] )	
orderno			= getOrderNumber()
Dono 			= getDono()	

Insert Into Delivery_Master (Do_no, Project_id,Ord_date,Ord_status,Ord_Type,Inventory_type,freight_cost,
			   Cust_code, Cust_Name, Address_1,City, State, zip, wh_code, Invoice_No,Carrier,Last_user,Last_Update  )
Values ( :DONO,:gs_project,:ldtToday,'N','S','N',0,
               :cust, :custName, :custAdr1, :custcity, :custstate, :custzip, :warehouse,:orderno,:carrier,:gs_userid,:ldtToday )
Using SQLCA;

If sqlca.sqlcode <> 0 Then
	lsErrText = sqlca.sqlerrtext /*text will be lost after rollback*/
	Execute Immediate "ROLLBACK" using SQLCA;
	Messagebox("Import","Error saving Row: " + String(index) + " Unable to save new Delivery Master record to database!~r~r" + lsErrText)
	SetPointer(Arrow!)
	Return failure
End If	

return success



end function

public function integer dodonodetail (integer _index, integer _lineitemnumber);// integer = doDoNoDetail( int index, int lineitemnumber )

string lsSku
string lsAltSku
string lsSupplier
string lsErrText
string lsDoNo
string lsCurrencyCode
string	lsDeliveryNbr
decimal		dprice
decimal		dQty
long	 llOwner

lsSku 				= Trim(This.object.material[ _index ] )
lsSupplier 			= Trim(This.object.supplier[ _index ] )
lsCurrencyCode	= Trim(This.object.currencycode[ _index ] )
lsDeliveryNbr		= Trim(This.object.delivery_number[ _index ] )
dprice				= dec( Trim(This.object.local_unit_price[ _index ] ) )
dQty					= dec( Trim(This.object.requested_qty[ _index ] ) )
lsDono 				= getDono()

// Get the ALternate SKU 
Select Alternate_sku, Supp_code, Owner_ID
Into	:lsAltSku
From Item_MAster
Where Project_id = :gs_project and sku = :lsSku;
If isnull(lsAltSku) or lsAltSku = '' Then lsAltSku = lsSku
	
//Return the Default Owner ID for the Supplier for the project 
Select Owner_id 
Into	:llOwner
From Owner
Where Project_id = :gs_project and owner_Type = 'S' and owner_cd = :lsSupplier;

// Insert the Delivery Detail Record
Insert Into Delivery_Detail (do_no, sku, supp_code, Owner_id, Alternate_sku, req_qty, alloc_qty, uom, price, cost,  line_Item_no,
										user_field1, user_field2)
Values	(	:lsdoNo, :lsSKU,:lsSupplier, :llOwner, :lsAltSKU, :dQty, 0,  'EA', :dprice, 0,  :_lineitemnumber,	:lsDeliveryNbr, :lsCurrencyCode ) 
Using SQLCA;
	
If sqlca.sqlcode <> 0 Then
	lsErrText = sqlca.sqlerrtext /*text will be lost after rollback*/
	Execute Immediate "ROLLBACK" using SQLCA;
	Messagebox("Import","Error saving Row: " + String( _index ) + " Unable to save new Delivery Detail record to database!~r~r" + lsErrText)
	SetPointer(Arrow!)
	Return failure
End If
return success

end function

on u_dw_import_ams_do.create
call super::create
end on

on u_dw_import_ams_do.destroy
call super::destroy
end on

