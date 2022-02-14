//
//  UIView.swift
//  
//
//  Created by Rouzbeh on 14.02.22.
//

#if !os(macOS)
import UIKit

extension UIView {
    
    public convenience init(backgroundColor: UIColor) {
        self.init(frame: CGRect())
        self.backgroundColor = backgroundColor
    }
}

extension UIView {
    
    public var isVisible: Bool {
        get {
            return !isHidden
        } set {
            isHidden = !newValue
        }
    }
}

extension UIView {
    
    public func setBackgroundColor(_ color: UIColor, animationDuration: TimeInterval) {
        let temporaryView = UIView()
        temporaryView.backgroundColor = color
        temporaryView.alpha = 0
        
        insertSubview(temporaryView, at: 0)
        temporaryView.translatesAutoresizingMaskIntoConstraints = false
        leadingAnchor.constraint(equalTo: temporaryView.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: temporaryView.trailingAnchor).isActive = true
        topAnchor.constraint(equalTo: temporaryView.topAnchor).isActive = true
        bottomAnchor.constraint(equalTo: temporaryView.bottomAnchor).isActive = true
        
        UIView.animate(withDuration: animationDuration, animations: {
            temporaryView.alpha = 1.0
        }, completion: { _ in
            self.backgroundColor = color
            temporaryView.removeFromSuperview()
        })
    }
    
    @discardableResult
    public func dropShadow(shadowColor: UIColor = UIColor.black,
                           fillColor: UIColor = UIColor.white,
                           opacity: Float = 0.2,
                           offset: CGSize = CGSize(width: 0.0, height: 1.0),
                           radius: CGFloat = 10) -> CAShapeLayer {
        
        let shadowLayer = CAShapeLayer()
        shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: radius).cgPath
        shadowLayer.fillColor = fillColor.cgColor
        shadowLayer.shadowColor = shadowColor.cgColor
        shadowLayer.shadowPath = shadowLayer.path
        shadowLayer.shadowOffset = offset
        shadowLayer.shadowOpacity = opacity
        shadowLayer.shadowRadius = radius
        layer.insertSublayer(shadowLayer, at: 0)
        return shadowLayer
    }
    
    public func setBorder(width: CGFloat, color: UIColor? = nil) {
        layer.borderWidth = width
        layer.borderColor = color?.cgColor
    }
    
    public func setCornerRadius(_ radius: CGFloat) {
        layer.masksToBounds = radius > 0
        layer.cornerRadius = radius
    }
}

extension UIView {
    
    public func frameIn(_ view: UIView?) -> CGRect {
        if let superview = superview {
            return superview.convert(frame, to: view)
        }
        return frame
    }
    
    public func originIn(_ view: UIView?) -> CGPoint {
        if let superview = superview {
            return superview.convert(frame.origin, to: view)
        }
        return frame.origin
    }
    
    public func centerIn(_ view: UIView?) -> CGPoint {
        if let superview = superview {
            return superview.convert(center, to: view)
        }
        return center
    }
}

extension UIView {
    
    public func mask(view: UIView, withRect rect: CGRect) {
        let maskLayer = CAShapeLayer()
        let path = CGPath(rect: rect, transform: nil)
        maskLayer.path = path
        view.layer.mask = maskLayer
    }
}
#endif
