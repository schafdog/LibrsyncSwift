# LibrsyncSwift

A modern Swift wrapper for librsync with full async/await support and streaming API for efficient delta synchronization.

## Features

- **Streaming API** - Constant memory usage for files of any size using AsyncSequence
- **Type-safe** - Comprehensive error handling with Swift enums
- **Thread-safe** - Full Sendable conformance for Swift 6 concurrency
- **HTTP-ready** - Direct integration with AsyncHTTPClient and Hummingbird
- **Cross-platform** - Supports macOS and Linux

## Installation

### Swift Package Manager

Add to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/schafdog/LibrsyncSwift.git", from: "1.0.0")
]
```

### System Requirements

LibrsyncSwift requires librsync to be installed on your system:

**macOS** (using Homebrew):
```bash
brew install librsync
```

**Linux** (Debian/Ubuntu):
```bash
sudo apt-get install librsync-dev
```

## Quick Start

### Basic Usage

```swift
import LibrsyncSwift

let rsync = Librsync()
let fileURL = URL(fileURLWithPath: "myfile.txt")

// Generate signature
let signatureData = try await rsync.generateSignature(from: fileURL)

// Load signature
let signatureHandle = try await rsync.loadSignature(from: signatureData)

// Generate delta
let deltaData = try await rsync.generateDelta(from: newFileURL, against: signatureHandle)

// Apply patch
try await rsync.applyPatch(delta: deltaData, toBasis: oldFileURL, output: patchedFileURL)
```

### Streaming API (for large files)

```swift
// Stream signature chunks
let signatureStream = rsync.signatureStream(from: fileURL)
for try await chunk in signatureStream {
    // Process each chunk without loading entire file
}

// Stream delta chunks
let deltaStream = rsync.deltaStream(from: newFileURL, against: signatureHandle)
for try await chunk in deltaStream {
    // Process each delta chunk
}
```

## Documentation

See [Sources/LibrsyncSwift/README.md](Sources/LibrsyncSwift/README.md) for detailed API documentation and examples.

## License

This program is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

## Author

Copyright (C) 2025 by Dennis Schafroth <dennis@schafroth.com>
