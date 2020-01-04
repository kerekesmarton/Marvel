//
//  INSPhotosOverlayView.swift
//  INSPhotoViewer
//
//  Created by Michal Zaborowski on 28.02.2016.
//  Copyright © 2016 Inspace Labs Sp z o. o. Spółka Komandytowa. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this library except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

import UIKit
import Presentation

protocol INSPhotosOverlayViewable:class {
    var photosViewController: INSPhotosViewController? { get set }
    
    func populateWithPhoto(_ photo: INSPhotoViewable, fontCaclulating: FontCalculating)
    func setHidden(_ hidden: Bool, animated: Bool)
    func view() -> UIView
}

extension INSPhotosOverlayViewable where Self: UIView {
    func view() -> UIView {
        return self
    }
}

class INSPhotosOverlayView: UIView , INSPhotosOverlayViewable {
    private(set) var navigationBar: UINavigationBar!
    private(set) var captionLabel: UILabel!
    private(set) var captionLabel2: UILabel!
    private(set) var deleteToolbar: UIToolbar?
    
    private(set) var navigationItem: UINavigationItem!
    weak var photosViewController: INSPhotosViewController?
    private var currentPhoto: INSPhotoViewable?
    
    private var topShadow: CAGradientLayer!
    private var bottomShadow: CAGradientLayer!
    
    var leftBarButtonItem: UIBarButtonItem? {
        didSet {
            navigationItem.leftBarButtonItem = leftBarButtonItem
        }
    }
    var rightBarButtonItem: UIBarButtonItem? {
        didSet {
            navigationItem.rightBarButtonItem = rightBarButtonItem
        }
    }
    
    var titleTextAttributes: [NSAttributedString.Key : AnyObject] = [:] {
        didSet {
            navigationBar.titleTextAttributes = titleTextAttributes
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupShadows()
        setupNavigationBar()
        setupCaptionLabel()
        setupDeleteButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Pass the touches down to other views
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if let hitView = super.hitTest(point, with: event) , hitView != self {
            return hitView
        }
        return nil
    }
    
    override func layoutSubviews() {
        // The navigation bar has a different intrinsic content size upon rotation, so we must update to that new size.
        // Do it without animation to more closely match the behavior in `UINavigationController`
        UIView.performWithoutAnimation { () -> Void in
            self.navigationBar.invalidateIntrinsicContentSize()
            self.navigationBar.layoutIfNeeded()
        }
        super.layoutSubviews()
        self.updateShadowFrames()
    }
    
    func setHidden(_ hidden: Bool, animated: Bool) {
        if self.isHidden == hidden {
            return
        }
        
        if animated {
            self.isHidden = false
            self.alpha = hidden ? 1.0 : 0.0
            
            UIView.animate(withDuration: 0.2, delay: 0.0, options: [.allowAnimatedContent, .allowUserInteraction], animations: { () -> Void in
                self.alpha = hidden ? 0.0 : 1.0
                }, completion: { result in
                    self.alpha = 1.0
                    self.isHidden = hidden
            })
        } else {
            self.isHidden = hidden
        }
    }
    
    func populateWithPhoto(_ photo: INSPhotoViewable, fontCaclulating: FontCalculating) {
        self.currentPhoto = photo

        if let photosViewController = photosViewController {
            if let index = photosViewController.dataSource.indexOfPhoto(photo) {
                navigationItem.title = String(format:NSLocalizedString("%d of %d",comment:""), index+1, photosViewController.dataSource.numberOfPhotos)
            }
            if let caption1 = photo.caption, let caption2 = photo.secondCaption {
                captionLabel.attributedText = fontCaclulating.makeAttributedString(from: caption1)
                captionLabel2.attributedText = fontCaclulating.makeAttributedString(from: caption2)
            }
        }
        deleteToolbar?.isHidden = photo.isDeletable != true
    }
    
    @objc private func closeButtonTapped(_ sender: UIBarButtonItem) {
        photosViewController?.dismiss(animated: true, completion: nil)
    }
    
    @objc private func actionButtonTapped(_ sender: UIBarButtonItem) {
        if let currentPhoto = currentPhoto {
            currentPhoto.loadImageWithCompletionHandler({ [weak self] (image, error) -> () in
                if let image = (image ?? currentPhoto.thumbnailImage) {
                    let activityController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
                    activityController.popoverPresentationController?.barButtonItem = sender
                    self?.photosViewController?.present(activityController, animated: true, completion: nil)
                }
            });
        }
    }
    
    @objc private func deleteButtonTapped(_ sender: UIBarButtonItem) {
        photosViewController?.handleDeleteButtonTapped()
    }
    
    private func setupNavigationBar() {
        navigationBar = UINavigationBar()
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        navigationBar.backgroundColor = UIColor.clear
        navigationBar.barTintColor = nil
        navigationBar.isTranslucent = true
        navigationBar.shadowImage = UIImage()
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        
        navigationItem = UINavigationItem(title: "")
        navigationBar.items = [navigationItem]
        addSubview(navigationBar)
        
        let topConstraint: NSLayoutConstraint
        if #available(iOS 11.0, *) {
            topConstraint = NSLayoutConstraint(item: navigationBar!, attribute: .top, relatedBy: .equal, toItem: self.safeAreaLayoutGuide, attribute: .top, multiplier: 1.0, constant: 0.0)
        } else {
            topConstraint = NSLayoutConstraint(item: navigationBar!, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0.0)
        }
        let widthConstraint = NSLayoutConstraint(item: navigationBar!, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1.0, constant: 0.0)
        let horizontalPositionConstraint = NSLayoutConstraint(item: navigationBar!, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0.0)
        self.addConstraints([topConstraint,widthConstraint,horizontalPositionConstraint])
        
        leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "closeDelete"), landscapeImagePhone: #imageLiteral(resourceName: "closeDelete"), style: .plain, target: self, action: #selector(INSPhotosOverlayView.closeButtonTapped(_:)))
        
        rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "More-Item-Black"), style: .plain, target: self, action: #selector(INSPhotosOverlayView.actionButtonTapped(_:)))
    }
    
    private func setupCaptionLabel() {
        captionLabel = UILabel()
        captionLabel.translatesAutoresizingMaskIntoConstraints = false
        captionLabel.backgroundColor = UIColor.clear
        captionLabel.numberOfLines = 1
        addSubview(captionLabel)
        
        captionLabel2 = UILabel()
        captionLabel2.translatesAutoresizingMaskIntoConstraints = false
        captionLabel2.backgroundColor = UIColor.clear
        captionLabel2.numberOfLines = 1
        addSubview(captionLabel2)
        
        let leadingConstraint = captionLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 8.0)
        let trailingConstraint = captionLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: 8.0)
        let heightConstraint = captionLabel.heightAnchor.constraint(equalToConstant: 30)
        
        let topConstraint2 = captionLabel.bottomAnchor.constraint(equalToSystemSpacingBelow: captionLabel2.topAnchor, multiplier: 1.0)
        let bottomConstraint2 = captionLabel2.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -24.0)
        let leadingConstraint2 = captionLabel2.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 8.0)
        let trailingConstraint2 = captionLabel2.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: 8.0)
        let heightConstraint2 = captionLabel2.heightAnchor.constraint(equalToConstant: 30)
        
        self.addConstraints([leadingConstraint,trailingConstraint, heightConstraint, topConstraint2, bottomConstraint2, leadingConstraint2,trailingConstraint2, heightConstraint2])
    }
    
    private func setupShadows() {
        let startColor = UIColor.black.withAlphaComponent(0.5)
        let endColor = UIColor.clear
        
        self.topShadow = CAGradientLayer()
        topShadow.colors = [startColor.cgColor, endColor.cgColor]
        self.layer.insertSublayer(topShadow, at: 0)
        
        self.bottomShadow = CAGradientLayer()
        bottomShadow.colors = [endColor.cgColor, startColor.cgColor]
        self.layer.insertSublayer(bottomShadow, at: 0)
        
        self.updateShadowFrames()
    }
    
    private func updateShadowFrames(){
        topShadow.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 60)
        bottomShadow.frame = CGRect(x: 0, y: self.frame.height - 60, width: self.frame.width, height: 60)
        
    }
    
    var needsDeleteButton = false
    private func setupDeleteButton() {
        guard needsDeleteButton else {
            return
        }
        deleteToolbar = UIToolbar()
        deleteToolbar?.translatesAutoresizingMaskIntoConstraints = false
        deleteToolbar?.setBackgroundImage(UIImage(), forToolbarPosition: .any, barMetrics: .default)
        deleteToolbar?.setShadowImage(UIImage(), forToolbarPosition: .any)
        deleteToolbar?.isTranslucent = true
        let item = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(INSPhotosOverlayView.deleteButtonTapped(_:)))
        deleteToolbar?.setItems([item], animated: false)
        
        addSubview(deleteToolbar!)
        
        let bottomConstraint = NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: deleteToolbar, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        let trailingConstraint = NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: deleteToolbar, attribute: .trailing, multiplier: 1.0, constant: 0.0)
        
        let widthConstraint = NSLayoutConstraint(item: deleteToolbar!, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 65)
        let heightConstraint = NSLayoutConstraint(item: deleteToolbar!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 50)
        self.addConstraints([bottomConstraint,trailingConstraint,widthConstraint, heightConstraint])
    }
}
