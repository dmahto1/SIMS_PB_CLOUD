HA$PBExportHeader$w_download.srw
forward
global type w_download from Window
end type
type st_1 from statictext within w_download
end type
end forward

global type w_download from Window
int X=581
int Y=740
int Width=1422
int Height=304
boolean TitleBar=true
string Title="Downloading ......"
long BackColor=79741120
boolean MinBox=true
WindowType WindowType=popup!
st_1 st_1
end type
global w_download w_download

on w_download.create
this.st_1=create st_1
this.Control[]={this.st_1}
end on

on w_download.destroy
destroy(this.st_1)
end on

event open;Setpointer(HourGlass!)
end event

event activate;g.of_resize(this)
end event

type st_1 from statictext within w_download
int X=27
int Y=28
int Width=1353
int Height=140
boolean Enabled=false
string Text="Please wait downloading the latest version ...."
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=67108864
int TextSize=-10
int Weight=700
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

