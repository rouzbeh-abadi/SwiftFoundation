
import Foundation

extension Snapshotting where Value: UIViewController, Format == UIImage {
    public static var windowedImage: Snapshotting {
        return Snapshotting<UIImage, UIImage>.image.asyncPullback { vc in
            Async<UIImage> { callback in
                UIView.setAnimationsEnabled(false)
                let window = UIApplication.shared.windows[0]
                window.rootViewController = vc
                DispatchQueue.main.async {
                    let image = UIGraphicsImageRenderer(bounds: window.bounds).image { ctx in
                        window.drawHierarchy(in: window.bounds, afterScreenUpdates: true)
                    }
                    callback(image)
                    UIView.setAnimationsEnabled(true)
                }
            }
        }
    }
}
