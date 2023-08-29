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
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let listLayout = listLayout()
		collectionView.collectionViewLayout = listLayout
		
		let cellRegistration = UICollectionView.CellRegistration(handler: cellRegistrationHandler)
		
		dataSource = DataSource(collectionView: collectionView) { (collectionView: UICollectionView, indexPath: IndexPath, itemIdentifier: String) in
			return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
		}
		var snapshot = Snapshot()
		snapshot.appendSections([0])
		var reminderTitles = [String]()
		snapshot.appendItems(Reminder.sampleData.map { $0.title })
		dataSource.apply(snapshot)
		
		collectionView.dataSource = dataSource
	}

	private func listLayout() -> UICollectionViewCompositionalLayout {
		var listConfiguration = UICollectionLayoutListConfiguration(appearance: .grouped)
		listConfiguration.showsSeparators = false
		listConfiguration.backgroundColor = .clear
		
		return UICollectionViewCompositionalLayout.list(using: listConfiguration)
	}
	
}

