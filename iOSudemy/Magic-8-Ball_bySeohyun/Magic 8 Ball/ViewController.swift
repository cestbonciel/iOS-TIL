//
//  ViewController.swift
//  Magic 8 Ball
//
//  Created by Seohyun Kim on 14/1/2023.

import UIKit

class ViewController: UIViewController {
	
	@IBOutlet weak var noticeMention: UILabel!
	@IBOutlet weak var imageView: UIImageView!
	
	let ballArray = [#imageLiteral(resourceName: "ball1"),#imageLiteral(resourceName: "ball2"),#imageLiteral(resourceName: "ball3"),#imageLiteral(resourceName: "ball4"),#imageLiteral(resourceName: "ball5")]
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	
	@IBAction func askButtonPressed(_ sender: UIButton) {
//		imageView.image = ballArray.randomElement()
		noticeMention.isHidden = true
		imageView.image = ballArray[Int.random(in: 0...4)]
		
	}
}

