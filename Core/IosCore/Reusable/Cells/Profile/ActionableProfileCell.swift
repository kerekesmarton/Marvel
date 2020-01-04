//
//  UI
//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import UIKit

public class ActionableProfileCell: UITableViewCell, Styleable {
    
    public override func awakeFromNib() {
        super.awakeFromNib()        
        applyStyle()
    }
    
    public func applyStyle() {
        primaryButton.isHidden = true
        secondaryButton.isHidden = true
        tertiaryButton.isHidden = true
    }
    
    @IBOutlet public var primaryButton: SecondaryActionButton!
    @IBOutlet public var secondaryButton: SecondaryActionButton!
    @IBOutlet public var tertiaryButton: SecondaryActionButton!
    @IBOutlet var secondaryWidthConstraint: NSLayoutConstraint!
    
    public var primaryAction: (() -> Void)? = nil {
        didSet {
            primaryButton.addTargetClosure { [weak self] (_) in
                self?.primaryAction?()
            }
        }
    }
    
    public var secondaryAction: (() -> Void)? = nil {
        didSet {
            secondaryButton.addTargetClosure { [weak self] (_) in
                self?.secondaryAction?()
            }
        }
    }
    
    public var thirdAction: (() -> Void)? = nil {
        didSet {
            tertiaryButton.addTargetClosure { [weak self] (_) in
                self?.thirdAction?()
            }
        }
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
    }
}
