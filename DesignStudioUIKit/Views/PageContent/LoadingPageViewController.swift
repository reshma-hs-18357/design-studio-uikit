//
//  LoadingPageViewController.swift
//  DesignStudioUIKit
//
//  Created by Reshma S on 13/11/25.
//

import UIKit

class LoadingPageView: UIView {
    private let spinner = UIActivityIndicatorView(style: .large)
    private let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) { fatalError() }

    private func setupUI() {
        spinner.startAnimating()

        label.text = "Loading Content"
        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel

        let stack = UIStackView(arrangedSubviews: [spinner, label])
        stack.axis = .vertical
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false

        addSubview(stack)

        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

