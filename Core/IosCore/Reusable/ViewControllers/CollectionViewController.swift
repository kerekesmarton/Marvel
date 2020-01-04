///
//  IosCore
//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import Foundation
import Presentation

open class CollectionViewController: UICollectionViewController, Styleable, PresentationOutput {
    open func applyStyle() {}    

    public func registerCell(cellClass: AnyClass, with collectionView: UICollectionView, reuseIdentifier: String? = nil) {
        guard let cellName = NSStringFromClass(cellClass.self).components(separatedBy: ".").last else {
            fatalError("missing name")
        }
        let identifier = reuseIdentifier ?? cellName
        collectionView.register(UINib(nibName: cellName, bundle: Bundle(for: cellClass)), forCellWithReuseIdentifier: identifier)
    }
    
    open var state: PresentationOutputState? {
        didSet {
            switch state {
            case .loading:
                showActivityIndicatorOn(collectionView)
            default:
                removeActivityIndicator()
            }
        }
    }
}
