//
//  Disposable.swift
//  
//
//  Created by Rouzbeh on 15.02.22.
//

import Foundation

public protocol Disposable {
    var isDisposed: Bool { get }
    func dispose()
}
