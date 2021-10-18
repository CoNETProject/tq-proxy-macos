//
//  ContentView.swift
//  tq-proxy-macos
//
//  Created by peter xie on 2021-10-15.
//

import SwiftUI

struct ContentView: View {
    let service: VPNConfigurationService = .shared
    let dnsService = AppDelegate()
    var body: some View {
        Text("Hello, world!")
            .padding()
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
