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

struct DocumentListView: View {
    
    @State var documents = [Document]()
    @State var showPicker = false
    
    var body: some View {
        VStack {
            NavigationView {
                
//                Button(action: {
//                    self.showPicker.toggle()
//                }, label: {
//                    Text("Push me")
//                })
//                .sheet(isPresented: self.$showPicker) {
//                    DocumentPickerView()
//                }
                
                List(documents, id: \.title) { d in
                    NavigationLink {
                        DocumentView(document: d)
                    } label: {
                        Text(d.title)
                    }
                }
            }
        }.onAppear {
            guard let s = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else { return }
            guard let directoryContents = try? FileManager.default.contentsOfDirectory(atPath: s) else { return }
            var cs = [Document]()
            for c in directoryContents {
                if c.hasSuffix(".epub") {
                    let d = Document(title: c, url: URL(fileURLWithPath: s + "/" + c))
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
