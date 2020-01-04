//
//  IosCore
//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import UIKit

public class ClearNavigationController: NavigationController {
    public override func applyStyle() {
        let style = styleProvider?.navigation?.clear
        view.backgroundColor = style?.backgroundColor
        navigationBar.tintColor = style?.barTintColour
        navigationBar.barTintColor = style?.backgroundColor
        navigationBar.isTranslucent = style?.translucency ?? false
        
        navigationBar.shadowImage = nil
        navigationBar.setBackgroundImage(nil, for: UIBarMetrics.default)
        
        guard let titleStyle = style?.titleLabel, let titleColor = titleStyle.color, let titleFont = titleStyle.font  else { return }
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : titleColor,
                                             NSAttributedString.Key.font : titleFont]
    }
}
