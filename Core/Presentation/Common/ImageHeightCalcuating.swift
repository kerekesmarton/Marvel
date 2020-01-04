//
//  Presentation
//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import Foundation

public protocol ImageHeightCalcuating {
    var totalHeight: RowHeight { get }
}

public protocol ImageContentCalculating {
    var numberOfImages: Int { get }
    var isFirstImagePortrait: Bool { get }
    func imageURL(for index: Int) -> URL?
    func item(for index: Int) -> Data?
}

public enum ImageHeight: Double {
    case portrait = 320
    case landscape = 240
}
