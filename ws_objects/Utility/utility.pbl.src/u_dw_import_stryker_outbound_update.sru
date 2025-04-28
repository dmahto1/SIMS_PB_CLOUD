$PBExportHeader$u_dw_import_stryker_outbound_update.sru
$PBExportComments$-STRTKER Update Outbound Orders
forward
global type u_dw_import_stryker_outbound_update from u_dw_import
end type
end forward

global type u_dw_import_stryker_outbound_update from u_dw_import
integer width = 3817
string dataobject = "d_import_stryker_outbound_update"
end type
global u_dw_import_stryker_outbound_update u_dw_import_stryker_outbound_update

forward prototypes
public function string wf_validate (long al_row)
public function integer wf_save ()
end prototypes

public function string wf_validate (long al_row);//06-Dec-2013 :Madhu - Added code to validate Stryker Outbound Update Order

String lsOrder,lsShip_Ref,lsuser_field1,lsuser_field2,lsuser_field3,lsuser_field4,lsuser_field5
String lsuser_field6,lsuser_field7,lsuser_field8,lsuser_field9,lsuser_field10,lsuser_field11
String lsuser_field12,lsuser_field13,lsuser_field14,lsuser_field15,lsuser_field16,lsuser_field17
String lsuser_field19,lsuser_field20,lsuser_field21,lsuser_field22,lsFreight_Terms,lsFreight_Cost
String lsCarrier,lstransport_mode,lsFreight_etd,lsAwb


long		llCount
boolean ib_fail =false

//Validate for valid field length and type

// if Currvalcolumn > '' then we didn't validate the whole row, start with the next column
Choose Case isCurrValColumn
	Case "Order"
		goto lsOrder
	case "Ship_Ref"
		goto lsShip_Ref
	Case "user_field1"
		goto lsuser_field1
	case "user_field2"
		goto lsuser_field2
	case "user_field3"
		goto lsuser_field3
	Case "user_field4"
		goto lsuser_field4
	Case "user_field5"
		goto lsuser_field5
	Case "user_field6"
		goto lsuser_field6
	Case "user_field7"
		goto lsuser_field7
	Case "user_field8"
		goto lsuser_field8
	Case "user_field9"
		goto lsuser_field9
	Case "user_field10"
		goto lsuser_field10
	Case "user_field11"
		goto lsuser_field11
	Case "user_field12"
		goto lsuser_field12
	Case "user_field13"
		goto lsuser_field13
	Case "user_field14"
		goto lsuser_field14
	Case "user_field15"
		goto lsuser_field15
	Case "user_field16"
		goto lsuser_field16
	Case "user_field17"
		goto lsuser_field17
	Case "user_field19"
		goto lsuser_field19
	Case "user_field20"
		goto lsuser_field20
	Case "user_field21"
		goto lsuser_field21
	Case "user_field22"
		goto lsuser_field22
	Case "Freight_Terms"
		goto lsFreight_Terms
	Case "Freight_Cost"
		goto lsFreight_Cost
	Case "Carrier"
		goto lsCarrier
	Case "Transport_Mode"
		goto lstransport_mode
	Case "Freight_ETD"
		goto lsFreight_etd
	Case "Awb"
		goto lsAwb

		isCurrValColumn = ''
	return ''
End Choose

//Validate Order
lsOrder:

// We want to validate Order# if present. If null, don't validate
	lsOrder = This.getItemString(al_row,"order")
	
	If (Not isnull(lsOrder)) and lsOrder > ' ' Then

		Select Count(*)  into :llCount
		from Delivery_Master
		Where project_id = :gs_project and Invoice_No = :lsOrder
		Using SQLCA;

		If llCount <= 0 Then
			This.Setfocus()
			This.SetColumn("Order")
			iscurrvalcolumn = "Order"
			Return "Order No is not valid!"
		End If
		
		If len(trim(This.getItemString(al_row,"Order"))) > 20 Then
			This.Setfocus()
			This.SetColumn("Order")
			iscurrvalcolumn = "Order"
			Return "Order No is > 20 Characters"
		End If
	else
		return "'Order' can not be null!"		
	End If	
	
lsShip_Ref:
//Validate ShipRef
If len(trim(This.getItemString(al_row,"Ship_Ref"))) > 40 Then
	This.Setfocus()
	This.SetColumn("lsShip_Ref")
	iscurrvalcolumn = "lsShip_Ref"
	Return "Ship Ref is > 40 Characters"
End If
	
lsuser_field1:
//Validate UF1
If len(trim(This.getItemString(al_row,"user_field1"))) > 20 Then
	This.Setfocus()
	This.SetColumn("user_field1")
	iscurrvalcolumn = "user_field1"
	Return "User Field1 is > 20 Characters"
End If

lsuser_field2:
//Validate UF2
If  (This.GetItemString(al_row,"user_field2")) >'' Then
	If len(trim(This.getItemString(al_row,"user_field2"))) > 200 Then
		This.Setfocus()
		This.SetColumn("user_field2")
		iscurrvalcolumn = "user_field2"
		Return "User Field1 is > 200 Characters"
	End If
else
	This.SetFocus()
	This.SetRow(al_row)
	This.SetColumn('user_field2')
	return "User Field2 shouldnot be blank"
End if
	
lsuser_field3:
//Validate UF3
If len(trim(This.getItemString(al_row,"user_field3"))) > 20 Then
	This.Setfocus()
	This.SetColumn("user_field3")
	iscurrvalcolumn = "user_field3"
	Return "User Field1 is > 20 Characters"
End If

lsuser_field4:
//Validate UF4
If len(trim(This.getItemString(al_row,"user_field4"))) > 40 Then
	This.Setfocus()
	This.SetColumn("user_field4")
	iscurrvalcolumn = "user_field4"
	Return "User Field1 is > 40 Characters"
End If

lsuser_field5:
//Validate UF5
If len(trim(This.getItemString(al_row,"user_field5"))) > 200 Then
	This.Setfocus()
	This.SetColumn("user_field5")
	iscurrvalcolumn = "user_field5"
	Return "User Field5 is > 200 Characters"
End If

lsuser_field6:
//Validate UF6
If len(trim(This.getItemString(al_row,"user_field6"))) > 40 Then
	This.Setfocus()
	This.SetColumn("user_field6")
	iscurrvalcolumn = "user_field6"
	Return "User Field6 is > 40 Characters"
End If

lsuser_field7:
//Validate UF7
If len(trim(This.getItemString(al_row,"user_field7"))) > 60 Then
	This.Setfocus()
	This.SetColumn("user_field7")
	iscurrvalcolumn = "user_field7"
	Return "User Field7 is > 60 Characters"
End If

lsuser_field8:
//Validate UF8
If len(trim(This.getItemString(al_row,"user_field8"))) > 120 Then
	This.Setfocus()
	This.SetColumn("user_field8")
	iscurrvalcolumn = "user_field8"
	Return "User Field8 is > 120 Characters"
End If

lsuser_field9:
//Validate UF9
If len(trim(This.getItemString(al_row,"user_field9"))) > 100 Then
	This.Setfocus()
	This.SetColumn("user_field9")
	iscurrvalcolumn = "user_field9"
	Return "User Field9 is > 100 Characters"
End If

lsuser_field10:
//Validate UF10
If len(trim(This.getItemString(al_row,"user_field1"))) > 100 Then
	This.Setfocus()
	This.SetColumn("user_field10")
	iscurrvalcolumn = "user_field10"
	Return "User Field1 is > 100 Characters"
End If

lsuser_field11:
//Validate UF11
If len(trim(This.getItemString(al_row,"user_field11"))) > 100 Then
	This.Setfocus()
	This.SetColumn("user_field11")
	iscurrvalcolumn = "user_field11"
	Return "User Field1 is > 100 Characters"
End If

lsuser_field12:
//Validate UF12
If len(trim(This.getItemString(al_row,"user_field1"))) > 100 Then
	This.Setfocus()
	This.SetColumn("user_field12")
	iscurrvalcolumn = "user_field12"
	Return "User Field1 is > 100 Characters"
End If

lsuser_field13:
//Validate UF13
If len(trim(This.getItemString(al_row,"user_field1"))) > 100 Then
	This.Setfocus()
	This.SetColumn("user_field13")
	iscurrvalcolumn = "user_field13"
	Return "User Field13 is > 100 Characters"
End If

lsuser_field14:
//Validate UF14
If len(trim(This.getItemString(al_row,"user_field14"))) > 100 Then
	This.Setfocus()
	This.SetColumn("user_field14")
	iscurrvalcolumn = "user_field14"
	Return "User Field14 is > 100 Characters"
End If

lsuser_field15:
//Validate UF15
If len(trim(This.getItemString(al_row,"user_field15"))) > 100 Then
	This.Setfocus()
	This.SetColumn("user_field15")
	iscurrvalcolumn = "user_field15"
	Return "User Field15 is > 100 Characters"
End If

lsuser_field16:
//Validate UF1
If len(trim(This.getItemString(al_row,"user_field16"))) > 200 Then
	This.Setfocus()
	This.SetColumn("user_field16")
	iscurrvalcolumn = "user_field16"
	Return "User Field16 is > 200 Characters"
End If

lsuser_field17:
//Validate UF1
If len(trim(This.getItemString(al_row,"user_field17"))) > 200 Then
	This.Setfocus()
	This.SetColumn("user_field17")
	iscurrvalcolumn = "user_field17"
	Return "User Field17 is > 200 Characters"
End If

lsuser_field19:
//Validate UF19
If len(trim(This.getItemString(al_row,"user_field19"))) > 200 Then
	This.Setfocus()
	This.SetColumn("user_field19")
	iscurrvalcolumn = "user_field19"
	Return "User Field19 is > 200 Characters"
End If

lsuser_field20:
//Validate UF20
If len(trim(This.getItemString(al_row,"user_field20"))) > 200 Then
	This.Setfocus()
	This.SetColumn("user_field20")
	iscurrvalcolumn = "user_field20"
	Return "User Field20 is > 200 Characters"
End If

lsuser_field21:
//Validate UF21
If len(trim(This.getItemString(al_row,"user_field21"))) > 200 Then
	This.Setfocus()
	This.SetColumn("user_field21")
	iscurrvalcolumn = "user_field21"
	Return "User Field21 is > 200 Characters"
End If

lsuser_field22:
//Validate UF22
If len(trim(This.getItemString(al_row,"user_field22"))) > 200 Then
	This.Setfocus()
	This.SetColumn("user_field22")
	iscurrvalcolumn = "user_field22"
	Return "User Field22 is > 200 Characters"
End If

lsFreight_Terms:
//Validate Frieght Terms
If len(trim(This.getItemString(al_row,"Freight_Terms"))) > 40 Then
	This.Setfocus()
	This.SetColumn("Freight_Terms")
	iscurrvalcolumn = "Freight_Terms"
	Return "Freight Terms is > 40 Characters"
End If

lsFreight_Cost:
//Validate Freight_Cost
If len(trim(This.getItemString(al_row,"Freight_Cost"))) > 9 Then
	This.Setfocus()
	This.SetColumn("Freight_Cost")
	iscurrvalcolumn = "Freight_Cost"
	Return "Freight Cost is > 9 Characters"
End If

lsCarrier:
//Validate Carrier
If (This.getItemString(al_row,"Carrier")) > '' Then
	If len(trim(This.getItemString(al_row,"Carrier"))) > 40 Then
		This.Setfocus()
		This.SetColumn("Carrier")
		iscurrvalcolumn = "Carrier"
		Return "Carrier is > 40 Characters"
	End If
else
	This.SetFocus()
	This.SetRow(al_row)
	This.SetColumn('Carrier')
	return "Carrier shouldnot be blank"
End if

lstransport_mode:
//Validate transport_mode
	If len(trim(This.getItemString(al_row,"transport_mode"))) > 20 Then
		This.Setfocus()
		This.SetColumn("transport_mode")
		iscurrvalcolumn = "transport_mode"
		Return "transport_mode is > 20 Characters"
	End If

lsFreight_etd:
//Validate Freight_etd

If  (this.GetITemString(al_row, "Freight_ETD")) > '' Then
	If  not isdate(left(this.GetItemString( al_row, "Freight_ETD"), 2) + "/" +  mid(this.GetItemString( al_row, "Freight_ETD"),4, 2) + "/" + mid(this.GetItemString(al_row, "Freight_ETD"), 7,4) ) then
		ib_fail =true
		This.SetFocus()
		This.SetRow(al_row)
		This.SetColumn('Freight_etd')
		return "'Outbound Freight_ETD' must be a valid DateTime."
	End If
	
	If  not istime(mid(this.GetItemString(al_row, "Freight_ETD"), 11)) then
		ib_fail =true
		This.SetFocus()
		This.SetRow(al_row)
		This.SetColumn('Freight_etd')
		return "'Outbound Freight_ETD' must be a valid DateTime."
	End If

Else /* Not present*/
	This.SetFocus()
	This.SetRow(al_row)
	This.SetColumn('Freight_etd')
	return "'Outbound Freight_ETD' is Required."
End If

lsAwb:
//Validate Awb
If (This.getItemString(al_row,"Awb"))> '' Then
	If len(trim(This.getItemString(al_row,"Awb"))) > 30 Then
		This.Setfocus()
		This.SetColumn("Awb")
		iscurrvalcolumn = "Awb"
		Return "Awb is > 30 Characters"
	End If
else
	This.SetFocus()
	This.SetRow(al_row)
	This.SetColumn('Awb')
	return "Awb shouldnot be blank"
End if


iscurrvalcolumn = ''
return ''

end function

public function integer wf_save ();//06-Dec-2013 :Madhu - Added code to validate Stryker Outbound Update Order

String lsOrder,lsShip_Ref,lsuser_field1,lsuser_field2,lsuser_field3,lsuser_field4,lsuser_field5
String lsuser_field6,lsuser_field7,lsuser_field8,lsuser_field9,lsuser_field10,lsuser_field11
String lsuser_field12,lsuser_field13,lsuser_field14,lsuser_field15,lsuser_field16,lsuser_field17
String lsuser_field19,lsuser_field20,lsuser_field21,lsuser_field22,lsFreight_Terms
String lsCarrier,lstransport_mode,lsAwb,lsSQL,lsErrorText,lsFreight_etd,lsFind

long		llRowCount,llRowPos,llUpdate,llFreight_Cost,llFindRow,ll_duplicaterow

llUpdate =0
ll_duplicaterow=0

llRowCount =this.Rowcount()

Execute Immediate " Begin Transaction " using SQLCA;

For llRowPos =1 to llRowCount

w_main.SetmicroHelp("Saving Row " + string(llRowPos) + " of " + string(llRowCount))

	lsOrder = this.getItemString(llRowPos,"Order")
	lsShip_Ref = this.getItemString(llRowPos,"Ship_Ref")
	lsuser_field1 = this.getItemString(llRowPos,"user_field1")
	lsuser_field2 = this.getItemString(llRowPos,"user_field2")
	lsuser_field3 = this.getItemString(llRowPos,"user_field3")
	lsuser_field4 = this.getItemString(llRowPos,"user_field4")
	lsuser_field5 = this.getItemString(llRowPos,"user_field5")
	lsuser_field6 = this.getItemString(llRowPos,"user_field6")
	lsuser_field7 = this.getItemString(llRowPos,"user_field7")
	lsuser_field8 = this.getItemString(llRowPos,"user_field8")
	lsuser_field9 = this.getItemString(llRowPos,"user_field9")
	lsuser_field10 = this.getItemString(llRowPos,"user_field10")
	lsuser_field11 = this.getItemString(llRowPos,"user_field11")
	lsuser_field12 = this.getItemString(llRowPos,"user_field12")
	lsuser_field13 = this.getItemString(llRowPos,"user_field13")
	lsuser_field14 = this.getItemString(llRowPos,"user_field14")
	lsuser_field15 = this.getItemString(llRowPos,"user_field15")
	lsuser_field16 = this.getItemString(llRowPos,"user_field16")
	lsuser_field17 = this.getItemString(llRowPos,"user_field17")
	lsuser_field19 = this.getItemString(llRowPos,"user_field19")
	lsuser_field20 = this.getItemString(llRowPos,"user_field20")
	lsuser_field21 = this.getItemString(llRowPos,"user_field21")
	lsuser_field22 = this.getItemString(llRowPos,"user_field22")
	lsFreight_Terms = this.getItemString(llRowPos,"Freight_Terms")
	llFreight_Cost = Long(this.getItemString(llRowPos,"Freight_Cost"))
	lsCarrier = this.getItemString(llRowPos,"Carrier")
	lstransport_mode = this.getItemString(llRowPos,"transport_mode")
	//lsFreight_etd = String(this.GetITemDateTime(llRowPos, "Freight_ETD"))
	lsFreight_etd = this.GetITemString(llRowPos, "Freight_ETD")
	lsAwb = this.getItemString(llRowPos,"Awb")
	
	lsFind = "Order = '" + lsOrder + "'"
	llFindRow =  this.Find(lsFind,0,this.RowCount())
	
	Do While llFindRow >0 
		llFindRow = this.Find(lsFind,llFindRow+1,this.RowCount()+1)
		
		IF llFindRow >1 Then
			ll_duplicaterow =llFindRow
		END IF
	Loop

//doesn't allow to update duplicate delivery orders
If (ll_duplicaterow <> llRowPos) Then
	
	//if following fields are blank, don't update an order
	If (((Not isnull(lsCarrier)) and lsCarrier > ' ') and ((Not isnull(lsAwb)) and lsAwb > ' ')  &
	 and ( Not isnull(this.GetITemString(llRowPos,'Freight_ETD')))  &
	 and ((Not isnull(lsuser_field2)) and lsuser_field2 > ' '))Then
	
	//((Not isnull(ldFreight_etd)) and ldFreight_etd > ' ')
		//prepare dynamic sql to update
		lsSQL ="Update Delivery_Master Set   "
		If lsShip_Ref >' '  Then lsSQL += "Ship_Ref = '" +lsShip_Ref+"',"
		If lsuser_field1 >' '  Then lsSQL += "user_field1 = '" +lsuser_field1+"',"
		If lsuser_field2 >' '  Then lsSQL += "user_field2 = '" +lsuser_field2+"',"
		If lsuser_field3 >' '  Then lsSQL += "user_field3 = '" +lsuser_field3+"',"
		If lsuser_field4 >' '  Then lsSQL += "user_field4 = '" +lsuser_field4+"',"
		If lsuser_field5 >' '  Then lsSQL += "user_field5 = '" +lsuser_field5+"',"
		If lsuser_field6 >' '  Then lsSQL += "user_field6 = '" +lsuser_field6+"',"
		If lsuser_field7 >' '  Then lsSQL += "user_field7 = '" +lsuser_field7+"',"
		If lsuser_field8 >' '  Then lsSQL += "user_field8 = '" +lsuser_field8+"',"
		If lsuser_field9 >' '  Then lsSQL += "user_field9 = '" +lsuser_field9+"',"
		If lsuser_field10 >' '  Then lsSQL += "user_field10 = '" +lsuser_field10+"',"
		If lsuser_field11 >' '  Then lsSQL += "user_field11 = '" +lsuser_field11+"',"
		If lsuser_field12 >' '  Then lsSQL += "user_field12 = '" +lsuser_field12+"',"
		If lsuser_field13 >' '  Then lsSQL += "user_field13 = '" +lsuser_field13+"',"
		If lsuser_field14 >' '  Then lsSQL += "user_field14 = '" +lsuser_field14+"',"
		If lsuser_field15 >' '  Then lsSQL += "user_field15 = '" +lsuser_field15+"',"
		If lsuser_field16 >' '  Then lsSQL += "user_field16 = '" +lsuser_field16+"',"
		If lsuser_field17 >' '  Then lsSQL += "user_field17 = '" +lsuser_field17+"',"
		If lsuser_field19 >' '  Then lsSQL += "user_field19 = '" +lsuser_field19+"',"
		If lsuser_field20 >' '  Then lsSQL += "user_field20 = '" +lsuser_field20+"',"
		If lsuser_field21 >' '  Then lsSQL += "user_field21 = '" +lsuser_field21+"',"
		If lsuser_field22 >' '  Then lsSQL += "user_field22 = '" +lsuser_field22+"',"
		If lsFreight_Terms >' '  Then lsSQL += "Freight_Terms = '" +lsFreight_Terms+"',"
		If llFreight_Cost >0  Then lsSQL += "Freight_Cost = '" +string(llFreight_Cost)+"',"
		If lsCarrier >' '  	Then lsSQL += "Carrier = '" +lsCarrier+"',"
		If lstransport_mode >' '  Then lsSQL += "Transport_Mode = '" +lstransport_mode+"',"
		If lsAwb >' '  Then lsSQL += "Awb_Bol_No = '" +lsAwb+"',"
		lsSQL += "Freight_etd = '" +lsFreight_etd + "'"
		
		lsSQL += "WHERE Project_Id = '"+ gs_project +"' and Invoice_NO = '"+lsOrder+"'"
		Execute Immediate :lsSQL using SQLCA;
		
		If sqlca.sqlcode <> 0 Then
			lsErrorText =sqlca.sqlerrtext
			Execute Immediate "ROLL BACK" using SQLCA;
			
			MessageBox("Import","Unable to save changes to database!~r~r" +lsErrorText)
			SetPointer(Arrow!)
			Return -1	
		ELSE
			llUpdate++
		END IF
	END IF

ELSE
	MessageBox("Import","Doesn't allow to update Duplicate Delivery Order ~r~r" +lsOrder+ "  at row  " +string(ll_duplicaterow))
END IF	

Next

Execute Immediate "COMMIT" using SQLCA;

If sqlca.sqlcode <> 0 Then
	MessageBox("Import","Unable to Commit changes! No changes made to Database")
	Return -1
End if 

MessageBox("Import","Records saved.~r~rRecords Updated: " + String(llUpdate) + "'")
w_main.SetmicroHelp("READY")
Setpointer(Arrow!)
return 0
end function

on u_dw_import_stryker_outbound_update.create
call super::create
end on

on u_dw_import_stryker_outbound_update.destroy
call super::destroy
end on

