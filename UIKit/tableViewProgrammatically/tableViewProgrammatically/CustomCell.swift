//
//  CustomCell.swift
//  tableViewProgrammatically
//
//  Created by Seohyun Kim on 2023/08/31.
//

import UIKit

class CustomCell: UITableViewCell {
	
	static let identifier = "CustomCell"
	
	private let myImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.contentMode = .scaleAspectFit
		imageView.image = UIImage(systemName: "questionmark")
		imageView.tintColor = .label
		return imageView
	}()
	
	private let myLabel: UILabel = {
		let label = UILabel()
		label.textAlignment = .left
		label.font = .systemFont(ofSize: 24, weight: .medium)
		label.text = "Error"
		
		return label
	}()
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		self.setupUI()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	public func configure(with image: UIImage, and label: String) {
		self.myImageView.image = image
		self.myLabel.text = label
	}
	
	private func setupUI() {
		self.contentView.addSubview(myImageView)
		self.contentView.addSubview(myLabel)
		
		myImageView.translatesAutoresizingMaskIntoConstraints = false
		myLabel.translatesAutoresizingMaskIntoConstraints = false
		
		NSLayoutConstraint.activate([
			myImageView.topAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.topAnchor),
			myImageView.bottomAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.bottomAnchor),
			myImageView.leadingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.leadingAnchor),
			myImageView.heightAnchor.constraint(equalToConstant: 90),
			myImageView.widthAnchor.constraint(equalToConstant: 90), 
			
			myLabel.leadingAnchor.constraint(equalTo: self.myImageView.trailingAnchor, constant: 24),
			myLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -12),
			myLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor),
			myLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
		])
	}
	
}
