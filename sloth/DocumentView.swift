//
//  DocumentView.swift
//  sloth
//
//  Created by Rain Qian on 2022/11/19.
//

import SwiftUI
import EPUBKit

struct DocumentView: View {
    
    @State var document: Document
    @State var contents = [TableOfContent]()
    
    var body: some View {
        VStack {
            List(contents, id: \.path) { c in
                NavigationLink {
                    DocumentTextView(url: URL(fileURLWithPath: parse(s: c.path ?? "")))
//                        .navigationBarHidden(true)
                } label: {
                    Text(c.title)
                }
            }
        }.onAppear {
            guard let url = document.url else { return }
            let epub = EPUBDocument(url: url)
            var items = [TableOfContent]()
            if let ts = epub?.tableOfContents.subTable {
                for t in ts {
                    if let content = t.item, let c = epub?.contentDirectory.appendingPathComponent(content) {
                        let toc = TableOfContent(title: t.label, path: c.path)
                        items.append(toc)
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
