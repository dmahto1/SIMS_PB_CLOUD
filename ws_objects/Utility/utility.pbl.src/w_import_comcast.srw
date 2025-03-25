$PBExportHeader$w_import_comcast.srw
forward
global type w_import_comcast from window
end type
type cb_3 from commandbutton within w_import_comcast
end type
type sle_order_no_rono from singlelineedit within w_import_comcast
end type
type st_3 from statictext within w_import_comcast
end type
type st_1 from statictext within w_import_comcast
end type
type sle_order_no from singlelineedit within w_import_comcast
end type
type cb_2 from commandbutton within w_import_comcast
end type
type cb_1 from commandbutton within w_import_comcast
end type
type st_4 from statictext within w_import_comcast
end type
type sle_sku from singlelineedit within w_import_comcast
end type
type cb_close from commandbutton within w_import_comcast
end type
type hpb_1 from hprogressbar within w_import_comcast
end type
type cb_5 from commandbutton within w_import_comcast
end type
type cbx_1 from checkbox within w_import_comcast
end type
type st_2 from statictext within w_import_comcast
end type
type cb_4 from commandbutton within w_import_comcast
end type
type dw_comcast_import from datawindow within w_import_comcast
end type
type gb_1 from groupbox within w_import_comcast
end type
end forward

global type w_import_comcast from window
integer width = 3721
integer height = 2712
boolean titlebar = true
string title = "Import Pallet / Serial Number Files"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cb_3 cb_3
sle_order_no_rono sle_order_no_rono
st_3 st_3
st_1 st_1
sle_order_no sle_order_no
cb_2 cb_2
cb_1 cb_1
st_4 st_4
sle_sku sle_sku
cb_close cb_close
hpb_1 hpb_1
cb_5 cb_5
cbx_1 cbx_1
st_2 st_2
cb_4 cb_4
dw_comcast_import dw_comcast_import
gb_1 gb_1
end type
global w_import_comcast w_import_comcast

type variables
//
end variables

on w_import_comcast.create
this.cb_3=create cb_3
this.sle_order_no_rono=create sle_order_no_rono
this.st_3=create st_3
this.st_1=create st_1
this.sle_order_no=create sle_order_no
this.cb_2=create cb_2
this.cb_1=create cb_1
this.st_4=create st_4
this.sle_sku=create sle_sku
this.cb_close=create cb_close
this.hpb_1=create hpb_1
this.cb_5=create cb_5
this.cbx_1=create cbx_1
this.st_2=create st_2
this.cb_4=create cb_4
this.dw_comcast_import=create dw_comcast_import
this.gb_1=create gb_1
this.Control[]={this.cb_3,&
this.sle_order_no_rono,&
this.st_3,&
this.st_1,&
this.sle_order_no,&
this.cb_2,&
this.cb_1,&
this.st_4,&
this.sle_sku,&
this.cb_close,&
this.hpb_1,&
this.cb_5,&
this.cbx_1,&
this.st_2,&
this.cb_4,&
this.dw_comcast_import,&
this.gb_1}
end on

on w_import_comcast.destroy
destroy(this.cb_3)
destroy(this.sle_order_no_rono)
destroy(this.st_3)
destroy(this.st_1)
destroy(this.sle_order_no)
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.st_4)
destroy(this.sle_sku)
destroy(this.cb_close)
destroy(this.hpb_1)
destroy(this.cb_5)
destroy(this.cbx_1)
destroy(this.st_2)
destroy(this.cb_4)
destroy(this.dw_comcast_import)
destroy(this.gb_1)
end on

event open;

dw_comcast_import.SetTransObject(SQLCA)
end event

type cb_3 from commandbutton within w_import_comcast
integer x = 1641
integer y = 2164
integer width = 805
integer height = 112
integer taborder = 90
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Update Order/Sku Inbound"
end type

event clicked;
SetPointer(Hourglass!)

string ls_order_no, ls_sku, ls_ro_no

ls_order_no = sle_order_no_rono.text

if trim(ls_order_no) = '' or IsNull(ls_order_no) then
	
	MessageBox ("Error", "Must enter a Inbound Order Number")
	
	RETURN -1
	
end if

select ro_no into :ls_ro_no from receive_master where supp_invoice_no = :ls_order_no and project_id = 'COMCAST' USING SQLCA;

if sqlca.sqlcode <> 0 then
	
	MessageBox ("DB Error", SQLCA.SQLCode )
	
end if

select max(sku) into :ls_sku from receive_detail where ro_no = :ls_ro_no  USING SQLCA;


if sqlca.sqlcode <> 0 then
	
	MessageBox ("DB Error", SQLCA.SQLCode )
	
end if


update  carton_serial set sku = :ls_sku where pallet_id in (select lot_no from receive_putaway  where  ro_no = :ls_ro_no ) and project_id = 'COMCAST';

if sqlca.sqlcode <> 0 then
	
	MessageBox ("DB Error", SQLCA.SQLCode )
	
end if

MessageBox ("Fixed", "Fixed")
end event

type sle_order_no_rono from singlelineedit within w_import_comcast
integer x = 878
integer y = 2164
integer width = 677
integer height = 112
integer taborder = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type st_3 from statictext within w_import_comcast
integer x = 247
integer y = 2188
integer width = 549
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Inbound Order No:"
boolean focusrectangle = false
end type

type st_1 from statictext within w_import_comcast
integer x = 247
integer y = 2008
integer width = 544
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Outbound Order No:"
boolean focusrectangle = false
end type

type sle_order_no from singlelineedit within w_import_comcast
integer x = 878
integer y = 1984
integer width = 677
integer height = 112
integer taborder = 70
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type cb_2 from commandbutton within w_import_comcast
integer x = 1641
integer y = 1988
integer width = 805
integer height = 112
integer taborder = 70
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Update Order/Sku Outbound"
end type

event clicked;
SetPointer(Hourglass!)

string ls_order_no, ls_sku, ls_do_no

ls_order_no = sle_order_no.text

if trim(ls_order_no) = '' or IsNull(ls_order_no) then
	
	MessageBox ("Error", "Must enter a Outbound Order Number")
	
	RETURN -1
	
end if

select do_no into :ls_do_no from delivery_master where invoice_no = :ls_order_no and project_id = 'COMCAST' USING SQLCA;

if sqlca.sqlcode <> 0 then
	
	MessageBox ("DB Error", SQLCA.SQLCode )
	
end if

select max(sku) into :ls_sku from delivery_detail where do_no = :ls_do_no  USING SQLCA;


if sqlca.sqlcode <> 0 then
	
	MessageBox ("DB Error", SQLCA.SQLCode )
	
end if


update  carton_serial set sku = :ls_sku where pallet_id in (select lot_no from delivery_picking  where  do_no = :ls_do_no ) and project_id = 'COMCAST';

if sqlca.sqlcode <> 0 then
	
	MessageBox ("DB Error", SQLCA.SQLCode )
	
end if

MessageBox ("Fixed", "Fixed")
end event

type cb_1 from commandbutton within w_import_comcast
integer x = 3328
integer y = 104
integer width = 329
integer height = 112
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Set Sku"
end type

event clicked;
string ls_sku
integer li_idx

ls_sku = sle_sku.text
for li_idx = 1 to dw_comcast_import.Rowcount()
	
	//48394 is labeled as Motorola 
	
	//		dw_comcast_import.SetItem( li_idx, "last_update", datetime( today(), now()))
	
	dw_comcast_import.SetItem( li_idx, "sku", ls_sku)
//			dw_comcast_import.SetItem( li_idx, "supp_code", "MOTOROLA")
	
	
next
end event

type st_4 from statictext within w_import_comcast
integer x = 2555
integer y = 128
integer width = 174
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Sku:"
boolean focusrectangle = false
end type

type sle_sku from singlelineedit within w_import_comcast
integer x = 2747
integer y = 100
integer width = 558
integer height = 112
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type cb_close from commandbutton within w_import_comcast
integer x = 50
integer y = 2424
integer width = 402
integer height = 112
integer taborder = 60
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Close"
end type

event clicked;Close(parent)
end event

type hpb_1 from hprogressbar within w_import_comcast
integer x = 837
integer y = 1592
integer width = 1115
integer height = 64
unsignedinteger maxposition = 100
integer setstep = 10
end type

type cb_5 from commandbutton within w_import_comcast
integer x = 37
integer y = 1564
integer width = 590
integer height = 112
integer taborder = 40
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Create Sweeper File"
end type

event clicked;
hpb_1.position = 0

ulong li_idx,  li_RowCount

if  dw_comcast_import.RowCount() <= 0 then
	MessageBox ("No Rows", "There are no rows to import.")
	RETURN -1
end if 

long ll_File_No

string lsPath, lsFile



//Get the file name
If GetFileSaveName("Select Export File",lsPath,lsFile,"TXT","Text Files (*.TXT),*.TXT,") <> 1 Then REturn -1


SetPointer(Hourglass!)

ll_File_No = FileOpen(lsPath,LineMode!,Write!,LockReadWrite!, Replace!)

li_RowCount = dw_comcast_import.RowCount()

for li_idx = 1 to li_RowCount

	hpb_1.maxposition = dw_comcast_import.RowCount()

	
//	st_3.text = string(li_idx)
	hpb_1.position = li_idx
	
//	parent.SetRedraw(true)

	string ls_pallet_id, ls_sku, ls_supp_code, ls_serial_no
	string ls_mac_id, ls_carton_id, ls_user_field1, ls_user_field2, ls_user_field4, ls_user_field5



	ls_pallet_id = dw_comcast_import.GetItemString( li_idx, "pallet_id")
	ls_sku =  dw_comcast_import.GetItemString( li_idx, "sku")
	ls_supp_code  =  Upper(dw_comcast_import.GetItemString( li_idx, "supp_code"))
	ls_serial_no  =  dw_comcast_import.GetItemString( li_idx, "serial_no")
	ls_mac_id   =  dw_comcast_import.GetItemString( li_idx, "mac_id")
	
	if trim(ls_mac_id) = '' or IsNull(ls_mac_id) then ls_mac_id = '-'
	
	ls_carton_id  =  dw_comcast_import.GetItemString( li_idx, "carton_id")

	if trim(ls_carton_id) = '' or IsNull(ls_carton_id) then ls_carton_id = '-'

	
	ls_user_field1 =  dw_comcast_import.GetItemString( li_idx, "user_field1")
	ls_user_field2 =  dw_comcast_import.GetItemString( li_idx, "user_field2")
	ls_user_field4 =  dw_comcast_import.GetItemString( li_idx, "user_field4")
	ls_user_field5 =  dw_comcast_import.GetItemString( li_idx, "user_field5")

	if IsNull(ls_user_field1) or trim(ls_user_field1) = '' then ls_user_field1 = ''
	if IsNull(ls_user_field2) or trim(ls_user_field2) = '' then ls_user_field2 = ''
	if IsNull(ls_user_field4) or trim(ls_user_field4) = '' then ls_user_field4 = ''
	if IsNull(ls_user_field5) or trim(ls_user_field5) = '' then ls_user_field5 = ''

	
  	string ls_out_string
	  
	//PAck List Number - Not Used (#1)
			
	ls_out_string = "|"			

	
	//Pallet ID (#2)


	ls_out_string = ls_out_string + ls_pallet_id + "|"


		
	//Model Number - Not Used (#3)
		//04/10 - PCONKL - May be used to map to SKU if OEM Part not found

		ls_out_string = ls_out_string  + "|"

		
//		lsModel = lsTemp
		
		

	
//		//Finished Goods Number - OEM Part Number, need to convert to our SKU (#4)


		string lsCurrentCheckSku, ls_LastCheckSku, lsLastSKU, ls_user_field9, ls_user_field10, ls_Model
		
		lsCurrentCheckSku = ls_sku
		
		if lsCurrentCheckSku <> ls_LastCheckSku  then
			
			Select user_field9, user_field10 into :ls_user_field9, :ls_user_field10
			from Item_Master
			Where Project_id = 'COMCAST' and sku = :ls_sku and supp_code = :ls_supp_code USING SQLCA;
			
			 ls_LastCheckSku = lsCurrentCheckSku
			 
		end if
		
		// 04/10 - PCONKL - If SKU not found from OEM SKU (UF9), load it from UF10 (EIS Model). That's where most of them are coing from now.
		If  trim(ls_user_field9) = "" or isnull(ls_user_field9) Then
			
			ls_Model = ls_user_field9
			
		Else 
			
			ls_Model = ls_user_field10
			
		End If


		if IsNull(ls_model) or trim(ls_model) = '' then ls_model = " "
		
		ls_out_string = ls_out_string  + "|"

		
		//Ship Date - Not Used (#5)
	
		ls_out_string =  ls_out_string + "|"		
		
		//Manufacturer (Supplier) (#6)
		
		ls_out_string =  ls_out_string + ls_supp_code +  "|"	
		
		//Customer - Not Used (#7)

		ls_out_string =  ls_out_string + "|"		

		
		//City - Not Used (#8)
		
		ls_out_string =  ls_out_string + "|"		

		
		//State - Not Used (#9)
		
		ls_out_string =  ls_out_string + "|"		

		
		//Serial Number (#10)

		ls_out_string =  ls_out_string + ls_serial_no +  "|"	
		
		//Unit ID (UF1) (#11)

		ls_out_string =  ls_out_string + ls_user_field1 +  "|"	
	
		
		//Host ID - (UF2) (#12)

		ls_out_string =  ls_out_string + ls_user_field2 +  "|"	
	
			
		//ECM MAC (UF4) (#13)
	
		ls_out_string =  ls_out_string + ls_user_field4 +  "|"	

		
		//Ethernet MAC - Not used (#14)

		ls_out_string =  ls_out_string + "|"		
	
		
		//Set Top MAC - USED (#15)
	
		ls_out_string =  ls_out_string + ls_mac_id +  "|"	
		
		
		//USB MAC - Not USed (#16)
		
		ls_out_string =  ls_out_string + "|"		
		
		//1394 MAC - Not USed (#17)
		
		ls_out_string =  ls_out_string + "|"		
		
		//Embedded MAC - Not USed (#18)
		
		ls_out_string =  ls_out_string + "|"	
		
		//m-Card Serial -(UF5)  (#19) - 
		// 05/10 - PCONKL - Added mapping for CPE product

		ls_out_string =  ls_out_string + ls_user_field5 +  "|"	
		
		//m-card unit Address - (UF3) (#20)

		//ls_user_field3

		ls_out_string =  ls_out_string  +  "|"	

		
		//m-Card  MAC - Not USed (#21)

		ls_out_string =  ls_out_string  +  "|"	
		
		//M-Card cableCard ID - Not USed (#22)
		
		ls_out_string =  ls_out_string  +  "|"	
		
		
		//Master Pack Carton - Should be last field (#23)
		
		ls_out_string =  ls_out_string  +  ls_carton_id


		FileWrite(ll_File_No, ls_out_string)

//
//	INSERT INTO Carton_Serial
//		(project_id, sku, supp_code, Carton_id, Last_Update, serial_no, Pallet_ID, Mac_ID, user_field1, user_field2, user_field4, user_field5)
//		VALUES ('COMCAST',  :ls_sku, :ls_supp_code, :ls_carton_id,  getdate(), :ls_serial_no, :ls_pallet_id,:ls_mac_id, :ls_user_field1, :ls_user_field2, :ls_user_field4, :ls_user_field5  ) USING SQLCA;
//
//	IF SQLCA.SQLCode = 0 THEN
//
//		Execute Immediate "COMMIT" using SQLCA;
//	
//	ELSE
//	
////		Execute Immediate "ROLLBACK" using SQLCA;
//	
//		mle_1.text = mle_1.text + "Row:" +  string(li_idx) + " SN :" + ls_serial_no + " Error:" + sqlca.SQLErrText + char(10) + char(13)
//	
//	END IF
//
next

FileClose(ll_File_No)


Messagebox ("Import Complete", "File Processed.")

//Execute Immediate "Begin Transaction" using SQLCA;
//if dw_comcast_import.Update() = 1 then
//	
//	Messagebox ("Errors With Import", "There were error with the import.")


//Check to see if this fixes any of the 'S' Type Pallets.
//Need to re-visit this.
//	
//update receive_putaway set receive_putaway.inventory_type = 'N'   from receive_putaway, receive_master, carton_serial where receive_putaway.ro_no =  receive_master.ro_no and receive_master.project_id = 'COMCAST'and receive_putaway.inventory_type = 'S'  and carton_serial.project_id = 'COMCAST' and receive_putaway.lot_no = carton_serial.pallet_id;


end event

type cbx_1 from checkbox within w_import_comcast
integer x = 73
integer y = 24
integer width = 946
integer height = 80
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "First Column Contains Header"
boolean checked = true
end type

type st_2 from statictext within w_import_comcast
integer x = 635
integer y = 184
integer width = 1883
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "File Must Be in Following Format As Shown Below"
boolean focusrectangle = false
end type

type cb_4 from commandbutton within w_import_comcast
integer x = 46
integer y = 156
integer width = 402
integer height = 112
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Select File"
end type

event clicked;
integer liRC, li_begin_row 

string ls_path, ls_File

SetPointer(Hourglass!)

liRC = getFileOpenName("Select FIle to Import",ls_path, ls_File,"TXT","Text Files (*.*),*.*,")


If liRC <>1 Then Return

if cbx_1.checked then 
	li_begin_row = 2
else
	li_begin_row = 1
end if

integer li_idx

dw_comcast_import.Reset()

//if not rb_1.checked then
	

	dw_comcast_import.ImportFile(ls_path, li_begin_row )
	
//	MessageBox ("done", "done")
	
//	if dw_comcast_import.RowCount() > 0 then
//	
//		for li_idx = 1 to dw_comcast_import.Rowcount()
//	
//	//48394 is labeled as Motorola 
//	
//	//		dw_comcast_import.SetItem( li_idx, "last_update", datetime( today(), now()))
//	
////			dw_comcast_import.SetItem( li_idx, "sku", "48394")
////			dw_comcast_import.SetItem( li_idx, "supp_code", "MOTOROLA")
//	
//	
//	
//		next
//	
//	end if

//else
//	
//	integer liFileNo, llNewRow
//	string lsRecData, lsorder, lsRONO
//	DataStore	lu_ds
//	
//	lu_ds = Create datastore
//	lu_ds.dataobject = 'd_generic_import'
//	
//	liFileNo = FileOpen(ls_path,LineMode!,Read!,LockReadWrite!)
//	If liFileNo < 0 Then
//		MessageBox ("Error",  "-       ***Unable to Open File for Comcast Processing: " + ls_path)
//		RETURN -1
//	End If
//	
//	//read file and load to datastore for processing
//	liRC = FileRead(liFileNo,lsRecData)
//	
//	Do While liRC > 0
//		llNewRow = lu_ds.InsertRow(0)
//		lu_ds.SetItem(llNewRow,'rec_data',lsRecData) 
//		liRC = FileRead(liFileNo,lsRecData)
//	Loop /*Next File record*/
//	
//	FileClose(liFileNo)
//	
//	//We need the Order number from the file and retreive the RO_NO from the Inbound Order that should already be loaded in SIMS. File naming format is "SN=Warehouse=Order.txt"
//	lsOrder = Mid(ls_path,(LastPos(ls_path,"=") + 1),99999)
//	lsOrder = Left(lsOrder,(Pos(lsOrder,".") - 1)) /*remove ".txt" */
//	
//	If lsOrder > '' Then
//		
//		Select Max(ro_No) into :lsRONO
//		From Receive_master
//		Where Project_id = 'COMCAST' and supp_invoice_No = :lsOrder;
//		
//	End If
//	
//	If lsRONO = "" Then /*no order for this file */
//	
//		mle_1.text = mle_1.text +    "       File: " + ls_Path +  ", Order number: " + lsOrder + " not found in SIMS. File will still be loaded (Warning Only)." + char(13) + char(10)
//	
//	End If
//	string lstemp
//	long llRowCount, lLRowPos
//	
//	
//	llRowCount = lu_ds.RowCount()
//	
//	mle_1.text = mle_1.text +  '      -  ' + String(llRowCount)  + " records retrieved for processing." + char(13) + char(10)
//	//FileWrite(giLogFileNo,lsLogOut)
//	//gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
//	
//	//Loop through each record and build a carton serial record...
//	
//	For lLRowPos = 1 to llRowCount
//		
//		st_3.text = "Loading " + string(lLRowPos) + " of " + string(llRowCount)
//		
//		parent.SetRedraw(true)
//
//		
//		lsRecData = lu_ds.GetITemString(llRowPos,'rec_data')
//	
//		llNewRow = dw_comcast_import.InsertRow(0)
//	
////		luCartonSerial.SetItem(llNewRow,'ro_no',lsRoNo)  /* used to link to Inbound Order */
//		
//		//PAck List Number - Not Used (#1)
//		If Pos(lsRecData,'|') > 0 Then
//			lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
//		Else /*error*/
//			mle_1.text = mle_1.text +    "Row: " + string(llRowPos) + " - No delimiter found after 'Packer List Number' field. Record will not be processed." + char(13) + char(10)
//		End If
//
//		
//				
//		lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
//
//	
//		//Pallet ID (#2)
//		If Pos(lsRecData,'|') > 0 Then
//			lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
//		Else /*error*/
//			mle_1.text = mle_1.text +    "Row: " + string(llRowPos) + " - No delimiter found after 'Pallet ID' field. Record will not be processed." + char(13) + char(10)
//		End If
//	
//		dw_comcast_import.SetItem(llNewRow,'pallet_id',trim(lsTemp))
//		
//		lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
//
//		string lsModel, lsSku
//		
//		//Model Number - Not Used (#3)
//		//04/10 - PCONKL - May be used to map to SKU if OEM Part not found
//		If Pos(lsRecData,'|') > 0 Then
//			lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
//		Else /*error*/
//			mle_1.text = mle_1.text +    "Row: " + string(llRowPos) + " - No delimiter found after 'Model Number' field. Record will not be processed." + char(13) + char(10)
//		End If
//		
//		lsModel = lsTemp
//		
//		lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
//		
//		
//		//Finished Goods Number - OEM Part Number, need to convert to our SKU (#4)
//		If Pos(lsRecData,'|') > 0 Then
//			lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
//		Else /*error*/
//			mle_1.text = mle_1.text +    "Row: " + string(llRowPos) + " - No delimiter found after 'Finished Goods Number' field. Record will not be processed." + char(13) + char(10)
//		End If
//		
//		//There is currently a Case statement to hardcode the OEM Part Number to the SIMS SKU. 
//		//I have added the OEM Part Number to the Item Master UF9. 
//		//Please remove the Case statement and do a lookup against the Item Master to translate the OEM SKU to our SKU. 
//		//Only do the lookup if the SKU changes. We are probably only receiving a single SKU per file.
//		
//		string lsCurrentCheckOEMSku, ls_LastCheckOEMku, lsLastSKU
//		
//		lsCurrentCheckOEMSku = lsTemp
//		
//		if lsCurrentCheckOEMSku <> ls_LastCheckOEMku  then
//			
//			Select sku into :lsLastSKU
//			from Item_Master
//			Where Project_id = 'COMCAST' and user_field9 = :lsCurrentCheckOEMSku;
//			
//			 ls_LastCheckOEMku = lsCurrentCheckOEMSku
//			 
//			lsSKU = lsLastSKU		 
//			
//		else
//			lsSKU = lsLastSKU
//		end if
//		
//		// 04/10 - PCONKL - If SKU not found from OEM SKU (UF9), load it from UF10 (EIS Model). That's where most of them are coing from now.
//		If lsSKU = "" or isnull(lsSKU) Then
//			
//			Select sku into :lsSKU
//			from Item_Master
//			Where Project_id = 'COMCAST' and user_field10 = :lsModel;
//			
//		End If
//
//		dw_comcast_import.SetItem(llNewRow,'sku', lsSKU)	
//		
//		lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
//		
//		
//		//Ship Date - Not Used (#5)
//		If Pos(lsRecData,'|') > 0 Then
//			lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
//		Else /*error*/
//			mle_1.text = mle_1.text +    "Row: " + string(llRowPos) + " - No delimiter found after 'Ship Date' field. Record will not be processed." + char(13) + char(10)
//		End If
//		
//		lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
//		
//		
//		//Manufacturer (Supplier) (#6)
//		If Pos(lsRecData,'|') > 0 Then
//			lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
//		Else /*error*/
//			mle_1.text = mle_1.text +    "Row: " + string(llRowPos) + " - No delimiter found after 'Manufacturer' field. Record will not be processed." + char(13) + char(10)
//		End If
//
//		long llcount
//		
//		//validate
//		Select Count(*) into :llCount
//		From Supplier
//		Where project_id = 'COMCAST' and supp_code = :lsTemp;
//		
//		If llCount = 0 Then
//			mle_1.text = mle_1.text +    "Row: " + string(llRowPos) + " - Invalid Supplier: '" + lsTemp + "'. Record will not be processed." + char(13) + char(10)
//		Else
//				dw_comcast_import.SetItem(llNewRow,'supp_code',trim(lsTemp))
//		End If
//		
//		lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
//		
//		
//		//Customer - Not Used (#7)
//		If Pos(lsRecData,'|') > 0 Then
//			lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
//		Else /*error*/
//			mle_1.text = mle_1.text +    "Row: " + string(llRowPos) + " - No delimiter found after 'Customer Name' field. Record will not be processed." + char(13) + char(10)
//		End If
//		
//		lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
//		
//		
//		//City - Not Used (#8)
//		If Pos(lsRecData,'|') > 0 Then
//			lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
//		Else /*error*/
//			mle_1.text = mle_1.text +    "Row: " + string(llRowPos) + " - No delimiter found after 'City' field. Record will not be processed." + char(13) + char(10)
//		End If
//		
//		lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
//		
//		
//		//State - Not Used (#9)
//		If Pos(lsRecData,'|') > 0 Then
//			lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
//		Else /*error*/
//			mle_1.text = mle_1.text +    "Row: " + string(llRowPos) + " - No delimiter found after 'State' field. Record will not be processed." + char(13) + char(10)
//		End If
//		
//		lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
//		
//		
//		//Serial Number (#10)
//		If Pos(lsRecData,'|') > 0 Then
//			lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
//		Else /*error*/
//			mle_1.text = mle_1.text +    "Row: " + string(llRowPos) + " - No delimiter found after 'Serial Number' field. Record will not be processed." + char(13) + char(10)
//		End If
//		
//		dw_comcast_import.SetItem(llNewRow,'serial_no',trim(lsTemp))
//		
//	
//		lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
//		
//	
//	// DTA vs CPE address fields are mapped differently for CPE and DTA (Item Group)
//		
//	//Address1 -  CPE = Cable Card Unit Address Field 20 – M-Card Unit Address (UF3),   						DTA = MAC Address (MAC_ID)
//	//Address2 - CPE = Host Embedded Serial Number Field 10 – Set-top Serial Number - (Serial_NO),		DTA = Unit Address (UF1)
//	//Address3 - CPE = Host Embedded STB MAC Field 15 – eSTB MAC - (mac_id)									DTA = Blank
//	//Address4  - CPE =Host Embedded Cable Modem MAC Field 13 – eCM MAC (UF4)							DTA = Blank
//	//Address5  - CPE =Host ID Field 12 – Host ID (UF2)
//	
//		
//		//Unit ID (UF1) (#11)
//		If Pos(lsRecData,'|') > 0 Then
//			lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
//		Else /*error*/
//			mle_1.text = mle_1.text +    "Row: " + string(llRowPos) + " - No delimiter found after 'Unit ID' field. Record will not be processed." + char(13) + char(10)
//		End If
//		
//		dw_comcast_import.SetItem(llNewRow,'user_field1',trim(lsTemp))
//		
//		
//		
//		lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
//		
//		
//		//Host ID - (UF2) (#12)
//		If Pos(lsRecData,'|') > 0 Then
//			lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
//		Else /*error*/
//			mle_1.text = mle_1.text +    "Row: " + string(llRowPos) + " - No delimiter found after 'Host ID' field. Record will not be processed." + char(13) + char(10)
//		End If
//	
//		dw_comcast_import.SetItem(llNewRow,'user_field2',trim(lsTemp))
//	
//		
//		lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
//		
//		
//		//ECM MAC (UF4) (#13)
//		If Pos(lsRecData,'|') > 0 Then
//			lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
//		Else /*error*/
//			mle_1.text = mle_1.text +    "Row: " + string(llRowPos) + " - No delimiter found after 'ECM MAC ID' field. Record will not be processed." + char(13) + char(10)
//		End If
//
//		dw_comcast_import.SetItem(llNewRow,'user_field4',trim(lsTemp))
//	
//	
//		lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
//		
//		
//		//Ethernet MAC - Not used (#14)
//		If Pos(lsRecData,'|') > 0 Then
//			lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
//		Else /*error*/
//			mle_1.text = mle_1.text +    "Row: " + string(llRowPos) + " - No delimiter found after 'Ethernet MAC' field. Record will not be processed." + char(13) + char(10)
//		End If
//		
//		lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
//		
//		
//		//Set Top MAC - USED (#15)
//		If Pos(lsRecData,'|') > 0 Then
//			lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
//		Else /*error*/
//			mle_1.text = mle_1.text +    "Row: " + string(llRowPos) + " - No delimiter found after 'STB MAC' field. Record will not be processed." + char(13) + char(10)
//		End If
//		
//	
//		dw_comcast_import.SetItem(llNewRow,'mac_id',trim(lsTemp))
//
//		
//		lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
//		
//		
//		//USB MAC - Not USed (#16)
//		If Pos(lsRecData,'|') > 0 Then
//			lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
//		Else /*error*/
//			mle_1.text = mle_1.text +    "Row: " + string(llRowPos) + " - No delimiter found after 'USB MAC' field. Record will not be processed." + char(13) + char(10)
//		End If
//		
//		lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
//		
//		
//		//1394 MAC - Not USed (#17)
//		If Pos(lsRecData,'|') > 0 Then
//			lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
//		Else /*error*/
//			mle_1.text = mle_1.text +    "Row: " + string(llRowPos) + " - No delimiter found after '1394 MAC' field. Record will not be processed." + char(13) + char(10)
//		End If
//		
//		lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
//		
//		
//		//Embedded MAC - Not USed (#18)
//		If Pos(lsRecData,'|') > 0 Then
//			lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
//		Else /*error*/
//			mle_1.text = mle_1.text +    "Row: " + string(llRowPos) + " - No delimiter found after 'Embedded MAC' field. Record will not be processed." + char(13) + char(10)
//		End If
//		
//		lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
//		
//		
//		//m-Card Serial -(UF5)  (#19) - 
//		// 05/10 - PCONKL - Added mapping for CPE product
//		If Pos(lsRecData,'|') > 0 Then
//			lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
//		Else /*error*/
//			mle_1.text = mle_1.text +    "Row: " + string(llRowPos) + " - No delimiter found after 'm-card Serial' field. Record will not be processed." + char(13) + char(10)
//		End If
//		
//		dw_comcast_import.SetItem(llNewRow,'user_field5',trim(lsTemp))
//		
//		lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
//		
//		
//		//m-card unit Address - (UF3) (#20)
//		If Pos(lsRecData,'|') > 0 Then
//			lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
//		Else /*error*/
//			mle_1.text = mle_1.text +    "Row: " + string(llRowPos) + " - No delimiter found after 'm-Card Unit Address' field. Record will not be processed." + char(13) + char(10)
//		End If
//
////		dw_comcast_import.SetItem(llNewRow,'user_field3',trim(lsTemp))
//
//		lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
//		
//		
//		//m-Card  MAC - Not USed (#21)
//		If Pos(lsRecData,'|') > 0 Then
//			lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
//		Else /*error*/
//			mle_1.text = mle_1.text +    "Row: " + string(llRowPos) + " - No delimiter found after 'M-Card MAC' field. Record will not be processed." + char(13) + char(10)
//		End If
//		
//		lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
//		
//		
//		//M-Card cableCard ID - Not USed (#22)
//		If Pos(lsRecData,'|') > 0 Then
//			lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
//		Else /*error*/
//			mle_1.text = mle_1.text +    "Row: " + string(llRowPos) + " - No delimiter found after 'M-Card CableCard ID' field. Record will not be processed." + char(13) + char(10)
//		End If
//		
//		lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
//		
//		
//		
//		//Master Pack Carton - Should be last field (#23)
//		If Pos(lsRecData,'|') > 0 Then
//			lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
//		Else /*error*/
//			lsTemp = lsRecData
//		End If
//
//		dw_comcast_import.SetItem(llNewRow,'carton_id',trim(lsTemp))
//
//			
//	Next /*serial row */
//	
//
//end if
end event

type dw_comcast_import from datawindow within w_import_comcast
integer x = 27
integer y = 336
integer width = 3607
integer height = 1200
integer taborder = 10
string title = "none"
string dataobject = "d_comcast_import"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event dberror;

MessageBox ("DB Error", "Row: " + string(row))
end event

event sqlpreview;
hpb_1.position = row
end event

type gb_1 from groupbox within w_import_comcast
integer x = 32
integer y = 1836
integer width = 2523
integer height = 532
integer taborder = 70
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Update Sku on Carton/Serial Table"
end type

