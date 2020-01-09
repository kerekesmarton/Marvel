//
//  CharacterRouter.swift
//  MarvelCharacters
//
//  Created by Marton Kerekes on 06/01/2020.
//  Copyright © 2020 Marton Kerekes. All rights reserved.
//

import Foundation
import IosCore
import UIKit
import Presentation

class CharacterRouter: SegmentsRouter, ErrorRouting, CameraRouting, CharacterRouting {
    
    weak var context: SegmentedHeaderViewController?
    
    init(navigation: UINavigationController, context: SegmentedHeaderViewController) {
        super.init(nav: navigation)
        self.context = context
    }
    
    override func start() {
        guard let context = context else {
            fatalError()
        }
        navigationController?.pushViewController(context, animated: true)
        self.delegate = context
        context.router = self
    }
    
    var parent: Routing?
    
    private var _viewControllers: [UIViewController]?
    override var viewControllers: [UIViewController]? {
        get {
            if _viewControllers?.count != delegate?.segments.count {
                _viewControllers = nil
            }
            guard let _viewControllers = _viewControllers else {
                self._viewControllers = delegate?.segments.compactMap { (segment) -> UIViewController? in
                    let result = setup(segment: segment)
                    addChild(router: result.router)
                    return result.controller
                }
                return self._viewControllers
            }
            return _viewControllers
        }
        set {
            _viewControllers = newValue
        }
    }
    
    override func setup(segment: SegmentedDisplayable) -> (router: Routing, controller: UIViewController) {
        guard let segment = segment as? CharacterSegmentedContent else { fatalError() }
        switch segment {
        case .series(character: let character):
            let module: SeriesListModuleable = config.appModules.module()
            let result = module.setup(type: .character(character), config: config)
            return (router: result.router, controller: result.viewController)
        case .bio(text: let text):
            let module: TextModule = config.appModules.module()
            let result = module.setup(text: text, config: config)
            return (router: result.router, controller: result.viewController)
        }
    }
    
    override func present(controller: UIViewController) {
        host?.present(controller, animated: true)
    }
    
}
