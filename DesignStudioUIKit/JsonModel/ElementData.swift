//
//  DataViewModel.swift
//  designStudioDemo
//
//  Created by reshma-18357 on 02/07/25.
//

import Foundation

struct ElementData: Codable{
    let displayName: String?
    let elementName: String?
    let componentID: Int?
    let linkURL: String?
    let imageSrc: String?
    let builderSrc: String?
    let content: String?
    
    private enum CodingKeys: String, CodingKey {
        case displayName = "display_name"
        case elementName = "element_name"
        case imageSrc = "src"
        case builderSrc = "builder_src"
        case componentID = "component_id"
        case linkURL = "link_url"
        case content = "content"
    }
}

