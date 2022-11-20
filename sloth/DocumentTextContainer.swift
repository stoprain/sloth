//
//  DocumentTextContainer.swift
//  sloth
//
//  Created by Rain Qian on 2022/11/19.
//

import SwiftUI

struct DocumentTextContainer: UIViewRepresentable {
    
    var url: URL
    let frame: CGRect
    
    var newYorkFont: UIFont {
    /// 1. Initialize a system font with the preferred size and weight and access its `fontDescriptor` property.
          let descriptor = UIFont.systemFont(ofSize: 15,
                                             weight: .regular).fontDescriptor

    /// 2. Use the new iOS13 `withDesign` to get the `UIFontDescriptor` for a serif version of your system font. The size is derived from your initial `UIFont` so set it to `0.0`
          if let serif = descriptor.withDesign(.serif) {
            return UIFont(descriptor: serif, size: 0.0)
          }

    /// 3. Initialize a font with the serif descriptor of your system font. Again: use `0.0` as `size` parameter to prevent overriding the initial size we did set above.
          return UIFont(descriptor: descriptor, size: 0.0)
        }
    
    func makeUIView(context: Context) -> UIScrollView {
        let l = UIScrollView()
        return l
    }
    
    func updateUIView(_ uiView: UIScrollView, context: Context) {
        
        let textStorage = try? NSTextStorage(url: url, options: [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: NSUTF8StringEncoding,
        ], documentAttributes: nil)
        
        
        let layoutManager = NSLayoutManager()
        textStorage?.addLayoutManager(layoutManager)
        
        var lastRenderedGlyph = 0
        var currentXOffset = 0.0
        
        let w = frame.width
        let h = frame.height
        
        while lastRenderedGlyph < layoutManager.numberOfGlyphs {
            let textViewFrame = CGRect(x: currentXOffset, y: 0, width: w, height: h)
            let columnSize = CGSize(width: w, height: h)
            
            let textContainer = NSTextContainer(size: columnSize)
            layoutManager.addTextContainer(textContainer)
            
            let textView = UITextView(frame: textViewFrame, textContainer: textContainer)
            textView.font = newYorkFont
            textView.isScrollEnabled = false
            textView.textColor = .label
            textView.isEditable = false
            uiView.addSubview(textView)
            
            textView.attributedText.enumerateAttribute(NSAttributedString.Key.attachment, in: NSRange(location: 0, length: textView.attributedText.length)) { (value, range, stop) in
                if (value is NSTextAttachment){
                    guard let attachment = value as? NSTextAttachment else { return }
                    if attachment.bounds.width > w {
                        let r = attachment.bounds.width / attachment.bounds.height
                        attachment.bounds = CGRect(x: 0, y: 0, width: w, height: w/r)
                    }
                }
            }
            
            currentXOffset += w
            lastRenderedGlyph = NSMaxRange(layoutManager.glyphRange(for: textContainer))
        }
        
        let contentSize = CGSize(width: currentXOffset, height: h)
        uiView.contentSize = contentSize
        uiView.isPagingEnabled = true
        uiView.showsHorizontalScrollIndicator = false
    }
    
    typealias UIViewType = UIScrollView
    
}
