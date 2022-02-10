
import Foundation

public extension URLRequest {
    var postBodyArguments: [String: Any]? {
        guard let httpBody = httpBodyStreamData() else { return nil }
        return try? JSONSerialization.jsonObject(with: httpBody, options: .fragmentsAllowed) as? [String: Any]
    }
    
    /// We need to use the http body stream data as the URLRequest once launched converts the `httpBody` to this stream of data.
    private func httpBodyStreamData() -> Data? {
        guard let bodyStream = httpBodyStream else { return nil }
        
        bodyStream.open()
        
        // Will read 16 chars per iteration. Can use bigger buffer if needed
        let bufferSize: Int = 16
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: bufferSize)
        var data = Data()
        
        while bodyStream.hasBytesAvailable {
            let readData = bodyStream.read(buffer, maxLength: bufferSize)
            data.append(buffer, count: readData)
        }
        
        buffer.deallocate()
        bodyStream.close()
        
        return data
    }
}
