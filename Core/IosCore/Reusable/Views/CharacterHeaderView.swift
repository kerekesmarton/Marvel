//
//  File.swift
//  MarvelCharacters
//
//  Created by Marton Kerekes on 06/01/2020.
//  Copyright © 2020 Marton Kerekes. All rights reserved.
//

import UIKit
import Kingfisher
import Presentation

public struct HeaderDataModel {
    
    let header: ProfileExtrasLabel.DataModel
    let description: String?
    
    public init(header: ProfileExtrasLabel.DataModel, description: String?) {
        self.header = header
        self.description = description
    }
}

public protocol CharacterHeaderViewProtocol: ImageReferenceCalculating {
    var profileTapClosure: (() -> Void)?  { get set }
    func setProfileImage(url: URL)
    func setHeaderData(_ data: HeaderDataModel?)
}

public class CharacterHeaderView: UIView, CharacterHeaderViewProtocol {
    
    //MARK: - Properties
    public func setHeaderData(_ data: HeaderDataModel?) {
        headerDataModel = data
    }
    
    private var headerDataModel: HeaderDataModel? {
        didSet{
            profileLabel.dataModel = headerDataModel?.header
            profileLabel.isHidden = false
            descriptionLabel.text = headerDataModel?.description
            descriptionLabel.isHidden = headerDataModel?.description?.count == 0
        }
    }
    
    //MARK: - IBOutlets
    @IBOutlet private weak var imageView: UIImageView!
    
    @IBOutlet private weak var profileTitleStack: UIStackView!
    @IBOutlet private weak var profileLabel: ProfileExtrasLabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    //MARK: - Lifecycle methods
    override public func awakeFromNib() {
        super.awakeFromNib()
        clearAllLabels()
        applyStyle()
    }
    
    override public func sizeThatFits(_ size: CGSize) -> CGSize {
        if descriptionLabel.text ?? "" == ""{
            profileTitleStack.spacing = 0
            return .init(width: size.width, height: 503)
        }
        
        profileTitleStack.spacing = 10
        return .init(width: size.width, height: 503)
    }
    
    //MARK: - Private methods
    private func updateFrame() {
        frame.size = sizeThatFits(frame.size)
    }
    
    private func clearAllLabels() {
        
        profileLabel.text = nil
        descriptionLabel.text = nil
    }
    
    public var profileTapClosure: (() -> Void)? {
        didSet {
            imageView.addTapGestureRecognizer { [weak self] (recorgnizer) in
                self?.profileTapClosure?()
            }
        }
    }
    
    public func setProfileImage(url: URL) {
        imageView.kf.setImage(with: url)
        imageView.contentMode = .scaleAspectFill
        imageView.isHidden = false
    }
    
    public func reference(for index: Int) -> ImageReferenceable? {
        return imageView
    }
}

extension UIImageView: ImageReferenceable {}

extension CharacterHeaderView: Styleable{
    
    public func applyStyle() {
        
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 1
        imageView.layer.cornerRadius = 0
        
        profileLabel.applyStyle()
        descriptionLabel.textColor = styleProvider?.list?.header.titleOneLabel.color
        descriptionLabel.font = styleProvider?.list?.header.titleOneLabel.font
    }
}

extension CharacterHeaderView: SegmentedHeaderAnimatableView {
    public func animate(by factor: CGFloat) {}
}
