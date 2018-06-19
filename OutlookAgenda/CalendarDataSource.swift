import Foundation
import UIKit

class CalendarDataSource {
    
    struct Constants {
        static let weeksCount = 1 * 2 // all weeks count before and after current week
    }
    private let gregorian: Calendar = {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone.current
        calendar.locale = Locale.current
        return calendar
    }()
    private let startDate: Date
    private let endDate: Date
    let allDaysCount: Int
    
    init?(previousWeeksCount: Int, afterWeeksCount: Int) {

        let weekday = gregorian.component(.weekday, from: Date())
        let previousDaysCount = previousWeeksCount * 7 + ( weekday - gregorian.firstWeekday + 7 ) % 7
        allDaysCount = ( previousDaysCount + 1 + afterWeeksCount ) * 7
        let firstDate = gregorian.date(byAdding: .day, value: previousDaysCount, to: Date())
        guard let tempFirstDate = firstDate else {
            return nil
        }
        startDate = tempFirstDate
        
        let lastDate = gregorian.date(byAdding: .day, value: allDaysCount - 1, to: startDate)
        guard let tempLastDate = lastDate else {
            return nil
        }
        endDate = tempLastDate
    }
    
    
}
