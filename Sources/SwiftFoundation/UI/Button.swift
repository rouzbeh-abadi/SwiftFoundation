
import Foundation
import UIKit

open class Button: UIButton {
    
    public init(title: String, radius: CGFloat, height: CGFloat, color: UIColor, tintColor: UIColor) {
        super.init(frame: .zero)
        setTitle(title, for: .normal)
        self.tintColor = tintColor
        setTitleColor(tintColor, for: .normal)
        titleLabel?.font = .systemFont(ofSize: 14)
        backgroundColor = color
        heightAnchor.constraint(equalToConstant: height).isActive = true
        setCornerRadius(radius)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
