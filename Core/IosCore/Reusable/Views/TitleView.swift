///
//  IosCore
//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import UIKit

class TitleView: UIView {

    //MARK: - Properties
    var title: String {
        didSet{
            titleLabel.text = title
        }
    }
    var style: TableHeaderViewStyle? {
        didSet{
            setStyle(style)
        }
    }
    private var padding: UIEdgeInsets
    
    private lazy var titleLabel: UILabel = { return UILabel() }()
    
    
    //MARK: - Constructor
    init(title: String, style: TableHeaderViewStyle?, padding: UIEdgeInsets, frame: CGRect) {
        
        self.title = title
        self.style = style
        self.padding = padding
        super.init(frame: frame)
        
        isAccessibilityElement = true
        accessibilityIdentifier = "TitleView"
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Lifecycle methods
    override func didMoveToSuperview() {
        
        if superview != nil{
            
            addSubview(titleLabel)
            titleLabel.constraintToSuperviewEdges(isSafe: true, padding: padding)
            titleLabel.text = title
            setStyle(style)
            
        }
        
    }
    
    
    //MARK: - Private methods
    private func setStyle(_ style: TableHeaderViewStyle?){
        
        guard let style = style else { return }
        backgroundColor = style.backgroundColor
        
        titleLabel.textColor = style.titleLabel.color
        titleLabel.font = style.titleLabel.font
        titleLabel.backgroundColor = style.backgroundColor
        
    }
    
}
