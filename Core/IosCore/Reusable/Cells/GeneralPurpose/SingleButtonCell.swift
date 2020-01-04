//
//  IosCore
//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import UIKit

public class SingleButtonCell: UITableViewCell, Styleable {
    
    public func applyStyle() {}
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        applyStyle()
    }
    
    @IBOutlet var button: PrimaryActionButton!
    public var didTap: (()-> Void)?
    
    @IBAction func buttonAction(_ sender: Any) {
        didTap?()
    }
    
    public var model: DataModel? {
        didSet {
            guard let model = model else {
                return
            }
            button.isEnabled = model.enabled
            button.model = SecondaryActionButton.DataModel.filled(text: model.title, image: nil)
        }
    }
    
    public struct DataModel {
        let title: String
        let enabled: Bool
        public init(title: String, enabled: Bool) {
            self.title = title
            self.enabled = enabled
        }
    }
}
