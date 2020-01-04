//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import UIKit
import IosCore

public enum Font {
    // https://developer.apple.com/design/human-interface-guidelines/ios/visual-design/typography/
    
    public static let lightCaption2     = light(11, style: .caption2)
    public static let lightFootnote     = light(13, style: .footnote)
    
    public static let regularCaption2   = regular(11, style: .caption2)
    public static let regularFootnote   = regular(13, style: .footnote)
    public static let regularSubhead    = regular(15, style: .subheadline)
    public static let regularBody       = regular(17, style: .body)
    public static let regularTitle2     = regular(22, style: .title2)
    public static let regularTitle3     = regular(20, style: .title3)
    
    public static let semiBoldCaption2  = semiBold(11, style: .caption2)
    public static let semiBoldFootnote  = semiBold(13, style: .footnote)
    public static let semiBoldSubhead   = semiBold(15, style: .subheadline)
    public static let semiBoldHeadline  = semiBold(17, style: .headline)
    public static let semiBoldBody      = semiBold(17, style: .body)
    
    public static let boldHeadline      = bold(17, style: .headline)
    public static let boldTitle3        = bold(20, style: .title3)
    public static let boldTitle2        = bold(22, style: .title2)
    
    
    struct FontDefinitions {
        static let regular = "SFProText-Regular"
        static let bold = "SFProText-Bold"
        static let boldItalic = "SFProText-BoldItalic"
        static let semiBold = "SFProText-Semibold"
        static let light = "SFProText-Light"
        static let italic = "SFProText-HeavyItalic"
    }

    private static func light(_ size: CGFloat, style: UIFont.TextStyle) -> UIFont {
        registerFontsIfNeeded()
        do {
            return try UIFont.scaledFont(name: FontDefinitions.light, style: style)
        } catch {
            return UIFont(name: FontDefinitions.light, size: size)!// ?? UIFont.systemFont(ofSize: size, weight: .light)
        }
    }
    
    private static func regular(_ size: CGFloat, style: UIFont.TextStyle) -> UIFont {
        registerFontsIfNeeded()
        do {
            return try UIFont.scaledFont(name: FontDefinitions.regular, style: style)
        } catch {
            return UIFont(name: FontDefinitions.regular, size: size)!// ?? UIFont.systemFont(ofSize: size)
        }
    }
    
    private static func semiBold(_ size: CGFloat, style: UIFont.TextStyle) -> UIFont {
        registerFontsIfNeeded()
        do {
            return try UIFont.scaledFont(name: FontDefinitions.semiBold, style: style)
        } catch {
            return UIFont(name: FontDefinitions.semiBold, size: size)!
            // ?? UIFont.systemFont(ofSize: size, weight: .semibold)
        }
    }
    
    private static func bold(_ size: CGFloat, style: UIFont.TextStyle) -> UIFont {
        registerFontsIfNeeded()
        do {
            return try UIFont.scaledFont(name: FontDefinitions.bold, style: style)
        } catch {
            return UIFont(name: FontDefinitions.bold, size: size)!
            // ?? UIFont.systemFont(ofSize: size, weight: UIFont.Weight.bold)
        }
    }
    
    private static func boldItalic(_ size: CGFloat, style: UIFont.TextStyle) -> UIFont {
        registerFontsIfNeeded()
        do {
            return try UIFont.scaledFont(name: FontDefinitions.boldItalic, style: style)
        } catch {
            return UIFont(name: FontDefinitions.boldItalic, size: size)!
            // ?? UIFont.systemFont(ofSize: size, weight: UIFont.Weight.bold)
        }
    }
    
    private static func registerFontsIfNeeded() {
//        UIFont.familyNames.forEach { (family) in
//            print(UIFont.fontNames(forFamilyName: family))
//        }

        guard hasToRegisterFonts else {
            return
        }
        hasToRegisterFonts = false
        let bundle = Bundle(for: BundleHelper.self)
        do {
            try UIFont.registerFontWithFilenameString(filenameString: "SF-Pro-Text-Regular",
                                                      type: ".otf", bundle: bundle)
            try UIFont.registerFontWithFilenameString(filenameString: "SF-Pro-Text-Bold",
                                                      type: ".otf", bundle: bundle)
            try UIFont.registerFontWithFilenameString(filenameString: "SF-Pro-Text-HeavyItalic",
                                                      type: ".otf", bundle: bundle)
            try UIFont.registerFontWithFilenameString(filenameString: "SF-Pro-Text-BoldItalic",
                                                      type: ".otf", bundle: bundle)
            try UIFont.registerFontWithFilenameString(filenameString: "SF-Pro-Text-Light",
                                                      type: ".otf", bundle: bundle)
            try UIFont.registerFontWithFilenameString(filenameString: "SF-Pro-Text-Semibold",
                                                      type: ".otf", bundle: bundle)
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    private static var hasToRegisterFonts = true
    private class BundleHelper {}
}
