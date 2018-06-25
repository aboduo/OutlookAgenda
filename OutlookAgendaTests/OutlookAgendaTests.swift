//
//  OutlookAgendaTests.swift
//  OutlookAgendaTests
//
//  Created by sheng on 2018/6/14.
//  Copyright © 2018 sheng. All rights reserved.
//

@testable import OutlookAgenda
import XCTest

class OutlookAgendaTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let agendaVC = AgendaViewController(calendarDataSource: CalendarDataSource(calendar: CalendarCalculator.calendar)!, eventsDataSource: AgendaEventsDataSource())
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
