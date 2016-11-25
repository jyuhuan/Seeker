//
//  FileIO.swift
//  Seeker
//
//  Created by Yuhuan Jiang on 11/24/16.
//  Copyright © 2016 Yuhuan Jiang. All rights reserved.
//

import Foundation

class FileIO {
    static func isDirectory(path: String) -> Bool {
        let fileMgr = FileManager.default
        var isDir: ObjCBool = false
        fileMgr.fileExists(atPath: path, isDirectory: &isDir)
        return isDir.boolValue
    }
    
    static func exists(path: String) -> Bool {
        let fileMgr = FileManager.default
        return fileMgr.fileExists(atPath: path)
    }

}
