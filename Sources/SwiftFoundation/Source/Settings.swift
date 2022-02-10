
import Foundation

public struct Settings {

   open class Key: ExpressibleByStringLiteral {

      public let value: String

      public required init(stringLiteral value: String) {
         self.value = value
      }

      open var appIdentifier: String {
         return Key.appIdentifier
      }

      open var id: String {
         return appIdentifier + "-" + value
      }

      public static let bundleID = Bundle.main.bundleIdentifier ?? "app.settings"

      open class var appIdentifier: String {
         var appID = bundleID
         if RuntimeInfo.isUnderTesting {
            appID = "test." + bundleID
         } else if !BuildInfo.isProduction {
            appID = "development." + bundleID
         }
         return appID
      }

      public static func identifier<T>(for type: T.Type) -> String {
         var typeName = String(describing: type) // As alternative can be used `self.description()` or `NSStringFromClass(self)`
         typeName = typeName.components(separatedBy: ".").last!
         let result = appIdentifier + "." + typeName
         return result
      }
   }
}

extension Settings {

   public static func removeObject(forKey key: Settings.Key) {
      UserDefaults.standard.removeObject(forKey: key.id)
   }

   public static func set(_ newValue: String?, forKey key: Settings.Key) {
      UserDefaults.standard.set(newValue, forKey: key.id)
   }

   public static func string(forKey key: Settings.Key) -> String? {
      return UserDefaults.standard.string(forKey: key.id)
   }

   public static func set(_ newValue: URL?, forKey key: Settings.Key) {
      UserDefaults.standard.set(newValue, forKey: key.id)
   }

   public static func url(forKey key: Settings.Key) -> URL? {
      return UserDefaults.standard.url(forKey: key.id)
   }

   public static func set(_ newValue: Bool, forKey key: Settings.Key) {
      UserDefaults.standard.set(newValue, forKey: key.id)
   }

   public static func bool(forKey key: Settings.Key) -> Bool {
      return UserDefaults.standard.bool(forKey: key.id)
   }

   public static func set(_ newValue: Int?, forKey key: Settings.Key) {
      UserDefaults.standard.set(newValue, forKey: key.id)
   }

   public static func int(forKey key: Settings.Key) -> Int? {
      return UserDefaults.standard.object(forKey: key.id) as? Int
   }

   public static func set(_ newValue: Date?, forKey key: Settings.Key) {
      UserDefaults.standard.set(newValue, forKey: key.id)
   }

   public static func date(forKey key: Settings.Key) -> Date? {
      return UserDefaults.standard.object(forKey: key.id) as? Date
   }

   public static func set(_ newValue: Data?, forKey key: Settings.Key) {
      UserDefaults.standard.set(newValue, forKey: key.id)
   }

   public static func data(forKey key: Settings.Key) -> Data? {
      return UserDefaults.standard.data(forKey: key.id)
   }

   public static func set<T>(_ newValue: [T]?, forKey key: Settings.Key) {
      UserDefaults.standard.set(newValue, forKey: key.id)
   }

   public static func array<T>(forKey key: Settings.Key) -> [T]? {
      return UserDefaults.standard.value(forKey: key.id) as? [T]
   }
}
