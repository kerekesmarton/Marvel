//
//  UI
//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import UIKit
import Kingfisher
import Presentation

public class ProfileListCell: UITableViewCell, Styleable {
    
    @IBOutlet weak var profileImageView: RoundedImageView!
    @IBOutlet weak var titleLabel: UILabel!
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

    var dataModel: DataModel? {
        didSet {
            guard let dataModel = dataModel else { return }
            profileLabel.dataModel = dataModel.headerData
            titleLabel.text = dataModel.firstTitle
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
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        updateSeparatorInset()
    }
    
    @IBAction func tap(_ sender: UIButton) {
        guard let table = superview as? UITableView, let indexPath = table.indexPath(for: self) else { return }
        
        tapClosure?(indexPath)
    }
    
    public func applyStyle() {
        selectionStyle = .none
        accessoryButton.isHidden = true
        
        profileLabel.applyStyle()
        
        titleLabel.textColor = styleProvider?.cells?.listCell.infoLabel.color
        titleLabel.font = styleProvider?.cells?.listCell.infoLabel.font
        
        guard let dataModel = dataModel else { return }
        
        switch dataModel.type {
        case .buttonWithOptions:
            accessoryView = buttonsStackView
        case .button:
            accessoryView = accessoryButton
        case .selection:
            accessoryView = checkButton
        case .options:
            accessoryView = optionButton
        case .none:
            accessoryView = nil
        }
        
    }
    
    private func updateSeparatorInset() {
        let separatorInset = titleLabel.convert(titleLabel.frame.origin, to: tableView)
        tableView?.separatorInset = .init(top: 0, left: separatorInset.x, bottom: 0, right: 0)
    }
}

extension ProfileListCell: PresentableItem {
    
    public func setup(profileInfo: PresentableInfo, title: String?, imageURL: URL?, type: ListType) {
        let headerData: ProfileExtrasLabel.DataModel = ProfileExtrasLabel.DataModel(with: profileInfo, size: .small)
        dataModel = DataModel(headerData: headerData, firstTitle: title, imageURL: imageURL, type: type)
    }
    
    public func setup(action: @escaping (IndexPath) -> Void) {
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
