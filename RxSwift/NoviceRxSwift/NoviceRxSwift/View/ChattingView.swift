//
//  ChattingView.swift
//  NoviceRxSwift
//
//  Created by Nat Kim on 3/2/25.
//

import UIKit
import SnapKit

/// PublishSubject(채팅) UI
class ChattingView: UIView {
    
    let titleLabel = UILabel()
    let textField = UITextField()
    let sendButton = UIButton(type: .system)
    let subscribeButton = UIButton(type: .system)
    let textView = UITextView()
    
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
    
    private func setupUI() {
        backgroundColor = .white
        
        titleLabel.text = "PublishSubject (Chat Messages)"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        
        textField.placeholder = "Enter chat..."
        textField.borderStyle = .roundedRect
        
        sendButton.setTitle("Send Chat", for: .normal)
        subscribeButton.setTitle("Subscribe Chat", for: .normal)
        
        textView.isEditable = false
        textView.backgroundColor = UIColor.systemGray6
        
        [titleLabel, textField, sendButton, subscribeButton, textView].forEach {
            addSubview($0)
        }
    }
    
    private func setupConstraints() {
        let margin: CGFloat = 16
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset(margin)
            make.trailing.equalToSuperview().inset(margin)
        }
        
        textField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(margin)
            make.width.equalTo(120)
            make.height.equalTo(36)
        }
        
        sendButton.snp.makeConstraints { make in
            make.centerY.equalTo(textField)
            make.leading.equalTo(textField.snp.trailing).offset(8)
            make.width.equalTo(100)
        }
        
        subscribeButton.snp.makeConstraints { make in
            make.centerY.equalTo(textField)
            make.leading.equalTo(sendButton.snp.trailing).offset(8)
            make.width.equalTo(120)
            make.trailing.lessThanOrEqualToSuperview().inset(margin)
        }
        
        textView.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(margin)
            make.trailing.equalToSuperview().inset(margin)
            make.height.equalTo(100)
            make.bottom.equalToSuperview().inset(0)
        }
    }
}
