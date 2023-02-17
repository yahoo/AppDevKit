// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AppDevKit",
    platforms: [
        .iOS(.v10)
    ],
    products: [
         .library(
             name: "AppDevKit",
             targets: ["AppDevKit"]
         ),
        .library(
            name: "AppDevCommonKit",
            targets: ["AppDevCommonKit"]
        ),
        .library(
            name: "AppDevUIKit",
            targets: ["AppDevUIKit"]
        ),
        .library(
            name: "AppDevAnimateKit",
            targets: ["AppDevAnimateKit"]
        ),
        .library(
            name: "AppDevImageKit",
            targets: ["AppDevImageKit"]
        ),
        .library(
            name: "AppDevListViewKit",
            targets: ["AppDevListViewKit"]
        ),
        .library(
            name: "AppDevCameraKit",
            targets: ["AppDevCameraKit"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "AppDevKit",
            dependencies: ["AppDevCommonKit", "AppDevUIKit", "AppDevAnimateKit", "AppDevImageKit", "AppDevListViewKit", "AppDevCameraKit"],
            path: "AppDevPods/All"
        ),
        .target(
            name: "AppDevCommonKit",
            path: "AppDevPods/AppDevCommonKit",
            publicHeadersPath: "."
        ),
        .target(
            name: "AppDevUIKit",
            path: "AppDevPods/AppDevUIKit",
            publicHeadersPath: "."
        ),
        .target(
            name: "AppDevAnimateKit",
            path: "AppDevPods/AppDevAnimateKit",
            publicHeadersPath: "."
        ),
        .target(
            name: "AppDevImageKit",
            dependencies: ["AppDevCommonKit"],
            path: "AppDevPods/AppDevImageKit",
            publicHeadersPath: ".",
            cSettings: [
                .headerSearchPath("../")
            ]
        ),
        .target(
            name: "AppDevListViewKit",
            dependencies: ["AppDevUIKit", "AppDevCommonKit"],
            path: "AppDevPods/AppDevListViewKit",
            publicHeadersPath: ".",
            cSettings: [
                .headerSearchPath("../")
            ]
        ),
        .target(
            name: "AppDevCameraKit",
            path: "AppDevPods/AppDevCameraKit",
            publicHeadersPath: "."
        ),
        .testTarget(
            name: "AppDevKitTests",
            dependencies: ["AppDevKit"],
            path: "AppDevKitTests")
    ]
)

