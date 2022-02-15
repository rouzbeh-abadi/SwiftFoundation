//
//  UITextField.swift
//  
//
//  Created by Rouzbeh on 14.02.22.
//

import Foundation
import UIKit

extension UITextField {
    
    public func setLeftPaddingPoints(_ amount: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: frame.size.height))
        leftView = paddingView
        leftViewMode = .always
    }
    
    public func setRightPaddingPoints(_ amount: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: frame.size.height))
        rightView = paddingView
        rightViewMode = .always
    }
    
    public func placeholderColor(color: UIColor) {
        let attributeString = [
            NSAttributedString.Key.foregroundColor: color.withAlphaComponent(0.6),
            NSAttributedString.Key.font: font!
        ] as [NSAttributedString.Key: Any]
        attributedPlaceholder = NSAttributedString(string: placeholder!, attributes: attributeString)
    }
}
