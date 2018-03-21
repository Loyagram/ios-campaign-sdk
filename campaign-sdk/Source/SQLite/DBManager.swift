//
//  DBManager.swift
//  campaign-sdk
//
//  Created by iOS-Apps on 15/03/18.
//  Copyright © 2018 loyagram. All rights reserved.
//

import Foundation
import SQLite3

class DBManager {
    var db: OpaquePointer?
    static let instance = DBManager()
    //let fileUrl:URL!
    var dbPath = String()
    let documentsDirectory = ""
    init() {
//        fileUrl = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("loyagram.sqlite")
       // let fileMgr = FileManager.default
         dbPath = URL(fileURLWithPath: Bundle.main.resourcePath ?? "").appendingPathComponent("loyagram.sqlite").absoluteString
        //let success: Bool = fileMgr.fileExists(atPath: dbPath)
        openDB()
        createTableResponse()
    }
    
    func openDB() {
        
        if !(sqlite3_open(dbPath, &db) == SQLITE_OK) {
            print("An error has occured.")
        }
//        let databasePath: String = URL(fileURLWithPath: documentsDirectory).appendingPathComponent("loyagram.sqlite").absoluteString
//        if sqlite3_open(databasePath, &db) != SQLITE_OK {
//            print("error openning db")
//        }
    }
    func createTableResponse() {
        let createTableQuery = "CREATE TABLE IF NOT EXISTS RESPONSE(id INTEGER PRIMARY KEY AUTOINCREMENT, response TEXT, kioskStatus INTEGER)"
        if sqlite3_exec(db, createTableQuery, nil, nil, nil) != SQLITE_OK {
            print("error creating table")
        }
    }
    
    func insertResponseIntoDB(response: String) {
        if(getResponseFromDB() == nil) {
            var insertStatement: OpaquePointer?
            let insertQuery = "INSERT INTO RESPONSE(response, kioskStatus) VALUES (?, ?)"
            if sqlite3_prepare(db, insertQuery, -1, &insertStatement, nil) != SQLITE_OK{
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("error preparing insert: \(errmsg)")
                return
            }
            
            if sqlite3_bind_text(insertStatement, 1, response, -1, nil) != SQLITE_OK{
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("failure binding response: \(errmsg)")
                return
            }
            
            if sqlite3_bind_int(insertStatement, 2, 0) != SQLITE_OK{
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("failure binding name: \(errmsg)")
                return
            }
            
            if sqlite3_step(insertStatement) != SQLITE_DONE {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("failure inserting response: \(errmsg)")
                return
            }
            sqlite3_finalize(insertStatement)
        } else {
            var updateStatement: OpaquePointer? = nil
            let UpdateQuery = "UPDATE RESPONSE set response = '\(response)' WHERE kioskStatus = 0"
            if sqlite3_prepare_v2(db, UpdateQuery, -1, &updateStatement, nil) == SQLITE_OK {
                if sqlite3_step(updateStatement) == SQLITE_DONE {
                    print("Successfully updated row.")
                } else {
                    print("Could not update row.")
                }
            } else {
                print("UPDATE statement could not be prepared")
            }
            sqlite3_finalize(updateStatement)
        }
        
    }
    
    func getResponseFromDB() -> String? {
        var responseString:String?
        let queryString = "SELECT * FROM RESPONSE WHERE kioskStatus = 0"
        var readStatement:OpaquePointer?
        if sqlite3_prepare(db, queryString, -1, &readStatement, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return nil
        }
        //traversing through all the records
        while(sqlite3_step(readStatement) == SQLITE_ROW){
            responseString = String(cString: sqlite3_column_text(readStatement, 1))
            //responses.append(name)
        }
        sqlite3_finalize(readStatement)
        return responseString
        
    }
    
    func deleteResponseFromDB() -> Bool {
      let queryString = "DELETE FROM RESPONSE WHERE kioskStatus = 0"
        var deleteStatement: OpaquePointer?
        var isSuccess = false
        if sqlite3_prepare_v2(db, queryString, -1, &deleteStatement, nil) == SQLITE_OK{
            if (sqlite3_step(deleteStatement) == SQLITE_DONE) {
            }
            isSuccess = true
        } else {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
        }
        
        sqlite3_finalize(deleteStatement)
        return isSuccess
        
    }
    
    func getRowCount() -> Int {
        
        let query = "SELECT COUNT(*) AS c FROM RESPONSE"
        var count = -1
        var readStatement:OpaquePointer?
        if sqlite3_prepare(db, query, -1, &readStatement, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return count
        }
        while( sqlite3_step(readStatement) == SQLITE_ROW ){
            count = Int(sqlite3_column_int(readStatement, 0));
        }
        return count
    }
    func closeDB() {
//        if sqlite3_close(db) != SQLITE_OK {
//            print("cannot close db")
//        }
    }
    
}
