//
//  UI
//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import UIKit
import Presentation
import Domain

open class TableViewController: UITableViewController, Styleable, PresentationOutput {
    
    public var headerTitle:String? {
        didSet{
            if let headerTitle = headerTitle{
                print(tableView.separatorInset)
                tableView.tableHeaderView = TitleView(title: headerTitle,
                                                      style: styleProvider?.list?.tableHeaderTitleStyle,
                                                      padding: .init(top: 21, left: 16, bottom: 19, right: 16),
                                                      frame: .init(origin: .zero,
                                                                   size: .init(width: tableView.frame.width,
                                                                               height: 64)))
            }
            else{
                tableView.tableHeaderView = nil
            }
        }
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        applyStyle()
        tableView.keyboardDismissMode = .interactive
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    open func reload() {
        tableView.reloadData()
    }
    
    open func update(index: IndexPath, height: Double) {
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    open func update(index: IndexPath) {
        tableView.performBatchUpdates({
            tableView.reloadRows(at: [index], with:.automatic)
        }, completion: nil)
    }
    
    open func reload(at index: IndexPath) {
        tableView.reloadRows(at: [index], with: .fade)
    }
    
    open func reloadSections(at indexs: [IndexPath]) {
        tableView.reloadSections(IndexSet(indexs.compactMap { $0.section }), with: .none)
    }
    
    open func insertSections(at indexs: [IndexPath]) {
        let array = indexs.compactMap { $0.section }
        tableView.performBatchUpdates({
            tableView.insertSections(IndexSet(array), with: .fade)
        }, completion: nil)
    }
    
    open func insertItems(at indexs: [IndexPath]) {
        tableView.performBatchUpdates({
            tableView.insertRows(at: indexs, with: .fade)
        }, completion: nil)
    }
    
    open func fadeOutSections(at indexs: [IndexPath]) {
        tableView.performBatchUpdates({
            tableView.deleteSections(IndexSet(indexs.compactMap { $0.section }), with: .fade)
        }, completion: nil)
    }
    
    open func fadeOutItems(at indexs: [IndexPath]) {
        tableView.performBatchUpdates({
            tableView.deleteRows(at: indexs, with: .fade)
        }, completion: nil)
    }
    
    //MARK: - Stylable
    open var styleProvider: StyleProviding? {
        return StyleManager.shared.styleProvider
    }
    
    open func applyStyle() {
        tableView.separatorInset = .zero
    }
    
    public func registerCell(cellClass: AnyClass, with tableView: UITableView, reuseIdentifier: String? = nil) {
        guard let cellName = NSStringFromClass(cellClass.self).components(separatedBy: ".").last else {
            fatalError("missing name")
        }
        let identifier = reuseIdentifier ?? cellName
        tableView.register(UINib(nibName: cellName, bundle: Bundle(for: cellClass)), forCellReuseIdentifier: identifier)
    }
    
    open var state: PresentationOutputState? {
        didSet {
            switch state {
            case .loading:
                showActivityIndicator()
            default:
                hideActivityIndicator()
            }
        }
    }
    
    open func showActivityIndicator() {
        if let nav = navigationController {
            showActivityIndicatorOn(nav.view)
        } else {
            showActivityIndicatorOn(view)
        }
    }
    
    open func hideActivityIndicator() {
        removeActivityIndicator()
    }
    
}

extension TableViewController: UIPopoverPresentationControllerDelegate, UIViewControllerTransitioningDelegate, ToastPresentationStyleable {
    
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return makePresentationController(forPresented: presented, presenting: presenting, source: source)
    }
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return makeAnimationController(forPresented: presented, presenting: presenting, source: source)
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return makeAnimationController(forDismissed: dismissed)
    }
    
    public func style(for message: InAppMessage) -> ToastPresentationStyle {
        return .bottom(totalHeight: 60, bottomOffset: view.safeAreaInsets.bottom)
    }
}
