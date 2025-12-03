//
//  TextView.swift
//  DesignStudioUIKit
//
//  Created by Reshma S on 18/11/25.
//

import UIKit

class TextView: UIImageView {
    let element: ElementViewModel
    private var textViewHeightConstraint: NSLayoutConstraint?
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
        self.addSubview(textView)
        self.isUserInteractionEnabled = true

        textView.translatesAutoresizingMaskIntoConstraints = false

        textView.text = cleanContent(content)
        textView.font = fontStyle
        textView.textColor = textViewColor
        textView.isEditable = false
        textView.textAlignment = textViewAlignment
        textView.backgroundColor = .clear
        textView.bounces = false
        textView.textContainerInset =  padding
        textView.isScrollEnabled = shouldEnableScroll
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
//        textView.setContentHuggingPriority(.defaultLow, for: .horizontal)
//        textView.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
    
        // Apply styling
        ViewDecorator.applyBackground(imageView: self, element: element)
        ViewDecorator.applyCornerRadius(view: self, element: element)
        ViewDecorator.applyShadow(view: self, element: element)
        ViewDecorator.applyBorder(view: self, element: element)
        ViewDecorator.applyOpacity(view: self, element: element)
                
        ConstraintSetter.fillParent(parent: self, child: textView)
    }
    
//    private func calcContentSize(child: UITextView)  {
//        guard var width = element.elementDetail?.layout?.width else {
//          return
//        }
//        var widthValue: CGFloat = 0        
//        switch width.unit {
//        case .px:
//            widthValue = CGFloat(Double(width.value ?? "0") ?? 0)
//         
//        case .percent:
//           print("")
//        case .auto:
//            return
//            
//        case .fillContent, .fitContent:
//            return
//           
//        default:
//            return
//           
//        }
//        widthValue = (self.textView.frame.width == 0) ? widthValue : self.textView.frame.width
//        
//        let size = CGSize(width: widthValue, height: .infinity)
//        let estimatedSize = self.textView.sizeThatFits(size)
//            self.textViewHeightConstraint?.constant = estimatedSize.height
////                    UIView.animate(withDuration: 0.1) {
//                    self.layoutIfNeeded()
//    }
//    
    
    private func calcContentSize(child: UITextView)  {
        var availableParentWidth = textView.frame.width
        guard let width = element.elementDetail?.layout?.width else {
          return
        }
        DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
            let size = CGSize(width: self.textView.frame.width, height: .infinity)
            let estimatedSize = self.textView.sizeThatFits(size)
                self.textViewHeightConstraint?.constant = estimatedSize.height
//                    UIView.animate(withDuration: 0.1) {
                        self.layoutIfNeeded()
//                    }
        })
    
    }
//    
//    }
//   
   
    private var shouldEnableScroll: Bool {
        guard let width = element.elementDetail?.layout?.width,
              let height = element.elementDetail?.layout?.height else {
            return false
        }
        if width.unit == .auto || height.unit == .auto {
             return false
         }

        if width.unit == .percent,
              height.unit == .percent,
           Double(width.value ?? "0") ?? 0.0 <= 100.0,
           Double(height.value ?? "0") ?? 0.0 <= 100.0 {
               return false
           }
        return true
        
        
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

    private func fontWeight(from weightString: String?) -> UIFont.Weight {
        guard (weightString?.lowercased()) != nil else { return .regular }
    
        switch weightString {
        case "100": return .ultraLight
        case "200": return .thin
        case "300": return .light
        case "400": return .regular
        case "500": return .medium
        case "600": return .semibold
        case "700": return .bold
        case "800": return .heavy
        case "900": return .black
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
        guard let horizontalAlignment = element.elementDetail?.style?.align?.horizontal else {
            return .left
        }
        switch horizontalAlignment {
            case .left : return .left
            case .center : return .center
            case .right : return .right
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
