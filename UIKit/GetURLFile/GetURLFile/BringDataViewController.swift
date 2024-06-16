//
//  BringDataViewController.swift
//  GetURLFile
//
//  Created by Seohyun Kim on 2023/11/06.
//

import UIKit

class BringDataViewController: UIViewController {
	var textViewModel: TextViewModel!
	var bringData: [TextData] = []
	@IBOutlet weak var dateData: UILabel!
	@IBOutlet weak var textData: UILabel!
	override func viewDidLoad() {
		super.viewDidLoad()
		textViewModel.load()
	}
	
	
	@IBAction func bringTheData(_ sender: Any) {
		if let data = textViewModel.textData.last {
			let formatter = DateFormatter()
			formatter.timeZone = TimeZone.current
			formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
			dateData.text = formatter.string(from: data.creationDate)
			
			textData.text = data.article
		}
	}
}
