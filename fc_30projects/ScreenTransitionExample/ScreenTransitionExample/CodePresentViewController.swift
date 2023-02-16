//
//  CodePresentViewController.swift
//  ScreenTransitionExample
//
//  Created by a0000 on 2022/12/13.
//

import UIKit

protocol SendDataDelegate: AnyObject {
	func sendData(name: String)
}

class CodePresentViewController: UIViewController {
	
	@IBOutlet weak var nameLabel: UILabel!
	var name: String?
	weak var delegate: SendDataDelegate?
	// delegate 변수를 사용할 때 weak 를 안 붙이면 강한 순한 참조 발생 -> 메모리 누수의 원인이 됨
	override func viewDidLoad() {
		super.viewDidLoad()
		if let name = name {
			self.nameLabel.text = name
			self.nameLabel.sizeToFit()
		}
	}
	@IBAction func tapBackButton(_ sender: UIButton) {
		self.delegate?.sendData(name: "데이터를 전송할 내용: Seohyun")
		self.presentingViewController?.dismiss(animated: true, completion: nil)
	}
}
