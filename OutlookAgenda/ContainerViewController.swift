import UIKit

class ContainerViewController: UIViewController {
    
    struct Constants {
        static let calendarShortHeight: CGFloat = CalendarViewController.Constants.calendarHeadViewHeiht + CalendarViewController.Constants.calendarRowHeight * 2
        static let calendarTallHeight: CGFloat = CalendarViewController.Constants.calendarHeadViewHeiht + CalendarViewController.Constants.calendarRowHeight * 5
    }
    
    private let calendarDataSource = CalendarDataSource(calendar: CalendarCalculator.calendar)
    
    lazy private var calendarViewController: CalendarViewController? = {
        guard let calendarDataSource = calendarDataSource else { return nil }
        
        let viewController = CalendarViewController(calendarDataSource: calendarDataSource)
        viewController.delegate = self
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        return viewController
    }()
    
    lazy private var agendaViewController: AgendaViewController? = {
        guard let calendarDataSource = calendarDataSource else { return nil }
        
        let viewController = AgendaViewController(calendarDataSource: calendarDataSource, eventsDataSource: AgendaEventsDataSource())
        viewController.delegate = self
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        return viewController
    }()
    
    lazy var agendaViewControllerTopConstraint: NSLayoutConstraint? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
}


// MARK: - Private

extension ContainerViewController {
    private func initView() {
        self.title = "Title"
        
        /// remove the bottom line of navigation bar
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
        
        addChildViewController(calendarVC, to: view)
        calendarVC.view.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        calendarVC.view.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor).isActive = true
        calendarVC.view.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor).isActive =  true
        calendarVC.view.heightAnchor.constraint(equalToConstant: Constants.calendarTallHeight).isActive = true
        
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
    
    func calendarViewControllerDidSelect(date: Date, at index: Int, on calendarViewController: CalendarViewController) {
        agendaViewController?.scroll(to: index)
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

