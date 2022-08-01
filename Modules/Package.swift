// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

extension Target {
    static var uiComponents: Target { .target(name: "UIComponents") }
    static var cocoaToysKit: Target { .target(name: "CocoaToysKit") }
    static var dependencies: Target { .target(name: "Dependencies", dependencies: [.targetItem(name: Self.cocoaToysKit.name, condition: nil)]) }
    static var caffeinator: Target { .target(
        name: "Caffeinator",
        dependencies: [
            .target(name: Self.cocoaToysKit.name),
            .target(name: Self.uiComponents.name)
        ])
    }
}

let targets: [Target] = [
    .uiComponents,
    .cocoaToysKit,
    .dependencies,
    .caffeinator,
]

let package = Package(
    name: "Modules",
    platforms: [
        .macOS(.v11)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "Modules",
            type: .dynamic,
            targets: targets.map(\.name)
        ),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: targets
)
