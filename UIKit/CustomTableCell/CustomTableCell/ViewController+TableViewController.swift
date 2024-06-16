//
//  ViewController+TableViewController.swift
//  CustomTableCell
//
//  Created by Seohyun Kim on 2023/09/04.
//

import UIKit

extension ViewController: UITableViewDataSource,UITableViewDelegate {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.movieImage.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomCell.identifier, for: indexPath) as? CustomCell else {
			fatalError("The tableView couldn't dequeue a CustomCell in ViewController.")
		}
		let image = self.movieImage[indexPath.row]
		let title = self.movieName
		let detailTitle = "\(self.movieNote[indexPath.row])번째의 설명"
//		detailTitle.text = "\(indexPath.row)번째의 설명"
		
		cell.configure(image: image, label: title, label2: detailTitle)
		return cell
	}
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		print("DEBUG PRINT:", indexPath.row)
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 200
	}
	
}
