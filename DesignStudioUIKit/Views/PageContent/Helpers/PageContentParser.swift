//
//  JSONParserHandler.swift
//  designStudioDemo
//
//  Created by Reshma S on 11/08/25.
//


enum JsonParserError : Error {
    case invalidData
    case decodingFailed (Error)
    case emptyJsonString
    case noRootElement
    case fileNotFound

   
    var localizedDescription: String {
           switch self {
           case .invalidData:
               return "The JSON data is invalid or corrupted"
           case .decodingFailed(let error):
               return "Failed to decode JSON: \(error.localizedDescription)"
           case .fileNotFound:
               return "JSON file not found in bundle"
           case .noRootElement:
               return "No root element found in the JSON structure"
           case .emptyJsonString:
                return "JSON string is empty or invalid"
           }
       }
}
