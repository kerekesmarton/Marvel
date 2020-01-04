//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import Foundation
import Domain
import Presentation

public protocol OrientationLocking {
    func lockOrientation(_ orientation: UIInterfaceOrientationMask)
    func lockOrientation(_ orientation: UIInterfaceOrientationMask, andRotateTo rotateOrientation:UIInterfaceOrientation)
}

public struct ImageEditModule: Module {
    public init() {}
    public func setup(model: ImageCropViewController.Model,  config: Configurable, completion: @escaping ImageCropViewController.ImageCropCompletion) -> (controller: UIViewController, router: Routing) {
        
        let cropNav = UIStoryboard.viewController(with: "ImageCropViewController", storyboard: "ImageCropViewController", bundle: Bundle(for: ImageCropViewController.self)) as! UINavigationController
        let crop = cropNav.viewControllers.first as! ImageCropViewController
        crop.completion = completion
        crop.model = model
        
        let router = ImageEditRouter(nav: cropNav)
        crop.router = router
        return (cropNav, router)
    }
}

class ImageEditRouter: Routing, ImageCropRouter {
    
    weak var navigation: UINavigationController?
    init(nav: UINavigationController) {
        navigation = nav
    }
    
    func start() {
        let orientationLocking: OrientationLocking? = findResponder()
        orientationLocking?.lockOrientation(.all)
    }
    
    func close(completion: (() -> Void)?) {
        let orientationLocking: OrientationLocking? = findResponder()
        orientationLocking?.lockOrientation(.portrait)
        navigation?.dismiss(animated: true, completion: completion)
    }
}
