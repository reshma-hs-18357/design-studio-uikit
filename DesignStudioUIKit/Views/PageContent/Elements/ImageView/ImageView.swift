//
//  ImageView.swift
//  DesignStudioUIKit
//
//  Created by Reshma S on 13/11/25.
//

import UIKit

class ImageView: UIImageView {
    let element: ElementViewModel

    private let loadingView = UIView()
    private let loadingIndicator = UIActivityIndicatorView(style: .medium)
    private let loadingLabel = UILabel()
    
    private let failureView = UIView()
    private let defaultView = UIView()
    
    private let imageView = UIImageView()
    private let imageContainerView = UIView()
    
    private var imageLoadTask: URLSessionDataTask?


    init(element: ElementViewModel) {
        self.element = element
        super.init(frame: .zero)
        setupView()
        loadImage()
        clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        imageLoadTask?.cancel()
    }
    
    private func setupView() {
        
        imageContainerView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = imageContentMode
        imageView.clipsToBounds = true
        
        self.addSubview(imageContainerView)
        imageContainerView.addSubview(imageView)
        ViewDecorator.applyBackground(imageView: self, element: element)
        ViewDecorator.applyCornerRadius(view: self, element: element)
        ViewDecorator.applyShadow(view: self, element: element)
        ViewDecorator.applyBorder(view: self, element: element)
        ViewDecorator.applyOpacity(view: self, element: element)
        
        ConstraintSetter.fillParent(parent: self, child: imageContainerView)
        ConstraintSetter.fillParent(parent: imageContainerView, child: imageView, element: element)
        
        setupLoadingView()
        
        setupFailureView()
        
        setupDefaultView()
             
        showLoading()
        
        setupConstraints()
    }
    
    private func setupLoadingView() {
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.isHidden = true
        addSubview(loadingView)
        
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingView.addSubview(loadingIndicator)
        
        loadingLabel.text = "Loading image..."
        loadingLabel.font = .systemFont(ofSize: 12)
        loadingLabel.textColor = .gray
        loadingLabel.translatesAutoresizingMaskIntoConstraints = false
        loadingView.addSubview(loadingLabel)
        
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: loadingView.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: loadingView.centerYAnchor, constant: -15),
            
            loadingLabel.topAnchor.constraint(equalTo: loadingIndicator.bottomAnchor, constant: 8),
            loadingLabel.centerXAnchor.constraint(equalTo: loadingView.centerXAnchor)
        ])
    }
    
    private func setupFailureView() {
        failureView.translatesAutoresizingMaskIntoConstraints = false
        failureView.isHidden = true
        failureView.backgroundColor = UIColor.systemGray5
        failureView.layer.cornerRadius = 8
        addSubview(failureView)
        
        let iconImageView = UIImageView(image: UIImage(systemName: "exclamationmark.triangle"))
        iconImageView.tintColor = .red
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        failureView.addSubview(iconImageView)
        
        let failureLabel = UILabel()
        failureLabel.text = "Failed to load"
        failureLabel.font = .systemFont(ofSize: 12)
        failureLabel.textColor = .gray
        failureLabel.translatesAutoresizingMaskIntoConstraints = false
        failureView.addSubview(failureLabel)
        
        NSLayoutConstraint.activate([
            iconImageView.widthAnchor.constraint(equalToConstant: 40),
            iconImageView.heightAnchor.constraint(equalToConstant: 40),
            iconImageView.centerXAnchor.constraint(equalTo: failureView.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: failureView.centerYAnchor, constant: -15),
            
            failureLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 8),
            failureLabel.centerXAnchor.constraint(equalTo: failureView.centerXAnchor)
        ])
    }
    
    private func setupDefaultView() {
        defaultView.translatesAutoresizingMaskIntoConstraints = false
        defaultView.isHidden = true
        defaultView.backgroundColor = UIColor.systemGray5
        defaultView.layer.cornerRadius = 8
        addSubview(defaultView)
        
        let iconImageView = UIImageView(image: UIImage(systemName: "photo"))
        iconImageView.tintColor = .gray
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        defaultView.addSubview(iconImageView)
        
        NSLayoutConstraint.activate([
            iconImageView.widthAnchor.constraint(equalToConstant: 40),
            iconImageView.heightAnchor.constraint(equalToConstant: 40),
            iconImageView.centerXAnchor.constraint(equalTo: defaultView.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: defaultView.centerYAnchor)
        ])
    }
    
    private func setupConstraints() {
        
        for view in [loadingView, failureView, defaultView] {
            ConstraintSetter.fillParent(parent: self, child: view)
        }
    }
    
    // MARK: - Image Loading
    
    private func loadImage() {
        guard let src = element.elementDetail?.data?.imageSrc else {
            showDefault()
            return
        }
        
        let domainURL = "https://dockerdev19.csez.zohocorpin.com/creator/\(staticImageID)/\(src)"
//        let domainURL = src
        
        guard let encodedURLString = domainURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: encodedURLString) else {
            showDefault()
            return
        }
        
        showLoading()
        
        imageLoadTask = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                if let error = error {
                    print("Image load error: \(error.localizedDescription)")
                    self.showFailure()
                    return
                }
                guard let data = data,
                      let image = UIImage(data: data) else {
                    self.showFailure()
                    return
                }
                self.imageView.image = image
                self.showImage()
            }
        }
        imageLoadTask?.resume()
    }
    
    private func showLoading() {
        imageView.isHidden = true
        loadingView.isHidden = false
        failureView.isHidden = true
        defaultView.isHidden = true
        loadingIndicator.startAnimating()
    }
    
    private func showImage() {
        imageView.isHidden = false
        loadingView.isHidden = true
        failureView.isHidden = true
        defaultView.isHidden = true
        loadingIndicator.stopAnimating()
    }
    
    private func showFailure() {
        imageView.isHidden = true
        loadingView.isHidden = true
        failureView.isHidden = false
        defaultView.isHidden = true
        loadingIndicator.stopAnimating()
    }
    
    private func showDefault() {
        imageView.isHidden = true
        loadingView.isHidden = true
        failureView.isHidden = true
        defaultView.isHidden = false
        loadingIndicator.stopAnimating()
    }
    
    // MARK: - Computed Properties
    
    private var imageContentMode: UIView.ContentMode {
        if let value = element.elementDetail?.style?.image?.size {
            switch value {
            case .fill:
                return .scaleAspectFill
            case .fit:
                return .scaleAspectFit
            case .stretch:
                return .scaleToFill
            }
        }
        return .scaleAspectFill
    }
    
    private var padding: UIEdgeInsets {
        guard let padding = element.elementDetail?.style?.padding else {
            return UIEdgeInsets.zero
        }
        if padding.isEven == true, let value = padding.value {
            let value = Double(value) ?? 0
            return UIEdgeInsets(top: value, left: value, bottom: value, right: value)
        }
        else{
            let top = Double(padding.top?.value ?? "0") ?? 0
            let left = Double(padding.left?.value ?? "0") ?? 0
            let right = Double(padding.right?.value ?? "0") ?? 0
            let bottom = Double(padding.bottom?.value ?? "0") ?? 0
            
            return UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
        }
    }
        
}
