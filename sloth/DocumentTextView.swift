//
//  DocumentTextView.swift
//  sloth
//
//  Created by Rain Qian on 2022/11/19.
//

import SwiftUI

struct DocumentTextView: View {
    
    var url: URL
    
    var body: some View {
        VStack {

            DocumentTranslatorView()
            
            GeometryReader { proxy in
                DocumentTextContainer(url: url, frame: proxy.frame(in: .local))
            }
        }
    }
}

//struct DocumentTextView_Previews: PreviewProvider {
//    static var previews: some View {
//        DocumentTextView()
//    }
//}
