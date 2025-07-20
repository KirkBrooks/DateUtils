//%attributes = {}
/* Purpose: 
 ------------------
DateFormatter_test ()
 Created by: Kirk Brooks as Designer, Created: 07/20/25, 09:40:07
*/

var $input_str; $result; $pattern : Text

$input_str:=Timestamp
$pattern:=DateFormatter.logFormat
$result:=DateFormatter.format($input_str; $pattern)



