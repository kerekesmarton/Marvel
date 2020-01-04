///
//  DemoApp
//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import IosCore
import UIKit

class DemoNavigationStyle: NavigationStyleProvider {

    var standard: NavigationStyle = StandardNavigationStyle()
    var transparent: NavigationStyle = TransparentNavigationStyle()
    var clear: NavigationStyle = ClearNavigationStyle()
    var white: NavigationStyle = WhiteNavigationStyle()
}

class StandardNavigationStyle: NavigationStyle {
    var titleLabel: LabelStyle          = NavigationTitle()
    var titleImage: UIImage?
    var translucency: Bool?             = false
    var transparentNavigationBar: Bool? = false
    
    var item: ButtonStyle?              = NavigationItem()
    var doneItem: ButtonStyle?          = NavigationDoneItem()
    var destructiveItem: ButtonStyle?   = NavigationDestructiveItem()
    
    var backgroundColor: UIColor?       = Color.primary
    var barTintColour: UIColor?         = Color.neutralDark
    
    class NavigationItem: ButtonStyle {
        var backgroundColor: UIColor?
        
        var color: UIColor?             = Color.base
        var font: UIFont?               = Font.lightCaption2
    }
    class NavigationDoneItem: ButtonStyle {
        var backgroundColor: UIColor?
        
        var color: UIColor?             = Color.neutralDark
        var font: UIFont?               = Font.lightCaption2
    }
    class NavigationDestructiveItem: ButtonStyle {
        var backgroundColor: UIColor?
        
        var color: UIColor?             = Color.base
        var font: UIFont?               = Font.lightCaption2
    }
    
    class NavigationTitle: LabelStyle {
        var color: UIColor?             = Color.neutralDark
        var font: UIFont?               = Font.semiBoldHeadline
    }
}

class ClearNavigationStyle: NavigationStyle {
    
    var titleLabel: LabelStyle          = NavigationTitle()
    var titleImage: UIImage?
    var translucency: Bool?             = true
    var transparentNavigationBar: Bool? = false
    
    var backgroundColor: UIColor?       = Color.base
    var barTintColour: UIColor?         = Color.neutralDark
    var item: ButtonStyle?
    
    var doneItem: ButtonStyle?
    
    var destructiveItem: ButtonStyle?
    
    class NavigationTitle: LabelStyle {
        var color: UIColor?             = Color.neutralDark
        var font: UIFont?               = Font.boldHeadline
    }
}

class WhiteNavigationStyle: NavigationStyle {
    var titleLabel: LabelStyle          = NavigationTitle()
    var titleImage: UIImage?
    var translucency: Bool?             = false
    var transparentNavigationBar: Bool? = false
    
    var backgroundColor: UIColor?       = Color.color(.white, alpha: 1.0)
    var barTintColour: UIColor?         = Color.primary
    var item: ButtonStyle?
    
    var doneItem: ButtonStyle?
    
    var destructiveItem: ButtonStyle?
    
    class NavigationTitle: LabelStyle {
        var color: UIColor?             = Color.neutralDark
        var font: UIFont?               = Font.boldHeadline
    }
}

class TransparentNavigationStyle: NavigationStyle {
    
    var titleLabel: LabelStyle          = NavigationTitle()
    var titleImage: UIImage?
    var translucency: Bool?             = true
    var transparentNavigationBar: Bool? = true
    
    var backgroundColor: UIColor?       = Color.base
    var barTintColour: UIColor?         = Color.base
    var item: ButtonStyle?
    
    var doneItem: ButtonStyle?
    
    var destructiveItem: ButtonStyle?
    
    class NavigationTitle: LabelStyle {
        var color: UIColor?             = Color.neutralDark
        var font: UIFont?               = Font.semiBoldHeadline
    }
}
