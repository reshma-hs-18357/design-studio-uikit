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

extension ElementViewModel {
    func layoutStrategy() -> LayoutStrategy{
        let elementViewModel = self
        let height = elementViewModel.elementDetail?.layout?.height
        let width = elementViewModel.elementDetail?.layout?.width
        let heightUnitType = height?.unit
        let widthUnitType = width?.unit
        
        let heightPercentValue = (Double(height?.value ?? "0") ?? 0) / 100.0
        let widthPercentValue = (Double(width?.value ?? "0") ?? 0) / 100.0
        let frameHeight = CGFloat(Double(height?.value ?? "0") ?? 0)
        let frameWidth = CGFloat(Double(width?.value ?? "0") ?? 0)
        
        switch (widthUnitType,heightUnitType) {
        case (.px, .px):
            return .fixed(width: frameWidth, height: frameHeight)
        case (.percent, .percent):
            return .percentage(widthRatio: heightPercentValue, heightRatio: widthPercentValue)
        case (.px, .percent):
            return .fixedWidthPercentageHeight(width: frameWidth, heightRatio: heightPercentValue)
        case (.percent, .px):
            return .fixedHeightPercentageWidth(widthRatio: widthPercentValue, height: frameHeight)
        case (.px, .auto):
            return .fixedWidthAutoHeight(width: frameWidth)
        case (.auto, .px):
            return .fixedHeightAutoWidth(height: frameHeight)
        case (.percent, .auto):
            return .percentageWidthAutoHeight(widthRatio: widthPercentValue)
        case (.auto, .percent):
            return .percentageHeightAutoWidth(heightRatio: heightPercentValue)
        case (.auto, .auto):
            return .intrinsic
        default:
            return .intrinsic
        }
    }
}
