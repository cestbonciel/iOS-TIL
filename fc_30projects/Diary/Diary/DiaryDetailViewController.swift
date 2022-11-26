//
//  DiaryDetailViewController.swift
//  Diary
//
//  Created by a0000 on 2022/11/18.
//

import UIKit

// 삭제 시 다이어리 뷰 - 일기 삭제 되었다는 이벤트 보내주는 거
protocol DiaryDetailViewDelegate: AnyObject {
	func didSelectDelete(indexPath: IndexPath)
}
class DiaryDetailViewController: UIViewController {

	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var contentsTextView: UILabel!
	@IBOutlet weak var dateLabel: UILabel!
	weak var delegate: DiaryDetailViewDelegate?
	// 전달받을 Property
	var diary: Diary?
	var indexPath: IndexPath?
	override func viewDidLoad() {
		super.viewDidLoad()
		self.configureView()
	}
	
	// 전달받을 것 초기화?
	private func configureView(){
		guard let diary = self.diary else { return }
		self.titleLabel.text = diary.title
		self.contentsTextView.text = diary.contents
		self.dateLabel.text = self.dateToString(date: diary.date)
	}
	
	private func dateToString(date: Date) -> String {
		let formatter = DateFormatter()
		formatter.dateFormat = "yy년 MM월 dd일(EEEEE)"
		formatter.locale = Locale(identifier: "ko_KR")
		return formatter.string(from: date)
	}
	
	@objc func editDiaryNotification(_ notification: Notification) {
		guard let diary = notification.object as? Diary else { return }
		guard let row = notification.userInfo?["indexPath.row"] as? Int else { return }
		self.diary = diary
		self.configureView()
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
		guard let indexPath = self.indexPath else { return }
		self.delegate?.didSelectDelete(indexPath: indexPath)
		// 삭제 시 이전 화면으로 돌아가게 만들어주는것 (navigationController)
		self.navigationController?.popViewController(animated: true)
	}
	
	deinit {
		NotificationCenter.default.removeObserver(self)
		// 해당 옵저버 내용 제거가 되게 해주는것 ? 
	}
}
