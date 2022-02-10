
import Foundation

public enum RequestParams {
    case bodyData(Data)
    case bodyParameters([AnyHashable: Any])
    case query([AnyHashable: Any])
    case none
}
