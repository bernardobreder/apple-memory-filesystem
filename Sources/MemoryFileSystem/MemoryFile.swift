//
//  MemoryFile.swift
//  codegenv
//
//  Created by Bernardo Breder on 12/11/16.
//
//

import Foundation
import FileSystem

open class MemoryFile: MemoryResource, File {
    
    internal override init(fileSystem: MemoryFileSystem?, parent: Folder?, name: String) {
        super.init(fileSystem: fileSystem, parent: parent, name: name)
    }
    
    public func read() throws -> Data {
        guard let fileSystem = self.fileSystem else { throw throwFileSystemCollected() }
        return try fileSystem.read(file: self)
    }
    
    public func write(data: Data) throws -> Self {
        guard let fileSystem = self.fileSystem else { throw throwFileSystemCollected() }
        try fileSystem.write(file: self, data: data)
        return self
    }
    
    public func append(data: Data) throws -> Self {
        guard let fileSystem = self.fileSystem else { throw throwFileSystemCollected() }
        try fileSystem.append(file: self, data: data)
        return self
    }
    
    public func create() throws -> Self {
        guard let fileSystem = self.fileSystem else { throw throwFileSystemCollected() }
        try fileSystem.create(resource: self)
        return self
    }
    
    public func createIfNotExist() throws -> Self {
        if !exist { _ = try create() }
        return self
    }
    
    public override var file: Bool {
        return true
    }
    
}
