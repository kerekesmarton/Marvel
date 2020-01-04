//
//  UI
//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import Foundation
import UIKit
import CoreGraphics

class ImageTransformTask {
    
    private(set) var transform: CGAffineTransform
    private(set) var inputSize = CGSize.zero
    private(set) var outputSize = CGSize.zero
    
    init(transform: CGAffineTransform, inputSize: CGSize, outputSize: CGSize) {
        assert(inputSize.height > 0 && inputSize.width > 0, "Invalid parameter not satisfying: inputSize.height > 0 && inputSize.width > 0")
        assert(outputSize.height > 0 && outputSize.width > 0, "Invalid parameter not satisfying: outputSize.height > 0 && outputSize.width > 0")
        
        self.inputSize = inputSize
        self.outputSize = outputSize
        self.transform = transform
        
    }
    
    var tranformScale: CGFloat {
        let t: CGAffineTransform = transform
        let scale = sqrt(t.a * t.a + t.c * t.c)
        return scale
    }
    
    func withInputSizeScaled(to inputSize: CGSize) -> ImageTransformTask {
        let newInputAspectRatio: CGFloat = inputSize.width / inputSize.height
        let existingInputAspectRatio: CGFloat = self.inputSize.width / self.inputSize.height
        let aspectRatioProportionalDifference = CGFloat(abs(Float(newInputAspectRatio - existingInputAspectRatio))) / existingInputAspectRatio
        assert(aspectRatioProportionalDifference < 0.04, """
        The aspect ratio of the input varies too much conpared to the existing apsect ratio.  \
        Have you provided the correct inputSize?
        """)

        let scaleFactor: CGFloat = inputSize.width / self.inputSize.width
        return withScaledInputSize(scaleFactor)
    }
    
    func withOutputSizeScaled(to outputSize: CGSize) -> ImageTransformTask {
        let scaleFactor: CGFloat = outputSize.width / self.outputSize.width
        return withScaledOutputSize(scaleFactor)
    }
    
    func withScaledInputSize(_ scaleFactor: CGFloat) -> ImageTransformTask {
        let inputSize: CGSize = self.inputSize
        let scaledInputSize = CGSize(width: inputSize.width * scaleFactor, height: inputSize.height * scaleFactor)
        let inverseScaleFactor: CGFloat = 1.0 / scaleFactor
        let inverseScaleTransform = CGAffineTransform(scaleX: inverseScaleFactor, y: inverseScaleFactor)
        let adjustedTransform: CGAffineTransform = inverseScaleTransform.concatenating(transform)
        let transformTask = ImageTransformTask(transform: adjustedTransform, inputSize: scaledInputSize, outputSize: outputSize)
        return transformTask
    }
    
    func withOptimisedOutputSize(withAMaximumSizeOf maxOutputSize: CGSize) -> ImageTransformTask {
        let tranformScale = self.tranformScale
        let outputScaleFactorToMakeTransformScaleEqual1: CGFloat = 1.0 / tranformScale
        let oldWidthToNewWidthScaleFactor: CGFloat = maxOutputSize.width / outputSize.width
        let outputScaleFactorToMakeSizeEqualMaxOutputSize: CGFloat = oldWidthToNewWidthScaleFactor
        let outputScaleFactor = min(outputScaleFactorToMakeTransformScaleEqual1, outputScaleFactorToMakeSizeEqualMaxOutputSize)
        return withScaledOutputSize(outputScaleFactor)
    }
    
    func withScaledOutputSize(_ scaleFactor: CGFloat) -> ImageTransformTask {
        let outputSize: CGSize = self.outputSize
        let scaledOutputSize = CGSize(width: outputSize.width * scaleFactor, height: outputSize.height * scaleFactor)
        let scaleTransform = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)
        let scaledTransform: CGAffineTransform = transform.concatenating(scaleTransform)
        let transformTask = ImageTransformTask(transform: scaledTransform, inputSize: inputSize, outputSize: scaledOutputSize)
        return transformTask
    }
}
