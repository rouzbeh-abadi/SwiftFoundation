
import Foundation
import XCTest

public struct MockNetworkingData: Equatable {
    
    public enum HTTPMethod: String {
        case options = "OPTIONS"
        case get = "GET"
        case head = "HEAD"
        case post = "POST"
        case put = "PUT"
        case patch = "PATCH"
        case delete = "DELETE"
        case trace = "TRACE"
        case connect = "CONNECT"
    }
    
    public enum DataType: String {
        case json
        case html
        case imagePNG
        case pdf
        case mp4
        case zip
        
        var headerValue: String {
            switch self {
            case .json:
                return "application/json; charset=utf-8"
            case .html:
                return "text/html; charset=utf-8"
            case .imagePNG:
                return "image/png"
            case .pdf:
                return "application/pdf"
            case .mp4:
                return "video/mp4"
            case .zip:
                return "application/zip"
            }
        }
    }
    
    public typealias OnRequest = (_ request: URLRequest, _ httpBodyArguments: [String: Any]?) -> Void
    public let dataType: DataType
    public let requestError: Error?
    public let headers: [String: String]
    public let statusCode: Int
    
    public var url: URL {
        if urlToMock == nil, !data.keys.contains(.get) {
            assertionFailure("For non GET mocks you should use the `request` property so the HTTP method is set.")
        }
        return urlToMock ?? generatedURL
    }
    
    private let urlToMock: URL?
    private let generatedURL: URL
    public let request: URLRequest
    public let ignoreQuery: Bool
    public let fileExtensions: [String]?
    private let data: [HTTPMethod: Data]
    public var delay: DispatchTimeInterval?
    public var cacheStoragePolicy: URLCache.StoragePolicy = .notAllowed
    public var completion: (() -> Void)?
    public var onRequest: OnRequest?
    var onRequestExpectation: XCTestExpectation?
//
    var onCompletedExpectation: XCTestExpectation?
    
    private init(url: URL? = nil, ignoreQuery: Bool = false, cacheStoragePolicy: URLCache.StoragePolicy = .notAllowed, dataType: DataType, statusCode: Int, data: [HTTPMethod: Data], requestError: Error? = nil, additionalHeaders: [String: String] = [:], fileExtensions: [String]? = nil) {
        urlToMock = url
        let generatedURL = URL(string: "https://SwiftFoundation.com/\(dataType.rawValue)/\(statusCode)/\(data.keys.first!.rawValue)")!
        self.generatedURL = generatedURL
        var request = URLRequest(url: url ?? generatedURL)
        request.httpMethod = data.keys.first!.rawValue
        self.request = request
        self.ignoreQuery = ignoreQuery
        self.requestError = requestError
        self.dataType = dataType
        self.statusCode = statusCode
        self.data = data
        self.cacheStoragePolicy = cacheStoragePolicy
        
        var headers = additionalHeaders
        headers["Content-Type"] = dataType.headerValue
        self.headers = headers
        
        self.fileExtensions = fileExtensions?.map({ $0.replacingOccurrences(of: ".", with: "") })
    }
    
    /// Creates a `Mock` for the given data type. The mock will be automatically matched based on a URL created from the given parameters.
    ///
    /// - Parameters:
    ///   - dataType: The type of the data which is returned.
    ///   - statusCode: The HTTP status code to return with the response.
    ///   - data: The data which will be returned as the response based on the HTTP Method.
    ///   - additionalHeaders: Additional headers to be added to the response.
    public init(dataType: DataType, statusCode: Int, data: [HTTPMethod: Data], additionalHeaders: [String: String] = [:]) {
        self.init(url: nil, dataType: dataType, statusCode: statusCode, data: data, additionalHeaders: additionalHeaders, fileExtensions: nil)
    }
    
    /// Creates a `Mock` for the given URL.
    ///
    /// - Parameters:
    ///   - url: The URL to match for and to return the mocked data for.
    ///   - ignoreQuery: If `true`, checking the URL will ignore the query and match only for the scheme, host and path. Defaults to `false`.
    ///   - cacheStoragePolicy: The caching strategy. Defaults to `notAllowed`.
    ///   - reportFailure: if `true`, the URLsession will report an error loading the URL rather than returning data. Defaults to `false`.
    ///   - dataType: The type of the data which is returned.
    ///   - statusCode: The HTTP status code to return with the response.
    ///   - data: The data which will be returned as the response based on the HTTP Method.
    ///   - additionalHeaders: Additional headers to be added to the response.
    public init(url: URL, ignoreQuery: Bool = false, cacheStoragePolicy: URLCache.StoragePolicy = .notAllowed, dataType: DataType, statusCode: Int, data: [HTTPMethod: Data], additionalHeaders: [String: String] = [:], requestError: Error? = nil) {
        self.init(url: url, ignoreQuery: ignoreQuery, cacheStoragePolicy: cacheStoragePolicy, dataType: dataType, statusCode: statusCode, data: data, requestError: requestError, additionalHeaders: additionalHeaders, fileExtensions: nil)
    }
    
    /// Creates a `Mock` for the given file extensions. The mock will only be used for urls matching the extension.
    ///
    /// - Parameters:
    ///   - fileExtensions: The file extension to match for.
    ///   - dataType: The type of the data which is returned.
    ///   - statusCode: The HTTP status code to return with the response.
    ///   - data: The data which will be returned as the response based on the HTTP Method.
    ///   - additionalHeaders: Additional headers to be added to the response.
    public init(fileExtensions: String..., dataType: DataType, statusCode: Int, data: [HTTPMethod: Data], additionalHeaders: [String: String] = [:]) {
        self.init(url: nil, dataType: dataType, statusCode: statusCode, data: data, additionalHeaders: additionalHeaders, fileExtensions: fileExtensions)
    }
    
    /// Registers the mock with the shared `Mocker`.
    public func register() {
        DataMocker.register(self)
    }
    
    public func unregister() {
        DataMocker.removeAll()
    }
    
    /// Returns `Data` based on the HTTP Method of the passed request.
    ///
    /// - Parameter request: The request to match data for.
    /// - Returns: The `Data` which matches the request. Will be `nil` if no data is registered for the request `HTTPMethod`.
    func data(for request: URLRequest) -> Data? {
        guard let requestHTTPMethod = MockNetworkingData.HTTPMethod(rawValue: request.httpMethod ?? "") else { return nil }
        return data[requestHTTPMethod]
    }
    
    /// Used to compare the Mock data with the given `URLRequest`.
    static func == (mock: MockNetworkingData, request: URLRequest) -> Bool {
        guard let requestHTTPMethod = MockNetworkingData.HTTPMethod(rawValue: request.httpMethod ?? "") else { return false }
        
        if let fileExtensions = mock.fileExtensions {
            // If the mock contains a file extension, this should always be used to match for.
            guard let pathExtension = request.url?.pathExtension else { return false }
            return fileExtensions.contains(pathExtension)
        } else if mock.ignoreQuery {
            return mock.request.url!.baseString == request.url?.baseString && mock.data.keys.contains(requestHTTPMethod)
        }
        
        return mock.request.url!.absoluteString == request.url?.absoluteString && mock.data.keys.contains(requestHTTPMethod)
    }
    
    public static func == (lhs: MockNetworkingData, rhs: MockNetworkingData) -> Bool {
        let lhsHTTPMethods: [String] = lhs.data.keys.compactMap { $0.rawValue }
        let rhsHTTPMethods: [String] = rhs.data.keys.compactMap { $0.rawValue }
        
        if let lhsFileExtensions = lhs.fileExtensions, let rhsFileExtensions = rhs.fileExtensions, !lhsFileExtensions.isEmpty || !rhsFileExtensions.isEmpty {
            return lhsFileExtensions == rhsFileExtensions && lhsHTTPMethods == rhsHTTPMethods
        }
        
        return lhs.request.url!.absoluteString == rhs.request.url!.absoluteString && lhsHTTPMethods == rhsHTTPMethods
    }
}





