//
//  PageContentViewModel.swift
//  designStudioDemo
//
//  Created by reshma-18357 on 01/07/25.
//


struct ScreenUIViewModel: Codable {
    
    struct PageContentViewModel: Codable {
        let elements: [String: ElementViewModel]
        let elementType: UIElementType
        let sections: [String]
        
        private enum CodingKeys: String, CodingKey{
            case elements = "elements"
            case elementType = "type"
            case sections = "sections"
        }
    }
    
    let pageContent: PageContentViewModel
    
    private enum CodingKeys: String, CodingKey {
        case pageContent = "page_content"
    }
    
}


