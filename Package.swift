// swift-tools-version:5.6

import PackageDescription

let package = Package(
  name: "CSVUtils",
  platforms: [
    .macOS(.v12),
    .iOS(.v15),
  ],
  products: [
    .executable(name: "CSVUtils", targets: ["CSVUtils"]),
  ],
  targets: [
    .executableTarget(name: "CSVUtils"),
  ]
)
