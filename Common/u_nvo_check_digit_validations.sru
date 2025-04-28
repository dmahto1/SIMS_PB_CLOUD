HA$PBExportHeader$u_nvo_check_digit_validations.sru
$PBExportComments$Check Digit Validations (i.e. Luhn Mod N)
forward
global type u_nvo_check_digit_validations from nonvisualobject
end type
end forward

global type u_nvo_check_digit_validations from nonvisualobject
end type
global u_nvo_check_digit_validations u_nvo_check_digit_validations

type variables

String	isCodePoint 



end variables

forward prototypes
public function integer getnumberofvalidcharacters ()
public function boolean uf_validate_luhn (string asinputstring)
public function integer getcodepointfromchar (string aschar)
public function string getcharfromcodepoint (integer aicodepoint)
public function integer setluhnvalidcodeset ()
public function string uf_generate_luhn_checkdigit (string asinputstring)
public function string uf_lmc_generate_next_serial_no (string asinserial)
public function string getnextcharacter (string asinchar)
end prototypes

public function integer getnumberofvalidcharacters ();

Return Len(iscodepoint)
end function

public function boolean uf_validate_luhn (string asinputstring);
//Perform a Luhn Mod(N) checksum (where N=Number of valid characters in codeset)

Long		llSum, n, llCharCount, llPos, llChar, llMod, llDiv, llCrap, llPos2
int		liCodePoint
Boolean	lbDouble
String	lsChar

llSum = 0
n = getNumberofValidCharacters()

llCharCount = Len(asInputString)

For llPos = llCharCount to 1 Step - 1
	
	lsChar = Mid(asinputstring,llPos,1)
	
	llChar = getCodePointFromChar(lschar)
	
	If lbDouble then
		llChar*=2
	End If
	
	llDiv = llChar / n
	llMod = Mod(llChar,n)
	
	llChar = (llChar / n) + Mod(llChar,n) /* converting to base n (where n = number of valid characters) and adding to total*/

	llSum += llChar
	
	lbDouble = Not lbDouble /*doubling every other digit*/
	
Next /*Char */

Return Mod(llSum, n) = 0
end function

public function integer getcodepointfromchar (string aschar);
//First index is 0

Return Pos(iscodepoint,asChar) - 1
end function

public function string getcharfromcodepoint (integer aicodepoint);

//First index is 0
Return Mid(isCodePoint,(aiCodePoint + 1),1)
end function

public function integer setluhnvalidcodeset ();

Choose Case Upper(gs_Project)
		
	Case 'LMC' /* LMC not using I,O,0,1 */
		
		isCodePoint  = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789"
		
	Case 'PANDORA' /* PANDORA not using I, M, O, V */
		
		isCodePoint  = "0123456789ABCDEFGHJKLNPQRSTUWXYZ"
		
	Case Else /*default to A - Z, 0 - 9 */
		
		isCodePoint  = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
		
End Choose

Return 0
end function

public function string uf_generate_luhn_checkdigit (string asinputstring);
//Add a Luhn Check Digit

Long		llSum, n, llCharCount, llPos, llChar, llMod, llDiv, llCrap, llPos2
int		liCodePoint, liMod, liCheckPoint
Boolean	lbDouble = True /*start doubling with the rightmost char */
String	lsChar

llSum = 0
n = getNumberofValidCharacters()

llCharCount = Len(asInputString)

For llPos = llCharCount to 1 Step - 1
	
	lsChar = Mid(asinputstring,llPos,1)
	
	llChar = getCodePointFromChar(lschar)
	
	If lbDouble then
		llChar*=2
	End If
	
	llDiv = llChar / n
	llMod = Mod(llChar,n)
	
	llChar = (llChar / n) + Mod(llChar,n) /* converting to base n (where n = number of valid characters) and adding to total*/

	llSum += llChar
	
	lbDouble = Not lbDouble /*doubling every other digit*/
	
Next /*Char */

//Calc the number that must be added to the Sum to make it divisible by "N" (number of valid cahracters)
liMod = Mod(llSum, n)
liCheckPoint = n - liMod

liCheckPoint = Mod(liCheckPoint,N)

Return GetCharFromCodePoint(liCheckPoint)

end function

public function string uf_lmc_generate_next_serial_no (string asinserial);
//Generate the Next Serial Number given the Serial NUmber passed in.

String	lsNextSerial, lsSeq, lsNextSeq
Int		liSeqLength
	

//The format of the Serial NUmber is SSYAAAAX Where SS=Supplier, Y=Year, AAAA = Sequential Serial Number, X = Luhn Check Digit
//based on this, we will be incrementing the 4 - 7 digits and applying a check digit.
//We are using all of the characters except I and O and all the numbers except 0 and 1.

If Len(asInserial) <> 8 Then Return ""

lsSeq = Mid(asInserial,4,4)
liSeqLength = Len(lsSeq)

//Bump up the Rightmost and work left
lsNextSeq = getNextCharacter(Mid(lsSeq,liSeqLength,1))
lsSeq = Replace(lsSeq,liSeqLength,1,lsNextSeq)

//Keep working left and increment if necessary
Do WHile getCodePointFromChar(lsNextSeq) = 0 and liSeqLength > 0 /*first in seq - we rolled*/
	
	liSeqLength --
	lsNextSeq = getNextCharacter(Mid(lsSeq,liSeqLength,1))
	lsSeq = Replace(lsSeq,liSeqLength,1,lsNextSeq)
	
Loop
	
lsNextSerial = Left(asInserial,3) + lsSeq

//Add a check digit
lsNextSerial = lsNextSerial + uf_generate_luhn_checkdigit(lsNextSerial)

Return lsNextSerial
end function

public function string getnextcharacter (string asinchar);
//Get the next char in sequence from the set of valid characterset. If the input char is the last, return the first

String	lsNextChar
long		llPos

llPos = Pos(iscodepoint,asInChar)

If llPos = 0 Then
	lsNextChar = ""
ElseIf llPos = Len(isCodePoint) Then
	lsNextChar = Left(isCodePoint,1)
Else
	lsNextChar = Mid(isCodepOint,(llPos + 1),1)
End IF

REturn lsNextChar
end function

on u_nvo_check_digit_validations.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_nvo_check_digit_validations.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;
setLuhnValidCodeSet()
end event

