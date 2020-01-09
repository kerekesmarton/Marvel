//
//  TextViewController.swift
//  IosCore
//
//  Created by Marton Kerekes on 08/01/2020.
//  Copyright © 2020 Marton Kerekes. All rights reserved.
//

import Foundation
import UIKit
import Presentation


class TextViewController: ViewController, TextPresentationOutput {
    
    var presenter: TextPresenting!
    var textView: UITextView! {
        return view as? UITextView
    }
    
    override func loadView() {
        view = UITextView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.viewReady()
    }
    
    override func applyStyle() {
        super.applyStyle()
    }
    
    func reload(text: NSAttributedString) {
        guard let w = view.superview?.frame.width else { return }
        textView.attributedText = text
        let size = textView.sizeThatFits(CGSize(width: w, height: 10000))
        textView.contentSize = size
        
        updateSegmentDelegate()
    }
    
    var delegate: SegmentsRoutableChildDelegate?
    
    private func updateSegmentDelegate() {
        DispatchQueue.main.async {
            self.delegate?.didUpdate(self.textView)
        }
    }
}

extension TextViewController: SegmentsRoutableChild {
    var routableScrollView: UIScrollView? {
        get {
            loadViewIfNeeded()
            view.layoutIfNeeded()
            return textView
        }
    }
    
    func didScroll(to index: IndexPath) {
        
    }
}
