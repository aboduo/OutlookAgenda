import Foundation
import UIKit

class CalendarDataSource {
    
    struct Constants {
        // define how many weeks supported
        static let previousWeeksCount: Int = 100
        static let afterWeeksCount: Int = 100
    }

    private let startDate: Date
    private let endDate: Date
    let allDaysCount: Int   // the total count of all day
    let todayOrder: Int     // the order numbuer from startDate, startDate is 0
    
    init?(calendar: Calendar) {

        allDaysCount = ( Constants.previousWeeksCount + 1 + Constants.afterWeeksCount ) * 7
        let today = Date().startOfDay()
        let weekday = today.weekday()
        let todayIndexInCurrentWeek = ( weekday - calendar.firstWeekday + 7 ) % 7
        todayOrder = Constants.previousWeeksCount * 7 + todayIndexInCurrentWeek
        let previousDaysCount = Constants.previousWeeksCount * 7 + todayIndexInCurrentWeek
        let firstDate = today.add(days: -previousDaysCount)
        guard let tempFirstDate = firstDate else {
            return nil
        }
        startDate = tempFirstDate
        
        let lastDate = startDate.add(days: allDaysCount - 1)
        guard let tempLastDate = lastDate else {
            return nil
        }
        endDate = tempLastDate
    }
    
    func date(at dateOrder: Int) -> Date? {
        return startDate.add(days: dateOrder)
    }
    
    func previousWeeksCount() -> Int {
        return Constants.previousWeeksCount
    }
}
