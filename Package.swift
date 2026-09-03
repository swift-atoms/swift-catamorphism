// swift-tools-version: 6.4
import CompilerPluginSupport
import PackageDescription

let package = Package(
    name: "swift-catamorphism-derivation",
    products: [
        .library(name: "Catamorphism Derivation", targets: ["Catamorphism Derivation"]),
        .library(name: "Catamorphism Derivation Core", targets: ["Catamorphism Derivation Core"]),
    ],
    dependencies: [
        .package(url: "https://github.com/swift-molecules/swift-recursive-derivation.git", branch: "main"),
        .package(url: "https://github.com/swiftlang/swift-syntax.git", "603.0.2"..<"604.0.0"),
    ],
    targets: [
        .target(name: "Catamorphism Derivation Core", dependencies: [
            .product(name: "Recursive Derivation Core", package: "swift-recursive-derivation"),
            .product(name: "SwiftSyntax", package: "swift-syntax"),
            .product(name: "SwiftSyntaxBuilder", package: "swift-syntax"),
        ]),
        .macro(name: "Catamorphism Derivation Macros", dependencies: [
            "Catamorphism Derivation Core",
            .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
            .product(name: "SwiftSyntax", package: "swift-syntax"),
            .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
        ]),
        .target(name: "Catamorphism Derivation", dependencies: ["Catamorphism Derivation Macros"]),
        .testTarget(
            name: "Catamorphism Derivation Tests",
            dependencies: ["Catamorphism Derivation"]
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    let ecosystem: [SwiftSetting] = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("Lifetimes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
    ]
    let package: [SwiftSetting] = []

    target.swiftSettings = (target.swiftSettings ?? []) + ecosystem + package
}
