//
//  ViewController.swift
//  TableViewDemo
//
//  Created by Nat Kim on 2023/11/24.
//

import UIKit

class ViewController: UIViewController {

  @IBOutlet weak var tableView: UITableView!
  
  var strings: [String] = ["알림", "일반", "Wi-Fi", "집중모드"]
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.dataSource = self
    tableView.delegate = self
    
    tableView.register(MyTableViewCell.nib(), forCellReuseIdentifier: MyTableViewCell.identifier)
  }


}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let vc = storyboard.instantiateViewController(withIdentifier: "testVC")
    vc.navigationItem.title = strings[indexPath.row]
    navigationController?.pushViewController(vc, animated: true)
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return strings.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: MyTableViewCell.identifier, for: indexPath) as! MyTableViewCell
    cell.customTitleLabel.text = strings[indexPath.row]
    
    switch indexPath.row {
    case 0:
      cell.customButton.setImage(UIImage(systemName: "bell"), for: .normal)
    case 1:
      cell.customButton.setImage(UIImage(systemName: "gearshape.fill"), for: .normal)
      cell.accessoryType = .disclosureIndicator
    case 2:
      cell.customButton.setImage(UIImage(systemName: "wifi"), for: .normal)
      cell.accessoryType = .disclosureIndicator
    case 3:
      cell.customButton.setImage(UIImage(systemName: "moon.circle.fill"), for: .normal)
      cell.accessoryType = .disclosureIndicator
    default:
      ()
    }
    
    return cell
  }
}
