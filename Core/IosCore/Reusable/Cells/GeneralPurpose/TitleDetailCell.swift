//
//  UI
//  Copyright © 2018 mkerekes. All rights reserved.
//

import UIKit
import Kingfisher

public class TitleDetailCell: UITableViewCell, Styleable {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var detailLabel: UILabel!
    @IBOutlet var masterImageView: UIImageView!
    @IBOutlet var separator: UIView?
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        masterImageView.image = nil
    }
    
    public var dataModel: DataModel? {
        didSet {
            titleLabel.text = dataModel?.title
            detailLabel.text = dataModel?.detail
        }
    }
    
    public var imageModel: ImageModel? {
        didSet {
            masterImageView.kf.setImage(with: imageModel?.image, placeholder: #imageLiteral(resourceName: "cover-ex"),
                                  options: [.transition(.fade(0.2))])
            
            if let rounded = imageModel?.rounded, rounded {
                masterImageView.layer.cornerRadius = 4.0
                masterImageView.clipsToBounds = true
            }
        }
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        applyStyle()
        selectionStyle = .none        
    }

    //MARK: - Stylable
    public func applyStyle() {
        let cellStyle = styleProvider?.cells?.common
        
        let titleLabelStyle = cellStyle?.titleLabel
        titleLabel.font = titleLabelStyle?.font
        titleLabel.textColor = titleLabelStyle?.color
        
        let detailLabelStyle = cellStyle?.detailLabel
        detailLabel.font = detailLabelStyle?.font
        detailLabel.textColor = detailLabelStyle?.color
        if let rounded = imageModel?.rounded, rounded {
            masterImageView.layer.cornerRadius = 4.0
        }
        separator?.backgroundColor = styleProvider?.cells?.common.separatorColor
    }
}

public extension TitleDetailCell {
    struct DataModel {
        let title: String
        let detail: String
        
        public init(title: String, detail: String) {
            self.title = title
            self.detail = detail
        }
    }
    
    struct ImageModel {
        let image: URL?
        let rounded: Bool?
        public init(_ image: URL, rounded: Bool?) {
            self.image = image
            self.rounded = rounded
        }
    }
}
