//
//  TextRouter.swift
//  IosCore
//
//  Created by Marton Kerekes on 08/01/2020.
//  Copyright © 2020 Marton Kerekes. All rights reserved.
//

import Foundation
import UIKit

class TextRouter: Routing, TextRouting {
    
    init(host: UINavigationController?, context: UIViewController) {
        self.context = context
        self.host = host
    }
    
    func start() {
        guard let context = context else { return }
        host?.pushViewController(context, animated: true)
    }
    
    var parent: Routing?
    
    func present(controller: UIViewController) {
        context?.present(controller, animated: true, completion: {
            
        })
    }
    
    weak var context: UIViewController?
    weak var host: UINavigationController?
    
}

extension TextRouter: ScrollableChildRouter {
    func scrollToTop() {
        if let scrollView = context?.view as? UITextView, scrollView.contentSize.height > 0 {
            scrollView.scrollRectToVisible(CGRect.zero, animated: true)
        }
    }
}

