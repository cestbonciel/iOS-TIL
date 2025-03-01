//
//  SubjectDemoView.swift
//  NoviceRxSwift
//
//  Created by Nat Kim on 3/2/25.
//

import UIKit

class SubjectDemoView: UIView {
    // MARK: - UI Elements
        
        // 버튼: 탭 시 이벤트 발생
        let actionButton: UIButton = {
            let button = UIButton(type: .system)
            button.setTitle("Tap Me!", for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.2)
            return button
        }()
        
        // 스와이프가 가능한 뷰
        let swipeView: UIView = {
            let view = UIView()
            view.backgroundColor = UIColor.systemGray.withAlphaComponent(0.3)
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        // MARK: - Initializers
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            setupView()
        }
        
        required init?(coder: NSCoder) {
            super.init(coder: coder)
            setupView()
        }
        
        // MARK: - Setup Methods
        
        private func setupView() {
            backgroundColor = .white
            addSubview(actionButton)
            addSubview(swipeView)
            setupConstraints()
        }
        
        private func setupConstraints() {
            // 버튼 제약조건: 상단 중앙에 위치
            NSLayoutConstraint.activate([
                actionButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
                actionButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                actionButton.widthAnchor.constraint(equalToConstant: 120),
                actionButton.heightAnchor.constraint(equalToConstant: 50)
            ])
            
            // 스와이프 뷰 제약조건: 버튼 아래에 위치
            NSLayoutConstraint.activate([
                swipeView.topAnchor.constraint(equalTo: actionButton.bottomAnchor, constant: 40),
                swipeView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                swipeView.widthAnchor.constraint(equalToConstant: 200),
                swipeView.heightAnchor.constraint(equalToConstant: 200)
            ])
        }
}

