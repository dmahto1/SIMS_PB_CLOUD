HA$PBExportHeader$sims3.sra
$PBExportComments$Sims 3.0 Application
forward
global type sims3 from application
end type
global sims_transaction sqlca
global dynamicdescriptionarea sqlda
global dynamicstagingarea sqlsa
global error error
global message message
end forward

global variables
String gs_userid
String gs_company_name
String gs_role
String gs_default_wh
String gs_default_loc
String gs_default_loc2
String gs_damage_loc
String gs_inifile
String gs_syspath
String gs_labelpath
String gs_reportpath
String gs_pdfpath
String gs_project = 'TEST'
String gs_tier_desc = 'CLIENT' //TimA 02/12/15 for the f_Functionality_Manager function
Date today
m_main main_menu
Integer gi_menu_pos = 8
String	gsTitle
n_cst_appmanager g
boolean gb_sqlca_connected, gb_replication_sqlca_connected

//TimA 11/05/12
//Global flag to turn on or off method log tracing
String gs_method_log_flag

// 04/13 - PCONKL - Added Replication Transaction
//Transaction	Replication-SQLCA
Transaction	Replication_SQLCA

//TimA 06/18/13 part of the Pandora License Plate project #608
String gs_ActiveWindow //Sets on the Activate of both inbound and outbound windows to show which is active at the time.  Much like a has focus and lose focus.
String gs_menuitem //05-May-2014 :Madhu- Added to open usermanual upon F1 key

Integer gi_time_interval //07-Apr-2015 Madhu- SIMS Timer Notification Alert Functionality
String gs_Projectlist,gs_Userlist,gs_NotificationFlag,gs_ShutdownFlag,gs_AlertNotes //07-Apr-2015 Madhu- SIMS Timer Notification Alert Functionality
Boolean gbLogin =FALSE //07-Apr-2015 Madhu- SIMS Timer Notification Alert Functionality
string gs_buildVersion //29-Jun-2015 :Madhu- Added to validate QA build against PROD db.

//GailM 06/16/2015 Change to screen height when not showing named fields
Long gl_ScreenHeightChange

//TimA 08/13/15 Global variable to catpure whatever system numbers is for the avtice window.
String gs_system_no
String gbPressKeySNScan //10-Sep-2015 :Madhu- Added to turn ON/OFF PressKey vs SNScan.
String gbPressKeySNScanTransfers //12-Apr-2017 :Madhu- PEV-424 Stock Transfer Serial No.
boolean gbPressF10Unlock =FALSE //10-Sep-2015 :Madhu- Added to capture F10Unlock for Inbound Orders against PressKey vs SNScan.
String gbPressKeyContainerScan //15-Jun-2017 :TAM- PEV-605  Added to turn ON/OFF PressKey vs ContainerScan.

String gs_commodity_authorized_user //01-Jun-2016 Madhu Added for Commodity Authorized User

CONSTANT String gsFootPrintBlankInd = "NA"	//GailM 3/29/2019 Mixed Containerization DE9748
Boolean gbSerialReconcileOnly =FALSE //13-MAY-2019 :Madhu S33404 F15609 Inventory Serial Reconciliation Process
end variables
global type sims3 from application
string appname = "sims3"
string themestylename = "Do Not Use Themes"
long richtextedittype = 2
long richtexteditversion = 1
string richtexteditkey = ""
end type
global sims3 sims3

type prototypes
Function Boolean EncryptString (Ref String lpszString, String lpszKey) Library "EC.DLL" alias for "EncryptString;Ansi"
end prototypes

on sims3.create
appname="sims3"
message=create message
sqlca=create sims_transaction
sqlda=create dynamicdescriptionarea
sqlsa=create dynamicstagingarea
error=create error
end on

on sims3.destroy
destroy(sqlca)
destroy(sqlda)
destroy(sqlsa)
destroy(error)
destroy(message)
end on

event open;
// pvh - 05/01/06  Idle
Idle( 14400 ) // Default 4 hours




g= Create n_cst_appmanager
g.of_init_open()
end event

event systemerror;
//  5/2/00 pconkl - trap system errors instead of bombing!

Open(w_system_error)
end event

event close;destroy g



end event

event idle;// pvh - 05/01/06  Idle
open( w_idle_countdown )


end event

