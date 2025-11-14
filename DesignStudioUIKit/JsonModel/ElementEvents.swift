//
//  EventsViewModel.swift
//  designStudioDemo
//
//  Created by reshma-18357 on 01/07/25.
//

struct ElementEvents: Codable {
    struct Action: Codable {
        let action: String?
        let params: String?
        
        private enum CodingKeys: String, CodingKey {
            case action = "action"
            case params = " params"
        }
    }

    let ondblclick: [Action]?
    let onclick: [Action]?
    
    private enum CodingKeys: String, CodingKey {
        case ondblclick = "ondblclick"
        case onclick = "onclick"
    }
}



    
