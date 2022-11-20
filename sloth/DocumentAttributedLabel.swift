//
//  DocumentAttributedLabel.swift
//  sloth
//
//  Created by Rain Qian on 2022/11/19.
//

import SwiftUI

struct DocumentAttributedLabel: UIViewRepresentable {
    
    var url: URL
    
//    func makeUIView(context: Context) -> DTAttributedLabel {
//        let l = DTAttributedLabel()
//        return l
//    }
//
//    func updateUIView(_ uiView: DTAttributedLabel, context: Context) {
//        print(url)
//        guard let data = try? Data(contentsOf: url) else { return }
//        let options: [String : Any] = [
//            NSBaseURLDocumentOption: url,
//            DTDefaultFontName: "TimesNewRomanPSMT",
//            DTMaxImageSize: CGSize(width: 341, height: 1000),
//            NSTextSizeMultiplierDocumentOption: 1,
//            DTDefaultLineHeightMultiplier: 1,
//            DTDefaultLinkColor: "#536FFA",
//            DTDefaultTextColor: "#000000",
//            DTDefaultFontSize: 15.0
//        ]
//
//        let htmlString = try? NSAttributedString(htmlData: data, options: options, documentAttributes: nil)
//        uiView.attributedString = htmlString
//        print(htmlString)
//    }
//
//    typealias UIViewType = DTAttributedLabel
    
    func makeUIView(context: Context) -> UIScrollView {
        let l = UIScrollView()
        return l
    }
    
    func updateUIView(_ uiView: UIScrollView, context: Context) {
        let textStorage = try? NSTextStorage(fileURL: url, documentAttributes: nil)
        let layoutManager = NSLayoutManager()
        textStorage?.addLayoutManager(layoutManager)
        
        var lastRenderedGlyph = 0
        var currentXOffset = 0.0
        
        let w = UIScreen.main.bounds.size.width
        let h = UIScreen.main.bounds.size.height
        
        while lastRenderedGlyph < layoutManager.numberOfGlyphs {
            let textViewFrame = CGRect(x: currentXOffset, y: 0, width: w, height: h)
            let columnSize = CGSize(width: w, height: h)
            
            let textContainer = NSTextContainer(size: columnSize)
            layoutManager.addTextContainer(textContainer)
            
            let textView = UITextView(frame: textViewFrame, textContainer: textContainer)
            textView.isScrollEnabled = false
            uiView.addSubview(textView)
            
            currentXOffset += w
            lastRenderedGlyph = NSMaxRange(layoutManager.glyphRange(for: textContainer))
        }
        
        let contentSize = CGSize(width: currentXOffset, height: h)
        uiView.contentSize = contentSize
        uiView.isPagingEnabled = true
    }
    
    typealias UIViewType = UIScrollView
    
}
