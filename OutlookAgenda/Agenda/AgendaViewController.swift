import UIKit

protocol AgendaViewControllerDelegate: class {
    func agendaViewControllerBeginDragging(on agendaViewController: AgendaViewController)
}

class AgendaViewController: UIViewController {

    weak var delegate: AgendaViewControllerDelegate?
    private let calendarDataSource: CalendarDataSource
    private let eventsDataSource: AgendaEventsDataSource
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.accessibilityIdentifier = "tableView"
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.showsVerticalScrollIndicator = false
        tableView.sectionHeaderHeight = 26
        
        tableView.register(AgendaTableViewCell.self, forCellReuseIdentifier: AgendaTableViewCell.reuseIdentifier)
        tableView.register(AgendaTableSectionHeaderView.self, forHeaderFooterViewReuseIdentifier: AgendaTableSectionHeaderView.reuseIdentifier)
        return tableView
    }()
    
    // MARK: - Lifecycle Methods
    
    init(calendarDataSource: CalendarDataSource, eventsDataSource: AgendaEventsDataSource) {
        self.calendarDataSource = calendarDataSource
        self.eventsDataSource = eventsDataSource
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    // MARK: - Public
    func scroll(to section: Int) {
        let indexPath = IndexPath(row: 0, section: section)
        tableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }
}

// MARK: - Private

extension AgendaViewController {
    
    private func initView() {
        
        view.addSubview(tableView)
        NSLayoutConstraint.addEdgeInsetsConstraints(outerLayoutGuide: view, innerView: tableView, edgeInsets: .zero)
    }
    
    private func getEvents(at section: Int) -> [AgendaEvent]? {
        if let date = calendarDataSource.date(at: section), let events = eventsDataSource.agendaEvents(at: date) {
            return events
        }
        return nil
    }
}

extension AgendaViewController: UITableViewDataSource {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return calendarDataSource.allDaysCount
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getEvents(at: section)?.count ?? 1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AgendaTableViewCell.reuseIdentifier, for: indexPath)
        guard let agendaCell = cell as? AgendaTableViewCell  else {
            return cell
        }
        
        var event: AgendaEvent? = nil
        if let events = getEvents(at: indexPath.section), events.count > indexPath.row {
            event = events[indexPath.row]
        }
        agendaCell.load(event: event)
        return cell
    }
}

extension AgendaViewController: UITableViewDelegate {
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        delegate?.agendaViewControllerBeginDragging(on: self)
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: AgendaTableSectionHeaderView.reuseIdentifier)
        if let agendaSectionHeaderView = headerView as? AgendaTableSectionHeaderView {
            let date = calendarDataSource.date(at: section) ?? Date()
            agendaSectionHeaderView.load(date: date)
        }
        return headerView
    }
}
