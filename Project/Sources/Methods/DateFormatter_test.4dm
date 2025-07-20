//%attributes = {}
/* Purpose: 
 ------------------
 DateFormatter Test Suite
 Testing all input types and format patterns
 ------------------
*/

var $input_str; $dateStr; $pattern : Text
var $input_date : Date
var $input_time : Time
var $input_epoch : Real
var $input_obj : Object
var $dates : Collection:=[]

// === Test Timestamp strings ===
$input_str:=Timestamp
$dates.push("=== TIMESTAMP INPUT: "+$input_str+" ===")
$dates.push("Default: "+DateFormatter.forDefault($input_str))
$dates.push("Log: "+DateFormatter.forLog($input_str))
$dates.push("API: "+DateFormatter.forAPI($input_str))
$dates.push("Screen: "+DateFormatter.forScreen($input_str))
$dates.push("")

// === Test US date format ===
$input_str:="7/8/25"
$dates.push("=== US DATE: "+$input_str+" ===")
$dates.push("Log: "+DateFormatter.forLog($input_str))
$dates.push("API: "+DateFormatter.forAPI($input_str))
$dates.push("Screen: "+DateFormatter.forScreen($input_str))
$dates.push("")

// === Test ISO date string ===
$input_str:="2025-12-25"
$dates.push("=== ISO DATE: "+$input_str+" ===")
$dates.push("Log: "+DateFormatter.forLog($input_str))
$dates.push("API: "+DateFormatter.forAPI($input_str))
$dates.push("Screen: "+DateFormatter.forScreen($input_str))
$dates.push("")

// === Test Date objects ===
$input_date:=Current date
$dates.push("=== DATE OBJECT: "+String($input_date)+" ===")
$dates.push("Log: "+DateFormatter.forLog($input_date))
$dates.push("API: "+DateFormatter.forAPI($input_date))
$dates.push("Screen: "+DateFormatter.forScreen($input_date))
$dates.push("")

// === Test Time objects ===
$input_time:=Current time
$dates.push("=== TIME OBJECT: "+String($input_time)+" ===")
$dates.push("Log: "+DateFormatter.forLog($input_time))
$dates.push("API: "+DateFormatter.forAPI($input_time))
$dates.push("Screen: "+DateFormatter.forScreen($input_time))
$dates.push("")

// === Test Date + Time combination ===
$input_date:=Current date
$input_time:=Current time
$dates.push("=== DATE + TIME: "+String($input_date)+" "+String($input_time)+" ===")
$dates.push("Log: "+DateFormatter.format($input_date; $input_time; DateFormatter.patterns.logFormat))
$dates.push("API: "+DateFormatter.format($input_date; $input_time; DateFormatter.patterns.apiFormat))
$dates.push("Screen: "+DateFormatter.format($input_date; $input_time; DateFormatter.patterns.screenFormat))
$dates.push("")

// === Test Unix Epoch (Real) ===
$input_epoch:=1732550400  // Example epoch timestamp
$dates.push("=== UNIX EPOCH: "+String($input_epoch)+" ===")
$dates.push("Log: "+DateFormatter.forLog($input_epoch))
$dates.push("API: "+DateFormatter.forAPI($input_epoch))
$dates.push("Screen: "+DateFormatter.forScreen($input_epoch))
$dates.push("")

// === Test Object input ===
$input_obj:=New object("date"; Current date; "time"; Current time)
$dates.push("=== OBJECT INPUT: {date, time} ===")
$dates.push("Log: "+DateFormatter.forLog($input_obj))
$dates.push("API: "+DateFormatter.forAPI($input_obj))
$dates.push("Screen: "+DateFormatter.forScreen($input_obj))
$dates.push("")

// === Test custom patterns ===
$input_date:=Current date
$dates.push("=== CUSTOM PATTERNS ===")
$dates.push("EEEE, MMMM d, yyyy: "+DateFormatter.format($input_date; "EEEE, MMMM d, yyyy"))
$dates.push("dd/MM/yyyy: "+DateFormatter.format($input_date; "dd/MM/yyyy"))
$dates.push("MMM d 'at' h:mm a: "+DateFormatter.format($input_date; Current time; "MMM d 'at' h:mm a"))
$dates.push("")

// === Test error conditions ===
$dates.push("=== ERROR CONDITIONS ===")
$dates.push("Empty string: '"+DateFormatter.forLog("")+"'")
$dates.push("Invalid date: '"+DateFormatter.forLog("invalid")+"'")
$dates.push("Null object: '"+DateFormatter.forLog(New object)+"'")
$dates.push("Bad pattern: '"+DateFormatter.format(Current date; "bad-pattern")+"'")
$dates.push("")

// === Test dynamic pattern addition ===
DateFormatter.addPattern("customTest"; "'Today is' EEEE")
$dates.push("=== DYNAMIC PATTERN ===")
$dates.push("Added customTest pattern: "+DateFormatter.patterns.customTest)
$dates.push("Using patterns object: "+DateFormatter.format(Current date; DateFormatter.patterns.customTest))
$dates.push("Using dynamic function: "+DateFormatter.customTest(Current date))
$dates.push("")


ALERT($dates.join("\r"))



