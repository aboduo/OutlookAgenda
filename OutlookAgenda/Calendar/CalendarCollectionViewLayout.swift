import UIKit

class CalendarCollectionViewLayout: UICollectionViewFlowLayout {
    
    private let initialOffset: CGPoint
    
    init(initialOffset: CGPoint) {
        self.initialOffset = initialOffset
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepare() {
        super.prepare()
        collectionView?.contentOffset = initialOffset
    }
}
