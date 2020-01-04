//
//  UI
//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import UIKit
import Additions

public extension UIFont {
    
    static func registerFontWithFilenameString(filenameString: String, type: String, bundle: Bundle) throws {
        
        guard let pathForResourceString = bundle.path(forResource: filenameString, ofType: type) else {
            throw NSError(with: "UIFont+:  Failed to register font - path for resource not found.", domain: "UI")
        }
        
        guard let fontData = NSData(contentsOfFile: pathForResourceString) else {
            throw NSError(with: "UIFont+:  Failed to register font - font data could not be loaded.", domain: "UI")
        }
        
        guard let dataProvider = CGDataProvider(data: fontData) else {
            throw NSError(with: "UIFont+:  Failed to register font - data provider could not be loaded.", domain: "UI")
        }
        
        guard let fontRef = CGFont(dataProvider) else {
            throw NSError(with: "UIFont+:  Failed to register font - font could not be loaded.", domain: "UI")
        }
        
        var errorRef: Unmanaged<CFError>? = nil
        if (CTFontManagerRegisterGraphicsFont(fontRef, &errorRef) == false) {
            throw NSError(with: "UIFont+:  Failed to register font - register graphics font failed - this font may have already been registered in the main bundle.", domain: "UI")
        }
    }
    
    static func scaledFont(name: String, style: UIFont.TextStyle) throws -> UIFont {
        let fontDescriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: style)
        let size = fontDescriptor.pointSize
        guard let font = UIFont(name: name, size: size) else {
            throw NSError(with: "UIFont+:  Failed to load dynamic font", domain: "UI")
        }
        return UIFontMetrics.default.scaledFont(for: font)
    }
}
