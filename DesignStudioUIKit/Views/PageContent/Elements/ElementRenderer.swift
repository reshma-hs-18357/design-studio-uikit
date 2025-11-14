//
//  ElementRenderer.swift
//  DesignStudioUIKit
//
//  Created by Reshma S on 13/11/25.
//

import UIKit

class ElementRendererView: UIView {
    
    let element: ElementViewModel
    let elementsMap: [String: ElementViewModel]
    
    init(element: ElementViewModel, elementsMap: [String: ElementViewModel]) {
        self.element = element
        self.elementsMap = elementsMap
        super.init(frame: .zero)
        
        let rendered = renderElement()
        addSubview(rendered)
        rendered.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            rendered.topAnchor.constraint(equalTo: topAnchor),
            rendered.leadingAnchor.constraint(equalTo: leadingAnchor),
            rendered.trailingAnchor.constraint(equalTo: trailingAnchor),
            rendered.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func renderElement() -> UIView {
        switch element.elementType {
        case .canvas:
            return CanvasView(element: element, elementsMap: elementsMap)
            
        case .horizontalFlex:
            return DefaultElement(element: element, elementsMap: elementsMap)
            
        case .xycoordinates:
            return XYCoordinateView(element: element, elementsMap: elementsMap)
            
        case .verticalFlex:
            return DefaultElement(element: element, elementsMap: elementsMap)
            
        case .heading:
            return DefaultElement(element: element, elementsMap: elementsMap)
            
        case .image:
            return ImageView(element: element)
            
        case .createPassword:
            return DefaultElement(element: element, elementsMap: elementsMap)
            
        case .forgotPassword:
            return DefaultElement(element: element, elementsMap: elementsMap)
            
        case .signin:
            return DefaultElement(element: element, elementsMap: elementsMap)
            
        case .signup:
            return DefaultElement(element: element, elementsMap: elementsMap)
            
        case .menu:
            return DefaultElement(element: element, elementsMap: elementsMap)
            
        case .menuItem:
            return DefaultElement(element: element, elementsMap: elementsMap)
            
        case .icon:
            let v = UIView()
            v.backgroundColor = UIColor(hex: "#008000")
            v.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                v.widthAnchor.constraint(equalToConstant: 24),
                v.heightAnchor.constraint(equalToConstant: 24)
            ])
            return v
            
        default:
            let v = UIView()
            v.backgroundColor = UIColor(hex: "#0000FF")
            v.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                v.widthAnchor.constraint(equalToConstant: 100),
                v.heightAnchor.constraint(equalToConstant: 100)
            ])
            return v
        }
        
    }
    
}


class DefaultElement: UIView {
    init(element: ElementViewModel, elementsMap: [String: ElementViewModel]) {
        super.init(frame: .zero)
        
        let label = UILabel()
        label.text = "Rendering root element: \(element.elementId)"
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

