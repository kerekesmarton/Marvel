//
//  UI
//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import Foundation
import Additions
import Domain
import Presentation

open class SegmentsModule: TabModule {
    public let tabIdentifier: String
    public let tab: Int    
    public init(id: String, tab: Int) {
        tabIdentifier = id
        self.tab = tab
    }
    public func setup(title: String, image: String?, config: Configurable) -> (controller: UIViewController, router: Routing) {
        let nav = createNavigation(with: title, imageResource: image, tag: tab)
        let router = SegmentsRouter(nav: nav)
        return (nav, router)
    }
}

public protocol SegmentsRouterDelegate: class {
    var segmentedControl: SegmentedTabsView? { get }
    var segments: [SegmentedDisplayable] { get }
    var router: SegmentsRouter? { get set }
    func setSelected(index: Int)
    func scrollToTop()
    func childDidUpdate(_ scrollView: UIScrollView)
}

public protocol SegmentsRouting: Routing {
    func setup(segment: SegmentedDisplayable) -> (router: Routing, controller: UIViewController)
    func viewController(at index: Int) -> UIViewController?
    var delegate: SegmentsRouterDelegate? { get set }
    var host: UINavigationController? { get }
}

public protocol SegmentsRoutableChildDelegate: class {
    func didUpdate(_ scrollView: UIScrollView)
}

public protocol SegmentsRoutableChild: class {
    var delegate: SegmentsRoutableChildDelegate? { get set }
    var routableScrollView: UIScrollView? { get }
    func didScroll(to index: IndexPath)
}

open class SegmentsRouter: NSObject, SegmentsRouting, SegmentsRoutableChildDelegate {
    
    open func start() {
        guard let vc = UIStoryboard.viewController(with: "ExampleProfileUI", storyboard: "UI", bundle: Bundle(for: ExampleProfileUI.self)) as? ExampleProfileUI else {
            fatalError()
        }        
        navigationController?.setViewControllers([vc], animated: false)
    }
    
    open func setup(segment: SegmentedDisplayable) -> (router: Routing, controller: UIViewController) {
        let module: LabelledModule = config.appModules.module()
        let result = module.setup(text: segment.title, config: config)
        return result
    }
    
    open func present(controller: UIViewController) {}
    
    public weak var delegate: SegmentsRouterDelegate?
    
    func removeViewControllers() {
        viewControllers?.removeAll()
    }
    
    open lazy var viewControllers: [UIViewController]? = {
        return delegate?.segments.compactMap { (segment) -> UIViewController? in
            let result = setup(segment: segment)
            addChild(router: result.router)
            return result.controller
        }
    }()
    
    public weak var navigationController: UINavigationController?
    
    public init(nav: UINavigationController?) {
        self.navigationController = nav
        super.init()
    }
    
    public func viewController(at index: Int) -> UIViewController? {
        guard let vc = viewControllers?[safe: index] else {
            return nil
        }
        configure(viewController: vc)
        return vc
    }
    
    func index(of viewController: UIViewController) -> Int? {
        return viewControllers?.firstIndex(of: viewController)
    }
    
    open func canHandle<T>(deepLink: DeepLinkOption<T>) -> Bool {
        return false
    }
    
    public var host: UINavigationController? {
        return navigationController
    }
    
    open func configure(viewController: UIViewController) {
        guard let vc = viewController as? SegmentsRoutableChild else {
            return
        }
        vc.delegate = self
        vc.routableScrollView?.isScrollEnabled = false
    }
    
    public func didUpdate(_ scrollView: UIScrollView) {
        delegate?.childDidUpdate(scrollView)
    }
    
    open func route<T>(deepLink: DeepLinkOption<T>, stack: [UIViewController]) {}
}

class ExampleProfileUI: AnimatingHeaderViewController, UITableViewDelegate, UITableViewDataSource {
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        makeBlurredHeader(with: #imageLiteral(resourceName: "cover-ex"))
        profileImageView.image = #imageLiteral(resourceName: "profile-ex")
        tableView.bounces = false
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    @IBOutlet var tableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "row \(indexPath.row)"
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        super.didScroll(scrollView)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        super.didEndDragging(scrollView, willDecelerate: false)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        super.didEndDecelerating(scrollView)
    }
}
