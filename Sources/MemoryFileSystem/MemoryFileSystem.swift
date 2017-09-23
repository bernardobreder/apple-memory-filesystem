//
//  MemoryFileSystem.swift
//  codegenv
//
//  Created by Bernardo Breder on 12/11/16.
//
//

import Foundation
import FileSystem

open class MemoryFileSystem: FileSystem {
    
    internal var _bytes: [String: Data] = [:]
    
    internal var _exists: [String: Resource] = [:]
    
    internal var _list: [String: [Resource]] = [:]
    
    internal lazy var _home: Folder = MemoryFolder(fileSystem: self, parent: nil, name: "home")
    
    public init() {
        _exists["/home"] = _home
        _list["/home"] = []
    }
    
    public func cwd() -> Folder {
        return _home
    }
    
    public func home() -> Folder {
        return _home
    }
    
    public func folder(_ path: String) -> Folder {
        return parentFolder(path)
    }
    
    public func file(_ path: String) -> File {
        let components = parents(path)
        if let parent = components.parent {
            return MemoryFile(fileSystem: self, parent: parentFolder(parent), name: components.name)
        } else {
            return MemoryFile(fileSystem: self, parent: nil, name: components.name)
        }
    }
    
    func parents(_ path: String) -> (parent: String?, name: String) {
        if let range = path.range(of: "/", options: .backwards) {
            var parent: String? = path.substring(to: range.lowerBound)
            if parent == "" { parent = nil }
            return (parent, path.substring(from: range.upperBound))
        } else { return (nil, path) }
    }
    func parentFolder(_ path: String) -> Folder {
        let components = parents(path)
        if let parent = components.parent {
            return MemoryFolder(fileSystem: self, parent: parentFolder(parent), name: components.name)
        } else {
            return MemoryFolder(fileSystem: self, parent: nil, name: components.name)
        }
    }
    
    internal func read(file: MemoryFile) throws -> Data {
        let path = file.path
        guard let bytes = _bytes[path] else { throw throwFileNotFound(path: path) }
        return bytes
    }
    
    internal func write(file: MemoryFile, data: Data) throws {
        let path = file.path
        if !exist(resource: file) {
            try create(resource: file)
        }
        _bytes[path] = data
    }
    
    internal func append(file: MemoryFile, data: Data) throws {
        let path = file.path
        if let _ = _exists[path] {} else {
            _exists[path] = file
            if let parent = file.parent {
                let parentPath = parent.path
                var array = _list[parentPath] ?? []
                array.append(file)
                _list[parentPath] = array
            }
        }
        let oldData = _bytes[path] ?? Data()
        _bytes[path] = oldData + data
    }
    
    public func deleteFile(folder: Folder, name: String) throws {
        let folderPath = folder.path
        let path = folderPath + "/" + name
        _exists.removeValue(forKey: path)
        if var list = _list[folderPath] {
            for (i, item) in list.enumerated() {
                if item.name == name {
                    list.remove(at: i)
                    break
                }
            }
            _list[folderPath] = list
        }
        _bytes.removeValue(forKey: path)
    }
    
    public func deleteFolder(folder: Folder, name: String, deep: Bool) throws {
        let folderPath = folder.path
        let path = folderPath + "/" + name
        if deep {
            if let list = _list[path] {
                for item in list {
                    try item.delete(deep: true)
                }
            }
        }
        if let list = _list[path] {
            guard list.isEmpty else { throw throwFolderNotEmpty(path: path) }
        }
        if var list = _list[folderPath] {
            for (i, item) in list.enumerated() {
                if item.name == name {
                    list.remove(at: i)
                    break
                }
            }
            _list[folderPath] = list
        }
        _exists.removeValue(forKey: path)
        _list.removeValue(forKey: path)
    }
    
    internal func create(resource: MemoryResource) throws {
        let path = resource.path
        guard _exists[path] == nil else { throw FileSystemError.fileAlreadyExist(path) }
        if let parent = resource.parent {
            let parentPath = parent.path
            var array = _list[parentPath] ?? []
            array.append(resource)
            _list[parentPath] = array
        }
        if resource.file {
            _bytes[path] = Data()
        } else {
            _list[path] = []
        }
        _exists[path] = resource
    }
    
    internal func exist(resource: MemoryResource) -> Bool {
        return _exists[resource.path] != nil
    }
    
    internal func throwFileNotFound(path: String) -> FileSystemError {
        return FileSystemError.fileNotFound(path)
    }
    
    internal func throwFolderNotEmpty(path: String) -> FileSystemError {
        return FileSystemError.folderNotEmpty(path)
    }
    
}
