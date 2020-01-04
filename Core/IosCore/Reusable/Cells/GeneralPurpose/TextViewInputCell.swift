//
//  UI
//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import UIKit
import Presentation

public class TextViewInputCell: UITableViewCell, Styleable {
    
    @IBOutlet weak var textView: PlaceholderTextView!
    @IBOutlet weak var keyline: UIView?
    @IBOutlet var inputErrorLabel: UILabel?
    @IBOutlet var titleLabel: UILabel?
    
    public var sizeUpdateBlock: (() -> Void)?
    public var didEdit: Edit?
    
    public var dataModel: DataModel? {
        didSet {
            textView.placeholder = dataModel?.placeholder
            textView.text = dataModel?.content
            titleLabel?.text = dataModel?.title
            errorModel = nil
            guard let text = dataModel?.content else { return }
            clearButton.isHidden = text.isEmpty
        }
    }
    
    public var errorModel: ErrorModel? {
        didSet {
            guard let model = errorModel else {
                inputErrorLabel?.isHidden = true
                guard let label = inputErrorLabel else { return }
                sendSubviewToBack(label)
                return
            }
            inputErrorLabel?.isHidden = false
            inputErrorLabel?.text = model.title
            guard let label = inputErrorLabel else { return }
            bringSubviewToFront(label)
        }
    }
    
    @IBOutlet var clearButton: UIButton!
    override public func awakeFromNib() {
        super.awakeFromNib()
        textView.delegate = self
        applyStyle()
        
        clearButton.setImage(#imageLiteral(resourceName: "clearDelete"), for: .normal)
    }
    
    @IBAction func clearText(_ sender: Any) {
        let result = textView(textView, shouldChangeTextIn: NSRange(location: 0, length: textView.text.count), replacementText: "")
        if result {
            textView.text = ""
        }
    }
    
    public func applyStyle() {
        let cellStyle = styleProvider?.cells?.common
        
        let inputTitleLabelStyle = cellStyle?.detailLabel
        titleLabel?.font = inputTitleLabelStyle?.font
        titleLabel?.textColor = inputTitleLabelStyle?.color
        textView.placeholderLabel.textColor = inputTitleLabelStyle?.color
        
        let inputTextFieldStyle = cellStyle?.titleLabel
        textView.font = inputTextFieldStyle?.font
        textView.textColor = inputTextFieldStyle?.color
        textView.placeholderLabel.font = inputTextFieldStyle?.font        
    }
}

extension TextViewInputCell: UITextViewDelegate {
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text.contains("\n") {
            return false
        }
        let textViewString = textView.text! as NSString
        let string = textViewString.replacingCharacters(in: range, with: text)
        
        UIView.animate(withDuration: 0.1, animations: {
            textView.layoutSubviews()
        }) { (finished) in
            self.sizeUpdateBlock?()
        }
        clearButton.isHidden = string.isEmpty
        errorModel = nil
        didEdit?(string)
        return true
    }
}

public extension TextViewInputCell {
    struct DataModel {
        let title: String?
        let content: String?
        let placeholder: String?
        
        public init(title: String? = nil, placeholder: String? = nil, content: String? = nil) {
            self.title = title
            self.placeholder = placeholder
            self.content = content
        }
    }
    
    struct ErrorModel {
        let title: String?
        
        public init(title: String? = nil) {
            self.title = title
        }
    }
}

