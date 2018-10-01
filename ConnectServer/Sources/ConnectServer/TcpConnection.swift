//
//  TcpConnection.swift
//  ConnectServer
//
//  Created by Nguyễn Tiến Dũng on 9/30/18.
//

import Socket

import Foundation
open class TcpConnection{
    static let bufferSize = 4096
    static let maxConnectionSize = 2
    var socket : Socket!
    let queue = DispatchQueue.global(qos: .userInteractive)
    var connectedSockets = [Int32: Socket]()
    let socketLockQueue = DispatchQueue(label: "com.ibm.serverSwift.socketLockQueue")
    var continueRunning = true
    
    
    /// CALL BACK
    
    var onAcceptedClient : ((_ newClient : Socket)->Void)?
    var onDisconectClient : ((_ client : Socket)->Void)?
    
    init(_ port : Int,onAcceptedClient:((_ newClient : Socket)->Void)? = nil) {
        queue.async {
            if(onAcceptedClient != nil)
            {
                self.onAcceptedClient = onAcceptedClient
            }
            do{
                self.socket = try Socket.create()
                try self.socket.listen(on: port)
                debugPrint("Listening on port: \(self.socket.listeningPort)")
                repeat {
                    let newSocket = try self.socket.acceptClientConnection()
                    debugPrint("Accepted connection from: \(newSocket.remoteHostname) on port \(newSocket.remotePort)")
                    debugPrint("Socket Signature: \(String(describing: newSocket.signature?.description))")
                    self.addNewConnection(socket: newSocket)
                } while (self.continueRunning);
            }catch{
                debugPrint(error.localizedDescription)
            }
        }
    }
    deinit {
        // Close all open sockets...
        for socket in connectedSockets.values {
            socket.close()
        }
        self.socket.close()
    }
    
    func disConnectClient(clientID : Int32){
        socketLockQueue.async { [unowned self] in
            if let socket = self.connectedSockets.removeValue(forKey: clientID){
                self.onDisconectClient?(socket)
                socket.close()
            }
        }
    }
    
    
    func addNewConnection(socket: Socket) {
        
        socketLockQueue.sync { [unowned self, socket] in
            if(self.connectedSockets.count < TcpConnection.maxConnectionSize){
                self.connectedSockets[socket.socketfd] = socket
                self.onAcceptedClient?(socket)
            }else{
                _ = try? socket.write(from: "MAX CONNECTION")
                socket.close()
                return
            }
        }
        let queue = DispatchQueue.global(qos: .default)
        
        queue.async { [unowned self, socket] in
            do {
                var shouldKeepRunning = true
                var readData = Data(capacity: TcpConnection.bufferSize)
                repeat {
                    let bytesRead = try socket.read(into: &readData)
                    if bytesRead > 0 {
                        
                        
                    }
                    if bytesRead == 0 {
                        
                        shouldKeepRunning = false
                        break
                    }
                    
                    readData.count = 0
                }while (shouldKeepRunning)
                
                debugPrint("Socket: \(socket.remoteHostname):\(socket.remotePort) closed...")
                
                
                self.socketLockQueue.sync { [unowned self, socket] in
                    self.connectedSockets[socket.socketfd] = nil
                    self.onDisconectClient?(socket)
                }
                socket.close()
                
            }catch{
                
            }            
        }
    }
    
}
