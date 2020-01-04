//
//  UI
//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import UIKit
import Presentation

public class SwitchFieldCell: UITableViewCell {
    
    @IBOutlet var checkbox: UISwitch!
    @IBOutlet var label: UILabel!
    @IBOutlet var inputErrorLabel: UILabel!
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        inputErrorLabel.isHidden = true
        selectionStyle = .none
    }
    
    public var didEdit: Switch?
    
    public var dataModel: DataModel? {
        didSet {
            guard let model = dataModel else { return }
            label.text = model.title
        }
    }
    
    public var errorModel: ErrorModel? {
        didSet {
            guard let model = errorModel else {
                inputErrorLabel.isHidden = true
                return
            }
            inputErrorLabel.isHidden = false
            inputErrorLabel.text = model.title
        }
    }
    
    @IBAction func didChange(_ sender: Any) {
        didEdit?(checkbox.isOn)
        errorModel = nil
    }
    
    public struct DataModel {
        let title: String?
        
        public init(title: String?) {
            self.title = title
        }
    }
    
    public struct ErrorModel {
        let title: String?
        
        public init(title: String? = nil) {
            self.title = title
        }
    }
}
