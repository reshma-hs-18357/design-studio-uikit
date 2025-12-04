import UIKit

enum LayoutStrategy {
    case fixed(width: CGFloat, height: CGFloat)
    case fixedWidthAutoHeight(width: CGFloat)
    case fixedHeightAutoWidth(height: CGFloat)
    case fixedWidthPercentageHeight(width: CGFloat, heightRatio: CGFloat)
    case fixedHeightPercentageWidth(widthRatio: CGFloat, height: CGFloat)
    case percentageWidthAutoHeight(widthRatio: CGFloat)
    case percentageHeightAutoWidth(heightRatio: CGFloat)
    case percentage(widthRatio: CGFloat, heightRatio: CGFloat)
    case intrinsic
}

class SubElementsCell: UICollectionViewCell {
    static let identifier = "SubElementsCell"
    
   
    private var widthConstraint: NSLayoutConstraint?
    private var heightConstraint: NSLayoutConstraint?
    
    // Keep track of layout mode to inform the sizing calculation
    private var isFixedWidth = false
    private var isFixedHeight = false
    
    weak var hzViewDelegate: HorizontalView?
    
    private var elementViewModel: ElementViewModel?
    
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
        self.elementViewModel = element
        ElementRendererView.renderElement(parent: contentView, element: element, elementsMap: elementsMap, parentElementType: .horizontalFlex)
//        setNeedsLayout()
//        layoutIfNeeded()
    }

//    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
//        
//        setNeedsLayout()
//        layoutIfNeeded()
//        
//        let attributes = super.preferredLayoutAttributesFitting(layoutAttributes)
//        
//        // Determine Fitting Priorities based on Layout Mode
//        
//        let targetSize: CGSize
//        let horizontalPriority: UILayoutPriority
//        let verticalPriority: UILayoutPriority
//        
//        // WIDTH STRATEGY
//        if isFixedWidth {
//            // If fixed, we try to stay close to the size defined in our constraint (or the layout's suggestion)
//            targetSize = CGSize(width: layoutAttributes.frame.width, height: 0)
//            horizontalPriority = .required // Force width
//        } else {
//            // If auto, we let the content decide the width
//            targetSize = CGSize(width: UIView.layoutFittingCompressedSize.width,
//                                       height: UIView.layoutFittingCompressedSize.height)
//            horizontalPriority = .fittingSizeLevel // Relax width
//        }
//        
//        // HEIGHT STRATEGY (Usually .fittingSizeLevel for auto height cells)
//        verticalPriority = .fittingSizeLevel
//        
//        // Calculate
//        let size = contentView.systemLayoutSizeFitting(
//            targetSize,
//            withHorizontalFittingPriority: horizontalPriority,
//            verticalFittingPriority: verticalPriority
//        )
//        
//        // Update Frame
//        var newFrame = attributes.frame
//        
//        // If auto-width, use calculated size. If fixed, ensure we respect the constraint/layout.
//        newFrame.size.width = isFixedWidth ? layoutAttributes.frame.width : ceil(size.width)
//        newFrame.size.height = ceil(size.height)
//        
//        attributes.frame = newFrame
//        return attributes
//    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        var strategy = elementViewModel?.layoutStrategy() ?? .intrinsic
        
        let attributes = super.preferredLayoutAttributesFitting(layoutAttributes)
        let parentSize = hzViewDelegate?.parentSize() ?? CGSizeZero
        let containerWidth = parentSize.width
        let containerHeight = parentSize.height
        
        var targetSize = CGSize.zero
        
        switch strategy {
            
        case .fixed(let w, let h):
            targetSize = CGSize(width: w, height: h)
            
        case .percentage(let wRatio, let hRatio):
            // CASE B: Percentage Width (e.g., 50% of screen)
            let calculatedWidth = containerWidth * wRatio
            let calculatedHeight = containerHeight * hRatio
            targetSize = CGSize(width: calculatedWidth, height: calculatedHeight)
            
        case .intrinsic:
            let targetSizeProbe = CGSize(width: UIView.layoutFittingCompressedSize.width, height: UIView.layoutFittingCompressedSize.height)
            let autoSize = contentView.systemLayoutSizeFitting(
                targetSizeProbe,
                withHorizontalFittingPriority: .fittingSizeLevel,
                verticalFittingPriority: .fittingSizeLevel
            )
            targetSize = autoSize
        case .fixedWidthAutoHeight(width: let width):
            let sizeProbe = CGSize(width: width, height: UIView.layoutFittingCompressedSize.height)
            
            let autoSize = contentView.systemLayoutSizeFitting(
                sizeProbe,
                withHorizontalFittingPriority: .required, // Width is STRICT
                verticalFittingPriority: .fittingSizeLevel // Height is FLEXIBLE
            )
            targetSize = CGSize(width: width, height: autoSize.height)
        case .fixedHeightAutoWidth(height: let height):
            let sizeProbe = CGSize(width: UIView.layoutFittingCompressedSize.width, height: height)
            
            let autoSize = contentView.systemLayoutSizeFitting(
                sizeProbe,
                withHorizontalFittingPriority: .fittingSizeLevel,
                verticalFittingPriority: .required
            )
            targetSize = CGSize(width: autoSize.width, height: height)
        case .fixedWidthPercentageHeight(width: let width, heightRatio: let heightRatio):
            let calculatedHeight = containerHeight * heightRatio
            targetSize = CGSize(width: width, height: calculatedHeight)
        case .fixedHeightPercentageWidth(widthRatio: let widthRatio, height: let height):
            let calculatedWidth = containerWidth * widthRatio
            targetSize = CGSize(width: calculatedWidth, height: height)
        case .percentageWidthAutoHeight(widthRatio: let widthRatio):
            let calculatedWidth = parentSize.width * widthRatio
            let sizeProbe = CGSize(width: calculatedWidth, height: UIView.layoutFittingCompressedSize.height)
            
            let autoSize = contentView.systemLayoutSizeFitting(
                sizeProbe,
                withHorizontalFittingPriority: .required,
                verticalFittingPriority: .fittingSizeLevel
            )
            targetSize = CGSize(width: calculatedWidth, height: autoSize.height)
        case .percentageHeightAutoWidth(heightRatio: let heightRatio):
            let calculatedHeight = containerHeight * heightRatio
            let sizeProbe = CGSize(width: UIView.layoutFittingCompressedSize.width, height: calculatedHeight)
            
            let autoSize = contentView.systemLayoutSizeFitting(
                sizeProbe,
                withHorizontalFittingPriority: .fittingSizeLevel, // Width is STRICT
                verticalFittingPriority: .required // Height is FLEXIBLE
            )
            targetSize = CGSize(width: autoSize.width, height: calculatedHeight)
        }
        attributes.frame = CGRect(origin: attributes.frame.origin, size: targetSize)
        return attributes
    }
}
