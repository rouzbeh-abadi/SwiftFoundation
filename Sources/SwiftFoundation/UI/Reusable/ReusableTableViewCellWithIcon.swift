
import Foundation

#if !os(macOS)
import UIKit

public class ReusableTableViewCellWithIcon: View {
    
    private lazy var stackView = StackView(axis: .horizontal).autoLayoutView()
    private lazy var iconImage = UIImageView().autoLayoutView()
    private lazy var titleLabel = UILabel().autoLayoutView()
    
    
}

// MARK: - Method

extension ReusableTableViewCellWithIcon {
    

    
    /// Configure cell based on data
    /// - Parameters:
    ///   - icon: The icon the left side of the cell
    ///   - title: The title in the right side of icon
    ///   - accentColor: The accent color of the icon
    ///   - titleColor: The color  of the title label
    ///   - fontSize: The font size of the title label
    func configure(icon: UIImage, title: String, accentColor: UIColor, titleColor: UIColor, fontSize: CGFloat) {
        titleLabel.text = title
        iconImage.image = icon
        iconImage.tintColor = tintColor
        titleLabel.textColor = titleColor
        titleLabel.font = UIFont.systemFont(ofSize: fontSize)
    }
}


// MARK: - Default

extension ReusableTableViewCellWithIcon {
    
    public override func setupStackViews() {
        addSubviews(stackView)
        stackView.addArrangedSubviews(iconImage, titleLabel, UIView())
        stackView.spacing = 10
    }
    
    public override func setupLayout() {
        LayoutConstraint.pin(to: .margins, stackView).activate()
        LayoutConstraint.constrainSize(view: iconImage, size: CGSize(squareSide: 30)).activate()
    }
}
#endif
