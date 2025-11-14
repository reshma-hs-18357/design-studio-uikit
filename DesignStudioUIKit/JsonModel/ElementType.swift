//
//  ElementType.swift
//  designStudioDemo
//
//  Created by Reshma S on 06/08/25.
//

import SwiftUI

enum UIElementType: String, Codable {
    case canvas = "canvas"
    case horizontalFlex = "horizontal_flex"
    case verticalFlex = "vertical_flex"
    case heading = "heading"
    case image = "image"
    case xycoordinates = "xycoordinates"
    case signin = "signin"
    case signup = "signup"
    case createPassword = "create_password"
    case forgotPassword = "forgot_password"
    case menu = "menu"
    case menuItem = "menu_item"
    case icon = "icon"
    case unknown
    
    init(from decoder: Decoder) throws {
           let container = try decoder.singleValueContainer()
           let value = try container.decode(String.self)
           self = UIElementType(rawValue: value) ?? .unknown
       }
}
