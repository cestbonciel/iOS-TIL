//
//  ViewController.swift
//  GetURLFile
//
//  Created by Seohyun Kim on 2023/11/05.
//

import UIKit

class ViewController: UIViewController {
	var viewModel: TextViewModel!
	var newArticleText = ""
	var date = Date()
	@IBOutlet weak var inputTextView: UITextView!
	override func viewDidLoad() {
		super.viewDidLoad()
		viewModel = TextViewModel()
	}
	
	@IBAction func saveTextFile(_ sender: Any) {
		newArticleText = inputTextView.text ?? ""
		finishSaving()
	}
	
	func finishSaving() {
		if let text = self.inputTextView.text {
			viewModel.add(newArticleText, date: date)
		}
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "BringDataIdentifier", let bringDataVC = segue.destination as? BringDataViewController {
			bringDataVC.textViewModel = self.viewModel
		}
	}
}

