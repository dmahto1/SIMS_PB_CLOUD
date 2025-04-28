HA$PBExportHeader$u_nvo_ship_documents_3com.sru
$PBExportComments$Print shipping documents for 3COM
forward
global type u_nvo_ship_documents_3com from u_nvo_ship_documents
end type
end forward

global type u_nvo_ship_documents_3com from u_nvo_ship_documents
end type
global u_nvo_ship_documents_3com u_nvo_ship_documents_3com

forward prototypes
public function integer wf_load_documents (ref datawindow adw_shipdocs)
public function integer wf_print (ref datawindow adw_shipdocs)
end prototypes

public function integer wf_load_documents (ref datawindow adw_shipdocs);//Printing Packing List, BOL and Shipping Labels

Long	llNewRow
String	lsPrinter

//PAckList
llNewRow = adw_shipdocs.InsertRow(0)
adw_shipdocs.SetItem(llNewRow,'document','Packing List')
adw_shipdocs.SetItem(llNewRow,'copies',1)

If w_do.idw_PAck.RowCount() > 0 and w_do.idw_Main.RowCount() > 0  Then
	adw_shipdocs.SetItem(llNewRow,'select_ind','Y')
	adw_shipdocs.SetItem(llNewRow,'status','Ready to Print')
	adw_shipdocs.SetItem(llNewRow,'status_flag','R')
Else
	adw_shipdocs.SetItem(llNewRow,'select_ind','N')
	adw_shipdocs.SetItem(llNewRow,'status','Not generated.')
	adw_shipdocs.SetItem(llNewRow,'status_flag','N')
End If

lsPrinter = Trim(ProfileString(gs_iniFile,'PRINTERS','PACKLIST',''))
If lsPrinter > '' Then adw_shipdocs.SetItem(llNewRow,'Printer',lsPrinter)


//BOL
llNewRow = adw_shipdocs.InsertRow(0)
adw_shipdocs.SetItem(llNewRow,'document','BOL/SLI')
adw_shipdocs.SetItem(llNewRow,'copies',1)

If w_do.tab_main.tabpage_bol.dw_bol_prt.RowCount() > 0 and w_do.idw_Main.RowCount() > 0 Then
	adw_shipdocs.SetItem(llNewRow,'select_ind','Y')
	adw_shipdocs.SetItem(llNewRow,'status','Ready to Print')
	adw_shipdocs.SetItem(llNewRow,'status_flag','R')
Else
	adw_shipdocs.SetItem(llNewRow,'select_ind','N')
	adw_shipdocs.SetItem(llNewRow,'status','Not generated.')
	adw_shipdocs.SetItem(llNewRow,'status_flag','N')
End If

lsPrinter = Trim(ProfileString(gs_iniFile,'PRINTERS','BOL',''))
If lsPrinter > '' Then adw_shipdocs.SetItem(llNewRow,'Printer',lsPrinter)


//Shipping Labels
llNewRow = adw_shipdocs.InsertRow(0)
adw_shipdocs.SetItem(llNewRow,'document','Shipping Labels')
adw_shipdocs.SetItem(llNewRow,'copies',1)

If w_do.idw_PAck.RowCount() > 0 and w_do.idw_Main.RowCount() > 0 Then
	adw_shipdocs.SetItem(llNewRow,'select_ind','Y')
	adw_shipdocs.SetItem(llNewRow,'status','Ready to Print')
	adw_shipdocs.SetItem(llNewRow,'status_flag','R')
Else
	adw_shipdocs.SetItem(llNewRow,'select_ind','N')
	adw_shipdocs.SetItem(llNewRow,'status','Not generated.')
	adw_shipdocs.SetItem(llNewRow,'status_flag','N')
End If

lsPrinter = Trim(ProfileString(gs_iniFile,'PRINTERS','SHIPLABEL',''))
If lsPrinter > '' Then adw_shipdocs.SetItem(llNewRow,'Printer',lsPrinter)


REturn 0
end function

public function integer wf_print (ref datawindow adw_shipdocs);Long	llRowCount, llRowPos, llLoopPos
String	lsPrinter
u_nvo_custom_packlists	lu_packlist
U_Nvo_Custom_BOL	lu_BOL

SetPointer(Hourglass!)

adw_shipdocs.AcceptText()
 
g.ibNoPromptPrint = True /* called print routine will not display print dialog box */

//Print each checked document

llRowCount = adw_shipdocs.rowCount()
For llRowPos = 1 to llRowCount
	
	If adw_shipDocs.GetITemString(llRowPos,'select_ind') <> 'Y' Then Continue
	
	Choose Case Upper(adw_shipdocs.GetITemString(llRowPos,'document'))
			
		Case 'PACKING LIST'
			
			lu_packlist = Create u_nvo_custom_packlists
			
			adw_shipdocs.SetItem(llRowPos,'status','PRINTING...')
			adw_shipdocs.SetItem(llRowPos,'status_flag','P')
			
			//Set the printer
			lsPrinter = adw_shipdocs.GetITemString(llRowPos,'Printer')
			If lsPrinter > '' Then PrintSetPrinter(lsPrinter)
						
			//Set The Copies
			g.ilPrintCopies = adw_shipdocs.GetITemNumber(llRowPos,'Copies')
			
			//Print
			lu_packlist.uf_packing_print_3com()
			
			//store printer back to ini file
			lsPrinter = PrintGetPrinter()
			SetProfileString(gs_inifile,'PRINTERS','PACKLIST',lsPrinter)
			
			adw_shipdocs.SetItem(llRowPos,'status','PRINTED')
			adw_shipdocs.SetItem(llRowPos,'status_flag','X')
						
		Case 'BOL/SLI'
			
			adw_shipdocs.SetItem(llRowPos,'status','PRINTING...')
			adw_shipdocs.SetItem(llRowPos,'status_flag','P')
			
			lu_bol = Create u_nvo_Custom_Bol
			
			//Set the printer
			lsPrinter = adw_shipdocs.GetITemString(llRowPos,'Printer')
			If lsPrinter > '' Then PrintSetPrinter(lsPrinter)
			
			//Set The Copies
			g.ilPrintCopies = adw_shipdocs.GetITemNumber(llRowPos,'Copies')
						
			//Print
			lu_bol.uf_print_bol_3com()
			
			//store printer back to ini file
			lsPrinter = PrintGetPrinter()
			SetProfileString(gs_inifile,'PRINTERS','BOL',lsPrinter)
			
			adw_shipdocs.SetItem(llRowPos,'status','PRINTED')
			adw_shipdocs.SetItem(llRowPos,'status_flag','X')
			
		Case 'SHIPPING LABELS'
			
			adw_shipdocs.SetItem(llRowPos,'status','PRINTING...')
			adw_shipdocs.SetItem(llRowPos,'status_flag','P')
			
			//Set the printer
			lsPrinter = adw_shipdocs.GetITemString(llRowPos,'Printer')
			If lsPrinter > '' Then PrintSetPrinter(lsPrinter)
			
			//Set The Copies
			g.ilPrintCopies = adw_shipdocs.GetITemNumber(llRowPos,'Copies')
			
			//Open and hide the Labels Window
			//OpenSheet(w_3com_labels,w_main, gi_menu_pos, Original!)	
			Open(w_3com_labels)
			w_3com_labels.visible=False
						
			//Select All Labels
			w_3com_labels.TriggerEvent('ue_postopen')
			w_3com_labels.cb_selectall.TriggerEvent('clicked')
			
			//Print
			w_3com_labels.cb_Print.TriggerEvent('clicked')
			
			//Close
			w_3com_labels.cb_ok.TriggerEvent('clicked')
			
			//store printer back to ini file
			lsPrinter = PrintGetPrinter()
			SetProfileString(gs_inifile,'PRINTERS','SHIPLABEL',lsPrinter)
			
			adw_shipdocs.SetItem(llRowPos,'status','PRINTED')
			adw_shipdocs.SetItem(llRowPos,'status_flag','X')
			
	End CHoose
	
Next /*document to print*/

g.ibNoPromptPrint = False
g.ilPrintCopies = 1

SetPointer(Arrow!)

Return 0
end function

on u_nvo_ship_documents_3com.create
call super::create
end on

on u_nvo_ship_documents_3com.destroy
call super::destroy
end on

