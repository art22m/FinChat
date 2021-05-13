//
//  Request.swift
//  FinChat
//
//  Created by Артём Мурашко on 22.04.2021.
//

import Foundation

protocol IRequest {
    var urlRequest: URLRequest? { get }
}

class Request: IRequest {
    lazy var APIkey = Bundle.main.object(forInfoDictionaryKey: "PICTURES_API_KEY")
    
    var mainURL: String? {
        if let APIkey = APIkey {
            return "https://pixabay.com/api/?key=\(APIkey)&q=yellow+flowers&image_type=photo&pretty=true&per_page=50"
        } else {
            return nil
        }
    }

    var urlRequest: URLRequest? {
        guard let urlString: String = mainURL else { return nil }
        if let url = URL(string: urlString) { return URLRequest(url: url, timeoutInterval: 5) }
        return nil
    }
}
