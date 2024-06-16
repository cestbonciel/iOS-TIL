//
//  TodoThingsData.swift
//  TestByRealm
//
//  Created by Nat Kim on 2024/02/15.
//

import Foundation
import RealmSwift

class TodoThingsData: Object {
    @Persisted var name: String = ""
    @Persisted var category: String = Category.uncategorized.rawValue
    @Persisted var isChecked: Bool = false
    
    override init() {
        super.init()
    }
    
    init(name: String, category: Category = Category.uncategorized, isChecked: Bool = false) {
        self.name = name
        self.category = category.rawValue
        self.isChecked = isChecked
    }
    
    
}


