//
//  UI
//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import UIKit

public class PlaceholderTextView: UITextView, Styleable {
    
    private var placeholderLabelConstraints: [NSLayoutConstraint] = []
    
    public let placeholderLabel: UILabel = UILabel()
    
    public var placeholder: String? {
        didSet {
            placeholderLabel.text = placeholder
        }
    }
    
    override public var text: String! {
        didSet {
            textDidChange()
        }
    }
    
    public override var accessibilityIdentifier: String?{
        get{
            return "PlaceholderTextView"
        }
        set{
            super.accessibilityIdentifier = newValue
        }
    }
    
    override public var attributedText: NSAttributedString! {
        didSet {
            textDidChange()
        }
    }
    
    override public var textContainerInset: UIEdgeInsets {
        didSet {
            updateConstraintsForPlaceholderLabel()
        }
    }
    
    
    override public init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        applyStyle()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        applyStyle()
    }
    
    public func applyStyle() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(textDidChange),
                                               name: UITextView.textDidChangeNotification,
                                               object: nil)
        
        let style = styleProvider?.controls?.placeholderTextView
        
        placeholderLabel.font = style?.placeholderLabel.font
        placeholderLabel.textColor = style?.placeholderLabel.color
        placeholderLabel.textAlignment = style?.placeholderTextAlignment ?? .left
        placeholderLabel.backgroundColor = style?.placeholderBackgroundColor
        
        placeholderLabel.text = placeholder
        placeholderLabel.numberOfLines = 0
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(placeholderLabel)
        updateConstraintsForPlaceholderLabel()
    }
    
    private func updateConstraintsForPlaceholderLabel() {
        var newConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(\(textContainerInset.left + textContainer.lineFragmentPadding))-[placeholder]",
            options: [],
            metrics: nil,
            views: ["placeholder": placeholderLabel])
        newConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-(\(textContainerInset.top))-[placeholder]",
            options: [],
            metrics: nil,
            views: ["placeholder": placeholderLabel])
        newConstraints.append(NSLayoutConstraint(
            item: placeholderLabel,
            attribute: .width,
            relatedBy: .equal,
            toItem: self,
            attribute: .width,
            multiplier: 1.0,
            constant: -(textContainerInset.left + textContainerInset.right + textContainer.lineFragmentPadding * 2.0)
        ))
        removeConstraints(placeholderLabelConstraints)
        addConstraints(newConstraints)
        placeholderLabelConstraints = newConstraints
    }
    
    @objc private func textDidChange() {
        placeholderLabel.isHidden = !text.isEmpty
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        placeholderLabel.preferredMaxLayoutWidth = textContainer.size.width - textContainer.lineFragmentPadding * 2.0
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self,
                                                  name: UITextView.textDidChangeNotification,
                                                  object: nil)
    }
    
}

