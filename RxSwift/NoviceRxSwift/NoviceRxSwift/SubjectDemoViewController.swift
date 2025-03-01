//
//  SubjectDemoViewController.swift
//  NoviceRxSwift
//
//  Created by Nat Kim on 3/2/25.
//

import UIKit
import RxSwift
import RxCocoa

class SubjectDemoViewController: UIViewController {
    
    // SubjectDemoView를 인스턴스로 생성
    let subjectDemoView = SubjectDemoView()
    
    // RxSwift DisposeBag
    let disposeBag = DisposeBag()
    
    // RxSwift Subject 예시 (필요한 경우)
    let publishSubject = PublishSubject<String>()
    let behaviorSubject = BehaviorSubject<String>(value: "Initial")
    let replaySubject = ReplaySubject<String>.create(bufferSize: 2)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupSubjectDemoView()
        setupRxBindings()
    }
    
    private func setupSubjectDemoView() {
        // 커스텀 뷰를 컨트롤러의 view에 추가
        subjectDemoView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(subjectDemoView)
        NSLayoutConstraint.activate([
            subjectDemoView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            subjectDemoView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            subjectDemoView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            subjectDemoView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupRxBindings() {
        // 버튼 탭 시 RxCocoa를 통해 Subject에 이벤트 전달
        subjectDemoView.actionButton.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            let message = "Button tapped at \(Date())"
            print("Button action: \(message)")
            self.publishSubject.onNext(message)
            self.behaviorSubject.onNext(message)
            self.replaySubject.onNext(message)
        })
        .disposed(by: disposeBag)
        
        // 스와이프 제스처 추가 및 RxCocoa를 통해 이벤트 처리
        let swipeGesture = UISwipeGestureRecognizer()
        swipeGesture.direction = .left
        subjectDemoView.swipeView.addGestureRecognizer(swipeGesture)
        
        swipeGesture.rx.event.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            let message = "Swiped left at \(Date())"
            print("Swipe action: \(message)")
            self.publishSubject.onNext(message)
            self.behaviorSubject.onNext(message)
            self.replaySubject.onNext(message)
        })
        .disposed(by: disposeBag)
        
        // 예시로 각 Subject를 구독하여 이벤트 출력
        publishSubject.subscribe(onNext: { value in
            print("PublishSubject: \(value)")
        })
        .disposed(by: disposeBag)
        
        behaviorSubject.subscribe(onNext: { value in
            print("BehaviorSubject: \(value)")
        })
        .disposed(by: disposeBag)
        
        replaySubject.subscribe(onNext: { value in
            print("ReplaySubject: \(value)")
        })
        .disposed(by: disposeBag)
    }
}
