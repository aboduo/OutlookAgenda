import UIKit

final class CalendarCell: UICollectionViewCell {
    
    static let calendarCellIdentifier = "calendarCellIdentifier"
    
    // MARK: - Lifecycle Methods
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .green
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("This subclass does not support NSCoding.")
    }
}
