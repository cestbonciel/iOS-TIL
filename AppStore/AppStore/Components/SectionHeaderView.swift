//
//  SectionHeaderView.swift
//  AppStore
//
//  Created by Nat Kim on 7/24/25.
//

import UIKit

class SectionHeaderView: UICollectionReusableView {
	// MARK: - Properties
	static let reuseIdentifier = "SectionHeaderView"
	
	private let subtitleLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.preferredFont(forTextStyle: .body)
		label.textColor = .secondaryLabel
		label.numberOfLines = 0
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	private let titleLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.preferredFont(forTextStyle: .title2)
		label.textColor = .label
		label.numberOfLines = 0
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	private let stackView: UIStackView = {
		let stack = UIStackView()
		stack.axis = .vertical
		stack.spacing = 2
		stack.translatesAutoresizingMaskIntoConstraints = false
		return stack
	}()
	
	// MARK: - Lifecycle
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupUI()
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		setupUI()
	}
	
	// MARK: - Setup
	private func setupUI() {
		backgroundColor = .clear
		
		stackView.addArrangedSubview(subtitleLabel)
		stackView.addArrangedSubview(titleLabel)
		
		addSubview(stackView)
		
		NSLayoutConstraint.activate([
			stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
			stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
			stackView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
			stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12)
		])
	}
	
	// MARK: - Configuration
	func configure(title: String, subtitle: String? = nil) {
		titleLabel.text = title
		
		if let currentFont = titleLabel.font {
			let descriptor = currentFont.fontDescriptor.withSymbolicTraits(.traitBold) ?? currentFont.fontDescriptor
			titleLabel.font = UIFont(descriptor: descriptor, size: currentFont.pointSize)
		}
		
		if let subtitle = subtitle, !subtitle.isEmpty {
			subtitleLabel.text = subtitle
			subtitleLabel.isHidden = false
		} else {
			subtitleLabel.isHidden = true
		}
	}
	
	// MARK: - Size Calculation
	static func estimatedSize(for title: String, subtitle: String? = nil, containerWidth: CGFloat) -> CGSize {
		let titleFont = UIFont.preferredFont(forTextStyle: .title3)
		let subtitleFont = UIFont.preferredFont(forTextStyle: .caption2)
		
		let textWidth = containerWidth - 40
		
		let titleHeight = title.boundingRect(
			with: CGSize(width: textWidth, height: .greatestFiniteMagnitude),
			options: [.usesLineFragmentOrigin, .usesFontLeading],
			attributes: [.font: titleFont],
			context: nil
		).height
		
		var subtitleHeight: CGFloat = 0
		if let subtitle = subtitle, !subtitle.isEmpty {
			subtitleHeight = subtitle.boundingRect(
				with: CGSize(width: textWidth, height: .greatestFiniteMagnitude),
				options: [.usesLineFragmentOrigin, .usesFontLeading],
				attributes: [.font: subtitleFont],
				context: nil
			).height + 2
		}
		
		let totalHeight = titleHeight + subtitleHeight + 28
		
		return CGSize(width: containerWidth, height: ceil(totalHeight))
	}
}
