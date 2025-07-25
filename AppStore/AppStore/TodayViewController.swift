//
//  TodayViewController.swift
//  AppStore
//
//  Created by Nat Kim on 7/22/25.
//
import UIKit

extension UIView {
	func asImage() -> UIImage {
		let renderer = UIGraphicsImageRenderer(bounds: bounds)
		return renderer.image { rendererContext in
			layer.render(in: rendererContext.cgContext)
		}
	}
}

class TodayViewController: UIViewController {
	
	// MARK: - UI Components
	private let scrollView = UIScrollView()
	private let contentView = UIView()
	private let headerView = TodayHeaderView()
	private var angryBirdCollectionView = UICollectionView(
		frame: .zero,
		collectionViewLayout: UICollectionViewFlowLayout()
	)
	private var chatGPTCollectionView = UICollectionView(
		frame: .zero,
		collectionViewLayout: UICollectionViewFlowLayout()
	)
	private var temuStyleCell: TemuStyleCell!
	private var recommendedAppsView: RecommendedAppsView!
	
	private var angryBirdDataSource: UICollectionViewDiffableDataSource<TodaySection, TodayItem>!
	private var chatGPTDataSource: UICollectionViewDiffableDataSource<TodaySection, TodayItem>!
	private var robloxDataSource: UICollectionViewDiffableDataSource<TodaySection, TodayItem>!
	
	// MARK: - Properties
	private var chatGPTData: FeaturedAppModel = FeaturedAppModel.chatGPTSample
	private var appIntroduceData: [AppIntroduce] = AppIntroduce.sampleData
	private var temuData: TemuStyleModel = TemuStyleModel.sampleData
	private var recommendedAppsData: RecommendedAppsModel = RecommendedAppsModel.sampleData
	private var essentialAppsView: RecommendedAppsView!
	private var essentialAppsData: RecommendedAppsModel = RecommendedAppsModel.essentialAppsData
	private var robloxCollectionView = UICollectionView(
		frame: .zero,
		collectionViewLayout: UICollectionViewFlowLayout()
	)
	private var robloxData: FeaturedAppModel = FeaturedAppModel.robloxSample
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupScrollView()
		setupAngryBirdCollectionView()
		setupChatGPTCollectionView()
		setupRobloxCollectionView()
		setupDataSources()
		setupTemuCell()
		setupRecommendedAppsView()
		setupEssentialAppsView()
		setupConstraints()
		loadData()
	}
	
	// MARK: - Setup
	private func setupScrollView() {
		scrollView.translatesAutoresizingMaskIntoConstraints = false
		scrollView.showsVerticalScrollIndicator = true
		scrollView.delaysContentTouches = false
		scrollView.canCancelContentTouches = true
		
		contentView.translatesAutoresizingMaskIntoConstraints = false
		
		view.addSubview(scrollView)
		scrollView.addSubview(contentView)
		
		headerView.translatesAutoresizingMaskIntoConstraints = false
		contentView.addSubview(headerView)
	}
	
	private func setupAngryBirdCollectionView() {
		let layout = createAppIntroduceLayout()
		angryBirdCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
		
		angryBirdCollectionView.translatesAutoresizingMaskIntoConstraints = false
		angryBirdCollectionView.backgroundColor = .clear
		angryBirdCollectionView.showsVerticalScrollIndicator = false
		angryBirdCollectionView.isScrollEnabled = false
		
		contentView.addSubview(angryBirdCollectionView)
	}
	
	private func setupChatGPTCollectionView() {
		let layout = createChatGPTLayout()
		chatGPTCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
		
		chatGPTCollectionView.translatesAutoresizingMaskIntoConstraints = false
		chatGPTCollectionView.backgroundColor = .clear
		chatGPTCollectionView.showsVerticalScrollIndicator = false
		chatGPTCollectionView.isScrollEnabled = false
		
		contentView.addSubview(chatGPTCollectionView)
	}
	
	private func setupEssentialAppsView() {
		essentialAppsView = RecommendedAppsView(data: essentialAppsData)
		essentialAppsView.translatesAutoresizingMaskIntoConstraints = false
		contentView.addSubview(essentialAppsView)
	}
	
	private func createAppIntroduceLayout() -> UICollectionViewLayout {
		let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
			return self.createAppIntroduceSection()
		}
		return layout
	}
	
	private func createChatGPTLayout() -> UICollectionViewLayout {
		let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
			return self.createFeaturedAppSection()
		}
		return layout
	}
	
	private func createAppIntroduceSection() -> NSCollectionLayoutSection {
		let itemSize = NSCollectionLayoutSize(
			widthDimension: .fractionalWidth(1.0),
			heightDimension: .absolute(415)
		)
		let item = NSCollectionLayoutItem(layoutSize: itemSize)
		
		let groupSize = NSCollectionLayoutSize(
			widthDimension: .fractionalWidth(1.0),
			heightDimension: .absolute(415)
		)
		let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
		
		let section = NSCollectionLayoutSection(group: group)
		section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 20, trailing: 20)
		
		return section
	}
	
	private func createFeaturedAppSection() -> NSCollectionLayoutSection {
		let itemSize = NSCollectionLayoutSize(
			widthDimension: .fractionalWidth(1.0),
			heightDimension: .absolute(415)
		)
		let item = NSCollectionLayoutItem(layoutSize: itemSize)
		
		let groupSize = NSCollectionLayoutSize(
			widthDimension: .fractionalWidth(1.0),
			heightDimension: .absolute(415)
		)
		let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
		
		let section = NSCollectionLayoutSection(group: group)
		section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
		
		let headerSize = NSCollectionLayoutSize(
			widthDimension: .fractionalWidth(1.0),
			heightDimension: .estimated(80)
		)
		let header = NSCollectionLayoutBoundarySupplementaryItem(
			layoutSize: headerSize,
			elementKind: UICollectionView.elementKindSectionHeader,
			alignment: .top
		)
		section.boundarySupplementaryItems = [header]
		
		return section
	}
	
	private func setupTemuCell() {
		temuStyleCell = TemuStyleCell(frame: .zero)
		temuStyleCell.translatesAutoresizingMaskIntoConstraints = false
		temuStyleCell.configure(with: temuData)
		
		contentView.addSubview(temuStyleCell)
	}
	
	private func setupRecommendedAppsView() {
		recommendedAppsView = RecommendedAppsView(data: recommendedAppsData)
		recommendedAppsView.translatesAutoresizingMaskIntoConstraints = false
		contentView.addSubview(recommendedAppsView)
	}
	
	private func setupDataSources() {
		let nib = UINib(nibName: "AppIntroduceCell", bundle: nil)
		angryBirdCollectionView.register(nib, forCellWithReuseIdentifier: "AppIntroduceCell")
		chatGPTCollectionView.register(nib, forCellWithReuseIdentifier: "AppIntroduceCell")
		robloxCollectionView.register(nib, forCellWithReuseIdentifier: "AppIntroduceCell")
		
		let headerRegistration = UICollectionView.SupplementaryRegistration<SectionHeaderView>(
			elementKind: UICollectionView.elementKindSectionHeader
		) { supplementaryView, elementKind, indexPath in
			let section = TodaySection.chatGPT
			if let title = section.headerTitle, let subtitle = section.headerSubtitle {
				supplementaryView.configure(title: title, subtitle: subtitle)
				supplementaryView.isHidden = false
			} else {
				supplementaryView.isHidden = true
			}
		}
		
		angryBirdDataSource = UICollectionViewDiffableDataSource<TodaySection, TodayItem>(
			collectionView: angryBirdCollectionView
		) { collectionView, indexPath, item in
			switch item {
			case .featuredApp(let featuredApp):
				guard let cell = collectionView.dequeueReusableCell(
					withReuseIdentifier: "AppIntroduceCell",
					for: indexPath
				) as? AppIntroduceCell else {
					return UICollectionViewCell()
				}
				let appIntroduce = featuredApp.toAppIntroduce()
				cell.configure(with: appIntroduce, styleConfig: .automatic)
				return cell
			case .temu, .recommendedApps:
				return UICollectionViewCell()
			}
		}
		
		chatGPTDataSource = UICollectionViewDiffableDataSource<TodaySection, TodayItem>(
			collectionView: chatGPTCollectionView
		) { collectionView, indexPath, item in
			switch item {
			case .featuredApp(let featuredApp):
				guard let cell = collectionView.dequeueReusableCell(
					withReuseIdentifier: "AppIntroduceCell",
					for: indexPath
				) as? AppIntroduceCell else {
					return UICollectionViewCell()
				}
				let appIntroduce = featuredApp.toAppIntroduce()
				cell.configure(with: appIntroduce, styleConfig: .chatGPT)
				return cell
			case .temu, .recommendedApps:
				return UICollectionViewCell()
			}
		}
		
		// ChatGPT Supplementary view provider
		chatGPTDataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
			return collectionView.dequeueConfiguredReusableSupplementary(
				using: headerRegistration,
				for: indexPath
			)
		}
		
		let robloxHeaderRegistration = UICollectionView.SupplementaryRegistration<SectionHeaderView>(
			elementKind: UICollectionView.elementKindSectionHeader
		) { supplementaryView, elementKind, indexPath in
			let section = TodaySection.roblox
			if let title = section.headerTitle, let subtitle = section.headerSubtitle {
				supplementaryView.configure(title: title, subtitle: subtitle)
				supplementaryView.isHidden = false
			} else {
				supplementaryView.isHidden = true
			}
		}
		
		robloxDataSource = UICollectionViewDiffableDataSource<TodaySection, TodayItem>(
			collectionView: robloxCollectionView
		) { collectionView, indexPath, item in
			switch item {
			case .featuredApp(let featuredApp):
				guard let cell = collectionView.dequeueReusableCell(
					withReuseIdentifier: "AppIntroduceCell",
					for: indexPath
				) as? AppIntroduceCell else {
					return UICollectionViewCell()
				}
				let appIntroduce = featuredApp.toAppIntroduce()
				cell.configure(with: appIntroduce, styleConfig: .chatGPT)
				return cell
			case .temu, .recommendedApps:
				return UICollectionViewCell()
			}
		}
		
		robloxCollectionView.dataSource = robloxDataSource
		
		// Roblox Supplementary view provider
		robloxDataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
			return collectionView.dequeueConfiguredReusableSupplementary(
				using: robloxHeaderRegistration,
				for: indexPath
			)
		}
	}
	
	private func setupRobloxCollectionView() {
		let layout = createRobloxLayout()
		robloxCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
		
		robloxCollectionView.translatesAutoresizingMaskIntoConstraints = false
		robloxCollectionView.showsVerticalScrollIndicator = false
		robloxCollectionView.isScrollEnabled = false
		
		contentView.addSubview(robloxCollectionView)
	}

	private func createRobloxLayout() -> UICollectionViewLayout {
		let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
			return self.createRobloxSection()
		}
		return layout
	}

	private func createRobloxSection() -> NSCollectionLayoutSection {
		let itemSize = NSCollectionLayoutSize(
			widthDimension: .fractionalWidth(1.0),
			heightDimension: .absolute(415)
		)
		let item = NSCollectionLayoutItem(layoutSize: itemSize)
		
		let groupSize = NSCollectionLayoutSize(
			widthDimension: .fractionalWidth(1.0),
			heightDimension: .absolute(415)
		)
		let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
		
		let section = NSCollectionLayoutSection(group: group)
		section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
		
		let headerSize = NSCollectionLayoutSize(
			widthDimension: .fractionalWidth(1.0),
			heightDimension: .estimated(80)
		)
		let header = NSCollectionLayoutBoundarySupplementaryItem(
			layoutSize: headerSize,
			elementKind: UICollectionView.elementKindSectionHeader,
			alignment: .top
		)
		section.boundarySupplementaryItems = [header]
		
		return section
	}
	
	private func loadData() {
		var angryBirdSnapshot = NSDiffableDataSourceSnapshot<TodaySection, TodayItem>()
		angryBirdSnapshot.appendSections([.appIntroduce])
		let appItems = appIntroduceData.map { appIntroduce in
			let featuredApp = FeaturedAppModel(
				id: UUID().uuidString,
				category: appIntroduce.category,
				title: appIntroduce.title,
				subtitle: appIntroduce.subtitle,
				description: appIntroduce.description,
				appIconName: appIntroduce.appIconName,
				buttonType: appIntroduce.buttonType,
				hasInAppPurchase: appIntroduce.hasInAppPurchase,
				showInAppPurchaseInfo: appIntroduce.showInAppPurchaseInfo,
				gradientColors: appIntroduce.gradientColors
			)
			return TodayItem.featuredApp(featuredApp)
		}
		angryBirdSnapshot.appendItems(appItems, toSection: .appIntroduce)
		angryBirdDataSource.apply(angryBirdSnapshot, animatingDifferences: false)
		
		var chatGPTSnapshot = NSDiffableDataSourceSnapshot<TodaySection, TodayItem>()
		chatGPTSnapshot.appendSections([.chatGPT])
		chatGPTSnapshot.appendItems([.featuredApp(chatGPTData)], toSection: .chatGPT)
		chatGPTDataSource.apply(chatGPTSnapshot, animatingDifferences: false)

		var robloxSnapshot = NSDiffableDataSourceSnapshot<TodaySection, TodayItem>()
		robloxSnapshot.appendSections([.roblox])
		robloxSnapshot.appendItems([.featuredApp(robloxData)], toSection: .roblox)
		robloxDataSource.apply(robloxSnapshot, animatingDifferences: false)
	}
	
	
	private func setupConstraints() {
		NSLayoutConstraint.activate([
			// ScrollView
			scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
			
			// ContentView
			contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
			contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
			contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
			contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
			contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
			
			// 1. Header View (투데이, 날짜, 프로필)
			headerView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 8),
			headerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
			headerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
			
			// 2. AngryBird CollectionView (앵그리버드)
			angryBirdCollectionView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 20),
			angryBirdCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
			angryBirdCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
			angryBirdCollectionView.heightAnchor.constraint(equalToConstant: 415),
			
			// 3. TemuStyleCell (테무 앱 광고)
			temuStyleCell.topAnchor.constraint(equalTo: angryBirdCollectionView.bottomAnchor, constant: 20),
			temuStyleCell.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
			temuStyleCell.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
			temuStyleCell.heightAnchor.constraint(equalToConstant: 154),
			
			// 4. RecommendedAppsView (모두에게 사랑받는 앱 리스트)
			recommendedAppsView.topAnchor.constraint(equalTo: temuStyleCell.bottomAnchor, constant: 20),
			recommendedAppsView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
			recommendedAppsView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
			
			// 5. ChatGPT CollectionView (ChatGPT - 헤더 포함)
			chatGPTCollectionView.topAnchor.constraint(equalTo: recommendedAppsView.bottomAnchor, constant: 20),
			chatGPTCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
			chatGPTCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
			chatGPTCollectionView.heightAnchor.constraint(equalToConstant: 495),
			
			// 6. 필수 앱
			essentialAppsView.topAnchor.constraint(equalTo: chatGPTCollectionView.bottomAnchor, constant: 20),
			essentialAppsView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
			essentialAppsView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
			// 7. 로블록스 게임앱
			robloxCollectionView.topAnchor.constraint(equalTo: essentialAppsView.bottomAnchor, constant: 20),
			robloxCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
			robloxCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
			robloxCollectionView.heightAnchor.constraint(equalToConstant: 495),
			
			// TODO: ContentView 넣을 때마다 수정하기
			contentView.bottomAnchor.constraint(equalTo: robloxCollectionView.bottomAnchor, constant: 50)
		])
	}
	
	// MARK: - Actions
	@objc private func profileButtonTapped() {
		print("Profile button tapped")
	}
}
