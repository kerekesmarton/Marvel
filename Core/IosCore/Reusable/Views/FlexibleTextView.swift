//
//  IosCore
//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import UIKit
import Presentation

final public class FlexibleTextView: UITextView, Styleable {
    
    public var didEdit: Edit?
    
    public func applyStyle() {
        
    }
    
    public var placeholder: String? {
        get { return loadedPlaceholderTextView?.text }
        set {
            placeholderTextView.text = newValue
            needsUpdateHeight = true
            setNeedsLayout()
        }
    }
    
    public private(set) lazy var placeholderTextView: UITextView = self.createPlaceholderTextView()
    public var maximumHeight: CGFloat = 120
    
    public lazy var textSize = CGSize.zero
    public private(set) var minimumHeight: CGFloat = 0.0 {
        didSet {
            if minimumHeight > maximumHeight {
                maximumHeight = minimumHeight
            }
        }
    }
    private var needsUpdateHeight = true
    
    private var loadedPlaceholderTextView: UITextView?
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }
    
    public func commonInit() {
        isScrollEnabled = false
        textContainer.heightTracksTextView = true
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = .byWordWrapping
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange(_:)),
                                               name: UITextView.textDidChangeNotification,object: self)
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        if needsUpdateHeight {
            calculateMinimumHeight()
            updateTextSize()
            needsUpdateHeight = false
        }
    }
    
    func createPlaceholderTextView() -> UITextView {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = true
        textView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        textView.isScrollEnabled = false
        textView.isUserInteractionEnabled = false
        textView.backgroundColor = .clear
        textView.textColor = #colorLiteral(red: 0.6571614146, green: 0.6571771502, blue: 0.6571686864, alpha: 1)
        textView.font = font
        textView.textContainer.lineFragmentPadding = textContainer.lineFragmentPadding
        textView.textContainerInset = textContainerInset
        textView.frame = bounds
        addSubview(textView)
        loadedPlaceholderTextView = textView
        return textView
    }
    
    func updatePlaceholderState() {
        loadedPlaceholderTextView?.isHidden = !text.isEmpty
    }
    
    func calculateMinimumHeight() {
        minimumHeight = calculateSize(for: placeholderTextView.attributedText).height
    }
    
    @objc func textDidChange(_ notification: Notification) {
        textDidChange()
    }
    
    func textDidChange() {
        didEdit?(text)
        updatePlaceholderState()
        needsUpdateHeight = true
        setNeedsLayout()
    }
    
    override public var text: String! {
        didSet { textDidChange() }
    }
    
    override public var attributedText: NSAttributedString! {
        didSet { textDidChange() }
    }
    
    override public var font: UIFont? {
        didSet { loadedPlaceholderTextView?.font = font }
    }
    
    override public var textContainerInset: UIEdgeInsets {
        didSet { loadedPlaceholderTextView?.textContainerInset = textContainerInset }
    }
    
    override public var intrinsicContentSize: CGSize {
        return textSize
    }
    
    func calculateSize(for string: NSAttributedString) -> CGSize {
        let horizontalInsets = textContainerInset.left + textContainerInset.right
        let verticalInsets = textContainerInset.top + textContainerInset.bottom
        let size = CGSize(width: frame.width - horizontalInsets,
                          height: UIView.layoutFittingExpandedSize.height)
        
        let boundingRect = string.boundingRect(with: size,
                                               options: [.usesLineFragmentOrigin,
                                                         .usesFontLeading],
                                               context: nil).integral
        var newSize = boundingRect.size
        newSize.width += horizontalInsets
        newSize.height += verticalInsets
        return newSize
    }
    
    func updateTextSize() {
        var newSize = calculateSize(for: attributedText)
        
        if newSize.height < minimumHeight {
            newSize.height = minimumHeight
        }
        if newSize.height <= maximumHeight {
            isScrollEnabled = false
        } else {
            newSize.height = maximumHeight
            isScrollEnabled = true
        }
        textSize = newSize
        invalidateIntrinsicContentSize()
        setNeedsLayout()
    }
    
    deinit { NotificationCenter.default.removeObserver(self) }
    
}

