//
//  packet.swift
//  vpn-tunnel
//
//  Created by peter xie on 2021-10-16.
//

import Foundation
import NetworkExtension
import os.log

struct IPHeader {
    let version: UInt8
    let headerLength: UInt8
    let typeOfService: UInt8
    let length: UInt16
    let id: UInt16
    let offset: UInt16
    let timeToLive: UInt8
    let proto:UInt8
    let checksum: UInt16
    let source: in_addr
    let destination: in_addr
}

struct GatewayStruct {
    var hostname = ""
    var port = ""
}

@available(macOSApplicationExtension 11.0, *)
struct PacketCode {
    private let myLog = Logger(subsystem: "vpn-tunnel", category: "PacketTunnelProvider")
    private var Gateways: [String]!
    init(gateways: [String]){
        Gateways = gateways
    }
    public func packets (packets: [NEPacket]) -> Int {
        let packet = packets.first!
        let data = BinaryData(data: packet.data)
        do {
            let header = IPHeader(version: try data.get(0),
                headerLength: try data.get(1),
                typeOfService: try data.get(2),
                length: try data.get(3),
                id: try data.get(5),
                offset: try data.get(7),
                timeToLive: try data.get(8),
                proto: try data.get(9),
                checksum: try data.get(10),
                source: in_addr(s_addr: try data.get(12)),
                destination: in_addr(s_addr: try data.get(16)))
            
            if let i = Gateways.firstIndex(of:header.destination.description) {
                myLog.log ("Use tunnel i = \(i, privacy: .public) connect source \(header.source, privacy: .public), destination \(header.destination, privacy: .public)")
                return i
            } else {
                myLog.log ("Direct connect source \(header.source, privacy: .public), destination \(header.destination, privacy: .public)  gateway = \(Gateways, privacy: .public)")
                return -1
            }
            
        } catch {
            return -1
        }
        
    }
}

extension in_addr: CustomStringConvertible {
    public var description: String {
        let ip_addr = in_addr(s_addr: self.s_addr)
        let ip = String(cString: inet_ntoa(ip_addr)).split(separator: ".").reversed().joined(separator: ".")
        return ip
    }
}
