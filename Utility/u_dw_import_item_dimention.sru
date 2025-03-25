HA$PBExportHeader$u_dw_import_item_dimention.sru
$PBExportComments$Generic DW for importing data
forward
global type u_dw_import_item_dimention from u_dw_import
end type
end forward

global type u_dw_import_item_dimention from u_dw_import
integer width = 3982
integer height = 720
string dataobject = "d_import_itemaster_dimentions_external"
end type
global u_dw_import_item_dimention u_dw_import_item_dimention

forward prototypes
public function integer wf_save ()
end prototypes

public function integer wf_save ();Long	llRowCount,	&
		llRowPos,  &
		ll_qty		
real 	lrLength,	&
			lrWidth,	&
			lrHeight

String	lsSku,lsErrText

			
Datetime		ldToday, ldtServerTime

// pvh 02.15.06 - gmt
ldToday = f_getLocalWorldTime( gs_default_wh ) 
ldtServerTime = DateTime(Today(),Now())

llRowCount = This.RowCount()

//llupdate = 0
//llNew = 0
//
SetPointer(Hourglass!)
//Update or Insert for each Row...

Execute Immediate "Begin Transaction" using SQLCA; /* 11/04 - PCONKL - Auto Commit Turned on to eliminate DB locks*/

If Upper(gs_project) = 'CHINASIMS'  THEN
	 SQLCA.DBParm = "disablebind =0"
End If

For llRowPos = 1 to llRowCOunt
	
	w_main.SetmicroHelp("Saving Row " + string(llRowPos) + " of " + string(llRowCount))
	
	lsSku = left(trim(This.GetItemString(llRowPos,"sku")),50)
	lrLength=real(trim(this.object.length[llRowPos]))
	lrWidth=real(trim(this.object.width[llRowPos]))
	lrHeight=real(trim(this.object.height[llRowPos]))
//	Messagebox("",lsSku+" "+String(lrLength)+" "+String(lrWidth)+" "+String(lrHeight))
//	lsACSku = left(trim(This.GetItemString(llRowPos,"acdelco_sku")),50)
////	lsDesc = left(trim(This.GetItemString(llRowPos,"Description")),50)
////	lsSupplier = left(trim(This.GetItemString(llRowPos,"supplier_id")),10)
//	If Upper(Left(gs_project,4)) = 'GM_M' and (isnull(lsSupplier) or lsSupplier = '') Then
//		lsSupplier = 'XX'
//	End If
//	
////	lsGroup = left(trim(This.GetItemString(llRowPos,"group")),10)
////	lsuom1 = left(trim(This.GetItemString(llRowPos,"uom_1")),4)
//	llLength1 = Long(This.GetItemString(llRowPos,"length_1"))
//	llWidth1 = Long(This.GetItemString(llRowPos,"Width_1"))
//	llheight1 = Long(This.GetItemString(llRowPos,"height_1"))
//	
//	// 11/00 PCONKL - Supplier is now part of the primary key and Required
//	//try update first
//	
//	If Upper(Left(gs_project,4)) <> 'GM_M'  Then
//		
//		Update item_master Set
//		alternate_sku = :lsacSku,
//		grp = :lsGroup,
//		description = :lsDesc,
//		uom_1 = :lsUOM1, 
//		length_1 = :lllength1,
//		width_1 = :llWidth1,
//		height_1 = :llHeight1,
//		last_user = :gs_userid,
//		last_update = :ldToday
//		Where sku = :lsSku and project_id = :gs_project and supp_code = :lsSupplier
//		Using Sqlca;
//		
//	Else
		Update item_master 
		Set length_1 = :lrlength,
			width_1 = :lrWidth,
			height_1 = :lrHeight,
			last_user = :gs_userid,
			last_update = :ldToday,
			interface_upd_req_Ind = 'Y'
			Where sku = :lsSku and project_id = :gs_project 
			Using Sqlca;
//	End If
//	
//	If Sqlca.sqlnrows <> 1 Then /*Insert*/
	   
		// 11/00 PCONKL - Owner ID is required. Default to 'XX' for current project
	//	Select owner_id into :llOwner
	//	From Owner
	//	Where project_id = :gs_project and owner_type = 'S' and owner_cd = 'XX'
	//	Using SQLCA;
		
//		Insert Into item_master (project_id,sku,owner_id,supp_code,length_1, width_1, height_1, last_user,last_update) values (:gs_project,:lsSku,:llOwner,'XXX',:lsDesc,:lsACSku,:lsSupplier,:lsgroup,:lsuom1,:llLength1, :llWidth1, :llheight1,:gs_userid,:ldToday)
//		Using SQLCA;
//	
		If sqlca.sqlcode <> 0 Then
			lsErrText = sqlca.sqlerrtext /*text will be lost after rollback*/
			
			If Upper(gs_project) = 'CHINASIMS'  THEN
				 SQLCA.DBParm = "disablebind =1"
			End If			
		
			Execute Immediate "ROLLBACK" using SQLCA;
			Messagebox("Import","Unable to save changes to database!~r~r" + lsErrText)
			SetPointer(Arrow!)
			Return -1
	Else
//			llnew ++
		End If
//	Else /*update*/
//		llupdate ++
//	End If
//	
Next
//

If Upper(gs_project) = 'CHINASIMS'  THEN
	 SQLCA.DBParm = "disablebind =1"
End If

Execute Immediate "COMMIT" using SQLCA;
If sqlca.sqlcode <> 0 Then
	MessageBox("Import","Unable to Commit changes! No changes made to Database!")
	Return -1
End If

// 02/09 - PCONKL - We may need to trigger an Item Master Update to another party (e.g LMS) - Only need one record
Execute Immediate "Begin Transaction" using SQLCA; 
	
Insert Into batch_Transaction (project_ID, Trans_Type, Trans_Order_ID, Trans_Status, Trans_Create_Date, Trans_Parm)
		Values(:gs_Project, 'IM', "",'N', :ldtServerTime, '');
							
Execute Immediate "COMMIT" using SQLCA;
	
	

//MessageBox("Import","Records saved.~r~rRecords Updated: " + String(llUpdate) + "~r~rRecords Added: " + String(llNew))
//w_main.SetmicroHelp("Ready")
//SetPointer(Arrow!)
Return 0
end function

on u_dw_import_item_dimention.create
call super::create
end on

on u_dw_import_item_dimention.destroy
call super::destroy
end on

