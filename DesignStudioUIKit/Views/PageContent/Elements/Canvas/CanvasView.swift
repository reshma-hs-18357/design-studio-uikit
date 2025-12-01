//
//  CanvasView.swift
//  DesignStudioUIKit
//
//  Created by Reshma S on 13/11/25.
//


import UIKit

class CanvasView: UIView, Scrollable {
    
    private let contentWrapper = UIView()
    let element: ElementViewModel
    let elementsMap: [String: ElementViewModel]
    
    init(element: ElementViewModel, elementsMap: [String: ElementViewModel]) {
        self.element = element
        self.elementsMap = elementsMap
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        setupSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubViews() {
        guard let subElements = element.subElements else { return }
//        makeContentScrollable(contentView: contentWrapper)
        for subElementId in subElements {
            if let subElement = elementsMap[subElementId] {
                ElementRendererView.renderElement(parent: self, element: subElement, elementsMap: elementsMap)
            }
        }
    }
}
