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

public protocol CharacterHeaderViewProtocol: ImageReferenceCalculating {
    var profileTapClosure: (() -> Void)?  { get set }
    func setProfileImage(url: URL)
    func setText(_ text: String?)
}

public class CharacterHeaderView: UIView, CharacterHeaderViewProtocol {
    
    //MARK: - Properties
    public func setText(_ text: String?) {
        descriptionTextView.text = text
        descriptionTextView.isHidden = false
    }
    
    //MARK: - IBOutlets
    @IBOutlet private weak var imageView: UIImageView!
    
    @IBOutlet private weak var descriptionTextView: UITextView!
    
    //MARK: - Lifecycle methods
    override public func awakeFromNib() {
        super.awakeFromNib()
        clearAllLabels()
        applyStyle()
    }
    
    override public func sizeThatFits(_ size: CGSize) -> CGSize {
        if descriptionTextView.text ?? "" == ""{
            return .init(width: size.width, height: 300)
        }
        
        let remainderSize = CGSize(width: descriptionTextView.frame.width, height: size.height - 300)
        
        let totalSize = descriptionTextView.sizeThatFits(remainderSize)
        
        return .init(width: size.width, height: 300 + totalSize.height)
    }
    
    //MARK: - Private methods
    private func updateFrame() {
        frame.size = sizeThatFits(frame.size)
    }
    
    private func clearAllLabels() {
        descriptionTextView.text = nil
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
        
        descriptionTextView.textColor = styleProvider?.list?.header.titleOneLabel.color
        descriptionTextView.font = styleProvider?.list?.header.titleOneLabel.font
    }
}

extension CharacterHeaderView: SegmentedHeaderAnimatableView {
    public func animate(by factor: CGFloat) {}
}
