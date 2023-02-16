//
//  ViewController.swift
//  Dice-iOS15
//
//  Created by Seohyun Kim on 2022/12/23.
//

import UIKit

class ViewController: UIViewController {
	// IBOutlet allows me to reference a UI element
	@IBOutlet weak var diceImageView1: UIImageView!
	@IBOutlet weak var diceImageView2: UIImageView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
	}
	
	@IBAction func rollButtonPressed(_ sender: UIButton) {
		
		let diceArray = [#imageLiteral(resourceName: "DiceOne"), #imageLiteral(resourceName: "DiceTwo"), #imageLiteral(resourceName: "DiceThree"), #imageLiteral(resourceName: "DiceFour"), #imageLiteral(resourceName: "DiceFive"), #imageLiteral(resourceName: "DiceSix")]
		
		diceImageView1.image = diceArray[Int.random(in: 0...5)]
		diceImageView2.image = diceArray[Int.random(in: 0...5)]
		
		
	}
	
	
}

