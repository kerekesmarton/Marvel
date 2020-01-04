//
//  IosCore
//
//  Copyright © 2019 Connectt. All rights reserved.
//

import UIKit
import Presentation

public class FullCommentCell: BaseCommentCell, Styleable {
    
    @IBOutlet var offsetView: UIView!
    @IBOutlet var offsetViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet var leftImageView: UIImageView!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var rightButton: UIButton!
    @IBOutlet var bottomStackView: UIStackView!
    @IBOutlet var firstStackLabel: UILabel!
    @IBOutlet var firstStackButton: UIButton!
    @IBOutlet var secondStackButton: UIButton!
    @IBOutlet var contentLabelBottomConstraint: NSLayoutConstraint!
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        firstStackLabel.isHidden = true
        firstStackButton.isHidden = true
        secondStackButton.isHidden = true
        contentLabelBottomConstraint.constant = 3
    }
    
    
    override public func applyStyle() {
        super.applyStyle()
        let cellStyle = styleProvider?.table?.cell
        let detailLabelStyle = cellStyle?.detailLabel
        
        firstStackButton.setTitleColor(detailLabelStyle?.color, for: .normal)
        firstStackButton.titleLabel?.font = detailLabelStyle?.font
        
        secondStackButton.setTitleColor(detailLabelStyle?.color, for: .normal)
        secondStackButton.titleLabel?.font = detailLabelStyle?.font
        
        firstStackLabel.font = detailLabelStyle?.font
        firstStackLabel.textColor = detailLabelStyle?.color
    }
    
    
    public var imageForCell: UIImage? {
        didSet {
            leftImageView.image = imageForCell
            leftImageView.layer.cornerRadius = leftImageView.frame.size.height/2
            leftImageView.clipsToBounds = true
        }
    }
    
    public func setImage(data: Data) {
        imageForCell = UIImage(data: data)
    }
    
    override func applyDataModel(_ model:DataModel) {
        super.applyDataModel(model)
        descriptionLabel.attributedText = attributedText
        applyLikeIcon()
        firstStackLabel.isHidden = (model.commentTime == nil) ? true : false
        firstStackLabel.text = model.commentTime
    }

   override func applyLikeIcon(){
        if let likeImage = likeImageName {
            rightButton.setImage(UIImage(named: likeImage), for: .normal)
        }
    }

    override func applyCommentAtibutedText(){
        descriptionLabel.attributedText = attributedText
    }

    // MARK: - Button actions
    @IBAction func buttonRightAction(_ sender: Any) {
        guard let path = rightButtonModel?.path else {
            return
        }
        rightButtonModel?.action(path)
    }
    
    public var firstStackButtonAction: (() -> Void)? = nil {
        didSet {
            firstStackButton.isHidden = (firstStackButtonAction == nil) ? true : false
            firstStackButton.addTargetClosure { [weak self] (_) in
                self?.firstStackButtonAction?()
            }
        }
    }
    
    public var secondStackButtonAction: (() -> Void)? = nil {
        didSet {
            secondStackButton.isHidden = (secondStackButtonAction == nil) ? true : false
            secondStackButton.addTargetClosure { [weak self] (_) in
                self?.secondStackButtonAction?()
            }
        }
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
    }
}
