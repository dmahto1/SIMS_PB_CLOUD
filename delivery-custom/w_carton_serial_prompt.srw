HA$PBExportHeader$w_carton_serial_prompt.srw
$PBExportComments$Carton Serial number prompt for Sku and Serial/Mac ID
forward
global type w_carton_serial_prompt from w_response_ancestor
end type
type dw_prompt from datawindow within w_carton_serial_prompt
end type
type st_sku from statictext within w_carton_serial_prompt
end type
type st_serial from statictext within w_carton_serial_prompt
end type
end forward

global type w_carton_serial_prompt from w_response_ancestor
integer width = 1166
integer height = 608
string title = ""
dw_prompt dw_prompt
st_sku st_sku
st_serial st_serial
end type
global w_carton_serial_prompt w_carton_serial_prompt

forward prototypes
public function integer wf_validation ()
end prototypes

public function integer wf_validation ();Long	llCount
String	lsMACID, lsSerial

dw_prompt.AcceptText()

Choose Case Upper(gs_Project)
		
	Case 'LINKSYS'
		
		//SKU must be present
		If isNull(dw_prompt.getitemString(1,'SKU')) or dw_prompt.getitemString(1,'SKU') = '' Then
			Messagebox('','Please enter a value for SKU')
			dw_prompt.Setfocus()
			dw_prompt.SetColumn('SKU')
			Return -1
		End IF
		
		//MAc ID must be present, start with '00' and be 12 digits
		If isNull(dw_prompt.getitemString(1,'MAC_ID')) or dw_prompt.getitemString(1,'MAC_ID') = '' Then
			Messagebox('','Please enter a value for MAC ID')
			dw_prompt.Setfocus()
			dw_prompt.SetColumn('MAC_ID')
			Return -1
		End IF
		
		If Len(dw_prompt.getitemString(1,'MAC_ID')) <> 12 Then
			Messagebox('','MAC ID must be 12 digits!')
			dw_prompt.Setfocus()
			dw_prompt.SetColumn('MAC_ID')
			Return -1
		End If
				
		//Serial Number must be present and be 12 characters and not begin with 00
		If isNull(dw_prompt.getitemString(1,'Serial_No')) or dw_prompt.getitemString(1,'Serial_No') = '' Then
			Messagebox('','Please enter a value for Serial Number')
			dw_prompt.Setfocus()
			dw_prompt.SetColumn('Serial_No')
			Return -1
		End IF
		
		If Len(dw_prompt.getitemString(1,'Serial_No')) <> 12 Then
			Messagebox('','Serial Number must be 12 digits!')
			dw_prompt.Setfocus()
			dw_prompt.SetColumn('Serial_No')
			Return -1
		End If
		
		//Make sure this MAC ID hasn't been previously scanned  - must get from DB
		//We can assume that since this is a manually entered record, it shouldn't exist on the file at all
		//If it does exist and it equals the Serial Number currently being scanned, it is OK.
		
		lsMACID = dw_prompt.getitemString(1,'MAC_ID')
		lsSerial = ''
		
		Select serial_no into :lsSerial
		from Carton_serial
		Where project_id = :gs_project and Mac_ID = :lsMACID;
		
		If lsSerial > '' and lsSerial <> dw_prompt.getitemString(1,'Serial_No') Then
			Messagebox('','This MAC ID has already been scanned for another Serial Number!',StopSign!)
			dw_prompt.Setfocus()
			dw_prompt.SetColumn('MAC_ID')
			Return -1
		End If
		
End Choose

Return 0
end function

on w_carton_serial_prompt.create
int iCurrent
call super::create
this.dw_prompt=create dw_prompt
this.st_sku=create st_sku
this.st_serial=create st_serial
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_prompt
this.Control[iCurrent+2]=this.st_sku
this.Control[iCurrent+3]=this.st_serial
end on

on w_carton_serial_prompt.destroy
call super::destroy
destroy(this.dw_prompt)
destroy(this.st_sku)
destroy(this.st_serial)
end on

event open;call super::open;
IstrParms = Message.PowerObjectParm
end event

event ue_postopen;call super::ue_postopen;

dw_prompt.InsertRow(0)

//Set text and properties based on parms.
If istrparms.String_arg[1] > '' Then
	dw_Prompt.SetItem(1,'SKU',istrparms.String_arg[1])
	dw_Prompt.Modify("Sku.border=2 ")
Else
	st_Sku.text="ENTER SKU "
	dw_Prompt.Modify("Sku.Background.Color='16777215'")
End If

If istrparms.String_arg[2] > '' Then /*Serial number present*/
	dw_prompt.SetITem(1,'Serial_No',istrparms.String_arg[2])
//	st_Serial.text="And Enter MAC ID"
	dw_Prompt.Modify("serial_no.border=2  mac_id.Background.Color='16777215'")
End If

If istrparms.String_arg[3] > '' Then /*MAC ID present*/
	dw_prompt.SetITem(1,'mac_id',istrparms.String_arg[3])
	dw_Prompt.Modify("mac_id.border=2 serial_no.Background.Color='16777215'")
End If

//set cursor to appropriate field
dw_Prompt.SetFocus()
If istrparms.String_arg[1] = '' Then
	dw_prompt.SetColumn("SKU")
ElseIf istrparms.String_arg[2] = '' Then
	dw_prompt.SetColumn("serial_no")
Else
	dw_prompt.SetColumn("mac_id")
End If
end event

event closequery;call super::closequery;
If istrparms.Cancelled Then Return 0

If wf_validation() < 0 Then
	REturn 1
End If

dw_prompt.AcceptText()

Istrparms.String_arg[1] = dw_prompt.GetITemString(1,'SKU')
Istrparms.String_arg[2] = dw_prompt.GetITemString(1,'Serial_No')
Istrparms.String_arg[3] = dw_prompt.GetITemString(1,'Mac_ID')
Istrparms.Cancelled = False

Return 0
end event

event close;call super::close;
Message.PowerObjectParm = Istrparms
end event

type cb_cancel from w_response_ancestor`cb_cancel within w_carton_serial_prompt
integer x = 622
integer y = 428
integer width = 233
integer height = 76
integer textsize = -8
end type

type cb_ok from w_response_ancestor`cb_ok within w_carton_serial_prompt
integer x = 256
integer y = 428
integer height = 76
integer textsize = -8
boolean default = false
end type

type dw_prompt from datawindow within w_carton_serial_prompt
event process_enter pbm_dwnprocessenter
integer x = 32
integer y = 144
integer width = 1070
integer height = 260
integer taborder = 10
boolean bringtotop = true
string title = "none"
string dataobject = "d_carton_serial_prompt"
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event process_enter;
IF This.GetColumnName() = "mac_id" THEN
	If This.GetITemString(1,'Serial_no') > '' Then
		parent.TriggerEvent("ue_close")
	Else
		Send(Handle(This),256,9,Long(0,0))
		Return 1
	End If
ElseIF This.GetColumnName() = "serial_no" THEN
	If This.GetITemString(1,'Mac_ID') > '' Then
		parent.TriggerEvent("ue_close")
	Else
		Send(Handle(This),256,9,Long(0,0))
		Return 1
	End If
Else
	Send(Handle(This),256,9,Long(0,0))
	Return 1
End If
end event

type st_sku from statictext within w_carton_serial_prompt
integer x = 32
integer y = 4
integer width = 1070
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = "VERIFY SKU"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_serial from statictext within w_carton_serial_prompt
integer x = 32
integer y = 60
integer width = 1070
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = "Enter/Verify MAC ID and Serial Number"
alignment alignment = center!
boolean focusrectangle = false
end type

