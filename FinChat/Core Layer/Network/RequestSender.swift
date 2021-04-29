//
//  RequestSender.swift
//  FinChat
//
//  Created by Артём Мурашко on 22.04.2021.
//

import Foundation

enum RequestError: Error {
    case requestURLError
    case clientError
    case emptyDataError
    case decodingDataError
}

protocol IRequestSender {
    func send(completionHandler: @escaping (Result<[Images], RequestError>) -> Void)
}

class RequestSender: IRequestSender {
    var config: RequestConfig
    init(requestConfig config: RequestConfig) {
        self.config = config
    }
  
    let session = URLSession.shared
  
    func send(completionHandler: @escaping (Result<[Images], RequestError>) -> Void) {
        guard let urlRequest = config.request.urlRequest else {
            completionHandler(.failure(.requestURLError))
        return
        }
    
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
//            print(data, response, error)
            guard error == nil else {
                completionHandler(.failure(.clientError))
                return
            }
            guard let data = data else {
                completionHandler(.failure(.emptyDataError))
                return
            }
            guard let parsedModel: [Images] = self.config.parser.parse(data: data) else {
                completionHandler(.failure(.decodingDataError))
                return
            }
            completionHandler(.success(parsedModel))
        }
        task.resume()
    }
}
