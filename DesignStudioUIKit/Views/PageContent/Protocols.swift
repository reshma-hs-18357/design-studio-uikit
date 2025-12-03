//
//  Protocols.swift
//  DesignStudioUIKit
//
//  Created by Ganesh Arora on 01/12/25.
//

import UIKit

protocol Scrollable: UIView {
    func makeContentScrollable(contentView: UIView, padding: UIEdgeInsets)
}

extension Scrollable {
    func makeContentScrollable(contentView: UIView, padding: UIEdgeInsets = .zero) {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
//        scrollView.backgroundColor = UIColor.green
//        contentView.backgroundColor = UIColor.blue
        self.addSubview(scrollView)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        
    
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: self.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: padding.top),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -padding.bottom),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: padding.left),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -padding.right)
        ])
        
        let widthConstraint = contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor)
        widthConstraint.isActive = true
        widthConstraint.priority = .defaultLow
        
        let heightConstraint = scrollView.heightAnchor.constraint(equalTo: contentView.heightAnchor)
        heightConstraint.priority = .defaultLow
        heightConstraint.isActive = true
               
    }
}
