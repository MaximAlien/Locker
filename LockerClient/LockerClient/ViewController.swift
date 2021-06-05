//
//  ViewController.swift
//  LockerClient
//
//  Created by Maxim Makhun on 12.27.2018.
//  Copyright © 2018 Maxim Makhun. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var netServiceBrowser = NetServiceBrowser()
    let webSocketClient = WebSocketClient()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        netServiceBrowser.delegate = self
        netServiceBrowser.searchForServices(ofType: "_myservice._tcp.", inDomain: "local.")
        
        webSocketClient.start("127.0.0.1", port: 1234)
    }
    
    @IBAction func lockScreen(_ sender: Any) {
        webSocketClient.send("lock_screen")
    }
}

// MARK: - NetServiceBrowserDelegate methods

extension ViewController: NetServiceBrowserDelegate {
    
    public func netServiceBrowserWillSearch(_ browser: NetServiceBrowser) {
        NSLog(#function)
    }
    
    public func netServiceBrowserDidStopSearch(_ browser: NetServiceBrowser) {
        NSLog(#function)
    }
    
    public func netServiceBrowser(_ browser: NetServiceBrowser, didNotSearch errorDict: [String : NSNumber]) {
        NSLog(#function)
    }
    
    public func netServiceBrowser(_ browser: NetServiceBrowser, didFindDomain domainString: String, moreComing: Bool) {
        NSLog(#function)
    }
    
    public func netServiceBrowser(_ browser: NetServiceBrowser, didFind service: NetService, moreComing: Bool) {
        NSLog(#function)
        NSLog("Service details. Name: \(service.name), HostName: \(service.hostName ?? "Unavailable"), Domain: \(service.domain), Type: \(service.type), Address: \(service.addresses?.first?.ipAddress ?? "None").")
    }
    
    public func netServiceBrowser(_ browser: NetServiceBrowser, didRemoveDomain domainString: String, moreComing: Bool) {
        NSLog(#function)
    }
    
    public func netServiceBrowser(_ browser: NetServiceBrowser, didRemove service: NetService, moreComing: Bool) {
        NSLog(#function)
    }
}
