import Foundation

extension NotificationCenter {
    
    public func post(name: NSNotification.Name) {
        post(name: name, object: nil)
    }
    
    public func post(name: NSNotification.Name, userInfo: [AnyHashable: Any]) {
        post(name: name, object: nil, userInfo: userInfo)
    }
}
