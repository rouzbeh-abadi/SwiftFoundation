
#if !os(macOS)
import UIKit

extension UIStackView {

   public convenience init(axis: NSLayoutConstraint.Axis) {
      self.init()
      self.axis = axis
   }

   public func addArrangedSubviews(_ subviews: UIView...) {
      addArrangedSubviews(subviews)
   }

   public func addArrangedSubviews(_ subviews: [UIView]) {
      subviews.forEach {
         addArrangedSubview($0)
      }
   }

   public func removeArrangedSubviews() {
      let views = arrangedSubviews
      views.forEach {
         removeArrangedSubview($0)
         $0.removeFromSuperview()
      }
   }
}
#endif
