///
//  Core
//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import Foundation

public enum FontStyle {
    case normal
    case author
    case largeAuthor
    case mention
    case minorCTA // minor Call To Action, later we introduce CTA also..
    case time
    case link
}

public struct FontCalculable {
    public var text: String
    public var style: FontStyle
    
    public init(text: String, style: FontStyle) {
        self.text = text
        self.style = style
    }
}

public protocol FontCalculating: class {
    var availableWidth: Double { get }
    func getFont(for style: FontStyle) -> UIFont
    func getColor(for style: FontStyle) -> UIColor
    
    func calculateHeight(for components: [FontCalculable], maxWidth: Double) -> Double
    func makeAttributedString(from components: [FontCalculable]) -> NSAttributedString
    func replace(segment: String, in original: NSAttributedString, with style: FontStyle) -> NSAttributedString
    func detectLinksIn(content: NSAttributedString) -> (NSAttributedString, [String])
    func changeColorForMentionIn(text: NSAttributedString, range: NSRange) -> NSAttributedString
}
