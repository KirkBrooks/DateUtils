//%attributes = {}
/* Purpose: wrapper for DateFormatter singleton
 ------------------
DateFormatter ()
 Created by: Kirk Brooks as Designer, Created: 07/20/25, 09:40:25
I think this is a cleaner implentation

$log := DateFormatter.forLog($timestamp)
$display := DateFormatter.forScreen($date)
$api := DateFormatter.forAPI($dateTime)
*/
#DECLARE : cs.DateFormatter
return cs.DateFormatter.me
