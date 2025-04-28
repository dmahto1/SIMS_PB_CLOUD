HA$PBExportHeader$u_autotask_tabpage_outbound.sru
forward
global type u_autotask_tabpage_outbound from u_tabpage
end type
type tab_1 from u_autotask_outbound_tab within u_autotask_tabpage_outbound
end type
type tab_1 from u_autotask_outbound_tab within u_autotask_tabpage_outbound
end type
end forward

global type u_autotask_tabpage_outbound from u_tabpage
integer width = 1819
integer height = 1260
string text = "Outbound"
string picturename = "CheckOut!"
tab_1 tab_1
end type
global u_autotask_tabpage_outbound u_autotask_tabpage_outbound

on u_autotask_tabpage_outbound.create
int iCurrent
call super::create
this.tab_1=create tab_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tab_1
end on

on u_autotask_tabpage_outbound.destroy
call super::destroy
destroy(this.tab_1)
end on

type tab_1 from u_autotask_outbound_tab within u_autotask_tabpage_outbound
integer taborder = 20
end type

