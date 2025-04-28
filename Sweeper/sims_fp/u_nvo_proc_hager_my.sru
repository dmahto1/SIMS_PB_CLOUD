HA$PBExportHeader$u_nvo_proc_hager_my.sru
$PBExportComments$Hager MY
forward
global type u_nvo_proc_hager_my from nonvisualobject
end type
end forward

global type u_nvo_proc_hager_my from nonvisualobject
end type
global u_nvo_proc_hager_my u_nvo_proc_hager_my

type variables


				



end variables

forward prototypes
public function integer uf_process_files (string asproject, string aspath, string asfile, string asinifile)
public function integer uf_process_boh (string asinifile, string asemail)
end prototypes

public function integer uf_process_files (string asproject, string aspath, string asfile, string asinifile);
Return 0
end function

public function integer uf_process_boh (string asinifile, string asemail);
//Process the Daily Balance on Hand Report

String			sql_syntax, ERRORS, lsLogOut, lsOutString, lsFileName, lsWarehouseSave, lsfilenamepath
Long			llRowPos, llRowCount, llNewRow
Int				liRC
Datastore	ldsBOH, ldsOut
Date			ldToday


ldToday = Today()

lsLogOut = "      Creating Hager-MY Daily Balance on Hand-Volume File... " 
FileWrite(gilogFileNo,lsLogOut)


ldsboh = Create Datastore

sql_syntax = "Select Content_Summary.Project_ID, Content_Summary.wh_code, wh_name, content_summary.supp_code as 'supp_code', content_summary.sku as 'SKU', Description, Alternate_Sku, Inventory_type.Inv_type_Desc, 'HAGER MY' as 'project_name', "
sql_syntax += "Sum(avail_qty) as 'avail_qty', Sum(Alloc_Qty) as 'Alloc_Qty', Sum(sit_qty) as 'SIT Qty', Sum(wip_qty) as 'WIP_Qty' "
sql_syntax += " From Content_Summary, Item_Master, Warehouse, Inventory_type "
sql_syntax += " Where Content_Summary.Project_ID = 'HAGER-MY' "
sql_syntax += " and Content_Summary.Project_id = Item_Master.Project_id and Content_Summary.SKU = Item_Master.SKU and Content_Summary.Supp_Code = Item_Master.Supp_Code "
sql_syntax += " and Content_Summary.wh_code = Warehouse.wh_Code "
sql_syntax += " and Content_Summary.Project_id = Inventory_Type.Project_id and Content_Summary.Inventory_type = Inventory_Type.inv_type "
sql_syntax += " Group By Content_Summary.Project_ID, Content_Summary.wh_code, wh_name, content_summary.supp_code, content_summary.sku, Description, Alternate_Sku, Inventory_type.Inv_type_Desc "

ldsboh.Create(SQLCA.SyntaxFromSQL(sql_syntax,"", ERRORS))

IF Len(ERRORS) > 0 THEN
 	 lsLogOut = "        *** Unable to create datastore for Hager BOH data.~r~r" + Errors
	FileWrite(gilogFileNo,lsLogOut)
 	 RETURN - 1
END IF

lirc = ldsboh.SetTransobject(sqlca)

lLRowCount = ldsBoh.Retrieve()


lsLogOut = "    - " + String(lLRowCount) + " inventory records retrieved for  processing..."
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/

/* Now SAVE  it so we can attach the file to email. */
lsFileName = 'Hager-MY_BOH_' + String(DateTime( today(), now()), "yyyymmddhhmm") + '.XLS'
lsFileNamePath = ProfileString(asInifile, 'HAGER-MY', "archivedirectory","") + '\' + lsFileName

ldsboh.SaveAs ( lsFileNamePath, Excel!	, true )

gu_nvo_process_files.uf_send_email("HAGER-MY", asEmail, "Hager-MY BOH  -Run on " + string(Today(), 'YYYY/MM/DD HH:MM') + ' GMT', "Attached is the Hager-MY BOH  -Run on " + string(Today(), 'YYYY/MM/DD HH:MM') + ' GMT', lsFileNamePath)

		

REturn 0
end function

on u_nvo_proc_hager_my.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_nvo_proc_hager_my.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

