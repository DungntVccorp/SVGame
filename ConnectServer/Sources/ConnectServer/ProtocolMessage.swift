//
//  ProtocolMessage.swift
//  ConnectServer
//
//  Created by Nguyễn Tiến Dũng on 10/1/18.
//

import Foundation
import Gzip
/*
 |Start Header|                       Header                     |      ID     |payload size|   PAYLOAD   |
 |   2 byte   |                      1 Byte                      | 1 -> 2 byte | 1 -> 4 byte|             |
 | 0xAA 0xAA  |Ma Hoa | Kieu Ma Hoa  |size ID | playload |is Zip |             |            |   ZIP OR    |
 |            | 1 bit |   2 bit      | 2 bit  | 2 bit    | 1 bit |             |            |     RAW     |
 
    OxAA 0xAA    1         01            01       00         1      00000001      00000001     11111111
 
 
 
 DEFAULT
 isEncrypt      = false
 isZip          = false
 encryptType    = 0 // type = 0,1,2,3
 length_id      = 1 // MAX = 2 bytes
 length_payload = 1 // MAX = 4 bytes
 protocol_id    = 0 -> 65535
 payload size   = 0 -> 4294967295
 PAYLOAD        = ZIP OR RAW DATA
 */

enum EncryptType {
    case default_none /// payload data để nguyên
    case type_1 // payload data đảo chẵn lẻ
    case type_2 // payload đảo ngược
    case type_3 // payload đảo chẵn lẻ -> đảo ngược
}

class ProtocolMessage: NSObject {
    
    var isEncrypt : Bool = false
    var isZip : Bool = false
    var encryptType : EncryptType = .default_none
    var protocol_size : Int = 0 // default 1 bytes id
    var protocol_id : UInt16 = 0
    var payload : Data!
    var playload_lenght : Int = 0 /// DEFAULT 1 BYTES
    var payload_size : Int = 0
    public override init() { /// DEFAULT
        
    }
    public convenience init(isEncrypt : Bool = false,encryptType : EncryptType = .default_none,isZip : Bool = false,protocol_id : UInt16 = 0,payload : Data) throws {
        self.init()
        self.isEncrypt = isEncrypt
        self.encryptType = encryptType
        self.isZip = isZip
        self.protocol_id = protocol_id
        if(self.protocol_id > 0xFF){
            /// 2
            protocol_size = 1
        }else{
            ///1
            protocol_size = 0
        }
        if(isZip){
            do{
                self.payload = try payload.gzipped(level: CompressionLevel.bestSpeed)
                
            }catch{
                throw error
            }
        }else{
            self.payload = payload
        }
        
        if(self.isEncrypt){
            if(self.encryptType == .type_1){
                
            }else if(self.encryptType == .type_2){
                
            }else if(self.encryptType == .type_3){
                
            }
        }
        let p_size = self.payload.count + (protocol_size + 1)
        if( p_size  > 16_777_211){
            //4
            self.payload_size = p_size + 4
            playload_lenght = 3
        }else if(self.payload.count > 65_532){
            //3
            self.payload_size = p_size + 3
            playload_lenght = 2
        }else if(self.payload.count >= 253){
            // 2
            self.payload_size = p_size + 2
            playload_lenght = 1
        }else{
            //1
            self.payload_size = p_size + 1
        }
        self.payload_size += 3 //HEADER SIZE DEFAULT = 3
    }
    public init?(withStreamData streamData : Data) { /// STREAM DATA
        
    }
    
    public func getStreamData() -> Data{
        return Data()
    }
}
