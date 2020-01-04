///
//  DemoApp
//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import IosCore
import UIKit

class DemoControlsStyle: ControlsProvider {
    
    var popupStyle: PopUpViewStyle = DemoPopUpViewStyle()
    var roundedImageView: RoundedImageViewStyle = DemoRoundedImageViewStyle()
    var roundedButton: RoundedButtonStyle = DemoRoundedButtonStyle()
    var roundedActionButton: RoundedButtonStyle = DemoRoundedActionButtonStyle()
    var toastMessage: ToastStyle = DemoToastStyle()
    var linkView: LinkViewStyle = DemoLinkViewStyle()
    var shareView: ShareViewStyle = DemoShareViewStyle()
    var chatInputView: ChatInputViewStyle = DemoChatInputViewStyle()
    var popUpView: PopUpViewStyle = DemoPopUpViewStyle()
    var segmentedTabsView: SegmentedTabsViewStyle = DemoSegmentedTabsViewStyle()
    var placeholderTextView: PlaceholderTextViewStyle = DemoPlaceholderTextViewStyle()
    var imageContentStyle: ImageContentCellStyle = ImageContentTableViewCellStyle()
    var titleStyle: LabelStyle = TitleStyle()
    
    var primaryLabel: LabelStyle = PrimaryLabelStyle()
    var secondaryLabel: LabelStyle = SecondaryLabelStyle()
    
    var primaryActionButton: ActionButtonStyle = PrimaryActionSemiboldRegularButton()
    var secondaryActionButton: ActionButtonStyle = DemoSecondaryActionButtonStyle()
}

class TitleStyle: LabelStyle {
    var color: UIColor? = Color.black
    var font: UIFont? = Font.regularTitle2
}

class PlaceholderLabel: LabelStyle {
    var backgroundColor: UIColor?               = Color.clear
    var color: UIColor?                         = Color.neutralMedium
    var font: UIFont?                           = Font.regularSubhead
}

class DemoPlaceholderTextViewStyle: PlaceholderTextViewStyle {
    var color: UIColor?                             = Color.neutralDark
    var font: UIFont?                               = Font.regularSubhead
    var placeholderTextAlignment: NSTextAlignment   = .left
    var placeholderBackgroundColor: UIColor?        = Color.clear
    var placeholderLabel: LabelStyle                = PlaceholderLabel()
}

class DemoSegmentedTabsViewStyle: SegmentedTabsViewStyle {
    
    var indicatorColor: UIColor = Color.primary
    var item: ButtonStyle? = SegmentedControlItemStyle()
    var unselectedItem: ButtonStyle? = UnselectedSegmentedControlItemStyle()
    var borderColor: UIColor = Color.terciary
    
}

    
class PrimaryLabelStyle: LabelStyle{
    var color: UIColor? {
        return Color.primaryText
    }
    var font: UIFont? {
        return Font.regularSubhead
    }
}

class SecondaryLabelStyle: LabelStyle{
    var color: UIColor? {
        return Color.secondaryText
    }
    var font: UIFont? {
        return Font.regularSubhead
    }
}

class DemoRoundedButtonStyle: RoundedButtonStyle {
    var backgroundColor: UIColor?       = .clear
    var titleColor: UIColor             = Color.primary
    var titleFont: UIFont               = Font.regularCaption2
    var borderColor: UIColor?
    var borderWidth: CGFloat?           = 0
    var cornerRadius: CGFloat?          = 4
}

class DemoRoundedActionSecondarySmallButtonStyle: RoundedButtonStyle {
    var titleColor: UIColor             = Color.neutralDark
    var titleFont: UIFont               = Font.regularFootnote
    var backgroundColor: UIColor?       = Color.clear
    var borderColor: UIColor?           = Color.neutralLight
    var borderWidth: CGFloat?           = 1.0
    var cornerRadius: CGFloat?          = 4.0
}

class DemoRoundedActionSecondaryMediumButtonStyle: RoundedButtonStyle {
    var titleColor: UIColor             = Color.neutralDark
    var titleFont: UIFont               = Font.regularSubhead
    var backgroundColor: UIColor?       = Color.clear
    var borderColor: UIColor?           = Color.neutralLight
    var borderWidth: CGFloat?           = 1.0
    var cornerRadius: CGFloat?          = 4.0
}

class DemoRoundedActionButtonStyle: RoundedButtonStyle {
    var titleColor: UIColor             = Color.neutralDark
    var titleFont: UIFont               = Font.regularBody
    var backgroundColor: UIColor?       = Color.clear
    var borderColor: UIColor?           = Color.neutralLight
    var borderWidth: CGFloat?           = 1.0
    var cornerRadius: CGFloat?          = 4.0
}

class PrimaryActionSemiboldRegularButton: ActionButtonStyle {
    
    var font: UIFont                        = Font.semiBoldSubhead
    
    var borderWidth: CGFloat                = 1
    var cornerRadius: CGFloat               = 5
    
    var activeFontColor: UIColor            = Color.primaryButtonText // Color.neutralMedium
    var activeBackgroundColor: UIColor      = Color.primary
    var activeBorderColor: UIColor          = Color.primary
    
    var selectedFontColor: UIColor          = Color.primaryButtonText
    var selectedBackgroundColor: UIColor    = .clear
    var selectedBorderColor: UIColor        = Color.primaryButtonText
    
    var disabledFontColor: UIColor          = Color.primaryTextDark
    var disabledBackgroundColor: UIColor    = Color.separatorDark
    var disabledBorderColor: UIColor        = Color.neutralTint
    
    // Will dissapear
    var activeFontFillColor: UIColor        = Color.white
    var activeFillColor: UIColor            = Color.primary
    var disabledFontFillColor: UIColor      = Color.inactiveLight
    var disabledFillColor: UIColor          = Color.primary
    var alertFontColor: UIColor             = Color.error
    var alertBackgroundColor: UIColor       = Color.base
    var alertBorderColor: UIColor           = Color.error
    var inactiveBackgroundColor: UIColor    = .clear
    var inactiveFontFillColor: UIColor      = .clear
    var inactiveFillColor: UIColor          = .clear
    
}

class DemoSecondaryActionButtonStyle: ActionButtonStyle {
    
    var font: UIFont                        = Font.semiBoldFootnote
    
    var borderWidth: CGFloat                = 1
    var cornerRadius: CGFloat               = 4
    
    var activeFontColor: UIColor            = Color.neutralDark
    var activeFontFillColor: UIColor        = Color.neutralDark
    var activeBackgroundColor: UIColor      = Color.white
    var activeFillColor: UIColor            = Color.neutralDark
    var activeBorderColor: UIColor          = Color.separatorDark
    
    var selectedFontColor: UIColor          = Color.secondaryButtonText
    var selectedBackgroundColor: UIColor    = Color.secondaryButtonBackground
    var selectedBorderColor: UIColor        = Color.separatorDark
    var inactiveFontColor: UIColor          = Color.neutralMedium
    var inactiveFontFillColor: UIColor      = Color.neutralMedium
    var inactiveBackgroundColor: UIColor    = Color.white
    var inactiveFillColor: UIColor          = Color.neutralMedium
    
    var disabledFontColor: UIColor          = Color.neutralGray
    var disabledFontFillColor: UIColor      = Color.neutralGray
    var disabledBackgroundColor: UIColor    = Color.neutralLight
    var disabledFillColor: UIColor          = Color.neutralMedium
    var disabledBorderColor: UIColor        = Color.separatorDark
    
    var alertFontColor: UIColor             = Color.error
    var alertBackgroundColor: UIColor       = Color.base
    var alertBorderColor: UIColor           = Color.error
}

class DemoPrimaryActionCellButtonStyle: ActionButtonStyle {
    
    var font: UIFont                        = Font.semiBoldSubhead
    
    var borderWidth: CGFloat                = 1
    var cornerRadius: CGFloat               = 4
    
    var activeFontColor: UIColor            = Color.white
    var activeFontFillColor: UIColor        = Color.white
    var activeBackgroundColor: UIColor      = Color.clear
    var activeFillColor: UIColor            = Color.primary
    var activeBorderColor: UIColor          = UIColor.clear
    
    var selectedFontColor: UIColor          = .clear
    var selectedBackgroundColor: UIColor    = .clear
    var selectedBorderColor: UIColor        = .clear
    
    var inactiveFontColor: UIColor          = Color.neutralMedium
    var inactiveFontFillColor: UIColor      = Color.neutralMedium
    var inactiveBackgroundColor: UIColor    = Color.white
    var inactiveFillColor: UIColor          = Color.neutralMedium
    
    var disabledFontColor: UIColor          = Color.neutralGray
    var disabledFontFillColor: UIColor      = Color.neutralGray
    var disabledBackgroundColor: UIColor    = Color.neutralTint
    var disabledFillColor: UIColor          = Color.neutralMedium
    var disabledBorderColor: UIColor        = UIColor.clear
    
    var alertFontColor: UIColor             = Color.error
    var alertBackgroundColor: UIColor       = Color.base
    var alertBorderColor: UIColor           = Color.error
    
}

class DemoSecondaryActionCellButtonStyle: ActionButtonStyle {
    
    var font: UIFont                        = Font.semiBoldSubhead
    
    var borderWidth: CGFloat                = 1
    var cornerRadius: CGFloat               = 4
    
    var activeFontColor: UIColor            = Color.primary
    var activeFontFillColor: UIColor        = Color.white
    var activeBackgroundColor: UIColor      = Color.clear
    var activeFillColor: UIColor            = Color.primary
    var activeBorderColor: UIColor          = UIColor.clear
    
    var selectedFontColor: UIColor          = .clear
    var selectedBackgroundColor: UIColor    = .clear
    var selectedBorderColor: UIColor        = .clear
    
    var inactiveFontColor: UIColor          = Color.neutralMedium
    var inactiveFontFillColor: UIColor      = Color.neutralMedium
    var inactiveBackgroundColor: UIColor    = Color.white
    var inactiveFillColor: UIColor          = Color.neutralMedium
    
    var disabledFontColor: UIColor          = Color.neutralGray
    var disabledFontFillColor: UIColor      = Color.neutralGray
    var disabledBackgroundColor: UIColor    = Color.neutralTint
    var disabledFillColor: UIColor          = Color.neutralMedium
    var disabledBorderColor: UIColor        = UIColor.clear
    
    var alertFontColor: UIColor             = Color.error
    var alertBackgroundColor: UIColor       = Color.base
    var alertBorderColor: UIColor           = Color.error
}





class ConnectSeparatorStyle: ViewStyle {
    var backgroundColor: UIColor? {
        return Color.neutralLight
    }
}

class DemoToastStyle: ToastStyle {
    var backgroundColor: UIColor? = Color.primary
    var messageBackgroundColor: UIColor? = Color.primary
    var errorBackgroundColor: UIColor? = Color.error
    var loadingBackgroundColor: UIColor? = Color.neutralMedium.withAlphaComponent(0.3)
    var label: LabelStyle? = BaseRegularFootnote()
}

class DemoDoubleTitleViewStyle: DoubleTitleViewStyle {
    var titleLabel: LabelStyle          = NeutralGraySemiBoldSubhead()
    var descriptionLabel: LabelStyle    = NeutralGrayRegularCaption2()
    var backgroundColor: UIColor?       = .clear
}

class DemoLinkViewStyle: LinkViewStyle {
    
    var backgroundColor: UIColor?       = Color.neutralLight
    var titleLabel: LabelStyle          = NeutralDarkSemiBoldSubHead()
    var descriptionLabel: LabelStyle    = NeutralDarkRegularFootnote()
    var linkLabel: LabelStyle           = NeutralMediumRegularFootnote()
    var border: BorderStyle             = LinkViewBorderStyle()
    
    class LinkViewBorderStyle: BorderStyle {
        var width: CGFloat?             = 0.5
        var color: UIColor?             = Color.inactiveLight
        var cornerRadius: CGFloat?      = 12.0
    }
}

class DemoChatInputViewStyle: ChatInputViewStyle {
    var backgroundColor: UIColor?                       = Color.clear
    var borderColor: UIColor?                           = Color.neutralMedium
    var placeholderTextView: PlaceholderTextViewStyle   = DemoPlaceholderTextViewStyle()
}

class DemoPopUpViewStyle: PopUpViewStyle {
    var cellStyle: CommonCellStyle                        = DemoCommonCellStyle()
    var separatorColor: UIColor?                        = Color.neutralGray
    var backgroundColor: UIColor?                       = Color.base
}

class DemoShareViewStyle: ShareViewStyle {
    
    var backgroundColor: UIColor?       = Color.neutralLight
    var titleLabel: LabelStyle          = NeutralDarkSemiBoldSubHead()
    var descriptionLabel: LabelStyle    = NeutralDarkRegularFootnote()
    var contentLabel: LabelStyle        = NeutralDarkRegularFootnote()
    var border: BorderStyle             = ShareViewBorderStyle()
    
    class ShareViewBorderStyle: BorderStyle {
        var width: CGFloat?             = 0.5
        var color: UIColor?             = Color.inactiveLight
        var cornerRadius: CGFloat?      = 12.0
    }
}

class DemoRoundedImageViewStyle: RoundedImageViewStyle {
    var backgroundColor: UIColor?       = Color.base
    var borderColor: UIColor?
    var borderWidth: CGFloat            = 0
}

class SegmentedControlItemStyle: ButtonStyle {
    var backgroundColor: UIColor?   = Color.terciary
    var color: UIColor?             = Color.primaryTextDark
    var font: UIFont?               = Font.semiBoldFootnote
}

class UnselectedSegmentedControlItemStyle: ButtonStyle {
    var backgroundColor: UIColor?   = Color.base
    var color: UIColor?             = Color.neutralMedium
    var font: UIFont?               = Font.regularFootnote
}

class DemoTableHeaderViewStyle: TableHeaderViewStyle {
    var titleLabel: LabelStyle          = NeutralDarkBoldTitle3()
    var backgroundColor: UIColor?       = Color.white
}

class DemoProfileHeaderStyle: ProfileHeaderStyle {
    var titleOneLabel: LabelStyle  = TertiaryRegularFootnote()
    var titleTwoLabel: LabelStyle  = NeutralMediumRegularFootnote()
    var nameLabel: LabelStyle = NeutralDarkSemiBoldHeadline()
    var descriptionLabel: LabelStyle = NeutralDarkSemiBoldHeadline()
    var followLabel: LabelStyle = NeutralMediumRegularCaption2()
    var followValueLabel: LabelStyle = NeutralDarkRegularFootnote()
}
