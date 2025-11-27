////
////  Untitled.swift
////  DesignStudioUIKit
////
////  Created by Reshma S on 27/11/25.
////
// import UIKit
//
//class IconElement: UIImageView {
//    private var element : ElementViewModel!
//    
//    private let loadingView = UIView()
//    private let loadingIndicator = UIActivityIndicatorView(style: .medium)
//    private let loadingLabel = UILabel()
//    
//    private let failureView = UIView()
//    private let defaultView = UIView()
//    
//    
//    init(element: ElementViewModel) {
//        super.init(frame: .zero)
//        populateDatasource(element: element)
//        setupView()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    private func populateDatasource(element: ElementViewModel){
//        self.element = element
//    }
//    private let iconContainerView =  UIView()
//    private let iconView = UIImageView()
//    
//    private func setupView() {
//        
//        iconContainerView.translatesAutoresizingMaskIntoConstraints = false
//        
//        self.addSubview(iconContainerView)
//        ViewDecorator.applyBackground(imageView: self, element: element)
//        ViewDecorator.applyCornerRadius(view: self, element: element)
//        ViewDecorator.applyShadow(view: self, element: element)
//        ViewDecorator.applyBorder(view: self, element: element)
//        ViewDecorator.applyOpacity(view: self, element: element)
//        
//        ConstraintSetter.fillParent(parent: self, child: iconContainerView)
//        ConstraintSetter.fillParent(parent: iconContainerView, child: iconView, element: element)
//        
//        loadIcon()
//    }
//    
//    private func setupFailureView() {
//        failureView.translatesAutoresizingMaskIntoConstraints = false
//        failureView.isHidden = true
//        failureView.backgroundColor = UIColor.systemGray5
//        failureView.layer.cornerRadius = 8
//        addSubview(failureView)
//        
//        let iconImageView = UIImageView(image: UIImage(systemName: "exclamationmark.triangle"))
//        iconImageView.tintColor = .red
//        iconImageView.contentMode = .scaleAspectFit
//        iconImageView.translatesAutoresizingMaskIntoConstraints = false
//        failureView.addSubview(iconImageView)
//        
//        let failureLabel = UILabel()
//        failureLabel.text = "Failed to load"
//        failureLabel.font = .systemFont(ofSize: 12)
//        failureLabel.textColor = .gray
//        failureLabel.translatesAutoresizingMaskIntoConstraints = false
//        failureView.addSubview(failureLabel)
//        
//        NSLayoutConstraint.activate([
//            iconImageView.widthAnchor.constraint(equalToConstant: 40),
//            iconImageView.heightAnchor.constraint(equalToConstant: 40),
//            iconImageView.centerXAnchor.constraint(equalTo: failureView.centerXAnchor),
//            iconImageView.centerYAnchor.constraint(equalTo: failureView.centerYAnchor, constant: -15),
//            
//            failureLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 8),
//            failureLabel.centerXAnchor.constraint(equalTo: failureView.centerXAnchor)
//        ])
//    }
//    
//    private func setupDefaultView() {
//        defaultView.translatesAutoresizingMaskIntoConstraints = false
//        defaultView.isHidden = true
//        defaultView.backgroundColor = UIColor.systemGray5
//        defaultView.layer.cornerRadius = 8
//        addSubview(defaultView)
//        
//        let iconImageView = UIImageView(image: UIImage(systemName: "photo"))
//        iconImageView.tintColor = .gray
//        iconImageView.contentMode = .scaleAspectFit
//        iconImageView.translatesAutoresizingMaskIntoConstraints = false
//        defaultView.addSubview(iconImageView)
//        
//        NSLayoutConstraint.activate([
//            iconImageView.widthAnchor.constraint(equalToConstant: 40),
//            iconImageView.heightAnchor.constraint(equalToConstant: 40),
//            iconImageView.centerXAnchor.constraint(equalTo: defaultView.centerXAnchor),
//            iconImageView.centerYAnchor.constraint(equalTo: defaultView.centerYAnchor)
//        ])
//    }
//    
//    private func setupConstraints() {
//        
//        for view in [loadingView, failureView, defaultView] {
//            ConstraintSetter.fillParent(parent: self, child: view)
//        }
//    }
//
//    
//    private func loadIcon() {
//        guard let src = element.elementDetail?.data?.content else {
//            showDefault()
//            return
//        }
//        
//        let domainURL = "https://dockerdev19.csez.zohocorpin.com/creator/\(staticImageID)/\(src)"
////        let domainURL = src
//        
//        guard let encodedURLString = domainURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
//              let url = URL(string: encodedURLString) else {
//            showDefault()
//            return
//        }
//        
//        showLoading()
//        imageLoadTask?.resume()
//    }
//    
//    
//    private func showLoading() {
//        imageView.isHidden = true
//        loadingView.isHidden = false
//        failureView.isHidden = true
//        defaultView.isHidden = true
//        loadingIndicator.startAnimating()
//    }
//    
//    private func showImage() {
//        imageView.isHidden = false
//        loadingView.isHidden = true
//        failureView.isHidden = true
//        defaultView.isHidden = true
//        loadingIndicator.stopAnimating()
//    }
//    
//    private func showFailure() {
//        imageView.isHidden = true
//        loadingView.isHidden = true
//        failureView.isHidden = false
//        defaultView.isHidden = true
//        loadingIndicator.stopAnimating()
//    }
//    
//    private func showDefault() {
//        imageView.isHidden = true
//        loadingView.isHidden = true
//        failureView.isHidden = true
//        defaultView.isHidden = false
//        loadingIndicator.stopAnimating()
//    }
//    
//}
//
//
