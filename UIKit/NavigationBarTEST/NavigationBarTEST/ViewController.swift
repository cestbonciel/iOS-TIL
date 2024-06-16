//
//  ViewController.swift
//  NavigationBarTEST
//
//  Created by Nat Kim on 2023/12/05.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        title = "Bar Items"
        view.backgroundColor = .lightGray
        configureItems()
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        view.addSubview(button)
        button.center = view.center
        button.backgroundColor = .systemBlue
        button.setTitle("Go To View2", for: .normal)
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        
        navigationController?.navigationBar.tintColor = .label
    }
    
    private func configureItems() {
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(
                image:UIImage(systemName: "person.circle"),
                style: .done,
                target: self,
                action: nil
            ),
            UIBarButtonItem(
                barButtonSystemItem: .add,
                target: self,
                action: nil
            )
        ]
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "gear"),
            style: .done,
            target: self,
            action: nil
        )
        
//        let customView = UILabel(frame: CGRect(x: 0, y: 0, width: 48, height: 32))
//        customView.text = "취소"
//        customView.textAlignment = .center
//        customView.backgroundColor = .orange
//        customView.layer.cornerRadius = 8
//        customView.layer.masksToBounds = true
        
//        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: customView)
    }
    
    @objc func didTapButton() {
        let vc = UIViewController()
        vc.title = "View 2"
        vc.view.backgroundColor = .systemGreen
        
        vc.navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "설정",
            style: .done,
            target: self,
            action: nil)
        navigationController?.pushViewController(vc, animated: true)
    }
}

