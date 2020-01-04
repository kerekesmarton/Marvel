///
//  IosCore
//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import UIKit
import Presentation

public class BaseCommentCell: UITableViewCell {
    
    var likeImageName: String? {
        didSet {
            guard let _ = likeImageName else { return }
            applyLikeIcon()
        }
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        applyStyle()
        accessibilityIdentifier = "CommentCell"
    }
    
    public func applyStyle() {
        selectionStyle = .none
    }
    
    // MARK: -
    
    func applyDataModel(_ model: DataModel) {
        apply(info: model.info)
        likeImageName = (model.isLiked == true) ? "Like-active-comment" : "Like-normal-comment"
    }
    
    func applyLikeIcon() { }
    func apply(info: PresentableInfo) { }
    
    public var dataModel: DataModel? {
        didSet {
            guard let model = dataModel else { return }
            applyDataModel(model)
        }
    }
    
    func updatedRightModel(){}
    
    public var rightButtonModel: ButtonModel? {
        didSet {
            guard let model = rightButtonModel, let image = model.image else { return }
            likeImageName = image
            updatedRightModel()
        }
    }
}

public extension BaseCommentCell {
    struct ButtonModel {
        let title: String?
        let image: String?
        let path: IndexPath
        let action: TapWithIndex
        
        public init(title: String?, image: String?, cellPath: IndexPath, action: @escaping (_ path: IndexPath) -> Void) {
            self.title = title
            self.image = image
            self.path = cellPath
            self.action = action
        }
    }

    struct DataModelAuthor {
        let keyWordForPress: String?
        let path: IndexPath?
        let action: TapWithIndex
        let defaultAction: TapWithIndex
        
        public init(keyWordForPress: String,
                    cellPath: IndexPath,
                    action: @escaping (_ path: IndexPath) -> Void,
                    defaultAction: @escaping (_ path: IndexPath) -> Void) {
            self.keyWordForPress = keyWordForPress
            self.path = cellPath
            self.action = action
            self.defaultAction = defaultAction
        }
    }

    struct DataModel {
        let info: PresentableInfo
        let imageURL: URL?
        let isLiked: Bool
        
        public init(info: PresentableInfo, imageURL: URL?, isLiked: Bool) {
            self.info = info
            self.imageURL = imageURL
            self.isLiked = isLiked
        }
    }
}
