///
//  IosCore
//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import Foundation
import SnapKit
import Presentation

open class SegmentedViewController: ViewController, SegmentsRouterDelegate {
    
    public var enableSegmentedControl = true
    var segmentedControlContainerHeight: CGFloat {
        return enableSegmentedControl ? 46 : .zero
    }
    var currentIndex: Int?
    
    var scrollViews: [UIScrollView] = []
    weak var currentScrollView: UIScrollView?
    
    private var mainScrollView: UIScrollView!
    
    var segmentedControlContainer: UIView!
    
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
        
        segmentedControlContainer.frame = computeSegmentedControlContainerFrame()
        
        scrollViews.forEach({ (scrollView) in
            scrollView.frame = computeTableViewFrame(tableView: scrollView)
            scrollView.isScrollEnabled = false
        })
        
        updateMainScrollViewFrame()
        
        mainScrollView.scrollIndicatorInsets = computeMainScrollViewIndicatorInsets()
    }
    
    
    //MARK: - SegmentsRouterDelegate
    func numberOfSegments() -> Int {
        return segments.count
    }
    
    func segmentTitle(forSegment index: Int) -> String {
        return segments[index].title
    }
    
    open func setSelected(index: Int) {
        segmentedControl?.selectedIndex = index
        segmentedControlValueDidChange(index, previous: currentIndex)
    }
    
    public func deselect() {
        currentIndex = nil
    }
    
    public var segments = [SegmentedDisplayable]() {
        didSet { didSetSegments() }
    }
    
    public func childDidUpdate(_ scrollView: UIScrollView) {
        update(scrollview: scrollView, scrollToTop: false)
    }
    
    private func update(scrollview: UIScrollView, scrollToTop: Bool) {
        
        scrollview.frame = view.frame //computeTableViewFrame(tableView: scrollview)
        updateMainScrollViewFrame()

        if scrollToTop {
            mainScrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
        }
        
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
    
    open func didSetSegments() {
        let titles = segments.map { return $0.title }
        segmentedControl?.updateSource(titles: titles, didChangeValue: { [weak self] itemNumber, previousItemNumber in
            self?.segmentedControlValueDidChange(itemNumber, previous: previousItemNumber)
        })
        setupScrollViews()
        segmentedControlValueDidChange(currentIndex ?? 0, previous: nil)
    }
    
    open func userNameToDisplay() -> String {
        return "{username}"
    }
    
    open func titleToDisplay() -> String {
        return "{title}"
    }
    
    // When scrollView reached the top edge of Title label
    open func animateNavigationTitle(offset: CGPoint) {}
    
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
            
            guard let scrollView = child?.routableScrollView else { return }
            
            scrollView.clipsToBounds = false
            scrollViews.append(scrollView)
            scrollView.isHidden = true
            mainScrollView.addSubview(scrollView)
            
        })
        
    }
    
    func prepareViews() {
        let _mainScrollView = TouchRespondScrollView(frame: view.bounds)
        _mainScrollView.delegate = self
        _mainScrollView.showsHorizontalScrollIndicator = false
        _mainScrollView.keyboardDismissMode = .onDrag
        
        mainScrollView  = _mainScrollView
        
        view.addSubview(_mainScrollView)
        
        _mainScrollView.snp.makeConstraints { (builder) in
            builder.edges.equalToSuperview()
        }
        
        // Segmented Control Container
        let _segmentedControlContainer = UIView(frame: CGRect.init(x: 0, y: 0, width: mainScrollView.bounds.width, height: segmentedControlContainerHeight))
        _segmentedControlContainer.backgroundColor = UIColor.white
        _mainScrollView.addSubview(_segmentedControlContainer)
        segmentedControlContainer = _segmentedControlContainer
        segmentedControlContainer.isHidden = !enableSegmentedControl
        // Segmented Control
        let _segmentedControl = SegmentedTabsView.makeFromNib()!
        segmentedControlContainer.addSubview(_segmentedControl)
        _segmentedControl.snp.makeConstraints { (make) in
            make.width.equalToSuperview().offset(-16)
            make.centerX.equalToSuperview()
            make.centerY.equalTo(_segmentedControlContainer.snp.centerY)
        }
        segmentedControl = _segmentedControl
    }
    
    func computeTableViewFrame(tableView: UIScrollView) -> CGRect {
        let upperViewFrame = computeSegmentedControlContainerFrame()
        tableView.layoutIfNeeded()
        return CGRect(x: 0, y: upperViewFrame.maxY , width: mainScrollView.bounds.width, height: tableView.contentSize.height)
    }
    
    func computeMainScrollViewIndicatorInsets() -> UIEdgeInsets {
        return UIEdgeInsets(top: computeSegmentedControlContainerFrame().lf_originBottom, left: 0, bottom: 0, right: 0)
    }
    
    func computeSegmentedControlContainerFrame() -> CGRect {
        return CGRect(x: 0, y: 0, width: mainScrollView.bounds.width, height: segmentedControlContainerHeight)
    }
    
    func updateMainScrollViewFrame() {
        guard let currentScrollView = currentScrollView else { return }
    
        mainScrollView.frame = view.frame
        mainScrollView.contentSize = CGSize(width: view.bounds.width,
                                            height: segmentedControlContainer.bounds.height + currentScrollView.bounds.height)
        
    }
    
    public func scrollToTop() {
        mainScrollView?.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
}

extension SegmentedViewController: UIScrollViewDelegate {
    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let contentOffset = scrollView.contentOffset
        
        // sticky headerCover
        if contentOffset.y <= 0 {
            // adjust mainScrollView indicator insets
            var baseInset = computeMainScrollViewIndicatorInsets()
            baseInset.top += abs(contentOffset.y)
            mainScrollView.scrollIndicatorInsets = baseInset
        } else {
            
            // anything to be set if contentOffset.y is positive
            mainScrollView.scrollIndicatorInsets = computeMainScrollViewIndicatorInsets()
        }
        
        if contentOffset.y > 0 {
            
            segmentedControlContainer.frame = computeSegmentedControlContainerFrame()
            
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

// status bar style override
extension SegmentedViewController {
    override open var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
