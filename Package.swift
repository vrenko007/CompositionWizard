// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ComposableWizard",
    platforms: [
      .iOS(.v15),
    ],
    products: [
        .library(name: "AppMain", targets: ["AppMain"]),
        .library(name: "FeatureA", targets: ["FeatureA"]),

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
            .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
          ]
        ),
    ]
)
