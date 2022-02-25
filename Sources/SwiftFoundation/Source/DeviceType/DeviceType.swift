
#if !os(macOS)
import UIKit

public struct DeviceType {
    
    public static let isPhone = UIDevice.current.userInterfaceIdiom == .phone
    public static let isPad = UIDevice.current.userInterfaceIdiom == .pad
    
    //iPhones
    public static var isPhoneSE1: Bool {
        return DeviceType.isPhone && ScreenSize.maxLength <= 568.0
    }
    
    public static var isPhone8: Bool {
        return DeviceType.isPhone && ScreenSize.maxLength == 667.0
    }
    
    public static var isPhone8P: Bool {
        return DeviceType.isPhone && ScreenSize.maxLength == 736.0
    }
    
    public static var isPhoneXOrXsOr11: Bool {
        return DeviceType.isPhone && ScreenSize.maxLength == 812.0
    }
    
    public static var isPhoneXrORMax: Bool {
        return DeviceType.isPhone && ScreenSize.maxLength == 896.0
    }
    
    public static var isPhone13ProMax: Bool {
        return DeviceType.isPhone && ScreenSize.maxLength == 926.0
    }
    
    //iPads
    
    public static var isPadMini_6th: Bool {
        return DeviceType.isPad && ScreenSize.maxLength == 1133.0
    }
    
    public static var isPadPro12_9: Bool {
        return DeviceType.isPad && ScreenSize.maxLength == 1366.0
    }
    
    public static var isPad9_7: Bool {
        return DeviceType.isPad && ScreenSize.maxLength == 1024.0
    }
    
    public static var isPad10_5: Bool {
        return DeviceType.isPad && ScreenSize.maxLength == 1112.0
    }
    
    public static var isPad_11: Bool {
        return DeviceType.isPad && ScreenSize.maxLength == 1194.0
    }
}
#endif
