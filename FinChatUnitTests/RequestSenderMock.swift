//
//  File.swift
//  FinChatUnitTests
//
//  Created by Артём Мурашко on 04.05.2021.
//

@testable import FinChat
import Foundation

final class RequestSenderMock: IRequestSender {
    var receivedImages: [Images]
    var callsCount: Int
    
    init(receivedImages: [Images]) {
        self.receivedImages = receivedImages
        self.callsCount = 0
    }
    
    func send(completionHandler: @escaping (Result<[Images], RequestError>) -> Void) {
        callsCount += 1
        completionHandler(.success(receivedImages))
    }
}
