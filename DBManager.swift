//
//  DBManager.swift
//  SoShi-fy
//
//  Created by CSPC140 on 28/02/18.
//  Copyright © 2018 CSPC140. All rights reserved.
//

import UIKit
import SQLite3

let database = "dbemp"
class DBManager: NSObject {
    static let shared  = DBManager()
   var db: OpaquePointer?
    class func createEditableCopyOfDatabaseIfNeeded() {
        let success : Bool!
        let fileManager =  FileManager.default
        let _ : Error
        let paths =  NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentDirectory =  paths[0] as NSString
        let path =   documentDirectory.appendingPathComponent(database) as NSString
        success =  fileManager.fileExists(atPath: path as String)
        if success {
            print("ALready exists")
            return;
        }
        let baseDBPath =  Bundle.main.resourcePath! as NSString
        let completeDBPath =  baseDBPath.appendingPathComponent(database)
        
        do {
            try fileManager.copyItem(atPath: completeDBPath, toPath: path as String)
        }
        catch  {
            print("Ooops! Something went wrong: ")
        }

        
    }
    
    func openConnection()  {
        let paths =  NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentDirectory =  paths[0] as NSString
        let path =   documentDirectory.appendingPathComponent(database) as NSString
        
        print(path)
        if sqlite3_open(path.utf8String, &db) != SQLITE_OK {
            print("Database Successfully Opened")
        }else {
            print("Error in opening database ")
        }
    }
    
    func closeConnection()  {
        sqlite3_close(db)
    }
    
    func insertRecord(query: String){
        print(query)
       self.openConnection()
        var insertStatement: OpaquePointer? = nil
        // 1
        if sqlite3_prepare_v2(db, query, -1, &insertStatement, nil) == SQLITE_OK {
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted row.")
            } else {
                print("Could not insert row.")
            }
        } else {
            print("INSERT statement could not be prepared.")
        }
        // 5
        sqlite3_finalize(insertStatement)
  
    }
    func deleteRecord(query: String){
         print(query)
        openConnection()
        var selectStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, query, -1, &selectStatement, nil) == SQLITE_OK {
            let success = sqlite3_step(selectStatement)
            print(success)
            sqlite3_finalize(selectStatement)
            closeConnection()
        } else {
            print("some error occured")
        }

    }
    

    
    func getEmployeeRecords(query: String) -> NSMutableArray {
         print(query)
        let list  = NSMutableArray()
        openConnection()
        var selectStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, query, -1, &selectStatement, nil) == SQLITE_OK {
            while sqlite3_step(selectStatement) == SQLITE_ROW {
                var dict = [String: String] ()
                let empno = String(cString: sqlite3_column_text(selectStatement, 0))
                let ename = String(cString: sqlite3_column_text(selectStatement, 1))
                let eadd = String(cString: sqlite3_column_text(selectStatement, 2))
                let esal = String(cString: sqlite3_column_text(selectStatement, 3))
                dict.updateValue(empno, forKey: "Empno")
                dict.updateValue(ename, forKey: "Ename")
                dict.updateValue(eadd, forKey: "Eadd")
                dict.updateValue(esal, forKey: "Esal")
                list.add(dict)
            }
            sqlite3_finalize(selectStatement)
            closeConnection()
        } else {
            print("some error occured")
        }
        
        return list
    }
    
    func updateRecord(query: String){
        print(query)
        openConnection()
        var selectStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, query, -1, &selectStatement, nil) == SQLITE_OK {
            _ = sqlite3_step(selectStatement)
            sqlite3_finalize(selectStatement)
            closeConnection()
        } else {
        }
  }
    
    
    
    
}
