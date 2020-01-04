//
//  UI
//  Copyright © 2018 mkerekes. All rights reserved.
//

import UIKit
import Presentation

public class TextFieldCell: UITableViewCell, Styleable {

    @IBOutlet var inputTitleLabel: UILabel!
    @IBOutlet var inputTextField: UITextField!
    @IBOutlet var inputErrorLabel: UILabel!
    @IBOutlet var keyline: UIView?
    @IBOutlet var separator: UIView?
    
    public var didEdit: Edit?
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        applyStyle()
        selectionStyle = .none
        inputErrorLabel.isHidden = true
        inputTextField.delegate = self
    }

    public override func becomeFirstResponder() -> Bool {
        return inputTextField.becomeFirstResponder()
    }
    
    public var dataModel: DataModel? {
        didSet {
            guard let dataModel = dataModel else { return }
            inputTextField.placeholder = dataModel.placeholder
            inputTitleLabel.text = dataModel.title
            switch dataModel.type {
            case .password:
                inputTextField.isSecureTextEntry = true
                inputTextField.keyboardType = .default
                inputTextField.autocorrectionType = .no
            case .email:
                inputTextField.keyboardType = .emailAddress
                inputTextField.autocorrectionType = .no
            case .name:
                inputTextField.keyboardType = .default
                inputTextField.autocorrectionType = .no
                inputTextField.autocapitalizationType = .words
                inputTextField.text = dataModel.content
            case .standard:
                inputTextField.autocorrectionType = .no
                inputTextField.autocapitalizationType = .sentences
                inputTextField.text = dataModel.content
            }
        }
    }

    public var errorModel: ErrorModel? {
        didSet {
            guard let model = errorModel else {
                inputErrorLabel.isHidden = true
                return
            }
            inputErrorLabel.isHidden = false
            inputErrorLabel.text = model.title
        }
    }
    
    //MARK: - Stylable
    public func applyStyle() {
        let cellStyle = styleProvider?.cells?.common
        
        let inputTitleLabelStyle = cellStyle?.detailLabel
        inputTitleLabel.font = inputTitleLabelStyle?.font
        inputTitleLabel.textColor = inputTitleLabelStyle?.color
        
        let inputTextFieldStyle = cellStyle?.titleLabel
        inputTextField.font = inputTextFieldStyle?.font
        inputTextField.textColor = inputTextFieldStyle?.color        
    }
}

public extension TextFieldCell {
    struct DataModel {
        let title: String?
        let content: String?
        let placeholder: String?
        let type:InputType
        
        public enum InputType: String {
            case email
            case password
            case name
            case standard
        }
        
        public init(title: String? = nil, placeholder: String? = nil, type: InputType, content: String? = nil) {
            self.title = title
            self.placeholder = placeholder
            self.type = type
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

extension TextFieldCell: UITextFieldDelegate {

    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let text = textField.text, let stringRange = Range.init(range, in: text) else {
            didEdit?("")
            return true
        }
        let newText = text.replacingCharacters(in: stringRange, with: string)
        errorModel = nil
        didEdit?(newText)
        return true
    }
    
    public func textFieldShouldClear(_ textField: UITextField) -> Bool {
        errorModel = nil
        didEdit?("")        
        return true
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
