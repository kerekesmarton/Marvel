//
//  IosCore
//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import UIKit
import Presentation
import Kingfisher

public class ImageTableViewCell: UITableViewCell, Styleable {

    @IBOutlet public var customImageView: UIImageView?
    @IBOutlet var button: UIButton!
    public var didTap: Tap? {
        didSet {
            button.setImage(#imageLiteral(resourceName: "cameraicon38Px").withRenderingMode(.alwaysTemplate), for: .normal)
        }
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        applyStyle()
    }
    
    @IBAction func buttonAction(_ sender: Any) {
        didTap?()
    }
    
    //MARK: - Stylable
    public func applyStyle() {
        customImageView?.layer.cornerRadius = 4.0
        customImageView?.clipsToBounds = true
        customImageView?.backgroundColor = styleProvider?.controls?.primaryActionButton.activeFillColor
    }
    
    public var imageModel: ImageModel? {
        didSet {
            applyStyle()
            if let data = imageModel?.data {
                customImageView?.image = UIImage(data: data)
            } else if let imageUrl = imageModel?.imageUrl {
                customImageView?.kf.setImage(with: URL(string: imageUrl))
            } else if let placeholder = imageModel?.placeholder {
                customImageView?.image = UIImage(named: placeholder)
            }
        }
    }
    
    public struct ImageModel {
        let imageUrl: String?
        let placeholder: String?
        let data: Data?
        let rounded: Bool?
        public init(_ imageUrl: String?, placeholder: String?, data: Data?, rounded: Bool?) {
            self.imageUrl = imageUrl
            self.placeholder = placeholder
            self.data = data
            self.rounded = rounded
        }
    }
}
