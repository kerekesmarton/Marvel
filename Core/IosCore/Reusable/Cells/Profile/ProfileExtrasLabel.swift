///
//  IosCore
//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import UIKit
import Presentation

public class ProfileExtrasLabel: UILabel, Styleable, NibViewLoadable {
    
    var tap: UITapGestureRecognizer?
    
    public var dataModel: DataModel? {
        didSet {
            guard let dataModel = dataModel else {
                return
            }
            refreshTapGesture()
            
            let string = NSMutableAttributedString(attributedString: dataModel.name)
            
            if dataModel.hasTick {
                string.append(NSAttributedString(string: " "))
                let attachment = ImageAttachment(image: styleProvider?.cells?.listCell.verifiedTick.image)
                string.append(NSAttributedString(attachment: attachment))
            }
            
            if let details = dataModel.details {
                string.append(NSAttributedString(string: " "))
                string.append(details)
            }
            
            attributedText = string
            
            applyStyle()
        }
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        applyStyle()
    }
    
    func didTap(_ tap: UITapGestureRecognizer) {
        guard let model = dataModel else { return }
        
        if let range = text?.nsRange(of: model.name.string), tap.didTapAttributedText(in: self, targetRange: range) {
            model.nameTap?()
        } else if let details = model.details, let range = text?.nsRange(of: details.string), tap.didTapAttributedText(in: self, targetRange: range) {
            if let string = checkTapOnLinks(with: tap) {
                model.linksTap?(string)
            } else {
                model.detailsTap?()
            }            
        } else {
            model.nameTap?()
        }
    }
    
    private func checkTapOnLinks(with tap: UITapGestureRecognizer) -> String? {
        guard let model = dataModel else { return nil }
        
        let string = model.links?.first(where: { (link) -> Bool in
            guard let range = text?.nsRange(of: link) else {
                return false
            }
            return tap.didTapAttributedText(in: self, targetRange: range)
        })
        return string
    }
    
    public func applyStyle() {
        
    }
    
    private func refreshTapGesture() {
        if let tap = tap {
            removeGestureRecognizer(tap)
        }
        guard dataModel?.nameTap != nil else {
            return
        }
        self.tap = addTapGestureRecognizer { [weak self] tap in
            self?.didTap(tap)
        }
    }
}

public extension ProfileExtrasLabel {
    
    struct DataModel {
        let size: ProfileExtrasLabelSize
        let info: PresentableInfo
        
        public enum ProfileExtrasLabelSize {
            case small
            case large
        }
        
        public init(with info: PresentableInfo, size: ProfileExtrasLabelSize) {
            self.info = info
            self.size = size
        }
        
        var name: NSAttributedString {
            return info.name
        }
        var nameTap: Tap? {
            return info.nameTap
        }
        var hasTick: Bool {
            return info.verified
        }
        var details: NSAttributedString? {
            return info.details
        }
        var detailsTap: Tap? {
            return info.detailsTap
        }
        var links: [String]? {
            return info.links
        }
        
        var linksTap: LinkTap? {
            return info.linkTap
        }
    }
}

class ImageAttachment: NSTextAttachment {
    
    init(image: UIImage?) {
        super.init(data: nil, ofType: nil)
        self.image = image
    }
    
    internal required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func attachmentBounds(for textContainer: NSTextContainer?, proposedLineFragment lineFrag: CGRect, glyphPosition position: CGPoint, characterIndex charIndex: Int) -> CGRect {
        var rect = CGRect.zero
        rect.origin = CGPoint(x: 0, y: -5)
        rect.size = self.image!.size
        
        return rect
    }
}
