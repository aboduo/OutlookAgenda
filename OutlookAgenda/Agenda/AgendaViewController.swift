import UIKit

protocol AgendaViewControllerDelegate: class {
    func agendaViewControllerBeginDragging(on agendaViewController: AgendaViewController)
}

class AgendaViewController: UIViewController {

    weak var delegate: AgendaViewControllerDelegate?
    private let calendarDataSource: CalendarDataSource
    
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.accessibilityIdentifier = "tableView"
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.showsVerticalScrollIndicator = false
        
        tableView.backgroundColor = .brown
        
        tableView.register(AgendaTableViewCell.self, forCellReuseIdentifier: AgendaTableViewCell.agendaTableViewCellIdentifier)
        return tableView
    }()
    
    // MARK: - Lifecycle Methods
    
    init(calendarDataSource: CalendarDataSource) {
        self.calendarDataSource = calendarDataSource
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        return calendarDataSource.allDaysCount
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
