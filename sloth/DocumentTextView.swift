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
        DocumentAttributedLabel(url: url)
    }
}

//struct DocumentTextView_Previews: PreviewProvider {
//    static var previews: some View {
//        DocumentTextView()
//    }
//}
