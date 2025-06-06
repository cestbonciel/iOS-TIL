//
//  ReminderListViewController.swift
//  Today
//
//  Created by Seohyun Kim on 2023/08/30.
//

//
//  ReminderListViewController.swift
//  Today
//
//  Created by Seohyun Kim on 2023/08/29.
//

import UIKit

class ReminderListViewController: UICollectionViewController {
	
	var dataSource: DataSource!
	var reminders: [Reminder] = Reminder.sampleData
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let listLayout = listLayout()
		collectionView.collectionViewLayout = listLayout
		
		let cellRegistration = UICollectionView.CellRegistration(handler: cellRegistrationHandler)
		
		dataSource = DataSource(collectionView: collectionView) { (collectionView: UICollectionView, indexPath: IndexPath, itemIdentifier: Reminder.ID) in
			return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
		}
		
		var snapshot = Snapshot()
		snapshot.appendSections([0])
		snapshot.appendItems(Reminder.sampleData.map { $0.id })
		dataSource.apply(snapshot)
		
		updateSnapshot()
		
		collectionView.dataSource = dataSource
	}
	
	override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
		let id = reminders[indexPath.item].id
		pushDetailViewForReminder(withId: id)
		return false
	}
	
	func pushDetailViewForReminder(withId id: Reminder.ID) {
		let reminder = reminder(withId: id)
		let viewController = ReminderViewController(reminder: reminder)
		navigationController?.pushViewController(viewController, animated: true)
	}
	
	private func listLayout() -> UICollectionViewCompositionalLayout {
		var listConfiguration = UICollectionLayoutListConfiguration(appearance: .sidebar)
		listConfiguration.showsSeparators = false
		listConfiguration.backgroundColor = .systemGray4
		
		return UICollectionViewCompositionalLayout.list(using: listConfiguration)
	}
	
}

