// swift-tools-version:5.10
import PackageDescription

let package = Package(
  name: "RMessage",
  platforms: [
    .iOS(.v17),
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
