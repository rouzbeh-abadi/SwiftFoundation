//
//  KeyedDecodingContainer.swift
//  GitTime
//
//  Created by Rouzbeh on 08.02.22.
//  Copyright © 2022 EEx. All rights reserved.
//

extension KeyedDecodingContainer {
    
    public func decode<T>(key: K) throws -> T where T: Decodable {
        return try decode(T.self, forKey: key)
    }
    
    public func decodeIfPresent<T>(key: K) throws -> T? where T: Decodable {
        return try decodeIfPresent(T.self, forKey: key)
    }
    
    public func decodeIfPresent<T>(key: K, substitution: T) throws -> T where T: Decodable {
        return try decodeIfPresent(T.self, forKey: key) ?? substitution
    }
}
