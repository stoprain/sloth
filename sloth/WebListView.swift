//
//  WebListView.swift
//  sloth
//
//  Created by Rain Qian on 2022/11/23.
//

import SwiftUI

struct WebListView: View {
    
    var links = [
        "https://en.wikipedia.org/wiki/Sloth",
        "https://en.wikipedia.org/wiki/Red_fox"
    ]
    
    var body: some View {
        List(links, id: \.self) { link in
            NavigationLink {
                VStack {
                    DocumentTranslatorView()
                    WebView(url: URL(string: link)!)
                }
            } label: {
                Text(link)
            }
        }
    }
}

struct WebListView_Previews: PreviewProvider {
    static var previews: some View {
        WebListView()
    }
}
