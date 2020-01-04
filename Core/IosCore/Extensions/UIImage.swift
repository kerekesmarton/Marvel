///
//  IosCore
//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import UIKit

extension UIImage {
    
    func fixOrientation() -> UIImage {
        
        // No-op if the orientation is already correct
        if ( self.imageOrientation == UIImage.Orientation.up ) {
            return self;
        }
        
        // We need to calculate the proper transformation to make the image upright.
        // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
        var transform: CGAffineTransform = CGAffineTransform.identity
        
        if ( self.imageOrientation == UIImage.Orientation.down || self.imageOrientation == UIImage.Orientation.downMirrored ) {
            transform = transform.translatedBy(x: self.size.width, y: self.size.height)
            transform = transform.rotated(by: CGFloat(Double.pi))
        }
        
        if ( self.imageOrientation == UIImage.Orientation.left || self.imageOrientation == UIImage.Orientation.leftMirrored ) {
            transform = transform.translatedBy(x: self.size.width, y: 0)
            transform = transform.rotated(by: CGFloat(Double.pi / 2.0))
        }
        
        if ( self.imageOrientation == UIImage.Orientation.right || self.imageOrientation == UIImage.Orientation.rightMirrored ) {
            transform = transform.translatedBy(x: 0, y: self.size.height);
            transform = transform.rotated(by: CGFloat(-Double.pi / 2.0));
        }
        
        if ( self.imageOrientation == UIImage.Orientation.upMirrored || self.imageOrientation == UIImage.Orientation.downMirrored ) {
            transform = transform.translatedBy(x: self.size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        }
        
        if ( self.imageOrientation == UIImage.Orientation.leftMirrored || self.imageOrientation == UIImage.Orientation.rightMirrored ) {
            transform = transform.translatedBy(x: self.size.height, y: 0);
            transform = transform.scaledBy(x: -1, y: 1);
        }
        
        // Now we draw the underlying CGImage into a new context, applying the transform
        // calculated above.
        let ctx: CGContext = CGContext(data: nil, width: Int(self.size.width), height: Int(self.size.height),
                                       bitsPerComponent: self.cgImage!.bitsPerComponent, bytesPerRow: 0,
                                       space: self.cgImage!.colorSpace!,
                                       bitmapInfo: self.cgImage!.bitmapInfo.rawValue)!;
        
        ctx.concatenate(transform)
        
        if ( self.imageOrientation == UIImage.Orientation.left ||
            self.imageOrientation == UIImage.Orientation.leftMirrored ||
            self.imageOrientation == UIImage.Orientation.right ||
            self.imageOrientation == UIImage.Orientation.rightMirrored ) {
            ctx.draw(self.cgImage!, in: CGRect(x: 0,y: 0,width: self.size.height,height: self.size.width))
        } else {
            ctx.draw(self.cgImage!, in: CGRect(x: 0,y: 0,width: self.size.width,height: self.size.height))
        }
        
        // And now we just create a new UIImage from the drawing context and return it
        return UIImage(cgImage: ctx.makeImage()!)
    }
    
    public static func resizableImage(cornerRadius: CGFloat,
                                      fillColor: UIColor,
                                      borderColor: UIColor = .clear,
                                      borderWidth: CGFloat = 1.0,
                                      opaque: Bool? = nil) -> UIImage {
        let cornerSize = max(borderWidth, cornerRadius)
        let side = 2 * cornerSize + 1
        let imageRect = CGRect(x: 0, y: 0, width: side, height: side)
        
        let isOpaque = opaque ?? (cornerRadius == 0 && fillColor != .clear)
        UIGraphicsBeginImageContextWithOptions(imageRect.size, isOpaque, 0)
        let context = UIGraphicsGetCurrentContext()
        
        let path = UIBezierPath(roundedRect: imageRect, cornerRadius: cornerRadius)
        
        context?.setFillColor(fillColor.cgColor)
        
        path.fill()
        
        if borderWidth > 0 && borderColor != .clear {
            let borderPath = UIBezierPath(roundedRect: imageRect.insetBy(dx: borderWidth / 2, dy: borderWidth / 2),
                                          cornerRadius: cornerRadius - borderWidth / 2)
            borderPath.lineWidth = borderWidth
            
            context?.setStrokeColor(borderColor.cgColor)
            borderPath.stroke()
        }
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!.resizableImage(withCapInsets: UIEdgeInsets(top: cornerSize,
                                                                 left: cornerSize,
                                                                 bottom: cornerSize,
                                                                 right: cornerSize),
                                     resizingMode: .stretch)
    }
    
}
