import UIKit

// Helper methods
extension UIViewController {
    
    public func showView() {
        assert(view != nil, "Loaded view, but it's nil!")
        if view.frame.size.width <= 0 || view.frame.size.height <= 0 {
            view.frame = CGRect(x: 0, y: 0, width: 320, height: 500)
        }
        
        loadViewIfNeeded()
        
        updateViewConstraints()
        for child in childViewControllers {
            child.updateViewConstraints()
        }
        
        viewWillLayoutSubviews()
        for child in childViewControllers {
            child.viewWillLayoutSubviews()
        }
        
        view.setNeedsLayout()
        view.layoutIfNeeded()
        for child in childViewControllers {
            child.view.setNeedsLayout()
            child.view.layoutIfNeeded()
        }
        
        viewDidLayoutSubviews()
        for child in childViewControllers {
            child.viewDidLayoutSubviews()
        }
        
        viewWillAppear(false)
        for child in childViewControllers {
            child.viewWillAppear(false)
        }
        
        viewDidAppear(false)
        for child in childViewControllers {
            child.viewDidAppear(false)
        }
    }
    
    public func navigationItemCustomView(withIdentifier identifier: String) -> UIView? {
        for item in (navigationItem.rightBarButtonItems ?? []) + (navigationItem.leftBarButtonItems ?? []) {
            let customView = item.customView
            if customView?.accessibilityIdentifier == identifier {
                return customView
            }
        }
        if navigationItem.titleView?.accessibilityIdentifier == identifier {
            return navigationItem.titleView
        }
        return nil
    }
    
    public var navigationTitleView: UIView? {
        return navigationItem.titleView
    }
    
}
