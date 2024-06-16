//
//  DetailView.swift
//  ShortcutDemo
//
//  Created by Seohyun Kim on 14/10/2023
//

import SwiftUI

struct DetailView: View {
    
    var purchase: Purchase
    
    var body: some View {
        Form {
                        
            HStack {
                Spacer()
                Text("\(purchase.symbol) Purchase")
                    .bold()
                Spacer()
            }
            
            HStack {
                Text("Symbol:")
                    .bold()
                Text(purchase.symbol)
            }
            
            HStack {
                Text("Quantity:")
                    .bold()
                Text(purchase.quantity)
            }
            
            HStack {
                Text("Date:")
                    .bold()
                Text(purchase.timestamp)
            }
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(purchase: Purchase(symbol: "GE", quantity: "100", timestamp: "Today"))
    }
}
