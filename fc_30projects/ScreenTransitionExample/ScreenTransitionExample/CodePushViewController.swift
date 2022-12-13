//
//  CodePushViewController.swift
//  ScreenTransitionExample
//
//  Created by a0000 on 2022/12/13.
//

import UIKit

class CodePushViewController: UIViewController {
	
	@IBOutlet weak var nameLabel: UILabel!
	 var name: String?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		if let name = name {
			self.nameLabel.text = name
			self.nameLabel.sizeToFit()
		}
	}
	@IBAction func tapBackButton(_ sender: Any) {
		self.navigationController?.popViewController(animated: true)
	}
}
