
import Foundation

extension Range where Bound: FixedWidthInteger {

   public func expanding(by value: Bound) -> Range {
      let newValue = lowerBound - value ..< upperBound + value
      return newValue
   }

   public func shifted(by value: Bound) -> Range {
      let newValue = lowerBound + value ..< upperBound + value
      return newValue
   }
}
