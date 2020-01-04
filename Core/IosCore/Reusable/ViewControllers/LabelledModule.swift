//
//  IosCore
//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import Domain
import Additions
import Presentation

public class LabelledModule: Module {
    public init() {}
    
    public func setup(text: String, config: Configurable) -> (controller: UIViewController, router: Routing) {
        let vc = UIStoryboard.viewController(with: "LabelledController", storyboard: "UI", bundle: Bundle(for: LabelledController.self)) as! LabelledController
        vc.text = text
        let router = LabelledRouter(vc: vc)
        return (vc, router)
    }
}

public class LabelledRouter: Routing {
    weak var vc: LabelledController?
    public init(vc: LabelledController) {
        self.vc = vc
    }
    
    public func start() {}
}

public class LabelledController: UITableViewController, SegmentsRoutableChild {
    public weak var delegate: SegmentsRoutableChildDelegate?
    
    public var routableScrollView: UIScrollView? {
        return tableView
    }
    @IBOutlet var label: UILabel!
    public var text: String?
    override public func viewDidLoad() {
        super.viewDidLoad()
        label.text = text
    }
    
    public func didScroll(to index: IndexPath) {}
}
