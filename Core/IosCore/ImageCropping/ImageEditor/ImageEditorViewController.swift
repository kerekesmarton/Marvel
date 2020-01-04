//
//  UI
//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import UIKit

private let MPGImageEditorViewControllerMinScaleFactor: CGFloat = 0.1
private let MPGImageEditorViewControllerMaxScaleFactor: CGFloat = 5

public protocol ImageEditorViewControllerDelegate: NSObjectProtocol {
    /**
     *  Invoked when the editing(pinch,rotate,pan and double tap) is done on the image editing viewcontroller
     *
     *  @param imageEditingViewController  Object where the editing is started
     */
    func imageEditorViewControllerDidStartEditing(_ imageEditingViewController: ImageEditorViewController?)
    
    /**
     *  Invoked when the editing(pinch,rotate,pan and double tap) is ended or cancelled on the image editing viewcontroller
     *
     *  @param imageEditingViewController  Object where the editing is started
     */
    func imageEditorViewControllerDidEndEditing(_ imageEditingViewController: ImageEditorViewController?)
}

public class ImageEditorViewController: UIViewController, UIGestureRecognizerDelegate {
    
    public var image: UIImage? {
        didSet {
            editingState = ImageEditingState()
            configureEditingStateMinAndMaxScaleFactors()
            configureImageView(with: image)
            resetEditingStateOnImageView()
            updateViewBasedOnEditingState()
        }
    }
    
    weak var delegate: ImageEditorViewControllerDelegate?
    private var allowEditing = true
    
    lazy var imageView: UIImageView = {
        let _imageView = UIImageView()
        _imageView.layer.anchorPoint = CGPoint.zero
        view.addSubview(_imageView)
        return _imageView
    }()
    
    lazy var editingState: ImageEditingState = {
        let _editingState = ImageEditingState()
        _editingState.minScaleFactor = MPGImageEditorViewControllerMinScaleFactor
        _editingState.maxScaleFactor = MPGImageEditorViewControllerMaxScaleFactor
        return _editingState
    }()
    
    public var lastOffset = CGPoint.zero
    public var lastScale: CGFloat = 0.0
    public var lastRotation: CGFloat = 0.0
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        view.clipsToBounds = false
    }
    
    func setImage(_ image: UIImage?, with editingState: ImageEditingState?) {
        guard let editingState = editingState, let image = image else { return }
        
        let areInputSizesCorrect = image.size.equalTo(editingState.transformTask.inputSize)
        
        if !areInputSizesCorrect {
            self.image = image
        } else {
            self.image = image
            self.editingState = editingState
            configureEditingStateMinAndMaxScaleFactors()
            configureImageView(with: image)
            updateViewBasedOnEditingState()
        }
    }
    
    func configureEditingStateMinAndMaxScaleFactors() {
        editingState.minScaleFactor = CGFloat(MPGImageEditorViewControllerMinScaleFactor)
        editingState.maxScaleFactor = CGFloat(MPGImageEditorViewControllerMaxScaleFactor)
    }
    
    func configureImageView(with image: UIImage?) {
        imageView.transform = CGAffineTransform.identity
        imageView.image = image
        imageView.frame = CGRect(x: 0, y: 0, width: image?.size.width ?? 0.0, height: image?.size.height ?? 0.0)
    }
    
    func resetEditingStateOnImageView() {
        guard let image = image else { return }
        let fromSize: CGSize = image.size
        let toSize: CGSize = view.bounds.size
        editingState.resetTransformWith(from: fromSize, to: toSize)
    }
    
    // MARK: - UIGestureRecognizer setup
    
    lazy var pinchGestureRecognizer: UIPinchGestureRecognizer = {
        let pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(didPinch(_:)))
        pinchGestureRecognizer.delegate = self
        return pinchGestureRecognizer
    }()
    
    lazy var doubleTapGestureRecognizer: UITapGestureRecognizer = {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didDoubleTap(_:)))
        tapGestureRecognizer.numberOfTapsRequired = 2
        tapGestureRecognizer.numberOfTouchesRequired = 1
        tapGestureRecognizer.delegate = self
        return tapGestureRecognizer
    }()
    
    lazy var rotationGestureRecognizer: UIRotationGestureRecognizer = {
        let rotationGestureRecognizer = UIRotationGestureRecognizer(target: self, action: #selector(didRotate(_:)))
        rotationGestureRecognizer.delegate = self
        return rotationGestureRecognizer
    }()
    
    lazy var panGestureRecognizer: UIPanGestureRecognizer = {
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didPan(_:)))
        panGestureRecognizer.maximumNumberOfTouches = 2
        panGestureRecognizer.delegate = self
        return panGestureRecognizer
    }()
    
    // MARK: - UIGestureRecognizerDelegate
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        // The user should be able to zoom pan and pinch at the same time
        return true
    }
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        delegate?.imageEditorViewControllerDidStartEditing(self)
        return allowEditing
    }
    
    @objc func didDoubleTap(_ recognizer: UITapGestureRecognizer?) {
        resetEditingStateOnImageView()
        updateViewBasedOnEditingState()
        handleGestureEndState(recognizer)
    }
    
    @objc func didPan(_ recognizer: UIPanGestureRecognizer?) {
        guard let gestureOffset: CGPoint = recognizer?.translation(in: view) else {
            return
        }
        var offsetSinceLastUpdate: CGPoint
        if recognizer?.state == .began {
            offsetSinceLastUpdate = gestureOffset
        } else {
            offsetSinceLastUpdate = CGPoint(x: gestureOffset.x - lastOffset.x, y: gestureOffset.y - lastOffset.y)
        }
        lastOffset = gestureOffset
        editingState.offsetTransform(offsetSinceLastUpdate)
        updateViewBasedOnEditingState()
        handleGestureEndState(recognizer)
    }
    
    @objc func didPinch(_ recognizer: UIPinchGestureRecognizer?) {
        guard let scale: CGFloat = recognizer?.scale, let pinchCenter: CGPoint = recognizer?.location(in: view) else {
            return
        }
        var scaleSinceLastUpdate: CGFloat = 0
        if recognizer?.state == .began {
            scaleSinceLastUpdate = scale
        } else {
            scaleSinceLastUpdate = scale / lastScale
        }
        lastScale = scale
        editingState.scaleTransform(scaleSinceLastUpdate, aboutPoint: pinchCenter)
        updateViewBasedOnEditingState()
        handleGestureEndState(recognizer)
    }
    
    @objc func didRotate(_ recognizer: UIRotationGestureRecognizer?) {
        guard let rotation: CGFloat = recognizer?.rotation, let rotationCenter: CGPoint = recognizer?.location(in: view) else {
            return
        }
        var rotationSinceLastUpdate: CGFloat = 0
        if recognizer?.state == .began {
            rotationSinceLastUpdate = rotation
        } else {
            rotationSinceLastUpdate = rotation - lastRotation
        }
        lastRotation = rotation
        editingState.rotateTransform(rotationSinceLastUpdate, aboutPoint: rotationCenter)
        updateViewBasedOnEditingState()
        handleGestureEndState(recognizer)
    }
    
    func updateViewBasedOnEditingState() {
        let uiKitTransform: CGAffineTransform = editingState.uiKitTransform
        imageView.transform = uiKitTransform
    }
    
    func handleGestureEndState(_ recognizer: UIGestureRecognizer?) {
        if recognizer?.state == .ended || recognizer?.state == .cancelled {
            delegate?.imageEditorViewControllerDidEndEditing(self)
        }
    }
}

