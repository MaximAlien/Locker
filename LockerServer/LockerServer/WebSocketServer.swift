//
//  WebSocketServer.swift
//  LockerServer
//
//  Created by Maxim Makhun on 25.12.2020.
//  Copyright © 2020 Maxim Makhun. All rights reserved.
//

import Foundation
import Network

protocol WebSocketServerDelegate: AnyObject {
    
    func didSetup(_ webSocketServer: WebSocketServer)
    
    func didStop(_ webSocketServer: WebSocketServer, identifier: UUID)
}

protocol WebSocketServerCompatible {
    
    var delegate: WebSocketServerDelegate? { get set }
    
    func start()
    
    func stop()
    
    func send(_ message: String)
}

class WebSocketServer: WebSocketServerCompatible {
    
    weak var delegate: WebSocketServerDelegate? = nil
    
    let port: NWEndpoint.Port
    var listener: NWListener!
    var connections: [UUID: Connection] = [:]

    init(_ port: NWEndpoint.Port) {
        self.port = port

        setup()
    }

    deinit {
        stop()
    }

    public func start() {
        listener.stateUpdateHandler = didChange(_:)
        listener.newConnectionHandler = didAccept(_:)
        listener.start(queue: .main)
    }

    public func stop() {
        listener.stateUpdateHandler = nil
        listener.newConnectionHandler = nil
        listener.cancel()

        connections.values.forEach {
            $0.didStop = nil
            $0.stop()
        }

        connections.removeAll()
    }

    public func send(_ message: String) {
        connections.values.forEach {
            $0.send(message)
        }
    }

    private func setup() {
        let parameters = NWParameters(tls: nil)
        parameters.allowLocalEndpointReuse = true
        parameters.includePeerToPeer = true

        let options = NWProtocolWebSocket.Options()
        options.autoReplyPing = true
        parameters.defaultProtocolStack.applicationProtocols.append(options)

        do {
            listener = try NWListener(using: parameters, on: self.port)
        } catch (let error) {
            NSLog("Failed to create listener with error: \(error.localizedDescription).")
        }
    }

    func didAccept(_ connection: NWConnection) {
        let connection = Connection(connection)
        connections[connection.id] = connection

        connection.start()

        connection.didStop = {
            if let errorDescription = $0?.localizedDescription {
                NSLog("Connection did stop with error: \(errorDescription).")
            }

            self.didStop(connection)
        }

        connection.didReceive = {
            NSLog("Did receive message: \($0).")

            connection.send("Message was received from server.")

            ResponseHandler.handle($0)
        }

        NSLog("Connections: \(connections)")
    }

    func didChange(_ state: NWListener.State) {
        switch state {
        case .setup:
            NSLog("Setting-up server.")
        case .waiting(let error):
            NSLog("Server is waiting. Error: \(error)")
        case .ready:
            NSLog("Server is ready.")
        case .failed(let error):
            NSLog("Error occured: \(error.localizedDescription)")
        case .cancelled:
            NSLog("Server was canceled.")
        @unknown default:
            break
        }
    }

    func didStop(_ connection: Connection) {
        NSLog("Connections before removal: \(connections.count)")
        connections.removeValue(forKey: connection.id)
        NSLog("Connections after removal: \(connections.count)")
    }
}
