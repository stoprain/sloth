//
//  DocumentTranslatorView.swift
//  sloth
//
//  Created by Hong,Qian on 2022/11/23.
//

import SwiftUI

struct DocumentTranslatorView: View {
    
    @StateObject var translator = Translator.shared
    
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
                .background(Color(UIColor.lightGray))
        }
    }
}

struct DocumentTranslatorView_Previews: PreviewProvider {
    static var previews: some View {
        DocumentTranslatorView()
    }
}
