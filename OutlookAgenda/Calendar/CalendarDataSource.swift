import Foundation
import UIKit

class CalendarDataSource {
    
    struct Constants {
        /// define how many weeks supported
        static let previousWeeksCount: Int = 1
        static let afterWeeksCount: Int = 1
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
    
    init?() {

        allDaysCount = ( Constants.previousWeeksCount + 1 + Constants.afterWeeksCount ) * 7
        
        let weekday = gregorian.component(.weekday, from: Date())
        let previousDaysCount = Constants.previousWeeksCount * 7 + ( weekday - gregorian.firstWeekday + 7 ) % 7
        let firstDate = gregorian.date(byAdding: .day, value: -previousDaysCount, to: Date())
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
    
    func date(at index: Int) -> Date? {
        return gregorian.date(byAdding: .day, value: index, to: startDate)
    }
    
    func previousWeeksCount() -> Int {
        return Constants.previousWeeksCount
    }
}
