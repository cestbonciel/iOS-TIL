//
//  ReminderViewController+CellConfiguration.swift
//  Today
//
//  Created by Seohyun Kim on 2023/10/04.
//

import UIKit

extension ReminderViewController {
	func defaultConfiguration(for cell: UICollectionViewListCell, at row: Row) -> UIListContentConfiguration {
		var contentConfiguration = cell.defaultContentConfiguration()
		contentConfiguration.text = text(for: row)
		contentConfiguration.textProperties.font = UIFont.preferredFont(forTextStyle: row.textStyle)
		contentConfiguration.image = row.image
		return contentConfiguration
	}
}
