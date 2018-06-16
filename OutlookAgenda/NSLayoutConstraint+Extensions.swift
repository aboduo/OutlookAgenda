import UIKit

protocol UILayoutGuideProtocol {
    var leadingAnchor: NSLayoutXAxisAnchor { get }

    var trailingAnchor: NSLayoutXAxisAnchor { get }
    
    var leftAnchor: NSLayoutXAxisAnchor { get }
    
    var rightAnchor: NSLayoutXAxisAnchor { get }
    
    var topAnchor: NSLayoutYAxisAnchor { get }
    
    var bottomAnchor: NSLayoutYAxisAnchor { get }
    
    var widthAnchor: NSLayoutDimension { get }
    
    var heightAnchor: NSLayoutDimension { get }
    
    var centerXAnchor: NSLayoutXAxisAnchor { get }
    
    var centerYAnchor: NSLayoutYAxisAnchor { get }
}

extension UIView: UILayoutGuideProtocol {
    
}

extension UILayoutGuide: UILayoutGuideProtocol {
    
}

extension NSLayoutConstraint {
    
    @discardableResult
    static func addEdgeInsetsConstraints(outerLayoutGuide: UILayoutGuideProtocol, innerView: UIView, edgeInsets: UIEdgeInsets, rectEdge: UIRectEdge = .all) -> (topConstraint: NSLayoutConstraint?, leadingConstraint: NSLayoutConstraint?, bottomConstraint: NSLayoutConstraint?, trailingConstraint: NSLayoutConstraint?) {
        
        var topConstraint: NSLayoutConstraint?
        var leadingConstraint: NSLayoutConstraint?
        var bottomConstraint: NSLayoutConstraint?
        var trailingConstraint: NSLayoutConstraint?
        
        if rectEdge.contains(.top) {
            topConstraint = innerView.topAnchor.constraint(equalTo: outerLayoutGuide.topAnchor, constant: edgeInsets.top)
            topConstraint?.isActive = true
        }
        
        if rectEdge.contains(.left) {
            leadingConstraint = innerView.leadingAnchor.constraint(equalTo: outerLayoutGuide.leadingAnchor, constant: edgeInsets.left)
            leadingConstraint?.isActive = true
        }
        
        if rectEdge.contains(.bottom) {
            bottomConstraint = outerLayoutGuide.bottomAnchor.constraint(equalTo: innerView.bottomAnchor, constant: edgeInsets.bottom)
            bottomConstraint?.isActive = true
        }
        
        if rectEdge.contains(.right) {
            trailingConstraint = outerLayoutGuide.trailingAnchor.constraint(equalTo: innerView.trailingAnchor, constant: edgeInsets.right)
            trailingConstraint?.isActive = true
        }
        
        return (topConstraint, leadingConstraint, bottomConstraint, trailingConstraint)
    }
    
//    @discardableResult
//    static func addEdgeInsetsConstraints(outerView: UIView, innerView: UIView, edgeInsets: UIEdgeInsets, rectEdge: UIRectEdge = .all) -> (topConstraint: NSLayoutConstraint?, leadingConstraint: NSLayoutConstraint?, bottomConstraint: NSLayoutConstraint?, trailingConstraint: NSLayoutConstraint?) {
//        
//        var topConstraint: NSLayoutConstraint?
//        var leadingConstraint: NSLayoutConstraint?
//        var bottomConstraint: NSLayoutConstraint?
//        var trailingConstraint: NSLayoutConstraint?
//        
//        if rectEdge.contains(.top) {
//            topConstraint = innerView.topAnchor.constraint(equalTo: outerView.topAnchor, constant: edgeInsets.top)
//            topConstraint?.isActive = true
//        }
//        
//        if rectEdge.contains(.left) {
//            leadingConstraint = innerView.leadingAnchor.constraint(equalTo: outerView.leadingAnchor, constant: edgeInsets.left)
//            leadingConstraint?.isActive = true
//        }
//        
//        if rectEdge.contains(.bottom) {
//            bottomConstraint = outerView.bottomAnchor.constraint(equalTo: innerView.bottomAnchor, constant: edgeInsets.bottom)
//            bottomConstraint?.isActive = true
//        }
//        
//        if rectEdge.contains(.right) {
//            trailingConstraint = outerView.trailingAnchor.constraint(equalTo: innerView.trailingAnchor, constant: edgeInsets.right)
//            trailingConstraint?.isActive = true
//        }
//        
//        return (topConstraint, leadingConstraint, bottomConstraint, trailingConstraint)
//    }
}
