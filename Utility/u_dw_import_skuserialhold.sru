HA$PBExportHeader$u_dw_import_skuserialhold.sru
$PBExportComments$Import Locations
forward
global type u_dw_import_skuserialhold from u_dw_import
end type
end forward

global type u_dw_import_skuserialhold from u_dw_import
integer width = 3077
integer height = 1572
string dataobject = "d_import_skuserialhold"
end type
global u_dw_import_skuserialhold u_dw_import_skuserialhold

forward prototypes
public function integer wf_save ()
public function string wf_validate (long al_row)
end prototypes

public function integer wf_save ();//Jxlim 07/18/2013 Import Arien file to SkuSerialHold table, delete all then overwrite the whole table
//dts 8/26 - concatenating the Model + Serial and Making sure Model is 8-character in the SKU field
/*dts 2/25/14 - now not deleting all SKU/Serial records from the HOLD table and reloading
   - scrolling through the table and looking in the latest file to see if the SKU/Serial combo is there (keeping in mind the differnt masks
	 for HOLD file vs Inventory (6-char SKU and Serial in file, 8-char SKU and 12-char serial number in inventory
	 As of today, all SKUs are 8-char and all SerialNos are 12-char.
	 *** I think we should only load the versions that are in inventory.
	*/

Long                      llRowCount,       &
                                                llRowPos,            &
                                                llUpdate,             &
                                                llNew, llcount, llDel
                                
Decimal                ldLength,             &
                                                ldWidth,                               &
                                                ldHeight,              &
                                                ldCapacity,          &
                                                ldPriority, &
                                                ld_picking_seq
                                
String lsSKU, lsSerial_no, lssql, lsErrText
String lsProject //dts not using lsToday, lsServerTime, 
// not using datetime ldtToday, ldtServerTime 

f_method_trace_special(gs_project, this.ClassName() , 'Start Ariens HOLD file Import' ,'', '','','')

//18-Feb-2014 :Madhu- Added code to delete Serial hold records -START
Datastore ldsserialholddata
String sql_syntax,lsErrors,lsserialsku,lsserialno,lsFind,ls_serialsku,ls_serialno
Long ll_serial_rowcount,li_serial,llFindRow,llrecord,llrecord1
int li_serialno
//18-Feb-2014 :Madhu- Added code to delete Serial hold records -END

llRowCount = This.RowCount()
f_method_trace_special(gs_project, this.ClassName() , 'Records in new HOLD File: ' + string(llRowCount),'', '','','')

llupdate = 0
llNew = 0

SetPointer(Hourglass!)

// pvh 02.15.06 - gmt
//dts ldtToday = f_getLocalWorldTime( gs_default_wh ) 
//dts lsToday = string( ldtToday, 'mm/dd/yyyy hh:mm:ss')

// pvh 02.15.06 - gmt
//dts ldtServerTime = DateTime(Today(),Now())
//dts lsServerTime = String( ldtServerTime, 'mm/dd/yyyy hh:mm:ss')

lsProject = Upper(gs_project)

//18-Feb-2014 :Madhu- Added code to delete Serial hold records -START
//Execute Immediate "Begin Transaction" using SQLCA; /* 11/04 - PCONKL - Auto Commit Turned on to eliminate DB locks*/                 
//Delete all record/s  Before insert
//compare the import file records with db records, if doesn't exists delete
//Delete From Sku_Serial_Hold Where project_id = :lsProject
//Using SQLCA;

//dts - now scrolling through table to look for SKU/Serial combos not in latest file...
ldsserialholddata = Create Datastore
sql_syntax = " select Sku, Serial_No from SKU_Serial_hold with(nolock) Where Project_ID = '" + gs_project + "'"

ldsserialholddata.Create(SQLCA.SyntaxFromSQL(sql_syntax, "", lsErrors))
If Len(lsErrors) > 0 Then
	Return -1
else
	ldsserialholddata.SetTransObject(SQLCA)
	ll_serial_rowcount =ldsserialholddata.retrieve()
	f_method_trace_special(gs_project, this.ClassName() , 'Current Records in Hold table: ' + string(ll_serial_RowCount),'', '','','')                          
END IF

//scroll through the Hold table, check against the file, and delete record from db if it's not in the file...
f_method_trace_special(gs_project, this.ClassName() , 'looking for deletes by scrolling through Hold table and comparing to the file','', '','','')                           
// moving inside the loop to prevent blocking...Execute Immediate "Begin Transaction" using SQLCA;
For li_serial =1 to ll_serial_rowcount //scrolling through the table...
	lsserialsku = ldsserialholddata.getItemString(li_serial,"Sku")
	lsserialno =ldsserialholddata.getItemString(li_serial,"Serial_No")

	w_main.SetmicroHelp("scrolling through HOLD Table, looking for Deletes: " + string(li_serial) + " of " + string(ll_serial_RowCount))

	//we've 2 entries for each sku/serial - one as delivered in HOLD file and one with the naming convention found in Inventory
	//2/25/14 - dts - Inventory only has 8-char SKUs and 12-char Serial#s so considering only loading Inventory version
	IF len(lsserialno) > 6 THEN
		ls_serialno = RIGHT(lsserialno,6)
		//ls_serialsku =LEFT (lsserialsku,6)
		ls_serialsku =LEFT (lsserialsku,6)
		lsFind = "Upper(SKU) = '" + ls_serialsku + "'" +" and Upper(Serial_No) ='" + ls_serialno + "'"
		llFindRow = this.Find(lsFind,1,this.RowCount()) //check db record exists in Import file
	ELSE
		lsFind = "Upper(SKU) = '" + lsserialsku + "'" +" and Upper(Serial_No) ='" + lsserialno + "'"
		llFindRow = this.Find(lsFind,1,this.RowCount()) //check db record exists in Import file
	END IF
	
	IF llFindRow = 0 Then //If doesn't exist (in file), delete from HOLD table and set Hold_Status in SNI to blank
	
		//Deleting records from SKU_Serial_Hold table (delete the version as found in the table, not necessarily the file)
		Execute Immediate "Begin Transaction" using SQLCA; //dts - now inside loop to avoid blocking
		Delete From Sku_Serial_Hold Where Project_id = :lsProject and Sku = :lsserialsku and Serial_No =:lsserialno Using SQLCA;
		
		If sqlca.sqlcode <> 0 Then
			Execute Immediate "ROLLBACK" using SQLCA; 
			lsErrText = sqlca.sqlerrtext /* sql error text returned */
			Messagebox("Import","Unable to delete existing rows in database!~r~r" + lsErrText)
			SetPointer(Arrow!)
		else
			//dts - 2/22/14 - hold_status for ALL production records is blank. Need to set based on Inventory Mask, not HOLD File mask
			// - I think we could JUST insert the Inventory Mask (8-char sku / 12-char serial
			//Jxlim 09/23/2013 Ariens;CR26 Serial Number Scanning
			//When Deleting the existing sku_serial_Hold records, also update the hold_status field on Serial_Number_Inventory to blank (update all for Project).
			Update Serial_Number_Inventory
			Set Hold_status =''
			Where Project_Id =:lsProject
			And SKU=:lsserialsku
			And Serial_No= :lsserialno using SQLCA;
			Execute Immediate "COMMIT" using SQLCA;
			llDel ++
		END IF
	END IF
Next //Next record in the TABLE
//dts moving inside loop - Execute Immediate "COMMIT" using SQLCA;
f_method_trace_special(gs_project, this.ClassName() , 'Records deleted: ' +string(llDel) + '. Now scrolling through file for insert/update','', '','','')
//18-Feb-2014 :Madhu - Added code to delete Serial hold records -END

//Insert/update for each Record in file...              
//dts 2/24/14 Execute Immediate "Begin Transaction" using SQLCA;   //Stay out of loop
For llRowPos = 1 to llRowCount //dts - scroll through file and insert/update as appropriate...
	  
	  w_main.SetmicroHelp("Insert/Update Row " + string(llRowPos) + " of " + string(llRowCount))

	  lsSku = left(trim(This.GetItemString(llRowPos,"sku")),50)
	  lsSerial_No = left(trim(This.GetItemString(llRowPos,"serial_no")),50)                                                                                     
/*dts - 2/25/14 - not inserting the records as they are in the File. Only as they are in inventory (8-char SKU, 12-char Serial)	  
	  //18-Feb-2014 :Madhu- check whether record exists in DB or not -START
	  SELECT count(*) into :llrecord from Sku_Serial_Hold
	  WHERE Project_Id =:lsProject  and sku =:lsSku and Serial_No =:lsSerial_No
	  USING SQLCA;
	  //18-Feb-2014 :Madhu- check whether record exists in DB or not -END
	  Execute Immediate "Begin Transaction" using SQLCA;   //now inside loop to minimize blocking
	  IF llrecord = 0 Then  //18-Feb-2014 :Madhu- record doesn't exist, INSERT record -Added
		Insert Into Sku_Serial_Hold (Project_id, sku, serial_no, last_updated)
		//dts Values (:lsProject, :lsSku, :lsSerial_no, :lsToday)
		Values (:lsProject, :lsSku, :lsSerial_no, getdate())
		USING SQLCA;
		llNew ++
	  else
		Update Sku_Serial_Hold set last_updated =GetDate() where Project_Id =:lsProject and Sku=:lsSku and Serial_no =:lsSerial_no USING SQLCA;
		llUpdate ++
	  END IF   //18-Feb-2014 :Madhu- record doesn't exist, INSERT record -Added
	  
	  If sqlca.sqlcode <> 0 Then
		lsErrText = sqlca.sqlerrtext /*text will be lost after rollback*/                                                                                                                                      
		Execute Immediate "ROLLBACK" using SQLCA;
		Messagebox("Import","Unable to save changes to database!~r~r" + lsErrText)
		SetPointer(Arrow!)
		Return -1             
	  Else
		//!!!! dts 2/25/14 - this wasn't working as it was using the SKU/Serial as found in the File, not as found in SNI table
		// - moving this below (to insert of 8-char sku, 12-char serial
		//Jxlim 09/23/2013 Ariens;CR26 Serial Number Scanning
		//When inserting the serial number into sku_serial_hold, 
		//also do an update to serial_number_inventory setting hold_status = $$HEX1$$1820$$ENDHEX$$Y$$HEX2$$19202000$$ENDHEX$$based on Project, SKU and Serial_No (no need to check if it exists. It will just update nothing if it doesn$$HEX1$$1920$$ENDHEX$$t)
		/*Update Serial_Number_Inventory
		Set Hold_status ='Y'
		Where Project_Id =:lsProject
		And SKU=:lsSku
		And Serial_No= :lsSerial_No
		Using SQLCA;
		*/
		//dts llnew ++   
	  End If    
dts 2/25/14*/																	  
	  /*dts 8/26 - adding another record for the way it looks like we'll be getting the data (6-char Model, 6-Char Serial)
		  - once we see how the records are really coming, we can modify the import to only import the correct format */
		  // dts 2/25/14 - I think we can import ONLY the Inventory Mask (8-char SKU, 12-char Serial)
	  if len(lsSKU) = 6 and len(lsSerial_No) = 6 then
			lsSerial_No = lsSKU + lsSerial_No
			lsSku = lsSKU + '00'
			
			//18-Feb-2014 :Madhu- check whether record exists in DB or not -START
			SELECT count(*) into :llrecord1 from Sku_Serial_Hold with(nolock)
			WHERE Project_Id =:lsProject  and sku =:lsSku and Serial_No =:lsSerial_No
			USING SQLCA;
			
			IF llrecord1 =0 Then   //18-Feb-2014 :Madhu- check whether record exists in DB or not -END
				//not in found in DB, so insert
				Execute Immediate "Begin Transaction" using SQLCA;   //now inside loop to minimize blocking
				 Insert Into Sku_Serial_Hold (Project_id, sku, serial_no, last_updated)
				 Values (:lsProject, :lsSku, :lsSerial_no, getdate()) using SQLCA;
				 llNew ++
				//!!!! dts 2/25/14 - this wasn't working as it was using the SKU/Serial as found in the File, not as found in SNI table
				// - moved this to the 8-char sku / 12-char serial block
				// - and only updating if it's an insert (not an update)
				//Jxlim 09/23/2013 Ariens;CR26 Serial Number Scanning
				//When inserting the serial number into sku_serial_hold, 
				//also do an update to serial_number_inventory setting hold_status = $$HEX1$$1820$$ENDHEX$$Y$$HEX2$$19202000$$ENDHEX$$based on Project, SKU and Serial_No (no need to check if it exists. It will just update nothing if it doesn$$HEX1$$1920$$ENDHEX$$t)
				Update Serial_Number_Inventory
				Set Hold_status ='Y'
				Where Project_Id =:lsProject
				And SKU=:lsSku
				And Serial_No= :lsSerial_No using SQLCA;
			If sqlca.sqlcode <> 0 Then
				 lsErrText = sqlca.sqlerrtext /*text will be lost after rollback*/                                                                                                                                      
				 Execute Immediate "ROLLBACK" using SQLCA;
				 Messagebox("Import","Unable to save changes to database!~r~r" + lsErrText)
				 SetPointer(Arrow!)
				 Return -1             
			Else
				Execute Immediate "COMMIT" using SQLCA;    //now inside loop
			End If    
			ELSE //found in Hold Table. Update last_updated field
				 //dts - for performance reasons, not updating for each loop (updating all records at end).  Update Sku_Serial_Hold set last_updated =GetDate() where Project_Id =:lsProject and Sku=:lsSku and Serial_no =:lsSerial_no using SQLCA;
				 llUpdate ++
			//25-Aug-2014 : Madhu- Added code to set Hold_Status=Y on SNI, if record has already exists in SKU_Serial_Hold table- START
				Update Serial_Number_Inventory
				Set Hold_status ='Y'
				Where Project_Id =:lsProject
				And SKU=:lsSku
				And Serial_No= :lsSerial_No using SQLCA;
			END IF
			//25-Aug-2014 : Madhu- Added code to set Hold_Status=Y on SNI, if record has already exists in SKU_Serial_Hold table- END

			/* moved this to be only on an Insert.
			If sqlca.sqlcode <> 0 Then
				 lsErrText = sqlca.sqlerrtext /*text will be lost after rollback*/                                                                                                                                      
				 Execute Immediate "ROLLBACK" using SQLCA;
				 Messagebox("Import","Unable to save changes to database!~r~r" + lsErrText)
				 SetPointer(Arrow!)
				 Return -1             
			Else
				 //dts llnew ++   
			End If    
			*/
	  end if
Next  //next record in HOLD FILE

//stamp the last_updated field with the current date/time. for performance reasons, not updating each record as we loop through
Execute Immediate "Begin Transaction" using SQLCA;
Update Sku_Serial_Hold set last_updated =GetDate() where Project_Id =:lsProject;
Execute Immediate "COMMIT" using SQLCA;

If sqlca.sqlcode <> 0 Then
	MessageBox("Import","Unable to Commit changes! No changes made to Database!")
	Return -1
End If

//dts 2/24/14 moving inside loop Execute Immediate "COMMIT" using SQLCA;    //Stay out of loop
f_method_trace_special(gs_project, this.ClassName() , 'Records Updated: ' + String(llUpdate) + ', Records Added: ' + String(llNew) + ', Records Deleted: ' + String(llDel),'', '','','') 

//MessageBox("Import","Records saved.~r~rRecords Added: " + String(llNew))
MessageBox("Import","Records saved.~r~rRecords Updated: " + String(llUpdate) + "~r~rRecords Added: " + String(llNew) + + "~r~rRecords Deleted: " + String(llDel))
w_main.SetmicroHelp("Ready")
SetPointer(Arrow!)

Return 0

end function

public function string wf_validate (long al_row);//Jxlim 07/18/2013 Delete existing record and load new import file all done in wf_save
//String	lswarehouse,	&
//			lsType, &
//			lssku, lserial_no
//			
//Long llCount
//
////Validate for valid field length and type
//
//// if Currvalcolumn > '' then we didn't validate the whole row, start with the next column
//Choose Case iscurrvalcolumn
//	case "sku"
//		goto lsku	
//	case "serial_no"
//		goto lserial_no		
//End Choose
////
//lsku:
////If len(trim(This.getItemString(al_row,"sku"))) > 50 Then
////	This.Setfocus()
////	This.SetColumn("sku")
////	iscurrvalcolumn = "sku"
////	Return "sku is > 50 digits"
////End If
////
//lssku = This.getItemString(al_row,"sku")
////if isnull(lssku) or lssku = '' Then
////Else
////	Select Count(*)
////	Into :llCount
////	from sku_serial_hold
////	Where sku = :lssku
////	And Project_id = :gs_project
////	Using SQLCA;
////
////	//If llCount <=0 Then
////	If llCount > 0 Then
////		This.Setfocus()
////		This.SetColumn("sku")
////		iscurrvalcolumn = "sku"
////		//Return "SKU is Invalid"
////		Return "Sku record exist"
////	End If
////End If
//
//lserial_no:
//If len(trim(This.getItemString(al_row,"serial_no"))) > 50 Then
//	This.Setfocus()
//	This.SetColumn("serial_no")
//	iscurrvalcolumn = "serial_no"
//	Return "serial_no is > 50 digits"
//End If
//
//lserial_no = This.getItemString(al_row,"serial_no")
//if isnull(lserial_no) or lserial_no = '' Then
//Else
//	Select Count(*)
//	Into :llCount
//	from sku_serial_hold
//	Where sku = :lssku 
//	And serial_no = :lserial_no
//	And Project_id = :gs_project
//	Using SQLCA;
//
//	//If llCount <=0 Then
//	If llCount > 0 Then
//		This.Setfocus()
//		This.SetColumn("serial_no")
//		iscurrvalcolumn = "serial_no"
//		Return "Sku and Serial_No record exist"
//	End If
//End If
//
//iscurrvalcolumn = ''
Return ''

end function

on u_dw_import_skuserialhold.create
call super::create
end on

on u_dw_import_skuserialhold.destroy
call super::destroy
end on

