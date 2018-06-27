import UIKit

class AgendaTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "AgendaTableViewCellReuseIdentifier"
    
    struct Constants {
        static let edgeInsets = UIEdgeInsets(top: 13, left: 13, bottom: 13, right: 13)
    }
    
    private lazy var timeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.accessibilityIdentifier = "timeStackView"
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.spacing = 4
        
        stackView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        return stackView
    }()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.accessibilityIdentifier = "contentStackView"
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.spacing = 7
        return stackView
    }()
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.accessibilityIdentifier = "mainStackView"
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .top
        stackView.distribution = .fill
        stackView.spacing = 15
        return stackView
    }()
    
    private lazy var noEventsLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.accessibilityIdentifier = "noEventsLabel"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        label.text = NSLocalizedString("No Events", comment: "No Events")
        return label
    }()
    
    private lazy var startDateLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.accessibilityIdentifier = "startDateLabel"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15)
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
    
    private lazy var eventTypeImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "point_events"))
        imageView.accessibilityIdentifier = "weatherImageView"
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.accessibilityIdentifier = "titleLabel"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentHuggingPriority(UILayoutPriority.defaultLow - 10, for: .horizontal)
        label.setContentCompressionResistancePriority(UILayoutPriority.defaultHigh - 10, for: .horizontal)
        label.numberOfLines = 2
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
        stackView.spacing = 5
        return stackView
    }()
    
    private lazy var locationStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.accessibilityIdentifier = "locationStackView"
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 5
        return stackView
    }()
    
    private lazy var locationLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.accessibilityIdentifier = "locationLabel"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentHuggingPriority(.defaultLow - 10, for: .horizontal)
        label.setContentCompressionResistancePriority(UILayoutPriority.defaultHigh - 10, for: .horizontal)
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        return label
    }()
    
    private lazy var locationImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "event_location"))
        return imageView
    }()

    override func prepareForReuse() {
        super.prepareForReuse()
        [timeStackView, avatarsStackView, locationStackView, contentStackView, mainStackView].forEach { stackView in
            stackView.arrangedSubviews.forEach { view in
                view.removeFromSuperview()
            }
            stackView.removeFromSuperview()
        }
    }
    
    func load(event: AgendaEvent?) {
        contentView.addSubview(mainStackView)
        NSLayoutConstraint.addEdgeInsetsConstraints(outerLayoutGuide: contentView, innerView: mainStackView, edgeInsets: Constants.edgeInsets, rectEdge: [.top, .left, .bottom])
        mainStackView.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -Constants.edgeInsets.right).isActive = true
        
        if let event = event {
            showEventView(event: event)
        } else {
            showNoEventView()
        }
    }
    
    private func showEventView(event: AgendaEvent) {
        mainStackView.addArrangedSubview(timeStackView)
        mainStackView.addArrangedSubview(eventTypeImageView)
        mainStackView.addArrangedSubview(contentStackView)
        
        if let startDate = event.dateInterval?.start {
            startDateLabel.text = startDate.formatString(dateFormat: "h:mm a")
            timeStackView.addArrangedSubview(startDateLabel)
        }
        if let timeInterval = event.dateInterval?.duration {
            durationLabel.text = timeInterval.format(using: [.hour, .minute])
            timeStackView.addArrangedSubview(durationLabel)
        }
        
        titleLabel.text = event.title ?? NSLocalizedString("Untitled", comment: "")
        contentStackView.addArrangedSubview(titleLabel)
        
        // TODO: need to limit the count of avatar
        if let participants = event.participants, participants.count > 0 {
            event.participants?.forEach { event in
                let avatarImageView = UIImageView(image: UIImage(named: event.avatar ?? "avatar_default"))
                avatarsStackView.addArrangedSubview(avatarImageView)
            }
            contentStackView.addArrangedSubview(avatarsStackView)
        }

        if let location = event.location, !location.isEmpty {
            locationLabel.text = location
            locationStackView.addArrangedSubview(locationImageView)
            locationStackView.addArrangedSubview(locationLabel)
            contentStackView.addArrangedSubview(locationStackView)
        }
    }
    
    private func showNoEventView() {
        mainStackView.addArrangedSubview(noEventsLabel)
    }
}

extension TimeInterval {
    
    func format(using units: NSCalendar.Unit) -> String? {
        
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = units
        formatter.unitsStyle = .abbreviated
        return formatter.string(from: self)
    }
}
