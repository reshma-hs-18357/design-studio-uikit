//
//  Untitled.swift
//  Design Studio UIKit dev
//
//  Created by Ganesh Arora on 19/11/25.
//
import UIKit


enum LayoutMode {
    case autoWidthAutoHeight
    case fixedWidthAutoHeight
    case fixedHeightAutoWidth
    case fixedFixed
}

enum NewLayoutMode {
    case autoWidthAutoHeight
    case fixedWidthAutoHeight(width: CGFloat)
    case fixedHeightAutoWidth(height: CGFloat)
    case fixedFixed(width: CGFloat, height: CGFloat)
}


struct LayoutConfig {
    let mode: LayoutMode
    let fixedWidth: CGFloat
    let fixedHeight: CGFloat
    let maxWidth: CGFloat
    
    init(mode: LayoutMode,
         fixedWidth: CGFloat = 180,
         fixedHeight: CGFloat = 80,
         maxWidth: CGFloat = UIScreen.main.bounds.width - 32) {
        self.mode = mode
        self.fixedWidth = fixedWidth
        self.fixedHeight = fixedHeight
        self.maxWidth = maxWidth
    }
}

protocol LayoutManageable: UIView {
    var widthConstraint: NSLayoutConstraint? { get set }
    var heightConstraint: NSLayoutConstraint? { get set }
    func apply(config: LayoutConfig)
}



extension LayoutManageable {
    
    func apply(config: LayoutConfig) {
        widthConstraint?.isActive = false
        heightConstraint?.isActive = false
        
       
        switch config.mode {
        case .autoWidthAutoHeight:
            break
            
        case .fixedWidthAutoHeight:
            widthConstraint?.constant = config.fixedWidth
            widthConstraint?.isActive = true
            
        case .fixedHeightAutoWidth:
            heightConstraint?.constant = config.fixedHeight
            heightConstraint?.isActive = true
            
        case .fixedFixed:
            widthConstraint?.constant = config.fixedWidth
            widthConstraint?.isActive = true
            heightConstraint?.constant = config.fixedHeight
            heightConstraint?.isActive = true
        }
        
        self.layoutIfNeeded()
    }
}

extension NSLayoutConstraint {
    func with(identifier: String) -> NSLayoutConstraint {
        self.identifier = identifier
        return self
    }
}
