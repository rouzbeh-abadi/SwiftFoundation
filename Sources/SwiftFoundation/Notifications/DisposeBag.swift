
import Foundation

public final class DisposeBag {

   public var isEmpty: Bool {
      return items.isEmpty
   }

   private var items: [Disposable] = []

   public init() {}

   public func add(_ item: Disposable) {
      items.append(item)
   }

   public func dispose() {
      items.forEach { $0.dispose() }
      items.removeAll()
   }

   deinit {
      dispose()
   }

   public static func += (left: DisposeBag, right: Disposable) {
      left.add(right)
   }

   public static func += (left: DisposeBag, right: Disposable?) {
      if let right = right {
         left.add(right)
      }
   }
}
