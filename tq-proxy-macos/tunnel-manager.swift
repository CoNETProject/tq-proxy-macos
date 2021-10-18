//
//  tunnel-manager.swift
//  tq-proxy-macos
//
//  Created by peter xie on 2021-10-15.
//

import Foundation
import NetworkExtension

final class VPNConfigurationService: ObservableObject {
    static let shared = VPNConfigurationService()
    private init() {
        refresh()
    }
    
    private func refresh() {
        // Read all of the VPN configurations created by the app that have
        // previously been saved to the Network Extension preferences.
        
        
        NETunnelProviderManager.loadAllFromPreferences { [weak self] managers, error in

            // There is only one VPN configuration the app provides
            
            if let error = error {
                return NSLog("NETunnelProviderManager.loadAllFromPreferences ERROR", error.localizedDescription)
            }
            
            guard let strongSelf = self else { return }
            guard let tunnels = managers else { return }
            
            NSLog("refresh NETunnelProviderManager.loadAllFromPreferences success! tunnels.count = ", tunnels.count)
            
            if tunnels.count == 0 {
                return strongSelf.createTunnel()
            }
            
            
            let group = DispatchGroup()

            for tunnel in tunnels {
                group.enter()
                tunnel.removeFromPreferences { error in
                    if let error = error {
                        NSLog("tunnel.removeFromPreferences ERROR", error.localizedDescription)
                    }
                    group.leave()
                }
            }

            group.notify(queue: .main) {
                NSLog("remove all old Preferences finished!")
                strongSelf.createTunnel()
            }
     
        }
    }
    
    private func createTunnel () {
        let tunnel = makeManager()
        
        tunnel.saveToPreferences { error in
           
            if let error = error {
                NSLog("createTunnel ERROR ", error.localizedDescription)
                return
            }
            
            
            tunnel.loadFromPreferences { error in
                if let error = error {
                    NSLog("tunnel.loadFromPreferences ERROR ", error.localizedDescription)
                    return
                }
                
                print("createTunnel success!")
                do {
                    try tunnel.connection.startVPNTunnel()
                } catch {
                    NSLog("Failed to start VPN tunnel:", error.localizedDescription)
                }
                
                NSLog("startVPNTunnel success")
            }
        }
    }
    
    private func makeManager() -> NETunnelProviderManager {
        let manager = NETunnelProviderManager()
        manager.localizedDescription = "TQ-Proxy"

        let proto = NETunnelProviderProtocol()

        // WARNING: This must send the actual VPN server address, for the demo
        // purposes, I'm passing the address of the server in my local network.
        // The address is going to be different in your network.
        proto.serverAddress = "127.0.0.1"

        proto.username = ""
        proto.passwordReference = nil
        proto.includeAllNetworks = false
        
        // WARNING: This must match the bundle identifier of the app extension
        // containing packet tunnel provider.
        proto.providerBundleIdentifier = "com.kloak.tq-proxy-macos.vpn-tunnel"
        
        
        manager.protocolConfiguration = proto

        manager.isEnabled = true

        return manager
    }
    
}
