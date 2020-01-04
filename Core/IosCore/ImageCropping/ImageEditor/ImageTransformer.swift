//
//  UI
//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import UIKit

struct ImageTransformer {
    
    public func transformImage(_ image: UIImage, with transformTask: ImageTransformTask, completionHandler completion: @escaping (_ image: UIImage?) -> Void) {
        DispatchQueue.global().async(execute: {
            self.transform(image, transformTask: transformTask, completion: completion)
        })
    }
    
    private func transform(_ image: UIImage, transformTask: ImageTransformTask, completion: @escaping (_ image: UIImage?) -> Void) {
        guard let resultImage = transformedImage(forRawImage: image, transformTask: transformTask) else {
            completion(nil)
            return
        }
        DispatchQueue.main.async(execute: {
            completion(resultImage)
        })
    }
    
    private func transformedImage(forRawImage rawImage: UIImage, transformTask: ImageTransformTask) -> UIImage? {
        return ImageTransformHelper.transformImage(fromRawImage: rawImage, transformTask: transformTask)
    }
    
    private struct ImageTransformHelper {
        static func transformImage(fromRawImage rawImage: UIImage, transformTask: ImageTransformTask) -> UIImage? {
            let transform: CGAffineTransform = transformTask.transform
            let orientaitonAdjustmentTransform: CGAffineTransform = self.orientaitonAdjustmentTransform(for: rawImage)
            let transformWithAdjustmentForOrientation: CGAffineTransform = orientaitonAdjustmentTransform.concatenating(transform)
            let outputBounds = CGRect(x: 0, y: 0, width: transformTask.outputSize.width, height: transformTask.outputSize.height)
            var resultImage: UIImage? = nil
            resultImage = self.imageUsingCoreImage(fromRawImage: rawImage, transformWithAdjustmentForOrientation: transformWithAdjustmentForOrientation, outputBounds: outputBounds)
            return resultImage
        }
        
        static func imageUsingCoreImage(fromRawImage rawImage: UIImage, transformWithAdjustmentForOrientation: CGAffineTransform, outputBounds: CGRect) -> UIImage? {
            var coreImage: CIImage? = rawImage.ciImage
            if coreImage == nil {
                if let anImage = rawImage.cgImage {
                    coreImage = CIImage(cgImage: anImage)
                }
            }
            guard let ciImage = coreImage?.transformed(by: transformWithAdjustmentForOrientation) else {
                return nil
            }
            let context = CIContext(options: nil)
            guard let cgImage = context.createCGImage(ciImage, from: outputBounds) else {
                return nil
            }
            return UIImage(cgImage: cgImage)
        }
        
        static func imageBounds(forDrawing image: UIImage?) -> CGRect {
            // If the image is in a landscape orientation
            // it reports its width as its height and vice versa
            let orientation: UIImage.Orientation? = image?.imageOrientation
            var bounds: CGRect = CGRect.zero
            let width: CGFloat? = image?.size.width
            let height: CGFloat? = image?.size.height
            switch orientation {
            case .upMirrored?, .downMirrored?, .up?, .down?:
                bounds = CGRect(x: 0, y: 0, width: width ?? 0.0, height: height ?? 0.0)
            case .leftMirrored?, .rightMirrored?, .left?, .right?:
                bounds = CGRect(x: 0, y: 0, width: height ?? 0.0, height: width ?? 0.0)
            default:
                ()
            }
            return bounds
        }
        
        static func orientaitonAdjustmentTransform(for image: UIImage) -> CGAffineTransform {
            var transform: CGAffineTransform = .identity
            let orientation: UIImage.Orientation = image.imageOrientation
            let height: CGFloat = image.size.height
            let width: CGFloat = image.size.width
            switch orientation {
            case .down, .downMirrored:
                transform = transform.rotated(by: .pi)
                transform = transform.translatedBy(x: -width, y: -height)
            case .left, .leftMirrored:
                transform = transform.rotated(by: CGFloat(Double.pi/2))
                transform = transform.translatedBy(x: 0, y: -width)
            case .right, .rightMirrored:
                transform = transform.rotated(by: -CGFloat(Double.pi/2))
                transform = transform.translatedBy(x: -(height), y: 0)
            default:
                break
            }
            switch orientation {
            case .upMirrored, .downMirrored:
                transform = transform.translatedBy(x: width, y: 0)
                transform = transform.scaledBy(x: -1, y: 1)
            case .leftMirrored, .rightMirrored:
                transform = transform.translatedBy(x: height, y: 0)
                transform = transform.scaledBy(x: -1, y: 1)
            default:
                break
            }
            return transform
        }
    }
    
    
}



