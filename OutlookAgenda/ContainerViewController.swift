import UIKit

class ContainerViewController: UIViewController {
    
    struct Constants {
        static let calendarHeadViewHeiht: CGFloat = 30
        static let calendarRowHeight: CGFloat = 48
        
    }
    
    lazy private var calendarViewController: CalendarViewController = {
        let viewController = CalendarViewController()
//        viewController.delegate = self
        return viewController
    }()
    
    lazy private var agendaViewController: AgendaViewController = {
        let viewController = AgendaViewController()
        //        viewController.delegate = self
        return viewController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
}


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
        let calendarViewHeight = CalendarViewController.Constants.calendarHeadViewHeiht + CalendarViewController.Constants.calendarRowHeight * 2
        calendarViewController.view.heightAnchor.constraint(equalToConstant: calendarViewHeight).isActive = true
        
        agendaViewController.view.backgroundColor = .green
        addChildViewController(agendaViewController, to: view)
        agendaViewController.view.translatesAutoresizingMaskIntoConstraints = false
        agendaViewController.view.topAnchor.constraint(equalTo: calendarViewController.view.bottomAnchor).isActive = true
        agendaViewController.view.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor).isActive = true
        agendaViewController.view.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor).isActive =  true
        agendaViewController.view.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
}
