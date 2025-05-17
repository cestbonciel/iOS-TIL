//
//  ContentView.swift
//  WidgetDemo
//
//  Created by Nat Kim on 5/18/25.
//

import SwiftUI
import WidgetKit

struct ContentView: View { 
	@AppStorage("streak", store: UserDefaults(suiteName: "group.com.seohyunKim.iOS.WidgetDemo")) var streak = 0
	
	var body: some View {
		
		ZStack {
			Color.black
				.ignoresSafeArea()
			
			VStack {
				
				Spacer()
				
				ZStack {
					Circle()
						.stroke(.white.opacity(0.1), lineWidth: 20)
					
					let pct = Double(streak)/50.0
					
					Circle()
						.trim(from: 0, to: pct)
						.stroke(
							.blue,
							style: StrokeStyle(
								lineWidth: 20,
								lineCap: .round,
								lineJoin: .round
							)
						)
						.rotationEffect(.degrees(-90))
					VStack {
						Text("Streak")
							.font(.largeTitle)
						Text(String(streak))
							.font(.system(size: 70))
							.bold()
					}
					.foregroundStyle(.white)
					.fontDesign(.rounded)
					
				}
				.padding(.horizontal, 50)
				
				Spacer()
				
				Button {
					streak += 1
					
					// 수동으로 위젯 리로드
					WidgetCenter.shared.reloadTimelines(ofKind: "widgetextension")
				} label: {
					ZStack {
						RoundedRectangle(cornerRadius: 20)
							.foregroundStyle(.blue)
							.frame(height: 50)
						Text("+1")
							.foregroundStyle(.white)
					}
				}
				.padding(.horizontal)
				
				

			}
			
			
		}
		
		
	}
}

#Preview {
	ContentView()
}
