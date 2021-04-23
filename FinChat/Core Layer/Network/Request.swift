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
    var mainURL: String? {
        return "https://pixabay.com/api/?key=21288647-43db279afe2e05f96a06c2f01&q=yellow+flowers&image_type=photo&pretty=true&per_page=50"
    }

    var urlRequest: URLRequest? {
        guard let urlString: String = mainURL else { return nil }
        if let url = URL(string: urlString) { return URLRequest(url: url, timeoutInterval: 5) }
        return nil
    }
}
