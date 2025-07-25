//
//  AppInfoDisplayable.swift
//  AppStore
//
//  Created by Nat Kim on 7/24/25.
//

import Foundation
import UIKit

protocol AppInfoDisplayable: AppBottomInfoDisplayable {
	var appIconImageView: UIImageView? { get }
	var categoryLabel: UILabel? { get }
	var appNameLabel: UILabel? { get }
	var descriptionLabel: UILabel? { get }
	var actionButton: UIButton? { get }
	var inAppPurchaseLabel: UILabel? { get }
	var containerView: UIView? { get } 
	
	func configureAppInfo(with info: AppDisplayInfo)
}

extension AppInfoDisplayable {
	var bottomContainerView: UIView? { return containerView }
	var downloadButton: UIButton? { return actionButton }
	
	func configureAppInfo(with info: AppDisplayInfo) {
		if let iconView = appIconImageView {
			iconView.layer.cornerRadius = 12
			iconView.clipsToBounds = true
			
			if let image = info.appIcon {
				iconView.image = image
				iconView.backgroundColor = .clear
			} else {
				iconView.image = nil
				iconView.backgroundColor = .white.withAlphaComponent(0.2)
			}
		}
		
		categoryLabel?.text = info.category
		categoryLabel?.textColor = info.textColor
		
		appNameLabel?.text = info.appName
		appNameLabel?.textColor = info.textColor
		
		descriptionLabel?.text = info.description
		descriptionLabel?.textColor = info.textColor
		
		actionButton?.setTitle(info.buttonType.title, for: .normal)
		
		if let purchaseLabel = inAppPurchaseLabel {
			if info.hasInAppPurchase && info.showInAppPurchaseInfo {
				purchaseLabel.text = "앱 내 구입"
				purchaseLabel.textColor = info.textColor.withAlphaComponent(0.7)
				purchaseLabel.isHidden = false
			} else {
				purchaseLabel.isHidden = true
			}
		}
	}
}
