//
//  CampaignSdkDemoUITests.swift
//  CampaignSdkDemoUITests
//
//  Created by iOS-Apps on 07/02/18.
//  Copyright © 2018 loyagram. All rights reserved.
//

import XCTest

class CampaignSdkDemoUITests: XCTestCase {
        
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
        
        
        
        let app = XCUIApplication()
        app.buttons["SHOW IN VIEW CONTROLLER"].tap()
        app.buttons["Start"].tap()
        
        let nextButton = app.buttons["Next"]
        nextButton.tap()
        nextButton.tap()
        
        let textView = app.scrollViews.children(matching: .textView).element(boundBy: 1)
        textView.tap()
        textView.typeText("test")
   

        
    }
    
}
