//
//  UI
//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import UIKit

public class RoundedImageView: UIImageView, Styleable {
    
    public func applyStyle() {
        draw()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        applyStyle()
    }
    
    public override init(image: UIImage?) {
        super.init(image: image)
        applyStyle()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        applyStyle()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.size.width/2
    }
    
    func draw() {
        let style = styleProvider?.controls?.roundedImageView
        layer.masksToBounds = true
        layer.borderWidth = style?.borderWidth ?? 2
        layer.borderColor = style?.borderColor?.cgColor
        backgroundColor = style?.backgroundColor
    }
}
