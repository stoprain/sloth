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
    
    class Coordinator: NSObject {
        @objc func doAction(sender: Any) {
            guard let recognizer = sender as? UITapGestureRecognizer else { return }
            guard let textView = recognizer.view as? UITextView else { return }
//
//            print("########")
//            print(recognizer)
//            print(textView)
//
//            let location: CGPoint = recognizer.location(in: textView)
//            print(location)
//            let position: CGPoint = CGPoint(x: location.x, y: location.y)
//            print(position)
//            if let tapPosition: UITextPosition = textView.closestPosition(to: position) {
//                guard let textRange: UITextRange = textView.tokenizer.rangeEnclosingPosition(tapPosition, with: UITextGranularity.word, inDirection: UITextDirection(rawValue: 1)) else {return}
//
//                let tappedWord: String = textView.text(in: textRange) ?? ""
//
//                Translator.shared.input = tappedWord
//            } else {
//                Translator.shared.input = ""
//            }
            
//        https://stackoverflow.com/questions/25465274/get-tapped-word-from-uitextview-in-swift

//            guard let textView = recognizer.view as? UITextView else { return }
//            let layoutManager = textView.layoutManager
//            var location: CGPoint = recognizer.location(in: textView)
//            location.x -= textView.textContainerInset.left
//            location.y -= textView.textContainerInset.top
//
//            var charIndex = layoutManager.characterIndex(for: location, in: textView.textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
//
//             guard charIndex < textView.textStorage.length else {
//                 return
//             }
//
//             var range = NSRange(location: 0, length: 0)
//
//            if let idval = textView.attributedText?.attribute(NSAttributedString.Key("idnum"), at: charIndex, effectiveRange: &range) as? NSString {
//                 print("id value: \(idval)")
//                 print("charIndex: \(charIndex)")
//                 print("range.location = \(range.location)")
//                 print("range.length = \(range.length)")
//                 let tappedPhrase = (textView.attributedText.string as NSString).substring(with: range)
//                 print("tapped phrase: \(tappedPhrase)")
//                 var mutableText = textView.attributedText.mutableCopy() as? NSMutableAttributedString
//                mutableText?.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.red], range: range)
//                 textView.attributedText = mutableText
//             }
//            if let desc = textView.attributedText?.attribute(NSAttributedString.Key("desc"), at: charIndex, effectiveRange: &range) as? NSString {
//                 print("desc: \(desc)")
//             }
            
            let layoutManager = textView.layoutManager
            var location = recognizer.location(in: textView)
            location.x -= textView.textContainerInset.left
            location.y -= textView.textContainerInset.top
            
            let characterIndex = layoutManager.characterIndex(for: location, in: textView.textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
            print(characterIndex)
            if characterIndex < textView.textStorage.length {
//                textView.position(within: , atCharacterOffset: <#T##Int#>)
//                textView.tokenizer.rangeEnclosingPosition(UITextPosition, with: <#T##UITextGranularity#>, inDirection: <#T##UITextDirection#>)
//                guard let textRange: UITextRange = textView.tokenizer.rangeEnclosingPosition(characterIndex, with: UITextGranularity.word, inDirection: UITextDirection(rawValue: 1)) else {return}
                //
                //                let tappedWord: String = textView.text(in: textRange) ?? ""
            }
            
        }
    }
    
}
