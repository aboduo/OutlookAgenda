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
    lazy var calendarViewControllerHeightConstraint: NSLayoutConstraint? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        registerNotification()
    }
    
    public func focusOnToday(gesture: UIGestureRecognizer) {
        if let calendarDataSource = calendarDataSource {
            calendarViewController?.select(date: Date(), at: calendarDataSource.todayOrder)
            agendaViewController?.scroll(to: calendarDataSource.todayOrder, animated: true)
        }
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

        calendarViewControllerHeightConstraint = calendarVC.view.heightAnchor.constraint(equalToConstant: Constants.calendarShortHeight)
        calendarViewControllerHeightConstraint?.isActive = true
        
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
    
    private func registerNotification() {
        NotificationCenter.default.addObserver(forName: .NSCalendarDayChanged, object: self, queue: .main) { notification in
            print("\(notification)")
        }
    }
}

// MARK: - CalendarViewControllerDelegate

extension ContainerViewController: CalendarViewControllerDelegate {
    
    func calendarViewControllerBeginDragging(_ calendarViewController: CalendarViewController) {
        guard let agendaViewControllerTopConstraint = agendaViewControllerTopConstraint, Int(agendaViewControllerTopConstraint.constant) != Int(Constants.calendarTallHeight) else {
            return
        }

        view.layoutIfNeeded()
        UIView.animate(withDuration: 0.15) {
            agendaViewControllerTopConstraint.constant = Constants.calendarTallHeight
            self.view.layoutIfNeeded()
        }
        
        calendarViewControllerHeightConstraint?.constant = Constants.calendarTallHeight + CalendarViewController.Constants.collectionViewEdgeInset.bottom
    }
    
    func calendarViewController(_ calendarViewController: CalendarViewController, didSelect date: Date, at dateOrder: Int) {
        agendaViewController?.scroll(to: dateOrder, animated: true)
    }
}

// MARK: - AgendaViewControllerDelegate

extension ContainerViewController: AgendaViewControllerDelegate {
    
    func agendaViewControllerBeginDragging(_ agendaViewController: AgendaViewController) {
        guard let agendaViewControllerTopConstraint = agendaViewControllerTopConstraint, Int(agendaViewControllerTopConstraint.constant) != Int(Constants.calendarShortHeight) else {
            return
        }

        view.layoutIfNeeded()
        UIView.animate(withDuration: 0.15) {
            agendaViewControllerTopConstraint.constant = Constants.calendarShortHeight
            self.view.layoutIfNeeded()
        }
        
        calendarViewControllerHeightConstraint?.constant = Constants.calendarTallHeight
    }
    
    func agendaViewController(_ agendaViewController: AgendaViewController, didScrollTo date: Date, at dateOrder: Int) {
        calendarViewController?.select(date: date, at: dateOrder)
    }
}
