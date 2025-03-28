$PBExportHeader$u_dw_import_wave_plan.sru
$PBExportComments$+ Import Wave Plan
forward
global type u_dw_import_wave_plan from u_dw_import
end type
end forward

global type u_dw_import_wave_plan from u_dw_import
integer width = 4256
integer height = 2064
string dataobject = "d_baseline_unicode_generic_import"
end type
global u_dw_import_wave_plan u_dw_import_wave_plan

type variables
long llvisiblecoulmncount
Datastore idsIM
n_warehouse i_nwarehouse
end variables

forward prototypes
public function integer wf_save ()
public function string of_get_sequenceno ()
public function string wf_validate (long al_row)
end prototypes

public function integer wf_save ();//24-Apr-2017 :Madhu PEVS-567- KNY– Custom Wave Plan input sheet
//create Delivery Master and Delivery Detail Records.

String ls_WhName, ls_whcode, ls_dono, ls_Sku, ls_find, ls_suppcode
long ll_row, ll_rowcount, ll_row1, i, ll_lineNo, ll_findrow, ll_ownerId, ll_rc, j
Decimal ld_Qty

Datastore ldsDM , ldsDD

ldsDM = create u_ds_datastore
ldsDM.dataobject='d_do_master'
ldsDM.settransobject( SQLCA)

ldsDD = create u_ds_datastore
ldsDD.dataobject='d_do_detail'
ldsDD.settransobject( SQLCA)

ll_rowcount = this.rowcount( ) //DW rowcount

For ll_row =3 to ll_rowcount
	
	ls_WhName = this.getitemstring( ll_row, 'col2')   //Warehouse

	choose case upper(ls_WhName)
		case 'EDGEWOOD'
			ls_whcode ='NYCSP-EDGE'
		case 'MONROE'
			ls_whcode ='NYCSP-MONR'
		//dts - 07/28/2021 - S59828 - Add Dayton warehouse to case statement.
		case 'DAYTON'
			ls_whcode='NYCSC-DAYT'
	end choose

	ls_dono = of_get_sequenceNo() //get DoNo

	i =ldsDM.insertrow( 0)
	ldsDM.setitem(i, 'Do_No', ls_dono)
	ldsDM.setitem(i, 'Project_Id', gs_project)
	ldsDM.setitem(i, 'Ord_Type', 'S')
	ldsDM.setitem(i, 'Ord_Status', 'N')
	ldsDM.setitem(i, "Ord_Date", f_GetLocalWorldTime(ls_whcode))
	ldsDM.setitem(i, 'Create_User', 'SIMSFP')
	ldsDM.setitem(i, 'Inventory_Type', 'N')
	
	ldsDM.setitem(i, 'wh_code', ls_whcode) //Warehouse
	ldsDM.setitem(i, 'Priority', Long(trim(this.getitemstring( ll_row, 'col8')))) //Zone 2 Sequence
	ldsDM.setitem(i, 'Invoice_No', trim(this.getitemstring( ll_row, 'col9'))) //Build Id
	ldsDM.setitem(i, 'Cust_Code', trim(this.getitemstring( ll_row, 'col9'))) //Build Id
	ldsDM.setitem(i, 'Cust_Name', trim(this.getitemstring( ll_row, 'col10'))) //Building Name
	ldsDM.setitem(i, 'Address_1', trim( this.getitemstring( ll_row, 'col11'))) //Address
	ldsDM.setitem(i, 'City', trim(this.getitemstring( ll_row, 'col12'))) //City
	ldsDM.setitem(i, 'District', trim(this.getitemstring( ll_row, 'col13'))) //Boro (District)
	ldsDM.setitem(i, 'State', trim(this.getitemstring( ll_row, 'col14'))) //State
	ldsDM.setitem(i, 'Zip', trim(this.getitemstring( ll_row, 'col15'))) //Zip

	ldsDM.setitem(i, 'User_Field4', trim(this.getitemstring( ll_row, 'col30'))) //Team Priority
	ldsDM.setitem(i, 'User_Field5', trim(this.getitemstring( ll_row, 'col31'))) //Required Staff
	ldsDM.setitem(i, 'User_Field6', trim(this.getitemstring( ll_row, 'col32'))) //Max Shifts
	ldsDM.setitem(i, 'User_Field7', trim(this.getitemstring( ll_row, 'col33'))) //Total Staff Required
	ldsDM.setitem(i, 'User_Field8', trim(this.getitemstring( ll_row, 'col34'))) //Trailer Size
	ldsDM.setitem(i, 'User_Field9', trim(this.getitemstring( ll_row, 'col35'))) //Pallets per Trailer
	ldsDM.setitem(i, 'User_Field10', trim(this.getitemstring( ll_row, 'col36'))) //Dock Doors at Warehouse
	
	ll_lineNo =0 //Re-set Line No for every Order
	
	//SKU starts from 39th Position
	For ll_row1 = 39 to llvisiblecoulmncount
		ls_Sku = this.getitemstring(1,'col'+string(ll_row1))
		ld_Qty = Dec(this.getitemstring(ll_row, 'col'+string(ll_row1)))
		
		//Qty should be greater than 0 to add for DD
		If not isnull(ld_Qty) and (ld_Qty) > 0 Then
			
			ls_find = "Sku ='"+ls_Sku+"'"
			ll_findrow = idsIM.find( ls_find, 1, idsIM.rowcount())
			
			ll_lineNo++
			j =ldsDD.insertrow( 0)
			ldsDD.setitem(j, 'Do_No', ls_dono)
			ldsDD.setitem(j, 'Sku', ls_Sku)
			ldsDD.setitem(j, 'Alternate_SKU', ls_Sku)
			ldsDD.setitem(j, 'Supp_Code', idsIM.getitemstring(ll_findrow, 'Supp_Code'))
			ldsDD.setitem(j, 'Owner_Id', idsIM.getitemnumber( ll_findrow, 'Owner_Id'))
			ldsDD.setitem(j, 'Req_Qty', ld_qty)
			ldsDD.setitem(j, 'Line_Item_No', ll_lineNo)
			
		End if
	Next
	
Next

//storing into DB
Execute Immediate "Begin Transaction" using SQLCA;

If ldsDM.rowcount( ) > 0 Then
	ll_rc = ldsDM.update( false, false)
End IF

If ll_rc =1 Then ll_rc = ldsDD.update( false, false)

If ll_rc =1 Then
	Execute Immediate "COMMIT" using SQLCA;
	
	if sqlca.sqlcode = 0 then
		ldsDM.resetupdate( )
		ldsDD.resetupdate( )
		w_import.st_validation.text = " Records are Saved!"
	else
		Execute Immediate "ROLLBACK" using SQLCA;
		ldsDM.reset( )
		ldsDD.reset()
	     MessageBox("ERROR", SQLCA.SQLErrText)
		Return -1
	end if
	
else
	Execute Immediate "ROLLBACK" using SQLCA;
	w_import.st_validation.text = "Save failed!"
	MessageBox("ERROR", "System error, record save failed!")
	Return -1
End If

destroy ldsDM
destroy ldsDD
destroy idsIM

return 0
end function

public function string of_get_sequenceno ();//24-Apr-2017 :Madhu PEVS-567- KNY– Custom Wave Plan input sheet

long ll_no
String ls_order

//Assign order no. for new order
ll_no = g.of_next_db_seq(gs_project,'Delivery_Master','DO_No')

If ll_no <= 0 Then
	messagebox("Delivery Order","Unable to retrieve the next available order Number!")
End If

//Only take first 9 char of Project ID
ls_order = Trim(Left(gs_project,9)) + String(ll_no,"0000000")

return ls_order
end function

public function string wf_validate (long al_row);//24-Apr-2017 :Madhu PEVS-567- KNY– Custom Wave Plan input sheet
//Validate required columns.
String lsSku, lsSql, lsError, lsSkuRec, ls_whname
long llcol, llret
boolean lbFail =FALSE



//sku is available on 1st row
If al_row = 1 Then

	//Validate SKU and starts from 39th Position
	For llcol= 39 to llvisiblecoulmncount
		lsSku = trim(this.getitemString( 1, "col"+string(llcol)))
		
		//02-AUG-2018 :Madhu DE5562 - validate SKU
		If IsNull(lsSku) OR lsSku='' OR lsSku=' ' Then
			lbFail =TRUE
			this.setfocus( )
			this.setcolumn("col"+string(llcol))
			return " SKU should not be empty at col "+string(llcol)
		End If
		
		//validate SKU
		llret =i_nwarehouse.of_item_sku( gs_project, lsSku)
		
		If llret < 0 Then
			lbFail =TRUE
			this.setfocus( )
			this.setcolumn("col"+string(llcol))
			return lsSKU+" is not a valid SKU."
	
		else
			lsSkuRec += "'"+lsSku+"' ,"
		End If
		
	Next
	
	lsSkuRec = left(lsSkuRec, len(lsSkuRec) -1) //Remove comma at end
	
	//If all sku's are valid
	IF lbFail =FALSE Then 
		//create a datastore to store all Item Master records.
		lsSql =" select SKU, Supp_code, Owner_Id "
		lsSql += " From Item_Master with(nolock) "
		lsSql += " Where Project_Id='"+gs_project+"' and SKU IN (" + lsSkuRec +")"
		
		idsIM.create(SQLCA.SyntaxFromSQL(lsSql, "",lsError))
		idsIM.settransobject(SQLCA)
		idsIM.retrieve()
		
		w_import.cb_save.Enabled = TRUE
	End IF
 
else
	
	ls_whname = this.getitemstring( al_row, 'col2')
	
	If isnull(ls_whname) or ls_whname ='' or ls_whname=' ' or len(ls_whname) =0 Then
			w_import.cb_save.Enabled = FALSE
			this.setfocus( )
			this.setcolumn("col2")
			return "GXO WAREHOUSE should not be Empty. Or please delete Empty rows!"
	End If

End IF

//Return value
Return ''
end function

on u_dw_import_wave_plan.create
call super::create
end on

on u_dw_import_wave_plan.destroy
call super::destroy
end on

event ue_pre_import;call super::ue_pre_import;//24-Apr-2017 :Madhu PEVS-567- KNY– Custom Wave Plan input sheet
//Allow to Import TXT /CSV File

String lscomma =","
String lsTab ="~t"
String lsdelimiter = lscomma //set default to comma
String lsFileRead

long i, llFileNo, llFileRead, llFileLength,  llColumnCount, llCommaPos, llTabPos, llCount, llPos
long llcol, llrow

//Open File
llFileNo =FileOpen(isFilePath, LineMode!, Read!)

//Read File
llFileRead =FileReadEx(llFileNo, lsFileRead) //1st row

//initialize attribute values
llCount =0
llCommaPos=0
llTabPos=0

//Find appropriate Delimiter
llCommaPos = Pos(lsFileRead, lscomma, 1 )
llTabPos = Pos(lsFileRead, lsTab, 1 )

If llCommaPos > 0 Then
	lsdelimiter = lscomma
elseIf llTabPos > 0 Then
	lsdelimiter = lsTab
else
	MessageBox('ERROR', 'Unable to determine delimiter. ~r~n' &
		+ 'Please confirm that the file uses either the comma or tab characters as column markers' )
End IF

llFileLength = len(lsFileRead) //Length of record

//Loop through FileRecord to get column count
DO UNTIL ( i >= llFileLength)

	// get the columns
	llPos = Pos(lsFileRead, lsdelimiter, i)
	llCount++ // increment column counter
	
	if llPos > 0 then
		i = llPos + 1
	elseif llPos = 0 and i = 0 then
		i++
		llCount --
	else
		i = llFileLength
	end if
	
LOOP

//close file
FileClose(llFileNo)

//Get DW column count
llColumnCount =  long (this.Object.datawindow.column.count)

//Make Non-visible data window columns, if DW column count is greater than import file column count
If llColumnCount > llCount Then
	
	For llcol = llCount+1 to  llColumnCount 
		this.modify( "col"+string(llcol)+".visible =false")
	Next
	
End IF

//Import File
this.importfile( isFilePath)

IF isvalid(w_import) Then
	w_import.cb_validate.Enabled = TRUE
	w_import.cb_delete.Enabled = TRUE
	w_import.cb_ok.Enabled = TRUE
End IF

llvisiblecoulmncount = llCount

this.accepttext( )
end event

event constructor;call super::constructor;//24-Apr-2017 :Madhu PEVS-567- KNY– Custom Wave Plan input sheet
i_nwarehouse = create n_warehouse
idsIM = create Datastore
end event

