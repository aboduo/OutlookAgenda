import UIKit

extension UIColor {
    
    private struct Constants {
        static let hexScaleFactor: CGFloat = 255
    }
    
    
    public convenience init(hex hexValue: UInt32, withAlpha alpha: CGFloat = 1) {
        self.init(red: CGFloat((hexValue & 0xFF0000) >> 16) / Constants.hexScaleFactor,
                  green: CGFloat((hexValue & 0x00FF00) >> 8) / Constants.hexScaleFactor,
                  blue: CGFloat((hexValue & 0x0000FF)) / Constants.hexScaleFactor,
                  alpha: alpha)
    }
    
    
}

