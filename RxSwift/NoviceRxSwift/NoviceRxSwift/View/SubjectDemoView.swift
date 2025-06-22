//
//  SubjectDemoView.swift
//  NoviceRxSwift
//
//  Created by Nat Kim on 3/2/25.
//

import UIKit
import SnapKit

/// BehaviorSubject(닉네임), ReplaySubject(알림) UI
class SubjectDemoView: UIView {
    
    // BehaviorSubject (Nickname)
    let behaviorTitleLabel = UILabel()
    let behaviorTextField = UITextField()
    let behaviorSetButton = UIButton(type: .system)
    let behaviorSubscribeButton = UIButton(type: .system)
    let behaviorCurrentLabel = UILabel()
    
    // ReplaySubject (Notifications)
    let replayTitleLabel = UILabel()
    let replaySendButton = UIButton(type: .system)
    let replaySubscribeButton = UIButton(type: .system)
    let replayTextView = UITextView()
    
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
        
        // BehaviorSubject
        behaviorTitleLabel.text = "BehaviorSubject (Nickname)"
        behaviorTitleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        
        behaviorTextField.placeholder = "Enter nickname"
        behaviorTextField.borderStyle = .roundedRect
        
        behaviorSetButton.setTitle("Set Nickname", for: .normal)
        behaviorSubscribeButton.setTitle("Subscribe Nick", for: .normal)
        
        behaviorCurrentLabel.text = "Current Nickname: (no subscription yet)"
        behaviorCurrentLabel.numberOfLines = 0
        
        // ReplaySubject
        replayTitleLabel.text = "ReplaySubject (Last 2 Notifications)"
        replayTitleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        
        replaySendButton.setTitle("Send Notification", for: .normal)
        replaySubscribeButton.setTitle("Subscribe Notifications", for: .normal)
        
        replayTextView.isEditable = false
        replayTextView.backgroundColor = UIColor.systemGray6
        
        [
            behaviorTitleLabel,
            behaviorTextField,
            behaviorSetButton,
            behaviorSubscribeButton,
            behaviorCurrentLabel,
            replayTitleLabel,
            replaySendButton,
            replaySubscribeButton,
            replayTextView
        ].forEach { addSubview($0) }
    }
    
    private func setupConstraints() {
        let margin: CGFloat = 16
        
        // BehaviorSubject
        behaviorTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset(margin)
            make.trailing.equalToSuperview().inset(margin)
        }
        
        behaviorTextField.snp.makeConstraints { make in
            make.top.equalTo(behaviorTitleLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(margin)
            make.width.equalTo(120)
            make.height.equalTo(36)
        }
        
        behaviorSetButton.snp.makeConstraints { make in
            make.centerY.equalTo(behaviorTextField)
            make.leading.equalTo(behaviorTextField.snp.trailing).offset(8)
            make.width.equalTo(100)
        }
        
        behaviorSubscribeButton.snp.makeConstraints { make in
            make.centerY.equalTo(behaviorTextField)
            make.leading.equalTo(behaviorSetButton.snp.trailing).offset(8)
            make.width.equalTo(120)
            make.trailing.lessThanOrEqualToSuperview().inset(margin)
        }
        
        behaviorCurrentLabel.snp.makeConstraints { make in
            make.top.equalTo(behaviorTextField.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(margin)
            make.trailing.equalToSuperview().inset(margin)
        }
        
        // ReplaySubject
        replayTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(behaviorCurrentLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(margin)
            make.trailing.equalToSuperview().inset(margin)
        }
        
        replaySendButton.snp.makeConstraints { make in
            make.top.equalTo(replayTitleLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(margin)
            make.width.equalTo(140)
            make.height.equalTo(36)
        }
        
        replaySubscribeButton.snp.makeConstraints { make in
            make.centerY.equalTo(replaySendButton)
            make.leading.equalTo(replaySendButton.snp.trailing).offset(8)
            make.width.equalTo(160)
            make.trailing.lessThanOrEqualToSuperview().inset(margin)
        }
        
        replayTextView.snp.makeConstraints { make in
            make.top.equalTo(replaySendButton.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(margin)
            make.trailing.equalToSuperview().inset(margin)
            make.height.equalTo(100)
            make.bottom.lessThanOrEqualToSuperview().offset(-20)
        }
    }
}
