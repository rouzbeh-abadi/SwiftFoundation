
#if !os(macOS)
import Foundation
import UIKit

public protocol ReusableView: AnyObject {
    
    static var reusableViewID: String { get }
}

extension ReusableView {
    
    public static var reusableViewID: String {
        let id = "vid:" + NSStringFromClass(self)
        return id
    }
}

extension UIView: ReusableView {}

extension UITableView {
    
    public func register(cells: ReusableView.Type...) {
        for type in cells {
            register(type, forCellReuseIdentifier: type.reusableViewID)
        }
    }
    
    public func register(cells: [ReusableView.Type]) {
        for type in cells {
            register(type, forCellReuseIdentifier: type.reusableViewID)
        }
    }
    
    public func register(headersFooters: [ReusableView.Type]) {
        for type in headersFooters {
            register(type, forHeaderFooterViewReuseIdentifier: type.reusableViewID)
        }
    }
}

extension UICollectionView {
    
    public func register(cells: ReusableView.Type...) {
        for type in cells {
            register(type, forCellWithReuseIdentifier: type.reusableViewID)
        }
    }
    
    public func register(cells: [ReusableView.Type]) {
        for type in cells {
            register(type, forCellWithReuseIdentifier: type.reusableViewID)
        }
    }
}
#endif

