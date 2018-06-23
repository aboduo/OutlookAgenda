import Foundation
import UIKit

class CalendarDataSource {
    
    struct Constants {
        /// define how many weeks supported
        static let previousWeeksCount: Int = 3
        static let afterWeeksCount: Int = 10
    }

    private let startDate: Date
    private let endDate: Date
    let allDaysCount: Int
    
    init?(calendar: Calendar) {

        allDaysCount = ( Constants.previousWeeksCount + 1 + Constants.afterWeeksCount ) * 7
        let today = Date().startOfDay()
        let weekday = today.weekday()
        let previousDaysCount = Constants.previousWeeksCount * 7 + ( weekday - calendar.firstWeekday + 7 ) % 7
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
    
    func date(at index: Int) -> Date? {
        return startDate.add(days: index)
    }
    
    func previousWeeksCount() -> Int {
        return Constants.previousWeeksCount
    }
}
