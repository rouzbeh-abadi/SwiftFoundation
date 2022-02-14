//
//  Bundle.swift
//  
//
//  Created by Rouzbeh on 15.02.22.
//

import Foundation
#if os(macOS)
import AppKit
#elseif os(iOS) || os(tvOS) || os(watchOS)
import UIKit
#endif

extension Bundle {
    
    enum Error: Swift.Error {
        case resourceFileIsNotFound(name: String, in: Bundle)
    }
    
    public func url(forResourceNamed fileName: String) throws -> URL {
        let ext = fileName.pathExtension
        let baseName = fileName.deletingPathExtension
        guard let value = url(forResource: baseName, withExtension: ext) else {
            throw Error.resourceFileIsNotFound(name: fileName, in: self)
        }
        return value
    }
    
#if !os(macOS)
    public func nib<T: UIView>(reusableType: T.Type) -> UINib? {
        let nibName = String(describing: reusableType)
        // Note that `nib` is used instead of `xib`.
        let isExists = url(forResource: nibName, withExtension: "nib") != nil
        return isExists ? UINib(nibName: nibName, bundle: self) : nil
    }
#endif
}
