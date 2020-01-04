//
//  IosCore
//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import Presentation
import Domain
import Photos

public extension CameraRouting where Self: Routing {
    
    
    func showCamera(type: AssetType, completion: @escaping (Asset?) -> Void) {
        let module: ImagePickerModule = config.appModules.module()
        
        guard module.isCameraAvailable else {
            present(controller: module.noCameraAlert())
            return
        }
        guard module.hasCameraPermission else {
            
            module.requestCameraAccess { [weak self] (result) in
                
                DispatchQueue.main.async {
                    if result {
                        self?.showCamera(type: type, completion: completion)
                    }
                    else {
                        self?.present(controller: module.changePermissionsInSettingsAlert())
                    }
                }
                
            }
            return
            
        }
        
        let result = module.setupCamera(type: type, config: config) { (data) in
            guard let data = data else {
                completion(nil)
                return
            }
            completion(Asset(data: data, id: UUID().uuidString, type: .photo))
        }
        
        addChild(router: result.0)
        present(controller: result.1)
    }
    
    func showPhotoLibrary(for option: CameraRoutingOption, with completion: @escaping ([Asset]) -> Void) {
        
        let imagePickerModule: ImagePickerModule = config.appModules.module()
        
        guard case CameraRoutingOption.picker(let limit, let type) = option else { return }
        guard imagePickerModule.hasLibraryPermission else {
            
            imagePickerModule.requestLibraryAccess { [weak self] (result) in
                
                DispatchQueue.main.async {
                    if result {
                        self?.showPhotoLibrary(for: option, with: completion)
                    }
                    else {
                        self?.present(controller: imagePickerModule.changePermissionsInSettingsAlert())
                    }
                }
            }
            
            return
            
        }
        
        let result = imagePickerModule.setupAlbums(limit: limit, type: type, config: config) { [weak self] (assets) in
            if assets.count > 0 {
                self?.showConverter(assets: assets, with: completion)
            } else {
                completion([])
            }
        }
        
        addChild(router: result.0)
        present(controller: result.1)
        
    }
        
    func showConverter(assets: [PHAsset], with completion: @escaping ([Asset]) -> Void) {
        let imageConvertingModule: MediaConvertingModule = config.appModules.module()
        let result = imageConvertingModule.setupConverter(assets: assets, config: config, completion: completion)
        addChild(router: result.0)
        present(controller: result.1)
    }
    
    func showViewer(option: CameraRoutingOption, with completion: ((Image?) -> Void)?) {
        
        switch option {
        case .viewer(imageModel: let imageModel):
            guard let image = UIImage(data: imageModel.data) else { return }
            let model = ImageCropViewController.Model(image: image, style: option)
            let imageEditModule: ImageEditModule = config.appModules.module()
            let result = imageEditModule.setup(model: model, config: config, completion: { _ in () })
            
            addChild(router: result.router)
            result.router.start()
            present(controller: result.controller)
            
        case .edit(shape: _, data: let image):
            guard let completion = completion, let uiimage = UIImage(data: image.data) else { return }
            let model = ImageCropViewController.Model(image: uiimage, style: option)
            cropAndTransformToData(with: model, completion: completion)
        default:
            ()
        }
        
    }
    
    private func cropAndTransformToData(with model: ImageCropViewController.Model, completion: @escaping (Image?)->Void) {
        
        let imageEdit: ImageEditModule = config.appModules.module()
        let result = imageEdit.setup(model: model, config: config, completion: { croppedImage in
            guard let croppedImage = croppedImage?.pngData() else {
                completion(nil)
                return
            }
            completion(Image(data: croppedImage))
        })
        
        addChild(router: result.router)
        result.router.start()
        
        present(controller: result.controller)
    }
    
    func showViewer(for assets: [RemoteAsset], startIndex: Int, reference: ImageReferenceCalculating?) {
        let imageGallery: ImageGalleryModule = config.appModules.module()
        guard let result = imageGallery.setup(assets: assets, startIndex: startIndex, reference: reference) else {
            return
        }
        
        addChild(router: result.router)
        result.router.start()
        
        present(controller: result.viewController)
    }
}
