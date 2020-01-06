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
//        guard let segment = segment as? ProfileSegmentedContent else { fatalError() }
//        switch segment {
//        case .wall(profile: let profile):
//            let module: PostsListModulable = config.appModules.module()
//            return module.setup(feature: PostsListingType.profile(profile), config: config)
//        case .network(profile: let profile):
//            let module: ChannelListModulable = config.appModules.module()
//            return module.setup(type: .member(profile), cellPresenterType: .channelList, config: config)
//        case .blockProfile(profile: let profile):
//            let module: ProfileUnblockingModule = config.appModules.module()
//            return module.setup(profile: profile, config: config)
//        case .other:
//            let module: LabelledModule = config.appModules.module()
//            return module.setup(text: segment.title, config: config)
//        case .photos:
//            let module: LabelledModule = config.appModules.module()
//            return module.setup(text: segment.title, config: config)
//        }
        
        return (self, context!)
    }
    
    override func present(controller: UIViewController) {
        host?.present(controller, animated: true)
    }
    
}
