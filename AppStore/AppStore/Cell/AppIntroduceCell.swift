//
//  AppIntroduceCell.swift
//  AppStore
//
//  Created by Nat Kim on 7/23/25.
//

import UIKit

class AppIntroduceCell: UICollectionViewCell, AppInfoDisplayable {
	
	@IBOutlet weak var appIntroContentView: UIView!
	@IBOutlet weak var subtitleLabel: UILabel!
	@IBOutlet weak var titleLabel: UILabel!
	
	@IBOutlet weak var appBgView: UIView!
	@IBOutlet weak var appIconImage: UIImageView!
	
	@IBOutlet weak var appCategory: UILabel!
	@IBOutlet weak var appNameTitle: UILabel!
	@IBOutlet weak var appPromoSentence: UILabel!
	@IBOutlet weak var downloadBtn: UIButton!
	
	var appIconImageView: UIImageView? { return appIconImage }
	var categoryLabel: UILabel? { return appCategory }
	var appNameLabel: UILabel? { return appNameTitle }
	var descriptionLabel: UILabel? { return appPromoSentence}
	var actionButton: UIButton? { return downloadBtn }
	var inAppPurchaseLabel: UILabel? { return nil }
	var containerView: UIView? { return appBgView }
	
	
	
	// MARK: - Properties
	private var gradientLayer: CAGradientLayer?
	private var currentDisplayInfo: AppDisplayInfo?
	
	override func awakeFromNib() {
		super.awakeFromNib()
		setupUI()
	}
	
	override func prepareForReuse() {
		super.prepareForReuse()
		gradientLayer?.removeFromSuperlayer()
		gradientLayer = nil
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		DispatchQueue.main.async { [weak self] in
			guard let self = self else { return }
			self.gradientLayer?.frame = self.appIntroContentView.bounds
		}
	}
	
	// MARK: - Setup
	private func setupUI() {
		appIntroContentView.layer.cornerRadius = 12
		appIntroContentView.clipsToBounds = true
		
		appIconImage.layer.cornerRadius = 12
		appIconImage.clipsToBounds = true
		
		if let currentFont = titleLabel.font {
			let descriptor = currentFont.fontDescriptor.withSymbolicTraits(.traitBold) ?? currentFont.fontDescriptor
			titleLabel.font = UIFont(descriptor: descriptor, size: currentFont.pointSize)
		}
		
		downloadBtn.layer.cornerRadius = downloadBtn.frame.height / 2
		downloadBtn.clipsToBounds = true
	}
	
	// MARK: - Configuration
	func configure(with model: AppIntroduce, styleConfig: StyleConfiguration = .automatic) {
		if let description = model.description {
			let lines = description.components(separatedBy: "\n")
			if lines.count >= 2 {
				subtitleLabel.text = lines[0]
				titleLabel.text = lines[1]
			} else {
				subtitleLabel.text = description
				titleLabel.text = model.title
			}
		} else {
			subtitleLabel.text = model.category
			titleLabel.text = model.title
		}
		
		// 그라디언트 설정
		setupGradient(with: model.gradientColors)
		
		let averageColor = calculateAverageColor(from: model.gradientColors)
		let displayInfo = AppDisplayInfo(
			appIcon: UIImage(named: model.appIconName),
			category: model.category,
			appName: model.title,
			description: model.subtitle,
			buttonType: model.buttonType,
			hasInAppPurchase: model.hasInAppPurchase,
			showInAppPurchaseInfo: model.showInAppPurchaseInfo,
			backgroundColor: averageColor
		)
		
		self.currentDisplayInfo = displayInfo
		configureAppInfo(with: displayInfo)
		
		if let containerColor = styleConfig.containerColor,
		   let buttonStyle = styleConfig.buttonStyle {
			setupBottomStyle(containerColor: containerColor, buttonStyle: buttonStyle)
		} else {
			let brightness = averageColor.brightness
			if brightness > 0.6 {
				setupBottomStyle(containerColor: UIColor.black.withAlphaComponent(0.15),
								 buttonStyle: .whiteTransparent)
			} else {
				setupBottomStyle(containerColor: UIColor.white.withAlphaComponent(0.5),
								 buttonStyle: .whiteTransparent)
			}
		}
	}
	
	private func setupGradient(with colors: [UIColor]) {
		gradientLayer?.removeFromSuperlayer()
		
		let gradient = CAGradientLayer()
		gradient.colors = colors.map { $0.cgColor }
		gradient.startPoint = CGPoint(x: 0, y: 0)
		gradient.endPoint = CGPoint(x: 1, y: 1)
		gradient.frame = appIntroContentView.bounds
		
		appIntroContentView.layer.insertSublayer(gradient, at: 0)
		self.gradientLayer = gradient
	}
	
	private func calculateAverageColor(from colors: [UIColor]) -> UIColor {
		guard !colors.isEmpty else { return .clear }
		
		var totalRed: CGFloat = 0
		var totalGreen: CGFloat = 0
		var totalBlue: CGFloat = 0
		var totalAlpha: CGFloat = 0
		
		for color in colors {
			var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
			color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
			
			totalRed += red
			totalGreen += green
			totalBlue += blue
			totalAlpha += alpha
		}
		
		let count = CGFloat(colors.count)
		return UIColor(
			red: totalRed / count,
			green: totalGreen / count,
			blue: totalBlue / count,
			alpha: totalAlpha / count
		)
	}
	
}
