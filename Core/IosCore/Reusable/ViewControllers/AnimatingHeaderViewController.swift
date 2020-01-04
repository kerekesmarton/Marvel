//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import UIKit

open class AnimatingHeaderViewController: ViewController {
    
    @IBOutlet open weak var profileImageView: RoundedImageView!
    @IBOutlet open weak var profileWidthConstraint: NSLayoutConstraint!
    @IBOutlet open weak var profileHeightConstraint: NSLayoutConstraint!
    @IBOutlet var profileBottomConstraint: NSLayoutConstraint!
    open var profileClosure: (() -> Void)? = nil
    
    @IBOutlet open weak var coverImageView: UIImageView!
    @IBOutlet open weak var coverHeightConstraint: NSLayoutConstraint!
    open var coverClosure: (() -> Void)? = nil
    
    @IBOutlet open weak var nameLabel: UILabel!
    
    @IBOutlet public weak var additionalContentView: UIView!
    @IBOutlet public var additionalContentTopConstraint: NSLayoutConstraint!
    @IBOutlet public var additionalContentBottomConstraint: NSLayoutConstraint!
    @IBOutlet public var additionalContentHeight: NSLayoutConstraint!
    public func setAdditionalContentHeight(_ height: CGFloat, nonCollapsingHeight: CGFloat? = nil) {
        additionalContentHeight.constant = height
        HeaderDimensions.additionalContentHeight = height
        HeaderDimensions.additionalContentNonCollapsingHeight = nonCollapsingHeight ?? 0
    }
    
    @IBOutlet public weak var containerView: UIView!
    
    @IBOutlet open weak var topView: UIView!
    @IBOutlet var topViewHeightConstraint: NSLayoutConstraint!
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        view.bringSubviewToFront(topView)
        profileImageView.addTapGestureRecognizer { [weak self] tap in
            self?.profileClosure?()
        }
        coverHeightConstraint.constant = HeaderDimensions.maxHeaderHeight
        
        animateCover()
        applyStyle()
        
        profileWidthConstraint.constant = HeaderDimensions.maxProfileSize
        profileHeightConstraint.constant = HeaderDimensions.maxProfileSize
        profileBottomConstraint.constant = HeaderDimensions.halfOfMaxProfileSize
        guard let navH = navigationController?.navigationBar.frame.maxY else { return }
        HeaderDimensions.minHeaderHeight = navH
    }
    
    open override func applyStyle() {
        super.applyStyle()
        
        let style = styleProvider?.navigation?.clear
        topView.backgroundColor = style?.backgroundColor
        nameLabel.font = style?.titleLabel.font
        nameLabel.alpha = 0

        navigationController?.navigationBar.tintColor = style?.barTintColour
        navigationController?.navigationBar.barTintColor = style?.backgroundColor
        navigationController?.navigationBar.isTranslucent = style?.translucency ?? false
        
        guard let titleStyle = style?.titleLabel, let titleColor = titleStyle.color, let titleFont = titleStyle.font  else { return }
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : titleColor,
                                                                   NSAttributedString.Key.font : titleFont]

    }
    
    struct HeaderDimensions {
        static var minHeaderHeight: CGFloat = 64;
        static let maxHeaderHeight: CGFloat = 156;
        
        static let minNameHeight: CGFloat = 95
        static let maxNameHeight: CGFloat = 115
        
        static let minProfileSize: CGFloat = 60;
        static let maxProfileSize: CGFloat = 100;
        static let profileScaleMultiplier: CGFloat = 1.5
        
        static let halfOfMaxProfileSize: CGFloat = 45
        static let profileBottomMovementMultiplier: CGFloat = 0.5
        static let profileBottomLimitToPop: CGFloat = 96
        
        static var additionalContentHeight: CGFloat = 80;
        static var additionalContentMinPosition: CGFloat? = nil;
        static var additionalContentNonCollapsingHeight: CGFloat = 0;
    }
    
    public func didScroll(_ scrollView: UIScrollView?) {
        guard let scrollView = scrollView else { return }
        showNameLabel(scrollView)
        resizeProfile(scrollView)
        resizeCover(scrollView)
    }
    
    public func didEndDecelerating(_ scrollView: UIScrollView?) {
        scrollViewDidStopScrolling()
    }
    
    public func didEndDragging(_ scrollView: UIScrollView?, willDecelerate decelerate: Bool) {
        if !decelerate {
            scrollViewDidStopScrolling()
        }
    }
    
    private func showNameLabel(_ scrollView: UIScrollView) {
        let range = HeaderDimensions.maxNameHeight - HeaderDimensions.minNameHeight
        let value = min((scrollView.contentOffset.y - HeaderDimensions.minNameHeight), range) / range
        nameLabel.alpha = value
    }
    
    private func resizeProfile(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > HeaderDimensions.profileBottomLimitToPop {
            topView.bringSubviewToFront(coverImageView)
        } else if scrollView.contentOffset.y < HeaderDimensions.profileBottomLimitToPop {
            topView.bringSubviewToFront(profileImageView)
        }
        topView.bringSubviewToFront(nameLabel)
        
        let profileSizeDiff = max(HeaderDimensions.minProfileSize, HeaderDimensions.maxProfileSize - scrollView.contentOffset.y * HeaderDimensions.profileScaleMultiplier)
        profileWidthConstraint.constant = profileSizeDiff
        profileHeightConstraint.constant = profileSizeDiff
        
        let profileBottomDiff: CGFloat = min( -scrollView.contentOffset.y * HeaderDimensions.profileBottomMovementMultiplier + HeaderDimensions.halfOfMaxProfileSize, HeaderDimensions.halfOfMaxProfileSize)
        profileBottomConstraint.constant = profileBottomDiff
        
        let range = HeaderDimensions.maxProfileSize - HeaderDimensions.minProfileSize
        let value = min((scrollView.contentOffset.y - HeaderDimensions.minProfileSize), range) / range
        profileImageView.alpha = 1 - value
        
        if HeaderDimensions.additionalContentMinPosition == nil, coverImageView.frame.maxY >= additionalContentView.frame.maxY - HeaderDimensions.additionalContentNonCollapsingHeight {
            HeaderDimensions.additionalContentMinPosition = additionalContentTopConstraint.constant
        }
        guard let topPostion = HeaderDimensions.additionalContentMinPosition else {
            additionalContentTopConstraint.constant = -scrollView.contentOffset.y
            return
        }
        additionalContentTopConstraint.constant = max(topPostion, -scrollView.contentOffset.y)
    }
    
    private func resizeCover(_ scrollView: UIScrollView) {
        let coverDiff = max(HeaderDimensions.minHeaderHeight, HeaderDimensions.maxHeaderHeight - scrollView.contentOffset.y)
        // Header needs to animate
        if coverDiff != coverHeightConstraint.constant {
            coverHeightConstraint.constant = coverDiff
            animateCover()
        }
    }
    
    private func animateCover() {
        let range = HeaderDimensions.maxHeaderHeight - HeaderDimensions.minHeaderHeight
        let openAmount = coverHeightConstraint.constant - HeaderDimensions.minHeaderHeight
        let percentage = openAmount / range
        blurView?.alpha = 1 - percentage
    }
    
    func scrollViewDidStopScrolling() {
        let range = HeaderDimensions.maxHeaderHeight - HeaderDimensions.minHeaderHeight
        let midPoint = HeaderDimensions.minHeaderHeight + (range / 2)
        
        if coverHeightConstraint.constant > midPoint {
            expandHeader()
        } else {
            collapseHeader()
        }
    }
    
    func collapseHeader() {
        view.layoutIfNeeded()
        UIView.animate(withDuration: 0.1, delay: 0, options: .beginFromCurrentState, animations: {
            self.coverHeightConstraint.constant = HeaderDimensions.minHeaderHeight
            self.animateCover()
            self.view.layoutIfNeeded()
        })
    }
    
    func expandHeader() {
        view.layoutIfNeeded()
        UIView.animate(withDuration: 0.1, delay: 0, options: .beginFromCurrentState, animations: {
            self.coverHeightConstraint.constant = HeaderDimensions.maxHeaderHeight
            self.animateCover()
            self.view.layoutIfNeeded()
        })
    }
    
    var blurView: UIVisualEffectView?
    var vibrancyView: UIVisualEffectView?    
    
    public func makeBlurredHeader(with image: UIImage) {
        
        coverImageView.image = image
        
        if self.blurView == nil, self.vibrancyView == nil {
            let blur = UIBlurEffect(style: .light)
            let blurView = UIVisualEffectView(effect: blur)
            blurView.translatesAutoresizingMaskIntoConstraints = false
            coverImageView.insertSubview(blurView, at: 0)
            NSLayoutConstraint.activate([blurView.topAnchor.constraint(equalTo: coverImageView.topAnchor),
                                         blurView.bottomAnchor.constraint(equalTo: coverImageView.bottomAnchor),
                                         blurView.leftAnchor.constraint(equalTo: coverImageView.leftAnchor),
                                         blurView.rightAnchor.constraint(equalTo: coverImageView.rightAnchor),])
            let vibrancy = UIVibrancyEffect(blurEffect: blur)
            let vibrancyView = UIVisualEffectView(effect: vibrancy)
            vibrancyView.translatesAutoresizingMaskIntoConstraints = false
            blurView.contentView.addSubview(vibrancyView)
            NSLayoutConstraint.activate([vibrancyView.topAnchor.constraint(equalTo: coverImageView.topAnchor),
                                         vibrancyView.bottomAnchor.constraint(equalTo: coverImageView.bottomAnchor),
                                         vibrancyView.leftAnchor.constraint(equalTo: coverImageView.leftAnchor),
                                         vibrancyView.rightAnchor.constraint(equalTo: coverImageView.rightAnchor),])            
            topView.bringSubviewToFront(nameLabel)
            
            blurView.alpha = 0
            self.blurView = blurView
            self.vibrancyView = vibrancyView
        }
    }
}
