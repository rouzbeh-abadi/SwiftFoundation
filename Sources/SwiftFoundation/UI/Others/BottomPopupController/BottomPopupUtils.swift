
import UIKit

typealias BottomPresentableViewController = BottomPopupAttributesDelegate & UIViewController

public protocol BottomPopupDelegate: AnyObject {
    func bottomPopupViewLoaded()
    func bottomPopupWillAppear()
    func bottomPopupDidAppear()
    func bottomPopupWillDismiss()
    func bottomPopupDidDismiss()
    func bottomPopupDismissInteractionPercentChanged(from oldValue: CGFloat, to newValue: CGFloat)
}

public extension BottomPopupDelegate {
    func bottomPopupViewLoaded() { }
    func bottomPopupWillAppear() { }
    func bottomPopupDidAppear() { }
    func bottomPopupWillDismiss() { }
    func bottomPopupDidDismiss() { }
    func bottomPopupDismissInteractionPercentChanged(from oldValue: CGFloat, to newValue: CGFloat) { }
}

public protocol BottomPopupAttributesDelegate: AnyObject {
    var popupHeight: CGFloat { get }
    var popupTopCornerRadius: CGFloat { get }
    var popupPresentDuration: Double { get }
    var popupDismissDuration: Double { get }
    var popupShouldDismissInteractivelty: Bool { get }
    var popupDimmingViewAlpha: CGFloat { get }
    var popupShouldBeganDismiss: Bool { get }
    var popupViewAccessibilityIdentifier: String { get }
}

public enum BottomPopupConstants {
    public static let minPercentOfVisiblePartToCompleteAnimation: CGFloat = 0.5
    public static let swipeDownThreshold: CGFloat = 1000
    public static let defaultHeight: CGFloat = 377.0
    public static let defaultTopCornerRadius: CGFloat = 10.0
    public static let defaultPresentDuration = 0.5
    public static let defaultDismissDuration = 0.5
    public static let dismissInteractively = true
    public static let shouldBeganDismiss = true
    public static let dimmingViewDefaultAlphaValue: CGFloat = 0.5
    public static let defaultPopupViewAccessibilityIdentifier: String = "bottomPopupView"
}
