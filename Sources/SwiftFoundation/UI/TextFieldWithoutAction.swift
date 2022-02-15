
#if !os(macOS)
import Foundation

open class TextFieldWithoutAction: UITextField {
    override public func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(UIResponderStandardEditActions.paste(_:)) {
            return false
        } else if action == #selector(UIResponderStandardEditActions.cut(_:)) {
            return false
        } else if action == #selector(UIResponderStandardEditActions.copy(_:)) {
            return false
        } else if action == #selector(UIResponderStandardEditActions.select(_:)) {
            return false
        } else if action == #selector(UIResponderStandardEditActions.selectAll(_:)) {
            return false
        }
        return super.canPerformAction(action, withSender: sender)
    }
}
#endif

