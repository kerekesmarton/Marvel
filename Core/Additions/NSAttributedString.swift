///
//  Additions
//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import Foundation

public extension NSAttributedString {
    func width(height: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect,
                                            options: [.usesLineFragmentOrigin],
                                            context: nil)
        return ceil(boundingBox.width)
    }
    
    func numberOfLines(with width: CGFloat) -> Int {
        
        let path = UIBezierPath(rect: CGRect(x: 0, y: 0, width: width, height: CGFloat(MAXFLOAT)))
        let frameSetterRef : CTFramesetter = CTFramesetterCreateWithAttributedString(self as CFAttributedString)
        let frameRef: CTFrame = CTFramesetterCreateFrame(frameSetterRef, CFRangeMake(0, 0), path.cgPath, nil)
        
        let linesNS: NSArray  = CTFrameGetLines(frameRef)
        
        guard let lines = linesNS as? [CTLine] else { return 0 }
        return lines.count
    }
}

public func + (left: NSAttributedString, right: NSAttributedString) -> NSAttributedString {
    let result = NSMutableAttributedString()
    result.append(left)
    result.append(right)
    return result
}
