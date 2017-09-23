import XCTest
import Foundation
@testable import FileSystem
@testable import MemoryFileSystem

class MemoryFileSystemTests: XCTestCase {
    
    func testPath() throws {
        let fs = MemoryFileSystem()
        XCTAssertEqual("/home", fs.home().path)
        XCTAssertEqual("/a.txt", fs.file("/a.txt").path)
        XCTAssertEqual("/b/a.txt", fs.folder("/b").getFile("a.txt").path)
        XCTAssertEqual("/a", fs.folder("/a").path)
    }
    
    func testCreateFile() throws {
        let fs = MemoryFileSystem()
        XCTAssertEqual(0, try fs.home().list().count)
        _ = try fs.home().createFile("a", data: Data())
        XCTAssertEqual(1, try fs.home().list().count)
    }
    
    func testCreateFolder() throws {
        let fs = MemoryFileSystem()
        XCTAssertEqual(0, try fs.home().list().count)
        _ = try fs.home().createFolder("a")
        XCTAssertEqual(1, try fs.home().list().count)
    }
    
    func testWrite() throws {
        let fs = MemoryFileSystem()
        let file = try fs.home().createFile("a", data: Data())
        try file.write(data: "abc".data(using: .utf8)!)
        XCTAssertEqual("abc", try String(data: file.read(), encoding: .utf8)!)
    }
    
    func testWriteTwice() throws {
        let fs = MemoryFileSystem()
        let file = try fs.home().createFile("a", data: Data())
        try file.write(data: "abc".data(using: .utf8)!)
        try file.write(data: "def".data(using: .utf8)!)
        XCTAssertEqual("def", try String(data: file.read(), encoding: .utf8)!)
    }
    
    func testAppendTwice() throws {
        let fs = MemoryFileSystem()
        let file = try fs.home().createFile("a", data: Data())
        try file.write(data: "abc".data(using: .utf8)!)
        try file.append(data: "1".data(using: .utf8)!)
        try file.append(data: "2".data(using: .utf8)!)
        XCTAssertEqual("abc12", try String(data: file.read(), encoding: .utf8)!)
    }

    func testAppend() throws {
        let fs = MemoryFileSystem()
        let file = try fs.home().createFile("a", data: Data())
        try file.append(data: "abc".data(using: .utf8)!)
        XCTAssertEqual("abc", try String(data: file.read(), encoding: .utf8)!)
    }
    
    func testDeleteDeep() throws {
        let fs = MemoryFileSystem()
        let a = try fs.home().createFolder("a")
        let b = try a.createFolder("b")
        _ = try a.createFile("c", data: Data())
        let d = try b.createFolder("d")
        _ = try d.createFile("e", data: Data())
        let f = try d.createFolder("f")
        _ = try f.createFile("g", data: Data())
        try a.delete(deep: true)
        XCTAssertEqual(0, try fs.home().list().count)
    }
    
    func testExt() throws {
        let fs = MemoryFileSystem()
        XCTAssertEqual("txt", try fs.home().createFile("c.txt", data: Data()).ext)
        XCTAssertEqual("", try fs.home().createFile("c.", data: Data()).ext)
        XCTAssertTrue(try fs.home().createFile("c", data: Data()).ext.empty)
    }

}
