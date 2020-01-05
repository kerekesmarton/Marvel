//
//  ConnecttApp
//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import UIKit
import Domain
import Presentation
import IosCore
import Data

public final class LoginViewController: ViewController {
    
    //MARK: - Properties
    var presenter: LoginPresenting?
    override public var state: PresentationOutputState? {
        didSet {
            guard let state = self.state else { return }
            switch state {
            case .disabled:
                loginButton.isEnabled = false
                removeActivityIndicator()
            case .enabled:
                loginButton.isEnabled = true
                removeActivityIndicator()
            case .loading:
                showActivityIndicatorOn(view)
            }
        }
    }
    private var separatorBackgroundColor: UIColor {
        return styleProvider?.list?.separatorStyle.backgroundColor ?? .clear
    }
    
    private var _inputUsernameAction: Edit?
    private var _inputPasswordAction: Edit?
    
    
    //MARK: - IBOutlets
    @IBOutlet private weak var logoImageView: UIImageView!
    @IBOutlet private weak var usernameTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var loginButton: PrimaryActionButton!
    @IBOutlet private weak var noAccountViewWrapper: UIView!
    @IBOutlet private weak var noAccountLabel: UILabel!
    @IBOutlet private weak var signUpButton: UIButton!

    //MARK: - IBActions
    @IBAction func loginAction(_ sender: UIButton) {
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        presenter?.save()
    }
    
    @IBAction func signUpAction() {
        presenter?.signUpPressed()
    }
    
    //MARK: - Lifecycle methods
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        presenter?.viewReady()        
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    public override func applyStyle() {
        super.applyStyle()
        
        logoImageView.image = #imageLiteral(resourceName: "General-logo")
    
        let titleLabel = styleProvider?.cells?.common.titleLabel
        usernameTextField.font = titleLabel?.font
        usernameTextField.textColor = titleLabel?.color
        passwordTextField.font = titleLabel?.font
        passwordTextField.textColor = titleLabel?.color
        
        loginButton.layer.cornerRadius = styleProvider?.controls?.primaryActionButton.cornerRadius ?? 4.0
        loginButton.layer.borderWidth = styleProvider?.controls?.primaryActionButton.borderWidth ?? 1.0
        
        noAccountLabel.font = styleProvider?.cells?.common.descriptionCell.label.font
        signUpButton.titleLabel?.font = styleProvider?.cells?.common.descriptionCell.label.font
        
    }
    
}


//MARK: - Private methods
private extension LoginViewController{
    
    func setupView(){
        
        applyStyle()
        noAccountViewWrapper.addTopSeparator(color: separatorBackgroundColor, height: 0.5, margins: 0)
        setupTextFields()
        setupButtons()
        setupLabels()
        
        view.addTapGestureRecognizer { [weak self] (tap) in
            self?.view.endEditing(true)
        }
        
    }
    
    func setupTextFields() {
        let placeHolderStyle = styleProvider?.controls?.placeholderTextView
        
        //UserName
        usernameTextField.addTopSeparator(color: separatorBackgroundColor, height: 1, margins: 0)
        usernameTextField.addBottomSeparator(color: separatorBackgroundColor, height: 0.5, margins: 0)
        usernameTextField.delegate = self
        usernameTextField.keyboardType = .emailAddress
        usernameTextField.enablesReturnKeyAutomatically = true
        usernameTextField.returnKeyType = .next
        usernameTextField.attributedPlaceholder = NSAttributedString(string: "login_publicKey_placeholder".localised,
                                                                     attributes: [NSAttributedString.Key.foregroundColor: placeHolderStyle?.placeholderLabel.color ?? .clear])
        usernameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        //Password
        passwordTextField.addTopSeparator(color: separatorBackgroundColor, height: 0.5, margins: 0)
        passwordTextField.addBottomSeparator(color: separatorBackgroundColor, height: 1, margins: 0)
        passwordTextField.delegate = self
        passwordTextField.isSecureTextEntry = true
        passwordTextField.enablesReturnKeyAutomatically = true
        passwordTextField.returnKeyType = .go
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "login_privateKey_placeholder".localised,
                                                                     attributes: [NSAttributedString.Key.foregroundColor: placeHolderStyle?.placeholderLabel.color ?? .clear])
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
    }
    
    func setupButtons() {
        
        loginButton.model = .filled(text: "login_button_title".localised, image: nil)
        signUpButton.setTitle("login_button_title_sign_up".localised, for: .normal)
        
    }
    
    func setupLabels() {
        noAccountLabel.text = "login_title_dont_have_an_account".localised
    }
    
}

extension LoginViewController: LoginPresentingOutput {
    
    public var inputPublicAction: Edit? {
        get { return _inputUsernameAction }
        set { _inputUsernameAction = newValue }
    }
    
    public var inputPrivateAction: Edit? {
        get { return _inputPasswordAction }
        set { _inputPasswordAction = newValue }
    }
    
}


extension LoginViewController: UITextFieldDelegate {
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == usernameTextField{
            textField.resignFirstResponder()
            passwordTextField.becomeFirstResponder()
        }
        else if textField == passwordTextField {
            presenter?.save()
        }
        
        return false
        
    }
    
    @objc private func textFieldDidChange(textField: UITextField) {
        if textField == usernameTextField {
            inputPublicAction?(textField.text ?? "")
        }
        else if textField == passwordTextField {
            inputPrivateAction?(textField.text ?? "")
        }
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        if textField == usernameTextField {
            passwordTextField.becomeFirstResponder()
        }
        if textField == passwordTextField {
            passwordTextField.resignFirstResponder()
        }
    }
    
}
