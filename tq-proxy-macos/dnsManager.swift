//
//  dnsManager.swift
//  tq-proxy-macos
//
//  Created by peter xie on 2021-10-18.
//

import Foundation
import NetworkExtension

final class AppDelegate {
    let manager = NEDNSProxyManager.shared()
    init(){
        //enable()
    }
    private func update(_ body: @escaping () -> Void) {
        manager.loadFromPreferences { error in
            guard error == nil else {
                NSLog("DNSProxySample.App: load error")
                return
            }
            body()
            self.manager.saveToPreferences { error in
                guard error == nil else {
                    NSLog("DNSProxySample.App: save error")
                    return
                }
                NSLog("DNSProxySample.App: saved")
            }
        }
    }
    public func disable() {
        self.update {
            self.manager.isEnabled = false
        }
    }
    private func enable() {
        self.update {
            self.manager.localizedDescription = "DNS"
//            let proto = NEDNSProxyProviderProtocol()
            let settings = NEDNSOverHTTPSSettings(servers: ["127.0.0.1"])
            settings.serverURL = URL(string: "http://127.0.0.1/dns")

//            self.manager.providerProtocol = proto
            self.manager.isEnabled = true
        }
    }
    
}
