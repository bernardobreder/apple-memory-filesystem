//
//  MemoryFolder.swift
//  codegenv
//
//  Created by Bernardo Breder on 12/11/16.
//
//

import Foundation
import FileSystem

open class MemoryFolder: MemoryResource, Folder {
    
    internal override init(fileSystem: MemoryFileSystem?, parent: Folder?, name: String) {
        super.init(fileSystem: fileSystem, parent: parent, name: name)
    }
    
    public func list() -> [Resource] {
        guard let fileSystem = self.fileSystem else { return [] }
        return fileSystem._list[path] ?? []
    }
    
    public func listFiles() -> [File] {
        guard let fileSystem = self.fileSystem else { return [] }
        return (fileSystem._list[path] ?? []).filter({$0.file}).map({$0 as! File})
    }
    
    public func listFolders() -> [Folder] {
        guard let fileSystem = self.fileSystem else { return [] }
        return (fileSystem._list[path] ?? []).filter({$0.folder}).map({$0 as! Folder})
    }
    
    public func get(_ name: String) -> Resource {
        return MemoryResource(fileSystem: fileSystem, parent: self, name: name)
    }
    
    public func getFile(_ name: String) -> File {
        return MemoryFile(fileSystem: fileSystem, parent: self, name: name)
    }
    
    public func getFolder(_ name: String) -> Folder {
        return MemoryFolder(fileSystem: fileSystem, parent: self, name: name)
    }
    
    public func find(_ name: String) -> Resource? {
        guard let fileSystem = self.fileSystem else { return nil }
        return (fileSystem._list[path] ?? []).filter({$0.name == name}).first
    }
    
    public func findFile(_ name: String) -> File? {
        guard let fileSystem = self.fileSystem else { return nil }
        return (fileSystem._list[path] ?? []).filter({$0.file}).filter({$0.name == name}).map({$0 as! File}).first
    }
    
    public func findFolder(_ name: String) -> Folder? {
        guard let fileSystem = self.fileSystem else { return nil }
        return (fileSystem._list[path] ?? []).filter({$0.folder}).filter({$0.name == name}).map({$0 as! Folder}).first
    }
    
    public func createFile(_ name: String, data: Data) throws -> File {
        guard let fileSystem = self.fileSystem else { throw throwFileSystemCollected() }
        let file = MemoryFile(fileSystem: fileSystem, parent: self, name: name)
        try fileSystem.create(resource: file)
        try fileSystem.write(file: file, data: data)
        return file
    }
    
    public func createFolder(_ name: String) throws -> Folder {
        guard let fileSystem = self.fileSystem else { throw throwFileSystemCollected() }
        let folder = MemoryFolder(fileSystem: fileSystem, parent: self, name: name)
        try fileSystem.create(resource: folder)
        return folder
    }
    
    public func create() throws {
        guard let fileSystem = self.fileSystem else { throw throwFileSystemCollected() }
        try fileSystem.create(resource: self)
    }
    
    public func createIfNotExist() throws -> Self {
        if !exist { _ = try create() }
        return self
    }
    
    public func deleteFile(_ name: String) throws -> Self {
        guard let fileSystem = self.fileSystem else { throw throwFileSystemCollected() }
        try fileSystem.deleteFile(folder: self as! Folder, name: name)
        return self
    }
    
    public func deleteFolder(_ name: String, deep: Bool) throws -> Self {
        guard let fileSystem = self.fileSystem else { throw throwFileSystemCollected() }
        try fileSystem.deleteFolder(folder: self as! Folder, name: name, deep: deep)
        return self
    }
    
    public override var folder: Bool {
        return true
    }
    
}
