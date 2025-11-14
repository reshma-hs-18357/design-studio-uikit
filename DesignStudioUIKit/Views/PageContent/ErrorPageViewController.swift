//
//  ErrorPageViewController.swift
//  DesignStudioUIKit
//
//  Created by Reshma S on 13/11/25.
//

import UIKit

class ErrorPageView: UIView {

    private let icon = UIImageView(image: UIImage(systemName: "exclamationmark.triangle"))
    private let titleLabel = UILabel()
    private let messageLabel = UILabel()
    private let button = UIButton(type: .system)

    private var retry: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    private func setupUI() {
        icon.tintColor = .systemRed
        icon.contentMode = .scaleAspectFit
        icon.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.text = "Something went wrong"
        titleLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        titleLabel.textAlignment = .center

        messageLabel.font = .systemFont(ofSize: 14)
        messageLabel.textColor = .secondaryLabel
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center

        button.setTitle("Try Again", for: .normal)
        button.addTarget(self, action: #selector(onRetry), for: .touchUpInside)

        let stack = UIStackView(arrangedSubviews: [icon, titleLabel, messageLabel, button])
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false

        addSubview(stack)

        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            stack.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    func configure(message: String, retry: @escaping () -> Void) {
        messageLabel.text = message
        self.retry = retry
    }

    @objc private func onRetry() {
        retry?()
    }
}

