
import CoreGraphics
#if os(OSX)
import AppKit
#elseif os(iOS) || os(tvOS) || os(watchOS)
import UIKit
#endif

extension CGSize {

   #if os(OSX)
   typealias View = NSView
   #elseif os(iOS) || os(tvOS) || os(watchOS)
   typealias View = UIView
   #endif

   public init(squareSide: CGFloat) {
      self.init(width: squareSide, height: squareSide)
   }

   public init(intrinsicWidth: CGFloat) {
      self.init(width: intrinsicWidth, height: View.noIntrinsicMetric)
   }

   public init(intrinsicHeight: CGFloat) {
      self.init(width: View.noIntrinsicMetric, height: intrinsicHeight)
   }

   public func insetBy(dx: CGFloat, dy: CGFloat) -> CGSize {
      return CGSize(width: width - dx, height: height - dy)
   }

   public var isZeroSize: Bool {
      return width <= CGFloat.leastNormalMagnitude && height <= CGFloat.leastNormalMagnitude
   }
}
