//
//  IosCore
//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import UIKit
import Presentation
import Kingfisher
import Additions

public protocol InputCommentDisplayable: class, ViewAdapting {
    func setup(placeholder: String, imageURL: URL?, maxCharacters limit: Int, cellPath: IndexPath, mentionsView: Any?)
    func showMentionsList(view: Any?)
    var inputStartAction: TapWithIndex? { get set }
    var path: IndexPath? { get set }
    var inputFinishedAction: Edit? { get set }
    var inputAction: EditWithFont? { get set }
    var inputActionForMention: EditAtPosition? { get set }
    var inputFinishedActionForMention: Edit? { get set }
}

public class CommentInputCell: UITableViewCell, Styleable {
    
    @IBOutlet var cellImageView: RoundedImageView!
    @IBOutlet public var cellTextView: PlaceholderTextView!
    @IBOutlet public var mentionsView: UIView!
    @IBOutlet public weak var mentionsViewHeightConstraint: NSLayoutConstraint!
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        applyStyle()
        selectionStyle = .none
        cellTextView.delegate = self
        cellTextView.isScrollEnabled = false
        accessibilityIdentifier = "CommentInputCell"
    }
    
    public override func prepareForReuse() {
        cellTextView.text = nil
        cellImageView.image = nil
    }
    
    public var inputFinishedAction: Edit?
    public var inputStartAction: TapWithIndex?
    public var inputAction: EditWithFont?
    public var inputActionForMention: EditAtPosition?
    public var inputFinishedActionForMention: Edit?
    public var dispatcher: Dispatching = Dispatcher()
    public var path: IndexPath?
    
    public var dataModel: DataModel? {
        didSet {
            cellTextView.placeholder = dataModel?.placeholder
            cellImageView.kf.setImage(with: dataModel?.imageURL)
            path = dataModel?.path
        }
    }
    
    public func applyStyle() {
        let style = styleProvider?.cells?.common.descriptionCell
        cellTextView.font = style?.placeholderTextView.font
        cellTextView.textColor = style?.placeholderTextView.color
        cellTextView.placeholderLabel.font = style?.placeholderTextView.placeholderLabel.font
        cellTextView.placeholderLabel.textColor = style?.placeholderTextView.placeholderLabel.color
        cellTextView.placeholderLabel.textAlignment = style?.placeholderTextView.placeholderTextAlignment ?? .left
        cellTextView.placeholderLabel.backgroundColor = style?.placeholderTextView.placeholderBackgroundColor
    }
    
    // MARK: -
    
    override public func becomeFirstResponder() -> Bool {
        return cellTextView.becomeFirstResponder()
    }
    
    override public var canBecomeFirstResponder: Bool {
        return true
    }
    
    var previousEdit: String? = nil
    
}

extension CommentInputCell: UITextViewDelegate {
    public func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if let indexPath = path {
            inputStartAction?(indexPath)
        }
         return true
    }
    
    public func textViewDidChange(_ textView: UITextView) {
        let text = textView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        inputAction?(FontCalculable(text: text, style: .normal))
        if let indexPath = path {
            inputStartAction?(indexPath)
        }
    }
    
    public func textViewDidEndEditing(_ textView: UITextView) {
        dispatcher.dispatchMain(after: 1, block: { [weak self] in
            self?.inputFinishedActionForMention?(textView.text)
        })
        guard let previousEdit = previousEdit else {
            guard textView.text.count > 0 else {
                return
            }
            return
        }
        guard previousEdit != textView.text else {
            return
        }
        self.previousEdit = textView.text
        inputFinishedAction?(textView.text)
        textView.text = nil
    }
    
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n" { 
            inputFinishedAction?(textView.text)
            textView.text = nil
            self.previousEdit = nil
            textView.resignFirstResponder()
            return false
        }
        
        if let charactersLimit = dataModel?.charactersLimit {
            let charactersCount = textView.text.count + (text.count - range.length)
            
            var caretPositionRectangle = CGRect(x: 0, y: 0, width: 0, height: 0)
            if let cursorPosition = textView.selectedTextRange?.start {
                caretPositionRectangle = textView.caretRect(for: cursorPosition)
            }
            
            inputActionForMention?(textView, range, text, caretPositionRectangle)
            return charactersCount <= charactersLimit
        }
        else {
            return true
        }
        
    }
}

public extension CommentInputCell {
    
    struct DataModel {
        let placeholder: String?
        let imageURL: URL?
        let charactersLimit: Int?
        let path: IndexPath
        
        public init(placeholder: String?, imageURL: URL?, charactersLimit: Int?, cellPath: IndexPath) {
            self.placeholder = placeholder
            self.imageURL = imageURL
            self.charactersLimit = charactersLimit
            self.path = cellPath
        }
        
    }
    
}
