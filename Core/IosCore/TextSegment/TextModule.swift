//
//  TextModule.swift
//  IosCore
//
//  Created by Marton Kerekes on 08/01/2020.
//  Copyright © 2020 Marton Kerekes. All rights reserved.
//

import Foundation
import Domain
import Data
import Presentation


public class TextModule: Module {
    
    public init() {}
    
    public func setup(text: [FontCalculable], config: Configurable) -> (router: Routing, viewController: UIViewController) {
    
        let vc = UIStoryboard.viewController(with: "TextViewController",
                                             storyboard: "UI",
                                             bundle: Bundle(for: TextViewController.self)) as! TextViewController
        let router = TextRouter(host: nil, context: vc)
        let presenter = TextPresenter(text: text, router: router)
        
        presenter.output = vc
        vc.presenter = presenter
        
        return (router, vc)
    }
}
