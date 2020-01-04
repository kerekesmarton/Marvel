//
//  IosCore
//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import UIKit

public class DetailInfoTableViewCell: UITableViewCell, Styleable {

    public enum CellType{
        case selection
        case none
    }
    
    public var type: CellType? {
        didSet {
            applyStyle()
        }
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        applyStyle()
    }
    
    public var didTap: (()-> Void)?
    @IBOutlet var separator: UIView?
    
    public func applyStyle() {
        let cellStyle = styleProvider?.cells?.common
        separator?.backgroundColor = cellStyle?.separatorColor
        separator?.frame = CGRect(x: 0, y: frame.maxY-1, width: frame.width, height: 1)
        let titleLabelStyle = cellStyle?.titleLabel
        textLabel?.font = titleLabelStyle?.font
        textLabel?.textColor = titleLabelStyle?.color
        
        let detailLabelStyle = cellStyle?.detailLabel
        detailTextLabel?.font = detailLabelStyle?.font
        detailTextLabel?.textColor = detailLabelStyle?.color
        
        guard let type = type else { accessoryView = nil
            return
        }
        
        switch type {
        case .selection:
            accessoryView = checkButton
        case .none:
            accessoryView = nil
        }
    }
    
    lazy var checkButton: UIButton = {
        let btn = SecondaryActionButton(frame: CGRect(x: 0, y: 0, width: 85, height: 24))
        btn.addTarget(self, action: #selector(tap(_:)), for: .touchUpInside)
        btn.imageView?.contentMode = .scaleAspectFill
        return btn
    }()
    
    public var detailTapClosure: ((Int) -> Void)?
    
    @IBAction func tap(_ sender: UIButton) {
        guard let table = superview as? UITableView, let indexPath = table.indexPath(for: self) else { return }
        
        detailTapClosure?(indexPath.row)
    }
    
    public var dataModel: DataModel? {
        didSet {
            textLabel?.text = dataModel?.title
            detailTextLabel?.text = dataModel?.detail
            layoutIfNeeded()
            
            if let selected = dataModel?.selected {
                type = .selection
                if selected {
                    let image = #imageLiteral(resourceName: "verified").withRenderingMode(.alwaysTemplate)
                    checkButton.setImage(image, for: .normal)
                    checkButton.tintColor = styleProvider?.controls?.primaryActionButton.activeFillColor
                } else {
                    let image = #imageLiteral(resourceName: "off").withRenderingMode(.alwaysTemplate)
                    checkButton.setImage(image, for: .normal)
                    checkButton.tintColor = styleProvider?.controls?.primaryActionButton.disabledFillColor
                }
            } else {
                type = DetailInfoTableViewCell.CellType.none
            }
        }
    }
}

extension DetailInfoTableViewCell {
    public struct DataModel {
        let title: String
        let detail: String
        let selected: Bool?
        public init(title: String, detail: String, selected: Bool? = nil) {
            self.title = title
            self.detail = detail
            self.selected = selected
        }
    }
}
