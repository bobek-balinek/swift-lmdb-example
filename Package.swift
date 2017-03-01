import PackageDescription

let package = Package(
    name: "swift-lmdb-example",
    dependencies: [
        .Package(url: "https://github.com/IBM-Swift/Kitura.git", majorVersion: 1, minor: 2),
        .Package(url: "https://github.com/IBM-Swift/HeliumLogger.git", majorVersion: 1, minor: 1),
        .Package(url: "https://github.com/agisboye/SwiftLMDB.git", majorVersion: 1, minor: 0)
    ]
)
