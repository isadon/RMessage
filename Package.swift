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
  targets: [
    .target(
      name: "RMessage",
      resources: [.process("Resources")]
    ),
    .testTarget(
      name: "RMessageTests",
      dependencies: ["RMessage"]
    ),
  ]
)
