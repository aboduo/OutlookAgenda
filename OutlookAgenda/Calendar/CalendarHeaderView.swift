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
        
        let gregorian = NSCalendar(calendarIdentifier: .gregorian)
        let _ = gregorian?.veryShortWeekdaySymbols.map { weekDay in
            let label = createWeekLabel()
            label.text = weekDay
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
