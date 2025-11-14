//
//  AppColors.swift
//  designStudioDemo
//
//  Created by reshma-18357 on 02/07/25.
//

import UIKit

// MARK: - UIColor Extension for Hex


extension UIColor {
        
    convenience init?(hex: String) {
        let r, g, b, a: CGFloat
        
        var hexColor = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexColor = hexColor.replacingOccurrences(of: "#", with: "")
        
        var int: UInt64 = 0
        Scanner(string: hexColor).scanHexInt64(&int)
        
        switch hexColor.count {
        case 3: // RGB (12-bit)
            (r, g, b, a) = (
                CGFloat((int >> 8) * 17) / 255.0,
                CGFloat((int >> 4 & 0xF) * 17) / 255.0,
                CGFloat((int & 0xF) * 17) / 255.0,
                1.0
            )
        case 6: // RGB (24-bit)
            (r, g, b, a) = (
                CGFloat((int >> 16) & 0xFF) / 255.0,
                CGFloat((int >> 8) & 0xFF) / 255.0,
                CGFloat(int & 0xFF) / 255.0,
                1.0
            )
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (
                CGFloat((int >> 24) & 0xFF) / 255.0,
                CGFloat((int >> 16) & 0xFF) / 255.0,
                CGFloat((int >> 8) & 0xFF) / 255.0,
                CGFloat(int & 0xFF) / 255.0
            )
        default:
            return nil
        }
        
        self.init(red: r, green: g, blue: b, alpha: a)
    }
    
    
    
    static func from(_ value: String) -> UIColor {
        let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        
        // Case 1: rgba(r,g,b,a)
        if trimmed.starts(with: "rgba") {
            return parseRGBA(trimmed)
        }
        
        // Case 2: hex (#FFF, #FFFFFF)
        if trimmed.starts(with: "#") {
            return UIColor(hex: trimmed) ?? UIColor.clear
        }
        
        // Default fallback
        return .clear
    }

    
    private static func parseRGBA(_ rgbaString: String) -> UIColor {
        let values = rgbaString
            .replacingOccurrences(of: "rgba(", with: "")
            .replacingOccurrences(of: ")", with: "")
            .split(separator: ",")
            .map { $0.trimmingCharacters(in: .whitespaces) }
        
        guard values.count == 4,
              let r = Double(values[0]),
              let g = Double(values[1]),
              let b = Double(values[2]),
              let a = Double(values[3]) else {
            return .clear
        }
        
        return UIColor(
            red: CGFloat(r / 255.0),
            green: CGFloat(g / 255.0),
            blue: CGFloat(b / 255.0),
            alpha: CGFloat(a)
        )
    }
}
