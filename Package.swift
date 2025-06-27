// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription

let package = Package(
  name: "RMessage",
  platforms: [
    .iOS(.v11),
  ],
  products: [
    .library(name: "RMessage", targets: ["RMessage"]),
  ],
  dependencies: [],
  targets: [
    .target(
      name: "RMessage",
    ),
    .testTarget(
      name: "RMessageTests",
      dependencies: ["RMessage"]
    ),
  ]
)
