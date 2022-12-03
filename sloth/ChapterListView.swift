//
//  ChapterListView.swift
//  sloth
//
//  Created by Rain Qian on 2022/11/19.
//

import SwiftUI
import EPUBKit

struct ChapterListView: View {
  
  @State var document: Document
  @Binding var isPresented: Bool
  
  var body: some View {
    VStack {
      List(document.contents.indices, id: \.self) { index in
        Button(document.contents[index].title) {
          document.chapter = index
          document.page = 0
          isPresented = false
        }
      }
    }.onAppear {
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
    ChapterListView(document: d, isPresented: .constant(false))
  }
}
