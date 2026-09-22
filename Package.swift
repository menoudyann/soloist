// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "Soloist",
    platforms: [.macOS(.v14)],
    products: [
        .executable(name: "Soloist", targets: ["Soloist"])
    ],
    targets: [
        .executableTarget(name: "Soloist"),
        .testTarget(name: "SoloistTests", dependencies: ["Soloist"])
    ]
)
