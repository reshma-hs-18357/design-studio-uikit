//
//  Element.swift
//  designStudioDemo
//
//  Created by reshma-18357 on 01/07/25.
//

import Foundation


struct ElementViewModel: Codable {
    
    struct ElementDetailViewModel: Codable {
        let layout: ElementLayout?
        let data: ElementData?
        let style: ElementStyle?
        let events: ElementEvents?
        let content: String?
        
        private enum CodingKeys: String, CodingKey {
            case layout = "layout"
            case data = "data"
            case style = "style"
            case events = "events"
            case content = "content"
            
        }
    }

    let elementId: String
    let elementType: UIElementType
    let elementDetail: ElementDetailViewModel?
    let subElements: [String]?
    
    private enum CodingKeys: String, CodingKey {
        case elementId = "elementId"
        case elementType = "type"
        case elementDetail = "element"
        case subElements = "elements"
    }
}
