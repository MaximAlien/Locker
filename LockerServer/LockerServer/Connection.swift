//
//  Connection.swift
//  LockerServer
//
//  Created by Maxim Makhun on 25.12.2020.
//  Copyright © 2020 Maxim Makhun. All rights reserved.
//

import Foundation
import Network

class Connection: Identifiable {
    
    let connection: NWConnection
    let id = UUID()
    
    var didStop: ((Error?) -> Void)? = nil
    var didReceive: ((String) -> Void)? = nil
    
    init(_ connection: NWConnection) {
        self.connection = connection
    }
    
    public func start() {
        connection.stateUpdateHandler = didChange(_:)
        
        setupReceive()
        
        connection.start(queue: .main)
    }
    
    func setupReceive() {
        connection.receiveMessage() { [weak self] (data, context, isComplete, error) in
            if let error = error {
                self?.didFail(error)
            }
            
            if let data = data, !data.isEmpty, let message = String(data: data, encoding: .utf8) {
                self?.didReceive?(message)
            }

            if isComplete {
                self?.setupReceive()
            }
        }
    }
    
    public func send(_ message: String) {
        guard let data = message.data(using: .utf8) else { return }
        let metadata = NWProtocolWebSocket.Metadata(opcode: .binary)
        let context = NWConnection.ContentContext(identifier: "\(id)", metadata: [metadata])
        
        connection.send(content: data, contentContext: context, isComplete: true, completion: .contentProcessed( { [weak self] error in
            if let error = error {
                self?.didFail(error)
                return
            }
        }))
    }
    
    public func stop(_ error: Error? = nil) {
        connection.stateUpdateHandler = nil
        connection.cancel()
        
        if let didStop = didStop {
            self.didStop = nil
            didStop(error)
        }
    }
    
    func didChange(_ state: NWConnection.State) {
        var message = "Unknown"
        switch state {
        case .setup:
            message = "Setting-up connection"
        case .waiting(let error):
            message = "Connection is waiting. Error: \(error)"
        case .preparing:
            message = "Connection is preparing"
        case .ready:
            message = "Connection is ready"
        case .failed(_):
            message = "Connection has failed"
        case .cancelled:
            message = "Connection was cancelled"
        @unknown default:
            break
        }
        
        NSLog("State did change: \(message).")
    }
    
    func didFail(_ error: Error) {
        NSLog("Connection \(id) failed with error: \(error.localizedDescription)")
        stop(error)
    }
}
