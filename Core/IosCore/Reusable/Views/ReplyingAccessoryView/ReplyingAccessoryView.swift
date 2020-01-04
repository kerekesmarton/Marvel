//
//  UI
//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import UIKit
import Presentation
import Kingfisher

public class ReplyingAccessoryView: UIView, Styleable{
    
    public func applyStyle() {
        
        let style = styleProvider?.cells?.common.descriptionCell
        
        let separatoColor:UIColor = styleProvider?.list?.separatorStyle.backgroundColor ?? .clear
        midleView.addTopSeparator(color: separatoColor, height: 1, margins: 0)
        midleView.addBottomSeparator(color: separatoColor, height: 1, margins: 0)
        
        textView.font = style?.placeholderTextView.font
        textView.textColor = style?.placeholderTextView.color
        textView.placeholderLabel.font = style?.placeholderTextView.placeholderLabel.font
        textView.placeholderLabel.textColor = style?.placeholderTextView.placeholderLabel.color
        textView.placeholderLabel.textAlignment = style?.placeholderTextView.placeholderTextAlignment ?? .left
        textView.placeholderLabel.backgroundColor = style?.placeholderTextView.placeholderBackgroundColor
        
    }
    
    enum Constants {
        static let maxHeight: CGFloat = 167.0 + 55
        static let minHeight: CGFloat = 167.0
        
        static let paddingTop: CGFloat = 8.0
        static let paddingBottom: CGFloat = 8.0
    }
    
    @IBOutlet public weak var mentionsView: UIView!
    @IBOutlet weak var mentionsViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var textView: PlaceholderTextView!
    @IBOutlet weak var imageView: RoundedImageView!
    @IBOutlet weak var relyingToLabel: UILabel!
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var midleView: UIView!

    public var inputFinishedAction: Edit?
    
    public var inputAction: EditWithFont?
    
    public var inputActionForMention: EditAtPosition?
    
    public var resignAction: Tap?
    
    public var dataModel: DataModel? {
        didSet {
            textView.placeholder = dataModel?.placeholder ?? ""
            author = dataModel?.author ?? ""
            textView.text = previousEdit ?? ""
            let actionTittle = dataModel?.isNewComment ?? true ? "send_action".localised : "save_action".localised
            sendButton.setTitle(actionTittle, for: .normal)
            imageView.kf.setImage(with: dataModel?.imageURL)
        }
    }
    
    public var author: String = "" {
        didSet { updateReplyingTo() }
    }
    
    
    public var previousEdit:String?{
        didSet{ textView.text = previousEdit}
    }
    
    private var replyTo: String = ""

    //func update
    func updateReplyingTo(){
        if author.isEmpty {
            replyTo = ""
            topView.isHidden = true
            previousEdit = ""
        } else {
            replyTo = "Replying to " + author
            topView.isHidden = false
            previousEdit = "@" + author
        }
        textView.text = previousEdit
        relyingToLabel.text = replyTo
    }
    
    public func setEditing(_ isEdititng: Bool) {
        let actionTittle = isEdititng  ? "save_action".localised : "send_action".localised
        sendButton.setTitle(actionTittle, for: .normal)
        textView.becomeFirstResponder()
        let text = textView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        sendButton.isEnabled = text.count > 0
    }

    @IBAction func smileAction(_ sender: Any) {
        guard let button  = sender as? UIButton,
        let smile = button.titleLabel?.text else{ return}
        previousEdit = textView.text + smile
        textView.text = previousEdit
    }
    
    @IBAction func closeReplyToAction(_ sender: Any) {
        author = ""
    }
    @IBAction func sendButtonAction(_ sender: Any) {
        inputFinishedAction?(textView.text)
        setEditing(false)
        textViewDidEndEditing(textView)
        textView.resignFirstResponder()
    }
    
    public static func getInputView(target: UIViewController, text: String? = nil,
                                    placeholder: String? = "Add Comment...",
                                    action: Selector) -> ReplyingAccessoryView? {
        let nib = UINib(nibName: String(describing: ReplyingAccessoryView.self),
                        bundle: Bundle(for: ReplyingAccessoryView.self))

        if let view = nib.instantiate(withOwner: target, options: nil).first as?
            ReplyingAccessoryView {
            view.sendButton.addTarget(target, action: action, for: .touchUpInside)
            view.textView.delegate = view
            if text != nil, text?.isEmpty == false {
                view.textView.text = text
            }
            return view
        } else {
            return nil
        }
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        applyStyle()
        mentionsViewHeightConstraint.constant = 0
    }
    
    
    public override var intrinsicContentSize: CGSize {
        self.textView.isScrollEnabled = true
        let size = textView.sizeThatFits(CGSize(width: textView.frame.width, height: CGFloat(MAXFLOAT)))
        let totalHeight = size.height + Constants.paddingTop + Constants.paddingBottom
        if totalHeight <= Constants.maxHeight + mentionsViewHeightConstraint.constant {
            return CGSize(width: bounds.width, height: max(totalHeight, Constants.minHeight))
        } else {
            self.textView.isScrollEnabled = true
            return CGSize(width: bounds.width, height: Constants.maxHeight + mentionsViewHeightConstraint.constant)
        }
    }
    
    public func showMentionsList(view: UIView) {
        var frame = view.frame
        frame.origin.y = 0
        view.frame = frame
        mentionsViewHeightConstraint.constant = view.frame.height
        updateConstraints()
        layoutIfNeeded()
    }
}

extension ReplyingAccessoryView: UITextViewDelegate {
    public func textViewDidEndEditing(_ textView: UITextView) {
        guard !textView.text.isEmpty else { return }
        textView.text = nil
        previousEdit = ""
        author = ""
        resignAction?()
    }
    
    public func textViewDidChange(_ textView: UITextView) {
        invalidateIntrinsicContentSize()
        updateConstraints()
        let text = textView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        inputAction?(FontCalculable(text: text, style: .normal))
        sendButton.isEnabled = text.count > 0
    }
    
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        
        if let charactersLimit = dataModel?.charactersLimit {
            let charactersCount = textView.text.count + (text.count - range.length)
            inputActionForMention?(textView, range, text, CGRect(x: 0, y: 0, width: 0, height: 0))
            return charactersCount <= charactersLimit
        } else {
            return true
        }
    }
}

public extension ReplyingAccessoryView {
    struct DataModel {
        let placeholder: String?
        let imageURL: URL?
        let charactersLimit: Int?
        let author: String?
        
        let isNewComment:Bool
        public init(placeholder: String?, imageURL: URL?, charactersLimit: Int?, author: String?, isNewComment:Bool = true) {
            self.placeholder = placeholder
            self.imageURL = imageURL
            self.charactersLimit = charactersLimit
            self.author = author
            self.isNewComment = isNewComment
        }
    }
}
