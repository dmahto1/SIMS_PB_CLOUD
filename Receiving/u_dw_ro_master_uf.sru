HA$PBExportHeader$u_dw_ro_master_uf.sru
forward
global type u_dw_ro_master_uf from u_dw_ancestor
end type
end forward

global type u_dw_ro_master_uf from u_dw_ancestor
integer width = 3538
integer height = 668
string dataobject = "d_ro_master_uf"
end type
global u_dw_ro_master_uf u_dw_ro_master_uf

on u_dw_ro_master_uf.create
call super::create
end on

on u_dw_ro_master_uf.destroy
call super::destroy
end on

