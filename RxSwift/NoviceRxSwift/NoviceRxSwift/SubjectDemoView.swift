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
    
    // 이미지뷰: 버튼 탭 시 랜덤 이미지가 표시됨
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.backgroundColor = .lightGray
        return iv
    }()
    
    // UILabel1: 버튼 탭 관련 메시지 출력
    let label1: UILabel = {
        let label = UILabel()
        label.text = "Label1"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // 스와이프가 가능한 뷰: 스와이프 시 배경색 변경됨
    let swipeView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemGray.withAlphaComponent(0.3)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // UILabel2: 스와이프 관련 메시지(랜덤 컬러 hex 코드) 출력
    let label2: UILabel = {
        let label = UILabel()
        label.text = "Label2"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
        // Add subviews
        addSubview(actionButton)
        addSubview(imageView)
        addSubview(label1)
        addSubview(swipeView)
        addSubview(label2)
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
        
        // 이미지뷰: 버튼 아래, 가운데 정렬, 200x200 크기
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: actionButton.bottomAnchor, constant: 20),
            imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 200),
            imageView.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        // UILabel1: 이미지뷰 아래에 위치
        NSLayoutConstraint.activate([
            label1.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            label1.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            label1.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            label1.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        // swipeView: UILabel1 아래에 위치, 200x200 크기
        NSLayoutConstraint.activate([
            swipeView.topAnchor.constraint(equalTo: label1.bottomAnchor, constant: 20),
            swipeView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            swipeView.widthAnchor.constraint(equalToConstant: 200),
            swipeView.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        // UILabel2: swipeView 아래에 위치
        NSLayoutConstraint.activate([
            label2.topAnchor.constraint(equalTo: swipeView.bottomAnchor, constant: 10),
            label2.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            label2.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            label2.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
}

