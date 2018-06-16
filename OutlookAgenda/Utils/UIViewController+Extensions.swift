import UIKit

extension UIViewController {
    public func addChildViewController(_ childViewController: UIViewController, to parentView: UIView) {
        addChildViewController(childViewController)
        parentView.addSubview(childViewController.view)
        childViewController.didMove(toParentViewController: self)
    }
 
    public func removeFromParentViewControllerAndParentView() {
        willMove(toParentViewController: nil)
        view.removeFromSuperview()
        removeFromParentViewController()
    }
}
