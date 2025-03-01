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
    
       // 커스텀 뷰 인스턴스
       let subjectDemoView = SubjectDemoView()
       
       // RxSwift DisposeBag
       let disposeBag = DisposeBag()
       
       override func viewDidLoad() {
           super.viewDidLoad()
           view.backgroundColor = .white
           setupSubjectDemoView()
           setupRxBindings()
       }
       
       private func setupSubjectDemoView() {
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
           // 버튼 탭 시: 랜덤 이미지를 불러오고 UILabel1 업데이트
           subjectDemoView.actionButton.rx.tap
               .flatMapLatest { () -> Observable<UIImage?> in
                   // 랜덤 시드 생성 (1~1000)
                   let randomSeed = Int.random(in: 1...1000)
                   let urlString = "https://picsum.photos/seed/\(randomSeed)/200/200"
                   guard let url = URL(string: urlString) else { return Observable.just(nil) }
                   let request = URLRequest(url: url)
                   // URLSession을 통해 데이터 받아오기
                   return URLSession.shared.rx.data(request: request)
                       .map { UIImage(data: $0) }
                       .catchAndReturn(nil)
               }
               .observe(on: MainScheduler.instance)
               .subscribe(onNext: { [weak self] image in
                   guard let self = self else { return }
                   if let image = image {
                       self.subjectDemoView.imageView.image = image
                       let message = "Button tapped: Image updated"
                       self.subjectDemoView.label1.text = message
                       print(message)
                   } else {
                       self.subjectDemoView.label1.text = "Image load failed"
                   }
               })
               .disposed(by: disposeBag)
           
           // 스와이프 제스처 추가 및 처리
           let swipeGesture = UISwipeGestureRecognizer()
           swipeGesture.direction = .left
           subjectDemoView.swipeView.addGestureRecognizer(swipeGesture)
           
           // 랜덤 컬러 Hex 코드 배열 (중복 제거)
           let colorHexes = [
               "#704a9d", "#abcd8e", "#ca6e07", "#2d785a",
               "#9fac69", "#36fb70", "#ae9af0", "#508fc6",
               "#8b62e9", "#fc40e6", "#909759", "#8a33bd",
               "#9aa37d", "#a26b8e", "#3af78f", "#258feb"
           ]
           
           swipeGesture.rx.event.subscribe(onNext: { [weak self] _ in
               guard let self = self else { return }
               let randomHex = colorHexes.randomElement() ?? "#ffffff"
               if let color = UIColor(hex: randomHex) {
                   self.subjectDemoView.swipeView.backgroundColor = color
               }
               let message = "Swiped: Color updated to \(randomHex)"
               self.subjectDemoView.label2.text = message
               print(message)
           })
           .disposed(by: disposeBag)
       }
}
