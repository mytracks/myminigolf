//
//  test1.swift
//  myMinigolfUISnapshots
//
//  Created by Dirk Stichling on 29.07.22.
//

import XCTest

extension XCUIApplication {
}

extension XCUIElement {
    func waitAndTap() {
        XCTAssertTrue(self.waitForExistence(timeout: 2))

        self.tap()
    }
}

class Snapshots: XCTestCase {

    private var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        self.app = XCUIApplication()
        self.app.launchArguments = ["-noPersistence", "true"]
        setupSnapshot(app)
        self.app.launch()
    }

    func add(user: String) {
        self.app.images["newPlayerButton"].waitAndTap()
        
        let newPlayerNameTextfield = self.app.textFields["newPlayerNameTextfield"]
        
        newPlayerNameTextfield.waitAndTap()
        newPlayerNameTextfield.typeText(user)
        
        self.app.buttons["newPlayerAdd"].waitAndTap()
    }
    
    func playNextLane(user: String, strokes: Int, screenshot: String? = nil) {
        self.app.otherElements["playerCard:"+user].waitAndTap()
        
//        let playerCard = self.app.otherElements["playerCard:"+user]
//        XCTAssertTrue(playerCard.waitForExistence(timeout: 1))
//        playerCard.tap()
        
        let newLaneIncreaseStrokes = self.app.images["newLaneIncreaseStrokes"]
        XCTAssertTrue(newLaneIncreaseStrokes.waitForExistence(timeout: 1))

        for _ in 0..<strokes {
            usleep(100*1000)
            newLaneIncreaseStrokes.tap()
        }
        
        if let screenshot = screenshot {
            snapshot(screenshot)
        }

        self.app.buttons["newLaneIncreaseSave"].waitAndTap()
    }
    
    func playNextLane(dirk: Int, michael: Int, kai: Int) {
        self.playNextLane(user: "Dirk", strokes: dirk)
        self.playNextLane(user: "Michael", strokes: michael)
        self.playNextLane(user: "Kai", strokes: kai)
    }

    func testWelcome() {
        snapshot("Welcome")
    }
    
    func testGameHistory() {
        self.app.buttons["mainMenu"].tap()
        self.app.buttons["mainMenuGameHistory"].waitAndTap()
        snapshot("gameHistory")
        self.app.buttons["gameHistoryClose"].waitAndTap()
    }
    
    func testSettings() {
        self.app.buttons["mainMenu"].tap()
        self.app.buttons["mainMenuSettings"].waitAndTap()
        snapshot("Settings")
        self.app.buttons["settingsClose"].waitAndTap()
    }
    
    func testPlaying() {
        self.app.buttons["mainMenu"].tap()
        self.app.buttons["mainMenuNewGame"].waitAndTap()

        snapshot("PlayerCards")

        self.playNextLane(user: "Dirk", strokes: 3, screenshot: "Stroke")
    }
    
    func OLDtestPlaying() {
        self.add(user: "Dirk")
        self.add(user: "Michael")
        self.add(user: "Kai")

        snapshot("PlayerCards")

        self.playNextLane(dirk: 2, michael: 1, kai: 2)
        
        self.playNextLane(user: "Dirk", strokes: 3, screenshot: "Stroke")

//        self.playNextLane(dirk: 3, michael: 3, kai: 2)
//        self.playNextLane(dirk: 1, michael: 1, kai: 1)
//        self.playNextLane(dirk: 4, michael: 3, kai: 5)
//        self.playNextLane(dirk: 2, michael: 2, kai: 1)
//        self.playNextLane(dirk: 4, michael: 4, kai: 3)
//        self.playNextLane(dirk: 2, michael: 1, kai: 2)
    }
}
