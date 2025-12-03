//
//  ViewDecorator.swift
//  DesignStudioUIKit
//
//  Created by Reshma S on 17/11/25.
//

import UIKit

class ViewDecorator {
        
    static func applyBackground(imageView: UIImageView, element : ElementViewModel){
        
        imageView.contentMode = ViewDecorator.backgroundImageContentMode(element: element)
        guard let imageSrc = element.elementDetail?.style?.background?.image?.src,
               !imageSrc.isEmpty else {
             return
         }
        let rawURL = "https://dockerdev19.csez.zohocorpin.com/creator/\(staticImageID)/\(imageSrc)"
          
          guard
              let encodedURL = rawURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: encodedURL)
          else {
              return
          }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
               guard error == nil,
                     let data = data,
                     let image = UIImage(data: data) else {
                   return
               }
               DispatchQueue.main.async {
                   imageView.image = image
               }
           }.resume()
        
    }
    
    static func applyBackgroundColor(view: UIView, element: ElementViewModel) {
        if let hex = element.elementDetail?.style?.background?.color, !hex.isEmpty {
            view.backgroundColor = UIColor.from(hex)
        } else {
            view.backgroundColor = .clear
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
            view.layer.borderColor = (UIColor(hex: border.color ?? "#000000") ?? .clear).cgColor
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
            case "preset1": return 0
            case "preset2": return 6
            case "preset3": return 12
            case "preset4": return 16
            case "preset5": return 24
            case "preset6": return 32
            case "preset7": return 1000
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
                return .scaleAspectFill
            case .fit:
                return .scaleAspectFit
            case .stretch:
                return .scaleAspectFill
            default:
                return .scaleAspectFill
            }
        }
        return .scaleAspectFit
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
