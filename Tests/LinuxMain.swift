//
//  MemoryFileSystemTests.swift
//  MemoryFileSystem
//
//  Created by Bernardo Breder.
//
//

import XCTest
@testable import MemoryFileSystemTests

extension MemoryFileSystemTests {

	static var allTests : [(String, (MemoryFileSystemTests) -> () throws -> Void)] {
		return [
			("testAppend", testAppend),
			("testAppendTwice", testAppendTwice),
			("testCreateFile", testCreateFile),
			("testCreateFolder", testCreateFolder),
			("testDeleteDeep", testDeleteDeep),
			("testExt", testExt),
			("testPath", testPath),
			("testWrite", testWrite),
			("testWriteTwice", testWriteTwice),
		]
	}

}

XCTMain([
	testCase(MemoryFileSystemTests.allTests),
])

