//
//  ViewDecorator.swift
//  DesignStudioUIKit
//
//  Created by Reshma S on 17/11/25.
//

import UIKit

class ViewDecorator {
    
    private static let backgroundViewTag = 900_001
    
    static func applyBackground(imageView: UIImageView, element : ElementViewModel){
        
        imageView.backgroundColor = backgroundColor(element: element)
        imageView.contentMode = ViewDecorator.backgroundImageContentMode(element: element)
        if let background = element.elementDetail?.style?.background,
           let imageSrc = background.image?.src,
           !imageSrc.isEmpty {
            
            let rawURL = "https://dockerdev19.csez.zohocorpin.com/creator/\(staticImageID)/\(imageSrc)"
            if let encodedURL = rawURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
               let url = URL(string: encodedURL) {
                URLSession.shared.dataTask(with: url) { data, _, error in
                    guard error == nil, let data = data, let image = UIImage(data: data) else { return }
                    DispatchQueue.main.async {
                        imageView.image = image
                    }
                }.resume()
            }
        }
        
    }
    
    static  func applyCornerRadius (view : UIView, element: ElementViewModel) {
        let radius =  ViewDecorator.cornerRadius(element: element)
        if radius != 0 {
            view.layer.cornerRadius = radius
        }
    }
    
    static func applyBorder(view : UIView , element : ElementViewModel) {
        if let border = element.elementDetail?.style?.border,
           (border.isEnabled ?? true),
           let thickness = border.thickness,
           let thicknessValue = Double(thickness),
           thicknessValue > 0 {
            view.layer.borderWidth = CGFloat(thicknessValue)
            view.layer.borderColor = (UIColor(hex: border.color ?? "#000000") ?? .black).cgColor
        } else {
            view.layer.borderWidth = 0
        }
    }
    
    static func applyOpacity(view : UIView , element : ElementViewModel) {
        guard let opacity = element.elementDetail?.style?.opacity else {
            return
        }
        view.layer.opacity = (Float(opacity) ?? 100) / 100.0
    }
    
    static func applyShadow(view : UIView , element : ElementViewModel) {
        guard let shadow = element.elementDetail?.style?.shadow,
              shadow.isEnabled == true else {
            view.layer.shadowOpacity = 0
            return
        }
        let colorString = shadow.color ?? ""
        let shadowUIColor = !colorString.isEmpty ? (UIColor(hex: colorString) ?? .clear) : .clear
        let blur = CGFloat(Double(shadow.blur ?? "0") ?? 0)
        let x = CGFloat(Double(shadow.xOffset ?? "0") ?? 0)
        let y = CGFloat(Double(shadow.yOffset ?? "0") ?? 0)
        
        view.layer.shadowColor = shadowUIColor.cgColor
        view.layer.shadowRadius = blur
        view.layer.shadowOffset = CGSize(width: x, height: y)
        view.layer.shadowOpacity = 1.0
        view.layer.masksToBounds = false
    }
    
    private static func cornerRadius (element : ElementViewModel)-> CGFloat {
        guard let cornerRadius = element.elementDetail?.style?.cornerRadius else {
            return 0
        }
        if let value = cornerRadius.value, !value.isEmpty {
            let cleanedValue = value
                .replacingOccurrences(of: "px", with: "", options: .caseInsensitive)
                .trimmingCharacters(in: .whitespacesAndNewlines)
            
            return CGFloat(Double(cleanedValue) ?? 0)
        }
        if let preset = cornerRadius.preset, !preset.isEmpty {
            switch preset {
            case "preset1": return 6
            case "preset2": return 12
            case "preset3": return 16
            case "preset4": return 24
            case "preset5": return 32
            case "preset6": return 1000
            default: break
            }
        }
        return 0
    }
    
    private static func backgroundColor (element : ElementViewModel) -> UIColor {
        if let color = element.elementDetail?.style?.background?.color, !color.isEmpty {
            return UIColor(hex: color) ?? .clear
        }
        return .clear
    }
    
    
    private static func backgroundImageContentMode(element: ElementViewModel) -> UIView.ContentMode {
        if let value = element.elementDetail?.style?.background?.image?.size {
            switch value {
            case .fill:
                return .scaleToFill
            case .fit:
                return .scaleAspectFit
            case .stretch:
                return .scaleToFill
            default:
                return .scaleAspectFill
            }
        }
        return .scaleAspectFill
    }
        
    
    private static func loadBackgroundImage(element: ElementViewModel) -> UIView {
        let imageView = UIImageView()
        imageView.contentMode = ViewDecorator.backgroundImageContentMode(element: element)
        imageView.clipsToBounds = true
        
        if let background = element.elementDetail?.style?.background,
           background.isEnabled == true,
           let imageSrc = background.image?.src,
           !imageSrc.isEmpty {
            
            let rawURL = "https://dockerdev19.csez.zohocorpin.com/creator/\(staticImageID)/\(imageSrc)"
            if let encodedURL = rawURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
               let url = URL(string: encodedURL) {
                URLSession.shared.dataTask(with: url) { data, _, error in
                    guard error == nil, let data = data, let image = UIImage(data: data) else { return }
                    DispatchQueue.main.async {
                        imageView.image = image
                    }
                }.resume()
            }
        }
        return imageView
    }
}
