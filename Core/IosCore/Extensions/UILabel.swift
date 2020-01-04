///
//  IosCore
//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import UIKit

public extension UILabel {
    
    func expectedHeightForAttributedString(forWidth width: CGFloat) -> CGFloat {
        guard let attrString = self.attributedText else { return .zero }
        let maxSize = CGSize(width: width, height: .greatestFiniteMagnitude)
        
        let expectedRect = attrString.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, context: nil)
        return ceil(expectedRect.size.height)
    }
}
