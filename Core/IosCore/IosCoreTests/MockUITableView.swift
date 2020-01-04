//
//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import UIKit

public final class MockUITableView<T: UITableViewCell, U: UITableViewHeaderFooterView>: UITableView {
    
    var spyReloadDataCalled = 0
    var spyDequeueReusableCellCalled = 0
    var spyDequeueReusableHeaderFooterCalled = 0
    var spySelectRowIndexPathCalled: IndexPath?
    var spyDequeuedHeaderFooterViewIdentifiers = [String]()
    var spyRegisteredHeaderFooterViewIdentifiers = [String]()
    var capturedScrollPosition: UITableView.ScrollPosition?
    
    override public var indexPathForSelectedRow: IndexPath? {
        return spySelectRowIndexPathCalled
    }
    
    override public func reloadData() {
        spyReloadDataCalled += 1
    }
    
    override public func dequeueReusableCell(withIdentifier identifier: String) -> UITableViewCell? {
        spyDequeueReusableCellCalled += 1
        return T()
    }
    
    public var spyIdentifier: String?
    override public func dequeueReusableCell(withIdentifier identifier: String, for indexPath: IndexPath) -> UITableViewCell {
        spyDequeueReusableCellCalled += 1
        spyIdentifier = identifier
        return T()
    }
    
    override public func dequeueReusableHeaderFooterView(withIdentifier identifier: String) -> UITableViewHeaderFooterView? {
        spyDequeueReusableHeaderFooterCalled += 1
        spyDequeuedHeaderFooterViewIdentifiers.append(identifier)
        return U()
    }
    
    override public func selectRow(at indexPath: IndexPath?, animated: Bool, scrollPosition: UITableView.ScrollPosition) {
        spySelectRowIndexPathCalled = indexPath
        capturedScrollPosition = scrollPosition
    }
    
    override public func register(_ nib: UINib?, forHeaderFooterViewReuseIdentifier identifier: String) {
        spyRegisteredHeaderFooterViewIdentifiers.append(identifier)
        super.register(nib, forHeaderFooterViewReuseIdentifier: identifier)
    }

}
