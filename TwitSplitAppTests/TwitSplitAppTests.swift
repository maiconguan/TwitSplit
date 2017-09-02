//
//  TwitSplitAppTests.swift
//  TwitSplitAppTests
//
//  Created by khoa on 8/30/17.
//  Copyright © 2017 Mai Cong Uan. All rights reserved.
//

import XCTest
@testable import TwitSplitApp

class TwitSplitAppTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSplitMessage() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let message = "The        product    Tweeter    allows       users to post     short messages limited to 50     characters each. Sometimes, users get excited and write    messages longer than 50 characters.Instead of     rejecting these messages,     we would like     to add a new feature that will split the message into parts and send multiple messages on the user's behalf, all of them meeting the 50 character requirement."
        let results = String.splitMessage(message: message)
        
        if results == nil {
            
        }
        else if results?.count == 1 {
            XCTAssert((results?[0].length())! <= Contants.maxMessageLength)
        }
        else {
            for i in 0..<((results?.count)! - 1) {
                let currentLength = results?[i].length()

                XCTAssert(currentLength! <= Contants.maxMessageLength)
                
                let nextWords = results?[i + 1].characters.split(separator: " ").map(String.init)
                
                if (nextWords?.count)! > 1 {
                    let nextWordLength = nextWords?[1].length()
                    
                    XCTAssert(currentLength! + nextWordLength! + 1 > Contants.maxMessageLength) // +1 for blank
                }
            }
            
            XCTAssert((results?.last?.length())! <= Contants.maxMessageLength)
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
            
            String.splitMessage(message: "I can't beleive that Twitter now supports chunking my messages, so I don't have to do it myself.")
        }
    }
    
}
