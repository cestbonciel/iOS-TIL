//
//  ViewController.swift
//  Clima
//
//  Created by Seohyun Kim 10/09/2023
//

import UIKit

class WeatherViewController: UIViewController, UITextFieldDelegate {

	@IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
	@IBOutlet weak var searchTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
		 searchTextField.delegate = self
    }

	@IBAction func searchPressed(_ sender: UIButton) {
		searchTextField.endEditing(true)
		print(searchTextField.text!)
	}
	//MARK: - should: asking for permission
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		searchTextField.endEditing(true)
		print(searchTextField.text!)
		return true
	}
	
	func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
		if textField.text != "" {
			return true
		} else {
			textField.placeholder = "도시를 입력하세요."
			return false
		} 
	}
	
	
	func textFieldDidEndEditing(_ textField: UITextField) {
		//Use searchTextField.text to get 도시 날씨 정보
		searchTextField.text = ""
	}
}

