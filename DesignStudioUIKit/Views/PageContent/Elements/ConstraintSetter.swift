//
//  Untitled.swift
//  DesignStudioUIKit
//
//  Created by Reshma S on 17/11/25.
//
import UIKit

class ConstraintSetter {
    
    static func applyConstraints(parent: UIView, child: UIView , element: ElementViewModel){

        let hasTop = hasTopConstraint(element: element)
        let topMargin = topMargin(element: element)
      
        if hasTop {
            child.topAnchor.constraint(equalTo: parent.topAnchor, constant: topMargin).isActive = true
        }else{
            child.topAnchor.constraint(greaterThanOrEqualTo: parent.topAnchor).isActive = true
        }
        
        let hasBottom = hasBottomConstraint(element: element)
        let bottomMargin =  bottomMargin(element: element)
        
        if hasBottom {
            child.bottomAnchor.constraint(equalTo: parent.bottomAnchor, constant: -1 * bottomMargin).isActive = true
        }else{
            child.bottomAnchor.constraint(lessThanOrEqualTo: parent.bottomAnchor).isActive = true
        }
        
        let hasLeading = hasLeadingConstraint(element: element)
        let leftmargin = leftMargin(element: element)
        
        if hasLeading {
            child.leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: leftmargin).isActive = true
        }else {
            child.leadingAnchor.constraint(greaterThanOrEqualTo: parent.leadingAnchor).isActive = true
        }
        
        let hasTrailing = hasTrailingConstraint(element: element)
        let trailmargin =  rightMargin(element: element)

        if hasTrailing {
            child.trailingAnchor.constraint(equalTo: parent.trailingAnchor, constant: -1 * trailmargin).isActive = true
        }else {
            child.trailingAnchor.constraint(lessThanOrEqualTo: parent.trailingAnchor).isActive = true
        }
        
        
        applyHeightConstraints(parent: parent, child: child, element: element)
        
        applyWidthConstraints(parent: parent, child: child, element: element)
    }
    
    private static func hasTopConstraint (element :ElementViewModel) -> Bool {
        let isEnabled = element.elementDetail?.layout?.constraints?.top?.isEnabled ?? false
//        if element.elementDetail?.layout?.height?.unit == .auto {
//            return true
//        }
        return isEnabled
    }

    private static func hasBottomConstraint (element :ElementViewModel) -> Bool {
        let isEnabled = element.elementDetail?.layout?.constraints?.bottom?.isEnabled ?? false
//        if element.elementDetail?.layout?.height?.unit == .auto {
//            return true
//        }
        return isEnabled
    }
    
    private static func hasLeadingConstraint (element :ElementViewModel) -> Bool {
        let isEnabled = element.elementDetail?.layout?.constraints?.left?.isEnabled ?? false
//        if element.elementDetail?.layout?.width?.unit == .auto {
//            return true
//        }
        return isEnabled
    }
    
    private static func hasTrailingConstraint (element :ElementViewModel) -> Bool {
        let isEnabled = element.elementDetail?.layout?.constraints?.right?.isEnabled ?? false
//        if isEnabled && hasLeadingConstraint(element: element) && element.elementDetail?.layout?.width?.unit == .auto {
//            return true
//        }
        return isEnabled
    }
    
    private static func applyHeightConstraints(parent: UIView, child: UIView, element :ElementViewModel) {
        
        guard let height = element.elementDetail?.layout?.height else {
          return
        }
        switch height.unit {
        case .px:
            let frameHeight = CGFloat(Double(height.value ?? "0") ?? 0)
            child.heightAnchor.constraint(equalToConstant: frameHeight).isActive = true
         
        case .percent:
            print(parent.tag);
            let percentValue = Double(height.value ?? "0") ?? 0
            let multiplier = percentValue / 100.0
            if multiplier < 1.0 {
                child.heightAnchor.constraint(equalTo: parent.heightAnchor, multiplier: CGFloat(multiplier)).isActive = true
            }
            else {
                let overflow = (multiplier - 1.0) / 2.0
                let margin = parent.bounds.width * overflow
                child.topAnchor.constraint(equalTo: parent.topAnchor, constant: -1 * margin).isActive = true
                child.bottomAnchor.constraint(equalTo: parent.bottomAnchor, constant: margin).isActive = true
            }
            
        case .auto:
            return
            
        case .fillContent, .fitContent:
            child.heightAnchor.constraint(equalTo: parent.heightAnchor, multiplier: 1.0).isActive = true
           
        default:
            return
           
        }
    }
        
    private static func applyWidthConstraints(parent: UIView, child: UIView, element :ElementViewModel) {
        guard let width = element.elementDetail?.layout?.width else {
          return
        }
        switch width.unit {
        case .px:
            
            let frameWidth = CGFloat(Double(width.value ?? "0") ?? 0)
            child.widthAnchor.constraint(equalToConstant: frameWidth).isActive = true
            
        case .percent:
            print(parent.tag);
            let padding = padding(elementModel: element)
            let percentValue = Double(width.value ?? "0") ?? 0
            let multiplier = percentValue / 100.0
         
            if multiplier <= 1.0 {
                child.widthAnchor.constraint(equalTo: parent.widthAnchor, multiplier: CGFloat(multiplier)).isActive = true
            }
            else {
                let overflow = (multiplier - 1.0) / 2.0
                let margin = parent.bounds.width * overflow
                child.leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: -margin).isActive = true
                child.trailingAnchor.constraint(equalTo: parent.trailingAnchor, constant: margin).isActive = true
            }
            
        case .auto:
            child.trailingAnchor.constraint(lessThanOrEqualTo: parent.trailingAnchor).isActive = true
//            return
            
        case .fillContent, .fitContent:
            child.widthAnchor.constraint(equalTo: parent.widthAnchor, multiplier: 1.0).isActive = true
            
        default:
            return
         
        }
    }
    
    private static func topMargin(element :ElementViewModel) -> CGFloat {
        guard let isEnabled = element.elementDetail?.layout?.constraints?.top?.isEnabled,
              isEnabled,
              let value = element.elementDetail?.layout?.constraints?.top?.value,
              let margin = Double(value) else {
            return 0
        }
        return CGFloat(margin)
    }
    
    private static func bottomMargin(element :ElementViewModel) -> CGFloat {
        guard let isEnabled = element.elementDetail?.layout?.constraints?.bottom?.isEnabled,
              isEnabled,
              let value = element.elementDetail?.layout?.constraints?.bottom?.value,
              let margin = Double(value) else {
            return 0
        }
        return CGFloat(margin)
    }
    
    private static func leftMargin(element :ElementViewModel) -> CGFloat {
        guard let isEnabled = element.elementDetail?.layout?.constraints?.left?.isEnabled,
              isEnabled,
              let value = element.elementDetail?.layout?.constraints?.left?.value,
              let margin = Double(value) else {
            return 0
        }
        return CGFloat(margin)
    }
    
    private static func rightMargin(element :ElementViewModel) -> CGFloat {
        guard let isEnabled = element.elementDetail?.layout?.constraints?.right?.isEnabled,
              isEnabled,
              let value = element.elementDetail?.layout?.constraints?.right?.value,
              let margin = Double(value) else {
            return 0
        }
        return CGFloat(margin)
    }
    
}

extension ConstraintSetter {
    
    static func fillParent(parent: UIView, child: UIView , element : ElementViewModel? = nil){
        let padding =  padding(elementModel: element)
        
        NSLayoutConstraint.activate([
            child.topAnchor.constraint(equalTo: parent.topAnchor, constant: padding.top),
            child.bottomAnchor.constraint(equalTo: parent.bottomAnchor, constant: padding.bottom * -1),
            child.leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: padding.left),
            child.trailingAnchor.constraint(equalTo: parent.trailingAnchor, constant: padding.right * -1)
        ])
    }

    private static func padding(elementModel : ElementViewModel?) -> UIEdgeInsets {
      
        guard let padding = elementModel?.elementDetail?.style?.padding else {
                 return .zero
        }
        if padding.isEven == true,
            let value = padding.value {
            let value = CGFloat(Double(value) ?? 0)
            return UIEdgeInsets.init(top: value, left: value, bottom: value, right: value)
            
        } else {
            let top = CGFloat(Double(padding.top?.value ?? "0") ?? 0)
            let left = CGFloat(Double(padding.left?.value ?? "0") ?? 0)
            let right = CGFloat(Double(padding.right?.value ?? "0") ?? 0)
            let bottom = CGFloat(Double(padding.bottom?.value ?? "0") ?? 0)
            
            return UIEdgeInsets.init(top: top, left: left, bottom: bottom, right: right)
        }
    }
}

extension ConstraintSetter {
    
    static func applyStackChildConstraints(stackView: UIStackView, child: UIView, element: ElementViewModel) {
        applyStackHeightConstraints(parent: stackView, child: child, element: element)
        applyStackWidthConstraints(parent: stackView, child: child, element: element)
    }
    
    private static func applyStackHeightConstraints(parent: UIView, child: UIView, element: ElementViewModel) {
        guard let height = element.elementDetail?.layout?.height else {
            return
        }
        switch height.unit {
        case .px:
            let frameHeight = CGFloat(Double(height.value ?? "0") ?? 0)
            child.heightAnchor.constraint(equalToConstant: frameHeight).isActive = true
            
        case .percent:
            let percentValue = Double(height.value ?? "0") ?? 0
            let multiplier = percentValue / 100.0
            child.heightAnchor.constraint(equalTo: parent.heightAnchor, multiplier: CGFloat(multiplier)).isActive = true
        
        case .auto:
            return
        case .fillContent, .fitContent:
            child.heightAnchor.constraint(equalTo: parent.heightAnchor, multiplier: 1.0).isActive = true
            
        default:
            return
        }
    }
    
    private static func applyStackWidthConstraints(parent: UIView, child: UIView, element: ElementViewModel) {
        guard let width = element.elementDetail?.layout?.width else {
            return
        }
        switch width.unit {
        case .px:
            let frameWidth = CGFloat(Double(width.value ?? "0") ?? 0)
            child.widthAnchor.constraint(equalToConstant: frameWidth).isActive = true
            
        case .percent:
            let percentValue = Double(width.value ?? "0") ?? 0
            let multiplier = percentValue / 100.0
            child.widthAnchor.constraint(equalTo: parent.widthAnchor, multiplier: CGFloat(multiplier)).isActive = true
                     
            if multiplier <= 1.0 {
                child.widthAnchor.constraint(equalTo: parent.widthAnchor, multiplier: CGFloat(multiplier)).isActive = true
            }
            else {
                let overflow = (multiplier - 1.0) / 2.0
                let margin = parent.bounds.width * overflow
                child.leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: -1 * margin).isActive = true
                child.trailingAnchor.constraint(equalTo: parent.trailingAnchor, constant: margin).isActive = true
            }
            
        case .auto:
            return
            
        case .fillContent, .fitContent:
            child.widthAnchor.constraint(equalTo: parent.widthAnchor, multiplier: 1.0).isActive = true
            
        default:
            return
        }
    }
}
