import UIKit

final class CalendarCollectionViewCell: UICollectionViewCell {
    
    static let calendarCellIdentifier = "calendarCellIdentifier"
    
    private lazy var bottomLineView: UIView = {
        let view = UIView.init(frame: .zero)
        view.accessibilityIdentifier = "bottomLineView"
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .gray
        return view
    }()

    var label: UILabel = {
        let label = UILabel(frame: .zero)
        label.accessibilityIdentifier = "label"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Lifecycle Methods
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.init(hex: 0xEDEDED)
        
        addSubview(bottomLineView)
        NSLayoutConstraint.addEdgeInsetsConstraints(outerLayoutGuide: self, innerView: bottomLineView, edgeInsets: .zero, rectEdge: [.left, .bottom, .right])
        bottomLineView.heightAnchor.constraint(equalToConstant: CGFloat(1) / UIScreen.main.scale).isActive = true
        
        addSubview(label)
        NSLayoutConstraint.addEdgeInsetsConstraints(outerLayoutGuide: self, innerView: label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("This subclass does not support NSCoding.")
    }
    
    
}
