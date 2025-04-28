HA$PBExportHeader$u_autotask_tab.sru
forward
global type u_autotask_tab from u_tab
end type
end forward

global type u_autotask_tab from u_tab
integer width = 2514
integer height = 1756
end type
global u_autotask_tab u_autotask_tab

event constructor;call super::constructor;// Open the tab pages.
opentab(u_autotask_tabpage_inbound, 1)
opentab(u_autotask_tabpage_outbound, 2)
opentab(u_autotask_tabpage_customer, 3)
opentab(u_autotask_tabpage_notes, 4)
end event

