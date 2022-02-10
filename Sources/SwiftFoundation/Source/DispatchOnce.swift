
import Foundation

public final class DispatchOnce {

   private var isInitialized = false

   public init() {}

   public func perform(block: () -> Void) {
      if !isInitialized {
         block()
         isInitialized = true
      }
   }
}
