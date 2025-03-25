$PBExportHeader$n_cst_encoder.sru
forward
global type n_cst_encoder from nonvisualobject
end type
end forward

global type n_cst_encoder from nonvisualobject
end type
global n_cst_encoder n_cst_encoder

type variables
String is_AscToBinary[190,2], &
         is_Base64[65,3], &
         is_AscToHex[256,2]
end variables

forward prototypes
private subroutine of_populatebase64array (boolean ab_populate)
private subroutine of_populatebinaryarray (boolean ab_populate)
public function string of_encodebase64 (string as_source)
public function string of_decodebase64 (string as_source)
public function string of_encodeurl (string as_url)
private subroutine of_populateasciihexarray (boolean ab_populate)
public function string of_encodehex (string as_source)
public function string of_decodehex (string as_source)
private function string of_globalreplace (string as_source, string as_old, string as_new, boolean ab_ignorecase)
end prototypes

private subroutine of_populatebase64array (boolean ab_populate);///////////////////////////////////////////////////////////////////////////////////////////
//
// Function:      of_PopulateBase64Array
//
// Author:        David Cervenan
//
// Access:        Private
//
// Arguments:  Boolean ab_populate
//
// Returns:       None
//
// Description:   This function populates a 3-dimensional array containing all the 
//                     Base64 information the encoding and decoding functions need to 
//                     perform the conversions.
//
// Modifications: 1/31/2011; David Cervenan - Initial version
//
////////////////////////////////////////////////////////////////////////////////////////////
String  ls_Dummy[64,3]

if ab_populate then
	is_Base64[1,1] = "0"
	is_Base64[1,2] = "A"
	is_Base64[1,3] = "000000"
	is_Base64[2,1] = "1"
	is_Base64[2,2] = "B"
	is_Base64[2,3] = "000001"
	is_Base64[3,1] = "2"
	is_Base64[3,2] = "C"
	is_Base64[3,3] = "000010"
	is_Base64[4,1] = "3"
	is_Base64[4,2] = "D"
	is_Base64[4,3] = "000011"
	is_Base64[5,1] = "4"
	is_Base64[5,2] = "E"
	is_Base64[5,3] = "000100"
	is_Base64[6,1] = "5"
	is_Base64[6,2] = "F"
	is_Base64[6,3] = "000101"
	is_Base64[7,1] = "6"
	is_Base64[7,2] = "G"
	is_Base64[7,3] = "000110"
	is_Base64[8,1] = "7"
	is_Base64[8,2] = "H"
	is_Base64[8,3] = "000111"
	is_Base64[9,1] = "8"
	is_Base64[9,2] = "I"
	is_Base64[9,3] = "001000"
	is_Base64[10,1] = "9"
	is_Base64[10,2] = "J"
	is_Base64[10,3] = "001001"
	is_Base64[11,1] = "10"
	is_Base64[11,2] = "K"
	is_Base64[11,3] = "001010"
	is_Base64[12,1] = "11"
	is_Base64[12,2] = "L"
	is_Base64[12,3] = "001011"
	is_Base64[13,1] = "12"
	is_Base64[13,2] = "M"
	is_Base64[13,3] = "001100"
	is_Base64[14,1] = "13"
	is_Base64[14,2] = "N"
	is_Base64[14,3] = "001101"
	is_Base64[15,1] = "14"
	is_Base64[15,2] = "O"
	is_Base64[15,3] = "001110"
	is_Base64[16,1] = "15"
	is_Base64[16,2] = "P"
	is_Base64[16,3] = "001111"
	is_Base64[17,1] = "16"
	is_Base64[17,2] = "Q"
	is_Base64[17,3] = "010000"
	is_Base64[18,1] = "17"
	is_Base64[18,2] = "R"
	is_Base64[18,3] = "010001"
	is_Base64[19,1] = "18"
	is_Base64[19,2] = "S"
	is_Base64[19,3] = "010010"
	is_Base64[20,1] = "19"
	is_Base64[20,2] = "T"
	is_Base64[20,3] = "010011"
	is_Base64[21,1] = "20"
	is_Base64[21,2] = "U"
	is_Base64[21,3] = "010100"
	is_Base64[22,1] = "21"
	is_Base64[22,2] = "V"
	is_Base64[22,3] = "010101"
	is_Base64[23,1] = "22"
	is_Base64[23,2] = "W"
	is_Base64[23,3] = "010110"
	is_Base64[24,1] = "23"
	is_Base64[24,2] = "X"
	is_Base64[24,3] = "010111"
	is_Base64[25,1] = "24"
	is_Base64[25,2] = "Y"
	is_Base64[25,3] = "011000"
	is_Base64[26,1] = "25"
	is_Base64[26,2] = "Z"
	is_Base64[26,3] = "011001"
	is_Base64[27,1] = "26"
	is_Base64[27,2] = "a"
	is_Base64[27,3] = "011010"
	is_Base64[28,1] = "27"
	is_Base64[28,2] = "b"
	is_Base64[28,3] = "011011"
	is_Base64[29,1] = "28"
	is_Base64[29,2] = "c"
	is_Base64[29,3] = "011100"
	is_Base64[30,1] = "29"
	is_Base64[30,2] = "d"
	is_Base64[30,3] = "011101"
	is_Base64[31,1] = "30"
	is_Base64[31,2] = "e"
	is_Base64[31,3] = "011110"
	is_Base64[32,1] = "31"
	is_Base64[32,2] = "f"
	is_Base64[32,3] = "011111"
	is_Base64[33,1] = "32"
	is_Base64[33,2] = "g"
	is_Base64[33,3] = "100000"
	is_Base64[34,1] = "33"
	is_Base64[34,2] = "h"
	is_Base64[34,3] = "100001"
	is_Base64[35,1] = "34"
	is_Base64[35,2] = "i"
	is_Base64[35,3] = "100010"
	is_Base64[36,1] = "35"
	is_Base64[36,2] = "j"
	is_Base64[36,3] = "100011"
	is_Base64[37,1] = "36"
	is_Base64[37,2] = "k"
	is_Base64[37,3] = "100100"
	is_Base64[38,1] = "37" 
	is_Base64[38,2] = "l"
	is_Base64[38,3] = "100101"
	is_Base64[39,1] = "38"
	is_Base64[39,2] = "m"
	is_Base64[39,3] = "100110"
	is_Base64[40,1] = "39"
	is_Base64[40,2] = "n"
	is_Base64[40,3] = "100111"
	is_Base64[41,1] = "40"
	is_Base64[41,2] = "o"
	is_Base64[41,3] = "101000"
	is_Base64[42,1] = "41"
	is_Base64[42,2] = "p"
	is_Base64[42,3] = "101001"
	is_Base64[43,1] = "42"
	is_Base64[43,2] = "q"
	is_Base64[43,3] = "101010"
	is_Base64[44,1] = "43"
	is_Base64[44,2] = "r"
	is_Base64[44,3] = "101011"
	is_Base64[45,1] = "44"
	is_Base64[45,2] = "s"
	is_Base64[45,3] = "101100"
	is_Base64[46,1] = "45"
	is_Base64[46,2] = "t"
	is_Base64[46,3] = "101101"
	is_Base64[47,1] = "46"
	is_Base64[47,2] = "u"
	is_Base64[47,3] = "101110"
	is_Base64[48,1] = "47"
	is_Base64[48,2] = "v"
	is_Base64[48,3] = "101111"
	is_Base64[49,1] = "48"
	is_Base64[49,2] = "w"
	is_Base64[49,3] = "110000"
	is_Base64[50,1] = "49"
	is_Base64[50,2] = "x"
	is_Base64[50,3] = "110001"
	is_Base64[51,1] = "50"
	is_Base64[51,2] = "y"
	is_Base64[51,3] = "110010"
	is_Base64[52,1] = "51"
	is_Base64[52,2] = "z"
	is_Base64[52,3] = "110011"
	is_Base64[53,1] = "52"
	is_Base64[53,2] = "0"
	is_Base64[53,3] = "110100"
	is_Base64[54,1] = "53"
	is_Base64[54,2] = "1"
	is_Base64[54,3] = "110101"
	is_Base64[55,1] = "54"
	is_Base64[55,2] = "2"
	is_Base64[55,3] = "110110"
	is_Base64[56,1] = "55"
	is_Base64[56,2] = "3"
	is_Base64[56,3] = "110111"
	is_Base64[57,1] = "56"
	is_Base64[57,2] = "4"
	is_Base64[57,3] = "111000"
	is_Base64[58,1] = "57"
	is_Base64[58,2] = "5"
	is_Base64[58,3] = "111001"
	is_Base64[59,1] = "58"
	is_Base64[59,2] = "6"
	is_Base64[59,3] = "111010"
	is_Base64[60,1] = "59"
	is_Base64[60,2] = "7"
	is_Base64[60,3] = "111011"
	is_Base64[61,1] = "60"
	is_Base64[61,2] = "8"
	is_Base64[61,3] = "111100"
	is_Base64[62,1] = "61"
	is_Base64[62,2] = "9"
	is_Base64[62,3] = "111101"
	is_Base64[63,1] = "62"
	is_Base64[63,2] = "+"
	is_Base64[63,3] = "111110"
	is_Base64[64,1] = "63"
	is_Base64[64,2] = "/"
	is_Base64[64,3] = "111111"
	is_Base64[65,1] = "64"
	is_Base64[65,2] = "="
	is_Base64[65,3] = "200000"
else
	is_Base64 = ls_Dummy
end if
end subroutine

private subroutine of_populatebinaryarray (boolean ab_populate);///////////////////////////////////////////////////////////////////////////////////////////
//
// Function:      of_PopulateBinaryArray
//
// Author:        David Cervenan
//
// Access:        Private
//
// Arguments:  Boolean ab_populate
//
// Returns:       None
//
// Description:   This function populates a 2-dimensional array containing all the 
//                     ASCII and binary information the encoding and decoding functions
//                     need to perform the conversions.
//
// Modifications: 1/31/2011; David Cervenan - Initial version
//
////////////////////////////////////////////////////////////////////////////////////////////
String ls_Dummy[190,2]

if ab_populate then
	is_AscToBinary[1,1] = "!"
	is_AscToBinary[1,2] = "00100001"
	is_AscToBinary[2,1] = "~"" 	
	is_AscToBinary[2,2] = "00100010"
	is_AscToBinary[3,1] = "#"
	is_AscToBinary[3,2] = "00100011"
	is_AscToBinary[4,1] = "$"
	is_AscToBinary[4,2] = "00100100"
	is_AscToBinary[5,1] = "%"
	is_AscToBinary[5,2] = "00100101"
	is_AscToBinary[6,1] = "&"
	is_AscToBinary[6,2] = "00100110"
	is_AscToBinary[7,1] = "'"
	is_AscToBinary[7,2] = "00100111"
	is_AscToBinary[8,1] = "("
	is_AscToBinary[8,2] = "00101000"
	is_AscToBinary[9,1] = ")"
	is_AscToBinary[9,2] = "00101001"
	is_AscToBinary[10,1] = "*"
	is_AscToBinary[10,2] = "00101001"
	is_AscToBinary[11,1] = "+"
	is_AscToBinary[11,2] = "00101011"
	is_AscToBinary[12,1] = ","
	is_AscToBinary[12,2] = "00101100"
	is_AscToBinary[13,1] = "-"
	is_AscToBinary[13,2] = "00101101"
	is_AscToBinary[14,1] = "."
	is_AscToBinary[14,2] = "00101110"
	is_AscToBinary[15,1] = "/"
	is_AscToBinary[15,2] = "00101111"
	is_AscToBinary[16,1] = "0"
	is_AscToBinary[16,2] = "00110000"
	is_AscToBinary[17,1] = "1"
	is_AscToBinary[17,2] = "00110001"
	is_AscToBinary[18,1] = "2"
	is_AscToBinary[18,2] = "00110010"
	is_AscToBinary[19,1] = "3"
	is_AscToBinary[19,2] = "00110011"
	is_AscToBinary[20,1] = "4"
	is_AscToBinary[20,2] = "00110100"
	is_AscToBinary[21,1] = "5"
	is_AscToBinary[21,2] = "00110101"
	is_AscToBinary[22,1] = "6"
	is_AscToBinary[22,2] = "00110110"
	is_AscToBinary[23,1] = "7"
	is_AscToBinary[23,2] = "00110111"
	is_AscToBinary[24,1] = "8"
	is_AscToBinary[24,2] = "00111000"
	is_AscToBinary[25,1] = "9"
	is_AscToBinary[25,2] = "00111001"
	is_AscToBinary[26,1] = ":"
	is_AscToBinary[26,2] = "00111010"
	is_AscToBinary[27,1] = ";"
	is_AscToBinary[27,2] = "00111011"
	is_AscToBinary[28,1] = "<"
	is_AscToBinary[28,2] = "00111100"
	is_AscToBinary[29,1] = "="
	is_AscToBinary[29,2] = "00111101"
	is_AscToBinary[30,1] = ">"
	is_AscToBinary[30,2] = "00111110"
	is_AscToBinary[31,1] = "?"
	is_AscToBinary[31,2] = "00111111"
	is_AscToBinary[32,1] = "@"
	is_AscToBinary[32,2] = "01000000"
	is_AscToBinary[33,1] = "A"
	is_AscToBinary[33,2] = "01000001"
	is_AscToBinary[34,1] = "B"
	is_AscToBinary[34,2] = "01000010"
	is_AscToBinary[35,1] = "C"
	is_AscToBinary[35,2] = "01000011"
	is_AscToBinary[36,1] = "D"
	is_AscToBinary[36,2] = "01000100"
	is_AscToBinary[37,1] = "E"
	is_AscToBinary[37,2] = "01000101"
	is_AscToBinary[38,1] = "F"
	is_AscToBinary[38,2] = "01000110"
	is_AscToBinary[39,1] = "G"
	is_AscToBinary[39,2] = "01000111"
	is_AscToBinary[40,1] = "H"
	is_AscToBinary[40,2] = "01001000"
	is_AscToBinary[41,1] = "I"
	is_AscToBinary[41,2] = "01001001"
	is_AscToBinary[42,1] = "J"
	is_AscToBinary[42,2] = "01001010"
	is_AscToBinary[43,1] = "K"
	is_AscToBinary[43,2] = "01001011"
	is_AscToBinary[44,1] = "L"
	is_AscToBinary[44,2] = "01001100"
	is_AscToBinary[45,1] = "M"
	is_AscToBinary[45,2] = "01001101"
	is_AscToBinary[46,1] = "N"
	is_AscToBinary[46,2] = "01001110"
	is_AscToBinary[47,1] = "O"
	is_AscToBinary[47,2] = "01001111"
	is_AscToBinary[48,1] = "P"
	is_AscToBinary[48,2] = "01010000"
	is_AscToBinary[49,1] = "Q"
	is_AscToBinary[49,2] = "01010001"
	is_AscToBinary[50,1] = "R"
	is_AscToBinary[50,2] = "01010010"
	is_AscToBinary[51,1] = "S"
	is_AscToBinary[51,2] = "01010011"
	is_AscToBinary[52,1] = "T"
	is_AscToBinary[52,2] = "01010100"
	is_AscToBinary[53,1] = "U"
	is_AscToBinary[53,2] = "01010101"
	is_AscToBinary[54,1] = "V"
	is_AscToBinary[54,2] = "01010110"
	is_AscToBinary[55,1] = "W"
	is_AscToBinary[55,2] = "01010111"
	is_AscToBinary[56,1] = "X"
	is_AscToBinary[56,2] = "01011000"
	is_AscToBinary[57,1] = "Y"
	is_AscToBinary[57,2] = "01011001"
	is_AscToBinary[58,1] = "Z"
	is_AscToBinary[58,2] = "01011010"
	is_AscToBinary[59,1] = "["
	is_AscToBinary[59,2] = "01011011"
	is_AscToBinary[60,1] = "\"
	is_AscToBinary[60,2] = "01011100"
	is_AscToBinary[61,1] = "]"
	is_AscToBinary[61,2] = "01011101"
	is_AscToBinary[62,1] = "^"
	is_AscToBinary[62,2] = "01011110"
	is_AscToBinary[63,1] = "_"
	is_AscToBinary[63,2] = "01011111"
	is_AscToBinary[64,1] = "`"
	is_AscToBinary[64,2] = "01100000"
	is_AscToBinary[65,1] = "a"
	is_AscToBinary[65,2] = "01100001"
	is_AscToBinary[66,1] = "b"
	is_AscToBinary[66,2] = "01100010"
	is_AscToBinary[67,1] = "c"
	is_AscToBinary[67,2] = "01100011"
	is_AscToBinary[68,1] = "d"
	is_AscToBinary[68,2] = "01100100"
	is_AscToBinary[69,1] = "e"
	is_AscToBinary[69,2] = "01100101"
	is_AscToBinary[70,1] = "f"
	is_AscToBinary[70,2] = "01100110"
	is_AscToBinary[71,1] = "g"
	is_AscToBinary[71,2] = "01100111"
	is_AscToBinary[72,1] = "h"
	is_AscToBinary[72,2] = "01101000"
	is_AscToBinary[73,1] = "i"
	is_AscToBinary[73,2] = "01101001"
	is_AscToBinary[74,1] = "j"
	is_AscToBinary[74,2] = "01101010"
	is_AscToBinary[75,1] = "k"
	is_AscToBinary[75,2] = "01101011"
	is_AscToBinary[76,1] = "l"
	is_AscToBinary[76,2] = "01101100"
	is_AscToBinary[77,1] = "m"
	is_AscToBinary[77,2] = "01101101"
	is_AscToBinary[78,1] = "n"
	is_AscToBinary[78,2] = "01101110"
	is_AscToBinary[79,1] = "o"
	is_AscToBinary[79,2] = "01101111"
	is_AscToBinary[80,1] = "p"
	is_AscToBinary[80,2] = "01110000"
	is_AscToBinary[81,1] = "q"
	is_AscToBinary[81,2] = "01110001"
	is_AscToBinary[82,1] = "r"
	is_AscToBinary[82,2] = "01110010"
	is_AscToBinary[83,1] = "s"
	is_AscToBinary[83,2] = "01110011"
	is_AscToBinary[84,1] = "t"
	is_AscToBinary[84,2] = "01110100"
	is_AscToBinary[85,1] = "u"
	is_AscToBinary[85,2] = "01110101"
	is_AscToBinary[86,1] = "v"
	is_AscToBinary[86,2] = "01110110"
	is_AscToBinary[87,1] = "w"
	is_AscToBinary[87,2] = "01110111"
	is_AscToBinary[88,1] = "x"
	is_AscToBinary[88,2] = "01111000"
	is_AscToBinary[89,1] = "y"
	is_AscToBinary[89,2] = "01111001"
	is_AscToBinary[90,1] = "z"
	is_AscToBinary[90,2] = "01111010"
	is_AscToBinary[91,1] = "{"
	is_AscToBinary[91,2] = "01111011"
	is_AscToBinary[92,1] = "|"
	is_AscToBinary[92,2] = "01111100"
	is_AscToBinary[93,1] = "}"
	is_AscToBinary[93,2] = "01111101"
	is_AscToBinary[94,1] = "~~"
	is_AscToBinary[94,2] = "01111110"
	is_AscToBinary[95,1] = "€"
	is_AscToBinary[95,2] = "10000000"
	is_AscToBinary[96,1] = "¡"
	is_AscToBinary[96,2] = "10100001"
	is_AscToBinary[97,1] = "¢"
	is_AscToBinary[97,2] = "10100010"
	is_AscToBinary[98,1] = "£"
	is_AscToBinary[98,2] = "10100011"
	is_AscToBinary[99,1] = "¤"
	is_AscToBinary[99,2] = "10100100"
	is_AscToBinary[100,1] = "¥"
	is_AscToBinary[100,2] = "10100101"
	is_AscToBinary[101,1] = "¦"
	is_AscToBinary[101,2] = "10100110"
	is_AscToBinary[102,1] = "§"
	is_AscToBinary[102,2] = "10100111"
	is_AscToBinary[103,1] = "¨"
	is_AscToBinary[103,2] = "10100111"
	is_AscToBinary[104,1] = "©"
	is_AscToBinary[104,2] = "10101001"
	is_AscToBinary[105,1] = "ª"
	is_AscToBinary[105,2] = "10101010"
	is_AscToBinary[106,1] = "«"
	is_AscToBinary[106,2] = "10101011"
	is_AscToBinary[107,1] = "¬"
	is_AscToBinary[107,2] = "10101100"
	is_AscToBinary[108,1] = "®"
	is_AscToBinary[108,2] = "10101110"
	is_AscToBinary[109,1] = "¯"
	is_AscToBinary[109,2] = "10101111"
	is_AscToBinary[110,1] = "°"
	is_AscToBinary[110,2] = "10110000"
	is_AscToBinary[111,1] = "±"
	is_AscToBinary[111,2] = "10110001"
	is_AscToBinary[112,1] = "²"
	is_AscToBinary[112,2] = "10110010"
	is_AscToBinary[113,1] = "³"
	is_AscToBinary[113,2] = "10110011"
	is_AscToBinary[114,1] = "´"
	is_AscToBinary[114,2] = "10110100"
	is_AscToBinary[115,1] = "µ"
	is_AscToBinary[115,2] = "10110101"
	is_AscToBinary[116,1] = "¶"
	is_AscToBinary[116,2] = "10110110"
	is_AscToBinary[117,1] = "·"
	is_AscToBinary[117,2] = "10110111"
	is_AscToBinary[118,1] = "¸"
	is_AscToBinary[118,2] = "10111000"
	is_AscToBinary[119,1] = "¹"
	is_AscToBinary[119,2] = "10111001"
	is_AscToBinary[120,1] = "º"
	is_AscToBinary[120,2] = "10111010"
	is_AscToBinary[121,1] = "»"
	is_AscToBinary[121,2] = "10111011"
	is_AscToBinary[122,1] = "¼"
	is_AscToBinary[122,2] = "10111100"
	is_AscToBinary[123,1] = "½"
	is_AscToBinary[123,2] = "10111101"
	is_AscToBinary[124,1] = "¾"
	is_AscToBinary[124,2] = "10111110"
	is_AscToBinary[125,1] = "¿"
	is_AscToBinary[125,2] = "10111111"
	is_AscToBinary[126,1] = "À"
	is_AscToBinary[126,2] = "11000000"
	is_AscToBinary[127,1] = "Á"
	is_AscToBinary[127,2] = "11000001"
	is_AscToBinary[128,1] = "Â"
	is_AscToBinary[128,2] = "11000010"
	is_AscToBinary[129,1] = "Ã"
	is_AscToBinary[129,2] = "11000011"
	is_AscToBinary[130,1] = "Ä"
	is_AscToBinary[130,2] = "11000100"
	is_AscToBinary[131,1] = "Å"
	is_AscToBinary[131,2] = "11000101"
	is_AscToBinary[132,1] = "Æ"
	is_AscToBinary[132,2] = "11000110"
	is_AscToBinary[133,1] = "Ç"
	is_AscToBinary[133,2] = "11000111"
	is_AscToBinary[134,1] = "È"
	is_AscToBinary[134,2] = "11001000"
	is_AscToBinary[135,1] = "É"
	is_AscToBinary[135,2] = "11001001"
	is_AscToBinary[136,1] = "Ê"
	is_AscToBinary[136,2] = "11001010"
	is_AscToBinary[137,1] = "Ë"
	is_AscToBinary[137,2] = "11001011"
	is_AscToBinary[138,1] = "Ì"
	is_AscToBinary[138,2] = "11001100"
	is_AscToBinary[139,1] = "Í"
	is_AscToBinary[139,2] = "11001101"
	is_AscToBinary[140,1] = "Î"
	is_AscToBinary[140,2] = "11001110"
	is_AscToBinary[141,1] = "Ï"
	is_AscToBinary[141,2] = "11001111"
	is_AscToBinary[142,1] = "Ð"
	is_AscToBinary[142,2] = "11010000"
	is_AscToBinary[143,1] = "Ñ"
	is_AscToBinary[143,2] = "11010001"
	is_AscToBinary[144,1] = "Ò"
	is_AscToBinary[144,2] = "11010010"
	is_AscToBinary[145,1] = "Ó"
	is_AscToBinary[145,2] = "11010011"
	is_AscToBinary[146,1] = "Ô"
	is_AscToBinary[146,2] = "11010100"
	is_AscToBinary[147,1] = "Õ"
	is_AscToBinary[147,2] = "11010101"
	is_AscToBinary[148,1] = "Ö"
	is_AscToBinary[148,2] = "11010110"
	is_AscToBinary[149,1] = "×"
	is_AscToBinary[149,2] = "11010111"
	is_AscToBinary[150,1] = "Ø"
	is_AscToBinary[150,2] = "11011000"
	is_AscToBinary[151,1] = "Ù"
	is_AscToBinary[151,2] = "11011001"
	is_AscToBinary[152,1] = "Ú"
	is_AscToBinary[152,2] = "11011010"
	is_AscToBinary[153,1] = "Û"
	is_AscToBinary[153,2] = "11011011"
	is_AscToBinary[154,1] = "Ü"
	is_AscToBinary[154,2] = "11011100"
	is_AscToBinary[155,1] = "Ý"
	is_AscToBinary[155,2] = "11011101"
	is_AscToBinary[156,1] = "Þ"
	is_AscToBinary[156,2] = "11011110"
	is_AscToBinary[157,1] = "ß"
	is_AscToBinary[157,2] = "11011111"
	is_AscToBinary[158,1] = "à"
	is_AscToBinary[158,2] = "11100000"
	is_AscToBinary[159,1] = "á"
	is_AscToBinary[159,2] = "11100001"
	is_AscToBinary[160,1] = "â"
	is_AscToBinary[160,2] = "11100010"
	is_AscToBinary[161,1] = "ã"
	is_AscToBinary[161,2] = "11100011"
	is_AscToBinary[162,1] = "ä"
	is_AscToBinary[162,2] = "11100100"
	is_AscToBinary[163,1] = "å"
	is_AscToBinary[163,2] = "11100101"
	is_AscToBinary[164,1] = "æ"
	is_AscToBinary[164,2] = "11100110"
	is_AscToBinary[165,1] = "ç"
	is_AscToBinary[165,2] = "11100111"
	is_AscToBinary[166,1] = "è"
	is_AscToBinary[166,2] = "11101000"
	is_AscToBinary[167,1] = "é"
	is_AscToBinary[167,2] = "11101001"
	is_AscToBinary[168,1] = "ê"
	is_AscToBinary[168,2] = "11101010"
	is_AscToBinary[169,1] = "ë"
	is_AscToBinary[169,2] = "11101011"
	is_AscToBinary[170,1] = "ì"
	is_AscToBinary[170,2] = "11101100"
	is_AscToBinary[171,1] = "í"
	is_AscToBinary[171,2] = "11101101"
	is_AscToBinary[172,1] = "î"
	is_AscToBinary[172,2] = "11101110"
	is_AscToBinary[173,1] = "ï"
	is_AscToBinary[173,2] = "11101111"
	is_AscToBinary[174,1] = "ð"
	is_AscToBinary[174,2] = "11110000"
	is_AscToBinary[175,1] = "ñ"
	is_AscToBinary[175,2] = "11110001"
	is_AscToBinary[176,1] = "ò"
	is_AscToBinary[176,2] = "11110010"
	is_AscToBinary[177,1] = "ó"
	is_AscToBinary[177,2] = "11110011"
	is_AscToBinary[178,1] = "ô"
	is_AscToBinary[178,2] = "11110100"
	is_AscToBinary[179,1] = "õ"
	is_AscToBinary[179,2] = "11110101"
	is_AscToBinary[180,1] = "ö"
	is_AscToBinary[180,2] = "11110110"
	is_AscToBinary[181,1] = "÷"
	is_AscToBinary[181,2] = "11110111"
	is_AscToBinary[182,1] = "ø"
	is_AscToBinary[182,2] = "11111000"
	is_AscToBinary[183,1] = "ù"
	is_AscToBinary[183,2] = "11111001"
	is_AscToBinary[184,1] = "ú"
	is_AscToBinary[184,2] = "11111010"
	is_AscToBinary[185,1] = "û"
	is_AscToBinary[185,2] = "11111011"
	is_AscToBinary[186,1] = "û"
	is_AscToBinary[186,2] = "11111100"
	is_AscToBinary[187,1] = "ý"
	is_AscToBinary[187,2] = "11111101"
	is_AscToBinary[188,1] = "þ"
	is_AscToBinary[188,2] = "11111110"
	is_AscToBinary[189,1] = "ÿ"
	is_AscToBinary[189,2] = "11111111"
	is_AscToBinary[190,1] = " "
	is_AscToBinary[190,2] = "00100000"
else
	is_AscToBinary = ls_Dummy
end if
end subroutine

public function string of_encodebase64 (string as_source);///////////////////////////////////////////////////////////////////////////////////////////
//
// Function:      of_EncodeBase64
//
// Author:        David Cervenan
//
// Access:        Public
//
// Arguments:  String as_source
//
// Returns:       String
//
// Description:   This function encodes an ASCII string to a Base64 stream. 
//
// Modifications: 1/31/2011; David Cervenan - Initial version
//
////////////////////////////////////////////////////////////////////////////////////////////
String ls_BinaryString, &
          ls_Base64String

Char   lc_CharArray[], &
          lc_BinaryArray[]
			 
Int      li_Base64Int[]

Long   ll_UpperBound, &
          ll_Counter, &
          ll_Base64Count, &
          ll_AscCount, &
          ll_BinaryCount, &
          ll_Base64IntCount = 1, &
          ll_Len, &
          ll_Mod

// Populate the binary array
this.of_PopulateBinaryArray ( true )

// Parse the source string into a character array
lc_CharArray   = as_source
ll_UpperBound = UpperBound ( lc_CharArray )

// Convert the ASCII characters to a binary stream
for ll_Counter = 1 to ll_UpperBound
	for ll_AscCount = 1 to 190
		if lc_CharArray[ll_Counter] = is_AscToBinary[ll_AscCount,1] then
			ls_BinaryString += is_AscToBinary[ll_AscCount,2]
			
			exit
		end if
	next
next

// Clear the binary array
this.of_PopulateBinaryArray ( false )

// Parse the binary stream into a character array
lc_BinaryArray = ls_BinaryString
ll_UpperBound = UpperBound ( lc_BinaryArray )

// Break the binary stream into chunks of 6 bits and calculate the numeric equivalent in the Base64 alphabet
for ll_Counter = 1 to ll_UpperBound	
	if ll_BinaryCount = 6 then
		ll_Base64IntCount ++
	end if
	
	if ll_BinaryCount = 6 then
		ll_BinaryCount = 1
	else
		ll_BinaryCount++
	end if
	
	// If we are left with 4 bits remaining, pad the binary string with 1 more byte
	if ll_Counter = ll_UpperBound - 4 and ll_BinaryCount = 6 then
		ls_BinaryString += "00200000"
		
		lc_BinaryArray = ls_BinaryString
		ll_UpperBound = UpperBound ( lc_BinaryArray )
	end if
	
	// If we are left with 2 bits remaining, pad the binary string with 2 more bytes
	if ll_Counter = ll_UpperBound - 2 and ll_BinaryCount = 6 then
		ls_BinaryString += "0000200000200000"
		
		lc_BinaryArray = ls_BinaryString
		ll_UpperBound = UpperBound ( lc_BinaryArray )
	end if
	
	// Calculate the Base64 numeric equivalent 
	choose case ll_BinaryCount
		case 1
			li_Base64Int[ll_Base64IntCount] += Integer ( lc_BinaryArray[ll_Counter] ) * 32
			
		case 2
			li_Base64Int[ll_Base64IntCount] += Integer ( lc_BinaryArray[ll_Counter] ) * 16
			
		case 3
			li_Base64Int[ll_Base64IntCount] += Integer ( lc_BinaryArray[ll_Counter] ) * 8
			
		case 4
			li_Base64Int[ll_Base64IntCount] += Integer ( lc_BinaryArray[ll_Counter] ) * 4
			
		case 5
			li_Base64Int[ll_Base64IntCount] += Integer ( lc_BinaryArray[ll_Counter] ) * 2
			
		case 6
			li_Base64Int[ll_Base64IntCount] += Integer ( lc_BinaryArray[ll_Counter] ) * 1
		
	end choose
next

// Populate the Base64 array
this.of_PopulateBase64Array ( true )

ll_UpperBound = UpperBound ( li_Base64Int )

// Assemble the Base64 stream from the numbers calculated above
for ll_Counter = 1 to ll_UpperBound
	for ll_Base64Count = 1 to 65
		if String ( li_Base64Int[ll_Counter] ) = is_Base64[ll_Base64Count,1] then
			ls_Base64String += is_Base64[ll_Base64Count,2]
			
			exit
		end if
	next
	
	// Insert a CRLF after each 76th character
	ll_Len  = Len ( ls_Base64String )
	ll_Mod = Mod ( ll_Len, 76 )
	
	if ll_Mod  = 0 then 
		ls_Base64String += "~r~n"
	end if
next

// Clear the Base64 array
this.of_PopulateBase64Array ( false )

Return ls_Base64String
end function

public function string of_decodebase64 (string as_source);///////////////////////////////////////////////////////////////////////////////////////////
//
// Function:      of_DecodeBase64
//
// Author:        David Cervenan
//
// Access:        Public
//
// Arguments:  String as_source
//
// Returns:       String
//
// Description:   This function decodes a Base64 stream into an ASCII character
//                     string.
//
// Modifications: 1/31/2011; David Cervenan - Initial version
//
////////////////////////////////////////////////////////////////////////////////////////////
String ls_Base64BitStream, &
          ls_BinaryString, &
          ls_AscString

Char   lc_Base64Array[]

Long   ll_UpperBound, &
          ll_Counter, &
          ll_Base64Count, &
          ll_Len, &
          ll_AscCount

// Populate Base64 array
this.of_PopulateBase64Array ( true )

// Convert Base64 stream to a character array
lc_Base64Array = as_source
ll_UpperBound   = UpperBound ( lc_Base64Array )

// Assemble ASCII byte stream from Base64 character array
for ll_Counter = 1 to ll_Upperbound
	// Skip "padding" character and add 6 to the length
	if lc_Base64Array[ll_Counter] <> "=" then
		// Do not process CRLF if encountered
		if lc_Base64Array[ll_Counter] <> "~r" and lc_Base64Array[ll_Counter] <> "~n" then
			for ll_Base64Count = 1 to 65		
				if  lc_Base64Array[ll_Counter] = is_Base64[ll_Base64Count,2] then
					ls_Base64BitStream += is_Base64[ll_Base64Count,3]
					
					exit
				end if
			next
		end if
	else
		ll_Len += 6
	end if
next

// Clear the Base64 array
this.of_PopulateBase64Array ( false )

// Add the actual length to the length of the stream
ll_Len += Len ( ls_Base64BitStream )

// If the length is not divisible by 8 then bail out
if Mod ( ll_Len, 8 ) <> 0 then Return "Error decoding Base64 string."

// Populate the binary array
this.of_PopulateBinaryArray ( true )

// Assemble the ASCII string from the ASCII byte stream
for ll_Counter = 1 to ll_Len step 8
	ls_BinaryString = Mid ( ls_Base64BitStream, ll_Counter, 8 )
	
	for ll_AscCount = 1 to 190
		if ls_BinaryString = is_AscToBinary[ll_AscCount,2] then
			ls_AscString += is_AscToBinary[ll_AscCount,1]
		end if
	next
next

// Clear the binary array
this.of_PopulateBinaryArray ( false )

Return ls_AscString
end function

public function string of_encodeurl (string as_url);///////////////////////////////////////////////////////////////////////////////////////////
//
// Function:      of_EncodeURL
//
// Author:        David Cervenan
//
// Access:        Public
//
// Arguments:  String as_url
//
// Returns:       String
//
// Description:   This function encodes a URL replacing "unsafe" ASCII 
//                     characters with hexidecimal characters.
//
// Modifications: 1/31/2011; David Cervenan - Initial version
//
////////////////////////////////////////////////////////////////////////////////////////////
Char   lc_URL[]

Long   ll_UpperBound, &
          ll_Counter
		  
Int      li_Asc

String ls_EncodedURL

Boolean lb_ParamFound

// Parse the url into a character array
lc_URL = as_url

ll_UpperBound = UpperBound ( lc_URL )

// Inspect each character
for ll_Counter = 1 to ll_UpperBound
	li_Asc = Asc ( lc_URL[ll_Counter] )
	
	// Check for "unsafe" ASCII characters
	if li_Asc <= 32 or li_Asc >= 123 or li_Asc = 34 or li_Asc = 35 or li_Asc = 37 or li_Asc = 60 or li_Asc = 62 or li_Asc = 91 or li_Asc = 92 or li_Asc = 93 or li_Asc = 94 or li_Asc = 96 then
		// Encode the URL with its hexidecimal equivalent
		ls_EncodedURL += "%" + this.of_EncodeHex ( lc_URL[ll_Counter] )
	else
		// If request parameters were found then encode the reserved characters
		if lb_ParamFound then
			if li_Asc = 36 or li_Asc = 43 or li_Asc = 44 or li_Asc = 47 or li_Asc = 58 or li_Asc = 59 or li_Asc = 63 or li_Asc = 64 then
				// Encode the URL with its hexidecimal equivalent
				ls_EncodedURL += "%" + this.of_EncodeHex ( lc_URL[ll_Counter] )
			else
				ls_EncodedURL += String ( lc_URL[ll_Counter] )
			end if
		else
			ls_EncodedURL += String ( lc_URL[ll_Counter] )
		end if
	end if
	
	// Check for request parameters in the URL
	if li_Asc = 63 then lb_ParamFound = true
next

Return ls_EncodedURL
end function

private subroutine of_populateasciihexarray (boolean ab_populate);///////////////////////////////////////////////////////////////////////////////////////////
//
// Function:      of_PopulateASCIIHexArray
//
// Author:        David Cervenan
//
// Access:        Private
//
// Arguments:  Boolean ab_populate
//
// Returns:       None
//
// Description:   This function populates a 2-dimensional array containing all the 
//                     ASCII and Hex information the encoding and decoding functions
//                     need to perform the conversions.
//
// Modifications: 1/31/2011; David Cervenan - Initial version
//
////////////////////////////////////////////////////////////////////////////////////////////
String ls_Dummy[255,2]

if ab_populate then
	is_AscToHex[1,1] = "0"
	is_AscToHex[1,2] = "00"
	is_AscToHex[2,1] = "1"
	is_AscToHex[2,2] = "01"
	is_AscToHex[3,1] = "2"
	is_AscToHex[3,2] = "02"
	is_AscToHex[4,1] = "3"
	is_AscToHex[4,2] = "03"
	is_AscToHex[5,1] = "4"
	is_AscToHex[5,2] = "04"
	is_AscToHex[6,1] = "5"
	is_AscToHex[6,2] = "05"
	is_AscToHex[7,1] = "6"
	is_AscToHex[7,2] = "06"
	is_AscToHex[8,1] = "7"
	is_AscToHex[8,2] = "07"
	is_AscToHex[9,1] = "8"
	is_AscToHex[9,2] = "08"
	is_AscToHex[10,1] = "9"
	is_AscToHex[10,2] = "09"
	is_AscToHex[11,1] = "10"
	is_AscToHex[11,2] = "0A"
	is_AscToHex[12,1] = "11"
	is_AscToHex[12,2] = "0B"
	is_AscToHex[13,1] = "12"
	is_AscToHex[13,2] = "0C"
	is_AscToHex[14,1] = "13"
	is_AscToHex[14,2] = "0D"
	is_AscToHex[15,1] = "14"
	is_AscToHex[15,2] = "0E"
	is_AscToHex[16,1] = "15"
	is_AscToHex[16,2] = "0F"
	is_AscToHex[17,1] = "16"
	is_AscToHex[17,2] = "10"
	is_AscToHex[18,1] = "17"
	is_AscToHex[18,2] = "11"
	is_AscToHex[19,1] = "18"
	is_AscToHex[19,2] = "12"
	is_AscToHex[20,1] = "19"
	is_AscToHex[20,2] = "13"
	is_AscToHex[21,1] = "20"
	is_AscToHex[21,2] = "14"
	is_AscToHex[22,1] = "21"
	is_AscToHex[22,2] = "15"
	is_AscToHex[23,1] = "22"
	is_AscToHex[23,2] = "16"
	is_AscToHex[24,1] = "23"
	is_AscToHex[24,2] = "17"
	is_AscToHex[25,1] = "24"
	is_AscToHex[25,2] = "18"
	is_AscToHex[26,1] = "25"
	is_AscToHex[26,2] = "19"
	is_AscToHex[27,1] = "26"
	is_AscToHex[27,2] = "1A"
	is_AscToHex[28,1] = "27"
	is_AscToHex[28,2] = "1B"
	is_AscToHex[29,1] = "28"
	is_AscToHex[29,2] = "1C"
	is_AscToHex[30,1] = "29"
	is_AscToHex[30,2] = "1D"
	is_AscToHex[31,1] = "30"
	is_AscToHex[31,2] = "1E"
	is_AscToHex[32,1] = "31"
	is_AscToHex[32,2] = "1F"
	is_AscToHex[33,1] = "32"
	is_AscToHex[33,2] = "20"
	is_AscToHex[34,1] = "33"
	is_AscToHex[34,2] = "21"
	is_AscToHex[35,1] = "34"
	is_AscToHex[35,2] = "22"
	is_AscToHex[36,1] = "35"
	is_AscToHex[36,2] = "23"
	is_AscToHex[37,1] = "36"
	is_AscToHex[37,2] = "24"
	is_AscToHex[38,1] = "37"
	is_AscToHex[38,2] = "25"
	is_AscToHex[39,1] = "38"
	is_AscToHex[39,2] = "26"
	is_AscToHex[40,1] = "39"
	is_AscToHex[40,2] = "27"
	is_AscToHex[41,1] = "40"
	is_AscToHex[41,2] = "28"
	is_AscToHex[42,1] = "41"
	is_AscToHex[42,2] = "29"
	is_AscToHex[43,1] = "42"
	is_AscToHex[43,2] = "2A"
	is_AscToHex[44,1] = "43"
	is_AscToHex[44,2] = "2B"
	is_AscToHex[45,1] = "44"
	is_AscToHex[45,2] = "2C"
	is_AscToHex[46,1] = "45"
	is_AscToHex[46,2] = "2D"
	is_AscToHex[47,1] = "46"
	is_AscToHex[47,2] = "2E"
	is_AscToHex[48,1] = "47"
	is_AscToHex[48,2] = "2F"
	is_AscToHex[49,1] = "48"
	is_AscToHex[49,2] = "30"
	is_AscToHex[50,1] = "49"
	is_AscToHex[50,2] = "31"
	is_AscToHex[51,1] = "50"
	is_AscToHex[51,2] = "32"
	is_AscToHex[52,1] = "51"
	is_AscToHex[52,2] = "33"
	is_AscToHex[53,1] = "52"
	is_AscToHex[53,2] = "34"
	is_AscToHex[54,1] = "53"
	is_AscToHex[54,2] = "35"
	is_AscToHex[55,1] = "54"
	is_AscToHex[55,2] = "36"
	is_AscToHex[56,1] = "55"
	is_AscToHex[56,2] = "37"
	is_AscToHex[57,1] = "56"
	is_AscToHex[57,2] = "38"
	is_AscToHex[58,1] = "57"
	is_AscToHex[58,2] = "39"
	is_AscToHex[59,1] = "58"
	is_AscToHex[59,2] = "3A"
	is_AscToHex[60,1] = "59"
	is_AscToHex[60,2] = "3B"
	is_AscToHex[61,1] = "60"
	is_AscToHex[61,2] = "3C"
	is_AscToHex[62,1] = "61"
	is_AscToHex[62,2] = "3D"
	is_AscToHex[63,1] = "62"
	is_AscToHex[63,2] = "3E"
	is_AscToHex[64,1] = "63"
	is_AscToHex[64,2] = "3F"
	is_AscToHex[65,1] = "64"
	is_AscToHex[65,2] = "40"
	is_AscToHex[66,1] = "65"
	is_AscToHex[66,2] = "41"
	is_AscToHex[67,1] = "66"
	is_AscToHex[67,2] = "42"
	is_AscToHex[68,1] = "67"
	is_AscToHex[68,2] = "43"
	is_AscToHex[69,1] = "68"
	is_AscToHex[69,2] = "44"
	is_AscToHex[70,1] = "69"
	is_AscToHex[70,2] = "45"
	is_AscToHex[71,1] = "70"
	is_AscToHex[71,2] = "46"
	is_AscToHex[72,1] = "71"
	is_AscToHex[72,2] = "47"
	is_AscToHex[73,1] = "72"
	is_AscToHex[73,2] = "48"
	is_AscToHex[74,1] = "73"
	is_AscToHex[74,2] = "49"
	is_AscToHex[75,1] = "74"
	is_AscToHex[75,2] = "4A"
	is_AscToHex[76,1] = "75"
	is_AscToHex[76,2] = "4B"
	is_AscToHex[77,1] = "76"
	is_AscToHex[77,2] = "4C"
	is_AscToHex[78,1] = "77"
	is_AscToHex[78,2] = "4D"
	is_AscToHex[79,1] = "78"
	is_AscToHex[79,2] = "4E"
	is_AscToHex[80,1] = "79"
	is_AscToHex[80,2] = "4F"
	is_AscToHex[81,1] = "80"
	is_AscToHex[81,2] = "50"
	is_AscToHex[82,1] = "81"
	is_AscToHex[82,2] = "51"
	is_AscToHex[83,1] = "82"
	is_AscToHex[83,2] = "52"
	is_AscToHex[84,1] = "83"
	is_AscToHex[84,2] = "53"
	is_AscToHex[85,1] = "84"
	is_AscToHex[85,2] = "54"
	is_AscToHex[86,1] = "85"
	is_AscToHex[86,2] = "55"
	is_AscToHex[87,1] = "86"
	is_AscToHex[87,2] = "56"
	is_AscToHex[88,1] = "87"
	is_AscToHex[88,2] = "57"
	is_AscToHex[89,1] = "88"
	is_AscToHex[89,2] = "58"
	is_AscToHex[90,1] = "89"
	is_AscToHex[90,2] = "59"
	is_AscToHex[91,1] = "90"
	is_AscToHex[91,2] = "5A"
	is_AscToHex[92,1] = "91"
	is_AscToHex[92,2] = "5B"
	is_AscToHex[93,1] = "92"
	is_AscToHex[93,2] = "5C"
	is_AscToHex[94,1] = "93"
	is_AscToHex[94,2] = "5D"
	is_AscToHex[95,1] = "94"
	is_AscToHex[95,2] = "5E"
	is_AscToHex[96,1] = "95"
	is_AscToHex[96,2] = "5F"
	is_AscToHex[97,1] = "96"
	is_AscToHex[97,2] = "60"
	is_AscToHex[98,1] = "97"
	is_AscToHex[98,2] = "61"
	is_AscToHex[99,1] = "98"
	is_AscToHex[99,2] = "62"
	is_AscToHex[100,1] = "99"
	is_AscToHex[100,2] = "63"
	is_AscToHex[101,1] = "100"
	is_AscToHex[101,2] = "64"
	is_AscToHex[102,1] = "101"
	is_AscToHex[102,2] = "65"
	is_AscToHex[103,1] = "102"
	is_AscToHex[103,2] = "66"
	is_AscToHex[104,1] = "103"
	is_AscToHex[104,2] = "67"
	is_AscToHex[105,1] = "104"
	is_AscToHex[105,2] = "68"
	is_AscToHex[106,1] = "105"
	is_AscToHex[106,2] = "69"
	is_AscToHex[107,1] = "106"
	is_AscToHex[107,2] = "6A"
	is_AscToHex[108,1] = "107"
	is_AscToHex[108,2] = "6B"
	is_AscToHex[109,1] = "108"
	is_AscToHex[109,2] = "6C"
	is_AscToHex[110,1] = "109"
	is_AscToHex[110,2] = "6D"
	is_AscToHex[111,1] = "110"
	is_AscToHex[111,2] = "6E"
	is_AscToHex[112,1] = "111"
	is_AscToHex[112,2] = "6F"
	is_AscToHex[113,1] = "112"
	is_AscToHex[113,2] = "70"
	is_AscToHex[114,1] = "113"
	is_AscToHex[114,2] = "71"
	is_AscToHex[115,1] = "114"
	is_AscToHex[115,2] = "72"
	is_AscToHex[116,1] = "115"
	is_AscToHex[116,2] = "73"
	is_AscToHex[117,1] = "116"
	is_AscToHex[117,2] = "74"
	is_AscToHex[118,1] = "117"
	is_AscToHex[118,2] = "75"
	is_AscToHex[119,1] = "118"
	is_AscToHex[119,2] = "76"
	is_AscToHex[120,1] = "119"
	is_AscToHex[120,2] = "77"
	is_AscToHex[121,1] = "120"
	is_AscToHex[121,2] = "78"
	is_AscToHex[122,1] = "121"
	is_AscToHex[122,2] = "79"
	is_AscToHex[123,1] = "122"
	is_AscToHex[123,2] = "7A"
	is_AscToHex[124,1] = "123"
	is_AscToHex[124,2] = "7B"
	is_AscToHex[125,1] = "124"
	is_AscToHex[125,2] = "7C"
	is_AscToHex[126,1] = "125"
	is_AscToHex[126,2] = "7D"
	is_AscToHex[127,1] = "126"
	is_AscToHex[127,2] = "7E"
	is_AscToHex[128,1] = "127"
	is_AscToHex[128,2] = "7F"
	is_AscToHex[129,1] = "128"
	is_AscToHex[129,2] = "80"
	is_AscToHex[130,1] = "129"
	is_AscToHex[130,2] = "81"
	is_AscToHex[131,1] = "130"
	is_AscToHex[131,2] = "82"
	is_AscToHex[132,1] = "131"
	is_AscToHex[132,2] = "83"
	is_AscToHex[133,1] = "132"
	is_AscToHex[133,2] = "84"
	is_AscToHex[134,1] = "133"
	is_AscToHex[134,2] = "85"
	is_AscToHex[135,1] = "134"
	is_AscToHex[135,2] = "86"
	is_AscToHex[136,1] = "135"
	is_AscToHex[136,2] = "87"
	is_AscToHex[137,1] = "136"
	is_AscToHex[137,2] = "88"
	is_AscToHex[138,1] = "137"
	is_AscToHex[138,2] = "89"
	is_AscToHex[139,1] = "138"
	is_AscToHex[139,2] = "8A"
	is_AscToHex[140,1] = "139"
	is_AscToHex[140,2] = "8B"
	is_AscToHex[141,1] = "140"
	is_AscToHex[141,2] = "8C"
	is_AscToHex[142,1] = "141"
	is_AscToHex[142,2] = "8D"
	is_AscToHex[143,1] = "142"
	is_AscToHex[143,2] = "8E"
	is_AscToHex[144,1] = "143"
	is_AscToHex[144,2] = "8F"
	is_AscToHex[145,1] = "144"
	is_AscToHex[145,2] = "90"
	is_AscToHex[146,1] = "145"
	is_AscToHex[146,2] = "91"
	is_AscToHex[147,1] = "146"
	is_AscToHex[147,2] = "92"
	is_AscToHex[148,1] = "147"
	is_AscToHex[148,2] = "93"
	is_AscToHex[149,1] = "148"
	is_AscToHex[149,2] = "94"
	is_AscToHex[150,1] = "149"
	is_AscToHex[150,2] = "95"
	is_AscToHex[151,1] = "150"
	is_AscToHex[151,2] = "96"
	is_AscToHex[152,1] = "151"
	is_AscToHex[152,2] = "97"
	is_AscToHex[153,1] = "152"
	is_AscToHex[153,2] = "98"
	is_AscToHex[154,1] = "153"
	is_AscToHex[154,2] = "99"
	is_AscToHex[155,1] = "154"
	is_AscToHex[155,2] = "9A"
	is_AscToHex[156,1] = "155"
	is_AscToHex[156,2] = "9B"
	is_AscToHex[157,1] = "156"
	is_AscToHex[157,2] = "9C"
	is_AscToHex[158,1] = "157"
	is_AscToHex[158,2] = "9D"
	is_AscToHex[159,1] = "158"
	is_AscToHex[159,2] = "9E"
	is_AscToHex[160,1] = "159"
	is_AscToHex[160,2] = "9F"
	is_AscToHex[161,1] = "160"
	is_AscToHex[161,2] = "A0"
	is_AscToHex[162,1] = "161"
	is_AscToHex[162,2] = "A1"
	is_AscToHex[163,1] = "162"
	is_AscToHex[163,2] = "A2"
	is_AscToHex[164,1] = "163"
	is_AscToHex[164,2] = "A3"
	is_AscToHex[165,1] = "164"
	is_AscToHex[165,2] = "A4"
	is_AscToHex[166,1] = "165"
	is_AscToHex[166,2] = "A5"
	is_AscToHex[167,1] = "166"
	is_AscToHex[167,2] = "A6"
	is_AscToHex[168,1] = "167"
	is_AscToHex[168,2] = "A7"
	is_AscToHex[169,1] = "168"
	is_AscToHex[169,2] = "A8"
	is_AscToHex[170,1] = "169"
	is_AscToHex[170,2] = "A9"
	is_AscToHex[171,1] = "170"
	is_AscToHex[171,2] = "AA"
	is_AscToHex[172,1] = "171"
	is_AscToHex[172,2] = "AB"
	is_AscToHex[173,1] = "172"
	is_AscToHex[173,2] = "AC"
	is_AscToHex[174,1] = "173"
	is_AscToHex[174,2] = "AD"
	is_AscToHex[175,1] = "174"
	is_AscToHex[175,2] = "AE"
	is_AscToHex[176,1] = "175"
	is_AscToHex[176,2] = "AF"
	is_AscToHex[177,1] = "176"
	is_AscToHex[177,2] = "B0"
	is_AscToHex[178,1] = "177"
	is_AscToHex[178,2] = "B1"
	is_AscToHex[179,1] = "178"
	is_AscToHex[179,2] = "B2"
	is_AscToHex[180,1] = "179"
	is_AscToHex[180,2] = "B3"
	is_AscToHex[181,1] = "180"
	is_AscToHex[181,2] = "B4"
	is_AscToHex[182,1] = "181"
	is_AscToHex[182,2] = "B5"
	is_AscToHex[183,1] = "182"
	is_AscToHex[183,2] = "B6"
	is_AscToHex[184,1] = "183"
	is_AscToHex[184,2] = "B7"
	is_AscToHex[185,1] = "184"
	is_AscToHex[185,2] = "B8"
	is_AscToHex[186,1] = "185"
	is_AscToHex[186,2] = "B9"
	is_AscToHex[187,1] = "186"
	is_AscToHex[187,2] = "BA"
	is_AscToHex[188,1] = "187"
	is_AscToHex[188,2] = "BB"
	is_AscToHex[189,1] = "188"
	is_AscToHex[189,2] = "BC"
	is_AscToHex[190,1] = "189"
	is_AscToHex[190,2] = "BD"
	is_AscToHex[191,1] = "190"
	is_AscToHex[191,2] = "BE"
	is_AscToHex[192,1] = "191"
	is_AscToHex[192,2] = "BF"
	is_AscToHex[193,1] = "192"
	is_AscToHex[193,2] = "C0"
	is_AscToHex[194,1] = "193"
	is_AscToHex[194,2] = "C1"
	is_AscToHex[195,1] = "194"
	is_AscToHex[195,2] = "C2"
	is_AscToHex[196,1] = "195"
	is_AscToHex[196,2] = "C3"
	is_AscToHex[197,1] = "196"
	is_AscToHex[197,2] = "C4"
	is_AscToHex[198,1] = "197"
	is_AscToHex[198,2] = "C5"
	is_AscToHex[199,1] = "198"
	is_AscToHex[199,2] = "C6"
	is_AscToHex[200,1] = "199"
	is_AscToHex[200,2] = "C7"
	is_AscToHex[201,1] = "200"
	is_AscToHex[201,2] = "C8"
	is_AscToHex[202,1] = "201"
	is_AscToHex[202,2] = "C9"
	is_AscToHex[203,1] = "202"
	is_AscToHex[203,2] = "CA"
	is_AscToHex[204,1] = "203"
	is_AscToHex[204,2] = "CB"
	is_AscToHex[205,1] = "204"
	is_AscToHex[205,2] = "CC"
	is_AscToHex[206,1] = "205"
	is_AscToHex[206,2] = "CD"
	is_AscToHex[207,1] = "206"
	is_AscToHex[207,2] = "CE"
	is_AscToHex[208,1] = "207"
	is_AscToHex[208,2] = "CF"
	is_AscToHex[209,1] = "208"
	is_AscToHex[209,2] = "D0"
	is_AscToHex[210,1] = "209"
	is_AscToHex[210,2] = "D1"
	is_AscToHex[211,1] = "210"
	is_AscToHex[211,2] = "D2"
	is_AscToHex[212,1] = "211"
	is_AscToHex[212,2] = "D3"
	is_AscToHex[213,1] = "212"
	is_AscToHex[213,2] = "D4"
	is_AscToHex[214,1] = "213"
	is_AscToHex[214,2] = "D5"
	is_AscToHex[215,1] = "214"
	is_AscToHex[215,2] = "D6"
	is_AscToHex[216,1] = "215"
	is_AscToHex[216,2] = "D7"
	is_AscToHex[217,1] = "216"
	is_AscToHex[217,2] = "D8"
	is_AscToHex[218,1] = "217"
	is_AscToHex[218,2] = "D9"
	is_AscToHex[219,1] = "218"
	is_AscToHex[219,2] = "DA"
	is_AscToHex[220,1] = "219"
	is_AscToHex[220,2] = "DB"
	is_AscToHex[221,1] = "220"
	is_AscToHex[221,2] = "DC"
	is_AscToHex[222,1] = "221"
	is_AscToHex[222,2] = "DD"
	is_AscToHex[223,1] = "222"
	is_AscToHex[223,2] = "DE"
	is_AscToHex[224,1] = "223"
	is_AscToHex[224,2] = "DF"
	is_AscToHex[225,1] = "224"
	is_AscToHex[225,2] = "E0"
	is_AscToHex[226,1] = "225"
	is_AscToHex[226,2] = "E1"
	is_AscToHex[227,1] = "226"
	is_AscToHex[227,2] = "E2"
	is_AscToHex[228,1] = "227"
	is_AscToHex[228,2] = "E3"
	is_AscToHex[229,1] = "228"
	is_AscToHex[229,2] = "E4"
	is_AscToHex[230,1] = "229"
	is_AscToHex[230,2] = "E5"
	is_AscToHex[231,1] = "230"
	is_AscToHex[231,2] = "E6"
	is_AscToHex[232,1] = "231"
	is_AscToHex[232,2] = "E7"
	is_AscToHex[233,1] = "232"
	is_AscToHex[233,2] = "E8"
	is_AscToHex[234,1] = "233"
	is_AscToHex[234,2] = "E9"
	is_AscToHex[235,1] = "234"
	is_AscToHex[235,2] = "EA"
	is_AscToHex[236,1] = "235"
	is_AscToHex[236,2] = "EB"
	is_AscToHex[237,1] = "236"
	is_AscToHex[237,2] = "EC"
	is_AscToHex[238,1] = "237"
	is_AscToHex[238,2] = "ED"
	is_AscToHex[239,1] = "238"
	is_AscToHex[239,2] = "EE"
	is_AscToHex[240,1] = "239"
	is_AscToHex[240,2] = "EF"
	is_AscToHex[241,1] = "240"
	is_AscToHex[241,2] = "F0"
	is_AscToHex[242,1] = "241"
	is_AscToHex[242,2] = "F1"
	is_AscToHex[243,1] = "242"
	is_AscToHex[243,2] = "F2"
	is_AscToHex[244,1] = "243"
	is_AscToHex[244,2] = "F3"
	is_AscToHex[245,1] = "244"
	is_AscToHex[245,2] = "F4"
	is_AscToHex[246,1] = "245"
	is_AscToHex[246,2] = "F5"
	is_AscToHex[247,1] = "246"
	is_AscToHex[247,2] = "F6"
	is_AscToHex[248,1] = "247"
	is_AscToHex[248,2] = "F7"
	is_AscToHex[249,1] = "248"
	is_AscToHex[249,2] = "F8"
	is_AscToHex[250,1] = "249"
	is_AscToHex[250,2] = "F9"
	is_AscToHex[251,1] = "250"
	is_AscToHex[251,2] = "FA"
	is_AscToHex[252,1] = "251"
	is_AscToHex[252,2] = "FB"
	is_AscToHex[253,1] = "252"
	is_AscToHex[253,2] = "FC"
	is_AscToHex[254,1] = "253"
	is_AscToHex[254,2] = "FD"
	is_AscToHex[255,1] = "254"
	is_AscToHex[255,2] = "FE"
	is_AscToHex[256,1] = "255"
	is_AscToHex[256,2] = "FF"
else
	is_AscToHex = ls_Dummy
end if
end subroutine

public function string of_encodehex (string as_source);///////////////////////////////////////////////////////////////////////////////////////////
//
// Function:      of_EncodeHex
//
// Author:        David Cervenan
//
// Access:        Public
//
// Arguments:  String as_source
//
// Returns:       String
//
// Description:   This function encodes an ASCII character string to hexidecimal.
//
// Modifications: 1/31/2011; David Cervenan - Initial version
//
////////////////////////////////////////////////////////////////////////////////////////////
Char  lc_Asc[]

Long  ll_UpperBound, &
         ll_Counter, &
         ll_HexCount
		  
String ls_HexString, &
          ls_AscDec

// Populate the ASCII Hex array
this.of_PopulateASCIIHexArray ( true )

// Parse the string into a character array
lc_Asc = as_source

ll_UpperBound = UpperBound ( lc_Asc )

// Convert each character to its hexidecimal equivalent
for ll_Counter = 1 to ll_UpperBound
	ls_AscDec = String ( Asc ( lc_Asc[ll_Counter] ) )
	
	for ll_HexCount = 1 to 256
		if ls_AscDec = is_AscToHex[ll_HexCount,1] then
			ls_HexString += is_AscToHex[ll_HexCount,2]
		end if
	next
next

// Clear the array
this.of_PopulateASCIIHexArray ( false )

Return ls_HexString
end function

public function string of_decodehex (string as_source);///////////////////////////////////////////////////////////////////////////////////////////
//
// Function:      of_DecodeHex
//
// Author:        David Cervenan
//
// Access:        Public
//
// Arguments:  String as_source
//
// Returns:       String
//
// Description:   This function decodes a hexidecimal stream to an ASCII 
//                     character string.
//
// Modifications: 1/31/2011; David Cervenan - Initial version
//
////////////////////////////////////////////////////////////////////////////////////////////
Long  ll_UpperBound, &
         ll_Counter, &
         ll_AscCount, &
         ll_Len, &
         ll_HexCount
		  
String ls_AscString, &
          ls_HexArray[]

// Get the length of the string
ll_Len = Len ( as_source )

// Remove all spaces from the string
as_source = Trim ( this.of_GlobalReplace ( as_source, " ", "", true ) )

// If the length is not divisible by 2 then bail out
if Mod ( ll_Len, 2 ) <> 0 then Return ""

// Parse every 2 characters into a string array
for ll_Counter = 1 to ll_Len step 2
	ll_HexCount++
	
	ls_HexArray[ll_HexCount] = Upper ( Mid ( as_source, ll_Counter, 2 ) )
next

// Populate the ASCII Hex array
this.of_PopulateASCIIHexArray ( true )

ll_UpperBound = UpperBound ( ls_HexArray )

// Convert each hexidecimal to its equivalent ASCII character
for ll_Counter = 1 to ll_UpperBound
	for ll_AscCount = 1 to 256
		if ls_HexArray[ll_Counter] = is_AscToHex[ll_AscCount,2] then
			ls_AscString += String ( Char ( Integer ( is_AscToHex[ll_AscCount,1] ) ) )
		end if
	next
next

// Clear the array
this.of_PopulateASCIIHexArray ( false )

Return ls_AscString
end function

private function string of_globalreplace (string as_source, string as_old, string as_new, boolean ab_ignorecase);///////////////////////////////////////////////////////////////////////////////////////////
//
// Function:      of_GlobalReplace
//
// Access:        Private
//
// Arguments:  String as_source
//                    String as_old
//                    String as_new
//                    Boolean ab_ignorecase
//
// Returns:       String
//
// Description:  Replace all occurrences of one string inside another with
//                    a new string.
//
////////////////////////////////////////////////////////////////////////////////////////////
Long	ll_Start, &
         ll_OldLen, &
         ll_NewLen
			
String ls_Source, &
         ls_Null

// Check parameters
if IsNull ( as_source ) or IsNull ( as_old ) or IsNull ( as_new ) or IsNull ( ab_ignorecase ) then
	SetNull ( ls_Null )
	
	Return ls_Null
end if

// Get the string lenghts
ll_OldLen   = Len ( as_old )
ll_NewLen = Len ( as_new )

// Should function respect case.
if ab_ignorecase then
	as_old     = Lower ( as_old )
	ls_Source = Lower ( as_source )
else
	ls_Source = as_source
end if

// Search for the first occurrence of as_Old
ll_Start = Pos ( ls_Source, as_old )

do while ll_Start > 0
	// Replace as_old with as_new
	as_source = Replace ( as_source, ll_Start, ll_OldLen, as_new )
	
	// Should function respect case.
	if ab_ignorecase then 
		ls_Source = Lower ( as_source )
	else
		ls_Source = as_source
	end if
	
	// Find the next occurrence of as_old
	ll_Start = Pos ( ls_Source, as_old, ( ll_Start + ll_NewLen ) )
loop

Return as_source
end function

on n_cst_encoder.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cst_encoder.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

