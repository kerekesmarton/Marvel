///
//  IosCore
//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import Foundation
import Photos

public class PhotoAlbum {
    
    public let albumName: String
    public let numberOfPhotos: Int
    public let localIdentifier: String
    public var thumbnailIdentifier: String?
    public let endDate: Date
    
    public init(albumName: String, numberOfPhotos: Int, identifier: String, thumbnailIdentifier: String?, endDate: Date) {
        self.albumName = albumName
        self.numberOfPhotos = numberOfPhotos
        self.localIdentifier = identifier
        self.thumbnailIdentifier = thumbnailIdentifier
        self.endDate = endDate
    }
}

public class PhotoAlbumEntityConverter {
    
    public func convertToAlbum(from assetCollection: PHAssetCollection, details: ((PHAssetCollection) -> (count: Int, thumbnailIdentifier: String?, date: Date))) -> PhotoAlbum? {
        let (count, thumbnailIdentifier, date) = details(assetCollection)
        guard let safeName = assetCollection.localizedTitle else {
            return nil
        }
        
        return PhotoAlbum(albumName: safeName,
                          numberOfPhotos: count,
                          identifier: assetCollection.localIdentifier,
                          thumbnailIdentifier: thumbnailIdentifier,
                          endDate: date)
    }
    
    public func convertToAlbumsArray(from fetchResult: PHFetchResult<PHAssetCollection>, details: @escaping ((PHAssetCollection) -> (count: Int, thumbnailIdentifier: String?, date: Date))) -> [PhotoAlbum] {
        var albums = [PhotoAlbum]()
        fetchResult.enumerateObjects({ [weak self] (assetCollection: AnyObject, index: Int, unused: UnsafeMutablePointer<ObjCBool>) in
            guard let safeAssetCollection = assetCollection as? PHAssetCollection,
                
                let album = self?.convertToAlbum(from: safeAssetCollection, details: details) else { return }
            albums.append(album)
        })
        return albums
    }
}



public class AlbumsDataStore {
    func fetch(albumType: PHAssetCollectionType, subtype: PHAssetCollectionSubtype) -> PHFetchResult<PHAssetCollection> {
        return PHAssetCollection.fetchAssetCollections(with: albumType, subtype: subtype, options: nil)
    }
    
    func fetchAssets(from assetCollection: PHAssetCollection, options: PHFetchOptions) -> PHFetchResult<PHAsset> {
        return PHAsset.fetchAssets(in: assetCollection, options: options)
    }
    
    func detailsFetcher(assetCollection: PHAssetCollection) -> (count: Int, thumbnailIdentifier: String?, lastDate: Date) {
        let results = fetchAssets(from: assetCollection, options: nonVideosPredicate)
        let lastObject = results.lastObject
        if let date: Date = lastObject?.creationDate {
            return (results.count, lastObject?.localIdentifier, date)
        } else {
            return (results.count, lastObject?.localIdentifier, Date.distantPast)
        }
    }
    
    private lazy var nonVideosPredicate: PHFetchOptions = {
        let options = PHFetchOptions()
        options.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
        return options
    }()
}
