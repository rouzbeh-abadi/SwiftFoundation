
import Foundation

public class RequestProvider {
    
    private let queue = OperationQueue()
    public let session: URLSession
    
    public init(session: URLSession = URLSession.shared, shouldSaveTracesToFile: Bool = true) {
        self.session = session
        queue.name = Settings.Key.identifier(for: type(of: self))
    }
    
    deinit {
        cancelAllTasks()
    }
}

// MARK: -

extension RequestProvider {
    
    public func cancelAllTasks() {
        queue.cancelAllOperations()
    }
    
    public func execute(task: URLSessionDataTask) {
        queue.addOperation(TaskOperation(task: task))
    }
    
    public func execute(operations: [Operation]) {
        queue.addOperations(operations, waitUntilFinished: false)
    }
    
    // MARK: -
    
    public func defaultExecute<T: Decodable>(_ type: T.Type, request: Request,
                                             on: DispatchQueue, completion: @escaping Result<T>.Completion) {
        defaultExecute(type, request: request) { result in
            on.async {
                completion(result)
            }
        }
    }
    
    public func defaultExecute<T: Decodable>(_ type: T.Type, request: Request, completion: @escaping Result<T>.Completion) {
        do {
            let task = try defaultObjectTask(type, request: request) {
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
    
    public func defaultDataTask(request: Request, session: URLSession? = nil,
                                completion: @escaping Result<Data>.Completion) throws -> URLSessionDataTask {
        
        let task = try (session ?? self.session).dataTask(request: request) { result in
            switch result {
            case .failure(let error):
                completion(.error(error))
            case .success(let data):
                completion(.success(data))
            }
        }
        return task
    }
    
    public func defaultJsonTask<Key: Hashable, Value>(request: Request, session: URLSession? = nil,
                                                      completion: @escaping Result<[Key: Value]>.Completion) throws -> URLSessionDataTask {
        let task = try (session ?? self.session).jsonTask(request: request) { (result: Swift.Result<[Key: Value], Swift.Error>) in
            switch result {
            case .failure(let error):
                completion(.error(error))
            case .success(let data):
                completion(.success(data))
            }
        }
        return task
    }
    
    public func defaultObjectTask<T: Decodable>(_ type: T.Type, request: Request, session: URLSession? = nil,
                                                completion: @escaping Result<T>.Completion) throws -> URLSessionDataTask {
        let task = try (session ?? self.session).objectTask(type, request: request) { result in
            switch result {
            case .failure(let error):
                completion(.error(error))
            case .success(let data):
                completion(.success(data))
            }
        }
        return task
    }
}
