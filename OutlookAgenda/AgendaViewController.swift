import UIKit

protocol AgendaViewControllerDelegate: class {
    func agendaViewControllerBeginDragging(on agendaViewController: AgendaViewController)
}

class AgendaViewController: UIViewController {

    weak var delegate: AgendaViewControllerDelegate?
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.accessibilityIdentifier = "tableView"
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.showsVerticalScrollIndicator = false
        
        tableView.register(AgendaTableViewCell.self, forCellReuseIdentifier: AgendaTableViewCell.agendaTableViewCellIdentifier)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
}

// MARK: - Private

extension AgendaViewController {
    
    private func initView() {
        view.addSubview(tableView)
        NSLayoutConstraint.addEdgeInsetsConstraints(outerLayoutGuide: view, innerView: tableView, edgeInsets: .zero)
    }
}

extension AgendaViewController: UITableViewDataSource {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AgendaTableViewCell.agendaTableViewCellIdentifier, for: indexPath)
        
        return cell
    }
}

extension AgendaViewController: UITableViewDelegate {
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        delegate?.agendaViewControllerBeginDragging(on: self)
    }
}
