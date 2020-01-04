//
//  UI
//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import UIKit

public class SecondaryActionButton: UIButton, Styleable {
    
    public var model: DataModel? {
        didSet { applyStyle() }
    }
    
    var style: ActionButtonStyle? {
        return styleProvider?.controls?.secondaryActionButton
    }
    
    public override var isEnabled: Bool {
        didSet { applyStyle() }
    }
    
    public func applyStyle() {
        layer.cornerRadius = style?.cornerRadius ?? 4
        layer.borderWidth = style?.borderWidth ?? 4
        titleLabel?.font = style?.font
        
        guard let model = model else { return }
        
        switch model {
        case .translucent(text: let title, image: let buttonImage):
            if let image = buttonImage {
                setImage(UIImage(named: image), for: .normal)
            }
            setTitle(title, for: .normal)
            setTitle(title, for: .disabled)
            setTitleColor(style?.activeFontColor, for: .normal)
            setTitleColor(style?.disabledFontColor, for: .disabled)
            tintColor = isEnabled ? style?.activeFontColor : style?.disabledFontColor
            backgroundColor = .clear
            layer.borderColor = isEnabled ? style?.activeBorderColor.cgColor : style?.disabledBorderColor.cgColor
        case .normal(text: let title, let buttonImage):
            if let image = buttonImage {
                setImage(UIImage(named: image), for: .normal)
            }
            backgroundColor = isEnabled ? style?.inactiveBackgroundColor : style?.disabledFillColor
            setTitleColor(style?.disabledFontColor, for: .normal)
            setTitleColor(style?.disabledFontColor, for: .disabled)
            tintColor = isEnabled ? style?.inactiveFillColor : style?.disabledFillColor
            layer.borderColor = isEnabled ? style?.disabledBorderColor.cgColor : style?.disabledBorderColor.cgColor
            setTitle(title, for: .normal)
            setTitle(title, for: .disabled)
           
        case .filled(text: let title, let buttonImage):
            if let image = buttonImage {
                setImage(UIImage(named: image), for: .normal)
            }            
            
            setTitle(title, for: .normal)
            setTitle(title, for: .disabled)
            
            setTitleColor(style?.activeFontFillColor, for: .normal)
            setTitleColor(style?.disabledFontFillColor, for: .disabled)
            
            tintColor = isEnabled ? style?.activeFontFillColor : style?.disabledFontFillColor
            backgroundColor = isEnabled ? style?.activeFillColor : style?.disabledFillColor
            
            layer.borderColor = isEnabled ? style?.activeFillColor.cgColor : style?.disabledFillColor.cgColor
        case .warning(text: let title):
            layer.borderColor = isEnabled ? style?.alertBorderColor.cgColor : style?.disabledFillColor.cgColor
            backgroundColor = isEnabled ? style?.alertBorderColor : style?.disabledFillColor
            setTitleColor(style?.activeBackgroundColor, for: .normal)
            setTitleColor(style?.activeBackgroundColor, for: .disabled)
            tintColor = isEnabled ? style?.alertBorderColor : style?.disabledFillColor
            setTitle(title, for: .normal)
            layer.borderColor = isEnabled ? style?.activeFillColor.cgColor : style?.disabledFillColor.cgColor
        }
    }
    
    public enum DataModel {
        case normal(text: String?, image: String?)
        case translucent(text: String?, image: String?)
        case filled(text: String?, image: String?)
        case warning(text: String)
    }
}

public class PrimaryActionButton: SecondaryActionButton {
    
    override var style: ActionButtonStyle? {
        return styleProvider?.controls?.primaryActionButton
    }
}
