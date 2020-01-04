//
//  UI
//
//  Copyright © 2018 mkerekes. All rights reserved.
//


import UIKit

public typealias UIButtonTargetClosure = (UIButton) -> ()

class ClosureWrapper: NSObject {
    let closure: UIButtonTargetClosure
    init(_ closure: @escaping UIButtonTargetClosure) {
        self.closure = closure
    }
}

public extension UIButton {
    
    func setBackgroundColor(_ color: UIColor, for state: UIControl.State) {
        
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        UIGraphicsGetCurrentContext()!.setFillColor(color.cgColor)
        UIGraphicsGetCurrentContext()!.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        setBackgroundImage(colorImage, for: state)
        
    }
    
    private struct AssociatedKeys {
        static var targetClosure = "targetClosure"
        static var targetLongClosure = "targetLongClosure"
    }
    
    private var targetClosure: UIButtonTargetClosure? {
        get {
            guard let closureWrapper = objc_getAssociatedObject(self, &AssociatedKeys.targetClosure) as? ClosureWrapper else { return nil }
            return closureWrapper.closure
        }
        set(newValue) {
            guard let newValue = newValue else { return }
            objc_setAssociatedObject(self, &AssociatedKeys.targetClosure, ClosureWrapper(newValue), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    private var longPressTargetClosure: UIButtonTargetClosure? {
        get {
            guard let closureWrapper = objc_getAssociatedObject(self, &AssociatedKeys.targetLongClosure) as? ClosureWrapper else { return nil }
            return closureWrapper.closure
        }
        set(newValue) {
            guard let newValue = newValue else { return }
            objc_setAssociatedObject(self, &AssociatedKeys.targetLongClosure, ClosureWrapper(newValue), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func addTargetClosure(closure: @escaping UIButtonTargetClosure) {
        targetClosure = closure
        addTarget(self, action: #selector(closureAction), for: .touchUpInside)
    }
    
    func add(closure: @escaping UIButtonTargetClosure, longPressClosure: @escaping UIButtonTargetClosure) {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector (closureAction(sender:)))
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(longClosureAction(sender:)))
        addGestureRecognizer(tapGesture)
        addGestureRecognizer(longGesture)
        
        targetClosure = closure
        longPressTargetClosure = longPressClosure
    }
    
    @objc func closureAction(sender: Any) {
        guard let closure = targetClosure else { return }
        closure(self)
    }
    
    @objc func longClosureAction(sender: Any) {
        longPressTargetClosure?(self)
        guard let gesture = sender as? UILongPressGestureRecognizer else { return }
        
        gesture.isEnabled = false
        gesture.isEnabled = true
    }
    
}
