HA$PBExportHeader$w_autotask.srw
forward
global type w_autotask from w
end type
type tab_1 from u_autotask_tab within w_autotask
end type
type tab_1 from u_autotask_tab within w_autotask
end type
end forward

global type w_autotask from w
string title = "AutoTask Utilities"
tab_1 tab_1
end type
global w_autotask w_autotask

on w_autotask.create
int iCurrent
call super::create
this.tab_1=create tab_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tab_1
end on

on w_autotask.destroy
call super::destroy
destroy(this.tab_1)
end on

type tab_1 from u_autotask_tab within w_autotask
integer x = 183
integer y = 160
integer taborder = 30
end type

