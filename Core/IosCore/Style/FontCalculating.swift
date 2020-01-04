///
//  IosCore
//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import Presentation

extension FontCalculating where Self: Styleable {
    
    public var availableWidth: Double {
        switch self {
        case is UIViewController:
            let controller = self as! UIViewController
            return Double(controller.view.frame.width)
        case is UIView:
            let view = self as! UIView
            return Double(view.frame.width)
        default:
            return Double(UIScreen.main.bounds.width)
        }
    }
    
    public func calculateHeight(for components: [FontCalculable], maxWidth: Double) -> Double {
        
        let attrString = makeAttributedString(from: components)
        
        let largestSize = CGSize(width: maxWidth, height: .greatestFiniteMagnitude)
        let framesetter = CTFramesetterCreateWithAttributedString(attrString)
        let textSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRange(), nil, largestSize, nil)
        
        return Double(textSize.height)
    }
    
    public func makeAttributedString(from components: [FontCalculable]) -> NSAttributedString {
        
        let attrString = NSMutableAttributedString()
        
        components.forEach { (fontCalculable) in
            let font = getFont(for: fontCalculable.style)
            let color = getColor(for: fontCalculable.style)
            let component = NSAttributedString(string: fontCalculable.text,
                                               attributes: [NSAttributedString.Key.font: font,
                                                            NSAttributedString.Key.foregroundColor : color])            
            attrString.append(component)
        }
        
        return attrString
    }
    
    public func getFont(for style: FontStyle) -> UIFont {
        switch style {
        case .normal:
            guard let font = styleProvider?.cells?.listCell.contentLabel.font  else {
                fatalError()
            }
            return font
        case .author:
            guard let font = styleProvider?.cells?.listCell.nameLabel.font  else {
                fatalError()
            }
            return font
        case .largeAuthor:            
            guard let font = styleProvider?.list?.header.nameLabel.font  else {
                fatalError()
            }
            return font
        case .minorCTA:
            guard let font = styleProvider?.cells?.common.descriptionCell.placeholderTextView.placeholderLabel.font else {
                fatalError()
            }
            return font
        case .link:
            guard let font = styleProvider?.cells?.common.labelWithLink.font  else {
                fatalError()
            }
            return font
        default:
            guard let font = styleProvider?.cells?.common.highlightedLabel.font else {
                fatalError()
            }
            return font
        }
        
    }
    
    public func getColor(for style: FontStyle) -> UIColor {
        switch style {
        case .normal:
            guard let color = styleProvider?.cells?.common.descriptionCell.label.color else {
                fatalError()
            }
            return color
        case .minorCTA:
            guard let color = styleProvider?.cells?.common.descriptionCell.placeholderTextView.placeholderLabel.color else {
                fatalError()
            }
            return color
        case .link:
            guard let color = styleProvider?.cells?.common.labelWithLink.color else {
                fatalError()
            }
            return color
        default:
            guard let color = styleProvider?.cells?.common.highlightedLabel.color else {
                fatalError()
            }
            return color
        }
    }
    
    public func replace(segment: String, in original: NSAttributedString, with style: FontStyle) -> NSAttributedString {
        let font = getFont(for: style)
        
        let resultString = NSMutableAttributedString(attributedString: original)
        let range = (original.string as NSString).range(of: segment)
        resultString.addAttributes([NSAttributedString.Key.font : font], range: range)
        
        return resultString
    }
    
    public func detectLinksIn(content: NSAttributedString) -> (NSAttributedString, [String]) {
        let matches = content.string.getURLRange()
        let attributedString = NSMutableAttributedString(attributedString: content)
        var strings = [String]()
        for match in matches {
            let url = (content.string as NSString).substring(with: match.range)
            strings.append(url)
            let linkText = NSMutableAttributedString(string: url,
                                                     attributes: [NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue): getColor(for: .link),
                NSAttributedString.Key.font : getFont(for: .link)])
            attributedString.replaceCharacters(in: match.range, with: linkText)
        }
        
        return (attributedString, strings)
    }
    
    public func changeColorForMentionIn(text: NSAttributedString, range: NSRange) -> NSAttributedString {
        guard text.length >= range.location + range.length else {
            return text
        }
        let attributedString = NSMutableAttributedString(attributedString: text)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: getColor(for: .link) , range: range)
        attributedString.addAttribute(NSAttributedString.Key.font, value: getFont(for: .link), range: range)
        
        return attributedString
    }
    
}
