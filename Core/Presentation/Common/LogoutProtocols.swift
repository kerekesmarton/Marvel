///
//  Core
//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import Foundation

public protocol LogoutRouting: class {
    func routeLogoutSuccessful()
}

public protocol LogoutResponder {
    func didLogout()
}

public protocol LogoutButtonHosting: class {
    func hostLogoutButton(presenter: LogoutPresenting, buttonTitle: String)
}

public protocol LogoutPresenting: class {
    func didPressLogout()
    func shouldShowLogout() -> Bool
}
