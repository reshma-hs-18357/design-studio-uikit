//
//  VerticalStackView.swift
//  DesignStudioUIKit
//
//  Created by Reshma S on 20/11/25.
//

import UIKit

class VerticalView: UIStackView {
    let element: ElementViewModel
    let elementsMap: [String: ElementViewModel]
    
    private let verticalContainerView = UIImageView()
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
        self.layoutMargins = padding
        self.isLayoutMarginsRelativeArrangement = true

        verticalContainerView.translatesAutoresizingMaskIntoConstraints = false
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(verticalContainerView)
        verticalContainerView.addSubview(verticalStackView)
        
        verticalStackView.axis = .vertical
        verticalStackView.spacing = gap
        verticalStackView.alignment = subElementsAlignment
        verticalStackView.distribution = .fillProportionally
        verticalStackView.isUserInteractionEnabled = true
        verticalStackView.isLayoutMarginsRelativeArrangement = true
        verticalStackView.layoutMargins = padding
        
        
        // Apply styling
        ViewDecorator.applyBackground(imageView: verticalContainerView, element: element)
        ViewDecorator.applyCornerRadius(view: self, element: element)
        ViewDecorator.applyShadow(view: self, element: element)
        ViewDecorator.applyBorder(view: self, element: element)
        ViewDecorator.applyOpacity(view: self, element: element)
        
        
        ConstraintSetter.fillParent(parent: self, child: verticalContainerView)
        ConstraintSetter.fillParent(parent: verticalContainerView, child: verticalStackView)
        
        setupSubElements()
    }
    
    private func setupSubElements() {
        guard let subElements = element.subElements else { return }
       
        for subElementId in subElements {
            if let subElement = elementsMap[subElementId] {
                
                let childWrapper = UIView()
                childWrapper.translatesAutoresizingMaskIntoConstraints = false
                verticalStackView.addArrangedSubview(childWrapper)
        
                ElementRendererView.renderElement(parent: childWrapper, element: subElement, elementsMap: elementsMap)
               
                ConstraintSetter.applyStackChildConstraints(stackView: verticalStackView, parent: childWrapper, element: element)
    
                ConstraintSetter.fillParent(parent: childWrapper, child: childWrapper.subviews.first!)

            }
        }
    }
    
//    override func sizeThatFits(_ size: CGSize) -> CGSize {
//        calculateIntrinsicSize(for: size.width)
//    }
//
//    override var intrinsicContentSize: CGSize {
//        calculateIntrinsicSize(for: bounds.width)
//    }
//    
//    private func calculateIntrinsicSize(for width: CGFloat) -> CGSize {
//        guard !arrangedSubviews.isEmpty else {
//            return CGSize(width: width, height: padding.top + padding.bottom)
//        }
//        
//        let availableWidth = width - padding.left - padding.right
//        let totalSpacing = spacing * CGFloat(arrangedSubviews.count - 1)
//        
//        let totalHeight = arrangedSubviews.reduce(0) { result, view in
//            let size = view.sizeThatFits(CGSize(width: availableWidth, height: .greatestFiniteMagnitude))
//            return result + size.height
//        }
//        
//        return CGSize(
//            width: width,
//            height: totalHeight + totalSpacing + padding.top + padding.bottom
//        )
//    }
    
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
