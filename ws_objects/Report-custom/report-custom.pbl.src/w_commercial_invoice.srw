$PBExportHeader$w_commercial_invoice.srw
forward
global type w_commercial_invoice from window
end type
type lb_pdf_list from listbox within w_commercial_invoice
end type
type ole_web_browser from olecustomcontrol within w_commercial_invoice
end type
end forward

global type w_commercial_invoice from window
boolean visible = false
integer width = 553
integer height = 464
boolean titlebar = true
string title = "Commercial Invoice"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
windowtype windowtype = child!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
lb_pdf_list lb_pdf_list
ole_web_browser ole_web_browser
end type
global w_commercial_invoice w_commercial_invoice

type variables
boolean ib_visible
dec id_ole_pct = .95
end variables

event open;ib_visible = f_retrieve_parm(gs_Project, "CI", "VISIBLE") = "Y"
if ib_visible then
	this.visible = true
	this.width = 4100
	this.height = 2200
	ole_web_browser.width = (this.width * id_ole_pct)
	ole_web_browser.height = (this.height * id_ole_pct)
end if

String ls_do_no, ls_encoded_ci, ls_response_error, ls_ci, ls_pdf_file_created, ls_retrieved_ind
Blob lb_work
n_cryptoapi ln_crypto  

if IsValid(w_do) then
	ls_do_no = w_do.is_dono
end if
if IsNull(ls_do_no) or Len(Trim(ls_do_no)) = 0 then
	MessageBox("Error", "An order must be retrieved in the Delivery Order Window in order to retrieve a Commercial Invoice.", StopSign!)
	close(this)
	Return -1
end if

SELECT Invoice_Encoded, Response_Error, Retrieved_Ind
INTO :ls_encoded_ci, :ls_response_error, :ls_retrieved_ind
FROM Commercial_Invoice
WHERE project_id = :gs_Project 
AND do_no = :ls_do_no
USING SQLCA;

if SQLCA.sqlcode <> 0 then
	MessageBox('Data Unavailable', 'Commercial Invoice has not been generated for System Number:  ' + ls_do_no)
	close(this)
	Return -1
end if

if IsNull(ls_retrieved_ind) or (Upper(Trim(ls_retrieved_ind)) <> 'Y')  then
	UPDATE Commercial_Invoice
	SET Retrieved_Ind = 'Y'
	WHERE project_id = :gs_Project 
	AND do_no = :ls_do_no
	USING SQLCA;

	if sqlca.sqlcode <> 0 then
		Messagebox('ERROR', "Unable to update Commercial_Invoice.Retrieved_Ind = 'Y' for do_no = "  +ls_do_no + ".  Please call support.")
		close(this)
		return
	end if
end if

if NOT(IsNull(ls_response_error)) and Len(ls_response_error) > 0 then

	MessageBox('ERROR', "The following error(s) were encountered retrieving the Commercial Invoice.  " + &
		"Please resolve the error condition(s) and generate the Commercial Invoice once again.  ~r~rError(s):  " + ls_response_error)
	close(this)
	Return -1
else
	if IsNull(ls_encoded_ci) or Len(Trim(ls_encoded_ci)) = 0 then
		MessageBox('ERROR', 'The retrieved Commercial Invoice was erroneous for System Number: ' + ls_do_no + &
		"~r~rPlease attempt to regenerate the Commercial Invoice.")
		close(this)
		Return -1
	end if

	if NOT(IsNull(ls_encoded_ci)) and Len(Trim(ls_encoded_ci)) > 0 then
		// call the decode function
		ls_pdf_file_created = "CI-" + ls_do_no + ".pdf"
		lb_work = ln_crypto.of_decode64(ls_encoded_ci)
		ls_ci = String( lb_work, EncodingANSI! )

		int li_file_no
		li_file_no = FileOpen ( ls_pdf_file_created, StreamMode!, Write!, LockWrite!, Replace!)
		//FileWriteEx(li_file_no, ls_ci)
		FileWriteEx(li_file_no, lb_work)
		FileClose(li_file_no)
	
		ole_web_browser.Object.Navigate(GetCurrentDirectory() + "\" + ls_pdf_file_created)
		
	end if
end if

// Delete previously viewed (old) PDF files
lb_pdf_list.DirList("CI-*.pdf",0)

String ls_file_name
int i, li_total_files
li_total_files = lb_pdf_list.TotalItems()

for i = 1 to li_total_files
	ls_file_name = lb_pdf_list.Text( i )
	if Len(ls_file_name) > 0 and Pos(ls_file_name, ".pdf") > 0 then
		if ls_file_name <> ls_pdf_file_created then
			FileDelete(ls_file_name)
		end if
	end if
next

if NOT ib_visible then
	close(this)
end if

end event

on w_commercial_invoice.create
this.lb_pdf_list=create lb_pdf_list
this.ole_web_browser=create ole_web_browser
this.Control[]={this.lb_pdf_list,&
this.ole_web_browser}
end on

on w_commercial_invoice.destroy
destroy(this.lb_pdf_list)
destroy(this.ole_web_browser)
end on

event resize;if IsValid(ole_web_browser) then
	ole_web_browser.width = newwidth * id_ole_pct
	ole_web_browser.height = newheight * id_ole_pct
end if
end event

type lb_pdf_list from listbox within w_commercial_invoice
boolean visible = false
integer x = 210
integer y = 44
integer width = 590
integer height = 428
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type ole_web_browser from olecustomcontrol within w_commercial_invoice
event statustextchange ( string text )
event progresschange ( long progress,  long progressmax )
event commandstatechange ( long command,  boolean enable )
event downloadbegin ( )
event downloadcomplete ( )
event titlechange ( string text )
event propertychange ( string szproperty )
event beforenavigate2 ( oleobject pdisp,  any url,  any flags,  any targetframename,  any postdata,  any headers,  ref boolean cancel )
event newwindow2 ( ref oleobject ppdisp,  ref boolean cancel )
event navigatecomplete2 ( oleobject pdisp,  any url )
event documentcomplete ( oleobject pdisp,  any url )
event onquit ( )
event onvisible ( boolean ocx_visible )
event ontoolbar ( boolean toolbar )
event onmenubar ( boolean menubar )
event onstatusbar ( boolean statusbar )
event onfullscreen ( boolean fullscreen )
event ontheatermode ( boolean theatermode )
event windowsetresizable ( boolean resizable )
event windowsetleft ( long left )
event windowsettop ( long top )
event windowsetwidth ( long ocx_width )
event windowsetheight ( long ocx_height )
event windowclosing ( boolean ischildwindow,  ref boolean cancel )
event clienttohostwindow ( ref long cx,  ref long cy )
event setsecurelockicon ( long securelockicon )
event filedownload ( boolean activedocument,  ref boolean cancel )
event navigateerror ( oleobject pdisp,  any url,  any frame,  any statuscode,  ref boolean cancel )
event printtemplateinstantiation ( oleobject pdisp )
event printtemplateteardown ( oleobject pdisp )
event updatepagestatus ( oleobject pdisp,  any npage,  any fdone )
event privacyimpactedstatechange ( boolean bimpacted )
event setphishingfilterstatus ( long phishingfilterstatus )
event newprocess ( long lcauseflag,  oleobject pwb2,  ref boolean cancel )
event redirectxdomainblocked ( oleobject pdisp,  any starturl,  any redirecturl,  any frame,  any statuscode )
integer width = 494
integer height = 336
integer taborder = 10
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
string binarykey = "w_commercial_invoice.win"
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
end type


Start of PowerBuilder Binary Data Section : Do NOT Edit
05w_commercial_invoice.bin 
2B00000a00e011cfd0e11ab1a1000000000000000000000000000000000003003e0009fffe000000060000000000000000000000010000000100000000000010000000000200000001fffffffe0000000000000000fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffdfffffffefffffffefffffffeffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff006f00520074006f004500200074006e00790072000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000050016ffffffffffffffff0000000100000000000000000000000000000000000000000000000000000000a99dd8e001cf497100000003000001800000000000500003004f0042005800430054005300450052004d0041000000000000000000000000000000000000000000000000000000000000000000000000000000000102001affffffff00000002ffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000000000009c00000000004200500043004f00530058004f00540041005200450047000000000000000000000000000000000000000000000000000000000000000000000000000000000001001affffffffffffffff000000038856f96111d0340ac0006ba9a205d74f00000000a99dd8e001cf4971a99dd8e001cf4971000000000000000000000000004f00430054004e004e00450053005400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001020012ffffffffffffffffffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000030000009c000000000000000100000002fffffffe0000000400000005fffffffeffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
2Affffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff0000004c00000b2a000008af0000000000000000000000000000000000000000000000000000004c0000000000000000000000010057d0e011cf3573000869ae62122e2b00000008000000000000004c0002140100000000000000c0460000000000008000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004c00000b2a000008af0000000000000000000000000000000000000000000000000000004c0000000000000000000000010057d0e011cf3573000869ae62122e2b00000008000000000000004c0002140100000000000000c0460000000000008000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
15w_commercial_invoice.bin 
End of PowerBuilder Binary Data Section : No Source Expected After This Point
