//
//  ECDICTHelper.swift
//  sloth
//
//  Created by Rain Qian on 2022/11/21.
//

import SQLite
import Foundation

struct ECDICTHelper {
    static let shared = ECDICTHelper()
    private var db: Connection!
    private let stardict = Table("stardict")
    private let word = Expression<String?>("word")
    private let translation = Expression<String?>("translation")
    
    private init() {
        do {
            let path = Bundle.main.path(forResource: "ecdict", ofType: "db")!
            db = try Connection(path)
        } catch {
            print(error)
        }
        
    }
    
    func query(s: String) -> String {
        let q = stardict.filter(word == s).limit(1)
        do {
            let r = try db.prepare(q)
            for row in r {
                return row[translation] ?? ""
            }
        } catch {
            print(error)
        }

        return ""
    }
    
}
