import Foundation

open class CalendarCalculator {
    
//    static var calendar = Calendar(identifier: .gregorian)
    static fileprivate var calendar = Calendar.autoupdatingCurrent
    static fileprivate var currentYear = CalendarCalculator.year(of: Date())
    
    static func set(local: Locale = .autoupdatingCurrent, timezone: TimeZone = .autoupdatingCurrent) {
        CalendarCalculator.calendar.locale = local
        CalendarCalculator.calendar.timeZone = timezone
    }
    
    static func shortStandaloneMonthSymbols() -> [String] {
        return calendar.shortStandaloneMonthSymbols
    }
    
    static func day(of date: Date) -> Int {
        return calendar.component(.day, from: date)
    }
    
    static func year(of date: Date) -> Int {
        return calendar.component(.year, from: date)
    }
    
    static func month(of date: Date) -> Int {
        return calendar.component(.month, from: date)
    }
    
    static func isDateInToday(_ date: Date) -> Bool {
        return calendar.isDateInToday(date)
    }
    
    static func isDateInYesterday(_ date: Date) -> Bool {
        return calendar.isDateInYesterday(date)
    }
    
    static func isDateInTomorrow(_ date: Date) -> Bool {
        return calendar.isDateInTomorrow(date)
    }
}

extension Date {
    public func day() -> Int {
        return CalendarCalculator.day(of: self)
    }
    
    public func year() -> Int {
        return CalendarCalculator.year(of: self)
    }
    
    public func month() -> Int {
        return CalendarCalculator.month(of: self)
    }
    
    public func isInCurrentYear() -> Bool {
        return year() == CalendarCalculator.currentYear
    }
    
    public func isInToday() -> Bool {
        return CalendarCalculator.isDateInToday(self)
    }
    
    public func isInYesterday() -> Bool {
        return CalendarCalculator.isDateInYesterday(self)
    }
    
    public func isInTomorrow() -> Bool {
        return CalendarCalculator.isDateInTomorrow(self)
    }
    
    public func shortStandaloneMonthSymbol() -> String {
        return CalendarCalculator.calendar.shortStandaloneMonthSymbols[ month() - 1 ]
    }
}
