HA$PBExportHeader$w_comcast_rekit_label.srw
$PBExportComments$BCR 04-MAY-11: Comcast Rekit Label window
forward
global type w_comcast_rekit_label from w_main_ancestor
end type
type cb_print from commandbutton within w_comcast_rekit_label
end type
type dw_label from u_dw_ancestor within w_comcast_rekit_label
end type
end forward

global type w_comcast_rekit_label from w_main_ancestor
boolean visible = false
integer width = 2642
integer height = 852
string title = "Comcast Rekit Label"
string menuname = ""
event ue_print ( )
cb_print cb_print
dw_label dw_label
end type
global w_comcast_rekit_label w_comcast_rekit_label

type variables
n_warehouse i_nwarehouse
n_labels	invo_labels
	
String	isLabels[], isOEMLabel, isPrintText, isShipFormat

Boolean ibPrinterSelected=FALSE

end variables

forward prototypes
public function integer uf_shipping_label (integer airow, string asformat)
public function integer wf_validate ()
end prototypes

event ue_print();Str_Parms	lstrparms
n_labels	lu_labels
Long	llRowCount, llRowPos, 	llPrintJob,  llLabelPos, llBeginRow, llEndRow
String	lsPrintText, lsShipFormat, lsSKUFormat, lsCarton, lsCartonSave, lsOEMFormat, lsCustomer, lsNullLabel[]


//Call AcceptText
Dw_Label.AcceptText()

////Validate any required fields before printing ..... No longer necessary to do now that we are not even using the Print button
//If wf_validate() < 0 Then Return

//Has Printer been selected?
IF NOT ibPrinterSelected THEN

	//Open printer options window
	OpenWithParm(w_label_print_options,iStrParms)
	istrparms = Message.PowerObjectParm		  
	If istrParms.Cancelled Then
		Return
	End If
	
	//Set printer selection boolean
	ibPrinterSelected = TRUE

END IF

//Open Printer File 
llPrintJob = PrintOpen(isPrintText)
	
If llPrintJob <0 Then 
	Messagebox('Labels', 'Unable to open Printer file. Labels will not be printed')
	Return
End If

//Shipping label for displayed data
uf_shipping_label(1, isShipFormat) 

//Do the print
PrintSend(llPrintJob, isLabels[1])

//Close printer
PrintClose(llPrintJob)

//After print, clear out serial no and unit id
dw_label.SetRedraw(False)
dw_label.SetItem(1,"serial_no",'')
dw_label.SetItem(1,"unit_id",'')
dw_label.SetRedraw(True)

//Make Serial Number ready for more entries
dw_label.SetColumn("serial_no")

end event

public function integer uf_shipping_label (integer airow, string asformat);String	lsWarehouse, lsFormat, lsAddr, lsCityState, lsShipDate, lsUCCPRefix, lsUCCCarton, lsCarrier, lsCarrierName
Long		lLWarehouseRow, llAddressPos, llLabelPos
Integer	liCheck
lsFormat = asFormat


//Model
lsFormat = invo_labels.uf_replace(lsFormat,"~~model~~",String(dw_label.getITemString(1,'model')))

//Serial No and Bar Code
lsFormat = invo_labels.uf_replace(lsFormat,"~~serial_no~~",String(dw_label.getITemString(1,'serial_no')))
lsFormat = invo_labels.uf_replace(lsFormat,"~~serial_no_bc~~",String(dw_label.getITemString(1,'serial_no')))

//Unit ID & Bar Code
lsFormat = invo_labels.uf_replace(lsFormat,"~~unit_id~~",String(dw_label.getITemString(1,'unit_id')))
lsFormat = invo_labels.uf_replace(lsFormat,"~~unit_id_bc~~",String(dw_label.getITemString(1,'unit_id')))

//Condition
lsFormat = invo_labels.uf_replace(lsFormat,"~~condition~~",String(dw_label.getITemString(1,'condition')))

//Swedish characters need to be 'cleansed'
lsFormat = f_cleanse_printer(lsFormat)

isLabels[1] = lsFormat

Return 0
end function

public function integer wf_validate ();String ls_SerialNo, ls_UnitId, ls_UnitId2


//Accept Text to start
dw_label.AcceptText()

//Populate variables
ls_SerialNo  = dw_label.GetItemString(1, "serial_no")
ls_UnitId      = dw_label.GetItemString(1, "unit_id")

IF IsNull(ls_SerialNo) OR ls_SerialNo = "" THEN
	//Remove any previously entered unit id
	ls_UnitId = ""
	// Not ready to print
	Messagebox('Labels','Serial Number must be entered before printing.')
	Return -1
ELSE
	//Populate unit id2 with value from file if serial no is already on file
	SELECT Max(user_field1)
	INTO :ls_UnitId2
	FROM carton_serial
	WHERE project_id = 'Comcast'
	and serial_no = :ls_SerialNo;
	
	IF IsNull(ls_UnitId2) OR ls_UnitId2 ="" THEN
		//Do Nothing
	ELSE
		
		//Replace entered unit id with value from file
		ls_UnitId = ls_UnitId2
		
		//Reset displayed unit id value on dw
		dw_label.SetItem(1,"unit_id", ls_UnitId2)
		
		//Call AcceptText again...in this case  
		dw_label.AcceptText()

	END IF
END IF
		
IF  IsNull(ls_UnitId) OR ls_UnitId = "" THEN
	// Not ready to print
	Messagebox('Labels','Unit ID must be entered before printing.')
	Return -1
END IF

REturn 0
end function

on w_comcast_rekit_label.create
int iCurrent
call super::create
this.cb_print=create cb_print
this.dw_label=create dw_label
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_print
this.Control[iCurrent+2]=this.dw_label
end on

on w_comcast_rekit_label.destroy
call super::destroy
destroy(this.cb_print)
destroy(this.dw_label)
end on

event resize;call super::resize;dw_label.Resize(workspacewidth() - 50,workspaceHeight()-250)
end event

event close;call super::close;IF ISVALID(i_nwarehouse) THEN Destroy(i_nwarehouse)
IF ISVALID(n_labels) THEN Destroy(n_labels)
end event

event open;call super::open;invo_labels = Create n_labels


//Set print text
isPrintText = 'Comcast Rekit Labels '

//Retrieive necessary formats
isShipFormat = invo_labels.uf_read_label_Format("Comcast_Rekit_Label.txt")
end event

type cb_cancel from w_main_ancestor`cb_cancel within w_comcast_rekit_label
boolean visible = false
integer x = 942
integer y = 1596
integer width = 274
integer height = 80
integer taborder = 0
boolean enabled = false
string text = "&Close"
end type

type cb_ok from w_main_ancestor`cb_ok within w_comcast_rekit_label
boolean visible = false
integer x = 2272
integer y = 52
integer height = 80
integer taborder = 0
integer textsize = -9
boolean enabled = false
boolean default = false
end type

type cb_print from commandbutton within w_comcast_rekit_label
boolean visible = false
integer x = 78
integer y = 52
integer width = 329
integer height = 80
integer taborder = 20
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "&Print"
end type

event clicked;Parent.TriggerEvent('ue_Print')



end event

type dw_label from u_dw_ancestor within w_comcast_rekit_label
integer x = 9
integer y = 208
integer width = 2574
integer height = 216
boolean bringtotop = true
string dataobject = "d_comcast_rekit_label_grid"
boolean livescroll = false
end type

event itemerror;call super::itemerror;return 1
end event

event clicked;call super::clicked;String ls_Model, ls_Condition, ls_SerialNo, ls_UnitId


THIS.AcceptText()

//Get values of model and condition
ls_Model = THIS.GetItemString(1, "model")
ls_Condition = THIS.GetItemString(1, "condition")
ls_SerialNo = THIS.GetItemString(1, "serial_no")

//Protect Serial Number and unit ID if BOTH Model and Condition are not yet entered 
IF (IsNull(ls_Model) OR ls_Model = '') OR (IsNull(ls_Condition) OR ls_Condition = '') THEN
	THIS.Object.serial_no.Protect = 1
	THIS.Object.unit_id.Protect = 1
ELSE
	THIS.Object.serial_no.Protect = 0
	THIS.Object.unit_id.Protect = 0
END IF
		
//Unit Id cannot be valid until Serial number has been entered
IF IsNull(ls_SerialNo) OR ls_SerialNo ="" THEN
	//Remove any previously entered unit id
	THIS.SetItem(1,"unit_id", "")
ELSE
	
	//Populate unit id if serial no is already on file
	SELECT Max(user_field1)
	INTO :ls_UnitId
	FROM carton_serial
	WHERE project_id = 'Comcast'
	and serial_no = :ls_SerialNo;
	
	IF IsNull(ls_UnitId) OR ls_UnitId ="" THEN
		//No Unit ID associated with this Serial Number in table. Get Unit ID from datawindow...if already populated
		ls_UnitId = THIS.GetItemString(1, "unit_id")
	ELSE
		//Set Unit ID to value in table
		THIS.SetItem(1,"unit_id", ls_UnitId)

	END IF
	
	//Invoke Print Routine at this point...only if unit id is populated
	IF IsNull(ls_UnitId) OR ls_UnitId = "" THEN
		//Do nothing
	ELSE
		Parent.TriggerEvent('ue_Print')
	END IF
	
END IF
				



end event

event constructor;call super::constructor;DataWindowChild ldwc_condition
String ls_new, ls_used, ls_ColName,ls_DisplayCol,ls_DataCol 


//Insert Row into dw
dw_label.InsertRow(0)

//Create wh nvo
i_nwarehouse = Create n_warehouse

i_nwarehouse.of_init_inv_ddw(dw_label,TRUE) 
dw_label.GetChild('condition',ldwc_condition)
ldwc_condition.SetTransObject(SQLCA)

//Retrieve dddw
ldwc_condition.Retrieve(gs_project)

//SetFilter
ldwc_condition.SetFilter("inv_type_desc= 'Normal' OR inv_type_desc= 'USED'")

//Filter
ldwc_condition.Filter() 

//After filter, change Normal to NEW as per spec...
ldwc_condition.SetItem(1,"inv_type_desc","NEW")

end event

event itemfocuschanged;call super::itemfocuschanged;String ls_Model, ls_Condition, ls_SerialNo, ls_UnitId

THIS.AcceptText()

//Get values of model and condition
ls_Model = THIS.GetItemString(1, "model")
ls_Condition = THIS.GetItemString(1, "condition")
ls_SerialNo = THIS.GetItemString(1, "serial_no")

//Unprotect to start with
THIS.Object.serial_no.Protect = 0
THIS.Object.unit_id.Protect = 0

Choose Case Upper(dwo.name)
				
	Case 'SERIAL_NO' , 'UNIT_ID'
		
		//Make serial no and unit id protected until both model and condition have been entered
		IF (IsNull(ls_Model) OR ls_Model = '') OR (IsNull(ls_Condition) OR ls_Condition = '') THEN
			THIS.Object.serial_no.Protect = 1
			THIS.Object.unit_id.Protect = 1
		END IF
		
		IF IsNull(ls_SerialNo) OR ls_SerialNo ="" THEN
			//Remove any previously entered unit id
			THIS.SetItem(1,"unit_id", "")
		ELSE
			
			//Populate unit id if serial no is already on file
			SELECT Max(user_field1)
			INTO :ls_UnitId
			FROM carton_serial
			WHERE project_id = 'Comcast'
			and serial_no = :ls_SerialNo;
			
			IF IsNull(ls_UnitId) OR ls_UnitId ="" THEN
				//Do Nothing
			ELSE
				THIS.SetRedraw(False)
				THIS.SetItem(1,"unit_id", ls_UnitId)
				THIS.SetRedraw(True)
			END IF
			
			//Invoke Print Routine at this point...only if unit id is populated
			IF IsNull(ls_UnitId) OR ls_UnitId = "" THEN
				//Do Nothing
			ELSE
				Parent.TriggerEvent('ue_Print')
			END IF
			
		END IF
		
	CASE ELSE
		IF IsNull(ls_SerialNo) OR ls_SerialNo ="" THEN
			//Remove any previously entered unit id
			THIS.SetItem(1,"unit_id", "")
		ELSE
			
			//Populate unit id if serial no is already on file
			SELECT Max(user_field1)
			INTO :ls_UnitId
			FROM carton_serial
			WHERE project_id = 'Comcast'
			and serial_no = :ls_SerialNo;
			
			IF IsNull(ls_UnitId) OR ls_UnitId ="" THEN
				//No Unit ID associated with this Serial Number in table. Get Unit ID from datawindow...if already populated
				ls_UnitId = THIS.GetItemString(1, "unit_id")
			ELSE
				THIS.SetRedraw(False)
				THIS.SetItem(1,"unit_id", ls_UnitId)
				THIS.SetRedraw(True)
			END IF
			
			//Invoke Print Routine at this point...only if unit id is populated
			IF IsNull(ls_UnitId) OR ls_UnitId = "" THEN
				//Do Nothing
			ELSE
				Parent.TriggerEvent('ue_Print')
			END IF
			
		END IF
		
End Choose


end event

event process_enter;call super::process_enter;Send(Handle(This),256,9,Long(0,0))
Return 1
end event

