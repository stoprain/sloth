//
//  ECDICTHelper.swift
//  sloth
//
//  Created by Rain Qian on 2022/11/21.
//

import SQLite
import Foundation
import Zip

struct ECDICTHelper {
    static let shared = ECDICTHelper()
    private var db: Connection!
    private let stardict = Table("stardict")
    private let word = Expression<String?>("word")
    private let translation = Expression<String?>("translation")
    
    //TODO: remove __MACOSX in zip
    private init() {
        let path = Preference.documentPath + "/sloth/ecdict.db"
        if !FileManager.default.fileExists(atPath:path) {
            guard let url = Bundle.main.url(forResource: "ecdict.db", withExtension: "zip") else { return }
            let durl = URL(fileURLWithPath: Preference.documentPath + "/sloth")
            try? Zip.unzipFile(url, destination: durl, overwrite: true, password: nil)
        }
        do {
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
