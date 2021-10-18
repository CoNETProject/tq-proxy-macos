//
//  PacketTunnelProvider.swift
//  vpn-tunnel
//
//  Created by peter xie on 2021-10-15.
//

import NetworkExtension
import os.log


class PacketTunnelProvider: NEPacketTunnelProvider {

    override func startTunnel(options: [String : NSObject]?, completionHandler: @escaping (Error?) -> Void) {
        NSLog("NEPacketTunnelProvider start tun2socks\(String(describing: options))")
        // Add code here to start the process of connecting the tunnel.
        setup(completionHandler)
    }
    
    private func setup(_ completionHandler: @escaping (Error?) -> Void) {
        let settings = NEPacketTunnelNetworkSettings(tunnelRemoteAddress: "127.0.0.1")
        //settings.mtu = 1440
        
        //      proxy setup
        let proxySettings = NEProxySettings()
        proxySettings.excludeSimpleHostnames = true
        proxySettings.autoProxyConfigurationEnabled = false
        
        proxySettings.httpEnabled = true
        proxySettings.httpServer = NEProxyServer(address: "127.0.0.1", port: 8888)
        proxySettings.httpsEnabled = true
        proxySettings.httpsServer = NEProxyServer(address: "127.0.0.1", port: 8888)
        proxySettings.exceptionList = [
            "192.168.0.0/16",
            "10.0.0.0/8",
            "172.16.0.0/12",
            "127.0.0.1",
            "localhost",
            "*.local"
        ]
        
        settings.proxySettings = proxySettings
        
        //
        let ipv4Settings = NEIPv4Settings(addresses: ["127.0.0.1"], subnetMasks: ["255.255.255.255"])
        ipv4Settings.includedRoutes = [NEIPv4Route.default()]

        ipv4Settings.excludedRoutes = [
            
            NEIPv4Route(destinationAddress: "127.0.0.1", subnetMask: "255.255.255.255"),
            NEIPv4Route(destinationAddress: "10.0.0.0", subnetMask: "255.0.0.0"),
            NEIPv4Route(destinationAddress: "100.64.0.0", subnetMask: "255.192.0.0"),
            NEIPv4Route(destinationAddress: "169.254.0.0", subnetMask: "255.255.0.0"),
            NEIPv4Route(destinationAddress: "172.16.0.0", subnetMask: "255.240.0.0"),
            NEIPv4Route(destinationAddress: "192.168.0.0", subnetMask: "255.255.0.0"),
        ]
        
        
        
        settings.ipv4Settings = ipv4Settings
        
//        let dnsSettings = NEDNSSettings(servers: ["8.8.8.8"])
//        dnsSettings.matchDomainsNoSearch = false
//        settings.dnsSettings = dnsSettings
        setTunnelNetworkSettings(settings) { error in
            
            if let error = error {
                NSLog("Did setup tunnel error: \(String(describing: error))")
            }
            
            completionHandler(error)
           
        }
        
    }
    
    
    override func stopTunnel(with reason: NEProviderStopReason, completionHandler: @escaping () -> Void) {
        // Add code here to start the process of stopping the tunnel.
        completionHandler()
    }
    
    override func handleAppMessage(_ messageData: Data, completionHandler: ((Data?) -> Void)?) {
        // Add code here to handle the message.
        if let handler = completionHandler {
            handler(messageData)
        }
    }
    
    override func sleep(completionHandler: @escaping () -> Void) {
        // Add code here to get ready to sleep.
        completionHandler()
    }
    
    override func wake() {
        // Add code here to wake up.
    }
    
    

}


