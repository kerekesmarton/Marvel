//
//  IosCore
//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import UIKit

final public class DoubleTitleView: UIStackView, Styleable {
    
    public var titleLabel: UILabel?
    public var detailLabel: UILabel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        axis = .vertical
        distribution = .fillProportionally
        
        let titleLabel = UILabel()
        insertArrangedSubview(titleLabel, at: 0)
        self.titleLabel = titleLabel
        
        let detailLabel = UILabel()
        self.insertArrangedSubview(detailLabel, at: 1)
        self.detailLabel = detailLabel
        
        applyStyle()
    }
    
    public func applyStyle() {
        titleLabel?.textAlignment = .left
        titleLabel?.textColor = styleProvider?.navigation?.standard.titleLabel.color
        titleLabel?.font = styleProvider?.navigation?.standard.titleLabel.font
        titleLabel?.sizeToFit()
        
        detailLabel?.textAlignment = .left
        detailLabel?.textColor = styleProvider?.navigation?.standard.titleLabel.color
        detailLabel?.font = styleProvider?.navigation?.standard.titleLabel.font
        detailLabel?.sizeToFit()
    }
    
    override public func sizeThatFits(_ size: CGSize) -> CGSize {
        let titleWidth = self.titleLabel?.sizeThatFits(size).width
        let detailWidth = self.detailLabel?.sizeThatFits(size).width
        return CGSize(width: CGFloat(ceilf(Float(max(titleWidth!, detailWidth!)))), height: size.height)
    }
    
}
