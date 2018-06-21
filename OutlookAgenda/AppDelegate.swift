import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window =  UIWindow(frame: UIScreen.main.bounds)
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
        let containerViewController = ContainerViewController()
        containerViewController.tabBarItem = UITabBarItem.init(tabBarSystemItem: .contacts, tag: 1000)
        let navigationController = UINavigationController.init(rootViewController: containerViewController)
        let tabBarViewController = UITabBarController.init()
        tabBarViewController.viewControllers = [navigationController]
        
        // action on double tap TabBar
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(onDoubleTapTabBar(_:)))
        doubleTapGesture.numberOfTapsRequired = 2
        tabBarViewController.tabBar.addGestureRecognizer(doubleTapGesture)
        
        return tabBarViewController
    }
    
    @objc private func onDoubleTapTabBar(_ sender: UIGestureRecognizer) {
        // using x position of tap to detect which tab bar item is tapped
    }
}
