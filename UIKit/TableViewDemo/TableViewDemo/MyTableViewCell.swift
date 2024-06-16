//
//  MyTableViewCell.swift
//  TableViewDemo
//
//  Created by Nat Kim on 2023/11/24.
//

import UIKit

class MyTableViewCell: UITableViewCell {
  
  @IBOutlet weak var customTitleLabel: UILabel!
  @IBOutlet weak var customButton: UIButton!
  static let identifier = "MyTableViewCell"
  
  static func nib() -> UINib {
    return UINib(nibName: "MyTableViewCell", bundle: nil)
  }
  override func awakeFromNib() {
    super.awakeFromNib()
    selectionStyle = .none
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}
