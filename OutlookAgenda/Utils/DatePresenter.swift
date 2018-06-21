import Foundation

open class DatePresenter {
    static fileprivate let dateFormatter: DateFormatter = {
        var dateFormatter = DateFormatter()
        return dateFormatter
    }()
    
    static func string(from date: Date, dateFormat: String? = nil) -> String {
        if dateFormat != nil {
            dateFormatter.dateFormat = dateFormat
        }
        return dateFormatter.string(from: date)
    }
}

extension Date {
    public func string(dateFormat: String) -> String {
        return DatePresenter.string(from: self, dateFormat: dateFormat)
    }
    

}
