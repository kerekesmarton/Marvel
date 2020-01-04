//
//  IosCore
//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import UIKit

private extension UILabel {
    
    func expectedHeight(forWidth width: CGFloat) -> CGFloat {
        guard let attrString = self.attributedText else { return .zero }

        let maxSize = CGSize(width: width, height: .greatestFiniteMagnitude)

        let expectedRect = attrString.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, context: nil)
        return ceil(expectedRect.size.height)
    }
}

public class EmptyStateView: UIView {
    
    private var widthConstraint: NSLayoutConstraint?
    
    private var heightConstraint: NSLayoutConstraint?
    
    private var centerYConstraint: NSLayoutConstraint?
    
    public weak var delegate: EmptyStateDelegate?
    
    public var title: NSAttributedString {
        didSet {
            titleLabel.attributedText = title
            setNeedsUpdateConstraints()
        }
    }
    
    public var image: UIImage? {
        didSet {
            guard let img = image else {
                if oldValue != nil {
                    imageView.removeFromSuperview()
                    setNeedsUpdateConstraints()
                }
                return
            }
            imageView.image = img
            setNeedsUpdateConstraints()
            handleAdding(view: imageView)
        }
    }
    
    public var imageSize: CGSize? { didSet { setNeedsUpdateConstraints() } }
    
    public var imageViewTintColor: UIColor? {
        didSet {
            guard let tintColor = imageViewTintColor else { return }
            imageView.tintColor = tintColor
        }
    }
    
    public var centerYOffset: CGFloat? {
        didSet {
            guard let offset = centerYOffset else { return }
            centerYConstraint?.constant = offset
        }
    }
    
    public var buttonDataModel: PrimaryActionButton.DataModel? {
        didSet {
            guard let buttonModel = buttonDataModel else {
                button.removeFromSuperview()
                setNeedsUpdateConstraints()
                return
            }            
            button.model = buttonModel
            setNeedsUpdateConstraints()
            handleAdding(view: button)
        }
    }
    
    public var buttonSize: CGSize? {
        didSet {
            guard buttonSize != nil else { return }
            setNeedsUpdateConstraints()
        }
    }
    
    public var detailMessage: NSAttributedString? {
        didSet {
            guard let message = detailMessage else {
                if oldValue != nil {
                    detailLabel.removeFromSuperview()
                    setNeedsUpdateConstraints()
                }
                return
            }
            
            detailLabel.attributedText = message
            setNeedsUpdateConstraints()
            handleAdding(view: detailLabel)
        }
    }
    
    public var spacing: CGFloat? { didSet { contentView.spacing = spacing ?? .zero } }
    
    public required init(frame: CGRect, title: NSAttributedString) {
        self.title = title
        super.init(frame: frame)
        initializeViews()
        accessibilityIdentifier = "empty_state_view"
    }
    
    public required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func updateConstraints() {
        super.updateConstraints()
        
        for subview in contentView.subviews {
            
            subview.removeConstraints(subview.constraints)
            
            if let label = subview as? UILabel {
                if let labelWidth = contentView.superview?.superview?.readableContentGuide.layoutFrame.width {
                    label.widthAnchor.constraint(equalToConstant: labelWidth).isActive = true
                    let labelHeight = label.expectedHeight(forWidth: labelWidth)
                    label.heightAnchor.constraint(equalToConstant: labelHeight).isActive = true
                } else {
                    label.sizeToFit()
                    label.widthAnchor.constraint(equalToConstant: label.frame.width).isActive = true
                    label.heightAnchor.constraint(equalToConstant: label.frame.height).isActive = true
                }
            } else if let imageView = subview as? UIImageView {
                let size = imageSize ?? CGSize(width: 100, height: 100)
                imageView.heightAnchor.constraint(equalToConstant: size.height).isActive = true
                imageView.widthAnchor.constraint(equalToConstant: size.width).isActive = true
            } else if let button = subview as? UIButton {
                let size = buttonSize ?? buttonDataModel?.size() ?? CGSize.zero
                button.heightAnchor.constraint(equalToConstant: size.height).isActive = true
                button.widthAnchor.constraint(equalToConstant: size.width).isActive = true
            }
        }
        
        contentView.layoutIfNeeded()
        
        widthConstraint?.isActive = false
        widthConstraint = widthAnchor.constraint(equalToConstant: contentView.frame.width)
        widthConstraint?.isActive = true
        
        heightConstraint?.isActive = false
        heightConstraint = heightAnchor.constraint(equalToConstant: contentView.frame.height)
        heightConstraint?.isActive = true
    }
    
    private func initializeViews() {
        isAccessibilityElement = false
        translatesAutoresizingMaskIntoConstraints = false
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewWasTouched)))
        
        contentView.axis = .vertical
        contentView.distribution = .equalSpacing
        contentView.alignment = .center
        contentView.backgroundColor = UIColor.red
        contentView.spacing = spacing ?? 0
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addArrangedSubview(titleLabel)
        
        addSubview(contentView)
        contentView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        centerYConstraint = contentView.centerYAnchor.constraint(equalTo: centerYAnchor)
        centerYConstraint?.isActive = true
    }
    
    private func handleAdding(view: UIView) {
        
        if contentView.subviews.firstIndex(of: view) != nil { return }
        
        switch view.tag {
        case 1:
            contentView.insertArrangedSubview(view, at: 0)
        case 2:
            contentView.insertArrangedSubview(view, at: 1)
        case 3:
            if contentView.arrangedSubviews.count == 3 {
                contentView.insertArrangedSubview(view, at: 2)
            } else {
                contentView.insertArrangedSubview(view, at: contentView.arrangedSubviews.count)
            }
        case 4:
            contentView.insertArrangedSubview(view, at: contentView.arrangedSubviews.count)
        default:
            return
        }
    }
    
    @objc private func viewWasTouched(view: UIView) {
        delegate?.emptyStateViewWasTapped(view: self)
    }
    
    @objc private func buttonTouched(button: UIButton) {
        delegate?.emptyStatebuttonWasTapped(button: button)
    }
    
    public lazy var contentView = UIStackView()
    
    public lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.attributedText = title
        view.textAlignment = .center
        view.numberOfLines = 0
        view.lineBreakMode = .byWordWrapping
        view.tag = 2
        view.accessibilityIdentifier = "empty_state_title_label"
        return view
    }()
    
    public lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.tag = 1
        return view
    }()
    
    public lazy var button: PrimaryActionButton = {
        let button = PrimaryActionButton(frame: CGRect.zero)
        button.contentVerticalAlignment = .center
        button.contentHorizontalAlignment = .center
        button.tag = 4
        button.addTarget(self, action: #selector(buttonTouched), for: .touchUpInside)
        button.accessibilityIdentifier = "empty_state_button"
        return button
    }()
    
    public lazy var detailLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.numberOfLines = 0
        view.lineBreakMode = .byWordWrapping
        view.tag = 3
        view.accessibilityIdentifier = "empty_state_detail_label"
        return view
    }()
    
    public override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        guard let stackView = subviews.first as? UIStackView else { return super.point(inside: point, with: event) }
        return stackView.subviews.reduce(false, { (result, subview) -> Bool in
            result || subview.point(inside: convert(point, to: subview), with: event)
        })
    }
}
