///
//  IosCore
//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import Foundation
import Presentation
import Domain

import TLPhotoPicker
import Photos

public class ImagePickerModule: Module {
    
    public init() {}
    
    public func setupCamera(type: AssetType, config: Configurable, completion: @escaping (Data?) -> Void) -> (Routing, UIViewController) {
        
        let router = ImagePickerRouter(completion: completion)
        let imagePicker = ImagePickerController()
        imagePicker.sourceType = UIImagePickerController.SourceType.camera
        let availableTypes = UIImagePickerController.availableMediaTypes(for: .camera) ?? []
        switch type {
        case .photo:
            imagePicker.mediaTypes = availableTypes.contains("public.image") ? ["public.image"] : []
        case .video:
            imagePicker.mediaTypes = availableTypes.contains("public.movie") ? ["public.movie"] : []
        }
        imagePicker.delegate = router
        imagePicker.router = router
        return (router, imagePicker)
    }
    
    public func setupAlbums(limit: Int, type: AssetType, config: Configurable, completion: @escaping ([PHAsset]) -> Void) -> (Routing, UIViewController) {
        
        let imagePickerRouter = ImagePickerRouter(completion: completion)
        
        let photosPickerViewController = PhotosPickerViewController()
        photosPickerViewController.delegate = imagePickerRouter
        photosPickerViewController.router = imagePickerRouter
        
        var config = TLPhotosPickerConfigure()
        if limit == 1 {
            config.singleSelectedMode = true
        }
        else {
            config.maxSelectedAssets = limit
        }
        
        switch type {
        case .photo:
            config.mediaType = .image
        case .video:
            config.mediaType = .video
        }
        
        photosPickerViewController.configure = config
        
        return (imagePickerRouter, photosPickerViewController)
    }
    
    public func noCameraAlert() -> UIAlertController {
        let alert  = UIAlertController(title: "warning".localised, message: "no_camera_permission".localised, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "confirm".localised, style: .default, handler: nil))
        return alert
    }
    
    public var isCameraAvailable: Bool {
        return UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera)
    }
    
    public var hasCameraPermission: Bool {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            return true
        default:
            return false
        }
    }
    
    public func requestCameraAccess(completion: @escaping (Bool)->Void) {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { (finished) in
                completion(finished)
            }
        default:
            completion(false)
        }
    }
    
    public var hasLibraryPermission: Bool {
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch photoAuthorizationStatus {
        case .authorized:
            return true
        default:
            return false
        }
    }
    
    public func requestLibraryAccess(completion: @escaping (Bool)->Void) {
        switch PHPhotoLibrary.authorizationStatus() {
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({ (newStatus) in
                completion(newStatus == PHAuthorizationStatus.authorized)
            })
        default:
            completion(false)
        }
    }
    
    public func changePermissionsInSettingsAlert() -> UIAlertController {
        let alert  = UIAlertController(title: "go_to_settings_title".localised, message: "go_to_settings_detail".localised, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "confirm".localised, style: .default, handler: { (action) in
            UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
        }))
        alert.addAction(UIAlertAction(title: "cancel".localised, style: .cancel, handler: nil))
        return alert
    }
}

class PhotosPickerViewController: TLPhotosPickerViewController {
    var router: ImagePickerRouter?
}

class ImagePickerController: UIImagePickerController {
    var router: ImagePickerRouter?
}

