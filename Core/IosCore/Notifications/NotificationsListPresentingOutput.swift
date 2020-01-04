///
//  IosCore
//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import Foundation
import Presentation

public protocol NotificationsListPresentingOutput: EmptyStateDataSource, FontCalculating, PresentationOutput {
    func refresh()
    func setIconBadgeWith(number: Int, tabIndex: Int)
    func setupBadge()
    func setRedDotOnNotificationsTab(show: Bool)
    var settingsClosure: Tap? { get set }
    func setSettingsButtonWithImage(named: String)
    var sourceItemForPopupControl: Any? { get }
}
