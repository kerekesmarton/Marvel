//
//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import UIKit
import IosCore

class DemoAppStyle: StyleProviding {
    
    var navigation: NavigationStyleProvider? = DemoNavigationStyle()
    var tabBar: TabBarStyle? = DemoTabBarStyle()
    var controls: ControlsProvider? = DemoControlsStyle()
    var cells: CellsProvider? = DemoCellsStyle()
    var list: TableStyle? = DemoListStyle()
    
    func setup() {
        do {
            try StyleManager.create(provider: self)
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
}

class DemoTabBarStyle: TabBarStyle {
    
    var isTranslucent: Bool { return false }
    var barTintColor: UIColor { return Color.alternativeBase }
    var tintColor: UIColor { return Color.primary }
    var unselectedItemTintColor: UIColor { return Color.tintDark }
    var titleLabel: LabelStyle { return TintDarkRegularCaption2() }

}

class TintDarkRegularCaption2: LabelStyle {
    var color: UIColor?         = Color.tintDark
    var font: UIFont?           = Font.regularCaption2
}

class DemoListStyle: TableStyle {
    var tableHeaderTitleStyle: TableHeaderViewStyle = DemoTableHeaderViewStyle()
    var header: ProfileHeaderStyle = DemoProfileHeaderStyle()
    var headerView: HeaderViewStyle? = DemoHeaderViewStyle()
    var swipeActionCellDeleteStyle: SwipeActionCellStyle = SwipeActionCellDeleteStyle()
    var swipeActionCellReportStyle: SwipeActionCellStyle = SwipeActionCellReportStyle()
    var swipeActionCellReplyStyle: SwipeActionCellStyle = SwipeActionCellReplyStyle()
    var swipeActionCellEditStyle: SwipeActionCellStyle = SwipeActionCellEditStyle()
    var separatorStyle: ViewStyle = ConnectSeparatorStyle()
    var backgroundColor: UIColor?       = Color.base
}

class DemoHeaderViewStyle: HeaderViewStyle {
    var descriptionLabel: LabelStyle    = NeutralDarkSemiBoldFootnote()
    var titleLabel: LabelStyle          = NeutralMediumRegularCaption2()
    var backgroundColor: UIColor?       = Color.neutralLight
}
