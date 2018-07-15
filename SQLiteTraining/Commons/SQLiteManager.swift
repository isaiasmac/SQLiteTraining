//
//  SQLiteManager.swift
//  SQLiteTraining
//
//  Created by Isaías on 7/14/18.
//  Copyright © 2018 IsaiasMac. All rights reserved.
//

import Foundation
import SQift

class SQLiteManager {
    
    static func sqliteFile() -> String {
        var fileURL: URL?
        do {
            fileURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                .appendingPathComponent("myDB.sqlite")
        } catch {
            print("Error SQLITEDB => \(error.localizedDescription)")
        }
        
        return fileURL!.path
    }
    
    static func connect() -> Connection {
        do {
            return try Connection(storageLocation: .onDisk(sqliteFile()))
        } catch {
            fatalError("\(#function) \(error.localizedDescription)")
        }
        
    }
}
