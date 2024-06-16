//
//  CustomCell.swift
//  CustomTableCell
//
//  Created by Seohyun Kim on 2023/09/04.
//

import UIKit

class CustomCell: UITableViewCell {
	static let identifier = "CustomCell"
	
	lazy var customImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.contentMode = .scaleAspectFit
		imageView.image = UIImage(systemName: "photo.fill")
		imageView.tintColor = .label
		return imageView
	}()
	
	lazy var customLabel: UILabel = {
		let label = UILabel()
		label.textAlignment = .center
		label.font = .systemFont(ofSize: 16, weight: .regular)
		label.text = "Suicide Squad Image"
		
		return label
	}()
	
	lazy var customDetailLabel: UILabel = {
		let label = UILabel()
		label.textAlignment = .center
		label.font = .preferredFont(forTextStyle: .subheadline)
		label.textColor = .darkGray
		label.text = "Error"
		return label
	}()
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		self.buildUI()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	public func configure(image customImage: UIImage, label customLabel: String, label2 customDetailLabel: String) {
		self.customImageView.image = customImage
		self.customLabel.text = customLabel
		self.customDetailLabel.text = customDetailLabel
	}
	
	private func buildUI() {
		self.contentView.addSubview(customImageView)
		self.contentView.addSubview(customLabel)
		self.contentView.addSubview(customDetailLabel)
		
		customImageView.translatesAutoresizingMaskIntoConstraints = false
		customLabel.translatesAutoresizingMaskIntoConstraints = false
		customDetailLabel.translatesAutoresizingMaskIntoConstraints = false
		
		NSLayoutConstraint.activate([
			customImageView.topAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.topAnchor),
			customImageView.bottomAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.bottomAnchor),
			customImageView.leadingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.leadingAnchor),
			customImageView.widthAnchor.constraint(equalToConstant: 100),
			customImageView.heightAnchor.constraint(equalToConstant: 100),
			
			customLabel.leadingAnchor.constraint(equalTo: self.customImageView.trailingAnchor, constant: 24),
			customLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -12),
			customLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor),
			customLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
			
			customDetailLabel.leadingAnchor.constraint(equalTo: self.customImageView.trailingAnchor, constant: 24),
			customDetailLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -12),
			customDetailLabel.topAnchor.constraint(equalTo: self.customLabel.topAnchor, constant: 56),
			customDetailLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
		])
	}
	
	
}

