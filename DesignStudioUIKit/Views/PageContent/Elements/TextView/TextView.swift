//
//  TextView.swift
//  DesignStudioUIKit
//
//  Created by Reshma S on 18/11/25.
//

import UIKit

class TextView: UIImageView {
    let element: ElementViewModel

    private let textView = UITextView()
    
    init(element: ElementViewModel) {
        self.element = element
        super.init(frame: .zero)
        clipsToBounds = true
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupView(){
        guard let content = element.elementDetail?.content else { return }
        
        self.isUserInteractionEnabled = true // UIImageView blocks the default scroll behaviour of UITextView
        self.backgroundColor = .purple

        textView.translatesAutoresizingMaskIntoConstraints = false

        self.addSubview(textView)
                
        textView.text = cleanContent(content)
        textView.font = fontStyle
        textView.textColor = textViewColor
        textView.isScrollEnabled = true
        textView.isEditable = false
        textView.textAlignment = textViewAlignment
        textView.backgroundColor = .clear
        textView.textContainerInset =  padding
        textView.textContainer.lineFragmentPadding = 0
    
        // Apply styling
        ViewDecorator.applyBackground(imageView: self, element: element)
        ViewDecorator.applyCornerRadius(view: self, element: element)
        ViewDecorator.applyShadow(view: self, element: element)
        ViewDecorator.applyBorder(view: self, element: element)
        ViewDecorator.applyOpacity(view: self, element: element)
        
        ConstraintSetter.fillParent(parent: self, child: textView)

    }
    
    
    private func cleanContent(_ content: String) -> String {
         guard let data = content.data(using: .utf8) else {
             return content.trimmingCharacters(in: .whitespacesAndNewlines)
         }
         
         let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
             .documentType: NSAttributedString.DocumentType.html,
             .characterEncoding: String.Encoding.utf8.rawValue
         ]
         
         if let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil) {
             let decodedString = attributedString.string
             return cleanupWhitespace(decodedString)
         }
         
         let decoded = decodeHTMLEntities(content)
         return cleanupWhitespace(decoded)
     }
     
     private func cleanupWhitespace(_ string: String) -> String {
         let lines = string.components(separatedBy: .newlines)
         let cleanedLines = lines
             .map { $0.trimmingCharacters(in: .whitespaces) }
             .filter { !$0.isEmpty }
        return cleanedLines.joined(separator: "\n")
     }
     
     private func decodeHTMLEntities(_ string: String) -> String {
         var result = string
         let entities: [String: String] = [
             "&nbsp;": " ",
             "&amp;": "&",
             "&lt;": "<",
             "&gt;": ">",
             "&quot;": "\"",
             "&apos;": "'",
             "&#39;": "'",
             "&copy;": "©",
             "&reg;": "®"
         ]
         for (entity, character) in entities {
             result = result.replacingOccurrences(of: entity, with: character)
         }
          result = result.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression)
         return result
     }
    
    private var fontStyle: UIFont {
        guard let font = element.elementDetail?.style?.font else {
            return .systemFont(ofSize: 14)
        }
        
        let size = CGFloat(Double(font.size?.value ?? "14") ?? 14)
        let weight = fontWeight(from: font.weight)
        return .systemFont(ofSize: size, weight: weight)
    }
    
    private func fontWeight(from weight: String?) -> UIFont.Weight {
        guard let weight = weight?.lowercased() else { return .regular }
        
        switch weight {
        case "thin": return .thin
        case "ultralight": return .ultraLight
        case "light": return .light
        case "regular": return .regular
        case "medium": return .medium
        case "semibold": return .semibold
        case "bold": return .bold
        case "heavy": return .heavy
        case "black": return .black
        default: return .regular
        }
    }
    
    
    private var textViewColor: UIColor {
        guard let hex = element.elementDetail?.style?.font?.color, !hex.isEmpty else {
            return .black
        }
        return UIColor(hex: hex) ?? .black
    }
    
    private var textViewAlignment: NSTextAlignment {
        guard let alignString = element.elementDetail?.style?.align?.textAlign?.lowercased() else {
            return .left
        }
        
        switch alignString {
        case "center", "centre": return .center
        case "right": return .right
        case "left": return .left
        default: return .left
        }
    }
    
    private var padding: UIEdgeInsets {
        guard let padding = element.elementDetail?.style?.padding else {
            return UIEdgeInsets.zero
        }
        if padding.isEven == true, let value = padding.value {
            let value = Double(value) ?? 0
            return UIEdgeInsets(top: value, left: value, bottom: value, right: value)
        }
        else{
            let top = Double(padding.top?.value ?? "0") ?? 0
            let left = Double(padding.left?.value ?? "0") ?? 0
            let right = Double(padding.right?.value ?? "0") ?? 0
            let bottom = Double(padding.bottom?.value ?? "0") ?? 0
            
            return UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
        }
    }
    
}
