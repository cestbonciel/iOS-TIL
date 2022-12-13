//
//  SeguePresentViewController.swift
//  ScreenTransitionExample
//
//  Created by a0000 on 2022/12/13.
//

import UIKit

class SeguePresentViewController: UIViewController {
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	
	
	@IBAction func tapBackButton(_ sender: UIButton) {
		self.presentingViewController?.dismiss(animated: true, completion: nil)
	}
}
