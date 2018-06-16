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
        return headerView
    }()

    lazy private var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInsetReference = .fromSafeArea
        layout.itemSize = CGSize(width: UIScreen.main.bounds.size.width / 7, height: Constants.calendarRowHeight)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.accessibilityIdentifier = "collectionView"
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.scrollsToTop = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .white

        collectionView.register(CalendarCollectionViewCell.self, forCellWithReuseIdentifier: CalendarCollectionViewCell.calendarCellIdentifier)
        return collectionView
    }()
    
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }

    // MARK: - Navigation

}

extension CalendarViewController {
    
    private func initView() {
        view.addSubview(headerView)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.backgroundColor = .white
        NSLayoutConstraint.addEdgeInsetsConstraints(outerLayoutGuide: view, innerView: headerView, edgeInsets: .zero, rectEdge: [.top, .left, .right])
        headerView.heightAnchor.constraint(equalToConstant: Constants.calendarHeadViewHeiht).isActive = true

        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
        NSLayoutConstraint.addEdgeInsetsConstraints(outerLayoutGuide: view, innerView: collectionView, edgeInsets: .zero, rectEdge: [.left, .bottom, .right])
    }
}

extension CalendarViewController: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 200
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CalendarCollectionViewCell.calendarCellIdentifier, for: indexPath)
        
        return cell
    }

}

extension CalendarViewController: UICollectionViewDelegate {
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        delegate?.calendarViewControllerBeginDragging(on: self)
    }
}
