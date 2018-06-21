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
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
    
        addSubview(stackView)
        NSLayoutConstraint.addEdgeInsetsConstraints(outerLayoutGuide: safeAreaLayoutGuide, innerView: stackView)
        
        stackView.addArrangedSubview(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
    }
    
    func load(date: Date) {
        let dateString = date.string(dateFormat: "EEEE, d MMMM")
        label.text = dateString
    }
}
