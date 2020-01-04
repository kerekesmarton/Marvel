//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import Foundation
import Presentation
import Domain

public protocol InAppMessageRouting: ErrorRouting {}

public extension ErrorRouting where Self: Routing {
    
    func showActionSheet(with actionSheetOptions: ActionSheetOption) {
        
        let actionSheet = UIAlertController(title: actionSheetOptions.title, message: actionSheetOptions.message, preferredStyle: .actionSheet)
        actionSheetOptions.options.forEach { (option) in
            switch option.style {
            case .cancel:
                actionSheet.addAction(UIAlertAction(title: option.title, style: .cancel, handler: { (action) in
                    option.action?()
                }))
            case .normal:
                actionSheet.addAction(UIAlertAction(title: option.title, style: .default, handler: { (action) in
                    option.action?()
                }))
            case .destructive:
                actionSheet.addAction(UIAlertAction(title: option.title, style: .destructive, handler: { (action) in
                    option.action?()
                }))
            }
        }
        present(controller: actionSheet)
    }
    
    func showAlert(with actionSheetOptions: ActionSheetOption) {
        let alert = UIAlertController(title: actionSheetOptions.title, message: actionSheetOptions.message, preferredStyle: .alert)
        actionSheetOptions.options.forEach { (option) in
            switch option.style {
            case .cancel:
                alert.addAction(UIAlertAction(title: option.title, style: .cancel, handler: { (action) in
                    option.action?()
                }))
            case .normal:
                alert.addAction(UIAlertAction(title: option.title, style: .default, handler: { (action) in
                    option.action?()
                }))
            case .destructive:
                alert.addAction(UIAlertAction(title: option.title, style: .destructive, handler: { (action) in
                    option.action?()
                }))
            }
        }
        present(controller: alert)
    }
    
    func show(error: ServiceError?) {
        guard let message = error?.message else { return }
        
        showGenericAlert(message: message, title: error?.title)
    }
    
    func showGenericAlert(message: String, title: String?) {
        let alert = ActionSheetOption(title: title, message: message, options: [ActionSheetOption.dismiss()])
        showAlert(with: alert)
    }
    
    func route(message: InAppMessage) {
        route(message: message, completion: nil)
    }
    
    func route(message: InAppMessage, completion: DisplayInAppMessageResultBlock?) {
        if let responder: InAppMessageRouting = findResponder() {
            responder.route(message: message, completion: completion)
        }
    }
}
