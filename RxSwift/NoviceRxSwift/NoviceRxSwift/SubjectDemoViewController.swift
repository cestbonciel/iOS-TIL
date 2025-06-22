//
//  SubjectDemoViewController.swift
//  NoviceRxSwift
//
//  Created by Nat Kim on 3/2/25.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class SubjectDemoViewController: UIViewController {
    
    // 맨 위: PublishSubject(채팅)
    let chattingView = ChattingView()
    // 그 아래: BehaviorSubject(닉네임), ReplaySubject(알림)
    let demoView = SubjectDemoView()
    
    // MARK: - Subjects
    let publishSubject = PublishSubject<String>()
    let behaviorSubject = BehaviorSubject<String>(value: "(initial nickname)")
    let replaySubject = ReplaySubject<String>.create(bufferSize: 2)
    
    // MARK: - Rx
    let disposeBag = DisposeBag()
    
    // 현재 활성화된 구독(중복 구독 방지)
    var currentChatSubscription: Disposable?
    var currentBehaviorSubscription: Disposable?
    var currentReplaySubscription: Disposable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupLayout()
        setupPublishSubjectActions()
        setupBehaviorSubjectActions()
        setupReplaySubjectActions()
    }
    
    // MARK: - Layout
    private func setupLayout() {
        view.addSubview(chattingView)
        view.addSubview(demoView)
        
        chattingView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
        }
        
        // 중간 간격 0 → 검은 줄 없음
        demoView.snp.makeConstraints { make in
            make.top.equalTo(chattingView.snp.bottom).offset(0)
            make.leading.trailing.equalToSuperview()
            make.bottom.lessThanOrEqualTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
        }
    }
    
    // MARK: - PublishSubject (Chat)
    private func setupPublishSubjectActions() {
        
        // (1) 메시지 전송
        chattingView.sendButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                let message = self.chattingView.textField.text ?? ""
                guard !message.isEmpty else { return }
                
                // 메시지 발행
                self.publishSubject.onNext(message)
                self.chattingView.textField.text = ""
            })
            .disposed(by: disposeBag)
        
        // (2) 새로 구독 (Subscribe Chat)
        chattingView.subscribeButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                
                // 기존 구독 dispose (중복 구독 방지)
                self.currentChatSubscription?.dispose()
                
                // TextView 초기화
                self.chattingView.textView.text = ""
                
                // 새 구독
                let newSubscription = self.publishSubject
                    .subscribe(onNext: { [weak self] chat in
                        self?.appendText(self?.chattingView.textView, "Chat received: \(chat)")
                    })
                
                self.currentChatSubscription = newSubscription
                
                self.appendText(self.chattingView.textView, "[New PublishSubject subscriber added]")
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - BehaviorSubject (Nickname)
    private func setupBehaviorSubjectActions() {
        
        // (1) 닉네임 설정
        demoView.behaviorSetButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                let nickname = self.demoView.behaviorTextField.text ?? ""
                guard !nickname.isEmpty else { return }
                
                // BehaviorSubject에 새 닉네임
                self.behaviorSubject.onNext(nickname)
                self.demoView.behaviorTextField.text = ""
            })
            .disposed(by: disposeBag)
        
        // (2) 구독 (Subscribe Nick)
        demoView.behaviorSubscribeButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                
                // 기존 구독 dispose
                self.currentBehaviorSubscription?.dispose()
                
                // "현재 닉네임" Label 초기화
                self.demoView.behaviorCurrentLabel.text = "[New BehaviorSubject subscriber added]\n"
                
                // 새 구독: "가장 최근 닉네임" + 이후 닉네임 전달
                let newSubscription = self.behaviorSubject
                    .subscribe(onNext: { [weak self] nick in
                        self?.demoView.behaviorCurrentLabel.text =
                            "[New BehaviorSubject subscriber added]\nCurrent Nickname: \(nick)"
                    })
                
                self.currentBehaviorSubscription = newSubscription
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - ReplaySubject (Notifications)
    private func setupReplaySubjectActions() {
        
        // (1) 알림 전송
        demoView.replaySendButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                let dateString = DateFormatter.localizedString(
                    from: Date(),
                    dateStyle: .short,
                    timeStyle: .medium
                )
                let notification = "Notification at \(dateString)"
                
                // ReplaySubject에 알림 발행
                self.replaySubject.onNext(notification)
            })
            .disposed(by: disposeBag)
        
        // (2) 구독 (Subscribe Notifications)
        demoView.replaySubscribeButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                
                // 기존 구독 dispose
                self.currentReplaySubscription?.dispose()
                
                // TextView 초기화
                self.demoView.replayTextView.text = "[New ReplaySubject subscriber added]"
                
                // 새 구독: 최근 2개 알림 + 이후 알림 수신
                let newSubscription = self.replaySubject
                    .subscribe(onNext: { [weak self] note in
                        self?.appendText(self?.demoView.replayTextView, "Received: \(note)")
                    })
                
                self.currentReplaySubscription = newSubscription
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Helper
    private func appendText(_ textView: UITextView?, _ newLine: String) {
        guard let tv = textView else { return }
        let current = tv.text ?? ""
        tv.text = current.isEmpty ? newLine : current + "\n" + newLine
        
        // 스크롤 맨 아래로 이동
        let bottom = NSMakeRange(tv.text.count - 1, 1)
        tv.scrollRangeToVisible(bottom)
    }
}


