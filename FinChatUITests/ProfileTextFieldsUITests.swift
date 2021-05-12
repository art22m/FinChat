//
//  FinChatUITests.swift
//  FinChatUITests
//
//  Created by Артём Мурашко on 06.05.2021.
//

import XCTest

class FinChatUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    func testProfileTextFields() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        
        let profileButton = app.buttons["profile"].firstMatch
        _ = profileButton.waitForExistence(timeout: 5.0)
        profileButton.tap()
        
        // No need to tap button Edit, figured it out later :)
//        let editButton = app.buttons["edit"].firstMatch
//        _ = editButton.waitForExistence(timeout: 7.0)
//        editButton.tap()
        
        let nameTextField = app.textFields["profileName"]
        _ = nameTextField.waitForExistence(timeout: 4.0)
        let descriptionTextField = app.textFields["profileDescription"]
        _ = descriptionTextField.waitForExistence(timeout: 4.0)
        
        XCTAssert(nameTextField.exists)
        XCTAssert(descriptionTextField.exists)
    }
/* This takes to much time,*/
    
//    func testLaunchPerformance() throws {
//        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
//            // This measures how long it takes to launch your application.
//            measure(metrics: [XCTApplicationLaunchMetric()]) {
//                XCUIApplication().launch()
//            }
//        }
//    }
}
