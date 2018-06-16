import UIKit

class CalendarHeaderView: UIView {

    lazy private var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.accessibilityIdentifier = "stackView"
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
//        stackView.spacing = Constants.MainStackViewItemSpace
//        stackView.layoutMargins = Constants.MainStackViewEdgeInsets
//        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
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
            label.backgroundColor = .red
            stackView.addArrangedSubview(label)
        }
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
