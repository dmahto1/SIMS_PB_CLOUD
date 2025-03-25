HA$PBExportHeader$u_dw_import_ams_ro.sru
forward
global type u_dw_import_ams_ro from u_dw_import
end type
end forward

global type u_dw_import_ams_ro from u_dw_import
string dataobject = "d_import_asm_muser"
boolean livescroll = false
end type
global u_dw_import_ams_ro u_dw_import_ams_ro

type variables
constant integer success = 0
constant integer failure = -1

string isRono
string isOrderNo

end variables

forward prototypes
public function string wf_validate (long al_row)
public function integer wf_save ()
public function string getrono ()
public subroutine setrono ()
public subroutine setordernumber (string _value)
public function string getordernumber ()
public function integer doronoheader (long _index)
public function integer doronodetail (long _index, long _lineitemnumber)
public function integer doroputaway (long _index, long _lineitemnumber)
end prototypes

public function string wf_validate (long al_row);// string = wf_validate( long al_row )
string lsMsg
string apot
string testing
long llOwner
string whCode

lsMsg = ''

// supplier code must exist and be valid
testing = trim( this.object.supplier[ al_row ] )
if isNull( testing ) or len( testing ) = 0 then 
	lsMsg="Supplier Code Missing"
	return lsMsg
end if
SELECT dbo.Supplier.Supp_Code  
 INTO :apot  
 FROM dbo.Supplier  
WHERE ( dbo.Supplier.Project_ID = :gs_project ) AND  
		( dbo.Supplier.Supp_Code = :testing )
USING SQLCA;
if isNull( apot ) or len( apot ) = 0 then 
	lsMsg="Invalid Supplier Code"
	return lsMsg
end if

// material (sku) must be set up in item master
testing = trim( this.object.material[ al_row ] )
if isNull( testing ) or len( testing ) = 0 then 
	lsMsg="Material Data Missing"
	return lsMsg
end if
SELECT dbo.Item_Master.SKU  
INTO :apot
FROM dbo.Item_Master  
WHERE ( dbo.Item_Master.Project_ID = :gs_project )
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
testing = trim( this.object.wh_code[ al_row ] )
if isNull( testing ) or len( testing ) = 0 then 
	lsMsg="Warehouse Data Missing"
	return lsMsg
end if
SELECT dbo.project_Warehouse.WH_Code  
INTO :apot  
FROM dbo.project_Warehouse  
WHERE dbo.project_Warehouse.WH_Code = :testing
and project_Warehouse.project_id = :gs_project;
if sqlca.sqlcode = 100 then
	lsMsg = "Warehouse Code not found."
	return lsMsg
end if
if sqlca.sqlcode < 0 then
	lsMsg = "Datebase Error Validating Warehouse Code" 
	return lsMsg
end if

whCode = testing
// validate putaway location
testing = trim( this.object.putaway_location[ al_row ] )
if isNull( testing ) or len( testing ) = 0 then 
	lsMsg="Location Code Data Missing"
	return lsMsg
end if
SELECT dbo.Location.L_Code  
INTO :apot
FROM dbo.Location  
WHERE ( dbo.Location.WH_Code = :whCode ) AND  
( dbo.Location.L_Code = :testing )   ;
if sqlca.sqlcode = 100 then
	lsMsg = "Location Code not found."
	return lsMsg
end if
if sqlca.sqlcode < 0 then
	lsMsg = "Datebase Error Validating Location Code" 
	return lsMsg
end if

// coo
testing = trim( this.object.country_of_fab[ al_row ] )
if isNull( testing ) or len( testing ) = 0 then 
	lsMsg="Country of Origin Data Missing"
	return lsMsg
end if
testing = f_get_country_name( testing )
if isNull( testing ) or len( testing ) = 0 then 
	lsMsg="Country of Origin Data Invalid"
	return lsMsg
end if


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
		setRoNo()
		if doRoNoHeader( index ) = failure then return failure
		llNew++
		lsCustBreak = lsCust
		lineItemNumber = 0
	end if
	lineItemNumber++
	if doRoNoDetail( index , lineItemNumber ) = failure then return failure
	if doRoPutaway( index, lineItemNumber ) = failure then return failure
Next 	

Execute Immediate "COMMIT" using SQLCA;
If sqlca.sqlcode <> 0 Then
	MessageBox("Import","Unable to Commit changes! No changes made to Database!")
	Return -1
End If

MessageBox("Import","Records saved.~r~rRecieving Orders Added : " + String(llNew))

w_main.SetmicroHelp("Ready")

SetPointer(Arrow!)

Return success

end function

public function string getrono ();// string = getRono()
return isRoNo

end function

public subroutine setrono ();// setRoNo( string _value )

decimal ldRONO

//Get the next available DONO
sqlca.sp_next_avail_seq_no(gs_project,"Receive_Master","RO_No" ,ldRONO) 
isRono = gs_Project + String(Long( ldRONO ),"0000000") 

return 

end subroutine

public subroutine setordernumber (string _value);// setOrderNumber( string _value )
isOrderNo = _value

end subroutine

public function string getordernumber ();// getOrderNumber()
return isOrderNo

end function

public function integer doronoheader (long _index);// integer = doRoNoHeader( long _index )

string	cust
string	custName
string	custAdr1
string	custcity		
string	custstate
string	custzip		
string	carrier
string	orderno
string 	lsErrText

string	supplier
string	warehouse
string	rono
string	fltnbr
string	supplierOrderNbr
string	shipref
string	route
string	shipmentNbr
string	shipdate
datetime ldtToday, arrivaldate

ldtToday = f_getLocalWorldTime( gs_default_wh ) 

supplierOrderNbr 	= Trim( this.object.mawb[ _index ] )	
shipref					= Trim( this.object.mawb[ _index ] )	
fltnbr						= Trim( this.object.flight_nbr[ _index ] )	// uf1
route						= Trim( this.object.route[ _index ] )	// uf4
shipmentnbr			= Trim( this.object.shipment[ _index ] )	// uf6
warehouse			= Trim( this.object.wh_code[ _index ] )	
supplier					= Trim( this.object.supplier[ _index ] )	
shipdate				= Trim( this.object.ship_date[ _index ] )
Rono 					= getRono()	
	
if isDate( shipdate ) then arrivaldate = datetime( date(shipdate),time( '00:00:00') )

//Create the Receive Master Record - Only one order per import file
Insert Into Receive_Master (ro_no, project_id, Ord_date, Ord_status, Ord_type, Inventory_Type, wh_Code,
										Supp_code, Supp_order_No, ship_ref,user_field1,user_field4,user_field6,arrival_date,
										Last_User, Last_Update)
		Values					(:RONO, :gs_Project, :ldtToday, 'N', 'S', 'N', :Warehouse,
										:supplier, :supplierOrderNbr,:shipref,:fltnbr,:route,:shipmentnbr,:arrivaldate,	:gs_userid, :ldtToday)
Using SQLCA;

If sqlca.sqlcode <> 0 Then
	This.SetRow( _index )
	This.ScrollToRow( _index )
	lsErrText = sqlca.sqlerrtext /*error text lost in rollback*/
	Execute Immediate "ROLLBACK" using SQLCA;
	Messagebox("Import","Unable to Save new Receive Order header Record to Database.~r~r" + lsErrtext)
	SetPointer(Arrow!)
	Return -1
End If

return success

end function

public function integer doronodetail (long _index, long _lineitemnumber);// integer = doRoNoDetail( long _index, long _lineitemnumber )

string 		lsSku
string 		lsAltSku
string 		lsSupplier
string 		lsErrText
string 		lsRoNo
string 		lsCurrencyCode
string 		coo
string 		refdoc 
string 		tariffCode
string 		grossWeight
string		lsDeliveryNbr
string		lsprice
decimal		dQty
long	 		llOwner

grossweight		= Trim(This.object.total_gross_wght[ _index ] )
refDoc				= Trim(This.object.reference_doc_nbr[ _index ] )
tariffCode			= Trim(This.object.tarriff_code[ _index ] )
coo					= Trim(This.object.country_of_fab[ _index ] )
lsSku 				= Trim(This.object.material[ _index ] )
lsSupplier 			= Trim(This.object.supplier[ _index ] )
lsCurrencyCode	= Trim(This.object.currencycode[ _index ] )
lsDeliveryNbr		= Trim(This.object.delivery_number[ _index ] )
lsprice				= Trim(This.object.local_unit_price[ _index ]  )
dQty					= dec( Trim(This.object.requested_qty[ _index ] ) )
lsRoNo 				= getRono()

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

insert into receive_detail
		( 	ro_no, Sku, supp_code, owner_id, country_of_origin, alternate_sku, line_item_no,
   			user_field1, user_field2, user_field3, user_field4,user_field5,req_qty
)
values( 	:lsRoNo,:lsSku,:lsSupplier,:llOwner, : coo,:lsAltSku,:_lineitemnumber,
			:refDoc,:grossweight,:tariffCode,:dQty,:lsprice,:lsCurrencyCode 
)
;
	
If sqlca.sqlcode <> 0 Then
	lsErrText = sqlca.sqlerrtext /*text will be lost after rollback*/
	Execute Immediate "ROLLBACK" using SQLCA;
	Messagebox("Import","Error saving Row: " + String( _index ) + " Unable to save new Receiving Detail record to database!~r~r" + lsErrText)
	SetPointer(Arrow!)
	Return failure
End If
return success


end function

public function integer doroputaway (long _index, long _lineitemnumber);// integer = doRoPutaway( long _index, long _lineitemnumber )

string lsSku
string lsAltSku
string lsSupplier
string lsErrText
string lsRoNo
string	lot
decimal		dQty
long	 llOwner
string coo
string l_code
string po
datetime	dtExp

lsRoNo 				= getRono()
lsSku 				= Trim(This.object.material[ _index ] )
lsSupplier 			= Trim(This.object.supplier[ _index ] )
coo					= Trim(This.object.country_of_fab[ _index ] )
l_code				= Trim(This.object.putaway_location[ _index ] )
lot						= Trim(This.object.hawb[ _index ] )
po						= Trim(This.object.number_of_cartons[ _index ] )
dQty					= dec( Trim(This.object.requested_qty[ _index ] ) )
dtExp 				= datetime( date( '12/31/2999'),time('23:59:59') )

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

  INSERT INTO dbo.Receive_Putaway  
         ( RO_No, SKU,  Supp_Code,    Owner_ID,     Country_of_Origin,    L_Code,   
            Inventory_Type,    Serial_No,    Lot_No,     PO_No,      PO_No2, SKU_Parent,   Component_Ind,     Quantity,   
          Component_No, Line_Item_No ,Container_ID,Expiration_Date )  
  VALUES ( :lsRoNo,:lsSku,:lsSupplier,:llOwner,:coo,:l_code,'N', '-',:lot,:po,'-',  '-','-',:dqty, 0, :_lineitemnumber,'-', :dtexp  )
USING SQLCA;
	
If sqlca.sqlcode <> 0 Then
	lsErrText = sqlca.sqlerrtext /*text will be lost after rollback*/
	Execute Immediate "ROLLBACK" using SQLCA;
	Messagebox("Import","Error saving Row: " + String( _index ) + " Unable to save new Receiving Putaway record to database!~r~r" + lsErrText)
	SetPointer(Arrow!)
	Return failure
End If
return success

end function

on u_dw_import_ams_ro.create
call super::create
end on

on u_dw_import_ams_ro.destroy
call super::destroy
end on

