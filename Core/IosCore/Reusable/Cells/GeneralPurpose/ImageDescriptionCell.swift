//
//  ImageDescriptionCell.swift
//  IosCore
//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import UIKit
import Domain
import Kingfisher

public class ImageDescriptionCell: UITableViewCell, Styleable {
    
    @IBOutlet public var cellImage: RoundedImageView!
    @IBOutlet public var cellLabel: UILabel!
    @IBOutlet public var cellDescriptionLabel: UILabel!
    
    public var dataModel: DataModel? {
        didSet {
            cellLabel.text = dataModel?.title
            cellDescriptionLabel.text = dataModel?.description
            if let imageURL = dataModel?.imageURL {
                cellImage.kf.setImage(with: URL(string: imageURL))
            }
            if let selected = dataModel?.selected, selected == true {
                setSelected(true, animated: false)
            }
        }
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        applyStyle()
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        imageView?.image = nil
    }
    
    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        accessoryType = selected ? .checkmark : .none
    }
    
    //MARK: - Stylable
    
    public func applyStyle() {
        let cellStyle = styleProvider?.cells?.common
        
        let titleLabelStyle = cellStyle?.titleLabel
        cellLabel.font = titleLabelStyle?.font
        cellLabel.textColor = titleLabelStyle?.color
        
        let detailLabelStyle = cellStyle?.detailLabel
        cellDescriptionLabel.font = detailLabelStyle?.font
        cellDescriptionLabel.textColor = detailLabelStyle?.color
    }
    
}

public extension ImageDescriptionCell {
    struct DataModel {
        let title: String?
        let description: String?
        let imageURL: String?
        let selected: Bool
        
        public init(title: String?, description: String?, imageURL: String?, selected: Bool) {
            self.title = title
            self.description = description
            self.imageURL = imageURL
            self.selected = selected
        }
    }
}
