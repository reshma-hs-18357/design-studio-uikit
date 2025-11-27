//
//  SubElementCell.swift
//  DesignStudioUIKit
//
//  Created by Reshma S on 25/11/25.
//

import UIKit

class SubElementsCell: UICollectionViewCell {
    static let identifier = "SubElementsCell"
    
    private var renderedView: UIView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCell() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        ConstraintSetter.fillParent(parent: self, child: contentView)
        contentView.backgroundColor = .systemPink.withAlphaComponent(0.1)
    }
    
    func configure(element: ElementViewModel, elementsMap: [String: ElementViewModel]) {
        // Remove previous rendered view if exists
        renderedView?.removeFromSuperview()
        
        // Render the element into the contentView
        ElementRendererView.renderElement(parent: contentView, element: element, elementsMap: elementsMap)
        
        // Keep reference to the rendered view (it's the last subview added)
        renderedView = contentView.subviews.last
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        renderedView?.removeFromSuperview()
        renderedView = nil
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes)
           -> UICollectionViewLayoutAttributes {

           setNeedsLayout()
           layoutIfNeeded()

           let attributes = super.preferredLayoutAttributesFitting(layoutAttributes)

           // Use the incoming width (set by collection view / flow layout)
           let targetWidth = attributes.frame.width

           let targetSize = CGSize(width: targetWidth, height: UIView.layoutFittingCompressedSize.height)

           let fittedSize = contentView.systemLayoutSizeFitting(
               targetSize,
               withHorizontalFittingPriority: .required,
               verticalFittingPriority: .fittingSizeLevel
           )

           var newFrame = attributes.frame
           newFrame.size.width = ceil(targetWidth)
           newFrame.size.height = ceil(fittedSize.height)

           attributes.frame = newFrame
           return attributes
       }
}

