//
//  HistoryView.swift
//  ShortcutDemo
//
//  Created by Seohyun Kim on 14/10/2023
//

import SwiftUI

struct HistoryView: View {
    
    @State var purchaseData: PurchaseData = PurchaseData()
    
    var body: some View {
        NavigationView {
            List(purchaseData.purchases) { item in
                
                HistoryRowView(purchase: item)
            }
            .navigationTitle("Purchase History")
        }
        .onAppear() {
            print("HistoryView: onAppear")
            purchaseData.refresh()
        }
        
    }
}

struct HistoryRowView: View {
    
    var purchase: Purchase
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                NavigationLink(destination: DetailView(purchase: purchase)) {
                    Text(purchase.symbol)
                    Text(purchase.quantity)
                }
            }
            Text(purchase.timestamp)
        }
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
    }
}

