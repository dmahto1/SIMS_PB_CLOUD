$PBExportHeader$w_select_customer.srw
$PBExportComments$Select Customer
forward
global type w_select_customer from w_response_ancestor
end type
type dw_select from u_dw_ancestor within w_select_customer
end type
type cb_search from commandbutton within w_select_customer
end type
type sle_cust_name from singlelineedit within w_select_customer
end type
type st_1 from statictext within w_select_customer
end type
type st_2 from statictext within w_select_customer
end type
end forward

global type w_select_customer from w_response_ancestor
integer width = 2290
integer height = 1244
string title = "Select Customer"
dw_select dw_select
cb_search cb_search
sle_cust_name sle_cust_name
st_1 st_1
st_2 st_2
end type
global w_select_customer w_select_customer

type variables
string	isOrigSQL

boolean w_b3rdParty //hdc 10/30/2012  controls whether 3rd party or regular customer select is performed

string	is_Ignore_Wh_Code
end variables

forward prototypes
public function integer uf_configure_4thirdparty (boolean bthirdparty)
end prototypes

public function integer uf_configure_4thirdparty (boolean bthirdparty);//hdc 10/31/2012 Initial deposition- function to change the SQL allowing this window to select from all customers or only 3rd party for trax

w_b3rdParty = bThirdParty

return 0
end function

on w_select_customer.create
int iCurrent
call super::create
this.dw_select=create dw_select
this.cb_search=create cb_search
this.sle_cust_name=create sle_cust_name
this.st_1=create st_1
this.st_2=create st_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_select
this.Control[iCurrent+2]=this.cb_search
this.Control[iCurrent+3]=this.sle_cust_name
this.Control[iCurrent+4]=this.st_1
this.Control[iCurrent+5]=this.st_2
end on

on w_select_customer.destroy
call super::destroy
destroy(this.dw_select)
destroy(this.cb_search)
destroy(this.sle_cust_name)
destroy(this.st_1)
destroy(this.st_2)
end on

event ue_postopen;
isOrigSql = dw_select.GetSqlSelect()

sle_cust_name.Setfocus()
end event

event closequery;
//If Not Cancelled then return Selected Customer Code (if Any) to calling program
// 05/13 - PCONKL - For Batch PIcking, we will be returning 1 or more rows

long	llPos, llRowPos, llRowCount

If Not Istrparms.Cancelled Then 
	
	//If isvalid(w_batch_pick) or (isvalid(w_starbucks-th_dn) and not isvalid(w_do))  Then
	If not isvalid(w_do)   Then
		
		llpos = 0
		llRowCount = dw_Select.RowCount()
		
		For llRowPos = 1 to llRowCOunt
			
			if dw_select.GetITemString(llRowpos,'c_select_ind') = 'Y' Then
				llPos ++
				Istrparms.String_arg[llPos] = dw_select.getItemString(llRowPos,"cust_code")
			End If
				
		NExt
		
	Else
		
		If dw_select.GetRow() > 0 Then
			Istrparms.String_arg[1] = dw_select.getItemString(dw_select.GetRow(),"cust_code")
		Else
			Istrparms.String_arg[1] =''
		End If
		
	End If
	
End If /*not cancelled*/

Message.PowerObjectParm = Istrparms
end event

event open;call super::open;String sTemp

IF gs_Project = "PANDORA" AND trim(message.StringParm) <> "" THEN
	is_Ignore_Wh_Code = message.StringParm
	dw_select.dataobject = "d_select_customer"
END IF

//hdc 10/30/2012 even though in the "normal" case there is nothing passed this is still valid; toggles whether this window selects 3rd party or does a regular customer lookup
if Message.StringParm = "3P" then 
	this.uf_configure_4thirdparty(true)
end if

// 05/13 - PCONKL - For Batch PIcking, we will allow multiple customers to be selected by checkbox
//if  isvalid(w_batch_pick) or isvalid(w_starbucks-th_dn) Then
if  not isvalid(w_do) Then
	st_2.Text = 'Select one or more customers and click OK'
Else
	dw_select.modify("c_select_ind.width=0")
End IF
end event

type cb_cancel from w_response_ancestor`cb_cancel within w_select_customer
integer x = 965
integer y = 1020
integer taborder = 40
end type

type cb_ok from w_response_ancestor`cb_ok within w_select_customer
integer y = 1020
boolean default = false
end type

type dw_select from u_dw_ancestor within w_select_customer
integer x = 41
integer y = 116
integer width = 2190
integer height = 824
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_select_customer"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event ue_retrieve;String	lsWhere,	lsNewSQL, lsOrdType

//Always tackon Project ID to Sql
LsWhere = " Where Project_id = '" + gs_project + "'"

//If name is Present, tackon

If sle_cust_name.Text > '' Then
	lswhere += " and cust_name like '" + sle_cust_name.Text + "%' "
End If


lsNewSql = isOrigSQL + lsWhere 
if w_b3rdParty = true then //hdc 10/31/2012  Now there's a 3rd party flag; only select 3P if set; filter otherwise as the user would see duplicates
	lsNewSql += " and customer_type = '3P' "
else
	lsNewSql += " and customer_type <> '3P' "	
end if
This.SetSqlSelect(lsNewSql)

This.Retrieve()

If This.RowCount() <= 0 Then
	MessageBox("Select Customer","No Customer records found matching your criteria!")
End If

sle_cust_name.SetFocus()
	sle_cust_name.SelectText(1,Len(sle_cust_name.Text))
end event

event clicked;call super::clicked;//If row is clicked then highlight the row
IF row > 0 THEN
	This.SelectRow(0, FALSE)
	This.SelectRow(row, TRUE)
	cb_ok.Default=true
	cb_search.Default=false
	//this.SetITem(row,'c_select_ind','Y') /* 05/13 - PCONKL*/
End If
end event

event doubleclicked;// 05/13 - PCONKL - disable double click select/close for Batch Pick to allow multiple records to be selected
If Row > 0 and not isvalid(w_batch_pick)Then
	Close(Parent)
End If
end event

type cb_search from commandbutton within w_select_customer
integer x = 1335
integer y = 1020
integer width = 270
integer height = 108
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Search"
boolean default = true
end type

event clicked;
dw_select.TriggerEvent("ue_retrieve")


end event

type sle_cust_name from singlelineedit within w_select_customer
integer x = 485
integer y = 16
integer width = 818
integer height = 76
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within w_select_customer
integer x = 41
integer y = 24
integer width = 439
integer height = 76
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Customer Name:"
boolean focusrectangle = false
end type

type st_2 from statictext within w_select_customer
integer x = 41
integer y = 940
integer width = 1646
integer height = 76
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
boolean enabled = false
string text = "Double click on a Customer to select or highlight and click ~'OK~'"
boolean focusrectangle = false
end type

