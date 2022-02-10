
import Foundation

extension String.Index {

   public func shifting(by offset: Int, in string: String) -> String.Index {
      return String.Index(utf16Offset: utf16Offset(in: string) + offset, in: string)
   }
}
