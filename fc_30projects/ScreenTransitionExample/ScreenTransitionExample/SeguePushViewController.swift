//
//  SeguePushViewController.swift
//  ScreenTransitionExample
//
//  Created by a0000 on 2022/12/13.
//

import UIKit

class SeguePushViewController: UIViewController {
	@IBOutlet weak var nameLabel: UILabel!
	var name: String?
	
	// MARK: Lifecycle Study
	override func viewDidLoad() {
		super.viewDidLoad()
		print("📌SeguePushViewController 뷰가 로드 되었다. - viewDidLoad 한번만 호출")
		if let name = name {
			self.nameLabel.text = name
			self.nameLabel.sizeToFit()
		}
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		print("🔮미래, 반복: SeguePushViewController 뷰가 나타날 것이다.")
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		print("💥SeguePushViewController 뷰가 나타났다.")
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		print("⏰SeguePushViewController 뷰가 사라질 것이다.")
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		print("💨SeguePushViewController 뷰가 사라졌다.")
	}
	
	@IBAction func tapBackButton(_ sender: UIButton) {
		self.navigationController?.popViewController(animated: true)
	}
}
