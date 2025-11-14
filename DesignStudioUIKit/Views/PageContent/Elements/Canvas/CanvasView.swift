//
//  CanvasView.swift
//  DesignStudioUIKit
//
//  Created by Reshma S on 13/11/25.
//


import UIKit

class CanvasView: UIView {
    let element: ElementViewModel
    let elementsMap: [String: ElementViewModel]
    
    private let containerView = UIView()
    
    init(element: ElementViewModel, elementsMap: [String: ElementViewModel]) {
        self.element = element
        self.elementsMap = elementsMap
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        containerView.backgroundColor = UIColor.cyan
        containerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(containerView)
        
        // Add sub-elements
        if let subElements = element.subElements {
            for subElementId in subElements {
                if let subElement = elementsMap[subElementId] {
                    let renderer = ElementRendererView(
                        element: subElement,
                        elementsMap: elementsMap
                    )
                    renderer.translatesAutoresizingMaskIntoConstraints = false
                    containerView.addSubview(renderer)
                    
                    // Position using XY coordinates or layout constraints
                    positionChildElement(renderer, withLayout: subElement.elementDetail?.layout)
                }
            }
        }
    }
    
    private func positionChildElement(_ childView: UIView, withLayout layout: ElementLayout?) {
        var constraints: [NSLayoutConstraint] = []
        
        // Get XY position from constraints
        let topOffset = getConstraintValue(layout?.constraints?.top) ?? 0
        let leftOffset = getConstraintValue(layout?.constraints?.left) ?? 0
        
        // Position the child
        constraints.append(childView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: topOffset))
        constraints.append(childView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: leftOffset))
        
        // Apply width if specified
        if let width = layout?.width {
            switch width.unit {
            case .px:
                if let value = width.value, let widthValue = Double(value), widthValue > 0 {
                    constraints.append(childView.widthAnchor.constraint(equalToConstant: CGFloat(widthValue)))
                }
            case .percent:
                if let value = width.value, let percentage = Double(value), percentage > 0 {
                    constraints.append(childView.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: CGFloat(percentage) / 100.0))
                }
            default:
                break
            }
        }
        
        // Apply height if specified
        if let height = layout?.height {
            switch height.unit {
            case .px:
                if let value = height.value, let heightValue = Double(value), heightValue > 0 {
                    constraints.append(childView.heightAnchor.constraint(equalToConstant: CGFloat(heightValue)))
                }
            case .percent:
                if let value = height.value, let percentage = Double(value), percentage > 0 {
                    constraints.append(childView.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: CGFloat(percentage) / 100.0))
                }
            default:
                break
            }
        }
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func getConstraintValue(_ constraint: ElementLayout.ConstraintDetail?) -> CGFloat {
        guard let constraint = constraint,
              constraint.isEnabled == true,
              let value = constraint.value,
              let doubleValue = Double(value) else {
            return 0
        }
        return CGFloat(doubleValue)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let width = canvasWidth(in: bounds.size)
        let height = canvasHeight(in: bounds.size)
        
        var frame = CGRect.zero
        frame.size.width = width ?? bounds.width
        frame.size.height = height ?? bounds.height
        containerView.frame = frame
    }
    
    private func canvasWidth(in size: CGSize) -> CGFloat? {
        guard let width = element.elementDetail?.layout?.width else {
            return nil
        }
        
        switch width.unit {
        case .percent:
            if let valueStr = width.value, let percentage = Double(valueStr) {
                return size.width * CGFloat(percentage) / 100.0
            }
            return nil
        case .auto, .fitContent, .fillContent:
            return size.width
        case .px:
            return CGFloat(Double(width.value ?? "0") ?? 0)
        default:
            return nil
        }
    }
    
    private func canvasHeight(in size: CGSize) -> CGFloat? {
        guard let height = element.elementDetail?.layout?.height else {
            return nil
        }
        
        switch height.unit {
        case .percent:
            if let valueStr = height.value, let percentage = Double(valueStr) {
                return size.height * CGFloat(percentage) / 100.0
            }
            return nil
        case .auto, .fitContent, .fillContent:
            return size.height
        case .px:
            return CGFloat(Double(height.value ?? "0") ?? 0)
        default:
            return nil
        }
    }
}
