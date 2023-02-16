//
//  ViewController.swift
//  ScreenTransitionExample
//
//  Created by a0000 on 2022/12/13.
//

import UIKit

class ViewController: UIViewController, SendDataDelegate {
	@IBOutlet weak var nameLabel: UILabel!
	// MARK: Lifecycle Study
	override func viewDidLoad() {
		super.viewDidLoad()
		print("📌ViewController 뷰가 로드 되었다. - viewDidLoad 한번만 호출")
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		print("🔮미래, 반복: ViewController 뷰가 나타날 것이다.")
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		print("💥ViewController 뷰가 나타났다.")
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		print("⏰viewController 뷰가 사라질 것이다.")
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		print("💨ViewController 뷰가 사라졌다.")
	}
	
	@IBAction func tapCodePushButton(_ sender: UIButton) {
		guard 	let viewController = self.storyboard?.instantiateViewController(identifier: "CodePushViewController") as? CodePushViewController else { return }
		viewController.name = "Seohyeon-Push"
		self.navigationController?.pushViewController(viewController, animated: true)
	}
	
	@IBAction func tapCodePresentButton(_ sender: UIButton) {
		guard let viewController = self.storyboard?.instantiateViewController(identifier: "CodePresentViewController") as? CodePresentViewController else { return }
		viewController.modalPresentationStyle = .fullScreen
		viewController.name = "Seohyeon-Present"
		viewController.delegate = self
		self.present(viewController, animated: true, completion: nil)
	}
	
	// MARK: 화면 간 데이터 전달 ( Scene to Scene, Dispatched Data ) 
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let viewController = segue.destination as? SeguePushViewController {
			viewController.name = "Segue Push Data: Seohyun"
		}
	}
	
	func sendData(name: String) {
		self.nameLabel.text = name
		self.nameLabel.sizeToFit()
	}
}

