//
//  Untitled.swift
//  DesignStudioUIKit
//
//  Created by Reshma S on 27/11/25.
//
import UIKit

class IconElement: UIImageView {
    private var element: ElementViewModel!
    
    init(element: ElementViewModel) {
        super.init(frame: .zero)
        populateDatasource(element: element)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let iconContainerView = UIImageView()
    private let iconView = UIImageView()
        
    private func populateDatasource(element: ElementViewModel) {
        self.element = element
    }
    
    private func setupView() {
        iconContainerView.translatesAutoresizingMaskIntoConstraints = false
        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconContainerView.backgroundColor = .yellow.withAlphaComponent(0.5)
        iconView.backgroundColor = .yellow
        self.addSubview(iconContainerView)
        iconContainerView.addSubview(iconView)
        
        // Apply decorations
        ViewDecorator.applyBackground(imageView: self, element: element)
        ViewDecorator.applyCornerRadius(view: self, element: element)
        ViewDecorator.applyShadow(view: self, element: element)
        ViewDecorator.applyBorder(view: self, element: element)
        ViewDecorator.applyOpacity(view: self, element: element)
        
        // Apply size constraints
        ConstraintSetter.fillParent(parent: self, child: iconView, element: element)
        ConstraintSetter.fillParent(parent: iconContainerView, child: iconView, element: element)
        
    }

}
