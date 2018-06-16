import UIKit

class ContainerViewController: UIViewController {
    
    struct Constants {
        static let calendarShortHeight: CGFloat = CalendarViewController.Constants.calendarHeadViewHeiht + CalendarViewController.Constants.calendarRowHeight * 2
        static let calendarTallHeight: CGFloat = CalendarViewController.Constants.calendarHeadViewHeiht + CalendarViewController.Constants.calendarRowHeight * 5
        
    }
    
    lazy private var calendarViewController: CalendarViewController = {
        let viewController = CalendarViewController()
        viewController.delegate = self
        return viewController
    }()
    
    lazy private var agendaViewController: AgendaViewController = {
        let viewController = AgendaViewController()
        viewController.delegate = self
        return viewController
    }()
    
    lazy var calendarViewControllerHeightConstraint = calendarViewController.view.heightAnchor.constraint(equalToConstant: Constants.calendarShortHeight)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
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
        calendarViewController.view.translatesAutoresizingMaskIntoConstraints = false
        calendarViewController.view.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        calendarViewController.view.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor).isActive = true
        calendarViewController.view.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor).isActive =  true
        calendarViewControllerHeightConstraint.isActive = true
        
        agendaViewController.view.backgroundColor = .green
        addChildViewController(agendaViewController, to: view)
        agendaViewController.view.translatesAutoresizingMaskIntoConstraints = false
        agendaViewController.view.topAnchor.constraint(equalTo: calendarViewController.view.bottomAnchor).isActive = true
        agendaViewController.view.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor).isActive = true
        agendaViewController.view.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor).isActive =  true
        agendaViewController.view.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
}

// MARK: - CalendarViewControllerDelegate

extension ContainerViewController: CalendarViewControllerDelegate {
    
    func calendarViewControllerBeginDragging(on calendarViewController: CalendarViewController) {
        guard Int(calendarViewController.view.bounds.size.height) != Int(Constants.calendarTallHeight)  else { return }
        
        view.layoutIfNeeded()
        UIView.animate(withDuration: 0.25) {
            self.calendarViewControllerHeightConstraint.constant = Constants.calendarTallHeight
            self.view.layoutIfNeeded()
        }
    }
}

// MARK: - AgendaViewControllerDelegate

extension ContainerViewController: AgendaViewControllerDelegate {
    
    func agendaViewControllerBeginDragging(on agendaViewController: AgendaViewController) {
        guard Int(calendarViewController.view.bounds.size.height) != Int(Constants.calendarShortHeight)  else { return }
        
        view.layoutIfNeeded()
        UIView.animate(withDuration: 0.25) {
            self.calendarViewControllerHeightConstraint.constant = Constants.calendarShortHeight
            self.view.layoutIfNeeded()
        }
    }
}

