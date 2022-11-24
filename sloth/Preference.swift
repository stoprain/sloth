//
//  Preference.swift
//  sloth
//
//  Created by Hong,Qian on 2022/11/23.
//

import Defaults
import SQLite
import Foundation

extension Defaults.Keys {
    static let pageIndex = Key<UInt>("pageIndex", default: 0)
}

struct Preference {
    
    static let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
    
    static let shared = Preference()
    private var db: Connection!
    private let documents = Table("documents")
    private let id = Expression<Int64>("id")
    private let title = Expression<String?>("title")
    private let chapter = Expression<Int64?>("chapter")
    private let page = Expression<Int64?>("page")
    
    private init() {
        let path = Preference.documentPath + "/sloth/ecdict.db"
        do {
            db = try Connection(path)
            try db.run(documents.create(ifNotExists: true) { t in
                t.column(id, primaryKey: true)
                t.column(title, unique: true)
                t.column(chapter)
                t.column(page)
            })
        } catch {
            print(error)
        }
    }
    
    func updateDocumentProgress(title: String, chapter: Int64, page: Int64) {
        do {
            try documents.insert([self.title <- title, self.chapter <- chapter, self.page <- page])
//            let doc = documents.filter(self.title == title)
//            try db.run(doc.update([self.chapter <- chapter, self.page <- page]))
        } catch {
            print(error)
        }
    }
}
