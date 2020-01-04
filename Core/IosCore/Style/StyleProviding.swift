//
//  UI
//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import UIKit

public protocol StyleProviding: class {
    func setup()
    
    var navigation: NavigationStyleProvider? { get }
    var tabBar: TabBarStyle? { get }
    var controls: ControlsProvider? { get }
    var list: TableStyle? { get }
    var cells: CellsProvider? { get }
}

public protocol NavigationStyleProvider {
    var standard: NavigationStyle { get }
    var clear: NavigationStyle { get }
}

public protocol TabBarStyle {
    var isTranslucent: Bool { get }
    var barTintColor: UIColor { get }
    var tintColor: UIColor { get }
    var unselectedItemTintColor: UIColor { get }
    var titleLabel: LabelStyle { get }
}

public protocol ControlsProvider {
    var titleStyle: LabelStyle { get }
    var popupStyle: PopUpViewStyle { get }
    var roundedImageView: RoundedImageViewStyle { get }
    var placeholderTextView: PlaceholderTextViewStyle { get }
    var roundedButton: RoundedButtonStyle { get }
    var toastMessage: ToastStyle { get }
    var linkView: LinkViewStyle { get }
    var shareView: ShareViewStyle { get }
    var chatInputView: ChatInputViewStyle { get }
    var segmentedTabsView: SegmentedTabsViewStyle { get }
    var imageContentStyle: ImageContentCellStyle { get }
    
    //Added
    var primaryLabel: LabelStyle { get }
    var secondaryLabel: LabelStyle { get }
    
    var primaryActionButton: ActionButtonStyle { get }
    var secondaryActionButton: ActionButtonStyle { get }
}

public protocol TableStyle: ViewStyle {
    var tableHeaderTitleStyle: TableHeaderViewStyle { get }
    var header: ProfileHeaderStyle { get }
    var headerView: HeaderViewStyle? { get }
    var separatorStyle: ViewStyle { get }
    var swipeActionCellDeleteStyle: SwipeActionCellStyle { get }
    var swipeActionCellReportStyle: SwipeActionCellStyle { get }
    var swipeActionCellReplyStyle: SwipeActionCellStyle { get }
    var swipeActionCellEditStyle: SwipeActionCellStyle { get }
}

public protocol CellsProvider {
    var common: CommonCellStyle { get }
    var actions: ActionableCellStyle { get }
    var listCell: ListCellStyle { get }
    var collectionCell: CollectionCellStyle { get }
    var comment: ActionableCellStyle { get }
}

public protocol ImageContentCellStyle {
    var countIndicator: LabelStyle? { get }
    var countBackground: UIColor { get }  
}

public protocol SegmentedTabsViewStyle {
    var indicatorColor: UIColor { get }    
    var item: ButtonStyle? { get }
    var unselectedItem: ButtonStyle? { get }
    var borderColor: UIColor { get }
}

public protocol ViewStyle {
    var backgroundColor: UIColor? { get }
}

public protocol BorderStyle {
    var width: CGFloat? { get }
    var color: UIColor? { get }
    var cornerRadius: CGFloat? { get }
}

public protocol RoundedImageViewStyle: ViewStyle {
    var borderColor: UIColor? { get }
    var borderWidth: CGFloat { get }
}

public protocol RoundedButtonStyle: ViewStyle {
    var titleColor: UIColor { get }
    var titleFont: UIFont { get }
    
    var borderColor: UIColor? { get }
    var borderWidth: CGFloat? { get }
    var cornerRadius: CGFloat? { get }
}

public protocol ActionButtonStyle {
    var font: UIFont { get }
    
    var borderWidth: CGFloat { get }
    var cornerRadius: CGFloat { get }
    
    var activeFontColor: UIColor { get }
    var activeBackgroundColor: UIColor { get }
    var activeBorderColor: UIColor { get }
    
    var selectedFontColor: UIColor { get }
    var selectedBackgroundColor: UIColor { get }
    var selectedBorderColor: UIColor { get }
    
    var disabledFontColor: UIColor { get }
    var disabledBackgroundColor: UIColor { get }
    var disabledBorderColor: UIColor { get }
    
    // Will dissapear
    var alertFontColor: UIColor { get }
    var alertBackgroundColor: UIColor { get }
    var alertBorderColor: UIColor { get }
    var activeFillColor: UIColor { get }
    var activeFontFillColor: UIColor { get }
    var inactiveBackgroundColor: UIColor { get }
    var inactiveFontFillColor: UIColor { get }
    var inactiveFillColor: UIColor { get }
    var disabledFontFillColor: UIColor { get }
    var disabledFillColor: UIColor { get }
    
}

public protocol ToastStyle: ViewStyle {
    var label: LabelStyle? { get }
    var messageBackgroundColor: UIColor? { get }
    var errorBackgroundColor: UIColor? { get }
    var loadingBackgroundColor: UIColor? { get }
}

public protocol NavigationStyle: ViewStyle {
    
    var titleLabel: LabelStyle { get }
    
    var titleImage: UIImage? { get }
    var translucency: Bool? { get }
    var barTintColour: UIColor? { get }
    
    var item: ButtonStyle? { get }
    var doneItem: ButtonStyle? { get }
    var destructiveItem: ButtonStyle? { get }
}

public protocol LabelStyle {
    var color: UIColor? { get }
    var font: UIFont? { get }
}

public protocol DoubleTitleViewStyle: ViewStyle {
    var titleLabel: LabelStyle { get }
    var descriptionLabel: LabelStyle { get }
}

public protocol LinkViewStyle: ViewStyle {
    var titleLabel: LabelStyle { get }
    var descriptionLabel: LabelStyle { get }
    var linkLabel: LabelStyle { get }
    var border: BorderStyle { get }
}

public protocol ChatStatusViewStyle: ViewStyle {
    var titleLabel: LabelStyle { get }
    var acceptButton: ActionButtonStyle { get }
    var declineButton: ActionButtonStyle { get }
}

public protocol ShareViewStyle: ViewStyle {
    var titleLabel: LabelStyle { get }
    var descriptionLabel: LabelStyle { get }
    var contentLabel: LabelStyle { get }
    var border: BorderStyle { get }
}

public protocol ChatInputViewStyle: ViewStyle {
    var borderColor: UIColor? { get }
    var placeholderTextView: PlaceholderTextViewStyle { get }
}

public protocol PopUpViewStyle: ViewStyle {
    var cellStyle: CommonCellStyle { get }
    var separatorColor: UIColor?  { get }
}

public protocol PlaceholderTextViewStyle {
    var color: UIColor? { get }
    var font: UIFont? { get }
    var placeholderTextAlignment: NSTextAlignment { get }
    var placeholderBackgroundColor: UIColor? { get }
    var placeholderLabel: LabelStyle { get }
}

public protocol ButtonStyle: LabelStyle {
    var backgroundColor: UIColor? { get }
}

public protocol HeaderViewStyle: ViewStyle {
    var titleLabel: LabelStyle { get }
    var descriptionLabel: LabelStyle { get }
}

public protocol TableHeaderViewStyle: ViewStyle {
    var titleLabel: LabelStyle { get }
}

public protocol ProfileHeaderStyle {
    var nameLabel: LabelStyle { get }
    var titleOneLabel: LabelStyle { get }
    var titleTwoLabel: LabelStyle { get }
    var descriptionLabel: LabelStyle { get }
    var followLabel: LabelStyle { get }
    var followValueLabel: LabelStyle { get }
}

public protocol ListCellStyle {
    var nameLabel: LabelStyle { get }
    var contentLabel: LabelStyle { get }
    var infoLabel: LabelStyle { get }
    var verifiedTick: TintedImage { get }
}

public protocol CollectionCellStyle {
    var header: ListCellStyle { get }
    var titleBigLabel: LabelStyle { get }
    var titleSmallLabel: LabelStyle { get }
    
    var cornerRadius: CGFloat { get }
    var borderColor: UIColor { get }
    var borderWidth: CGFloat { get }
}

public protocol TintedImage {
    var image: UIImage { get }
    var tint: UIColor { get}
}

public protocol CommonCellStyle: ViewStyle {
    var titleLabel: LabelStyle { get }
    var detailLabel: LabelStyle { get }
    var contentLabel: LabelStyle { get }
    var highlightedLabel: LabelStyle { get }
    var separatorColor: UIColor { get }
    var descriptionCell: DescriptionCellStyle { get }
    var rightDetailCell: RightDetailCellStyle { get }
    var switchCell: SwitchCellStyle { get }
    var labelWithLink: LabelStyle  { get }
}

public protocol DescriptionCellStyle {
    var placeholderTextView: PlaceholderTextViewStyle { get }
    var actionButton: RoundedButtonStyle { get }
    var label: LabelStyle { get }
}

public protocol RightDetailCellStyle {
    var titleLabel: LabelStyle { get }
    var valueLabel: LabelStyle { get }
}

public protocol SwitchCellStyle {
    var titleLabel: LabelStyle { get }
}

public protocol ActionableCellStyle: ViewStyle {
    var firstLabel: LabelStyle { get }
    var secondLabel: LabelStyle { get }
}

public protocol SwipeActionCellStyle {
    var image: UIImage? { get }
    var color: UIColor? { get }
}

