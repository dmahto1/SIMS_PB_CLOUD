$PBExportHeader$w_edit_warehouse_address.srw
forward
global type w_edit_warehouse_address from w_response_ancestor
end type
type dw_1 from datawindow within w_edit_warehouse_address
end type
end forward

global type w_edit_warehouse_address from w_response_ancestor
integer height = 720
string title = "Edit Warehouse Address"
dw_1 dw_1
end type
global w_edit_warehouse_address w_edit_warehouse_address

on w_edit_warehouse_address.create
int iCurrent
call super::create
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
end on

on w_edit_warehouse_address.destroy
call super::destroy
destroy(this.dw_1)
end on

event ue_postopen;call super::ue_postopen;istrparms = message.powerobjectparm

long theRow

theRow = dw_1.insertrow(0)
dw_1.object.name[ theRow  ]			=	istrparms.string_arg[1] 
dw_1.object.address1[ theRow  ]		=	istrparms.string_arg[2] 
dw_1.object.address2[ theRow  ]		=	istrparms.string_arg[3] 
dw_1.object.address3[ theRow  ]		=	istrparms.string_arg[4] 
dw_1.object.address4[ theRow  ]		=	istrparms.string_arg[5] 
dw_1.object.city[ theRow  ]				=	istrparms.string_arg[6] 
dw_1.object.state[ theRow  ]			=	istrparms.string_arg[7] 
dw_1.object.zip[ theRow  ]				=	istrparms.string_arg[8] 
dw_1.setfocus()


end event

event ue_close;// override ancestor

long theRow

theRow = dw_1.getrow()

dw_1.accepttext()

istrparms.string_arg[1] =	     dw_1.object.name[ theRow  ]	
istrparms.string_arg[2] =	     dw_1.object.address1[ theRow  ]
istrparms.string_arg[3] =	     dw_1.object.address2[ theRow  ]
istrparms.string_arg[4] =	     dw_1.object.address3[ theRow  ]
istrparms.string_arg[5] =	     dw_1.object.address4[ theRow  ]
istrparms.string_arg[6] =	     dw_1.object.city[ theRow  ]		
istrparms.string_arg[7] =	     dw_1.object.state[ theRow  ]		
istrparms.string_arg[8] =	     dw_1.object.zip[ theRow  ]		

closewithreturn( this, istrparms )


end event

event ue_cancel;Istrparms.Cancelled = True
CloseWithReturn(This, istrparms )
end event

type cb_cancel from w_response_ancestor`cb_cancel within w_edit_warehouse_address
integer x = 1019
integer y = 524
end type

type cb_ok from w_response_ancestor`cb_ok within w_edit_warehouse_address
integer x = 585
integer y = 524
end type

type dw_1 from datawindow within w_edit_warehouse_address
integer y = 16
integer width = 1989
integer height = 492
integer taborder = 10
boolean bringtotop = true
string title = "none"
string dataobject = "d_edit_warehouse_address"
boolean livescroll = true
borderstyle borderstyle = styleraised!
end type

