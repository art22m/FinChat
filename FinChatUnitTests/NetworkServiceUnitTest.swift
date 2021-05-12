//
//  NetworkServiceUnitTest.swift
//  NetworkServiceUnitTest
//
//  Created by Артём Мурашко on 04.05.2021.
//

@testable import FinChat
import XCTest

class NetworkServiceUnitTest: XCTestCase {

    func testRequestAndCallsCount() throws {
        // Arrange
        let images = [Images(previewURL: "https://www.artmurashko.ru")]
        let requestSender = RequestSenderMock(receivedImages: images)
        let networkService = NetworkService(requestSender: requestSender)
        
        // Act
        networkService.sendRequest { response in
            switch response {
                case .success(let URLs):
                    // Assert
                    XCTAssertEqual(URLs, [URL(string: "https://www.artmurashko.ru")])
//                    print(URLs)
                default:
                    print(response)
            }
        }
        
        // Assert
        XCTAssertEqual(requestSender.callsCount, 1)
    }
}
