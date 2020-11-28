//
//  WonderfulChatUITests.swift
//  WonderfulChatUITests
//
//  Created by Роман Мисников on 28.11.2020.
//

import XCTest

class WonderfulChatUITests: XCTestCase {
    
    private let app = XCUIApplication()
    
    override func setUp() {
        super.setUp()
        app.activate()
    }
    
    func testLogin() {
        let introduceNavigationBar = app.navigationBars["Introduce yourself"]
        let activeUsersNavigationBar = app.navigationBars["Active users"]
        
        // log out if is logged in
        if activeUsersNavigationBar.isHittable {
            app.buttons["Log out"].tap()
        }
            
        XCTAssertTrue(introduceNavigationBar.isHittable)
        login()
        
        // users list screen
        XCTAssertTrue(activeUsersNavigationBar.exists)
        let testStaticText = activeUsersNavigationBar.staticTexts["Test"]
        XCTAssertTrue(testStaticText.exists)
    }
    
    func testSwitchServer() {
        
        // login if needed
        let introduceNavigationBar = app.navigationBars["Introduce yourself"]
        if introduceNavigationBar.isHittable {
            login()
        }
        
        let tabBar = app.tabBars["Tab Bar"]
        tabBar.buttons["Debug"].tap()
        
        // debug screen
        let serverButton = app.buttons[A11y.serverSelectButton]
        
        serverButton.tap()
        app.cells["wonderfulchat.herokuapp.com"].tap()
        app.buttons["Отключиться"].tap()
        
        serverButton.tap()
        app.cells["127.0.0.1:8080"].tap()
        app.buttons["Отключиться"].tap()
    }
}

private extension WonderfulChatUITests {
    func login() {
        app.textFields["name"].tap()
        app.textFields["name"].typeText("Test")
        app.buttons["Continue"].tap()
    }
    
    func logout() {
        app.buttons["Log out"].tap()
    }
}
