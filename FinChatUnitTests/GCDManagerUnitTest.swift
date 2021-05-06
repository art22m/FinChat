//
//  DataManagerUnitTest.swift
//  FinChatUnitTests
//
//  Created by Артём Мурашко on 06.05.2021.
//

@testable import FinChat
import XCTest

class GCDManagerUnitTest: XCTestCase {

    func testExample() throws {
        // Arrange
        let exp = expectation(description: "Saving data")
        
        let dataStub = CurrentData()
        dataStub.descriptionFromFile = "Test1"
        dataStub.nameFromFile = "Test2"
        dataStub.descriptionFromProfile = "Test3"
        dataStub.nameFromProfile = "Test4"
        
        let profileDataManagerMock = ProfileDataManagerMock(data: dataStub)
        let GCDManager = GCDDataManager(profileDataManager: profileDataManagerMock)
        
        
        var dataForTest = CurrentData()
        
        // Act
        GCDManager.saveData(dataToSave: dataStub) { (SuccessStatus) in
            switch SuccessStatus {
            case .success:
                print("Success Save")
            case .error:
                print("Error Save")
            }
        }
        
        GCDManager.readData { (response) in
            dataForTest = response.0
            exp.fulfill()
        }
    
        // Assert
        waitForExpectations(timeout: 3)
        XCTAssertEqual(profileDataManagerMock.data.descriptionFromFile, dataForTest.descriptionFromFile)
        XCTAssertEqual(profileDataManagerMock.data.descriptionFromProfile, dataForTest.descriptionFromProfile)
        XCTAssertEqual(profileDataManagerMock.data.nameFromFile, dataForTest.nameFromFile)
        XCTAssertEqual(profileDataManagerMock.data.nameFromProfile, dataForTest.nameFromProfile)
        XCTAssertEqual(profileDataManagerMock.callsCount, 2)
    }

}
