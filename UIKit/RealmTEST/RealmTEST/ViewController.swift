//
//  ViewController.swift
//  RealmTEST
//
//  Created by Nat Kim on 2024/02/17.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {
    // 기존 Swift 객체 인스턴스처럼 사용할 수 있따!
    let pictureOne = Picture()
    let identifier = "MyRealm"
    var token: NotificationToken?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let config = Realm.Configuration(inMemoryIdentifier: identifier)
    }
    let realm = try! Realm()
    
    
    func updateData() {
        // 리스너를 설정하고 개체 알림을 관찰할 때 Swift 의 Property Observer 와 비슷함.(속성감시자) -> 즉각적인 데이터 상태 변경 적용이 가능하다는 의미에요.
        try! realm.write {
            pictureOne.name1 = "Mona Lisa"
        }
        token = pictureOne.observe { change in
//            switch change {
//            case .change(let properties):
//                for propertyChange in (change, properties) {
//                    if let newValue = propertyChange.newValue {
//                        print("속성 '\(propertyChange.name)'이(가) '\(newValue)'로 변경되었습니다.")
//                    }
//                }
//            case .error(let error):
//                print("An error occurred: \(error)")
//            case .deleted:
//                print("The Object was deleted.")
//
//            }
        }
    }
}

