HA$PBExportHeader$n_cst_resizeattrib.sru
forward
global type n_cst_resizeattrib from n_base
end type
end forward

global type n_cst_resizeattrib from n_base autoinstantiate
end type

type variables
Public:
graphicobject		wo_control
string		s_classname
string		s_typeof
boolean		b_scale
boolean		b_movex
boolean		b_movey
boolean		b_scalewidth
boolean		b_scaleheight
real		r_x
real		r_y
real		r_width
real		r_height
integer		i_widthmin
integer		i_heightmin
integer		i_movex
integer		i_movey
integer		i_scalewidth
integer		i_scaleheight
end variables

on n_cst_resizeattrib.create
call super::create
end on

on n_cst_resizeattrib.destroy
call super::destroy
end on

