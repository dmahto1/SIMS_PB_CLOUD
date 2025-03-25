$PBExportHeader$w_select_sku_supplier.srw
$PBExportComments$- Select SKU Supplier Combination
forward
global type w_select_sku_supplier from w_response_ancestor
end type
type dw_select from u_dw_ancestor within w_select_sku_supplier
end type
type st_1 from statictext within w_select_sku_supplier
end type
end forward

global type w_select_sku_supplier from w_response_ancestor
int Width=1970
int Height=892
boolean TitleBar=true
string Title="Select SKU/Supplier"
dw_select dw_select
st_1 st_1
end type
global w_select_sku_supplier w_select_sku_supplier

on w_select_sku_supplier.create
int iCurrent
call super::create
this.dw_select=create dw_select
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_select
this.Control[iCurrent+2]=this.st_1
end on

on w_select_sku_supplier.destroy
call super::destroy
destroy(this.dw_select)
destroy(this.st_1)
end on

event open;call super::open;
Istrparms = message.PowerObjectparm
Istrparms.Cancelled = True
end event

event ue_postopen;String	lsSql,	&
			lsWhere

lsSql = dw_select.GetSQLSelect() /*get original SQL*/

lsWhere = " Where Project_id = '" + gs_project + "'" /*alwys include project*/

//We'll ether be retrieving by SKU or Alternate Sku depending on String_arg[1]
If istrparms.String_arg[1] = 'S' Then /*searching by SKU*/
	lsWhere += " and sku = '" + Istrparms.String_arg[2] + "'"
Elseif istrparms.String_arg[1] = 'A' Then /*searching by Alternate SKU*/
	lsWhere += " and alternate_sku = '" + Istrparms.String_arg[2] + "'"
End If

//Tackon Supplier if not searching for a specific supplier
If Istrparms.String_arg[3] <> '*' Then
	lsWhere += " and supp_code = '" + Istrparms.String_arg[3] + "'"
End If

lsSQL += lsWhere
dw_Select.SetSqlSelect(lssql)

dw_Select.Retrieve()
end event

event closequery;Long	llRow
str_parms	lstrparms

istrparms = lstrparms /*clear parm*/

//Return parameters from selected Row
llRow = dw_select.getSelectedRow(0)
If (Not Istrparms.Cancelled) and (llrow > 0) Then
	Istrparms.String_arg[1] = dw_select.GetItemString(llRow,"supp_code")
	Istrparms.String_arg[2] = dw_select.GetItemString(llRow,"sku")
	Istrparms.String_arg[3] = dw_select.GetItemString(llRow,"alternate_sku")
Else
	Istrparms.Cancelled = True
End If
	
message.PowerObjectParm = Istrparms
end event

type cb_cancel from w_response_ancestor`cb_cancel within w_select_sku_supplier
int X=1001
int Y=664
end type

type cb_ok from w_response_ancestor`cb_ok within w_select_sku_supplier
int X=553
int Y=664
boolean Enabled=false
end type

event cb_ok::clicked;//Ancestor being overridden

Istrparms.Cancelled = False
parent.TriggerEvent("ue_close")
end event

type dw_select from u_dw_ancestor within w_select_sku_supplier
int X=27
int Y=32
int Width=1920
int Height=520
boolean BringToTop=true
string DataObject="d_select_sku_supplier"
boolean HScrollBar=true
boolean VScrollBar=true
end type

event clicked;//If row is clicked then highlight the row
IF row > 0 THEN
	This.SelectRow(0, FALSE)
	This.SelectRow(row, TRUE)
	cb_ok.Enabled = True
Else
	cb_ok.Enabled = False
END IF
end event

event doubleclicked;
//If valid row clicked, close window, closequery will return parms for clicked row

If Row > 0 Then parent.TriggerEvent("ue_close")
end event

type st_1 from statictext within w_select_sku_supplier
int X=201
int Y=556
int Width=1499
int Height=76
boolean Enabled=false
boolean BringToTop=true
string Text="Double Click a Row or Select a Row and CLick 'OK'"
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=67108864
int TextSize=-10
int Weight=700
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

