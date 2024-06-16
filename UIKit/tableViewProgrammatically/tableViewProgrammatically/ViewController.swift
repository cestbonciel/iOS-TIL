//
//  ViewController.swift
//  tableViewProgrammatically
//
//  Created by Seohyun Kim on 2023/08/31.
//

import UIKit

class ViewController: UIViewController {
	// MARK: Variables
	let images: [UIImage] = [
		UIImage(named: "img1")!,
		UIImage(named: "img2")!,
		UIImage(named: "img3")!,
		UIImage(named: "img4")!,
		UIImage(named: "img5")!,
	]
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.setupUI()
		
		tableView.delegate = self
		tableView.dataSource = self
	}
	// MARK: UI Components
	private let tableView: UITableView = {
		let tableView = UITableView()
		tableView.backgroundColor = .systemBackground
		tableView.allowsSelection = true
		tableView.register(CustomCell.self, forCellReuseIdentifier: CustomCell.identifier)
		return tableView
	}()
	
	// MARK: Setup UI
	
	private func setupUI() {
		self.view.backgroundColor = .systemBlue
		
		self.view.addSubview(tableView)
		tableView.translatesAutoresizingMaskIntoConstraints = false
		
		NSLayoutConstraint.activate([
			tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
			tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
			tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
			tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
		])
	}
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.images.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomCell.identifier, for: indexPath) as? CustomCell else {
			fatalError("The tableView could not dequeue a CustomCell in ViewController.")
		}
		let image = self.images[indexPath.row]
		cell.configure(with: image, and: indexPath.row.description)
		return cell
		
	}
	
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 112.5
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		print("DEBUG PRINT:", indexPath.row)
	}
}
