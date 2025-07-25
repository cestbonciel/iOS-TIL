//
//  RecommendedAppsView.swift
//  AppStore
//
//  Created by Nat Kim on 7/24/25.
//

import UIKit

class RecommendedAppsView: UIView {
	// MARK: - UI Components
	private let containerView = UIView()
	private let headerLabel = UILabel()
	private let subtitleLabel = UILabel()
	private let collectionView: UICollectionView
	
	// MARK: - Properties
	private let recommendedAppsData: RecommendedAppsModel
	
	// MARK: - Initialization
	init(data: RecommendedAppsModel) {
		self.recommendedAppsData = data
		let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
											  heightDimension: .absolute(80))
		let item = NSCollectionLayoutItem(layoutSize: itemSize)
		
		let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
											   heightDimension: .absolute(80))
		let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
		
		let section = NSCollectionLayoutSection(group: group)
		section.interGroupSpacing = 0
		section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
		
		let layout = UICollectionViewCompositionalLayout(section: section)
		self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
		
		super.init(frame: .zero)
		setupUI()
		setupConstraints()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Setup
	private func setupUI() {
		backgroundColor = .clear
		translatesAutoresizingMaskIntoConstraints = false
		
		containerView.translatesAutoresizingMaskIntoConstraints = false
		containerView.backgroundColor = .systemBackground
		containerView.layer.cornerRadius = 12
		containerView.layer.shadowColor = UIColor.label.cgColor
		containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
		containerView.layer.shadowOpacity = 0.3
		containerView.layer.shadowRadius = 4
		containerView.clipsToBounds = false
		
		headerLabel.text = recommendedAppsData.headerCategory ?? "추천"
		headerLabel.font = UIFont.preferredFont(forTextStyle: .callout)
		headerLabel.adjustsFontForContentSizeCategory = true
		headerLabel.textColor = .secondaryLabel
		headerLabel.translatesAutoresizingMaskIntoConstraints = false
		
		subtitleLabel.text = recommendedAppsData.headerTitle
		let subTitleDescriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .title1)
		subtitleLabel.font = UIFont(descriptor: subTitleDescriptor.withSymbolicTraits(.traitBold) ?? subTitleDescriptor,size: 0)
		subtitleLabel.adjustsFontForContentSizeCategory = true
		subtitleLabel.textColor = .label
		subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
		
		collectionView.translatesAutoresizingMaskIntoConstraints = false
		collectionView.backgroundColor = .clear
		collectionView.delegate = self
		collectionView.dataSource = self
		collectionView.isScrollEnabled = false
		collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "RecommendedAppListCell")
		
		addSubview(containerView)
		containerView.addSubview(headerLabel)
		containerView.addSubview(subtitleLabel)
		containerView.addSubview(collectionView)
	}
	
	private func setupConstraints() {
		NSLayoutConstraint.activate([
			containerView.topAnchor.constraint(equalTo: topAnchor),
			containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
			containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
			containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
			
			headerLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
			headerLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
			headerLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
			
			subtitleLabel.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 4),
			subtitleLabel.leadingAnchor.constraint(equalTo: headerLabel.leadingAnchor),
			subtitleLabel.trailingAnchor.constraint(equalTo: headerLabel.trailingAnchor),
			
			collectionView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 16),
			collectionView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
			collectionView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
			collectionView.heightAnchor.constraint(equalToConstant: CGFloat(recommendedAppsData.apps.count * 80)),
			
			containerView.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 20)
		])
	}
}

// MARK: - UICollectionViewDataSource
extension RecommendedAppsView: UICollectionViewDataSource {
	func collectionView(
		_ collectionView: UICollectionView,
		numberOfItemsInSection section: Int
	) -> Int {
		return recommendedAppsData.apps.count
	}
	
	func collectionView(
		_ collectionView: UICollectionView,
		cellForItemAt indexPath: IndexPath
	) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(
			withReuseIdentifier: "RecommendedAppListCell",
			for: indexPath
		)
		
		let appInfo = recommendedAppsData.apps[indexPath.item]
		configureRecommendedAppCell(cell, with: appInfo, at: indexPath)
		return cell
	}
	
	private func configureRecommendedAppCell(
		_ cell: UICollectionViewCell,
		with appInfo: AppDisplayInfo,
		at indexPath: IndexPath
	) {
		cell.contentView.subviews.forEach { $0.removeFromSuperview() }
		
		let iconView = UIView()
		iconView.backgroundColor = appInfo.backgroundColor ?? .systemGray4
		iconView.layer.cornerRadius = 12
		iconView.clipsToBounds = true
		iconView.translatesAutoresizingMaskIntoConstraints = false
		
		let nameLabel = UILabel()
		nameLabel.text = appInfo.appName
		nameLabel.font = .boldSystemFont(ofSize: 16)
		nameLabel.textColor = .label
		nameLabel.translatesAutoresizingMaskIntoConstraints = false
		
		let descLabel = UILabel()
		descLabel.text = appInfo.description
		descLabel.font = .systemFont(ofSize: 14)
		descLabel.textColor = .secondaryLabel
		descLabel.numberOfLines = 2
		descLabel.translatesAutoresizingMaskIntoConstraints = false
		
		let button = UIButton(type: .system)
		button.setTitle(appInfo.buttonType.title, for: .normal)
		button.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
		button.setTitleColor(.systemBlue, for: .normal)
		button.titleLabel?.font = .boldSystemFont(ofSize: 14)
		button.layer.cornerRadius = 15.5
		button.clipsToBounds = true
		button.translatesAutoresizingMaskIntoConstraints = false
		
		button.addTarget(self,
						 action: #selector(recommendedAppButtonTapped),
						 for: .touchUpInside)
		button.tag = indexPath.item

		cell.contentView.addSubview(iconView)
		cell.contentView.addSubview(nameLabel)
		cell.contentView.addSubview(descLabel)
		cell.contentView.addSubview(button)
		
		if appInfo.showInAppPurchaseInfo && appInfo.hasInAppPurchase {
			let inAppLabel = UILabel()
			inAppLabel.text = "앱 내 구입"
			inAppLabel.font = .systemFont(ofSize: 10)
			inAppLabel.textColor = .secondaryLabel
			inAppLabel.textAlignment = .center
			inAppLabel.translatesAutoresizingMaskIntoConstraints = false
			
			cell.contentView.addSubview(inAppLabel)
			
			NSLayoutConstraint.activate([
				inAppLabel.topAnchor.constraint(equalTo: button.bottomAnchor, constant: 2),
				inAppLabel.centerXAnchor.constraint(equalTo: button.centerXAnchor),
				inAppLabel.widthAnchor.constraint(equalTo: button.widthAnchor)
			])
		}
		
		let buttonWidthConstraint = button.widthAnchor.constraint(equalToConstant: 70)
		buttonWidthConstraint.priority = UILayoutPriority(999)
		
		let nameTrailingConstraint = nameLabel.trailingAnchor.constraint(
			lessThanOrEqualTo: button.leadingAnchor,
			constant: -12
		)
		nameTrailingConstraint.priority = UILayoutPriority(750)
		
		NSLayoutConstraint.activate(
			[
				iconView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 16),
				iconView.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
				iconView.widthAnchor.constraint(equalToConstant: 48),
				iconView.heightAnchor.constraint(equalToConstant: 48),
				
				nameLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 12),
				nameLabel.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 16),
				nameTrailingConstraint,
				
				descLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
				descLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
				descLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
				descLabel.bottomAnchor.constraint(lessThanOrEqualTo: cell.contentView.bottomAnchor,
												  constant: -16),
				
				button.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -16),
				button.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
				buttonWidthConstraint,
				button.heightAnchor.constraint(equalToConstant: 31)
			]
		)
	}
	
	@objc private func recommendedAppButtonTapped(_ sender: UIButton) {
		let appInfo = recommendedAppsData.apps[sender.tag]
		print("\(appInfo.appName) - \(appInfo.buttonType.title)")
	}
}

// MARK: - UICollectionViewDelegate
extension RecommendedAppsView: UICollectionViewDelegate {
	
} 
