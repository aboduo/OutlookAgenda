import UIKit

protocol CalendarViewControllerDelegate: class {
    func calendarViewControllerBeginDragging(on calendarViewController: CalendarViewController)
}

class CalendarViewController: UIViewController {
    
    struct Constants {
        static let calendarHeadViewHeiht: CGFloat = 30
        static let calendarRowHeight: CGFloat = 48
    }
    
    weak var delegate: CalendarViewControllerDelegate?
    
    lazy private var headerView: CalendarHeaderView = {
        let headerView = CalendarHeaderView.init(frame: .zero)
        headerView.accessibilityIdentifier = "headerView"
        headerView.translatesAutoresizingMaskIntoConstraints = false
        return headerView
    }()

    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInsetReference = .fromSafeArea
        layout.itemSize = CGSize(width: UIScreen.main.bounds.size.width / 7, height: Constants.calendarRowHeight)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.accessibilityIdentifier = "collectionView"
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.scrollsToTop = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .white

        collectionView.register(CalendarCollectionViewCell.self, forCellWithReuseIdentifier: CalendarCollectionViewCell.calendarCellIdentifier)
        return collectionView
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.accessibilityIdentifier = "tableView"
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.showsVerticalScrollIndicator = false
        
        tableView.register(AgendaTableViewCell.self, forCellReuseIdentifier: AgendaTableViewCell.agendaTableViewCellIdentifier)
        return tableView
    }()
    
    private let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    private let dataSource: CalendarDataSource
    
    // MARK: - Lifecycle Methods
    
    init(calendarDataSource: CalendarDataSource) {
        self.dataSource = calendarDataSource
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        registerNotification()
        
        // At this point, the constraints do not act, so change the contentOffset of collectionView is not active.
        // There are some workarounds, I think this is easier one.
//        DispatchQueue.main.async {
//            self.collectionView.scrollToItem(at: IndexPath(item: 1000, section: 0), at: .top, animated: false)
//        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

}

extension CalendarViewController {
    
    private func initView() {
        view.addSubview(headerView)
        headerView.backgroundColor = .white
        NSLayoutConstraint.addEdgeInsetsConstraints(outerLayoutGuide: view, innerView: headerView, edgeInsets: .zero, rectEdge: [.top, .left, .right])
        headerView.heightAnchor.constraint(equalToConstant: Constants.calendarHeadViewHeiht).isActive = true

        view.addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
        NSLayoutConstraint.addEdgeInsetsConstraints(outerLayoutGuide: view, innerView: collectionView, edgeInsets: .zero, rectEdge: [.left, .bottom, .right])
        
//        view.addSubview(tableView)
//        tableView.backgroundColor = .brown
//        NSLayoutConstraint.addEdgeInsetsConstraints(outerLayoutGuide: view, innerView: tableView, edgeInsets: UIEdgeInsets(top: 0, left: 200, bottom: 0, right: 0))
        
    }
    
    private func registerNotification() {
        NotificationCenter.default.addObserver(forName: .NSCalendarDayChanged, object: self, queue: .main) { notification in
            print("\(notification)")
        }
    }
}

extension CalendarViewController: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.allDaysCount
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        print("collectionView indexPath = \(indexPath)")
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CalendarCollectionViewCell.calendarCellIdentifier, for: indexPath) as! CalendarCollectionViewCell
        if let date = dataSource.date(at: indexPath.item) {
            cell.load(date: date)
        }
        
        return cell
    }

}

extension CalendarViewController: UICollectionViewDelegate {
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        delegate?.calendarViewControllerBeginDragging(on: self)
    }
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        guard scrollView == collectionView else {
//            return
//        }
//
//        tableView.setContentOffset(scrollView.contentOffset, animated: false)
//    }
}

extension CalendarViewController: UITableViewDataSource {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 200
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        print("tableView indexPath = \(indexPath)")
        
        let cell = tableView.dequeueReusableCell(withIdentifier: AgendaTableViewCell.agendaTableViewCellIdentifier, for: indexPath)
        
        return cell
    }
}

extension CalendarViewController: UITableViewDelegate {

    
    
}

