//
//  Document.swift
//  sloth
//
//  Created by Rain Qian on 2022/11/26.
//

import Foundation
import EPUBKit

class Document: ObservableObject {
    var title: String
    var url: URL?
    @Published var chapter = 0
    var page = 0
    var epub: EPUBDocument?
    var contents = [TableOfContent]()
    
    init(title: String, url: URL? = nil) {
        self.title = title
        self.url = url
        
        guard let url = url else { return }
        epub = EPUBDocument(url: url)
        if let ts = epub?.tableOfContents.subTable {
            for t in ts {
                if let content = t.item, let c = epub?.contentDirectory.appendingPathComponent(content) {
                    let toc = TableOfContent(title: t.label, path: c.path)
                    contents.append(toc)
                }
            }
        }
    }
    
    func getCurrentChapterUrl() -> URL {
        return URL(fileURLWithPath: parse(s: contents[chapter].path ?? ""))
    }
    
    private func parse(s: String) -> String {
        if let r = s.firstIndex(of: "#") {
            let before = s.prefix(upTo: r)
            return String(before)
        }
        
        return s
    }
}

struct TableOfContent {
    var title: String
    var path: String?
}
