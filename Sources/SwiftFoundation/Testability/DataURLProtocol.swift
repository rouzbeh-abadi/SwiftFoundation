
import Foundation

public final class DataURLProtocol: URLProtocol {
    
    enum Error: Swift.Error, LocalizedError, CustomDebugStringConvertible {
        case missingMockedData(url: String)
        case explicitMockFailure(url: String)
        
        var errorDescription: String? {
            return debugDescription
        }
        
        var debugDescription: String {
            switch self {
            case .missingMockedData(let url):
                return "Missing mock for URL: \(url)"
            case .explicitMockFailure(url: let url):
                return "Induced error for URL: \(url)"
            }
        }
    }
    
    private var responseWorkItem: DispatchWorkItem?
    
    override public func startLoading() {
        guard
            let mock = DataMocker.mock(for: request),
            let response = HTTPURLResponse(url: mock.request.url!, statusCode: mock.statusCode, httpVersion: DataMocker.httpVersion.rawValue, headerFields: mock.headers),
            let data = mock.data(for: request)
        else {
            print("\n\n 🚨 No mocked data found for url \(String(describing: request.url?.absoluteString)) method \(String(describing: request.httpMethod)). Did you forget to use `register()`? 🚨 \n\n")
            client?.urlProtocol(self, didFailWithError: Error.missingMockedData(url: String(describing: request.url?.absoluteString)))
            return
        }
        
        if let onRequest = mock.onRequest {
            onRequest(request, request.postBodyArguments)
        }
        mock.onRequestExpectation?.fulfill()
        
        guard let delay = mock.delay else {
            finishRequest(for: mock, data: data, response: response)
            return
        }
        
        responseWorkItem = DispatchWorkItem(block: { [weak self] in
            guard let self = self else { return }
            self.finishRequest(for: mock, data: data, response: response)
        })
        
        DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).asyncAfter(deadline: .now() + delay, execute: responseWorkItem!)
    }
    
    private func finishRequest(for mock: MockNetworkingData, data: Data, response: HTTPURLResponse) {
        if let redirectLocation = data.redirectLocation {
            client?.urlProtocol(self, wasRedirectedTo: URLRequest(url: redirectLocation), redirectResponse: response)
        } else if let requestError = mock.requestError {
            client?.urlProtocol(self, didFailWithError: requestError)
        } else {
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: mock.cacheStoragePolicy)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        }
        
        mock.completion?()
        mock.onCompletedExpectation?.fulfill()
    }
    
    /// Implementation does nothing, but is needed for a valid inheritance of URLProtocol.
    override public func stopLoading() {
        responseWorkItem?.cancel()
    }
    
    /// Simply sends back the passed request. Implementation is needed for a valid inheritance of URLProtocol.
    override public class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    /// Overrides needed to define a valid inheritance of URLProtocol.
    override public class func canInit(with request: URLRequest) -> Bool {
        return DataMocker.shouldHandle(request)
    }
}
