
import Foundation

extension String {
    
    public var pathExtension: String {
        return (self as NSString).pathExtension
    }
    
    public var deletingLastPathComponent: String {
        return (self as NSString).deletingLastPathComponent
    }
    
    public func appendingPathComponent(_ str: String) -> String {
        return (self as NSString).appendingPathComponent(str)
    }
    
    public var deletingPathExtension: String {
        return (self as NSString).deletingPathExtension
    }
    
    public func appendingPathExtension(_ str: String) -> String? {
        return (self as NSString).appendingPathExtension(str)
    }
    
    public var lastPathComponent: String {
        return (self as NSString).lastPathComponent
    }
    
    public var expandingTildeInPath: String {
        return (self as NSString).expandingTildeInPath
    }
    
    public func replacingCharacters(in nsRange: NSRange, with: String) -> String {
        return (self as NSString).replacingCharacters(in: nsRange, with: with)
    }
    
    public func nsRange(of searchString: String) -> NSRange {
        return (self as NSString).range(of: searchString)
    }
    
    public func deletingLastPathComponents(_ numberOfComponents: Int) -> String {
        var result = self
        for _ in 0 ..< numberOfComponents {
            result = result.deletingLastPathComponent
        }
        return result
    }
}
