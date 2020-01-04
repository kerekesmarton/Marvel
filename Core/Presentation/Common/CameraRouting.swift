//
//  Presentation
//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import Domain
import Photos

public enum AssetType {
    case photo
    case video
    
    public init(with mediaType: Media.ModelType) {
        switch mediaType {
        case .image:
            self = .photo
        case .video:
            self = .video
        }
    }
    
    var mediaType: Media.ModelType {
        switch self {
        case .photo:
            return .image
        case .video:
            return .video
        }
    }
}

public class Asset: Equatable {
    public static func == (lhs: Asset, rhs: Asset) -> Bool {
        return lhs.asset == rhs.asset && lhs.data == rhs.data
    }
    
    public var asset: PHAsset?
    public var type: AssetType
    public var data: Data?
    public var id: String
    
    public init(data: Data, asset: PHAsset, type: AssetType) {
        self.data = data
        self.asset = asset
        self.id = asset.localIdentifier
        self.type = type
    }
    
    public init(data: Data, id: String, type: AssetType) {
        self.data = data
        self.id = id
        self.asset = nil
        self.type = type
    }
}

public class RemoteAsset: Equatable {
    public static func == (lhs: RemoteAsset, rhs: RemoteAsset) -> Bool {
        return lhs.url == rhs.url
    }
    
    public let url: URL
    public let caption: [FontCalculable]
    public let secondCaption: [FontCalculable]
    
    public init(url: URL, caption: [FontCalculable], secondCaption: [FontCalculable] = []) {
        self.url = url
        self.caption = caption
        self.secondCaption = secondCaption
    }
}

public enum CameraRoutingOption {
    case picker(limit: Int, type: AssetType)
    case viewer(imageModel: Image)
    case edit(shape: Shape, data: Image)
    
    public enum Shape {
        case square(ratio: Double)
        case round
    }
}

public extension ActionSheetOption {
    static func library(type: AssetType, action: Action? = nil) -> ActionSheetOption.Option {
        switch type {
        case .photo:
            return ActionSheetOption.Option(title: "choose_photo".localised, style: .normal, action: action)
        case .video:
            return ActionSheetOption.Option(title: "choose_video".localised, style: .normal, action: action)
        }
        
    }
    
    static func camera(action: Action? = nil) -> ActionSheetOption.Option {
        return ActionSheetOption.Option(title: "take_photo".localised, style: .normal, action: action)        
    }
}

public protocol ImageReferenceable: class {}

public protocol ImageReferenceCalculating: class {
    func reference(for index: Int) -> ImageReferenceable?
}

public protocol CameraRouting {
    func showCamera(type: AssetType,completion: @escaping (Asset?) -> Void)
    func showPhotoLibrary(for option: CameraRoutingOption, with completion: @escaping ([Asset]) -> Void)
    func showViewer(option: CameraRoutingOption, with completion: ((Image?) -> Void)?)
    func showViewer(for assets: [RemoteAsset], startIndex: Int, reference: ImageReferenceCalculating?)
}
