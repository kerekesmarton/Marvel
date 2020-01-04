//
//  UI
//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import UIKit

public class TableFooter: UITableViewCell {
    
    @IBOutlet var nextButton: UIButton!
    public typealias NextAction = () -> Void
    
    public var nextAction: NextAction?
    public var dataModel: DataModel? {
        didSet {
            guard let model = dataModel else { return }
            
            nextButton.isHidden = !model.isVisible
            nextButton.isEnabled = model.isEnabled
            nextButton.setTitle(model.title, for: .normal)
            guard let imageName = model.asset else { return }
            nextButton.setBackgroundImage(UIImage(named: imageName), for: .normal)
        }
    }
    @IBAction func didTap(_ sender: Any) {
        nextAction?()
    }
    
    public struct DataModel {
        let title: String?
        let asset: String?
        let isVisible: Bool
        let isEnabled: Bool
        
        public init(title: String?, asset: String?, isVisible: Bool, isEnabled: Bool) {
            self.title = title
            self.asset = asset
            self.isVisible = isVisible
            self.isEnabled = isEnabled
        }
    }
}
