//
//  WebSocketClient.swift
//  LockerClient
//
//  Created by Maxim Makhun on 25.12.2020.
//  Copyright © 2020 Maxim Makhun. All rights reserved.
//

import Foundation

class WebSocketClient: NSObject {
    
    var webSocketTask: URLSessionWebSocketTask?
    var pingTimer: Timer?
    
    override init() {
        super.init()
    }
    
    func start(_ ipAddress: String, port: UInt16) {
        let sessionConfiguration = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfiguration,
                                 delegate: self,
                                 delegateQueue: nil)
        let request = URLRequest(url: URL(string: "ws://\(ipAddress):\(port)/")!)
        webSocketTask = session.webSocketTask(with: request)
        webSocketTask?.resume()
        
        listen()
    }
    
    func listen() {
        webSocketTask?.receive { result in
            switch result {
            case .failure(let error):
                NSLog("Error occured while receiving message: \(error.localizedDescription)")
            case .success(let message):
                switch message {
                case .string(let text):
                    NSLog("Did receive text message: \(text).")
                case .data(let data):
                    if let message = String(data: data, encoding: .utf8) {
                        NSLog("Did receive data message: \(message).")
                    }
                @unknown default:
                    fatalError()
                }
                
                self.listen()
            }
        }
    }
    
    func send(_ message: String) {
        let message = URLSessionWebSocketTask.Message.string(message)
        webSocketTask?.send(message) { (error) in
            if let error = error {
                NSLog("Error occured while sending message to the server: \(error.localizedDescription)")
            }
        }
    }
    
    func startPingTimer(_ interval: TimeInterval = 30.0) {
        pingTimer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { [weak self] _ in
            self?.ping()
        }
    }
    
    func ping() {
        webSocketTask?.sendPing { error in
            if let error = error {
                NSLog("Error occured while pinging server: \(error.localizedDescription)")
            }
        }
    }
}

extension WebSocketClient: URLSessionWebSocketDelegate {
    
    func urlSession(_ session: URLSession,
                    webSocketTask: URLSessionWebSocketTask,
                    didOpenWithProtocol protocol: String?) {
        NSLog(#function)
    }
    
    func urlSession(_ session: URLSession,
                    webSocketTask: URLSessionWebSocketTask,
                    didCloseWith closeCode: URLSessionWebSocketTask.CloseCode,
                    reason: Data?) {
        NSLog(#function)
    }
}
