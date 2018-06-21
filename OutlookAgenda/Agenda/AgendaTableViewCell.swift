import UIKit

class AgendaTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "AgendaTableViewCellReuseIdentifier"

    private lazy var timeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.accessibilityIdentifier = "timeStackView"
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        return stackView
    }()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.accessibilityIdentifier = "contentStackView"
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        return stackView
    }()
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.accessibilityIdentifier = "mainStackView"
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .top
        stackView.distribution = .fill
        return stackView
    }()
    
    private lazy var noEventsLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.accessibilityIdentifier = "noEventsLabel"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        return label
    }()
    
    private lazy var startDateLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.accessibilityIdentifier = "startDateLabel"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    private lazy var durationLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.accessibilityIdentifier = "durationLabel"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.accessibilityIdentifier = "titleLabel"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    private lazy var avatarsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.accessibilityIdentifier = "avatarsStackView"
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        return stackView
    }()
    
    private lazy var locationStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.accessibilityIdentifier = "locationStackView"
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        return stackView
    }()
    
    private lazy var locationLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.accessibilityIdentifier = "locationLabel"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .lightGray
        return label
    }()
    
    private lazy var locationImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "event_location"))
        return imageView
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .orange
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        [timeStackView, avatarsStackView, locationStackView, contentStackView, mainStackView].forEach { stackView in
            stackView.arrangedSubviews.forEach{ view in
                view.removeFromSuperview()
            }
            stackView.removeFromSuperview()
        }
    }
    
    func load(event: AgendaEvent?) {
        if let event = event {
            showEventView(event: event)
        } else {
            showNoEventView()
        }
    }
    
    private func showEventView(event: AgendaEvent) {
        contentView.addSubview(mainStackView)
        NSLayoutConstraint.addEdgeInsetsConstraints(outerLayoutGuide: contentView.safeAreaLayoutGuide, innerView: mainStackView)
        
        mainStackView.addArrangedSubview(timeStackView)
        mainStackView.addArrangedSubview(contentStackView)
        
        startDateLabel.text = "9:15 AM"
        timeStackView.addArrangedSubview(startDateLabel)
        durationLabel.text = "1h 30M"
        timeStackView.addArrangedSubview(durationLabel)
        
        contentStackView.addArrangedSubview(titleLabel)
        contentStackView.addArrangedSubview(avatarsStackView)
        contentStackView.addArrangedSubview(locationStackView)
        
//        avatarsStackView
        
        locationStackView.addArrangedSubview(locationImageView)
        locationStackView.addArrangedSubview(locationLabel)
    }
    
    private func showNoEventView() {
        contentView.addSubview(mainStackView)
        NSLayoutConstraint.addEdgeInsetsConstraints(outerLayoutGuide: contentView.safeAreaLayoutGuide, innerView: mainStackView)
        
        mainStackView.addArrangedSubview(noEventsLabel)
    }
}
