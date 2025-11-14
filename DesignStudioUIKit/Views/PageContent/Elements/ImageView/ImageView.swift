//
//  ImageView.swift
//  DesignStudioUIKit
//
//  Created by Reshma S on 13/11/25.
//

import UIKit


class ImageView: UIView {
    let element: ElementViewModel
    
    private let imageView = UIImageView()
    private let loadingView = UIView()
    private let loadingIndicator = UIActivityIndicatorView(style: .medium)
    private let loadingLabel = UILabel()
    private let failureView = UIView()
    private let defaultView = UIView()
    private var backgroundImageView: UIImageView?
    
    private var imageLoadTask: URLSessionDataTask?
    
    init(element: ElementViewModel) {
        self.element = element
        super.init(frame: .zero)
        setupView()
        loadImage()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        // Cancel any ongoing image load task to prevent memory leaks
        imageLoadTask?.cancel()
    }
    
    private func setupView() {
        // Setup main image view
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = imageContentMode
        imageView.clipsToBounds = true
        addSubview(imageView)
        
        // Setup loading view
        setupLoadingView()
        
        // Setup failure view
        setupFailureView()
        
        // Setup default view
        setupDefaultView()
        
        // Apply styling
        applyBorder()
        applyShadow()
        
        // Apply properties
        layer.cornerRadius = cornerRadius
        clipsToBounds = true
        alpha = opacity
        
        // Show loading initially
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
        let paddingInsets = padding
        
        // Main container constraints with margins
        var constraints: [NSLayoutConstraint] = []
        
        // Width constraint
        if let width = frameWidth {
            constraints.append(widthAnchor.constraint(equalToConstant: width))
        }
        
        // Height constraint
        if let height = frameHeight {
            constraints.append(heightAnchor.constraint(equalToConstant: height))
        }
        
        NSLayoutConstraint.activate(constraints)
        
        // Image view constraints with padding
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: paddingInsets.top),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: paddingInsets.leading),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -paddingInsets.trailing),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -paddingInsets.bottom)
        ])
        
        // Loading, failure, and default views fill the entire view
        for view in [loadingView, failureView, defaultView] {
            NSLayoutConstraint.activate([
                view.topAnchor.constraint(equalTo: topAnchor),
                view.leadingAnchor.constraint(equalTo: leadingAnchor),
                view.trailingAnchor.constraint(equalTo: trailingAnchor),
                view.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
        }
    }
    
    // MARK: - Image Loading
    
    private func loadImage() {
        guard let src = element.elementDetail?.data?.imageSrc else {
            showDefault()
            return
        }
        
        let domainURL = "https://dockerdev19.csez.zohocorpin.com/creator/\(staticImageID)/\(src)"
        
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
    
    private var frameWidth: CGFloat? {
        guard let width = element.elementDetail?.layout?.width else {
            return nil
        }
        switch width.unit {
        case .px:
            return CGFloat(Double(width.value ?? "0") ?? 0)
        case .auto, .fitContent, .fillContent, .percent:
            return nil
        default:
            return nil
        }
    }
    
    private var frameHeight: CGFloat? {
        guard let height = element.elementDetail?.layout?.height else {
            return nil
        }
        switch height.unit {
        case .px:
            return CGFloat(Double(height.value ?? "0") ?? 0)
        case .auto, .fitContent, .fillContent, .percent:
            return nil
        default:
            return nil
        }
    }
    
    private var cornerRadius: CGFloat {
        guard let cornerRadius = element.elementDetail?.style?.cornerRadius else {
            return 0
        }
        if let value = cornerRadius.value, !value.isEmpty {
            let cleanedValue = value
                .replacingOccurrences(of: "px", with: "", options: .caseInsensitive)
                .trimmingCharacters(in: .whitespacesAndNewlines)
            
            return CGFloat(Double(cleanedValue) ?? 0)
        }
        if let preset = cornerRadius.preset, !preset.isEmpty {
            switch preset {
            case "preset1": return 6
            case "preset2": return 12
            case "preset3": return 16
            case "preset4": return 24
            case "preset5": return 32
            case "preset6": return 1000
            default: break
            }
        }
        return 0
    }
    
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
    
    private var padding: (top: CGFloat, leading: CGFloat, bottom: CGFloat, trailing: CGFloat) {
        guard let padding = element.elementDetail?.style?.padding else {
            return (0, 0, 0, 0)
        }
        if padding.isEven == true, let value = padding.value {
            let value = CGFloat(Double(value) ?? 4)
            return (value, value, value, value)
        } else {
            let top = CGFloat(Double(padding.top?.value ?? "0") ?? 0)
            let left = CGFloat(Double(padding.left?.value ?? "0") ?? 0)
            let right = CGFloat(Double(padding.right?.value ?? "0") ?? 0)
            let bottom = CGFloat(Double(padding.bottom?.value ?? "0") ?? 0)
            
            return (top, left, bottom, right)
        }
    }
    
    private var topMargin: CGFloat? {
        guard let isEnabled = element.elementDetail?.layout?.constraints?.top?.isEnabled,
              isEnabled,
              let value = element.elementDetail?.layout?.constraints?.top?.value,
              let margin = Double(value) else {
            return nil
        }
        return CGFloat(margin)
    }
    
    private var leftMargin: CGFloat? {
        guard let isEnabled = element.elementDetail?.layout?.constraints?.left?.isEnabled,
              isEnabled,
              let value = element.elementDetail?.layout?.constraints?.left?.value,
              let margin = Double(value) else {
            return nil
        }
        return CGFloat(margin)
    }
    
    private var rightMargin: CGFloat? {
        guard let isEnabled = element.elementDetail?.layout?.constraints?.right?.isEnabled,
              isEnabled,
              let value = element.elementDetail?.layout?.constraints?.right?.value,
              let margin = Double(value) else {
            return nil
        }
        return CGFloat(margin)
    }
    
    private var bottomMargin: CGFloat? {
        guard let isEnabled = element.elementDetail?.layout?.constraints?.bottom?.isEnabled,
              isEnabled,
              let value = element.elementDetail?.layout?.constraints?.bottom?.value,
              let margin = Double(value) else {
            return nil
        }
        return CGFloat(margin)
    }
    
    private var opacity: Double {
        guard let opacity = element.elementDetail?.style?.opacity else {
            return 1.0
        }
        return (Double(opacity) ?? 100) / 100.0
    }
    
    // MARK: - Styling Methods
    
 
    private func applyBorder() {
        if let border = element.elementDetail?.style?.border,
           (border.isEnabled ?? true),
           let thickness = border.thickness,
           let thicknessValue = Double(thickness),
           thicknessValue > 0 {
            
            layer.borderWidth = CGFloat(thicknessValue)
            layer.borderColor = (UIColor(hex: border.color ?? "#000000") ?? .black).cgColor
        } else {
            layer.borderWidth = 0
        }
    }
    
    private func applyShadow() {
        guard let shadow = element.elementDetail?.style?.shadow,
              shadow.isEnabled == true else {
            layer.shadowOpacity = 0
            return
        }
        
        let colorString = shadow.color ?? ""
        let shadowUIColor = !colorString.isEmpty ? (UIColor(hex: colorString) ?? .clear) : .clear
        let blur = CGFloat(Double(shadow.blur ?? "0") ?? 0)
        let x = CGFloat(Double(shadow.xOffset ?? "0") ?? 0)
        let y = CGFloat(Double(shadow.yOffset ?? "0") ?? 0)
        
        layer.shadowColor = shadowUIColor.cgColor
        layer.shadowRadius = blur
        layer.shadowOffset = CGSize(width: x, height: y)
        layer.shadowOpacity = 1.0
        layer.masksToBounds = false
    }
}
