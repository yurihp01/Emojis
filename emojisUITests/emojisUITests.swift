//
//  emojisUITests.swift
//  emojisUITests
//
//  Created by Yuri Pedroso on 05/04/21.
//

import XCTest

// MARK: - Class
class emojisUITests: XCTestCase {

    // MARK: - Variables
    let app = XCUIApplication()
    
    // MARK: - Override Functions
    override func setUpWithError() throws {
        app.launch()
        continueAfterFailure = false
    }
    
    // MARK: - Functions
    func testSearchAvatar() throws {
        let searchfield = app.searchFields.element(boundBy: 0)
        searchfield.tap()
        searchfield.typeText(Constants.searchBarText)
        app.staticTexts[Constants.searchButton].tap()
        
        XCTAssertTrue(searchfield.title.isEmpty, "Search textfield should be empty")
        sleep(5)
        
        app.buttons[Constants.avatarListButton].tap()
        
        let cellsCount = app.collectionViews[Constants.avatarList].cells.count
        let header = app.staticTexts[Constants.avatarHeader]
        
        XCTAssertTrue(header.exists, "Collection view header should exists")
        XCTAssertTrue(cellsCount > 0, "Cells count should be more than 0.")
    }
    
    func testSearchAvatarIsEmpty() throws {
        let searchfield = app.searchFields.element(boundBy: 0)

        app.staticTexts[Constants.searchButton].tap()
        XCTAssertTrue(app.staticTexts[Constants.searchBarError].exists, "Search button should shows a dialog with error message")
        
        app.buttons[Constants.okButton].tap()
        XCTAssertTrue(searchfield.title.isEmpty, "Search textfield should be empty")
    }
    
    func testEmojisList() throws {
        app.staticTexts[Constants.emojiListButton].tap()
        
        let cellsCount = app.collectionViews[Constants.emojiList].cells.count
                    
        XCTAssertTrue(cellsCount > 0, "Cells count must be more than 0.")
    }
    
    func testReposList() {
        
        let app = XCUIApplication()
        app.staticTexts[Constants.reposButton].tap()
        
        let _ = app.tables[Constants.reposList].waitForExistence(timeout: 5)

        scrolls(to: -6)
        scrolls(to: 6)

        existsText()
    }
    
    private func existsText() {
        let cellCount = app.tables[Constants.reposList].cells.count
        XCTAssertTrue(cellCount > 0, "This cell should be shown.")
    }
    
    private func scrolls(to value: Int) {
        existsText()
        let cell = app.tables[Constants.reposList].cells.firstMatch
        let start = app.tables[Constants.reposList].cells.firstMatch.coordinate(withNormalizedOffset: CGVector(dx: 0, dy: 0))
        let finish = cell.coordinate(withNormalizedOffset: CGVector(dx: 0, dy: value))
        start.press(forDuration: 0, thenDragTo: finish)
        
        sleep(2)
    }
    
}
