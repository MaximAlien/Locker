//
//  Utilities.swift
//  LockerServer
//
//  Created by Maxim Makhun on 23.12.2020.
//  Copyright © 2020 Maxim Makhun. All rights reserved.
//

import Foundation

final class Utilities {
    
    @objc public class func lockScreen() {        
        let handle = dlopen("/System/Library/PrivateFrameworks/login.framework/Versions/Current/login", RTLD_LAZY)
        let symbol = dlsym(handle, "SACLockScreenImmediate")
        typealias functionAlias = @convention(c) () -> Void
        let lockScreen = unsafeBitCast(symbol, to: functionAlias.self)
        lockScreen()
    }
}
