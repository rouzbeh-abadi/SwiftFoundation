import Foundation
import UIKit


public let haptic = UIImpactFeedbackGenerator()

/// Check email that has a valid format
/// - Parameter email: the email
/// - Returns: true if it's valid
public func isValidEmail(_ email: String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    
    let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
    return emailPred.evaluate(with: email)
}
