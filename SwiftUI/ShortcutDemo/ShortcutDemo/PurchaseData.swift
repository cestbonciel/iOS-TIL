//
//  PurchaseData.swift
//  ShortcutDemo
//
// Created by Seohyun Kim on 14/10/2023
//

import SwiftUI

struct PurchaseData: Codable {

    var purchases: [Purchase]
    
    init() {
        purchases = []
        refresh()
    }
    
    mutating func refresh() {
        purchases = PurchaseStore().getPurchases()
    }
    
    mutating func saveTransaction(symbol: String, quantity: String) -> Bool {
    
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.medium
        formatter.timeStyle = DateFormatter.Style.medium
        
        let timeStamp = formatter.string(from: Date())
    
        purchases.append(Purchase(symbol: symbol, quantity: quantity, timestamp: timeStamp))
        
        return PurchaseStore().update(purchaseData: self)
    }
}
