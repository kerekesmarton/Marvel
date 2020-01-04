
import Foundation
import UIKit

internal class TouchRespondScrollView: UIScrollView {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.delaysContentTouches = false
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.delaysContentTouches = false
    }
    
    override func touchesShouldCancel(in view: UIView) -> Bool {
        if view.isKind(of: UIButton.self) {
            return true
        }
        
        return super.touchesShouldCancel(in: view)
    }
}
