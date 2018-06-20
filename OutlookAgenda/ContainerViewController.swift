import UIKit

class ContainerViewController: UIViewController {
    
    struct Constants {
        static let calendarShortHeight: CGFloat = CalendarViewController.Constants.calendarHeadViewHeiht + CalendarViewController.Constants.calendarRowHeight * 2
        static let calendarTallHeight: CGFloat = CalendarViewController.Constants.calendarHeadViewHeiht + CalendarViewController.Constants.calendarRowHeight * 5
        
        // define how many weeks supported
        static let previousWeeksCount: Int = 500
        static let afterWeeksCount: Int = 500
    }
    
    private let calendarDataSource = CalendarDataSource(previousWeeksCount: Constants.previousWeeksCount, afterWeeksCount: Constants.afterWeeksCount)
    
    lazy private var calendarViewController: CalendarViewController? = {
        guard let calendarDataSource = calendarDataSource else { return nil }
        
        let viewController = CalendarViewController(calendarDataSource: calendarDataSource)
        viewController.delegate = self
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        return viewController
    }()
    
    lazy private var agendaViewController: AgendaViewController? = {
        guard let calendarDataSource = calendarDataSource else { return nil }
        
        let viewController = AgendaViewController(calendarDataSource: calendarDataSource, agendaDataSource: AgendaDataSource())
        viewController.delegate = self
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        return viewController
    }()
    
    lazy var agendaViewControllerTopConstraint: NSLayoutConstraint? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        initView()
        
        
//        let gesture = calendarViewController.collectionView.panGestureRecognizer
//        calendarViewController.collectionView.removeGestureRecognizer(gesture)
//        agendaViewController.tableView.addGestureRecognizer(gesture)
        
//        gesture.addTarget(agendaViewController.tableView, action: #selector(handlePan(_:)))
    }
}


// MARK: - Private

extension ContainerViewController {
    private func initView() {
        self.title = "Title"
        
        // remove the bottom line of navigation bar
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        if let calendarVC = calendarViewController, let agendaVC = agendaViewController {
            showRightView(calendarVC: calendarVC, agendaVC: agendaVC)
        } else {
            showErrorView()
        }
    }
    
    private func showRightView(calendarVC: CalendarViewController, agendaVC: AgendaViewController) {
        let safeAreaLayoutGuide = view.safeAreaLayoutGuide
        
        calendarVC.view.backgroundColor = .brown
        addChildViewController(calendarVC, to: view)
        calendarVC.view.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        calendarVC.view.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor).isActive = true
        calendarVC.view.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor).isActive =  true
        calendarVC.view.heightAnchor.constraint(equalToConstant: Constants.calendarTallHeight).isActive = true
        
        agendaVC.view.backgroundColor = .green
        addChildViewController(agendaVC, to: view)
        agendaViewControllerTopConstraint = agendaVC.view.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: Constants.calendarShortHeight)
        agendaViewControllerTopConstraint?.isActive = true
        agendaVC.view.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor).isActive = true
        agendaVC.view.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor).isActive =  true
        agendaVC.view.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    // TODO: low priority, complete if have time
    private func showErrorView() {
        
    }
}

// MARK: - CalendarViewControllerDelegate

extension ContainerViewController: CalendarViewControllerDelegate {
    
    func calendarViewControllerBeginDragging(on calendarViewController: CalendarViewController) {
        guard let agendaViewControllerTopConstraint = agendaViewControllerTopConstraint, Int(agendaViewControllerTopConstraint.constant) != Int(Constants.calendarTallHeight) else {
            return
        }

        view.layoutIfNeeded()
        UIView.animate(withDuration: 0.15) {
            agendaViewControllerTopConstraint.constant = Constants.calendarTallHeight
            self.view.layoutIfNeeded()
        }
    }
}

// MARK: - AgendaViewControllerDelegate

extension ContainerViewController: AgendaViewControllerDelegate {
    
    func agendaViewControllerBeginDragging(on agendaViewController: AgendaViewController) {
        guard let agendaViewControllerTopConstraint = agendaViewControllerTopConstraint, Int(agendaViewControllerTopConstraint.constant) != Int(Constants.calendarShortHeight) else {
            return
        }
        
        view.layoutIfNeeded()
        UIView.animate(withDuration: 0.15) {
            agendaViewControllerTopConstraint.constant = Constants.calendarShortHeight
            self.view.layoutIfNeeded()
        }
    }
}

extension ContainerViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

