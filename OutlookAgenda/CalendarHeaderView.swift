import UIKit

class CalendarHeaderView: UIView {

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.accessibilityIdentifier = "stackView"
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private lazy var bottomLineView: UIView = {
        let view = UIView.init(frame: .zero)
        view.accessibilityIdentifier = "bottomLineView"
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .gray
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(stackView)
        NSLayoutConstraint.addEdgeInsetsConstraints(outerLayoutGuide: self, innerView: stackView, edgeInsets: .zero)
        
        /*
         if we use single char as the key of localizedString, such as: "S", which may impact others,
         so we can increase the key, such as: "S" -> "abbreviation of Sunday".
         And adding a item in the english Localizable.strings: "abbreviation of Sunday" = "S"
         */
        let weekDays = [NSLocalizedString("S", comment: "Sunday"),
                        NSLocalizedString("M", comment: "Monday"),
                        NSLocalizedString("T", comment: "Tuesday"),
                        NSLocalizedString("W", comment: "Wednesday"),
                        NSLocalizedString("T", comment: "Thursday"),
                        NSLocalizedString("F", comment: "Friday"),
                        NSLocalizedString("S", comment: "Saturday")]
        let _ = weekDays.map { day in
            let label = createWeekLabel()
            label.text = day
            stackView.addArrangedSubview(label)
        }
        
        addSubview(bottomLineView)
        NSLayoutConstraint.addEdgeInsetsConstraints(outerLayoutGuide: self, innerView: bottomLineView, edgeInsets: .zero, rectEdge: [.left, .bottom, .right])
        bottomLineView.heightAnchor.constraint(equalToConstant: CGFloat(1) / UIScreen.main.scale).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createWeekLabel() -> UILabel {
        let label = UILabel(frame: .zero)
        label.textColor = .lightGray
        label.textAlignment = .center
        return label
    }
}
