///
//  IosCore
//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import Foundation
import Domain
import Presentation

public class ImageGalleryModule: Module {
    
    public init() {}
    
    private func findReferenceView(_ photo: INSPhotoViewable, in photos: [INSPhotoViewable], from reference: ImageReferenceCalculating?) -> UIView? {
        if let index = photos.firstIndex(where: {$0 === photo}) {
            return reference?.reference(for: index) as? UIView
        }
        
        return nil
    }
    
    func setup(assets: [RemoteAsset], startIndex: Int, reference: ImageReferenceCalculating?) -> (router: Routing, viewController: UIViewController)? {
        let photos = assets.compactMap({ (remoteAsset) -> INSPhotoViewable? in
            let model = CustomPhotoModel(imageURL: remoteAsset.url, thumbnailImage: #imageLiteral(resourceName: "Open-gallery-icon"))
            model.caption = remoteAsset.caption
            model.secondCaption = remoteAsset.secondCaption
            return model
        })
        
        guard let currentPhoto = photos[safe: startIndex] ?? photos.first, let referenceView = findReferenceView(currentPhoto, in: photos, from: reference) else {
            return nil
        }
        
        let galleryViewController = ImageGalleryViewController(photos: photos, initialPhoto: currentPhoto, referenceView: referenceView)
        
        galleryViewController.referenceViewForPhotoWhenDismissingHandler = { [weak self] photo in
            return self?.findReferenceView(photo, in: photos, from: reference)
        }
        
        let router = ImageGalleryRouting(viewController: galleryViewController)
        galleryViewController.router = router
        return (router, galleryViewController)
    }
}

class ImageGalleryRouting: Routing {
    
    init(viewController: UIViewController) {
        self.context = viewController
    }
    
    func start() {
        let orientationLocking: OrientationLocking? = findResponder()
        orientationLocking?.lockOrientation(.all)
    }
    
    func close() {
        let orientationLocking: OrientationLocking? = findResponder()
        orientationLocking?.lockOrientation(.portrait, andRotateTo: .portrait)
    }
}

class ImageGalleryViewController: INSPhotosViewController, FontCalculating, Styleable {
    var styleProvider: StyleProviding? {
        return StyleManager.shared.styleProvider
    }
    
    var router: ImageGalleryRouting? {
        didSet {
            didDismissHandler = { [weak self] _ in
                self?.router?.close()
            }
        }
    }
    
    deinit {
        router = nil
    }
    
    func applyStyle() {
        
    }
    
    func getColor(for style: FontStyle) -> UIColor {
        switch style {
        case .normal:
            guard let color = styleProvider?.controls?.imageContentStyle.countIndicator?.color else {
                fatalError()
            }
            return color
        case .minorCTA:
            guard let color = styleProvider?.controls?.imageContentStyle.countIndicator?.color else {
                fatalError()
            }
            return color
        default:
            guard let color = styleProvider?.controls?.imageContentStyle.countIndicator?.color else {
                fatalError()
            }
            return color
        }
    }
}
