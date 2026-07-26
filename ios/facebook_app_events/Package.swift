// swift-tools-version: 5.9
// Copyright (c) Oddbit (https://oddbit.id)
//
// This source file is part of facebook_app_events.
// Licensed under the Apache License, Version 2.0. See LICENSE and NOTICE.

// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "facebook_app_events",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        // If the plugin name contains "_", the library name must use "-".
        .library(name: "facebook-app-events", targets: ["facebook_app_events"])
    ],
    dependencies: [
        .package(name: "FlutterFramework", path: "../FlutterFramework"),
        // Keep SwiftPM on the audited 18.x SDK line. The kids-app privacy
        // guarantee is enforced by this plugin rather than vendor defaults.
        .package(url: "https://github.com/facebook/facebook-ios-sdk.git", "18.0.0"..<"19.0.0")
    ],
    targets: [
        .target(
            name: "facebook_app_events",
            dependencies: [
                .product(name: "FlutterFramework", package: "FlutterFramework"),
                .product(name: "FacebookCore", package: "facebook-ios-sdk"),
                .product(name: "FacebookBasics", package: "facebook-ios-sdk")
            ]
        )
    ]
)
