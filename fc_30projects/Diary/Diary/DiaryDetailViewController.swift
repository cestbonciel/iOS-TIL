//
//  DiaryDetailViewController.swift
//  Diary
//
//  Created by a0000 on 2022/11/18.
//

import UIKit


class DiaryDetailViewController: UIViewController {

	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var contentsTextView: UILabel!
	@IBOutlet weak var dateLabel: UILabel!
	var starButton: UIBarButtonItem?
	// delegate 대신 NotificationCenter 을 이용해 전달하게 됨.
//	weak var delegate: DiaryDetailViewDelegate?
	// 전달받을 Property
	var diary: Diary?
	var indexPath: IndexPath?
	override func viewDidLoad() {
		super.viewDidLoad()
		self.configureView()
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(starDiaryNotification(_:)),
			name: NSNotification.Name("starDiary"),
			object: nil
		)
	}
	
	// 전달받을 것 초기화?
	private func configureView(){
		guard let diary = self.diary else { return }
		self.titleLabel.text = diary.title
		self.contentsTextView.text = diary.contents
		self.dateLabel.text = self.dateToString(date: diary.date)
		self.starButton = UIBarButtonItem(image: nil, style: .plain, target: self, action: #selector(tapStarButton))
		self.starButton?.image = diary.isStar ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
		self.starButton?.tintColor = .orange
		self.navigationItem.rightBarButtonItem = self.starButton
	}
	
	private func dateToString(date: Date) -> String {
		let formatter = DateFormatter()
		formatter.dateFormat = "yy년 MM월 dd일(EEEEE)"
		formatter.locale = Locale(identifier: "ko_KR")
		return formatter.string(from: date)
	}
	
	@objc func editDiaryNotification(_ notification: Notification) {
		guard let diary = notification.object as? Diary else { return }
		self.diary = diary
		self.configureView()
	}
	
	@objc func starDiaryNotification(_ notification: Notification) {
		guard let starDiary = notification.object as? [String: Any] else { return }
		guard let isStar = starDiary["isStar"] as? Bool else { return }
		guard let uuidString = starDiary["uuidString"] as? String else { return }
		guard let diary = self.diary else { return }
		if diary.uuidString == uuidString {
			self.diary?.isStar = isStar
			self.configureView()
		}
	}
	
	@IBAction func tapEditButton(_ sender: UIButton) {
		guard let viewController = self.storyboard?.instantiateViewController(withIdentifier: "WriteDiaryViewController") as? WriteDiaryViewController else { return }
		guard let indexPath = self.indexPath else { return }
		guard let diary = self.diary else { return }
		viewController.diaryEditorMode = .edit(indexPath, diary)
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(editDiaryNotification(_:)),
			name: NSNotification.Name("editDiary"),
			object: nil
		)
		self.navigationController?.pushViewController(viewController, animated: true)
		
	}
	@IBAction func tapDeleteButton(_ sender: UIButton) {
		guard let uuidString = self.diary?.uuidString else { return }
		NotificationCenter.default.post(
			name: NSNotification.Name("deleteDiary"),
			object: uuidString,
			userInfo: nil
		)
		// 삭제 시 이전 화면으로 돌아가게 만들어주는것 (navigationController)
		self.navigationController?.popViewController(animated: true)
	}
	
	@objc func tapStarButton() {
		// true 일 때 false, false 일 때 true
		guard let isStar = self.diary?.isStar else { return }

		if isStar {
			self.starButton?.image = UIImage(systemName: "star")
		} else {
			self.starButton?.image = UIImage(systemName: "star.fill")
		}
		self.diary?.isStar = !isStar
		NotificationCenter.default.post(
			name: NSNotification.Name("starDiary"),
			object: [
				"diary": self.diary,
				"isStar": self.diary?.isStar ?? false,
				"uuidString": diary?.uuidString
			],
			userInfo: nil)
	}
	
	deinit {
		NotificationCenter.default.removeObserver(self)
		// 해당 옵저버 내용 제거가 되게 해주는것 ? 
	}
}
