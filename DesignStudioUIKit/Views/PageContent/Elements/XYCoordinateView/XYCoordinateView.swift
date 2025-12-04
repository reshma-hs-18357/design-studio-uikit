//
//  XYCoordinateVie3.swift
//  DesignStudioUIKit
//
//  Created by Reshma S on 14/11/25.
//

import UIKit

class XYCoordinateView: UIView, Scrollable {
    let element: ElementViewModel
    let elementsMap: [String: ElementViewModel]
    
    private let xyContainerView = UIImageView()
    private let xyview = UIView()
    
    init(element: ElementViewModel, elementsMap: [String: ElementViewModel]) {
        self.element = element
        self.elementsMap = elementsMap
        super.init(frame: .zero)
        setupView()
        clipsToBounds = true
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {


        ViewDecorator.applyCornerRadius(view: self, element: element)
        ViewDecorator.applyShadow(view: self, element: element)
        ViewDecorator.applyBorder(view: self, element: element)
        ViewDecorator.applyOpacity(view: self, element: element)
        makeContentScrollable(contentView: xyview, padding: self.padding)
        setupContentWrapper()
    }
    
    private func setupContentWrapper() {
            xyContainerView.translatesAutoresizingMaskIntoConstraints = false
            xyview.translatesAutoresizingMaskIntoConstraints = false
            
            addSubview(xyContainerView)
            //addSubview(xyview)
            
            ViewDecorator.applyBackground(imageView: xyContainerView, element: element)
            ConstraintSetter.fillParent(parent: self, child: xyContainerView)
           // ConstraintSetter.fillParent(parent: xyContainerView, child: xyview)
            
            setupSubElements()
        }
    
    private func setupSubElements() {
        guard let subElements = element.subElements else { return }
        
        for subElementId in subElements {
            if let subElement = elementsMap[subElementId] {
                ElementRendererView.renderElement(parent: xyview, element: subElement, elementsMap: elementsMap)
            }
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
