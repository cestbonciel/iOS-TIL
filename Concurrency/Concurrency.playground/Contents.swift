import UIKit
import Foundation

actor BuildMessage {
	var message: String = ""
	let greeting = "Hello"
	
	func setName(name: String) {
		self.message = "\(greeting), \(name)!"
	}
	
	nonisolated func getGreeting() -> String {
		return greeting
	}
}

func someFunction() async {
	let builder = BuildMessage()
	await builder.setName(name: "Nat Kim")
	//builder.message = "No"
	let message = await builder.message
	print(message)
}

Task {
	await someFunction()
}

let builder = BuildMessage()



func asyncFunction() async {
	let greeting = builder.getGreeting()
	print(greeting)
}
