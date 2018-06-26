import UIKit

extension UIView {
    
    @nonobjc public func viewWithAccessibilityIdentifier(_ accessibilityIdentifier: String) -> UIView? {
        return viewWithAccessibilityIdentifier(accessibilityIdentifier, classType: UIView.self)
    }
    
    @nonobjc public func viewWithAccessibilityIdentifier<T: UIView>(_ accessibilityIdentifier: String, classType: T.Type) -> T? {
        if let selfObject = self as? T, self.accessibilityIdentifier == accessibilityIdentifier {
            return selfObject
        }
        
        for subview in self.subviews {
            if let match = subview.viewWithAccessibilityIdentifier(accessibilityIdentifier, classType: classType) {
                return match
            }
        }
        
        return nil
    }
    
}
