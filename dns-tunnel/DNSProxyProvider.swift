//
//  DNSProxyProvider.swift
//  dns-tunnel
//
//  Created by peter xie on 2021-10-18.
//

import NetworkExtension

class DNSProxyProvider: NEDNSProxyProvider {

    override func startProxy(options:[String: Any]? = nil, completionHandler: @escaping (Error?) -> Void) {
        // Add code here to start the DNS proxy.
        completionHandler(nil)
        NSLog("DNSProxySample.Provider: start")
    }

    override func stopProxy(with reason: NEProviderStopReason, completionHandler: @escaping () -> Void) {
        // Add code here to stop the DNS proxy.
        completionHandler()
        NSLog("DNSProxySample.Provider: stop")
    }

    override func sleep(completionHandler: @escaping () -> Void) {
        // Add code here to get ready to sleep.
        completionHandler()
    }

    override func wake() {
        // Add code here to wake up.
    }

    override func handleNewFlow(_ flow: NEAppProxyFlow) -> Bool {
        // Add code here to handle the incoming flow.
        NSLog("DNSProxySample.Provider: new flow (denied)")
        return false
    }

}
