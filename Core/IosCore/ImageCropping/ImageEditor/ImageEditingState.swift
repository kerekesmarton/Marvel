//
//  UI
//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import Foundation
import UIKit
import CoreGraphics

class ImageEditingState: NSObject {
    private(set) var uiKitTransform: CGAffineTransform!
    private var quartzTransform: CGAffineTransform!
    lazy var transformTask: ImageTransformTask = {
        let task = ImageTransformTask(transform: quartzTransform, inputSize: fromSize, outputSize: toSize)
        return task
    }()
    private var toSize = CGSize.zero
    private var fromSize = CGSize.zero
    
    var minScaleFactor: CGFloat = 0.0
    var maxScaleFactor: CGFloat = 0.0
    
    var currentTranslation: CGPoint {
        let t: CGAffineTransform = uiKitTransform
        let currentTranslation = CGPoint(x: t.tx, y: t.ty)
        return currentTranslation
    }
    
    var currentScale: CGFloat {
        // This gets the xScale of the UIKit transform.
        // This is the same as the yScale and the scale of the quartzTransform
        let t: CGAffineTransform = uiKitTransform
        let scale = sqrt(t.a * t.a + t.c * t.c)
        return scale
    }
    
    var currentRotation: CGFloat {
        // This works since we know there is no skew in the matrix
        let t: CGAffineTransform = uiKitTransform
        let currentRotation = atan2(t.b, t.a)
        return currentRotation
    }
    
    func resetTransformWith(from fromSize: CGSize, to toSize: CGSize) {
        self.toSize = toSize
        self.fromSize = fromSize
        let scaleWidth: CGFloat = toSize.width / fromSize.width
        let scaleHeight: CGFloat = toSize.height / fromSize.height
        var aspectFillScale = max(scaleHeight, scaleWidth)
        if aspectFillScale < minScaleFactor {
            aspectFillScale = minScaleFactor
        }
        if aspectFillScale > maxScaleFactor {
            aspectFillScale = maxScaleFactor
        }
        var initialTransform = CGAffineTransform(scaleX: aspectFillScale, y: aspectFillScale)
        if aspectFillScale > scaleHeight {
            let heightOverlap: CGFloat = aspectFillScale * fromSize.height - toSize.height
            initialTransform = offsetTransform(initialTransform, xOffset: 0, yOffset: -heightOverlap / 2)
        } else if aspectFillScale > scaleWidth {
            let widthOverlap: CGFloat = aspectFillScale * fromSize.width - toSize.width
            initialTransform = offsetTransform(initialTransform, xOffset: -widthOverlap / 2, yOffset: 0)
        }
        uiKitTransform = initialTransform
        quartzTransform = initialTransform
    }
    
    func make(_ transform: CGAffineTransform, actAboutPivotPoint pivotPoint: CGPoint) -> CGAffineTransform {
        // Maths for rotating about a given point.
        // http://math.stackexchange.com/questions/820589/calculating-the-adjustment-translation-to-be-applied-after-rotating-and-scaling
        let translateReverseTransform = CGAffineTransform(translationX: -pivotPoint.x, y: -pivotPoint.y)
        let translateForwardTransform = CGAffineTransform(translationX: pivotPoint.x, y: pivotPoint.y)
        // -Txy * T * Txy
        let transformAboutPivotPoint: CGAffineTransform = translateReverseTransform.concatenating(transform).concatenating(translateForwardTransform)
        return transformAboutPivotPoint
    }
    
    func transformUIKitPoint(toQuartzCoordinates uiKitPoint: CGPoint, viewHieght viewHeight: CGFloat) -> CGPoint {
        let quartzPoint = CGPoint(x: uiKitPoint.x, y: viewHeight - uiKitPoint.y)
        return quartzPoint
    }
    
    func scaleTransform(_ scale: CGFloat, aboutPoint pivotPoint: CGPoint) {
        var scale = scale
        let currentScale: CGFloat = self.currentScale
        let newScale: CGFloat = scale * currentScale
        if newScale < minScaleFactor {
            scale = minScaleFactor / currentScale
        }
        if newScale > maxScaleFactor {
            scale = maxScaleFactor / currentScale
        }
        let scaleTransform = CGAffineTransform(scaleX: scale, y: scale)
        let scaleAboutAnchorTransform: CGAffineTransform = make(scaleTransform, actAboutPivotPoint: pivotPoint)
        uiKitTransform = uiKitTransform.concatenating(scaleAboutAnchorTransform)
        let pivotPointQuartz: CGPoint = transformUIKitPoint(toQuartzCoordinates: pivotPoint, viewHieght: toSize.height)
        let scaleAboutAnchorquartzTransform: CGAffineTransform = make(scaleTransform, actAboutPivotPoint: pivotPointQuartz)
        quartzTransform = quartzTransform.concatenating(scaleAboutAnchorquartzTransform)
    }
    
    func rotateTransform(_ angleInRadians: CGFloat, aboutPoint pivotPoint: CGPoint) {
        let rotateTransform = CGAffineTransform(rotationAngle: angleInRadians)
        let rotateAboutAnchorTransform: CGAffineTransform = make(rotateTransform, actAboutPivotPoint: pivotPoint)
        uiKitTransform = uiKitTransform.concatenating(rotateAboutAnchorTransform)
        let rotateQuartzTransform = CGAffineTransform(rotationAngle: -angleInRadians)
        let pivotPointQuartz: CGPoint = transformUIKitPoint(toQuartzCoordinates: pivotPoint, viewHieght: toSize.height)
        let rotateAboutAnchorquartzTransform: CGAffineTransform = make(rotateQuartzTransform, actAboutPivotPoint: pivotPointQuartz)
        quartzTransform = quartzTransform.concatenating(rotateAboutAnchorquartzTransform)
    }
    
    func offsetTransform(_ offset: CGPoint) {
        uiKitTransform = offsetTransform(uiKitTransform, xOffset: offset.x, yOffset: offset.y)
        quartzTransform = offsetTransform(quartzTransform, xOffset: offset.x, yOffset: -offset.y)
    }
    
    func offsetTransform(_ transform: CGAffineTransform, xOffset: CGFloat, yOffset: CGFloat) -> CGAffineTransform {
        // This works in the coodinate space of the destination by concatenating the translation after the exsting transform.
        // A more simple `CGAffineTransformTranslate` would work in the co-ordinate space of the source which would mean that
        // the offset would need to be transformed before it could be used.
        let translationTransform = CGAffineTransform(translationX: xOffset, y: yOffset)
        return transform.concatenating(translationTransform)
    }
    
    func isStateValid() -> Bool {
        return toSize.height > 0 && toSize.width > 0 && fromSize.height > 0 && fromSize.width > 0 && currentScale > 0 && transformTask.tranformScale > 0
    }

}
