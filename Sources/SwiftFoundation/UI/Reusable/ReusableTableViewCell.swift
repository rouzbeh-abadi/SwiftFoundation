
import Foundation

#if !os(macOS)
import UIKit

public class ReusableTableViewCell<T: UIView>: UITableViewCell {
    
    public let view: T
    
    public init(view: T = T(), reuseIdentifier: String = T.reusableViewID, pinToMargins: Bool = false) {
        self.view = view.autoLayoutView()
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(view)
        if pinToMargins {
            LayoutConstraint.withFormat("|-[*]-|", view).activate()
            LayoutConstraint.withFormat("V:|-[*]-|", view).activate(priority: UILayoutPriority(rawValue: 999))
        } else {
            LayoutConstraint.withFormat("|[*]|", view).activate()
            LayoutConstraint.withFormat("V:|[*]|", view).activate(priority: UILayoutPriority(rawValue: 999))
        }
    }
    
    public init(view: T = T(), reuseIdentifier: String = T.reusableViewID, margins: UIEdgeInsets) {
        self.view = view.autoLayoutView()
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(view)
        preservesSuperviewLayoutMargins = false
        contentView.preservesSuperviewLayoutMargins = false
        contentView.layoutMargins = margins
        LayoutConstraint.withFormat("|-[*]-|", view).activate()
        LayoutConstraint.withFormat("V:|-[*]-|", view).activate(priority: UILayoutPriority(rawValue: 999))
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

extension ReusableTableViewCell {
    
    public func `default`() -> Self {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        return self
    }
}

extension UITableView {
    
    public func dequeueReusableCell<T: UIView>(_ viewType: T.Type, margins: UIEdgeInsets) -> ReusableTableViewCell<T> {
        let reuseIdentifier = viewType.reusableViewID
        if let cell = dequeueReusableCell(withIdentifier: reuseIdentifier) as? ReusableTableViewCell<T> {
            return cell
        } else {
            return ReusableTableViewCell(reuseIdentifier: reuseIdentifier, margins: margins)
        }
    }
    
    public func dequeueReusableCell<T: UIView>(_ viewType: T.Type, pinToMargins: Bool = false) -> ReusableTableViewCell<T> {
        let reuseIdentifier = viewType.reusableViewID
        if let cell = dequeueReusableCell(withIdentifier: reuseIdentifier) as? ReusableTableViewCell<T> {
            return cell
        } else {
            return ReusableTableViewCell(reuseIdentifier: reuseIdentifier, pinToMargins: pinToMargins)
        }
    }
}
#endif
