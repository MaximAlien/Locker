//
//  AppDelegate.swift
//  LockerServer
//
//  Created by Maxim Makhun on 09.05.2019.
//  Copyright © 2019 Maxim Makhun. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    let netServiceProvider = NetServiceProvider(123)
    var webSocketServer = WebSocketServer(1234)
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        constructMenu()
        
        webSocketServer.delegate = self
        webSocketServer.start()
    }
    
    func applicationWillTerminate(_ notification: Notification) {
        
    }
    
    func constructMenu() {
        if let button = self.statusItem.button {
            button.image = NSImage(named: "menu_icon")
        }
        
        let menu = NSMenu()
        
        menu.addItem(NSMenuItem(title: "Lock", action: #selector(AppDelegate.lockScreen), keyEquivalent: "P"))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        
        self.statusItem.menu = menu
    }
    
    @objc func lockScreen() {
        Utilities.lockScreen()
    }
}

extension AppDelegate: WebSocketServerDelegate {
    
    func didSetup(_ webSocketServer: WebSocketServer) {
        NSLog("Did setup WebSocketServer.")
    }
    
    func didStop(_ webSocketServer: WebSocketServer, identifier: UUID) {
        NSLog("Connection \(identifier) was closed.")
    }
}
