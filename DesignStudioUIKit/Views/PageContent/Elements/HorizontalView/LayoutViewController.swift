//import UIKit
//
//class MixedLayoutViewController: UIViewController {
//    
//    private var collectionView: UICollectionView!
//    private var shouldWrapToNextRow: Bool = true
//    
//    private lazy var items: [MenuItem] = {
//            var temp = [MenuItem]()
//            let baseText = "Marinated grilled shrimp with fresh cilantro, lime juice, and chilli flakes. "
//            
//            for i in 1...10 {
//                let config: LayoutConfig
//                let typeTitle: String
//                let subtitleText: String
//                
//                switch i % 4 {
//                case 0:
//                    config = LayoutConfig(mode: .autoWidthAutoHeight)
//                    typeTitle = "AutoWidth AutoHeight #\(i)"
//                    subtitleText = String(repeating: baseText, count: 3)
//                    
//                case 1:
//                    config = LayoutConfig(mode: .fixedWidthAutoHeight, fixedWidth: 160)
//                    typeTitle = "FixedWidth AutoHeight #\(i)"
//                    subtitleText = String(repeating: baseText, count: 2)
//                    
//                case 2:
//                    config = LayoutConfig(mode: .fixedHeightAutoWidth, fixedHeight: 60)
//                    typeTitle = "FixedHeight AutoWidth #\(i)"
//                    subtitleText = String(repeating: baseText, count: 5)
//                    
//                default:
//                    config = LayoutConfig(mode: .fixedFixed, fixedWidth: 140, fixedHeight: 120)
//                    typeTitle = "Fixed Fixed Scroll Box #\(i)"
//                    subtitleText = String(repeating: baseText, count: 10)
//                }
//                
//                temp.append(MenuItem(title: typeTitle, subtitle: subtitleText, config: config))
//            }
//        
//        temp.append(MenuItem(
//                title: "Mode 1: Auto/Auto",
//                subtitle: "", // Ignored by ImageCardCell
//                type: .image,
//                config: LayoutConfig(mode: .autoWidthAutoHeight)
//            ))
//            
//            temp.append(MenuItem(
//                title: "Mode 2: Fixed W / Auto H\n(Feed Style with Wrapping Text)",
//                subtitle: "",
//                type: .image,
//                config: LayoutConfig(mode: .fixedWidthAutoHeight, fixedWidth: 180)
//            ))
//            
//            temp.append(MenuItem(
//                title: "Mode 3: Fixed H / Auto W",
//                subtitle: "",
//                type: .image,
//                config: LayoutConfig(mode: .fixedHeightAutoWidth, fixedHeight: 80)
//            ))
//            
//            
//            temp.append(MenuItem(
//                title: "Mode 4: Fixed/Fixed\n(Scrollable Box)\nThis text makes the content taller than the box.",
//                subtitle: "",
//                type: .image,
//                config: LayoutConfig(mode: .fixedFixed, fixedWidth: 150, fixedHeight: 150)
//            ))
//        
//            return temp
//        }()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .systemGray6
//        title = "Mixed Cells"
//        setupUI()
//        
//        // Initial Layout
//        updateLayout(animated: false)
//    }
//    
//    private func setupUI() {
//        // 1. Controls
//        let stack = UIStackView()
//        stack.axis = .horizontal
//        stack.spacing = 10
//        stack.translatesAutoresizingMaskIntoConstraints = false
//        
//        let label = UILabel()
//        label.text = "Wrap Items?"
//        let toggle = UISwitch()
//        toggle.isOn = shouldWrapToNextRow
//        toggle.addTarget(self, action: #selector(toggleWrap(_:)), for: .valueChanged)
//        
//        stack.addArrangedSubview(label)
//        stack.addArrangedSubview(toggle)
//        view.addSubview(stack)
//        
//        // 2. Collection View (Init with generic layout, we will set it immediately after)
//        collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
//        collectionView.backgroundColor = .clear
//        collectionView.dataSource = self
//        collectionView.delegate = self
//        collectionView.register(MixedLayoutCell.self, forCellWithReuseIdentifier: MixedLayoutCell.identifier)
//        collectionView.register(MultiLayoutImageCardCell.self, forCellWithReuseIdentifier: MultiLayoutImageCardCell.identifier)
//        collectionView.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(collectionView)
//        
//        NSLayoutConstraint.activate([
//            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
//            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            
//            collectionView.topAnchor.constraint(equalTo: stack.bottomAnchor, constant: 10),
//            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
//        ])
//    }
//    
//    @objc private func toggleWrap(_ sender: UISwitch) {
//        shouldWrapToNextRow = sender.isOn
//        updateLayout(animated: false) // Animated switching between engines can be glitchy, better false
//    }
//    
//    private func updateLayout(animated: Bool) {
//        
//        if shouldWrapToNextRow {
//
//            let flow = UICollectionViewFlowLayout()
//            flow.scrollDirection = .vertical
//            flow.minimumInteritemSpacing = 10
//            flow.minimumLineSpacing = 10
//            flow.sectionInset = UIEdgeInsets(top: 20, left: 16, bottom: 20, right: 16)
//            
//            flow.estimatedItemSize = CGSize(width: 100, height: 100)
//         
//            collectionView.setCollectionViewLayout(flow, animated: animated)
//            
//        } else {
//            
//            let layout = UICollectionViewCompositionalLayout { (_, _) -> NSCollectionLayoutSection? in
//                
//            
//                let itemSize = NSCollectionLayoutSize(
//                    widthDimension: .estimated(200),
//                    heightDimension: .fractionalHeight(1.0)
//                )
//                let item = NSCollectionLayoutItem(layoutSize: itemSize)
//                
//              
//                let groupSize = NSCollectionLayoutSize(
//                    widthDimension: .estimated(1000),
//                    heightDimension: .absolute(150) 
//                )
//                
//                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
//                group.interItemSpacing = .fixed(10)
//                
//                let section = NSCollectionLayoutSection(group: group)
//                section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 16, bottom: 20, trailing: 16)
//                section.orthogonalScrollingBehavior = .continuous // Enables the scroll
//                
//                return section
//            }
//            
//            collectionView.setCollectionViewLayout(layout, animated: animated)
//        }
//        
//        // Force a reload to ensure cells re-measure correctly for the new layout engine
//        collectionView.reloadData()
//    }
//}
//
//// MARK: - DataSource
//extension MixedLayoutViewController: UICollectionViewDelegateFlowLayout ViewDataSource, UICollectionViewDelegate {
//    func numberOfSections(in collectionView: UICollectionView) -> Int { 1 }
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return items.count
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//            
//        let item = items[indexPath.item]
//       
//        var cell =  UICollectionViewCell()
//        
//        if item.type == .text, let tempCell = collectionView.dequeueReusableCell(
//            withReuseIdentifier: MixedLayoutCell.identifier,
//            for: indexPath
//        ) as? MixedLayoutCell {
//            tempCell.configure(title: item.title, subtitle: item.subtitle, config: item.config)
//            cell = tempCell
//        }else if item.type == .image, let tempCell = collectionView.dequeueReusableCell(
//            withReuseIdentifier: MultiLayoutImageCardCell.identifier,
//            for: indexPath
//        ) as? MultiLayoutImageCardCell {
//            tempCell.configure(title: item.title, subtitle: item.subtitle, config: item.config)
//            cell = tempCell
//        }
//           
//    
//        return cell
//    }
//}
