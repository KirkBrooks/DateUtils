/*  DateFormatter class
 Created by: Kirk Brooks as Designer, Created: 07/20/25, 09:37:11
 ------------------
 Singleton for handling all date/time formatting needs
 Stage 1: Core foundation with input type detection

*/

// Pattern storage - functional out of the box
property patterns : Object:={}

shared singleton Class constructor
	// Self-configuring - no initialization needed
	This.patterns.logFormat:="yyyy-MM-dd HH:mm:ss.SSS"
	This.patterns.screenFormat:="MMM d, yyyy"
	This.patterns.apiFormat:="yyyy-MM-ddTHH:mm:ss.SSSZ"
	
Function format() : Text
	// Core formatting method with flexible parameter handling
	// Returns empty string on any error - safe for web/remote processes
	
	var $params : Collection
	var $pattern : Text
	var $dateStr : Text
	var $inputType1; $inputType2 : Integer
	var $date : Date
	var $time : Time
	
	$params:=Copy parameters
	
	// Need at least input + pattern
	If ($params.length<2)
		return ""
	End if 
	
	// Pattern is always the last parameter
	$pattern:=$params[$params.length-1]
	
	If ($pattern="")
		return ""
	End if 
	
	Case of 
		: ($params.length=2)
			// Single input + pattern: format($input; $pattern)
			$inputType1:=Value type($params[0])
			
			Case of 
				: ($inputType1=Is date)
					$date:=$params[0]
					$dateStr:=This._formatDate($date; $pattern)
					
				: ($inputType1=Is time)
					$time:=$params[0]
					$dateStr:=This._formatTime($time; $pattern)
					
				: ($inputType1=Is real)
					// Unix epoch timestamp
					$date:=This._epochToDate($params[0])
					$dateStr:=This._formatDate($date; $pattern)
					
				: ($inputType1=Is text) && (Match regex("^\\d{4}-\\d{2}-\\d{2}$"; $params[0]; 1))
					// Date-only ISO string like "2025-04-05"
					$date:=Date($params[0]+"T00:00:00")
					$dateStr:=This._formatDate($date; $pattern)
					
				: ($inputType1=Is text) && (Match regex("^\\d{1,2}/\\d{1,2}/\\d{2,4}$"; $params[0]; 1))
					// US/European date format like "01/02/2025" - let system locale handle it
					$date:=Date($params[0])
					$dateStr:=This._formatDate($date; $pattern)
					
				: ($inputType1=Is text)
					// Assume full ISO timestamp like "2025-04-05T14:30:00Z"
					$date:=Date($params[0])
					$time:=Time($params[0])
					$dateStr:=This._formatDateTime($date; $time; $pattern)
					
				: ($inputType1=Is object)
					// Object with date/time properties
					$dateStr:=This._formatObject($params[0]; $pattern)
					
				Else 
					// Unknown type - return empty
					$dateStr:=""
					
			End case 
			
		: ($params.length=3)
			// Date + time + pattern: format($date; $time; $pattern)
			$inputType1:=Value type($params[0])
			$inputType2:=Value type($params[1])
			
			Case of 
				: ($inputType1=Is date) && ($inputType2=Is time)
					$date:=$params[0]
					$time:=$params[1]
					$dateStr:=This._formatDateTime($date; $time; $pattern)
					
				Else 
					// Invalid parameter combination
					$dateStr:=""
					
			End case 
			
		Else 
			// Too many parameters
			$dateStr:=""
			
	End case 
	
	return $dateStr
	
	//mark: --- Default format shortcuts
Function forLog($input : Variant) : Text
	return This.format($input; This.patterns.logFormat)
	
Function forScreen($input : Variant) : Text
	return This.format($input; This.patterns.screenFormat)
	
Function forAPI($input : Variant) : Text
	return This.format($input; This.patterns.apiFormat)
	
	//mark: --- Private implementation
Function _formatDate($date : Date; $pattern : Text) : Text
	// Format date using 4D's String() command
	var $result : Text
	
	If ($date=!00-00-00!)
		return ""
	End if 
	
	Try
		$result:=String($date; $pattern)
	Catch
		$result:=""
	End try
	
	return $result
	
Function _formatTime($time : Time; $pattern : Text) : Text
	// Format time using 4D's String() command
	var $result : Text
	
	Try
		$result:=String($time; $pattern)
	Catch
		$result:=""
	End try
	
	return $result
	
Function _formatDateTime($date : Date; $time : Time; $pattern : Text) : Text
	// Format combined date and time
	var $result : Text
	
	If ($date=!00-00-00!)
		return ""
	End if 
	
	Try
		$result:=String($date; $pattern; $time)
	Catch
		$result:=""
	End try
	
	return $result
	
Function _epochToDate($epoch : Real) : Date
	// Convert Unix epoch to 4D date
	// Returns null date on error
	var $result : Date
	
	If ($epoch<=0)
		return !00-00-00!
	End if 
	
	Try
		$result:=!1970-01-01!+($epoch/86400)
	Catch
		$result:=!00-00-00!
	End try
	
	return $result
	
Function _formatObject($obj : Object; $pattern : Text) : Text
	// Handle object input with date/time properties
	// Look for common property names
	var $date : Date
	var $time : Time
	var $result : Text
	
	If ($obj=Null)
		return ""
	End if 
	
	Try
		// Try common date property names
		Case of 
			: ($obj.date#Null)
				$date:=$obj.date
			: ($obj.created#Null)
				$date:=$obj.created
			: ($obj.timestamp#Null)
				$date:=$obj.timestamp
			: ($obj.datetime#Null)
				$date:=$obj.datetime
		End case 
		
		// Try common time property names
		Case of 
			: ($obj.time#Null)
				$time:=$obj.time
			: ($obj.created_time#Null)
				$time:=$obj.created_time
		End case 
		
		If ($date#!00-00-00!)
			$result:=This._formatDateTime($date; $time; $pattern)
		End if 
		
	Catch
		$result:=""
	End try
	
	return $result