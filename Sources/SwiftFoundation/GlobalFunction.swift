
import Foundation
import UIKit


/// Present alert controller with ok button
/// - Parameters:
///   - title: the title of the alert
///   - message: the message of the alert
///   - vc: the target VC that present alert
public func presentOKButtonAlert(title: String, message: String, vc: UIViewController) {
    
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
    }))
    vc.present(alert, animated: true)
}


/// convert timestamp to  h:mm a format
/// - Parameter timestamp: the timestamp
/// - Returns: A string of h:mm a
public func convertTimestampToHH(timestamp: Int64) -> String {
    let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
    let dateFormatter = DateFormatter()
    dateFormatter.locale = NSLocale.current
    dateFormatter.dateFormat = "h:mm a"
    return dateFormatter.string(from: date)
}
