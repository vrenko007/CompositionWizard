// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "ComposableWizard",
  platforms: [
    .iOS(.v15),
    .macOS(.v13)
  ],
  products: [
    .library(name: "AppMain", targets: ["AppMain"]),
    .library(name: "FeatureA", targets: ["FeatureA"]),
    .library(name: "FeatureB", targets: ["FeatureB"]),
    .library(name: "FeatureC", targets: ["FeatureC"]),
    .library(name: "FormData", targets: ["FormData"]),
    .library(name: "ComposableNavigationTools", targets: ["ComposableNavigationTools"]),
  ],
  dependencies: [
    .package(url: "https://github.com/pointfreeco/swift-composable-architecture", .upToNextMajor(from: "1.2.0"))
  ],
  targets: [
    .target(
      name: "AppMain",
      dependencies: [
        "FeatureA"
      ]
    ),
    .target(
      name: "FeatureA",
      dependencies: [
        "FeatureB",
        "FeatureC",
        "FormData",
        "ComposableNavigationTools",
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
      ]
    ),
    .target(
      name: "FeatureB",
      dependencies: [
        "FeatureD",
        "FormData",
        "ComposableNavigationTools",
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
      ]
    ),
    .target(
      name: "FeatureC",
      dependencies: [
        "FeatureD",
        "FormData",
        "ComposableNavigationTools",
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
      ]
    ),
    .target(
      name: "FeatureD",
      dependencies: [
        "FormData",
        "ComposableNavigationTools",
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
      ]
    ),
    .target(
      name: "FormData"
    ),
    .target(
      name: "ComposableNavigationTools",
      dependencies: [
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
      ]
    ),
  ]
)
