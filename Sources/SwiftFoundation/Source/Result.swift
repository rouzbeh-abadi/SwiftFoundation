
import Foundation

public enum Result<T> {
    
    public typealias Completion = (Result<T>) -> Void
    
    case success(T)
    case error(Swift.Error)
    
    public var error: Swift.Error? {
        switch self {
        case .error(let error): return error
        case .success: return nil
        }
    }
    
    public var value: T? {
        switch self {
        case .error: return nil
        case .success(let result): return result
        }
    }
    
    public var hasError: Bool {
        switch self {
        case .error: return true
        case .success: return false
        }
    }
    
    public func dematerialize() throws -> T {
        switch self {
        case .success(let result):
            return result
        case .error(let error):
            throw error
        }
    }
    
    public func map<U>(_ transform: (T) throws -> U) -> Result<U> {
        return flatMap { .success(try transform($0)) }
    }
    
    public func flatMap<U>(_ transform: (T) throws -> Result<U>) -> Result<U> {
        switch self {
        case .success(let value):
            do {
                return try transform(value)
            } catch {
                return .error(error)
            }
        case .error(let error):
            return .error(error)
        }
    }
}
