//
//  MemoryResource.swift
//  codegenv
//
//  Created by Bernardo Breder on 12/11/16.
//
//

import Foundation
import Optional
import FileSystem

open class MemoryResource: Resource, Hashable {
    
    internal weak var fileSystem: MemoryFileSystem?
    
    public let parent: Folder?
    
    public let name: String
    
    internal init(fileSystem: MemoryFileSystem?, parent: Folder?, name: String) {
        self.fileSystem = fileSystem
        self.parent = parent.some({MemoryFolder(fileSystem: fileSystem, parent: $0.parent, name: $0.name)})
        self.name = name
    }
    
    public var exist: Bool {
        return fileSystem?.exist(resource: self) ?? false
    }
    
    public func delete(deep: Bool) throws -> Self {
        guard let fileSystem = self.fileSystem else { throw throwFileSystemCollected() }
        guard let parent = self.parent else { throw FileSystemError.fileNotFound(path) }
        if file {
            try fileSystem.deleteFile(folder: parent, name: name)
        } else if folder {
            try fileSystem.deleteFolder(folder: parent, name: name, deep: deep)
        }
        return self
    }
    
    public func delete() throws -> Self {
        return try delete(deep: true)
    }
    
    public var canBeRead: Bool {
        return true
    }
    
    public var canBeWrite: Bool {
        return true
    }
    
    public func asFile() -> File {
        return self as! File
    }
    
    public func asFolder() -> Folder {
        return self as! Folder
    }
    
    public var file: Bool {
        return false
    }
    
    public var folder: Bool {
        return false
    }
    
    public var path: String {
        return ((parent?.path) ?? "") + "/" + name
    }
    
    internal func throwFileSystemCollected() -> FileSystemError{
        return FileSystemError.fileSystemCollected
    }
    
    public var hashValue: Int {
        return path.hashValue
    }
    
    public static func ==(lhs: MemoryResource, rhs: MemoryResource) -> Bool {
        return lhs.path == rhs.path
    }
    
}
