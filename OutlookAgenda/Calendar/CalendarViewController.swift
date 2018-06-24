import UIKit

protocol CalendarViewControllerDelegate: class {
    func calendarViewControllerBeginDragging(_ calendarViewController: CalendarViewController)
    func calendarViewController(_ calendarViewController: CalendarViewController, didSelect date: Date, at dateOrder: Int)
}

class CalendarViewController: UIViewController {
    
    struct Constants {
        static let calendarHeadViewHeiht: CGFloat = 30
        static let calendarRowHeight: CGFloat = 48
        static let collectionViewEdgeInset = UIEdgeInsets(top: 0, left: 0, bottom: calendarRowHeight * 3, right: 0)
    }
    
    weak var delegate: CalendarViewControllerDelegate?
    private let calendarDataSource: CalendarDataSource
    lazy private var currentSelectedOrder = calendarDataSource.todayOrder
    
    lazy private var headerView: CalendarHeaderView = {
        let headerView = CalendarHeaderView.init(frame: .zero)
        headerView.accessibilityIdentifier = "headerView"
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.backgroundColor = .white
        return headerView
    }()

    lazy var collectionView: UICollectionView = {
        // FIXME: we need to limit the previousWeeksCount to prevent the CGFloat multiplication overflow
        let layout = CalendarCollectionViewLayout(initialOffset: CGPoint(x: 0, y: CGFloat(calendarDataSource.previousWeeksCount()) * Constants.calendarRowHeight))
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
        collectionView.contentInset = Constants.collectionViewEdgeInset

        collectionView.register(CalendarCollectionViewCell.self, forCellWithReuseIdentifier: CalendarCollectionViewCell.calendarCellIdentifier)
        return collectionView
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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // MARK: - public

    func select(date: Date, at dateOrder: Int) {
        guard currentSelectedOrder != dateOrder else { return }
        
        updateVisibelCellsSelectedState(for: dateOrder)
        if !collectionView.isTracking {
            collectionView.scrollToItem(at: IndexPath(item: dateOrder, section: 0), at: .top, animated: true)
        }
    }
}

extension CalendarViewController {
    
    private func initView() {
        view.addSubview(headerView)
        NSLayoutConstraint.addEdgeInsetsConstraints(outerLayoutGuide: view, innerView: headerView, edgeInsets: .zero, rectEdge: [.top, .left, .right])
        headerView.heightAnchor.constraint(equalToConstant: Constants.calendarHeadViewHeiht).isActive = true

        view.addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
        NSLayoutConstraint.addEdgeInsetsConstraints(outerLayoutGuide: view, innerView: collectionView, edgeInsets: .zero, rectEdge: [.left, .bottom, .right])
    }
    
    private func updateVisibelCellsSelectedState(for newSelectedOrder: Int) {
        let newIndexPath = IndexPath(item: newSelectedOrder, section: 0)
        collectionView.indexPathsForVisibleItems.forEach() { visibileIndex in
            collectionView.cellForItem(at: visibileIndex)?.isSelected = (visibileIndex == newIndexPath)
        }
        currentSelectedOrder = newSelectedOrder
    }
}

extension CalendarViewController: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return calendarDataSource.allDaysCount
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CalendarCollectionViewCell.calendarCellIdentifier, for: indexPath) as! CalendarCollectionViewCell
        if let date = calendarDataSource.date(at: indexPath.item) {
            cell.load(date: date)
        }
        return cell
    }
}

extension CalendarViewController: UICollectionViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        delegate?.calendarViewControllerBeginDragging(self)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard collectionView == scrollView else { return }

        let offsetY = targetContentOffset.pointee.y
        guard offsetY > scrollView.contentInset.top, offsetY < (scrollView.contentSize.height - scrollView.bounds.size.height + scrollView.contentInset.bottom) else {
            return
        }
        let nearestRow = round( offsetY / Constants.calendarRowHeight )
        let alignedOffset = CGPoint(x: 0, y: nearestRow * Constants.calendarRowHeight)
        targetContentOffset.pointee = alignedOffset
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        updateVisibelCellsSelectedState(for: currentSelectedOrder)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        updateVisibelCellsSelectedState(for: indexPath.item)
        if let date = calendarDataSource.date(at: indexPath.item) {
            delegate?.calendarViewController(self, didSelect: date, at: indexPath.item)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.isSelected = (currentSelectedOrder == indexPath.item)
    }
}

extension CalendarViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 200
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: AgendaTableViewCell.reuseIdentifier, for: indexPath)
        
        return cell
    }
}
