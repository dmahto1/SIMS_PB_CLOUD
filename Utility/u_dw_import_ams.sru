HA$PBExportHeader$u_dw_import_ams.sru
forward
global type u_dw_import_ams from u_dw_import
end type
end forward

global type u_dw_import_ams from u_dw_import
string dataobject = "d_import_asm_muser"
boolean hsplitscroll = false
end type
global u_dw_import_ams u_dw_import_ams

type variables
constant integer success = 0
constant integer failure = -1

constant string  isEDIIn = 'EDI_Inbound_Header'
constant string  isEDIOut = 'EDI_Outbound_Header'

string isDono
string isOrderNo
string isRono
string isMsg
long	ilErrorRow
long	ilEdiBatchNo
long ilEdiOrderLineNo
long ilEdiOrderSeq
long ilEdiBatchNoIn
long ilEdiOrderLineNoIn
long ilEdiOrderSeqIn


datastore idsInventory
datastore idsSupplier
datastore idsWarehouse
datastore idsPutawayLoc
datastore idsCountry
datastore idsOwner

// pvh - 12/05/06 - websphere import
//
// Change UseWebsphere to true when activating App Server processing.
constant boolean UseWebsphere = false
inet	linit
u_nvo_websphere_post	iuoWebsphere
string isDWXML
string isTheXml
//
// eom








end variables

forward prototypes
public function string wf_validate (long al_row)
public function integer wf_save ()
public subroutine setdono ()
public subroutine setordernumber (string _value)
public function string getordernumber ()
public function string getdono ()
public function integer dodonoheader (integer index)
public function integer dodonodetail (integer _index, integer _lineitemnumber)
public subroutine setrono ()
public function string getrono ()
public function integer doronoheader (long _index)
public function integer doronodetail (long _index, long _lineitemnumber)
public function integer dovalidatebreaks ()
public subroutine setmsg (string _value)
public function string getmsg ()
public subroutine seterrorrow (long _value)
public function long geterrorrow ()
public function long getedibatchno ()
public function integer getedilineno ()
public subroutine setediorderseq ()
public function integer getediorderseq ()
public subroutine setedilineno ()
public subroutine setedilineno (integer _value)
public function integer doedidetail (long _index, long _lineitemno)
public function integer setedibatchno (string _tablename)
public function integer doedioutdetail (long _index, long _lineitemno)
public function integer doaltaddress (long _index)
public function string getaltsku (string _sku)
public function long getownerid (string _supplier)
public function string getcommastrippedvalue (string value, boolean adecimal)
public function string getservervalidation ()
public function string dovalidate ()
end prototypes

public function string wf_validate (long al_row);// string = wf_validate( long al_row )

// pvh - 12/05/06 - websphere
if UseWebsphere then 
	return getServerValidation()
end if

// 04.11.06 - pvh modified to validate sku/supplier combination.

string lsMsg
string apot
string testing
string whCode
long llOwner
string ship2country	
string	findthis
long		foundrow

string testvalue
string myMsg

// pvh - 04.11.06 -sku/supplier validation
string sku
string supplier
//

lsMsg = ''

// material (sku) must be set up in item master
testing = Upper( trim( this.object.material[ al_row ] ) )
if isNull( testing ) or len( testing ) = 0 then 
	lsMsg="Material Missing"
	return lsMsg
end if

findthis = "Upper( sku ) = '" + testing + "'"
foundrow = idsInventory.find( findthis,1,idsInventory.rowcount() )
if foundrow <=0 then
	lsMsg = "Material not found in Item Master"
	return lsMsg
end if
// pvh - 04.11.06 -sku/supplier validation
sku = testing

// validate warehouse code
whCode = trim( this.object.wh_code[ al_row ] )
findthis = "Upper( wh_code ) = '" + whCode + "'"
foundrow = idsWarehouse.find( findthis,1,idsWarehouse.rowcount() )
if foundrow <=0 then
	lsMsg = "Warehouse Code not found."
	return lsMsg
end if

// supplier code must exist and be valid
testing = Upper( trim( this.object.supplier[ al_row ] ) )
if isNull( testing ) or len( testing ) = 0 then 
	lsMsg="Supplier Code Missing"
	return lsMsg
end if
findthis = "Upper( supp_code ) = '" + testing + "'"
foundrow = idsSupplier.find( findthis, 1, idsSupplier.rowcount() )
if foundrow <= 0 then
	lsMsg="Invalid Supplier Code"
	return lsMsg
end if
// pvh - 04.11.06 -sku/supplier validation
supplier = testing

// pvh - 04.11.06 -sku/supplier validation
findthis = "Upper( sku ) = '" + sku + "' and supp_code = '" + supplier + "'"
foundrow = idsInventory.find( findthis,1,idsInventory.rowcount() )
if foundrow <=0 then
	lsMsg = "Material, " + sku + " not found in Item Master with Supplier " + supplier
	return lsMsg
end if

// validate putaway location
testing = Upper( trim( this.object.putaway_location[ al_row ] ) )
if isNull( testing ) or len( testing ) = 0 then 
	lsMsg="Location Code Data Missing"
	return lsMsg
end if
findthis = "Upper( l_code) = '" + testing + "'"
foundrow = idsPutawayLoc.find( findthis, 1, idsPutawayLoc.rowcount() )
if foundrow <= 0 then
	lsMsg = "Location Code not found."
	return lsMsg
end if

// coo

testing = Upper( trim( this.object.country_of_fab[ al_row ] ) )
if isNull( testing ) or len( testing ) = 0 then 
	lsMsg="Country of Origin Data Missing"
	return lsMsg
end if
testing = f_get_country_name( testing )
if isNull( testing ) or len( testing ) = 0 then 
	lsMsg="Country of Origin Data Invalid"
	return lsMsg
end if

// ship 2 country 
ship2country = Upper( trim( this.object.ship_to_country[ al_row ] ))
if isNull( ship2country ) or len( ship2country ) = 0 then
	lsMsg = "Missing Ship to Country" 
	return lsMsg
end if
choose case len( ship2country )
	case 2,3
		if len( f_get_country_name( ship2Country ) ) = 0 then
			lsMsg = "Missing Ship to Country" 
			return lsMsg
		end if
	case is > 3  // validate by country name
		findthis = "Upper( country_name ) = '" + ship2country + "'"
		foundrow = idsCountry.find( findthis,1,idsCountry.rowcount() )
		if foundrow <=0 then		
			lsMsg = "Ship to Country not found."
			return lsMsg
		end if
end choose
/*
	if there is a price, there must be a currency code
*/
if len( Trim ( string( this.object.local_unit_price[ al_row ] ))) > 0 then
	if  isNull( this.object.currencycode[ al_row ] ) or len( string( this.object.currencycode[ al_row ] )) = 0 then
		lsMsg = "Missing Currency Code"
		return lsMsg
	end if
end if
/*
	pvh - 08.29.06 - added numeric validation
	// note. if the value contains a comma, make it a decimal point. Then validate the number.
	
*/

myMsg = "Invalid Numeric Format: "

testvalue = Trim( this.object.local_unit_price[ al_row ] )
if NOT isNull( testvalue ) and len( testvalue ) > 0 then
	testValue = getCommaStrippedValue( testvalue, true )
	if dec( testvalue ) = 0 then return myMsg + "Local Price, Must be Decimal."
	 this.object.local_unit_price[ al_row ] = testvalue
end if

testvalue = Trim( this.object.total_gross_wght[ al_row ] )
if NOT isNull( testvalue ) and len( testvalue ) > 0 then
	testValue = getCommaStrippedValue( testvalue, true )
	if dec( testvalue ) = 0 then return myMsg + "Total Gross Weight, Must be Decimal."
	this.object.total_gross_wght[ al_row ] = testvalue
end if
//
testvalue = Trim( this.object.total_value_of_delivery[ al_row ] )
if NOT isNull( testvalue ) and len( testvalue ) > 0 then
	testValue = getCommaStrippedValue( testvalue, true )
	if dec( testvalue ) = 0 then return myMsg + "Total Value of Delivery, Must be Decimal."
	this.object.total_value_of_delivery[ al_row ] = testvalue
end if
testvalue = Trim( this.object.requested_qty[ al_row ] )
if NOT isNull( testvalue ) and len( testvalue ) > 0 then
	testValue = getCommaStrippedValue( testvalue, false )
	if NOT IsNumber( testvalue ) then return myMsg + "Requested Quantity, Must be a Number"
	this.object.requested_qty[ al_row ] = testvalue
end if
// pvh - 08.29.06 -  eom

return lsMsg

end function

public function integer wf_save ();// integer = wf_save()
string 		lsCust
string		lsCustHold
string		lsMAWB
string 		lsMAWBHold
datetime 	ldtToday
int 			index
int				lineItemNumber
long 			llRowCount
long			llRoNew
long			llDoNew
string		lsGroupId
string		lsGroupBreak

ldtToday = f_getLocalWorldTime( gs_default_wh ) 

llRowCount = This.RowCount()
llDoNew = 0

SetPointer(Hourglass!)

Execute Immediate "Begin Transaction" using SQLCA; 

lsGroupBreak=  "*"
for index = 1 to llRowCount
	lsGroupId = Trim(this.object.outboundgroupid[ index ])	
	w_main.SetmicroHelp("Saving Master Record for " + string(lsMAWB))
	if lsGroupId <> lsGroupBreak then
		setDoNo()
		if doDoNoHeader( index ) = failure then return failure
		if doAltAddress( index ) = failure then return failure
		llDoNew++
		lsGroupBreak = lsGroupId
		lineItemNumber = 0
	end if
	lineItemNumber++
	setEdiLineNo( lineItemNumber )
	if doDoNoDetail( index , lineItemNumber )= failure then return failure
	if doEDIOutDetail( index,lineItemNumber)= failure then return failure
Next 	
Execute Immediate "COMMIT" using SQLCA;
If sqlca.sqlcode <> 0 Then
	MessageBox("Import","Unable to Commit changes! No changes made to Database!~r~n~r~n" + sqlca.sqlerrtext )
	Return failure
End If

llRoNew = 0
lineItemNumber = 0
lsGroupBreak= "*"

Execute Immediate "Begin Transaction" using SQLCA; 

lsGroupBreak  = "*"
for index = 1 to llRowCount
	lsGroupid= Trim(this.object.inboundgroupid[ index ])
	w_main.SetmicroHelp("Saving Master Record for " + string(lsMAWB))
	if lsGroupid <> lsGroupBreak then
		setRoNo()
		if doRoNoHeader( index ) = failure then return failure
		llRoNew++
		lsGroupBreak = lsGroupid
		lineItemNumber = 0
	end if
	lineItemNumber++
	setEdiLineNo( lineItemNumber )
	if doRoNoDetail( index , lineItemNumber ) = failure then return failure
	if doEDIDetail( index,lineItemNumber ) = failure then return failure
Next 	

Execute Immediate "COMMIT" using SQLCA;
If sqlca.sqlcode <> 0 Then
	MessageBox("Import","Unable to Commit changes! No changes made to Database!~r~n~r~n" + sqlca.sqlerrtext )
	Return failure
End If

MessageBox("Import","Records saved.~r~rRecieving Orders Added : " + String(llRoNew) + "~r~n~r~nDelivery Orders Added : " + String(llDoNew))
w_main.SetmicroHelp("Ready")

SetPointer(Arrow!)

Return success

end function

public subroutine setdono ();// setDoNo(  )
decimal lddONO
string lsDoNo
string lsorderno

//Get the next available DONO
sqlca.sp_next_avail_seq_no(gs_project,"Delivery_Master","DO_No" ,lddONO) 
lsDoNO = gs_Project + String(Long(ldDoNo),"000000") 
lsOrderNo = mid(lsDoNO, ( len( lsDoNO ) - 5 ), len( lsDoNO )) //Get The Invoice Number - last 7 digits of lsDoNO 

setOrderNumber( lsOrderNo )
isDono = lsDoNo

return 


end subroutine

public subroutine setordernumber (string _value);//setOrderNumber( string _value )

if isNull( _value ) then _value = ''
isorderno = _value

end subroutine

public function string getordernumber ();// string = getOrderNumber()
return isorderno


end function

public function string getdono ();// string = getDono()
return isDono

end function

public function integer dodonoheader (integer index);// doDoNoHeader( int index )

string	custstat
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
string	ship2country
string	ship2COO
int 		seq
int 		edibatchno
string	mawb

datetime ldtToday
datetime ldtRecieveDate
string	 shipdate
string	findthis
long		foundrow

// pvh 02.15.06 - gmt
ldtToday = f_getLocalWorldTime( gs_default_wh ) 

// 
// grab the data
// 
custstat			= Trim( this.object.customsstat[ index ] )
cust				= Trim( this.object.cust_code[ index ] )
custName		= Trim( this.object.cust_name[ index ] )
custAdr1		= Trim( this.object.cust_addr1[ index ] )
custcity			= Trim( this.object.cust_city[ index ] )
custstate		= Trim( this.object.cust_state[ index ] )
custzip			= Trim( this.object.cust_zip[ index ] )
carrier			= Trim( this.object.carrier[ index ] )	
warehouse	= Trim( this.object.wh_code[ index ] )	
ship2country	= Upper( Trim( this.object.ship_to_country[ index ] ))
shipdate		= Trim( this.object.ship_date[ index ] )
mawb			= Trim( this.object.mawb[ index ]  )
Dono 			= getDono()	
orderno			= right( dono, 6)

if isDate( shipdate ) then ldtRecieveDate = datetime( date(shipdate),time( '00:00:00') )

if setEdiBatchNo( isEDIOut ) = failure then return failure
ediBatchNo = getEDIBatchNo()

findthis = "Upper( country_name ) = '" + ship2country + "'"
foundrow = idsCountry.find( findthis,1,idsCountry.rowcount() )
if foundrow > 0 then
	ship2COO = idsCountry.object.designating_code[ foundrow ]
else
	ship2COO = ''
end if

if Upper(custstat) = 'T1' then custstat = 'T'

Insert Into Delivery_Master (Do_no, Project_id,Ord_date,Ord_status,Ord_Type,Inventory_type,freight_cost,user_field1,user_field11,request_date,EDI_Batch_Seq_No,
			   Cust_code, Cust_Name, Address_1,City, State, zip,country, wh_code, Invoice_No,Carrier,cust_order_no,Last_user,Last_Update  )
Values ( :DONO,:gs_project,:ldtToday,'N','S','N',0,'DDP',:custstat,:ldtRecieveDate,:ediBatchNo,
               :cust, :custName, :custAdr1, :custcity, :custstate, :custzip, :ship2COO, :warehouse,:orderno,:carrier,:mawb,:gs_userid,:ldtToday )
Using SQLCA;

If sqlca.sqlcode <> 0 Then
	lsErrText = sqlca.sqlerrtext /*text will be lost after rollback*/
	Execute Immediate "ROLLBACK" using SQLCA;
	Messagebox("Import","Error saving Row: " + String(index) + " Unable to save new Delivery Master record to database!~r~r" + lsErrText)
	SetPointer(Arrow!)
	Return failure
End If	

setEdiOrderSeq()
seq = getEdiOrderSeq()

// insert the edi outbound header
INSERT INTO dbo.EDI_Outbound_Header  
		( Project_ID, EDI_Batch_Seq_No,   Order_Seq_No, Status_cd)	
VALUES (  :gs_project, :ediBatchNo, :seq, 'C'	)
Using SQLCA;

If sqlca.sqlcode <> 0 Then
	lsErrText = sqlca.sqlerrtext /*error text lost in rollback*/
	Execute Immediate "ROLLBACK" using SQLCA;
	Messagebox("Import","Unable to Save EDI OutBound  header Record to Database.~r~r" + lsErrtext)
	SetPointer(Arrow!)
	Return failure
End If

setEdiLineNo( 0 )

return success



end function

public function integer dodonodetail (integer _index, integer _lineitemnumber);// integer = doDoNoDetail( int index, int lineitemnumber )

string lsSku
string lsAltSku
string lsSupplier
string lsErrText
string lsDoNo
string lsCurrencyCode
string lsPO
string	lsDeliveryNbr
decimal		dprice
decimal		dQty
string 	weight
long	 llOwner

lsSku 				= Upper( Trim(This.object.material[ _index ] ) )
lsSupplier 			= Upper( Trim(This.object.supplier[ _index ] ) )
lsCurrencyCode	= Trim(This.object.currencycode[ _index ] )
lsDeliveryNbr		= Trim(This.object.delivery_number[ _index ] )
dprice				= dec( Trim(This.object.local_unit_price[ _index ] ) )

//TAM 2006/06/16  Add an Upcharge calculation for price
if isnumber(g.isprojectuserfield1) and g.isprojectuserfield1 <> '0' then
	dprice = dprice * dec(g.isprojectuserfield1)
End If		

dQty					= dec( Trim(This.object.requested_qty[ _index ] ) )
weight				= Trim( this.object.total_gross_wght[ _index ] )
lsDono 				= getDono()
lsPO					= Trim( this.object.po_nbr[ _index ] )

// Get the ALternate SKU 
lsAltSku = getAltSKU( lsSKU )

//Return the Default Owner ID for the Supplier for the project 
llOwner = getOwnerId( lsSupplier )

// Insert the Delivery Detail Record
Insert Into Delivery_Detail (do_no, sku, supp_code, Owner_id, Alternate_sku, req_qty, alloc_qty, uom, price, cost,  line_Item_no,
										user_field1, user_field2,user_field3, user_field4 )
Values	(	:lsdoNo, :lsSKU,:lsSupplier, :llOwner, :lsAltSKU, :dQty, 0,  'EA', :dprice, 0,  :_lineitemnumber,	
				:lsDeliveryNbr, :lsCurrencyCode,:weight, :lsPO ) 
				
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

public subroutine setrono ();// setRoNo( string _value )

decimal ldRONO

//Get the next available DONO
sqlca.sp_next_avail_seq_no(gs_project,"Receive_Master","RO_No" ,ldRONO) 
isRono = gs_Project + String(Long( ldRONO ),"0000000") 

return 

end subroutine

public function string getrono ();// string = getRono()
return isRoNo

end function

public function integer doronoheader (long _index);// integer = doRoNoHeader( long _index )
long			ediBatchNo
string		cust
string		custName
string		custAdr1
string		custcity		
string		custstate
string		custzip		
string		carrier
string		orderno
string 		lsErrText
string		invoiceno
string		supplier
string		warehouse
string		rono
string		fltnbr
string		supplierOrderNbr
string		shipref
string		route
string		shipmentNbr
string		shipdate
string 		userfield5
datetime 	ldtToday, arrivaldate
int 			seq

// pvh 02.15.06 - gmt
ldtToday = f_getLocalWorldTime( gs_default_wh ) 

supplierOrderNbr 	= Trim( this.object.mawb[ _index ] )	
shipref					= Trim( this.object.mawb[ _index ] )	
userfield5				= Trim( this.object.mawb[ _index ] )
fltnbr						= Trim( this.object.flight_nbr[ _index ] )	// uf1
route						= Trim( this.object.route[ _index ] )	// uf4
shipmentnbr			= Trim( this.object.shipment[ _index ] )	// uf6
warehouse			= Trim( this.object.wh_code[ _index ] )	
supplier					= Trim( this.object.supplier[ _index ] )	
shipdate				= Trim( this.object.ship_date[ _index ] )
Rono 					= getRono()	
invoiceno 				= right( rono , 6 )

if isDate( shipdate ) then arrivaldate = datetime( date(shipdate),time( '00:00:00') )

if setEdiBatchNo( isEDIIn ) = failure then return failure
ediBatchNo = getEDIBatchNo()

Insert Into Receive_Master (ro_no, project_id, Ord_date, Ord_status, Ord_type, Inventory_Type, wh_Code,EDI_batch_seq_no,
										Supp_code, Supp_order_No,Supp_invoice_No ,ship_ref,AWB_BOL_NO,user_field4,user_field5,user_field6,arrival_date,request_date,
										Last_User, Last_Update)
		Values					(:RONO, :gs_Project, :ldtToday, 'N', 'S', 'N', :Warehouse,:ediBatchNo,
										:supplier, :supplierOrderNbr,:invoiceno,:shipref,:fltnbr,:route,:userfield5,:shipmentnbr,:arrivaldate,:arrivaldate,:gs_userid, :ldtToday)
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

setEdiOrderSeq()
seq = getEdiOrderSeq()

// insert the edi inbound header
INSERT INTO dbo.EDI_Inbound_Header  
		( Project_ID, EDI_Batch_Seq_No,   Order_Seq_No, status_cd)	
VALUES (  :gs_project, :ediBatchNo, :seq, 'C'	)
Using SQLCA;

If sqlca.sqlcode <> 0 Then
	lsErrText = sqlca.sqlerrtext /*error text lost in rollback*/
	Execute Immediate "ROLLBACK" using SQLCA;
	Messagebox("Import","Unable to Save EDI Inbound  header Record to Database.~r~r" + lsErrtext)
	SetPointer(Arrow!)
	Return failure
End If

setEdiLineNo( 0 )

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
string 		tariffCode
string 		grossWeight
string		lsDeliveryNbr
string		lsprice
decimal		dQty
long	 		llOwner
long 			ediBatchNo
string		findthis
long			foundrow

grossweight		= Trim(This.object.total_gross_wght[ _index ] )
tariffCode			= Trim(This.object.tarriff_code[ _index ] )
coo					= Trim(This.object.country_of_assembly[ _index ] )
lsSku 				= Upper( Trim(This.object.material[ _index ] ) )
lsSupplier 			= Upper(Trim(This.object.supplier[ _index ] ))
lsCurrencyCode	= Trim(This.object.currencycode[ _index ] )
lsDeliveryNbr		= Trim(This.object.delivery_number[ _index ] )
lsprice				= Trim(This.object.local_unit_price[ _index ]  )

//TAM 2006/06/16  Add an Upcharge calculation for price
if isnumber(g.isprojectuserfield1) and isNumber(lsprice) and g.isprojectuserfield1 <> '0' then
	lsprice = string(dec(lsprice) * dec(g.isprojectuserfield1),'#####.0000')
End If		

dQty					= dec( Trim(This.object.requested_qty[ _index ] ) )
lsRoNo 				= getRono()

// Get the ALternate SKU 
lsAltSku = getAltSKU( lsSKU )
	
//Return the Default Owner ID for the Supplier for the project 
llOwner = getOwnerId( lsSupplier )

insert into receive_detail
		( 	ro_no, Sku, supp_code, owner_id, country_of_origin, alternate_sku, line_item_no,
   			 user_field1, user_field3, req_qty, user_field4,user_field5,user_field6)
values( 	:lsRoNo,:lsSku,:lsSupplier,:llOwner,: coo,:lsAltSku,:_lineitemnumber,
			:lsDeliveryNbr,:tariffCode,:dQty,:lsprice,:lsCurrencyCode,:grossweight);

If sqlca.sqlcode <> 0 Then
	lsErrText = sqlca.sqlerrtext /*text will be lost after rollback*/
	Execute Immediate "ROLLBACK" using SQLCA;
	Messagebox("Import","Error saving Row: " + String( _index ) + " Unable to save new Receiving Detail record to database!~r~r" + lsErrText)
	SetPointer(Arrow!)
	Return failure
End If

return success


end function

public function integer dovalidatebreaks ();// integer = dovalidateBreaks()

string 		lsCust
string		lsCustHold
string		lsMAWB
string 		lsMAWBHold
datetime 	ldtToday
long 			index
int				lineItemNumber
long 			llRowCount
long			llRoNew
long			llDoNew
string		lsGroupId
string		lsGroupBreak

llRowCount = This.RowCount()

SetPointer(Hourglass!)

/*
	if MAWB changes but outbund order group id does not
	it's an error
*/

lsGroupBreak = Trim(this.object.outboundgroupid[ 1 ])	
lsMAWBHold = Trim(this.object.mawb[ 1 ]) 
for index = 1 to llRowCount
	lsGroupId = Trim(this.object.outboundgroupid[ index ])	
	lsMAWB = Trim(this.object.mawb[ index ]) 
	if lsMawb <> lsMawbHold then
		if lsGroupBreak = lsGroupId then
			setErrorRow( index )
			setmsg("No Outbound Group Code change when MAWB changed!")
			return failure
		end if
	end if
	lsMAWBHold = lsMawb
	lsGroupBreak = lsGroupId
next

/*
	if customer code changes but outbound order group id does not 
	it's an error
	
*/

lsGroupBreak	= Trim(this.object.outboundgroupid[ 1 ])	
lsCustHold 		= Trim(this.object.cust_code[ 1 ]) 
for index = 1 to llRowCount
	lsGroupId = Trim(this.object.outboundgroupid[ index ])	
	lsCust = Trim(this.object.cust_code[ index ]) 
	if lsCust <> lsCustHold then
		if lsGroupId = lsGroupBreak  then
			setErrorRow( index )
			setmsg("No Customer Code change when Outbound Group ID changed!")
			return failure
		end if
		lsGroupBreak = lsGroupId
		lsCustHold = lsCust
	end if
Next 	
return success

end function

public subroutine setmsg (string _value);// setmsg( string _value )
ismsg = _value

end subroutine

public function string getmsg ();// string = getmsg()
return ismsg

end function

public subroutine seterrorrow (long _value);ilErrorRow = _value

end subroutine

public function long geterrorrow ();return ilErrorRow

end function

public function long getedibatchno ();// long = getEdiBatchNo()
return ilEdiBatchNo

end function

public function integer getedilineno ();// int = getEdiLineNo()
return ilEdiOrderLineNo

end function

public subroutine setediorderseq ();// setEdiOrderSeq(  )

long seq

seq = getEdiOrderSeq()
if isNull( seq ) then seq = 0

seq++

ilEdiOrderSeq = seq
 
 
end subroutine

public function integer getediorderseq ();// int = getEdiOrderSeq()
return ilEdiOrderSeq
end function

public subroutine setedilineno ();// setEdiLineNo(  )
int seq

seq = getEdiLineNo()
if isNull( seq ) then seq = 0

seq++
ilEdiOrderLineNo = seq

end subroutine

public subroutine setedilineno (integer _value);// setEdiLineNo( int _value )
ilEdiOrderLineNo = _value

end subroutine

public function integer doedidetail (long _index, long _lineitemno);// integer = doEDIDetail( long _index )

string 		lsSku
string 		lsAltSku
string 		lsSupplier
string 		lsErrText
string 		coo
long	 		llOwner
long 			ediBatchNo
string		lot
string 		l_code
string 		po
int				seq
int				_line
string		invoiceno
decimal		dqty
datetime 	dtexp

l_code				= Trim(This.object.putaway_location[ _index ] )
lot						= Trim(This.object.hawb[ _index ] )
po						= Trim(This.object.number_of_cartons[ _index ] )
coo					= Trim(This.object.country_of_assembly[ _index ] )
lsSku 				= Upper( Trim(This.object.material[ _index ] ))
lsSupplier 			= Upper(Trim(This.object.supplier[ _index ] ))
invoiceno 			= right( getrono() , 6 )
dQty					= dec( Trim(This.object.requested_qty[ _index ] ) )
dtExp 				= datetime( date( '12/31/2999'),time('23:59:59') )

// magic
lot += "-" + string ( _index, "000" )

// Get the ALternate SKU 
lsAltSku = getAltSKU( lsSKU )

//Return the Default Owner ID for the Supplier for the project 
llOwner = getOwnerId( lsSupplier )

// Create the edi_inbound_detail
ediBatchNo = getEDIBatchNo()
seq = getEdiOrderSeq()
_line = getEdiLineNo()

insert into edi_inbound_detail
( project_id, EDI_batch_seq_no, Order_seq_no, Order_line_no, sku, Supp_Code, Owner_id,Country_of_Origin, 
  Alternate_SKU,lot_no,po_no,po_no2,l_code,order_no,line_item_no,quantity,container_id,expiration_date)
  
values( :gs_project,:ediBatchNo,:seq,:_line,:lsSku,:lsSupplier,:llOwner,:coo,
 :lsAltSku,:lot,:po,'Y',:l_code,:invoiceno,:_lineitemno,:dQty,'-',:dtExp)
using sqlca;

If sqlca.sqlcode <> 0 Then
	lsErrText = sqlca.sqlerrtext /*text will be lost after rollback*/
	Execute Immediate "ROLLBACK" using SQLCA;
	Messagebox("Import","Error saving Row: " + String( _index ) + " Unable to save EDI Batch Detail record to database!~r~r" + lsErrText)
	SetPointer(Arrow!)
	Return failure
End If

return success


end function

public function integer setedibatchno (string _tablename);// setEDIBatchNo()

decimal ldNexSeq
long llCount
string lsColumn = 'EDI_Batch_Seq_No'

Execute Immediate "Begin Transaction" using SQLCA; 

sqlca.sp_next_avail_seq_no(gs_project, _tablename ,lsColumn,ldNexSeq)
If SQLca.SQLCode < 0 Then
	Execute Immediate "ROLLBACK" using SQLCA;
	Messagebox("System Error","Unable to retrieve the Next Available Batch Seq No.")
	return failure
End If

If ldNexSeq <=0 Then
	
	//See if it already exists, if so that's not the problem. If not, add it
	Select Count(*) into :llCount
	From next_sequence_no
	Where Project_id = :gs_project and table_name = :_tablename and column_name = :lsColumn;
	If llCount > 0 Then
		Execute Immediate "ROLLBACK" using SQLCA;
		Messagebox("System Error","Unable to retrieve the Next Available Batch Seq No.")
	return failure

		
Else /* insert a new row and try again*/
		
		insert Into Next_Sequence_NO
			(project_id, table_name, column_Name, Next_Avail_seq_no)
			Values (:gs_project, :_tablename, :lsColumn, 1);
			
		Execute Immediate "COMMIT" using SQLCA;
		
		sqlca.sp_next_avail_seq_no(gs_project,_tablename,lsColumn,ldNexSeq)
		If SQLca.SQLCode < 0 Then
			Execute Immediate "ROLLBACK" using SQLCA;
			Messagebox("System Error","Unable to retrieve the Next Available Batch Seq No.")
			return failure
		End If
	End If /*Row not found */
End If

Execute Immediate "COMMIT" using SQLCA;

ilEdiBatchNo = Long( ldNexSeq )

Return success




end function

public function integer doedioutdetail (long _index, long _lineitemno);// integer = doEdiOutDetail( long _index )

string 		lsSku
string 		lsAltSku
string 		lsSupplier
string 		lsErrText
string 		coo
long	 		llOwner
long 			ediBatchNo
string		lot
string 		l_code
string 		po
int				seq
int				_line
string		orderno
decimal		dqty
datetime 	dtexp

l_code				= Trim(This.object.putaway_location[ _index ] )
lot						= Trim(This.object.hawb[ _index ] )
po						= Trim(This.object.number_of_cartons[ _index ] )
coo					= Trim(This.object.country_of_assembly[ _index ] )
lsSku 				= Upper(Trim(This.object.material[ _index ] ))
lsSupplier 			= Upper(Trim(This.object.supplier[ _index ] ))
dQty					= dec( Trim(This.object.requested_qty[ _index ] ) )
dtExp 				= datetime( date( '12/31/2999'),time('23:59:59') )
orderno				= right( getDono(), 6)

// magic
lot += "-" + string ( _index, "000" )

// Get the ALternate SKU 
lsAltSku = getAltSKU( lsSKU )

//Return the Default Owner ID for the Supplier for the project 
llOwner = getOwnerId( lsSupplier )

// Create the edi_inbound_detail
ediBatchNo = getEDIBatchNo()
seq = getEdiOrderSeq()
_line = getEdiLineNo()

insert into edi_outbound_detail
( project_id, EDI_batch_seq_no, Order_seq_no, Order_line_no, sku, Supp_Code, Owner_id,Country_of_Origin,invoice_no,inventory_type,sku_pickable_ind,
  Alternate_SKU,lot_no,po_no,po_no2,line_item_no,quantity,container_id,expiration_date)
  
values( :gs_project,:ediBatchNo,:seq,:_line,:lsSku,:lsSupplier,:llOwner,:coo,:orderno,'N','Y',
 :lsAltSku,:lot,:po,'Y',:_lineitemno,:dQty,'-',:dtExp)
using sqlca;

If sqlca.sqlcode <> 0 Then
	lsErrText = sqlca.sqlerrtext /*text will be lost after rollback*/
	Execute Immediate "ROLLBACK" using SQLCA;
	Messagebox("Import","Error saving Row: " + String( _index ) + " Unable to save EDI Outbound Batch Detail record to database!~r~r" + lsErrText)
	SetPointer(Arrow!)
	Return failure
End If
		
return success


end function

public function integer doaltaddress (long _index);// integer = doAltAddress( long _index )
// 
// create the alt address based on supplier
//
string 			supplier
string 			dono
long 				seq
int	    				orderseq
string 			cname
string 			addr1
string 			city
string 			state
string 			zip
string 			countryName
string 			countryCode
string			findthis
long				foundrow

seq 						= getEdiBatchNo()
orderseq				= getEdiOrderSeq()
dono 					= getDono()
supplier 				= Trim(This.object.supplier[ _index ] )
cname 					= Trim(This.object.cust_name[ _index ] )
addr1 					= Trim(This.object.cust_addr1[ _index ] )
city 						= Trim(This.object.cust_city[ _index ] )
state 						= Trim(This.object.cust_state[ _index ] )
zip 						= Trim(This.object.cust_zip[ _index ] )
countryName 		= Upper( Trim(This.object.ship_to_country[ _index ] ))

//designating_code
findthis = "Upper( country_name ) = '" + countryName + "'"
foundrow = idsCountry.find( findthis,1,idsCountry.rowcount() )
if foundrow > 0 then
	countryCode = idsCountry.object.designating_code[ foundrow ]
else
	countryCode = ''
end if

INSERT INTO dbo.Delivery_Alt_Address  
		( Project_ID, Address_Type, Name, Address_1, City,  State, Zip,Country, 
		EDI_Batch_Seq_No,Order_Seq_No,DO_NO )  
values(	:gs_project,'BT',:CName,:addr1,:city,:state,:zip, :countryCode,
		:seq,:orderseq, :dono);
if sqlca.sqlcode <> 0 then
	Execute Immediate "ROLLBACK" using SQLCA;
	Messagebox("System Error","Unable to Insert Delivery Alt  Address Entry!" )
	return failure
end if

return success

end function

public function string getaltsku (string _sku);// string = getAltSKU( string _sku )

string findthis
long foundrow
string AltSku

findthis = "Upper( sku ) = '" + _sku + "'"
foundrow = idsInventory.find( findthis,1,idsInventory.rowcount() )
if foundrow > 0 then
	AltSku = idsInventory.object.alternate_sku[ foundrow ]
else
	AltSku = _sku
end if
if isNull( AltSku ) then AltSku = _sku

return AltSKU
end function

public function long getownerid (string _supplier);// string = getAltSKU( string _sku )

string findthis
long foundrow
long ownerid

findthis = "Upper( owner_cd ) = '" + _supplier + "'"
foundrow = idsOwner.find( findthis,1,idsOwner.rowcount() )
if foundrow > 0 then
	ownerid = idsOwner.object.owner_id[ foundrow ]
else
	ownerid = 0 // can't be null
end if
return ownerid
end function

public function string getcommastrippedvalue (string value, boolean adecimal);// string = getCommaStrippedValue( string value )

int ipos
int lastpos

// modify any  
ipos = pos( value,"," ) 
do while ipos > 0
	value = left( value, ( ipos - 1) ) + right( value, len( value) - ipos )
	lastpos = ipos
	ipos = pos( value,"," ) 
loop
if not adecimal then return value

// make the last pos a period
if pos( value, "." ) = 0 then  // no decimal found
	if lastpos > 0 then	value = left( value, ( lastpos - 1 ) ) + "." + right( value, len( value) - ( lastpos -1 ) )
end if

return value

end function

public function string getservervalidation ();// string = getServerValidation()

return "OK"

end function

public function string dovalidate ();// string = doValidate()
string lsXMLResponse
string lsXML, lsDWXML
string lsReturnCode
string lsReturnDesc


//dovalidateBreaks()

// Format XML for websphere
// pvh 12/05/06 Validating List from Websphere now
iuoWebsphere = CREATE u_nvo_websphere_post
linit = Create Inet
lsXML = iuoWebsphere.uf_request_header("SimsImportRequest", "ProjectID='" + gs_Project + "'"   )
lsXML += 	'<ACTION>' + "RequestAction='Validate'"  +  '</ACTION>' 
// add in the datawindow data...
lsXML += Trim( this.Object.DataWindow.Data.XML )
lsXML = iuoWebsphere.uf_request_footer( lsXML  )
lsXMLResponse = iuoWebsphere.uf_post_url( lsXML )

messagebox( "XML", lsXMLResponse )


//Check for Valid Return...
//If we didn't receive an XML back, there is a fatal exception error
If pos(Upper(lsXMLResponse),"SIMSRESPONSE") = 0 Then
	Return "Websphere Fatal Exception Error! Unable to generate Pick List:" + lsXMLResponse
End If

//Check the return code and return description for any trapped errors
lsReturnCode = iuoWebsphere.uf_get_xml_single_Element(lsXMLResponse,"returncode")
lsReturnDesc = iuoWebsphere.uf_get_xml_single_Element(lsXMLResponse,"errormessage")
//
Choose Case lsReturnCode
	Case "-99" /* Websphere non fatal exception error*/
		Return "Websphere Operational Exception Error! Unable to generate Pick List: " + lsReturnDesc
	Case Else
		If lsReturnDesc > '' Then
			return lsReturnDesc
		End If
End Choose

//messagebox('',lsreturn)

return "OK"

end function

on u_dw_import_ams.create
call super::create
end on

on u_dw_import_ams.destroy
call super::destroy
end on

event ue_pre_validate;call super::ue_pre_validate;

if doValidateBreaks() = failure then
	this.scrolltorow( getErrorRow() )
	this.setrow( getErrorRow() )
	messagebox("Validation Error", getmsg(), stopsign! )
	return failure
end if
return success


end event

event constructor;call super::constructor;
//idsInventory 			= f_datastoreFactory("d_ams_sku_list")
//idsInventory.retrieve( gs_project )
//
//idsWarehouse		= f_datastoreFactory("d_ams_warehouse_cd_list")
//idsWarehouse.retrieve( gs_project )
//
//idsPutawayLoc		= f_datastoreFactory( "d_ams_warehouse_loc_list" )
//idsPutawayLoc.retrieve( gs_project )
//
//idsOwner				= f_datastoreFactory( "d_ams_warehouse_owner_list" )
//idsOwner.retrieve( gs_project )
//
//// pvh - 01/29/07 - g.getSupplierDs() was changed to only load for 3com
////idsSupplier 			= g.getSupplierDs()
//idsSupplier = f_datastoreFactory( 'd_supplier_list_by_project' )
//idsSupplier.retrieve( gs_project )
////
//idsCountry 			= g.getCountryDs()

if gs_project = "PHYSIO-XD" then //hdc 09252012
	this.dataobject = "d_import_physio_xdoc"
	this.setTransObject(SQLCA)
end if



end event

event destructor;call super::destructor;if isValid( idsInventory  ) then destroy( idsInventory )
if isValid( idsWarehouse ) then destroy( idsWarehouse)
if isValid( idsPutawayLoc  ) then destroy( idsPutawayLoc)



end event

