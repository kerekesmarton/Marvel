///
//  IosCore
//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import UIKit


public class ActionButton: UIButton, Styleable {
   
    //MARK: - Properties
    public var style: ActionButtonStyle? {
        didSet {
            applyStyle()
        }
    }
    public override var isEnabled: Bool {
        didSet {
            applyStyle()
        }
    }
    public override var isSelected: Bool {
        didSet {
            applyStyle()
        }
    }
    public override var adjustsImageWhenHighlighted: Bool{
        get { return false }
        set {}
    }
    
    
    //MARK: - Constructor
    public init(withStyle style: ActionButtonStyle) {
        self.style = style
        super.init(frame: .zero)
        applyStyle()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        applyStyle()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        applyStyle()
    }
    
    
    //MARK: - Styleable
    public func applyStyle() {
        
        // Borders are not handled here
        guard let style = style else { return }
        titleLabel?.font = style.font
        
        setTitleColor(style.activeFontColor, for: .normal)
        setBackgroundColor(style.activeBackgroundColor, for: .normal)
        
        setTitleColor(style.selectedFontColor, for: .selected)
        setBackgroundColor(style.selectedBackgroundColor, for: .selected)
        
        setTitleColor(style.disabledFontColor, for: .disabled)
        setBackgroundColor(style.disabledBackgroundColor, for: .disabled)
        
        switch state {
        case .normal:
            tintColor = style.activeFontColor
        case .selected:
            tintColor = style.selectedFontColor
        case .disabled:
            tintColor = style.disabledFontColor
        default:
            tintColor = .clear
        }
       
    }
    
}
