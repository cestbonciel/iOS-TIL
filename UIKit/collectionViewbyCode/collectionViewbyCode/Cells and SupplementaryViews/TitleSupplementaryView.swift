//
//  TitleSupplementaryView.swift
//  collectionViewbyCode
//
//  Created by Seohyun Kim on 2023/09/05.
//

import UIKit

class TitleSupplementaryView: UICollectionReusableView {
	let label = UILabel()
	static let reuseIdentifier = "title-supplementary-reuse-identifier"
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		configure()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}

extension TitleSupplementaryView {
	func configure() {
		addSubview(label)
		label.translatesAutoresizingMaskIntoConstraints = false
		label.adjustsFontForContentSizeCategory = true
		let inset = CGFloat(10)
		NSLayoutConstraint.activate([
			label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: inset),
			label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -inset),
			label.topAnchor.constraint(equalTo: topAnchor, constant: inset),
			label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -inset),
		])
		label.font = UIFont.preferredFont(forTextStyle: .title3)
	}
}
