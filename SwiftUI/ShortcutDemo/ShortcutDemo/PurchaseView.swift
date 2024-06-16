//
//  PurchaseView.swift
//  ShortcutDemo
//
//  Created by Seohyun Kim on 14/10/2023
//

import SwiftUI
import Intents

struct PurchaseView: View {
    
    @State var symbol: String = ""
    @State var quantity: String = ""
    @State var status: String = "Enter symbol and quantity"
    
    @State var purchaseData: PurchaseData = PurchaseData()
    
    @AppStorage("demostorage", store: UserDefaults(
                    suiteName: "com.seohyun.iOSApp.ShortcutDemo")) var store: Data = Data()
    
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some View {
        
        VStack {
            Form {
                HStack {
                    Spacer()
                    Text("Purchase Stocks")
                        .bold()
                    Spacer()
                }
                TextField("Symbol", text: $symbol)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
            
                TextField("Quantity", text: $quantity)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                HStack {
                    Spacer()
                    Text(status)
                        .font(.footnote)
                    Spacer()
                }
            
                HStack {
                    Spacer()
                    Button(action: {
                        buyStock()
                    }) {
                        Text("Purchase")
                    }
                    Spacer()
                }
            }
        }
        .onAppear() {
            print("PurchaseView: onAppear")
            purchaseData.refresh()
        }
    }
	
	func makeDonation(symbol: String, quantity: String) {
		let intent = BuyStockIntent()
		intent.quantity = quantity
		intent.symbol = symbol
		
		let interaction = INInteraction(intent: intent, response: nil)
		
		interaction.donate { (error) in
			if error != nil {
				if let error = error as NSError? {
					print("Donation failed: %@" + error.localizedDescription)
				}
			} else {
				print("Successfully donated interaction.")
			}
		}
	}
    
    private func buyStock() {
        if (symbol == "" || quantity == "") {
            status = "Please enter a symbol and quantity"
        } else {
            if purchaseData.saveTransaction(symbol: symbol, quantity: quantity) {
                status = "Purchase completed"
					makeDonation(symbol: symbol, quantity: quantity)
            }
        }
    }
}

struct PurchaseView_Previews: PreviewProvider {
    static var previews: some View {
        PurchaseView()
    }
}

