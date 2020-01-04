///
//  IosCore
//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import UIKit

extension UICollectionView {
    public func registerCell(cellClass: AnyClass, reuseIdentifier: String? = nil) {
        guard let cellName = NSStringFromClass(cellClass.self).components(separatedBy: ".").last else {
            fatalError("missing name")
        }
        let identifier = reuseIdentifier != nil ? reuseIdentifier : cellName
        let nib = UINib(nibName: cellName, bundle: Bundle(for: cellClass))
        self.register(nib, forCellWithReuseIdentifier: identifier!)
    }
}



