//
//  UI
//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import UIKit
import SnapKit

public class SegmentedTabsView: UIView, Styleable, NibViewLoadable {

    //MARK: - Properties
    let widthOffset: CGFloat = 1
    var singleWidth: CGFloat {
        return (frame.width - 2 * widthOffset) / CGFloat(titles.count)
    }
    
    private var titles: [String] = []
    private var buttons: [UIButton] = []
    
    public var selectedIndex: Int = 0 {
        didSet { animateIndicator(to: selectedIndex) }
    }
    public var selectedSegmentIndex: Int = 0 {
        didSet { animateIndicator(to: selectedIndex) }
    }
    private var didChangeValue: ((Int, Int?) -> Void)?
    
    
    //MARK: - IBOutlets
    @IBOutlet var buttonsStackView: UIStackView! {
        didSet {
            buttonsStackView.axis = .horizontal
            buttonsStackView.alignment = .center
            buttonsStackView.distribution = .fillEqually
        }
    }
    
    
    //MARK: - Public methods
    public func updateSource(titles: [String], didChangeValue: @escaping (Int, Int?) -> Void) {
        self.titles = titles
        self.didChangeValue = didChangeValue
        
        buttonsStackView.subviews.forEach{ $0.removeFromSuperview() }
        
        for (index, title) in titles.enumerated() {
            let button = UIButton()
            
            let buttonBorderColor = styleProvider?.controls?.segmentedTabsView.item?.backgroundColor ?? .gray
            button.tag = index
            button.setTitle(title, for: .normal)
            button.addTarget(self, action: #selector(tabPressed), for: .touchUpInside)
            buttons.append(button)
            buttonsStackView.addArrangedSubview(button)
            
            if index == 0 {
                button.maskSideCorners(edge: .left, border: 1, corner: 5, color: buttonBorderColor)
            }
            else if index == titles.indices.last {
                button.maskSideCorners(edge: .right, border: 1, corner: 5, color: buttonBorderColor)
            }
            else{
                button.addLeftSeparator(color: buttonBorderColor, width: 1, margins: 0)
                button.addRightSeparator(color: buttonBorderColor, width: 1, margins: 0)
            }
            
        }
        
        addTopSeparator(color: styleProvider?.list?.separatorStyle.backgroundColor, height: 1, margins: 0)
        addBottomSeparator(color: styleProvider?.list?.separatorStyle.backgroundColor, height: 1, margins: 0)
        
        applyStyle()
    }
    
    
    //MARK: - Private methods
    private func animateIndicator(to index: Int) {
        UIView.animate(withDuration: 0.2, animations: {
            self.layoutIfNeeded()
        }) { (_) in
            self.applyStyle()
        }
    }
    
    @objc private func tabPressed(sender: UIButton) {
        //only notify didChangeBlock with new and old value once value has been set
        let previousValue = selectedIndex
        selectedIndex = sender.tag
        didChangeValue?(selectedIndex, previousValue)
    }
    
    
    //MARK: - Styleable implementation
    public func applyStyle() {
        
        let style = styleProvider?.controls?.segmentedTabsView
        
        for button in buttons {
            button.layer.borderColor = style?.borderColor.cgColor
            
            if button.tag == selectedIndex {
                button.setTitleColor(style?.item?.color, for: .normal)
                button.titleLabel?.font = style?.item?.font
                button.backgroundColor = style?.item?.backgroundColor
            }
            else {
                button.setTitleColor(style?.unselectedItem?.color, for: .normal)
                button.titleLabel?.font = style?.unselectedItem?.font
                button.backgroundColor = style?.unselectedItem?.backgroundColor
            }
            
            if button.tag != 0 && button.tag != titles.count - 1 {
                button.applyBorderStyle(color: style?.borderColor)
            }
            
        }
        
        applyBorderStyle(color: style?.borderColor)
        
    }

}


