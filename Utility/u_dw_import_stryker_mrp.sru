HA$PBExportHeader$u_dw_import_stryker_mrp.sru
forward
global type u_dw_import_stryker_mrp from u_dw_import
end type
end forward

global type u_dw_import_stryker_mrp from u_dw_import
integer width = 3506
integer height = 1572
string dataobject = "d_import_stryker_mrp"
boolean border = false
borderstyle borderstyle = stylebox!
end type
global u_dw_import_stryker_mrp u_dw_import_stryker_mrp

type variables

Datastore	idsItem

string is_dw_name[]
end variables

forward prototypes
public function string wf_validate (long al_row)
public function integer wf_save ()
end prototypes

public function string wf_validate (long al_row);
return ''

end function

public function integer wf_save ();//
////Upon validation pass ,  for each SHP (order no) update the corresponding fields in SIMS with those data found in the excel file $$HEX1$$1320$$ENDHEX$$Batch No (LOB) , Region, Carton Remarks and Remarks.
////If the SHP (order no) contain batch no, ship date, region, carton remark and remarks fields in the excel file contain blank, do not update blank to the corresponding  field in SIMS. Remain the corresponding field in SIMS as it is.
////System will prompt status of posting successful upon completion of the upload.
////
//
//
////$$HEX1$$1320$$ENDHEX$$Batch No (LOB) , Region, Carton Remarks and Remarks.
//

string ls_sku, ls_supp_code, ls_License_Number, ls_Country_of_Manufacturer, ls_State
decimal ld_MRP_price


long llRow, llCount
string lsDoNo
boolean ib_fail = false
string lsBatch, lsRegion, lsCartonRemarks, lsRemarks

For llRow = 1 to this.RowCount()  

	ls_sku = this.GetItemString( llRow, "sku")
	ls_supp_code = "IN_STRYKER"
	ld_MRP_price = dec(this.GetItemString( llRow, "mrp_price"))
	ls_License_Number = this.GetItemString( llRow, "license_num")
	ls_Country_of_Manufacturer = GetItemString( llRow, "country_of_manufacturer")
	ls_State =  GetItemString( llRow, "state")
	
	
	If IsNull(ls_Country_of_Manufacturer) OR trim(ls_Country_of_Manufacturer) = '' Then
		ls_Country_of_Manufacturer = "XXX"
	End IF
	


	Select Count(*) INTO :llCount
		FROM SKU_MRP with (NoLock)
		WHERE Project_ID = :gs_project AND Sku = :ls_sku AND Supp_Code = :ls_supp_code AND country_of_manufacturer = :ls_Country_of_Manufacturer USING SQLCA;

	if SQLCA.SQLCode <> 0 then
		MessageBox ("Error DB - Select", SQLCA.SQLErrText )
	end if

	IF llCount > 0 then

		Update SKU_MRP 
		Set MRP_price = :ld_MRP_price,
			License_Number = :ls_License_Number,
			State = :ls_State,
			Last_User =:gs_userid,
			Last_Update = getdate()
		WHERE Project_ID = :gs_project AND Sku = :ls_sku AND Supp_Code = :ls_supp_code AND 
				  country_of_manufacturer = :ls_Country_of_Manufacturer USING SQLCA;
				  

		if SQLCA.SQLCode <> 0 then
			MessageBox ("Error DB - Update", SQLCA.SQLErrText )
		end if			  

	ELSE

		Insert Into SKU_MRP (
			Project_ID,
			SKU,
			Supp_Code,
			MRP_price,
			License_Number,
			Country_of_Manufacturer,
			State,
			Last_User,
			Last_Update )
			Values (
			:gs_project,
			:ls_sku,
			:ls_supp_code,
			:ld_MRP_price,
			:ls_License_Number,
			:ls_Country_of_Manufacturer,
			:ls_State,
			:gs_userid,
			getdate());
	
			if SQLCA.SQLCode <> 0 then
				MessageBox ("Error DB - Insert", SQLCA.SQLErrText )
			end if
	
		END IF
		
	COMMIT using SQLCA;
	
	if SQLCA.SQLCode <> 0 then
		MessageBox ("Error DB - Commit", SQLCA.SQLErrText )
	end if

Next /*Next Import Column*/



MessageBox("Import","Records saved.~r~rDelivery Orders Updated : " + String( this.RowCount() ))
w_main.SetmicroHelp("Ready")
SetPointer(Arrow!)

Return 0

end function

on u_dw_import_stryker_mrp.create
call super::create
end on

on u_dw_import_stryker_mrp.destroy
call super::destroy
end on

event ue_pre_validate;call super::ue_pre_validate;
Long	llRowPos, llRowCount, llFindRow
string  lsSku

boolean ib_Fail = false
integer li_count

//Loop thru Items and preload into DS
lLRowCount = This.RowCount()

For llRowPOs = 1 to llRowCount
	
	w_main.SetMicroHelp("Retrieving ItemMaster information for row: " + String(lLRowPos))
	
	
	lsSku = this.GetItemString( llRowPOs, "sku") 
	
	IF Not IsNull(lsSku) AND trim(lsSku) <> "" THEN	
		
	
		SELECT  Count(*) into :li_count
        FROM Item_Master   
			Where Project_id = :gs_project AND Sku = :lsSku USING SQLCA;
			
			
		IF SQLCA.SQLCode <> 0  OR li_count = 0 THEN
			
			if not ib_fail then
				this.SetRow(llRowPOs)
			end if
			
			ib_fail = true

			MessageBox ("Error", "Sku: " + lsSku + " is not a valid sku.")
			
		END IF
		
	ELSE
		
			if not ib_fail then
				this.SetRow(llRowPOs)
			end if
		
		ib_fail = true

		MessageBox ("Error", "Sku cannot be blank.")
		
		
	
	END IF
	

	
Next


w_main.SetMicroHelp("Ready")

IF ib_fail = true THEN
	
	RETURN -1
	
END IF


Return 0
end event

