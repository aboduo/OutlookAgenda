import Foundation
import UIKit

class AgendaTableSectionHeaderView: UITableViewHeaderFooterView {
    static let reuseIdentifier = "AgendaSectionHeaderViewReuseIndentifier"
    
    struct Constants {
        static let edgeInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
    }
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.accessibilityIdentifier = "stackView"
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        return stackView
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.accessibilityIdentifier = "dateLabel"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .darkGray
        label.textAlignment = .left
        return label
    }()
    
    private lazy var weatherImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.accessibilityIdentifier = "weatherImageView"
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
    
        addSubview(stackView)
        NSLayoutConstraint.addEdgeInsetsConstraints(outerLayoutGuide: safeAreaLayoutGuide, innerView: stackView, edgeInsets: Constants.edgeInsets)
        
        dateLabel.setContentHuggingPriority(.defaultLow - 10, for: .horizontal)
        dateLabel.setContentCompressionResistancePriority(.defaultHigh - 10, for: .horizontal)
        stackView.addArrangedSubview(dateLabel)
        stackView.addArrangedSubview(weatherImageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        dateLabel.text = nil
        weatherImageView.image = nil
    }
    
    func load(date: Date) {
        dateLabel.textColor = date.isInToday() ? .blue : .lightGray
        dateLabel.text = date.dateStringForTableSectionHeader()
        
        let weatherImageName = WeatherDataSource.weather(at: date).weatherIco()
        weatherImageView.image = UIImage(named: weatherImageName)
    }
}

extension Date {
    fileprivate func dateStringForTableSectionHeader() -> String {
        var dateString = formatString(dateFormat: "EEEE, d MMMM")
        if isInToday() {
            dateString = "Today • \(dateString)"
        } else if isInYesterday() {
            dateString = "Yesterday • \(dateString)"
        } else if isInTomorrow() {
            dateString = "Tomorrow • \(dateString)"
        }
        
        if !isInCurrentYear() {
            dateString = "\(dateString) \(String( year() ))"
        }
        return dateString
    }
}
