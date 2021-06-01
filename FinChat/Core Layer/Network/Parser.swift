//
//  Parser.swift
//  FinChat
//
//  Created by Артём Мурашко on 22.04.2021.
//

import Foundation

protocol IParser {
    func parse(data: Data) -> [Images]?
}

class Parser: IParser {
    func parse(data: Data) -> [Images]? {
        do {
            let images = try JSONDecoder().decode(DataModel.self, from: data).hits
            return images
        } catch {
            return nil
        }
    }
}

protocol IImages {
    var previewURL: String? { get set }
}

struct Images: Decodable, IImages {
    var previewURL: String?
}

struct RequestConfig {
    let request: IRequest
    let parser: Parser
}

struct DataModel: Decodable {
    let hits: [Images]
}

