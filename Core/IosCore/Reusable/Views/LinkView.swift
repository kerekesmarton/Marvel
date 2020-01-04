//
//  IosCore
//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher
import Presentation

public final class LinkView: UIView, Styleable {
    
    public var contentInteraction: ContentInteraction? {
        didSet {
            addTapGestureRecognizer { [weak self] tap in
                guard let text = self?.urlLabel.text, let url = URL(string: text) else {
                    return
                }
                self?.contentInteraction?(ContentInteractionType.preview(url))
            }
        }
    }
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var urlLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    public var dataModel: DataModel? {
        didSet {
            titleLabel.text = dataModel?.title
            descriptionLabel.text = dataModel?.description
            urlLabel.text = dataModel?.link
            imageView.kf.setImage(with: dataModel?.imageURL)
            layoutIfNeeded()
        }
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupSubviews()
        applyStyle()
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = styleProvider?.controls?.linkView.border.cornerRadius ?? 0
        layer.borderWidth = styleProvider?.controls?.linkView.border.width ?? 0
        layer.borderColor = styleProvider?.controls?.linkView.border.color?.cgColor
        imageView.layer.cornerRadius = styleProvider?.controls?.linkView.border.cornerRadius ?? 0
    }
    
    public func applyStyle() {
        clipsToBounds = true
        imageView.clipsToBounds = true
        backgroundColor = styleProvider?.controls?.linkView.backgroundColor
        titleLabel.font = styleProvider?.controls?.linkView.titleLabel.font
        titleLabel.textColor = styleProvider?.controls?.linkView.titleLabel.color
        descriptionLabel.font = styleProvider?.controls?.linkView.descriptionLabel.font
        descriptionLabel.textColor = styleProvider?.controls?.linkView.descriptionLabel.color
        urlLabel.font = styleProvider?.controls?.linkView.linkLabel.font
        urlLabel.textColor = styleProvider?.controls?.linkView.linkLabel.color
    }
    
    private func setupSubviews() {
        
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        addSubview(urlLabel)
        
        imageView.snp.makeConstraints { builder in
            builder.width.height.equalTo(80)
            builder.leading.top.equalTo(16)
        }
        titleLabel.snp.makeConstraints { builder in
            builder.leading.equalTo(imageView.snp.trailing).offset(12)
            builder.right.equalToSuperview().inset(16)
            builder.height.equalTo(40)
            builder.top.equalTo(imageView)
        }
        descriptionLabel.snp.makeConstraints { builder in
            builder.top.equalTo(titleLabel.snp.bottom).offset(4)
            builder.leading.equalTo(titleLabel)
            builder.trailing.equalTo(titleLabel)
        }
        urlLabel.snp.makeConstraints { builder in
            builder.top.equalTo(descriptionLabel.snp.bottom).offset(4)
            builder.leading.equalTo(titleLabel)
            builder.trailing.equalTo(titleLabel)
        }
    }
}

extension LinkView {
    public struct DataModel {
        let title: String?
        let description: String?
        let link: String?
        let imageURL: URL?
        
        public init(title: String?, description: String?, link: String?, imageURL: URL?) {
            self.title = title
            self.description = description
            self.link = link
            self.imageURL = imageURL
        }
    }
}
