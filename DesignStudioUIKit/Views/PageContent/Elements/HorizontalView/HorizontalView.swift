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
        let tempLayout = UICollectionViewCompositionalLayout { (_, _) -> NSCollectionLayoutSection? in
            let size = NSCollectionLayoutSize(widthDimension: .absolute(self.desiredCellWidth),
                                              heightDimension: .absolute(110))
            let item = NSCollectionLayoutItem(layoutSize: size)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuous
            section.interGroupSpacing = self.interItemSpacing
            section.contentInsets = self.sectionInset
            return section
        }

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
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        measureMaxCellHeightAndInstallLayout()
    }
   
    private func measureMaxCellHeightAndInstallLayout() {

        if shouldWrapToNextRow {
            // -------------------------------------------
            // MULTI-ROW MODE (vertical scroll, wrapping)
            // -------------------------------------------

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
            collectionView.collectionViewLayout.invalidateLayout()

            collectionView.setCollectionViewLayout(flow, animated: false)
            collectionView.isScrollEnabled = true               // vertical scroll
            collectionView.showsHorizontalScrollIndicator = false
            
           return
        }

        // -------------------------------------------
        // SINGLE-ROW MODE (horizontal scroll)
        // -------------------------------------------

        let measured = measureMaxHeightForAllItems()
        let padded = ceil(measured)
        guard padded != maxMeasuredItemHeight else { return }
        maxMeasuredItemHeight = padded

        let layout = UICollectionViewCompositionalLayout { [weak self] (_, _) -> NSCollectionLayoutSection? in
            guard let self = self else { return nil }

            let itemSize = NSCollectionLayoutSize(
                widthDimension: .absolute(self.desiredCellWidth),
                heightDimension: .fractionalHeight(1.0)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            let groupSize = NSCollectionLayoutSize(
                widthDimension: .absolute(self.desiredCellWidth),
                heightDimension: .absolute(self.maxMeasuredItemHeight)
            )
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuous
            section.interGroupSpacing = self.interItemSpacing
            section.contentInsets = self.sectionInset

            return section
        }

        collectionView.setCollectionViewLayout(layout, animated: false)
        collectionView.reloadData()

        // Resize collection view height (single-row mode only)
        if collectionViewHeight() == nil {
            collectionViewHeightConstraint?.isActive = false
            collectionViewHeightConstraint = collectionView.heightAnchor.constraint(
                equalToConstant: maxMeasuredItemHeight + sectionInset.top + sectionInset.bottom
            )
            collectionViewHeightConstraint?.isActive = true
        }
    }

    private func measureMaxHeightForAllItems() -> CGFloat {
            // prototype cell (offscreen)
            let prototype = SubElementsCell(frame: .zero)

            // We must ensure the prototype cell uses the same width as in the layout.
            // If the cell has internal horizontal insets (content margins), you must account for them
            // but here we assume the cell expects the full item width as its content width.

            var maxHeight: CGFloat = 0
            // Limit measurement if very large dataset to avoid cost — measure first N and a sample of rest.
            // For now we'll measure all; change `itemsToMeasure` if performance is a concern.
            let itemsToMeasure = horizontalSubElements.enumerated().map { $0 } // all
            for (_, item) in itemsToMeasure {
                prototype.prepareForReuse()
                prototype.configure(element: item, elementsMap: allElementsMap)

                // Set bounds to a width = desiredCellWidth and large height so internal layout can compute correctly
                prototype.bounds = CGRect(x: 0, y: 0, width: desiredCellWidth, height: 1000)
                prototype.layoutIfNeeded()

                // systemLayoutSizeFitting with required horizontal priority
                let targetSize = CGSize(width: desiredCellWidth, height: UIView.layoutFittingCompressedSize.height)
                let fitting = prototype.contentView.systemLayoutSizeFitting(
                    targetSize,
                    withHorizontalFittingPriority: .required,
                    verticalFittingPriority: .fittingSizeLevel
                )

                let h = ceil(fitting.height)
                maxHeight = max(maxHeight, h)
            }

            // Ensure at least a minimum
            return max(44, maxHeight)
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
