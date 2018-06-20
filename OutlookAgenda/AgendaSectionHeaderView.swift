import Foundation
import UIKit

class AgendaSectionHeaderView: UIView {
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.accessibilityIdentifier = "stackView"
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
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
    
    init(date: Date) {
        super.init(frame: .zero)
        
        addSubview(stackView)
        NSLayoutConstraint.addEdgeInsetsConstraints(outerLayoutGuide: safeAreaLayoutGuide, innerView: stackView)
        
        stackView.addArrangedSubview(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
