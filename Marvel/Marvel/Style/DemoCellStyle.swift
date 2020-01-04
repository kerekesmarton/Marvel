///
//  DemoApp
//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import IosCore
import UIKit

class DemoCellsStyle: CellsProvider {
    var common: CommonCellStyle = DemoCommonCellStyle()
    var actions: ActionableCellStyle = DemoActionableCellStyle()
    var listCell: ListCellStyle = DemoProfileListCellStyle()
    var collectionCell: CollectionCellStyle = DemoCollectionCellStyle()
    var comment: ActionableCellStyle = DemoCommentCellStyle()
    var followButton: ActionButtonStyle = DemoPrimaryActionCellButtonStyle()
}

class DemoCommonCellStyle: CommonCellStyle {
    var separatorColor: UIColor     = Color.neutralLight
    var titleLabel: LabelStyle      = NeutralDarkRegularSubhead()
    var detailLabel: LabelStyle     = NeutralDarkRegularSubhead()
    var highlightedLabel: LabelStyle = NeutralDarkSemiBoldSubHead()
    var contentLabel: LabelStyle    = NeutralDarkSemiBoldHeadline()
    var labelWithLink: LabelStyle   = LightBlueRegularSubHead()
    
    var backgroundColor: UIColor?   = Color.base
    var descriptionCell: DescriptionCellStyle   = DemoDescriptionCellStyle()
    var rightDetailCell: RightDetailCellStyle   = DemoRightDetailCellStyle()
    var switchCell: SwitchCellStyle             = DemoSwitchCellStyle()
}

class DemoActionableCellStyle: ActionableCellStyle {
    
    var backgroundColor: UIColor?
    
    var firstLabel: LabelStyle  = NeutralMediumRegularFootnote()
    var secondLabel: LabelStyle  = NeutralMediumRegularFootnote()
}

class DemoCommentCellStyle: ActionableCellStyle {
    var backgroundColor: UIColor?
    
    var firstLabel: LabelStyle  = NeutralMediumRegularSubhead()
    var secondLabel: LabelStyle  = NeutralMediumSemiBoldSubhead()
}

class DemoProfileListCellStyle: ListCellStyle {
    var contentLabel: LabelStyle = NeutralDarkRegularSubhead()
    var nameLabel: LabelStyle = NeutralDarkSemiBoldSubHead()
    var infoLabel: LabelStyle = NeutralMediumRegularFootnote()
    var verifiedTick: TintedImage = DemoTintedImage()
}

class DemoCollectionCellStyle: CollectionCellStyle {
    var header: ListCellStyle = DemoProfileListCellStyle()
    var titleBigLabel: LabelStyle = BaseBoldTitle2()
    var titleSmallLabel: LabelStyle = BaseSemiBoldFootnote()
    var cornerRadius: CGFloat { return 12.0 }
    var borderColor: UIColor = Color.terciary
    var borderWidth: CGFloat = 1.0
}

class DemoTintedImage: TintedImage {
    var image: UIImage = #imageLiteral(resourceName: "verified-tick")
    var tint: UIColor = Color.primary
}

// MARK: - Other cells

class ImageContentTableViewCellStyle: ImageContentCellStyle {
    var countIndicator: LabelStyle? = BaseRegularCaption2()
    var countBackground: UIColor = Color.neutralDark
}

class SwipeActionCellDeleteStyle: SwipeActionCellStyle {
    var color: UIColor?         = Color.error
    var image: UIImage?         = UIImage(named: "SwipeActionDelete")
}

class SwipeActionCellReportStyle: SwipeActionCellStyle {
    var color: UIColor?         = Color.neutralMedium
    var image: UIImage?         = UIImage(named: "SwipeActionReport")
}

class SwipeActionCellReplyStyle: SwipeActionCellStyle {
    var color: UIColor?         = Color.neutralMedium
    var image: UIImage?         = UIImage(named: "SwipeActionReply")
}

class SwipeActionCellEditStyle: SwipeActionCellStyle {
    var color: UIColor?         = Color.neutralMedium
    var image: UIImage?         = UIImage(named: "SwipeActionEdit")
}

class DemoDescriptionCellStyle: DescriptionCellStyle {
    var placeholderTextView: PlaceholderTextViewStyle   = DemoPlaceholderTextViewStyle()
    var actionButton: RoundedButtonStyle                = DemoRoundedActionSecondaryMediumButtonStyle()
    var label: LabelStyle                               = NeutralMediumRegularFootnote()
}

class DemoRightDetailCellStyle: RightDetailCellStyle {
    var titleLabel: LabelStyle                          = NeutralDarkRegularSubhead()
    var valueLabel: LabelStyle                          = NeutralMediumRegularSubhead()
}

class DemoSwitchCellStyle: SwitchCellStyle {
    var titleLabel: LabelStyle                          = NeutralDarkRegularSubhead()
}
