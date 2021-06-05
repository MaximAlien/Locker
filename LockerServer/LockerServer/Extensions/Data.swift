//
//  Data.swift
//  LockerServer
//
//  Created by Maxim Makhun on 05.06.2021.
//  Copyright © 2021 Maxim Makhun. All rights reserved.
//

import Foundation

extension Data {
    
    var ipAddress: String {
        let data = self as NSData
        
        var firstOctet = UInt8(0)
        data.getBytes(&firstOctet, range: NSMakeRange(4, 1))
        
        var secondOctet = UInt8(0)
        data.getBytes(&secondOctet, range: NSMakeRange(5, 1))
        
        var thirdOctet = UInt8(0)
        data.getBytes(&thirdOctet, range: NSMakeRange(6, 1))
        
        var fourthOctet = UInt8(0)
        data.getBytes(&fourthOctet, range: NSMakeRange(7, 1))
        
        return String(format: "%d.%d.%d.%d", firstOctet, secondOctet, thirdOctet, fourthOctet)
    }
}
