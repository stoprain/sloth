//
//  DocumentView.swift
//  sloth
//
//  Created by Rain Qian on 2022/11/19.
//

import SwiftUI

struct DocumentView: View {
    
    @State var document: Document
    @State var contents = [String]()
    
    var body: some View {
        VStack {
            List(contents, id: \.self) { c in
                NavigationLink {
//                    DocumentWebView(url: URL(fileURLWithPath: parse(s: c)))
                    DocumentTextView(url: URL(fileURLWithPath: parse(s: c)))
                } label: {
                    Text(c)
                }
            }
        }.onAppear {
            guard let url = document.url else { return }
            let epub = EPUBDocument(url: url)
            var items = [String]()
            if let ts = epub?.tableOfContents.subTable {
                for t in ts {
                    if let content = t.item, let c = epub?.contentDirectory.appendingPathComponent(content) {
//                        let html = try? String(contentsOfFile: c.path)
                        items.append(c.path)
                    }
                }
            }
            contents = items
        }
        
    }
    
    private func parse(s: String) -> String {
        if let r = s.firstIndex(of: "#") {
            let before = s.prefix(upTo: r)
            return String(before)
        }
        
        return s
    }
}

struct DocumentView_Previews: PreviewProvider {
    static var previews: some View {
        let d = Document(title: "Charlotte")
        DocumentView(document: d)
    }
}
