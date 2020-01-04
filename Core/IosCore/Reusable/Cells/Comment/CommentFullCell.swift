//
//  IosCore
//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import UIKit
import Presentation
import Kingfisher

public class CommentFullCell: BaseCommentCell, Styleable {
    
    @IBOutlet var leftImageView: RoundedImageView!
    @IBOutlet var descriptionLabel: ProfileExtrasLabel!
    @IBOutlet var rightButton: UIButton!
    @IBOutlet var bottomStackView: UIStackView!
    @IBOutlet var firstStackLabel: UILabel!
    @IBOutlet var firstStackButton: UIButton!
    @IBOutlet var secondStackButton: UIButton!
    
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        firstStackLabel.isHidden = true
        firstStackButton.isHidden = true
        secondStackButton.isHidden = true
        indentationWidth = 42
        
        let iconTap = UITapGestureRecognizer(target: self, action: #selector(tapImage(tap:)))        
        leftImageView.addGestureRecognizer(iconTap)
        leftImageView.isUserInteractionEnabled = true
    }
    
    
    override public func applyStyle() {
        super.applyStyle()
        let labelStyle = styleProvider?.cells?.comment.firstLabel
        let buttonStyle = styleProvider?.cells?.comment.secondLabel
        
        firstStackLabel.font = labelStyle?.font
        firstStackLabel.textColor = labelStyle?.color
        
        firstStackButton.setTitleColor(buttonStyle?.color, for: .normal)
        firstStackButton.titleLabel?.font = buttonStyle?.font
        
        secondStackButton.setTitleColor(buttonStyle?.color, for: .normal)
        secondStackButton.titleLabel?.font = buttonStyle?.font
        
        rightButton.tintColor = styleProvider?.controls?.primaryActionButton.activeFillColor
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layoutMargins.left = layoutMargins.left + CGFloat(indentationLevel) * indentationWidth
    }
    
    public func setupTime(_ text: String) {
        firstStackLabel.isHidden = false
        firstStackLabel.text = text        
    }
    
    public func setupLikes(_ text: String, path: IndexPath, action: @escaping TapWithIndex) {
        firstStackButton.isHidden = false
        firstStackButton.setTitle(text, for: .normal)
        firstStackButtonAction = action
    }
    
    public func setupReply(_ text: String, path: IndexPath, action: @escaping TapWithIndex) {
        secondStackButton.isHidden = false
        secondStackButton.setTitle(text, for: .normal)
        secondStackButtonAction = action
    }
    
    override func applyDataModel(_ model: DataModel) {
        super.applyDataModel(model)
        leftImageView.kf.setImage(with: model.imageURL)
        applyLikeIcon()
    }

   override func applyLikeIcon(){
        if let likeImage = likeImageName {
            rightButton.setImage(UIImage(named: likeImage), for: .normal)
        }
    }

    override func apply(info: PresentableInfo) {
        descriptionLabel.dataModel = ProfileExtrasLabel.DataModel(with: info, size: .small)
    }

    override func updatedRightModel(){
        rightButton.isEnabled = true
    }
    // MARK: - Button actions
    @IBAction func buttonRightAction(_ sender: Any) {
        guard let path = rightButtonModel?.path else { return }
        //is like action pressed than disable touch till API do not finish
        //when likeAPI finished than we have new buttonModel
        rightButton.isEnabled = false
        rightButtonModel?.action(path)
    }
    
    public var firstStackButtonAction: TapWithIndex? = nil {
        didSet {
            firstStackButton.isHidden = (firstStackButtonAction == nil) ? true : false
            firstStackButton.addTargetClosure { [weak self] (_) in
                guard let weakSelf = self, let table = weakSelf.superview as? UITableView, let indexPath = table.indexPath(for: weakSelf) else { return }
                self?.firstStackButtonAction?(indexPath)
            }
        }
    }
    
    public var secondStackButtonAction: TapWithIndex? = nil {
        didSet {
            secondStackButton.isHidden = (secondStackButtonAction == nil) ? true : false
            secondStackButton.addTargetClosure { [weak self] (_) in
                guard let weakSelf = self, let table = weakSelf.superview as? UITableView, let indexPath = table.indexPath(for: weakSelf) else { return }
                self?.secondStackButtonAction?(indexPath)
            }
        }
    }
    public var leftButtonModel: DataModelAuthor?
    
    @objc func tapLabel(tap: UITapGestureRecognizer) {
        guard let model = leftButtonModel,let userName = model.keyWordForPress,
            let range = descriptionLabel.text?.nsRange(of: userName),
            let path = model.path
            else { return }
        if tap.didTapAttributedText(in: descriptionLabel, targetRange: range) {
            model.action(path)
        } else {
            model.defaultAction(path)
        }
    }
    
    @objc func tapImage(tap: UITapGestureRecognizer) {
        guard let model = leftButtonModel,
            let path = model.path else { return }
        model.action(path)
    }
}
