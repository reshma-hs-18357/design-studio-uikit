//
//  ElementRenderer.swift
//  DesignStudioUIKit
//
//  Created by Reshma S on 13/11/25.
//

import UIKit

struct ElementRendererView {

    public static func renderElement(parent : UIView ,element: ElementViewModel, elementsMap: [String: ElementViewModel] )  {
        
        switch element.elementType {
            
        case .canvas:
            let rendered =  CanvasView(element: element, elementsMap: elementsMap)
            parent.addSubview(rendered)
            rendered.translatesAutoresizingMaskIntoConstraints = false
            ConstraintSetter.fillParent(parent: parent, child: rendered)
            
            
        case .horizontalFlex:
            let rendered = HorizontalView(element: element, elementsMap: elementsMap)
           rendered.translatesAutoresizingMaskIntoConstraints = false
           if let parent = parent as? UIStackView {
               parent.addArrangedSubview(rendered)
               ConstraintSetter.applyStackChildConstraints(stackView: parent, child: rendered, element: element)
           }
           else{
               parent.addSubview(rendered)
               ConstraintSetter.applyConstraints(parent: parent, child: rendered, element: element)
           }
            
        case .xycoordinates:
            let rendered =  XYCoordinateView(element: element, elementsMap: elementsMap)
            rendered.translatesAutoresizingMaskIntoConstraints = false
            if let parent = parent as? UIStackView {
                parent.addArrangedSubview(rendered)
                ConstraintSetter.applyStackChildConstraints(stackView: parent, child: rendered, element: element)
            }
            else{
                parent.addSubview(rendered)
                ConstraintSetter.applyConstraints(parent: parent, child: rendered, element: element)

            }
            
        case .verticalFlex:
             let rendered = VerticalView(element: element, elementsMap: elementsMap)
            rendered.translatesAutoresizingMaskIntoConstraints = false
            if let parent = parent as? UIStackView {
                parent.addArrangedSubview(rendered)
                ConstraintSetter.applyStackChildConstraints(stackView: parent, child: rendered, element: element)
            }
            else{
                parent.addSubview(rendered)
                ConstraintSetter.applyConstraints(parent: parent, child: rendered, element: element)
            }

        case .heading:
            let rendered = TextView(element: element)
            rendered.translatesAutoresizingMaskIntoConstraints = false
            if let parent = parent as? UIStackView {
                parent.addArrangedSubview(rendered)
                ConstraintSetter.applyStackChildConstraints(stackView: parent, child: rendered, element: element)
            } else {
                parent.addSubview(rendered)
                ConstraintSetter.applyConstraints(parent:parent, child: rendered, element: element)
            }
        
        case .image:
            let rendered =  ImageView(element: element)
            rendered.translatesAutoresizingMaskIntoConstraints = false
            if let parent = parent as? UIStackView {
                parent.addArrangedSubview(rendered)
                ConstraintSetter.applyStackChildConstraints(stackView: parent, child: rendered, element: element)
            } else {
                parent.addSubview(rendered)
                ConstraintSetter.applyConstraints(parent: parent, child: rendered, element: element)
            }
            
        case .createPassword:
            let rendered =  CreatePassword(element: element)
            rendered.translatesAutoresizingMaskIntoConstraints = false
            if let parent = parent as? UIStackView {
                parent.addArrangedSubview(rendered)
                ConstraintSetter.applyStackChildConstraints(stackView: parent, child: rendered, element: element)
            } else {
                parent.addSubview(rendered)
                ConstraintSetter.applyConstraints(parent: parent, child: rendered, element: element)
            }
            
        case .forgotPassword:
            let rendered =  ResetPassword(element: element)
            rendered.translatesAutoresizingMaskIntoConstraints = false
            if let parent = parent as? UIStackView {
                parent.addArrangedSubview(rendered)
                ConstraintSetter.applyStackChildConstraints(stackView: parent, child: rendered, element: element)
            } else {
                parent.addSubview(rendered)
                ConstraintSetter.applyConstraints(parent: parent, child: rendered, element: element)
            }
            
        case .signin:
            let rendered =  SignIn(element: element)
            rendered.translatesAutoresizingMaskIntoConstraints = false
            if let parent = parent as? UIStackView {
                parent.addArrangedSubview(rendered)
                ConstraintSetter.applyStackChildConstraints(stackView: parent, child: rendered, element: element)
            } else {
                parent.addSubview(rendered)
                ConstraintSetter.applyConstraints(parent: parent, child: rendered, element: element)
            }
        case .signup:
            let rendered =  SignUp(element: element)
            rendered.translatesAutoresizingMaskIntoConstraints = false
            if let parent = parent as? UIStackView {
                parent.addArrangedSubview(rendered)
                ConstraintSetter.applyStackChildConstraints(stackView: parent, child: rendered, element: element)
            } else {
                parent.addSubview(rendered)
                ConstraintSetter.applyConstraints(parent: parent, child: rendered, element: element)
            }

        case .menu:
            return

        case .menuItem:
            return

        case .icon:
            let rendered = UIView()
            rendered.backgroundColor = UIColor(hex: "#008000")
            rendered.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                rendered.widthAnchor.constraint(equalToConstant: 24),
                rendered.heightAnchor.constraint(equalToConstant: 24)
            ])
            parent.addSubview(rendered)
            
        default:
            let v = UIView()
            v.backgroundColor = UIColor(hex: "#0000FF")
            v.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                v.widthAnchor.constraint(equalToConstant: 100),
                v.heightAnchor.constraint(equalToConstant: 100)
            ])
        }
    }
}

