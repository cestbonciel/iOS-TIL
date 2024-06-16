//
//  Artwork.swift
//  RealmTEST
//
//  Created by Nat Kim on 2024/02/17.
//

import UIKit
import RealmSwift

// 정규 Swift 클래스처럼 모델을 정의할 수 있다!
class Picture: Object {
    @Persisted var name1: String
    @Persisted var age: Int
    
   

    var token: NotificationToken
    // An opaque token which is returned from methods which subscribe to changes to a Realm.
    init(token: NotificationToken) {
        self.token = token
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class Owner: Object {
    @Persisted(primaryKey: true) var _id: String
    @Persisted var name: String
    @Persisted var age: Int
    // 다른 객체 필드와 relationships 형성
    @Persisted var pictures: List<Picture>
}

