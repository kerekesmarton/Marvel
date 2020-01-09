///
//  IosCore
//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import UIKit
import Presentation
import SnapKit

public protocol SegmentedHeaderAnimatableView {
    func animate(by factor: CGFloat)
}

open class SegmentedHeaderViewController: ViewController, SegmentsRouterDelegate {
    
    // Constants
    public var stickyheaderContainerViewHeight: CGFloat {
        return self.enableCoverView ? 125 : 44
    }
    
    let bouncingThreshold: CGFloat = 100
    
    var scrollToScaleDownProfileIconDistance: CGFloat {
        return stickyheaderContainerViewHeight
    }
    
    public var enableCoverView = true {
        didSet {
            mainScrollView.bounces = enableCoverView
        }
    }
    
    open var contentViewHeight: CGFloat = 160 {
        didSet { view.setNeedsLayout() }
    }
    
    let segmentedControlContainerHeight: CGFloat = 46
    
    open var coverImage: UIImage? {
        didSet { headerCoverView?.image = coverImage }
    }
    
    // Properties
    
    var currentIndex: Int?
    
    var scrollViews: [UIScrollView] = []
    weak public var currentScrollView: UIScrollView?
    
    fileprivate var mainScrollView: UIScrollView!
    
    var headerCoverView: UIImageView!
    
    public var contentView: (UIView & SegmentedHeaderAnimatableView)?
    var stickyHeaderContainerView: UIView!
    
    public var blurEffectView: UIVisualEffectView!
    
    public var segmentedControlContainer: UIView!
    
    public var navigationTitleLabel: UILabel!
    public var navigationDetailLabel: UILabel!
    
    public var segmentedControl: SegmentedTabsView?
    
    public weak var router: SegmentsRouter? {
        didSet { router?.delegate = self }
    }
    
    deinit {
        scrollViews.forEach { (scrollView) in
            scrollView.removeFromSuperview()
        }
        scrollViews.removeAll()
        children.forEach {
            $0.willMove(toParent: nil)
            $0.removeFromParent()
            $0.didMove(toParent: nil)
        }
        mainScrollView = nil
        router?.removeViewControllers()
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        setNeedsStatusBarAppearanceUpdate()
        prepareViews()
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let index = currentIndex else { return }
        router?.viewController(at: index)?.viewWillAppear(animated)
    }    
    
    override open func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        contentViewHeight = contentView?.sizeThatFits(mainScrollView.bounds.size).height ?? 0
        
        // configure layout frames
        stickyHeaderContainerView.frame = computeStickyHeaderContainerViewFrame()
        
        contentView?.frame = computeProfileHeaderViewFrame()
        
        segmentedControlContainer.frame = computeSegmentedControlContainerFrame()
        
        scrollViews.forEach({ (scrollView) in
            scrollView.frame = computeTableViewFrame(tableView: scrollView)
            scrollView.isScrollEnabled = false
        })
        
        updateMainScrollViewFrame()
        
        mainScrollView.scrollIndicatorInsets = computeMainScrollViewIndicatorInsets()
    }
    
    public func childDidUpdate(_ scrollView: UIScrollView) {
        update(scrollview: scrollView, scrollToTop: false)
    }
    
    private func update(scrollview: UIScrollView, scrollToTop: Bool) {
        guard let aScrollView = currentScrollView else {
            return
        }
        aScrollView.frame = computeTableViewFrame(tableView: aScrollView)
        updateMainScrollViewFrame()
        
        // auto scroll to top if mainScrollView.contentOffset > navigationHeight + segmentedControl.height
        let navigationHeight = scrollToScaleDownProfileIconDistance
        let threshold = computeProfileHeaderViewFrame().lf_originBottom - navigationHeight
        
        if mainScrollView.contentOffset.y > threshold, scrollToTop {
            mainScrollView.setContentOffset(CGPoint(x: 0, y: threshold), animated: false)
        }
        
    }
    
    
    //MARK: - SegmentsRouterDelegate
    
    func numberOfSegments() -> Int {
        return segments.count
    }
    
    func segmentTitle(forSegment index: Int) -> String {
        return segments[index].title
    }
    
    public func setSelected(index: Int) {
        segmentedControl?.selectedIndex = index
        segmentedControlValueDidChange(index, previous: currentIndex)
    }
    
    public var segments = [SegmentedDisplayable]() {
        didSet { didSetSegments() }
    }
    
    internal func segmentedControlValueDidChange(_ index: Int, previous: Int?) {
        currentIndex = index
        
        guard let vc = router?.viewController(at: index) as? (UIViewController & SegmentsRoutableChild),
            let scrollViewToBeShown = vc.routableScrollView else { return }
        currentScrollView = scrollViewToBeShown
        
        let animated = false
        vc.viewWillAppear(animated)
        if let previous = previous, let previousVC = router?.viewController(at: previous) as? (UIViewController & SegmentsRoutableChild) {
            previousVC.viewWillDisappear(animated)
        }
        //hide scrollViews
        scrollViews.forEach { (scrollView) in
            scrollView.isHidden = scrollView != scrollViewToBeShown
        }
        
        if let current = currentScrollView {
            update(scrollview: current, scrollToTop: true)
        }
        
        vc.viewDidAppear(animated)
        if let previous = previous, let previousVC = router?.viewController(at: previous) as? (UIViewController & SegmentsRoutableChild) {
            previousVC.viewDidDisappear(animated)
        }
    }
    
    public func didSetSegments() {
        let titles = segments.map { return $0.title }
        segmentedControl?.updateSource(titles: titles, didChangeValue: { [weak self] itemNumber, previousItemNumber in
            self?.segmentedControlValueDidChange(itemNumber, previous: previousItemNumber)
        })
        setupScrollViews()
        segmentedControlValueDidChange(currentIndex ?? 0, previous: nil)
    }
    
    open func setupContentView(_ _mainScrollView: UIScrollView) {
    }
    
    open func userNameToDisplay() -> String {
        return "{username}"
    }
    
    open func titleToDisplay() -> String {
        return "{title}"
    }
    
    // When scrollView reached the top edge of Title label
    open func animateNavigationTitle(offset: CGPoint) {
        
    }
    
    public func setupScrollViews() {
        scrollViews.forEach { (view) in
            view.removeFromSuperview()
        }
        children.forEach { (vc) in
            vc.willMove(toParent: nil)
            vc.removeFromParent()
            vc.didMove(toParent: nil)
        }
        router?.viewControllers?.forEach({ (vc) in
            let child = vc as? SegmentsRoutableChild
            child?.delegate = router
            
            vc.willMove(toParent: self)
            addChild(vc)
            vc.didMove(toParent: self)
            
            guard let scrollView = child?.routableScrollView else {
                return
            }
            
            scrollViews.append(scrollView)
            scrollView.isHidden = true
            mainScrollView.addSubview(scrollView)
        })
    }
    
    func prepareViews() {
        let _mainScrollView = TouchRespondScrollView(frame: view.bounds)
        _mainScrollView.delegate = self
        _mainScrollView.showsHorizontalScrollIndicator = false
        
        mainScrollView = _mainScrollView
        mainScrollView.contentInset = .zero
        view.addSubview(_mainScrollView)
        
        _mainScrollView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        
        // sticker header Container view
        let _stickyHeaderContainer = UIView()
        _stickyHeaderContainer.clipsToBounds = true
        _mainScrollView.addSubview(_stickyHeaderContainer)
        stickyHeaderContainerView = _stickyHeaderContainer
        
        // Cover Image View
        let coverImageView = UIImageView()
        coverImageView.clipsToBounds = true
        _stickyHeaderContainer.addSubview(coverImageView)
        coverImageView.snp.makeConstraints { (make) in
            make.edges.equalTo(_stickyHeaderContainer)
        }
        
        coverImageView.image = UIImage(named: "background.png")
        coverImageView.contentMode = .scaleAspectFill
        coverImageView.clipsToBounds = true
        headerCoverView = coverImageView
        
        // blur effect on top of coverImageView
        let blurEffect = UIBlurEffect(style: .dark)
        let _blurEffectView = UIVisualEffectView(effect: blurEffect)
        _blurEffectView.alpha = 0
        blurEffectView = _blurEffectView
        
        _stickyHeaderContainer.addSubview(_blurEffectView)
        _blurEffectView.snp.makeConstraints { (make) in
            make.edges.equalTo(_stickyHeaderContainer)
        }
        
        // Detail Title
        let _navigationDetailLabel = UILabel()
        _navigationDetailLabel.text = " "
        _navigationDetailLabel.textColor = UIColor.white
        _navigationDetailLabel.font = UIFont.boldSystemFont(ofSize: 13.0)
        _stickyHeaderContainer.addSubview(_navigationDetailLabel)
        _navigationDetailLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(_stickyHeaderContainer.snp.centerX)
            make.bottom.equalTo(_stickyHeaderContainer.snp.bottom).inset(12)
        }
        navigationDetailLabel = _navigationDetailLabel
        
        // Navigation Title
        let _navigationTitleLabel = UILabel()
        _navigationTitleLabel.text = userNameToDisplay()
        _navigationTitleLabel.textColor = UIColor.white
        _navigationTitleLabel.font = UIFont.boldSystemFont(ofSize: 17.0)
        _stickyHeaderContainer.addSubview(_navigationTitleLabel)
        
        _navigationTitleLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(_stickyHeaderContainer.snp.centerX)
            make.bottom.equalTo(_navigationDetailLabel.snp.top).offset(0)
        }
        navigationTitleLabel = _navigationTitleLabel
        
        // preset the navigation title and detail at progress=0 position
        animateNavigationTitleAt(progress: 0)
        
        setupContentView(_mainScrollView)
        
        // Segmented Control Container
        let _segmentedControlContainer = UIView.init(frame: CGRect.init(x: 0, y: 0, width: mainScrollView.bounds.width, height: 100))
        _segmentedControlContainer.backgroundColor = UIColor.white
        _mainScrollView.addSubview(_segmentedControlContainer)
        segmentedControlContainer = _segmentedControlContainer
        
        // Segmented Control
        
        let _segmentedControl = SegmentedTabsView.makeFromNib()!
        _segmentedControlContainer.addSubview(_segmentedControl)
        _segmentedControl.snp.makeConstraints { (make) in
            make.width.equalToSuperview().offset(-16)
            make.centerX.equalToSuperview()
            make.centerY.equalTo(_segmentedControlContainer.snp.centerY)
        }
        segmentedControl = _segmentedControl
    }
    
    func computeStickyHeaderContainerViewFrame() -> CGRect {
        return CGRect(x: 0, y: 0, width: mainScrollView.bounds.width, height: stickyheaderContainerViewHeight)
    }
    
    func computeProfileHeaderViewFrame() -> CGRect {
        return CGRect(x: 0, y: computeStickyHeaderContainerViewFrame().origin.y + stickyheaderContainerViewHeight, width: mainScrollView.bounds.width, height: contentViewHeight)
    }
    
    func computeTableViewFrame(tableView: UIScrollView) -> CGRect {
        let upperViewFrame = computeSegmentedControlContainerFrame()
        tableView.layoutIfNeeded()
        return CGRect(x: 0, y: upperViewFrame.origin.y + upperViewFrame.height , width: mainScrollView.bounds.width, height: tableView.contentSize.height)
    }
    
    func computeMainScrollViewIndicatorInsets() -> UIEdgeInsets {
        return UIEdgeInsets(top: computeSegmentedControlContainerFrame().lf_originBottom, left: 0, bottom: 0, right: 0)
    }
    
    func computeNavigationFrame() -> CGRect {
        return headerCoverView.convert(headerCoverView.bounds, to: view)
    }
    
    func computeSegmentedControlContainerFrame() -> CGRect {
        let rect = computeProfileHeaderViewFrame()
        return CGRect(x: 0, y: rect.origin.y + rect.height, width: mainScrollView.bounds.width, height: segmentedControlContainerHeight)
    }
    
    func updateMainScrollViewFrame() {
        
        guard let currentScrollView = currentScrollView else { return }
        
        mainScrollView.contentSize = CGSize(
            width: view.bounds.width,
            height: stickyheaderContainerViewHeight + contentViewHeight + segmentedControlContainer.bounds.height + currentScrollView.bounds.height)
    }
    
    public func scrollToTop() {
        mainScrollView?.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
}

extension SegmentedHeaderViewController: UIScrollViewDelegate {
    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let contentOffset = scrollView.contentOffset
        
        // sticky headerCover
        if contentOffset.y <= 0 {
            let bounceProgress = min(1, abs(contentOffset.y) / bouncingThreshold)
            
            let newHeight = abs(contentOffset.y) + stickyheaderContainerViewHeight
            
            // adjust stickyHeader frame
            stickyHeaderContainerView.frame = CGRect(
                x: 0,
                y: contentOffset.y,
                width: mainScrollView.bounds.width,
                height: newHeight)
            
            // blurring effect amplitude
            blurEffectView.alpha = min(1, bounceProgress * 2)
            
            // scaling effect
            let scalingFactor = 1 + min(log(bounceProgress + 1), 2)
            //      print(scalingFactor)
            headerCoverView.transform = CGAffineTransform(scaleX: scalingFactor, y: scalingFactor)
            
            // adjust mainScrollView indicator insets
            var baseInset = computeMainScrollViewIndicatorInsets()
            baseInset.top += abs(contentOffset.y)
            mainScrollView.scrollIndicatorInsets = baseInset
            guard let contentView = contentView else {
                return
            }
            mainScrollView.bringSubviewToFront(contentView)
        } else {
            
            // anything to be set if contentOffset.y is positive
            blurEffectView.alpha = 0
            mainScrollView.scrollIndicatorInsets = computeMainScrollViewIndicatorInsets()
        }
        
        // Universal
        // applied to every contentOffset.y
        let scaleProgress = max(0, min(1, contentOffset.y / scrollToScaleDownProfileIconDistance))
        contentView?.animate(by: scaleProgress)
        
        if contentOffset.y > 0 {
            
            // When scroll View reached the threshold
            if contentOffset.y >= scrollToScaleDownProfileIconDistance {
                stickyHeaderContainerView.frame = CGRect(x: 0, y: contentOffset.y - scrollToScaleDownProfileIconDistance, width: mainScrollView.bounds.width, height: stickyheaderContainerViewHeight)
                
                // bring stickyHeader to the front
                mainScrollView.bringSubviewToFront(stickyHeaderContainerView)
            } else if let contentView = contentView {
                mainScrollView.bringSubviewToFront(contentView)
                stickyHeaderContainerView.frame = computeStickyHeaderContainerViewFrame()
            }
            
            // Sticky Segmented Control
            let navigationLocation = CGRect(x: 0, y: 0, width: stickyHeaderContainerView.bounds.width, height: stickyHeaderContainerView.frame.origin.y - contentOffset.y + stickyHeaderContainerView.bounds.height)
            let navigationHeight = navigationLocation.height - abs(navigationLocation.origin.y)
            let segmentedControlContainerLocationY = stickyheaderContainerViewHeight + contentViewHeight - navigationHeight
            
            if contentOffset.y > 0 && contentOffset.y >= segmentedControlContainerLocationY {
                //    if segmentedControlLocation.origin.y <= navigationHeight {
                segmentedControlContainer.frame = CGRect(x: 0, y: contentOffset.y + navigationHeight, width: segmentedControlContainer.bounds.width, height: segmentedControlContainer.bounds.height)
            } else {
                segmentedControlContainer.frame = computeSegmentedControlContainerFrame()
            }
            
            animateNavigationTitle(offset: contentOffset)
        }
        // Segmented control is always on top in any situations
        mainScrollView.bringSubviewToFront(segmentedControlContainer)
        
        router?.viewControllers?.forEach { (vc) in
            guard let child = vc as? SegmentsRoutableChild else {
                return
            }
            let maxVisiblePoint = CGPoint(x: 0, y: mainScrollView.contentOffset.y + mainScrollView.frame.height)
            if let tableView = child.routableScrollView as? UITableView, let visibleIndex = tableView.indexPathForRow(at: maxVisiblePoint) {
                child.didScroll(to: visibleIndex)
            }
            
            if let collectionView = child.routableScrollView as? UICollectionView {
                let x1 = collectionView.frame.width / 4
                let maxVisiblePoint1 = CGPoint(x: x1, y: mainScrollView.contentOffset.y + mainScrollView.frame.height)
                let x2 = x1 * 3
                let maxVisiblePoint2 = CGPoint(x: x2, y: mainScrollView.contentOffset.y + mainScrollView.frame.height)
             
                if let visibleIndex = collectionView.indexPathForItem(at: maxVisiblePoint2) {
                    child.didScroll(to: visibleIndex)
                } else if let visibleIndex = collectionView.indexPathForItem(at: maxVisiblePoint1){
                    child.didScroll(to: visibleIndex)
                }
            }
        }
    }
}

// MARK: Animators
extension SegmentedHeaderViewController {
    public func animateNavigationTitleAt(progress: CGFloat) {
        
        guard let superview = navigationDetailLabel?.superview else {
            return
        }
        
        let totalDistance: CGFloat = 75
        
        if progress >= 0 {
            let distance = (1 - progress) * totalDistance
            navigationDetailLabel.snp.updateConstraints({ (make) in
                make.bottom.equalTo(superview.snp.bottom).inset(8 - distance)
            })
        }
    }
}

// status bar style override
extension SegmentedHeaderViewController {
    override open var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

// Table View Switching

extension CGRect {
    var lf_originBottom: CGFloat {
        return origin.y + height
    }
}
