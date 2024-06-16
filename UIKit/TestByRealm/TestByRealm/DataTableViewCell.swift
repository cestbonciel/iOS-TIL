//
//  DataTableViewCell.swift
//  TestByRealm
//
//  Created by Nat Kim on 2024/02/15.
//

import UIKit

protocol DataTableViewCellDelegate {
    func toggleCheckmark(indexPath: IndexPath)
}

class DataTableViewCell: UITableViewCell {
    static let identifier = "TodoItemCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(nameLabel)
        addSubview(categoryLabel)
        addSubview(checkmarkImage)
        
        let checkmarkImageWidth: CGFloat = 20.0
        let paddingVertical:  CGFloat = 30.0
        let paddingHorizontal: CGFloat = 20.0
        let spacing: CGFloat = 10.0
        
        nameLabel.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: paddingVertical, paddingLeft: paddingHorizontal, paddingBottom: 0, paddingRight: 0, width: frame.size.width - checkmarkImageWidth, height: 0, enableInsets: false)
        
        categoryLabel.anchor(top: nameLabel.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: spacing, paddingLeft: paddingHorizontal, paddingBottom: paddingVertical, paddingRight: 0, width: frame.size.width - checkmarkImageWidth, height: 0, enableInsets: false)
        
        checkmarkImage.anchor(top: topAnchor, left: nameLabel.rightAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: paddingVertical, paddingLeft: spacing, paddingBottom: paddingVertical, paddingRight: paddingHorizontal, width: checkmarkImageWidth, height: 0, enableInsets: false)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var data: Data? {
        didSet {
            nameLabel.text = data?.name
            categoryLabel.text = data?.category
            checkmarkImage.isHidden = data == nil ? true : !data!.isChecked
        }
    }
    
    private var nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .left
        label.lineBreakMode = .byCharWrapping
        return label
    }()
    
    private var categoryLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textAlignment = .left
        label.lineBreakMode = .byCharWrapping
        return label
    }()
    
    private var checkmarkImage: UIImageView = {
        let checkmarkImage = UIImage(systemName: "checkmark.diamond.fill")
        let imageView = UIImageView(image: checkmarkImage)
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    var getCheckmarkImage: UIImageView {
        get { checkmarkImage }
    }
    
    
}
