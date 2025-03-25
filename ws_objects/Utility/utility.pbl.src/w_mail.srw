$PBExportHeader$w_mail.srw
forward
global type w_mail from Window
end type
type cb_1 from commandbutton within w_mail
end type
type st_3 from statictext within w_mail
end type
type mle_1 from multilineedit within w_mail
end type
type st_2 from statictext within w_mail
end type
type sle_mailsubject from singlelineedit within w_mail
end type
type st_1 from statictext within w_mail
end type
type sle_mailto from singlelineedit within w_mail
end type
end forward

global type w_mail from Window
int X=997
int Y=628
int Width=1970
int Height=1312
boolean TitleBar=true
string Title="Mail"
long BackColor=12639424
boolean ControlMenu=true
boolean MinBox=true
WindowType WindowType=popup!
cb_1 cb_1
st_3 st_3
mle_1 mle_1
st_2 st_2
sle_mailsubject sle_mailsubject
st_1 st_1
sle_mailto sle_mailto
end type
global w_mail w_mail

type variables
n_warehouse i_nwarehouse
end variables

on w_mail.create
this.cb_1=create cb_1
this.st_3=create st_3
this.mle_1=create mle_1
this.st_2=create st_2
this.sle_mailsubject=create sle_mailsubject
this.st_1=create st_1
this.sle_mailto=create sle_mailto
this.Control[]={this.cb_1,&
this.st_3,&
this.mle_1,&
this.st_2,&
this.sle_mailsubject,&
this.st_1,&
this.sle_mailto}
end on

on w_mail.destroy
destroy(this.cb_1)
destroy(this.st_3)
destroy(this.mle_1)
destroy(this.st_2)
destroy(this.sle_mailsubject)
destroy(this.st_1)
destroy(this.sle_mailto)
end on

event open;i_nwarehouse = create n_warehouse
end event

event close;destroy n_warehouse
end event

type cb_1 from commandbutton within w_mail
int X=256
int Y=1088
int Width=247
int Height=108
int TabOrder=4
string Text="&Send"
int TextSize=-10
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;Boolean flag

flag=i_nwarehouse.of_sendemail(sle_mailto.text,sle_mailsubject.text, mle_1.text )

If flag then
	MessageBox("Sent", "Your mail has been sent")
Else
	MessageBox("Error", "Error, Your mail can't sent")
End if 	
end event

type st_3 from statictext within w_mail
int X=5
int Y=280
int Width=155
int Height=76
boolean Enabled=false
string Text="Text"
boolean FocusRectangle=false
long TextColor=32768
long BackColor=12639424
int TextSize=-10
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type mle_1 from multilineedit within w_mail
int X=256
int Y=280
int Width=1655
int Height=784
int TabOrder=10
BorderStyle BorderStyle=StyleLowered!
long TextColor=32768
long BackColor=15793151
int TextSize=-8
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_2 from statictext within w_mail
int X=5
int Y=176
int Width=247
int Height=76
boolean Enabled=false
string Text="Subject"
boolean FocusRectangle=false
long TextColor=32768
long BackColor=12639424
int TextSize=-10
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type sle_mailsubject from singlelineedit within w_mail
int X=256
int Y=168
int Width=1655
int Height=92
int TabOrder=30
BorderStyle BorderStyle=StyleLowered!
boolean AutoHScroll=false
long BackColor=15780518
int TextSize=-10
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_1 from statictext within w_mail
int X=5
int Y=72
int Width=142
int Height=76
boolean Enabled=false
string Text="To :"
boolean FocusRectangle=false
long TextColor=32768
long BackColor=12639424
int TextSize=-10
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type sle_mailto from singlelineedit within w_mail
int X=256
int Y=60
int Width=1655
int Height=92
int TabOrder=20
BorderStyle BorderStyle=StyleLowered!
boolean AutoHScroll=false
long BackColor=15780518
int TextSize=-10
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

