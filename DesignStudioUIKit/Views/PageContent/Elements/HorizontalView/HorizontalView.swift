//
//  HorizontalView.swift
//  DesignStudioUIKit
//
//  Created by Reshma S on 25/11/25.
//

import UIKit

class HorizontalView: UIView {
    
    private var horizontalSubElements: [ElementViewModel] = []
    private var horizontalElement: ElementViewModel!
    private var allElementsMap: [String: ElementViewModel] = [:]
    
    init(element: ElementViewModel, elementsMap: [String : ElementViewModel]) {
        self.horizontalElement = element
        self.allElementsMap = elementsMap
        super.init(frame: .zero)
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
    
    
    private var collectionView: UICollectionView!
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
    
        // create collection view with a temporary layout
        let tempLayout = generateLayout()

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: tempLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.alwaysBounceHorizontal = true
        collectionView.showsHorizontalScrollIndicator = true
        collectionView.layer.borderColor = UIColor.red.cgColor
        collectionView.layer.borderWidth = 1
        collectionView.register(SubElementsCell.self, forCellWithReuseIdentifier: SubElementsCell.identifier)

        self.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: self.topAnchor),
            collectionView.bottomAnchor.constraint(lessThanOrEqualTo: self.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
        
        if let cvheight = collectionViewHeight() {
            collectionViewHeightConstraint = collectionView.heightAnchor.constraint(equalToConstant: cvheight)
            collectionViewHeightConstraint?.isActive = true
        }else{
            observeContentSize()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        measureMaxCellHeightAndInstallLayout()
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
        
        return UICollectionViewCompositionalLayout { [weak self] (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            
            guard let self = self else { return nil }
            
            // 1. Item
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .estimated(100),
                heightDimension: .estimated(100)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            // 2. Group
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .estimated(100),
                heightDimension: .estimated(100)
            )
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            
            // 3. Section
            let section = NSCollectionLayoutSection(group: group)
            
            // FIX: Use self.padding directly if it is NSDirectionalEdgeInsets
            // (No need to create new insets if types match)
            section.contentInsets = self.padding
            
            section.interGroupSpacing = self.gap
            section.orthogonalScrollingBehavior = .continuous
            
            return section
        }
    }

    private var contentSizeObservation: NSKeyValueObservation?
    private func observeContentSize() {
            contentSizeObservation = collectionView.observe(\.contentSize, options: .new) { [weak self] (cv, change) in
                guard let self = self else { return }
                
                // If explicit height is set in JSON, ignore this (logic not shown for brevity, but easy to add)
                // Otherwise, adapt to content:
                
                var targetHeight = cv.contentSize.height
                if targetHeight == 0{
                    targetHeight = 50
                }
                if self.collectionViewHeightConstraint == nil {
                    self.collectionViewHeightConstraint = self.collectionView.heightAnchor.constraint(equalToConstant: targetHeight)
                    self.collectionViewHeightConstraint?.isActive = true
                } else if self.collectionViewHeightConstraint?.constant != targetHeight {
                    // Determine if the change is significant to avoid layout loops
                    if abs((self.collectionViewHeightConstraint?.constant ?? 0) - targetHeight) > 1 {
                        self.collectionViewHeightConstraint?.constant = targetHeight
                        
                        // Notify parent to update if needed
                        self.layoutIfNeeded()
                    }
                }
            }
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
