//
//  TodayHeaderView.swift
//  AppStore
//
//  Created by Nat Kim on 7/24/25.
//

import UIKit

class TodayHeaderView: UIView {
	
	// MARK: - UI Components
	private let headerStackView = UIStackView()
	private let todayLabel = UILabel()
	private let dateLabel = UILabel()
	private let profileImageView = UIImageView()
	
	// MARK: - Initialization
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupUI()
		setupConstraints()
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		setupUI()
		setupConstraints()
	}
	
	// MARK: - Setup
	private func setupUI() {
		backgroundColor = .clear
		
		todayLabel.text = "투데이"
		let largeTitleDescriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .largeTitle)
		todayLabel.font = UIFont(descriptor: largeTitleDescriptor.withSymbolicTraits(.traitBold) ?? largeTitleDescriptor, size: 0)
		todayLabel.adjustsFontForContentSizeCategory = true
		todayLabel.textColor = .label
		
		let formatter = DateFormatter()
		formatter.locale = Locale(identifier: "ko_KR")
		formatter.dateFormat = "M월 d일"
		dateLabel.text = formatter.string(from: Date())
		let title3Descriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .title3)
		dateLabel.font = UIFont(descriptor: title3Descriptor.withSymbolicTraits(.traitBold) ?? title3Descriptor, size: 0)
		dateLabel.adjustsFontForContentSizeCategory = true
		dateLabel.textColor = .secondaryLabel
		
		headerStackView.axis = .horizontal
		headerStackView.alignment = .lastBaseline
		headerStackView.distribution = .fill
		headerStackView.spacing = 8
		headerStackView.translatesAutoresizingMaskIntoConstraints = false
		
		headerStackView.addArrangedSubview(todayLabel)
		headerStackView.addArrangedSubview(dateLabel)
		
		profileImageView.image = UIImage(named: "user2")
		profileImageView.contentMode = .scaleAspectFit
		profileImageView.translatesAutoresizingMaskIntoConstraints = false
		addSubview(headerStackView)
		addSubview(profileImageView)
	}
	
	private func setupConstraints() {
		NSLayoutConstraint.activate([
			// Header StackView
			headerStackView.topAnchor.constraint(equalTo: topAnchor),
			headerStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
			headerStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
			
			// Profile Image
			profileImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
			profileImageView.bottomAnchor.constraint(equalTo: headerStackView.bottomAnchor),
			profileImageView.widthAnchor.constraint(equalToConstant: 32),
			profileImageView.heightAnchor.constraint(equalToConstant: 32)
		])
	}
} 
