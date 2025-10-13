// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import Foundation

let librsyncPrefix: String = {
    // Detect typical Homebrew prefix at build time
    if FileManager.default.fileExists(atPath: "/opt/homebrew") {
        return "/opt/homebrew"
    } else if FileManager.default.fileExists(atPath: "/usr/local") {
        return "/usr/local"
    } else {
        return "/usr"
    }
}()

let package = Package(
    name: "LibrsyncSwift",
    platforms: [
        .macOS(.v14)
    ],
    products: [
        // Library for librsync Swift wrapper
        .library(
            name: "LibrsyncSwift",
            targets: ["LibrsyncSwift"]
        ),
    ],
    dependencies: [],
    targets: [
        // System library wrapper for librsync
        .systemLibrary(
            name: "Clibrsync",
            path: "Sources/Clibrsync",
            providers: [
                .apt(["librsync-dev"]),
                .brew(["librsync"])
            ]
        ),

        // Shared connection library
        .target(
            name: "LibrsyncSwift",
            dependencies: ["Clibrsync"],
            path: "Sources/LibrsyncSwift",
            exclude: ["README.md"],
            swiftSettings: [
                .unsafeFlags(["-I\(librsyncPrefix)/include"], .when(platforms: [.macOS])),
            ],
            linkerSettings: [
                .unsafeFlags(["-L\(librsyncPrefix)/lib"], .when(platforms: [.macOS])),
                .linkedLibrary("rsync")
            ]
        ),

        // Tests (Swift Testing - works on all platforms with Swift 6.1+)
        .testTarget(
            name: "LibrsyncSwiftTests",
            dependencies: [
                "LibrsyncSwift",
                "Clibrsync"
            ],
            path: "Tests/LibrsyncSwiftTests",
            exclude: [
                "README.md",
                "DummyTests.swift"  // Old placeholder, no longer needed
            ]
        ),
    ]
)
