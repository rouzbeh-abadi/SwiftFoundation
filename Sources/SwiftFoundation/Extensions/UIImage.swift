
import Foundation
import UIKit

extension UIImageView {
   public func loadFrom(URLAddress: String) {
        guard let url = URL(string: URLAddress) else {
            return
        }
        
        DispatchQueue.main.async { [weak self] in
            if let imageData = try? Data(contentsOf: url) {
                if let loadedImage = UIImage(data: imageData) {
                    self?.contentMode = .scaleAspectFit
                    self?.image = loadedImage
                }
            }
        }
    }
}
