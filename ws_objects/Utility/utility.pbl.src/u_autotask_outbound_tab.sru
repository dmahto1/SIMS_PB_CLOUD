$PBExportHeader$u_autotask_outbound_tab.sru
forward
global type u_autotask_outbound_tab from u_tab
end type
end forward

global type u_autotask_outbound_tab from u_tab
integer width = 2514
integer height = 1756
end type
global u_autotask_outbound_tab u_autotask_outbound_tab

event constructor;call super::constructor;// Open the tab pages.
opentab(u_autotask_outbound_tabpage_reconfirm, 1)
opentab(u_autotask_outbound_tabpage_nulllottables, 2)
end event

