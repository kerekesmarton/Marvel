//
//  UI
//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import UIKit

extension UIViewController {
   public func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    public func setLogoInNavigation(image: UIImage) {
        let maxW: CGFloat = 200
        let maxH: CGFloat = 40

        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: 0, y: 0, width: maxW, height: maxH)
        imageView.contentMode = .scaleAspectFit

        let titleView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: maxW, height: maxH))
        titleView.addSubview(imageView)
        navigationItem.titleView = titleView
    }
}
