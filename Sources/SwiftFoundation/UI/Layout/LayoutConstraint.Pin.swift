
import Foundation
#if os(iOS) || os(tvOS)
import UIKit
#elseif os(OSX)
import AppKit
#endif

extension LayoutConstraint {

   public enum Target {
      case center, margins, bounds
      case vertically, horizontally
      case verticallyToMargins, horizontallyToMargins
      case horizontallyToSafeArea, verticallyToSafeArea, toSafeArea
      case insets(EdgeInsets), horizontallyWithInsets(EdgeInsets)
   }

   public enum Corner: Int {
      case bottomTrailing
      #if os(iOS) || os(tvOS)
      case bottomTrailingMargins
      #endif
   }
}

extension LayoutConstraint {

   private static func pinAtCenter(in container: ViewType, view: ViewType) -> [NSLayoutConstraint] {
      let result = [container.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                    container.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                    view.leadingAnchor.constraint(greaterThanOrEqualTo: container.leadingAnchor),
                    view.topAnchor.constraint(greaterThanOrEqualTo: container.topAnchor)]
      return result
   }

   private static func pinWithInsets(_ insets: EdgeInsets, in container: ViewType, view: ViewType) -> [NSLayoutConstraint] {
      let metrics = ["top": insets.top, "bottom": insets.bottom, "left": insets.left, "right": insets.right]
      let metricsValue = metrics.mapElements { ($0, NSNumber(value: Float($1))) }
      var constraints: [NSLayoutConstraint] = []
      constraints += NSLayoutConstraint.constraints(withVisualFormat: "|-(left)-[v]-(right)-|",
                                                    options: [], metrics: metricsValue, views: ["v": view])
      constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-(top)-[v]-(bottom)-|",
                                                    options: [], metrics: metricsValue, views: ["v": view])
      return constraints
   }

   private static func pin(in container: ViewType, to: Target, view: ViewType) -> [NSLayoutConstraint] {
      let result: [NSLayoutConstraint]
      switch to {
      case .center:
         result = pinAtCenter(in: container, view: view)
      case .insets(let insets):
         result = pinWithInsets(insets, in: container, view: view)
      case .bounds:
         result = pin(in: container, to: .horizontally, view: view) + pin(in: container, to: .vertically, view: view)
      case .margins:
         result =
            pin(in: container, to: .horizontallyToMargins, view: view) + pin(in: container, to: .verticallyToMargins, view: view)
      case .horizontally:
         result = NSLayoutConstraint.constraints(withVisualFormat: "|[v]|", options: [], metrics: nil, views: ["v": view])
      case .vertically:
         result = NSLayoutConstraint.constraints(withVisualFormat: "V:|[v]|", options: [], metrics: nil, views: ["v": view])
      case .horizontallyToMargins:
         result = NSLayoutConstraint.constraints(withVisualFormat: "|-[v]-|", options: [], metrics: nil, views: ["v": view])
      case .verticallyToMargins:
         result = NSLayoutConstraint.constraints(withVisualFormat: "V:|-[v]-|", options: [], metrics: nil, views: ["v": view])
      case .horizontallyToSafeArea:
         #if !os(macOS)
         result = [view.leadingAnchor.constraint(equalTo: container.safeAreaLayoutGuide.leadingAnchor),
                   container.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: view.trailingAnchor)]
         #else
         fatalError()
         #endif
      case .verticallyToSafeArea:
         #if !os(macOS)
         result = [view.topAnchor.constraint(equalTo: container.safeAreaLayoutGuide.topAnchor),
                   container.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: view.bottomAnchor)]
         #else
         fatalError()
         #endif
      case .toSafeArea:
         result = pin(in: container, to: .horizontallyToSafeArea, view: view)
            + pin(in: container, to: .verticallyToSafeArea, view: view)
      case .horizontallyWithInsets(let insets):
         result = NSLayoutConstraint.constraints(withVisualFormat: "|-\(insets.left)-[v]-\(insets.right)-|",
                                                 options: [], metrics: nil, views: ["v": view])
      }
      return result
   }

   private static func pin(to: Target, _ view: ViewType) -> [NSLayoutConstraint] {
      var result: [NSLayoutConstraint] = []
      if let superview = view.superview {
         result = pin(in: superview, to: to, view: view)
      }
      return result
   }

   public static func pin(in view: ViewType, to: Target, _ views: ViewType...) -> [NSLayoutConstraint] {
      let result = views.map { pin(in: view, to: to, view: $0) }.reduce([]) { $0 + $1 }
      return result
   }

   public static func pin(to: Target, _ views: ViewType...) -> [NSLayoutConstraint] {
      let result = views.map { pin(to: to, $0) }.reduce([]) { $0 + $1 }
      return result
   }
}

extension LayoutConstraint {

   private static func pin(in container: ViewType, to: Corner, view: ViewType) -> [NSLayoutConstraint] {
      let result: [NSLayoutConstraint]
      switch to {
      case .bottomTrailing:
         result = [container.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                   container.trailingAnchor.constraint(equalTo: view.trailingAnchor)]
      #if os(iOS) || os(tvOS)
      case .bottomTrailingMargins:
         result = [container.layoutMarginsGuide.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                   container.layoutMarginsGuide.trailingAnchor.constraint(equalTo: view.trailingAnchor)]
      #endif
      }
      return result
   }

   private static func pinInSuperView(to: Corner, _ view: ViewType) -> [NSLayoutConstraint] {
      var result: [NSLayoutConstraint] = []
      if let superview = view.superview {
         result = pin(in: superview, to: to, view: view)
      }
      return result
   }

   public static func pin(in view: ViewType, to: Corner, _ views: ViewType...) -> [NSLayoutConstraint] {
      let result = views.map { pin(in: view, to: to, view: $0) }.reduce([]) { $0 + $1 }
      return result
   }

   public static func pinInSuperView(to: Corner, _ views: ViewType...) -> [NSLayoutConstraint] {
      let result = views.map { pinInSuperView(to: to, $0) }.reduce([]) { $0 + $1 }
      return result
   }
}
