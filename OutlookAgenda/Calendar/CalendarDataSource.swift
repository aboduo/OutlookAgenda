import Foundation
import UIKit

class CalendarDataSource: CalendarDataSourceProtocal {
    
    struct Constants {
        // define how many weeks supported
        static let previousWeeksCount: Int = 400
        static let afterWeeksCount: Int = 400
    }

    private let startDate: Date
    private let endDate: Date
    let allDaysCount: Int
    let todayOrder: Int
    
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
}
