import Foundation
import UIKit

class AgendaTableSectionHeaderView: UITableViewHeaderFooterView {
    static let reuseIdentifier = "AgendaSectionHeaderViewReuseIndentifier"
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.accessibilityIdentifier = "stackView"
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        return stackView
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel(frame: .zero)
        label.accessibilityIdentifier = "label"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
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
        NSLayoutConstraint.addEdgeInsetsConstraints(outerLayoutGuide: safeAreaLayoutGuide, innerView: stackView, edgeInsets: UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12))
        
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(weatherImageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
        weatherImageView.image = nil
    }
    
    func load(date: Date) {
        let dateString = date.string(dateFormat: "EEEE, d MMMM")
        label.text = dateString
        
        let weatherImageName = WeatherDataSource.weather(at: date).weatherIco()
        weatherImageView.image = UIImage(named: weatherImageName)
    }
}
