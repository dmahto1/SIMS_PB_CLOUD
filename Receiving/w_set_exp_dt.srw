HA$PBExportHeader$w_set_exp_dt.srw
$PBExportComments$Set Expiration Dates
forward
global type w_set_exp_dt from w_response_ancestor
end type
type dw_1 from u_dw_ancestor within w_set_exp_dt
end type
end forward

global type w_set_exp_dt from w_response_ancestor
integer width = 2066
integer height = 1272
string title = "Set Expiration Dates"
dw_1 dw_1
end type
global w_set_exp_dt w_set_exp_dt

on w_set_exp_dt.create
int iCurrent
call super::create
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
end on

on w_set_exp_dt.destroy
call super::destroy
destroy(this.dw_1)
end on

event ue_postopen;call super::ue_postopen;Long	llFindRow, llShelf
String	lsLabel, lsType

Istrparms = Message.PowerObjectParm

dw_1.InsertRow(0)
dw_1.SetItem(1,'SKU',Istrparms.String_arg[1])
dw_1.SetITem(1,'supp_code',Istrparms.String_arg[2])

//set the default Type and shelf life (if type B) - Get from Item Master
Select Shelf_life, expiration_tracking_Type 
Into	:llShelf, :lsType
From ITem_MAster
Where Project_id = :gs_Project and sku = :Istrparms.String_arg[1] and supp_code = :Istrparms.String_arg[2];

If isNull(lsType) or (lsType <> 'A' and lsType <> 'B') Then lsType = 'C'
If isNull(llShelf) Then llShelf = 0

dw_1.SetITem(1,'exp_type',lsType) 
dw_1.SetITem(1,'shelf_life',llShelf)

//Load the Custom labels for the Lot, PO, PO2 checkbox text

//Lot
If Istrparms.String_arg[3] = 'Y' Then /* Then Lot Trackable*/
	llFindROw = g.ids_Columnlabel.Find("Upper(table_Name)='INBOUND-PUTAWAY' and Upper(column_name) = 'LOT_NO'",1,g.ids_Columnlabel.RowCOunt())
	If llFindRow > 0 Then
		lslabel = g.ids_Columnlabel.getItemString(llFindRow,'column_label')
		dw_1.Modify("set_all_lot_ind.checkbox.Text='" + lsLabel + "'")
	End If
Else /* Not lot trackable, make invisible*/
	dw_1.modify("set_all_lot_ind.visible=False")
End If

//PO
If Istrparms.String_arg[4] = 'Y' Then /* Then PO Trackable*/
	llFindROw = g.ids_Columnlabel.Find("Upper(table_Name)='INBOUND-PUTAWAY' and Upper(column_name) = 'PO_NO'",1,g.ids_Columnlabel.RowCOunt())
	If llFindRow > 0 Then
		lslabel = g.ids_Columnlabel.getItemString(llFindRow,'column_label')
		dw_1.Modify("set_all_po_ind.checkbox.Text='" + lsLabel + "'")
	End If
Else /* Not PO trackable, make invisible*/
	dw_1.modify("set_all_po_ind.visible=False")
End If

//PO2
If Istrparms.String_arg[5] = 'Y' Then /* Then PO2 Trackable*/
	llFindROw = g.ids_Columnlabel.Find("Upper(table_Name)='INBOUND-PUTAWAY' and Upper(column_name) = 'PO_NO2'",1,g.ids_Columnlabel.RowCOunt())
	If llFindRow > 0 Then
		lslabel = g.ids_Columnlabel.getItemString(llFindRow,'column_label')
		dw_1.Modify("set_all_po2_ind.checkbox.Text='" + lsLabel + "'")
	End If
Else /* Not PO2 trackable, make invisible*/
	dw_1.modify("set_all_po2_ind.visible=False")
End If

//If we already have an expiration date entered, set the 'other date' and default to other on the RB
If String(istrparms.Date_arg[1],'MM/DD/YYYY') <> '12/31/2999' Then
	dw_1.SetItem(1,'other_date',istrparms.Date_Arg[1])
	dw_1.SetITem(1,'exp_type','C')
End If

dw_1.SetITem(1,'set_all_line_ind','Y')
end event

event closequery;call super::closequery;Boolean	lbError
dw_1.AcceptText()

If Not Istrparms.Cancelled Then

	Choose Case dw_1.GetITemString(1,'exp_type')
		
		Case 'A' /*vendor Exp Date*/
			
			If Not isnull(dw_1.GetITemDate(1,'vendor_exp_date')) Then
				istrparms.Date_arg[1] = dw_1.GetITemDate(1,'vendor_exp_date')
			Else
				MessageBox("Exp Date",'Vendor Exp Date is required')
				lbError = True
			End If
			
		Case 'B' /* Man Dt + shelf life */
			
			If dw_1.GetITemNumber(1,'shelf_Life') > 0 and Not isnull(dw_1.GetITemDate(1,'man_date'))Then
				istrparms.Date_arg[1] = RelativeDate(dw_1.GetITemDate(1,'man_date'),dw_1.GetITemNumber(1,'shelf_Life'))
			Else
				MessageBox("Exp Date",'Manufacturing Date and Shelf Lfe are required')
				lbError = True
				//istrparms.Date_arg[1] = dw_1.GetITemDate(1,'man_date')
			End If
			
		Case 'C' /*other */
			
			If Not isnull(dw_1.GetITemDate(1,'other_date')) Then
				istrparms.Date_arg[1] = dw_1.GetITemDate(1,'other_date')
			Else
				MessageBox("Exp Date",'Other Date is required')
				lbError = True
			End If
		
	End Choose

	Istrparms.String_arg[1] = dw_1.GetITemString(1,'set_all_line_ind')
	Istrparms.String_arg[2] = dw_1.GetITemString(1,'set_all_lot_ind')
	Istrparms.String_arg[3] = dw_1.GetITemString(1,'set_all_po_ind')
	Istrparms.String_arg[4] = dw_1.GetITemString(1,'set_all_po2_ind')

End If /*Not Cancelled*/

Message.PowerObjectParm = Istrparms

If lbError Then 
	Return 1
Else
	Return 0
End IF
end event

type cb_cancel from w_response_ancestor`cb_cancel within w_set_exp_dt
integer x = 1056
integer y = 1056
end type

type cb_ok from w_response_ancestor`cb_ok within w_set_exp_dt
integer x = 622
integer y = 1056
end type

type dw_1 from u_dw_ancestor within w_set_exp_dt
integer x = 5
integer y = 36
integer width = 2011
integer height = 988
boolean bringtotop = true
string dataobject = "d_set_exp_date"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event itemchanged;call super::itemchanged;
If dwo.name = 'set_all_line_ind' Then
	This.SetITem(1,'set_all_lot_ind','N')
	This.SetITem(1,'set_all_po_ind','N')
	This.SetITem(1,'set_all_po2_ind','N')
End If
end event

