
import Foundation

#if !os(macOS)
import UIKit

public class ReusableCollectionViewCell<T: UIView>: UICollectionViewCell {
    
    public let view: T
    
    public override init(frame: CGRect) {
        view = T().autoLayoutView()
        super.init(frame: frame)
        setPinnedToMargins(false)
    }
    
    fileprivate func setPinnedToMargins(_ value: Bool) {
        view.removeFromSuperview()
        contentView.addSubview(view)
        if value {
            LayoutConstraint.withFormat("|-[*]-|", view).activate()
            LayoutConstraint.withFormat("V:|-[*]-|", view).activate()
        } else {
            LayoutConstraint.withFormat("|[*]|", view).activate()
            LayoutConstraint.withFormat("V:|[*]|", view).activate()
        }
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        if let view = view as? ReusableCellContentView {
            view.prepareForReuse()
        }
    }
}

extension UICollectionView {
    
    public func dequeueReusableCell<T: UIView>(_ viewType: T.Type, pinToMargins: Bool = false,
                                               indexPath: IndexPath) -> ReusableCollectionViewCell<T> {
        let cell = dequeueReusableCell(reusableType: ReusableCollectionViewCell<T>.self, indexPath: indexPath)
        cell.setPinnedToMargins(pinToMargins)
        return cell
    }
}
#endif
