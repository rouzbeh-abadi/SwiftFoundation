//
//  UICollectionView.swift
//  
//
//  Created by Rouzbeh on 15.02.22.
//

#if !os(macOS)
import UIKit

extension UICollectionView {
    
    public func dequeueReusableCell<T: UICollectionViewCell>(type: T.Type, indexPath: IndexPath) -> T {
        let id = String(describing: type)
        if let cell = dequeueReusableCell(withReuseIdentifier: id, for: indexPath) as? T {
            return cell
        } else {
            fatalError("Cell with id \"\(id)\" not found.")
        }
    }
}

extension UICollectionView {
    
    private struct Key {
        static var registeredTypes = "app.ui.registeredTypes"
    }
    
    private var registeredTypes: [String] {
        get {
            return ObjCAssociation.value(from: self, forKey: &Key.registeredTypes) ?? []
        } set {
            ObjCAssociation.setCopyNonAtomic(value: newValue, to: self, forKey: &Key.registeredTypes)
        }
    }
    
    public func dequeueReusableCell<T: UICollectionViewCell>(reusableType: T.Type, indexPath: IndexPath) -> T {
        let id = reusableType.reusableViewID
        var types = registeredTypes
        if !types.contains(id) {
            types.append(id)
            if let nib = Bundle(for: reusableType).nib(reusableType: reusableType) {
                register(nib, forCellWithReuseIdentifier: id)
            } else {
                register(reusableType, forCellWithReuseIdentifier: id)
            }
        }
        if let cell = dequeueReusableCell(withReuseIdentifier: id, for: indexPath) as? T {
            return cell
        } else {
            fatalError("Cell with id \"\(id)\" of type \(T.self) seems not registered.")
        }
    }
}
#endif

