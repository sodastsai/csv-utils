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
  dependencies: [
    .package(url: "https://github.com/apple/swift-argument-parser", from: "1.0.0"),
    .package(url: "https://github.com/yaslab/CSV.swift.git", .upToNextMinor(from: "2.4.3")),
  ],
  targets: [
    .executableTarget(name: "CSVUtils", dependencies: [
      .product(name: "ArgumentParser", package: "swift-argument-parser"),
    ]),
    .target(name: "CalendarCells",
            dependencies: [
              .product(name: "ArgumentParser", package: "swift-argument-parser"),
              .product(name: "CSV", package: "CSV.swift"),
            ]),
    .testTarget(name: "CalendarCellsTests",
                dependencies: [
                  .target(name: "CalendarCells"),
                  .product(name: "ArgumentParser", package: "swift-argument-parser"),
                ]),
  ]
)
