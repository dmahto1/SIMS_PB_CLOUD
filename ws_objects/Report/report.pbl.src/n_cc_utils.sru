$PBExportHeader$n_cc_utils.sru
$PBExportComments$Cycle count rollup utilities
forward
global type n_cc_utils from nonvisualobject
end type
end forward

global type n_cc_utils from nonvisualobject
end type
global n_cc_utils n_cc_utils

type variables
constant int RESTULT_1 = 1
constant int RESTULT_2 = 2
constant int RESTULT_3 = 3

constant int DECODE_SERIAL_NO 			= 1
constant int DECODE_CONTAINER_ID 		= 2
constant int DECODE_LOT_NO	 			= 3
constant int DECODE_PO_NO	 			= 4
constant int DECODE_PO_NO2	 			= 5
constant int DECODE_EXP_DT	 			= 6
constant int DECODE_INV_TYPE	 		= 7
constant int DECODE_COO		 			= 8

end variables

forward prototypes
public function boolean uf_decode_indicators (string as_encoded_indicators, integer ai_position)
public function long uf_retrieve_results_ds (integer ai_result_number, string as_cc_no, ref datastore ads_result)
public function long uf_spread_rolled_up_si_counts (datawindow adw_si)
public subroutine uf_clear_si_count_results (integer ai_count, datawindow adw_si)
public function any uf_find_corresponding_si_rows (datastore ads_result, long al_row, boolean ab_has_zero_qty, datawindow adw_si, integer ai_result_tab_no)
public function long uf_get_si_row (long al_line_item_no, datawindow adw_si)
end prototypes

public function boolean uf_decode_indicators (string as_encoded_indicators, integer ai_position);boolean lb_return


if Len( as_encoded_indicators ) >= ai_position then
	lb_return = Mid( as_encoded_indicators, ai_position, 1 ) = 'Y'
end if

return lb_return

end function

public function long uf_retrieve_results_ds (integer ai_result_number, string as_cc_no, ref datastore ads_result);long ll_rows

choose case ai_result_number
	case RESTULT_1
		ads_result = f_datastoreFactory('d_cc_result1')

	case RESTULT_2
		ads_result = f_datastoreFactory('d_cc_result2')
		
	case RESTULT_3
		ads_result = f_datastoreFactory('d_cc_result3')
end choose

ll_rows = ads_result.Retrieve( as_cc_no )

return ll_rows

end function

public function long uf_spread_rolled_up_si_counts (datawindow adw_si);// Accepts a system inventory datastore and spreads any rolled up result counts accross the system inventory rows

String ls_cc_no, ls_table
String ls_result_column
long ll_rows, i, j, ll_found_row
long ll_si_rows[]
int k
dec ld_quantity
datastore lds_result

if NOT IsNull( adw_si ) and adw_si.RowCount() > 0 then

	//ls_cc_no = adw_si.Object.cc_no[ 1 ]
	ls_cc_no = adw_si.Object.cycle_count_no[ 1 ]

	for k = 1 to 3

		if IsValid( lds_result ) then DESTROY lds_result

		if k = 1 then
			ls_result_column = "count1_qty"
			ll_rows = uf_retrieve_results_ds( RESTULT_1, ls_cc_no, lds_result )
		elseif k = 2 then
			ls_result_column = "count2_qty"
			ll_rows = uf_retrieve_results_ds( RESTULT_2, ls_cc_no, lds_result )
		elseif k = 3 then
			ls_result_column = "count3_qty"
			ll_rows = uf_retrieve_results_ds( RESTULT_3, ls_cc_no, lds_result )
		end if

		if IsNull( lds_result ) then
			if IsValid( lds_result ) then DESTROY lds_result
			return -1
		end if
	
//		if ll_rows > 0 and adw_si.RowCount() <> ll_rows then
		if ll_rows > 0  then
	
			uf_clear_si_count_results( k, adw_si )		// Clear the results from the SQL retrieve and set below

			// Traverse the count DS and determine the SI rows
			for i = 1 to ll_rows		
				ld_quantity = lds_result.Object.quantity[ i ]

				if NOT IsNull( ld_quantity ) and ld_quantity > 0 then

					ll_si_rows = uf_find_corresponding_si_rows( lds_result, i, FALSE, adw_si, k )

					for j = 1 to UpperBound( ll_si_rows )

						ll_found_row = uf_get_si_row( ll_si_rows[ j ], adw_si )

						// Take the count from the count tab and spread it out over the corresponding SI rows

						if ld_quantity > 0 then
							//	if SI qty <= CC SUM qty; set SI CC qty to Sum qty and decrement SUM by SI qty
							//	SI qty > CC SUM qty; set SI CC qty to remaining Sum qty and break loop
							//if adw_si.Object.quantity[ ll_found_row ] <= ld_quantity then
							if adw_si.Object.system_quantity[ ll_found_row ] <= ld_quantity then
								adw_si.SetItem( ll_found_row, ls_result_column, adw_si.Object.system_quantity[ ll_found_row ] )
								ld_quantity -= adw_si.Object.system_quantity[ ll_found_row ]
							else
								adw_si.SetItem( ll_found_row, ls_result_column, ld_quantity )
								ld_quantity = 0
							end if
							if ( j = UpperBound( ll_si_rows ) ) and ( ld_quantity <> 0 ) then	// Last row and quantity still exists, assign rest to this last row
								adw_si.SetItem( ll_found_row, ls_result_column, ( adw_si.Object.system_quantity[ ll_found_row ] + ld_quantity) )
							end if
						else
							adw_si.SetItem( ll_found_row, ls_result_column, ld_quantity )
						end if
					next
				else
					
					ll_si_rows = uf_find_corresponding_si_rows( lds_result, i, FALSE, adw_si, k )
					for j = 1 to UpperBound( ll_si_rows )
						ll_found_row = uf_get_si_row( ll_si_rows[ j ], adw_si )
						if ll_found_row > 0 then
							adw_si.SetItem( ll_found_row, ls_result_column, ld_quantity )
						end if
					next
					
				end if
			next
		end if
	next
end if

if IsValid( lds_result ) then DESTROY lds_result

return 1

end function

public subroutine uf_clear_si_count_results (integer ai_count, datawindow adw_si);long ll_row, i
dec ld_null
SetNull( ld_null )

for i = 1 to adw_si.RowCount()

	if ai_count = RESTULT_1 then
		adw_si.Object.count1_qty[ i ] = ld_null
	elseif ai_count = RESTULT_2 then
		adw_si.Object.count2_qty[ i ] = ld_null
	elseif ai_count = RESTULT_3 then
		adw_si.Object.count3_qty[ i ] = ld_null
	end if

next

end subroutine

public function any uf_find_corresponding_si_rows (datastore ads_result, long al_row, boolean ab_has_zero_qty, datawindow adw_si, integer ai_result_tab_no);// ads_result could be any of the 3 count datawindows
// al_row is the row in ads_result

long ll_rows[]
long ll_row_found, ll_last_search_row
String ls_find_str
String ls_encoded_indicators
datastore lds_cc_main

if ads_result.RowCount() >= al_row and adw_si.RowCount() > 0 then

	lds_cc_main = f_datastoreFactory( 'd_cc_master' )
	if lds_cc_main.Retrieve( adw_si.Object.cycle_count_no[ 1 ] ) <> 1 then
		if IsValid( lds_cc_main ) then DESTROY lds_cc_main
		return -1
	end if

//	Find string
	ls_find_str = "sku = '" + ads_result.Object.sku[ al_row ] + "' "
	ls_find_str += "and location = '" + ads_result.Object.l_code[ al_row ] + "' "
//	ls_find_str += "and Inv_Type = '" + ads_result.Object.Inventory_Type[ al_row ] + "' "
	ls_find_str += "and Supp_Code = '" + Upper( ads_result.Object.Supp_Code[ al_row ] ) + "' "
	ls_find_str += "and Owner_ID = " + String( ads_result.Object.Owner_ID[ al_row ] ) + "  "


	if ai_result_tab_no = RESTULT_1 then
		ls_encoded_indicators = lds_cc_main.Object.Count1_Rollup_Code[1]
	elseif ai_result_tab_no = RESTULT_2 then
		ls_encoded_indicators = lds_cc_main.Object.Count2_Rollup_Code[1]
		if ab_has_zero_qty then
//			ls_find_str += "and (Result_1 = 0 or IsNull( Result_1 ) ) "
//			ls_find_str += "and ( (Result_1 = 0) or IsNull( Result_1 ) or (Result_1 <> quantity) ) "
		end if
	elseif ai_result_tab_no = RESTULT_3 then
		ls_encoded_indicators = lds_cc_main.Object.Count3_Rollup_Code[1]
		if ab_has_zero_qty then
//			ls_find_str += "and (Result_1 = 0 or IsNull( Result_1 ) ) and (Result_2 = 0 or IsNull( Result_2 ) ) "
//			ls_find_str += "and (Result_1 = 0 or IsNull( Result_1 ) or (Result_1 <> quantity) ) and (Result_2 = 0 or IsNull( Result_2 ) or (Result_2 <> quantity) ) "
		end if
	end if


	if uf_decode_indicators( ls_encoded_indicators, DECODE_SERIAL_NO ) then
		ls_find_str += "and Serial_No = '" + String( ads_result.Object.Serial_No[ al_row ] ) + "' "
	end if

	if uf_decode_indicators( ls_encoded_indicators, DECODE_CONTAINER_ID ) then
		ls_find_str += "and Container_Id = '" + String( ads_result.Object.container_id[ al_row ] ) + "' "
	end if

	if uf_decode_indicators( ls_encoded_indicators, DECODE_LOT_NO ) then
		ls_find_str += "and Lot_No = '" + String( ads_result.Object.Lot_No[ al_row ] ) + "' "
	end if

	if uf_decode_indicators( ls_encoded_indicators, DECODE_PO_NO ) then
		ls_find_str += "and Po_No = '" + String( ads_result.Object.Po_No[ al_row ] ) + "' "
	end if
	
	if uf_decode_indicators( ls_encoded_indicators, DECODE_PO_NO2 ) then
		ls_find_str += "and Po_No2 = '" + String( ads_result.Object.Po_No2[ al_row ] ) + "' "
	end if
	
	if uf_decode_indicators( ls_encoded_indicators, DECODE_EXP_DT ) then
		ls_find_str += "and String(expiration_date,'mm/dd/yyyy hh:mm:ss') = '" + String( ads_result.getItemDateTime( al_row, "Expiration_Date"), 'mm/dd/yyyy hh:mm:ss' ) + "' "
	end if

//	if uf_decode_indicators( ls_encoded_indicators, DECODE_INV_TYPE ) then
		ls_find_str += "and Inventory_Type = '" + String( ads_result.Object.Inventory_Type[ al_row ] ) + "' "
//	end if

	if uf_decode_indicators( ls_encoded_indicators, DECODE_COO ) then
		ls_find_str += "and Country_of_Origin = '" + String( ads_result.Object.Country_of_Origin[ al_row ] ) + "' "
	end if

	ll_last_search_row = adw_si.RowCount() + 1
	ll_row_found = adw_si.Find( ls_find_str, 1, ll_last_search_row )
	

	do while ll_row_found > 0

		ll_rows[ UpperBound( ll_rows ) + 1  ] = adw_si.Object.line_item_no[ ll_row_found ] 		// now capturing line item no
		ll_row_found = adw_si.Find( ls_find_str, ll_row_found + 1, ll_last_search_row )			// leave the +1 so no endless looping

	loop

end if

if IsValid( lds_cc_main ) then DESTROY lds_cc_main

return ll_rows

end function

public function long uf_get_si_row (long al_line_item_no, datawindow adw_si);String ls_find

ls_find = "line_item_no = " +String( al_line_item_no )

return adw_si.find( ls_find, 0, adw_si.rowcount() )

end function

on n_cc_utils.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cc_utils.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

