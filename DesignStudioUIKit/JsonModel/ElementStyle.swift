//
//  StyleViewModel.swift
//  designStudioDemo
//
//  Created by reshma-18357 on 01/07/25.
//

struct ElementStyle: Codable {
    struct CornerRadius: Codable {
        let preset: String?
        let value: String?
    }
    
    struct Border: Codable {
        let isEnabled: Bool?
        let color: String?
        let thickness: String?
        
        private enum CodingKeys: String, CodingKey {
            case isEnabled = "is_enabled"
            case color = "color"
            case thickness = "thickness"
        }
    }

    struct Padding: Codable {
        let unit: String?
        let top: UnitValue?
        let left: UnitValue?
        let bottom: UnitValue?
        let right: UnitValue?
        let isEven: Bool?
        let value: String?
        
        private enum CodingKeys: String, CodingKey {
            case unit = "unit"
            case top = "top"
            case left = "left"
            case bottom = "bottom"
            case right = "right"
            case isEven = "is_even"
            case value = "value"
        }
    }

    struct Shadow: Codable {
        let isEnabled: Bool?
        let color: String?
        let blur: String?
        let scale: String?
        let preset: String?
        let yOffset: String?
        let xOffset: String?
        
        private enum CodingKeys: String, CodingKey {
            case isEnabled = "is_enabled"
            case color = "color"
            case blur = "blur"
            case scale = "scale"
            case preset = "preset"
            case yOffset = "y_offset"
            case xOffset = "x_offset"
        }
    }

    struct Background: Codable {
        struct BackgroundImage: Codable {
            let size: String?
            let src: String?
            let builderSrc: String?
            let position: String?
            
            private enum CodingKeys: String, CodingKey {
                case src = "src"
                case builderSrc = "builder_src"
                case size = "size"
                case position = "position"
            }
        }

        let isEnabled: Bool?
        let color: String?
        let image: BackgroundImage?
        
        private enum CodingKeys: String, CodingKey {
            case isEnabled = "is_enabled"
            case color = "color"
            case image = "image"
        }
    }

    struct TextAlign: Codable {
        let textAlign: String?
        
        private enum CodingKeys: String, CodingKey {
            case textAlign = "text_align"
        }
    }

    struct Font: Codable {
        struct FontSize: Codable { //
            let value: String?
            
            private enum CodingKeys: String, CodingKey {
                case value = "value"
            }
        }
        let color: String?
        let size: FontSize?
        let weight: String?
        let family: String?
        
        private enum CodingKeys: String, CodingKey {
            case color = "color"
            case size = "size"
            case weight = "weight"
            case family = "family"
        }
    }
  
    struct Flex: Codable {
        
        enum FlexWrap: String, Codable {
            case wrap = "wrap"
            case nowrap = "nowrap"
            case wrapReverse = "wrap-reverse"
            case none = ""
        }
        
        enum FlexAlign: String, Codable {
            case topLeft = "topLeft"
            case top = "top"
            case topRight = "topRight"
            case left = "left"
            case center = "center"
            case right = "right"
            case bottomLeft = "bottomLeft"
            case bottom = "bottom"
            case bottomRight = "bottomRight"
            case edgeToEdge = "edgeToEdge"
            case equalSplit = "equalSplit"
            case none = "none"
        }
        
        enum FlexDirection: String, Codable {
            case row = "row"
            case column = "column"
        }
        
        let gap: String?
        let align: FlexAlign?
        let wrap: FlexWrap?
        let direction: FlexDirection?
        
        private enum CodingKeys: String, CodingKey {
            case gap = "gap"
            case align = "align"
            case wrap = "wrap"
            case direction = "direction"
        }
    }
    
    struct ImageStyle: Codable {
        let size: ImageSize?
        let position: ImagePosition?
        
        enum ImageSize: String, Codable, CodingKey {
            case fill = "fill"
            case fit = "fit"
            case stretch = "stretch"
        }
        
        enum ImagePosition: String, Codable, CodingKey {
            case topLeft = "topLeft"
            case top = "top"
            case topRight = "topRight"
            case left = "left"
            case center = "center"
            case right = "right"
            case bottomLeft = "bottomLeft"
            case bottom = "bottom"
            case bottomRight = "bottomRight"
        }
        
        private enum CodingKeys: String, CodingKey {
            case size = "size"
            case position = "position"
        }
    }
    
    let cornerRadius: CornerRadius?
    let border: Border?
    let padding: Padding?
    let shadow: Shadow?
    let background: Background?
    let align: TextAlign?
    let opacity: String?
    let font: Font?
    let flex: Flex?
    let image: ImageStyle?
    
    private enum CodingKeys: String, CodingKey {
        case cornerRadius = "corner_radius"
        case border = "border"
        case padding = "padding"
        case shadow = "shadow"
        case background = "background"
        case align = "align"
        case opacity = "opacity"
        case font = "font"
        case flex = "flex"
        case image = "image"
    }
}


extension ElementStyle.Padding {
    static func even(_ value: Double) -> ElementStyle.Padding {
        return ElementStyle.Padding(
            unit: "px",
            top: nil,
            left: nil,
            bottom: nil,
            right: nil,
            isEven: true,
            value: String(value)
        )
    }
}
