# DateFormatter Class Documentation

A comprehensive singleton class for handling all date/time formatting needs in 4D applications. The DateFormatter consolidates 4D's extensive formatting capabilities into a single, configurable, and extensible engine.

## Quick Start

```4d
// Basic usage with default formats
$default := DateFormatter.forDefault(Current date)
$log := DateFormatter.forLog(Current date)
$display := DateFormatter.forScreen(Current date)
$api := DateFormatter.forAPI(Timestamp)

// Custom formatting
$custom := DateFormatter.format(Current date; "EEEE, MMMM d, yyyy")
```

## Core Features

- **Polymorphic Input Handling**: Accepts Date, Time, Real (Unix epoch), Text (timestamps), and Objects
- **Thread-Safe**: Shared singleton safe for web and remote processes  
- **Silent Error Handling**: Returns empty strings on errors - never crashes
- **Self-Configuring**: Works immediately with sensible defaults
- **Extensible**: Add custom patterns and convenience functions dynamically

## Input Types Supported

### Date Objects
```4d
$result := DateFormatter.format(!2025-12-25!; "MMM d, yyyy")
// Result: "Dec 25, 2025"
```

### Time Objects  
```4d
$result := DateFormatter.format(?14:30:00?; "h:mm a")
// Result: "2:30 PM"
```

### Date + Time Combination
```4d
$result := DateFormatter.format(!2025-12-25!; ?14:30:00?; "MMM d 'at' h:mm a")
// Result: "Dec 25 at 2:30 PM"
```

### Unix Epoch Timestamps (Real)
```4d
$epoch := 1735142400  // Unix timestamp
$result := DateFormatter.format($epoch; "yyyy-MM-dd")
// Result: "2025-12-25"
```

### Text Strings

#### ISO Date Strings
```4d
$result := DateFormatter.format("2025-12-25"; "MMM d, yyyy")
// Result: "Dec 25, 2025"
```

#### US Date Format
```4d
$result := DateFormatter.format("12/25/2025"; "EEEE, MMMM d")
// Result: "Thursday, December 25"
```

#### ISO Timestamps
```4d
$result := DateFormatter.format("2025-12-25T14:30:00Z"; "MMM d 'at' h:mm a")
// Result: "Dec 25 at 2:30 PM"
```

### Object Input
```4d
$obj := New object("date"; !2025-12-25!; "time"; ?14:30:00?)
$result := DateFormatter.format($obj; "yyyy-MM-dd HH:mm")
// Result: "2025-12-25 14:30"
```

Supported object properties: `date`, `created`, `timestamp`, `datetime`, `time`, `created_time`

## Default Formats

The DateFormatter comes with four built-in formats:

| Format | Pattern | Example Output |
|--------|---------|----------------|
| `default` | `"MMM d, yyyy"` | "Dec 25, 2025" |
| `logFormat` | `"yyyy-MM-dd HH:mm:ss.SSS"` | "2025-12-25 14:30:45.123" |
| `screenFormat` | `"MMM d, yyyy"` | "Dec 25, 2025" |
| `apiFormat` | `"yyyy-MM-ddTHH:mm:ss.SSSZ"` | "2025-12-25T14:30:45.123Z" |

### Default Format Methods

```4d
// Quick access to default formats
$default := DateFormatter.forDefault($input)
$log := DateFormatter.forLog($input)
$display := DateFormatter.forScreen($input)  
$api := DateFormatter.forAPI($input)
```

### Default Pattern Property

The `default` pattern can be accessed and modified using computed properties:

```4d
// Get current default pattern
$pattern := DateFormatter.defaultPattern  // "MMM d, yyyy"

// Change default pattern for your project
DateFormatter.defaultPattern := "dd/MM/yyyy"

// Now forDefault() uses the new pattern
$result := DateFormatter.forDefault($date)  // "25/12/2025"
```

## Custom Patterns

Use any 4D date/time pattern supported in the `String()` command:

```4d
// Common patterns
DateFormatter.format($date; "EEEE, MMMM d, yyyy")     // "Thursday, December 25, 2025"
DateFormatter.format($date; "dd/MM/yyyy")             // "25/12/2025"  
DateFormatter.format($time; "h:mm a")                 // "2:30 PM"
DateFormatter.format($date; $time; "MMM d 'at' h:mm a") // "Dec 25 at 2:30 PM"
```

### Pattern Reference

Common pattern symbols (see 4D documentation for complete list):

| Symbol | Meaning | Example |
|--------|---------|---------|
| `yyyy` | 4-digit year | 2025 |
| `yy` | 2-digit year | 25 |
| `MMMM` | Full month name | December |
| `MMM` | Abbreviated month | Dec |
| `MM` | 2-digit month | 12 |
| `dd` | 2-digit day | 25 |
| `EEEE` | Full day name | Thursday |
| `EEE` | Abbreviated day | Thu |
| `HH` | 24-hour format | 14 |
| `h` | 12-hour format | 2 |
| `mm` | Minutes | 30 |
| `ss` | Seconds | 45 |
| `SSS` | Milliseconds | 123 |
| `a` | AM/PM | PM |

## Dynamic Pattern Management

### Adding Custom Patterns

```4d
// Add a new pattern and convenience function
DateFormatter.addPattern("invoice"; "MMMM d, yyyy")

// Now use either approach:
$result1 := DateFormatter.format($date; DateFormatter.patterns.invoice)
$result2 := DateFormatter.invoice($date)  // Convenience function created automatically
```

### Accessing Patterns

```4d
// Check if pattern exists
If (DateFormatter.patterns["myPattern"] # Null)
    // Pattern exists
End if

// List all available patterns
For each ($name; DateFormatter.patterns)
    $pattern := DateFormatter.patterns[$name]
    // Process each pattern
End for each
```

## Error Handling

The DateFormatter is designed for web and remote processes where error dialogs are not visible:

- **Invalid inputs** return empty strings
- **Malformed patterns** return empty strings  
- **Null/undefined values** return empty strings
- **No exceptions thrown** - guaranteed safe operation

```4d
// All of these return empty strings safely
$empty1 := DateFormatter.format(""; "yyyy-MM-dd")           // Empty input
$empty2 := DateFormatter.format("invalid"; "yyyy-MM-dd")    // Invalid date
$empty3 := DateFormatter.format($date; "")                  // Empty pattern
$empty4 := DateFormatter.format($date; "bad-pattern")       // Invalid pattern
```

## Method Access

For cleaner code, wrap the singleton in a method:

```4d
// Create method: DateFormatter()
#DECLARE : cs.DateFormatter
return cs.DateFormatter.me
```

Then use without the `cs.` prefix:

```4d
$result := DateFormatter.format($date; "MMM d, yyyy")
$log := DateFormatter.forLog($timestamp)
```

## Thread Safety

The DateFormatter is a shared singleton, making it thread-safe for:
- Web processes
- Preemptive processes  
- Remote client connections
- Concurrent access from multiple contexts

Pattern additions use automatic `Use/End use` blocks to ensure thread safety.

## Performance Notes

- **Input type detection** is efficient using `Value type()`
- **Regex matching** only applied to text inputs for format detection
- **Pattern storage** in object for fast lookup
- **Error handling** with Try/Catch blocks prevents process interruption

## Limitations

- **European date formats** (dd/MM/yyyy) depend on system locale settings
- **Timezone conversion** not included in Stage 1 (future enhancement)
- **No pattern validation** - malformed patterns will be apparent immediately during development

## Examples

### Basic Formatting
```4d
$date := !2025-12-25!
$time := ?14:30:45?

// Date only
$result := DateFormatter.format($date; "EEEE, MMMM d, yyyy")
// "Thursday, December 25, 2025"

// Time only  
$result := DateFormatter.format($time; "h:mm:ss a")
// "2:30:45 PM"

// Combined
$result := DateFormatter.format($date; $time; "MMM d 'at' h:mm a")
// "Dec 25 at 2:30 PM"
```

### Working with Different Input Types
```4d
// Current timestamp
$now := DateFormatter.forLog(Timestamp)

// Default formatting
$readable := DateFormatter.forDefault(Current date)

// Unix epoch
$epoch := 1735142400
$display := DateFormatter.forScreen($epoch)

// ISO date string
$iso := "2025-12-25"
$formatted := DateFormatter.format($iso; "EEEE, MMMM d")

// Object from database record
$record := Find first([Orders]; [Orders]created # !00-00-00!)
$display := DateFormatter.forScreen($record)  // Uses 'created' property
```

### Custom Business Formats
```4d
// Add business-specific patterns
DateFormatter.addPattern("report"; "'Report for' MMMM yyyy")
DateFormatter.addPattern("filename"; "yyyyMMdd_HHmmss")
DateFormatter.addPattern("invoice"; "MMMM d, yyyy")

// Use them
$header := DateFormatter.report(Current date)        // "Report for December 2025"
$filename := DateFormatter.filename(Current date)    // "20251225_143045"
$invoice := DateFormatter.invoice($orderDate)        // "December 25, 2025"
```

---

*DateFormatter v1.0 - Stage 1 Foundation*