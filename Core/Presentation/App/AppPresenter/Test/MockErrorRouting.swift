//
//  PresentationTests
//
//  Copyright © 2018 mkerekes. All rights reserved.
//

#if TEST
@testable import Presentation
#endif
import Domain
import Photos

open class MockErrorRouting: ErrorRouting, CameraRouting {
    var stubData = [Asset]()
    var spyCameraRoutingOption: CameraRoutingOption?
    
    public func showCamera(type: AssetType, completion: @escaping (Asset?) -> Void) {
        completion(stubData.first)
    }
    
    public func showPhotoLibrary(for option: CameraRoutingOption, with completion: @escaping ([Asset]) -> Void) {
        spyCameraRoutingOption = option
        completion(stubData)
    }
    
    var stubImage: Image?
    public func showViewer(option: CameraRoutingOption, with completion: ((Image?) -> Void)?) {
        spyCameraRoutingOption = option
        completion?(stubImage)
    }
    
    var spyAssets: [RemoteAsset]?
    public func showViewer(for assets: [RemoteAsset], startIndex: Int, reference: ImageReferenceCalculating?) {
        spyAssets = assets
    }

    var spyActionSheet: ActionSheetOption?
    var spyMessage: InAppMessage?
    var spyServiceError: ServiceError?
    
    open func route(message: InAppMessage) {
        spyMessage = message
    }
    
    public func route(message: InAppMessage, completion: DisplayInAppMessageResultBlock?) {
        spyMessage = message
    }
    
    open func showActionSheet(with actionSheetOptions: ActionSheetOption) {
        spyActionSheet = actionSheetOptions
    }
    
    open func showAlert(with actionSheetOptions: ActionSheetOption) {
        spyActionSheet = actionSheetOptions
    }
    
    open func show(error: ServiceError?) {
        spyServiceError = error
    }
    
    open func route(url: URL, completion: ((Bool) -> Void)?) {
        completion?(true)
    }
}
