//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import UIKit
import Presentation
import Domain

class InAppMessageToastViewController: UIViewController, Styleable {
    @IBOutlet var label: UILabel!
    @IBOutlet var topConstraint: NSLayoutConstraint!
    open override func viewDidLoad() {
        super.viewDidLoad()
        applyStyle()
    }
    
    public func applyStyle() {
        guard let style = styleProvider?.controls?.toastMessage, let message = message else {
            return
        }
        switch message {
        case .error(_):
            view.backgroundColor = style.errorBackgroundColor
        case .message(_):
            view.backgroundColor = style.messageBackgroundColor
        case.link(_, _):
            view.backgroundColor = style.backgroundColor
        }
        
        label.font = style.label?.font
        label.textColor = style.label?.color
        
        switch presentationStyle! {
        case .top(totalHeight: _, topOffset: let topOffset):
            topConstraint.constant = -topOffset
        default: 
            topConstraint.constant = 0
        }
    }
    
    static func toast(with message: InAppMessage, presentationStyle: ToastPresentationStyle) -> InAppMessageToastViewController {
        let vc = UIStoryboard.viewController(with: "ToastViewController", storyboard: "UI", bundle: Bundle(for: InAppMessageToastViewController.self)) as! InAppMessageToastViewController
        vc.message = message
        vc.presentationStyle = presentationStyle
        return vc
    }
    var presentationStyle: ToastPresentationStyle!
    var message: InAppMessage!
    var didTapBlock: ((DisplayInAppMessageCompletion)-> Void)?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        label.numberOfLines = 0
        if let text = message.text {
            label.text = text
        } else {
            label.text = ""
            label.isHidden = true
        }
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTap)))
        createDismissTimer()
    }
    
    @IBAction private func didTap() {
        didTapBlock?(.messageIntaraction)
    }
    
    func createDismissTimer() {
        let timeoutInterval: DispatchTime = .now() + .seconds(5)
        DispatchQueue.main.asyncAfter(deadline: timeoutInterval) { [weak self] in
            self?.didTapBlock?(.timeOut)
        }
    }
    
    func cancel() {
        didTapBlock?(.dismiss)
    }
}
