import UIKit

protocol AgendaViewControllerDelegate: class {
    func agendaViewControllerBeginDragging(_ agendaViewController: AgendaViewController)
    func agendaViewController(_ agendaViewController: AgendaViewController, didScrollTo dateOrder: Int)
}

class AgendaViewController: UIViewController {
    
    struct Constants {
        static let tableViewHeaderHeight: CGFloat = 26
    }

    weak var delegate: AgendaViewControllerDelegate?
    private let calendarDataSource: CalendarDataSourceProtocal
    private let eventsDataSource: AgendaEventsDataSource
    private var isInitializeComplete = false
    private var shouldUpdateSelectedOrderAndNoticeDelegate = true /// If scroll is caused by CalendarViewController, then prevent notice CalendarViewController to update cyclically
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.accessibilityIdentifier = "tableView"
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.showsVerticalScrollIndicator = false
        tableView.sectionHeaderHeight = Constants.tableViewHeaderHeight
        
        tableView.register(AgendaTableViewCell.self, forCellReuseIdentifier: AgendaTableViewCell.reuseIdentifier)
        tableView.register(AgendaTableSectionHeaderView.self, forHeaderFooterViewReuseIdentifier: AgendaTableSectionHeaderView.reuseIdentifier)
        return tableView
    }()
    
    // MARK: - Lifecycle Methods
    
    init(calendarDataSource: CalendarDataSourceProtocal, eventsDataSource: AgendaEventsDataSource) {
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // calculate the initial offset of tableview is not acurrate in `viewDidLoad()` and `viewDidLayoutSubviews()`,
        // even call `view.layoutIfNeeded()` to enforce layout
        // so move the code to here, and using `isInitializeComplete` to make sure excute one time
        // If you know the reason, please tell me: szs121@163.com, thanks
        if !isInitializeComplete {
            scroll(to: calendarDataSource.todayOrder, animated: false)
            isInitializeComplete = true
        }
    }
    
    // MARK: - Public
    
    func scroll(to dateOrder: Int, animated: Bool = false) {
        guard dateOrder > 0, dateOrder < calendarDataSource.allDaysCount else { return }
        guard !tableView.isTracking else { return }
        
        shouldUpdateSelectedOrderAndNoticeDelegate = false
        let indexPath = IndexPath(row: 0, section: dateOrder)
        tableView.scrollToRow(at: indexPath, at: .top, animated: animated)
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return calendarDataSource.allDaysCount
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getEvents(at: section)?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let tableView = scrollView as? UITableView else { return }
        guard isInitializeComplete else { return }
        
        var offset = tableView.contentOffset
        offset.y += 1  // let the offset locate in the visible range
        if let indexPath = tableView.indexPathForRow(at: offset),
            shouldUpdateSelectedOrderAndNoticeDelegate {
            
            delegate?.agendaViewController(self, didScrollTo: indexPath.section)
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard let tableView = scrollView as? UITableView else { return }
        
        let targetOffset = targetContentOffset.pointee
        /// make sure offset is in the right range
        guard targetOffset.y >= 0, targetOffset.y <= scrollView.maxContentOffset().y else { return }
        let alignedOffset = tableView.alignedContentOffset(for: targetOffset)
        targetContentOffset.pointee = alignedOffset
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        shouldUpdateSelectedOrderAndNoticeDelegate = true
        delegate?.agendaViewControllerBeginDragging(self)
    }
        
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: AgendaTableSectionHeaderView.reuseIdentifier)
        if let agendaSectionHeaderView = headerView as? AgendaTableSectionHeaderView {
            let date = calendarDataSource.date(at: section) ?? Date()
            agendaSectionHeaderView.load(date: date)
        }
        return headerView
    }
}

extension UIScrollView {
    /// do not take care insets for easier
    fileprivate func maxContentOffset() -> CGPoint {
        return CGPoint(x: contentSize.width - bounds.size.width, y: contentSize.height - bounds.size.height)
    }
}

extension UITableView {
    /// just calculate vertical orientation
    fileprivate func alignedContentOffset(for originalContentOffset: CGPoint) -> CGPoint {
        /// just take care of section header,
        /// and if the row will disappear almost(only 10 px outside) then scroll to next
        var adjustOffset = originalContentOffset
        adjustOffset.y += (sectionHeaderHeight + 10 )
        let indexPath = indexPathForRow(at: adjustOffset)
        
        if let indexPath = indexPath {
            let rowRect = rectForRow(at: indexPath)
            let alignedContentOffsetY = rowRect.origin.y - sectionHeaderHeight
            return CGPoint(x: originalContentOffset.x, y: alignedContentOffsetY)
        }
        return originalContentOffset
    }
}
