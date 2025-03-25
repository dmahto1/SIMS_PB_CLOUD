$PBExportHeader$u_dw_export.sru
$PBExportComments$Generic DW for exporting data
forward
global type u_dw_export from u_dw_ancestor
end type
end forward

global type u_dw_export from u_dw_ancestor
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
event ue_custom_export ( )
event ue_check_enable ( )
event ue_archive ( string aspath,  string asfile )
end type
global u_dw_export u_dw_export

type variables
String	isCurrValColumn, isArchiveFile, isArchivePath
Boolean	ibCustomExport, ibSaveRequired
Long	ilExportCount
Integer	iiFileNo
end variables

forward prototypes
public function integer wf_save ()
public function integer wf_close_file (integer aifileno)
public function long wf_retrieve ()
public function integer wf_export ()
end prototypes

event ue_custom_export;//Custom Export scripts go here - will bypass default tab/comma seperated export
// Used for fixed length, etc. exports
end event

event ue_check_enable;If This.Find("c_export_ind = 'Y'",1,This.RowCount()) = 0 Then
	w_export.cb_export_export.Enabled = False
End If
end event

public function integer wf_save ();
//If we need to update records so that thery are not exported here, Do so
If ibSaveRequired Then
	This.TriggerEvent('ue_save')
	ibSaveRequired = False
End If

Return 0
end function

public function integer wf_close_file (integer aifileno);Integer	liRC

liRC = FileClose(aiFileNo) /*close the file*/
If liRC < 0 Then
	Messagebox('Export','Unable to close export file')
Else
	Messagebox('Export', String(ilExportCOunt) + ' Rows were exported.')
End If


Return 0
end function

public function long wf_retrieve ();Long	llRowCount

llRowCount = This.Retrieve(gs_project)

//we may have some post retrieve functionality
This.TriggerEvent('ue_post_retrieve')

Return	llRowCount
end function

public function integer wf_export ();
String	lsPath,	&
			lsFile,			&
			lsLayout,		&
			lsData,			&
			lsRowData,		&
			lsTemp
		
Long		llColumnCOunt,	&
			llColumnPos,	&
			llRowCount,		&
			llRowPos,		&
			llLimit

Integer	liRC
Str_Parms	lStrParms

ilExportCount = 0

//See if there is a default export file for this layout
lsLayout = w_export.dw_layout_list.getItemString(1,'export_file')
lsPath = ProfileString(gs_inifile,"export",lsLayout,"")

//Get the file name
If GetFileSaveName("Select Export File",lsPath,lsFile,"TXT","Text Files (*.TXT),*.TXT,") <> 1 Then REturn -1

//If the file exists, prompt for Append/Replace
If FIleExists(lsPath) Then
	OpenWithParm(w_export_file_append_replace,lstrParms)
	lstrparms = Message.PowerObjectParm
	If lstrparms.Cancelled Then Return -1
End If /*File Exists*/

//Open the file for export
If UpperBound(lstrparms.String_ARg) > 0 Then /*prompt window was opened*/
	If lstrparms.String_arg[1] = 'R' Then /*Replace existing records*/
		iiFileNo = FileOpen(lsPath,LineMOde!,Write!,LockReadWrite!,Replace!)
	Else /*append*/
		iiFileNo = FileOpen(lsPath,LineMOde!,Write!,LockReadWrite!,Append!)
	End If
Else
	iiFileNo = FileOpen(lsPath,LineMOde!,Write!,LockReadWrite!,Append!) /*default to append - file doesn't esxist anyway*/
End If

If iiFileNo < 0 Then
	Messagebox('Export','Unable to open ' + lspath + ' for exporting.')
	REturn -1
End If

//Loop through and export each row/column
SetPointer(Hourglass!)

//*** If this is not a generic export (tab or comma seperated, the custom export will be defined in the Child script
If Not ibCustomExport Then

	llcolumnCount = Long(This.Object.datawindow.column.Count)
	llRowCount = This.RowCount()

	For llRowPos = 1 to llRowCount
	
		If This.GetItemString(llRowPos,'c_export_ind') <> 'Y' Then Continue /*dont export if unchecked*/
	
			lsRowDAta = ''
				
			For llColumnPos = 2 to llColumnCount /*first column is the export ind - skip*/
				lsData = String(This.object.data[llRowPos,llColumnPos])
				If not isnull(lsDAta) then	lsRowData += '"' + lsData + '"' /*wrap in quotes in case a delimiter is present in the data*/
				If llColumnPos <> llColumnCount Then /*add a tab to all but the last column*/
					If w_export.rb_tab.Checked then
						lsRowData += '~t'
					Else
						lsRowData += ','
					End If
				End If
			Next /*column*/
	
			//Write the row
			FileWrite(iiFileNo,lsRowDAta)
			ilExportCOunt ++
	
	Next /*Next Row*/
	
Else /*process the Custom Export*/
	
	This.TriggerEvent('ue_custom_export')
		
End If  /*Not a Custom Export*/

wf_close_file(iiFileNo)

//Each export may have a custom archive requirements
isArchivePath = lspath
isArchiveFile = lsFile
This.TriggerEvent('ue_archive')

SetPointer(Arrow!)

Return 0
end function

on u_dw_export.create
end on

on u_dw_export.destroy
end on

event itemchanged;call super::itemchanged;
If dwo.name = 'c_export_ind' Then
	If Data = 'Y' Then
		w_export.cb_export_export.Enabled = True
	Else /*see if any other rows are checked*/
		this.PostEvent('ue_check_enable')
	End If
End If
end event

event constructor;call super::constructor;
ibSaveRequired = False
end event

