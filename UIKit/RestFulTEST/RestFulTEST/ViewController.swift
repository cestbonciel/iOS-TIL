//
//  ViewController.swift
//  RestFulTEST
//
//  Created by Nat Kim on 2024/01/09.
//

import UIKit

class ViewController: UIViewController {
    let apiKey = "a9d007487c8efaee8edf8a00b3579ffd"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    let resultLabel: UILabel = {
        let label = UILabel()
        
        return label
    }()
    func getRequestValue() {
        let movieURL = "https://kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json?key=\(apiKey)&targetDt=20240101"
        let structUrl = URL(string: movieURL)!
        let session = URLSession.shared
        
        session.dataTask(with: structUrl) { data, response, error in
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            
            if let safeData = data {
                let str = String(decoding: safeData, as: UTF8.self)
                
            }
        }.resume()
        
//        task.resume()
    }
}

