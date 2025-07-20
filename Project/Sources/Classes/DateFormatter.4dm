/*  DateFormatter class
 Created by: Kirk Brooks as Designer, Created: 07/20/25, 09:37:11
 ------------------
 Singleton for handling all date/time formatting needs
 Stage 1: Core foundation with input type detection

*/

// Core format properties - functional out of the box
property patterns : Object:={}

shared singleton Class constructor
	// Self-configuring - no initialization needed
	This.patterns.logFormat:="yyyy-MM-dd HH:mm:ss.SSS"
	This.patterns.screenFormat:="MMM d, yyyy"
	This.patterns.apiFormat:="yyyy-MM-ddTHH:mm:ss.SSSZ"
	
Function format()->$dateStr : Text
	// Core formatting method with flexible parameter handling
	// Returns empty string on any error - safe for web/remote processes
	var $params : Collection
	var $pattern : Text
	
	$params:=Copy parameters
	
	// Pattern is always the last parameter
	If ($params.length<2) || ($params.length>3)
		return ""  // Need at least input + pattern
	End if 
	
	$pattern:=$params[$params.length-1]
	If ($pattern="")
		return ""
	End if 
	
	Case of 
		: ($params.length=2)  // format($input; $pattern)
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
					If ($date#!00-00-00!)
						$dateStr:=This._formatDate($date; $pattern)
					End if 
					
				: ($inputType1=Is text)
					// ISO timestamp string
					$date:=Date($params[0])
					$time:=Time($params[0])
					If ($date#!00-00-00!)
						$dateStr:=This._formatDateTime($date; $time; $pattern)
					End if 
					
				: ($inputType1=Is object)
					// Object with date/time properties
					$dateStr:=This._formatObject($params[0]; $pattern)
					
				Else 
					// Unknown type - return empty
					$dateStr:=""
					
			End case 
			
		: ($params.length=3)  // format($date; $time; $pattern)
			$inputType1:=Value type($params[0])
			$inputType2:=Value type($params[1])
			
			Case of 
				: ($inputType1=Is date) && ($inputType2=Is time)
					// Date + Time + Pattern
					$date:=$params[0]
					$time:=$params[1]
					If ($date#!00-00-00!)
						$dateStr:=This._formatDateTime($date; $time; $pattern)
					End if 
					
				Else 
					// Invalid parameter combination
					$dateStr:=""
					
			End case 
			
		Else 
			// Invalid parameter count
			$dateStr:=""
			
	End case 
	
	
	//mark: --- Default format shortcuts
Function forLog($input : Variant) : Text
	return This.format($input; This.logFormat)
	
Function forScreen($input : Variant) : Text
	return This.format($input; This.screenFormat)
	
Function forAPI($input : Variant) : Text
	return This.format($input; This.apiFormat)
	
	//mark: --- Private implementation
Function _formatDate($date : Date; $pattern : Text) : Text
	// Format date using 4D's String() command
	var $dateStr : Text
	
	If ($date=!00-00-00!)
		return ""
	End if 
	
	Try
		$dateStr:=String($date; $pattern)
	Catch
		$dateStr:=""
	End try
	
	return $dateStr
	
Function _formatTime($time : Time; $pattern : Text) : Text
	// Format time using 4D's String() command
	var $dateStr : Text
	
	Try
		$dateStr:=String($time; $pattern)
	Catch
		$dateStr:=""
	End try
	
	return $dateStr
	
Function _formatDateTime($date : Date; $time : Time; $pattern : Text) : Text
	// Format combined date and time
	var $dateStr : Text
	
	If ($date=!00-00-00!)
		return ""
	End if 
	
	Try
		$dateStr:=String($date; $pattern; $time)
	Catch
		$dateStr:=""
	End try
	
	return $dateStr
	
Function _epochToDate($epoch : Real) : Date
	// Convert Unix epoch to 4D date
	// Returns null date on error
	var $dateStr : Date
	
	If ($epoch<=0)
		return !00-00-00!
	End if 
	
	Try
		$dateStr:=!1970-01-01!+($epoch/86400)
	Catch
		$dateStr:=!00-00-00!
	End try
	
	return $dateStr
	
Function _formatObject($obj : Object; $pattern : Text) : Text
	// Handle object input with date/time properties
	// Look for common property names
	var $date : Date
	var $time : Time
	var $dateStr : Text
	
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
			$dateStr:=This._formatDateTime($date; $time; $pattern)
		End if 
		
	Catch
		$dateStr:=""
	End try
	
	return $dateStr