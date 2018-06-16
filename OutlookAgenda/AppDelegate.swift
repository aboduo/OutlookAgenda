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
        return tabBarViewController
    }
}
