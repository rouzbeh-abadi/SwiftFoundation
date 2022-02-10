
import Foundation

public enum ResponseError: Swift.Error {
    case notHTTPResponse
    case notDataResponse
    case serverFailure(statusCode: Int)
    case unexpectedResponseDataType(Any.Type, expected: Any.Type)
    case unexpectedStatusCode(Int)
}
