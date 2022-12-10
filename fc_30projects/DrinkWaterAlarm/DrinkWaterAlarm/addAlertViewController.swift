//
//  addAlertViewController.swift
//  DrinkWaterAlarm
//
//  Created by a0000 on 2022/12/10.
//

import UIKit

class addAlertViewController: UIViewController {
	var pickedDate: ((_ date: Date) -> Void)?
	
	@IBOutlet weak var datePicker: UIDatePicker!
	
	@IBAction func dismissButtonTapped(_ sender: UIBarButtonItem) {
		self.dismiss(animated: true, completion: nil)
	}
	@IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
		pickedDate?(datePicker.date)
		self.dismiss(animated: true, completion: nil)
	}
}
