//
//  PageContentHelper.swift
//  DesignStudioUIKit
//
//  Created by Reshma S on 13/11/25.
//

import UIKit

extension PageContentViewController {
    
    
    func getJsonString() throws -> String {
        guard let url = Bundle.main.url(forResource: jsonSource, withExtension: "json") else {
            throw JsonParserError.fileNotFound
        }
        do {
            let string = try String(contentsOf: url)
            guard !string.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                throw JsonParserError.emptyJsonString
            }
            return string
        } catch {
            throw JsonParserError.invalidData
        }
    }

    func decodeJsonString(_ string: String) throws -> ScreenUIViewModel {
        guard let data = string.data(using: .utf8) else {
            throw JsonParserError.invalidData
        }
        do {
            return try JSONDecoder().decode(ScreenUIViewModel.self, from: data)
        } catch {
            throw JsonParserError.decodingFailed(error)
        }
    }

    func createViewModelMap(from decoded: ScreenUIViewModel) throws -> [String: ElementViewModel] {
        let elements = decoded.pageContent.elements
        guard !elements.isEmpty else { throw JsonParserError.invalidData }
        return elements
    }

    func findRootElement(from decoded: ScreenUIViewModel, in map: [String: ElementViewModel]) throws -> ElementViewModel {
        guard let rootId = decoded.pageContent.sections.first,
              let root = map[rootId] else {
            throw JsonParserError.noRootElement
        }
        return root
    }
}
