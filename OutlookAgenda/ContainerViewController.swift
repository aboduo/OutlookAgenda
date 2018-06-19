import UIKit

class ContainerViewController: UIViewController {
    
    struct Constants {
        static let calendarShortHeight: CGFloat = CalendarViewController.Constants.calendarHeadViewHeiht + CalendarViewController.Constants.calendarRowHeight * 2
        static let calendarTallHeight: CGFloat = CalendarViewController.Constants.calendarHeadViewHeiht + CalendarViewController.Constants.calendarRowHeight * 5
        
    }
    
    lazy private var calendarViewController: CalendarViewController = {
        let viewController = CalendarViewController()
        viewController.delegate = self
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        return viewController
    }()
    
    lazy private var agendaViewController: AgendaViewController = {
        let viewController = AgendaViewController()
        viewController.delegate = self
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        return viewController
    }()
    
    lazy var agendaViewControllerTopConstraint = agendaViewController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.calendarShortHeight)
    
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
        
        let safeAreaLayoutGuide = view.safeAreaLayoutGuide
        
        calendarViewController.view.backgroundColor = .brown
        addChildViewController(calendarViewController, to: view)
        calendarViewController.view.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        calendarViewController.view.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor).isActive = true
        calendarViewController.view.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor).isActive =  true
        calendarViewController.view.heightAnchor.constraint(equalToConstant: Constants.calendarTallHeight).isActive = true
        
        agendaViewController.view.backgroundColor = .green
        addChildViewController(agendaViewController, to: view)
        agendaViewControllerTopConstraint.isActive = true
        agendaViewController.view.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor).isActive = true
        agendaViewController.view.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor).isActive =  true
        agendaViewController.view.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
}

// MARK: - CalendarViewControllerDelegate

extension ContainerViewController: CalendarViewControllerDelegate {
    
    func calendarViewControllerBeginDragging(on calendarViewController: CalendarViewController) {
        guard Int(agendaViewControllerTopConstraint.constant) != Int(Constants.calendarTallHeight)  else { return }
        
//        view.layoutIfNeeded()
        UIView.animate(withDuration: 0.15) {
            self.agendaViewControllerTopConstraint.constant = Constants.calendarTallHeight
            self.view.layoutIfNeeded()
        }
    }
}

// MARK: - AgendaViewControllerDelegate

extension ContainerViewController: AgendaViewControllerDelegate {
    
    func agendaViewControllerBeginDragging(on agendaViewController: AgendaViewController) {
        guard Int(agendaViewControllerTopConstraint.constant) != Int(Constants.calendarShortHeight)  else { return }
        
//        view.layoutIfNeeded()
        UIView.animate(withDuration: 0.15) {
            self.agendaViewControllerTopConstraint.constant = Constants.calendarShortHeight
            self.view.layoutIfNeeded()
        }
    }
}

extension ContainerViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

