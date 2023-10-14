//
//  Purchase.swift
//  ShortcutDemo
//
//  Created by Seohyun Kim on 14/10/2023
//

import SwiftUI

struct Purchase: Codable, Identifiable {
    var id = UUID()
    var symbol: String
    var quantity: String
    var timestamp: String
}
