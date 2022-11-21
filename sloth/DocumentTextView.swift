//
//  DocumentTextView.swift
//  sloth
//
//  Created by Rain Qian on 2022/11/19.
//

import SwiftUI

struct DocumentTextView: View {
    
    @StateObject var translator = Translator.shared
    
    var url: URL
    
    var body: some View {
        VStack {
            HStack {
                Text(translator.input)
                    .frame(width: 100)
                Text(translator.output)
                    .frame(
                      minWidth: 0,
                      maxWidth: .infinity,
                      minHeight: 0,
                      maxHeight: .infinity,
                      alignment: .topLeading
                    )
            }
                .frame(height: 50)
            
            Divider()
                .frame(height: 1)
                .background(.gray)
            
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
