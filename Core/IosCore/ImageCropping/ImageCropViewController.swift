//
//  UI
//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import Foundation
import Presentation

public protocol ImageCropRouter {
    func close(completion: (()-> Void)?)
}

public class ImageCropViewController: UIViewController {
    
    public typealias ImageCropCompletion = (UIImage?)->Void
    public struct Model {
        let image: UIImage
        let style: CameraRoutingOption
        
        public init(image: UIImage, style: CameraRoutingOption) {
            self.image = image
            self.style = style
        }
    }
    
    public var completion: ImageCropCompletion?
    public var model: Model!
    public var router: ImageCropRouter?
    
    private func addNormalGestures(_ imageEditorViewController: ImageEditorViewController) {
        view.addGestureRecognizer(imageEditorViewController.pinchGestureRecognizer)
        view.addGestureRecognizer(imageEditorViewController.doubleTapGestureRecognizer)
        view.addGestureRecognizer(imageEditorViewController.panGestureRecognizer)
    }
    
    private func addRotationGesture(_ imageEditorViewController: ImageEditorViewController) {
        view.addGestureRecognizer(imageEditorViewController.rotationGestureRecognizer)
    }
    
    private func configureImageEditorViewController() {
        guard let imageEditorViewController = children.first as? ImageEditorViewController else  {
            fatalError("Check storyboard for missing LocationTableViewController")
        }
        self.imageEditorViewController = imageEditorViewController
        imageEditorViewController.delegate = self
        
        switch model.style {
        case .viewer:
            navigationItem.rightBarButtonItem = nil
        default:
            ()
        }
        addNormalGestures(imageEditorViewController)
        addRotationGesture(imageEditorViewController)
    }
    
    private func configureContainers() {
        
        if case CameraRoutingOption.edit(shape: let shape, data: _) = model.style , case CameraRoutingOption.Shape.square(ratio: let ratio) = shape {
            NSLayoutConstraint.activate([containerView.heightAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: CGFloat(ratio))])
        } else {
            NSLayoutConstraint.activate([containerView.heightAnchor.constraint(equalTo: containerView.widthAnchor)])
        }
        
        UIView.animate(withDuration: 0.01, animations: {
            self.view.layoutIfNeeded()
        }) { (completed) in
            self.setupImage()
        }
    }
    
    var fillLayer: CAShapeLayer?
    
    private func drawLayers(_ path2: UIBezierPath!) {
        path2.usesEvenOddFillRule = true
        if let fillLayer = self.fillLayer {
            fillLayer.removeFromSuperlayer()
        }
        let path = UIBezierPath(rect: passThroughView.frame)
        path.append(path2)
        path.usesEvenOddFillRule = true
        let fillLayer = CAShapeLayer()
        fillLayer.path = path.cgPath
        fillLayer.fillRule = CAShapeLayerFillRule.evenOdd
        fillLayer.fillColor = UIColor.black.cgColor
        fillLayer.opacity = 0.8
        passThroughView.layer.addSublayer(fillLayer)
        self.fillLayer = fillLayer
    }
    
    fileprivate func setupRoundImage() {
        let size = min(passThroughView.frame.width, passThroughView.frame.height)
        let y = (passThroughView.frame.maxY - size) / 2
        let x = (passThroughView.frame.maxX - size) / 2
        let path = UIBezierPath(ovalIn: CGRect(x: x, y: y, width: size, height: size))
        drawLayers(path)
    }
    
    fileprivate func setupSquareImage(ratio: Double) {
        let w = passThroughView.frame.width
        let h = w * CGFloat(ratio)
        let y = (passThroughView.frame.height - h) / 2
        let path = UIBezierPath(rect: CGRect(x: 0, y: y, width: w, height: h))        
        drawLayers(path)
    }
    
    private func setupImage() {
        switch model.style {
        case .edit(shape: let shape, data: _):
            switch shape {
            case .round:
                setupRoundImage()
            case .square(ratio: let ratio):
                setupSquareImage(ratio: ratio)
            }
            
        case .picker:
            setupRoundImage()
        default:
            ()
        }

        imageEditorViewController?.image = model.image
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        configureImageEditorViewController()
        configureContainers()
    }
    
    public override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(alongsideTransition: { (context) in
            self.configureContainers()
        }) { (context) in }
    }
    
    @IBOutlet var containerView: UIView!
    @IBOutlet var passThroughView: PassThroughView!
    var imageEditorViewController: ImageEditorViewController?
    
    @IBOutlet var saveButton: UIBarButtonItem!
    @IBAction func save(_ sender: Any) {
        guard let state = imageEditorViewController?.editingState else {
            return
        }
        let spinner = UIActivityIndicatorView(style: .gray)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: spinner)
        spinner.startAnimating()
        ImageTransformer().transformImage(model.image, with: state.transformTask) { [weak self] (image) in
            spinner.stopAnimating()
            self?.router?.close(completion: { [weak self] in
                self?.completion?(image)
            })            
        }
    }
    
    @IBOutlet var closeButton: UIBarButtonItem! {
        didSet {
            closeButton.setBackgroundImage(#imageLiteral(resourceName: "closeDelete"), for: .normal, barMetrics: .default)
        }
    }
    
    @IBAction func close(_ sender: Any) {
        router?.close(completion: { [weak self] in
            self?.completion?(nil)
        })
    }
}

extension ImageCropViewController: ImageEditorViewControllerDelegate {
    public func imageEditorViewControllerDidStartEditing(_ imageEditingViewController: ImageEditorViewController?) {}
    public func imageEditorViewControllerDidEndEditing(_ imageEditingViewController: ImageEditorViewController?) {}
}
