HA$PBExportHeader$w_mim_proj_code_label.srw
$PBExportComments$- Process ASN by Order
forward
global type w_mim_proj_code_label from w_main_ancestor
end type
type cb_label_print from commandbutton within w_mim_proj_code_label
end type
type dw_label from u_dw_ancestor within w_mim_proj_code_label
end type
type cb_label_selectall from commandbutton within w_mim_proj_code_label
end type
type cb_label_clear from commandbutton within w_mim_proj_code_label
end type
end forward

global type w_mim_proj_code_label from w_main_ancestor
integer width = 5262
integer height = 1788
string title = "MIM Project Code Labels"
event ue_print ( )
cb_label_print cb_label_print
dw_label dw_label
cb_label_selectall cb_label_selectall
cb_label_clear cb_label_clear
end type
global w_mim_proj_code_label w_mim_proj_code_label

type variables
n_warehouse i_nwarehouse
n_labels	invo_labels

String	isUCCSCompanyPrefix, isUCCSWHPrefix

String	isDONO

String	isRONO

inet	linit   //26-Sep-2014 :Madhu- KLN B2B SPS Conversion
u_nvo_websphere_post	iuoWebsphere  //26-Sep-2014 :Madhu- KLN B2B SPS Conversion

end variables

event ue_print();Str_Parms	lstrparms
n_labels	lu_labels
string ls_uf5, ls_uf6, ls_PartInfo, lsTemp ,ls_ordtype

Long	llQty, llRowCount, llRowPos, ll_rtn, llPrintJob, llFindRow, llPrintPos, llPrintCount, ld_Qunatity , ld_Carton,llCar_no
		
Any	lsAny

String	lsformat, lsFormatSave, lsPrinter, lsLabel, lsLabelPrint, lsPrintText,  &
			lsCurrentLabel, lsLabelType, lsDateCode, lsKlone_sku_desc_color ,lsCountryName ,ls_city ,ls_dc_prefix
Integer	liMsg
datastore dw_labels

lu_labels = Create n_labels

Dw_Label.AcceptText()

llRowCount = dw_label.RowCount()


OpenWithParm(w_label_print_options,lStrParms)
Lstrparms = Message.PowerObjectParm		  
If lstrParms.Cancelled Then
	Return
End If
			
//Open Printer File 
llPrintJob = PrintOpen(lsPrintText)

If llPrintJob <0 Then 
	Messagebox('Labels', 'Unable to open Printer file. Labels will not be printed')
	Return
End If


For llRowPos = 1 to llRowCount /*each detail row */
			
	If dw_label.GetITEmString(llRowPos,'c_print_ind') <> 'Y' Then Continue

		lsformat = "Pandora_MIM_Project_Label.txt"
		
		lsLabel = lu_labels.uf_read_label_Format(lsFormat)
		
		If lsLabel = "" Then Return
		
		lsCurrentLabel= lsLabel
		
		lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~Project_Code~~", dw_label.GetITemString(llRowPos,'Po_No') ) 
		
		lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~Project_Code_Bc~~", dw_label.GetITemString(llRowPos,'Po_No') )
		lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~GPN~~", dw_label.GetITemString(llRowPos,'Sku') )
	
	integer liPos	
		
	llPrintCount = dw_label.GetITemNUmber(llRowPos,'c_qty_per_carton')	
		
	liPos = Pos(lsCurrentLabel, "^PQ", 1)
	
	if liPos > 0 then
		
		lsCurrentLabel = left(lsCurrentLabel,(liPos + 2)) + string(llPrintCount) + mid(lsCurrentLabel,(liPos + 4))
		
	end if	
		
	
	lsLabelPrint = lsCurrentLabel

	PrintSend(llPrintJob, lsLabelPrint)	
			
Next /*detail row to Print*/

PrintClose(llPrintJob)


end event

on w_mim_proj_code_label.create
int iCurrent
call super::create
this.cb_label_print=create cb_label_print
this.dw_label=create dw_label
this.cb_label_selectall=create cb_label_selectall
this.cb_label_clear=create cb_label_clear
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_label_print
this.Control[iCurrent+2]=this.dw_label
this.Control[iCurrent+3]=this.cb_label_selectall
this.Control[iCurrent+4]=this.cb_label_clear
end on

on w_mim_proj_code_label.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_label_print)
destroy(this.dw_label)
destroy(this.cb_label_selectall)
destroy(this.cb_label_clear)
end on

event ue_postopen;call super::ue_postopen;

invo_labels = Create n_labels
i_nwarehouse = Create n_warehouse

cb_label_print.Enabled = False

//We can only print based on DO_NO - User must have valid order open to pass DO_NO in from w_DO
If isVAlid(w_ro ) Then
	if w_ro.idw_main.RowCOunt() > 0 Then
		isRoNo = w_Ro.idw_main.GetITemString(1,'ro_no')
	End If
End If

If isNUll(isRONO) or  isRoNO = '' Then
	Messagebox('Labels','You must have an order retrieved in the Receive Order Window~rbefore you can print labels!')
Else
	This.TriggerEvent('ue_retrieve')
End If



end event

event ue_retrieve;call super::ue_retrieve;String	lsRONO,	&
			lsCartonNo

Long		llRowCount,	&
			llRowPos


cb_label_print.Enabled = False

If isrono > '' Then
	dw_label.Retrieve(gs_project,isrono)
End If

If dw_label.RowCOunt() > 0 Then
Else
	Messagebox('Labels','Order Not found!')
	Return
End If

lsRoNo = dw_label.GetITemString(1,'RO_NO')

//Default the Label Format and Starting Carton Number
llRowCount = dw_label.RowCount()


//cb_print.Enabled = True

// 12/03 - PCONKL - WE need the Project level UCCS Company prefix and the Warehouse level prefix
//Select ucc_Company_Prefix into :isuccscompanyprefix
//FRom Project
//Where Project_ID = :gs_Project;
//
//SElect ucc_location_Prefix into :isuccswhprefix
//From Warehouse
//Where wh_Code = (select wh_Code from Delivery_MASter where Project_ID = :gs_Project and do_no = :isrono);
//
//
end event

event ue_selectall;call super::ue_selectall;Long	llRowPos,	&
		llRowCount

		
dw_label.SetRedraw(False)

llRowCount = dw_label.RowCount()
For llRowPos = 1 to llRowCount
	dw_label.SetITem(llRowPos,'c_print_ind','Y')
Next

dw_label.SetRedraw(True)

cb_label_print.Enabled = True

end event

event ue_unselectall;call super::ue_unselectall;Long	llRowPos,	&
		llRowCount

		
dw_label.SetRedraw(False)

llRowCount = dw_label.RowCount()
For llRowPos = 1 to llRowCount
	dw_label.SetITem(llRowPos,'c_print_ind','N')
Next

dw_label.SetRedraw(True)

cb_label_print.Enabled = False

end event

event resize;call super::resize;dw_label.Resize(workspacewidth() - 50,workspaceHeight()-150)
end event

event close;call super::close;IF ISVALID(i_nwarehouse) THEN Destroy(i_nwarehouse)
end event

type cb_cancel from w_main_ancestor`cb_cancel within w_mim_proj_code_label
boolean visible = false
integer x = 1938
integer y = 1392
integer height = 80
end type

type cb_ok from w_main_ancestor`cb_ok within w_mim_proj_code_label
integer x = 1769
integer y = 24
integer height = 80
boolean default = false
end type

event cb_ok::constructor;call super::constructor;
g.of_check_label_button(this)
end event

type cb_label_print from commandbutton within w_mim_proj_code_label
integer x = 946
integer y = 24
integer width = 329
integer height = 80
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Print"
end type

event clicked;Parent.TriggerEvent('ue_Print')
end event

event constructor;
g.of_check_label_button(this)
end event

type dw_label from u_dw_ancestor within w_mim_proj_code_label
integer x = 9
integer y = 136
integer width = 5138
integer height = 1456
boolean bringtotop = true
string dataobject = "d_mim_proj_code_label_select"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event retrieveend;call super::retrieveend;//As this is compute column needs to be assigned value 
// DGM 09/22/03
integer i
FOR i = 1 TO rowcount
 This.object.c_qty_per_carton[i]=1
NEXT


end event

event itemchanged;call super::itemchanged;
If upper(dwo.Name) = 'C_PRINT_IND' and data = 'Y' Then cb_label_print.Enabled = True
end event

type cb_label_selectall from commandbutton within w_mim_proj_code_label
integer x = 32
integer y = 24
integer width = 338
integer height = 80
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Select All"
end type

event clicked;Parent.Event ue_selectall()

end event

event constructor;
g.of_check_label_button(this)
end event

type cb_label_clear from commandbutton within w_mim_proj_code_label
integer x = 393
integer y = 24
integer width = 338
integer height = 80
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Clear All"
end type

event clicked;Parent.Event ue_unselectall()
end event

event constructor;
g.of_check_label_button(this)
end event

