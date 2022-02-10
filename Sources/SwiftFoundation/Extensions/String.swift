
import Foundation

extension String {

   public var url: URL? {
      return URL(string: self)
   }

   public var replacingPlusEncoding: String {
      return replacingOccurrences(of: "+", with: " ").replacingOccurrences(of: "%2B", with: "+")
   }

   public func replacingCharacters(_ characters: [String], with: String) -> String {
      var result = self

      for character in characters {
         result = result.replacingOccurrences(of: character, with: with)
      }

      return result
   }

   // MARK: -

   public var componentsSeparatedByNewline: [String] {
      return components(separatedBy: .newlines)
   }

   // MARK: -

   public func uppercasedFirstCharacter() -> String {
      return uppercasedFirstCharacters(1)
   }

   public func lowercasedFirstCharacter() -> String {
      return lowercasedFirstCharacters(1)
   }

   public func uppercasedFirstCharacters(_ numberOfCharacters: Int) -> String {
      return changeCaseOfFirstCharacters(numberOfCharacters, action: .upper)
   }

   public func lowercasedFirstCharacters(_ numberOfCharacters: Int) -> String {
      return changeCaseOfFirstCharacters(numberOfCharacters, action: .lower)
   }

   private enum Action { case lower, upper }

   private func changeCaseOfFirstCharacters(_ numberOfCharacters: Int, action: Action) -> String {
      let offset = max(0, min(numberOfCharacters, count))
      if offset > 0 {
         if offset == count {
            switch action {
            case .lower:
               return lowercased()
            case .upper:
               return uppercased()
            }
         } else {
            let splitIndex = index(startIndex, offsetBy: offset)
            let firstCharacters: String
            switch action {
            case .lower:
               firstCharacters = self[..<splitIndex].lowercased()
            case .upper:
               firstCharacters = self[..<splitIndex].uppercased()
            }
            let sentence = self[splitIndex...]
            return firstCharacters + sentence
         }
      } else {
         return self
      }
   }

   // MARK: -

   public var OSTypeValue: OSType {
      let chars = utf8
      var result: UInt32 = 0
      for aChar in chars {
         result = result << 8 + UInt32(aChar)
      }
      return result
   }

   // MARK: -

   public var mutableAttributedString: NSMutableAttributedString {
      return NSMutableAttributedString(string: self)
   }

   public var attributedString: NSAttributedString {
      return NSAttributedString(string: self)
   }

   // MARK: -

   // http://stackoverflow.com/questions/25138339/nsrange-to-rangestring-index
   public func range(from nsRange: NSRange) -> Range<String.Index>? {
      return Range(nsRange, in: self)
   }

   // MARK: -

   struct ComponentsSplitByDelimiter {
      let start: String
      let middle: String
      let end: String
   }

   private func numberOf(_ character: Character) -> Int {
      var result = 0
      for value in self where character == value {
         result += 1
      }
      return result
   }

   // MARK: -

   // See: https://stackoverflow.com/questions/39488488/unescaping-backslash-in-swift
   public var unescaped: String {
      let entities = ["\0": "\\0",
                      "\t": "\\t",
                      "\n": "\\n",
                      "\r": "\\r",
                      "\"": "\\\"",
                      "\'": "\\'"]

      return entities
         .reduce(self) { string, entity in
            string.replacingOccurrences(of: entity.value, with: entity.key)
         }
         .replacingOccurrences(of: "\\\\", with: "\\")
   }
}

extension String {

   public func removingPrefix(_ prefix: String) -> String {
      if hasPrefix(prefix), !prefix.isEmpty {
         let range = startIndex.shifting(by: prefix.count, in: self)
         return String(self[range...])
      } else {
         return self
      }
   }

   public func removingSuffix(_ suffix: String) -> String {
      if hasSuffix(suffix), !suffix.isEmpty {
         let range = endIndex.shifting(by: -suffix.count, in: self)
         return String(self[..<range])
      } else {
         return self
      }
   }

   // See also: https://stackoverflow.com/a/42567641/1418981
   public func leftPadding(toLength: Int, withPad character: Character) -> String {
      let stringLength = count
      if stringLength < toLength {
         return String(repeatElement(character, count: toLength - stringLength)) + self
      } else {
         return self
      }
   }

   public func rangeBetweenCharacters(lower: Character, upper: Character, isBackwardSearch: Bool = true) -> Range<String.Index>? {
      guard let rangeLower = rangeOfCharacter(from: CharacterSet(charactersIn: String(lower)), options: []) else {
         return nil
      }
      if isBackwardSearch {
         guard let rangeUpper = rangeOfCharacter(from: CharacterSet(charactersIn: String(upper)), options: [.backwards]) else {
            return nil
         }
         return rangeLower.upperBound ..< rangeUpper.lowerBound
      } else {
         let searchRange = rangeLower.upperBound ..< endIndex
         guard let rangeUpper = rangeOfCharacter(from: CharacterSet(charactersIn: String(upper)), range: searchRange) else {
            return nil
         }
         return rangeLower.upperBound ..< rangeUpper.lowerBound
      }
   }

   public func replacingFirstOccurrence(of target: String, with replaceString: String) -> String {
      if let targetRange = range(of: target) {
         return replacingCharacters(in: targetRange, with: replaceString)
      }
      return self
   }

   public func replacingLastOccurrence(of target: String, with replaceString: String) -> String {
      if let targetRange = range(of: target, options: .backwards, range: nil, locale: nil) {
         return replacingCharacters(in: targetRange, with: replaceString)
      }
      return self
   }
}

extension String {
    
    public class Throwing {
        fileprivate let string: String
        fileprivate init(string: String) {
            self.string = string
        }
    }
    
    public var throwing: Throwing {
        return Throwing(string: self)
    }
}

extension String.Throwing {
    
    public enum Error: Swift.Error {
        case unableToEncodeToDataUsingEncoding(String.Encoding)
    }
    
    public func data(using: String.Encoding) throws -> Data {
        if let data = string.data(using: using) {
            return data
        } else {
            throw Error.unableToEncodeToDataUsingEncoding(using)
        }
    }
}
