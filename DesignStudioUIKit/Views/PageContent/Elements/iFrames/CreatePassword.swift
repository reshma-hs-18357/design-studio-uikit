//
//  CreatePassword.swift
//  DesignStudioUIKit
//
//  Created by Reshma S on 21/11/25.
//

import UIKit

class CreatePassword: UIImageView {
    let element: ElementViewModel
    
    private let signupContainerView = UIView()
    private let textLabel = UILabel()
    
    init(element: ElementViewModel) {
        self.element = element
        super.init(frame: .zero)
        clipsToBounds = true
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView(){
        self.isUserInteractionEnabled = true
        self.backgroundColor = .white
        
        signupContainerView.translatesAutoresizingMaskIntoConstraints = false
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        self.addSubview(signupContainerView)
        signupContainerView.addSubview(textLabel)
        
        textLabel.text = "Create Password View"
        textLabel.textAlignment = .center

        
        // Apply styling
        ViewDecorator.applyBackground(imageView: self, element: element)
        ViewDecorator.applyCornerRadius(view: self, element: element)
        ViewDecorator.applyShadow(view: self, element: element)
        ViewDecorator.applyBorder(view: self, element: element)
        ViewDecorator.applyOpacity(view: self, element: element)
        
        ConstraintSetter.fillParent(parent: self, child: signupContainerView)
        ConstraintSetter.fillParent(parent: signupContainerView, child: textLabel)

    }
    
}
