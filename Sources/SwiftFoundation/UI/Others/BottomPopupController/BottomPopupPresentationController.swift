
import UIKit

final public class BottomPopupPresentationController: UIPresentationController {
    private var dimmingView: UIView!
    private var popupHeight: CGFloat
    private unowned var attributesDelegate: BottomPopupAttributesDelegate
    
    public override var frameOfPresentedViewInContainerView: CGRect {
        CGRect(origin: CGPoint(x: 0, y: UIScreen.main.bounds.size.height - popupHeight), size: CGSize(width: presentedViewController.view.frame.size.width, height: popupHeight))
    }
    
    private func changeDimmingViewAlphaAlongWithAnimation(to alpha: CGFloat) {
        guard let coordinator = presentedViewController.transitionCoordinator else {
            dimmingView.backgroundColor = UIColor.black.withAlphaComponent(alpha)
            return
        }
        
        coordinator.animate(alongsideTransition: { _ in
            self.dimmingView.backgroundColor = UIColor.black.withAlphaComponent(alpha)
        })
    }
    
    init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?, attributesDelegate: BottomPopupAttributesDelegate) {
        self.attributesDelegate = attributesDelegate
        popupHeight = attributesDelegate.popupHeight
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        setupDimmingView()
    }
    
    public override func containerViewWillLayoutSubviews() {
        presentedView?.frame = frameOfPresentedViewInContainerView
    }
    
    public override func presentationTransitionWillBegin() {
        containerView?.insertSubview(dimmingView, at: 0)
        changeDimmingViewAlphaAlongWithAnimation(to: attributesDelegate.popupDimmingViewAlpha)
    }
    
    public override func dismissalTransitionWillBegin() {
        changeDimmingViewAlphaAlongWithAnimation(to: 0)
    }

    func setHeight(to height: CGFloat) {
        popupHeight = height
        UIView.animate(withDuration: attributesDelegate.popupPresentDuration) {
            self.containerViewWillLayoutSubviews()
        }
    }
    
    @objc private func handleTap(_ tap: UITapGestureRecognizer) {
        guard attributesDelegate.popupShouldBeganDismiss else { return }
        presentedViewController.dismiss(animated: true, completion: nil)
    }
    
    @objc private func handleSwipe(_ swipe: UISwipeGestureRecognizer) {
        guard attributesDelegate.popupShouldBeganDismiss else { return }
        presentedViewController.dismiss(animated: true, completion: nil)
    }
}

private extension BottomPopupPresentationController {
    func setupDimmingView() {
        dimmingView = UIView()
        dimmingView.frame = CGRect(origin: .zero, size: UIScreen.main.bounds.size)
        dimmingView.backgroundColor = UIColor.black.withAlphaComponent(0)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeGesture.direction = [.down, .up]
        dimmingView.isUserInteractionEnabled = true
        [tapGesture, swipeGesture].forEach { dimmingView.addGestureRecognizer($0) }
    }
}
