//
//  NetServiceProvider.swift
//  LockerServer
//
//  Created by Maxim Makhun on 25.12.2020.
//  Copyright © 2020 Maxim Makhun. All rights reserved.
//

import Foundation

class NetServiceProvider: NSObject {
    
    var netService: NetService!
    
    override init() {
        super.init()
    }
    
    convenience init(_ port: UInt16) {
        self.init()
        
        netService = NetService(domain: "local.",
                                type: "_myservice._tcp.",
                                name: "Macbook",
                                port: Int32(port))
        netService.delegate = self
        netService.publish()
    }
}

// MARK: - NetServiceDelegate methods

extension NetServiceProvider: NetServiceDelegate {
    
    public func netServiceWillPublish(_ sender: NetService) {
        NSLog(#function)
    }
    
    public func netServiceDidPublish(_ sender: NetService) {
        NSLog(#function)
    }
    
    public func netService(_ sender: NetService, didNotPublish errorDict: [String : NSNumber]) {
        NSLog(#function)
    }
    
    public func netServiceWillResolve(_ sender: NetService) {
        NSLog(#function)
    }
    
    public func netServiceDidResolveAddress(_ sender: NetService) {
        NSLog(#function)
        NSLog("Service details. Name: \(sender.name), HostName: \(sender.hostName ?? "Unavailable"), Domain: \(sender.domain), Type: \(sender.type), Address: \(sender.addresses?.first?.ipAddress ?? "None").")
    }
    
    public func netService(_ sender: NetService, didNotResolve errorDict: [String : NSNumber]) {
        NSLog(#function)
    }
    
    public func netServiceDidStop(_ sender: NetService) {
        NSLog(#function)
    }
    
    public func netService(_ sender: NetService, didUpdateTXTRecord data: Data) {
        NSLog(#function)
    }
    
    @available(iOS 7.0, *)
    public func netService(_ sender: NetService, didAcceptConnectionWith inputStream: InputStream, outputStream: OutputStream) {
        NSLog(#function)
    }
}
