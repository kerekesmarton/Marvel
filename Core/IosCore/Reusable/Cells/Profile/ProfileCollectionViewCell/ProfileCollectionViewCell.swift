//
//  Channels
//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import Kingfisher
import Domain
import Presentation
import SnapKit

final public class ProfileCollectionViewCell: UICollectionViewCell, Styleable {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var profileLabel: ProfileExtrasLabel!
    
    struct Sizes {
        static let buttonHeight = 28
        static let buttonWidth = 44
        static let wideButtonWidth = 100
    }
    
    lazy var accessoryButton: PrimaryActionButton = {
        let btn = PrimaryActionButton(frame: CGRect(x: 0, y: 0, width: Sizes.wideButtonWidth, height: Sizes.buttonHeight))
        btn.addTarget(self, action: #selector(tap(_:)), for: .touchUpInside)
        return btn
    }()
    
    lazy var checkButton: UIButton = {
        let btn = SecondaryActionButton(frame: CGRect(x: 0, y: 0, width: Sizes.buttonWidth, height: Sizes.buttonHeight))
        
        btn.addTarget(self, action: #selector(tap(_:)), for: .touchUpInside)
        btn.imageView?.contentMode = .scaleAspectFill
        
        return btn
    }()
    
    @IBOutlet weak var accessoryView: UIView?
    
    lazy var optionButton: UIButton = {
        let btn = SecondaryActionButton(frame: CGRect(x: 0, y: 0, width: Sizes.buttonWidth, height: Sizes.buttonHeight))
        btn.addTarget(self, action: #selector(tap(_:)), for: .touchUpInside)
        btn.imageView?.contentMode = .scaleAspectFill
        return btn
    }()
    
    lazy var buttonsStackView: UIStackView = {
        let stackView = UIStackView(frame: CGRect(x: 0, y: 0, width: Sizes.wideButtonWidth+8+24,
                                                  height: Sizes.buttonHeight))
        stackView.addArrangedSubview(accessoryButton)
        stackView.addArrangedSubview(optionButton)
        stackView.spacing = 10.0
        stackView.axis = .horizontal
        
        return stackView
    }()
    
    public var tapClosure: ((IndexPath) -> Void)? {
        didSet {
            guard tapClosure != nil else { return }
            accessoryButton.isHidden = false
        }
    }
    
    override public var isHighlighted: Bool{
        didSet {
            UIView.animate(withDuration: 0.27,
                           delay: 0.0,
                           usingSpringWithDamping: 1,
                           initialSpringVelocity: 1.0,
                           options: [.curveEaseOut, .beginFromCurrentState],
                           animations: {
                            
                            self.transform = self.isHighlighted ? self.transform.scaledBy(x: 0.96, y: 0.96) : .identity
                            self.titleLabel?.alpha = self.isHighlighted ? 0.35 : 1
                            self.accessoryView?.alpha = self.isHighlighted ? 0.35 : 1
                            
            })
        }
    }
    
    var dataModel: DataModel? {
        didSet {
            guard let dataModel = dataModel else { return }
            profileLabel.dataModel = dataModel.headerData
            titleLabel?.text = dataModel.firstTitle
            profileImageView.kf.setImage(with: dataModel.imageURL)
            
            switch dataModel.type {
            case .buttonWithOptions(let following):
                fallthrough
            case .button(let following):
                if following {
                    accessoryButton.model = PrimaryActionButton.DataModel.normal(text: "profile_following_btn".localised, image: nil)
                } else {
                    accessoryButton.model = PrimaryActionButton.DataModel.filled(text: "profile_follow_btn".localised, image: nil)
                }
                let image = #imageLiteral(resourceName: "More-Item-Black").withRenderingMode(.alwaysTemplate)
                optionButton.setImage(image, for: .normal)
                optionButton.tintColor = styleProvider?.cells?.listCell.infoLabel.color
            case .options(let options):
                if options {
                    let image = #imageLiteral(resourceName: "More-Item-Black").withRenderingMode(.alwaysTemplate)
                    optionButton.setImage(image, for: .normal)
                    optionButton.tintColor = styleProvider?.cells?.listCell.infoLabel.color
                } else {
                    optionButton.isHidden = true
                }
            case .selection(let checked):
                if checked {
                    let image = #imageLiteral(resourceName: "verified").withRenderingMode(.alwaysTemplate)
                    checkButton.setImage(image, for: .normal)
                    checkButton.tintColor = styleProvider?.controls?.primaryActionButton.activeFillColor
                } else {
                    let image = #imageLiteral(resourceName: "off").withRenderingMode(.alwaysTemplate)
                    checkButton.setImage(image, for: .normal)
                    checkButton.tintColor = styleProvider?.controls?.primaryActionButton.disabledFillColor
                }
            case .none:
                break
            }
            applyStyle()
        }
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        accessoryButton.isHidden = true
        profileImageView.image = nil
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        applyStyle()
    }
    
    @IBAction func tap(_ sender: UIButton) {
        guard let collection = superview as? UICollectionView, let indexPath = collection.indexPath(for: self) else { return }
        
        tapClosure?(indexPath)
    }
    
    public func applyStyle() {
        accessoryButton.isHidden = true
        
        profileLabel.applyStyle()
        
        if let style = styleProvider?.cells {
            titleLabel?.textColor = style.collectionCell.titleBigLabel.color
            titleLabel?.font = style.collectionCell.titleBigLabel.font
            profileImageView.clipsToBounds = true
            layer.cornerRadius = style.collectionCell.cornerRadius
            layer.borderWidth = style.collectionCell.borderWidth
            layer.borderColor = style.collectionCell.borderColor.cgColor
        }        
        
        guard let dataModel = dataModel else { return }
        
        var view: UIView?
        switch dataModel.type {
        case .buttonWithOptions:
            accessoryView?.subviews.forEach { $0.removeFromSuperview() }
            accessoryView?.addSubview(buttonsStackView)
            accessoryView?.isHidden = false
            view = buttonsStackView
        case .button:
            accessoryView?.subviews.forEach { $0.removeFromSuperview() }
            accessoryView?.addSubview(accessoryButton)
            accessoryView?.isHidden = false
            view = accessoryButton
        case .selection:
            accessoryView?.subviews.forEach { $0.removeFromSuperview() }
            accessoryView?.addSubview(checkButton)
            accessoryView?.isHidden = false
            view = checkButton
        case .options:
            accessoryView?.subviews.forEach { $0.removeFromSuperview() }
            accessoryView?.addSubview(optionButton)
            accessoryView?.isHidden = false
            view = optionButton
        case .none:
            accessoryView?.subviews.forEach { $0.removeFromSuperview() }
            accessoryView?.isHidden = true
            view = nil
        }
        
        view?.snp.makeConstraints { builder in
            builder.width.equalTo(Sizes.wideButtonWidth)
            builder.height.equalTo(Sizes.buttonHeight)
            builder.center.equalToSuperview()
        }
    }
}


extension ProfileCollectionViewCell {
    
    public func setup(info: PresentableInfo, title: String?, imageURL: URL?, type: ListType) {        
        let headerData: ProfileExtrasLabel.DataModel = ProfileExtrasLabel.DataModel(with: info, size: .small)
        dataModel = DataModel(headerData: headerData, firstTitle: title, imageURL: imageURL, type: type)
    }
    
    public func setup(action: @escaping ((IndexPath) -> Void)) {
        tapClosure = action
    }
    
    struct DataModel {
        
        let headerData: ProfileExtrasLabel.DataModel
        let firstTitle: String?
        let imageURL: URL?
        
        let type: ListType
        
        public init(headerData: ProfileExtrasLabel.DataModel, firstTitle: String?, imageURL: URL?, type: ListType) {
            self.headerData = headerData
            self.firstTitle = firstTitle
            self.imageURL = imageURL
            self.type = type
        }
    }
    
}
