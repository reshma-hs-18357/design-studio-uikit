//
//  VerticalStackView.swift
//  DesignStudioUIKit
//
//  Created by Reshma S on 20/11/25.
//

import UIKit

class VerticalView: UIView {
    let element: ElementViewModel
    let elementsMap: [String: ElementViewModel]
    
    private let verticalBGView = UIImageView()
    private let verticalStackView = UIStackView()
    
    init(element: ElementViewModel, elementsMap: [String : ElementViewModel]) {
        self.element = element
        self.elementsMap = elementsMap
        super.init(frame: .zero)
        setupView()
        clipsToBounds = true
    }
    
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        verticalBGView.translatesAutoresizingMaskIntoConstraints = false
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(verticalBGView)
        verticalBGView.addSubview(verticalStackView)
    
        verticalStackView.axis = .vertical
        verticalStackView.spacing = gap
        verticalStackView.alignment = subElementsAlignment
        verticalStackView.distribution = .fill
        
        ViewDecorator.applyBackgroundColor(view: self, element: element)
        ViewDecorator.applyBackground(imageView: verticalBGView, element: element)
        ViewDecorator.applyCornerRadius(view: self, element: element)
        ViewDecorator.applyShadow(view: self, element: element)
        ViewDecorator.applyBorder(view: self, element: element)
        ViewDecorator.applyOpacity(view: self, element: element)
        
        ConstraintSetter.fillParent(parent: self, child: verticalStackView, element: element)
        setupSubElements()
    }
    
    private func setupSubElements() {
        guard let subElements = element.subElements else { return }
       
        for subElementId in subElements {
            if let subElement = elementsMap[subElementId] {
                ElementRendererView.renderElement(parent: verticalStackView, element: subElement, elementsMap: elementsMap)
            }
        }
    }
    

    
    private var gap: CGFloat {
       return Double(element.elementDetail?.style?.flex?.gap ?? "0") ?? 0
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
    
    private var subElementsAlignment: UIStackView.Alignment {
        guard let alignment = element.elementDetail?.style?.flex?.align else {
            
            return .center
        }
        print("vstack alignment")
        print(element.elementId)
        print(alignment)
 
        switch alignment {
            case .topLeft : return .leading
            case .topRight : return .trailing
                        
            case .bottomLeft: return .leading
            case .bottomRight: return .trailing
                        
            case .left: return .leading
            case .right: return .trailing
            case .top : return .leading
            case .bottom: return .trailing
                
            case .center: return .center
            
            case .equalSplit: return .center
            case .edgeToEdge: return .fill
            
            case .none: return .center
        }
    }
}
