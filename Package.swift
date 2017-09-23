//
//  Package.swift
//  MemoryFileSystem
//
//

import PackageDescription

let package = Package(
	name: "MemoryFileSystem",
	targets: [
		Target(name: "MemoryFileSystem", dependencies: ["FileSystem", "Optional"]),
		Target(name: "FileSystem", dependencies: []),
		Target(name: "Optional", dependencies: []),
	]
)

