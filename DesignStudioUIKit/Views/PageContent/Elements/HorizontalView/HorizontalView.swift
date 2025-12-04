//
//  HorizontalView.swift
//  DesignStudioUIKit
//
//  Created by Reshma S on 25/11/25.
//

import UIKit

class ContentHuggingCollectionView: UICollectionView {
    
    var overrideContentWidth: CGFloat?
    var overrideContentHeight: CGFloat?
    var elementViewModel: ElementViewModel

    init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout, elementViewModel: ElementViewModel) {
        self.elementViewModel = elementViewModel
        super.init(frame: frame, collectionViewLayout: layout)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var contentSize: CGSize {
        didSet {
            if oldValue != contentSize {
              invalidateIntrinsicContentSize()
            }
        }
    }

    override var intrinsicContentSize: CGSize {
        let width = overrideContentWidth ?? contentSize.width
        let height = overrideContentHeight ?? contentSize.height
        return CGSize(width: max(1, width), height: max(1, height))
    }
    
    func setCollectionViewFrameBasedOnLayout(){
        let strategy = elementViewModel.layoutStrategy()
        let parentWidth = self.bounds.width > 0 ? self.bounds.width : UIScreen.main.bounds.width
        let parentHeight = self.bounds.height > 0 ? self.bounds.height : UIScreen.main.bounds.height
        switch strategy{
            
        case .fixed(width: let width, height: let height):
            overrideContentWidth = width
            overrideContentHeight = height
        case .fixedWidthAutoHeight(width: let width):
            overrideContentWidth = width
        case .fixedHeightAutoWidth(height: let height):
            overrideContentHeight = height
        case .fixedWidthPercentageHeight(width: let width, heightRatio: let heightRatio):
            overrideContentWidth = width
            overrideContentHeight = parentHeight * heightRatio
        case .fixedHeightPercentageWidth(widthRatio: let widthRatio, height: let height):
            overrideContentWidth = parentWidth * widthRatio
            overrideContentHeight = height
        case .percentageWidthAutoHeight(widthRatio: let widthRatio):
            overrideContentWidth = parentWidth * widthRatio
        case .percentageHeightAutoWidth(heightRatio: let heightRatio):
            overrideContentHeight = parentHeight * heightRatio
        case .percentage(widthRatio: let widthRatio, heightRatio: let heightRatio):
            overrideContentWidth = parentWidth * widthRatio
            overrideContentHeight = parentHeight * heightRatio
        case .intrinsic:
            overrideContentWidth = nil
            overrideContentHeight = nil
        }
        invalidateIntrinsicContentSize()
    }
}

class HorizontalView: ContentHuggingCollectionView {
    
    private var horizontalSubElements: [ElementViewModel] = []
    private var horizontalElement: ElementViewModel!
    private var allElementsMap: [String: ElementViewModel] = [:]
    
    init(element: ElementViewModel, elementsMap: [String : ElementViewModel]) {
        self.horizontalElement = element
        self.allElementsMap = elementsMap
        super.init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout(), elementViewModel: element)
        populateDatasource(element: element, elementsMap: elementsMap)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func populateDatasource(element: ElementViewModel, elementsMap: [String: ElementViewModel]){
        guard let subElements = element.subElements else { return }
        
        for subElementId in subElements {
            if let subElement = elementsMap[subElementId] {
                horizontalSubElements.append(subElement)
            }
        }
    }
    
    private lazy var autoHeight = horizontalElement.elementDetail?.layout?.height?.unit == .auto
    private lazy var shouldWrapToNextRow: Bool = horizontalElement.elementDetail?.style?.flex?.wrap != .nowrap
    private lazy var constantHeight: CGFloat = {
        if let heightValue = horizontalElement.elementDetail?.layout?.height?.value {
            return CGFloat(Double(heightValue) ?? 150.0)
        }
        return 150.0
    }()
    
    
    private let layout = UICollectionViewFlowLayout()
    private var maxMeasuredItemHeight: CGFloat = 44
    private var collectionViewHeightConstraint : NSLayoutConstraint?
   
    private func  collectionViewHeight() -> CGFloat? {
        return autoHeight ? nil : constantHeight
    }
    
    private let desiredCellWidth: CGFloat = 100
    private lazy var sectionInset = padding
    private lazy var interItemSpacing: CGFloat = gap
    private lazy var lineSpacing: CGFloat = gap
    
    private var gap: CGFloat {
       return Double(horizontalElement.elementDetail?.style?.flex?.gap ?? "0") ?? 0
    }
    
    private var padding: NSDirectionalEdgeInsets {
        guard let padding = horizontalElement.elementDetail?.style?.padding else {
            return NSDirectionalEdgeInsets.zero
        }
        if padding.isEven == true, let value = padding.value {
            let value = Double(value) ?? 0
            return NSDirectionalEdgeInsets(top: value, leading: value, bottom: value, trailing: value)
        }
        else{
            let top = Double(padding.top?.value ?? "0") ?? 0
            let left = Double(padding.left?.value ?? "0") ?? 0
            let right = Double(padding.right?.value ?? "0") ?? 0
            let bottom = Double(padding.bottom?.value ?? "0") ?? 0
            return NSDirectionalEdgeInsets(top: top, leading: left, bottom: bottom, trailing: right)
        }
    }

    private func setupView() {
        self.backgroundColor = UIColor.systemGray6
    
        self.collectionViewLayout = generateLayout()
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .clear
        self.dataSource = self
        self.delegate = self
        self.alwaysBounceHorizontal = true
        self.showsHorizontalScrollIndicator = true
        self.layer.borderColor = UIColor.red.cgColor
        self.layer.borderWidth = 1
        self.register(SubElementsCell.self, forCellWithReuseIdentifier: SubElementsCell.identifier)
        self.setCollectionViewFrameBasedOnLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    private func generateLayout() -> UICollectionViewLayout {
        
        if shouldWrapToNextRow {
            let flow = UICollectionViewFlowLayout()
            flow.scrollDirection = .vertical
            flow.minimumInteritemSpacing = interItemSpacing
            flow.minimumLineSpacing = lineSpacing
            flow.sectionInset = UIEdgeInsets(
                top: sectionInset.top,
                left: sectionInset.leading,
                bottom: sectionInset.bottom,
                right: sectionInset.trailing
            )
            
            // Fixed cell width + automatic height
            flow.estimatedItemSize = CGSize(width: desiredCellWidth, height: maxMeasuredItemHeight)
            flow.itemSize = UICollectionViewFlowLayout.automaticSize
            //collectionView.collectionViewLayout.invalidateLayout()
            
            return flow
        }
        
        let layoutConfig = UICollectionViewCompositionalLayoutConfiguration()
        layoutConfig.scrollDirection = .horizontal
        
        let layout = UICollectionViewCompositionalLayout(sectionProvider: { [weak self] (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
                    guard let self = self else { return nil }
                    
                    // 1. Item
                    let itemSize = NSCollectionLayoutSize(
                        widthDimension: .estimated(10),
                        heightDimension: .estimated(10)
                    )
                    let item = NSCollectionLayoutItem(layoutSize: itemSize)
                    
                    let groupSize = NSCollectionLayoutSize(
                        widthDimension: .estimated(10),
                        heightDimension: .estimated(10)
                    )
                    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                    
                    // 3. Section
                    let section = NSCollectionLayoutSection(group: group)
                    section.contentInsets = self.padding
                    section.interGroupSpacing = self.gap
                
                    return section
                    
                }, configuration: layoutConfig)
                
                return layout
    }
    
    func parentSize() -> CGSize{
        let width = self.bounds.width > 0 ? self.bounds.width : UIScreen.main.bounds.width
        let height = self.bounds.width > 0 ? self.bounds.width : UIScreen.main.bounds.width
        
        return CGSize(width: width, height: height)
    }
}

// MARK: - DataSource
extension HorizontalView: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int { 1 }

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return horizontalSubElements.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: SubElementsCell.identifier,
            for: indexPath
        ) as? SubElementsCell else {
            return UICollectionViewCell()
        }
        cell.hzViewDelegate = self
        let element = horizontalSubElements[indexPath.item]
        cell.configure(element: element, elementsMap: allElementsMap)
        
        return cell
    }

}

// MARK: - UICollectionViewDelegate
extension HorizontalView: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {

        collectionView.deselectItem(at: indexPath, animated: true)
        print("Selected item \(indexPath.item + 1)")
    }
}
