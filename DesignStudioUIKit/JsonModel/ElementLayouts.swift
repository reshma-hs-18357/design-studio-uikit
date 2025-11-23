//
//  LayoutsViewModel.swift
//  designStudioDemo
//
//  Created by reshma-18357 on 01/07/25.
//

struct UnitValue: Codable  {

    enum ElementLayoutUnits: String, Codable, CodingKey {
        case percent = "%"
        case px = "px"
        case auto = "auto"
        case fitContent = "fit-content"
        case fillContent = "fill-content"
        case unknown
    }
    
    let unit: ElementLayoutUnits?
    let value: String?
    
    private enum CodingKeys: String,  CodingKey {
        case unit = "unit"
        case value = "value"
    }
}

struct ElementLayout: Codable  {
    
    struct ConstraintDetail: Codable {
        let isEnabled: Bool?
        let unit: String?
        let value: String?
        
        
        private enum CodingKeys: String,  CodingKey {
            case isEnabled = "is_enabled"
            case unit = "unit"
            case value = "value"
        }
    }
    
    struct ConstraintsViewModel: Codable {
        let top, left, bottom, right: ConstraintDetail?
        let position: ConstraintPosition?
        
        enum ConstraintPosition: String, Codable, CodingKey {
            case absolute = "absolute"
            case relative = "relative"
            case auto = ""
            case unknown

        }
        
        private enum CodingKeys: String,  CodingKey {
            case top = "top"
            case left = "left"
            case bottom = "bottom"
            case right = "right"
            case position = "position"
        }
    }
 
    let width: UnitValue?
    let height: UnitValue?
    let constraints: ConstraintsViewModel?
    
    private enum CodingKeys: String,  CodingKey {
        case constraints = "constraints"
        case width = "width"
        case height = "height"
    }
}



