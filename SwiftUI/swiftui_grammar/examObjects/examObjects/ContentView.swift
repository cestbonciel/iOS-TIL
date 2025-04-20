//
//  ContentView.swift
//  examObjects
//
//  Created by Nat Kim on 4/20/25.
//

import SwiftUI

struct ContentView: View {
    @State private var wifiEnabled = true
    @State private var userName = ""
    
    var body: some View {
        VStack(alignment: .center) {
            Toggle(isOn: $wifiEnabled) {
                Text("Enable WiFi")
            }
            TextField("Enter User name", text: $userName)
            Text(userName)
            WifiImageView(wifiEnabled: $wifiEnabled)
        }
        .padding()
    }
}

struct WifiImageView: View {
    @Binding var wifiEnabled: Bool
    var body: some View {
        Image(systemName: wifiEnabled ? "wifi" : "wifi.slash")
            
    }
}

#Preview {
    ContentView()
}
