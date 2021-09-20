// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "SwiftUIComposableArchitecture",
  platforms: [
    .macOS(.v10_15),
    .iOS(.v14),
  ],
  products: [
    .library(name: "Client", targets: ["Client"]),
    .library(name: "Models", targets: ["Models"]),
    .library(name: "Components", targets: ["Components"]),
  ],
  dependencies: [
    .package(name: "Realm", url: "https://github.com/realm/realm-cocoa", from: "10.15.1"),
    .package(url: "https://github.com/onevcat/Kingfisher", from: "6.3.1"),
    .package(name: "Lottie", url: "https://github.com/airbnb/lottie-ios", from: "3.2.3"),
    .package(url: "https://github.com/CSolanaM/SkeletonUI", from: "1.0.5"),
    .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "0.27.0"),
    .package(url: "https://github.com/pointfreeco/swift-case-paths", from: "0.7.0"),
    .package(url: "https://github.com/pointfreeco/combine-schedulers", from: "0.5.0"),
    .package(url: "https://github.com/pointfreeco/swift-custom-dump", from: "0.1.0"),
    .package(url: "https://github.com/pointfreeco/swift-identified-collections", from: "0.3.0"),
    .package(url: "https://github.com/pointfreeco/xctest-dynamic-overlay", from: "0.2.0"),
    .package(name: "SnapshotTesting", url: "https://github.com/pointfreeco/swift-snapshot-testing", from: "1.9.0"),
  ],
  targets: [
    .target(
      name: "Client",
      dependencies: [
        "Models",
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
        .product(name: "CasePaths", package: "swift-case-paths"),
        .product(name: "CombineSchedulers", package: "combine-schedulers"),
        .product(name: "CustomDump", package: "swift-custom-dump"),
        .product(name: "IdentifiedCollections", package: "swift-identified-collections"),
        .product(name: "XCTestDynamicOverlay", package: "xctest-dynamic-overlay"),
        .product(name: "Realm", package: "Realm"),
        .product(name: "RealmSwift", package: "Realm"),
      ]
    ),
    .target(
      name: "Models",
      dependencies: [
        .product(name: "Realm", package: "Realm"),
        .product(name: "RealmSwift", package: "Realm"),
      ]
    ),
    .target(
      name: "Components",
      dependencies: [
        "Client",
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
        .product(name: "CasePaths", package: "swift-case-paths"),
        .product(name: "CombineSchedulers", package: "combine-schedulers"),
        .product(name: "CustomDump", package: "swift-custom-dump"),
        .product(name: "IdentifiedCollections", package: "swift-identified-collections"),
        .product(name: "XCTestDynamicOverlay", package: "xctest-dynamic-overlay"),
        .product(name: "Kingfisher", package: "Kingfisher"),
        .product(name: "SkeletonUI", package: "SkeletonUI"),
        .product(name: "Lottie", package: "Lottie"),
      ]
    ),
    .testTarget(
      name: "ModulesSnapshotTests",
      dependencies: [
        .product(name: "SnapshotTesting", package: "SnapshotTesting"),
      ],
      exclude: [
        "__Snapshots__",
      ],
      resources: [.process("Resources/")]
    ),
  ]
)
