//
//  DocumentTextView.swift
//  sloth
//
//  Created by Rain Qian on 2022/11/19.
//

import SwiftUI

struct DocumentTextView: View {
    
  @StateObject var document: Document
  @State private var isPresented = false
  @State private var url: URL?

    
  var body: some View {
    VStack {
      DocumentTranslatorView()
      
      //TODO: reponse to chapter change
      GeometryReader { proxy in
        DocumentTextContainer(url: url, frame: proxy.frame(in: .local))
      }
    }
    .onAppear {
      if url == nil {
        url = document.getCurrentChapterUrl()
      }
    }
    .onChange(of: document.chapter, perform: { newStateObject in
      url = document.getCurrentChapterUrl()
    })
    .toolbar {
      ToolbarItem(placement: .primaryAction) {
        Button {
          isPresented.toggle()
        } label: {
          Image(systemName: "list.bullet")
        }
      }
    }
    .sheet(isPresented: $isPresented) {
      ChapterListView(document: document, isPresented: $isPresented)
    }
  }
}

//struct DocumentTextView_Previews: PreviewProvider {
//    static var previews: some View {
//        DocumentTextView()
//    }
//}
