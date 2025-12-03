//
//  BackgroundView.swift
//  DesignStudioUIKit
//
//  Created by Reshma S on 02/12/25.
//

import UIKit

protocol BackgroundView: UIView {
    func applyBackgroundImage(contentView: UIView, element: ElementViewModel)
    func applyBackgroundColor(contentView: UIView, element: ElementViewModel)
    func applyBackground(contentView: UIView, element: ElementViewModel)
}

extension BackgroundView {
    func applyBackgroundImage(contentView: UIView, element: ElementViewModel) {
    }
    
    func applyBackgroundColor(contentView: UIView, element: ElementViewModel) {
    }
    
    func applyBackground(contentView: UIView, element: ElementViewModel) {
    }
}
