HA$PBExportHeader$w_printzoom.srw
forward
global type w_printzoom from Window
end type
type em_custom from editmask within w_printzoom
end type
type pb_cancel_preview from picturebutton within w_printzoom
end type
type cbx_rulers from checkbox within w_printzoom
end type
type st_percent from statictext within w_printzoom
end type
type cb_ok from commandbutton within w_printzoom
end type
type cb_cancel from commandbutton within w_printzoom
end type
type rb_custom from radiobutton within w_printzoom
end type
type rb_30 from radiobutton within w_printzoom
end type
type rb_65 from radiobutton within w_printzoom
end type
type rb_100 from radiobutton within w_printzoom
end type
type rb_200 from radiobutton within w_printzoom
end type
type gb_1 from groupbox within w_printzoom
end type
end forward

global type w_printzoom from Window
int X=827
int Y=528
int Width=1221
int Height=720
boolean TitleBar=true
string Title="Print Preview"
long BackColor=12632256
WindowType WindowType=response!
em_custom em_custom
pb_cancel_preview pb_cancel_preview
cbx_rulers cbx_rulers
st_percent st_percent
cb_ok cb_ok
cb_cancel cb_cancel
rb_custom rb_custom
rb_30 rb_30
rb_65 rb_65
rb_100 rb_100
rb_200 rb_200
gb_1 gb_1
end type
global w_printzoom w_printzoom

type variables
//int ii_zoom
datawindow idw_dw
end variables

event open;string tmp

idw_dw = message.powerobjectparm

tmp = idw_dw.describe('DataWindow.Print.Preview DataWindow.Print.Preview.rulers DataWindow.Print.Preview.Zoom')
pb_cancel_preview.enabled = ('yes' = f_get_token(tmp,'~n'))
cbx_rulers.checked = ('yes' = f_get_token(tmp,'~n'))
choose case tmp

	case '200'
		rb_200.checked = true
		rb_200.triggerevent(clicked!)

	case '100'
		rb_100.checked = true
		rb_100.triggerevent(clicked!)

	case '65'
		rb_65.checked = true
		rb_65.triggerevent(clicked!)

	case '30'
		rb_30.checked = true
		rb_30.triggerevent(clicked!)

	case else
		rb_custom.checked = true
		em_custom.text = tmp

end choose

end event

on w_printzoom.create
this.em_custom=create em_custom
this.pb_cancel_preview=create pb_cancel_preview
this.cbx_rulers=create cbx_rulers
this.st_percent=create st_percent
this.cb_ok=create cb_ok
this.cb_cancel=create cb_cancel
this.rb_custom=create rb_custom
this.rb_30=create rb_30
this.rb_65=create rb_65
this.rb_100=create rb_100
this.rb_200=create rb_200
this.gb_1=create gb_1
this.Control[]={this.em_custom,&
this.pb_cancel_preview,&
this.cbx_rulers,&
this.st_percent,&
this.cb_ok,&
this.cb_cancel,&
this.rb_custom,&
this.rb_30,&
this.rb_65,&
this.rb_100,&
this.rb_200,&
this.gb_1}
end on

on w_printzoom.destroy
destroy(this.em_custom)
destroy(this.pb_cancel_preview)
destroy(this.cbx_rulers)
destroy(this.st_percent)
destroy(this.cb_ok)
destroy(this.cb_cancel)
destroy(this.rb_custom)
destroy(this.rb_30)
destroy(this.rb_65)
destroy(this.rb_100)
destroy(this.rb_200)
destroy(this.gb_1)
end on

type em_custom from editmask within w_printzoom
event spun pbm_enchange
int X=416
int Y=452
int Width=233
int Height=88
int TabOrder=30
BorderStyle BorderStyle=StyleLowered!
string Mask="####"
boolean Spin=true
double Increment=5
string MinMax="1~~1000"
string Text="50"
long BackColor=16777215
int TextSize=-8
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

on spun;rb_custom.checked = true

end on

type pb_cancel_preview from picturebutton within w_printzoom
int X=855
int Y=264
int Width=283
int Height=212
int TabOrder=50
string Text="Cancel &Preview Mode"
VTextAlign VTextAlign=MultiLine!
int TextSize=-9
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;string tmp
tmp = "DataWindow.Print.Preview = no"
setpointer(hourglass!)
idw_dw.modify(tmp)
close ( parent )	 
end event

type cbx_rulers from checkbox within w_printzoom
int X=754
int Y=516
int Width=453
int Height=72
int TabOrder=40
string Text="Show Rulers"
BorderStyle BorderStyle=StyleLowered!
long BackColor=12632256
int TextSize=-9
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_percent from statictext within w_printzoom
int X=640
int Y=460
int Width=59
int Height=72
boolean Enabled=false
string Text="%"
Alignment Alignment=Right!
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=12632256
int TextSize=-9
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type cb_ok from commandbutton within w_printzoom
int X=855
int Y=32
int Width=283
int Height=96
int TabOrder=20
string Text="OK"
boolean Default=true
int TextSize=-9
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;string tmp

tmp = "DataWindow.Print.Preview.Zoom="+em_custom.text+" DataWindow.Print.Preview = yes DataWindow.Print.Preview.rulers = "
if cbx_rulers.checked then 
	tmp = tmp + "yes"
else
	tmp = tmp + 'no'
end if
setpointer(hourglass!)
idw_dw.modify(tmp)
close ( parent )	 
end event

type cb_cancel from commandbutton within w_printzoom
int X=855
int Y=148
int Width=283
int Height=96
int TabOrder=60
string Text="Cancel"
boolean Cancel=true
int TextSize=-9
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

on clicked;close ( parent)
end on

type rb_custom from radiobutton within w_printzoom
int X=101
int Y=460
int Width=338
int Height=72
string Text=" C&ustom"
BorderStyle BorderStyle=StyleLowered!
boolean Checked=true
long BackColor=12632256
int TextSize=-9
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

on clicked;em_custom.setfocus()
end on

type rb_30 from radiobutton within w_printzoom
int X=101
int Y=372
int Width=256
int Height=72
string Text=" &30 %"
BorderStyle BorderStyle=StyleLowered!
long BackColor=12632256
int TextSize=-9
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

on clicked;em_custom.text = '30'
end on

type rb_65 from radiobutton within w_printzoom
int X=101
int Y=284
int Width=256
int Height=72
string Text=" &65 %"
BorderStyle BorderStyle=StyleLowered!
long BackColor=12632256
int TextSize=-9
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

on clicked;em_custom.text = '65'
end on

type rb_100 from radiobutton within w_printzoom
int X=101
int Y=196
int Width=288
int Height=72
string Text="&100 %"
BorderStyle BorderStyle=StyleLowered!
long BackColor=12632256
int TextSize=-9
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

on clicked;em_custom.text = '100'
end on

type rb_200 from radiobutton within w_printzoom
int X=101
int Y=108
int Width=274
int Height=72
string Text="&200 %"
BorderStyle BorderStyle=StyleLowered!
long BackColor=12632256
int TextSize=-9
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

on clicked;em_custom.text = '200'

end on

type gb_1 from groupbox within w_printzoom
int X=41
int Y=32
int Width=686
int Height=552
int TabOrder=10
string Text="Magnification"
BorderStyle BorderStyle=StyleLowered!
long BackColor=12632256
int TextSize=-9
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

