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
    private let calendarDataSource: CalendarDataSourceProtocal
    private lazy var currentSelectedOrder = calendarDataSource.todayOrder
    private lazy var monthLabelItems: [String: (monthLabel: UIView, offsetY: CGFloat, centerYConstraint: NSLayoutConstraint)] = [:]
    
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
        view.backgroundColor = UIColor.white.withAlphaComponent(0)

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
    }
    
    // MARK: - public

    func select(date: Date, at dateOrder: Int) {
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
        
        view.addSubview(overlayView)
        NSLayoutConstraint.addEdgeInsetsConstraints(outerLayoutGuide: view, innerView: overlayView, edgeInsets: UIEdgeInsets(top: Constants.calendarHeadViewHeiht, left: 0, bottom: 0, right: 0))
    }
    
    private func updateVisibelCellsSelectedState(for newSelectedOrder: Int) {
        let newIndexPath = IndexPath(item: newSelectedOrder, section: 0)
        collectionView.indexPathsForVisibleItems.forEach { visibileIndex in
            collectionView.cellForItem(at: visibileIndex)?.isSelected = (visibileIndex == newIndexPath)
        }
        currentSelectedOrder = newSelectedOrder
    }
    
    private func showOverlayView() {
        overlayView.isHidden = false
        UIView.animate(withDuration: 0.25) {
            self.overlayView.backgroundColor = UIColor.white.withAlphaComponent(0.9)
            self.overlayView.subviews.forEach { view in
                if let monthLabel = view as? UILabel {
                    monthLabel.textColor = .black
                }
            }
        }
    }
    
    private func hideOverlayView() {
        UIView.animate(withDuration: 0.25, animations: {
            self.overlayView.backgroundColor = UIColor.white.withAlphaComponent(0)
            self.overlayView.subviews.forEach { view in
                if let monthLabel = view as? UILabel {
                    monthLabel.textColor = UIColor.black.withAlphaComponent(0)
                }
            }
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
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
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
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        updateVisibelCellsSelectedState(for: currentSelectedOrder)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        hideOverlayView()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        updateVisibelCellsSelectedState(for: indexPath.item)
        if let date = calendarDataSource.date(at: indexPath.item) {
            delegate?.calendarViewController(self, didSelect: date, at: indexPath.item)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.isSelected = (currentSelectedOrder == indexPath.item)
        
        if let date = calendarDataSource.date(at: indexPath.item), date.day() == 15 {
            let monthString = date.monthStringForOverlay()
            let monthLabel = createMonthLabel(monthString: monthString)
            if let alpha = overlayView.backgroundColor?.cgColor.alpha {
                monthLabel.textColor = UIColor.black.withAlphaComponent(alpha)
            }
            overlayView.addSubview(monthLabel)
            
            let cellCenterInOverlay = collectionView.convert(cell.center, to: overlayView)
            monthLabel.centerXAnchor.constraint(equalTo: overlayView.centerXAnchor).isActive = true
            let centerYConstraint = monthLabel.centerYAnchor.constraint(equalTo: overlayView.topAnchor, constant: cellCenterInOverlay.y)
            centerYConstraint.isActive = true
            monthLabelItems[monthString] = (monthLabel, cell.center.y, centerYConstraint)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
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
