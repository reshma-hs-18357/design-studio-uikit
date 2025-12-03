import UIKit

class SubElementsCell: UICollectionViewCell {
    static let identifier = "SubElementsCell"
    
   
    private var widthConstraint: NSLayoutConstraint?
    private var heightConstraint: NSLayoutConstraint?
    
    // Keep track of layout mode to inform the sizing calculation
    private var isFixedWidth = false
    private var isFixedHeight = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCell() {
        //contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = .systemPink.withAlphaComponent(0.1)
        //ConstraintSetter.fillParent(parent: self, child: contentView)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
       
        widthConstraint?.isActive = false
        heightConstraint?.isActive = false
        
        // Reset flags
        isFixedWidth = false
        isFixedHeight = false
    }
    
    func configure(element: ElementViewModel, elementsMap: [String: ElementViewModel]) {
        ElementRendererView.renderElement(parent: contentView, element: element, elementsMap: elementsMap)
        setNeedsLayout()
        layoutIfNeeded()
    }

    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        
        setNeedsLayout()
        layoutIfNeeded()
        
        let attributes = super.preferredLayoutAttributesFitting(layoutAttributes)
        
        // Determine Fitting Priorities based on Layout Mode
        
        let targetSize: CGSize
        let horizontalPriority: UILayoutPriority
        let verticalPriority: UILayoutPriority
        
        // WIDTH STRATEGY
        if isFixedWidth {
            // If fixed, we try to stay close to the size defined in our constraint (or the layout's suggestion)
            targetSize = CGSize(width: layoutAttributes.frame.width, height: 0)
            horizontalPriority = .required // Force width
        } else {
            // If auto, we let the content decide the width
            targetSize = CGSize(width: UIView.layoutFittingCompressedSize.width,
                                       height: UIView.layoutFittingCompressedSize.height)
            horizontalPriority = .fittingSizeLevel // Relax width
        }
        
        // HEIGHT STRATEGY (Usually .fittingSizeLevel for auto height cells)
        verticalPriority = .fittingSizeLevel
        
        // Calculate
        let size = contentView.systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: horizontalPriority,
            verticalFittingPriority: verticalPriority
        )
        
        // Update Frame
        var newFrame = attributes.frame
        
        // If auto-width, use calculated size. If fixed, ensure we respect the constraint/layout.
        newFrame.size.width = isFixedWidth ? layoutAttributes.frame.width : ceil(size.width)
        newFrame.size.height = ceil(size.height)
        
        attributes.frame = newFrame
        return attributes
    }
}
