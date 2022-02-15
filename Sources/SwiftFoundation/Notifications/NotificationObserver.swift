
import Foundation

public class NotificationObserver: NSObject {

   public typealias Handler = ((Foundation.Notification) -> Void)

   private var notificationObserver: NSObjectProtocol?
   private let notificationObject: Any?

   public var handler: Handler?
   public var isActive: Bool = true
   private var mNotificationName: NSNotification.Name

   public var notificationName: NSNotification.Name {
      return mNotificationName
   }

   public init(name: NSNotification.Name, object: Any? = nil, queue: OperationQueue = .main, handler: Handler? = nil) {
      mNotificationName = name
      notificationObject = object
      self.handler = handler
      super.init()
      notificationObserver = NotificationCenter.default.addObserver(forName: name, object: object, queue: queue) { [weak self] in
         guard let this = self else { return }
         if this.isActive {
            self?.handler?($0)
         }
      }
   }

   deinit {
      if let notificationObserver = notificationObserver {
         NotificationCenter.default.removeObserver(notificationObserver, name: notificationName, object: notificationObject)
      }
   }
}
