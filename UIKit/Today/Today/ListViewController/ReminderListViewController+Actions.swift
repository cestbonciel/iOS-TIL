//
//  ReminderListViewController+Actions.swift
//  Today
//
//  Created by Seohyun Kim on 2023/08/30.
//

import UIKit

extension ReminderListViewController {
	@objc func didPressDoneButton(_ sender: ReminderDoneButton) {
		guard let id = sender.id else { return }
		completeReminder(withId: id)
	}
}
