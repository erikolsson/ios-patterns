// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "MainApp",
  platforms: [.iOS(.v15)],
  products: [
    .library(
      name: "MainApp",
      targets: ["MainApp"]),
  ],
  dependencies: [
    .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "0.39.0"),
    .package(url: "https://github.com/robb/Cartography.git", from: "4.0.0"),
  ],
  targets: [

    .target(name: "Common",
            dependencies: [
              .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
              .product(name: "Cartography", package: "Cartography")
            ]),

    .target(name: "LoadAndNavigate",
            dependencies: [
              "Common"
            ]),

    .target(name: "NavigateAndLoad",
            dependencies: [
              "Common"
            ]),

    .target(name: "Downloads",
            dependencies: [
              "Common"
            ]),

    .target(name: "Form",
            dependencies: [
              "Common"
            ]),

    .target(
      name: "MainApp",
      dependencies: [
        "Common",
        "LoadAndNavigate",
        "NavigateAndLoad",
        "Downloads",
        "Form"
      ]),

    .testTarget(
      name: "MainAppTests",
      dependencies: ["MainApp"]),
  ]
)
