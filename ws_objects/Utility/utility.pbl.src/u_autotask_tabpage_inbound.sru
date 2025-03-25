$PBExportHeader$u_autotask_tabpage_inbound.sru
forward
global type u_autotask_tabpage_inbound from u_tabpage
end type
end forward

global type u_autotask_tabpage_inbound from u_tabpage
string text = "Inbound"
string picturename = "CheckIn!"
end type
global u_autotask_tabpage_inbound u_autotask_tabpage_inbound

on u_autotask_tabpage_inbound.create
call super::create
end on

on u_autotask_tabpage_inbound.destroy
call super::destroy
end on

