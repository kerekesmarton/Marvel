//
//  UI
//  Copyright © 2018 mkerekes. All rights reserved.
//

import UIKit

public class LabelCell: UITableViewCell, Styleable {

    @IBOutlet var headerLabel: UILabel!

    override public func awakeFromNib() {
        super.awakeFromNib()
        applyStyle()
        selectionStyle = .none
    }
    
    public var dataModel: DataModel? {
        didSet {
            headerLabel.text = dataModel?.headerTitle
        }
    }
    
    public func applyStyle() {
        let cellStyle = styleProvider?.cells?.common
        backgroundColor = cellStyle?.backgroundColor
        
        let inputTitleLabelStyle = cellStyle?.titleLabel
        headerLabel.font = inputTitleLabelStyle?.font
        headerLabel.textColor = inputTitleLabelStyle?.color
    }
}

public extension LabelCell {
    struct DataModel {
        let headerTitle: String
        public init(headerTitle: String) {
            self.headerTitle = headerTitle
        }
    }
}
