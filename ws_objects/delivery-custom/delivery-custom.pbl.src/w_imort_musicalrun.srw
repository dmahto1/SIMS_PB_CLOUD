$PBExportHeader$w_imort_musicalrun.srw
$PBExportComments$Import musical run packing list info
forward
global type w_imort_musicalrun from w_response_ancestor
end type
type dw_import from datawindow within w_imort_musicalrun
end type
type cb_import from commandbutton within w_imort_musicalrun
end type
type cb_insert from commandbutton within w_imort_musicalrun
end type
type cb_3 from commandbutton within w_imort_musicalrun
end type
end forward

global type w_imort_musicalrun from w_response_ancestor
integer y = 360
integer width = 2253
integer height = 1446
string title = "Import Musical Run"
dw_import dw_import
cb_import cb_import
cb_insert cb_insert
cb_3 cb_3
end type
global w_imort_musicalrun w_imort_musicalrun

type variables
datastore		idsPick
end variables

forward prototypes
public function integer wf_validate ()
end prototypes

public function integer wf_validate ();
Long	llRowPos, llRowCount, llFindRow, llSeq, llPickPos, llPickCount, llNumCases, llCartonSeq
decimal	ldPickQty, ldPAckQty, ldLength, ldWidth, ldHeight, ldGrossWeight
String	lsSKU, lsCartonType, lsCartonTypeSave

dw_import.AcceptText()
dw_import.Sort()

//Only need to validate musical run configuration
If w_do.idw_Main.GetITemString(1,'ord_type') = 'S' Then Return 0

llRowCOunt = dw_import.RowCount()
For llRowPOs = 1 to llRowCount
	
	lsSKU = dw_Import.GetITemString(llRowPos,'SKU')
	lsCartonType = dw_Import.GetITemString(llRowPos,'Carton_type')
	llSeq = dw_import.GetITemNumber(llRowPos,'seq')
	ldGrossWeight =  dw_import.GetITemNumber(llRowPos,'gross_weight')
	llNumCases = dw_import.GetITemNumber(llRowPos,'num_cases')
	
	//SKU must be on Pick List
	If w_do.idw_Pick.Find("Upper(SKU) = '" + Upper(lsSKU) + "'",1,w_do.idw_Pick.RowCount()) < 1 Then
		Messagebox("Validation Error", "SKU: " + lsSKU + " Not found on Pick List.",Stopsign!)
		dw_import.SetFocus()
		dw_import.SetRow(llRowPos)
		dw_import.SetColumn('SKU')
		REturn - 1
	End If
	
	// Seq/SKU should not be repeated
	If llRowPos < llRowCount Then
		If dw_Import.Find("Seq = " + String(llSeq) + " and Upper(SKU) = '" + upper(lsSKU) + "'",llRowPos + 1,dw_import.RowCount()) > 0 Then
			Messagebox("Validation Error", "Duplicate Seq/SKU found: " + String(llSeq) + "/" + lsSKU,Stopsign!)
			dw_import.SetFocus()
			dw_import.SetRow(llRowPos)
			dw_import.SetColumn('SKU')
			REturn - 1
		End If
	End If
	
	//all records for a sequence must have the same value number of cases
	If llRowPos < llRowCount Then
		If dw_Import.Find("Seq = " + String(llSeq) + " and num_cases <> " + String(llNumCases),llRowPos + 1,dw_import.RowCount()) > 0 Then
			Messagebox("Validation Error", "All records for Seq " + string(llSeq) + " must have the same number of cases.",Stopsign!)
			dw_import.SetFocus()
			dw_import.SetRow(llRowPos)
			dw_import.SetColumn('num_cases')
			REturn - 1
		End If
	End If
	
	//all records for a sequence must have the same value for Gross Weight
	If llRowPos < llRowCount Then
		If dw_Import.Find("Seq = " + String(llSeq) + " and gross_weight <> " + String(ldGrossWeight),llRowPos + 1,dw_import.RowCount()) > 0 Then
			Messagebox("Validation Error", "All records for Seq " + string(llSeq) + " must have the same Gross Weight.",Stopsign!)
			dw_import.SetFocus()
			dw_import.SetRow(llRowPos)
			dw_import.SetColumn('num_cases')
			REturn - 1
		End If
	End If
	
	//all records for a sequence must have the same value for carton Type
	If llRowPos < llRowCount Then
		If dw_Import.Find("Seq = " + String(llSeq) + " and upper(carton_type) <> '" + upper(lsCartonType) + "'",llRowPos + 1,dw_import.RowCount()) > 0 Then
			Messagebox("Validation Error", "All records for Seq " + string(llSeq) + " must have the same Carton Type.",Stopsign!)
			dw_import.SetFocus()
			dw_import.SetRow(llRowPos)
			dw_import.SetColumn('carton_type')
			REturn - 1
		End If
	End If
	
	//If Carton Type is Present, make sure it is valid
	if lsCartonType > ''  Then
		
		If lsCartonType <> lsCartonTypeSave Then
			
			ldLength = 0
			ldWidth = 0
			ldHeight = 0
			llCartonSeq = 0
			
			Select Seq_no, length, width, height into
					:llCartonSeq, :ldLength,:ldWidth,:ldHeight
			From Carton_Master
			Where Project_id = "*All" or Project_id = :gs_project and carton_type = :lsCartonType
			Using SQLCA;
			
			If isNull(llCartonSeq) or llCartonSeq = 0 Then
				
				Messagebox("Validation Error", "Invalid Carton Type",Stopsign!)
				dw_import.SetFocus()
				dw_import.SetRow(llRowPos)
				dw_import.SetColumn('carton_type')
				
				REturn - 1
				
			End If
			
			lsCartonTypeSave = lsCartonType
			
		End If
				
		dw_Import.SetITem(llRowPos,'Length',ldLength)
		dw_Import.SetITem(llRowPos,'Width',ldWidth)
		dw_Import.SetITem(llRowPos,'Height',ldHeight)
		
	End If
	
Next

//make sure picked qty = pack config qty
llPickCount = idsPick.RowCount()
For llPIckPos = 1 to llPickCount
	
	ldPackQty = 0
	
	lsSKU = idsPick.GetITemString(llPickPos,'SKU')
	ldPickQty = idsPick.GetITemNumber(llPickPos,'alloc_qty')
	
	llFindRow = dw_Import.Find("Upper(SKU) = '" + Upper(lsSKU) + "'",1,dw_import.RowCOunt())
	
	Do While llFindRow > 0
		
		ldPackQty += (dw_import.getITemNumber(llFindRow,'num_cases') * dw_import.getITemNumber(llFindRow,'qty_per_case'))
		
		llFindRow ++
		If llFindRow > dw_import.RowCount() Then
			llFindRow = 0
		Else
			llFindRow = dw_Import.Find("Upper(SKU) = '" + Upper(lsSKU) + "'",llFindRow,dw_import.RowCOunt())
		End If
		
	Loop
	
	If ldPAckQty <> ldPickQty Then
		Messagebox("Validation Error", "SKU: " + lsSKU + " Picked Qty (" + String(ldPickQty) + ") <> Pack Config Qty (" + string(ldPAckQty) + ")",Stopsign!)
		Return -1
	End If
	
Next 

Return 0
end function

on w_imort_musicalrun.create
int iCurrent
call super::create
this.dw_import=create dw_import
this.cb_import=create cb_import
this.cb_insert=create cb_insert
this.cb_3=create cb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_import
this.Control[iCurrent+2]=this.cb_import
this.Control[iCurrent+3]=this.cb_insert
this.Control[iCurrent+4]=this.cb_3
end on

on w_imort_musicalrun.destroy
call super::destroy
destroy(this.dw_import)
destroy(this.cb_import)
destroy(this.cb_insert)
destroy(this.cb_3)
end on

event ue_postopen;call super::ue_postopen;String	sql_syntax, ERRORS, lsDONO

lsDONO = w_do.idw_Main.GetITemString(1,'do_no')

//Retrieve the current picked quantities

idsPick = Create Datastore
sql_syntax = "SELECT SKU, sum(quantity) as alloc_qty from delivery_Picking" 
sql_syntax += " Where do_no = '" + lsdono + "' group by SKU"
idsPick.Create(SQLCA.SyntaxFromSQL(sql_syntax,"", ERRORS))

idsPick.SetTransObject(SQLCA)
idsPick.Retrieve()
end event

event closequery;call super::closequery;


str_parms	lstrparms
long	llRowCOunt, llRowPos
DataStore	ldsImport

// If cancelled, get out
If istrparms.Cancelled Then
	lstrparms.Cancelled = True
	message.PowerobjectParm = lstrparms
	Return 0
End If

If wf_Validate() < 0 Then
	dw_import.GroupCalc()
	REturn 1
End If

ldsImport= Create Datastore
ldsImport.dataobject = 'd_generate_musical_run'
dw_import.RowsCopy(1,dw_import.rowcount(),Primary!,ldsImport,1,Primary!)

lstrparms.dataStore_arg[1] = ldsImport

Message.PowerObjectParm = lstrparms


end event

event open;call super::open;
If w_do.idw_Main.GEtITEmString(1,'ord_type') = 'S' Then
	This.Title = 'Import Packing List'
End If
end event

type cb_cancel from w_response_ancestor`cb_cancel within w_imort_musicalrun
integer x = 1748
integer y = 1194
end type

type cb_ok from w_response_ancestor`cb_ok within w_imort_musicalrun
integer x = 1393
integer y = 1194
boolean default = false
end type

event cb_ok::clicked;call super::clicked;//
//
//
//str_parms	lstrparms
//long	llRowCOunt, llRowPos
//
//If wf_Validate() < 0 Then
//	REturn
//End If
//
//llRowCount = dw_import.RowCount()
//For llRowPos = 1 to llRowCOunt
//	
//	lstrParms.Integer_arg[llRowPos] = dw_import.GetItemNumber(llRowPos,'seq')
//	lstrParms.String_arg[llRowPos] = dw_import.GetItemString(llRowPos,'SKU')
//	lstrParms.Long_arg[llRowPos] = dw_import.GetItemNumber(llRowPos,'num_cases')
//	lstrParms.Decimal_arg[llRowPos] = dw_import.GetItemNumber(llRowPos,'qty_per_Case')
//	
//Next
//
//Message.PowerObjectParm = lstrparms
//
//parent.TriggerEvent("ue_close")
end event

type dw_import from datawindow within w_imort_musicalrun
event process_enter pbm_dwnprocessenter
integer x = 18
integer y = 16
integer width = 2205
integer height = 1117
integer taborder = 10
boolean bringtotop = true
string title = "none"
string dataobject = "d_generate_musical_run"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event process_enter;IF This.GetColumnName() = "qty_per_case" THEN
	IF This.GetRow() = This.RowCount() THEN
		cb_insert.TriggerEvent('clicked')
	END IF
Else
	Send(Handle(This),256,9,Long(0,0))
End If
end event

event constructor;//If not musical run, hide a couple of non relevent fields
If w_do.idw_Main.GetITemString(1,'ord_type') = 'S' Then
	this.modify("seq.visible = 0 num_cases.visible = 0")
End If
end event

type cb_import from commandbutton within w_imort_musicalrun
integer x = 750
integer y = 1194
integer width = 373
integer height = 109
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Import..."
end type

event clicked;
String	lsFile, lsPath
Int	liRC

liRC = getFileOpenName("Select FIle to Import",lsPath, lsFile,"TXT","Text Files (*.*),*.*,")
If liRC <>1 Then Return

dw_import.Reset()
dw_import.ImportFile(lsFile)
end event

type cb_insert from commandbutton within w_imort_musicalrun
integer x = 22
integer y = 1197
integer width = 304
integer height = 106
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Insert"
end type

event clicked;
dw_import.InsertRow(0)
dw_import.SetFocus()
dw_import.scrolltoRow(dw_Import.RowCount())
Dw_import.SetRow(dw_Import.rowCount())
dw_import.SetColumn('seq')

end event

type cb_3 from commandbutton within w_imort_musicalrun
integer x = 351
integer y = 1197
integer width = 304
integer height = 106
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Delete"
end type

event clicked;
dw_import.DeleteRow(dw_import.GetRow())
end event

