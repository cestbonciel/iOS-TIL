//
//  AppleConferenceVideoSessionsViewController.swift
//  collectionViewbyCode
//
//  Created by Seohyun Kim on 2023/09/05.
//

import UIKit

class AppleConferenceVideoSessionsViewController: UIViewController {
	let techVideosController = ConferenceTechVideoController()
	var collectionView: UICollectionView! = nil
	var dataSource: UICollectionViewDiffableDataSource
		<ConferenceTechVideoController.VideoCollection, ConferenceTechVideoController.Video>! = nil
	var currentSnapshot: NSDiffableDataSourceSnapshot
		<ConferenceTechVideoController.VideoCollection, ConferenceTechVideoController.Video>! = nil
	static let titleElementKind = "title-element-kind"

	override func viewDidLoad() {
		super.viewDidLoad()
		navigationItem.title = "Conference Videos"
		configureHierarchy()
		configureDataSource()
	}


}

extension AppleConferenceVideoSessionsViewController {
	func createLayout() -> UICollectionViewLayout {
		let sectionProvider = { (sectionIndex: Int,
			layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
			let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
												 heightDimension: .fractionalHeight(1.0))
			let item = NSCollectionLayoutItem(layoutSize: itemSize)

			// if we have the space, adapt and go 2-up + peeking 3rd item
			let groupFractionalWidth = CGFloat(layoutEnvironment.container.effectiveContentSize.width > 500 ?
				0.425 : 0.85)
			let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(groupFractionalWidth),
												  heightDimension: .absolute(250))
			let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

			let section = NSCollectionLayoutSection(group: group)
			section.orthogonalScrollingBehavior = .continuous
			section.interGroupSpacing = 20
			section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)

			let titleSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
												  heightDimension: .estimated(44))
			let titleSupplementary = NSCollectionLayoutBoundarySupplementaryItem(
				layoutSize: titleSize,
				elementKind: AppleConferenceVideoSessionsViewController.titleElementKind,
				alignment: .top)
			section.boundarySupplementaryItems = [titleSupplementary]
			return section
		}
		
		let config = UICollectionViewCompositionalLayoutConfiguration()
		config.interSectionSpacing = 20
		
		let layout = UICollectionViewCompositionalLayout(sectionProvider: sectionProvider, configuration: config)
		return layout
	}
}

extension AppleConferenceVideoSessionsViewController {
	func configureHierarchy() {
		collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
		collectionView.translatesAutoresizingMaskIntoConstraints = false
		collectionView.backgroundColor = .systemBackground
		view.addSubview(collectionView)
		NSLayoutConstraint.activate([
			collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			collectionView.topAnchor.constraint(equalTo: view.topAnchor),
			collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
		])
	}
	
	func configureDataSource() {
		let cellRegistration = UICollectionView.CellRegistration
		<AppleConferenceCell, ConferenceTechVideoController.Video> { (cell, indexPath, video) in
			// Populate the cell with our item description.
			cell.titleLabel.text = video.title
			cell.categoryLabel.text = video.category
		}
		
		dataSource = UICollectionViewDiffableDataSource
		<ConferenceTechVideoController.VideoCollection, ConferenceTechVideoController.Video>(collectionView: collectionView) { (collectionView: UICollectionView, indexPath: IndexPath, video: ConferenceTechVideoController.Video) -> UICollectionViewCell?  in
			return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: video)
		}
		
		let supplementaryRegistration = UICollectionView.SupplementaryRegistration
		<TitleSupplementaryView>(elementKind: AppleConferenceVideoSessionsViewController.titleElementKind) {
			(supplementaryView, string, indexPath) in
			if let snapshot = self.currentSnapshot {
				// Populate the view with our section's description.
				let videoCategory = snapshot.sectionIdentifiers[indexPath.section]
				supplementaryView.label.text = videoCategory.title
			}
		}
		
		dataSource.supplementaryViewProvider = { (view, kind, index) in
			return self.collectionView.dequeueConfiguredReusableSupplementary(
				using: supplementaryRegistration, for: index)
		}
		
		currentSnapshot = NSDiffableDataSourceSnapshot
			<ConferenceTechVideoController.VideoCollection, ConferenceTechVideoController.Video>()
		techVideosController.collections.forEach {
			let collection = $0
			currentSnapshot.appendSections([collection])
			currentSnapshot.appendItems(collection.videos)
		}
		dataSource.apply(currentSnapshot, animatingDifferences: false)
	}
}
