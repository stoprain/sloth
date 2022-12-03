//
//  DocumentTextContainer.swift
//  sloth
//
//  Created by Rain Qian on 2022/11/19.
//

import SwiftUI
import Defaults

var firstTextView: UITextView?

struct DocumentTextContainer: UIViewRepresentable {
    
    static let textColor = UIColor(displayP3Red: 69/255, green: 69/255, blue: 69/255, alpha: 1.0)
    static let backgroundColor = UIColor(displayP3Red: 249/255, green: 247/255, blue: 231/255, alpha: 1.0)
    
    var url: URL?
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
        l.delegate = context.coordinator
        return l
    }
    
    func updateUIView(_ uiView: UIScrollView, context: Context) {
      
      guard let url = url else { return }
        
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
            textView.textColor = DocumentTextContainer.textColor
            textView.backgroundColor = DocumentTextContainer.backgroundColor
            textView.isEditable = false
            textView.isSelectable = false
            uiView.addSubview(textView)
            
            if firstTextView == nil {
                firstTextView = textView
            }
            
            let tap = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.doAction(sender:)))
            textView.addGestureRecognizer(tap)
            
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
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
}

class Coordinator: NSObject {
    @objc func doAction(sender: Any) {
        guard let recognizer = sender as? UITapGestureRecognizer else { return }
        guard let textView = recognizer.view as? UITextView else { return }
        
        let layoutManager = textView.layoutManager
        var location = recognizer.location(in: textView)
        location.x -= textView.textContainerInset.left
        location.y -= textView.textContainerInset.top
        
        let characterIndex = layoutManager.characterIndex(for: location, in: textView.textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        //TODO: highlight tap area
        if characterIndex < textView.textStorage.length {
            let word = wordAtIndex(index: characterIndex, inString: textView.attributedText.string as NSString)
            Translator.shared.input = word as String
        }
        
    }
    
    func wordRangeAtIndex(index:Int, inString str:NSString) -> NSRange {
        let tagger = NSLinguisticTagger(tagSchemes: [NSLinguisticTagScheme.tokenType], options: 0)
        var r : NSRange = NSMakeRange(0, 0)
        tagger.string = str as String
        tagger.tag(at: index, scheme: NSLinguisticTagScheme.tokenType, tokenRange: &r, sentenceRange: nil )
        return r
    }

    func wordAtIndex(index:Int, inString str:NSString) -> NSString {
        return str.substring(with: wordRangeAtIndex(index: index, inString: str)) as NSString
    }
}

extension Coordinator: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        updateIndex(scrollView: scrollView)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        updateIndex(scrollView: scrollView)
    }
    
    func updateIndex(scrollView: UIScrollView) {
        let p = UInt(scrollView.contentOffset.x / scrollView.bounds.size.width)
//        Defaults[.pageIndex] = p
        Preference.shared.updateDocumentProgress(title: "test", chapter: 1, page: Int64(p))
    }
}
