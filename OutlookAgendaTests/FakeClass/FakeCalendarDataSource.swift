import Foundation
@testable import OutlookAgenda

class FakeCalendarDataSource: CalendarDataSourceProtocal {

    private let startDate: Date
    private let endDate: Date
    let allDaysCount: Int
    let todayOrder: Int // not updated real time, disorder when just pass 00:00 AM
    
    init?(calendar: Calendar, previousWeeksCount: Int, afterWeeksCount: Int) {
        
        allDaysCount = ( previousWeeksCount + 1 + afterWeeksCount ) * 7
        let today = Date().startOfDay()
        let weekday = today.weekday()
        let todayIndexInCurrentWeek = ( weekday - calendar.firstWeekday + 7 ) % 7
        todayOrder = previousWeeksCount * 7 + todayIndexInCurrentWeek
        let previousDaysCount = previousWeeksCount * 7 + todayIndexInCurrentWeek
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
