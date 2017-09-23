//
//  MemorySymbol.swift
//  MemoryFileSystem
//
//  Created by Bernardo Breder on 15/12/16.
//
//

import Foundation
import FileSystem

open class MemorySymbol: MemoryResource, Symbol {
    
    public var refFile: File? {
        guard file else { return nil }
        return MemoryFile(fileSystem: fileSystem, parent: parent as? MemoryFolder, name: name)
    }
    
    public var refFolder: Folder? {
        guard folder else { return nil }
        return MemoryFolder(fileSystem: fileSystem, parent: parent as? MemoryFolder, name: name)
    }
    
}
