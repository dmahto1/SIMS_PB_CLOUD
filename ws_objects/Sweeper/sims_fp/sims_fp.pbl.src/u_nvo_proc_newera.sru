$PBExportHeader$u_nvo_proc_newera.sru
$PBExportComments$Process files for SG-MUSER
forward
global type u_nvo_proc_newera from nonvisualobject
end type
end forward

global type u_nvo_proc_newera from nonvisualobject
end type
global u_nvo_proc_newera u_nvo_proc_newera

type variables

				



end variables

forward prototypes
public function integer uf_process_mww_csv_export (string asproject, string asinifile)
public function integer uf_process_mww_csv_export_mx (string asproject, string asinifile)
end prototypes

public function integer uf_process_mww_csv_export (string asproject, string asinifile);datastore lds_export
string lsFileNamePath //, lsProject
string lslogout

//Process the New Era MWW  CSV Export

//MEA - 12/11

//lsProject = ProfileString(asInifile, 'NEWERA', "project", "")

lsLogOut = "- PROCESSING FUNCTION: New Era MWW INV CSV Report!"
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/


lds_export = create datastore


//mww_inv_0510.csv Report

lds_export.dataobject = "d_new_era_mww_inv_csv_report"
lds_export.SetTransObject(SQLCA)

//0510

lds_export.Retrieve("0510")

//Save to flatfileout

lsFileNamePath = ProfileString(asInifile, "NEW ERA-0510", "ftpfiledirout","") + '\' + "mww_inv_0510.csv"
lds_export.SaveAs ( lsFileNamePath, CSV!,  false )

lsLogOut = "  Created File: " + lsFileNamePath
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/


//Save to Archive

lsFileNamePath = ProfileString(asInifile,  "NEW ERA-0510", "archivedirectory","") + '\' + "mww_inv_0510" + string(today(),"ddmmyyyy") + string(now(), "hhmmss") + ".csv"
lds_export.SaveAs ( lsFileNamePath, CSV!,  false )




//0580

lds_export.Retrieve("0580")

//Save to flatfileout


lsFileNamePath = ProfileString(asInifile, "NEW ERA-0580", "ftpfiledirout","") + '\' + "mww_inv_0580.csv"
lds_export.SaveAs ( lsFileNamePath, CSV!,  false )


lsLogOut = "  Created File: " + lsFileNamePath
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/

//Save to Archive

lsFileNamePath = ProfileString(asInifile, "NEW ERA-0580", "archivedirectory","") + '\' + "mww_inv_0580" + string(today(),"ddmmyyyy") + string(now(), "hhmmss") + ".csv"
lds_export.SaveAs ( lsFileNamePath, CSV!,  false )


////0280
//
//lds_export.Retrieve("0280")
//
////Save to flatfileout
//
//lsFileNamePath = ProfileString(asInifile, "NEW ERA-0280", "ftpfiledirout","") + '\' + "mww_inv_0280.csv"
//lds_export.SaveAs ( lsFileNamePath, CSV!,  false )
//
//
//lsLogOut = "  Created File: " + lsFileNamePath
//gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
//
////Save to Archive
//
//lsFileNamePath = ProfileString(asInifile, "NEW ERA-0280", "archivedirectory","") + '\' + "mww_inv_0280" + string(today(),"ddmmyyyy") + string(now(), "hhmmss") + ".csv"
//lds_export.SaveAs ( lsFileNamePath, CSV!,  false )


//mww_mm_0510.csv Report

lsLogOut = "- PROCESSING FUNCTION: New Era MWW MM CSV Report!"
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/

lds_export.dataobject = "d_new_era_mww_mm_csv_report"
lds_export.SetTransObject(SQLCA)

//0510 Report

lds_export.Retrieve("0510")


//Save to flatfileout

lsFileNamePath = ProfileString(asInifile,  "NEW ERA-0510", "ftpfiledirout","") + '\' + "mww_mm_0510.csv"
lds_export.SaveAs ( lsFileNamePath, CSV!,  false )

lsLogOut = "  Created File: " + lsFileNamePath
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/


//Save to Archive

lsFileNamePath = ProfileString(asInifile, "NEW ERA-0510", "archivedirectory","") + '\' + "mww_mm_0510" + string(today(),"ddmmyyyy") + string(now(), "hhmmss") + ".csv"
lds_export.SaveAs ( lsFileNamePath, CSV!,  false )



//0580 Report

lds_export.Retrieve("0580")


//Save to flatfileout

lsFileNamePath = ProfileString( asInifile, "NEW ERA-0580", "ftpfiledirout","") + '\' + "mww_mm_0580.csv"
lds_export.SaveAs ( lsFileNamePath, CSV!,  false )

//Save to Archive

lsFileNamePath = ProfileString(asInifile, "NEW ERA-0580", "archivedirectory","") + '\' + "mww_mm_0580" + string(today(),"ddmmyyyy") + string(now(), "hhmmss") + ".csv"
lds_export.SaveAs ( lsFileNamePath, CSV!,  false )

lsLogOut = "  Created File: " + lsFileNamePath
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/


////0280 Report
//
//lds_export.Retrieve("0280")
//
//
////Save to flatfileout
//
//lsFileNamePath = ProfileString(asInifile,  "NEW ERA-0280", "ftpfiledirout","") + '\' + "mww_mm_0280.csv"
//lds_export.SaveAs ( lsFileNamePath, CSV!,  false )
//
//lsLogOut = "  Created File: " + lsFileNamePath
//gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
//
//
////Save to Archive
//
//lsFileNamePath = ProfileString(asInifile, "NEW ERA-0280", "archivedirectory","") + '\' + "mww_mm_0280" + string(today(),"ddmmyyyy") + string(now(), "hhmmss") + ".csv"
//lds_export.SaveAs ( lsFileNamePath, CSV!,  false )

Return 0
end function

public function integer uf_process_mww_csv_export_mx (string asproject, string asinifile);datastore lds_export
string lsFileNamePath //, lsProject
string lslogout

//Process the New Era MWW  CSV Export

//MEA - 12/11

//lsProject = ProfileString(asInifile, 'NEWERA', "project", "")

lsLogOut = "- PROCESSING FUNCTION: New Era MWW INV CSV Report!"
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/


lds_export = create datastore


//mww_inv_0510.csv Report

lds_export.dataobject = "d_new_era_mww_inv_csv_report_mx"
lds_export.SetTransObject(SQLCA)

////0510
//
//lds_export.Retrieve("0510")
//
////Save to flatfileout
//
//lsFileNamePath = ProfileString(asInifile, "NEW ERA-0510", "ftpfiledirout","") + '\' + "mww_inv_0510.csv"
//lds_export.SaveAs ( lsFileNamePath, CSV!,  false )
//
//lsLogOut = "  Created File: " + lsFileNamePath
//gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
//
//
////Save to Archive
//
//lsFileNamePath = ProfileString(asInifile,  "NEW ERA-0510", "archivedirectory","") + '\' + "mww_inv_0510" + string(today(),"ddmmyyyy") + string(now(), "hhmmss") + ".csv"
//lds_export.SaveAs ( lsFileNamePath, CSV!,  false )
//
//
//
//
////0580
//
//lds_export.Retrieve("0580")
//
////Save to flatfileout
//
//
//lsFileNamePath = ProfileString(asInifile, "NEW ERA-0580", "ftpfiledirout","") + '\' + "mww_inv_0580.csv"
//lds_export.SaveAs ( lsFileNamePath, CSV!,  false )
//
//
//lsLogOut = "  Created File: " + lsFileNamePath
//gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
//
////Save to Archive
//
//lsFileNamePath = ProfileString(asInifile, "NEW ERA-0580", "archivedirectory","") + '\' + "mww_inv_0580" + string(today(),"ddmmyyyy") + string(now(), "hhmmss") + ".csv"
//lds_export.SaveAs ( lsFileNamePath, CSV!,  false )


//0280

lds_export.Retrieve() //"0280"

//Save to flatfileout

lsFileNamePath = ProfileString(asInifile, "NEW ERA-0280", "ftpfiledirout","") + '\' + "mww_inv_0280.csv"
lds_export.SaveAs ( lsFileNamePath, CSV!,  false )


lsLogOut = "  Created File: " + lsFileNamePath
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/

//Save to Archive

lsFileNamePath = ProfileString(asInifile, "NEW ERA-0280", "archivedirectory","") + '\' + "mww_inv_0280" + string(today(),"ddmmyyyy") + string(now(), "hhmmss") + ".csv"
lds_export.SaveAs ( lsFileNamePath, CSV!,  false )


//mww_mm_0510.csv Report

lsLogOut = "- PROCESSING FUNCTION: New Era MWW MM CSV Report!"
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/

lds_export.dataobject = "d_new_era_mww_mm_csv_report_mx"
lds_export.SetTransObject(SQLCA)

////0510 Report
//
//lds_export.Retrieve("0510")
//
//
////Save to flatfileout
//
//lsFileNamePath = ProfileString(asInifile,  "NEW ERA-0510", "ftpfiledirout","") + '\' + "mww_mm_0510.csv"
//lds_export.SaveAs ( lsFileNamePath, CSV!,  false )
//
//lsLogOut = "  Created File: " + lsFileNamePath
//gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
//
//
////Save to Archive
//
//lsFileNamePath = ProfileString(asInifile, "NEW ERA-0510", "archivedirectory","") + '\' + "mww_mm_0510" + string(today(),"ddmmyyyy") + string(now(), "hhmmss") + ".csv"
//lds_export.SaveAs ( lsFileNamePath, CSV!,  false )
//
//
//
////0580 Report
//
//lds_export.Retrieve("0580")
//
//
////Save to flatfileout
//
//lsFileNamePath = ProfileString( asInifile, "NEW ERA-0580", "ftpfiledirout","") + '\' + "mww_mm_0580.csv"
//lds_export.SaveAs ( lsFileNamePath, CSV!,  false )
//
////Save to Archive
//
//lsFileNamePath = ProfileString(asInifile, "NEW ERA-0580", "archivedirectory","") + '\' + "mww_mm_0580" + string(today(),"ddmmyyyy") + string(now(), "hhmmss") + ".csv"
//lds_export.SaveAs ( lsFileNamePath, CSV!,  false )
//
//lsLogOut = "  Created File: " + lsFileNamePath
//gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/


//0280 Report

lds_export.Retrieve()  //"0280"


//Save to flatfileout

lsFileNamePath = ProfileString(asInifile,  "NEW ERA-0280", "ftpfiledirout","") + '\' + "mww_mm_0280.csv"
lds_export.SaveAs ( lsFileNamePath, CSV!,  false )

lsLogOut = "  Created File: " + lsFileNamePath
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/


//Save to Archive

lsFileNamePath = ProfileString(asInifile, "NEW ERA-0280", "archivedirectory","") + '\' + "mww_mm_0280" + string(today(),"ddmmyyyy") + string(now(), "hhmmss") + ".csv"
lds_export.SaveAs ( lsFileNamePath, CSV!,  false )

Return 0
end function

on u_nvo_proc_newera.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_nvo_proc_newera.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

