//
//  IntentHandler.swift
//  ShortcutDemoIntent
//
//  Created by Seohyun Kim on 2023/10/14.
//

import Intents
import SwiftUI

class IntentHandler: INExtension, BuyStockIntentHandling {
	
	@AppStorage("demostorage", store: UserDefaults(suiteName: "group.com.seohyun.iOSApp.ShortcutDemo"))
	
	var store: Data = Data()
	var purchaseData = PurchaseData()

	 override func handler(for intent: INIntent) -> Any {
		  
		 guard intent is BuyStockIntent else {
			 fatalError("Unknown intent type: \(intent)")
		 }
		  return self
	 }
	
	
	
	func resolveSymbol(for intent: BuyStockIntent, with completion: @escaping (INStringResolutionResult) -> Void) {
		if let symbol = intent.symbol {
			completion(INStringResolutionResult.success(with: symbol))
		} else {
			completion(INStringResolutionResult.needsValue())
		}
	}
	
	
	
	func resolveQuantity(for intent: BuyStockIntent, with completion: @escaping (INStringResolutionResult) -> Void) {
		if let quantity = intent.quantity {
			completion(INStringResolutionResult.success(with: quantity))
		} else {
			completion(INStringResolutionResult.needsValue())
		}
	}
	
	func makePhrchase(symbol: String, quantity: String) -> Bool {
		var result: Bool = false
		let decoder = JSONDecoder()
		
		if let history = try? decoder.decode(PurchaseData.self, from: store) {
			purchaseData = history
			result = purchaseData.saveTransaction(symbol: symbol, quantity: quantity)
		}
		return result
	}
	
	
	func handle(intent: BuyStockIntent, completion: @escaping (BuyStockIntentResponse) -> Void) {
		guard let symbol = intent.symbol, let quantity = intent.quantity else {
			completion(BuyStockIntentResponse(code: .failure, userActivity: nil))
			return
		}
		
		let result = makePhrchase(symbol: symbol, quantity: quantity)
		
		if result {
			completion(BuyStockIntentResponse.success(quantity: quantity, symbol: symbol))
		} else {
			completion(BuyStockIntentResponse.failure(quantity: quantity, symbol: symbol))
		}
	}
	
	public func confirm(intent: BuyStockIntent, completion: @escaping (BuyStockIntentResponse) -> Void) {
		completion(BuyStockIntentResponse(code: .ready, userActivity: nil))
	}
	
	// MARK: - INSendMessageIntentHandling
	
	// Implement resolution methods to provide additional information about your intent (optional).
	func resolveRecipients(for intent: INSendMessageIntent, with completion: @escaping ([INSendMessageRecipientResolutionResult]) -> Void) {
		 if let recipients = intent.recipients {
			  
			  // If no recipients were provided we'll need to prompt for a value.
			  if recipients.count == 0 {
					completion([INSendMessageRecipientResolutionResult.needsValue()])
					return
			  }
			  
			  var resolutionResults = [INSendMessageRecipientResolutionResult]()
			  for recipient in recipients {
					let matchingContacts = [recipient] // Implement your contact matching logic here to create an array of matching contacts
					switch matchingContacts.count {
					case 2  ... Int.max:
						 // We need Siri's help to ask user to pick one from the matches.
						 resolutionResults += [INSendMessageRecipientResolutionResult.disambiguation(with: matchingContacts)]
						 
					case 1:
						 // We have exactly one matching contact
						 resolutionResults += [INSendMessageRecipientResolutionResult.success(with: recipient)]
						 
					case 0:
						 // We have no contacts matching the description provided
						 resolutionResults += [INSendMessageRecipientResolutionResult.unsupported()]
						 
					default:
						 break
						 
					}
			  }
			  completion(resolutionResults)
		 } else {
			  completion([INSendMessageRecipientResolutionResult.needsValue()])
		 }
	}
	
	func resolveContent(for intent: INSendMessageIntent, with completion: @escaping (INStringResolutionResult) -> Void) {
		 if let text = intent.content, !text.isEmpty {
			  completion(INStringResolutionResult.success(with: text))
		 } else {
			  completion(INStringResolutionResult.needsValue())
		 }
	}
	
	// Once resolution is completed, perform validation on the intent and provide confirmation (optional).
	
	func confirm(intent: INSendMessageIntent, completion: @escaping (INSendMessageIntentResponse) -> Void) {
		 // Verify user is authenticated and your app is ready to send a message.
		 
		 let userActivity = NSUserActivity(activityType: NSStringFromClass(INSendMessageIntent.self))
		 let response = INSendMessageIntentResponse(code: .ready, userActivity: userActivity)
		 completion(response)
	}
	
	// Handle the completed intent (required).
	
	func handle(intent: INSendMessageIntent, completion: @escaping (INSendMessageIntentResponse) -> Void) {
		 // Implement your application logic to send a message here.
		 
		 let userActivity = NSUserActivity(activityType: NSStringFromClass(INSendMessageIntent.self))
		 let response = INSendMessageIntentResponse(code: .success, userActivity: userActivity)
		 completion(response)
	}
	
	// Implement handlers for each intent you wish to handle.  As an example for messages, you may wish to also handle searchForMessages and setMessageAttributes.
	
	// MARK: - INSearchForMessagesIntentHandling
	
	func handle(intent: INSearchForMessagesIntent, completion: @escaping (INSearchForMessagesIntentResponse) -> Void) {
		 // Implement your application logic to find a message that matches the information in the intent.
		 
		 let userActivity = NSUserActivity(activityType: NSStringFromClass(INSearchForMessagesIntent.self))
		 let response = INSearchForMessagesIntentResponse(code: .success, userActivity: userActivity)
		 // Initialize with found message's attributes
		 response.messages = [INMessage(
			  identifier: "identifier",
			  content: "I am so excited about SiriKit!",
			  dateSent: Date(),
			  sender: INPerson(personHandle: INPersonHandle(value: "sarah@example.com", type: .emailAddress), nameComponents: nil, displayName: "Sarah", image: nil,  contactIdentifier: nil, customIdentifier: nil),
			  recipients: [INPerson(personHandle: INPersonHandle(value: "+1-415-555-5555", type: .phoneNumber), nameComponents: nil, displayName: "John", image: nil,  contactIdentifier: nil, customIdentifier: nil)]
			  )]
		 completion(response)
	}
	
	// MARK: - INSetMessageAttributeIntentHandling
	
	func handle(intent: INSetMessageAttributeIntent, completion: @escaping (INSetMessageAttributeIntentResponse) -> Void) {
		 // Implement your application logic to set the message attribute here.
		 
		 let userActivity = NSUserActivity(activityType: NSStringFromClass(INSetMessageAttributeIntent.self))
		 let response = INSetMessageAttributeIntentResponse(code: .success, userActivity: userActivity)
		 completion(response)
	}
	
}
