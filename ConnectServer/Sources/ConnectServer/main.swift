import Socket
import Dispatch
print("START CONNECT SERVER")

let tcp = TcpConnection(1111)
tcp.onAcceptedClient = {(newClient) -> Void in
    debugPrint(newClient.remotePort)
    tcp.disConnectClient(clientID: newClient.socketfd)
}
tcp.onDisconectClient = {(client) -> Void in
    debugPrint("\(client.remotePort)")
    _ = try? client.write(from: "BYE\n")
}


dispatchMain()
