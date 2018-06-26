import UIKit

protocol CalendarViewControllerDelegate: class {
    func calendarViewControllerBeginDragging(_ calendarViewController: CalendarViewController)
    func calendarViewController(_ calendarViewController: CalendarViewController, didSelect dateOrder: Int)
}

class CalendarViewController: UIViewController {
    
    struct Constants {
        static let calendarHeadViewHeiht: CGFloat = 30
        static let calendarRowHeight: CGFloat = 48
        static let collectionViewEdgeInset = UIEdgeInsets(top: 0, left: 0, bottom: calendarRowHeight * 3, right: 0)
    }
    
    weak var delegate: CalendarViewControllerDelegate?
    private let calendarDataSource: CalendarDataSourceProtocal
    private lazy var monthLabelItems: [String: (monthLabel: UIView, offsetY: CGFloat, centerYConstraint: NSLayoutConstraint)] = [:]
    private var isScrollingCellToVisible = false
    
    lazy private var headerView: CalendarHeaderView = {
        let headerView = CalendarHeaderView.init(frame: .zero)
        headerView.accessibilityIdentifier = "headerView"
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.backgroundColor = .white
        return headerView
    }()

    lazy private var collectionView: UICollectionView = {
        let previousWeeksCount = calendarDataSource.todayOrder / 7
        let layout = CalendarCollectionViewLayout(initialOffset: CGPoint(x: 0, y: previousWeeksCount * Int(Constants.calendarRowHeight)))
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
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = .white
        collectionView.contentInset = Constants.collectionViewEdgeInset

        collectionView.register(CalendarCollectionViewCell.self, forCellWithReuseIdentifier: CalendarCollectionViewCell.calendarCellIdentifier)
        return collectionView
    }()

    lazy private var overlayView: UIView = {
        let view = UIView(frame: .zero)
        view.accessibilityIdentifier = "overLayView"
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = false
        view.clipsToBounds = true
        view.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        view.alpha = 0
        return view
    }()
    
    // MARK: - Lifecycle Methods
    
    init(calendarDataSource: CalendarDataSourceProtocal) {
        self.calendarDataSource = calendarDataSource
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        select(dateOrder: calendarDataSource.todayOrder)
    }
    
    // MARK: - public

    func select(dateOrder: Int) {
        guard dateOrder > 0, dateOrder < calendarDataSource.allDaysCount else { return }
        if let selectedIndexPaths = collectionView.indexPathsForSelectedItems, selectedIndexPaths.contains(dateOrder.indexPathForCalendar()) {
            return
        }
        
        collectionView.selectItem(at: dateOrder.indexPathForCalendar(), animated: false, scrollPosition: [])
        scrollSelectedItemIfNeed(at: dateOrder)
    }
}

extension CalendarViewController {
    
    private func shouldScrollSelectedCellToVisible(at dateOrder: Int) -> Bool {
        if collectionView.isTracking {
            return false
        }
        if isScrollingCellToVisible {
            return false
        }
        if dateOrder < 7 {
            return false
        }
        let cellOffsetY = dateOrder.itemOffsetY()
        if cellOffsetY > collectionView.contentOffset.y + Constants.calendarRowHeight + 1 || cellOffsetY < collectionView.contentOffset.y + Constants.calendarRowHeight - 1 {
            return true
        }
        
        return false
    }
    
    private func scrollSelectedItemIfNeed(at dateOrder: Int) {
        if shouldScrollSelectedCellToVisible(at: dateOrder) {
            isScrollingCellToVisible = true
            collectionView.scrollToItem(at: IndexPath(item: dateOrder - 7, section: 0), at: .top, animated: true)
        }
    }

    private func initView() {
        view.addSubview(headerView)
        NSLayoutConstraint.addEdgeInsetsConstraints(outerLayoutGuide: view, innerView: headerView, edgeInsets: .zero, rectEdge: [.top, .left, .right])
        headerView.heightAnchor.constraint(equalToConstant: Constants.calendarHeadViewHeiht).isActive = true

        view.addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
        NSLayoutConstraint.addEdgeInsetsConstraints(outerLayoutGuide: view, innerView: collectionView, edgeInsets: .zero, rectEdge: [.left, .bottom, .right])
        
        view.addSubview(overlayView)
        NSLayoutConstraint.addEdgeInsetsConstraints(outerLayoutGuide: view, innerView: overlayView, edgeInsets: UIEdgeInsets(top: Constants.calendarHeadViewHeiht, left: 0, bottom: 0, right: 0))
    }
    
    private func showOverlayView() {
        UIView.animate(withDuration: 0.25) {
            self.overlayView.alpha = 1
        }
    }
    
    private func hideOverlayView() {
        UIView.animate(withDuration: 0.25, animations: {
            self.overlayView.alpha = 0
        })
    }
    
    private func createMonthLabel(monthString: String) -> UILabel {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = monthString
        label.textColor = .black
        return label
    }
}

extension CalendarViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return calendarDataSource.allDaysCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CalendarCollectionViewCell.calendarCellIdentifier, for: indexPath)
        if let calendarCell = cell as? CalendarCollectionViewCell, let date = calendarDataSource.date(at: indexPath.item) {
            calendarCell.load(date: date)
        }
        return cell
    }
}

extension CalendarViewController: UICollectionViewDelegate {
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        isScrollingCellToVisible = false
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isScrollingCellToVisible = false
        delegate?.calendarViewControllerBeginDragging(self)
        showOverlayView()
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
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        hideOverlayView()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        scrollSelectedItemIfNeed(at: indexPath.item)
        delegate?.calendarViewController(self, didSelect: indexPath.item)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        var selectedIndexPaths = [calendarDataSource.todayOrder.indexPathForCalendar()]
        if let indexPaths = collectionView.indexPathsForSelectedItems, !indexPaths.isEmpty {
            selectedIndexPaths = indexPaths
        }
        cell.isSelected = selectedIndexPaths.contains(indexPath)
        
        // add month label on overlay, algin with the day 15th
        if let date = calendarDataSource.date(at: indexPath.item), date.day() == 15 {
            let monthString = date.monthStringForOverlay()
            let monthLabel = createMonthLabel(monthString: monthString)
            overlayView.addSubview(monthLabel)
            
            let cellCenterInOverlay = collectionView.convert(cell.center, to: overlayView)
            monthLabel.centerXAnchor.constraint(equalTo: overlayView.centerXAnchor).isActive = true
            let centerYConstraint = monthLabel.centerYAnchor.constraint(equalTo: overlayView.topAnchor, constant: cellCenterInOverlay.y)
            centerYConstraint.isActive = true
            monthLabelItems[monthString] = (monthLabel, cell.center.y, centerYConstraint)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        // remove month label outside
        if let date = calendarDataSource.date(at: indexPath.item), date.day() == 15 {
            let monthString = date.monthStringForOverlay()
            if let (monthLabel, _, _) = monthLabelItems[monthString] {
                monthLabel.removeFromSuperview()
            }
            monthLabelItems.removeValue(forKey: monthString)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let alpha = overlayView.backgroundColor?.cgColor.alpha, alpha > 0 {
            monthLabelItems.forEach { _, value in
                let currentOffsetY = overlayView.convert(CGPoint.zero, to: collectionView).y
                let (_, offsetY, centerYConstraint) = value
                centerYConstraint.constant = offsetY - currentOffsetY
            }
        }
    }
}

extension Int {
    fileprivate func itemOffsetY() -> CGFloat {
        let offsetY = (self / 7) * Int(CalendarViewController.Constants.calendarRowHeight)
        return CGFloat(offsetY)
    }
    
    fileprivate func indexPathForCalendar() -> IndexPath {
        return IndexPath(item: self, section: 0)
    }
}
