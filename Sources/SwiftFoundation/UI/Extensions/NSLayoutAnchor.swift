
#if !os(macOS)
import UIKit

extension NSLayoutAnchor {

   @objc public func constraints(equalTo anchors: [NSLayoutAnchor<AnchorType>]) -> [NSLayoutConstraint] {
      var constraints: [NSLayoutConstraint] = []
      for anchor in anchors {

         let constraint = self.constraint(equalTo: anchor)
         constraints.append(constraint)
      }
      return constraints
   }

   @objc public func constraints(greaterThanOrEqualTo anchors: [NSLayoutAnchor<AnchorType>]) -> [NSLayoutConstraint] {
      var constraints: [NSLayoutConstraint] = []
      for anchor in anchors {
         let constraint = self.constraint(greaterThanOrEqualTo: anchor)
         constraints.append(constraint)
      }
      return constraints
   }
}
#endif
