//
//  TemuStyleCell.swift
//  AppStore
//
//  Created by Nat Kim on 7/25/25.
//

import UIKit

class TemuStyleCell: UICollectionViewCell, AppBottomInfoDisplayable {
	// MARK: - UI Components
	private let gradientBackgroundView = UIView()
	private let centerAppIconImageView = UIImageView()
	private let appTitleLabel = UILabel()
	private let adBadgeLabel = UILabel()
	private let descriptionLabel = UILabel()
	private var actionButton = UIButton()
	
	// MARK: - AppBottomInfoDisplayable Protocol
	var bottomContainerView: UIView? { return nil }
	var downloadButton: UIButton? { return actionButton }
	
	// MARK: - Properties
	private var gradientLayer: CAGradientLayer?
	
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
	
	override func prepareForReuse() {
		super.prepareForReuse()
		gradientLayer?.removeFromSuperlayer()
		gradientLayer = nil
		adBadgeLabel.isHidden = false
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		DispatchQueue.main.async { [weak self] in
			guard let self = self else { return }
			self.gradientLayer?.frame = self.gradientBackgroundView.bounds
		}
	}
	
	// MARK: - Setup
	private func setupUI() {
		contentView.layer.cornerRadius = 12
		contentView.clipsToBounds = true
		
		gradientBackgroundView.translatesAutoresizingMaskIntoConstraints = false
		contentView.addSubview(gradientBackgroundView)
		
		centerAppIconImageView.translatesAutoresizingMaskIntoConstraints = false
		centerAppIconImageView.contentMode = .scaleAspectFit
		centerAppIconImageView.layer.cornerRadius = 12
		centerAppIconImageView.clipsToBounds = true
		centerAppIconImageView.backgroundColor = .white.withAlphaComponent(0.1)
		contentView.addSubview(centerAppIconImageView)
		
		appTitleLabel.translatesAutoresizingMaskIntoConstraints = false
		appTitleLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
		appTitleLabel.textColor = .white
		appTitleLabel.numberOfLines = 1
		contentView.addSubview(appTitleLabel)
		
		adBadgeLabel.translatesAutoresizingMaskIntoConstraints = false
		adBadgeLabel.text = "광고"
		adBadgeLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
		adBadgeLabel.textColor = .white
		adBadgeLabel.backgroundColor = UIColor.systemBlue
		adBadgeLabel.textAlignment = .center
		adBadgeLabel.layer.cornerRadius = 4
		adBadgeLabel.clipsToBounds = true
		contentView.addSubview(adBadgeLabel)
		
		descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
		descriptionLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
		descriptionLabel.textColor = .white.withAlphaComponent(0.9)
		descriptionLabel.numberOfLines = 1
		contentView.addSubview(descriptionLabel)
		
		actionButton.translatesAutoresizingMaskIntoConstraints = false
		actionButton.setTitle("받기", for: .normal)
		actionButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
		actionButton.layer.cornerRadius = 14 // 버튼 높이(28)의 절반
		actionButton.clipsToBounds = true
		contentView.addSubview(actionButton)
		
		setupGradientBackground()
	}
	
	private func setupConstraints() {
		NSLayoutConstraint.activate([
			gradientBackgroundView.topAnchor.constraint(equalTo: contentView.topAnchor),
			gradientBackgroundView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
			gradientBackgroundView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
			gradientBackgroundView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
			
			centerAppIconImageView.widthAnchor.constraint(equalToConstant: 76),
			centerAppIconImageView.heightAnchor.constraint(equalToConstant: 76),
			centerAppIconImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
			centerAppIconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor,
															constant: -15),
			
			appTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
			appTitleLabel.bottomAnchor.constraint(equalTo: adBadgeLabel.topAnchor, constant: -4),
			appTitleLabel.trailingAnchor.constraint(lessThanOrEqualTo: actionButton.leadingAnchor,
													constant: -20),
			
			adBadgeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
			adBadgeLabel.bottomAnchor.constraint(equalTo: descriptionLabel.topAnchor, constant: -4),
			adBadgeLabel.widthAnchor.constraint(equalToConstant: 32),
			adBadgeLabel.heightAnchor.constraint(equalToConstant: 16),
			
			descriptionLabel.leadingAnchor.constraint(equalTo: adBadgeLabel.trailingAnchor,
													  constant: 8),
			descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
			descriptionLabel.trailingAnchor.constraint(lessThanOrEqualTo: actionButton.leadingAnchor,
													   constant: -20),
		
			actionButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
			actionButton.centerYAnchor.constraint(equalTo: descriptionLabel.centerYAnchor),
			actionButton.widthAnchor.constraint(equalToConstant: 60),
			actionButton.heightAnchor.constraint(equalToConstant: 28)
		])
	}
	
	private func setupGradientBackground() {
		let gradient = CAGradientLayer()
		gradient.colors = [
			UIColor(red: 1.0, green: 0.7, blue: 0.4, alpha: 1.0).cgColor,
			UIColor(red: 0.9, green: 0.5, blue: 0.2, alpha: 1.0).cgColor,
			UIColor(red: 0.7, green: 0.3, blue: 0.15, alpha: 1.0).cgColor
		]
		gradient.startPoint = CGPoint(x: 0, y: 0)
		gradient.endPoint = CGPoint(x: 0, y: 1)
		gradient.frame = gradientBackgroundView.bounds
		
		gradientBackgroundView.layer.insertSublayer(gradient, at: 0)
		self.gradientLayer = gradient
	}
	
	// MARK: - Configuration
	func configure(with model: TemuStyleModel) {
		centerAppIconImageView.image = UIImage(named: model.centerAppIconName)
		appTitleLabel.text = model.appTitle
		adBadgeLabel.isHidden = !model.hasAdBadge
		descriptionLabel.text = model.description
		
		actionButton.setTitle(model.buttonType.title, for: .normal)
		
		setupBottomStyle(containerColor: .clear, buttonStyle: .whiteTransparent)
	}
}
