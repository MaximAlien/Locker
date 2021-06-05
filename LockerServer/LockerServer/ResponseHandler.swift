//
//  ResponseHandler.swift
//  LockerServer
//
//  Created by Maxim Makhun on 25.12.2020.
//  Copyright © 2020 Maxim Makhun. All rights reserved.
//

import Foundation

final class ResponseHandler {

    class func handle(_ message: String) -> Void {
        if message == "lock_screen" {
            Utilities.lockScreen()
        }
    }
}
