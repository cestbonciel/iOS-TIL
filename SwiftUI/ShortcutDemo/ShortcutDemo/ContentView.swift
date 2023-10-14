//
//  ContentView.swift
//  ShortcutDemo
//
//  Created by Seohyun Kim on 14/10/2023
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        
        TabView {
            PurchaseView()
                .tabItem {
                    Image(systemName: "cart")
                    Text("Buy")
                }

            HistoryView()
                .tabItem {
                    Image(systemName: "clock")
                    Text("History")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
