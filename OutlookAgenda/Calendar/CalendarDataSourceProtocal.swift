import Foundation

protocol CalendarDataSourceProtocal: class {
    
    var allDaysCount: Int { get }  // the total count of all day
    var todayOrder: Int { get }    // the order numbuer from startDate, startDate is 0
    func date(at dateOrder: Int) -> Date?  // get the date at the index from first date
}
