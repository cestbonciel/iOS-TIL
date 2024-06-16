//
//  ContentView.swift
//  ObservableObjectTEST
//
//  Created by Seohyun Kim on 2023/11/11.
//

import SwiftUI

struct ContentView: View {
	@StateObject var timerData: TimerData = TimerData()
	
	var body: some View {
		NavigationStack {
			VStack {
				Text("Timer count = ⏲️ \(timerData.timeCount)")
					.font(.largeTitle)
					.fontWeight(.bold)
					.padding()
				Button(action: resetCount) {
					Text("Reset Counter")
				}
				.frame(width: 200, height: 100)
				.foregroundColor(.green)
				
				NavigationLink(destination: SecondView()) {
					Text("다음 화면으로 👉")
				}
				.padding()
			}//: VSTACK
		}//: NavigationStack
		.environmentObject(timerData)
	}

	func resetCount() {
		timerData.resetCount()
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
