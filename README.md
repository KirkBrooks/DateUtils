![version](https://img.shields.io/badge/version-20R4-5682DF)
![platform](https://img.shields.io/static/v1?label=platform&message=mac-intel%20|%20mac-arm%20|%20win-64&color=blue)
[![License: MIT](https://img.shields.io/github/license/KirkBrooks/DateUtils)](LICENSE)
![downloads](https://img.shields.io/github/downloads/kirkbrooks/DateUtils/total)

# DateUtils

A comprehensive 4D database project providing flexible date and time formatting utilities through the DateFormatter class. This project leverages 4D's new date customization features introduced in 20R4 to provide a unified, thread-safe formatting solution.

## Overview

DateUtils consolidates 4D's extensive formatting capabilities into a single, configurable, and extensible engine. The DateFormatter class is designed as a singleton that handles multiple input types and provides both predefined and custom formatting options.

## Features

- **Polymorphic Input Handling**: Accepts Date, Time, Real (Unix epoch), Text (timestamps), and Objects
- **Thread-Safe**: Shared singleton safe for web and remote processes
- **Silent Error Handling**: Returns empty strings on errors - never crashes
- **Self-Configuring**: Works immediately with sensible defaults
- **Extensible**: Add custom patterns and convenience functions dynamically

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

## Supported Input Types

- **Date Objects**: `!2025-12-25!`
- **Time Objects**: `?14:30:00?`
- **Unix Epoch Timestamps**: Real numbers representing Unix timestamps
- **Text Strings**: ISO dates, US format dates, ISO timestamps
- **Objects**: With properties like `date`, `created`, `timestamp`, `datetime`, `time`

## Default Formats

| Format | Pattern | Example Output |
|--------|---------|----------------|
| `default` | `"MMM d, yyyy"` | "Dec 25, 2025" |
| `logFormat` | `"yyyy-MM-dd HH:mm:ss.SSS"` | "2025-12-25 14:30:45.123" |
| `screenFormat` | `"MMM d, yyyy"` | "Dec 25, 2025" |
| `apiFormat` | `"yyyy-MM-ddTHH:mm:ss.SSSZ"` | "2025-12-25T14:30:45.123Z" |

## Installation

1. Clone or download this repository
2. Open the `DateUtils.4DProject` file in 4D
3. The DateFormatter class will be automatically available

## Usage Examples

### Basic Date Formatting

```4d
$result := DateFormatter.format(!2025-12-25!; "MMM d, yyyy")
// Result: "Dec 25, 2025"
```

### Time Formatting

```4d
$result := DateFormatter.format(?14:30:00?; "h:mm a")
// Result: "2:30 PM"
```

### Combined Date and Time

```4d
$result := DateFormatter.format(!2025-12-25!; ?14:30:00?; "MMM d 'at' h:mm a")
// Result: "Dec 25 at 2:30 PM"
```

### Unix Timestamp

```4d
$epoch := 1735142400  // Unix timestamp
$result := DateFormatter.format($epoch; "yyyy-MM-dd")
// Result: "2025-12-25"
```

### Object Input

```4d
$obj := New object("date"; !2025-12-25!; "time"; ?14:30:00?)
$result := DateFormatter.format($obj; "yyyy-MM-dd HH:mm")
// Result: "2025-12-25 14:30"
```

## Requirements

- 4D v20 R4 or later (required for advanced date customization features)
- Compatible with 4D Server environments
- Thread-safe for web and remote processes

## Documentation

Detailed documentation is available in the `Documentation/Classes/DateFormatter.md` file, which includes:

- Complete API reference
- Advanced usage examples
- Pattern syntax guide
- Troubleshooting tips

## Testing

The project includes test methods:

- `DateFormatter_test.4dm` - Comprehensive test suite for the DateFormatter class

## Project Structure

```text
DateUtils/
├── README.md                           # This file
├── Data/                              # 4D database data files
├── Documentation/
│   └── Classes/
│       └── DateFormatter.md          # Detailed class documentation
├── Project/
│   ├── DateUtils.4DProject           # Main project file
│   └── Sources/
│       ├── Classes/
│       │   └── DateFormatter.4dm     # DateFormatter class implementation
│       └── Methods/
│           ├── DateFormatter.4dm     # DateFormatter methods
│           ├── DateFormatter_test.4dm # Test suite
│           └── readMe.4dm           # Project notes
└── Resources/                        # Project resources
```

## Contributing

This project aims to provide a comprehensive date formatting solution for the 4D community. Contributions are welcome! Please:

1. Fork the repository
2. Create a feature branch
3. Add tests for new functionality
4. Submit a pull request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Author

Created by Kirk Brooks

## Acknowledgments

This project leverages 4D's date customization features introduced in v20 R4. For more information about these features, see:

- [4D Blog: Tailored customization for dates and times](https://blog.4d.com/tailored-customization-for-dates-and-times/)

---

*Note: This project hopes to provide a useful addition to the 4D community's date formatting tools without adding to the static of existing solutions.*
