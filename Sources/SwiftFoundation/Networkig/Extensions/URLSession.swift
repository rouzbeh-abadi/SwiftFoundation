
import Foundation

extension URLSession {
    
    public typealias Response = Swift.Result<(Data, HTTPURLResponse), Swift.Error>
    
    public func httpDataTask(with request: URLRequest, completion: @escaping (Response) -> Void) -> URLSessionDataTask {
        let task = dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(ResponseError.notHTTPResponse))
                return
            }
            guard let data = data else {
                completion(.failure(ResponseError.notDataResponse))
                return
            }
            completion(.success((data, httpResponse)))
        }
        return task
    }
}

