///
//  IosCore
//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import Foundation
import Photos
import Domain
import Presentation

class MediaConvertingAlert: UIAlertController {
    
    var presenter: MediaConvertingPresenter?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let indicator = UIActivityIndicatorView(style: .whiteLarge)
        view.addSubview(indicator)
        indicator.isUserInteractionEnabled = false // required otherwise if there buttons in the UIAlertController you will not be able to press them
        indicator.startAnimating()
        
        let cancel = UIAlertAction(title: "cancel".localised, style: .cancel) { [weak self] (action) in
            self?.presenter?.cancel()
        }
        
        addAction(cancel)
        
        presenter?.viewReady()
    }
    
    convenience init(loadingTitle: String) {
        self.init(title: loadingTitle, message: "", preferredStyle: .alert)
    }
    
}

class MediaConvertingPresenter {
    
    private let queue = OperationQueue()
    private let photosDataStore: PhotosDataFetching
    private var ops = [Operation & ConversionOperatable]()
    private var didFinishOperation: BlockOperation?
    private var convertCompletion: (([Asset]) -> Void)?
    private let assets: [PHAsset]
    private let router: MediaConvertingRouter
    
    init(assets: [PHAsset],
         router: MediaConvertingRouter,
         dataStore: PhotosDataFetching,
         completion: @escaping (([Asset]) -> Void)) {
        
        self.router = router
        self.assets = assets
        convertCompletion = completion
        photosDataStore = dataStore
        
    }
    
    func viewReady() {
        download(assets: assets)
    }
    
    func cancel() {
        queue.cancelAllOperations()
        dismiss(with: [])
    }
    
    private func convertAndFinish() {
        let images: [Asset] = ops.compactMap {
            guard let asset = $0.makeAsset() else { return nil }
            return asset
        }
        dismiss(with: images)
    }
    
    private func dismiss(with images: [Asset]) {
        DispatchQueue.main.async { [weak self] in
            self?.router.dismiss { [weak self] in
                self?.convertCompletion?(images)
            }
        }
    }
    
    private func download(assets: [PHAsset]) {
        didFinishOperation = BlockOperation(block: { [weak self] in
            self?.convertAndFinish()
        })
        
        ops = assets.compactMap {
            switch $0.mediaType{
            case .video:
                let op = VideoConvertOperation(fetcher: photosDataStore, asset: $0, didProgress: { (_, _) in })
                didFinishOperation!.addDependency(op)
                return op
            case .image:
                let op = ImageConvertOperation(fetcher: photosDataStore, asset: $0, didProgress: { (_, _) in })
                didFinishOperation!.addDependency(op)
                return op
            default:
                return nil
            }
        }
        queue.addOperation(didFinishOperation!)
        queue.addOperations(ops, waitUntilFinished: false)
    }
}

class MediaConvertingRouter: Routing {
    func start() {}
    
    var parent: Routing?
    func present(controller: UIViewController) {}
    
    init(alert: UIAlertController?) {
        self.alert = alert
    }
    weak var alert: UIAlertController?
    func dismiss(completion: (() -> Void)?) {
        alert?.dismiss(animated: false, completion: {
            completion?()
        })
    }
}

public class MediaConvertingModule: Module {
    
    public init() {}
    
    public func setupConverter(assets: [PHAsset], config: Configurable, completion: @escaping ([Asset]) -> Void) -> (Routing, UIViewController) {
        
        let imageConvertingAlert = MediaConvertingAlert(loadingTitle: "fetching_images".localised)
        let router = MediaConvertingRouter(alert: imageConvertingAlert)
        
        let presenter = MediaConvertingPresenter(assets: assets,
                                                 router: router,
                                                 dataStore: config.photosFetching,
                                                 completion: completion)
        imageConvertingAlert.presenter = presenter
        
        return (router, imageConvertingAlert)
    
    }
    
}
