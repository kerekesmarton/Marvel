//  Copyright © 2017 moonpig.com. All rights reserved.
//

import Foundation
import Photos
import Additions
import Domain
import Presentation

protocol DataConvertable {
    var data: Data { get }
    var previewData: Data? { get }
}

extension Media.Image: DataConvertable {
    var previewData: Data? {
        return  data
    }
}

extension Media.Video: DataConvertable {}

protocol ConversionOperatable {
    var result: DataConvertable? { get }
    var asset: PHAsset { get }
    func makeAsset() -> Asset?
}

class ImageConvertOperation: AsyncOperaiton, ConversionOperatable {
    let asset: PHAsset
    let fetcher: PhotosDataFetching
    var result: DataConvertable?
    let didProgress: (Double?, Error?) -> Void
    
    init(fetcher: PhotosDataFetching, asset: PHAsset, didProgress: @escaping (Double?, Error?) -> Void) {
        self.asset = asset
        self.didProgress = didProgress
        self.fetcher = fetcher
        super.init()
    }
    
    override func main() {
        super.main()
        
        fetcher.image(for: asset, with: PHImageManagerMaximumSize, completionHandler: { [weak self] (image, id) in
            self?.result = image
            self?.state = .finished
        }) { [weak self] (progress, error, _) in
            self?.didProgress(progress, error)
        }
        
    }
    
    func makeAsset() -> Asset? {
        guard let data = result?.data else { return nil }
        return Asset(data: data, asset: asset, type: .photo)
    }
}

class VideoConvertOperation: AsyncOperaiton, ConversionOperatable {
    let asset: PHAsset
    let fetcher: PhotosDataFetching
    var result: DataConvertable?
    let didProgress: (Double?, Error?) -> Void
    
    init(fetcher: PhotosDataFetching, asset: PHAsset, didProgress: @escaping (Double?, Error?) -> Void) {
        self.asset = asset
        self.didProgress = didProgress
        self.fetcher = fetcher
        super.init()
    }
    
    override func main() {
        super.main()
        
        fetcher.video(for: asset, completionHandler: { [weak self] (video, id) in
            self?.result = video
            guard let asset = self?.asset else {
                self?.state = .finished
                return
            }
            self?.fetcher.image(for: asset, with: PHImageManagerMaximumSize, completionHandler: { [weak self](image, id) in
                video?.previewData = image?.data
                self?.state = .finished
                }, progressHandler: nil)
        }) { [weak self] (progress, error, _) in
            self?.didProgress(progress, error)
        }
    }
    
    func makeAsset() -> Asset? {
        guard let data = result?.previewData else { return nil }
        return Asset(data: data, asset: asset, type: .video)
    }
}

public class PhotosDataStore: PhotosDataFetching {
    
    let imageManager: PHImageManager
    
    public init(imageManager: PHImageManager) {
        self.imageManager = imageManager
    }
    
    public func image(for asset: PHAsset, with size: CGSize, completionHandler: @escaping PhotoFetchingCompletion, progressHandler: UpdateBlock?) {
        
        imageManager.requestImageData(for: asset, options: nil) { (data, string, orientation, info) in
            
            guard let data = data else {
                completionHandler(nil, asset.localIdentifier)
                return
            }
            completionHandler(Media.Image(data: data), asset.localIdentifier)
        }
    }
    
    public func video(for asset: PHAsset, completionHandler: @escaping VideoFetchingCompletion, progressHandler: UpdateBlock?) {
        
        let options = PHVideoRequestOptions()
        options.deliveryMode = .highQualityFormat
        options.isNetworkAccessAllowed = true
        
        imageManager.requestAVAsset(forVideo: asset, options: options) { (playbackAsset, audioMix, info) in
            
            guard let urlAsset = playbackAsset as? AVURLAsset else {
                completionHandler(nil, asset.localIdentifier)
                return
            }
            do {
                let data = try Data(contentsOf: urlAsset.url)
                let video: Media.Video = Media.Video(url: urlAsset.url, data: data)
                completionHandler(video, asset.localIdentifier)
            } catch {
                completionHandler(nil, asset.localIdentifier)
            }
        }
    }
}
