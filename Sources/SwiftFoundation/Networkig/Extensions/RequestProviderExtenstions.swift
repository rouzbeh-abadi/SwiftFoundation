
import Foundation

extension RequestProvider {
    
    public func execute<T: Decodable>(_ type: T.Type, request: Request,
                                      on: DispatchQueue, completion: @escaping Result<T>.Completion) {
        execute(type, request: request) { result in
            on.async {
                completion(result)
            }
        }
    }
    
    public func execute<T: Decodable>(_ type: T.Type, request: Request, completion: @escaping Result<T>.Completion) {
        do {
            let task = try objectTask(type, request: request) {
                switch $0 {
                case .error(let error):
                    completion(.error(error))
                case .success(let object):
                    completion(.success(object))
                }
            }
            execute(task: task)
        } catch {
            completion(.error(error))
        }
    }
    
    func dataTask(request: Request, completion: @escaping Result<Data>.Completion) throws -> URLSessionDataTask {
        let urlRequest = try request.toURLRequest()
        let task = session.httpDataTask(with: urlRequest) { result in
            switch result {
            case .failure(let error):
                completion(.error(error))
            case .success((let data, let httpResponse)):
                if (200 ... 299).contains(httpResponse.statusCode) {
                    completion(.success(data))
                } else if httpResponse.statusCode == 401 {
//                    do {
//                        let responseValue = try JSONDecoder.makeDefault().decode(ErrorResponse.self, from: data)
//                        completion(.error(err))
//                    } catch {
//                        completion(.error(ResponseError.serverFailure(statusCode: httpResponse.statusCode)))
//                    }
                    completion(.error(ResponseError.serverFailure(statusCode: httpResponse.statusCode)))

                } else if [404, 500, 502].contains(httpResponse.statusCode) {
                    completion(.error(ResponseError.serverFailure(statusCode: httpResponse.statusCode)))
                } else {
//                    do {
//                        let responseValue = try JSONDecoder.makeDefault().decode(ErrorResponse.self, from: data)
//                        completion(.error(AggregatedError(errors: responseValue.errors)))
//                    } catch {
//                        completion(.error(error))
//                    }
                    completion(.error(ResponseError.serverFailure(statusCode: httpResponse.statusCode)))

                }
            }
        }
        return task
    }
    
    func jsonTask<Key: Hashable, Value>(request: Request,
                                        completion: @escaping Result<[Key: Value]>.Completion) throws -> URLSessionDataTask {
        let task = try dataTask(request: request) {
            switch $0 {
            case .error(let error):
                completion(.error(error))
            case .success(let data):
                do {
                    let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
                    if let json = jsonObject as? [Key: Value] {
                        completion(.success(json))
                    } else {
                        completion(.error(ResponseError.unexpectedResponseDataType(type(of: jsonObject), expected: [Key: Value].self)))
                    }
                } catch {
                    completion(.error(error))
                }
            }
        }
        return task
    }
    
    func objectTask<T: Decodable>(_: T.Type, request: Request,
                                  completion: @escaping Result<T>.Completion) throws -> URLSessionDataTask {
        let task = try dataTask(request: request) {
            switch $0 {
            case .error(let error):
                completion(.error(error))
            case .success(let data):
                do {
                    let responseValue = try JSONDecoder.makeDefault().decode(T.self, from: data)
                    completion(.success(responseValue))
                } catch {
                    completion(.error(error))
                }
            }
        }
        return task
    }
}
