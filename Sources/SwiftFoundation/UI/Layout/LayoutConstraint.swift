
#if os(iOS) || os(tvOS)
import UIKit
#elseif os(OSX)
import AppKit
#endif

public struct LayoutConstraint {

   public static func bindings(_ bindings: [String: ViewType]) -> [String: ViewType] {
      return bindings
   }

   public static func metrics(_ metrics: [String: CGFloat]) -> [String: Float] {
      return metrics.mapElements { ($0, Float($1)) }
   }

   #if os(iOS) || os(tvOS)
   public typealias ViewType = UIView
   public typealias EdgeInsets = UIEdgeInsets
   #elseif os(OSX)
   public typealias ViewType = NSView
   public typealias EdgeInsets = NSEdgeInsets
   #endif
}

extension LayoutConstraint {

   public static func withFormat(_ format: String, options: NSLayoutConstraint.FormatOptions = [],
                                 metrics: [String: Float] = [:], _ views: ViewType...) -> [NSLayoutConstraint] {

      let parsedInfo = parseFormat(format: format, views: views)
      let metrics = metrics.mapValues { NSNumber(value: $0) }
      let result = NSLayoutConstraint.constraints(withVisualFormat: parsedInfo.0, options: options, metrics: metrics,
                                                  views: parsedInfo.1)
      return result
   }

   public static func withFormat(_ format: String, options: NSLayoutConstraint.FormatOptions = [],
                                 metrics: [String: Float] = [:], forEveryViewIn: ViewType...) -> [NSLayoutConstraint] {

      let result = forEveryViewIn.map { withFormat(format, options: options, metrics: metrics, $0) }.reduce([]) { $0 + $1 }
      return result
   }

   private static func parseFormat(format: String, views: [ViewType]) -> (String, [String: Any]) {
      let viewPlaceholderCharacter = "*"
      var viewBindings: [String: Any] = [:]
      var parsedFormat = format
      for (index, view) in views.enumerated() {
         let viewBinding = "v\(index)"
         viewBindings[viewBinding] = view
         parsedFormat = parsedFormat.replacingFirstOccurrence(of: viewPlaceholderCharacter, with: viewBinding)
      }
      return (parsedFormat, viewBindings)
   }

   // MARK: - Centering

   public static func centerY(viewA: ViewType, viewB: ViewType, multiplier: CGFloat = 1,
                              constant: CGFloat = 0) -> NSLayoutConstraint {
      return NSLayoutConstraint(item: viewA, attribute: .centerY, relatedBy: .equal, toItem: viewB, attribute: .centerY,
                                multiplier: multiplier, constant: constant)
   }

   public static func centerY(_ views: ViewType..., multiplier: CGFloat = 1, constant: CGFloat = 0) -> [NSLayoutConstraint] {
      var result: [NSLayoutConstraint] = []
      views.forEach {
         if let viewB = $0.superview {
            result.append(centerY(viewA: $0, viewB: viewB, multiplier: multiplier, constant: constant))
         }
      }
      return result
   }

   public static func centerX(viewA: ViewType, viewB: ViewType, multiplier: CGFloat = 1,
                              constant: CGFloat = 0) -> NSLayoutConstraint {
      return NSLayoutConstraint(item: viewA, attribute: .centerX, relatedBy: .equal, toItem: viewB, attribute: .centerX,
                                multiplier: multiplier, constant: constant)
   }

   public static func centerX(_ views: ViewType..., multiplier: CGFloat = 1, constant: CGFloat = 0) -> [NSLayoutConstraint] {
      var result: [NSLayoutConstraint] = []
      views.forEach {
         if let viewB = $0.superview {
            result.append(centerX(viewA: $0, viewB: viewB, multiplier: multiplier, constant: constant))
         }
      }
      return result
   }

   public static func centerXY(viewA: ViewType, viewB: ViewType, multiplierX: CGFloat = 1, constantX: CGFloat = 0,
                               multiplierY: CGFloat = 1, constantY: CGFloat = 0) -> [NSLayoutConstraint] {
      let constraintX = LayoutConstraint.centerX(viewA: viewA, viewB: viewB, multiplier: multiplierX, constant: constantX)
      let constraintY = LayoutConstraint.centerY(viewA: viewA, viewB: viewB, multiplier: multiplierY, constant: constantY)
      return [constraintX, constraintY]
   }

   public static func centerXY(_ view: ViewType, multiplierX: CGFloat = 1, constantX: CGFloat = 0,
                               multiplierY: CGFloat = 1, constantY: CGFloat = 0) -> [NSLayoutConstraint] {
      if let viewB = view.superview {
         return centerXY(viewA: view, viewB: viewB,
                         multiplierX: multiplierX, constantX: constantX, multiplierY: multiplierY, constantY: constantY)
      } else {
         return []
      }
   }

   // MARK: - Dimensions

   public static func constrainHeight(constant: CGFloat, relation: NSLayoutConstraint.Relation = .equal,
                                      multiplier: CGFloat = 1, _ views: ViewType...) -> [NSLayoutConstraint] {
      return views.map {
         NSLayoutConstraint(item: $0, attribute: .height, relatedBy: relation, toItem: nil, attribute: .notAnAttribute,
                            multiplier: multiplier, constant: constant)
      }
   }

   public static func constrainWidth(constant: CGFloat, relation: NSLayoutConstraint.Relation = .equal,
                                     multiplier: CGFloat = 1, _ views: ViewType...) -> [NSLayoutConstraint] {
      return views.map {
         NSLayoutConstraint(item: $0, attribute: .width, relatedBy: relation, toItem: nil, attribute: .notAnAttribute,
                            multiplier: multiplier, constant: constant)
      }
   }

   public static func constrainSize(view: ViewType,
                                    relationForHeight: NSLayoutConstraint.Relation = .equal,
                                    relationForWidth: NSLayoutConstraint.Relation = .equal,
                                    multiplierForHeight: CGFloat = 1, multiplierForWidth: CGFloat = 1,
                                    size: CGSize) -> [NSLayoutConstraint] {
      let constraintW = NSLayoutConstraint(item: view, attribute: .width, relatedBy: relationForWidth,
                                           toItem: nil, attribute: .notAnAttribute,
                                           multiplier: multiplierForWidth, constant: size.width)
      let constraintH = NSLayoutConstraint(item: view, attribute: .height, relatedBy: relationForHeight,
                                           toItem: nil, attribute: .notAnAttribute,
                                           multiplier: multiplierForHeight, constant: size.height)
      return [constraintH, constraintW]
   }

   public static func minimunSize(view: ViewType, size: CGSize) -> [NSLayoutConstraint] {
      return constrainSize(view: view, relationForHeight: .greaterThanOrEqual, relationForWidth: .greaterThanOrEqual, size: size)
   }

   public static func equalWidth(viewA: ViewType, viewB: ViewType, relation: NSLayoutConstraint.Relation = .equal,
                                 multiplier: CGFloat = 1, constant: CGFloat = 0) -> NSLayoutConstraint {
      return NSLayoutConstraint(item: viewA, attribute: .width, relatedBy: relation, toItem: viewB, attribute: .width,
                                multiplier: multiplier, constant: constant)
   }

   public static func equalHeight(viewA: ViewType, viewB: ViewType, relation: NSLayoutConstraint.Relation = .equal,
                                  multiplier: CGFloat = 1, constant: CGFloat = 0) -> NSLayoutConstraint {
      return NSLayoutConstraint(item: viewA, attribute: .height, relatedBy: relation, toItem: viewB, attribute: .height,
                                multiplier: multiplier, constant: constant)
   }

   public static func equalHeight(_ views: [ViewType]) -> [NSLayoutConstraint] {
      var constraints: [NSLayoutConstraint] = []
      var previousView: ViewType?
      for view in views {
         if let previousView = previousView {
            constraints.append(LayoutConstraint.equalHeight(viewA: previousView, viewB: view))
         }
         previousView = view
      }
      return constraints
   }

   public static func equalSize(viewA: ViewType, viewB: ViewType) -> [NSLayoutConstraint] {
      let cH = NSLayoutConstraint(item: viewA, attribute: .height, relatedBy: .equal,
                                  toItem: viewB, attribute: .height,
                                  multiplier: 1, constant: 0)

      let cW = NSLayoutConstraint(item: viewA, attribute: .width, relatedBy: .equal,
                                  toItem: viewB, attribute: .width,
                                  multiplier: 1, constant: 0)

      return [cH, cW]
   }

   public static func constrainAspectRatio(view: ViewType, aspectRatio: CGFloat = 1) -> NSLayoutConstraint {
      return NSLayoutConstraint(item: view, attribute: .width, relatedBy: .equal, toItem: view, attribute: .height,
                                multiplier: aspectRatio, constant: 0)
   }

   // MARK: - Pinning

   public static func pinLeadings(viewA: ViewType, viewB: ViewType, multiplier: CGFloat = 1,
                                  constant: CGFloat = 0) -> NSLayoutConstraint {
      return NSLayoutConstraint(item: viewA, attribute: .leading, relatedBy: .equal, toItem: viewB, attribute: .leading,
                                multiplier: multiplier, constant: constant)
   }

   public static func pinTrailings(viewA: ViewType, viewB: ViewType, multiplier: CGFloat = 1,
                                   constant: CGFloat = 0) -> NSLayoutConstraint {
      return NSLayoutConstraint(item: viewA, attribute: .trailing, relatedBy: .equal, toItem: viewB, attribute: .trailing,
                                multiplier: multiplier, constant: constant)
   }

   public static func pinTrailing(view: ViewType, multiplier: CGFloat = 1, constant: CGFloat = 0) -> [NSLayoutConstraint] {
      if let superview = view.superview {
         return [pinTrailings(viewA: view, viewB: superview, multiplier: multiplier, constant: constant)]
      } else {
         return []
      }
   }

   public static func pinCenterToLeading(viewA: ViewType, viewB: ViewType, multiplier: CGFloat = 1,
                                         constant: CGFloat = 0) -> NSLayoutConstraint {
      return NSLayoutConstraint(item: viewA, attribute: .centerX, relatedBy: .equal, toItem: viewB, attribute: .leading,
                                multiplier: multiplier, constant: constant)
   }

   public static func pinCenterToTrailing(viewA: ViewType, viewB: ViewType, multiplier: CGFloat = 1,
                                          constant: CGFloat = 0) -> NSLayoutConstraint {
      return NSLayoutConstraint(item: viewA, attribute: .centerX, relatedBy: .equal, toItem: viewB, attribute: .trailing,
                                multiplier: multiplier, constant: constant)
   }

   public static func pinTops(viewA: ViewType, viewB: ViewType, relatedBy: NSLayoutConstraint.Relation = .equal,
                              multiplier: CGFloat = 1, constant: CGFloat = 0) -> NSLayoutConstraint {
      return NSLayoutConstraint(item: viewA, attribute: .top, relatedBy: .equal, toItem: viewB, attribute: .top,
                                multiplier: multiplier, constant: constant)
   }

   public static func pinTop(_ view: ViewType, relatedBy: NSLayoutConstraint.Relation = .equal,
                             multiplier: CGFloat = 1, constant: CGFloat = 0) -> [NSLayoutConstraint] {
      if let superview = view.superview {
         return [NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: superview, attribute: .top,
                                    multiplier: multiplier, constant: constant)]
      } else {
         return []
      }
   }

   public static func pinBottoms(viewA: ViewType, viewB: ViewType, relatedBy: NSLayoutConstraint.Relation = .equal,
                                 multiplier: CGFloat = 1, constant: CGFloat = 0) -> NSLayoutConstraint {
      return NSLayoutConstraint(item: viewA, attribute: .bottom, relatedBy: .equal, toItem: viewB, attribute: .bottom,
                                multiplier: multiplier, constant: constant)
   }

   public static func pinBottom(_ view: ViewType, relatedBy: NSLayoutConstraint.Relation = .equal,
                                multiplier: CGFloat = 1, constant: CGFloat = 0) -> [NSLayoutConstraint] {
      if let superview = view.superview {
         return [NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: superview, attribute: .bottom,
                                    multiplier: multiplier, constant: constant)]
      } else {
         return []
      }
   }

   public static func pinTopToBottom(viewA: ViewType, viewB: ViewType, multiplier: CGFloat = 1,
                                     constant: CGFloat = 0) -> NSLayoutConstraint {
      return NSLayoutConstraint(item: viewA, attribute: .top, relatedBy: .equal, toItem: viewB, attribute: .bottom,
                                multiplier: multiplier, constant: constant)
   }

   public static func pinBottomToTop(viewA: ViewType, viewB: ViewType, multiplier: CGFloat = 1,
                                     constant: CGFloat = 0) -> NSLayoutConstraint {
      return NSLayoutConstraint(item: viewA, attribute: .bottom, relatedBy: .equal, toItem: viewB, attribute: .top,
                                multiplier: multiplier, constant: constant)
   }

   #if os(iOS) || os(tvOS)
   public static func pinToEdge(_ edge: UIRectEdge, view: ViewType) -> [NSLayoutConstraint] {
      if edge == .top {
         return withFormat("|[*]|", view) + withFormat("V:|[*]", view)
      } else if edge == .bottom {
         return withFormat("|[*]|", view) + withFormat("V:[*]|", view)
      } else if edge == .left {
         return withFormat("|[*]", view) + withFormat("V:|[*]|", view)
      } else if edge == .right {
         return withFormat("[*]|", view) + withFormat("V:|[*]|", view)
      } else {
         return []
      }
   }
   #endif
}

extension Array where Element: NSLayoutConstraint {

   public func activate(priority: LayoutPriority? = nil) {
      if let priority = priority {
         forEach { $0.priority = priority }
      }
      NSLayoutConstraint.activate(self)
   }

   /// I.e. `999` fix for Apple layout engine issues observed in Cells.
   public func activateApplyingNonRequiredLastItemPriotity() {
      last?.priority = .required - 1
      NSLayoutConstraint.activate(self)
   }

   public func deactivate() {
      NSLayoutConstraint.deactivate(self)
   }
}
