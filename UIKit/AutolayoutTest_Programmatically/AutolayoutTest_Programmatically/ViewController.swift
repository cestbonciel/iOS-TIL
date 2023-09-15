//
//  ViewController.swift
//  AutolayoutTest_Programmatically
//
//  Created by Seohyun Kim on 2023/09/15.
//

import UIKit

class ViewController: UIViewController {
	lazy var button: UIButton = {
		let button = UIButton()
		button.setTitle("00:00", for: .normal)
		let config = UIImage.SymbolConfiguration(pointSize: 16, weight: .regular, scale: .default)
		button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
		button.tintColor = .black
		
		button.layer.borderColor = UIColor.yellow.cgColor
		button.layer.borderWidth = 2
		button.layer.cornerRadius = 10
		button.translatesAutoresizingMaskIntoConstraints = false
		return button
	}()
	
	lazy var button2: UIButton = {
		let button = UIButton()
		button.setTitle("01:00", for: .normal)
		button.tintColor = .black
		button.titleLabel?.font = .systemFont(ofSize: 24)
		return button
	}()
	
	lazy var progressView: UIProgressView = {
		let progressView = UIProgressView(progressViewStyle: .bar)
		progressView.setProgress(0.5, animated: true)
		progressView.trackTintColor = UIColor.systemGray6
		progressView.progressTintColor = UIColor.systemGreen
		progressView.translatesAutoresizingMaskIntoConstraints = false
//		progressView.alpha = 0.4
		return progressView
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupUI()
	}

	private func setupUI() {
		self.view.backgroundColor = .systemIndigo
		
		self.view.addSubview(button)
		self.view.addSubview(button2)
		self.view.addSubview(progressView)
		
		NSLayoutConstraint.activate([
//			button.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100),
			button.leadingAnchor.constraint(equalTo: progressView.leadingAnchor, constant: 0),
//			button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			button.centerYAnchor.constraint(equalTo: progressView.centerYAnchor),
			
			progressView.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor, constant: 150),
			progressView.leadingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.leadingAnchor,constant: 30),
			progressView.heightAnchor.constraint(equalToConstant: 32),
			progressView.widthAnchor.constraint(equalToConstant: 300),
//
			
		])
//		객체가 앞에오게
		view.bringSubviewToFront(button)
		
	}
	
}

