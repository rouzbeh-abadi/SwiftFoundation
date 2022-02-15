
import Foundation

public protocol Request {
    
    var path: String { get }
    var baseUrl: String { get }
    var method: HTTPMethod { get }
    var headers: [HTTPHeader]? { get }
    
    func parameters() throws -> RequestParams
    func isAccepted(statusCode: Int) -> Bool
    func error(from: Data) -> Swift.Error?
}

extension Request {
    
    var urlString: String {
        return baseUrl + path
    }
    
    func url() throws -> URL {
        guard let url = URL(string: urlString) else {
            throw RequestError.invalidURL(urlString)
        }
        return url
    }
    
    public func toURLRequest() throws -> URLRequest {
        var urlRequest = URLRequest(url: try url())
        let params = try parameters()
        switch params {
        case .bodyParameters(let params):
            urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
        case .query(let params):
            let params = params.map { ("\($0.key)", "\($0.value)") }.sorted(by: { $0.0 < $1.0 })
            let queryParams = params.map { element in
                URLQueryItem(name: element.0, value: element.1)
            }
            
            if var components = URLComponents(string: urlString) {
                components.queryItems = queryParams
                urlRequest.url = components.url
            }
        case .bodyData(let value):
            urlRequest.httpBody = value
        case .none:
            break
        }
        
        urlRequest.httpMethod = method.rawValue
        
        headers?.forEach { urlRequest.addValue($0.value, forHTTPHeaderField: $0.key) }
        
        return urlRequest
    }
    
    public func isAccepted(statusCode: Int) -> Bool {
        return (200 ... 299).contains(statusCode)
    }
    
    public func error(from: Data) -> Swift.Error? {
        return nil
    }
}
