//
//  NetworkService.swift
//  FinChat
//
//  Created by Артём Мурашко on 22.04.2021.
//

import Foundation

protocol INetworkService {
    func sendRequest(completionHandler: @escaping (Result<[URL], Error>) -> Void)
}

class NetworkService: INetworkService {
    let requestSender: IRequestSender
  
    init(requestSender: IRequestSender) {
        self.requestSender = requestSender
    }
    
    func sendRequest(completionHandler: @escaping (Result<[URL], Error>) -> Void) {
        var urls: [URL] = []
        
        requestSender.send { result in
            switch result {
            case .success(let successValues):
//                print(successValues)
                successValues.forEach { image in
                    if let urlString = image.previewURL {
                        if let url = URL(string: urlString) {
                            urls.append(url)
                        }
                    }
                }
                completionHandler(.success(urls))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
}
