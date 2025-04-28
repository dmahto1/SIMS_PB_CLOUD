HA$PBExportHeader$u_nvo_edi_confirmations_bobcat.sru
$PBExportComments$Process outbound edi confirmation transactions for Bobcat
forward
global type u_nvo_edi_confirmations_bobcat from nonvisualobject
end type
end forward

global type u_nvo_edi_confirmations_bobcat from nonvisualobject
end type
global u_nvo_edi_confirmations_bobcat u_nvo_edi_confirmations_bobcat

type variables

Datastore	idsROMain, idsRODetail, idsROPutaway, idsDOMain, idsDODetail, idsDOPick, idsDOPack,	&
				idsOut, idsGR, idsAdjustment
end variables

forward prototypes
public function integer uf_gi (string asproject, string asdono)
public function integer uf_gr (string asproject, string asrono)
end prototypes

public function integer uf_gi (string asproject, string asdono);
Integer	liRC
String	lsWarehouse, lsLogOut
//Bobcat gets a standard GLs Shipment MR

// we only want to send for shipments out of Aurora, Not Shanghai.

Select wh_code into :lsWarehouse
From Delivery_master
Where do_no = :asDoNo;

If lsWarehouse <> 'BOBCAT-AUR' Then 
	lsLogOut = "      Skipping GLS Shipment MR For DONO: " + asDONO + " (Order not shipped out of Aurora warehouse)"
	FileWrite(gilogFileNo,lsLogOut)
	Return 0
End If

//U_nvo_edi_confirmations_gls	lu_gls

//u_Gls = Create U_nvo_edi_confirmations_gls

//liRC = lu_gls.uf_shipment_MR(asProject,asDONO)

Return liRC
end function

public function integer uf_gr (string asproject, string asrono);
Integer liRC	
String	lsWarehouse, lsLogOut
//Bobcat gets a standard GLs Shipment MR

// we only want to send for Receipts Into Aurora, Not Shanghai.

Select wh_code into :lsWarehouse
From Receive_master
Where Ro_no = :asRoNo;

If lsWarehouse <> 'BOBCAT-AUR' Then 
	lsLogOut = "      Skipping GLS Receipt MR For RONO: " + asRONO + " (Order not Received into Aurora warehouse)"
	FileWrite(gilogFileNo,lsLogOut)
	Return 0
End If


//Send a standard MR back to GLS

//U_nvo_edi_confirmations_gls	lu_gls

//lu_gls = Create U_nvo_edi_confirmations_gls

//liRC = lu_gls.uf_receipt_mr(asProject, asRoNO, '',0) /* Blank for third parm and zero for 4th are to allow us to create the Inbound portion of the Ship MR for a particular SKU*/

REturn liRC
end function

on u_nvo_edi_confirmations_bobcat.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_nvo_edi_confirmations_bobcat.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

