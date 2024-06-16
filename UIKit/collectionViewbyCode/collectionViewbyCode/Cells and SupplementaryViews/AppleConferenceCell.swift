//
//  AppleConferenceCell.swift
//  collectionViewbyCode
//
//  Created by Seohyun Kim on 2023/09/05.
//

import UIKit

class AppleConferenceCell: UICollectionViewCell {
	
	static let reuseIdentifier = "video-cell-reuse-identifier"
	
	let imageView = UIImageView()
	let titleLabel = UILabel()
	let categoryLabel = UILabel()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		configure()
	}
	required init?(coder: NSCoder) {
		fatalError()
	}
}

extension AppleConferenceCell {
	func configure() {
		imageView.translatesAutoresizingMaskIntoConstraints = false
		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		categoryLabel.translatesAutoresizingMaskIntoConstraints = false
		
		contentView.addSubview(imageView)
		contentView.addSubview(titleLabel)
		contentView.addSubview(categoryLabel)
		
		titleLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
		titleLabel.adjustsFontForContentSizeCategory = true
		categoryLabel.font = UIFont.preferredFont(forTextStyle: .caption2)
		categoryLabel.adjustsFontForContentSizeCategory = true
		categoryLabel.textColor = .placeholderText
		
		imageView.layer.borderColor = UIColor.gray.cgColor
		imageView.layer.borderWidth = 1
		imageView.layer.cornerRadius = 10
		imageView.backgroundColor = UIColor.melon
		
		let spacing = CGFloat(20)
		NSLayoutConstraint.activate([
			imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
			imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
			imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
			
			titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: spacing),
			titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
			titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
			
			categoryLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
			categoryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
			categoryLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
			categoryLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
		])
	}
}
