import Foundation

extension Date {
    func monthStringForOverlay() -> String {
        let dateFormat = isInCurrentYear() ? "MMMM" : "MMMM yyyy"
        return formatString(dateFormat: dateFormat)
    }
}
