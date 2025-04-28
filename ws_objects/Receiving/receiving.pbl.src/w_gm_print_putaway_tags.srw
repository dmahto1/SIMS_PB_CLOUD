$PBExportHeader$w_gm_print_putaway_tags.srw
$PBExportComments$Print GM Putaway Tags
forward
global type w_gm_print_putaway_tags from w_main_ancestor
end type
type cb_print from commandbutton within w_gm_print_putaway_tags
end type
type dw_tags from u_dw_ancestor within w_gm_print_putaway_tags
end type
type cb_selectall from commandbutton within w_gm_print_putaway_tags
end type
type cb_clear from commandbutton within w_gm_print_putaway_tags
end type
end forward

global type w_gm_print_putaway_tags from w_main_ancestor
integer width = 3177
integer height = 1648
string title = "Putaway Tags"
string menuname = ""
event ue_print ( )
cb_print cb_print
dw_tags dw_tags
cb_selectall cb_selectall
cb_clear cb_clear
end type
global w_gm_print_putaway_tags w_gm_print_putaway_tags

type variables
n_warehouse i_nwarehouse
n_labels	invo_labels
n_3com_labels	invo_3com_labels

String	isOrigSql


end variables

forward prototypes
public function string wf_format_group (string asgroup)
end prototypes

event ue_print();
Long	llRowPos, llRowCount, llNewRow, llPrintPos
Datastore	ldsPrint

ldsPrint = Create Datastore
ldsPRint.Dataobject = 'd_gm_dat_putaway_tags'


SetPointer(Hourglass!)

//For each Selected Row, copy to tags DW and print

llRowCount = dw_tags.RowCount()
For llRowPOs = 1 to llRowCount
	
	//Skip if not selected to print or no qty
	If dw_tags.GetITemstring(llRowPos,'c_print_ind') <> 'Y' or dw_tags.GetITemNumber(llRowPos,'c_print_qty') < 1 Then Continue
		
	//insert a row for each qty of tag to print..
	For llPrintPos = 1 to dw_tags.GetITemNumber(llRowPos,'c_print_qty')
		
		llNewRow = ldsPrint.InsertRow(0)
		ldsPrint.SetITem(llNewRow,'sku',dw_tags.GetITemstring(llRowPos,'sku'))
		ldsPrint.SetITem(llNewRow,'acd_part',dw_tags.GetITemstring(llRowPos,'acd_part'))
		ldsPrint.SetITem(llNewRow,'l_code',dw_tags.GetITemstring(llRowPos,'location'))
		ldsPrint.SetITem(llNewRow,'coo',dw_tags.GetITemstring(llRowPos,'coo'))
		ldsPrint.SetITem(llNewRow,'package_spec',dw_tags.GetITemstring(llRowPos,'package_Spec'))
		ldsPrint.SetITem(llNewRow,'label',dw_tags.GetITemstring(llRowPos,'label'))
		ldsPrint.SetITem(llNewRow,'contract',dw_tags.GetITemstring(llRowPos,'contract'))
		
		ldsPrint.SetITem(llNewRow,'qty',dw_tags.GetITemNumber(llRowPos,'qty'))
		ldsPrint.SetITem(llNewRow,'Merch_qty',dw_tags.GetITemNumber(llRowPos,'merch_qty'))
			
	Next
	
Next /*bom row */


ldsPrint.Sort()

SetPointer(Arrow!)

If ldsPrint.RowCount() > 0 Then
	Openwithparm(w_dw_print_options,ldsPrint) 
End IF


end event

public function string wf_format_group (string asgroup);
String	lsGroup

// "Three digit group numbers will have one leading zero (i.e. 0.659). All other Group numbers will have
//  No leading zeros (i.e.1.266, 10.373" From the GM standards manual

lsGroup = asGroup

//First, make sure there is a period - If not, there should be 3 digits after...
If POs(lsGroup,'.') = 0 Then
	lsGroup = Left(lsGroup,(len(lsGroup) - 3)) + "." + Right(lsGroup,3)
End IF

Choose Case Len(lsGroup) /*len includes period*/
		
	Case 4 /*needs a leading zero for 3 digit groups*/
		
		lsGroup = "0" + lsGroup
		
	Case 6 /*drop any leading zeros*/
		
		If left(lsGroup,1) = '0' Then lsGroup = Right(lsGroup,5)
				
End Choose

lsGroup = "GR. " + lsGroup

Return lsGroup
end function

on w_gm_print_putaway_tags.create
int iCurrent
call super::create
this.cb_print=create cb_print
this.dw_tags=create dw_tags
this.cb_selectall=create cb_selectall
this.cb_clear=create cb_clear
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_print
this.Control[iCurrent+2]=this.dw_tags
this.Control[iCurrent+3]=this.cb_selectall
this.Control[iCurrent+4]=this.cb_clear
end on

on w_gm_print_putaway_tags.destroy
call super::destroy
destroy(this.cb_print)
destroy(this.dw_tags)
destroy(this.cb_selectall)
destroy(this.cb_clear)
end on

event ue_postopen;call super::ue_postopen;
This.TriggerEvent('ue_retrieve')
end event

event ue_retrieve;call super::ue_retrieve;Long	llRowCount, llRowPos, llNewRow, llDetailFindRow, llBomFindRow, llMerchQty
String	lsSupplier, lsRONO, lsBOM, lsLabel, lsSKU, lsACDPart
Datastore	ldsBom

//We need the packaging specs - load once for whole order...
ldsBom = Create Datastore
ldsBom.Dataobject = 'd_gm_putaway_tag_bom'
ldsBom.SetTransObject(SQLCA)

lsSupplier = w_ro.idw_main.GetITemString(1,'supp_code')
lsRoNo = w_ro.idw_main.GetITemString(1,'ro_no')
ldsBom.Retrieve(gs_project, lsSUpplier, lsRONO)

dw_tags.SetRedraw(false)
setPointer(Hourglass!)

//Load from Receive Putaway..
llRowCount = w_ro.idw_putaway.RowCount()
For llRowPos = 1 to llRowCount
	
	llNewRow = dw_tags.InsertRow(0)
	
	lsSKU = w_ro.idw_putaway.GetITEmString(llRowPos,'sku')
		
	dw_tags.SetITem(llNewRow,'sku',w_ro.idw_putaway.GetITEmString(llRowPos,'sku'))
	dw_tags.SetITem(llNewRow,'supp_code',lsSupplier)
	dw_tags.SetITem(llNewRow,'location',w_ro.idw_putaway.GetITEmString(llRowPos,'l_code'))
	dw_tags.SetITem(llNewRow,'qty',w_ro.idw_putaway.GetITEmNumber(llRowPos,'quantity'))
	
	If w_ro.idw_putaway.GetITEmString(llRowPos,'country_of_Origin') <> 'XXX' Then
		dw_tags.SetITem(llNewRow,'coo',w_ro.idw_putaway.GetITEmString(llRowPos,'country_of_Origin'))
	End IF
		
	//From Detail...
	llDEtailFindRow = w_ro.idw_Detail.Find("Upper(sku) = '" + Upper(w_ro.idw_putaway.GetITEmString(llRowPos,'sku')) + "'",1,w_ro.idw_Detail.RowCount())
	If llDEtailFindRow > 0 Then
		
		dw_tags.SetITem(llNewRow,'contract',w_ro.idw_detail.GetITEmString(lLDetailFindRow,'User_Field3'))
		
	End If
	
	//We need the ACD Part NUmber (UF12) and Merch Qty (uom_2) from Item MAster
	Select User_Field12, qty_2 into :lsACDPart, :llMerchQty
	From Item_MASter
	Where project_id = :gs_project and sku = :lsSKU and Supp_Code = :lsSUpplier;
	
	dw_tags.SetITem(llNewRow,'acd_part',lsACDPart)
	dw_tags.SetITem(llNewRow,'merch_qty',llMerchQty)
	
	//Load packaging and label specs from BOM datasatore
	lsBOM = ""
	lsLabel = ""
	
	llBomFindRow = ldsBom.Find("Upper(sku_parent) = '" + Upper(w_ro.idw_putaway.GetITEmString(llRowPos,'sku')) + "'", 1, ldsBom.RowCount())
	Do While llBomFindRow > 0
	
		If ldsBom.GetITemString(llBomFindRow,'child_package_Type') = 'L' Then /*label*/
			lsLabel += ", " + ldsBom.GetITemString(llBomFindRow,'sku_child')
		Else
			lsBom += ", " + ldsBom.GetITemString(llBomFindRow,'sku_child') + "(" + ldsBom.GetITemString(llBomFindRow,'child_package_Type') + ")"
		End If
	
		llBomFindRow ++
		If llBomFindRow > ldsBom.RowCount() Then
			llBomFindRow = 0
		Else
			llBomFindRow = ldsBom.Find("Upper(sku_parent) = '" + Upper(w_ro.idw_putaway.GetITEmString(llRowPos,'sku')) + "'", llBomFindRow, ldsBom.RowCount())
		End If
		
	Loop
	
	If lsLAbel > "" Then lsLabel = Mid(lsLabel,3,999)
	If lsBOM > "" Then lsBOM = Mid(lsBOM,3,999)
	
	dw_tags.SetITem(llNewRow,'label',lsLabel)
	dw_tags.SetITem(llNewRow,'package_spec',lsBOM)
		
		
	dw_tags.SetITem(llNewRow,'c_print_qty',1)
	dw_tags.SetITem(llNewRow,'c_print_ind','Y')
	
	
Next /*Putaway Row*/

dw_tags.SetRedraw(True)
SetPointer(Arrow!)
end event

event ue_selectall;call super::ue_selectall;Long	llRowPos,	&
		llRowCount

		
dw_tags.SetRedraw(False)

llRowCount = dw_tags.RowCount()
For llRowPos = 1 to llRowCount
	dw_tags.SetITem(llRowPos,'c_print_ind','Y')
Next

dw_tags.SetRedraw(True)

cb_print.Enabled = True

end event

event ue_unselectall;call super::ue_unselectall;Long	llRowPos,	&
		llRowCount

		
dw_tags.SetRedraw(False)

llRowCount = dw_tags.RowCount()
For llRowPos = 1 to llRowCount
	dw_tags.SetITem(llRowPos,'c_print_ind','N')
Next

dw_tags.SetRedraw(True)

cb_print.Enabled = True

end event

event resize;call super::resize;dw_tags.Resize(workspacewidth() - 50,workspaceHeight()-150)
end event

event close;call super::close;IF ISVALID(i_nwarehouse) THEN Destroy(i_nwarehouse)
end event

type cb_cancel from w_main_ancestor`cb_cancel within w_gm_print_putaway_tags
boolean visible = false
integer x = 1938
integer y = 1392
integer height = 80
end type

type cb_ok from w_main_ancestor`cb_ok within w_gm_print_putaway_tags
integer x = 1499
integer y = 32
integer height = 80
integer textsize = -9
boolean default = false
end type

type cb_print from commandbutton within w_gm_print_putaway_tags
integer x = 777
integer y = 32
integer width = 329
integer height = 80
integer taborder = 30
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Print"
end type

event clicked;Parent.TriggerEvent('ue_Print')
end event

type dw_tags from u_dw_ancestor within w_gm_print_putaway_tags
integer x = 9
integer y = 140
integer width = 3099
integer height = 1296
boolean bringtotop = true
string dataobject = "d_gm_print_putaway_tags_select"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event itemchanged;call super::itemchanged;
Choose Case Upper(dwo.name)
		
	Case "COO"
		
		If data > "" Then
			
			If f_get_country_name(data) = "" Then
				Messagebox("", "Invalid Country of Origin")
				Return 1
			End If
			
		End If
		
End Choose
end event

event itemerror;call super::itemerror;return 1
end event

event process_enter;call super::process_enter;
Send(Handle(This),256,9,Long(0,0))
end event

type cb_selectall from commandbutton within w_gm_print_putaway_tags
integer x = 37
integer y = 32
integer width = 338
integer height = 80
integer taborder = 20
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Select All"
end type

event clicked;Parent.Event ue_selectall()

end event

type cb_clear from commandbutton within w_gm_print_putaway_tags
integer x = 393
integer y = 32
integer width = 338
integer height = 80
integer taborder = 30
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Clear All"
end type

event clicked;Parent.Event ue_unselectall()
end event

