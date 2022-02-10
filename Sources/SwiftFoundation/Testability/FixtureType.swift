
import Foundation

import Foundation

public protocol FixtureType {
    
    var bundle: Bundle { get }
    
    func bundleName(for: FixtureKind) -> String
    func bundlePath(for: FixtureKind) -> String
    func localPath(for: FixtureKind) -> String
    
    func data(of: FixtureKind, pathComponent: String) throws -> Data
}
