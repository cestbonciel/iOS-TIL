//
//  ReminderViewController.swift
//  Today
//
//  Created by Seohyun Kim on 2023/09/01.
//

import UIKit

class ReminderViewController: UICollectionViewController {
	private typealias DataSource = UICollectionViewDiffableDataSource<Section, Row>
	private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Row>
	
	var reminder: Reminder
	private var dataSource: DataSource!
	
	init(reminder: Reminder) {
		self.reminder = reminder
		var listConfiguration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
		listConfiguration.showsSeparators = false
		listConfiguration.headerMode = .firstItemInSection
		let listLayout = UICollectionViewCompositionalLayout.list(using: listConfiguration)
		super.init(collectionViewLayout: listLayout)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		let cellRegistration = UICollectionView.CellRegistration(handler: cellRegistrationHandler)
		dataSource = DataSource(collectionView: collectionView) { (collectionView: UICollectionView, indexPath: IndexPath, itemIdentifier: Row) in
			return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
		}
		
		if #available(iOS 16, *) {
			navigationItem.style = .navigator
		}
		
		navigationItem.title = NSLocalizedString("Reminder", comment: "Reminder view controller title")
		navigationItem.rightBarButtonItem = editButtonItem
		updateSnapshotForViewing()
	}
	
	override func setEditing(_ editing: Bool, animated: Bool) {
		super.setEditing(editing, animated: animated)
		if editing {
			updateSnapshotForEditing()
		} else {
			updateSnapshotForViewing()
		}
	}
	
	func cellRegistrationHandler(cell: UICollectionViewListCell, indexPath: IndexPath, row: Row) {
		let section = section(for: indexPath)
		switch (section, row) {
		case (_, .header(let title)):
			cell.contentConfiguration = headerConfiguration(for: cell, with: title)
		case (.view, _):
			cell.contentConfiguration  = defaultConfiguration(for: cell, at: row)
		case (.title, .editableText(let title)):
			cell.contentConfiguration = titleConfiguration(for: cell, with: title)
		default:
			fatalError("Unexpected combination of section and row.")
		}
	}
	
	private func updateSnapshotForEditing() {
		var snapshot = Snapshot()
		snapshot.appendSections([.title, .date, .notes])
		snapshot.appendItems([.header(Section.title.name), .editableText(reminder.title)], toSection: .title)
		snapshot.appendItems([.header(Section.date.name)], toSection: .date)
		snapshot.appendItems([.header(Section.notes.name)], toSection: .notes)
		dataSource.apply(snapshot)
	}
	
	private func updateSnapshotForViewing() {
		var snapshot = Snapshot()
		snapshot.appendSections([.view])
		snapshot.appendItems([Row.header(""), Row.title, Row.date, Row.time, Row.notes], toSection: .view)
		dataSource.apply(snapshot)
	}
	
	private func section(for indexPath: IndexPath) -> Section {
		let sectionNumber = isEditing ? indexPath.section + 1 : indexPath.section
		guard let section = Section(rawValue: sectionNumber) else {
			fatalError("Unable to find matching section")
		}
		return section
	}
	
}
