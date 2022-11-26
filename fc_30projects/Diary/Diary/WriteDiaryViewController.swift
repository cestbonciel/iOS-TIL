//
//  WriteDiaryViewController.swift
//  Diary
//
//  Created by a0000 on 2022/11/18.
//

import UIKit

// 열거형 정의
enum DiaryEditorMode {
	case new
	case edit(IndexPath, Diary)
}
protocol WriteDiaryViewDelegate: AnyObject {
	func didSelectRegister(diary: Diary)
}

class WriteDiaryViewController: UIViewController {

	@IBOutlet weak var titleTextField: UITextField!
	@IBOutlet weak var contentsTextView: UITextView!
	@IBOutlet weak var dateTextField: UITextField!
	@IBOutlet weak var confirmButton: UIBarButtonItem!
	
	private let datePicker = UIDatePicker()
	private var diaryDate: Date?
	// property 설정
	weak var delegate: WriteDiaryViewDelegate?
	// 초깃값은 new로
	var diaryEditorMode: DiaryEditorMode = .new
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.configureContentsTextView()
		self.configureDatePicker()
		self.configureInputField()
		self.configureEditMode()
		self.confirmButton.isEnabled = false
	}
	
	private func configureEditMode() {
		switch self.diaryEditorMode {
		case let .edit(_, diary):
			self.titleTextField.text = diary.title
			self.contentsTextView.text = diary.contents
			self.dateTextField.text = self.dateToString(date: diary.date)
			self.diaryDate = diary.date
			self.confirmButton.title = "수정"
			
		default:
			break
		}
	}
	
	private func dateToString(date: Date) -> String {
		let formatter = DateFormatter()
		formatter.dateFormat = "yy년 MM월 dd일(EEEEE)"
		formatter.locale = Locale(identifier: "ko_KR")
		return formatter.string(from: date)
	}
	
	private func configureContentsTextView() {
		let borderColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1.0)
		self.contentsTextView.layer.borderColor = borderColor.cgColor
		self.contentsTextView.layer.borderWidth = 0.5
		self.contentsTextView.layer.cornerRadius = 5.0
	}
	
	private func configureDatePicker() {
		self.datePicker.datePickerMode = .date
		self.datePicker.preferredDatePickerStyle = .wheels
		self.datePicker.addTarget(self, action: #selector(datePickerValueDidChange(_:)), for: .valueChanged)
//		self.datePicker.locale = Locale(identifier: "ko-KR")
		self.dateTextField.inputView = self.datePicker
	}
	
	private func configureInputField() {
		self.contentsTextView.delegate = self
		self.titleTextField.addTarget(self, action: #selector(titleTextFieldDidChange(_:)), for: .editingChanged)
		self.dateTextField.addTarget(self, action: #selector(dateTextFieldDidChange(_:)), for: .editingChanged)
	}
	// notification center 란 => 앱 내에서 메세지를 던지면 전달? 이벤트 버스 역할을 한다.
	// 이벤트 등록 -> observign 한다. => 수정된 내용을 전달하자~!
	@IBAction func tapConfirmButton(_ sender: UIBarButtonItem) {
		guard let title = self.titleTextField.text else { return }
		guard let contents = self.contentsTextView.text else { return }
		guard let date = self.diaryDate else { return }
		let diary = Diary(title: title, contents: contents, date: date, isStar: false)
		
		switch self.diaryEditorMode {
		case .new:
			self.delegate?.didSelectRegister(diary: diary)
		case let .edit(indexPath, _):
			NotificationCenter.default.post(
				name: NSNotification.Name("editDiary"),
				object: diary, // 수용된 내용의 다이어리 객체 전달
				userInfo: [
					"indexPath.row": indexPath.row
				]
			)
		}
//		self.delegate?.didSelectRegister(diary: diary)
		self.navigationController?.popViewController(animated: true)
	}
	
	
	@objc private func datePickerValueDidChange(_ datePicker: UIDatePicker) {
		let formatter = DateFormatter()
		formatter.dateFormat = "yyyy 년 MM 월 dd일(EEEEE)"
		formatter.locale = Locale(identifier: "ko_KR")
		self.diaryDate = datePicker.date
		self.dateTextField.text = formatter.string(from: datePicker.date)
		self.dateTextField.sendActions(for: .editingChanged)
	}
	// 제목 입력시 input field
	@objc private func titleTextFieldDidChange(_ textField: UITextField) {
		self.validateInputField()
	}
	// 날짜 선택해서 넘길 시 
	@objc private func dateTextFieldDidChange(_ textField: UITextField) {
		self.validateInputField()
	}
	
	// when User touch the empty screen, keyboard or datePicker will be down.
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		self.view.endEditing(true)
	}
	
	private func validateInputField() {
		// 모든 input field 가 작성되어 있을 때만 등록이 가능하게끔 구현
		self.confirmButton.isEnabled  = !(self.titleTextField.text?.isEmpty ?? true) && !(self.dateTextField.text?.isEmpty ?? true) && !self.contentsTextView.text.isEmpty
	}
}

extension WriteDiaryViewController: UITextViewDelegate {
	func textViewDidChange(_ textView: UITextView) {
		self.validateInputField()
	}
}
