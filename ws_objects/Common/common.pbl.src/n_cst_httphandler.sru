$PBExportHeader$n_cst_httphandler.sru
forward
global type n_cst_httphandler from nonvisualobject
end type
end forward

global type n_cst_httphandler from nonvisualobject
end type
global n_cst_httphandler n_cst_httphandler

type prototypes
Function ULong WinHttpOpen ( String pwszUserAgent, ULong dwAccessType, String pwszProxyName, String pwszProxyBypass, ULong dwFlags ) LIBRARY "WINHTTP.DLL"
Function ULong WinHttpConnect ( ULong hSession, String pswzServerName, ULong nServerPort, ULong dwReserved) LIBRARY "WINHTTP.DLL"
Function ULong WinHttpOpenRequest ( ULong hConnect, String pwszVerb, String pwszObjectName, String pwszVersion, String pwszReferrer, String ppwszAcceptTypes, ULong dwFlags ) LIBRARY "WINHTTP.DLL"
Function Boolean WinHttpQueryOption ( ULong hInternet, ULong dwOption, Blob lpBuffer, Long lpdwBufferLength ) LIBRARY "WINHTTP.DLL"
Function Boolean WinHttpSendRequest ( ULong hRequest, String pwszHeaders, ULong dwHeadersLength, Blob lpOptional, ULong dwOptionalLength, ULong dwTotalLength, ULong dwContext ) LIBRARY "WINHTTP.DLL"
Function Boolean WinHttpReceiveResponse ( ULong hRequest, String lpReserved ) LIBRARY "WINHTTP.DLL"
Function Boolean WinHttpQueryDataAvailable ( ULong hRequest, Ref ULong lpdwNumberOfBytesAvailable ) LIBRARY "WINHTTP.DLL"
Function Boolean WinHttpReadData ( ULong hRequest, Ref Blob lpBuffer, ULong dwNumberOfBytesToRead, Ref ULong lpdwNumberOfBytesRead ) LIBRARY "WINHTTP.DLL"
Function Boolean WinHttpCloseHandle ( ULong hInternet ) LIBRARY "WINHTTP.DLL"
Function ULong GetLastError ( ) LIBRARY "Kernel32.dll"
Function Boolean WinHttpCheckPlatform ( ) LIBRARY "WINHTTP.DLL"
Function Boolean WinHttpQueryHeaders ( ULong hRequest, ULong dwInfoLevel, String pwszName, Ref String lpBuffer, Ref ULong lpdwBufferLength, Ref Ulong lpdwIndex ) LIBRARY "WINHTTP.DLL"
end prototypes

type variables
PRIVATE:

Int ii_RetryCount = -1

Constant Integer SUCCESS = 1
Constant Integer FAILURE   = -1

// WINHTTP Status Constants
Constant Integer HTTP_STATUS_CONTINUE = 100
Constant Integer HTTP_STATUS_SWITCH_PROTOCOLS = 101
Constant Integer HTTP_STATUS_OK = 200
Constant Integer HTTP_STATUS_CREATED = 201
Constant Integer HTTP_STATUS_ACCEPTED = 202
Constant Integer HTTP_STATUS_PARTIAL = 203
Constant Integer HTTP_STATUS_NO_CONTENT = 204
Constant Integer HTTP_STATUS_RESET_CONTENT = 205
Constant Integer HTTP_STATUS_PARTIAL_CONTENT = 206
Constant Integer HTTP_STATUS_WEBDAV_MULTI_STATUS = 207
Constant Integer HTTP_STATUS_AMBIGUOUS = 300
Constant Integer HTTP_STATUS_MOVED = 301
Constant Integer HTTP_STATUS_REDIRECT = 302
Constant Integer HTTP_STATUS_REDIRECT_METHOD = 303
Constant Integer HTTP_STATUS_NOT_MODIFIED = 304
Constant Integer HTTP_STATUS_USE_PROXY = 305
Constant Integer HTTP_STATUS_REDIRECT_KEEP_VERB = 307
Constant Integer HTTP_STATUS_BAD_REQUEST = 400
Constant Integer HTTP_STATUS_DENIED = 401
Constant Integer HTTP_STATUS_PAYMENT_REQ = 402
Constant Integer HTTP_STATUS_FORBIDDEN = 403
Constant Integer HTTP_STATUS_NOT_FOUND = 404
Constant Integer HTTP_STATUS_BAD_METHOD = 405
Constant Integer HTTP_STATUS_NONE_ACCEPTABLE = 406
Constant Integer HTTP_STATUS_PROXY_AUTH_REQ = 407
Constant Integer HTTP_STATUS_REQUEST_TIMEOUT = 408
Constant Integer HTTP_STATUS_CONFLICT = 409
Constant Integer HTTP_STATUS_GONE = 410
Constant Integer HTTP_STATUS_LENGTH_REQUIRED = 411
Constant Integer HTTP_STATUS_PRECOND_FAILED = 412
Constant Integer HTTP_STATUS_REQUEST_TOO_LARGE = 413
Constant Integer HTTP_STATUS_URI_TOO_LONG = 414
Constant Integer HTTP_STATUS_UNSUPPORTED_MEDIA = 415
Constant Integer HTTP_STATUS_RETRY_WITH = 449
Constant Integer HTTP_STATUS_SERVER_ERROR = 500
Constant Integer HTTP_STATUS_NOT_SUPPORTED = 501
Constant Integer HTTP_STATUS_BAD_GATEWAY = 502
Constant Integer HTTP_STATUS_SERVICE_UNAVAIL = 503
Constant Integer HTTP_STATUS_GATEWAY_TIMEOUT = 504
Constant Integer HTTP_STATUS_VERSION_NOT_SUP = 505

// WINHTTP Access Constants
Constant Integer WINHTTP_ACCESS_TYPE_DEFAULT_PROXY = 0
Constant Integer WINHTTP_ACCESS_TYPE_NO_PROXY = 1
Constant Integer WINHTTP_ACCESS_TYPE_NAMED_PROXY = 3

// WINHTTP Internet Constants
Constant ULong INTERNET_INVALID_PORT_NUMBER = 0
Constant ULong INTERNET_DEFAULT_FTP_PORT = 21
Constant ULong INTERNET_DEFAULT_GOPHER_PORT = 70
Constant ULong INTERNET_DEFAULT_HTTP_PORT = 80
Constant ULong INTERNET_DEFAULT_HTTPS_PORT = 443
Constant ULong INTERNET_DEFAULT_SOCKS_PORT = 1080

// More Constants
Constant ULong INTERNET_FLAG_NO_AUTO_REDIRECT = 2097152
Constant ULong WINHTTP_FLAG_SECURE = 8388608
Constant ULong WINHTTP_QUERY_RAW_HEADERS_CRLF = 22

// Error Constants
Constant ULong ERROR_WINHTTP_AUTO_PROXY_SERVICE_ERROR = 12178
Constant ULong ERROR_WINHTTP_AUTODETECTION_FAILED = 12180
Constant ULong ERROR_WINHTTP_BAD_AUTO_PROXY_SCRIPT = 12166
Constant ULong ERROR_WINHTTP_CANNOT_CALL_AFTER_OPEN = 12103
Constant ULong ERROR_WINHTTP_CANNOT_CALL_AFTER_SEND = 12102
Constant ULong ERROR_WINHTTP_CANNOT_CALL_BEFORE_OPEN = 12100
Constant ULong ERROR_WINHTTP_CANNOT_CALL_BEFORE_SEND = 12101
Constant ULong ERROR_WINHTTP_CANNOT_CONNECT = 12029
Constant ULong ERROR_WINHTTP_CHUNKED_ENCODING_HEADER_SIZE_OVERFLOW = 12183
Constant ULong ERROR_WINHTTP_CLIENT_AUTH_CERT_NEEDED = 12044
Constant ULong ERROR_WINHTTP_CONNECTION_ERROR = 12030
Constant ULong ERROR_WINHTTP_HEADER_ALREADY_EXISTS = 12155
Constant ULong ERROR_WINHTTP_HEADER_COUNT_EXCEEDED = 12181
Constant ULong ERROR_WINHTTP_HEADER_NOT_FOUND = 12150
Constant ULong ERROR_WINHTTP_HEADER_SIZE_OVERFLOW = 12182
Constant ULong ERROR_WINHTTP_INCORRECT_HANDLE_STATE = 12019
Constant ULong ERROR_WINHTTP_INCORRECT_HANDLE_TYPE = 12018
Constant ULong ERROR_WINHTTP_INTERNAL_ERROR = 12004
Constant ULong ERROR_WINHTTP_INVALID_OPTION = 12009
Constant ULong ERROR_WINHTTP_INVALID_QUERY_REQUEST = 12154
Constant ULong ERROR_WINHTTP_INVALID_SERVER_RESPONSE = 12152
Constant ULong ERROR_WINHTTP_INVALID_URL = 12005
Constant ULong ERROR_WINHTTP_LOGIN_FAILURE = 12015
Constant ULong ERROR_WINHTTP_NAME_NOT_RESOLVED = 12007
Constant ULong ERROR_WINHTTP_NOT_INITIALIZED = 12172
Constant ULong ERROR_WINHTTP_OPERATION_CANCELLED = 12017
Constant ULong ERROR_WINHTTP_OPTION_NOT_SETTABLE = 12011
Constant ULong ERROR_WINHTTP_OUT_OF_HANDLES = 12001
Constant ULong ERROR_WINHTTP_REDIRECT_FAILED = 12156
Constant ULong ERROR_WINHTTP_RESEND_REQUEST = 12032
Constant ULong ERROR_WINHTTP_RESPONSE_DRAIN_OVERFLOW = 12184
Constant ULong ERROR_WINHTTP_SECURE_CERT_CN_INVALID = 12038
Constant ULong ERROR_WINHTTP_SECURE_CERT_DATE_INVALID = 12037
Constant ULong ERROR_WINHTTP_SECURE_CERT_REV_FAILED = 12057
Constant ULong ERROR_WINHTTP_SECURE_CERT_REVOKED = 12170
Constant ULong ERROR_WINHTTP_SECURE_CERT_WRONG_USAGE = 12179
Constant ULong ERROR_WINHTTP_SECURE_CHANNEL_ERROR = 12157
Constant ULong ERROR_WINHTTP_SECURE_FAILURE = 12175
Constant ULong ERROR_WINHTTP_SECURE_INVALID_CA = 12045
Constant ULong ERROR_WINHTTP_SECURE_INVALID_CERT = 12169
Constant ULong ERROR_WINHTTP_SHUTDOWN = 12012
Constant ULong ERROR_WINHTTP_TIMEOUT = 12002
Constant ULong ERROR_WINHTTP_UNABLE_TO_DOWNLOAD_SCRIPT = 12167
Constant ULong ERROR_WINHTTP_UNRECOGNIZED_SCHEME = 12006
end variables

forward prototypes
private function string of_processerror (unsignedlong aul_error)
public function integer of_sendurlrequest (string as_url, string as_header, string as_post_data, unsignedlong aul_port_no, integer ai_retry_count, ref string as_header_result, ref blob ablb_internet_result)
public function integer of_sendurlrequest (string as_url, integer ai_retry_count, ref string as_header_result, ref blob ablb_internet_result)
public function integer of_sendurlrequest (string as_url, string as_post_data, integer ai_retry_count, ref string as_header_result, ref blob ablb_internet_result)
public function integer of_sendurlrequest (string as_url, unsignedlong aul_port_no, integer ai_retry_count, ref string as_header_result, ref blob ablb_internet_result)
end prototypes

private function string of_processerror (unsignedlong aul_error);///////////////////////////////////////////////////////////////////////////////////////////
//
// Function:      of_ProcessError
//
// Author:        David Cervenan
//
// Access:        Private
//
// Arguments:  Ulong aul_error
//
// Returns:       String
//
// Description:   This function determines the error text to return from the 
//                     passed error number that was generated.
//
// Modifications: 1/31/2011; David Cervenan - Initial version
//
////////////////////////////////////////////////////////////////////////////////////////////
choose case aul_error
	case ERROR_WINHTTP_AUTO_PROXY_SERVICE_ERROR
		Return "Proxy for the specified URL cannot be located."

	case ERROR_WINHTTP_AUTODETECTION_FAILED
		Return "Unable to discover the URL of the Proxy Auto-Configuration (PAC) file."
		
	case ERROR_WINHTTP_BAD_AUTO_PROXY_SCRIPT
		Return "An error occurred executing the script code in the Proxy Auto-Configuration (PAC) file."
		
	case ERROR_WINHTTP_CANNOT_CALL_AFTER_OPEN
		Return "Specified option cannot be requested after the Open method has been called."
		
	case ERROR_WINHTTP_CANNOT_CALL_AFTER_SEND
		Return "The requested operation cannot be performed after calling the Send method."
		
	case ERROR_WINHTTP_CANNOT_CALL_BEFORE_OPEN
		Return "The requested operation cannot be performed before calling the Open method."
		
	case ERROR_WINHTTP_CANNOT_CALL_BEFORE_SEND
		Return "The requested operation cannot be performed before calling the Send method."
		
	case ERROR_WINHTTP_CANNOT_CONNECT
		Return "Connection to the server failed."
		
	case ERROR_WINHTTP_CHUNKED_ENCODING_HEADER_SIZE_OVERFLOW
		Return "An overflow condition was encountered in the course of parsing chunked encoding."
		
	case ERROR_WINHTTP_CLIENT_AUTH_CERT_NEEDED
		Return "The server is requesting client authentication."
		
	case ERROR_WINHTTP_CONNECTION_ERROR
		Return "The connection with the server has been reset or terminated, or an incompatible SSL protocol was encountered."
		
	case ERROR_WINHTTP_HEADER_ALREADY_EXISTS
		Return "Header already exists."
		
	case ERROR_WINHTTP_HEADER_COUNT_EXCEEDED
		Return "A larger number of headers was present in the response than WinHTTP can receive."
		
	case ERROR_WINHTTP_HEADER_NOT_FOUND
		Return "The requested header cannot be located."
		
	case ERROR_WINHTTP_HEADER_SIZE_OVERFLOW
		Return "The size of headers received exceeds the limit for the request handle."
		
	case ERROR_WINHTTP_INCORRECT_HANDLE_STATE
		Return "The requested operation cannot be carried out because the handle supplied is not in the correct state."
		
	case ERROR_WINHTTP_INCORRECT_HANDLE_TYPE
		Return "The type of handle supplied is incorrect for this operation."
		
	case ERROR_WINHTTP_INTERNAL_ERROR
		Return "An internal error has occurred."
		
	case ERROR_WINHTTP_INVALID_OPTION
		Return "A request to WinHttpQueryOption or WinHttpSetOption specified an invalid option value."
		
	case ERROR_WINHTTP_INVALID_QUERY_REQUEST
		Return "Invalid query request."
		
	case ERROR_WINHTTP_INVALID_SERVER_RESPONSE
		Return "The server response cannot be parsed."
		
	case ERROR_WINHTTP_INVALID_URL
		Return "The URL is not valid."
		
	case ERROR_WINHTTP_LOGIN_FAILURE
		Return "The login attempt failed. When this error is encountered, the request handle should be closed with WinHttpCloseHandle. A new request handle must be created before retrying the function that originally produced this error."
		
	case ERROR_WINHTTP_NAME_NOT_RESOLVED
		Return "The server name cannot be resolved."
		
	case ERROR_WINHTTP_NOT_INITIALIZED
		Return "WinHttp not initialized."
		
	case ERROR_WINHTTP_OPERATION_CANCELLED
		Return "The operation was canceled, usually because the handle on which the request was operating was closed before the operation completed."
		
	case ERROR_WINHTTP_OPTION_NOT_SETTABLE
		Return "The requested option cannot be set, only queried."
		
	case ERROR_WINHTTP_OUT_OF_HANDLES
		Return "WinHttp out of handles."
		
	case ERROR_WINHTTP_REDIRECT_FAILED
		Return "The redirection failed because either the scheme changed or all attempts made to redirect failed (default is five attempts)."
		
	case ERROR_WINHTTP_RESEND_REQUEST
		Return "The WinHTTP function failed. The desired function can be retried on the same request handle."
		
	case ERROR_WINHTTP_RESPONSE_DRAIN_OVERFLOW
		Return "The incoming response exceeds the internal WinHTTP size limit."
		
	case ERROR_WINHTTP_SECURE_CERT_CN_INVALID
		Return "The certificate CN name does not match the passed value (equivalent to a CERT_E_CN_NO_MATCH error)."
		
	case ERROR_WINHTTP_SECURE_CERT_DATE_INVALID
		Return "A required certificate is not within its validity period when verifying against the current system clock or the timestamp in the signed file, or that the validity periods of the certification chain do not nest correctly (equivalent to a CERT_E_EXPIRED or a CERT_E_VALIDITYPERIODNESTING error)."
		
	case ERROR_WINHTTP_SECURE_CERT_REV_FAILED
		Return "Revocation cannot be checked because the revocation server was offline (equivalent to CRYPT_E_REVOCATION_OFFLINE)."
		
	case ERROR_WINHTTP_SECURE_CERT_REVOKED
		Return "The certificate has been revoked (equivalent to CRYPT_E_REVOKED)."
		
	case ERROR_WINHTTP_SECURE_CERT_WRONG_USAGE
		Return "The certificate is not valid for the requested usage (equivalent to CERT_E_WRONG_USAGE)."
		
	case ERROR_WINHTTP_SECURE_CHANNEL_ERROR
		Return "An error occurred with a secure channel (equivalent to error codes that begin with ~"SEC_E_~" and ~"SEC_I_~" listed in the ~"winerror.h~" header file)."
		
	case ERROR_WINHTTP_SECURE_FAILURE
		Return "One or more errors were found in the Secure Sockets Layer (SSL) certificate sent by the server."
		
	case ERROR_WINHTTP_SECURE_INVALID_CA
		Return "The certificate chain was processed, but terminated in a root certificate that is not trusted by the trust provider (equivalent to CERT_E_UNTRUSTEDROOT)."
		
	case ERROR_WINHTTP_SECURE_INVALID_CERT
		Return "The certificate is invalid (equivalent to errors such as CERT_E_ROLE, CERT_E_PATHLENCONST, CERT_E_CRITICAL, CERT_E_PURPOSE, CERT_E_ISSUERCHAINING, CERT_E_MALFORMED and CERT_E_CHAINING)."
		
	case ERROR_WINHTTP_SHUTDOWN
		Return "The WinHTTP function support is being shut down or unloaded."
		
	case ERROR_WINHTTP_TIMEOUT
		Return "The request has timed out."
		
	case ERROR_WINHTTP_UNABLE_TO_DOWNLOAD_SCRIPT
		Return "The PAC file cannot be downloaded. For example, the server referenced by the PAC URL may not have been reachable, or the server returned a 404 NOT FOUND response."
		
	case ERROR_WINHTTP_UNRECOGNIZED_SCHEME
		Return "The URL specified a scheme other than ~"http:~" or ~"https:~"."
		
	case 0
		Return ""
		
	case else
		Return "An unknown error occurred (Error #: " + String ( aul_error ) + ")."
		
end choose

Return ""
end function

public function integer of_sendurlrequest (string as_url, string as_header, string as_post_data, unsignedlong aul_port_no, integer ai_retry_count, ref string as_header_result, ref blob ablb_internet_result);///////////////////////////////////////////////////////////////////////////////////////////
//
// Function:      of_SendURLRequest
//
// Author:        David Cervenan
//
// Access:        Public
//
// Arguments:  String as_url
//                    String as_header (optional)
//                    String as_post_data (optional)
//                    ULong aul_port_no (optional)
//                    Integer ai_retry_count
//                    String as_header_result (By reference)
//                    Blob ablb_internet_result (By reference)
//
// Returns:       Integer
//
// Description:   This function sends a URL request to the passed URL and port 
//                     number over http or https and posts header data of if desired
//                     (Ex. Content-Type: application/x-www-form-urlencoded) and 
//                     passes the header and response back by reference. Errors 
//                     messages are reported in the header result variable if an error 
//                     occurs. This function is overloaded, therefore post data and 
//                     port number are optional.
//
// Modifications: 1/31/2011; David Cervenan - Initial version
//
////////////////////////////////////////////////////////////////////////////////////////////
ULong   lul_Session, &
            lul_Connect, &
            lul_Request, &
            lul_Error, &
            lul_Len, &
            lul_NoBytesRead, &
            lul_Null, &
            lul_HeaderLen, &
            lul_ContentLen, &
            lul_TotalLen

String   ls_Null, &
            ls_URL, &
            ls_OutBuffer, &
            ls_HttpString, &
            ls_Protocol, &
            ls_Object, &
            ls_Verb, &
            ls_ErrorTxt, &
            ls_HeaderBuffer, &
            ls_Header, &
            ls_Content, &
            ls_XMLString
			 
Long     ll_Pos

Int        li_Ret
			 
Boolean lb_DataRead, &
            lb_HeaderRead
				
Blob      lblb_Content, &
            lblb_OutBuffer

n_cst_encoder lnv_Encoder

try
	// Check to make sure we are using the correct OS for this process
	if not WinHttpCheckPlatform ( ) then
		as_header_result = "Your current Operating System is not supported with this process."
		
		Return FAILURE
	end if
	
	lnv_Encoder = create n_cst_encoder
	
	// Encode the URL to convert any "unsafe" characters
	as_url = lnv_Encoder.of_EncodeURL ( as_url )
	
	destroy lnv_Encoder
	
	SetNull ( ls_Null )
	SetNull ( lul_Null )
	
	// Assign variables for processing
	ls_URL       = as_url
	ls_Protocol = Upper ( Left ( ls_URL, 5 ) )
	ls_Content = as_post_data
	
	// Determine if we are performing a GET or POST request
	if not IsNull ( ls_Content ) and ls_Content <> "" then
		ls_Verb           = "POST"
		ls_Header        = as_header  //"Content-Type: application/x-www-form-urlencoded"
		lul_HeaderLen  = Len ( ls_Header )
		lblb_Content    = Blob ( ls_Content, EncodingANSI! )
		lul_ContentLen = Len ( lblb_Content )
		
//		if Trim ( as_header ) <> "" then ls_Header += "~r~n" + Trim ( as_header )
	else
		ls_Verb = "GET"
		SetNull ( ls_Header )
		SetNull ( lul_HeaderLen )
		SetNull ( lblb_Content )
		SetNull ( lul_ContentLen )
		SetNull ( lul_ContentLen )
	end if
	
	// Determine if the request is using HTTP or HTTPS
	choose case ls_Protocol
		case "HTTPS"
			ll_Pos = Pos ( ls_URL, "/", 9 )
			
			if ll_Pos > 0 then
				ls_Object = Mid ( ls_URL, ll_Pos )
				ls_URL     = Mid ( ls_URL, 9, ll_Pos - 9 )
			else
				SetNull ( ls_Object )
				ls_URL = Mid ( ls_URL, 9 )
			end if
			
		case "HTTP:"
			ll_Pos = Pos ( ls_URL, "/", 8 )
			
			if ll_Pos > 0 then
				ls_Object = Mid ( ls_URL, ll_Pos )
				ls_URL     = Mid ( ls_URL, 8, ll_Pos - 8 )
			else
				SetNull ( ls_Object )
			
				ls_URL = Mid ( ls_URL, 8 )
			end if
			
		case else
			as_header_result = "Please enter a valid URL. (Ex. - http://www.webserver.com)"
			
			Return FAILURE
			
	end choose
	
	// Open the connection
	lul_Session = WinHttpOpen ( "HTTP Handler", WINHTTP_ACCESS_TYPE_NO_PROXY, ls_Null, ls_Null, 0 )
	
	if lul_Session > 0 then
		// Assign the port number
		if ls_Protocol = "HTTPS" then
			if aul_port_no = 0 then aul_port_no = INTERNET_DEFAULT_HTTPS_PORT
		else
			if aul_port_no = 0 then aul_port_no = INTERNET_DEFAULT_HTTP_PORT
		end if
		
		// Connect to the URL and port
		lul_Connect = WinHttpConnect ( lul_Session, ls_URL, aul_port_no, 0 )
		
		if lul_Connect > 0 then
			// Open the request
			if ls_Protocol = "HTTPS" then
				lul_Request = WinHttpOpenRequest ( lul_Connect, ls_Verb, ls_Object, ls_Null, ls_Null, ls_Null, WINHTTP_FLAG_SECURE )
			else
				lul_Request = WinHttpOpenRequest ( lul_Connect, ls_Verb, ls_Object, ls_Null, ls_Null, ls_Null, 0 )
			end if
			
			if lul_Request > 0 then
				// Send the request along with headers to the specified URL
				if WinHttpSendRequest ( lul_Request, ls_Header, lul_HeaderLen, lblb_Content, lul_ContentLen, lul_ContentLen, 0 ) then
					// Receive the response from the URL
					if WinHttpReceiveResponse ( lul_Request, ls_Null ) then
						// Get the length of header response
						lb_HeaderRead = WinHttpQueryHeaders ( lul_Request, WINHTTP_QUERY_RAW_HEADERS_CRLF, ls_Null, ls_Null, lul_Len, lul_Null )
						
						// Allocate space in the buffer string for the header information
						ls_HeaderBuffer = Space ( lul_Len )
						
						// Get the header
						if WinHttpQueryHeaders ( lul_Request, WINHTTP_QUERY_RAW_HEADERS_CRLF, ls_Null, ls_HeaderBuffer, lul_Len, lul_Null ) then							
							as_header_result = ls_HeaderBuffer
						end if
						
						lul_Len = 0
						
						do
							// Get the length of the response
							if WinHttpQueryDataAvailable ( lul_Request, lul_Len ) then
								// Allocate space in the buffer string for the response
								ls_OutBuffer   = Space ( lul_Len )
								lblb_OutBuffer = Blob ( ls_OutBuffer, EncodingUTF8! )
								
								// Get the response
								lb_DataRead = WinHttpReadData ( lul_Request, lblb_OutBuffer, lul_Len, lul_NoBytesRead )
								
								if lb_DataRead and lul_NoBytesRead > 0 then
									ablb_internet_result += lblb_OutBuffer
								end if
							end if
						loop while lul_Len > 0
					else
						lul_Error = GetLastError ( )
					end if
				else
					lul_Error = GetLastError ( )
				end if
			else
				lul_Error = GetLastError ( )
			end if
		else
			lul_Error = GetLastError ( )
		end if
	else
		lul_Error = GetLastError ( )
	end if
	
	// Close all handles
	WinHttpCloseHandle ( lul_Connect )
	WinHttpCloseHandle ( lul_Session )
	WinHttpCloseHandle ( lul_Request )
	
	if lul_Error > 0 then
		// If a retry count was specified, then retry the request again
		if ai_retry_count > 0 then
			// Set the initial retry count
			if ii_RetryCount = -1 then
				ii_RetryCount = ai_retry_count
			end if
			
			// If all retry counts have not been expended, then attempt request again
			if ii_RetryCount > 0 then
				ii_RetryCount --
				
				li_Ret = this.of_SendURLRequest ( as_url, as_header, as_post_data, aul_port_no, ai_retry_count, as_header_result, ablb_internet_result )
				
				Return li_Ret
			else
				ls_ErrorTxt          = this.of_ProcessError ( lul_Error )
				as_header_result = "Error #: " + String ( lul_Error ) + " encountered: " + ls_ErrorTxt
				
				Return FAILURE
			end if
		else		
			ls_ErrorTxt          = this.of_ProcessError ( lul_Error )
			as_header_result = "Error #: " + String ( lul_Error ) + " encountered: " + ls_ErrorTxt
			
			Return FAILURE
		end if
	else
		Return SUCCESS
	end if
		
catch ( Throwable t )
	lul_Error             = GetLastError ( )
	ls_ErrorTxt          = this.of_ProcessError ( lul_Error )
	as_header_result = "An error occurred: " + t.GetMessage ( ) + " HTTP API Error: " + String ( lul_Error ) + " - " + ls_ErrorTxt
	
	if IsValid ( lnv_Encoder ) then destroy lnv_Encoder
	
	Return FAILURE
	
end try
end function

public function integer of_sendurlrequest (string as_url, integer ai_retry_count, ref string as_header_result, ref blob ablb_internet_result);///////////////////////////////////////////////////////////////////////////////////////////
//
// Function:      of_SendURLRequest
//
// Author:        David Cervenan
//
// Access:        Public
//
// Arguments:  String as_url
//                    Integer ai_retry_count
//                    String as_header_result (By reference)
//                    Blob ablb_internet_result (By reference)
//
// Returns:       Integer
//
// Description:   This is an overloaded function that calls of_SendURLRequest if
//                     post data and port number are not specified.
//
// Modifications: 1/31/2011; David Cervenan - Initial version
//
////////////////////////////////////////////////////////////////////////////////////////////
Return this.of_SendURLRequest ( as_url, "", "", 0, ai_retry_count, as_header_result, ablb_internet_result )
end function

public function integer of_sendurlrequest (string as_url, string as_post_data, integer ai_retry_count, ref string as_header_result, ref blob ablb_internet_result);///////////////////////////////////////////////////////////////////////////////////////////
//
// Function:      of_SendURLRequest
//
// Author:        David Cervenan
//
// Access:        Public
//
// Arguments:  String as_url
//                    String as_post_data
//                    Integer ai_retry_count
//                    String as_header_result (By reference)
//                    Blob ablb_internet_result (By reference)
//
// Returns:       Integer
//
// Description:   This is an overloaded function that calls of_SendURLRequest if
//                     port number is not specified.
//
// Modifications: 1/31/2011; David Cervenan - Initial version
//
////////////////////////////////////////////////////////////////////////////////////////////
Return this.of_SendURLRequest ( as_url, "", as_post_data, 0, ai_retry_count, as_header_result, ablb_internet_result )
end function

public function integer of_sendurlrequest (string as_url, unsignedlong aul_port_no, integer ai_retry_count, ref string as_header_result, ref blob ablb_internet_result);///////////////////////////////////////////////////////////////////////////////////////////
//
// Function:      of_SendURLRequest
//
// Author:        David Cervenan
//
// Access:        Public
//
// Arguments:  String as_url
//                    ULong aul_port_no
//                    Integer ai_retry_count
//                    String as_header_result (By reference)
//                    Blob ablb_internet_result (By reference)
//
// Returns:       Integer
//
// Description:   This is an overloaded function that calls of_SendURLRequest if
//                     post data is not specified.
//
// Modifications: 1/31/2011; David Cervenan - Initial version
//
////////////////////////////////////////////////////////////////////////////////////////////
Return this.of_SendURLRequest ( as_url, "", "", aul_port_no, ai_retry_count, as_header_result, ablb_internet_result )
end function

on n_cst_httphandler.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cst_httphandler.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

