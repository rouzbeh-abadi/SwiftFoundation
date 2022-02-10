
import Foundation

extension URLSession {
    
    public typealias DataResult = Swift.Result<Data, Swift.Error>
    public typealias JsonResult<Key: Hashable, Value> = Swift.Result<[Key: Value], Swift.Error>
    public typealias ObjectResult<T> = Swift.Result<T, Swift.Error>
    
    public func dataTask(request: Request, completion: @escaping (DataResult) -> Void) throws -> URLSessionDataTask {
        let urlRequest = try request.toURLRequest()
        let task = httpDataTask(with: urlRequest) { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success((let data, let response)):
                if request.isAccepted(statusCode: response.statusCode) {
                    completion(.success(data))
                } else {
                    if let error = request.error(from: data) {
                        completion(.failure(error))
                    } else {
                        completion(.failure(ResponseError.unexpectedStatusCode(response.statusCode)))
                    }
                }
            }
        }
        return task
    }
    
    public func jsonTask<Key: Hashable, Value>(request: Request,
                                               completion: @escaping (JsonResult<Key, Value>) -> Void) throws -> URLSessionDataTask {
        let task = try dataTask(request: request) {
            switch $0 {
            case .failure(let error):
                completion(.failure(error))
            case .success(let data):
                do {
                    let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
                    if let json = jsonObject as? [Key: Value] {
                        completion(.success(json))
                    } else {
                        completion(.failure(ResponseError.unexpectedResponseDataType(type(of: jsonObject), expected: [Key: Value].self)))
                    }
                } catch {
                    completion(.failure(error))
                }
            }
        }
        return task
    }
    
    public func objectTask<T: Decodable>(_: T.Type, request: Request,
                                         completion: @escaping (ObjectResult<T>) -> Void) throws -> URLSessionDataTask {
        let task = try dataTask(request: request) {
            switch $0 {
            case .failure(let error):
                completion(.failure(error))
            case .success(let data):
                do {
                    let responseValue = try JSONDecoder.makeDefault().decode(T.self, from: data)
                    completion(.success(responseValue))
                } catch {
                    completion(.failure(error))
                }
            }
        }
        return task
    }
}
