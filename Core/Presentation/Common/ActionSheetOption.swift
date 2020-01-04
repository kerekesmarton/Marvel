//
//  Presentation
//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import Foundation
import Domain

public struct ActionSheetOption {
    public let title: String?
    public let message: String?
    public let options: [Option]
    
    public typealias Action = () -> ()
    public struct Option {
        public let title: String
        public let style: Style
        public let action: Action?
        
        public enum Style {
            case cancel
            case normal
            case destructive
        }
        
        public init(title: String, style: Style, action: Action?) {
            self.title = title
            self.style = style
            self.action = action
        }
    }
    
    public init(title: String?, message: String?, options: [Option]) {
        self.title = title
        self.message = message
        self.options = options
    }
}

public extension ActionSheetOption {
    static func dismiss(action: Action? = nil) -> ActionSheetOption.Option {
        return ActionSheetOption.Option(title: "confirm".localised, style: .cancel, action: action)
    }
    
    static func cancel(action: Action? = nil) -> ActionSheetOption.Option {
        return ActionSheetOption.Option(title: "cancel".localised, style: .cancel, action: action)
    }
    
    static func tryAgain(action: Action? = nil) -> ActionSheetOption.Option {
        return ActionSheetOption.Option(title: "again".localised, style: .normal, action: action)
    }
    
    static func cancel(title: String, action: Action? = nil) -> ActionSheetOption.Option {
        return ActionSheetOption.Option(title: title, style: .cancel, action: action)
    }
    
    static func normal(title: String, action: Action? = nil) -> ActionSheetOption.Option {
        return ActionSheetOption.Option(title: title, style: .normal, action: action)
    }
    
    static func destructive(title: String, action: Action? = nil) -> ActionSheetOption.Option {
        return ActionSheetOption.Option(title: title, style: .destructive, action: action)
    }
}

public protocol ErrorRouting {
    func showActionSheet(with actionSheetOptions: ActionSheetOption)
    func showAlert(with actionSheetOptions: ActionSheetOption)
    func show(error: ServiceError?)
    func route(message: InAppMessage)
    func route(message: InAppMessage, completion: DisplayInAppMessageResultBlock?)
}
