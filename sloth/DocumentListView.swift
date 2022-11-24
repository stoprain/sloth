//
//  DocumentListView.swift
//  sloth
//
//  Created by Rain Qian on 2022/11/19.
//

import SwiftUI

struct Document {
    var title: String
    var url: URL?
}

struct TableOfContent {
    var title: String
    var path: String?
}

struct DocumentListView: View {
    
    @State var documents = [Document]()
    
    var body: some View {
        VStack {
            List(documents, id: \.title) { d in
                NavigationLink {
                    DocumentView(document: d)
                } label: {
                    Text(d.title)
                }
            }
        }.onAppear {
            guard let url = Bundle.main.url(forResource: "pg69407", withExtension: "epub") else { return }
            guard let directoryContents = try? FileManager.default.contentsOfDirectory(atPath: Preference.documentPath) else { return }
            var cs = [Document]()
            cs.append(Document(title: "pg69407", url: url))
            for c in directoryContents {
                if c.hasSuffix(".epub") {
                    let d = Document(title: c, url: URL(fileURLWithPath: Preference.documentPath + "/" + c))
                    cs.append(d)
                }
            }
            documents = cs
        }
    }
}

struct DocumentListView_Previews: PreviewProvider {
    static var previews: some View {
        DocumentListView()
    }
}
