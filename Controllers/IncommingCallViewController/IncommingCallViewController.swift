//
//  IncommingCallViewController.swift
//  DailerApp
//
//  Created by Muhammad Bilal on 11/03/2020.
//  Copyright © 2020 Solution Soul. All rights reserved.
//

import UIKit
import SQLite3
import CallKit

class IncommingCallViewController: UIViewController,CXProviderDelegate {

    @IBOutlet weak var numberLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let provider = CXProvider(configuration: CXProviderConfiguration(localizedName: "Cori.Tel"))
        provider.setDelegate(self, queue: nil)
        let update = CXCallUpdate()
        update.remoteHandle = CXHandle(type: .generic, value: "Dailer App Calling!")
        provider.reportNewIncomingCall(with: UUID(), update: update, completion: { error in })
        
//        // ------------------- Fetch Call History --------------------
//
//        let fileManager = FileManager.default
//        let dirnum = FileManager.default.enumerator(atPath: "/private/")
//        var nextItem = ""
//        while (nextItem == dirnum?.nextObject() as? String ?? "") {
//            if (URL(fileURLWithPath: nextItem).pathExtension == "db") || (URL(fileURLWithPath: nextItem).pathExtension == "sqlitedb") {
//                if fileManager.isReadableFile(atPath: nextItem) {
//                    print("dd \(nextItem)")
//                }
//            }
//        }
//
//        //  The converted code is limited to 1 KB.
//        //  Please Sign Up (Free!) to double this limit.
//        //
//        //  Converted to Swift 5.1 by Swiftify v5.1.33805 - https://objectivec2swift.com/
//        var callHisoryDatabasePath = "/private/var/wireless/Library/CallHistory/call_history.db"
//        var callHistoryFileExist = false
//        var database: sqlite3?
//        //Getting table names and schema
//        var compiledStatement: sqlite3_stmt?
//        var sqlStatement = "SELECT * FROM sqlite_master WHERE type='table';"
//        var errorCode = sqlite3_prepare_v2(database, sqlStatement.utf8CString, -1, &compiledStatement, nil)
//        var count = 1
//        // Read the data from the result row
//        var numberOfColumns = sqlite3_column_count(compiledStatement)
//        var data: String?
//        var columnName: String?
//        //  Converted to Swift 5.1 by Swiftify v5.1.33805 - https://objectivec2swift.com/
//        for i in 0..<numberOfColumns {
//            columnName = String(utf8String: Int8(sqlite3_column_name(compiledStatement, i)))
//            data = String(utf8String: Int8(sqlite3_column_text(compiledStatement, i)))
//            print("\(columnName) : \(data)")
//        }
//        //count += 1
//
//        // ===========================================================
        
        
        // Do any additional setup after loading the view.
    }
    
    func providerDidReset(_ provider: CXProvider) {
    }
    func provider(_ provider: CXProvider, perform action: CXAnswerCallAction) {
        action.fulfill()
    }
    func provider(_ provider: CXProvider, perform action: CXEndCallAction) {
        action.fulfill()
    }
    
    @IBAction func declineButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func acceptButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func messageButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func blockButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
