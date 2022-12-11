//
//  AppDelegate.swift
//  SpotifyLogin
//
//  Created by a0000 on 2022/05/09.
//

import UIKit
import FirebaseCore
import GoogleSignIn

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		let appearance = UINavigationBarAppearance()
		appearance.configureWithOpaqueBackground()
		appearance.backgroundColor = UIColor.systemBackground
		UINavigationBar.appearance().standardAppearance = appearance
		UINavigationBar.appearance().scrollEdgeAppearance = appearance
		// Firebase 초기화
		FirebaseApp.configure()
		
//		GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
//		GIDSignIn.sharedInstance().delegate = self
		return true
	}
	
	func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
//		return GIDSignIn.sharedInstance().handle(url)
		return GIDSignIn.sharedInstance.handle(url)
	}
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {

    }

//	func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
//		guard let clientID = FirebaseApp.app()?.options.clientID else { return }
//		// Create Google Sign In configuration object
//		let config = GIDConfiguration(clientID: clientID)
//		// Start the sign in flow
//		GIDSignIn.sharedInstance.signIn(with: config, presenting: self) { [unowned] user, error in
//			if let error = error {
//				print("Error Google Sign In \(error.localizedDescription)")
//				return
//			}
//			
//			guard let authentication = user?.authentication,
//						let idToken = authentication.idToken else { return }
//
//			let credential = FIRGoogleAuthProvider
//		}
//		
//
//	}
}

