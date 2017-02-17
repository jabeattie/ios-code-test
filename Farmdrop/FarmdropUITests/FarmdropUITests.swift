//
//  FarmdropUITests.swift
//  FarmdropUITests
//
//  Created by James Beattie on 15/02/2017.
//  Copyright © 2017 James Beattie. All rights reserved.
//

import XCTest

class FarmdropUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        XCUIDevice.shared().orientation = .faceUp
        XCUIDevice.shared().orientation = .faceUp
        
        let app = XCUIApplication()
        let tablesQuery = app.tables
        let typeAProducersNameSearchField = tablesQuery.searchFields["Type a producers name"]
        // In case of slow connectsions.
        sleep(5)
        typeAProducersNameSearchField.tap()
        typeAProducersNameSearchField.typeText("Farm")
        
        let parkFarmStaticText = tablesQuery.staticTexts["Park Farm"]
        XCTAssertNotNil(parkFarmStaticText)
        parkFarmStaticText.tap()
        
        let scrollViewsQuery = app.scrollViews
        scrollViewsQuery.otherElements.staticTexts["Hawkhurst, Kent"].tap()
        
        XCTAssertNotNil(scrollViewsQuery.otherElements.staticTexts["Hawkhurst, Kent"])
        
        app.navigationBars["Park Farm"].buttons["Producers"].tap()
        typeAProducersNameSearchField.tap()
        
        XCTAssertEqual(typeAProducersNameSearchField.title, "")
        
    }
    
}
