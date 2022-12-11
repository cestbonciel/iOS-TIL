//
//  LoginViewController.swift
//  SpotifyLogin
//
//  Created by a0000 on 2022/05/09.
//

import UIKit
import GoogleSignIn

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var emailLoginButton: UIButton!
    @IBOutlet weak var googleLoginButton: GIDSignInButton!
    @IBOutlet weak var appleLoginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        [emailLoginButton, googleLoginButton, appleLoginButton].forEach {
            $0?.layer.borderWidth = 1
            $0?.layer.borderColor = UIColor.white.cgColor
            $0?.layer.cornerRadius = 30
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Navigation Bar 숨기기
        navigationController?.navigationBar.isHidden = true
			
				// google sign In
//			GIDSignIn.sharedInstance().presentingViewController = self
    }
	private func googleSignIn() {
		
	}
	@IBAction func googleLoginButtonTapped(_ sender: UIButton) {
		// Firebase 인증
//		GIDSignIn.sharedInstance().signIn()
	}
	
	@IBAction func appleLoginButtonTapped(_ sender: UIButton) {
		// Firebase 인증
	}
	
  
}
