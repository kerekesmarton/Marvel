//
//  IosCore
//
//  Copyright © 2018 mkerekes. All rights reserved.
//


import UIKit

extension UIResponder {

    private struct Keys {
        static var emptyStateView = "com.emptyStateView"
        static var emptyStateDataSource = "com.emptyStateDataSource"
        static var emptyStateDelegate = "com.emptyStateDelegate"
    }
    
    public var emptyStateDataSource: EmptyStateDataSource? {
        get { return objc_getAssociatedObject(self, &Keys.emptyStateDataSource)  as? EmptyStateDataSource }
        set { objc_setAssociatedObject(self, &Keys.emptyStateDataSource, newValue, .OBJC_ASSOCIATION_ASSIGN) }
    }
    
    public var emptyStateDelegate: EmptyStateDelegate? {
        get { return objc_getAssociatedObject(self, &Keys.emptyStateDelegate) as? EmptyStateDelegate }
        set { objc_setAssociatedObject(self, &Keys.emptyStateDelegate, newValue, .OBJC_ASSOCIATION_ASSIGN) }
    }

    public private(set) var emptyView: UIView? {
        get { return objc_getAssociatedObject(self, &Keys.emptyStateView) as? UIView }
        set {
            objc_setAssociatedObject(self, &Keys.emptyStateView, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            if let view = emptyView as? EmptyStateView { view.delegate = emptyStateDelegate }
        }
    }
    
    func finishReload(for source: EmptyStateDataSource, in superView: UIView) {
        let emptyView = showView(for: source, in: superView)
        
        if emptyView.constraints.count <= 2 {
            createViewConstraints(for: emptyView, in: superView, source: source)
        }
        
        emptyStateDelegate?.emptyStateViewDidShow(view: emptyView)
    }
    
    private func createViewConstraints(for view: UIView, in superView: UIView, source: EmptyStateDataSource) {
        
        var centerYOffset: CGFloat?
        if let tableHeader = (superView as? UITableView)?.tableHeaderView {
            centerYOffset = tableHeader.frame.height / 2.0
        }
        var centerY = view.centerYAnchor.constraint(equalTo: superView.centerYAnchor)
        var centerX = view.centerXAnchor.constraint(equalTo: superView.centerXAnchor, constant: centerYOffset ?? 0)
        centerX.isActive = true
        centerY.isActive = true
        
        if source.emptyStateViewAdjustsToFitBars {
            centerX.isActive = false
            centerX = view.centerXAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.centerXAnchor)
            centerX.isActive = true
            centerY.isActive = false
            centerY = view.centerYAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.centerYAnchor, constant: centerYOffset ?? 0)
            centerY.isActive = true
        }
    }
    
    private func showView(for source: EmptyStateDataSource, in superview: UIView) -> UIView {
        if let createdView = emptyView {
            emptyStateDelegate?.emptyStateViewWillShow(view: createdView)
            
            createdView.isHidden = false
            guard let view = createdView as? EmptyStateView else { return createdView }
            
            view.backgroundColor = source.emptyStateBackgroundColor
            view.title = source.emptyStateTitle
            view.image = source.emptyStateImage
            view.imageSize = source.emptyStateImageSize
            view.imageViewTintColor = source.emptyStateImageViewTintColor
            view.buttonDataModel = source.emptyStateButtonModel
            view.buttonSize = source.emptyStateButtonSize
            view.detailMessage = source.emptyStateDetailMessage
            view.spacing = source.emptyStateViewSpacing
            view.centerYOffset = source.emptyStateViewCenterYOffset
            view.backgroundColor = source.emptyStateBackgroundColor
            
            if source.emptyStateViewCanAnimate && source.emptyStateViewAnimatesEverytime {
                DispatchQueue.main.async {
                    source.emptyStateViewAnimation(
                        for: view,
                        animationDuration: source.emptyStateViewAnimationDuration,
                        completion: { [weak self] finished in
                            self?.emptyStateDelegate?.emptyStateViewAnimationCompleted(for: view, didFinish: finished)
                    })
                }
            }
            return view
        } else {
            let newView = source.emptyStateView
            emptyStateDelegate?.emptyStateViewWillShow(view: newView)
            emptyView = newView
            superview.addSubview(newView)
            superview.bringSubviewToFront(newView)
            superview.clipsToBounds = emptyStateDelegate?.superviewShouldClip() ?? true
            if source.emptyStateViewCanAnimate {
                DispatchQueue.main.async {
                    source.emptyStateViewAnimation(
                        for: newView,
                        animationDuration: source.emptyStateViewAnimationDuration,
                        completion: { [weak self] finished in
                            self?.emptyStateDelegate?.emptyStateViewAnimationCompleted(for: newView, didFinish: finished)
                    })
                }
            }
            return newView
        }
    }
    
}

extension UITableViewController {
    
    public func reloadEmptyState() {
        reloadEmptyStateForTableView(tableView)
    }
    
    public func reloadEmptyStateForTableView(_ tableView: UITableView) {
        
        guard let source = emptyStateDataSource else {
            return
        }
        guard source.emptyStateViewShouldShow(for: tableView) else {
            
            if let view = emptyView {
                emptyStateDelegate?.emptyStateViewWillHide(view: view)
            }
            
            emptyView?.isHidden = true
            tableView.isScrollEnabled = source.emptyStateViewCanScroll
            
            if emptyStateDataSource?.emptyStateViewAdjustsToFitBars ?? false {
                edgesForExtendedLayout = .all
            }
            
            return
            
        }
        
        emptyView?.isHidden = false
        tableView.isScrollEnabled = source.emptyStateViewCanScroll
        finishReload(for: source, in: tableView)
    
    }

}

extension UITableView {
    public func reloadEmptyState() {
        guard let source = emptyStateDataSource else {
            return
        }
        guard source.emptyStateViewShouldShow(for: self) else {
            if let view = emptyView {
                emptyStateDelegate?.emptyStateViewWillHide(view: view)
            }
            emptyView?.isHidden = true
            isScrollEnabled = source.emptyStateViewCanScroll
            return
        }
        isScrollEnabled = source.emptyStateViewCanScroll
        finishReload(for: source, in: self)
    }
}

extension UICollectionViewController {
    public func reloadEmptyState() {
        reloadEmptyStateForCollectionView(collectionView)
    }
    
    public func reloadEmptyStateForCollectionView(_ collectionView: UICollectionView) {
        guard let source = emptyStateDataSource else {
            return
        }
        guard source.emptyStateViewShouldShow(for: collectionView) else {
                if let view = emptyView {
                    emptyStateDelegate?.emptyStateViewWillHide(view: view)
                }
                emptyView?.isHidden = true
                collectionView.isScrollEnabled = source.emptyStateViewCanScroll
                if emptyStateDataSource?.emptyStateViewAdjustsToFitBars ?? false {
                    edgesForExtendedLayout = .all
                }
                return
        }
        collectionView.isScrollEnabled = source.emptyStateViewCanScroll
        finishReload(for: source, in: collectionView)
    }
}

extension UICollectionView {
    public func reloadEmptyState() {
        guard let source = emptyStateDataSource else {
            return
        }
        guard source.emptyStateViewShouldShow(for: self) else {
            if let view = emptyView {
                emptyStateDelegate?.emptyStateViewWillHide(view: view)
            }
            emptyView?.isHidden = true
            isScrollEnabled = source.emptyStateViewCanScroll
            return
        }
        isScrollEnabled = source.emptyStateViewCanScroll
        finishReload(for: source, in: self)
    }
}
