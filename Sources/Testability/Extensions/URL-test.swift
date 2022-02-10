
import Foundation

public extension URL {
    var baseString: String? {
        guard let scheme = scheme, let host = host else { return nil }
        return scheme + "://" + host + path
    }
}
