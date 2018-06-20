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

    private lazy var monthLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.accessibilityIdentifier = "monthLabel"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        return label
    }()
    
    private lazy var dayLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.accessibilityIdentifier = "dayLabel"
        label.translatesAutoresizingMaskIntoConstraints = false
//        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        return label
    }()
    
    private lazy var yearLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.accessibilityIdentifier = "yearLabel"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.accessibilityIdentifier = "stackView"
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    
    private let dateFormatter: DateFormatter = {
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM"
        return dateFormatter
    }()
    
    // MARK: - Lifecycle Methods
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundView = UIView(frame: .zero)
        backgroundView?.backgroundColor = UIColor(hex: 0xEDEDED)
        
        selectedBackgroundView = UIView(frame: .zero)
        selectedBackgroundView?.backgroundColor = UIColor(hex: 0x0067A5)
        
        addSubview(stackView)
        NSLayoutConstraint.addEdgeInsetsConstraints(outerLayoutGuide: contentView, innerView: stackView)
        stackView.addArrangedSubview(monthLabel)
        stackView.addArrangedSubview(dayLabel)
        stackView.addArrangedSubview(yearLabel)
        
        addSubview(bottomLineView)
        NSLayoutConstraint.addEdgeInsetsConstraints(outerLayoutGuide: self, innerView: bottomLineView, edgeInsets: .zero, rectEdge: [.left, .bottom, .right])
        bottomLineView.heightAnchor.constraint(equalToConstant: CGFloat(1) / UIScreen.main.scale).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("This subclass does not support NSCoding.")
    }
    
    
    func load(date: Date) {
        
        if date.isInToday() {
            backgroundView?.backgroundColor = UIColor(hex: 0xE5E4E2)
        } else {
            let month = date.month()
            backgroundView?.backgroundColor = (month % 2 == 0) ? .white : .lightGray
        }
        
        let day = date.day()
        dayLabel.text = "\(day)"
        if day == 1 {
            monthLabel.isHidden = false
            monthLabel.text = date.shortStandaloneMonthSymbol()
        } else {
            monthLabel.isHidden = true
        }

        if !date.isInCurrentYear() && day == 1 {
            yearLabel.isHidden = false
            let year = date.year()
            yearLabel.text = "\(year)"
        } else {
            yearLabel.isHidden = true
        }   
    }
}
