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
    
    private var lastDateOrder: Int = 0
    private var lastFraction: CGFloat = 0
    private var isProgramScrollingRectToTop = false // prevent scrolling repeated
    
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
        
        view.setNeedsLayout()
        view.layoutIfNeeded()
        update(dateOrder: calendarDataSource.todayOrder)
    }
    
    // MARK: - public
    
    func update(dateOrder: Int, fraction: CGFloat = 0, ignoreFraction: Bool = true) {
        // TODO: we can add a back scroll animaiton when ignoreFraction
        let effectiveFraction = ignoreFraction ? 0 : fraction
        
        let lastLeftOrder = lastDateOrder
        let lastRightOrder = lastDateOrder + 1
        
        let currentLeftOrder = dateOrder
        let currentRightOrder = dateOrder + 1
        
        if let lastLeftCell = collectionView.cellForItem(at: lastLeftOrder.indexPathForCalendar()) as? CalendarCollectionViewCell {
            lastLeftCell.updateState(isSelected: false)
        }
        if let lastRigtCell = collectionView.cellForItem(at: lastRightOrder.indexPathForCalendar()) as? CalendarCollectionViewCell {
            lastRigtCell.updateState(isSelected: false)
        }
        
        if let leftCell = collectionView.cellForItem(at: currentLeftOrder.indexPathForCalendar()) as? CalendarCollectionViewCell {
            leftCell.updateState(isSelected: true, fraction: effectiveFraction)
        }
        if let rightCell = collectionView.cellForItem(at: currentRightOrder.indexPathForCalendar()) as? CalendarCollectionViewCell {
            rightCell.updateState(isSelected: true, fraction: effectiveFraction - 1)
        }
        lastDateOrder = dateOrder
        lastFraction = fraction

        if shouldProgramScrollToTop(for: dateOrder) {
            isProgramScrollingRectToTop = true
            collectionView.scrollToItem(at: IndexPath(item: dateOrder, section: 0), at: .top, animated: true)
        }
    }
}

extension CalendarViewController {
    
    // MARK: - Handle scrolling caused by Agenda

    private func shouldProgramScrollToTop(for dateOrder: Int) -> Bool {
        if isProgramScrollingRectToTop {
            return false
        }
        if collectionView.isTracking {
            return false
        }
        if dateOrder.itemMinY() < collectionView.contentOffset.y {
            return true
        }
        if (dateOrder + 1).itemMaxY() > collectionView.contentOffset.y + Constants.calendarRowHeight * 2 {
            return true
        }
        return false
    }
    
    // MARK: - InitView
    
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
    
    // MARK: - monthLabel Overlay
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
    
    private func addMonthLabel(for date: Date, at offset: CGPoint) {
        let monthString = date.monthStringForOverlay()
        let monthLabel = createMonthLabel(monthString: monthString)
        overlayView.addSubview(monthLabel)
        
        let offsetInOverlay = collectionView.convert(offset, to: overlayView)
        monthLabel.centerXAnchor.constraint(equalTo: overlayView.centerXAnchor).isActive = true
        let centerYConstraint = monthLabel.centerYAnchor.constraint(equalTo: overlayView.topAnchor, constant: offsetInOverlay.y)
        centerYConstraint.isActive = true
        monthLabelItems[monthString] = (monthLabel, offset.y, centerYConstraint)
    }
    
    private func removeMonthLabel(for date: Date) {
        let monthString = date.monthStringForOverlay()
        if let (monthLabel, _, _) = monthLabelItems[monthString] {
            monthLabel.removeFromSuperview()
        }
        monthLabelItems.removeValue(forKey: monthString)
    }
    
    private func updateMonthLabelPostion(currentOffset: CGPoint) {
        monthLabelItems.forEach { _, value in
            let (_, offsetY, centerYConstraint) = value
            centerYConstraint.constant = offsetY - currentOffset.y
        }
    }
    
    // MARK: - Aligned Offset
    
    private func alignedTargetContentOffset(for targetContentOffset: CGPoint, on scrollView: UIScrollView) -> CGPoint {
        let offsetY = targetContentOffset.y
        guard offsetY > scrollView.contentInset.top, offsetY < (scrollView.contentSize.height - scrollView.bounds.size.height + scrollView.contentInset.bottom) else {
            return targetContentOffset
        }
        let nearestRow = round( offsetY / Constants.calendarRowHeight )
        let alignedOffset = CGPoint(x: 0, y: nearestRow * Constants.calendarRowHeight)
        return alignedOffset
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
        isProgramScrollingRectToTop = false
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isProgramScrollingRectToTop = false
        delegate?.calendarViewControllerBeginDragging(self)
        showOverlayView()
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard collectionView == scrollView else { return }

        targetContentOffset.pointee = alignedTargetContentOffset(for: targetContentOffset.pointee, on: scrollView)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        hideOverlayView()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        update(dateOrder: indexPath.item)
        delegate?.calendarViewController(self, didSelect: indexPath.item)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == lastDateOrder || indexPath.item == (lastDateOrder + 1) {
            update(dateOrder: lastDateOrder, fraction: lastFraction, ignoreFraction: false)
        }
        
        if let date = calendarDataSource.date(at: indexPath.item), date.day() == 15 {
            addMonthLabel(for: date, at: cell.center)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if let date = calendarDataSource.date(at: indexPath.item), date.day() == 15 {
            removeMonthLabel(for: date)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let alpha = overlayView.backgroundColor?.cgColor.alpha, alpha > 0 {
            let currentOffset = overlayView.convert(CGPoint.zero, to: collectionView)
            updateMonthLabelPostion(currentOffset: currentOffset)
        }
    }
}

extension Int {
    fileprivate func itemMinY() -> CGFloat {
        let offsetY = (self / 7) * Int(CalendarViewController.Constants.calendarRowHeight)
        return CGFloat(offsetY)
    }
    
    fileprivate func itemMaxY() -> CGFloat {
        let offsetY = itemMinY() + CalendarViewController.Constants.calendarRowHeight
        return CGFloat(offsetY)
    }
    
    fileprivate func indexPathForCalendar() -> IndexPath {
        return IndexPath(item: self, section: 0)
    }
}
