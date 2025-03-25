$PBExportHeader$u_dw_import_forwardpick.sru
forward
global type u_dw_import_forwardpick from u_dw_import
end type
end forward

global type u_dw_import_forwardpick from u_dw_import
string dataobject = "d_import_forwardpick"
end type
global u_dw_import_forwardpick u_dw_import_forwardpick

forward prototypes
public function integer wf_save ()
public function string wf_validate (long al_row)
end prototypes

public function integer wf_save ();
// start- by Santosh - written to insert and update the forward pick location 2013/12/18

long ll_returncode, ll_numrows, ll_rownum, ll_reccount, ll_fileid , ll_minfpqty, ll_replqty,ll_maxqty
string ls_projectid, ls_sku, ls_suppcode,ls_location,ls_whcode, ls_curcode, ls_partind
decimal ld_price1, ld_price2

date ld_date

string ls_priceclass

// KRZ What is the dataobject?
Choose Case dataobject
		
	// d_import_price_data
	Case "d_import_forwardpick"
		
		ll_fileid = fileopen("c:\sims-mww\import.txt", linemode!, write!, lockwrite!, replace!)
		
		// Set the pointer to hourglass.
		setpointer(hourglass!)
		
		// Get the number of rows.
		ll_numrows = rowcount()
		
		// Loop through the rows.
		For ll_rownum = 1 to ll_numrows
			
			// Set microhelp.
			w_main.setmicrohelp("Getting Import Record " + string(ll_rownum) + " of " + string(ll_numrows) + ".")
			
			// Get primary key values for the record.
			ls_projectid = getitemstring(ll_rownum, "project_id")
			ls_sku = getitemstring(ll_rownum, "sku")
			ls_suppcode = getitemstring(ll_rownum, "supp_code")
			ls_location = getitemstring(ll_rownum, "l_code")
			ls_sku = getitemstring(ll_rownum, "sku")
			ls_whcode = getitemstring(ll_rownum, "wh_code")
			ll_minfpqty = getitemnumber(ll_rownum, "min_fp_qty")
			ll_maxqty = getitemnumber(ll_rownum, "Max_Qty_To_Pick")
			ll_replqty = getitemnumber(ll_rownum, "Replenish_Qty")
			ls_partind = getitemstring(ll_rownum, "Partial_Pick_Ind")
			
			ld_date = today();
			
		
			
			// See if this record already exists.
			Select count(*) into :ll_reccount from item_forward_pick where project_id = :ls_projectid and sku = :ls_sku and supp_code = :ls_suppcode and l_code = :ls_location using sqlca;
			
			// If the record already exists,
			If ll_reccount > 0 then
				
				// Update the price.
				Update item_forward_pick  set  l_code  = :ls_location , min_fp_qty = :ll_minfpqty, Max_Qty_To_Pick =:ll_maxqty , Replenish_Qty = :ll_replqty ,  Partial_Pick_Ind = :ls_partind  where project_id = :ls_projectid and sku = :ls_sku and supp_code = :ls_suppcode using sqlca;
			
				// Set microhelp.
				w_main.setmicrohelp("Updating import Record " + string(ll_rownum))
			
// 				// Set the status as datamodified.
//				SetItemStatus(ll_rownum, 0, Primary!, DataModified!)

			// Otherwise, if the record does not exist,
			Else
				
				// Insert a new price record.
				Insert into item_forward_pick values (:ls_projectid, :ls_sku, :ls_suppcode, :ls_whcode, :ls_location,:ll_minfpqty,:ll_maxqty, :	ll_replqty,:ls_partind ,:gs_userid,:ld_date, 0, 0) using sqlca;
			
				// Set microhelp.
				w_main.setmicrohelp("Inserting import Record " + string(ll_rownum))
				
			End If
			
			filewrite(ll_fileid, string(ll_rownum))
			
		// Next Record.
		Next
		
		fileclose(ll_fileid)
		
//		// Save the data
//		ll_returncode = update()
		
		// Commit the changes.
		Execute Immediate "COMMIT" using SQLCA;
		
		// Set the pointer to arrow.
		setpointer(arrow!)
		
// End What is the dataobject.
End Choose

// Set microhelp to 'ready'.
w_main.setmicrohelp("Ready...")

// Return ll_returncode
Return ll_returncode
end function

public function string wf_validate (long al_row);// validating each rows for forward pick location--- start by santosh
	
//Validate for valid field length and type

// if Currvalcolumn > '' then we didn't validate the whole row, start with the next column

string  ls_suppcode , ls_project,ls_sku,	ls_prevsku , ls_cursku,ls_cursupp, ls_prevsupp, ls_location, ls_whcode
long ll_count,  ll_cnt
int i 

Choose Case iscurrvalcolumn
	Case "project_id"
		goto lwhcode
	Case "wh_code"
		goto lsuppcode
	case "supp_code"
		goto sku
	case "sku"
		goto lcode
	Case "l_code"
		goto lreplenishQty
	Case "replenish_qty"
		goto lmaxqtypick
	Case "max_qty_to_pick"
		goto lminfpqty
	case "min_fp_qty"
		goto lpartialpick
	Case "partial_pick_ind"
		goto lreplenishuponind
	case "replenish_upon_reciept_ind"
			iscurrvalcolumn = ''
		return ''
End Choose


		//Validate project_id
		ls_project = This.getItemString(al_row,"project_id")
		If isnull( ls_project) Then
			This.Setfocus()
			This.SetColumn("project_id")
			iscurrvalcolumn = "project_id"
			return "'Projec_id' can not be null!"
		elseif (ls_project <> gs_project)  then
			messagebox("Error", "Project Id is not valid")
			return 'Project Id is not valid'
		End If
		
		
		If len(trim(This.getItemString(al_row,"project_id"))) > 10 Then
			This.Setfocus()
			This.SetColumn("Project_id")
			iscurrvalcolumn = "project_id"
			return "'Project Id is > 10 characters"
		End If
			
		lwhcode:
		//Validate wh_code
		
		ls_whcode = This.getItemString(al_row,"wh_code")
		
		If len(trim(This.getItemString(al_row,"wh_code"))) > 10 Then
			This.Setfocus()
			This.SetColumn("wh_code")
			iscurrvalcolumn = "wh_code"
			Return "wh code is > 10 Characters"
		End If
			
		lsuppcode:
		//Validate suppcode
		
		ls_suppcode = This.getItemString(al_row,"supp_code")
		If isnull( ls_suppcode) Then
			This.Setfocus()
			This.SetColumn("supp_code")
			iscurrvalcolumn = "supp_code"
			return "'supplier' can not be null!"
		End if 
			
			
		If len(trim(This.getItemString(al_row,"supp_code"))) > 20 Then
			This.Setfocus()
			This.SetColumn("supp_code")
			iscurrvalcolumn = "supp_code"
			Return "supp_code is > 20 characters"
		End If
		
		sku:
		//validate sku
		ls_sku = This.getItemString(al_row,"sku")
		If isnull( ls_sku) Then
			This.Setfocus()
			This.SetColumn("sku")
			iscurrvalcolumn = "sku"
			return "'SKU' can not be null!"
		End if 
			
		If len(trim(This.getItemString(al_row,"sku"))) > 10 Then
			This.Setfocus()
			This.SetColumn("sku")
			iscurrvalcolumn = "sku"
			Return "SKUis > 10 characters"
		End If
			
	lcode:
//		location code
		ls_location = This.getItemString(al_row,"l_code")
		If len(trim(This.getItemString(al_row,"l_code"))) > 10 Then
			This.Setfocus()
			This.SetColumn("l_code")
			iscurrvalcolumn = "location"
			Return "Location  is > 10 characters"
		End If
		

		select count(*) into :ll_cnt 
		From  location where wh_code = :ls_whcode and l_code =:ls_location and (loc_non_pickable_ind  <>' Y' or loc_non_pickable_ind is null)  using SQLCA; 
		If  (ll_cnt > 1) Then
			return " Location is not valid"
		End if 
		
		
		
		lreplenishqty:
		////Validate State
		//If len(trim(This.getItemString(al_row,"state"))) > 40 Then
		//	This.Setfocus()
		//	This.SetColumn("state")
		//	iscurrvalcolumn = "state"
		//	Return "State is > 40 characters"
		//End If
		//
		lminfpqty:
		////Validate Zip
		//If len(trim(This.getItemString(al_row,"zip"))) > 40 Then
		//	This.Setfocus()
		//	This.SetColumn("zip")
		//	iscurrvalcolumn = "zip"
		//	Return "Zip Code is > 40 characters"
		//End If
		//
		
		lmaxqtypick:
		////Validate Country
		//If len(trim(This.getItemString(al_row,"country"))) > 30 Then
		//	This.Setfocus()
		//	This.SetColumn("country")
		//	iscurrvalcolumn = "country"
		//	Return "Country is > 30 characters"
		//End If
		//
		lpartialpick:
		////Validate Telephone
		//If len(trim(This.getItemString(al_row,"telephone"))) > 20 Then
		//	This.Setfocus()
		//	This.SetColumn("telephone")
		//	iscurrvalcolumn = "telephone"
		//	Return "Telephone is > 20 characters"
		//End If
		//
		
		lreplenishuponind:
		////Validate fax
		//If len(trim(This.getItemString(al_row,"fax"))) > 20 Then
		//	This.Setfocus()
		//	This.SetColumn("fax")
		//	iscurrvalcolumn = "fax"
		//	Return "Fax is > 20 characters"
		//End If
		//
			

	
iscurrvalcolumn = ''
return ''










end function

on u_dw_import_forwardpick.create
call super::create
end on

on u_dw_import_forwardpick.destroy
call super::destroy
end on

event ue_pre_validate;//start by santosh K - 02-06-2014, for checking duplicate serial /sku combinatios for forward pick 

String ls_prevsku , ls_cursku , ls_prevsupp , ls_cursupp
long ll_count
int i 

//IF ( This.dataobject = 'd_import_forwardpick') THEN 
ll_count =	this.rowcount()
This.setsort("#3 C, #4 D")
This.sort()
FOR i=1 to This.RowCount()
	
		ls_cursku  = This.object.sku[i] 
			ls_cursupp =This.object.supp_code[i]
			IF ( ls_cursku  = ls_prevsku and ls_cursupp = ls_prevsupp) Then
				messagebox ("Duplicates", "Duplicate SKU/Suppliers Please check !!")
			return 1	
			End if 
			
			ls_prevsku =ls_cursku 
			ls_prevsupp =ls_cursupp
NEXT
this.setredraw(true)


//- end by santosh 02-06-2014, for checking duplicate serial /sku combinatios for forward pick 
end event

