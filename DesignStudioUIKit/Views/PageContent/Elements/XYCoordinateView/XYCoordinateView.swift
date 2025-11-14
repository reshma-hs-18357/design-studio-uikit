//
//  XYCoordinateVie3.swift
//  DesignStudioUIKit
//
//  Created by Reshma S on 14/11/25.
//

import UIKit

class XYCoordinateView: UIView {
    let element: ElementViewModel
    let elementsMap: [String: ElementViewModel]
    
    private let scrollView = UIScrollView()
    private let containerView = UIView()
    private var backgroundImageView: UIImageView?
    
    init(element: ElementViewModel, elementsMap: [String: ElementViewModel]) {
        self.element = element
        self.elementsMap = elementsMap
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        // Setup scroll view
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = true
        addSubview(scrollView)
        
        // Setup container view
        containerView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(containerView)
        
        // Apply styling
        applyBackground()
        applyBorder()
        applyShadow()
        
        // Add sub-elements
        if let subElements = element.subElements {
            for subElementId in subElements {
                if let subElement = elementsMap[subElementId] {
                    let renderer = ElementRendererView(
                        element: subElement,
                        elementsMap: elementsMap
                    )
                    renderer.translatesAutoresizingMaskIntoConstraints = false
                    containerView.addSubview(renderer)
                    
                    // Position using XY coordinates from constraints
                    positionChildElement(renderer, withLayout: subElement.elementDetail?.layout)
                }
            }
        }
        
        // Apply opacity
        alpha = opacity
        
        // Apply corner radius
        layer.cornerRadius = cornerRadius
        clipsToBounds = true
        
        setupConstraints()
    }
    
    private func positionChildElement(_ childView: UIView, withLayout layout: ElementLayout?) {
        var constraints: [NSLayoutConstraint] = []
        
        // Get XY position from constraints
        let topOffset = getConstraintValue(layout?.constraints?.top) ?? 0
        let leftOffset = getConstraintValue(layout?.constraints?.left) ?? 0
        
        // Position the child
        constraints.append(childView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: topOffset))
        constraints.append(childView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: leftOffset))
        
        // Apply width if specified
        if let width = layout?.width {
            switch width.unit {
            case .px:
                if let value = width.value, let widthValue = Double(value), widthValue > 0 {
                    constraints.append(childView.widthAnchor.constraint(equalToConstant: CGFloat(widthValue)))
                }
            case .percent:
                if let value = width.value, let percentage = Double(value), percentage > 0 {
                    constraints.append(childView.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: CGFloat(percentage) / 100.0))
                }
            default:
                break
            }
        }
        
        // Apply height if specified
        if let height = layout?.height {
            switch height.unit {
            case .px:
                if let value = height.value, let heightValue = Double(value), heightValue > 0 {
                    constraints.append(childView.heightAnchor.constraint(equalToConstant: CGFloat(heightValue)))
                }
            case .percent:
                if let value = height.value, let percentage = Double(value), percentage > 0 {
                    constraints.append(childView.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: CGFloat(percentage) / 100.0))
                }
            default:
                break
            }
        }
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func getConstraintValue(_ constraint: ElementLayout.ConstraintDetail?) -> CGFloat {
        guard let constraint = constraint,
              constraint.isEnabled == true,
              let value = constraint.value,
              let doubleValue = Double(value) else {
            return 0
        }
        return CGFloat(doubleValue)
    }
    
    private func setupConstraints() {
        let paddingInsets = padding
        
        // Scroll view constraints with margins
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor, constant: topMargin ?? 0),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leftMargin ?? 0),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -(rightMargin ?? 0)),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -(bottomMargin ?? 0))
        ])
        
        // Container view constraints
        var containerConstraints = [
            containerView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ]
        
        // Apply width if specified
        if let width = frameWidth {
            containerConstraints.append(
                containerView.widthAnchor.constraint(equalToConstant: width)
            )
        } else {
            containerConstraints.append(
                containerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
            )
        }
        
        // Apply height if specified
        if let height = frameHeight {
            containerConstraints.append(
                containerView.heightAnchor.constraint(equalToConstant: height)
            )
        }
        
        NSLayoutConstraint.activate(containerConstraints)
        
        // Apply padding to container
        containerView.layoutMargins = UIEdgeInsets(
            top: paddingInsets.top,
            left: paddingInsets.leading,
            bottom: paddingInsets.bottom,
            right: paddingInsets.trailing
        )
    }
    
    // MARK: - Computed Properties
    
    private var frameWidth: CGFloat? {
        guard let width = element.elementDetail?.layout?.width else {
            return nil
        }
        switch width.unit {
        case .px:
            return CGFloat(Double(width.value ?? "0") ?? 0)
        case .auto:
            return nil
        case .fitContent, .fillContent, .percent:
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
        case .auto:
            return nil
        case .fitContent, .fillContent, .percent:
            return nil
        default:
            return nil
        }
    }
    
    private var opacity: Double {
        guard let opacity = element.elementDetail?.style?.opacity else {
            return 1.0
        }
        return (Double(opacity) ?? 100) / 100.0
    }
    
    private var padding: (top: CGFloat, leading: CGFloat, bottom: CGFloat, trailing: CGFloat) {
        guard let padding = element.elementDetail?.style?.padding else {
            return (0, 0, 0, 0)
        }
        if padding.isEven == true, let value = padding.value {
            let value = CGFloat(Double(value) ?? 0)
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
    
    // MARK: - Styling Methods
    
    private func applyBackground() {
        if let background = element.elementDetail?.style?.background,
           background.isEnabled == true {
            
            if let imageSrc = background.image?.src {
                let domainURL = "https://dockerdev19.csez.zohocorpin.com/creator/\(staticImageID)/\(imageSrc)"
                
                // Create image view if needed
                if backgroundImageView == nil {
                    backgroundImageView = UIImageView()
                    backgroundImageView?.contentMode = .scaleAspectFill
                    backgroundImageView?.translatesAutoresizingMaskIntoConstraints = false
                    insertSubview(backgroundImageView!, at: 0)
                    
                    NSLayoutConstraint.activate([
                        backgroundImageView!.topAnchor.constraint(equalTo: topAnchor),
                        backgroundImageView!.leadingAnchor.constraint(equalTo: leadingAnchor),
                        backgroundImageView!.trailingAnchor.constraint(equalTo: trailingAnchor),
                        backgroundImageView!.bottomAnchor.constraint(equalTo: bottomAnchor)
                    ])
                }
                
                // Load image asynchronously
                if let url = URL(string: domainURL) {
                    URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                        guard let data = data, error == nil, let image = UIImage(data: data) else {
                            DispatchQueue.main.async {
                                self?.backgroundColor = self?.backgroundUIColor
                            }
                            return
                        }
                        DispatchQueue.main.async {
                            self?.backgroundImageView?.image = image
                        }
                    }.resume()
                } else {
                    backgroundColor = backgroundUIColor
                }
            } else {
                backgroundColor = backgroundUIColor
            }
        } else {
            backgroundColor = backgroundUIColor
        }
    }
    
    private var backgroundUIColor: UIColor {
        if let color = element.elementDetail?.style?.background?.color, !color.isEmpty {
            return UIColor(hex: color) ?? .clear
        }
        return .clear
    }
    
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
