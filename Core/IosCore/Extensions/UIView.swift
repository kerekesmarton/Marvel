//
//  UI
//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import UIKit

public extension UIView {
    
    // In order to create computed properties for extensions, we need a key to
    // store and access the stored property
    private struct AssociatedKeys {
        static var targetClosure = "targetClosure"
    }
    
    fileprivate typealias Action = ((UITapGestureRecognizer) -> Void)
    
    // Set our computed property type to a closure
    fileprivate var tapGestureRecognizerAction: Action? {
        set {
            if let newValue = newValue {
                // Computed properties get stored as associated objects
                objc_setAssociatedObject(self, &AssociatedKeys.targetClosure, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            }
        }
        get {
            let tapGestureRecognizerActionInstance = objc_getAssociatedObject(self, &AssociatedKeys.targetClosure) as? Action
            return tapGestureRecognizerActionInstance
        }
    }
    
    // This is the meat of the sauce, here we create the tap gesture recognizer and
    // store the closure the user passed to us in the associated object we declared above
    @discardableResult func addTapGestureRecognizer(action: ((UITapGestureRecognizer) -> Void)?) -> UITapGestureRecognizer {
        self.isUserInteractionEnabled = true
        self.tapGestureRecognizerAction = action
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        self.addGestureRecognizer(tapGestureRecognizer)
        
        return tapGestureRecognizer
    }
    
    // Every time the user taps on the UIImageView, this function gets called,
    // which triggers the closure we stored
    @objc fileprivate func handleTapGesture(sender: UITapGestureRecognizer) {
        guard let action = tapGestureRecognizerAction else {
            return
        }
        action(sender)
    }
    
    func dropShadow() {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: -1, height: 1)
        self.layer.shadowRadius = 1
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
    

    /// Remove all subviews from view
    func removeAllSubviews() {
        
        for view in subviews {
            view.removeFromSuperview()
        }
        
    }
    
    ///Adds a Top separator and returns the UIView if needed
    @discardableResult
    func addTopSeparator(color: UIColor?, height: CGFloat, margins:CGFloat)->UIView {
        
        let border = UIView()
        
        border.backgroundColor = color
        border.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(border)
        
        border.addConstraint(NSLayoutConstraint(item: border,
                                                attribute: NSLayoutConstraint.Attribute.height,
                                                relatedBy: NSLayoutConstraint.Relation.equal,
                                                toItem: nil,
                                                attribute: NSLayoutConstraint.Attribute.height,
                                                multiplier: 1, constant: height))
        self.addConstraint(NSLayoutConstraint(item: border,
                                              attribute: NSLayoutConstraint.Attribute.top,
                                              relatedBy: NSLayoutConstraint.Relation.equal,
                                              toItem: self,
                                              attribute: NSLayoutConstraint.Attribute.top,
                                              multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: border,
                                              attribute: NSLayoutConstraint.Attribute.leading,
                                              relatedBy: NSLayoutConstraint.Relation.equal,
                                              toItem: self,
                                              attribute: NSLayoutConstraint.Attribute.leading,
                                              multiplier: 1, constant: margins))
        self.addConstraint(NSLayoutConstraint(item: border,
                                              attribute: NSLayoutConstraint.Attribute.trailing,
                                              relatedBy: NSLayoutConstraint.Relation.equal,
                                              toItem: self,
                                              attribute: NSLayoutConstraint.Attribute.trailing,
                                              multiplier: 1, constant: margins))
        
        return border
        
    }
    
    ///Adds a Right separator and returns the UIView if needed
    @discardableResult
    func addRightSeparator(color: UIColor?, width: CGFloat, margins:CGFloat) -> UIView{
        
        let border = UIView()
        
        border.backgroundColor = color
        border.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(border)
        
        self.addConstraint(NSLayoutConstraint(item: border,
                                              attribute: NSLayoutConstraint.Attribute.top,
                                              relatedBy: NSLayoutConstraint.Relation.equal,
                                              toItem: self,
                                              attribute: NSLayoutConstraint.Attribute.top,
                                              multiplier: 1, constant: margins))
        self.addConstraint(NSLayoutConstraint(item: border,
                                              attribute: NSLayoutConstraint.Attribute.bottom,
                                              relatedBy: NSLayoutConstraint.Relation.equal,
                                              toItem: self,
                                              attribute: NSLayoutConstraint.Attribute.bottom,
                                              multiplier: 1, constant: -margins))
        self.addConstraint(NSLayoutConstraint(item: border,
                                              attribute: NSLayoutConstraint.Attribute.trailing,
                                              relatedBy: NSLayoutConstraint.Relation.equal,
                                              toItem: self,
                                              attribute: NSLayoutConstraint.Attribute.trailing,
                                              multiplier: 1, constant: 0))
        border.addConstraint(NSLayoutConstraint(item: border,
                                                attribute: NSLayoutConstraint.Attribute.width,
                                                relatedBy: NSLayoutConstraint.Relation.equal,
                                                toItem: nil,
                                                attribute: NSLayoutConstraint.Attribute.height,
                                                multiplier: 1, constant: width))
        
        return border
        
    }
    
    ///Adds a Bottom separator and returns the UIView if needed
    @discardableResult
    func addBottomSeparator(color: UIColor?, height: CGFloat, margins:CGFloat) -> UIView{
        
        let border = UIView()
        
        border.backgroundColor = color
        border.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(border)
        
        border.addConstraint(NSLayoutConstraint(item: border,
                                                attribute: NSLayoutConstraint.Attribute.height,
                                                relatedBy: NSLayoutConstraint.Relation.equal,
                                                toItem: nil,
                                                attribute: NSLayoutConstraint.Attribute.height,
                                                multiplier: 1, constant: height))
        self.addConstraint(NSLayoutConstraint(item: border,
                                              attribute: NSLayoutConstraint.Attribute.bottom,
                                              relatedBy: NSLayoutConstraint.Relation.equal,
                                              toItem: self,
                                              attribute: NSLayoutConstraint.Attribute.bottom,
                                              multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: border,
                                              attribute: NSLayoutConstraint.Attribute.leading,
                                              relatedBy: NSLayoutConstraint.Relation.equal,
                                              toItem: self,
                                              attribute: NSLayoutConstraint.Attribute.leading,
                                              multiplier: 1, constant: margins))
        self.addConstraint(NSLayoutConstraint(item: border,
                                              attribute: NSLayoutConstraint.Attribute.trailing,
                                              relatedBy: NSLayoutConstraint.Relation.equal,
                                              toItem: self,
                                              attribute: NSLayoutConstraint.Attribute.trailing,
                                              multiplier: 1, constant: margins))
        
        return border
        
    }
    
    ///Adds a Left separator and returns the UIView if needed
    @discardableResult
    func addLeftSeparator(color: UIColor?, width: CGFloat, margins:CGFloat) -> UIView{
        
        let border = UIView()
        
        border.backgroundColor = color
        border.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(border)
        
        self.addConstraint(NSLayoutConstraint(item: border,
                                              attribute: NSLayoutConstraint.Attribute.top,
                                              relatedBy: NSLayoutConstraint.Relation.equal,
                                              toItem: self,
                                              attribute: NSLayoutConstraint.Attribute.top,
                                              multiplier: 1, constant: margins))
        self.addConstraint(NSLayoutConstraint(item: border,
                                              attribute: NSLayoutConstraint.Attribute.bottom,
                                              relatedBy: NSLayoutConstraint.Relation.equal,
                                              toItem: self,
                                              attribute: NSLayoutConstraint.Attribute.bottom,
                                              multiplier: 1, constant: -margins))
        self.addConstraint(NSLayoutConstraint(item: border,
                                              attribute: NSLayoutConstraint.Attribute.leading,
                                              relatedBy: NSLayoutConstraint.Relation.equal,
                                              toItem: self,
                                              attribute: NSLayoutConstraint.Attribute.leading,
                                              multiplier: 1, constant: 0))
        border.addConstraint(NSLayoutConstraint(item: border,
                                                attribute: NSLayoutConstraint.Attribute.width,
                                                relatedBy: NSLayoutConstraint.Relation.equal,
                                                toItem: nil,
                                                attribute: NSLayoutConstraint.Attribute.height,
                                                multiplier: 1, constant: width))
        
        return border
    
    }
    
    ///Use this method to constraint the edges of a UIView to its superview
    func constraintToSuperviewEdges(isSafe: Bool = false, padding: UIEdgeInsets = .zero){
        
        guard let superview = superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        
        if isSafe {
            topAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.topAnchor, constant: padding.top).isActive = true
            leadingAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.leadingAnchor, constant: padding.left).isActive = true
            bottomAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.bottomAnchor, constant: -padding.bottom).isActive = true
            trailingAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.trailingAnchor, constant: -padding.right).isActive = true
        }
        else {
            topAnchor.constraint(equalTo: superview.topAnchor, constant: padding.top).isActive = true
            leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: padding.left).isActive = true
            bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -padding.bottom).isActive = true
            trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -padding.right).isActive = true
        }
        
    }
    
    static func findView<T:UIView>(ofType type: T.Type, from view: UIView) -> T? {

        for aView in view.subviews {
            if let res = aView as? T {
                return res
            }
            else {
                return findView(ofType:T.self, from: aView)
            }
        }

        return nil
        
    }
    
}
