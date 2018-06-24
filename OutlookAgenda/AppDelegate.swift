import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private let containerViewController = ContainerViewController()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        if let window = self.window {
            window.rootViewController = createRootViewContoller()
            window.backgroundColor = .white
            window.makeKeyAndVisible()
        }
        return true
    }
}

extension AppDelegate {
    private func createRootViewContoller() -> UIViewController {
        containerViewController.tabBarItem = UITabBarItem.init(tabBarSystemItem: .contacts, tag: 1000)
        let navigationController = UINavigationController.init(rootViewController: containerViewController)
        let tabBarViewController = UITabBarController.init()
        tabBarViewController.viewControllers = [navigationController]
        
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(onTapTabBar(_:)))
        doubleTapGesture.numberOfTapsRequired = 1
        tabBarViewController.tabBar.addGestureRecognizer(doubleTapGesture)
        
        return tabBarViewController
    }
    
    @objc private func onTapTabBar(_ sender: UIGestureRecognizer) {
        /// using x position of tap to detect which tab bar item is tapped
        containerViewController.focusOnToday(gesture: sender)
    }
}
