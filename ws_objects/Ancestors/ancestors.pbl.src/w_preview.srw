$PBExportHeader$w_preview.srw
$PBExportComments$Print Preview Window
forward
global type w_preview from Window
end type
type cb_3 from commandbutton within w_preview
end type
type cb_close from commandbutton within w_preview
end type
type cb_print from commandbutton within w_preview
end type
type em_page from editmask within w_preview
end type
type cb_last from commandbutton within w_preview
end type
type cb_next from commandbutton within w_preview
end type
type cb_2 from commandbutton within w_preview
end type
type cb_1 from commandbutton within w_preview
end type
type em_1 from editmask within w_preview
end type
type dw_1 from datawindow within w_preview
end type
type gb_rows from groupbox within w_preview
end type
type gb_1 from groupbox within w_preview
end type
end forward

global type w_preview from Window
int X=457
int Y=72
int Width=3214
int Height=1816
boolean TitleBar=true
string Title="Report Preview"
long BackColor=79741120
boolean ControlMenu=true
boolean MinBox=true
boolean MaxBox=true
boolean Resizable=true
event ue_zoom ( integer ai_size )
event ue_set_page ( )
cb_3 cb_3
cb_close cb_close
cb_print cb_print
em_page em_page
cb_last cb_last
cb_next cb_next
cb_2 cb_2
cb_1 cb_1
em_1 em_1
dw_1 dw_1
gb_rows gb_rows
gb_1 gb_1
end type
global w_preview w_preview

type variables
int ii_pagecount
end variables

event ue_zoom;dw_1.modify('datawindow.print.preview.zoom = ' + String(ai_size))

end event

event ue_set_page;em_page.text = string(1)

ii_pagecount = integer(dw_1.describe("evaluate('pagecount()',1)"))

em_page.minmax = "1-"+string(ii_pagecount)
end event

event open;string ls_syntax, ls_rc
int    li_rc
str_parms lstrparms

Integer			li_ScreenH, li_ScreenW
Environment	le_Env

lstrparms = Message.PowerObjectParm 

// Center window
GetEnvironment(le_Env)

li_ScreenH = PixelsToUnits(le_Env.ScreenHeight, YPixelsToUnits!)
li_ScreenW = PixelsToUnits(le_Env.ScreenWidth, XPixelsToUnits!)

This.Y = (li_ScreenH - This.Height) / 2
This.X = (li_ScreenW - This.Width) / 2


dw_1.dataobject = string(lstrparms.datawindow_arg[1].dataobject)


li_RC = lstrparms.datawindow_arg[1].ShareData(dw_1)



ls_rc = dw_1.modify("DataWindow.Print.Preview = yes")

This.TriggerEvent("ue_set_Page")



end event

on w_preview.create
this.cb_3=create cb_3
this.cb_close=create cb_close
this.cb_print=create cb_print
this.em_page=create em_page
this.cb_last=create cb_last
this.cb_next=create cb_next
this.cb_2=create cb_2
this.cb_1=create cb_1
this.em_1=create em_1
this.dw_1=create dw_1
this.gb_rows=create gb_rows
this.gb_1=create gb_1
this.Control[]={this.cb_3,&
this.cb_close,&
this.cb_print,&
this.em_page,&
this.cb_last,&
this.cb_next,&
this.cb_2,&
this.cb_1,&
this.em_1,&
this.dw_1,&
this.gb_rows,&
this.gb_1}
end on

on w_preview.destroy
destroy(this.cb_3)
destroy(this.cb_close)
destroy(this.cb_print)
destroy(this.em_page)
destroy(this.cb_last)
destroy(this.cb_next)
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.em_1)
destroy(this.dw_1)
destroy(this.gb_rows)
destroy(this.gb_1)
end on

event resize;dw_1.width = this.width - 60
dw_1.height = this.height - 300
end event

type cb_3 from commandbutton within w_preview
int X=1874
int Y=64
int Width=265
int Height=88
int TabOrder=70
string Text="Setup..."
int TextSize=-8
int Weight=700
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;Printsetup()
end event

type cb_close from commandbutton within w_preview
event clicked pbm_bnclicked
int X=2738
int Y=52
int Width=247
int Height=88
int TabOrder=70
string Text="Close"
int TextSize=-8
int Weight=700
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;close(parent)
end event

type cb_print from commandbutton within w_preview
int X=1490
int Y=64
int Width=247
int Height=88
int TabOrder=60
string Text="Print"
int TextSize=-8
int Weight=700
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;OpenWithParm(w_dw_print_options,dw_1) 
end event

type em_page from editmask within w_preview
event modified pbm_enmodified
int X=910
int Y=68
int Width=165
int Height=88
Alignment Alignment=Center!
BorderStyle BorderStyle=StyleRaised!
string Mask="#####"
boolean AutoSkip=true
string DisplayData="Ä"
boolean DisplayOnly=true
long TextColor=33554432
int TextSize=-8
int Weight=400
string FaceName="MS Sans Serif"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event modified;//parent.event trigger ue_zoom(integer(this.text))

//if integer(this.text) < ii_pagecount THEN
//	dw_1.scrolltopage(integer(this.text))
//end if
end event

type cb_last from commandbutton within w_preview
event clicked pbm_bnclicked
int X=809
int Y=68
int Width=101
int Height=88
int TabOrder=30
string Text="<<<"
int TextSize=-8
int Weight=700
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;if integer(em_page.text) >1 THEN
	em_page.text = string(integer(em_page.text) - 1)
	dw_1.scrollpriorpage()
end if

end event

type cb_next from commandbutton within w_preview
event clicked pbm_bnclicked
int X=1074
int Y=68
int Width=114
int Height=88
int TabOrder=80
string Text=">>>"
int TextSize=-8
int Weight=700
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;if integer(em_page.text) < ii_pagecount THEN
	em_page.text = string(integer(em_page.text) + 1)
	dw_1.scrollnextpage()
end if

end event

type cb_2 from commandbutton within w_preview
int X=494
int Y=68
int Width=105
int Height=88
int TabOrder=40
string Text=">>>"
int TextSize=-8
int Weight=700
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;int li_size

li_size = integer(em_1.text) +10

parent.event trigger ue_zoom(li_size)

em_1.text = string(li_size)
end event

type cb_1 from commandbutton within w_preview
int X=219
int Y=68
int Width=105
int Height=88
int TabOrder=50
string Text="<<<"
int TextSize=-8
int Weight=700
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;int li_size

if integer(em_1.text) > 10 THEN
	li_size = integer(em_1.text) -10

	parent.event trigger ue_zoom(li_size)

	em_1.text = string(li_size)
end if

end event

type em_1 from editmask within w_preview
int X=325
int Y=68
int Width=165
int Height=88
int TabOrder=90
Alignment Alignment=Center!
BorderStyle BorderStyle=StyleRaised!
string Mask="#####"
string DisplayData="l"
string Text="100"
long TextColor=33554432
int TextSize=-8
int Weight=400
string FaceName="MS Sans Serif"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event modified;parent.event trigger ue_zoom(integer(this.text))
end event

type dw_1 from datawindow within w_preview
int X=14
int Y=196
int Width=3127
int Height=1500
int TabOrder=100
BorderStyle BorderStyle=StyleLowered!
boolean HScrollBar=true
boolean VScrollBar=true
boolean LiveScroll=true
end type

type gb_rows from groupbox within w_preview
int X=626
int Y=12
int Width=599
int Height=172
int TabOrder=10
string Text="Pages:"
long TextColor=33554432
long BackColor=79416533
int TextSize=-8
int Weight=700
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type gb_1 from groupbox within w_preview
int X=41
int Y=12
int Width=599
int Height=172
int TabOrder=20
string Text="Zoom:"
long TextColor=33554432
long BackColor=79416533
int TextSize=-8
int Weight=700
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

