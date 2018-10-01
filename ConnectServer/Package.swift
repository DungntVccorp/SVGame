// swift-tools-version:4.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ConnectServer",
    products: [
        .executable(name: "ConnectServer", targets: ["ConnectServer"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/IBM-Swift/BlueSocket.git", from: "1.0.20"),
        .package(url: "https://github.com/1024jp/GzipSwift.git", from: "4.0.4"),
        
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "ConnectServer",
            dependencies: ["Socket","Gzip"]),
        .testTarget(
            name: "ConnectServerTests",
            dependencies: ["ConnectServer"]),
    ]
)
