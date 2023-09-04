//
//  ViewController.swift
//  CustomTableCell
//
//  Created by Seohyun Kim on 2023/09/04.
//

import UIKit

class ViewController: UIViewController {
	let movieName = "Suicide Squad"
	let movieImage: [UIImage] = [
		UIImage(named: "suic00")!,
		UIImage(named: "suic01")!,
		UIImage(named: "suic02")!,
		UIImage(named: "suic03")!,
		UIImage(named: "suic04")!,
		UIImage(named: "suic05")!,
	]
	
	let movieNote: [String] = ["movieScene1", "movieScene2", "movieScene3", "movieScene4", "movieScene5", "movieScene6"]
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.buildUI()
		
		tableView.delegate = self
		tableView.dataSource = self
	}
	
	private let tableView: UITableView = {
		let tableView = UITableView()
		tableView.backgroundColor = .systemBackground
		tableView.allowsSelection = true
		tableView.register(CustomCell.self, forCellReuseIdentifier: CustomCell.identifier)
		return tableView
	}()
	
	
	private func buildUI() {
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

