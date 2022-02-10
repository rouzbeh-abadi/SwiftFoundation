
import Foundation

public final class DispatchUntil {

   private var mIsFulfilled = false

   public var isFulfilled: Bool {
      return mIsFulfilled
   }

   public init() {}
}

extension DispatchUntil {

   public func performIfNeeded(block: () -> Void) {
      if !mIsFulfilled {
         block()
      }
   }

   public func fulfill() {
      if !mIsFulfilled {
         mIsFulfilled = true
      }
   }
}
