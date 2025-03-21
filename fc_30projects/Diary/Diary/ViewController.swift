//
//  ViewController.swift
//  Diary
//
//  Created by a0000 on 2022/11/15.
//

import UIKit

class ViewController: UIViewController {

	@IBOutlet weak var collectionView: UICollectionView!
	// property Observer
	private var diaryList = [Diary](){
		didSet{
			self.saveDiaryList()
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.configureCollectionView()
		self.loadDiaryList()
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(editDiaryNotification(_:)),
			name: NSNotification.Name("editDiary"),
			object: nil
		)
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(starDiaryNotification(_:)),
			name: NSNotification.Name("starDiary"),
			object: nil)
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(deleteDiaryNotification(_:)),
			name: NSNotification.Name("deleteDiary"),
			object: nil
		)
	}
	
	private func configureCollectionView() {
		self.collectionView.collectionViewLayout = UICollectionViewFlowLayout()
		self.collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
		self.collectionView.delegate = self
		self.collectionView.dataSource = self
	}
	
	@objc func editDiaryNotification(_ notification: Notification) {
		guard let diary = notification.object as? Diary else { return }
		guard let index = self.diaryList.firstIndex(where: { $0.uuidString == diary.uuidString
		}) else { return }
		self.diaryList[index] = diary
		self.diaryList = self.diaryList.sorted(by: {
			$0.date.compare($1.date) == .orderedDescending
		})
		self.collectionView.reloadData()
	}
	
	@objc func starDiaryNotification(_ notification: Notification) {
		guard let starDiary = notification.object as? [String: Any] else { return }
		guard let isStar = starDiary["isStar"] as? Bool else { return }
		guard let uuidString = starDiary["uuidString"] as? String else { return }
		guard let index = self.diaryList.firstIndex(where: { $0.uuidString == uuidString
		}) else { return }
		self.diaryList[index].isStar = isStar
	}
	
	@objc func deleteDiaryNotification(_ notification: Notification) {
		// post 로 전달한 indexPath 가져오기
		guard let uuidString = notification.object as? String else { return }
		guard let index = self.diaryList.firstIndex(where: { $0.uuidString == uuidString
		}) else { return }
		self.diaryList.remove(at: index)
		self.collectionView.deleteItems(at: [IndexPath(row: index, section: 0)])
	}
	
	//세그웨이로 이동하는 vc 가 어딘지 잡아주는 곳
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let writeDiaryViewController = segue.destination as? WriteDiaryViewController {
			writeDiaryViewController.delegate = self
		}
	}
	private func saveDiaryList() {
		let data = self.diaryList.map {
			[
				"uuidString": $0.uuidString,
				"title": $0.title,
				"contents": $0.contents,
				"date": $0.date,
				"isStar": $0.isStar
			]
		}
		let userDefaults = UserDefaults.standard
		userDefaults.set(data, forKey: "diaryList")
	}
	
	private func loadDiaryList() {
		let userDefaults = UserDefaults.standard
		guard let data = userDefaults.object(forKey: "diaryList") as? [[String: Any]] else { return }
		self.diaryList = data.compactMap{
			guard let uuidString = $0["uuidString"] as? String else { return nil }
			guard let title = $0["title"] as? String else { return nil }
			guard let contents = $0["contents"] as? String else { return nil}
			guard let date = $0["date"] as? Date else { return nil}
			guard let isStar = $0["isStar"] as? Bool else { return nil}
			return Diary(uuidString: uuidString,title: title, contents: contents, date: date, isStar: isStar)
		}
		self.diaryList = self.diaryList.sorted(by: {
			$0.date.compare($1.date) == .orderedDescending
		})
	}
	
	private func dateToString(date: Date) -> String {
		let formatter = DateFormatter()
		formatter.dateFormat = "yy년 MM월 dd일(EEEEE)"
		formatter.locale = Locale(identifier: "ko_KR")
		return formatter.string(from: date)
	}
}
// extension 모음
extension ViewController: UICollectionViewDataSource {

	//지정된 셀이 표시할 갯수
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return self.diaryList.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		// 다운 캐스팅에 실패시 빈 콜렉션 셀 반환
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DiaryCell", for: indexPath) as? DiaryCell else { return UICollectionViewCell() }
		let diary = self.diaryList[indexPath.row]
		cell.titleLabel.text = diary.title
		cell.dateLabel.text = self.dateToString(date: diary.date)
		return cell
	}
}


extension ViewController: UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
	return CGSize(width: (UIScreen.main.bounds.width / 2) - 20, height: 200)
	}
	
}

extension ViewController: UICollectionViewDelegate {
	//특정 셀이 선택되었음을 알려주는 것
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		// 다이어리 디테일 뷰가 push 되도록
		guard let viewController = self.storyboard?.instantiateViewController(withIdentifier: "DiaryDetailViewController") as? DiaryDetailViewController else { return }
		let diary = self.diaryList[indexPath.row]
		viewController.diary = diary
		viewController.indexPath = indexPath
		self.navigationController?.pushViewController(viewController, animated: true)
	}
}

extension ViewController: WriteDiaryViewDelegate {
	// 내용이 담긴 객체 전달
	func didSelectRegister(diary: Diary) {
		//배열에 추가
		self.diaryList.append(diary)
		self.diaryList = self.diaryList.sorted(by: {
			$0.date.compare($1.date) == .orderedDescending
		})
		self.collectionView.reloadData()
	}
}


