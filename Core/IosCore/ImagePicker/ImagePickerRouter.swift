//
//  UI
//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import UIKit
import Photos
import Additions
import Domain
import Presentation
import TLPhotoPicker

class ImagePickerRouter: NSObject, Routing, ErrorRouting {
    
    private var cameraCompletion: ((Data?) -> Void)?
    private var albumCompletion: (([PHAsset]) -> Void)?
    var results = [PHAsset]()
    
    init(completion: @escaping ((Data?) -> Void)) {
        cameraCompletion = completion
    }
    
    init(completion: @escaping (([PHAsset]) -> Void)) {
        albumCompletion = completion
    }
    
    func start() {}
    
}

extension ImagePickerRouter: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage,
            let data = image.fixOrientation().jpegData(compressionQuality: 0.7) else {
                
            cameraCompletion?(nil)
            return
        }
        
        picker.dismiss(animated: true) { [weak self] in
            self?.cameraCompletion?(data)
        }
        
        return
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true) { [weak self] in
            self?.cameraCompletion?(nil)
        }
    }
}

extension ImagePickerRouter: TLPhotosPickerViewControllerDelegate  {
    
    func dismissPhotoPicker(withPHAssets assets: [PHAsset]) {
        results = assets
    }
    
    func dismissComplete() {
        albumCompletion?(results)
    }
    
}
