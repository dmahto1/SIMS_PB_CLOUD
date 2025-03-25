$PBExportHeader$u_nvo_edi_confirmations_ams_muser.sru
forward
global type u_nvo_edi_confirmations_ams_muser from nonvisualobject
end type
end forward

global type u_nvo_edi_confirmations_ams_muser from nonvisualobject
end type
global u_nvo_edi_confirmations_ams_muser u_nvo_edi_confirmations_ams_muser

type variables

Datastore	idsROMain, idsRODetail, idsROPutaway, idsDOMain, idsDODetail, idsDOPick, idsDOPack,	&
				idsOut, idsGR, idsAdjustment, idsWOMain, idsWOPick, idsCOO_Translate
				
u_nvo_marc_transactions		iu_nvo_marc_transactions	

end variables

forward prototypes
public function integer uf_rt (string asproject, string asrono)
public function integer uf_gr (string asproject, string asrono)
public function integer uf_adjustment (string asproject, long aladjustid, long aitransid)
end prototypes

public function integer uf_rt (string asproject, string asrono);If Not isvalid(iu_nvo_marc_transactions) Then	
		iu_nvo_marc_transactions = Create u_nvo_marc_transactions
	End If
	iu_nvo_marc_transactions.uf_receipts(asProject,asRoNo)

Return 0
end function

public function integer uf_gr (string asproject, string asrono);

	If Not isvalid(iu_nvo_marc_transactions) Then	
		iu_nvo_marc_transactions = Create u_nvo_marc_transactions
	End If
	
	//24-Jun-2013 :Madhu added code to stop send transaction files to MarcGT, if WH is Non-bonded -START
      string ls_whtype
      select wh_type  into :ls_whtype from Warehouse_Type where WH_Type in (
                                        select WH_Type from Warehouse where WH_Code in (
                                         select WH_Code from Receive_Master where RO_No=:asrono))
      using sqlca;

 //17-Feb-2014 :Madhu- C13-135 - PHC - Split re-trigger interface files (SIMS- MARC GT) -START
//	IF ls_whtype <> 'N' THEN
//	//24-Jun-2013 :Madhu added code to stop send transaction files to MarcGT, if WH is Non-bonded -END
//		iu_nvo_marc_transactions.uf_receipts(asProject,asRoNo)
//	END IF 	//24-Jun-2013 :Madhu added code to stop send transaction files to MarcGT, if WH is Non-bonded -Added
//17-Feb-2014 :Madhu- C13-135 - PHC - Split re-trigger interface files (SIMS- MARC GT) -END
Return 0
end function

public function integer uf_adjustment (string asproject, long aladjustid, long aitransid);//Prepare a Marc GT Stock Adjustment Transaction for AMS-USER for the Stock Adjustment just made

Long			llNewRow, llOldQty, llNewQty, llNetQty, llRowCount, llAdjustID, llOwnerID, llOrigOwnerID
				
String		lsOldInvType,	lsNewInvType,		&
				lsLogOut, lsWarehouse, &
				lsoldcoo, lsnewcoo, lsoldPo_No2, lsnewPo_No2, lsNewOwnerCD, lsTransParm

DateTime	ldtTransTime

lsLogOut = "      Creating MM For AdjustID: " + String(alAdjustID)
FileWrite(gilogFileNo,lsLogOut)

If Not isvalid(idsAdjustment) Then
	idsAdjustment = Create Datastore
	idsAdjustment.Dataobject = 'd_adjustment'
	idsAdjustment.SetTransObject(SQLCA)
End If

// 06/04 - PCONKL - We need the transaction stamp from the transaction file instead of using the current timestamp which is GMT on the server.
// 03/05 - For qualitative adjustments between 2 existing buckets, there is relevent info in the parm field that we need to properly report the adjustment

Select Trans_create_date, Trans_parm into :ldtTranstime, :lsTransParm
From Batch_Transaction
Where Trans_ID = :aiTransID;

If isNull(ldtTranstime) Then ldtTranstime = DateTime(Today(),Now())

//Retreive the adjustment record
If idsAdjustment.Retrieve(asProject, alAdjustID) <= 0 Then
	lsLogOut = "        *** Unable to retreive Adjustment Record for AdjustID: " + String(alAdjustID)
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

lsOldInvType = idsadjustment.GetITemString(1,"old_inventory_type") /*original value before update!*/
lsNewInvType = idsadjustment.GetITemString(1,"inventory_type")

llOwnerID = idsadjustment.GetITemNumber(1,"owner_ID")
llOrigOwnerID = idsadjustment.GetITemNumber(1,"old_owner")

llNewQty = idsadjustment.GetITemNumber(1,"quantity")
lloldQty = idsadjustment.GetITemNumber(1,"old_quantity")

lsOldCOO = idsadjustment.GetITemString(1,"old_country_of_origin") /*original value before update!*/
lsNewCOO = idsadjustment.GetITemString(1,"country_of_origin")

lsOldPO_NO2 = idsadjustment.GetITemString(1,"old_Po_No2") /*original value before update!*/
lsNewPO_NO2 = idsadjustment.GetITemString(1,"Po_No2")

lsNewOwnerCd = idsadjustment.GetITemString(1,"new_owner_cd")
		
//TAMCCLANAHAN 
//Begin Process Mark GT interface

// Call MARC GT Interface on Change in Inventory Type, Original Owner, Qty, Bonded, COO --- To Be Coded Later 
lsWarehouse = idsadjustment.GetITemString(1,'Wh_Code')


If (lsOldInvType <> lsNewInvType) or (llOwnerID <> llOrigOwnerID) or (llOldQty <> llNewQty) or (lsOldPo_no2 <> lsNewPo_No2) or (lsOldCoo <> lsNewCoo) Then
		If Not isvalid(iu_nvo_marc_transactions) Then	
			iu_nvo_marc_transactions = Create u_nvo_marc_transactions
		End If
		iu_nvo_marc_transactions.uf_corrections(asProject,alAdjustID)
End If
//End Marc GT Process


Return 0
end function

on u_nvo_edi_confirmations_ams_muser.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_nvo_edi_confirmations_ams_muser.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

