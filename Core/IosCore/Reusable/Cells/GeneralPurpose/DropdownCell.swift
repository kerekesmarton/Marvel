///
//  IosCore
//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import Foundation
import Domain

public class DropdownCell: TextFieldCell {
    
    lazy var pickerView: UIPickerView? = {
        guard let dataModel = dropDownDataModel else {
            return nil
        }
        let picker = UIPickerView()
        picker.dataSource = self
        picker.delegate = self
        return picker
    }()
    
    public var dropDownDataModel: DropdownDataModel? {
        didSet {
            guard let dataModel = dropDownDataModel else { return }
            inputTextField.placeholder = dataModel.placeholder
            inputTitleLabel.text = dataModel.title
            inputTextField.autocorrectionType = .no
            inputTextField.autocapitalizationType = .sentences
            inputTextField.text = dataModel.content
            inputTextField.inputView = pickerView
            inputTextField.delegate = self            
        }
    }
}

extension DropdownCell {
    public struct DropdownDataModel {
        let title: String?
        let content: String?
        let placeholder: String?
        let allowedValues: [String]
        
        public init(title: String? = nil, placeholder: String? = nil, content: String? = nil, allowedValues: [String]) {
            self.title = title
            self.placeholder = placeholder
            self.allowedValues = allowedValues
            self.content = content
        }
    }
}

extension DropdownCell: UIPickerViewDataSource, UIPickerViewDelegate {
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        guard dropDownDataModel != nil else {
            return 0
        }
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard let dataModel = dropDownDataModel else {
            return 0
        }
        return dataModel.allowedValues.count
    }
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard let dataModel = dropDownDataModel else {
            return nil
        }
        return dataModel.allowedValues[row]
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let value = dropDownDataModel?.allowedValues[row] else {
            return
        }
        inputTextField.text = value        
        didEdit?(value)
    }
}

extension DropdownCell {
    public override func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
    
    public override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
