//
//  IosCore
//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import UIKit
import Presentation

public class CommentLiteCell: BaseCommentCell, Styleable {
    
    //MARK: - Properties
    public var leftButtonModel: DataModelAuthor?
    
    //MARK: - IBOutles
    @IBOutlet var descriptionLabel: ProfileExtrasLabel!
    @IBOutlet var rightButton: UIButton!
    
    
    //MARK: - IBActions
    @IBAction func buttonRightAction(_ sender: Any) {
        guard let path = rightButtonModel?.path else {
            return
        }
        //is like action pressed than disable touch till API do not finish
        //when likeAPI finished than we have new buttonModel
        rightButton.isEnabled = false
        rightButtonModel?.action(path)
        
    }
    
    @IBAction func fakeButtonActionOnAuthorName(_ sender: Any) {
        guard let path = leftButtonModel?.path else { return }
        leftButtonModel?.action(path)
    }
    
    
    //MARK: - Lifecycle methods
    override func apply(info: PresentableInfo) {
        descriptionLabel.dataModel = ProfileExtrasLabel.DataModel(with: info, size: .small)
    }

    override func applyLikeIcon(){
        if let likeImage = likeImageName {
            rightButton.setImage(UIImage(named: likeImage), for: .normal)
        }
    }

    // MARK: - Button actions
    override func updatedRightModel(){
        rightButton.isEnabled = true
    }
    
    
    //MARK: - Styleable implementation
    override public func applyStyle() {
        super.applyStyle()
        rightButton.tintColor = styleProvider?.controls?.primaryActionButton.activeFillColor
    }
    
}
